trigger AttachmentAI on Attachment (After insert) {
//COH_AllogeniecAndDeviationAttachmentUtil.SendEmailToVisaOwner(Trigger.new);
AttachmentTriggerHelper.SendEmailToVisaOwner(Trigger.new);
}