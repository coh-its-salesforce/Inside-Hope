/******* Changes By: Sanjay Singh 11/15/16 Start *******/   
public class Batch_Timesheet_EmailNotification 
            implements Database.batchable<sObject> , Database.AllowsCallouts,  Database.Stateful{
     Date d = date.today().addMonths(-1);
      public set<string> userRoleSet = new Set<String>{'COH Temp role'};
    //public set<string> userRoleSet = new Set<String>{'ITS','SysAdmins'};
    Set<Id> processedUserId  = new Set<id>();
    /** Changes By: Sanjay Singh 11/15/16 End ***/     
    public static final string TIME_SHEET_REMINDER_EMAIL_TEMPLATE= 'Time_sheet_Reminder_Email_Template';
    private static final string OWDEMAIL = 'ITPMO@coh.org';
    
    /*
     * Start Method of Batch Class
     * query all group member of public group - "Timesheet_Users".
     * */
    public Database.QueryLocator start(Database.BatchableContext BC){
        /** Changes Made By Sanjay --- Date - 11/17/2016---- START****/
        /*
        string groupName = 'Timesheet_Users';
        
        if(Test.isRunningTest()){
            groupname = 'TESTXYZ1234';
        }
        string groupMemberQuery = 'Select Id, GroupId, UserOrGroupId From GroupMember where group.DeveloperName=: groupName'; */
        /** Changes Made By Sanjay --- Date - 11/17/2016---- END****/
                  
    string userQuery = 'Select id, FirstName, Department,LastName from User where ITS_Timesheet__c = true and IsActive = true and Start_Date__c <: d'; 
     if(test.isRunningTest())
           userQuery += ' Limit 10 ';
     return Database.getQueryLocator(userQuery); 
   }    
   
   /*
    * Execute Methods
    * Send notification logic here
    * */ 
   public void execute(Database.BatchableContext BC, List<User> userList){
        Set<Id> userIds = new Set<Id>(); 
        //Last Week Start Date 
        date lastWeekStartDate = Date.today().toStartOfWeek().addDays(-1).toStartOfWeek();
        //Last Week End Date 
        date lastWeekEndDate = Date.today().toStartOfWeek().addDays(-1);
        //Second Last Week Start Date
        date secondLastWeekStartDate = lastWeekStartDate.addDays(-7);
        //Second Last Week ENd Date
        date secondLastWeekendDate = lastWeekStartDate.addDays(-1);
        // Get the default business hours
        BusinessHours bh = [select id from businesshours where IsDefault=true];
        // Convert week's enda dates in dateTime to calculate dates from end dates based on bussiness hours
        Datetime lastWeekEndDateDT = datetime.newInstance(lastWeekEndDate.year(), lastWeekEndDate.month(),lastWeekEndDate.day());
        Datetime secondlastWeekEndDateDT = datetime.newInstance(secondLastWeekendDate.year(), secondLastWeekendDate.month(),secondLastWeekendDate.day());
        
        //date for sending notifications after 1 bussiness day - 8 hours
        dateTime dt1 = BusinessHours.add(bh.id, lastWeekEndDateDT , 8*60*60*1000);
        
        // Start 06/03/2016 Sanjay Singh Adding code for 2 business days        
        //date for sending notification after 2 bussiness day - 16 hours
        dateTime dt2 = BusinessHours.add(bh.id, lastWeekEndDateDT , 16*60*60*1000);        
        // End Sanjay Singh
        
        //date for sending notification after 3 bussiness day - 8*3 hours
        dateTime dt3 = BusinessHours.add(bh.id, lastWeekEndDateDT , 24*60*60*1000);
        
        // Start 06/03/2016 Sanjay Singh Adding code for 4 business days        
        //date for sending notification after 4 bussiness day - 16 hours
        dateTime dt4 = BusinessHours.add(bh.id, lastWeekEndDateDT , 32*60*60*1000);        
        // End Sanjay Singh     
        
        //date for sending notification after 5 bussiness days - 8*5 hours
        dateTime dt5 = BusinessHours.add(bh.id, lastWeekEndDateDT , 40*60*60*1000);
        //We also have to check second last week , because if there is any holiday in week,3rd notification will be shifted to next week
        
        //date for sending notification after 7 bussiness days - 8*6 hours
        dateTime dt6 = BusinessHours.add(bh.id, lastWeekEndDateDT , 48*60*60*1000);
        //We also have to check second last week , because if there is any holiday in week,3rd notification will be shifted to next week
        
                
        dateTime sldt1 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 8*60*60*1000);
        dateTime sldt3 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 24*60*60*1000);
        dateTime sldt5 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 40*60*60*1000);
        
        // Start 06/03/2016 Sanjay Singh Adding code for 2nd,4th and 6th
        dateTime sldt2 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 16*60*60*1000);
        dateTime sldt4 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 32*60*60*1000);
        dateTime sldt6 = BusinessHours.add(bh.id, secondlastWeekEndDateDT , 48*60*60*1000);
        
        // End Sanjay Singh
      
        date dateAfter1Day = date.newInstance(dt1.year(), dt1.month(), dt1.day());
        date dateAfter3Day = date.newInstance(dt3.year(), dt3.month(), dt3.day());
        date dateAfter5Day = date.newInstance(dt5.year(), dt5.month(), dt5.day());
                
        
        //Start 06/03/2016 Sanjay Singh Adding code for 2nd week and 4th week
        date dateAfter2Day = date.newInstance(dt2.year(), dt2.month(), dt2.day());
        date dateAfter4Day = date.newInstance(dt4.year(), dt4.month(), dt4.day());
        date dateAfter7Day = date.newInstance(dt6.year(), dt6.month(), dt6.day());
        
        //End Sanjay Singh
        
        date dateAfter1DaySLW = date.newInstance(sldt1.year(), sldt1.month(), sldt1.day());
        date dateAfter3DaySLW = date.newInstance(sldt3.year(), sldt3.month(), sldt3.day());
        date dateAfter5DaySLW = date.newInstance(sldt5.year(), sldt5.month(), sldt5.day());
        
        //Start 06/03/2016 Sanjay Singh Adding code for 2nd week and 4th week
        date dateAfter2DaySLW = date.newInstance(sldt2.year(), sldt1.month(), sldt2.day());
        date dateAfter4DaySLW = date.newInstance(sldt4.year(), sldt4.month(), sldt4.day());
        date dateAfter7DaySLW = date.newInstance(sldt6.year(), sldt6.month(), sldt6.day());
        
        for(User u: userList){
        UserIds.add(u.id);
        }
        system.debug('=======userIds==='+userIds);
        if(!userIds.isEmpty()){
            Set<id> userWithTS = new Set<id>();
            
            Map<Id, User> userMap = new Map<Id, User>([Select id, FirstName, Department,LastName, Mgr__r.Email, Mgr__c, Email,(SELECT Id, Name, 

                                                                                                                                   Unique_Week_Name__c, User__c, 
                                              Week_Start_Date__c, Week_End_Date__c, Supervisor__c, 
                                              Profile__c FROM Timesheet_Week__r where Status__c ='Submitted' order by Week_End_Date__c DESC limit 5) 
                                              /** Changes By: Sanjay Singh : 11/15/16 Start ***/
                                              from User where id In:userIds ]);
                                               /** Changes By: Sanjay Singh : 11/15/16 End ***/         
                                              
            Set<string> depMap = new Set<string>();
            for(User u: usermap.values()){
                /** Start Changes By: Sanjay Singh : 11/15/16  ***/
                                              
                if(processedUserId != null && processedUserId.size() < 1000)
                    processedUserId.add(u.id);
                /** End Changes By: Sanjay Singh : 11/15/16 ***/   
                /* Department Owner functionality Commenting-- Date 1-10-2017
                if(string.isNotBlank(u.Department)){
                    depMap.add(u.Department);
                } 
                */
            }
            /* Department Owner functionality Commenting-- Date 1-10-2017
                
            //Query ITLT owner email
            Map<String, String> mapITLTOwnerEmail = new Map<String, String>(); 
            for(PeopleSoft__c p: [Select Name, ITLT_Owner__c, ITLT_Owner__r.Email from PeopleSoft__c where name in: depMap]){
                if(p.ITLT_Owner__c != null){  
                        mapITLTOwnerEmail.put(p.Name, p.ITLT_Owner__r.Email);
                }    
            }
            */
            date today = date.today();
            Map<Id, Map<Date, Timesheet_Week__c>> usertWeekMap = new Map<Id, Map<Date, Timesheet_Week__c>>();
            List<List<Messaging.SingleEmailMessage>> emails = new List<List<Messaging.SingleEmailMessage>>();
            List<Messaging.SingleEmailMessage> temp = new List<Messaging.SingleEmailMessage>();
            Map<string, EmailTemplate> templateMap = new Map<string,EmailTemplate>();
            Set<string> templateNames = new Set<string>{TIME_SHEET_REMINDER_EMAIL_TEMPLATE};
            for(EmailTemplate tem: [SELECT Id, Name, DeveloperName, HtmlValue,subject, Body FROM EmailTemplate 
                                    where DeveloperName IN:templateNames]){
                templateMap.put(tem.DeveloperName, tem);
            }
            
            for(User u: userMap.values()){
                usertWeekMap.put(u.id, new Map<date, Timesheet_Week__c>());
                String otherccaddress ;
                /*
                if(string.isNotBlank(u.Department) && 
                        mapITLTOwnerEmail.containsKey(u.Department)){ otherccaddress = mapITLTOwnerEmail.get(u.Department); }
                */
                if(u.Timesheet_Week__r != null && u.Timesheet_Week__r.size() > 0){
                    for(Timesheet_Week__c tw: u.Timesheet_Week__r){
                        usertWeekMap.get(u.id).put(tw.Week_Start_Date__c, tw);    
                    }
                }    
                system.debug('====usertWeekMap.get(u.id)===='+usertWeekMap.get(u.id));  
                
                if(!usertWeekMap.get(u.id).containsKey(lastWeekStartDate)){
                    if(today == dateAfter1Day ){
                        //Send First Reminder
                        temp.add(createMail(u, 'First Reminder' , 1, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE),null, lastWeekStartDate, 

lastWeekEndDate));
                    }
                    
                    // Start 06/03/2016 Sanjay Singh Added Second Reminder
                    
                    if(today == dateAfter2Day ){
                        //Send Second Reminder
                        temp.add(createMail(u, 'Second Reminder' , 2, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE),null,lastWeekStartDate, 

lastWeekEndDate) );
                    }
                    
                    // End Second Reminder
                    
                    if(today == dateAfter3Day){
                        // send Third Reminder
                        temp.add(createMail(u, 'Third Reminder' , 3, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), null,lastWeekStartDate, 

lastWeekEndDate));
                    }
                    
                    if(today == dateAfter4Day){
                        // send Fourth Reminder
                        temp.add(createMail(u, 'Fourth Reminder' , 4, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), otherccaddress,lastWeekStartDate, 

lastWeekEndDate));
                    }
                    
                    if(today == dateAfter5Day){
                        //send Fifth reminder   
                        temp.add(createMail(u, 'Fifth Reminder' , 5, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), otherccaddress,lastWeekStartDate, 

lastWeekEndDate));
                    }
                    
                    if(today == dateAfter7Day){
                        //send seventh reminder   
                        temp.add(createMail(u, 'Seven Reminder' , 7, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), null,lastWeekStartDate, 

lastWeekEndDate));
                    }
                    
                    /*** Start Changes by Sanjay Singh 01-16-2017----*/
                                 
                    if(temp.size() == 1000){
                        emails.add(temp);
                        temp = new List<Messaging.SingleEmailMessage>();
                    }
                    
                    /*** Changes made by Sanjay Singh 01-16-2017--End--*/
                }
                /*** Start Changes by Sanjay Singh 01-16-2017 ----*/ 
                /*Commenting below code to restrict sending emails for second last week timesheet reminder
                
                if(!usertWeekMap.get(u.id).containsKey(secondLastWeekStartDate)){
                    //Send First Reminder
                    if(today == dateAfter1DaySLW ){temp.add(createMail(u, 'First Reminder' , 1, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

null,secondLastWeekStartDate,secondLastWeekEndDate)); }
                    // send second Reminder
                    if(today == dateAfter2DaySLW){temp.add(createMail(u, 'Second Reminder' , 2, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

null,secondLastWeekStartDate,secondLastWeekEndDate));}
                    //send third reminder 
                    if(today == dateAfter3DaySLW){temp.add(createMail(u, 'Third Reminder' , 3, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

otherccaddress,secondLastWeekStartDate,secondLastWeekEndDate));}
                    //send Fourth reminder    
                    if(today == dateAfter4DaySLW){temp.add(createMail(u, 'Fourth Reminder' , 4, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

otherccaddress,secondLastWeekStartDate,secondLastWeekEndDate)); }
                    //send Fifth reminder
                    if(today == dateAfter5DaySLW){temp.add(createMail(u, 'Fifth Reminder' , 5, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

otherccaddress,secondLastWeekStartDate,secondLastWeekEndDate));}
                    //send seventh reminder
                    if(today == dateAfter7DaySLW){temp.add(createMail(u, 'Seventh Reminder' , 6, templateMap.get(TIME_SHEET_REMINDER_EMAIL_TEMPLATE), 

otherccaddress,secondLastWeekStartDate,secondLastWeekEndDate));}
                    if(temp.size() == 10){ emails.add(temp);  temp = new List<Messaging.SingleEmailMessage>(); }
                }
                
                ***********************************************/
                /*** Changes by Sanjay SIngh 01-16-2017--End--*/
            }
            
            if(!temp.isEmpty()){
                emails.add(temp);
            }
            try{
            // Start Sanjay Singh 06/20
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:OWDEMAIL  ];
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            system.debug('===owea ==='+owea );
            if (owea.size() > 0 ) {
            
                for(List<Messaging.SingleEmailMessage> emailList : emails){
                    for(Messaging.SingleEmailMessage mail : emailList ){
                        //Setting Org Wide Address         
                        mail.setOrgWideEmailAddressId(owea[0].id);
                     }
                }
            }
            
            
                
            for(List<Messaging.SingleEmailMessage> emailList : emails){
                if(!test.isRunningTest())
                Messaging.sendEmail(emailList);
            }
            }catch(Exception e){system.debug('Exceptions======'+e);}
            
        } 
   }
   
                public static Messaging.SingleEmailMessage createMail(user u, 
                                                                      string subject, 
                                                                      integer reminderPriority,
                                                                      EmailTemplate template,
                                                                      string itltOwnerEmail, 
                                                                      Date weekstartDate,
                                                                      Date weekEndDate){
       Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
       String[] sendingTo = new String[]{u.Email};
       string mailBody = '';
       semail.settoaddresses(sendingTo);                                           
       //Add the below code to send reminder to staff on 1st and 2nd days of the following weeks
       /*semail.setTemplateID(template.Id);
       semail.setSaveAsActivity(false);                                                                  
       semail.setTargetObjectId(u.id);*/
       //Reminder 1 message
          
       Set<string> ccAddresses = new Set<string>();
       if(string.isNotBlank(itltOwnerEmail)){ ccAddresses.add(itltOwnerEmail) ; }
       /*
       mailBody = 'Hi '+ u.FirstName +', \n'+
           'You have not filled your last week time sheet. Please fill it ASAP.\n'+
           'Thanks & Regards';
       */
       //Add the below code to send reminder to staff and manager on 3rd,4th and 5th days              
       //if(reminderPriority==2 && u.managerId != null){
       system.debug('====v===='+reminderPriority);
       system.debug('====u.managerId===='+u.Mgr__c);
                                                                            
       if((reminderPriority==4 || reminderPriority==5) && u.Mgr__c != null){
           //Add manager's email in cc
          
          /* Start Sanjay 01-16-2016 Disabling notification to manager and supervisors */
           
           //ccAddresses.add(u.manager.Email);
          
          /* End Sanjay 01-16-2016 */ 
           
           //semail.setCCAddresses(new String[]{u.manager.Email});
           //Reminder 2 message boody
           mailBody = 'Hi '+ u.FirstName +', \n'+
                       'This is a reminder 2\n'+
                       'You have not filled your last week time sheet. Please fill it ASAP.\n'+
                       'Thanks & Regards';
      // }else if(reminderPriority == 6 && u.managerId != null){
           //add manager and Sr Manager Emails as CC
           ccAddresses.add(u.Mgr__r.Email);
           //ccAddresses.add('gahwah@coh.org');
           
           //Reminder 3 message boody
              mailBody = 'Hi '+ u.FirstName +', \n'+
                        'This is a reminder 3\n'+
                       'You have not filled your last week time sheet. Please fill it ASAP.\n'+
                       'Thanks & Regards';
       }
       if(!ccAddresses.isEmpty()){                                                                   
          semail.setCCAddresses(new List<String>(ccAddresses));                                                                     
       }
       string WeekStr = weekstartDate.format() +'-'+weekEndDate.format();                                                                        
       string subj = template.Subject+' '+WeekStr;
       semail.setSubject(subj) ;
       string body = template.HtmlValue;
                                                                                
       //body = body + '\n\n\n TimeSheet is Overdue for the week of:' + weekstartDate.format() + '-'+ weekEndDate.format(); 
       body = body.replace('{!User.Name}',  u.firstName + ' '+ u.LastName);         
       //Replace {{Week}} String from template with actual week Date
       body = body.replace('{{WEEK}}',  WeekStr);         
       //semail.setHTMLBody(body);
       semail.setHTMLBody(body);
       
       return semail;   
   }
   public void finish(Database.BatchableContext info){     
    system.debug('======='+processedUserId);
   } 
}