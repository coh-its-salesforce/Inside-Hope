/*
 * This test class verifies that when an attachment is made to a ITS_Project_Request__c
 * object, an email is sent to the appropriate person, and the Current_Status__c field is updated.
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
public class IIRUtilityTest {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyUpdate = true;
    private static final Boolean mRunVerifyNonITS_Intake_Request = true;
    private static final Boolean mRunVerifyTriggerLimits = false;
	
    // Configuration constants
	private static final String APPLICATION_NAME = 'ITS Intake Request';
    private static final String EMAIL_TO_ADDRESS = 'Email To Address';
    private static final String EMAIL_SUBJECT = 'Email Subject';
    private static final String URL_PREFIX = 'URL Prefix';
    private static final String REQUESTED_STATE = 'Requested State';
    private static final String EDW_APPLICATION = 'EDW';
    private static final String ERP_APPLICATION = 'ERP';
    private static final String EMAIL_TEMPLATE_NAME = 'Email Template Name';

    private static final String STRING_TYPE = 'String';
    
	private static final String SEND_TO_ADDRESS_VAL = 'rtam@coh.org';
    private static final String SUBJECT_LINE_VAL = 'EDW Intake Request';
    private static final String URL_LINK_PREFIX = 'https://cs10.salesforce.com/';
    private static final String REQUESTED_STATE_VAL = '1.Requested';
    private static final String DUMMY_STATE_VAL = '2.Acknowledged';
    private static final String IIR_CONFIGURATION_GROUP_VAL = 'Valid Applications';
    private static final String EDW_APPLICATION_VAL = 'EDW';
    private static final String ERP_APPLICATION_VAL = 'ERP';
    
    private static final Integer CONFIGURATION_OBJ_COUNT = 6;
    private static final Integer MAX_RECORDS = 3;
    
    // Configuration for the test environment
    private static List<COH_App_Configuration__c> mConfigList = null;
    
    /*
     * Verifies that the updates were done correctly.
     */
    private static testMethod void verifyUpdate() {
        if (!mRunAllTests && !mRunVerifyUpdate) {
            System.debug('Skipping verifyUpdate()');
            return;
        }
        
        String objName1 = 'EDW Project1';
        String objName2 = 'Non EDW Project1';
        String attachmentName1 = 'attachmentName1';
        test.startTest();

        setIIRConfiguration();        
        Id ownerID = [select id from user where email = :SEND_TO_ADDRESS_VAL limit 1].Id;
        ITS_Project_Request__c IIRObj1 = new ITS_Project_Request__c();
        IIRObj1.Name = objName1;
        IIRObj1.ITS_Application__c = EDW_APPLICATION_VAL;
        IIRObj1.Current_State__c = DUMMY_STATE_VAL;
        IIRObj1.OwnerId = ownerID;
        insert IIRObj1;
        
        ITS_Project_Request__c IIRObj2 = new ITS_Project_Request__c();
        IIRObj2.Name = objName2;
        IIRObj2.ITS_Application__c = ERP_APPLICATION_VAL;
        IIRObj2.Current_State__c = DUMMY_STATE_VAL;
        IIRObj2.OwnerId = ownerID;
        insert IIRObj2;
        
        List<ITS_Project_Request__c> IIRObjList = new List<ITS_Project_Request__c>();
        IIRObjList = [select Id, Current_State__c, CreatedBy.Name, CreatedBy.CreatedDate, Name from ITS_Project_Request__c];
        System.assertEquals(2, IIRObjList.size());
        
        for (ITS_Project_Request__c obj : IIRObjList) {
	        System.assertEquals(DUMMY_STATE_VAL, IIRObj2.Current_State__c);
        }
        
        Attachment attachmentObj1 = createAttachmentObject(IIRObj1.Id, attachmentName1);
 		insert attachmentObj1;
        
        IIRObjList = [select Id, Current_State__c, CreatedBy.Name, CreatedBy.CreatedDate, Name from ITS_Project_Request__c];
        System.assertEquals(2, IIRObjList.size());
        for (ITS_Project_Request__c obj : IIRObjList) {
            String objName = obj.Name;
            if (objName.equalsIgnoreCase(objName1)) {
                System.assertEquals(REQUESTED_STATE_VAL, obj.Current_State__c);
            } else if (objName.equalsIgnoreCase(objName2)) {
                System.assertEquals(DUMMY_STATE_VAL, obj.Current_State__c);
            }
	        System.assertEquals(DUMMY_STATE_VAL, IIRObj2.Current_State__c);
        }
        
        test.stopTest();
        
    }
    /*
     * Verifies that attachments to non-ITS_Intake_Request__c objects are 
     * added correctly.
     * 
     * Note: This is not used because each Attachment to an ITS_Intake_Request__c 
     * object requires a single database lookup to build the email text body.
     */
    private static testMethod void verifyNonITS_Intake_Request() {
        if (!mRunAllTests && !mRunVerifyNonITS_Intake_Request) {
            System.debug('Skipping verifyNonITS_Intake_Request()');
            return;
        }
        
        Account accountObj = new Account();
        accountObj.FirstName = 'Thomas';
        accountObj.LastName = 'Thomas';
        accountObj.Marketing_Source__c = 'Other';
        
        insert accountObj;
        Id parentID = accountObj.Id;
        
        Attachment attachmentObj = createAttachmentObject(accountObj.Id, 'test attachment1');
		insert attachmentObj;
        Id attachmentID1 = attachmentObj.Id;
        
        attachmentObj = createAttachmentObject(accountObj.Id, 'test attachment2');
		insert attachmentObj;
        Id attachmentID2 = attachmentObj.Id;
        
        List<Attachment> attachmentObjList = [select Id from Attachment where ParentId = :parentID];
		System.assertEquals(2, attachmentObjList.size());
    }

    
    /*
     * Verifies that the trigger limits.  
     * 
     * Note: This is not used because each Attachment to an ITS_Intake_Request__c 
     * object requires a single database lookup to build the email text body.
     */
    private static testMethod void verifyTriggerLimits() {
        if (!mRunAllTests && !mRunVerifyTriggerLimits) {
            System.debug('Skipping verifyTriggerLimits()');
            return;
        }
    }
    
    /*
     *  Creates and retrieves the configuration objects for the IIR test environment.
     */
    private static List<COH_App_Configuration__c> getIIRConfiguration() {
        
        if (COHUtil.isValidList(mConfigList)) {
            return mConfigList;
        } else {
            mConfigList = new List<COH_App_Configuration__c>();
        }
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = APPLICATION_NAME;
		configObj1.Name = EMAIL_TO_ADDRESS;
        configObj1.Value__c = SEND_TO_ADDRESS_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = APPLICATION_NAME;
		configObj2.Name = EMAIL_SUBJECT;
        configObj2.Value__c = SUBJECT_LINE_VAL;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = APPLICATION_NAME;
		configObj3.Name = URL_PREFIX;
        configObj3.Value__c = URL_LINK_PREFIX;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = APPLICATION_NAME;
		configObj4.Name = REQUESTED_STATE;
        configObj4.Value__c = REQUESTED_STATE_VAL;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = APPLICATION_NAME;
		configObj5.Name = EDW_APPLICATION;
        configObj5.Value__c = EDW_APPLICATION_VAL;
        configObj5.Configuration_Group__c = IIR_CONFIGURATION_GROUP_VAL;
        configObj5.Value_Type__c = STRING_TYPE;
        configObj5.Active__c = true;

		// This should be ignored during processing because it is not part 
		// of the IIR_CONFIGURATION_GROUP_VAL configuration group.
        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
        configObj6.Application_Name__c = APPLICATION_NAME;
		configObj6.Name = ERP_APPLICATION;
        configObj6.Value__c = ERP_APPLICATION_VAL;
        configObj6.Value_Type__c = STRING_TYPE;
        configObj6.Active__c = true;

        mConfigList.add(configObj1);
        mConfigList.add(configObj2);
        mConfigList.add(configObj3);
        mConfigList.add(configObj4);
        mConfigList.add(configObj5);
        mConfigList.add(configObj6);
        
        return mConfigList;
        
    }
    
    /*
     * Insert configuration objects for the WTP test environment.  Test.startTest() and Test.stopTest()
     * must be invoked by the caller.
     */
    private static void setIIRConfiguration() {
        List<COH_App_Configuration__c> configList = getIIRConfiguration();
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
     * 
     */
    private static Attachment createAttachmentObject(Id parentObjectID, String attachmentName) {
        Attachment attachmentObj = new Attachment();
        attachmentObj.Body = Blob.valueOf('Now I know what you\'re thinking...');
        attachmentObj.Name = attachmentName;
        attachmentObj.ParentId = parentObjectID;   
        return attachmentObj;
    }
    
    
}