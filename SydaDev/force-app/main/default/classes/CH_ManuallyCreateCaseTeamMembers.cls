/*
*  Name           :   CH_ManuallyCreateCaseTeamMembers
*  Created By     :   Persistent System Ltd.
*  Created Date   :   Jan 30, 2015 
*  Description    :   This class is controller for inlinevfPage of case record and contains methods to support various functionalities.
*/
public class  CH_ManuallyCreateCaseTeamMembers{

   public list<caseteammember> ctm{get;set;}
   public List<caseteammember> ctmList{
       get{ return  [select id,memberId,member.Name,parentId,TeamRole.Name 
                        from 
                        caseTeamMember 
                        where 
                        parentId = :caseId 
                    ];
            }
       set;
   }
   Public Boolean SendEmail{get;set;}
   Public Boolean validationFound{get;set;}
   public user userID{get;set;}
   Public id caseId{get;set;}
   public integer rowNo{get;set;}
   public list<caseteamrole> lstCaseteamRoles{get;set;}
   public string selectedrole{get;set;}
   public string selecteduser{get;set;}
   public string selecteduserName{get;set;}
   public id getcaseteamrecordid{get;set;}
   public map<id,Disease_Matrix__c  > mapOfIdAndRoleName= new map<id,Disease_Matrix__c  >();
   public Set<id> ExistingTeamMemberIdList = new set<id>();
   public Set<id> ExistingcaseFollowers= new set<id>();
   public case caseRecord;
   public String caseOwnerRole;
   public id InsertedCaseTeamMember;
   public id parentCaseId;
   public set<id> setOfchecklistId= new set<id>();
   public map<string,Checklist_Tasks__c> mapIdAndCheckListRecordsmanually= new map<string,Checklist_Tasks__c>();
   public set<Health_Goal__c> setPreventDuplicateRecord= new set<Health_Goal__c>();
   public list< Health_Goal__c > lstCheckListRecordsTobeInsert= new list< Health_Goal__c >();
   public list<FeedItem>lstOfChatterPostToBeInserted= new list<FeedItem>();
   public set<FeedItem> setOfPreventDuplicateChatterPost= new set<FeedItem>();
   public  map<string,id>mapEmailTemplates= new map<string, id>();
   public  OrgWideEmailAddress owe= new  OrgWideEmailAddress ();
   map<string,CaseTeamMember> mapofRoleandCaseTeamMember= new map<string,CaseTeamMember>();
   set<string> setOfchecklistnameandAssignto = new set<string>();
   public string loggedInUserId {get;set;} 
   public string profileName {get;set;}
   //Refresh Primary Tab
   public boolean refreshPage{get;set;}
   public string caseOwnerProfile {get;set;}
   public string supervisor {get;set;}
   public string caseOwnerServiceDeskProfile {get;set;}
   public string supervisorServiceDeskProfile {get;set;}
   public map<id,EntitySubscription> chatterFollowerMap = new map<id,EntitySubscription>();
   public boolean sendEmailOnchecklistassingment;
   public  User UserRecord= new user();
    
    public CH_ManuallyCreateCaseTeamMembers(){
        caseId = ApexPages.currentPage().getParameters().get('CaseId');
        List<Role_Master__c> roleMasterList = [Select id,Name from ROle_Master__c where FkManager__c = :Userinfo.getUserId()];
        if(roleMasterList != null && roleMasterList.size() > 0){
            selectedrole = roleMasterList[0].Name;
        }
        initializeParameters();
        AddMember();
    }
    
   public CH_ManuallyCreateCaseTeamMembers(ApexPages.StandardController controller) {
        caseId = ApexPages.currentPage().getParameters().get('id');
        initializeParameters();
   }
   
   public void initializeParameters(){
        loggedInUserId = Userinfo.getUserId();
        List<Profile> profileNameList = [SELECT Name 
                                            FROM 
                                            Profile 
                                            WHERE 
                                            Id=:userinfo.getProfileId() LIMIT 1
                                        ];
        if(profileNameList != null && profileNameList.size() > 0) 
                    profileName = profileNameList[0].Name;
  
        for(EntitySubscription es:[select parentID,SubscriberId 
                                        from 
                                        EntitySubscription 
                                        where 
                                        parentId = :caseId ]){
            ExistingcaseFollowers.add(es.SubscriberId);
            chatterFollowerMap.put(es.SubscriberId,es);
        }
        //Get Existing Case Team Members  
        if (caseId!=Null){
            for(caseTeamMember ctm:[select id,memberId,member.Name,parentId,TeamRole.Name 
                                        from 
                                        caseTeamMember 
                                        where 
                                        parentId = :caseId 
                                    ]){
                ExistingTeamMemberIdList.add(ctm.memberId) ;
            }
        }
        ctmList= new List<caseTeamMember>();
        caseRecord = [select id,FKStage__c,Owner_Role__c,OwnerId,Owner.email 
                        FROM 
                        case 
                        WHERE 
                        id =: Caseid limit 1
                     ];
        List<caseTeamMember> ListCTM =new  List<caseTeamMember>(CtmList);
        //Get case Owner Role from Case Stage Matrix
        if(caseRecord.fkstage__c!=Null)
        For(Case_Stage_Team_Master__c SCT:[SELECT id,Case_Owner_Name__c 
                                            from 
                                            Case_Stage_Team_Master__c 
                                            where 
                                            FKStage__c=:caseRecord.fkstage__c 
                                            limit 1
                                         ]){
            caseOwnerRole=(string)SCT.Case_Owner_Name__c;
        }
        owe = [select Address,IsAllowAllProfiles,DisplayName 
                        from 
                        OrgWideEmailAddress 
                        where 
                        DisplayName='COH Care Coordination Application' 
                        limit 1
              ]; 
        caseOwnerProfile = CH_StaticComponentHelperClass.CH_CaseOwner;      
        supervisor = CH_StaticComponentHelperClass.CH_Supervisors;
        caseOwnerServiceDeskProfile = CH_StaticComponentHelperClass.CH_CaseOwnerServiceDesk;      
        supervisorServiceDeskProfile = CH_StaticComponentHelperClass.CH_SupervisorsServiceDesk;
   }

    public pageReference removeMember(){
       //Reset selected user and role
        selecteduser='none';
        selectedrole='none';
        if(getcaseteamrecordid !=Null && caseId!=null){
            List<CaseTeamMember> lstcaseteammemberIDs = new list<CaseTeamMember>();
            lstcaseteammemberIDs  = [select id,TeamRole.Name,memberid 
                                        from 
                                        caseteammember 
                                        where 
                                        memberid =:getcaseteamrecordid  
                                        AND 
                                        parentid = :CaseId 
                                        limit 1
                                    ];
            List<User_Limits__c> UserLimitsTobeUpdated = new List<User_Limits__c>();
          
            if(!lstcaseteammemberIDs.isempty())
                if(lstcaseteammemberIDs[0].TeamRole.Name != '%'+ CH_StaticComponentHelperClass.CH_Manager_Role_Suffix)
                    UserLimitsTobeUpdated =[select Id,User__c,Case_Count_Limit__c 
                                                from 
                                                User_Limits__c 
                                                where 
                                                User__c =:getcaseteamrecordid 
                                                Limit 1
                                            ];
            try{
                boolean useradded= False;
                Database.deleteResult[] deleteResults;
                if(lstcaseteammemberIDs !=null && lstcaseteammemberIDs.size()>0){
                    list<Role_Master__c> managerList = [select FkManager__c , name 
                                                            from 
                                                            Role_Master__c 
                                                            where 
                                                            Name =: lstcaseteammemberIDs[0].TeamRole.Name 
                                                            limit 1
                                                        ];                
                                            
                    list<case> loggedInUserList= [SELECT Id, OwnerId 
                                                    from 
                                                    Case 
                                                    WHERE 
                                                    OwnerId =: loggedInUserId 
                                                    and 
                                                    Id =: caseId 
                                                    limit 1
                                                 ];        
                        
                    //If Case owner is logged in or team member manager or profile is sys admin , case owner, user itself is logged in then remove 
                    if((managerList.size() > 0 && managerList[0].FkManager__c == loggedInUserId)||
                            (loggedInUserList != null && loggedInUserList.size() > 0) || 
                            (profileName != '' && (profileName == 'System Administrator' || 
                             profileName == CH_StaticComponentHelperClass.CH_CaseOwner)) ||
                             lstcaseteammemberIDs[0].MemberId == loggedInUserId){
                                    
                        deleteResults=database.delete(lstcaseteammemberIDs) ;
                        //ctmList.remove(rowNo);
                        ExistingTeamMemberIdList.remove(lstcaseteammemberIDs[0].memberid);
                                
                        ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.CONFIRM,
                                    System.Label.CH_PageMessage_Member_removed_Successfully));
                            
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.Error,
                                    system.label.CH_CaseTeamMember_Dont_Have_Permission));
                    }      
                }
                If(UserLimitsTobeUpdated.size() > 0 && deleteResults!= null && deleteResults[0].isSuccess()){
                    UserLimitsTobeUpdated[0].Case_Count_Limit__c -=1;
                    update UserLimitsTobeUpdated;
                }
                if(chatterFollowerMap.get(getcaseteamrecordid)!=Null){
                    delete chatterFollowerMap.get(getcaseteamrecordid);
                }
                if(ApexPages.getMessages().size() > 0){
                    refreshPage = false;
                }else{
                    refreshPage = true;
                }   
            }
        catch(DmlException de){
            System.debug('******************Exception***********'+de.getmessage());
            refreshPage = false;            
        }  
    }
    if(getcaseteamrecordid ==Null){
        if (rowNo!=NuLL)
            ctmList.remove(rowNo);
    }
    return Null;
   }
   
    public pageReference AddMember(){
        getusers();
        return null;
    }
   
    public List<SelectOption> getCon(){
        list<SelectOption> conOptions = new List<SelectOption>();      
        list< caseteamrole> conname = [select id,Name 
                                        from 
                                        caseteamRole  
                                        where 
                                        (NOT name like '% - Manager') 
                                        AND 
                                        name != 'Default User'
                                      ];
        conOptions.add(new selectoption('--None--','--None--'));
        for( caseteamrole ctm: conname ){
            conOptions.add(new selectoption(ctm.name,ctm.name));
        }
        return conOptions;
    }
     
    public list<SelectOption> getusers(){
       List<SelectOption> getUsers = new List<SelectOption>();  
       getUsers.add(new selectoption('--None--','--None--'));    
       set<id>matcheduserId= new set<id>();
       for( Disease_Matrix__c  getMatchingUsersrecords :[select id ,
                                                         User_Role_name__c ,
                                                         User__r.name ,
                                                         User__c ,
                                                         User__r.isactive
                                                         from 
                                                         Disease_Matrix__c 
                                                         where 
                                                         User_Role_name__c =: selectedrole 
                                                         AND 
                                                         User__c  
                                                         NOT IN :ExistingTeamMemberIdList 
                                                         AND 
                                                         User__r.isactive = true]){
             if(getMatchingUsersrecords !=null ){                       
                 matcheduserId.add( getMatchingUsersrecords.User__c);  
                 mapOfIdAndRoleName.put(getMatchingUsersrecords.User__c, getMatchingUsersrecords );          
              }                    
        }
        
        if(matcheduserId != null && matcheduserId.size()>0){
            list<User_Limits__c > getMatchingUsers = [select id ,
                                                                User__c,
                                                                User__r.name
                                                                from 
                                                                User_Limits__c 
                                                                where 
                                                                User__c in: matcheduserId
                                                                AND 
                                                                Max_Limit_reached__c=false  ];
            if(getMatchingUsers .size()>0 && getMatchingUsers  !=null){
                for( User_Limits__c matchinguser: getMatchingUsers ){
                    if(matchinguser.User__r.name !=null &&  matchinguser.User__c !=null){
                        Disease_Matrix__c temprecord=mapOfIdAndRoleName.get(matchinguser.User__c);
                        if(temprecord !=null){
                            getUsers.add(new selectoption(temprecord .User__c,temprecord .User__r.name));
                        }
                    }
                 }    
            }
        }
      return getUsers;
    }
  
    public void AddCaseteammember (){
        string selecteduserstore;
        refreshPage = true;
        CaseTeamRole getcaseteamrole = new CaseTeamRole();
        Case tempCase= new Case();
        list<Alert_Detail__c> getalertrecords= new list<Alert_Detail__c>();
        CaseTeamRole  getRoleid;
        if (selectedrole =='--None--' ){
            validationFound = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                            System.Label.CH_PageMessage_None_value_selected_for_Role);
            ApexPages.addmessage(myMsg);
            //refreshPage = false;
        }
        if(selecteduser =='--None--' ){
            validationFound =true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                System.Label.CH_PageMessage_None_value_selected_for_user);
            ApexPages.addmessage(myMsg);
           
        }
         
        if(selectedrole!=Null && selectedrole !='--None--' && selecteduser != Null && selecteduser !='--None--')
            getRoleid=[ select id,Name from CaseTeamRole where name=:selectedrole Limit 1];
            if(getRoleid !=null && selecteduser != Null && caseId != Null){
                CaseTeamMember createmember= new CaseTeamMember();
                createmember.MemberId=selecteduser;
                createmember.TeamRoleId=getRoleid.id;
                createmember.parentid=caseId;
                selecteduserstore=selecteduser;
               
                if(selecteduserstore != null ){
                     UserRecord = [Select id,CC_Receive_Checklist_Completion_Emails__c, CC_Receive_Checklist_Assignment_Email__c, 
                                    CC_Receive_Assingment_Emails__c from user where id =:selecteduserstore];
                }
                                                                
                try{
                    Database.SaveResult srList = Database.insert(createmember, false);
                    // Iterate through each returned result
                    if (srList.isSuccess()){                       
                        ctmList.Add(createmember);   
                        if(ExistingcaseFollowers.contains(createmember.MemberId) == false){
                            EntitySubscription es = new EntitySubscription(
                                        ParentId = CaseId, SubscriberId = createmember.MemberId);
                            insert es; 
                        }                     
                        /// make member as follower of case in chatter
                         ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.CONFIRM,
                                        System.Label.CH_PageMessage_Member_added_Successfully));
                         InsertedCaseTeamMember=getRoleid.id;
                         parentCaseId=caseId;
                         list<User_Limits__c> UserLimitforSelectedUser = 
                                                [select id,Case_count_limit__c  
                                                    from 
                                                    User_limits__c 
                                                    where 
                                                    User__c =:selecteduserstore 
                                                    limit 1
                                                ];
                         if(!UserLimitforSelectedUser.isempty()){
                             UserLimitforSelectedUser[0].Case_count_limit__c +=1;
                             Update UserLimitforSelectedUser;
                         }
                         CaseTeamMember ctm = [select id,teamrole.name,
                                                memberid,
                                                parentid,member.name 
                                                from 
                                                CaseTeamMember 
                                                where 
                                                id = :srList.getid()
                                             ];
                         if( ctm !=null){
                             selecteduserName=ctm.member.name;
                             if(caseOwnerRole!=Null && ctm.TeamRole.Name == caseOwnerRole){
                                 CaseRecord.OwnerID = createmember.Memberid;
                                 Update caseRecord;
                             }  
                         }
                         
                    }
                    else {
                       
                        refreshPage = false;
                    }
                }
                catch( Exception e){
                    system.debug('***************Exception*****************'+ e.getmessage());
                    refreshPage = false;
                }
                finally{
                    //Reset selected user and role
                    selecteduser='none';
                    selectedrole='none';
                }
                if(InsertedCaseTeamMember !=null){                    
                     getcaseteamrole    = [select id , name 
                                                from 
                                                CaseTeamRole 
                                                where 
                                                id =: InsertedCaseTeamMember];
                 }                 

                if(parentCaseId !=null){
                     tempCase = [select id,CC_Appointment_Date__c,
                                    fkstage__c,fkstatus__c,
                                    stage__c,status__c 
                                    from 
                                    case 
                                    where 
                                    id =:parentCaseId];
                }               
                
                if(getcaseteamrole != null && tempCase  !=null){
                  getalertrecords= [select id,  Due_Date__c,
                                        Alert_Master__c, Task_Name__c,
                                        Alert_Master__r.Alert_Type__c,
                                        Templates__c,Assign_To__c,
                                        Alert_Master__r.status__c, 
                                        Alert_Master__r.stage__c ,
                                        Checklist__c,
                                        Checklist__r.Checklist_Description__c,
                                        Checklist__r.name,
                                        Description__c,
                                        Checklist_Tasks__r.name ,
                                        Checklist__r.Days__c, 
                                        Checklist__r.UniqueIdentifier__c,
                                        Static_chatter_text__c,
                                        Checklist__r.Health_Goal_Name__c    
                                        from    
                                        Alert_Detail__c 
                                        where 
                                        Assign_To__c =:getcaseteamrole.name 
                                        and
                                        Alert_Master__r.stage__c =:tempCase.stage__c 
                                        and 
                                        Alert_Master__r.status__c =:tempCase.status__c
                                     ];
                    
                }
            }

             List<Messaging.SingleEmailMessage>
               mails = new List<Messaging.SingleEmailMessage>();
           
             for(EmailTemplate tempemailtmp : [SELECT id,folder.name ,DeveloperName  
                                                FROM 
                                                EmailTemplate 
                                                where 
                                                folder.name =:'COH Templates' 
                                                and 
                                                IsActive=true
                                             ] ){
                 if(tempemailtmp!=null)
                    mapEmailTemplates.put(tempemailtmp.DeveloperName,tempemailtmp.id);
             }
             if(getalertrecords !=null && getalertrecords.size()>0){
                for(Alert_Detail__c ad :getalertrecords){
                    if(ad.Alert_Master__r.Alert_Type__c=='Checklist'){
                        setOfchecklistId.add(ad.Checklist__c);
                    }
                }
             if(setOfchecklistId !=null && setOfchecklistId.size()>0){
                for( checklist_Tasks__c  checklsttsk :[select id, Name, 
                                                        Checklist__c,Due_Date__c,
                                                        Task_Description__c,
                                                        Checklist__r.Checklist_Description__c,
                                                        Checklist__r.Days__c, 
                                                        Checklist__r.UniqueIdentifier__c ,
                                                        Checklist__r.name ,
                                                        Checklist__r.Health_Goal_Name__c  
                                                        from 
                                                        Checklist_Tasks__c 
                                                        where 
                                                        Checklist__c in : setOfchecklistId 
                                                     ]){
                    if(checklsttsk.Checklist__c !=null)
                        mapIdAndCheckListRecordsmanually.put(checklsttsk.Checklist__r.name + 
                                                checklsttsk.Checklist__r.UniqueIdentifier__c + 
                                                checklsttsk.name+checklsttsk.Checklist__c  ,checklsttsk);
                        
                    }
            }
            lstOfChatterPostToBeInserted= new list<FeedItem>();
            lstCheckListRecordsTobeInsert= new list< Health_Goal__c >();
            for(Alert_Detail__c adetail :getalertrecords ){              
                if(adetail.Alert_Master__r.Alert_Type__c=='Checklist'){
                    string chatterpost;
                    string emailtemplate;
                    sendEmailOnchecklistassingment= false;
                    Health_Goal__c   TempChecklistvalue= new Health_Goal__c();
                    for (string key : mapIdAndCheckListRecordsmanually.keySet()) {
                        if(adetail.Checklist__c  !=null){
                            if( key.contains(adetail.Checklist__c)==true){
                                if(adetail.Templates__c!=null){
                                    emailtemplate=adetail.Templates__c;
                                }
                                if(adetail.Description__c!=null){
                                    chatterpost=adetail.Description__c;
                                }
                                if(UserRecord != null && UserRecord.CC_Receive_Checklist_Assignment_Email__c==true){
                                    
                                    sendEmailOnchecklistassingment=true;
                                    
                                }
                                TempChecklistvalue= CH_AlertEngineHelperClass.CreateGoal(
                                                            tempCase.id, adetail,
                                                            tempCase.CC_Appointment_Date__c,
                                                            selecteduserstore,emailtemplate,
                                                            chatterpost,adetail.Alert_Master__r.stage__c,
                                                            adetail.Alert_Master__r.status__c,sendEmailOnchecklistassingment);
                                                       
                                setOfchecklistnameandAssignto.add(TempChecklistvalue.UniqueIdentifier__c);
                                                        
                                if((setPreventDuplicateRecord.contains(TempChecklistvalue)==false) || 
                                        (setPreventDuplicateRecord.size()==0) ){
                                    lstCheckListRecordsTobeInsert.add(TempChecklistvalue);
                                }
                                setPreventDuplicateRecord.add(TempChecklistvalue);                                                        
                            }                                                    
                        }
                    }           
                }
                else if(adetail.Alert_Master__r.Alert_Type__c=='Chatter'){
                   FeedItem TempFeedItem= new FeedItem();
                   TempFeedItem=CH_AlertEngineHelperClass.CreateChatterPost( 
                                        tempCase.id ,adetail.Description__c,
                                        selecteduserName,adetail.Static_chatter_text__c);
                   if(TempFeedItem !=null){
                       if((setOfPreventDuplicateChatterPost.contains(TempFeedItem)== false)|| 
                                (setOfPreventDuplicateChatterPost.size()==0)){
                           lstOfChatterPostToBeInserted.add(TempFeedItem);
                       }
                       setOfPreventDuplicateChatterPost.add(TempFeedItem);
                    }                    
                }
                else if(adetail.Alert_Master__r.Alert_Type__c=='Email'){
                    
                   if(UserRecord != null  && UserRecord.CC_Receive_Assingment_Emails__c==true){
                        id et;
                        if(mapEmailTemplates !=null && mapEmailTemplates.size()>0){
                            et = mapEmailTemplates.get(adetail.Templates__c);
                        }
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> ccTo = new List<String>();
                        if( et != null){
                            mail.setTemplateId(et);
                            mail.setOrgWideEmailAddressId(owe.Id);
                            mail.whatid=tempCase.id;
                            mail.setTargetObjectId(selecteduserstore);
                            mail.saveAsActivity = false;
                            mails.add(mail);
                            Messaging.sendEmail(mails);
                        }
                    }
                }
            }
           
        }
        
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
                
        if(insertedRecordChecklistAndTaskid !=null && insertedRecordChecklistAndTaskid.size()>0){
            for(Health_Goal__c checklisttaskrecords:[select id,UniqueIdentifier__c,
                                                        Case__r.id,Assigned_to__c,name,Due_Date__c,case__r.CaseNumber, 
                                                        case__r.Account.name from 
                                                        Health_Goal__c  
                                                        where 
                                                        id in:insertedRecordChecklistAndTaskid
                                                    ]){
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
            tempTasksToBeInserted= new List<Task>();
            for (string key : mapIdAndCheckListRecordsmanually.keySet()) {
               if(insertedchecklist.UniqueIdentifier__c !=null){
                    if( key.contains(string.valueof(insertedchecklist.UniqueIdentifier__c))==true){
                        Checklist_Tasks__c TempTask1= new Checklist_Tasks__c();
                        TempTask1 =mapIdAndCheckListRecordsmanually.get(key);
                        Task TempTask= new Task();
                        TempTask  = CH_AlertEngineHelperClass.CreateTask( 
                                        insertedchecklist.Assigned_to__c ,
                                        insertedchecklist.Due_Date__c,
                                        TempTask1.Name,insertedchecklist.id,insertedchecklist);
                        if(TempTask !=null){
                            tempTasksToBeInserted.add( TempTask);
                        }
                    } 
                }
            }
            if(tempTasksToBeInserted.size()>0){
                for(Task tskrecord :tempTasksToBeInserted){
                   taskTobeIns1.add(tskrecord);
                }
            }    
         }
                
        /* Inserting the chcklist task for the checklist*/
        if( taskTobeIns1 !=null && taskTobeIns1.size()>0){
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
     /* sending emails */
     if(mails !=null && mails.size()>0){
        try{
            Messaging.sendEmail(mails);
        }
        catch(Exception e){
            System.debug('******************Exception***********'+ e.getmessage());
            ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR,
                                        e.getmessage()));
        }
            
     }
     if(ApexPages.hasMessages(ApexPages.Severity.ERROR)){
        refreshPage = false;
     }    
   }  
   
}