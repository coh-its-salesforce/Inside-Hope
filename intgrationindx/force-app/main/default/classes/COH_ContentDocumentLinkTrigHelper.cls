/************************************************************************************
 * @File Name.............:: ContentDocumentLinkTrigHelper
 * @Author................:: Sanjay Singh
 * @FileType..............:: Apex Class
 * @Description...........:: Helper class for trigger ContentDocumentLinkTrigger
 * **********************************************************************************
 * Version................:: 1.0
 * **********************************************************************************/
public without sharing class COH_ContentDocumentLinkTrigHelper {
    
    /**
     *@Description :: Logic to perform on after insert event of content document link,
     *                check Do_not_Include_in_Search__c to true if any content is associated to any object other than user and group.
     */
    public static void doAfterInsert(List<ContentDocumentLink> contentDocLink){
        Set<ID> contentVersionIDs = new Set<ID>();
        
        for(ContentDocumentLink cdl : contentDocLink){
            string recID = String.valueOf(cdl.LinkedEntityId).substring(0, 3);
            // Check if content is not associated to user -005 or group- 00G
            if(recID != '005' && recID != '00G' && recID != '058' && recID != null){// check keyprefix
                contentVersionIDs.add(cdl.ContentDocumentId);
            }
        }
        
        if(!contentVersionIDs.isEmpty()){
            
            List<ContentVersion> cvToUpdate = new List<ContentVersion>();
            // Query cotent version which needs to be updated
            for(contentVersion cv:[Select id, ContentDocumentID from ContentVersion Where ContentDocumentID in: contentVersionIDs] ){
                cv.Do_not_Include_in_Search__c = true;
                cvToUpdate.add(cv);
            }
            
            database.update(cvToUpdate);
        }
        
    }
    
    
    
}