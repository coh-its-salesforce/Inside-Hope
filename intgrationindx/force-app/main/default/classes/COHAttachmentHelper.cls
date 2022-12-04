/*
 * This class contains the methods for handling trigger events for Attachment objects.
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
public class COHAttachmentHelper {
    /*
     * This method handles all trigger calls for the Attachment object.
     * 
     */
    private static final String ITS_INTAKE_REQUEST = 'ITS_Project_Request__c';
    private static final String LAB_RESULT = 'Lab_Results__c';
    private static final String GIFT_IN_KIND = 'Gift_In_Kind__c';
    private static final String CASE_OBJ = 'Case';
    private static final String ACCOUNT = 'Account';
    // Changes By Sanjay Singh 10/05/2017 
    private static final String DEVIATION = 'Deviations__c'; 
    private static final String SECOND_ALLOGENIC_REQUEST = 'Second_Allogeneic_Request__c';    
    
    private static final Integer TRIGGER_NEW = 0;
    private static final Integer TRIGGER_OLD = 1;
    
    /*
     * Process Attachment objects.
     * 
     */
    public static void processAttachments() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isInsert) {
                // ITS Intake Request                    
                List<Attachment> IIRAttachmentObjList = getAttachments(ITS_INTAKE_REQUEST, TRIGGER_NEW);
                if (COHUtil.isValidList(IIRAttachmentObjList)) {
                    IIRUtility.processIIRAttachments(IIRAttachmentObjList);
                }
                
                // Lab File 
                List<Attachment> labAttachmentObjList = getAttachments(LAB_RESULT, TRIGGER_NEW);
                if (COHUtil.isValidList(labAttachmentObjList)) {
                    // Update the Lab Result object with the newly-constructed hyperlink.
                    LABFileIDUtility.updateFileID(labAttachmentObjList);
                }
                
                // Gifts in Kind
                List<Attachment> giftInKindAttachmentObjList = getAttachments(GIFT_IN_KIND, TRIGGER_NEW);
                if (COHUtil.isValidList(giftInKindAttachmentObjList)) {
                    GiftInKindUtility.insertAttachmentIDField(giftInKindAttachmentObjList);
                }
                
                // Cases--death certificate 
                List<Attachment> caseAttachmentList = getAttachments(CASE_OBJ, TRIGGER_NEW);
                if (COHUtil.isValidList(caseAttachmentList)) {
                    COHAttachmentUtility.processCaseAttachments(caseAttachmentList);
                }
                
                                             
                // DEVIATION Attachments - Abhishek 05/31/2017
                List<Attachment> DeviationAttachmentList = getAttachments(DEVIATION, TRIGGER_NEW);
                if (COHUtil.isValidList(DeviationAttachmentList)) {
                    COH_AllogeniecAndDeviationAttachmentUtil.processDeviationAttachments(DeviationAttachmentList);
                }
                
                //Changes By Sanjay 10/26/2017 
                // Second Allogenic Request Attachments
                List<Attachment> secondAllogenicReqAttachmentList = getAttachments(SECOND_ALLOGENIC_REQUEST, TRIGGER_NEW);
                if(COHUtil.isValidList(secondAllogenicReqAttachmentList)){
                    COH_AllogeniecAndDeviationAttachmentUtil.processSecondAllogenicReqAttachmets(secondAllogenicReqAttachmentList);
                }
                
                // Accounts
                
                List<Attachment> accountAttachmentList = getAttachments(ACCOUNT, TRIGGER_NEW);
                if (COHUtil.isValidList(accountAttachmentList)) {
                   COHAttachmentUtility.processAccountAttachments(accountAttachmentList); 
                }              
                               
            } else if (Trigger.isBefore && Trigger.isDelete) {
                List<Attachment> labAttachmentObjList = getAttachments(LAB_RESULT, TRIGGER_OLD);
                if (COHUtil.isValidList(labAttachmentObjList)) {
                    // Update the Lab Result object with the newly-constructed hyperlink.
                    LABFileIDUtility.deleteFileID(labAttachmentObjList);    
                }

                List<Attachment> giftInKindAttachmentObjList = getAttachments(GIFT_IN_KIND, TRIGGER_OLD);
                if (COHUtil.isValidList(giftInKindAttachmentObjList)) {
                    GiftInKindUtility.updateAttachmentIDField(giftInKindAttachmentObjList);
                }
                
            } 
        }
    }
    
    
    
    /*
     * Creates a list of attachments where the parent has a specific name
     * from the appropriate trigger objects.
     * 
     * @param parentObjectName  Name of parent object.
     * @param triggerType       Type of trigger.
     * @return                  List of attachments for the object and trigger type.
     * 
     */
    private static List<Attachment> getAttachments(String parentObjectName, Integer triggerType) {
        List<Attachment> attachmentObjList = null;
        if (COHUtil.isValidStr(parentObjectName)) {
            attachmentObjList = new List<Attachment>();
            List<Attachment> attachmentObjSourceList;
            if (triggerType == TRIGGER_NEW) {
                attachmentObjSourceList = (List<Attachment>) Trigger.new;
            } else if (triggerType == TRIGGER_OLD) {
                attachmentObjSourceList = (List<Attachment>) Trigger.old;
            } else {
                throw new COHException('Unknown triggerType encountered in COHAttachmentHelper: ' + triggerType + ', parentObjectName: ' + parentObjectName);
            }
            
            for(Attachment attachmentObject : attachmentObjSourceList) {
                Id parentID = attachmentObject.ParentId;
                String currentParentObjectName = COHUtil.getObjectName(parentID);
                if (parentObjectName.equalsIgnoreCase(currentParentObjectName)) {
                    attachmentObjList.add(attachmentObject);
                }
            }
        }
        return attachmentObjList;
    }
}