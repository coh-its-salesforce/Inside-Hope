@isTest
private class PatientAccessCaseAccountControllerTest {
    testmethod static void testGetAccountData(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        //Test for PatientAccessCaseAccountController GetAccountData Method
        //Need to create an account and a case record that is associated with the account.
        
        //create account
        Id patientRecordTypeId = COHUtil.getRecordtype('Account', 'Patient (Screen Unification)');
        String varFirstName = 'testPatientFirstName';
        String varLastName = 'testPatientLastName';
        Date varBirthDate = Date.newInstance(1977, 07, 07);
        
        Account testAccount = new Account();
        testAccount.FirstName = varFirstName;
        testAccount.LastName = varLastName;
        testAccount.RecordTypeId = patientRecordTypeId;
        testAccount.Gender__pc	= 'Male';
        testAccount.Primary_Phone_Number__c = 'Mobile';
        testAccount.PersonMobilePhone = '123-123-1234';
        testAccount.COH_Account_PatientAccess_SSN__c = '123-12-1234';
        testAccount.PersonBirthdate = varBirthDate;
        insert testAccount;
        
        //create case record
        
        Id caseEnterpriseRecordTypeId = COHUtil.getRecordType('Case','Enterprise Access – New Patient');
        Case testCase = new Case();
        testCase.RecordTypeId = caseEnterpriseRecordTypeId;
        testCase.AccountId = testAccount.Id;
        testCase.Status = 'New';
        testCase.Origin = 'Inbound Call';
        insert testCase;
        
        Account recAccount = PatientAccessCaseAccountController.getAccountData(testCase.Id);
        system.assertEquals(testAccount.Id, recAccount.Id);
    }
}