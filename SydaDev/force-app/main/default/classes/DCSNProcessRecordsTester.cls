/*
 * This test class verifies the processing of the COH customizations for Docusign.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class DCSNProcessRecordsTester {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyStatusUpdates = true;
    private static final Boolean mRunVerifyNegativeStatusUpdates = true;
    private static final Boolean mRunVerifyBulkStatusUpdates = false;
    private static final Boolean mRunVerifyNegativeBulkStatusUpdates = false;
    
    private static final Id NPSAccountRecordTypeID = [select Id,name from RecordType where name = 'New Patient Services' and SObjectType = 'Account' limit 1].Id;
    private static final Id NPSCaseRecordTypeID = [select Id,name from RecordType where name = 'New Patient Services' and SObjectType = 'Case' limit 1].Id;

    private static final String ACCOUNT_PATIENT_STATUS_IN_PROGRESS = 'In Progress';

    private static final String ENVELOPE_STATUS_SENT = 'Sent';
    private static final String ENVELOPE_STATUS_DELIVERED = 'Delivered';
    private static final String ENVELOPE_STATUS_COMPLETED = 'Completed';
    
    private static final String CASE_ORIGIN = 'ACD';
    private static final String CASE_ACTION_TAKEN = 'EMAIL SENT';
    private static final String CASE_STATUS_NEW = 'New';
    
    private static final String firstName1 = 'Thomas';
    private static final String lastName1 = 'Magnum';
    private static final String firstName2 = 'Buck';
    private static final String lastName2 = 'Green';
    
	private static final Integer MAX_CASES = 201;
        
	/*
	 * Verify the envelope status is updated correctly for a single Account.
	 * If the docuSignObj1.dsfs__Envelope_Status__c gets a new value, the new
	 * value is copied to the Case.PHI_StatusNew__c field.
	 * 
	 */
    private static testMethod void mRunVerifyStatusUpdates() {
        if (!mRunAllTests && !mRunVerifyStatusUpdates) {
            System.debug('Skipping verifyStatusUpdates()');
            return;
        }
        
        Test.startTest();
        createSingleRecord();
        
        Account accountObj = [select Id, Patient_Status__c from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1];
        Id accountObjId = accountObj.Id;
        
        // verify the initial status
        
        List<Case> casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(1, casesList.size());
        Case caseObj = casesList.get(0);
        Id caseObjID = caseObj.Id;
        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
        
        // update the Docusign record
        
        List<dsfs__DocuSign_Status__c> docuSignObjList = [select Id, dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Case__c = :caseObjID];
        System.assertEquals(1, docuSignObjList.size());
        dsfs__DocuSign_Status__c docuSignObj1 = docuSignObjList.get(0);
        System.assertEquals(ENVELOPE_STATUS_COMPLETED, docuSignObj1.dsfs__Envelope_Status__c);
        docuSignObj1.dsfs__Envelope_Status__c = ENVELOPE_STATUS_DELIVERED;
        update docuSignObj1;
        
        // verify the status change
        
        casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(1, casesList.size());
        caseObj = casesList.get(0);
        caseObjID = caseObj.Id;
        System.assertEquals(ENVELOPE_STATUS_DELIVERED, caseObj.PHI_StatusNew__c);
        
        Test.stopTest();
    }

    
	/*
	 * Verify the envelope status is updated correctly for a single Account.
	 * If the docuSignObj1.dsfs__Envelope_Status__c keeps its old value, the 
	 * value in the Case.PHI_StatusNew__c field is NOT changed
	 * 
	 */
    private static testMethod void mRunVerifyNegativeStatusUpdates() {
        if (!mRunAllTests && !mRunVerifyNegativeStatusUpdates) {
            System.debug('Skipping verifyNegativeStatusUpdates()');
            return;
        }
        
        Test.startTest();
        createSingleRecord();
        
        Account accountObj = [select Id, Patient_Status__c from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1];
        Id accountObjId = accountObj.Id;
        
        // verify the initial status
        
        List<Case> casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(1, casesList.size());
        Case caseObj = casesList.get(0);
        Id caseObjID = caseObj.Id;
        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
        
        // update the Docusign record
        
        List<dsfs__DocuSign_Status__c> docuSignObjList = [select Id, dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Case__c = :caseObjID];
        System.assertEquals(1, docuSignObjList.size());
        dsfs__DocuSign_Status__c docuSignObj1 = docuSignObjList.get(0);
        System.assertEquals(ENVELOPE_STATUS_COMPLETED, docuSignObj1.dsfs__Envelope_Status__c);
        docuSignObj1.dsfs__Envelope_Status__c = ENVELOPE_STATUS_COMPLETED;
        update docuSignObj1;
        
        // verify that the status did NOT change
        
        casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(1, casesList.size());
        caseObj = casesList.get(0);
        caseObjID = caseObj.Id;
        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
        
        Test.stopTest();
    }

	/*
	 * Verify the envelope status is updated correctly for a single Account but
	 * for many cases for bulk testing.  If the docuSignObj1.dsfs__Envelope_Status__c 
	 * gets a new value, the new value is copied to the Case.PHI_StatusNew__c field.
	 * 
	 */
    
    private static testMethod void mRunVerifyBulkStatusUpdates() {
        if (!mRunAllTests && !mRunVerifyBulkStatusUpdates) {
            System.debug('Skipping verifyBulkStatusUpdates()');
            return;
        }
        
        Test.startTest();

        createBulkRecords();

        Account accountObj = [select Id, Patient_Status__c from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1];
        Id accountObjId = accountObj.Id;
        
        // verify the initial status
        
        List<Case> casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(MAX_CASES, casesList.size());
        List<Id> caseIDList = new List<Id>();
        for (Case caseObj : casesList) {
	        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
            caseIDList.add(caseObj.Id);
        }

        // update the Docusign records
        
        List<dsfs__DocuSign_Status__c> docuSignObjList = [select Id, dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Case__c in :caseIDList];
        System.assertEquals(MAX_CASES, docuSignObjList.size());
        for (dsfs__DocuSign_Status__c docuSignObj : docuSignObjList) {
            System.assertEquals(ENVELOPE_STATUS_COMPLETED, docuSignObj.dsfs__Envelope_Status__c);
            docuSignObj.dsfs__Envelope_Status__c = ENVELOPE_STATUS_DELIVERED;
        }

        update docuSignObjList;
        
        // verify the status change
        
        casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(MAX_CASES, casesList.size());
        for (Case caseObj : casesList) {
	        System.assertEquals(ENVELOPE_STATUS_DELIVERED, caseObj.PHI_StatusNew__c);
        }

        Test.stopTest();
        
        
    }
    
	/*
	 * Verify the envelope status is updated correctly for a single Account but
	 * for many cases for bulk testing.  If the docuSignObj1.dsfs__Envelope_Status__c 
	 * does NOT get a new value, the value of the Case.PHI_StatusNew__c field is 
	 * NOT changed.
	 * 
	 */
    
    private static testMethod void mRunVerifyNegativeBulkStatusUpdates() {
        if (!mRunAllTests && !mRunVerifyNegativeBulkStatusUpdates) {
            System.debug('Skipping verifyNegativeBulkStatusUpdates()');
            return;
        }
        
        Test.startTest();

        createBulkRecords();

        Account accountObj = [select Id, Patient_Status__c from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1];
        Id accountObjId = accountObj.Id;
        
        // verify the initial status
        
        List<Case> casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(MAX_CASES, casesList.size());
        List<Id> caseIDList = new List<Id>();
        for (Case caseObj : casesList) {
	        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
            caseIDList.add(caseObj.Id);
        }

        // update the Docusign records
        
        List<dsfs__DocuSign_Status__c> docuSignObjList = [select Id, dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c where dsfs__Case__c in :caseIDList];
        System.assertEquals(MAX_CASES, docuSignObjList.size());
        for (dsfs__DocuSign_Status__c docuSignObj : docuSignObjList) {
            System.assertEquals(ENVELOPE_STATUS_COMPLETED, docuSignObj.dsfs__Envelope_Status__c);
            docuSignObj.dsfs__Envelope_Status__c = ENVELOPE_STATUS_COMPLETED;
        }

        update docuSignObjList;
        
        // verify the status change
        
        casesList = [select Id, PHI_StatusNew__c from Case where AccountId = :accountObjId];
        System.assertEquals(MAX_CASES, casesList.size());
        for (Case caseObj : casesList) {
	        System.assertEquals(ENVELOPE_STATUS_COMPLETED, caseObj.PHI_StatusNew__c);
        }

        Test.stopTest();
        
        
    }

    /*
     * Create the single Account object, Case object, and Docusign object for testing.
     * 
     */
    private static void createSingleRecord() {

        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = NPSAccountRecordTypeID;
        accountObj1.FirstName = firstName1;
        accountObj1.LastName = lastName1;
        accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;

        insert accountObj1;
        
        Id accountID1 = [select Id from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1].Id;
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = NPSCaseRecordTypeID;
        caseObj1.Origin = CASE_ORIGIN;       
        caseObj1.Action_Taken__c = CASE_ACTION_TAKEN;               
        caseObj1.Status = CASE_STATUS_NEW;
        caseObj1.Caller_First_Name__c = firstName2;
        caseObj1.Caller_Last_Name__c = lastName2;
        caseObj1.AccountId = accountID1;
        caseObj1.PHI_StatusNew__c = ENVELOPE_STATUS_COMPLETED;
        
        insert caseObj1;
        
        dsfs__DocuSign_Status__c docuSignObj1 = new dsfs__DocuSign_Status__c();
        docuSignObj1.dsfs__Company__c = accountID1;
        docuSignObj1.dsfs__Case__c = caseObj1.Id;
        docuSignObj1.dsfs__Envelope_Status__c = ENVELOPE_STATUS_COMPLETED;
        
        insert docuSignObj1;
        
    }
    
    /*
     * Create a single Account object with multiple Case and Docusign objects for testing.
     * 
     */
    private static void createBulkRecords() {

        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = NPSAccountRecordTypeID;
        accountObj1.FirstName = firstName1;
        accountObj1.LastName = lastName1;
        accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;

        insert accountObj1;
        
        Id accountID1 = [select Id from Account where FirstName = :firstName1 and LastName = :lastName1 limit 1].Id;
        
        List<Case> caseObjectsToInsert = new List<Case>();
        List<dsfs__DocuSign_Status__c> docuSignObjectsToInsert = new List<dsfs__DocuSign_Status__c>();
        
        for (Integer i = 0; i < MAX_CASES; i++) {
            Case caseObj = new Case();
            caseObj.RecordTypeId = NPSCaseRecordTypeID;
            caseObj.Origin = CASE_ORIGIN;       
            caseObj.Action_Taken__c = CASE_ACTION_TAKEN;               
            caseObj.Status = CASE_STATUS_NEW;
            caseObj.Caller_First_Name__c = firstName2;
            caseObj.Caller_Last_Name__c = lastName2;
            caseObj.AccountId = accountID1;
            caseObj.PHI_StatusNew__c = ENVELOPE_STATUS_COMPLETED;
            caseObjectsToInsert.add(caseObj);
        }
        insert caseObjectsToInsert;
        
        // Do we need to reload caseObjectsToInsert?
        for (Case caseObj : caseObjectsToInsert) {
            Id caseObjID = caseObj.Id;
            dsfs__DocuSign_Status__c docuSignObj = new dsfs__DocuSign_Status__c();
            docuSignObj.dsfs__Company__c = accountID1;
            docuSignObj.dsfs__Case__c = caseObjID;
            docuSignObj.dsfs__Envelope_Status__c = ENVELOPE_STATUS_COMPLETED;
        	docuSignObjectsToInsert.add(docuSignObj);
        }
        insert docuSignObjectsToInsert;
        
    }
    
}