/*
 * This test class verifies the processing of the Accounts for the NPS project.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2014
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class NPSProcessAccountTester {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyStatusCompletionUpdate = true;
    private static final Boolean mRunVerifyBulkStatusCompletionUpdate = true;
    private static final Boolean mRunVerifyCaseStatusAddUpdate = true;
    private static final Boolean mRunVerifyBulkCaseStatusAddUpdate = false;
	private static final Integer mPatientAdvocateTest = 0;
	private static final Integer mCaseStatusTest = 1;
        
    // Account constants

    private static final String ACCOUNT_PATIENT_STATUS_NEW = 'New';
    private static final String ACCOUNT_PATIENT_STATUS_IN_PROGRESS = 'In Progress';
    private static final String ACCOUNT_PATIENT_STATUS_COMPLETED = 'Completed';
    private static final String ACCOUNT_STATUS_SCHEDULED = 'Appointment Scheduled';
	private static final String ACCOUNT_STATUS_REASON = 'This is a test';	// To comply with a Validation Rule

    // Case constants
    
	private static final String CASE_ORIGIN = 'ACD';
	private static final String CASE_ACTION_TAKEN = 'EMAIL SENT';
	private static final String CASE_STATUS_NEW = 'New';
	private static final String CASE_STATUS_CLOSED = 'Closed';
	private static final String CASE_APPLICATION_TAKEN = 'APPLICATION TAKEN';
    private static final String CASE_WARM_HANDOFF_YES = 'Yes';

	// Configuration constants
    
    private static final String CALL_CENTER_APPLICATION_NAME = 'Call Center';
    private static final String DEATH_CERT_NEEDED = 'Death Certificate Needed';
    private static final String DEATH_CERT_NEEDED_VAL = 'Death Certificate Needed';
    private static final String STRING_TYPE = 'String';
    
    // Test constants
    
	private static final Id NPSAccountRecordTypeID = [select Id,name from RecordType where name = 'New Patient Services' and SObjectType = 'Account' limit 1].Id;
	private static final Id NPSCaseRecordTypeID = [select Id,name from RecordType where name = 'New Patient Services' and SObjectType = 'Case' limit 1].Id;
	private static final Id ContractsCaseRecordTypeID = [select Id,name from RecordType where name = 'Contracts' and SObjectType = 'Case' limit 1].Id;

    private static final String firstName1 = 'Maggie';
    private static final String lastName1 = 'Poole';
    private static final String firstName2 = 'Thomas';
    private static final String lastName2 = 'Magnum';
    private static final String firstName3 = 'Jonathan';
    private static final String lastName3 = 'Higgins';
    private static final String firstName4 = 'Rick';
    private static final String lastName4 = 'Wright';
    private static final String firstName5 = 'Buck';
    private static final String lastName5 = 'Green';
    private static final String firstName6 = 'Ice';
    private static final String lastName6 = 'Pick';
    
    private static final String COHMRN1 = '00000000000001';  
    private static final String COHMRN2 = '00000000000002';  
    private static final String COHMRN3 = '00000000000003';  
    
    private static final Integer MAX_RECORDS = 5;

    private static final Integer CASE_STATUS_UPDATE_COUNT = 1;
	private static Id mCaseObject1ID;
	private static Id mAccountObject1ID;
	private static Id mAccountObject2ID;
        
    /*
     * Verify the conversion from the Lead to Account and/or Case.
     * 
     */
    private static testMethod void verifyStatusCompletionUpdate() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        if (!mRunAllTests && !mRunVerifyStatusCompletionUpdate) {
            System.debug('Skipping verifyStatusCompletionUpdate()');
            return;
        }
        
        Test.startTest();
        setCOHAppConfiguration();
        createRecords(mPatientAdvocateTest);
        
        // Change the status to ACCOUNT_PATIENT_STATUS_COMPLETED.  This should change the 
        // status of the related Cases to CASE_STATUS_CLOSED.
        
        Account accountObj1 = [select Id, Patient_Status__c from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1];
        Id accountObjId1 = accountObj1.Id;
        accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_COMPLETED;
        accountObj1.Status_Reason__c = ACCOUNT_STATUS_REASON;
        update accountObj1;
        
        // Change the status to ACCOUNT_PATIENT_STATUS_IN_PROGRESS.  This should NOT change the 
        // status of the related Case.
        
        Account accountObj2 = [select Id, Patient_Status__c from Account where FirstName = :firstName2 and LastName = :lastName2 limit 1];
        Id accountObjId2 = accountObj2.Id;
        accountObj2.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj2.Status_Reason__c = ACCOUNT_STATUS_REASON;
        update accountObj2;
        
        // Change the status to ACCOUNT_PATIENT_STATUS_COMPLETED.  The status of the Case object
        // should NOT change because it has a Contracts record type.
        
        Account accountObj3 = [select Id, Patient_Status__c from Account where FirstName = :firstName6 and LastName = :lastName6 limit 1];
        Id accountObjId3 = accountObj3.Id;
        accountObj3.Patient_Status__c = ACCOUNT_PATIENT_STATUS_COMPLETED;
        accountObj3.Status_Reason__c = ACCOUNT_STATUS_REASON;
        update accountObj3;
        
        List<Case> casesList = [select Id, status from Case where AccountId = :accountObjId1];
        System.assertEquals(2, casesList.size());
        Case caseObj = casesList.get(0);
        System.assertEquals(CASE_STATUS_CLOSED, caseObj.status);
        caseObj = casesList.get(1);
        System.assertEquals(CASE_STATUS_CLOSED, caseObj.status);
        
        casesList = [select Id, status from Case where AccountId = :accountObjId2];
        System.assertEquals(1, casesList.size());
        caseObj = casesList.get(0);
        System.assertEquals(CASE_STATUS_NEW, caseObj.status);
        
        casesList = [select Id, status from Case where AccountId = :accountObjId3];
        System.assertEquals(1, casesList.size());
        caseObj = casesList.get(0);
        System.assertEquals(CASE_STATUS_NEW, caseObj.status);
        
        // Change the status to ACCOUNT_STATUS_SCHEDULED.  is should change the 
        // status of the related Cases to CASE_STATUS_CLOSED.
        
        accountObj2.Patient_Status__c = ACCOUNT_STATUS_SCHEDULED;
        update accountObj2;
        
        casesList = [select Id, status from Case where AccountId = :accountObjId2];
        System.assertEquals(1, casesList.size());
        caseObj = casesList.get(0);
        System.assertEquals(CASE_STATUS_CLOSED, caseObj.status);
        
        
        Test.stopTest();
    }

    /*
     * Verify that when the Case.Action_Taken__c field has been changed to CASE_APPLICATION_TAKEN,
     * the value of the Account.Patient_Status__c field should be changed to ACCOUNT_PATIENT_STATUS_NEW.
     * 
     */
    private static testMethod void verifyCaseStatusAddUpdate() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        if (!mRunAllTests && !mRunVerifyCaseStatusAddUpdate) {
            System.debug('Skipping verifyCaseStatusAddUpdate()');
            return;
        }
        
        Test.startTest();
        setCOHAppConfiguration();
        createRecords(mCaseStatusTest);
        
        // Verify inserted record
		
        List<Account> accountsList = [select Id, COH_MRN__c, Patient_Status__c from Account where Id = :mAccountObject2ID];
        if (!COHUtil.isValidList(accountsList)) {
            System.assert(false, 'Expected one Account record but retrieved none');
        } 
        Account accountObj = accountsList.get(0);
        System.assertEquals(COHMRN2, accountObj.COH_MRN__c);
        System.assertEquals(ACCOUNT_PATIENT_STATUS_NEW, accountObj.Patient_Status__c);

        // Verify updated record

        String caseSOQLquery = COHUtil.buildSelectAllSOQLStatement('Case');
        caseSOQLquery += ' where Id = \'' + mCaseObject1ID + '\'';
        List<Case> casesList = Database.query(caseSOQLquery);
        if (!COHUtil.isValidList(casesList)) {
            System.assert(false, 'Expected one Case record but retrieved none');
        } 
        
        // verify initial conditions
        System.assertEquals(CASE_STATUS_UPDATE_COUNT, casesList.size());
        Case caseObj = casesList.get(0);
        
        System.assertEquals(mAccountObject1ID, caseObj.AccountId);
        System.assertEquals(caseObj.Action_Taken__c, CASE_ACTION_TAKEN);
        System.assertEquals(COHMRN1, caseObj.COH_MRN__c);

        accountsList = [select Id, COH_MRN__c, Patient_Status__c from Account where Id = :mAccountObject1ID];
        if (!COHUtil.isValidList(accountsList)) {
            System.assert(false, 'Expected one Account record but retrieved none');
        } 
        accountObj = accountsList.get(0);
        System.assertEquals(COHMRN1, accountObj.COH_MRN__c);
        System.assertEquals(ACCOUNT_PATIENT_STATUS_IN_PROGRESS, accountObj.Patient_Status__c);
        
        // Update the status
        caseObj.Action_Taken__c = CASE_APPLICATION_TAKEN;
        Database.update(caseObj);
        
        casesList = [select Id, Action_Taken__c, AccountId from Case where Id = :mCaseObject1ID];
        if (!COHUtil.isValidList(casesList)) {
            System.assert(false, 'Expected one Case record but retrieved none');
        } 
        
        // verify update
        System.assertEquals(CASE_STATUS_UPDATE_COUNT, casesList.size());

        caseObj = casesList.get(0);
        System.assertEquals(caseObj.Action_Taken__c, CASE_APPLICATION_TAKEN);

		Id accountID = caseObj.AccountId;        
        System.assertEquals(mAccountObject1ID, accountID);
        
        accountsList = [select Id, Patient_Status__c from Account where Id = :mAccountObject1ID];
        if (!COHUtil.isValidList(accountsList)) {
            System.assert(false, 'Expected one Account record but retrieved none');
        } 
        
        accountObj = accountsList.get(0);
        System.assertEquals(ACCOUNT_PATIENT_STATUS_NEW, accountObj.Patient_Status__c);
        
        Test.stopTest();
        
    }

    /*
     * Bulk testing to verify that when the Case.Action_Taken__c field has been changed to CASE_APPLICATION_TAKEN,
     * the value of the Account.Patient_Status__c field should be changed to ACCOUNT_PATIENT_STATUS_NEW.
     * 
     */
/*    private static testMethod void verifyBulkCaseStatusAddUpdate() {
        if (!mRunAllTests && !mRunVerifyBulkCaseStatusAddUpdate) {
            System.debug('Skipping verifyBulkCaseStatusAddUpdate()');
            return;
        }
        
        Test.startTest();
        setCOHAppConfiguration();
        createBulkRecords();
        
        List<Account> accountsList = [select Id from Account where Patient_Status__c = :ACCOUNT_PATIENT_STATUS_NEW];
		System.assertEquals(MAX_RECORDS, accountsList.size());
        
        Test.stopTest();
    }
    */
    /*
     * Create a single Patient Advocate Record for testing.
     */
    private static void createPASRecord() {
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = NPSAccountRecordTypeID;
        accountObj1.FirstName = firstName1;
        accountObj1.LastName = lastName1;
       	accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
        accountObj1.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj1.COH_MRN__c = COHMRN1;        
        
        Database.insert(accountObj1);
        Id accountID1 = accountObj1.Id;

        Contact contactObj1 = [select Id, AccountId from Contact where AccountId = :accountID1 limit 1];
        Id tempAccountID1 = contactObj1.AccountId;
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = NPSCaseRecordTypeID;
 		caseObj1.Origin = CASE_ORIGIN;       
		caseObj1.Action_Taken__c = CASE_APPLICATION_TAKEN;		        
        caseObj1.Status = CASE_STATUS_NEW;
        caseObj1.Caller_First_Name__c = firstName3;
        caseObj1.Caller_Last_Name__c = lastName3;
		caseObj1.AccountId = accountID1;
        caseObj1.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj1.ContactId = contactObj1.Id;
        
        Database.insert(caseObj1);        
    }
    /*
     * Create the Account and Case objects for testing.
     * 
     * @param	testType		Indicates if the test is for Patient Advocate Records
     * 							or for Case Status updates
     * 
     */
    private static void createRecords(Integer testType) {
        
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = NPSAccountRecordTypeID;
        accountObj1.FirstName = firstName1;
        accountObj1.LastName = lastName1;
        if (testType == mPatientAdvocateTest) {
        	accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
        } else if (testType == mCaseStatusTest) {
			accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        }
        accountObj1.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj1.COH_MRN__c = COHMRN1;
        
        Account accountObj2 = new Account();
        accountObj2.RecordTypeId = NPSAccountRecordTypeID;
        accountObj2.FirstName = firstName2;
        accountObj2.LastName = lastName2;
        accountObj2.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
        accountObj2.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj2.COH_MRN__c = COHMRN2;

        Account accountObj3 = new Account();
        accountObj3.RecordTypeId = NPSAccountRecordTypeID;
        accountObj3.FirstName = firstName6;
        accountObj3.LastName = lastName6;
        accountObj3.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj3.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj3.COH_MRN__c = COHMRN3;

        List<Account> accountsToInsert = new List<Account>();
        accountsToInsert.add(accountObj1);
        accountsToInsert.add(accountObj2);
        accountsToInsert.add(accountObj3);
        insert accountsToInsert;
        
        Id accountID1 = [select Id from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1].Id;
        Id accountID2 = [select Id from Account where FirstName = :firstName2 and LastName = :lastName2 limit 1].Id;
        Id accountID3 = [select Id from Account where FirstName = :firstName6 and LastName = :lastName6 limit 1].Id;

        // Contact ID is required because of a validation rule.  The rule checks for 
        // Contact.Account.COH_MRN__c.  The validation rule checks for the MRN in the 
        // parent object because the COH_MRN__c field will not be copied until after
        // the Case is saved. 
        Contact contactObj1 = [select Id, AccountId from Contact where AccountId = :accountID1 limit 1];
        Id tempAccountID1 = contactObj1.AccountId;
        Contact contactObj2 = [select Id, AccountId from Contact where AccountId = :accountID2 limit 1];
        Id tempAccountID2 = contactObj2.AccountId;
        Contact contactObj3 = [select Id, AccountId from Contact where AccountId = :accountID3 limit 1];
        Id tempAccountID3 = contactObj3.AccountId;
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = NPSCaseRecordTypeID;
 		caseObj1.Origin = CASE_ORIGIN;       
		caseObj1.Action_Taken__c = CASE_ACTION_TAKEN;		        
        caseObj1.Status = CASE_STATUS_NEW;
        caseObj1.Caller_First_Name__c = firstName3;
        caseObj1.Caller_Last_Name__c = lastName3;
		caseObj1.AccountId = accountID1;
        caseObj1.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj1.ContactId = contactObj1.Id;
        
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = NPSCaseRecordTypeID;
 		caseObj2.Origin = CASE_ORIGIN;       
       	caseObj2.Action_Taken__c = CASE_ACTION_TAKEN;
        caseObj2.Status = CASE_STATUS_NEW;
        caseObj2.Caller_First_Name__c = firstName4;
        caseObj2.Caller_Last_Name__c = lastName4;
		caseObj2.AccountId = accountID1;
        caseObj2.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj2.ContactId = contactObj1.Id;
        
        Case caseObj3 = new Case();
        caseObj3.RecordTypeId = NPSCaseRecordTypeID;
 		caseObj3.Origin = CASE_ORIGIN;       
        if (testType == mPatientAdvocateTest) {
        	caseObj3.Action_Taken__c = CASE_ACTION_TAKEN;
        } else if (testType == mCaseStatusTest) {
			caseObj3.Action_Taken__c = CASE_APPLICATION_TAKEN;
        }
        caseObj3.Status = CASE_STATUS_NEW;
        caseObj3.Caller_First_Name__c = firstName5;
        caseObj3.Caller_Last_Name__c = lastName5;
		caseObj3.AccountId = accountID2;
        caseObj3.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj3.ContactId = contactObj2.Id;
        
        Case caseObj4 = new Case();
        caseObj4.RecordTypeId = ContractsCaseRecordTypeID;		
 		caseObj4.Origin = CASE_ORIGIN;       
		caseObj4.Action_Taken__c = CASE_ACTION_TAKEN;		        
        caseObj4.Status = CASE_STATUS_NEW;
        caseObj4.Caller_First_Name__c = firstName6;
        caseObj4.Caller_Last_Name__c = lastName6;
		caseObj4.AccountId = accountID3;
        caseObj4.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj4.ContactId = contactObj3.Id;
        
        List<Case> casesToInsert = new List<Case>();
        casesToInsert.add(caseObj1);
        casesToInsert.add(caseObj2);
        casesToInsert.add(caseObj3);
        casesToInsert.add(caseObj4);
        
        insert casesToInsert;
        
        mCaseObject1ID = [select Id from Case where Caller_First_Name__c = :firstName3 and Caller_Last_Name__c = :lastName3 limit 1].Id;
        mAccountObject1ID = accountID1;
        mAccountObject2ID = accountID2;
    }

    /*
     * Create the Account and Case objects for bulk testing.
     * 
     */
    private static void createBulkRecords() {
 	
        List<Account>accountList = new List<Account>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Account accountObj = new Account();
            accountObj.RecordTypeId = NPSAccountRecordTypeID;
            accountObj.FirstName = getStringWithDigits(firstName1, i);
            accountObj.LastName = getStringWithDigits(lastName1, i);
            accountObj.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
	        accountObj.Status_Reason__c = ACCOUNT_STATUS_REASON;
            accountList.add(accountObj);
        }
        
        insert accountList;
        
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
			Account accountObj = accountList[i];
            Case caseObj = new Case();
            caseObj.RecordTypeId = NPSCaseRecordTypeID;
            caseObj.Origin = CASE_ORIGIN;       
            caseObj.Action_Taken__c = CASE_ACTION_TAKEN;		        
            caseObj.Status = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
            caseObj.Caller_First_Name__c = getStringWithDigits(firstName3, i);
            caseObj.Caller_Last_Name__c = getStringWithDigits(lastName3, i);
            caseObj.AccountId = accountObj.Id;
	        caseObj.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
            caseList.add(caseObj);
        }
        insert caseList;
        
    }

    /*
     *  Creates the configuration objects for the COH Case test environment.
     */
    private static void setCOHAppConfiguration() {
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = CALL_CENTER_APPLICATION_NAME;
		configObj0.Name = DEATH_CERT_NEEDED;
        configObj0.Value__c = DEATH_CERT_NEEDED_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;
        
		Database.insert(configObj0);
    }

    
    // used to create a random string (e.g. "Jim0001")
    private static String getStringWithDigits(String baseString, Integer num) {
        String suffix = null;
        if (num < 10) {
            suffix = '000' + num;
        } else if (num < 100) {
            suffix = '00' + num;
        } else if (num < 1000) {
            suffix = '0' + num;
        } else {
            suffix = null;
        }
        return baseString + suffix;
    }
}