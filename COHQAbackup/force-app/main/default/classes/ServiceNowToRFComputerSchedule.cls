global class ServiceNowToRFComputerSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        ServiceNowComputerBatch  batchjob = new ServiceNowComputerBatch();
        Database.executebatch(batchjob, 100); 
    }
}