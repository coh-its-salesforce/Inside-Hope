global class SLMBatchColorSchedulable implements Schedulable{
    global void execute(SchedulableContext sc){
    }
/*    
    public Id cronTriggerId;
    public string Test = 'no';
    global void execute(SchedulableContext sc){
        
        SLMBatchColor B = new SLMBatchColor();
        Database.executeBatch(B,50);
        if (cronTriggerId == null)
            cronTriggerId = sc.getTriggerId();
        if (Test == 'no'){
            System.abortJob(cronTriggerId);
            abortCron(cronTriggerId, Test);
        }
        else
            abortCron(cronTriggerId, Test);
    }
    
    @future
    private static void abortCron(id recordId, string isTest){
        //System.abortJob(recordId);
        System.debug('Cron ID: ' + recordId);
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(120);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        if (isTest == 'no'){
            system.debug('Not a Test');
          SLMBatchColorSchedulable bs = new SLMBatchColorSchedulable();
          System.schedule('SLM Batch Scheduler (' + sysTime + ')',chron_exp, bs); 
        }
    }
*/
}