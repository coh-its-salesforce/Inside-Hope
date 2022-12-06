@isTest
private class CH_TimelineControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<user> careTeamUsersList = CH_Test_SampleData.createUserRecordsInBulk(1,8,'system administrator');
        User defaultuser = careTeamUsersList[0];
        //GET ROLE MASTER       
        Role_Master__c roleMaster = new Role_Master__c();
        roleMaster.name ='Test ONCC';
        roleMaster.Disease_Group_Assignment__c = false;
        roleMaster.FkManager__c = defaultuser.id;
        insert roleMaster;
        
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStage('First Appointment');
        Status_Stage_Master__c status = CH_Test_SampleData.CreateStatus('New');        
        Case_Stage_Team_Master__c sctm= CH_Test_SampleData.createStageCaseTeamMatrix('Test ONCC;Test Registered Nurse;Test Admit RN;Financial Counselor,Interpreter',roleMaster,stage.id,status.id);
        Account accountRecord = CH_Test_SampleData.createNewPatientAccounts(1);
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Case cse = new Case();              
            cse.accountid = accountRecord.id;   
            cse.Origin = 'Phone';
            cse.Status = 'New';
            cse.Type= 'Letters'; 
            cse.CC_Appointment_Date__c = Date.today().adddays(2);
            cse.Status = 'New';
            cse.Inactive__c = false;
            cse.RecordTypeId = conRecordTypeInfo.get('Care Coordination').getRecordTypeId();// 'Care Coordination';  
        insert cse;
        case_timelines__c csTmln = CH_Test_SampleData.createCasetime(stage.Name,cse);
        
         test.StartTest();
        system.currentPageReference().getParameters().put('Id', cse.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(cse);
       CH_TimelineController tmc = new CH_TimelineController(sc);
        test.StopTest();
    }
}