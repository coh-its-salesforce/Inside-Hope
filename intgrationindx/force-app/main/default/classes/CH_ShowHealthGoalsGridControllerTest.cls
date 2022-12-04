@isTest(seeAllData=false)
Public Class CH_ShowHealthGoalsGridControllerTest{
    //public String rId;
  static testMethod void TestUserData(){  
    String rId;
    PageReference pg = Page.CH_ShowHealthGoalsGrid;
    Test.setCurrentPage(pg);
    
    User u = CH_Test_SampleData.createUserRecord(1,'system administrator');    
    Account accountRecord = CH_Test_SampleData.createNewPatientAccounts(1);
    Case caseRecord= CH_Test_SampleData.createCase(1,accountRecord);
    Alert_Master__c smatrix = CH_Test_SampleData.createAlertMatrix('Patient Intake', 'Checklist', 'New');         
        
    Checklist__c checklist= new Checklist__c ();
    Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
            
    checklist = CH_Test_SampleData.createChecklist(1);
    checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);     
    Alert_Detail__c alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks, 'TestONCC');
    alertdetail.Static_chatter_text__c = true;
    update alertdetail;
        
    System.runAs ( u ) {
        CaseTeamRole ctRole =CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
        insert ctRole;
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = caseRecord.id; 
        ctm.TeamRoleid = ctRole.id;  
        ctm.memberid = u.id;
        insert ctm;
            
        Health_Goal__c temp= new Health_Goal__c(); 
        temp.Name = 'TestHealthGoal2';
        temp.status__c='Open';
        temp.Due_Date__c = Date.today(); 
        temp.Assign_To__c = 'TestONCC';
        temp.case__c=caseRecord.id;
        temp.No_of_Completed_Tasks__c = 1;  
        temp.Total_No_of_Tasks__c=3;
        temp.Assigned_to__c = u.id;
        insert temp;
                
        List<Task> taskList = new List<Task>();
        Task temptask = new Task();             
        temptask.Type = 'Email';
        temptask.Subject='demo';
        temptask.Status='Not Started';
        temptask .WhatId = temp.id; //record id
        temptask.IsHealthGoalTask__c = true;
        taskList.add(temptask);         
        insert taskList;                
         
        //GET AND UPDATE CASE STAGE 
        Task taskRecord = CH_Test_SampleData.createTask(temp.id);
        //taskRecord.WhatId = temp.id;  
        taskRecord.IsHealthGoalTask__c = true;      
        Update taskRecord;
        
        Test.startTest();
        
        Integer m = [SELECT count() FROM CaseTeamMember 
            WHERE CreatedDate = TODAY
            and CreatedById = :u.id] ;
        System.assertEquals(1, m);
            
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);
        CH_ShowHealthGoalsGridController show1 = new CH_ShowHealthGoalsGridController(sc);
        show1.rId = temp.id;    
        
        CH_ShowHealthGoalsGridController.GridParentRow psec1 = new CH_ShowHealthGoalsGridController.GridParentRow();
        
        psec1.saveParentRecord(temp);           
        psec1.saveChildRecords(taskList);
        show1.saveRecords();
        show1.getCon();
        show1.getAssignTo();
            
        ApexPages.CurrentPage().getParameters().put('Name','TestGoal');
        
        show1.AddNewParentRecord();
        show1.SaveNewParentRecords(); 
        psec1.AddNewRecord();     
        
        show1.saveRecords();
        show1.ChecklistComplete();
        show1.saveRecords(); 
        psec1.getNewListSize();
        
        Integer taskCount = [SELECT count() FROM Task 
                                WHERE CreatedDate = TODAY
                                and CreatedById = :u.id] ;
                                
        System.assertEquals(2, taskCount);
                                
        Integer healthGoalCount = [SELECT count() FROM Health_Goal__c 
                                    WHERE CreatedDate = TODAY
                                    and CreatedById = :u.id] ;                      
        System.assertEquals(2, healthGoalCount);
            
        
        Test.stopTest();
    }    
    }
  }