/*
 * This test class verifies that when packet types have been selected in the 
 * new Foundation Account screen, the attachments linked to those packet types 
 * will be sent in an email is sent to the patient.
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
public class FoundationProcessAccountUtilTest {
    private static final Boolean mRunAllTests = true;
    private static final Boolean mRunVerifyAddingRecordSinglePacketType = false;   
    // testing--raymond tam
    private static final Boolean mRunVerifyWebservice = true;

    private static final Boolean mRunVerifyAddingNoPacketTypeRecord = false;
    private static final Boolean mRunVerifyAddingNonFoundationRecord = false;
    private static final Boolean mRunVerifyTriggerLimits = false;

    // Configuration constants
    private static final String RECORD_TYPE_NAME = 'Foundation';
    private static final String COH_DATA_ENVELOPE = 'COH_Data_Envelope__c';
	private static final String APPLICATION_NAME = 'Foundation';
    private static final String LOCATION_GROUP_NAME = 'Locations';
    private static final String STRING_TYPE = 'String';
    private static final String EMAIL_SUBJECT = 'Email Subject';
    private static final String EMAIL_SUBJECT_VAL = 'City of Hope Medical Group – [SiteName] Registration Packet';
    private static final String DONT_SEND_EMAIL_ADDRESS = 'Dummy Email Address';
    private static final String DONT_SEND_EMAIL_ADDRESS_VAL = 'None@none.com';
    private static final String MAP_URL_TEMPLATE = 'Map URL Template';
    private static final String MAP_URL_TEMPLATE_VAL = 'https://www.google.com/maps/place/[SearchCriteria]';
    private static final String INTAKE_LOCATION_ARCADIA = 'Arcadia';
    private static final String INTAKE_LOCATION_ARCADIA_VAL = '301+W+Huntington+Dr+%23400,+Arcadia,+CA+91007';
    private static final String ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS = 'Activity History BCC Email Address';
    private static final String ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS_VAL = 'dummyaddress86775@salesforceX.com' ;
    private static final Integer CONFIGURATION_OBJ_COUNT = 5;

    // COH Data Envelope constants
	private static final String DATA_ENVELOPE_NAME1 = 'General Surgery';
	private static final String DATA_ENVELOPE_NAME2 = 'Neurosurgery';
	private static final String DATA_ENVELOPE_NAME3 = 'Gynecology';
    private static final Integer DATA_ENVELOPE_OBJ_COUNT = 3;

    // Attachment constants
	private static final String ATTACHMENT_NAME1 = 'Attachment1';
	private static final String ATTACHMENT_NAME2 = 'Attachment2';
	private static final String ATTACHMENT_NAME3a = 'Attachment3a';
	private static final String ATTACHMENT_NAME3b = 'Attachment3b';

    // COH Business Account and Contact constants
	private static final String COH_BUSINESS_ACCOUNT_TYPE = 'COH Business Accounts';
	private static final String COH_BUSINESS_ACCOUNT_NAME = 'City of Hope National Medical Center';
	private static final String CONTACT = 'Contact';
    private static final String COH_CONTACTS_TYPE = 'COH Contacts';
    private static final String PHYSICIAN_FIRST_NAME = 'Ji Lian';
    private static final String PHYSICIAN_LAST_NAME = 'Cai';
    private static final String PHYSICIAN_TYPE = 'Physician';	// Redundant, but it's harmless
    private static final String PHYSICIAN_DIVISION = 'Hematology';
	private static final String ADMIN_FIRST_NAME = 'Diana';
	private static final String ADMIN_LAST_NAME = 'Prince';
	private static final String ADMIN_SUPPORT_TYPE = 'Admin Support';

    // Other constants
	private static final String FIRST_NAME = 'Thomas';
	private static final String LAST_NAME = 'Magnum';
	private static final String DUMMY_EMAIL = 'c8kdi3@coh.org';
    private static final Date APPOINTMENT_DATE = Date.today();
    private static final String APPOINTMENT_TIME = '11:15 AM';
    private static final Integer MAX_RECORDS = 202;

    // Configuration for the test environment
    private static List<COH_App_Configuration__c> mConfigList = null;
    private static Id mFoundationRecordTypeID;
    private static Id mNPSRecordTypeID;
    private static Id mCOHBusinessAccountTypeID;
    private static Id mCOHBusinessAccountId = null;		// the ID of the actual Account object, not the record type
    private static Id mCOHContactsTypeID;
    private static Id mCOHPhysicianID;					// the ID of the actual Physician record
    
    /*
     * Verifies that adding a new record with a single packet type 
     * was done correctly.  
     * 
     * NOTE: This is done mainly for code coverage purposes.  It is 
     * not possible to use an automated test to verify if the actual email
     * has the correct attachments.
     * 
     */
    private static testMethod void verifyAddingRecordSinglePacketType() {
        if (!mRunAllTests && !mRunVerifyAddingRecordSinglePacketType) {
            System.debug('Skipping verifyAddingRecordSinglePacketType()');
            return;
        }
        
        test.startTest();
        
		mFoundationRecordTypeID = [select Id, name from RecordType where name = :APPLICATION_NAME and SObjectType = 'Account' limit 1].Id;

        setFoundationConfiguration();
        setCOHDataEnveopeObjects();
		setCOHContacts();
        
        Account accountObj = new Account();
        accountObj.RecordTypeId = mFoundationRecordTypeID;
        accountObj.FirstName = FIRST_NAME;
        accountObj.LastName = LAST_NAME;
        accountObj.Foundation_Packet_Type__c = DATA_ENVELOPE_NAME1;
        accountObj.PersonEmail = DUMMY_EMAIL;	// we don't really want to send an email to a real address
        accountObj.Appointment_Date_Time__c = APPOINTMENT_DATE;
        accountObj.Time__c = APPOINTMENT_TIME;
        accountObj.Location__pc = INTAKE_LOCATION_ARCADIA;
        accountObj.COH_Physician__c = mCOHPhysicianID;
        Database.insert(accountObj);
            
        test.stopTest();
    }

    /*
     * Verifies that the webservice works correctly.
     * 
     * NOTE: This is done mainly for code coverage purposes.  It is 
     * not possible to use an automated test to verify if the actual email
     * has the correct attachments.
     * 
     */
    private static testMethod void verifyWebservice() {
        if (!mRunAllTests && !mRunVerifyWebservice) {
            System.debug('Skipping verifyWebservice()');
            return;
        }
        
        test.startTest();
        
		mFoundationRecordTypeID = [select Id, name from RecordType where name = :APPLICATION_NAME and SObjectType = 'Account' limit 1].Id;

        setFoundationConfiguration();
        setCOHDataEnveopeObjects();
		setCOHContacts();
        
        Account accountObj = new Account();
        accountObj.RecordTypeId = mFoundationRecordTypeID;
        accountObj.FirstName = FIRST_NAME;
        accountObj.LastName = LAST_NAME;
        accountObj.Foundation_Packet_Type__c = DATA_ENVELOPE_NAME1;
        accountObj.PersonEmail = DUMMY_EMAIL;	// we don't really want to send an email to a real address
        accountObj.Appointment_Date_Time__c = APPOINTMENT_DATE;
        accountObj.Time__c = APPOINTMENT_TIME;
        accountObj.Location__pc = INTAKE_LOCATION_ARCADIA;
        accountObj.COH_Physician__c = mCOHPhysicianID;
        Database.insert(accountObj);
        
        Database.update(accountObj);
        FoundationProcessAccountUtil.resendEmailWS(accountObj.Id);   
        test.stopTest();
    }

      
    /*
     * Verifies that adding a new record without a packet type 
     * was done correctly.  
     * 
     * NOTE: This is done mainly for code coverage purposes.  It is 
     * not possible to use an automated test to verify if the actual email
     * has the correct attachments.
     * 
     */
    private static testMethod void verifyAddingNoPacketTypeRecord() {
        if (!mRunAllTests && !mRunVerifyAddingNoPacketTypeRecord) {
            System.debug('Skipping verifyAddingNoPacketTypeRecord()');
            return;
        }
        
        test.startTest();
        
		mFoundationRecordTypeID = [select Id, name from RecordType where name = :APPLICATION_NAME and SObjectType = 'Account' limit 1].Id;

        setFoundationConfiguration();
        setCOHDataEnveopeObjects();
		setCOHContacts();
        
		FoundationProcessAccountUtil fpau = new FoundationProcessAccountUtil();
            
        Account accountObj = new Account();
        accountObj.RecordTypeId = mFoundationRecordTypeID;
        accountObj.FirstName = FIRST_NAME;
        accountObj.LastName = LAST_NAME;
        accountObj.Foundation_Packet_Type__c = DATA_ENVELOPE_NAME1;
        accountObj.PersonEmail = DONT_SEND_EMAIL_ADDRESS_VAL;	// Indicates that an email should NOT be sent out
        accountObj.Appointment_Date_Time__c = APPOINTMENT_DATE;
        accountObj.Time__c = APPOINTMENT_TIME;
        accountObj.Location__pc = INTAKE_LOCATION_ARCADIA;
        accountObj.COH_Physician__c = mCOHPhysicianID;
        Database.insert(accountObj);
            
        test.stopTest();
    }

    /*
     * Verifies that adding a single new NON Foundation record was done correctly.
     * 
     * NOTE: This is done mainly for code coverage purposes.  It is 
     * not possible to use an automated test to verify if the actual email
     * has the correct attachments.
     * 
     */
    
    private static testMethod void verifyAddingNonFoundationRecord() {
        if (!mRunAllTests && !mRunVerifyAddingNonFoundationRecord) {
            System.debug('Skipping verifyAddingNonFoundationRecord()');
            return;
        }

        test.startTest();
        
		mNPSRecordTypeID = [select Id, name from RecordType where name = 'New Patient Services' and SObjectType = 'Account' limit 1].Id;
        setFoundationConfiguration();
        setCOHDataEnveopeObjects();
		setCOHContacts();
        
        Account accountObj = new Account();
        accountObj.RecordTypeId = mNPSRecordTypeID;
        accountObj.FirstName = FIRST_NAME;
        accountObj.LastName = LAST_NAME;
        accountObj.PersonEmail = DUMMY_EMAIL;	// we don't really want to send an email to a real address
        accountObj.Appointment_Date_Time__c = APPOINTMENT_DATE;
        accountObj.Time__c = APPOINTMENT_TIME;
        accountObj.Location__pc = INTAKE_LOCATION_ARCADIA;
        accountObj.COH_Physician__c = mCOHPhysicianID;
        Database.insert(accountObj);
            
        test.stopTest();
        
    }

    /*
     * Verifies that the trigger limits.  
     * 
     * NOTE: This is done mainly for code coverage purposes.  It is 
     * not possible to use an automated test to verify if the actual email
     * has the correct attachments.
     * 
     */
    private static testMethod void verifyTriggerLimits() {
        if (!mRunAllTests && !mRunVerifyTriggerLimits) {
            System.debug('Skipping verifyTriggerLimits()');
            return;
        }
        
        test.startTest();
        
		mFoundationRecordTypeID = [select Id, name from RecordType where name = 'Foundation' and SObjectType = 'Account' limit 1].Id;

        setFoundationConfiguration();
        setCOHDataEnveopeObjects();
		setCOHContacts();
        
        List<Account> accountObjectLists = new List<Account>();
        
        for (Integer i = 0 ; i < MAX_RECORDS; i++) {
            String uniqueID = generateIDString(i);
            
            Account accountObj = new Account();
            accountObj.RecordTypeId = mFoundationRecordTypeID;
            accountObj.FirstName = FIRST_NAME + uniqueID;
            accountObj.LastName = LAST_NAME + uniqueID;
            accountObj.Foundation_Packet_Type__c = DATA_ENVELOPE_NAME1;
            accountObj.PersonEmail = DUMMY_EMAIL;	// we don't really want to send an email to a real address
            accountObj.Appointment_Date_Time__c = APPOINTMENT_DATE;
            accountObj.Time__c = APPOINTMENT_TIME;
	        accountObj.Location__pc = INTAKE_LOCATION_ARCADIA;
	        accountObj.COH_Physician__c = mCOHPhysicianID;
        }
        Database.insert(accountObjectLists);
            
        test.stopTest();
        
    }
    
    
    /*
     *  Creates and retrieves the configuration objects for the Foundation test environment.
     */
    private static List<COH_App_Configuration__c> getFoundationConfiguration() {
        
        if (COHUtil.isValidList(mConfigList)) {
            return mConfigList;
        } else {
            mConfigList = new List<COH_App_Configuration__c>();
        }
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = APPLICATION_NAME;
		configObj0.Name = EMAIL_SUBJECT;
        configObj0.Value__c = EMAIL_SUBJECT_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;

        mConfigList.add(configObj0);

        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = APPLICATION_NAME;
		configObj1.Name = DONT_SEND_EMAIL_ADDRESS;
        configObj1.Value__c = DONT_SEND_EMAIL_ADDRESS_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;

        mConfigList.add(configObj1);

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = APPLICATION_NAME;
		configObj2.Name = MAP_URL_TEMPLATE;
        configObj2.Value__c = MAP_URL_TEMPLATE_VAL;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Active__c = true;

        mConfigList.add(configObj2);
        
        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = APPLICATION_NAME;
        configObj3.Configuration_Group__c = LOCATION_GROUP_NAME;
		configObj3.Name = INTAKE_LOCATION_ARCADIA;
        configObj3.Value__c = INTAKE_LOCATION_ARCADIA_VAL;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Active__c = true;

        mConfigList.add(configObj3);

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = APPLICATION_NAME;
		configObj4.Name = ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS;
        configObj4.Value__c = ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS_VAL;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;
        
        mConfigList.add(configObj4);

        return mConfigList;
        
    }
    
    /*
     * Create COH contacts for testing.  If the COH Business Account does not 
     * exist, it is created here.
     *
     */
    private static void setCOHContacts() {
        if (mCOHBusinessAccountId == null) {
            setCOHBusinessAccount();
        }
// testing--raymond tam            
//		mCOHContactsTypeID = [select Id, name from RecordType where name = :COH_CONTACTS_TYPE and SObjectType = 'Contact' limit 1].Id;
        mCOHContactsTypeID = COHUtil.getRecordType(CONTACT, COH_CONTACTS_TYPE);
        
        Contact contactObj0 = new Contact();
        contactObj0.FirstName = ADMIN_FIRST_NAME;
        contactObj0.LastName = ADMIN_LAST_NAME;
        contactObj0.Type__c = ADMIN_SUPPORT_TYPE;
        contactObj0.Division__c = PHYSICIAN_DIVISION;
        contactObj0.RecordTypeId = mCOHContactsTypeID;
        contactObj0.Email = DUMMY_EMAIL;
        contactObj0.AccountId = mCOHBusinessAccountId;
        
        Database.insert(contactObj0);
        Id secretaryID = contactObj0.Id;

        Contact contactObj1 = new Contact();
        contactObj1.FirstName = PHYSICIAN_FIRST_NAME;
        contactObj1.LastName = PHYSICIAN_LAST_NAME;
        contactObj1.Type__c = PHYSICIAN_TYPE;
        contactObj1.Division__c = PHYSICIAN_DIVISION;
        contactObj1.RecordTypeId = mCOHContactsTypeID;
        contactObj1.Email = DUMMY_EMAIL;
        contactObj1.AccountId = mCOHBusinessAccountId;
        contactObj1.Secretary__c = secretaryID;
        
        Database.insert(contactObj1);

        mCOHPhysicianID = contactObj1.Id;
    }
    
    /*
     * Create a COH Business Account for testing.  This is required for 
     * creating a COH contact.
     *
     */

    private static void setCOHBusinessAccount() {
		mCOHBusinessAccountTypeID = [select Id, name from RecordType where name = :COH_BUSINESS_ACCOUNT_TYPE and SObjectType = 'Account' limit 1].Id;
        Account accountObj = new Account();
        accountObj.Name = COH_BUSINESS_ACCOUNT_NAME;
        accountObj.RecordTypeId = mCOHBusinessAccountTypeID;
		Database.insert(accountObj);
        mCOHBusinessAccountId = accountObj.Id;
    }
    
    
    /*
     * Create the COH Data Envelope objects for testing.
     * 
     */
    private static void setCOHDataEnveopeObjects() {
        
        Id recordTypeID = COHUtil.getRecordType(COH_DATA_ENVELOPE, RECORD_TYPE_NAME);

        COH_Data_Envelope__c dataEnvelopeObj1 = new COH_Data_Envelope__c();
        dataEnvelopeObj1.Name = DATA_ENVELOPE_NAME1;
        dataEnvelopeObj1.Active__c = true;
        dataEnvelopeObj1.RecordTypeID = recordTypeID;
        Database.insert(dataEnvelopeObj1);
        Id dataEnvelopObjID1 = dataEnvelopeObj1.Id;
        
        Attachment attachmentObj1 = createAttachmentObject(dataEnvelopObjID1, ATTACHMENT_NAME1);
        Database.insert(attachmentObj1);
        
        COH_Data_Envelope__c dataEnvelopeObj2 = new COH_Data_Envelope__c();
        dataEnvelopeObj2.Name = DATA_ENVELOPE_NAME2;
        dataEnvelopeObj2.Active__c = true;
        dataEnvelopeObj2.RecordTypeID = recordTypeID;
        Database.insert(dataEnvelopeObj2);
        Id dataEnvelopObjID2 = dataEnvelopeObj2.Id;
        
        Attachment attachmentObj2 = createAttachmentObject(dataEnvelopObjID2, ATTACHMENT_NAME2);
        Database.insert(attachmentObj2);
        
        COH_Data_Envelope__c dataEnvelopeObj3 = new COH_Data_Envelope__c();
        dataEnvelopeObj3.Name = DATA_ENVELOPE_NAME3;
        dataEnvelopeObj3.Active__c = true;
        dataEnvelopeObj3.RecordTypeID = recordTypeID;
        Database.insert(dataEnvelopeObj3);
        Id dataEnvelopObjID3 = dataEnvelopeObj3.Id;
        
        Attachment attachmentObj3a = createAttachmentObject(dataEnvelopObjID3, ATTACHMENT_NAME3a);
        Database.insert(attachmentObj3a);
        
        Attachment attachmentObj3b = createAttachmentObject(dataEnvelopObjID3, ATTACHMENT_NAME3b);
        Database.insert(attachmentObj3b);
        
        
    }
    
    /*
     * Insert configuration objects for the Foundation test environment.  Test.startTest() and Test.stopTest()
     * must be invoked by the caller.
     */
    private static void setFoundationConfiguration() {
        List<COH_App_Configuration__c> configList = getFoundationConfiguration();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(CONFIGURATION_OBJ_COUNT, listSize);
        Database.insert(configList);
    }
    
    /*
     * Create an Attachment object and assign it the ID of the parent ITS_Project_Request__c object.
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
     * Generate a three character string based on the parameter.  It will be padded
     * to the left by 0s.  For example, if val is 1, it will return '001'.  If val 
     * is 23, it will return '023'.  If val is 173, it will return '173'.
     * 
     * @param	val		Integer value
     * @return			Three character string based on the value of the val parameter.
     * 
     */
    private static String generateIDString(Integer val) {
        String str = String.valueOf(val);
        if (val >= 0 && val < 10) {
            return '00' + str;
        } else if (val >= 0 && val < 10) {
            return '0' + str;
        } else {
            return str;
        } 
    }
}