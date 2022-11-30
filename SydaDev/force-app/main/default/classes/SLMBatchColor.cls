global class SLMBatchColor implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('select id from BMCServiceDesk__Incident_Service_Target__c');
    }
    global void execute(Database.BatchableContext context, List<SObject> scope){
    }
    global void finish(Database.BatchableContext context){
    }
/*    
    public string query = 'Select Id, Name, BMCServiceDesk__FKIncident__c, BMCServiceDesk__Support_Hour_Applied__c, BMCServiceDesk__Status__c, BMCServiceDesk__StartDate__c, BMCServiceDesk__ClockPauseDate__c, BMCServiceDesk__PausedDuration__c, BMCServiceDesk__TargetEndDate__c, BMCServiceDesk__ClockState__c, BMCServiceDesk__Service_Target_Duration__c,BMCServiceDesk__TargetType__c, BMCServiceDesk__Target_Duration__c from BMCServiceDesk__Incident_Service_Target__c WHERE BMCServiceDesk__ClockState__c <> \'Stopped\' AND BMCServiceDesk__ClockState__c <> \'Not Started\'';
    public boolean runTestMethod = false;
    
    global Database.QueryLocator start(Database.BatchableContext context){
     system.debug('start');
    system.debug('Testing: ' + runTestMethod);
        try{
            if(Test.isRunningTest()){
              query = query + ' order by Name Limit 50';
                system.debug('Entered Test Method');
            } 
        }catch (System.NullPointerException e){}
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, List<SObject> scope){
        system.debug('execute');
        //Build Incident list
        BMCServiceDesk__Incident__c a = new BMCServiceDesk__Incident__c();
        Map<Id, BMCServiceDesk__Incident__c> inc = new Map<Id, BMCServiceDesk__Incident__c>();
        Integer mapInt = 0;
        for (SObject rec : scope){
            BMCServiceDesk__Incident_Service_Target__c st = (BMCServiceDesk__Incident_Service_Target__c)rec;
            if (a != null){
                if (a.Id <> st.BMCServiceDesk__FKIncident__c){
                    a = new BMCServiceDesk__Incident__c();   
                }
            }


            Decimal timeCalc;
            Decimal remainingPct;
            Decimal duration = st.BMCServiceDesk__Service_Target_Duration__c;
            if (duration == 0.00 && st.BMCServiceDesk__Target_Duration__c == 0){
              duration = ReturnTimeMs(st.BMCServiceDesk__Support_Hour_Applied__c, st.BMCServiceDesk__StartDate__c, datetime.now());
                duration = (duration / 1000);  
            }
            else if (duration == 0.00 && st.BMCServiceDesk__Target_Duration__c != 0)
                duration = st.BMCServiceDesk__Target_Duration__c;
            System.debug('Target: ' + st.Name);
            if (st.BMCServiceDesk__Status__c != 'Missed' && st.BMCServiceDesk__ClockState__c == 'Paused'){
                //Paused
                timeCalc = ReturnTimeMs(st.BMCServiceDesk__Support_Hour_Applied__c, st.BMCServiceDesk__StartDate__c, st.BMCServiceDesk__ClockPauseDate__c);
                timeCalc = timeCalc - st.BMCServiceDesk__PausedDuration__c;
                remainingPct = (timeCalc / 1000) / (duration * 60);
            } else if (st.BMCServiceDesk__Status__c != 'Missed' && st.BMCServiceDesk__ClockState__c != 'Paused'){
                //Running   
                if (st.BMCServiceDesk__PausedDuration__c == null || st.BMCServiceDesk__PausedDuration__c == 0){
                    timeCalc = ReturnTimeMs(st.BMCServiceDesk__Support_Hour_Applied__c, st.BMCServiceDesk__StartDate__c, datetime.now());
                      
                    remainingPct = (timeCalc / 1000) / (duration * 60);
                } else {
                    System.debug('Paused Duration');
                        timeCalc = ReturnTimeMs(st.BMCServiceDesk__Support_Hour_Applied__c, st.BMCServiceDesk__StartDate__c, datetime.now());
                        timeCalc = timeCalc - st.BMCServiceDesk__PausedDuration__c;
                    remainingPct = (timeCalc / 1000) / (duration * 60);
                }         
            } else {
                remainingPct = 1.00;   
            }
            system.debug('Remaining PCT: ' + remainingPct.setScale(2));
            //Do processing here
            if (st.BMCServiceDesk__TargetType__c == 'ResponseTime'){
                a.Id = st.BMCServiceDesk__FKIncident__c;
                a.SLAResponseColor__c = remainingPct.SetScale(2);
                inc.put(st.BMCServiceDesk__FKIncident__c, a);
            } else {
                a.Id = st.BMCServiceDesk__FKIncident__c;
                a.SLAResolveColor__c = remainingPct.SetScale(2);
                inc.put(st.BMCServiceDesk__FKIncident__c, a);
            }
            mapInt = mapInt + 1;
        }
        update inc.values();
    }
    global void finish(Database.BatchableContext context){
        System.debug('finish');   

    }
    
    public Long ReturnTimeMs(Id hours, DateTime start, DateTime endTime){
        Long msTime;
        System.debug('Time Values: ' + start + ' End: ' + endTime);
        msTime = BusinessHours.diff(hours, start, endTime);
        System.debug('Time return: ' + msTime);
        return msTime;
    }
    
    public Decimal convertMs (Long timeMs){
        Decimal returnSec;
        returnSec = (timeMS / 1000);
        System.debug('Returned Seconds: ' + returnSec);
        return returnSec;
    }
    
*/
}