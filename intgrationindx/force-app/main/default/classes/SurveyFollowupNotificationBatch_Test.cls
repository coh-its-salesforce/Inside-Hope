@istest
public class SurveyFollowupNotificationBatch_Test {
    
    
    private static testmethod void unitTest(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id accRType = AccountRecordTypeInfo.get('New Patient Services').getRecordTypeId();
        List<account> accList = new List<account>();
        for(Integer i= 0; i<2; i++){
            Account account = new Account();
            account.RecordTypeId = accRType;
            account.Type = 'Press';
            account.FirstName = 'Test FirstName'+i;
            account.LastNAme = 'Test LastName'+i;
            
            account.COH_MRN__c = (i==0 ? '10159301' : (i==1 ? '10160150': '10159590'));
            account.Gender__pc = 'Male';
            account.personEmail = 'ab@xyz.com'+1;
            account.EPIC26_Survey_Sent__c = true;
            account.Preferred_Language__pc = 'English';
            account.Patient_Status__c = 'New';
            account.Marketing_Source__c = 'PRINT';  
            accList.add(account);
        }
        
        test.startTest();
        insert accList;
        
        //Test
        
        List<Surgery_Order__c> soList = new List<Surgery_Order__c>();
        for(Integer i=0; i<10; i++){
            Surgery_Order__c soObj = new Surgery_Order__c();
            soObj.CPT_Group__c = 'Radiation';
            soObj.Disease_Program_Group__c = 'Prostate';
            soObj.MRN__c = (i==0 ? '10159301' : (i==1 ? '10160150':'10159590'));
            soObj.CPT_No__c = '55815';
            sOObj.Date_Of_Surgery__c = date.today().addMonths((i==0 ? (-3) :(i==1 ? (-6):(i==2 ? (-9):(-12)))));
            soList.add(soObj);
        }
              
        List<Database.saveResult> sr  = database.insert(soList,False);
        
        for(Database.saveResult s : sr){
        system.debug('======'+s);
        }
        
        SurveyFollowupNotificationBatch bt = new SurveyFollowupNotificationBatch();
        database.executeBatch(bt);
        
        
        Test.stopTest();
        
        
    
    }
    
    static testmethod void testScheduler() {
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('test', CRON_EXP, new Scheduler_SurveyFollowupNotification() );   
        Test.stopTest();
    }
    
}