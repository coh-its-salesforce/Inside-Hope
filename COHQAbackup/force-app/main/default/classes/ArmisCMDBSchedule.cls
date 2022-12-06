global class ArmisCMDBSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        ArmisCMDBBatch  batchjob = new ArmisCMDBBatch();
        Database.executebatch(batchjob, 100); 
    }
}