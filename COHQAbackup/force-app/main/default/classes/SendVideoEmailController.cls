public class SendVideoEmailController {
    
    private static final string VIDEO_EMAIL_TEMPLATE_NAME = 'Send_Video_Email';
    
    @AuraEnabled
    public static void sendEmail(string accountId){
        Account data = [SELECT id,PersonContactId,PersonEmail,Email_Video_Sent__c FROM Account WHERE Id=:accountId];
        if(data.PersonEmail == '' || data.PersonEmail == null) throw new AuraHandledException('Email field value is required to send notifications via email.');
        EmailTemplate template = [SELECT Id, Name, DeveloperName, IsActive, Subject, HtmlValue, Body 
                                  FROM EmailTemplate Where DeveloperName =: VIDEO_EMAIL_TEMPLATE_NAME];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(data.PersonContactId); 
        message.setSenderDisplayName('City of Hopes'); 
        message.setUseSignature(false); 
        message.setBccSender(false); 
        message.setSaveAsActivity(true); 
        message.setTemplateID(template.Id); 
        message.setWhatId(accountId);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
        data.Email_Video_Sent__c = true;
        UPDATE data;
    }
}