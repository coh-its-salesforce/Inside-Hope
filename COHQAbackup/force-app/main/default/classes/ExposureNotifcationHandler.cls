public class ExposureNotifcationHandler {
    
    public static void sendNotification(List<Id> recordIds,string templateId){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Work_place_exposure__c data:[SELECT Id,
                                         Employee__r.Email,
                                         Employee__r.Manager__c,
                                         Employee__r.ManagerId__r.Email  
                                         FROM Work_place_exposure__c WHERE Id IN:recordIds AND Employee__r.Email!=null])
        {
            List<String> ccEmails = new List<String>();
            List<String> toEmails = new List<String>();
            toEmails.add(data.Employee__r.Email);
            if(data.Employee__r?.Manager__c <> null) {
                ccEmails.add(data.Employee__r.ManagerId__r.Email);
            }
            mails.add(getEmailMessage(data.Id,templateId,toEmails,ccEmails));
        }
        if(!mails.isEmpty() && !Test.isRunningTest()) Messaging.sendEmail(mails);
    }
    
    static Messaging.SingleEmailMessage getEmailMessage(
        string targetObjectId,
        string templateId,
        List<String> toEmails,List<String> ccEmails)
    {
        
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, null, targetObjectId);
        mail.setToAddresses(toEmails);
        mail.setCcAddresses(ccEmails);
        mail.setSubject(mail.getSubject());
        mail.sethtmlBody(mail.gethtmlBody());
        mail.saveAsActivity = false;
        return mail;
    }
}