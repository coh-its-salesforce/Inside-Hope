global without sharing class SurveyFollowupNotificationBatch implements Database.Batchable<sObject> {
    global static final date month3Date = date.today().addMonths(-3);
    global static final date month6Date = date.today().addMonths(-6);
    global static final date month9Date = date.today().addMonths(-9);
    global static final date month12Date = date.today().addMonths(-12);
    global static final date month24Date = date.today().addMonths(-24);
    global static final date month36Date = date.today().addMonths(36);
    private static final string OWDEMAIL = 'LCrocitto@coh.org';
   
    Set<Date> dateSet ;
    Set<Id> accountID = new Set<Id> ();
    string query ;
    Set<string> EmailTemplateSet;
    //Map Declaration: for storing mapping of month number and Email template Dev Name
    public final Map<integer, string> emailTempNameMap = 
                    new Map<Integer, String>{3=>'EPIC26_3mnths_Follow_up_Patient_Survey',
                                             6=>'EPIC26_6mnths_Follow_up_Patient_Survey',
                                             9=>'EPIC26_9mnths_Follow_up_Patient_Survey',
                                             12=>'EPIC26_12mnths_Follow_up_Patient_Survey',
                                             24=>'EPIC26_24mnths_Follow_up_Patient_Survey',
                                             36=>'EPIC26_36mnths_Follow_up_Patient_Survey'
                                            };
    public static final Set<string>  dpGroupSet = 
                        new Set<String>{'Prostate'};
    Set<string> CPTGroup = new Set<String>{'Surgery'};
    Set<string> MRN = new Set<String>{'160595'};
     
    global SurveyFollowupNotificationBatch(){
        dateSet = new Set<Date>{month3Date, month6Date, month9Date, month12Date, month24Date, month36Date};
        
       EmailTemplateSet = new Set<String>{'EPIC26_3mnths_Follow_up_Patient_Survey'};
               
        query = 'SELECT Id, Name, CPT_Group__c, CPT_No__c, Date_Of_Surgery__c,MRN__c '+
                'FROM Surgery_Order__c where Date_Of_Surgery__c in: dateSet order by Date_of_Surgery__c desc';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        Map<string, Surgery_Order__c> mrnNoMap = new Map<string, Surgery_Order__c>();
        for(Surgery_Order__c so : (List<Surgery_Order__c>)scope){
            system.debug('---so----'+so);
            If(!mrnNoMap.containsKey(so.MRN__c))
                mrnNoMap.put(so.MRN__c, so);
        }
        Map<string,EmailTemplate> templateMap = new Map<string,EmailTemplate>();
        for(EmailTemplate temp: [SELECT Body, HtmlValue, Id,Subject, IsActive, Name, Markup, DeveloperName 
                                  FROM EmailTemplate 
                                 where DeveloperName IN : emailTempNameMap.values()]) {
            templateMap.put(temp.developerName, temp) ;                            
        }
        

        if(!mrnNoMap.isEmpty() && !templateMap.isEmpty()){
            
            Map<String, Surgery_Order__c> surgeryOrderMap = new Map<String, Surgery_Order__c>();
            For(Surgery_Order__c sorder : [SELECT Id, Name, CPT_Group__c, CPT_No__c, Date_Of_Surgery__c,MRN__c FROM Surgery_Order__c where mrn__c in :mrnNoMap.KEYSET() 
                                            and Date_Of_Surgery__c != null ORDER BY Date_Of_Surgery__c DESC]){
                If(!surgeryOrderMap.containsKey(sorder.MRN__c)){
                    surgeryOrderMap.put(sorder.MRN__c, sorder);
                }
                
            }
            List<List<Messaging.SingleEmailMessage>> emailList = new List<List<Messaging.SingleEmailMessage>>();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Map<Id, Account> accMap = new Map<Id, Account>();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:OWDEMAIL  ];
            For(Account acc: [SELECT Id, LastName, FirstName, Type, ParentId, 
                                     RecordTypeId, PersonEmail, COH_MRN__c,
                                     EPIC26_3mnth_Survey_Sent__c, EPIC26_6mnth_Survey_Sent__c,
                                     EPIC26_9mnth_Survey_Sent__c, EPIC26_12mnth_Survey_Sent__c,
                                     EPIC26_24mnth_Survey_Sent__c, EPIC26_36mnth_Survey_Sent__c
                                FROM Account
                               Where COH_MRN__c in :mrnNoMap.keySet()
                                 AND PersonEmail != null
                                 ANd EPIC26_Survey_Sent__c = true
                                 AND Deceased__c = false]){
                date d =  mrnNoMap.get(acc.COH_MRN__c).Date_Of_Surgery__c;
                integer monthNum ; 
                system.debug('---accMap--'+accMap);
                If(accMap.containsKey(acc.Id)){
                    continue;
                }
                system.debug('---surgeryOrderMap--'+surgeryOrderMap);
                if(!surgeryOrderMap.containsKey(acc.COH_MRN__c) || (surgeryOrderMap.containsKey(acc.COH_MRN__c) && d == surgeryOrderMap.get(acc.COH_MRN__c).Date_Of_Surgery__c)){
                    if(d == month3Date && !acc.EPIC26_3mnth_Survey_Sent__c ){
                        acc.EPIC26_3mnth_Survey_Sent__c = true;
                        acc.EPIC26_3mnth_Survey_Sent_dateTime__c = system.now();
                        monthNum = 3;
                        //template.DeveloperName = 'EPIC26_3mnths_Follow_up_Patient_Survey';
                    }else if(d == month6Date && !acc.EPIC26_6mnth_Survey_Sent__c){
                        acc.EPIC26_6mnth_Survey_Sent__c = true;
                        acc.EPIC26_6mnth_Survey_Sent_dateTime__c = system.now();
                        //template.DeveloperName = 'EPIC26_6mnths_Follow_up_Patient_Survey';
                        monthNum = 6;
                    }else if(d ==month9Date && !acc.EPIC26_9mnth_Survey_Sent__c){monthNum = 9; acc.EPIC26_9mnth_Survey_Sent__c = true;  
                        acc.EPIC26_9mnth_Survey_Sent_dateTime__c = system.now();
                    }
                    else if(d ==month12Date && !acc.EPIC26_12mnth_Survey_Sent__c){monthNum = 12; acc.EPIC26_12mnth_Survey_Sent__c = 
                        true;acc.EPIC26_12mnth_Survey_Sent_dateTime__c = system.now();
                    }
                    else if(d ==month24Date && !acc.EPIC26_24mnth_Survey_Sent__c){monthNum = 24; acc.EPIC26_24mnth_Survey_Sent__c = true;  
                        acc.EPIC26_24mnth_Survey_Sent_dateTime__c = system.now();
                    }
                    else if(d ==month36Date && !acc.EPIC26_36mnth_Survey_Sent__c){monthNum = 36; acc.EPIC26_36mnth_Survey_Sent__c = true;  
                        acc.EPIC26_36mnth_Survey_Sent_dateTime__c = system.now();
                    }else{
                        continue;
                    }
                
                    if(monthNum != null && templateMap.containsKey(emailTempNameMap.get(monthNum))){
                        Messaging.SingleEmailMessage email = createNotificationEmail(acc, d,templateMap.get(emailTempNameMap.get(monthNum)));
                        if (owea.size() > 0 ) { 
                        email.setOrgWideEmailAddressId(owea[0].id);}
                        emails.add(email); 
                        if(emails.size() == 1000){   emailList.add(emails);   emails = new List<Messaging.SingleEmailMessage>();
                        }
                        accMap.put(acc.Id, acc);       
                    }
                }
            }
            if(emails.size() > 0){
                emailList.add(emails);
            }
            try{
                for(List<Messaging.SingleEmailMessage> eList : emailList){
                    Messaging.sendEmail(eList, false);  
                }
                database.update(accMap.values());
            }catch(Exception e){
                system.debug('======='+e);
            }
        }
    }
    
    private static Messaging.SingleEmailMessage createNotificationEmail(Account acc, date d, EmailTemplate temp){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{acc.PersonEmail});
        //string emailContent = temp.Body;
        string emailContent = temp.htmlvalue;
        
        if(d == month3Date){
            emailContent = emailContent.replace('{{xMonth}}', '3 Months');
            //temp.DeveloperName = 'EPIC26_3mnths_Follow_up_Patient_Survey';
            
        }else if(d ==month6Date){
            emailContent = emailContent.replace('{{xMonth}}', '6 Months');
            //temp.DeveloperName = 'EPIC26_6mnths_Follow_up_Patient_Survey';
            
        }else if(d ==month9Date){
            emailContent = emailContent.replace('{{xMonth}}', '9 Months');
        }
        else if(d ==month12Date){
            emailContent = emailContent.replace('{{xMonth}}', '12 Months');
        }
        else if(d ==month24Date){
            emailContent = emailContent.replace('{{xMonth}}', '24 Months');
        }
        else if(d ==month36Date){
            emailContent = emailContent.replace('{{xMonth}}', '36 Months');
        }else{
            system.debug('=====in else======');
            emailContent = 'Tests';
        }
        emailContent = emailContent.replace('{!Account.Id}', acc.id);
        //email.setPlainTextBody(emailContent);
        email.setHtmlBody(emailContent);
        email.setSubject(temp.Subject);
        return email;
    }
                                                                  
    global void finish(Database.BatchableContext BC){
        
    }   
}