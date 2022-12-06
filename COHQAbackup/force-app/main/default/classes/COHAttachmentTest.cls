/* 
 * This test class verifies the functionality of the COHAttachmentTrigger with
 * the exception of the code related to Gifts in Kind, ITS Intake, and Lab File Utility .  
 * Those are handled by other test classes.  
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COHAttachmentTest {
    private static final Boolean mRunVerifyDeathCertUpdate = false;
    private static final Boolean mRunVerifyBulkDeathCertUpdates = false;
    private static final Boolean mRunVerifyCauseMarketing = true;
    private static final Boolean mRunVerifyBulkCauseMarketing = false;
    
    private static final Boolean mRunAllTests = true;

    // Configuration constants
	private static final String ACCOUNT = 'Account';
    private static final String NEW_PATIENT_SERVICES_RECORD_TYPE = 'New Patient Services';
    private static final String CAUSE_MARKETING_RECORD_TYPE = 'Cause Marketing';
    
	private static final String CASE_CLASS = 'Case';
    private static final String MASTER_RECORD_TYPE = 'Master';
    private static final String APPLICATION_NAME = 'Call Center';
    private static final String DEATH_CERT_CALL_TYPE = 'Death Certificates';
    private static final String DEATH_CERT_CALL_TYPE_VAL = 'Death Certificates';
    private static final String DEATH_CERT_CALL_TYPE_NEEDED = 'Yes';
    private static final String CONSULTS_CALL_TYPE = 'Consults';
    private static final String CONSULTS_CALL_TYPE_VAL = 'Consults';
    private static final String DEFAULT_OWNER = 'Default Owner ID';
    private static final String DEFAULT_OWNER_VAL = [select Id from User where alias = 'saccount' limit 1].Id;
    private static final String DEATH_CERT_ATTACHMENT_NAME = 'Death Cert Attachment Name';
    private static final String DEATH_CERT_ATTACHMENT_VAL = 'Outside Death Notification.pdf';
    private static final String DEFAULT_EMAIL_ADDRESS = 'Default Email Address';
    private static final String DEFAULT_EMAIL_ADDRESS_VAL = 'czzz18kdi3@coh.org';
    private static final String CC_EMAIL_TRAIL_ADDRESS = 'CC Email Trail Address';
    private static final String CC_EMAIL_TRAIL_ADDRESS_VAL = 'dummyaddress86775@salesforceX.com' ;
    private static final String BOOLEAN_TYPE = 'Boolean';
    private static final String STRING_TYPE = 'String';

    // Account constants
    private static final String ACCOUNT_PATIENT_STATUS_NEW = 'New';
    private static final String ACCOUNT_PATIENT_STATUS_IN_PROGRESS = 'In Progress';
    private static final String ACCOUNT_PATIENT_STATUS_COMPLETED = 'Completed';
    private static final String ACCOUNT_STATUS_SCHEDULED = 'Appointment Scheduled';
	private static final String ACCOUNT_STATUS_REASON = 'This is a test';	// To comply with a Validation Rule
    private static final String CAUSE_MARKETING_ATTACHMENT_VAL = 'Cause Marketing Attachment Name';
    
    // Case constants
	private static final String CASE_ORIGIN = 'ACD';
	private static final String CASE_ACTION_TAKEN = 'EMAIL SENT';
	private static final String CASE_STATUS_NEW = 'New';
	private static final String CASE_STATUS_CLOSED = 'Closed';
	private static final String CASE_APPLICATION_TAKEN = 'APPLICATION TAKEN';
    private static final String CASE_WARM_HANDOFF_YES = 'Yes';
    

    // Attachment constants

	private static final String NON_DEATH_CERT_ATTACHMENT_NAME = 'Attachment0';
    
    // Test constants
    
    private static final String FIRST_NAME1 = 'Maggie';
    private static final String LAST_NAME1 = 'Poole';
    private static final String FIRST_NAME2 = 'Thomas';
    private static final String LAST_NAME2 = 'Magnum';
    private static final String FIRST_NAME3 = 'Jonathan';
    private static final String LAST_NAME3 = 'Higgins';
    private static final String FIRST_NAME4 = 'Rick';
    private static final String LAST_NAME4 = 'Wright';
    private static final String FIRST_NAME5 = 'Buck';
    private static final String LAST_NAME5 = 'Green';
    
    private static final String COHMRN1 = '00000000000001';  
    private static final String COHMRN2 = '00000000000002';  
    
    private static final Integer MAX_RECORDS = 202;
    private static final Integer DELAY = 2000;				// milliseconds
	private static final Integer CASES_COUNT = 3;
	private static final Integer RECORD_COUNT1 = 1;
    
    private static final Id mNPSAccountRecordTypeID = COHUtil.getRecordType(ACCOUNT, NEW_PATIENT_SERVICES_RECORD_TYPE);
    private static final Id mMasterCaseRecordTypeID = COHUtil.getRecordType(CASE_CLASS, MASTER_RECORD_TYPE);
    private static final Id mCauseMarketingRecordTypeID = COHUtil.getRecordType(ACCOUNT, CAUSE_MARKETING_RECORD_TYPE);

    private static Id mCaseObject0ID;
    private static Id mCaseObject1ID;
    private static Id mCaseObject2ID;
    
    /* 
     * Verifies the Death Certificate updates.  
     * This is mainly for code coverage reasons because the updates mainly involve sending emails.
     * 
     */
    private static testMethod void verifyDeathCertUpdate() {
        if (!mRunAllTests && !mRunVerifyDeathCertUpdate) {
            System.debug('Skipping verifyDeathCertUpdate()');
            return;
        }
        
        test.startTest();
        
		String mGetCasesSOQLQuery = COHUtil.buildSelectAllSOQLStatement(CASE_CLASS);
        
        setCOHAppConfigurationDeathCert();
        createRecordsDeathCert();
        
		List<Case> caseList = Database.query(mGetCasesSOQLQuery);
        System.assertEquals(CASES_COUNT, caseList.size());
        
        Attachment attachmentObj0 = createAttachmentObject(mCaseObject0ID, DEATH_CERT_ATTACHMENT_VAL);
        Attachment attachmentObj1 = createAttachmentObject(mCaseObject1ID, DEATH_CERT_ATTACHMENT_VAL);
        Attachment attachmentObj2 = createAttachmentObject(mCaseObject2ID, NON_DEATH_CERT_ATTACHMENT_NAME);
        
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        attachmentsToInsert.add(attachmentObj0);
        attachmentsToInsert.add(attachmentObj1);
        attachmentsToInsert.add(attachmentObj2);
        
        Database.insert(attachmentsToInsert);
        
        
    }
    
    /*
     * Verifies bulk updates for death certificate records
     * 
     */
    private static testMethod void verifyBulksDeathCertUpdates() {
        if (!mRunAllTests && !mRunVerifyBulkDeathCertUpdates) {
            System.debug('Skipping verifyBulksDeathCertUpdates()');
            return;
        }
        
        test.startTest();

        setCOHAppConfigurationDeathCert();
        
        List<Account>accountList = new List<Account>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Account accountObj = new Account();
            accountObj.RecordTypeId = mNPSAccountRecordTypeID;
            accountObj.FirstName = getStringWithDigits(FIRST_NAME1, i);
            accountObj.LastName = getStringWithDigits(LAST_NAME1, i);
            accountObj.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
	        accountObj.Status_Reason__c = ACCOUNT_STATUS_REASON;
            accountList.add(accountObj);
        }
        
        Database.insert(accountList);
        
        String defaultOwnerID = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEFAULT_OWNER);
		String deathCertType = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEATH_CERT_CALL_TYPE);

        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
			Account accountObj = accountList[i];
            Case caseObj = new Case();
            caseObj.Origin = CASE_ORIGIN;       
            caseObj.Action_Taken__c = CASE_ACTION_TAKEN;
            caseObj.Status = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
            caseObj.Caller_First_Name__c = getStringWithDigits(FIRST_NAME3, i);
            caseObj.Caller_Last_Name__c = getStringWithDigits(LAST_NAME3, i);
            caseObj.AccountId = accountObj.Id;
	        caseObj.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
			caseObj.OwnerId = defaultOwnerID;
	        caseObj.Type = deathCertType;
            caseObj.Death_Certificate__c = DEATH_CERT_CALL_TYPE_NEEDED;
            caseList.add(caseObj);
        }
        
        Database.insert(caseList);
        
        List<Attachment> attachmentList = new List<Attachment>();
        for (Case caseObj : caseList) {
	        Attachment attachmentObj = createAttachmentObject(caseObj.Id, DEATH_CERT_ATTACHMENT_VAL);
            attachmentList.add(attachmentObj);
        }

        Database.insert(attachmentList);
        
        test.stopTest();
    }
    
    /* 
     * Verifies processing Accounts with the Cause Marketing record type.
     * 
     */
    private static testMethod void verifyCauseMarketing() {
        if (!mRunAllTests && !mRunVerifyCauseMarketing) {
            System.debug('Skipping verifyCauseMarketing()');
            return;
        }
        
        test.startTest();
        
		createRecordsCauseMarketing();
        List<Account> accountList = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
        if (COHUtil.isValidList(accountList)) {
	        System.assertEquals(RECORD_COUNT1, accountList.size());
            Account accountObj = accountList.get(0);
            Datetime originalDateTime = accountObj.LastModifiedDate;

            // Force a delay
            COHUtil.delay(DELAY);	
            
            // add attachment
            Attachment attachmentObj = createAttachmentObject(accountObj.Id, CAUSE_MARKETING_ATTACHMENT_VAL);
            Database.insert(attachmentObj);
            
	        List<Account> accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
            accountObj = accountList1.get(0);
            Datetime newDateTime = accountObj.LastModifiedDate;
            
            System.assert(newDateTime.getTime() >= (originalDateTime.getTime() + DELAY), 
                          'Error: newDatetime (' + newDateTime + ') should be at least ' + DELAY + 
                          			' milliseconds greater than originalDateTime (' + originalDateTime + ')');
        } else {
            System.assert(false, 'Expected ' + RECORD_COUNT1 + ' records, but retrieved nothing');
        }
        test.stopTest();
    }    
    
    /*
     * Verifies bulk processing Accounts with the Cause Marketing record type.
     * 
     */
    private static testMethod void verifyBulksCauseMarketing() {
        if (!mRunAllTests && !mRunVerifyBulkCauseMarketing) {
            System.debug('Skipping verifyBulksCauseMarketing()');
            return;
        }
        
        test.startTest();

        List<Account>accountList = new List<Account>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Account tempAccountObj = new Account();
            tempAccountObj.RecordTypeId = mCauseMarketingRecordTypeID;
            tempAccountObj.Name = FIRST_NAME1;
            accountList.add(tempAccountObj);
        }
        
        Database.insert(accountList);
        
        List<Account> accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
        Account accountObj = accountList1.get(0);
        Datetime originalDateTime = accountObj.LastModifiedDate;
        
        // Force a delay
        COHUtil.delay(DELAY);	
        
        List<Attachment> attachmentList = new List<Attachment>();
        for (Account tempAccountObj : accountList) {
	        Attachment attachmentObj = createAttachmentObject(tempAccountObj.Id, DEATH_CERT_ATTACHMENT_VAL);
            attachmentList.add(attachmentObj);
        }

        Database.insert(attachmentList);
        
        accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
        accountObj = accountList1.get(0);
        Datetime newDateTime = accountObj.LastModifiedDate;
        
        System.assert(newDateTime.getTime() >= (originalDateTime.getTime() + DELAY), 
                      'Error: newDatetime (' + newDateTime + ') should be at least ' + DELAY + 
                      ' milliseconds greater than originalDateTime (' + originalDateTime + ')');
        test.stopTest();
    }
    
    /*
     * Create the Account and Case objects for bulk testing death certificates
     * 
     */
    private static void createBulkRecordsDeathCerts() {
 	
        List<Account>accountList = new List<Account>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Account accountObj = new Account();
            accountObj.RecordTypeId = mNPSAccountRecordTypeID;
            accountObj.FirstName = getStringWithDigits(FIRST_NAME1, i);
            accountObj.LastName = getStringWithDigits(LAST_NAME1, i);
            accountObj.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
	        accountObj.Status_Reason__c = ACCOUNT_STATUS_REASON;
            accountList.add(accountObj);
        }
        
        insert accountList;
        
        String defaultOwnerID = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEFAULT_OWNER);
		String deathCertType = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEATH_CERT_CALL_TYPE);

        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
			Account accountObj = accountList[i];
            Case caseObj = new Case();
            caseObj.Origin = CASE_ORIGIN;       
            caseObj.Action_Taken__c = CASE_ACTION_TAKEN;		        
            caseObj.Status = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
            caseObj.Caller_First_Name__c = getStringWithDigits(FIRST_NAME3, i);
            caseObj.Caller_Last_Name__c = getStringWithDigits(LAST_NAME3, i);
            caseObj.AccountId = accountObj.Id;
	        caseObj.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
			caseObj.OwnerId = defaultOwnerID;
	        caseObj.Type = deathCertType;
            caseList.add(caseObj);
        }
        
        Database.insert(caseList);
        
        List<Attachment> attachmentList = new List<Attachment>();
        for (Case caseObj : caseList) {
	        Attachment attachmentObj = createAttachmentObject(caseObj.Id, DEATH_CERT_ATTACHMENT_VAL);
            attachmentList.add(attachmentObj);
        }
        Database.insert(attachmentList);
    }
    
    /*
     *  Creates the configuration objects for the COH Case test environment.
     */
    private static void setCOHAppConfigurationDeathCert() {
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = APPLICATION_NAME;
		configObj0.Name = DEATH_CERT_CALL_TYPE;
        configObj0.Value__c = DEATH_CERT_CALL_TYPE_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = APPLICATION_NAME;
		configObj1.Name = CONSULTS_CALL_TYPE;
        configObj1.Value__c = CONSULTS_CALL_TYPE_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;
        
        // Get the ID of the default Owner
        
        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = APPLICATION_NAME;
		configObj2.Name = DEFAULT_OWNER;
        configObj2.Value__c = DEFAULT_OWNER_VAL;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Active__c = true;
        
        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = APPLICATION_NAME;
		configObj3.Name = DEFAULT_EMAIL_ADDRESS;
        configObj3.Value__c = DEFAULT_EMAIL_ADDRESS_VAL;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Active__c = true;
        
        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = APPLICATION_NAME;
		configObj4.Name = CC_EMAIL_TRAIL_ADDRESS;
        configObj4.Value__c = CC_EMAIL_TRAIL_ADDRESS_VAL;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = APPLICATION_NAME;
		configObj5.Name = DEATH_CERT_ATTACHMENT_NAME;
        configObj5.Value__c = DEATH_CERT_ATTACHMENT_VAL;
        configObj5.Value_Type__c = STRING_TYPE;
        configObj5.Active__c = true;

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);
        configList.add(configObj5);
		Database.insert(configList);
    }

    /*
     * Create the Account and Case objects for death certificate testing.
     * 
     */
    private static void createRecordsDeathCert() {
        
        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = mNPSAccountRecordTypeID;
        accountObj0.FirstName = FIRST_NAME1;
        accountObj0.LastName = LAST_NAME1;
		accountObj0.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj0.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj0.COH_MRN__c = COHMRN1;
        
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = mNPSAccountRecordTypeID;
        accountObj1.FirstName = FIRST_NAME2;
        accountObj1.LastName = LAST_NAME2;
        accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_NEW;
        accountObj1.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj1.COH_MRN__c = COHMRN2;

        List<Account> accountsToInsert = new List<Account>();
        accountsToInsert.add(accountObj0);
        accountsToInsert.add(accountObj1);
        insert accountsToInsert;
        
        Id accountID0 = [select Id from Account where FirstName = :FIRST_NAME1 and LastName = :LAST_NAME1 limit 1].Id;
        Id accountID1 = [select Id from Account where FirstName = :FIRST_NAME2 and LastName = :LAST_NAME2 limit 1].Id;

        // Contact ID is required because of a validation rule.  The rule checks for 
        // Contact.Account.COH_MRN__c.  The validation rule checks for the MRN in the 
        // parent object because the COH_MRN__c field will not be copied until after
        // the Case is saved. 
        Contact contactObj0 = [select Id, AccountId from Contact where AccountId = :accountID0 limit 1];
        Contact contactObj1 = [select Id, AccountId from Contact where AccountId = :accountID1 limit 1];
        
        String defaultOwnerID = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEFAULT_OWNER);
		String deathCertType = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DEATH_CERT_CALL_TYPE);
		String consultType = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, CONSULTS_CALL_TYPE);

        Case caseObj0 = new Case();			// Should NOT send email
 		caseObj0.Origin = CASE_ORIGIN;       
		caseObj0.Action_Taken__c = CASE_ACTION_TAKEN;		        
        caseObj0.Status = CASE_STATUS_NEW;
        caseObj0.Caller_First_Name__c = FIRST_NAME3;
        caseObj0.Caller_Last_Name__c = LAST_NAME3;
		caseObj0.AccountId = accountID0;
        caseObj0.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj0.ContactId = contactObj0.Id;
		caseObj0.OwnerId = defaultOwnerID;
        caseObj0.Type = consultType;
        
        Case caseObj1 = new Case();			// SHOULD send email
 		caseObj1.Origin = CASE_ORIGIN;       
       	caseObj1.Action_Taken__c = CASE_ACTION_TAKEN;
        caseObj1.Status = CASE_STATUS_NEW;
        caseObj1.Caller_First_Name__c = FIRST_NAME4;
        caseObj1.Caller_Last_Name__c = LAST_NAME4;
		caseObj1.AccountId = accountID0;
        caseObj1.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj1.ContactId = contactObj0.Id;
		caseObj1.OwnerId = defaultOwnerID;
        caseObj1.Type = deathCertType;
        caseObj1.Death_Certificate__c = DEATH_CERT_CALL_TYPE_NEEDED;
        
        Case caseObj2 = new Case();			// Should NOT send email
 		caseObj2.Origin = CASE_ORIGIN;       
		caseObj2.Action_Taken__c = CASE_APPLICATION_TAKEN;
        caseObj2.Status = CASE_STATUS_NEW;
        caseObj2.Caller_First_Name__c = FIRST_NAME5;
        caseObj2.Caller_Last_Name__c = LAST_NAME5;
		caseObj2.AccountId = accountID1;
        caseObj2.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj2.ContactId = contactObj1.Id;
		caseObj2.OwnerId = defaultOwnerID;
        caseObj2.Type = consultType;
        
        List<Case> casesToInsert = new List<Case>();
        casesToInsert.add(caseObj0);
        casesToInsert.add(caseObj1);
        casesToInsert.add(caseObj2);
        
        Database.insert(casesToInsert);

        mCaseObject0ID = caseObj0.Id;
        mCaseObject1ID = caseObj1.Id;
        mCaseObject2ID = caseObj2.Id;

    }

    /*
     * Create the Account for Cause Marketing testing.
     * 
     */
    private static void createRecordsCauseMarketing() {
        
        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = mCauseMarketingRecordTypeID;
        accountObj0.Name = FIRST_NAME1;
        
        insert accountObj0;
    }
    
    /*
     * Create an Attachment object and assign it the ID of the parent Case object.
     * 
     * @param	parentObjectID	ID of the parent object.
     * @param	attachmentName	Name of the attachment.
     * @return					Attachment object
     * 
     */
    private static Attachment createAttachmentObject(Id parentObjectID, String attachmentName) {
        Attachment attachmentObj = new Attachment();
        attachmentObj.Body = Blob.valueOf('Now I know what you\'re thinking...');
        attachmentObj.Name = attachmentName;
        attachmentObj.ParentId = parentObjectID;   
        return attachmentObj;
    }
    
    
    /*
     * Creates a random string by appending a three digit number (e.g. "Jim0001")
     * 
     * @param baseString	Basis for the new string
     * @param num			Number to be appended.
     * 
     */
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