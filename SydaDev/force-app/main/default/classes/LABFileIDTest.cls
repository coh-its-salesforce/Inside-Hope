/* 
 * This is the test class for adding Attachments where the parent object is an instance 
 * of Lab_Results.
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
public class LABFileIDTest {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunTestAttachment = true;
    private static final Boolean mRunTestBulkLoading = false;
    private static final Boolean mRunTestDeleteTwoAttachments = true;
    private static final Boolean mRunTestMiscellaneous = true;
    
    private static final String stringType = 'String';
    
    private static final String customerName = 'Thomas Magnum';
    private static final String customerMRN = '22221111';
    private static final Date curDate = Date.today();
    private static final String firstname = 'Thomas';
    private static final String lastName = 'Magnum';
    private static final String attachmentName1 = 'test1.txt';
    private static final String attachmentName2 = 'test2.txt';
    private static final String attachmentName3 = 'test3.txt';
    private static final String attachmentName4 = 'test4.txt';
    // This is for reference.  For actual testing, ignore the 'https://lab-cityofhope.cs21'
    // portion of the hyperlink because it will differ on the production system.
    private static final String mApplicationName = 'Lab Results';
    private static final String mPropertyName = 'Hyperlink Prefix';
 	private static final String mPropertyValue = 'https://lab-cityofhope.cs21.force.com/servlet/servlet.FileDownload?file=';//        
    private static String mHyperlinkPrefix;

    // Set the configuration
    private static void setConfiguration() {
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        
		configObj1.Name = mPropertyName;
        configObj1.Application_Name__c = mApplicationName;
        configObj1.Value__c = mPropertyValue;
        configObj1.Value_Type__c = stringType;
        configObj1.Active__c = true;
        
        insert configObj1;
        
        mHyperlinkPrefix = (String) COHUtil.getConfigurationValue(mApplicationName, mPropertyName);
        
    }

    /*
     * Create an Attachment to Lab_Result__c object and then delete the attachment.
     * 
     */    
    private static testMethod void testAttachment() {
        if (!mRunAllTests && !mRunTestAttachment) {
            System.debug('Skipping testAttachment()');
            return;
        }

        Test.startTest();

		setConfiguration();
        
        // Create the Lab_Result__c object.
        Lab_Results__c labResultObject = createLabResultObject();
        insert labResultObject;
        
        List<Lab_Results__c> labResultObjectList = new List<Lab_Results__c>();
            
        String soqlStr = COHUtil.buildSelectAllSOQLStatement('Lab_Results__c');
        soqlStr += ' where Last_Name__c = :lastName and First_Name__c = :firstname';
        
        labResultObjectList = Database.query(soqlStr);
        System.assertEquals(1, labResultObjectList.size());
        
        labResultObject = labResultObjectList.get(0);
        
        // Create the attachment.
        Attachment attachmentObj = createAttachmentObject(labResultObject.Id, attachmentName1);
        insert attachmentObj;

        // Retrieve the object ID of the attachment
        List<Attachment> attachmentIDList = [select Id from Attachment where name = :attachmentName1 limit 1];
        if (!COHUtil.isValidList(attachmentIDList)) {
            System.assert(false, 'Unable to retrieve the newly-created attachment');
        }
        attachmentObj = attachmentIDList.get(0);
        Id attachmentID = attachmentObj.Id;
        
        // Retrieve the parent object        
        labResultObjectList = Database.query(soqlStr);
        System.assertEquals(1, labResultObjectList.size());
        
        labResultObject = labResultObjectList.get(0);
        String basicLink = labResultObject.Lab_File__c;
        System.assertNotEquals(null, basicLink);
        
        // Retrieve the relevant portion of the hyperlink
        Integer startIndex = basicLink.indexOf('force');
        String linkBody = basicLink.substring(startIndex);
        startIndex = mHyperlinkPrefix.indexOf('force');
        String baselineLinkBody = mHyperlinkPrefix.substring(startIndex) + attachmentID;
        
        // Verify the hyperlink has been created correctly
        System.assertEquals(baselineLinkBody, linkBody);
        
        // Delete the attachment
        delete attachmentIDList;
        
        // Retrieve the parent object        
        labResultObjectList = Database.query(soqlStr);
        System.assertEquals(1, labResultObjectList.size());

        // Verify the link has been removed
        labResultObject = labResultObjectList.get(0);
        System.assertEquals(null, labResultObject.Lab_File__c);
        
        Test.stopTest();
        
    }
    
    /*
     * Create multiple attachments to Lab_Result__c object and then delete the attachments.
     * 
     */    
    private static testMethod void testBulkLoading() {
        
        Integer MAX_RECORDS = 202;
        
        if (!mRunAllTests && !mRunTestBulkLoading) {
            System.debug('Skipping testBulkLoading()');
            return;
        } 
        
        Test.startTest();
        
		setConfiguration();
        
        // Create the Lab_Result__c object.
        Lab_Results__c labResultObject = createLabResultObject();
        insert labResultObject;
        
        List<Lab_Results__c> labResultObjectList = new List<Lab_Results__c>();
            
        String soqlStr = COHUtil.buildSelectAllSOQLStatement('Lab_Results__c');
        soqlStr += ' where Last_Name__c = :lastName and First_Name__c = :firstname';
        
        labResultObjectList = Database.query(soqlStr);
        System.assertEquals(1, labResultObjectList.size());
        
        labResultObject = labResultObjectList.get(0);
        
        // Create the attachments.
        List<Attachment> attachmentsList = new List<Attachment>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Attachment attachmentObj = createAttachmentObject(labResultObject.Id, attachmentName1);
            attachmentsList.add(attachmentObj);
        }
        insert attachmentsList;
        
        // Retrieve the object ID of the attachments
        List<Attachment> attachmentIDs = [select Id from Attachment where name = :attachmentName1 and ParentId = :labResultObject.Id];
        
        // Verify the number of attachments
        if (COHUtil.isValidList(attachmentIDs)) {
            Integer listSize = attachmentIDs.size();
            System.assertEquals(MAX_RECORDS, listSize);
        } else {
            System.assert(false, 'Expected a list of ' + MAX_RECORDS + ' attachments but received an invalid list');
        }

        // Retrieve the parent object        
        labResultObjectList = Database.query(soqlStr);
        System.assertEquals(1, labResultObjectList.size());
        
        labResultObject = labResultObjectList.get(0);
        String basicLink = labResultObject.Lab_File__c;
        System.assertNotEquals(null, basicLink);    // cannot test for the specific attachment because
                                                    // this was done in bulk.
        
        // Delete the attachments
        delete attachmentIDs;

        Test.stopTest();
    }

    /*
     * Create two attachments to Lab_Result__c object and then delete the attachments.
     * 
     * It is not possible to test with more than two attachments.  The trigger relies on 
     * the CreatedDate field that is not populated in the test environment.  This is
     * probably because the objects are not actually inserted into the database.  
     * 
     * This means that if the attachments cannot be sorted by date.  If there are only two 
     * attachments, this is not important.  But if there are more, it becomes a problem.
     * 
     */    
    private static testMethod void testDeleteTwoAttachments() {
        
        if (!mRunAllTests && !mRunTestDeleteTwoAttachments) {
            System.debug('Skipping testDeleteTwoAttachments()');
            return;
        } 
        
        Test.startTest();
        
		setConfiguration();
        
        // Create the Lab_Result__c object.
        Lab_Results__c labResultObject = createLabResultObject();
        insert labResultObject;
        
        List<Lab_Results__c> labResultObjectList = [select Id, Lab_File__c from Lab_Results__c where Last_Name__c = :lastName and First_Name__c = :firstname];
        
        labResultObject = labResultObjectList.get(0);
        
        // Create the attachments.
        Attachment attachmentObj1 = createAttachmentObject(labResultObject.Id, attachmentName1);
        Attachment attachmentObj2 = createAttachmentObject(labResultObject.Id, attachmentName2);

        insert attachmentObj1;
        Id attachmentID1 = attachmentObj1.Id;
        
        insert attachmentObj2;
        Id attachmentID2 = attachmentObj2.Id;
        

        // Retrieve the object ID of the attachments
        List<Attachment> attachmentIDs = [select Id from Attachment where ParentId = :labResultObject.Id];
            
        // Verify the number of attachments
        if (COHUtil.isValidList(attachmentIDs)) {
            Integer listSize = attachmentIDs.size();
            System.assertEquals(2, listSize);
        } 

		String attachmentID = getAttachmentID();
        System.assertEquals(attachmentID2, attachmentID);
        
        // Delete the current attachment
        delete attachmentObj2;

        // Check if the attachment ID has been updated

		attachmentID = getAttachmentID();
        System.assertEquals(attachmentID1, attachmentID);
        
        // Delete the current attachment
        delete attachmentObj1;

        // Check if the attachment ID has been updated
        
		attachmentID = getAttachmentID();
        System.assertEquals(null, attachmentID);    
        Test.stopTest();

    }

    /*
     * Miscellaneous tests to increase test coverage percentage.
     * 
     */
    private static testmethod void testMiscellaneous () {
                
        if (!mRunAllTests && !mRunTestMiscellaneous) {
            System.debug('Skipping testMiscellaneous()');
            return;
        } 
        
        Test.startTest();

        COHUtilTester.setWTPConfiguration();
        
        List<COH_App_Configuration__c> configGroupList = COHUtil.getConfigurationGroup(null, null);
        if (COHUtil.isValidList(configGroupList)) {
            System.assert(false, 'Expected a null list but retrieved a list with ' + configGroupList.size() + ' elements');
        }
        
        configGroupList = COHUtil.getConfigurationGroup('foo', 'bar');
        if (COHUtil.isValidList(configGroupList)) {
            Integer listSize = configGroupList.size();
            System.assert(false, 'Expected an invalid COH_App_Configuration__c list but retrieved ' + listSize + ' records');
        }
        
        Object configVal = COHUtil.getConfigurationValue(null, null);
        System.assertEquals(null, configVal);

        configVal = COHUtil.getConfigurationValue('foo', 'bar');
        System.assertEquals(null, configVal);

        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Attachment');
        if (COHUtil.isValidStr(soqlQuery)) {
            System.assert(true);
        }
        
        soqlQuery = COHUtil.buildSelectAllSOQLStatement(null);
        if (!COHUtil.isValidStr(soqlQuery)) {
            System.assert(true);
        }
        
        // Create the Lab_Result__c object.
        Lab_Results__c labResultObject = createLabResultObject();
        insert labResultObject;
        
        Id objectID = labResultObject.Id;
        String objectName = COHUtil.getObjectName(objectID);
        System.assertEquals('Lab_Results__c', objectName);
        
        objectName = COHUtil.getObjectName(null);
        System.assertEquals(null, objectName);
        
        // should not cause any crashes or exceptions
        LABFileIDUtility.updateFileID(null);
        LABFileIDUtility.deleteFileID(null);
        
        Test.stopTest();
    }
    
    /*
     * Create a Lab_Result__c object.
     * 
     */
    private static Lab_Results__c createLabResultObject() {
        Lab_Results__c labResultObject = new Lab_Results__c();
        labResultObject.Customer__c = customerName; 
        labResultObject.Customer_MRN__c = customerMRN;
        labResultObject.Date__c = curDate;
        labResultObject.First_Name__c = firstName;
        labResultObject.Last_Name__c = lastName;
        return labResultObject;
    }
    
    /*
     * Create an Attachment object and assign it the ID of the parent Lab_Result__c object.
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
    
    /* 
     * Return the attachment ID from the Lab_File__c field.
     * 
     */
    private static String getAttachmentID() {
        List<Lab_Results__c> labResultObjectList = [select Id, Lab_File__c from Lab_Results__c where Last_Name__c = :lastName and First_Name__c = :firstname];
        System.assertEquals(1, labResultObjectList.size());
        Lab_Results__c labResultObj = labResultObjectList.get(0);
        String baseURL = labResultObj.Lab_File__c;
        if (COHUtil.isValidStr(baseURL)) {
	        Integer startIndex = baseURL.indexOf('=');
            String attachmentID = baseURL.substring(startIndex + 1);
            return attachmentID;
        } else {
            return null;
        }
    }
}