@isTest(SeeAllData=true)
 public class SLMBatchTest{
 /*   static testmethod void testBatch(){
        SLMBatchColor batch = new SLMBatchColor();
        batch.runTestMethod = true;     
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();        

        SLMBatchColorSchedulable obj = new SLMBatchColorSchedulable(); 
        obj.Test = 'Yes';
        
        //batch.query = 'Select Id, Name, BMCServiceDesk__FKIncident__c, BMCServiceDesk__Support_Hour_Applied__c, BMCServiceDesk__Status__c, BMCServiceDesk__StartDate__c, BMCServiceDesk__ClockPauseDate__c, BMCServiceDesk__PausedDuration__c, BMCServiceDesk__TargetEndDate__c, BMCServiceDesk__ClockState__c, BMCServiceDesk__Service_Target_Duration__c,BMCServiceDesk__TargetType__c, BMCServiceDesk__Target_Duration__c from BMCServiceDesk__Incident_Service_Target__c WHERE BMCServiceDesk__ClockState__c <> \'Stopped\' AND BMCServiceDesk__ClockState__c <> \'Not Started\'';
        

        System.debug('TEST: Triggering Schedulable');

        String jobId = system.schedule('test', sch, obj);        
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
        
        System.assertEquals(sch, ct.CronExpression);                     
        //obj.cronTriggerId = database.executeBatch(batch);        
            
        Test.stopTest();
            
        Datetime endTime = Datetime.newInstance(2015, 5, 28, 16, 6, 8);
        BusinessHours bh = [Select Id from businesshours where IsDefault=true];
        Long lngTest;
        Decimal decTest;
        lngTest = batch.ReturnTimeMs(bh.id, currTime, endTime);
        decTest = batch.ConvertMs(lngTest); */
        
    }