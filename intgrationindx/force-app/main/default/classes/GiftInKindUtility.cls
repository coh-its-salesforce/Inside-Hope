/* 
 * This class contains the methods for working on Attachments where the parent object is an 
 * instance of Gift_In_Kind__c.
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
public class GiftInKindUtility {
    private static final String GIFT_IN_KIND = 'Gift_In_Kind__c';
    private static String mGetGIKSoqlQuery = null;
    
    static {
        initialize();
    }

    /*
	 * Default constructor.
	 * 
	 */
    public GiftInKindUtility() {
    }
    
    /*
     * Initialization.
     * 
     */
    private static void initialize() {
        mGetGIKSoqlQuery = COHUtil.buildSelectAllSOQLStatement(GIFT_IN_KIND)
            + ' where Id in :keySet order by Id desc limit 1';
    }
    
    /*
     * Updates the contents of the AttachID__c field with the most ID of the 
     * most recent attachment.
     * 
     * @param	attachmentsList		List of Attachment objects to process.
     * 
     */
	public static void insertAttachmentIDField (List<Attachment> attachmentsList) {
        if (COHUtil.isValidList(attachmentsList)) {
            
            // Get a map of Parent ID to the Gift_in_Kind__c object
            Map<Id, Id> parentIDAttachmentIDMap = new Map<Id, Id>();

            // Map the parent to the Attachment Object
            for(Attachment attachmentObject : attachmentsList) {
                parentIDAttachmentIdMap.put(attachmentObject.ParentId, attachmentObject.Id);
            }
        
            // Retrieve all the parent objects.  Update the AttachID__c field 
            // with the value of the latest Attachment ID.
            Set<Id> keySet = parentIDAttachmentIDMap.keySet();
            if (!keySet.isEmpty()) {
                List<Gift_In_Kind__c> giftsInKindToUpdateList = new List<Gift_In_Kind__c>();
                List<Gift_In_Kind__c> giftsInKindList = Database.query(mGetGIKSoqlQuery);
                if (COHUtil.isValidList(giftsInKindList)) {
                    for (Gift_In_Kind__c gikObj : giftsInKindList) {
                        gikObj.AttachID__c = parentIDAttachmentIdMap.get(gikObj.Id);
                        giftsInKindToUpdateList.add(gikObj);
                    }
                    if (COHUtil.isValidList(giftsInKindToUpdateList)) {
		                Database.update(giftsInKindToUpdateList);
                    }
                }
            }
        }
    }
    
    /*
     * Update the AttachID__c field when an attachment is deleted.  If 
     * there are no other attachments, it is set to null.  Otherwise, it 
     * is set to the Attachement ID of the most recent remaining Attachment
     * 
     * @param attachmentsList	List of attachments to remove (Trigger.old).
     * 
     */
    
    public static void updateAttachmentIDField(List<Attachment> attachmentsList) {
        List<Gift_In_Kind__c> giftsInKindToUpdateList = new List<Gift_In_Kind__c>();
        List<Id> parentObjectIDsToProcess = new List<Id>();
        List<Id> attachmentsID = new List<Id>();
        Map<String, Id> parentAttachmentMap = new Map<String, ID>();
        
        if (COHUtil.isValidList(attachmentsList)) {

            // Identify the parent objects of the attachments to be deleted.
             
            for(Attachment attachmentObject : attachmentsList) {
                // exclude any non GIFT_IN_KIND objects
                Id parentID = attachmentObject.ParentId;
                String parentObjectName = COHUtil.getObjectName(parentID);
                if (parentObjectName.equalsIgnoreCase(GIFT_IN_KIND)) {
                    attachmentsID.add(attachmentObject.Id);
                    parentObjectIDsToProcess.add(parentID);
                    parentAttachmentMap.put(parentID, null);	// initialize the default value for the AttachID__c field
                }
            }
    
            // Check if the parent objects have any additional attachments.  
            
            List<Attachment> remainingAttachmentsList = [select Id, ParentId, CreatedDate from Attachment where Id not in :attachmentsID and ParentId in :parentObjectIDsToProcess order by ParentId asc, CreatedDate desc];
            if (COHUtil.isValidList(remainingAttachmentsList)) {
                String currentParentID = null;
                for (Attachment attachObj : remainingAttachmentsList) {
                    String newParentID = attachObj.ParentId;
                    if (!newParentID.equalsIgnoreCase(currentParentID)) {
                        // The parent object has additional attachments, so it
                        // retrieves the most recent one (ordered by descending CreatedDate)
                        parentAttachmentMap.put(newParentID, attachObj.Id);
                        currentParentID = newParentID;
                    }
                }
            }    
            
            // Get all Gift_In_Kind__c instances and update the AttachID__c field where needed
            giftsInKindToUpdateList = [select Id, AttachID__c from Gift_In_Kind__c where Id in :parentObjectIDsToProcess];
            if (COHUtil.isValidList(giftsInKindToUpdateList)) {
                for (Gift_In_Kind__c gikObj : giftsInKindToUpdateList) {
                    gikObj.AttachID__c = parentAttachmentMap.get(gikObj.Id);
                }
            }
            
            // Execute the bulk SOQL operations
            if (COHUtil.isValidList(giftsInKindToUpdateList)) {
                Database.update(giftsInKindToUpdateList);
            }

        }
        
    }
    
}