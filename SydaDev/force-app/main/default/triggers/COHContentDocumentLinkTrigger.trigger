trigger COHContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
  system.debug('-----Trigger---called----');
   COH_AllogeniecAndDeviationAttachmentUtil.processSecondAllogenicReqContent(trigger.New);
   
    if(trigger.isInsert & trigger.isAfter){
        
        COH_ContentDocumentLinkTrigHelper.doAfterInsert(Trigger.New);
       // COH_AllogeniecAndDeviationAttachmentUtil.SendEmailToVisaOwner(Trigger.new);
    }
}