global class ServiceNowToRFSoftwareSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        ServiceNowSoftwareBatch  batchjob = new ServiceNowSoftwareBatch();
        Database.executebatch(batchjob, 100);
    }
}