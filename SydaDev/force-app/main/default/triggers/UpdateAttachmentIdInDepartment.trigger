/*
*   Date: 28-Aug-2015
*   Desc: Created new trigger to update image attachement id in department detail page
*/
trigger UpdateAttachmentIdInDepartment on Attachment (after insert, after update, after delete) {
  Set<Id> depIds = new Set<Id>();
  Set<Id> newsAnnouncementIds = new Set<Id>();
    List<Attachment> lstAttachment = trigger.new;
    if(Trigger.isDelete) {
      lstAttachment = trigger.old;
    } 
    for(Attachment att : lstAttachment) {
      system.debug('att.ParentId : '+att.ParentId);
      if(att.ParentId != null) {
        if(String.valueOf(att.ParentId).startsWith(Label.Department_Object_Id)) {
            depIds.add(att.ParentId);
        } else if(String.valueOf(att.ParentId).startsWith(Label.NewsAnnouncement_Id)) {
          newsAnnouncementIds.add(att.ParentId);
        }
      }
    }  
    system.debug('depIds : '+depIds);
    if(!depIds.isEmpty()) {
      Map<Id, Department__c> mapDept = new Map<Id, Department__c>([Select Id, Image_Attachment_Id__c, (Select Id from Attachments order by LastModifiedDate DESC limit 1) from Department__c where Id IN :depIds]);
    for(Department__c dep : mapDept.values()) {
        if(!dep.Attachments.isEmpty()) {
          dep.Image_Attachment_Id__c = dep.Attachments[0].Id; 
        } else {
          dep.Image_Attachment_Id__c = null;
        }      
      }  
    update mapDept.values();
    
    }
    
    if(!newsAnnouncementIds.isEmpty()) {
      Map<Id, COH_SI_NewsandAnnouncement__c> mapNewsAnnouncement = new Map<Id, COH_SI_NewsandAnnouncement__c>([Select Id, Image_Attachment_Id__c, (Select Id from Attachments order by LastModifiedDate DESC limit 1) from COH_SI_NewsandAnnouncement__c where Id IN :newsAnnouncementIds]);
    for(COH_SI_NewsandAnnouncement__c na : mapNewsAnnouncement.values()) {
        if(!na.Attachments.isEmpty()) {
          na.Image_Attachment_Id__c = na.Attachments[0].Id; 
        } else {
          na.Image_Attachment_Id__c = null;
        }      
      }  
    update mapNewsAnnouncement.values();
    }
}