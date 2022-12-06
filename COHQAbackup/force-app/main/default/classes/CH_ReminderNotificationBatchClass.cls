/*
*  Name           :   CH_ReminderNotificationBatchClass
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   Batch class to notify user to complete checklist as defiend in reminder notification object
*/


global class CH_ReminderNotificationBatchClass implements Database.Batchable<SObject>,Schedulable {
    public Map<string,Reminder_Notification__c> Map_reminder_checklist = new Map<string,Reminder_Notification__c>();
    public List<Reminder_Notification__c> ListOfreminderNotifications = new List<Reminder_Notification__c>(); 
    public List<Health_Goal__c> setofUniqueChecklist = new List<Health_Goal__c>();
    public Set<String> checklistNames = new Set<String>(); 
    public set<string> emailTemplatesName;
    map<string,EmailTemplate> mapOfEmailTemplateNaameAndemailTemp = new map<string,EmailTemplate>();
    public List<Messaging.SingleEmailMessage> mails;
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
    /**
    * get list of notifation object records
    */
    return Database.getQueryLocator([select id, name,
                                                Complete__c,
                                                Case__c,
                                                Case__r.id,
                                                Status__c,
                                                Assigned_to__c,
                                                case__r.CC_Appointment_Date__c,
                                                Due_Date__c,
                                                Assigned_to__r.id,
                                                Appt_date_Change_Reminder__c 
                                                from Health_Goal__c where Due_Date__c!=null and case__r.Status != 'Closed' and case__r.RecordType.Name =: CH_StaticComponentHelperClass.CareCoordinator]);                                       
     
     }
    global void execute(Database.BatchableContext BC,List<Health_Goal__c> ListHealthGoal)
    {   
        mails = new List<Messaging.SingleEmailMessage>();
        emailTemplatesName= new set<string>();
        EmailTemplate emailTemplate;
        if(ListHealthGoal!=null && ListHealthGoal.size()>0){ 
            for( Health_Goal__c healthGoalChecklist: ListHealthGoal){
                checklistNames.add(healthGoalChecklist.Name);
            }
        }
        
        if(checklistNames != null && checklistNames.size()>0){
            ListOfreminderNotifications =[select id, 
                                                name,
                                                Checklist__r.Name,
                                                Days__c,
                                                Prior_To__c ,
                                                email_template__c
                                                from Reminder_Notification__c where Checklist__r.Name IN:checklistNames Order by Days__c];
        }                
        if(ListOfreminderNotifications!=null && ListOfreminderNotifications.size()>0){
            
            for( Reminder_Notification__c reminderChecklist: ListOfreminderNotifications){
                Map_reminder_checklist.put(reminderChecklist.Checklist__r.Name,reminderChecklist);
                emailTemplatesName.add(reminderChecklist.email_template__c);
            }            
        }
        if(emailTemplatesName !=null && emailTemplatesName.size()>0){
            for(EmailTemplate   emailTemplaterecord : [select Id,name,DeveloperName from EmailTemplate where DeveloperName = :emailTemplatesName]){
                if(emailTemplaterecord !=null)
                    mapOfEmailTemplateNaameAndemailTemp.put(emailTemplaterecord.DeveloperName,emailTemplaterecord );
            }
        }
       
        if(ListHealthGoal!=null && ListHealthGoal.size()>0){              
            for( Health_Goal__c  checklistTask : ListHealthGoal){
                if(Map_reminder_checklist.get(checklistTask.Name) !=null){
                    if(checklistTask!= null && checklistTask.Assigned_to__c != null && checklistTask.Complete__c!= 100.00){                        
                        Reminder_Notification__c temp = Map_reminder_checklist.get(checklistTask.name);                                         
                        if(temp  !=null && checklistTask.Due_Date__c!= null && temp.days__c != null 
                            && ((checklistTask.Due_Date__c).adddays(-integer.valueof(temp.days__c)).day())<= (date.today().day())){                           
                            if(((checklistTask.Due_Date__c).adddays(-integer.valueof(temp.days__c)).day())== (date.today().day())){                          
                                checklistTask.Appt_date_Change_Reminder__c = true;
                                setofUniqueChecklist.add(checklistTask);                                
                            }
                            if(checklistTask.Due_Date__c> date.today()){                              
                                 if(((checklistTask.Due_Date__c).adddays(-integer.valueof(temp.days__c))) < (date.today()) && checklistTask.Appt_date_Change_Reminder__c==false){
                                    checklistTask.Appt_date_Change_Reminder__c = true; 
                                    setofUniqueChecklist.add(checklistTask);
                                   
                                }
                            }
                           
                        }
                    }
                }    
            }
            if(setofUniqueChecklist!=null && setofUniqueChecklist.size()>0){
                for(Health_Goal__c  checklistTaskSet : setofUniqueChecklist){
                    Reminder_Notification__c temp = Map_reminder_checklist.get(checklistTaskSet.name);
                    if(temp!=null){
                        EmailTemplate emailname= mapOfEmailTemplateNaameAndemailTemp.get(temp.email_template__c);
                        if(emailname !=null){                            
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            email.setSaveAsActivity(false);
                            email.setTargetObjectId(checklistTaskSet.Assigned_to__r.id);
                            email.setTemplateId(emailname.Id);
                            email.whatid=checklistTaskSet.id;
                            mails.add(email);
                            
                        }
                    }
                }
            }
        }
                
        try{
            if(mails!=null && mails.size()>0 ){               
                Messaging.sendEmail(mails);                
                update  setofUniqueChecklist; 
                
                        
            }
                  
        }catch(Exception e){
            System.debug('Exception in sending Emails'+e.getStackTraceString());
        }
              
    }
    global void finish(Database.BatchableContext BC) { /* Done */ 
      
    }
    global void execute(SchedulableContext sc) {
        CH_ReminderNotificationBatchClass reNotification = new CH_ReminderNotificationBatchClass(); 
        database.executebatch(reNotification,99);
    }
}