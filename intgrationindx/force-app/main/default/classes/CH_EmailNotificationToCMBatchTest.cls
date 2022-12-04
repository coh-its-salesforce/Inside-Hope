@isTest(seeAllData=false)
public class CH_EmailNotificationToCMBatchTest{
    
    static testmethod void testSendNotification(){
        CaseTeamRole tmRole = new CaseTeamRole();
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
        
        Account accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
        
        Case caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
        
        Status_Stage_Master__c statusDenied  = CH_Test_SampleData.CreateStatus('Appoinment Created');
                
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('Patient Intake');
        
        Checklist__c checklistRecord = CH_Test_SampleData.createChecklist(1);   
      
        System.runAs(u) {
            Folder tempFolder = [select id,name from folder where name = 'COH Templates' limit 1];
            EmailTemplate emailTemplate = New EmailTemplate(Name = 'testTemplate', Body = 'Just to test the batch functionality', DeveloperName= 'testTemplate', FolderId= tempFolder.id, IsActive=True, Subject= 'Email Notification batch', TemplateType= 'Text') ;
            Insert emailTemplate;
            
            tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole; 
        }
        
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = caseRecord.id;
        ctm.TeamRoleid = tmRole .id;
        ctm.memberid = u.id;
               
        insert ctm;
        
        CaseTeamMemberNotification__c notifcation = new CaseTeamMemberNotification__c();        
        notifcation.Templates__c = 'testTemplate';
        notifcation.OwnerEmail__c ='abc@abc.com';
        notifcation.Owner_role__c = 'TestONCC';
        notifcation.Role__c = 'Interpreter';
        notifcation.Assign_to__c = u.id;
        
        insert notifcation; 
        
        Test.startTest();
        
        caseRecord.FkStage__c = stage.id;
        
        update caseRecord;
        
        CH_EmailNotificationToCaseMemberBatch emailNotiifcation = new CH_EmailNotificationToCaseMemberBatch();
        database.executebatch(emailNotiifcation,90);
        Test.stopTest();
        
        Integer notiifcationCount = [SELECT COUNT() FROM CaseTeamMemberNotification__c];
        System.assertEquals(notiifcationCount, 0);       
        
    }
    
    // this test is for code coverage reasons
    // Raymond Tam
    static testmethod void testSendNotification2(){
        CaseTeamRole tmRole = new CaseTeamRole();
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
        
        Account accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
        
        Case caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
        
        Status_Stage_Master__c statusDenied  = CH_Test_SampleData.CreateStatus('Appoinment Created');
                
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('Patient Intake');
        
        Checklist__c checklistRecord = CH_Test_SampleData.createChecklist(1);   
      
        System.runAs(u) {
            Folder tempFolder = [select id,name from folder where name = 'COH Templates' limit 1];
            EmailTemplate emailTemplate = New EmailTemplate(Name = 'testTemplate', Body = 'Just to test the batch functionality', DeveloperName= 'testTemplate', FolderId= tempFolder.id, IsActive=True, Subject= 'Email Notification batch', TemplateType= 'Text') ;
            Insert emailTemplate;
            
            tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole; 
        }
        
        CaseTeamMember ctm = new CaseTeamMember();
        ctm.ParentId = caseRecord.id;
        ctm.TeamRoleid = tmRole .id;
        ctm.memberid = u.id;
        insert ctm;
        
        CaseTeamMemberNotification__c notifcation = new CaseTeamMemberNotification__c();        
        notifcation.Templates__c = 'testTemplate';
        notifcation.OwnerEmail__c ='abc@fdsafdsdee.com';
        notifcation.Owner_role__c = 'TestONCC';
        notifcation.Role__c = 'Interpreter';
        notifcation.Assign_to__c = u.id;
        notifcation.Email_Body__c = 'Dummy message';
		notifcation.Manager_Notification__c = true;          
        
        insert notifcation; 
        
        Test.startTest();
        
        caseRecord.FkStage__c = stage.id;
        
        update caseRecord;
        
        CH_EmailNotificationToCaseMemberBatch emailNotiifcation = new CH_EmailNotificationToCaseMemberBatch();
        database.executebatch(emailNotiifcation,90);
        Test.stopTest();
        
        Integer notiifcationCount = [SELECT COUNT() FROM CaseTeamMemberNotification__c];
        System.assertEquals(notiifcationCount, 0);       
        
    }
        
}