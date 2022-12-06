global class COH_EmailEscalatetoManagerBatch implements Database.Batchable<sObject>{
    Infection_Prevention_Email__mdt IP_Settings = [Select Timelapse_between_RA_Req_and_Resp__c From Infection_Prevention_Email__mdt Where Label = 'Infection Prevention Email CC'];
    private Double TimelapseInHours = IP_Settings.Timelapse_between_RA_Req_and_Resp__c;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'Select id,Manager_Risk_Assessment_Request_Sent__c,Timelapse_between_RA_Req_and_Resp__c,Risk_AssessmentEscalation_Email_Sent__c from Contact_Trace_Loader__c Where Timelapse_between_RA_Req_and_Resp__c= ' + TimelapseInHours + ' and Risk_AssessmentEscalation_Email_Sent__c=null';
        System.debug('query==>'+query);
        return Database.getQueryLocator(query);    
    }
    global void execute(Database.BatchableContext BC, List<Contact_Trace_Loader__c> TraceList) {
        System.debug('TraceList-size-->'+TraceList.size());
        System.debug('TraceList--->'+TraceList);
        set<Id> conTraceIds = new set<Id>();
        for(Contact_Trace_Loader__c trc : TraceList) {
            if(trc.Timelapse_between_RA_Req_and_Resp__c == TimelapseInHours && trc.Risk_AssessmentEscalation_Email_Sent__c==null){
                conTraceIds.add(trc.Id);
            }        
        }
        if(conTraceIds.size()>0){
            set<String> managerEmails = new set<String>();
            List<Contact_Trace_Loader__c> contactTraceList = [select id,Manager_Email__c,Send_Risk_Assessment_to_Manager__c,Employee_Name__c,Last_Exposure_Date__c 
                                                              ,Risk_AssessmentEscalation_Email_Sent__c from Contact_Trace_Loader__c where Id IN:conTraceIds];
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Escalated Risk Assessment Reminder Email'];
            OrgWideEmailAddress[] owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='Infection Prevention'];
            System.debug('owea===>'+owea);
            Infection_Prevention_Email__mdt infectionPrevention = [SELECT Id, Label, Email_CC__c FROM Infection_Prevention_Email__mdt limit 1];
            System.debug('inPre==>'+infectionPrevention);
            List<String> ccEmailsList = infectionPrevention.Email_CC__c.split(',');
            System.debug('ccemailsList==>'+ccEmailsList);
            System.debug('ccemailsList=size=>'+ccEmailsList.size());
            Messaging.SingleEmailMessage[] allMails = new List<Messaging.SingleEmailMessage>();
            List<string> ctlToUpdate=new List<string>();
            for(Contact_Trace_Loader__c con:contactTraceList){
                System.debug('con.Manager_Email__c--->'+con.Manager_Email__c);
                System.debug('managerEmails--->'+managerEmails);
                if(!managerEmails.contains(con.Manager_Email__c)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    System.debug('con---'+con.Id);
                    message.setWhatId(con.Id); 
                    managerEmails.add(con.Manager_Email__c);
                    message.setTemplateID(emailTemplate.Id);
                    message.toAddresses = new String[] {con.Manager_Email__c};
                        message.setTargetObjectId(UserInfo.getUserId());
                    if(owea.size() > 0 ) {
                        message.setOrgWideEmailAddressId(owea[0].Id);
                    }
                    if(ccEmailsList.size() > 0){
                        message.setCcAddresses(ccEmailsList);
                    }
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
            
            if(ctlToUpdate.size()>0){
                List<Contact_Trace_Loader__c> UpdateRiskAssessment=new List<Contact_Trace_Loader__c>();
                for(Contact_Trace_Loader__c ctl:[select id,Risk_AssessmentEscalation_Email_Sent__c,Manager_Email__c from Contact_Trace_Loader__c where id IN:conTraceIds AND Manager_Email__c IN:ctlToUpdate]){
                    ctl.Risk_AssessmentEscalation_Email_Sent__c = DateTime.now();
                    UpdateRiskAssessment.add(ctl);
                } 
                if(UpdateRiskAssessment.size()>0){
                    Database.update(UpdateRiskAssessment,false);
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    }
}