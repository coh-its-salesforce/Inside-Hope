@isTest(seeAllData=false)
private class CH_AlertEngineHelperClassTest{


    
static testMethod void AlertTypeEmailTest() {  
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 

    
   
    Alert_Master__c alertMaster;
    Alert_Detail__c alertdetail;
    Health_Goal__c hhg;
    Checklist__c checklist  = new Checklist__c ();
    Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();   
    
    user u  = CH_Test_SampleData.createUserRecord(1,'System Administrator');
    
    System.runAs ( u ) {
        
        Test.startTest();       
        
        Account accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
        Case caseRecord = new case();
        if(accountRecord != null){
            caseRecord.accountid = accountRecord.id;
        }
        caseRecord.Origin = 'Phone';
        caseRecord.Status = 'New';
        Status_Stage_Master__c status  = CH_Test_SampleData.CreateStatus('test');
        caseRecord.FkStatus__c = status.id;
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('test');
        caseRecord.FkStage__c = stage.id;
        caseRecord.Type= 'Letters';
        caseRecord.Owner_Role__c = 'TestONCC';
        caseRecord.RecordTypeId = CaseRecordTypeInfo.get('Care Coordination').getRecordTypeId(); 
        insert caseRecord;
        
        alertMaster = CH_Test_SampleData.createAlertMatrix(' ', 'Email', 'New');       
        
        Integer alertCount = [SELECT COUNT() FROM Alert_Master__c];
        System.assertEquals(alertCount, 1); 

        checklist = CH_Test_SampleData.createChecklist(1);
        checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);
        
        alertdetail = CH_Test_SampleData.createAlertDetial(alertMaster, checklist, checklistTasks,'TestONCC');   

        Health_Goal__c hgTemp = new Health_Goal__c();
        hgTemp.status__c ='Open';
        hgTemp.case__c = caseRecord.id;
        hgTemp.No_of_Completed_Tasks__c = 1;
        hgTemp.Total_No_of_Tasks__c = 3;
        insert hgTemp;
        
        System.assertNotEquals(hgTemp.id, null); 
        
        Task temp = new Task();
        temp.Type = 'Email';
        temp.Subject='Interact with patient 1';
        temp.Status='Not Started';
        temp.WhatId = hgTemp.id;
        temp.ownerId = u.id;
        temp.IsHealthGoalTask__c = true;
        insert temp; 
        
        System.assertNotEquals(temp.id, null);           

        CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
        insert tmRole;
         
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = caseRecord.id;
        ctm.TeamRoleid = tmRole .id;
        ctm.memberid = u.id;
       
        insert ctm;     
        
        System.assertNotEquals(ctm.id, null);    
         
        date d = system.today();
        
        caseRecord.FkStage__c = alertMaster.Stage_Master__c;
        caseRecord.FkStatus__c = alertMaster.Status_Master__c;
        update caseRecord;
       
        CH_AlertEngineHelperClass testClass = new CH_AlertEngineHelperClass();
        boolean testvariable= true;
        CH_AlertEngineHelperClass.CreateGoal(hgTemp.case__c, alertdetail,d,ctm.memberId,'','',alertdetail.stage__c,alertdetail.status__c,testvariable);
        
        temp.Status ='Completed';
        update temp;            
        

        Test.stopTest();
    }
}
    
            
           
    
    static testMethod void AlertTypeChecklistTest() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        Case caseRecord;
        Account accountRecord;
        Alert_Master__c smatrix;
        Checklist__c checklist;
        Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
        Alert_Detail__c alertdetail;
        
        user u= CH_Test_SampleData.createUserRecord(2,'System Administrator');
        
        System.runAs ( u ) {
            
            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(3);            
            caseRecord = new case();
            if(accountRecord != null){
                caseRecord.accountid = accountRecord.id;
                }
            caseRecord.Origin = 'Phone';
            caseRecord.Status = 'New';
            Status_Stage_Master__c status  = CH_Test_SampleData.CreateStatus('test');
            caseRecord.FkStatus__c = status.id;
            Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('test');
            caseRecord.FkStage__c = stage.id;
            caseRecord.Type= 'Letters';
            caseRecord.Owner_Role__c = 'TestONCC';
            caseRecord.RecordTypeId = CaseRecordTypeInfo.get('Care Coordination').getRecordTypeId(); 
            insert caseRecord;
            
            Test.startTest();
            smatrix = CH_Test_SampleData.createAlertMatrix('', 'Checklist', 'New');         
        
            checklist= new Checklist__c ();         
            
            checklist = CH_Test_SampleData.createChecklist(1);
            
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);
            
            alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks,'TestONCC');

            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;
            
            CaseTeamMember ctm = new CaseTeamMember();
            ctm.ParentId = caseRecord.id;
            ctm.TeamRoleid = tmRole.id;
            ctm.memberid = u.id;  
            insert ctm;        

            date d = system.today();

            Health_Goal__c hgTemp = new Health_Goal__c();
            hgTemp.status__c ='Open';          
            hgTemp.case__c = caseRecord.id;
            hgTemp.No_of_Completed_Tasks__c = 0;
            hgTemp.Total_No_of_Tasks__c = 1;
            
            insert hgTemp;
            
            Task temp = new Task();
            temp.Type = 'Email';
            temp.Subject='Interact with patient 1';
            temp.Status='Not Started';
            temp.WhatId = hgTemp.id; //record id
            temp.ownerId = u.id;
            temp.IsHealthGoalTask__c = true;            
            insert temp;  
            
            caseRecord.FkStage__c = smatrix.Stage_Master__c;
            caseRecord.FkStatus__c = smatrix.Status_Master__c;
            update caseRecord;
            
            Health_Goal__c hgTempv = new Health_Goal__c();
            hgTempv.status__c ='New';           
            hgTempv.case__c = caseRecord.id;
            hgTempv.No_of_Completed_Tasks__c = 1;
            hgTempv.Total_No_of_Tasks__c = 3;
            insert hgTempv;
            
            hgTempv.No_of_Completed_Tasks__c =2;
            update hgTempv;
            
            hgTemp.Status__c = 'Completed';
            hgTemp.flag1__c = true;           
            update hgTemp;
                    
            CH_AlertEngineHelperClass.CreateChatterPost(caseRecord.id,'chatter Text',u.name,true);  
            CH_AlertEngineHelperClass.Createtask(temp.OwnerId, date.today(), 'Patient Intake', temp.WhatId,hgTempv);
            
            //Check if task and health goal added
// testing--raymond tam
// Commented out because CH_CaseTrigger has been deactivated.
//            Integer healthGoalCount = [SELECT COUNT() FROM Health_Goal__c];
//            System.assertEquals(healthGoalCount, 3); 
            
//            Integer taskCount = [SELECT COUNT() FROM Task];
//            System.assertEquals(taskCount, 2); 

            Test.stopTest();
           
        }
    }
   
     static testMethod void AlertTypeChatterTest() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Alert_Master__c smatrix;
        Checklist__c checklist;
        Checklist_Tasks__c checklistTasks;
        Account accountRecord;
        Case caseRecord;
        Alert_Detail__c alertdetail;
        
        user u= CH_Test_SampleData.createUserRecord(3,'System Administrator');
        
        System.runAs ( u ) {
           Test.startTest();
           accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(2);
           
           caseRecord = CH_Test_SampleData.createCase(3,accountRecord);

           smatrix= CH_Test_SampleData.createAlertMatrix('', 'Chatter', 'ON Hold');           
           
           checklist = CH_Test_SampleData.createChecklist(1);
           
           checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);
           
           alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks,'TestONCC');  

           Health_Goal__c hgTemp = new Health_Goal__c();
           hgTemp.status__c ='Open';           
           hgTemp.case__c = caseRecord.id;
           hgTemp.No_of_Completed_Tasks__c = 1;
           hgTemp.Total_No_of_Tasks__c = 3;
            
           insert hgTemp;
           
           System.assertNotEquals(hgTemp.id, null); 
           
           Task temp = new Task();
           temp.Type = 'Email';
           temp.Subject='Interact with patient 1';
           temp.Status='Not Started';
           temp.WhatId = hgTemp.id; //record id
           temp.ownerId = u.id;
           temp.IsHealthGoalTask__c = true;
           insert temp;           
           
           System.assertNotEquals(temp.id, null); 
           
           CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
           insert tmRole;
            
           CaseTeamMember ctm = new CaseTeamMember();
           ctm.ParentId = hgTemp.case__c;
           ctm.TeamRoleid = tmRole .id;
           ctm.memberid = u.id;
          
           insert ctm;    
           
           System.assertNotEquals(ctm.id, null);       
           
           caseRecord.FkStage__c = smatrix.Stage_Master__c;
           caseRecord.FkStatus__c = smatrix.Status_Master__c;
           update caseRecord; 
            
           temp.Status= 'In Progress';
           update temp;
            
           hgTemp.flag1__c = false;
           hgTemp.No_of_Completed_Tasks__c = 3;
           update hgTemp;
           
           CH_AlertEngineHelperClass.CreateChatterPost(caseRecord.id,'chatter Text',u.name,false);
           
           Test.stopTest();
        }
           
     }
    
    static testMethod void AlertTypeChecklistCompletedTest() {
        
        Alert_Master__c smatrix;
        Checklist__c checklist;
        Checklist_Tasks__c checklistTasks;
        Account accountRecord;
        Case caseRecord;
        Alert_Detail__c alertdetail;
        
        user u= CH_Test_SampleData.createUserRecord(3,'System Administrator');
        
        System.runAs ( u ) {
            
           Test.startTest();
           accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(2);
           
           caseRecord = CH_Test_SampleData.createCase(3,accountRecord);
    
           smatrix= CH_Test_SampleData.createAlertMatrix('', 'Checklist Completed', 'ON Hold');           
           
           checklist = CH_Test_SampleData.createChecklist(1);
           
           checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);
           
           alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks,'TestONCC');
           alertdetail.Static_chatter_text__c = false;           
           update alertdetail;
 
           Health_Goal__c hgTemp = new Health_Goal__c();
           hgTemp.status__c ='Open';           
           hgTemp.case__c = caseRecord.id;
           hgTemp.No_of_Completed_Tasks__c = 1;
           hgTemp.Total_No_of_Tasks__c = 3;
            hgTemp.Assigned_to__c = u.id;
           insert hgTemp;
            
           Task temp = new Task();
           temp.Type = 'Email';
           temp.Subject='demo';
           temp.Status='Not Started';
           temp.WhatId = hgTemp.id;
           temp.ownerId = u.id;
           insert temp;
           
           Integer alertCount = [SELECT COUNT() FROM Alert_Master__c];
           System.assertEquals(alertCount, 1);
           
           Integer healthGoalCount = [SELECT COUNT() FROM Health_Goal__c];
           System.assertEquals(healthGoalCount, 1);
           
           Integer taskCount = [SELECT COUNT() FROM Task];
           System.assertEquals(taskCount, 1);  
            
           CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
           insert tmRole;
           
           CaseTeamMember ctm = new CaseTeamMember();
           ctm.ParentId = hgTemp.case__c;
           ctm.TeamRoleid = tmRole.id;
           ctm.memberid = u.id;
           insert ctm;
            
            
           caseRecord.FkStage__c = smatrix.Stage_Master__c;
           caseRecord.FkStatus__c = smatrix.Status_Master__c;
           update caseRecord; 
           
           hgTemp.Status__c = 'Completed';
           hgTemp.flag1__c = true;
           hgTemp.No_of_Completed_Tasks__c = 3;
           update hgTemp;
            
           CH_AlertEngineHelperClass.CreateChatterPost(caseRecord.id,'chatter Text','',false);
           Test.stopTest();        
        
           
        }
           
     } 
    
    static testMethod void OnTaskCompletedTest() {   
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Alert_Master__c alertMaster;
        Alert_Detail__c alertdetail;
        Health_Goal__c hhg;
        Checklist__c checklist  = new Checklist__c ();
        Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();   
        
        user u  = CH_Test_SampleData.createUserRecord(1,'System Administrator');
        
        System.runAs ( u ) {
            
            Test.startTest();       
            
            Account accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
            Case caseRecord = new case();
            if(accountRecord != null){
                caseRecord.accountid = accountRecord.id;
            }
            caseRecord.Origin = 'Phone';
            caseRecord.Status = 'New';
            Status_Stage_Master__c status  = CH_Test_SampleData.CreateStatus('test');
            caseRecord.FkStatus__c = status.id;
            Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('test');
            caseRecord.FkStage__c = stage.id;
            caseRecord.Type= 'Letters';
            caseRecord.Owner_Role__c = 'TestONCC';
            caseRecord.RecordTypeId = CaseRecordTypeInfo.get('Care Coordination').getRecordTypeId(); 
            insert caseRecord;
            
            alertMaster = CH_Test_SampleData.createAlertMatrix(' ', 'Checklist', 'New');       
    
            checklist = CH_Test_SampleData.createChecklist(1);
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);
            
            alertdetail = CH_Test_SampleData.createAlertDetial(alertMaster, checklist, checklistTasks,'TestONCC');         
    
            Health_Goal__c hgTemp = new Health_Goal__c();
            hgTemp.status__c ='Open';
            hgTemp.case__c = caseRecord.id;
            hgTemp.No_of_Completed_Tasks__c = 1;
            hgTemp.Total_No_of_Tasks__c = 3;
            insert hgTemp;
            
            Task temp = new Task();
            temp.Type = 'Email';
            temp.Subject='Interact with patient 1';
            temp.Status='Not Started';
            temp.WhatId = hgTemp.id;
            temp.ownerId = u.id;
            temp.IsHealthGoalTask__c = true;
            insert temp;  
            
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;
            
            CaseTeamMember ctm = new CaseTeamMember();
            ctm.ParentId = hgTemp.case__c;
            ctm.TeamRoleid = tmRole .id;
            ctm.memberid = u.id;       
            insert ctm;       
                    
            temp.Status ='Completed';
            update temp;
            
            temp.Status ='In Progress';
            update temp;
            
            //Check if no of completed task incremented
            Health_Goal__c healthGoal  = [SELECT No_of_Completed_Tasks__c FROM Health_Goal__c];
            System.assertnotEquals(healthGoal.No_of_Completed_Tasks__c, 0);
            
            Test.stopTest(); 
            
            }
            
        }
    }