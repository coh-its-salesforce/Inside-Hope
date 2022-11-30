@isTest
private class PatientAccessEpicAccountControllerTest {
    testmethod static void testGetEpicAccountData(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Id patientRecordTypeId = COHUtil.getRecordtype('Account', 'Patient (Screen Unification)');
        system.debug('RecordTypeId for Patient (Screen Unification) | ' + patientRecordTypeId);
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
        
        PatientAccessEpicAccountController.getEpicAccountData(testAccount.Id);
        testAccount.COH_MRN__c = 'testCOHMRN';
        update testAccount;
        Epic_Account_Data__c recEpicAccountData = PatientAccessEpicAccountController.getEpicAccountData(testAccount.Id);
        System.assertEquals(recEpicAccountData.AccountMRN__c, recEpicAccountData.Account_MRN_Formula__c);
    }
    
    testmethod static void testGetPurchaserPlan(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        //Setup Values for Payer
        String strAccountName = 'TestPayerName';
        String strType = 'Payer';
        String strAccountSourceSystemId = 'testPayerNameId';
        String strBillingStreet = '123 Test Street';
        String strBillingCity = 'Duarte';
        String strBillingState = 'California';
        String strBillingPostalCode = '91010';
        String strBillingCountry = 'United States of America';
        Id payerRecordTypeId = COHUtil.getRecordtype('Account', 'Payer');
        
        //Setup Values for PurchaserPlan
		String strPlanType = 'HMO';
        String strPurchaserPlanName = strAccountName + ' ' + strPlanType;
        String strPlanStatus = 'Active';
        String strPayerSourceSystemIdId = strAccountSourceSystemId;
        String strPurchaserPlanSourceSystemIdentifier = 'testPurchaserPlanId';
        Id strFalseId = '50079000001nsEGAAY';
        
        //To create a purchaser plan, need to create a Payer and Patient Screen Unification Account record first.
        //Create Payer
        Account recPayer = new Account();
        recPayer.Name = strAccountName;
        recPayer.Type = strType;
        recPayer.HealthCloudGA__SourceSystemId__c 	= strAccountSourceSystemId;
        recPayer.BillingStreet 						= strBillingStreet;
        recPayer.BillingCity 						= strBillingCity;
        recPayer.BillingState 						= strBillingState;
        recPayer.BillingPostalCode 					= strBillingPostalCode;
        recPayer.BillingCountry 					= strBillingCountry;
        recPayer.RecordTypeId 						= payerRecordTypeId;
        insert recPayer;
        
        //Create PurchaserPlan
        PurchaserPlan recPurchaserPlan = new PurchaserPlan();
        recPurchaserPlan.Payor_Number__c = strPayerSourceSystemIdId;
        recPurchaserPlan.PlanStatus	= strPlanStatus;
        recPurchaserPlan.SourceSystemIdentifier	= strPurchaserPlanSourceSystemIdentifier;
        recPurchaserPlan.PlanType = strPlanType;
        recPurchaserPlan.Name = strPurchaserPlanName;
        insert recPurchaserPlan;
        
        String strPurchaserPlanNamefromMethod = PatientAccessEpicAccountController.getPurchaserPlanName(recPurchaserPlan.Id);
        system.assertEquals(strPurchaserPlanName, strPurchaserPlanNamefromMethod);
    }
}