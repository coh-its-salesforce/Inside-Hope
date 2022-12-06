global class CH_EmailNotificationToCaseMemberBatch implements Database.Batchable<SObject> {
    /*************************************************************************

*  Name           :  CH_EmailNotificationToCaseMemberBatch
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   This class sends  email notification to the case team members when they are assigned to the case as well as 
                      checklist assignment it gets called when the stage or status of the case gets changed .

**************************************************************************/
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        return Database.getQueryLocator([select id, Assign_to__c,
                                                        OwnerEmail__c,
                                                        Recordid__c,
                                                        Owner_role__c,
                                                        Templates__c,
                                                        Role__c,
                                                        Notification_send__c,
                                                        Manager_Notification__c,
                                                        Email_Body__c
                                                        from CaseTeamMemberNotification__c]);
    }
    global void execute(Database.BatchableContext BC,List<CaseTeamMemberNotification__c> ListEmailsToBeSendToActors) {
        List<Messaging.SendEmailResult> results =  new List<Messaging.SendEmailResult> ();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        map<string,id>mapEmailTemplates= new map<string, id>();
        list< OrgWideEmailAddress> owe= new  list<OrgWideEmailAddress> ();
        List<CaseTeamMemberNotification__c> lstCaseteamnotificationUpdate = new List<CaseTeamMemberNotification__c> ();
        /* Querying the org wide default email address */
        //owe = [select Address,IsAllowAllProfiles,DisplayName from OrgWideEmailAddress where DisplayName='COH Care Coordination Application'];
        owe = [select Address,IsAllowAllProfiles,DisplayName from OrgWideEmailAddress where DisplayName=: CH_StaticComponentHelperClass.Orgwideemailadress];
        
        /* Querying the Active email from coh folder and creating a map of email templates name */
        for (EmailTemplate tempemailtmp : [SELECT id,folder.name ,DeveloperName  FROM EmailTemplate where folder.name =:CH_StaticComponentHelperClass.CohEmailFolder and  IsActive=true] ) {
            if(tempemailtmp!=null)
                mapEmailTemplates.put(tempemailtmp.DeveloperName,tempemailtmp.id);
        }
		
		if(ListEmailsToBeSendToActors != null && ListEmailsToBeSendToActors.size()>0) {
    		for (CaseTeamMemberNotification__c cteammbrRecord : ListEmailsToBeSendToActors) {
	        	string body;
	        	/* If notification mail are send to managers then below condition
	            will execute*/
	        	if(cteammbrRecord.Manager_Notification__c==true){
	            	Messaging.SingleEmailMessage mailsToManager = new Messaging.SingleEmailMessage();
	            	if(cteammbrRecord.Email_Body__c != null && cteammbrRecord.Email_Body__c !=''){
	                	body = ' <img src="'+ system.Label.CH_imageurl +'" allign="left" /> <br></br> ';
	                	body += cteammbrRecord.Email_Body__c;
	                	mailsToManager.setSubject('Notification');
	                	if(owe!=null && owe.size()>0 ){
	                    	mailsToManager.setOrgWideEmailAddressId(owe[0].Id);
	                    	mailsToManager.setHtmlBody(body);
	                    	if(cteammbrRecord.Assign_to__c !=null){
	                       		id targetobject= id.valueof(cteammbrRecord.Assign_to__c);
	                        	mailsToManager.setTargetObjectId(targetobject);
	                        	mailsToManager.saveAsActivity = false;
	                        	mailsToManager.setCcAddresses(new List<String>{'carecoordination@coh.org'});
	                        	mails.add(mailsToManager);
	                    	}
	                	}
	            	}
	       		}else{
					id et;
	                if(mapEmailTemplates !=null && mapEmailTemplates.size()>0) {
	                	et = mapEmailTemplates.get(cteammbrRecord.Templates__c);
	                }
	                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	                List<String> ccTo = new List<String>();
	                if( cteammbrRecord.OwnerEmail__c !=null  &&cteammbrRecord.OwnerEmail__c !='' && cteammbrRecord.Owner_role__c!=cteammbrRecord.Role__c ) {
	    		        ccTo.add(cteammbrRecord.OwnerEmail__c);
	                }
	                // adding the static email id in cc for testing purpose.
	    	        ccTo.add('carecoordination@coh.org');
	                mail.setCcAddresses(ccTo);
	                    
					if( et != null) {
	                	mail.setTemplateId(et);
	                    if(owe!=null && owe.size()>0 ){
	                    	mail.setOrgWideEmailAddressId(owe[0].Id);
	                    }
	                    mail.whatid= cteammbrRecord.Recordid__c;
	                    if(cteammbrRecord.Assign_to__c !=null){
	                        id targetobject= id.valueof(cteammbrRecord.Assign_to__c);
	                        mail.setTargetObjectId(targetobject);
	                        mail.saveAsActivity = false;
	                        mails.add(mail);
	                    }
	               }
	           }
	           cteammbrRecord.Notification_send__c= true;
	           lstCaseteamnotificationUpdate.add(cteammbrRecord);
	       }
        }
        /*  sending mails for Case Assignments to the actors*/
        if( mails !=null &&  mails.size()>0) {
            try {
                results= Messaging.sendEmail(mails);
            }catch(Exception e) {
                System.debug('******************Exception***********'+ e.getmessage())  ;
            }
        }
        
        try{
            update lstCaseteamnotificationUpdate;
        }catch (Exception e){
            System.debug('******************Exception***********'+ e.getmessage())  ;
    	}
        
    }
    
    global void finish(Database.BatchableContext BC) {
        /* Done */
        list< AsyncApexJob> lstResult = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                  TotalJobItems, CreatedBy.Email
                  FROM AsyncApexJob WHERE Id =:BC.getJobId()];
    
        /* deleting  the processed records from CaseTeamMemberNotification__c object when the batch has executed 
          and processed  the records*/
        try{          
            delete [select id from CaseTeamMemberNotification__c where Notification_send__c = true ];
        }catch ( exception e){
            System.debug('******************Exception***********'+ e.getmessage())  ;
        }
        
        /* Checking if any new record has been inserted while the batch was executing  if any new 
        record inserted count  is > 0 then again calling the batch from the finish method*/ 
        if([select count() FROM CaseTeamMemberNotification__c where Notification_send__c = false  ]>0 ){
            CH_EmailNotificationToCaseMemberBatch reNotification = new CH_EmailNotificationToCaseMemberBatch();
            database.executebatch(reNotification,90);
        } 
    }
}