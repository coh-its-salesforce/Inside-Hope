@isTest(seeAllData=false)
private class CH_ManuallyCreateCaseTeamMembersTest{

    static testMethod void ChecklistAlertType(){
        string userId;
        string roleId;
        Account accountRecord;
        Case caseRecord;
        User_Limits__c userLimits;
        Disease_Matrix__c diseaseMatrix;
        Contact physicianContact;
        Case_Stage_Team_Master__c CaseTeamMaster;
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
       
            
        System.runAs ( u ) {
            
            userLimits = CH_Test_SampleData.createUserLimits(u);

            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
            
            physicianContact = CH_Test_SampleData.createReferringPhysiciansContact(1, accountRecord);
            
            Alert_Master__c smatrix = CH_Test_SampleData.createAlertMatrix('Patient Intake', 'Checklist', 'Appointment Created');         
        
            Checklist__c checklist= new Checklist__c ();
            Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
            
            checklist = CH_Test_SampleData.createChecklist(1);
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);     
    
            Alert_Detail__c alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks, 'TestONCC');         
 
            caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
           
            PageReference pg = Page.CH_Case_Team_Inline_Page;
            Test.setCurrentPage(pg);
            
            pg.getparameters().put('id', caseRecord.id);
                  
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);  
            
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;   
            
            Test.startTest();
             
            CH_ManuallyCreateCaseTeamMembers createCaseTeamMembers = new CH_ManuallyCreateCaseTeamMembers(sc);
            
            createCaseTeamMembers.caseId = caseRecord.id;            
            
            createCaseTeamMembers.selectedrole = tmRole.name;
    
            roleId = tmRole.id;
                        
            list<User_Limits__c> userLimit =  [select id ,User__c,User__r.name from User_Limits__c where User__c =: u.id
                                                                and Max_Limit_reached__c = false limit 1 ];
            if(userLimit.size()>0){
                userId = userLimit[0].User__c;          
            }            
            
  
            createCaseTeamMembers.selecteduser = userId;            
      
            createCaseTeamMembers.AddCaseteammember();       
     
            list<CaseTeamMember> caseTeams= [select id,teamrole.name,memberid,parentid,member.name,TeamRoleId
                                            from CaseTeamMember where TeamRoleId =: roleId
                                            limit 1];                                          
                 
                      
            if(caseTeams.size()>0){
                createCaseTeamMembers.getcaseteamrecordid = caseTeams[0].id;            
            }
            
            system.assertNotEquals(caseTeams[0].id, null);
                     
            createCaseTeamMembers.removeMember();     

            Test.stopTest();
        }
    }
    
    static testMethod void ValidateSelectedRoleUserTest(){
        
        string userId;
        string roleId;
        Account accountRecord;
        Case caseRecord;
        User_Limits__c userLimits;
        
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
       
            
        System.runAs ( u ) {            
            userLimits = CH_Test_SampleData.createUserLimits(u);
            
            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1);
            
            caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
            
            PageReference pg = Page.CH_Case_Team_Inline_Page;
            
            Test.setCurrentPage(pg);
            
            pg.getparameters().put('id', caseRecord.id);
                  
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);
            
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;               
            
            Test.startTest();
             
            CH_ManuallyCreateCaseTeamMembers createCaseTeamMembers = new CH_ManuallyCreateCaseTeamMembers(sc);
            createCaseTeamMembers.caseId = caseRecord.id;
            
            createCaseTeamMembers.AddMember();
            createCaseTeamMembers.getCon();
            createCaseTeamMembers.getUsers();
            
            createCaseTeamMembers.selectedrole = tmRole.name;
    
            roleId = tmRole.id;
            
            
            createCaseTeamMembers.selectedrole = '--None--';
            createCaseTeamMembers.selecteduser = '--None--';
            
            createCaseTeamMembers.AddCaseteammember();
            
            list<CaseTeamMember> caseTeams= [select id,teamrole.name,memberid,parentid,member.name,TeamRoleId
                                            from CaseTeamMember where TeamRoleId =: roleId
                                            limit 1];
                                            
            system.assertEquals(caseTeams.size(), 0); 
  
            Test.stopTest();
            
            
        }
        
    }
    
     static testMethod void ChatterAlertType(){
        string userId;
        string roleId;
        Account accountRecord;
        Case caseRecord;
        User_Limits__c userLimits;        
        Contact physicianContact;
        Case_Stage_Team_Master__c CaseTeamMaster;
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
       
            
        System.runAs ( u ) {
            
            userLimits = CH_Test_SampleData.createUserLimits(u);

            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
                      
            caseRecord = CH_Test_SampleData.createCase(5,accountRecord);
            Status_Stage_Master__c CreateStatus = CH_Test_SampleData.CreateStatus ('Appointment Created'); 
             Status_Stage_Master__c CreateStage = CH_Test_SampleData.CreateStage('Patient Intake'); 
            caseRecord.fkStage__c=CreateStage.id;
            caseRecord.fkStatus__c=CreateStatus.id; 
            update caseRecord;
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;   
            
            physicianContact = CH_Test_SampleData.createReferringPhysiciansContact(1, accountRecord);
            
            Alert_Master__c smatrix = CH_Test_SampleData.createAlertMatrix('Patient Intake', 'Chatter', 'Appointment Created');         
        
            Checklist__c checklist= new Checklist__c ();
            Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
            
            checklist = CH_Test_SampleData.createChecklist(1);
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);     
    
            Alert_Detail__c alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks, 'ONCC');         
 
           // caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
           
            PageReference pg = Page.CH_Case_Team_Inline_Page;
            Test.setCurrentPage(pg);
            
            pg.getparameters().put('id', caseRecord.id);
                  
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);
            
          //  CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            //insert tmRole;       
            
            Test.startTest();
             
            CH_ManuallyCreateCaseTeamMembers createCaseTeamMembers = new CH_ManuallyCreateCaseTeamMembers(sc);
            createCaseTeamMembers.caseId = caseRecord.id;

            createCaseTeamMembers.selectedrole = tmRole.name;
    
            roleId = tmRole.id;            
                     
            
            list<User_Limits__c> userLimit =  [select id ,User__c,User__r.name from User_Limits__c where User__c =: u.id
                                                                and Max_Limit_reached__c = false limit 1 ];
            if(userLimit.size() > 0){
                userId = userLimit[0].User__c;          
            }            
  
            createCaseTeamMembers.selecteduser = userId;            
      
            createCaseTeamMembers.AddCaseteammember();       
     
            list<CaseTeamMember> caseTeams= [select id,teamrole.name,memberid,parentid,member.name,TeamRoleId
                                            from CaseTeamMember where TeamRoleId =: roleId
                                            limit 1];                                              
                      
            if(caseTeams.size()>0){
                createCaseTeamMembers.getcaseteamrecordid = caseTeams[0].id;            
            }
            
            system.assertNotEquals(caseTeams[0].id, null);                                  
                         
            createCaseTeamMembers.removeMember();     

            Test.stopTest();
        }
    }
    
     static testMethod void ChecklistlAlertType(){
        string userId;
        string roleId;
        Account accountRecord;
        Case caseRecord;
        User_Limits__c userLimits;  
        Case_Stage_Team_Master__c CaseTeamMaster;
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
       
            
        System.runAs ( u ) {
            
            userLimits = CH_Test_SampleData.createUserLimits(u);

            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1);            
            caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
            Status_Stage_Master__c CreateStatus = CH_Test_SampleData.CreateStatus ('Appointment Created'); 
             Status_Stage_Master__c CreateStage = CH_Test_SampleData.CreateStage('Patient Intake'); 
            caseRecord.fkStage__c=CreateStage.id;
            caseRecord.fkStatus__c=CreateStatus.id; 
            update caseRecord;
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;   
            
            Alert_Master__c smatrix = CH_Test_SampleData.createAlertMatrix('Patient Intake', 'Email', 'Appointment Created');         
        
            Checklist__c checklist= new Checklist__c ();
            Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
            
            checklist = CH_Test_SampleData.createChecklist(1);
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);     
    
            Alert_Detail__c alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks, 'TestONCC');         
          
           List<Folder> lstFolder = [Select Id From Folder Where Name like '%coh%' limit 1];
           List<emailtemplate > lstTemplate = [Select Id From emailtemplate Where Name like '%coh%' limit 1];     
                if(lstFolder.size() > 0)
                {
                 
               //caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
              //    emailtemplate e = new emailtemplate();
                 // e= lstTemplate[0]; 
                  //insert e;
               
           }
            PageReference pg = Page.CH_Case_Team_Inline_Page;
            Test.setCurrentPage(pg);
            
            pg.getparameters().put('id', caseRecord.id);
                  
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);     
            
            
            Test.startTest();
             
            CH_ManuallyCreateCaseTeamMembers createCaseTeamMembers = new CH_ManuallyCreateCaseTeamMembers(sc);
            createCaseTeamMembers.caseId = caseRecord.id;
            
            createCaseTeamMembers.selectedrole = tmRole.name;
    
            roleId = tmRole.id;            
                     
            
            list<User_Limits__c> userLimit =  [select id ,User__c,User__r.name from User_Limits__c where User__c =: u.id
                                                                and Max_Limit_reached__c = false limit 1 ];
            if(userLimit.size()>0){
                userId = userLimit[0].User__c;          
            }            
            
  
            createCaseTeamMembers.selecteduser = userId;            
      
            createCaseTeamMembers.AddCaseteammember();       
     
            list<CaseTeamMember> caseTeams= [select id,teamrole.name,memberid,parentid,member.name,TeamRoleId
                                            from CaseTeamMember where TeamRoleId =: roleId
                                            limit 1];                                          
                 
                      
            if(caseTeams.size()>0){
                createCaseTeamMembers.getcaseteamrecordid = caseTeams[0].id;            
            }
            
            system.assertNotEquals(caseTeams[0].id, null);                                  
          
            createCaseTeamMembers.removeMember();     

            Test.stopTest();
        }
    }
         static testMethod void EmailAlertType(){
        string userId;
        string roleId;
        Account accountRecord;
        Case caseRecord;
        User_Limits__c userLimits;  
        Case_Stage_Team_Master__c CaseTeamMaster;
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
       
            
        System.runAs ( u ) {
            
            userLimits = CH_Test_SampleData.createUserLimits(u);

            accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1);            
            caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
            Status_Stage_Master__c CreateStatus = CH_Test_SampleData.CreateStatus ('Appointment Created'); 
             Status_Stage_Master__c CreateStage = CH_Test_SampleData.CreateStage('Patient Intake'); 
            caseRecord.fkStage__c=CreateStage.id;
            caseRecord.fkStatus__c=CreateStatus.id; 
            update caseRecord;
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole;   
            
            Alert_Master__c smatrix = CH_Test_SampleData.createAlertMatrix('Patient Intake', 'Checklist', 'Appointment Created');         
        
            Checklist__c checklist= new Checklist__c ();
            Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
            
            checklist = CH_Test_SampleData.createChecklist(1);
            checklistTasks = CH_Test_SampleData.createChecklistTasks(checklist, 1);     
    
            Alert_Detail__c alertdetail = CH_Test_SampleData.createAlertDetial(smatrix, checklist, checklistTasks, 'TestONCC');         
          
           List<Folder> lstFolder = [Select Id From Folder Where Name like '%coh%' limit 1];
           List<emailtemplate > lstTemplate = [Select Id From emailtemplate Where Name like '%coh%' limit 1];     
                if(lstFolder.size() > 0)
                {
                 
               //caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
              //    emailtemplate e = new emailtemplate();
                 // e= lstTemplate[0]; 
                  //insert e;
               
           }
            PageReference pg = Page.CH_Case_Team_Inline_Page;
            Test.setCurrentPage(pg);
            
            pg.getparameters().put('id', caseRecord.id);
                  
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caseRecord);     
            
            
            Test.startTest();
             
            CH_ManuallyCreateCaseTeamMembers createCaseTeamMembers = new CH_ManuallyCreateCaseTeamMembers(sc);
            createCaseTeamMembers.caseId = caseRecord.id;
            
            createCaseTeamMembers.selectedrole = tmRole.name;
    
            roleId = tmRole.id;            
                     
            
            list<User_Limits__c> userLimit =  [select id ,User__c,User__r.name from User_Limits__c where User__c =: u.id
                                                                and Max_Limit_reached__c = false limit 1 ];
            if(userLimit.size()>0){
                userId = userLimit[0].User__c;          
            }            
            
  
            createCaseTeamMembers.selecteduser = userId;            
      
            createCaseTeamMembers.AddCaseteammember();       
     
            list<CaseTeamMember> caseTeams= [select id,teamrole.name,memberid,parentid,member.name,TeamRoleId
                                            from CaseTeamMember where TeamRoleId =: roleId
                                            limit 1];                                          
                 
                      
            if(caseTeams.size()>0){
                createCaseTeamMembers.getcaseteamrecordid = caseTeams[0].id;            
            }
            
            system.assertNotEquals(caseTeams[0].id, null);                                  
          
            createCaseTeamMembers.removeMember();     

            Test.stopTest();
        }
    }
}