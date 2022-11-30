public class AttachmentTriggerHelper{
         /**
    Method to send email to Visa Owner when File is uploaded to Visa record.
    **/
    public static void SendEmailToVisaOwner(List<Attachment> files) {
    string visaKeyPrefix = Visa__c.sobjecttype.getDescribe().getKeyPrefix();
    Set<id> visaIdSet = new Set<id> ();
    List<id> receipientIdList = new List<id> ();
    
    for(Attachment con: files){  
    if(string.valueof(con.Parentid).startsWith(visaKeyPrefix)){
    visaIdSet.add(con.ParentId);
    }
    }
    
        
        EmailTemplate et=[Select id from EmailTemplate where name = 'Immigration Services Approval email to Department' limit 1];
        Messaging.SingleEmailMessage mail;
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Visa__c v : [select id,Owner.Email from Visa__c where id IN:visaIdSet]){
            if(v.ownerId != null){
                mail = new Messaging.SingleEmailMessage();
                mail.SettoAddresses(new String[] {v.Owner.Email});
                mail.Setsubject( ' Courtesy alert - {!Visa__c.Proposed_Individual_First_Name__c} {!Visa__c.Proposed_Individual_Last_Name__c} has uploaded/modified visa record');  // modification
                mail.SetTemplateId(et.id);
                mail.setCcAddresses(new String[] {'internationalservices@coh.org'}); // modification
                mailList.add(mail);
            }
        }
        if(!Test.isRunningtest() && mailList.size()>0)
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);
    }
}