/*
*  Name           :   CH_ShowHealthGoalsGridController
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   class to show data on CH_ShowHealthGoalsGridPage used in console
*/


public with sharing class CH_ShowHealthGoalsGridController{
    public String rId {get;set;}
    public String loggedinUserid {get;set;}
    Public Boolean hideSaveButton { get; set;}
    Public Boolean hideNewCheckListButton { get; set;}
    private final Case caseid;
    public final Health_Goal__c Contactid1 { get; private set; }
    public String profileName;
    public List<caseteammember> roleuser;
    public List<Case> caseDetailList;
    public List<Alert_Detail__c> alertDetailList;
    public Id contactId {get;set;}
    public string sortDirection {get;set;}
    public boolean  disableDelBtn {get;set;}
    public boolean showMsg              { get; set;}
    public string caseOwnerProfile {get;set;}

    public String headerName{
        get{
            headerName = System.Label.CH_HealthGoal_HeaderNM_ChecklistTask;
            return headerName;
        }
        set;
    } 
    //Contains all the records to be displayed on the grid
    public List<GridParentRow> gridTable        { get; set;}
    public List<GridParentRow> loggedinUserGoalRecords        { get; set;}
    //Contains all the new parent records to be created
    public List<GridParentRow> newParentRecords     { get; set;}
    //To hide or show the grid when a grid is selected    
    public boolean showGrid{
        get{
            
            return true;
        }
        set;
    }
    //Refresh Primary Tab
    public boolean refreshPage{get;set;}
    
    // Constructor of the class
    public CH_ShowHealthGoalsGridController(ApexPages.StandardController stdController) {
    

        this.caseid= (Case)stdController.getRecord();
        gridTable = new List<GridParentRow>();
        loggedinUserGoalRecords = new List<GridParentRow>();
        showMsg = false;
        hideSaveButton = true;
        hideNewCheckListButton = false;
        disableDelBtn = false;
        sortDirection = 'DESC';
        getUserData();
        loggedinUserid = UserInfo.getUserId();        
        List<Profile> profileNameList = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        profileName = profileNameList[0].Name;
        refreshPage = true;
        caseOwnerProfile = CH_StaticComponentHelperClass.CH_CaseOwner;
    }
    
    // To update the status to Complete on complete button click
     public void ChecklistComplete(){     
    
        Boolean userCanComplete = false;    
        List<SObject> objectsForUpdateOnComplete = new List<SObject>();
        if(rId != null && rId !=''){       
            if(gridTable !=null && gridTable.size()>0){
                for(GridParentRow parentRow : gridTable){                
                    if(parentRow.parentObj.id == rID){
                    system.debug('line 82');
                        if(parentRow.parentObj.Assigned_to__c != null && profileName !='' && (parentRow.parentObj.Assigned_to__c == UserInfo.getUserId() || profileName == CH_StaticComponentHelperClass.CH_CaseOwner || profileName == 'System Administrator') ){
                            parentRow.parentObj.Status__c ='Completed';
                            parentRow.parentObj.flag1__c =true;
                            parentRow.parentObj.Completed_By__c = loggedinUserid;
                            parentRow.parentObj.Completed_Date__c = system.today();
                            objectsForUpdateOnComplete.add(parentRow.parentObj);
                            userCanComplete = true;
                        }else{                                  
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CH_HealthGoal_UnAuthorized_To_Complete_Checklist));
                            refreshPage = false;
                        }
                        
                    }
                }
                
                try{
                    if(userCanComplete){
                        Update objectsForUpdateOnComplete;
                        if(ApexPages.getMessages().size() > 0){
                            refreshPage = false;
                        }else{
                            refreshPage = true;
                        }                   
                    }
                }Catch(Exception e){
                        showMsg = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                        refreshPage = false;  

                }
            }
            // new code added to complete the checklist of logged in user
            if(loggedinUserGoalRecords !=null && loggedinUserGoalRecords.size()>0){
                objectsForUpdateOnComplete = new List<SObject>();
                for(GridParentRow parentRow : loggedinUserGoalRecords){                
                    if(parentRow.parentObj.id == rID){
                    system.debug('line 822');
                        if(parentRow.parentObj.Assigned_to__c != null && profileName !='' && (parentRow.parentObj.Assigned_to__c == UserInfo.getUserId() || profileName == CH_StaticComponentHelperClass.CH_CaseOwner || profileName == 'System Administrator') ){
                            parentRow.parentObj.Status__c ='Completed';
                            parentRow.parentObj.flag1__c =true;
                            parentRow.parentObj.Completed_By__c = loggedinUserid;
                            parentRow.parentObj.Completed_Date__c = system.today();
                            objectsForUpdateOnComplete.add(parentRow.parentObj);
                            userCanComplete = true;
                        }else{                                  
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CH_HealthGoal_UnAuthorized_To_Complete_Checklist));
                            refreshPage = false;
                        }
                        
                    }
                }
                
                try{
                    if(userCanComplete){
                     
                        Update objectsForUpdateOnComplete;
                        if(ApexPages.getMessages().size() > 0){
                            refreshPage = false;
                        }else{
                            refreshPage = true;
                        }                   
                    }
                }Catch(Exception e){
                        showMsg = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                        refreshPage = false;  

                }
            } 
            // code changes ended 
         }
        getUserData();
    }
    //Dynamically retrive task status values
    public List<SelectOption> getCon(){
        list<SelectOption> conOptions = new List<SelectOption>();  
        Schema.DescribeFieldResult statusFieldDescription = Task.Status.getDescribe();
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()){
            conOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }     
        return conOptions;
    }
    
     //Dynamically retrive Assign to values for case team member
    public List<SelectOption> getAssignTo(){
        list<SelectOption> assignToOptions = new List<SelectOption>();  
        list<CaseTeamMember> lstCaseTM = new list<CaseTeamMember>();
        
        lstCaseTM = [select id ,teamrole.name,parentid,MemberId from caseteammember where parentid =: caseid.id];
        assignToOptions.add(new SelectOption('--None--','--None--'));
        for (CaseTeamMember caseTm : lstCaseTM){
            assignToOptions.add(new SelectOption(caseTm.teamrole.name,caseTm.teamrole.name));
        }     
        return assignToOptions;
    }
    
    
    //To populate the grid
    public void getUserData(){
        String teamRoleName;
        String logginUserInfo = UserInfo.getUserId();        
        gridTable = new List<GridParentRow>();
        loggedinUserGoalRecords = new List<GridParentRow>();
        Map<id,List<Task>> HealthGoalTaskMap = new Map<id,List<Task>>(); 
       
        if(newParentRecords != null)
            newParentRecords.clear(); 
            showMsg = false;
        //Fetching all the parent and child objects for the selected grid
        try{      
            for(CaseTeamMember caseTeamroleuser : [select teamrole.name,MemberId from caseteammember where MemberId =: logginUserInfo limit 1]){
                system.debug('inside for lop');
                 teamRoleName = caseTeamroleuser.teamrole.name;                
                               
            }
            
            List<Health_Goal__c> allRecords =[Select id,Status__c,case__r.Account.name,case__r.Stage__c,case__r.Status__c,case__r.CaseNumber,Completed_By__c, Name,Created_Status__c,Created_Stage__c,Stage__c,Assign_To__c,Assigned_to__c, Due_Date__c, Complete__c,Completed_Date__c,createddate,Abbreviated_name__c
                                                from Health_Goal__c 
                                                Where Case__c = :caseid.id
                                                ORDER BY createddate DESC];
            List<Task> allTask=[select subject, Status,OwnerId, ActivityDate, WhatId  from Task where WhatId in :allRecords order by Status DESC];
            //Filling up the GridParentRow structure
            for(Task alltasks : allTask){
                List<Task> temptasklist = new List<Task>();
                if(HealthGoalTaskMap.get(alltasks.WhatId)==Null && temptasklist.size()==0){
                    temptasklist.add(alltasks);  
                    system.debug('inside if');                 
                }   
                else{
                    temptasklist = HealthGoalTaskMap.get(alltasks.WhatId);
                    if(temptasklist!=null && temptasklist.size()>0){
                    temptasklist.add(alltasks);
                    }
                }
                if(temptasklist !=Null && temptasklist.size()>0){
                    HealthGoalTaskMap.put(alltasks.WhatId,temptasklist);                    
                }
            }
            for(Health_Goal__c parentRec:allRecords){
                system.debug('inside for lopp all records');
                GridParentRow gtr = new GridParentRow();
                //gtr.saveParentRecord(parentRec);
                List<Task> tempList;// = HealthGoalTaskMap.get(parentRec.id);
                //gtr.saveChildRecords(tempList);
                // new changes on below list gridtable for checklist sorting 
              // gridTable.add(gtr);
               
               if(parentRec.case__r.Stage__c == parentRec.Created_Stage__c && parentRec.case__r.Status__c == parentRec.Created_Status__c && parentRec.Assign_To__c == teamRoleName){
                    gtr.saveParentRecord(parentRec);                    
                    tempList = HealthGoalTaskMap.get(parentRec.id);                    
                    gtr.saveChildRecords(tempList);                    
                    loggedinUserGoalRecords.add(gtr);                   
               }else{
                    gtr.saveParentRecord(parentRec);
                    tempList = HealthGoalTaskMap.get(parentRec.id);
                    gtr.saveChildRecords(tempList);
                    // new changes on below list gridtable for checklist sorting 
                    gridTable.add(gtr);
                                   
               }
               system.debug('end of for loop');
               
            }
       
            showGrid = true;
            if(gridTable.size() == 0 && loggedinUserGoalRecords.size() == 0){
                hideSaveButton = false;
                hideNewCheckListButton = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.CH_HealthGoal_NoTask_for_Team));
            }
        }Catch(Exception e){
            showMsg = true;
            hideNewCheckListButton = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));  
        }
    }
    //To Add new Parent(checklist) Record.
    public void AddNewParentRecord(){
        hideSaveButton = true;
        System.debug('AddNewParentRecord');
        if(newParentRecords == null){
            newParentRecords = new List<GridParentRow>();    
        }
        GridParentRow gd = new GridParentRow();
        Health_Goal__c parentRec = new Health_Goal__c();
        parentRec.Case__c = caseid.id;
        if (Test.isRunningTest()) { 
            parentRec.Name = 'TestHealthGoal';
           parentRec.Assign_To__c = 'TestONCC';
        }
        gd.saveParentRecord(parentRec);
        List<Task> tempList = new List<Task>();
        gd.saveChildRecords(tempList);
        newParentRecords.add(gd);
    }
    
    //Remove checklist record when click on - button
    public void RemoveNewParentRow(){
        hideNewCheckListButton = false;
        newParentRecords.remove( newParentRecords.size()-1);
        refreshPage = true;


    }
    
    //To save the modified records for checklist and checklist task
    public void saveRecords(){
        List<SObject> objectsForUpdateloggedinUser = new List<SObject>();
            List<SObject> objectsToInsertloggedinUser = new List<SObject>();
            //List to insert chile record separatly to introduce error when task name is blank 
            List<Task> listtoinsertNewchildloggedinUser = new List<Task>();
        System.debug('Saving records');
        //To group sobject by sobject types
        //as Salesforce doesn't allow DML methods to work on staggered collection
        List<SObject> objectsForUpdate = new List<SObject>();
        List<SObject> objectsToInsert = new List<SObject>();
        //List to insert chile record separatly to introduce error when task name is blank 
        List<Task> listtoinsertNewchild = new List<Task>();
        showMsg = false;
        //Grouping parent records
        if(newParentRecords != null && newParentRecords.size()>0){
            SaveNewParentRecords();
        }
        if(gridTable.size() != 0){            
          
            for(GridParentRow parentRow : gridTable){
                objectsForUpdate.add(parentRow.parentObj);
            }
            //Grouping child records
            for(GridParentRow parentRow : gridTable){
                for(ChildObjWrapperClass c:parentRow.childRecords){
                        objectsForUpdate.add(c.childRecord);
                } 
                if(parentRow.NewChildObjs!= null && parentRow.NewChildObjs.size()>0){
                    for(Integer i=0; i<parentRow.NewChildObjs.size();i++)
                    {
                        Task newObj2 = (Task)parentRow.NewChildObjs.get(i);
                        if(newObj2.subject != null && newObj2.subject != ''){
                            if((newObj2.ActivityDate != null && newObj2.ActivityDate >= Date.today()) || (newObj2.ActivityDate == null) ){
                                listtoinsertNewchild.add(newObj2);

                            }else{
                                hideNewCheckListButton = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Duedate_lessthan_today));
                                
                            }
                        }else{
                            hideNewCheckListButton = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.CH_HealthGoal_Blank_TaskName));
                        }
                    }
                }    
            }
            
        }
        //new changes added to complete logged in user checklist when save record
        if(loggedinUserGoalRecords.size() != 0){            
            
            //newParentRecords = new List<GridParentRow>(); 
            /*for(GridParentRow parentRow : loggedinUserGoalRecords){
                objectsForUpdateloggedinUser.add(parentRow.parentObj);
            }*/
            //Grouping child records
            for(GridParentRow parentRow : loggedinUserGoalRecords){
                objectsForUpdateloggedinUser.add(parentRow.parentObj);
                for(ChildObjWrapperClass c:parentRow.childRecords){
                        objectsForUpdateloggedinUser.add(c.childRecord);
                } 
                if(parentRow.NewChildObjs!= null && parentRow.NewChildObjs.size()>0){
                    for(Integer i=0; i<parentRow.NewChildObjs.size();i++)
                    {
                        Task newObj2 = (Task)parentRow.NewChildObjs.get(i);
                        if(newObj2.subject != null && newObj2.subject != ''){
                            if((newObj2.ActivityDate != null && newObj2.ActivityDate >= Date.today()) || (newObj2.ActivityDate == null) ){
                                listtoinsertNewchildloggedinUser.add(newObj2);

                            }else{
                                hideNewCheckListButton = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Duedate_lessthan_today));
                                
                            }
                        }else{
                            hideNewCheckListButton = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.CH_HealthGoal_Blank_TaskName));
                        }
                    }
                }    
            }
            
        }
        
        // changes end
        try{
             if(listtoinsertNewchildloggedinUser!=null && listtoinsertNewchildloggedinUser.size()>0){
                insert listtoinsertNewchildloggedinUser;
            }
            if(objectsForUpdateloggedinUser!=null && objectsForUpdateloggedinUser.size()>0){
                update objectsForUpdateloggedinUser;
            }
            if(objectsForUpdateloggedinUser.size()>0 || objectsToInsertloggedinUser.size()>0 || (newParentRecords !=null && newParentRecords.size()>0) ){
                getUserData();  
            }
            
            
            if(listtoinsertNewchild!=null && listtoinsertNewchild.size()>0){
                insert listtoinsertNewchild;
            }
            if(objectsForUpdate!=null && objectsForUpdate.size()>0){
                update objectsForUpdate;
            }
            if(objectsForUpdate.size()>0 || objectsToInsert.size()>0 || (newParentRecords !=null && newParentRecords.size()>0) ){
                getUserData();  
            }
            if(ApexPages.getMessages().size() > 0){
                refreshPage = false;
            }else{
                refreshPage = true;
            }
            
        }Catch(Exception e){
            showMsg = true;
            System.debug('Exception in save method '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            refreshPage = false;
        }
    }  
    
    //To save new parent records(Checklist) Added.
    public void SaveNewParentRecords(){
        String caseStage;
        String caseStatus;
        String caseTeamrole;
        Boolean hideErrormessage = true;
        Set<String> roleSet = new Set<String>();
        Set<String> caseidSet = new Set<String>();
        System.debug('Saving new parent records');
        //To group sobject by sobject types
        //as Salesforce doesn't allow DML methods to work on staggered collection
        List<SObject> parentObjectsToInsert = new List<SObject>();
        List<SObject> childObjectsToInsert = new List<SObject>();
        List <Health_Goal__c> hltGoalsList = new List <Health_Goal__c>();
        showMsg = false;
        //validation to check due date of checklist should not be less than today
        if(newParentRecords != null && newParentRecords.size()>0 ){
            for(GridParentRow parentRow : newParentRecords){ 
                if(parentRow.parentObj.Name != null && parentRow.parentObj.Name!=''){
                    if(parentRow.parentObj.Assign_To__c != '--None--'){
                            if((parentRow.parentObj.Due_Date__c != null && parentRow.parentObj.Due_Date__c >= Date.today()) || (parentRow.parentObj.Due_Date__c == null) ){
                                
                            roleSet.add(parentRow.parentObj.Assign_To__c);
                            caseidSet.add(parentRow.parentObj.Case__c);  
                                              
                            }else{                              
                                hideNewCheckListButton = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_ChecklistDuedate_Lessthan_Today));
                            }
                    }else{
                            hideErrormessage = false;
                            hideNewCheckListButton = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.CH_HealthGoal_Select_Checklist_Role));                            
                    }

                }else{
                    hideErrormessage = false;
                    hideNewCheckListButton = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Blank_ChecklistName));
                
                }        
            }
        }
        //Query to feth the role related user from caseteammember object
        if(roleSet!=null && caseidSet!=null && roleSet.size()>0 && caseidSet.size()>0){
            roleuser = new List<caseteammember>();
            caseDetailList = new List<Case>();
            alertDetailList = new List<Alert_Detail__c>();
            roleuser = [select id ,teamrole.name,parentid,MemberId from caseteammember where parentid IN :caseidSet  and teamrole.name IN : roleSet];
            // Quering stage and status of case to insert in cehcklist record on creation if record 
            caseDetailList = [select id,Stage__c,status__c from Case where id IN :caseidSet];
            if(caseDetailList!=null && caseDetailList.size()>0){
                if(caseDetailList[0].Stage__c!=null){ 
                    caseStage = caseDetailList[0].Stage__c;
                }
                if(caseDetailList[0].status__c!=null ){
                    caseStatus = caseDetailList[0].status__c;
                }
                if(roleuser!=null && roleuser.size()>0){
                    if(roleuser[0].teamrole.name!=null){
                        caseTeamrole =roleuser[0].teamrole.name;
                    }
                }
            }
            if(caseStage!=null && caseStatus!=null && caseTeamrole!=null ){
                alertDetailList = [select id,Alert_Type__c,Assign_to__c,Static_chatter_text__c,Description__c,Templates__c,Stage__c,status__c from Alert_Detail__c where Stage__c=: caseStage and status__c =: caseStatus and Alert_Type__c = 'Checklist' and Assign_to__c =:caseTeamrole];
            }
            }
            //Grouping parent records
                if(roleuser!=null && roleuser.size()>0){
                    for(GridParentRow parentRow : newParentRecords)
                    {   
                        if(parentRow.parentObj.Name != null && parentRow.parentObj.Name!=''){
    
                            parentRow.parentObj.Assigned_to__c = roleuser[0].MemberId;
                            parentRow.parentObj.Checklist_Created_Manually__c = true;
                            if(caseDetailList!=null && caseDetailList.size()>0){
                                parentRow.parentObj.Created_Stage__c = caseDetailList[0].Stage__c ;
                                parentRow.parentObj.Created_Status__c = caseDetailList[0].status__c;
                                if(alertDetailList!=null && alertDetailList.size()>0){
                                    if(alertDetailList[0].Templates__c!=null){
                                        parentRow.parentObj.EmailTemplate__c = alertDetailList[0].Templates__c;
                                    }                                   
                                    if(alertDetailList[0].Description__c!=null){
                                        parentRow.parentObj.Chatter_Post__c = alertDetailList[0].Description__c;
                                    }
                                        parentRow.parentObj.Static_chatter_text__c = alertDetailList[0].Static_chatter_text__c;
                                } 
                               
                            }
                            hideNewCheckListButton = False;
                            parentObjectsToInsert.add(parentRow.parentObj);
    
                        }
                    }
                }else{
                    hideNewCheckListButton = false;
                    if(hideErrormessage){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Role_DoesnotExist_in_CaseTeam));
                    }
                }
            
        
        
        
        try{
            if(parentObjectsToInsert!=null && parentObjectsToInsert.size()>0){

                insert parentObjectsToInsert;
                // below query to insert case number and patient name in task, when parent and child created at the same time.
                hltGoalsList = [select id,case__r.CaseNumber,case__r.Account.name,Abbreviated_name__c from Health_Goal__c where id =:parentObjectsToInsert[0].id];
                hideNewCheckListButton = false;
                if(ApexPages.getMessages().size() > 0){
                            refreshPage = false;
                        }else{
                            refreshPage = true;
                        }
                    }                

            
        }Catch(Exception e){
            showMsg = true;
            System.debug('Exception in save parent record  method '+e.getStackTraceString());
            hideNewCheckListButton = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            refreshPage = false;
        }
        
        for(Integer parentIndex=0; parentIndex < newParentRecords.size();parentIndex++){
            GridParentRow parentRow = newParentRecords.get(parentIndex);
            
            if(parentRow.NewChildObjs!= null && parentRow.NewChildObjs.size()>0){
                for(Integer i=0; i<parentRow.NewChildObjs.size();i++){   
                    Task newObj = (Task)parentRow.NewChildObjs.get(i);
                    if(parentObjectsToInsert.size()>0){
                        newObj.WhatId = parentObjectsToInsert.get(parentIndex).Id;
                        // Added assigned to value in below line
                        List <Health_Goal__c> hlpGoals = parentObjectsToInsert;
                        newObj.Ownerid = hlpGoals[0].Assigned_to__c;
                        newObj.IsHealthGoalTask__c = true;
                        if(hltGoalsList!=null && hltGoalsList.size()>0){
                            newObj.Case_Number__c=hltGoalsList[0].case__r.CaseNumber;
                            newObj.Patient_name__c= hltGoalsList[0].case__r.Account.name;                   
                        }
                        if(newObj.subject != null && newObj.subject != ''){
                            if((newObj.ActivityDate != null && newObj.ActivityDate >= Date.today()) || (newObj.ActivityDate == null) ){
                                childObjectsToInsert.add((SObject)newObj);
                            }else{
                                hideNewCheckListButton = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Duedate_lessthan_today));
                            }
                        }else{
                            hideNewCheckListButton = false;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CH_HealthGoal_Blank_TaskName));
                        
                        }
                    }
                }
                 
            }    
        }
        try{
            if(childObjectsToInsert!=null && childObjectsToInsert.size()>0){
                insert childObjectsToInsert;
                hideNewCheckListButton = false;
                if(ApexPages.getMessages().size() > 0){
                            refreshPage = false;
                        }else{
                            refreshPage = true;
                        }
                    }

        }
        Catch(Exception e){
            showMsg = true;
            hideNewCheckListButton = false;
            System.debug('Exception in save cparent record  method '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            refreshPage = false;
        }
    }
    
    //Class to save each parent record with it's related child records
    public class GridParentRow{
        public boolean isSelected          { get; set;}
        public Health_Goal__c parentObj           { get; set;}
        //Constructor
        public GridParentRow(){
            this.isSelected = false;
        }
        //Set the parent record fields
        public void saveParentRecord(Health_Goal__c pObj) {
            this.parentObj = pObj;
        }   
        //Save the child record fields
        public void saveChildRecords(List<Task> cObj){
            this.childRecords = new List<ChildObjWrapperClass>();
            if(cObj!=null && cObj.size() != 0){
                for(Task c:cObj)
                    this.childRecords.add(new ChildObjWrapperClass(c));  
            }         
        }   
        public List<ChildObjWrapperClass> childRecords    { get; set;}
        public List<ChildObjWrapperClass> loggedinUserTaskRecords    { get; set;}
        public List<SObject> NewChildObjs          { get; set;}
        
        //Returns the count of records to be displayed in UI for each child relationship
        public Integer getsize()
        {
            return childRecords.size();
        }
        public void AddNewRecord(){
            System.debug('in Add New record function');
            if(NewChildObjs == null){
                
                NewChildObjs = new List<SObject>(); 
            }
            try{
                Task Obj = new Task();
                if(parentObj.Id != null){
                    Obj.WhatId =parentObj.Id;
                    
                }  
                if(parentObj.Id != null && parentObj.Assigned_to__c != null){
                     Obj.WhatId =parentObj.Id;
                      Obj.OwnerId =parentObj.Assigned_to__c;
                      Obj.Case_Number__c=parentObj.case__r.CaseNumber;
                      Obj.Patient_name__c= parentObj.case__r.Account.name;
                      obj.IsHealthGoalTask__c = true;
                }  
                NewChildObjs.add(Obj);  
            }
            catch(exception e){
                system.debug('sds' + e.getMessage()); 
            }
        }
        
        public void RemoveNewRow(){
            //hideNewCheckListButton = false; 
            NewChildObjs.remove(NewChildObjs.size()-1);    
                   
        }      
        
        public boolean getNewListSize(){
            if(NewChildObjs == null || NewChildObjs.size() == 0)
                return false;
            return true;
        } 

  }
    //Wrapper class for child record to show checkbox on the vf page.
    public class ChildObjWrapperClass{
        public boolean isSelected        { get; set;}
        public Task childRecord        { get; set;}
        
        public ChildObjWrapperClass(Task cObj){
            isSelected = false;
            this.childrecord = cObj;
        }
    }

}