global class COH_EmailRAtoManager{
    static List<Contact_Trace_Loader__c> contactTrace =new List<Contact_Trace_Loader__c>();
    
    static List<Contact_Trace_Loader__c> contactTraceList =new List<Contact_Trace_Loader__c>();
    public Id contactId {get;set;}
    public String conManagerEmail {set;get;}
    global static List<Id> selectedIds = new  List<Id>();
    webservice static void sendEmailtoManager(List<Id> emprec){
        Set<String> toAddress=new set<String>();
        selectedIds.addAll(emprec);
        set<String> managerEmails = new set<String>();
        contactTrace=[select id,Manager_Email__c,Send_Risk_Assessment_to_Manager__c,Employee_Name__c,Last_Exposure_Date__c from Contact_Trace_Loader__c where Id IN:emprec];
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Risk Assessment Request email'];
		OrgWideEmailAddress[] owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='Infection Prevention'];
		System.debug('owea===>'+owea);
        Infection_Prevention_Email__mdt infectionPrevention = [SELECT Id, Label, Email_CC__c FROM Infection_Prevention_Email__mdt limit 1];
        System.debug('inPre==>'+infectionPrevention);
        List<String> ccEmailsList = infectionPrevention.Email_CC__c.split(',');
        System.debug('ccemailsList==>'+ccEmailsList);
        System.debug('ccemailsList=size=>'+ccEmailsList.size());
        Messaging.SingleEmailMessage[] allMails = new List<Messaging.SingleEmailMessage>();
        List<string> ctlToUpdate=new List<string>();
        for(Contact_Trace_Loader__c con:contactTrace){

            System.debug('con.Manager_Email__c--->'+con.Manager_Email__c);
            System.debug('managerEmails--->'+managerEmails);
            if(!managerEmails.contains(con.Manager_Email__c)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                System.debug('con---'+con.Id);
                message.setWhatId(con.Id); 
                managerEmails.add(con.Manager_Email__c);
             	set<String> toemail=new set<String>();
              	toemail.add(con.Manager_Email__c);
                message.setTemplateID(emailTemplate.Id);
               	message.toAddresses = new String[] {con.Manager_Email__c};
                message.setTargetObjectId(UserInfo.getUserId());
                //message.setSenderDisplayName('Company Support'); 
                //message.setReplyTo('no-reply@COH.com');
                if(owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea[0].Id);
                }
                if(ccEmailsList.size() > 0){
                    message.setCcAddresses(ccEmailsList);
                }
               /* String[] ccAddresses = new String[] {'no-reply@COH.com','Donot-reply@coh.com'};
            	message.setccAddresses(ccAddresses); */
                message.setUseSignature(false); 
                message.setBccSender(false);
                message.setTreatTargetObjectAsRecipient(false);
                message.setSaveAsActivity(false);
                allMails.add(message);
            }
           
        }
        System.debug('allMails----->'+allMails);
        System.debug('allMails---size-->'+allMails.Size());
        System.debug('managerEmails--size--->'+managerEmails.Size());
        System.debug('managerEmails----->'+managerEmails);
    // System.debug('allMails---0-->'+allMails[0]);
        //System.debug('allMails-1---->'+allMails[1]);
        //Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {allMails};
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
     try{    
         Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
        if (results[0].success) 
        {
            System.debug('results[0]+'+results[0]);
            System.debug('The email was sent successfully.');
            for(String managerEmail:managerEmails){
                ctlToUpdate.add(managerEmail);
            }
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
     }
    
    catch(Exception e){
        System.debug('e.==>'+e.getMessage());
    }
        
        
        
        for(String managerEmail:toAddress){
            //message.toAddresses = new String[] {managerEmail};
            //message.setToAddresses(toAddress);
        }
        List<Contact_Trace_Loader__c> updaterecs=new List<Contact_Trace_Loader__c>();
        
        if(ctlToUpdate.size()>0){
            for(Contact_Trace_Loader__c ct:[select id,Send_Risk_Assessment_to_Manager__c,Manager_Email__c from Contact_Trace_Loader__c where id IN:emprec AND Manager_Email__c IN:ctlToUpdate]){
                ct.Send_Risk_Assessment_to_Manager__c=true;
                ct.Manager_Risk_Assessment_Request_Sent__c = DateTime.now();
                updaterecs.add(ct);
            }
        }
        if(updaterecs.size()>0){
            Database.update(updaterecs,false);
        }
    }
    public List<Contact_Trace_Loader__c> getContactList()
    {
        //conManagerEmail
        System.debug('contactId--->'+contactId);
        System.debug('conManagerEmail--->'+conManagerEmail);
        System.debug('selectedIds--->'+selectedIds);
        return [select id,Manager_Email__c,Send_Risk_Assessment_to_Manager__c,Employee_Name__c,Last_Exposure_Date__c 
                from Contact_Trace_Loader__c where Manager_Email__c =:conManagerEmail and  Id IN:selectedIds ];
     
    }
    /* public  List<Contact_Trace_Loader__c> getContactList()
    {
        System.debug('contactTrace2***'+contactTrace);
        return contactTrace;
        
    }*/
}