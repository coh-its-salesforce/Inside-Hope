public class BatchTimeSheetNotification implements Database.batchable<sObject> , Database.AllowsCallouts,Database.Stateful{
    Date d = date.today().addMonths(-1);
    //private static final string TEMPLATE_NAME = 'Timesheet_Non_Compliance_Notificatoin';
    string templateName ;
    public BatchTimeSheetNotification(string templateName){
        this.templateName = templateName;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
       string userQuery = 'Select id, FirstName, Department,LastName from User where ITS_Timesheet__c = true and IsActive = true and Start_Date__c <: d'; 
       
        //Code for testing ---- need to remove before prod deployment
        //userQuery += ' and Id =\'005d0000004Ax0N\' ';
       
        if(test.isRunningTest())
            userQuery += ' Limit 10 ';
        return Database.getQueryLocator(userQuery); 
    }
    
    public void execute(Database.BatchableContext BC, List<User> userList){
        List<EmailTemplate> templates = [SELECT Id, DeveloperName, Name, Body FROM EmailTemplate Where DeveloperName=: templateName ];
        system.debug('-templates----'+templates);
        if(templates.isEmpty())
            return;
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'itpmo@coh.org'];
                
        for(user u : [Select id, FirstName, Department,LastName, Mgr__r.Email, Mgr__c, Email,
                      (SELECT Id, Name, 
                           Unique_Week_Name__c, User__c, 
                           Week_Start_Date__c, Week_End_Date__c, Supervisor__c, 
                           Profile__c 
                           FROM Timesheet_Week__r where Status__c ='Submitted' 
                            //Check if submitted record of current week exist
                           and Week_Start_Date__c = THIS_WEEK order by Week_End_Date__c DESC limit 1 ) 
                      from User where id In:userList]){
                if(templateName == 'Timesheet_Non_Compliance_Notification' && !u.Timesheet_Week__r.isEmpty() ){
                    continue;
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTargetObjectId(u.Id); 
                mail.setTemplateId(templates[0].Id); 
                if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);}
                mail.setBccSender(false); 
                mail.setUseSignature(false); 
                mail.setTreatTargetObjectAsRecipient(true);
                mail.setSaveAsActivity(false); 
                emailList.add(mail);
                                                          
        }
        system.debug('-emailList----'+emailList);
        if(!emailList.isEmpty()){
            List<Messaging.SendEmailResult> emailresult = Messaging.sendEmail(emailList, false);
            system.debug('-emailresult----'+emailresult);
        }
    }
       
    public void finish(Database.BatchableContext info){     
        
    } 
}