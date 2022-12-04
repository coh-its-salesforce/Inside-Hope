/*************************************************************************

*  Name           :   CH_AlertEngineHelperClass
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   This class sends all the notifications like  email, creates chatter post and creates checklist for 
   case team members this class is called when the stage and status of case record is changed it finds the matching master records
   from alert master,alert details,checklist,checklist task objects .


**************************************************************************/


public  class CH_AlertEngineHelperClass{
    public static List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    public static List<Messaging.SingleEmailMessage> ActorsChecklistAssignmentmails = new List<Messaging.SingleEmailMessage>();
    public static map<string,id>mapEmailTemplates= new map<string, id>();
    public static OrgWideEmailAddress owe= new  OrgWideEmailAddress ();
    public  static list<CaseTeamMemberNotification__c> lstInsertCaseteamnotification= new list<CaseTeamMemberNotification__c>();
    public  static map<id,case> mapOfCaseIdVsCaseRecords = new map<id,case>();
    public static map<id,user> mapOfUserIdVsUserRecords= new map<id,user>();
    /* This method is called when the stage /status or both stage status is changed in case records
    basically it helps in creating notifications , checklist for actors in the case team member*/
    public static void actionItems(LIST <Case> newRecords , set<id> setCaseId,set<string>setOfCurrentStage ,set<string>setOfCurrentStatus){
        
       
        /*  CaseMemberMap is a map of Case member where we store the case member assisgned to a case.*/
        map<string, List<caseteammember>> CaseMemberMap = new map<string, list<caseteammember>>();
        /* setStatusChangedId set to hold the values of case whose status hav been changed.*/
        Set <String> setStatusChangedStatusName = new set< String>();
        /* setStageChangedStageName set to hold the values of case whose stage have been changed.*/
        Set <String> setStageChangedStageName = new set< String>();
        list< Alert_Detail__c> lstalertDetails= new list < Alert_Detail__c>();
        map <id, string> mapCaseStatus= new map<id,string>();
        map<string,list<CaseTeamMember> > mapCaseRoleandCaseMemberDetails = new map<string,list<CaseTeamMember> >();
        list<Checklist_Tasks__c> lstCheckListTask = new list<Checklist_Tasks__c>();
        set<id> setAlertDetailIdForAlertTypeTask= new set<id>();
        map<string,list<Alert_Detail__c>> mapStatusTypeAndAlertDetail= new map<string,list<Alert_Detail__c>>();
        map<string,Task> mapIDAndTaskRecords= new map<string,Task>();
        map<string,Health_Goal__c> mapofIDAndChecklistRecords= new map<string,Health_Goal__c>();
        Set<Task>setOfpreventduplicateTaskToBeInst= new set<Task>();
        List<FeedItem>lstOfChatterPostToBeInserted= new list<FeedItem>();
        set<FeedItem> setOfPreventDuplicateChatterPost= new set<FeedItem>();
        set<Task> setoFPreventDuplicateID= new set<Task>();
        list<Alert_Detail__c> AlertDetailsRecordLst=new list <Alert_Detail__c> ();
        map<string,Task >mapOfChecklistAndRelatedTask= new map<string,Task >();
        list< Health_Goal__c > lstCheckListRecordsTobeInsert= new list< Health_Goal__c >();
        set<Health_Goal__c> setPreventDuplicateRecord= new set<Health_Goal__c>();
        map<string,list<Checklist_Tasks__c>> mapIdAndCheckListRecords= new map<string,list<Checklist_Tasks__c>>();
        map<string,list<Checklist_Tasks__c>> mapIdAndCheckListRecordsForTask= new map<string,list<Checklist_Tasks__c>>();
        set<id> CaseteamMemberIds= new set<id>();
        mapOfCaseIdVsCaseRecords= new map<id,case>([select id,CC_Gender__c,Account.COH_MRN__c,Patient_DOB__c from case where  id in : setCaseId]);
        boolean sendEmailOnchecklistassingment;
        if(setCaseId != null && setCaseId.size()>0 ){
           
            /* querying the case team members and role and preparing a map of case team role and case team*/
            for(  caseteammember  ctm : [select id ,Member.name,TeamRole.name,ParentId,memberid,member.email from caseteammember where ParentId in : setCaseId]){
              
                CaseteamMemberIds.add(ctm.memberid);
                List <caseTeamMember> tempCaseTeamList = new List <caseTeamMember>();
               
                if( mapCaseRoleandCaseMemberDetails.get(ctm.parentID)==Null && (tempCaseTeamList == Null || tempCaseTeamList.isempty())) {
                    tempCaseTeamList.add(ctm);
                } else {
                    tempCaseTeamList = mapCaseRoleandCaseMemberDetails.get(ctm.TeamRole.name + ctm.parentID);
                    tempCaseTeamList.add(ctm);
                }
                if(tempCaseTeamList!=Null) {
                    mapCaseRoleandCaseMemberDetails.put(ctm.TeamRole.name+ctm.parentID,tempCaseTeamList);
                }
                
            }
        }
        /* Querying all the user details of the case team member and preparing a map of
        userid vs userdetails*/
        if(CaseteamMemberIds !=null && CaseteamMemberIds.size()>0){
            
            mapOfUserIdVsUserRecords= new map<id,user>([select id ,CC_Receive_Checklist_Completion_Emails__c, CC_Receive_Checklist_Assignment_Email__c, 
                                                                CC_Receive_Assingment_Emails__c from user where id in :CaseteamMemberIds]);
            
        }
        /* If stage and status not null then query all the master records from alert master and its alert detail*/
        if( setOfCurrentStatus  != null &&  setOfCurrentStage!=null && setOfCurrentStatus.size()>0  && setOfCurrentStage.size()>0    ){
            
            
            lstalertDetails = [select id,  Due_Date__c,Alert_Master__c, Task_Name__c,Alert_Master__r.Alert_Type__c,Templates__c,Assign_To__c ,Alert_Master__r.status__c,
            Alert_Master__r.stage__c,Checklist__c,Checklist__r.Checklist_Description__c,Checklist__r.name,Description__c,Checklist_Tasks__r.name ,
            Checklist__r.Days__c ,Checklist__r.UniqueIdentifier__c,Checklist__r.Health_Goal_Name__c,Static_chatter_text__c from Alert_Detail__c where Alert_Master__r.status__c in :setOfCurrentStatus and
            Alert_Master__r.stage__c in: setOfCurrentStage];
        }
              
        if(lstalertDetails.size()>0){
            for(Alert_Detail__c ad : lstalertDetails){
                if(ad.Alert_Master__r.Alert_Type__c=='Checklist'){
                    setAlertDetailIdForAlertTypeTask.add(ad.Checklist__c);
                }
                list<Alert_Detail__c> lsttempAlertdetailList= new list<Alert_Detail__c>();
                      if( mapStatusTypeAndAlertDetail.get(ad.Alert_Master__r.stage__c + ad.Alert_Master__r.status__c )==Null && (lsttempAlertdetailList == Null || lsttempAlertdetailList.isempty())) {
                        lsttempAlertdetailList.add(ad);
                       } else {
                        lsttempAlertdetailList = mapStatusTypeAndAlertDetail.get(ad.Alert_Master__r.stage__c + ad.Alert_Master__r.status__c );
                       lsttempAlertdetailList.add(ad);
                     }
                     if(lsttempAlertdetailList!=Null && lsttempAlertdetailList.size()>0) {
                         mapStatusTypeAndAlertDetail.put(ad.Alert_Master__r.stage__c +ad.Alert_Master__r.status__c  ,lsttempAlertdetailList );
            
                    }
             }
        }
                
       
        if(setAlertDetailIdForAlertTypeTask != null && setAlertDetailIdForAlertTypeTask.size()>0){
         for( checklist_Tasks__c  checklsttsk :[select id,   Name, Checklist__c,Due_Date__c,Task_Description__c,Checklist__r.Checklist_Description__c,Checklist__r.Days__c,
                                                    Checklist__r.UniqueIdentifier__c ,Checklist__r.name, Checklist__r.Health_Goal_Name__c from Checklist_Tasks__c where Checklist__c in : setAlertDetailIdForAlertTypeTask ]){
           
                   list<Checklist_Tasks__c> lsttempChecklistList= new list<Checklist_Tasks__c>();
                      if( mapIdAndCheckListRecords.get(checklsttsk.Checklist__c + checklsttsk.Checklist__r.UniqueIdentifier__c)==Null && (lsttempChecklistList == Null || lsttempChecklistList.isempty())) {
                        lsttempChecklistList.add(checklsttsk);
                    } else {
                    lsttempChecklistList = mapIdAndCheckListRecords.get(checklsttsk.Checklist__c + checklsttsk.Checklist__r.UniqueIdentifier__c);
                       lsttempChecklistList.add(checklsttsk);
                    }
                    if(lsttempChecklistList!=Null) {
                        mapIdAndCheckListRecords.put(checklsttsk.Checklist__c ,lsttempChecklistList);
                   }
              
             list<Checklist_Tasks__c> lsttempChecklistListFortask= new list<Checklist_Tasks__c>();
                  if( mapIdAndCheckListRecordsForTask.get( checklsttsk.Checklist__r.UniqueIdentifier__c)==Null && (lsttempChecklistListFortask == Null || lsttempChecklistListFortask.isempty())) {
                        lsttempChecklistListFortask.add(checklsttsk);
                    } else {
                    lsttempChecklistListFortask = mapIdAndCheckListRecordsForTask.get( checklsttsk.Checklist__r.UniqueIdentifier__c);
                       lsttempChecklistListFortask.add(checklsttsk);
                    }
                    if(lsttempChecklistList!=Null) {
                        mapIdAndCheckListRecordsForTask.put(checklsttsk.Checklist__r.UniqueIdentifier__c ,lsttempChecklistListFortask);
                   }
            }
        }
        
        
        /* below loop for each case records*/
        for( Case caseRecords : newRecords ){
            string CurrentCaseownerRole;
            string currentcaseowneremail;
            if(caseRecords.Owner_Role__c != null){
                CurrentCaseownerRole= caseRecords.Owner_Role__c;
                
            }
            AlertDetailsRecordLst = new list<Alert_Detail__c>();
            String caseTempStatus,caseTempStage;
            caseTempStage=caseRecords.stage__c;
            caseTempStatus=caseRecords.status__c;
            string TempCase= caseTempStage+caseTempStatus;            
           list<caseteammember> casetmMember = new list<caseteammember>();
           
            
            /* querying all theAlert master  details  reecord for the particular case and preparing a map of it.*/
            if ( TempCase != null){
             
                        list< Alert_Detail__c> templist= new list< Alert_Detail__c>();
                        templist=   mapStatusTypeAndAlertDetail.get(TempCase);
                        if(templist != null && templist.size()>0){
                            for(Alert_Detail__c alertdetailrecord : templist){
                                  List<CaseTeamMember> getMember = new list<CaseTeamMember>();
                                 getMember= mapCaseRoleandCaseMemberDetails.get(alertdetailrecord.Assign_To__c +caseRecords.id);
                                 
                                if(getMember!=null && getMember.size()>0){
                                    AlertDetailsRecordLst.add(alertdetailrecord);
                                }
                                else{
                                 
                                    if(alertdetailrecord .Assign_to__c=='Not specified' && alertdetailrecord .Alert_Master__r.Alert_Type__c=='Chatter')
                                   AlertDetailsRecordLst.add(alertdetailrecord);
                                    
                                }
                            }
                     }
                   
                if(AlertDetailsRecordLst.size()>0){
                    for(Alert_Detail__c  ad :AlertDetailsRecordLst ){
                      
                        /* Checking if the alert type is Checklist .*/
                        if( ad.Alert_Master__r.Alert_Type__c =='Checklist'){
                            string chatterpost;
                            string emailtemplate;
                            sendEmailOnchecklistassingment=false;
                            list <CaseTeamMember> tempid= new  list <CaseTeamMember> ();
                            set<Checklist_Tasks__c> preventDuplicateTasks= new set<Checklist_Tasks__c>();
                            lstCheckListTask = new list<Checklist_Tasks__c>();
                            user userdetails= new user();
                            tempid=  mapCaseRoleandCaseMemberDetails.get(ad.Assign_To__c +caseRecords.id);
                             if(mapOfUserIdVsUserRecords != null && mapOfUserIdVsUserRecords.size()>0 && tempid !=null && tempid.size()>0){
                                 UserDetails= mapOfUserIdVsUserRecords.get(tempid[0].memberid);
                                 if(UserDetails != null && UserDetails.CC_Receive_Checklist_Assignment_Email__c==true){
                                        sendEmailOnchecklistassingment=true;
                                 }
                            }
                           if( tempid !=null && tempid.size()>0 ){
                                Health_Goal__c   TempChecklistvalue= new Health_Goal__c();
                            
                                    if(ad.Checklist__c  !=null){
                                    
                                            if(ad.Templates__c!=null){
                                                emailtemplate=ad.Templates__c;
                                            }
                                            if(ad.Description__c!=null){
                                                chatterpost=ad.Description__c;
                                            }
                                           List<Checklist_Tasks__c> lstTemp= mapIdAndCheckListRecords.get(ad.Checklist__c);
                                           if( lstTemp != null && lstTemp.size()>0 ){ 
                                            
                                                for(Checklist_Tasks__c checklst:  lstTemp ){
                                                
                                                TempChecklistvalue= CreateGoal(caseRecords.id, ad,caseRecords.CC_Appointment_Date__c,tempid[0].MemberId,emailtemplate,chatterpost,ad.Alert_Master__r.stage__c,ad.Alert_Master__r.status__c,sendEmailOnchecklistassingment);
                                                if((setPreventDuplicateRecord.contains(TempChecklistvalue)==false) || (setPreventDuplicateRecord.size()==0)){
                                                    lstCheckListRecordsTobeInsert.add(TempChecklistvalue);
                                                }
                                                
                                                setPreventDuplicateRecord.add(TempChecklistvalue);
                                                
                                                
                                                }
                                        }
                                  }
                                
                            }
                        }
                        /* Checking if the alert type is Chatter .*/
                        if( ad.Alert_Master__r.Alert_Type__c =='Chatter'){
                            list< CaseTeamMember> tempid1= new  list< CaseTeamMember> ();
                            tempid1=  mapCaseRoleandCaseMemberDetails.get(ad.Assign_To__c+caseRecords.id);
                            FeedItem TempFeedItem= new FeedItem();
                            if( tempid1 !=null && tempid1.size()>0){
                                TempFeedItem=CreateChatterPost( caseRecords.id ,ad.Description__c,tempid1[0].member.name,ad.Static_chatter_text__c);
                            }
                            else{
                                
                                TempFeedItem=CreateChatterPost( caseRecords.id ,ad.Description__c,'',ad.Static_chatter_text__c);
                                
                            }
                            
                            if(TempFeedItem !=null && TempFeedItem.body !=null ){
                                if((setOfPreventDuplicateChatterPost.contains(TempFeedItem)== false)|| (setOfPreventDuplicateChatterPost.size()==0)){
                                    lstOfChatterPostToBeInserted.add(TempFeedItem);
                                }
                                setOfPreventDuplicateChatterPost.add(TempFeedItem);
                            }
                            
                        }
                        /* Checking if the alert type is Email .*/
                        if( ad.Alert_Master__r.Alert_Type__c =='Email'){
                            list<CaseTeamMember> tempid2= new  list<CaseTeamMember>();
                            list  <CaseTeamMember> getownerrecords= new list  <CaseTeamMember> ();
                            User UserDetails= new User();
                            tempid2=  mapCaseRoleandCaseMemberDetails.get(ad.Assign_To__c+caseRecords.id);
                            /* Finding the matching user details from the case team member id */
                            if(mapOfUserIdVsUserRecords != null && mapOfUserIdVsUserRecords.size()>0 && tempid2 !=null && tempid2.size()>0){
                                 UserDetails= mapOfUserIdVsUserRecords.get(tempid2[0].memberid);
                            }
                            if(UserDetails != null  && UserDetails.CC_Receive_Assingment_Emails__c==true){
                          
                                if(  CurrentCaseownerRole !=null){
                                    getownerrecords=  mapCaseRoleandCaseMemberDetails.get(CurrentCaseownerRole+caseRecords.id);
                                }
                               
                                if(  tempid2 !=null &&  getownerrecords!=null && tempid2.size()>0 && getownerrecords.size()>0 ){
                                    SendEmail( tempid2[0] ,caseRecords.id,ad.Templates__c,tempid2[0].teamrole.name,getownerrecords[0].member.email,CurrentCaseownerRole,caseRecords);
                                }
                                else if( tempid2 !=null && tempid2.size()>0 ) {
                                   SendEmail( tempid2[0]  ,caseRecords.id,ad.Templates__c,tempid2[0].teamrole.name,'',CurrentCaseownerRole,caseRecords);
                                }
                            }
                        }
                        
                    }
                    
                }
            }
        }
     
        
        /* Inserting the records of checklist and task object and then inserting task into it*/
        if(lstCheckListRecordsTobeInsert.size()>0){
            Map<id,Health_Goal__c > mapidAndCheclistTaskRecords= new map<id,Health_Goal__c >();
            List<Task> TasksToBeInserted= new List<Task>();
            List<Task> tempTasksToBeInserted= new List<Task>();
            set<Task> taskTobeIns= new set<Task>();
            set<task> taskTobeIns1= new set<task>();
            list<Health_Goal__c> listOfCheclistandTaskRecordsInserted= new list<Health_Goal__c>();
            set<id> insertedRecordChecklistAndTaskid= new set<id>();
            Database.SaveResult[] srList = Database.insert(lstCheckListRecordsTobeInsert, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    insertedRecordChecklistAndTaskid.add(sr.getId());
                }
                else{
                    system.debug('*********Exception ListNotInserted*******');
                }
            }
            
            if(insertedRecordChecklistAndTaskid.size()>0 && insertedRecordChecklistAndTaskid !=null){
                for(Health_Goal__c checklisttaskrecords:[select id,UniqueIdentifier__c,Case__r.id,Assigned_to__c,name,Due_Date__c, 
                                                          case__r.CaseNumber, case__r.Account.name  from Health_Goal__c  where id in:insertedRecordChecklistAndTaskid]){
                    
                    if(checklisttaskrecords !=null){
                        listOfCheclistandTaskRecordsInserted.add(checklisttaskrecords);
                        mapidAndCheclistTaskRecords.put(checklisttaskrecords.id,checklisttaskrecords);
                        
                    }
                }
            }
            for( Health_Goal__c insertedchecklist   :listOfCheclistandTaskRecordsInserted){
                tempTasksToBeInserted= new list<Task>();
                TasksToBeInserted= new list<Task>();
                taskTobeIns = new set<task>();
             
                    if(insertedchecklist.UniqueIdentifier__c !=null){
                   
                        list< Checklist_Tasks__c >TempTaskuinsert= new list<Checklist_Tasks__c>();
                            TempTaskuinsert =mapIdAndCheckListRecordsForTask.get(insertedchecklist.UniqueIdentifier__c);
                           
                            if(TempTaskuinsert != null && TempTaskuinsert.size()>0){
                                for( Checklist_Tasks__c TempTask1 : TempTaskuinsert){
                                
                                Task TempTask= new Task();
                                TempTask  = CreateTask( insertedchecklist.Assigned_to__c ,insertedchecklist.Due_Date__c,TempTask1.Name,insertedchecklist.id,insertedchecklist);
                                
                                if(TempTask !=null){
                                
                                    taskTobeIns1.add(TempTask);
                                  
                                }
                            }
                        }
                }
              
            }
            
            if( taskTobeIns1 !=null && taskTobeIns1.size()>0){
            TasksToBeInserted= new list<task>();
                TasksToBeInserted.addall(taskTobeIns1);
                try{
                    Insert TasksToBeInserted;
                }
                Catch (Exception e){
                    System.debug('******************Exception***********'+ e.getmessage())  ;
                }
                
            }
        }
        /*  Inserting the chatter feed records*/
        if(   lstOfChatterPostToBeInserted !=null &&   lstOfChatterPostToBeInserted.size()>0){
            try{
                Insert   lstOfChatterPostToBeInserted;
            }
            Catch (Exception e){
                
                System.debug('******************Exception***********'+ e.getmessage())  ;
            }
        }
      
        
        if( lstInsertCaseteamnotification !=null &&  lstInsertCaseteamnotification.size()>0){
            
            try{
                insert lstInsertCaseteamnotification;
            }
            catch(Exception e){
                System.debug('******************Exception***********'+ e.getmessage())  ;
                
            }
            
        }
        
     
        /*  Inserting the chatter feed records for checklist assignment for actors*/
        if(CH_HealthGoalHelperClass.lstOfChatterPostToBeInsertedonChecklistCreation !=null &&   CH_HealthGoalHelperClass.lstOfChatterPostToBeInsertedonChecklistCreation.size()>0){
            try{
                
                insert CH_HealthGoalHelperClass.lstOfChatterPostToBeInsertedonChecklistCreation;
            }
            catch (Exception e){
                
                system.debug('***********Exception ************'+ e.getmessage());
            }
            
        }
        /* call the batch class and check if any batch is currently executing */
        
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] ==0){
            CH_EmailNotificationToCaseMemberBatch reNotification = new CH_EmailNotificationToCaseMemberBatch();
            database.executebatch(reNotification,90);
            
        }
        
    }
    /* Createtask method is used to create task if alert type is task for users defined in Status matrix and alert detail object*/
    public static Task Createtask( id ownerId  , Date dueDateValue, String subject,id whatid,Health_Goal__c checklistrecord){
        list < Task> updatetask= new list<Task>();
        Task T = new Task();
        try{
            T.Type = 'Email';
            T.Subject=subject;
            T.Description = ''; //string
            T.OwnerId = ownerId; //user id
            T.WhatId = whatid; //record id
            T.IsHealthGoalTask__c=true;
            T.ActivityDate = date.valueof(dueDateValue);
            T.Case_Number__c=checklistrecord.case__r.CaseNumber;
            if(checklistrecord.case__r.Account.name!=null)
            T.Patient_name__c= checklistrecord.case__r.Account.name;
        }
        catch ( Exception e){
            system.debug('******Exception ******'+ e.getmessage());
        }
        return T ;
        
    }
    /* SendEmail method is used to send email notification if alert type is email  for users defined in Status matrix and alert detail object*/
    public static void SendEmail( CaseTeamMember targetObjectID , string whatid,string emailName,string role,string owneremail,string currentownerrole,case casedetails  ){
      
        CaseTeamMemberNotification__c Insertcaseteamnotification = new CaseTeamMemberNotification__c();
         if(role != null && role.endsWith(CH_StaticComponentHelperClass.ManagerTeamRoleSuffix)){
            if(casedetails !=null   ){
                
                Insertcaseteamnotification.Manager_Notification__c= true;
                String[] parts = role.split('-');
                string body;
                string birthdate;
                case getcasedetails;
                if(mapOfCaseIdVsCaseRecords !=null && mapOfCaseIdVsCaseRecords.size()>0){
                    getcasedetails =mapOfCaseIdVsCaseRecords.get(casedetails.id);
                
                }
                
                if(getcasedetails !=null){
                    birthdate= string.valueof(getcasedetails.Patient_DOB__c);
               }
                 
                string gender;
                string appointmentdate;
                if(casedetails.CC_Appointment_Date__c !=null){
                   appointmentdate= string.valueof(casedetails.CC_Appointment_Date__c);
                }
                else{
                    appointmentdate='';
                }
                if( getcasedetails !=null && getcasedetails.CC_Gender__c==null)
                gender='';
                else
                gender=getcasedetails.CC_Gender__c;
                IF (birthdate== NULL)
                    birthdate='';
                String MrnNo;
                if(getcasedetails !=null && getcasedetails.Account.COH_MRN__c !=null){
                     MrnNo =getcasedetails.Account.COH_MRN__c;
                }
                else{
                    MrnNo ='';
                }
                
                body = 'Dear ' + targetObjectId.Member.name +',<br></br><br></br>';
                body+= 'You have been assigned to the  following case as  a '+ parts[0] +' Manager  for the stage '+casedetails.Stage__c + ' - '+ casedetails.Status__c +' <br></br>';
                body += 'Please re-assign the case to  '+ parts[0] + '.<br></br>';
                body += 'Patient Name : ' + casedetails.Account_Name__c +'<br></br> Disease Name : '+ casedetails.CC_disease__c +  
                        '<br></br> Diagnosis : ' + casedetails.CC_Diagnosis__c +
                        '<br></br> Physician Name : '+ casedetails.CC_Physician_Name__c + '<br></br> Case Number : '+ casedetails.CaseNumber + 
                        '<br></br>     MRN : ' + MrnNo  +'<br></br>'+
                         '  Appointment Date : ' + appointmentdate +'<br></br>'+
                         ' DOB : ' + birthdate +'<br></br> Gender : ' + gender +'<br></br>' +
                         ' Stage : ' + casedetails.stage__c +'<br></br> Status : ' + casedetails.status__c +'<br></br>';
                         
                        
                body += '  Please   <a href=  "' + System.URL.getSalesforceBaseURL().toExternalForm()+'/' + CH_StaticComponentHelperClass.TaskReassignmentUrl + casedetails.id +  ' ">click here</a>  ' +      
                        ' to assign a '+ parts[0] +'';
                body += '<br></br><br></br> COH<br></br>  Care Coordination Application';
                Insertcaseteamnotification.Email_Body__c = body;
                if(targetObjectId.Memberid !=null)
                 Insertcaseteamnotification.Assign_to__c=targetObjectId.Memberid;
                
            }
        }
       
       else{
       
        if(targetObjectId.Memberid !=null)
        Insertcaseteamnotification.Assign_to__c=targetObjectId.Memberid;
        if(whatid !=null)
        Insertcaseteamnotification.Recordid__c=whatid;
        
        if(emailName !=null)
        Insertcaseteamnotification.Templates__c=emailName;
        if(role !=null)
        Insertcaseteamnotification.Role__c=role;
        if(owneremail !=null)
        Insertcaseteamnotification.OwnerEmail__c=owneremail;
        if(currentownerrole !=null)
        Insertcaseteamnotification.Owner_role__c=currentownerrole;
        }
        lstInsertCaseteamnotification.add(Insertcaseteamnotification);
       
    }
    /* CreateChatterPost method is used to create  chatter post is chatter post  for users defined in Status matrix and alert detail object*/
    public static FeedItem CreateChatterPost( string caseid, string Description ,String AssigntoName, boolean statictext){
        FeedItem post = new FeedItem();
      
        try{
            post.ParentId = caseid; //eg. Opportunity id, custom object id..
            string tempAssigntoName= AssigntoName;
            
            if(statictext==false){
                if( Description != null && Description !=''){
                    if(tempAssigntoName != null && tempAssigntoName !=''){
                        post.Body = Description+' '+tempAssigntoName;
                    }
                    else{
                        post.Body = Description;
                    }
                }
                
            }
            else{
                if( Description != null && Description !='')
                post.Body = Description;
            }
        }
        
        catch ( Exception e){
            system.debug('***********Exception*********'+ e.getmessage());
        }
        return post;
    }
    /* Creating checklist for actors*/
    public  static  Health_Goal__c  CreateGoal( string caseRecords,Alert_Detail__c  alertdetail ,Date appoinmentDate ,id assigntoid,string emailtemplate,string chatterpost,string stage,string status,boolean sendemail){
        
        Health_Goal__c InsertGoal =  new Health_Goal__c();
        try{
            InsertGoal.Case__c=caseRecords;
            InsertGoal.Description__c = alertdetail.Checklist__r.Checklist_Description__c;
            InsertGoal.Assigned_to__c=assigntoid;
            InsertGoal.UniqueIdentifier__c=string.valueof(alertdetail.Checklist__r.UniqueIdentifier__c);
            InsertGoal.Name =alertdetail.Checklist__r.Name;
            InsertGoal.Abbreviated_name__c=alertdetail.Checklist__r.Health_Goal_Name__c;
            if(alertdetail.Description__c !=null)
            InsertGoal.Chatter_Post__c= alertdetail.Description__c;
            InsertGoal.Start_Date__c= Date.Today();
            if(appoinmentDate !=null){
                if(alertdetail.Checklist__r.Days__c !=null){
                    if((appoinmentDate.addDays(-integer.valueof(alertdetail.Checklist__r.Days__c))<= Date.Today())){
                        InsertGoal.Due_Date__c=Date.Today();
                    }
                    else{
                        InsertGoal.Due_Date__c=appoinmentDate.addDays(-integer.valueof(alertdetail.Checklist__r.Days__c));
                        
                    }
                }
                else{
                    InsertGoal.Due_Date__c=appoinmentDate;
                }
            }
            if(emailtemplate !=null && sendemail==true)
            InsertGoal.EmailTemplate__c=emailtemplate;
            if(chatterpost !=null)
            InsertGoal.Chatter_Post__c=chatterpost;
            if(stage !=null)
            InsertGoal.Created_Stage__c=stage;
            if(status !=null)
            InsertGoal.Created_Status__c=status;
            InsertGoal.Static_chatter_text__c=alertdetail.Static_chatter_text__c;
            InsertGoal.Assign_To__c=alertdetail.Assign_to__c;
        }
        Catch ( Exception e){
            system.debug('***********Exception*********'+ e.getmessage());
            
        }
        return InsertGoal;
        
        
    }
    
   
    
}