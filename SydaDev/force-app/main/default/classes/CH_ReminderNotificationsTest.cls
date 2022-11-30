@isTest(SeeAllData=false)
/*
*  Name           :   CH_ReminderNotificationBatchClassTest
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015
*  Description    :   Test class 
*/
public class CH_ReminderNotificationsTest{
   /**
    *  Test Method to cover NotToExceedRollupBatch Class
    */

      static testMethod void testBatch() {
     // Created checlist record
     Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
     Checklist__c checklistRecord = CH_Test_SampleData.createChecklist(1);
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduserTest@coh.org', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTest@coh.org'); 
     
     
     System.runAs(u) {
        Folder tempFolder = [select id,name from folder where name = 'COH Templates' limit 1];
        EmailTemplate emailTemplate = New EmailTemplate(Name = 'testTemplate', Body = 'Just to test the batch functionality', DeveloperName= 'testTemplate', FolderId= tempFolder.id, IsActive=True, Subject= 'Email Notification batch', TemplateType= 'Text') ;
        Insert emailTemplate;
  
     //Created notification record    
     Reminder_Notification__c notificatioRecord = new Reminder_Notification__c();
     notificatioRecord.Checklist__c = checklistRecord.id;
     notificatioRecord.Days__c = 2;
     notificatioRecord.Email_Template__c= 'testTemplate';
     notificatioRecord.Prior_To__c= '1st Appointment';
     
     insert notificatioRecord;
     
     
      Account accountRecord = CH_Test_SampleData.createNewPatientAccounts(1);
         
      Case caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
      caseRecord.CC_Appointment_Date__c = Date.today().adddays(2);
      caseRecord.Status = 'New';
      caseRecord.RecordTypeId = conRecordTypeInfo.get('Care Coordination').getRecordTypeId();
      
      Update caseRecord ;     
      
      
      Health_Goal__c temp= new Health_Goal__c();
                temp.Name='Patient Intake – Care Coordinator Checklist1';
                temp.status__c='Open';              
                temp.case__c=caseRecord.id;
                temp.Assigned_to__c = u.id;
                temp.No_of_Completed_Tasks__c = 1;  
                temp.Total_No_of_Tasks__c=3;
                temp.Appt_date_Change_Reminder__c =false;
                temp.Due_Date__c = Date.today().adddays(2);
                insert temp; 
        }
        
        Test.startTest();
        
        CH_ReminderNotificationBatchClass reNotification = new CH_ReminderNotificationBatchClass(); 
        database.executebatch(reNotification,90);
            
            
        Health_Goal__c updatedHG = [select Appt_date_Change_Reminder__c,id ,name from Health_Goal__c where CreatedDate = TODAY
                                        and CreatedById = :u.id];
        
        system.assertEquals(updatedHG.Appt_date_Change_Reminder__c , false);
             
        Test.stopTest(); 
     
     }
     /**
    *  Test Method to cover Schedule Class
    */         
     static testMethod void ScheduleTest() {
     
     String CRON_EXP = '0 0 0 3 9 ? 2022';
      Test.startTest();
        
              String jobId = System.schedule('testBasicScheduledApex',CRON_EXP,new CH_ReminderNotificationBatchClass());
        
              CronTrigger ct = [SELECT Id, 
                                       CronExpression,
                                       TimesTriggered, 
                                       NextFireTime
                               FROM CronTrigger 
                               WHERE id = :jobId];

         // Verify the expressions are the same
            System.assertEquals(CRON_EXP,ct.CronExpression);
      
         // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
      
         // Verify the next time the job will run
            System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));
            
           Test.stopTest();
          }
     }