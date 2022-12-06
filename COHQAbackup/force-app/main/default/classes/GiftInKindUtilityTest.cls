/*
 * This test class verifies that the GiftInKindUtility class is 
 * working correctly
 *  
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class GiftInKindUtilityTest {
    
    private static final Boolean mRunAllTests = true;
    private static final Boolean mRunVerifyAttachmentAssignment = false;   
    private static final Boolean mRunVerifyAttachmentAssignmentBulk = false;   
    private static final Boolean mRunVerifyTriggerLimits = false;

    // test constants
	
    private static final String ARTIST_NAME0 = 'Charles Shultz';
    private static final String ARTIST_NAME1 = 'Vincent Van Gogh';
    private static final String COMMENTS = 'Likes Peanuts';
    private static final String DIMENSIONS = '7x9x11';
    private static final String DISPOSITION = 'Sold off';
    private static final Date DONATION_DATE = Date.today();
    private static final Integer FAIR_MARKET_VALUE = 100;
    private static final String IDONORS = 'Charlie Brown';
    private static final Date INVENTORY_DATE = Date.today();
    private static final String ITEM_CATEGORY = 'Personal Property and Toys';
    private static final String ITEM_DESCRIPTION = 'Lunch box';
    private static final String ITEM_NAME = 'Charlie Brown Lunch Box';
    private static final String LOCATION = 'Petaluma';
    private static final String PRINT_NUMBER = '332211';
    private static final String RESTRICTIONS = 'Don\'t pull the football';
    private static final Integer SOLD_AMOUNT = 200;
    private static final Date SOLD_DATE = Date.today();
    private static final String SOLD_TO = 'Snoopy';
    
    private static final Integer MAX_RECORDS = 202;
    
    /*
     * Verifies that Attachment ID assignment worked  
     * 
     */
    private static testMethod void verifyAttachmentAssignment() {
        if (!mRunAllTests && !mRunVerifyAttachmentAssignment) {
            System.debug('Skipping verifyAttachmentAssignment()');
            return;
        }
        
        test.startTest();

		Gift_In_Kind__c gikOjb0 = new Gift_In_Kind__c();
        gikOjb0.Artist_Name__c = ARTIST_NAME0;
		gikOjb0.Comments__c = COMMENTS;
        gikOjb0.Dimensions__c = DIMENSIONS;
        gikOjb0.Disposition_of_the_items__c = DISPOSITION;
        gikOjb0.Donation_Date__c = DONATION_DATE;
        gikOjb0.Fair_Market_Value__c = FAIR_MARKET_VALUE;
        gikOjb0.IDonors__c = IDONORS;
        gikOjb0.Inventory_date_of_fixed_assets__c = INVENTORY_DATE;
		gikOjb0.Item_Category__c = ITEM_CATEGORY;
        gikOjb0.Item_Description__c = ITEM_DESCRIPTION;
        gikOjb0.Item_Name__c = ITEM_NAME;
        gikOjb0.Location__c = LOCATION;
        gikOjb0.Print_Number__c = PRINT_NUMBER;
        gikOjb0.Restrictions__c = RESTRICTIONS;
        gikOjb0.Sold_Amount__c = SOLD_AMOUNT;
        gikOjb0.Sold_Date__c = SOLD_DATE;
        gikOjb0.Sold_To__c = SOLD_TO;
		 
        Database.insert(gikOjb0);
        
        Attachment attachmentObj0 = createAttachmentObject(gikOjb0.Id, 'test attachment1');
		insert attachmentObj0;
        Id attachmentID0 = attachmentObj0.Id;
        
		Gift_In_Kind__c gikOjb1 = new Gift_In_Kind__c();
        gikOjb1.Artist_Name__c = ARTIST_NAME1;
		gikOjb1.Comments__c = COMMENTS;
        gikOjb1.Dimensions__c = DIMENSIONS;
        gikOjb1.Disposition_of_the_items__c = DISPOSITION;
        gikOjb1.Donation_Date__c = DONATION_DATE;
        gikOjb1.Fair_Market_Value__c = FAIR_MARKET_VALUE;
        gikOjb1.IDonors__c = IDONORS;
        gikOjb1.Inventory_date_of_fixed_assets__c = INVENTORY_DATE;
		gikOjb1.Item_Category__c = ITEM_CATEGORY;
        gikOjb1.Item_Description__c = ITEM_DESCRIPTION;
        gikOjb1.Item_Name__c = ITEM_NAME;
        gikOjb1.Location__c = LOCATION;
        gikOjb1.Print_Number__c = PRINT_NUMBER;
        gikOjb1.Restrictions__c = RESTRICTIONS;
        gikOjb1.Sold_Amount__c = SOLD_AMOUNT;
        gikOjb1.Sold_Date__c = SOLD_DATE;
        gikOjb1.Sold_To__c = SOLD_TO;
		 
        Database.insert(gikOjb1);

        Id parentID = gikOjb0.Id;
        
        List<Attachment> attachmentObjList = [select Id from Attachment where ParentId = :parentID];
		System.assertEquals(1, attachmentObjList.size());
        Gift_In_Kind__c updatedGikObj0 = [select Id, AttachID__c from Gift_In_Kind__c where Id = :parentID limit 1];
        System.assertEquals(attachmentID0, updatedGikObj0.AttachID__c);

        
        // No attachments should have been made
        
        parentID = gikOjb1.Id;
        attachmentObjList = [select Id from Attachment where ParentId = :parentID];
        if (COHUtil.isValidList(attachmentObjList)) {
            System.assert(false, 'Expected zero attachments but retrieved ' + attachmentObjList.size());
        }
        
        // Create two attachments.  Verify the latest one is correct.  Delete it.
        // Verify that the second one is correct.  Delete it.
        // Verify the AttachID__c field is null

        Attachment attachmentObj1 = createAttachmentObject(gikOjb1.Id, 'test attachment2');
		insert attachmentObj1;
        Id attachmentID1 = attachmentObj1.Id;
        Attachment attachmentObj2 = createAttachmentObject(gikOjb1.Id, 'test attachment3');
		insert attachmentObj2;
        Id attachmentID2 = attachmentObj2.Id;

        parentID = gikOjb1.Id;
        
        attachmentObjList = [select Id from Attachment where ParentId = :parentID];
		System.assertEquals(2, attachmentObjList.size());
        Gift_In_Kind__c updatedGikObj1 = [select Id, AttachID__c from Gift_In_Kind__c where Id = :parentID limit 1];
        System.assertEquals(attachmentID2, updatedGikObj1.AttachID__c);

        // Delete attachmentObj2.  Now, the value of AttachID__c field should be attachmentObj1.ID. 

        Database.delete(attachmentID2);
        attachmentObjList = [select Id from Attachment where ParentId = :parentID];
		System.assertEquals(1, attachmentObjList.size());
        updatedGikObj1 = [select Id, AttachID__c from Gift_In_Kind__c where Id = :parentID limit 1];
        System.assertEquals(attachmentID1, updatedGikObj1.AttachID__c);
        
        // Delete attachmentObj1.  Now, the value of AttachID__c field should be null.

        Database.delete(attachmentID1);
        attachmentObjList = [select Id from Attachment where ParentId = :parentID];
		System.assertEquals(0, attachmentObjList.size());
        updatedGikObj1 = [select Id, AttachID__c from Gift_In_Kind__c where Id = :parentID limit 1];
        System.assertEquals(null, updatedGikObj1.AttachID__c);
        
        
        test.stopTest();
    }

    /*
     * Verifies that the trigger limits.  
     * 
     */
    private static testMethod void verifyTriggerLimits() {
        if (!mRunAllTests && !mRunVerifyTriggerLimits) {
            System.debug('Skipping verifyTriggerLimits()');
            return;
        }
        
        test.startTest();
        
		Gift_In_Kind__c gikOjb0 = new Gift_In_Kind__c();
        gikOjb0.Artist_Name__c = ARTIST_NAME0;
		gikOjb0.Comments__c = COMMENTS;
        gikOjb0.Dimensions__c = DIMENSIONS;
        gikOjb0.Disposition_of_the_items__c = DISPOSITION;
        gikOjb0.Donation_Date__c = DONATION_DATE;
        gikOjb0.Fair_Market_Value__c = FAIR_MARKET_VALUE;
        gikOjb0.IDonors__c = IDONORS;
        gikOjb0.Inventory_date_of_fixed_assets__c = INVENTORY_DATE;
		gikOjb0.Item_Category__c = ITEM_CATEGORY;
        gikOjb0.Item_Description__c = ITEM_DESCRIPTION;
        gikOjb0.Item_Name__c = ITEM_NAME;
        gikOjb0.Location__c = LOCATION;
        gikOjb0.Print_Number__c = PRINT_NUMBER;
        gikOjb0.Restrictions__c = RESTRICTIONS;
        gikOjb0.Sold_Amount__c = SOLD_AMOUNT;
        gikOjb0.Sold_Date__c = SOLD_DATE;
        gikOjb0.Sold_To__c = SOLD_TO;
		 
        Database.insert(gikOjb0);
        Id parentID = gikOjb0.Id;
        
        Attachment attachmentObj0 = createAttachmentObject(gikOjb0.Id, 'test attachment1');
        List<Attachment> attachmentObjectList = new List<Attachment>();
        for (Integer i = 0 ; i < MAX_RECORDS; i++) {
            String uniqueID = COHUtil.generateNumberString(i);
            Attachment attachmentObj = createAttachmentObject(parentID, 'test attachment' + uniqueID);
            attachmentObjectList.add(attachmentObj);
        }
        Database.insert(attachmentObjectList);

        Attachment attachmentObj = attachmentObjectList.get(MAX_RECORDS - 1);
        Id mostRecentAttachmentID = attachmentObj.Id;
        
        Gift_In_Kind__c updatedGikObj0 = [select Id, AttachID__c from Gift_In_Kind__c where Id = :parentID limit 1];
        System.assertEquals(mostRecentAttachmentID, updatedGikObj0.AttachID__c);
        
        test.stopTest();
        
    }
    
    /*
     * Create an Attachment object and assign it the ID of the parent object.
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