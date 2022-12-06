/* 
 * This class contains the methods for working on Attachments where the parent object is an instance of Lab_Results.
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
public class LABFileIDUtility {
    
    private static final String APPLICATION_NAME = 'Lab Results';
    private static final String CONFIGURATION_PROPERTY_NAME = 'Hyperlink Prefix';
    private static final String LAB_RESULTS = 'Lab_Results__c';
    private static String mHyperlinkPrefix;

    /*
     * Initialization.
     * 
     */
    static {
        initialize();
    }
    
	/*
	 * Default constructor.
	 * 
	 */
    public LABFileIDUtility() {
        initialize();
    }
    
    /*
     * Initialization.
     * 
     */
    private static void initialize() {
        mHyperlinkPrefix = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, CONFIGURATION_PROPERTY_NAME);
    }
    
    /*
     * Append the ID of the Attachment to a hyperlink and stores the hyperlink in the Lab_File__c field.
     * 
     * @param attachmentsList	List of attachments to add (Trigger.new).
     * 
     */
    public static void updateFileID(List<Attachment> attachmentsList) {
        
        List<Lab_Results__c> labResultsToUpdate = new List<Lab_Results__c>();
        Map<Id, String> parentObjectIDToHyperlinkMap = new Map<Id, String>();
        
        if (!COHUtil.isValidList(attachmentsList)) {
            return;
        }
        
        for(Attachment attachmentObject : attachmentsList) {
            // exclude any non LAB_RESULTS objects
            Id parentID = attachmentObject.ParentId;
            String parentObjectName = COHUtil.getObjectName(parentID);
            if (parentObjectName.equalsIgnoreCase(LAB_RESULTS)) {
                Id attachmentID = attachmentObject.Id;
                parentObjectIDToHyperlinkMap.put(parentID, mHyperlinkPrefix + attachmentID);
            }
        }
        
        // Execute the bulk SOQL operations
     
        if (!parentObjectIDToHyperlinkMap.isEmpty()) {
            Set<Id> parentIDs = parentObjectIDToHyperlinkMap.keySet();
            labResultsToUpdate = [select Id, File_ID__c from Lab_Results__c where Id in :parentIDs];
            if (COHUtil.isValidList(labResultsToUpdate))  {
                // Get the correct hyperlink for each parent object
                for (Lab_Results__c labResultObject : labResultsToUpdate) {
                    String hyperlink = parentObjectIDToHyperlinkMap.get(labResultObject.Id);
                    labResultObject.Lab_File__c = hyperlink;
                }
            }      
        }
        
        if (COHUtil.isValidList(labResultsToUpdate)) {
            upsert labResultsToUpdate;
        }
    
    }
    
    /*
     * Deletes the hyperlink in the Lab_File__c field.
     * 
     * @param attachmentsList	List of attachments to remove (Trigger.old).
     * 
     */
    
    public static void deleteFileID(List<Attachment> attachmentsList) {
        List<Lab_Results__c> labResultsToUpdate = new List<Lab_Results__c>();
        List<Id> parentObjectIDsToProcess = new List<Id>();
        List<Id> attachmentsID = new List<Id>();
        Map<String, Id> parentAttachmentMap = new Map<String, ID>();
        
        if (!COHUtil.isValidList(attachmentsList)) {
            return;
        }
        
        // Identify the parent objects of the attachments to be deleted.
         
        for(Attachment attachmentObject : attachmentsList) {
            // exclude any non LAB_RESULTS objects
            Id parentID = attachmentObject.ParentId;
            String parentObjectName = COHUtil.getObjectName(parentID);
            if (parentObjectName.equalsIgnoreCase(LAB_RESULTS)) {
                attachmentsID.add(attachmentObject.Id);
                parentObjectIDsToProcess.add(parentID);
	            parentAttachmentMap.put(parentID, null);	// initialize the default value for the hyperlink (null)
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
					// retrieves the first one (ordered by descending CreatedDate)
					// for later use as the hyperlink.
                    parentAttachmentMap.put(newParentID, attachObj.Id);
                    currentParentID = newParentID;
                }
            }
        }    
        
        // Get all Lab_Results__c instances 
        labResultsToUpdate = [select Id, Lab_File__c from Lab_Results__c where Id in :parentObjectIDsToProcess];
        if (COHUtil.isValidList(labResultsToUpdate)) {
            for (Lab_Results__c labResultObj : labResultsToUpdate) {
                // Get the Lab_Results__c instances that have more attachments and modify the hyperlink
                Id newAttachmentId = parentAttachmentMap.get(labResultObj.Id);
                if (COHUtil.isValidStr(newAttachmentId)) {
                    labResultObj.Lab_File__c = mHyperlinkPrefix + newAttachmentId;
                } else {
                    labResultObj.Lab_File__c = null;
                }
			}
        }
        
        // Execute the bulk SOQL operations
        if (COHUtil.isValidList(labResultsToUpdate)) {
            update labResultsToUpdate;
        }
    }

}