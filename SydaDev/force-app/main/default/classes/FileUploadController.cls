/**
 * Descripción: This class contains RemoteAction methods for File Upload
 */
global with sharing class FileUploadController {
    /*
    Description: Method to create an attachment.
    Parameters:
        parentId: The sfdc object Id this file will be attached to
        attachmentId: The record of the current Attachment file being processed
        fileName: Name of the attachment
        contentTye: Content Type of the file being attached
        base64BlobValue: Base64 encoded string of the file piece currently processing
    */    
    @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
        //If recordId is blank this is the first part of a multi piece upload
        system.debug('===attachmentId ==='+attachmentId );
        List<attachment> attList = new List<attachment>();
        string retId = '';
        if(attachmentId != null && attachmentId != ''){
            attList = [Select id, Name, ParentID, Body From attachment where id=: attachmentId limit 1];
            if(attList != null && attList.size()  >0 ){
                update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(base64BlobValue));
                retId = attachmentId ;
            }else{
                Id aid = insertAttach(parentId, attachmentId, contentType,base64BlobValue);
               //Return the new attachment Id
                retId = aid ;
            }
        }
        else{
            Id aid = insertAttach(parentId, attachmentId, contentType,base64BlobValue);
            //Return the new attachment Id
            retId = aid ;
        }
        update new contact(id=parentId, Image_URL__c=retId  );
        return retId ;
    }
    
    public static id insertAttach(String parentId, String attachmentId, String contentType, String base64BlobValue){
        Attachment att = new Attachment(
                ParentId = parentId,
                Body = EncodingUtil.Base64Decode(base64BlobValue),
                Name = 'ProfilePic.jpg',
                ContentType = contentType
            );
            insert att;
        return att.id;
    }
    
    /*
    Description: Method to delete un attachment.
    Parameters:
        attachmentId: The record of the current Attachment file to delete
    */
    @RemoteAction
    global static void deleteAttachment(String attachmentId){
        //Delete the attachment
        delete new Attachment(Id = attachmentId);
    }
}