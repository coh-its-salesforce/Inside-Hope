@isTest(seeAllData=false)
Public Class CH_CreateCaseTeamTest {
    static testMethod void createCaseTeamFirstBestUser() {
        //CREATE PHYSICIAN
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contact;
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Contact contact = new Contact();
        contact.FirstName='Doctor';
        contact.LastName='lastName';
        contact.RecordTypeId = conRecordTypeInfo.get('Contacts').getRecordTypeId();
        insert contact;
        system.assertNotEquals(contact.id, null);
        
        //test
        Contact contact2 = new Contact();
        contact2.FirstName='Doctor';
        contact2.LastName='lastName';
        contact2.RecordTypeId = conRecordTypeInfo.get('Contacts').getRecordTypeId();
        insert contact2;
        system.assertNotEquals(contact2.id, null);
        
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo2 = cfrSchema.getRecordTypeInfosByName();
        //GET USERS  
        List<user> careTeamUsersList = CH_Test_SampleData.createUserRecordsInBulk(1,8,'system administrator');
        User user1 = careTeamUsersList[0];
        User user2 = careTeamUsersList[1];
        User user3 = careTeamUsersList[2];
        User user4 = careTeamUsersList[3];
        User defaultUser1 = careTeamUsersList[4];
        User defaultUser2 = careTeamUsersList[5];
        User defaultUser3 = careTeamUsersList[6];
        User defaultUser4 = careTeamUsersList[7];
        CaseTeamRole tmRole4 = new CaseTeamRole();
        //CREATE CASE TEAM ROLE
        system.runAs(user2) {
            CaseTeamRole tmRole1 = new CaseTeamRole();
            tmRole1.Name = 'Test ONCC';
            tmRole1.PreferencesVisibleInCSP = false;
            tmRole1.ACCESSLEVEL ='Edit';
            insert tmRole1;
            system.assertNotEquals(tmRole1.id, null);
            CaseTeamRole tmRole2 = new CaseTeamRole();
            tmRole2.Name = 'Test Registered Nurse';
            tmRole2.PreferencesVisibleInCSP = false;
            tmRole2.ACCESSLEVEL ='Edit';
            insert tmRole2;
            system.assertNotEquals(tmRole2.id, null);
            CaseTeamRole tmRole3 = new CaseTeamRole();
            tmRole3.Name = 'Test Admit RN';
            tmRole3.PreferencesVisibleInCSP = false;
            tmRole3.ACCESSLEVEL ='Edit';
            insert tmRole3;
            system.assertNotEquals(tmRole3.id, null);
            tmRole4.Name = 'Existing Manager';
            tmRole4.PreferencesVisibleInCSP = false;
            tmRole4.ACCESSLEVEL ='Edit';
            insert tmRole4;
            system.assertNotEquals(tmRole4.id, null);
        }
        // GET AND UPDATE USER LIMITS
        User_Limits__c UL1= CH_Test_SampleData.createUserLimits(user1);
        User_Limits__c UL2= CH_Test_SampleData.createUserLimits(user2);
        User_Limits__c UL3= CH_Test_SampleData.createUserLimits(user3);
        UL3.Case_Count_Limit__c=20;
        update UL3;
        User_Limits__c UL4= CH_Test_SampleData.createUserLimits(user4);
        //GET ROLE MASTER       
        Role_Master__c roleMaster = new Role_Master__c();
        roleMaster.name ='Test ONCC';
        roleMaster.Disease_Group_Assignment__c = false;
        roleMaster.FkManager__c = defaultUser1.id;
        insert roleMaster;
        system.assertNotEquals(roleMaster.id, null);
        
        Role_Master__c roleMaster2 = new Role_Master__c();
        roleMaster2.name ='Test Registered Nurse';
        roleMaster2.Disease_Group_Assignment__c = true;
        roleMaster2.FkManager__c = defaultUser2.id;
        insert roleMaster2;
        system.assertNotEquals(roleMaster2.id, null);
        
        Role_Master__c roleMaster3 = new Role_Master__c();
        roleMaster3.name ='Test Admit RN';
        roleMaster3.Disease_Group_Assignment__c = true;
        roleMaster3.FkManager__c = defaultUser3.id;
        insert roleMaster3;
        system.assertNotEquals(roleMaster3.id, null);
        
        Role_Master__c roleMaster4 = new Role_Master__c();
        roleMaster4.name ='Existing Manager';
        roleMaster4.Disease_Group_Assignment__c = false;
        roleMaster4.FkManager__c = defaultUser4.id;
        insert roleMaster4;
        system.assertNotEquals(roleMaster4.id, null);
        
        // Create Disease Master Record   
        Disease_Master__c diseaseMaster = new Disease_Master__c();
        diseaseMaster.Disease_Group_Name__c ='Transplant Group';
        diseaseMaster.Name = 'Diabetes';
        insert diseaseMaster;
        system.assertNotEquals(diseaseMaster.id, null);
        
        // Create Stage And Status     
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('First Appointment');
        Status_Stage_Master__c status = CH_Test_SampleData.CreateStatus('New');
        //GET AND UPDATE CASE STAGE 
        Case_Stage_Team_Master__c sctm= CH_Test_SampleData.createStageCaseTeamMatrix('Test ONCC;Test Registered Nurse;Test Admit RN;Financial Counselor,Interpreter',roleMaster,stage.id,status.id);
        Case_Stage_Team_Master__c sctm2= CH_Test_SampleData.createStageCaseTeamMatrix('Test ONCC;Test Registered Nurse;Test Admit RN;Financial Counselor,Interpreter',roleMaster,stage.id);
        
        //GET DISEASE
        Disease_Matrix__c Dm1= CH_Test_SampleData.createDiseaseMaster(user1,contact,roleMaster,diseaseMaster);
        Disease_Matrix__c Dm2= CH_Test_SampleData.createDiseaseMaster(user2,Contact,roleMaster2,diseaseMaster);
        Disease_Matrix__c Dm3= CH_Test_SampleData.createDiseaseMaster(user3,Contact,roleMaster3,diseaseMaster);
        //GET AND UPDATE ACCOUNT  
        Account testAccount=CH_Test_SampleData.createNewPatientAccounts(1);
        testAccount.CC_AllScripts_Disease__c = 'Diabetes';
        testAccount.CC_AllScripts_Physician__c=contact.id;
        update testAccount;
        Account testAccount2=CH_Test_SampleData.createNewPatientAccounts(2);
        testAccount2.CC_AllScripts_Disease__c= 'Diabetes';
        testAccount2.CC_AllScripts_Physician__c=contact2.id;
        update testAccount2;
        //GET AND UPDATE CASE
        case testCase = CH_Test_SampleData.createCase(1,testAccount);
        
        testCase.CC_AllScripts_Physician__c=contact2.id;
        testCase.CC_AllScripts_Disease__c= 'Diabetes';
        update testCase;
        //Create existing team member
        caseTeamMember ctm = new caseTeamMember();
        ctm.memberid = user4.id;
        ctm.TeamRoleId = tmRole4.id;
        ctm.parentId = TestCase.Id;
        insert CTM;
         system.assertNotEquals(ctm.id, null);
        //CREATE EXISTING CHATTER FOLLOWER
        EntitySubscription es = new EntitySubscription(ParentId = Ctm.ParentID,SubscriberId = Ctm.MemberId);
        insert es;
         system.assertNotEquals(es.id, null);
         
        //UPDATE CASE 1   
        testCase.FkStage__c = stage.id;
        update testCase;
        
        case testCase2= CH_Test_SampleData.createCase(2,testAccount2);
        
        //UPDATE CASE 2 
        testCase2.CC_AllScripts_Physician__c=contact2.id;
        testCase2.CC_Disease__c= 'Diabetes';
        testCase2.Type='Consults';
        //testCase2.Interpreter_Needed__c=true;
        testCase2.FkStage__c = stage.id;
        testCase2.FkStatus__c = status.id;
        Update testCase2;
        
        testCase2.Inactive__c= true;
        
        update testCase2;
        
        try {
            system.runas(user1) {
                testCase2.Inactive__c= false;
                testCase2.Financial_Status__c='New';
                testCase2.Clinical_Status__c='New';
                update testCase2;
            }
        }
        catch(dmlexception e) {
        }
        try {
            system.runas(User2) {
                testCase2.Inactive__c= false;
                testCase2.Financial_Status__c='New';
                testCase2.Clinical_Status__c='New';
                update testCase2;
            }
            delete ul1;
            delete Dm2;
        }
        catch(dmlException e) {
        }
    }
}