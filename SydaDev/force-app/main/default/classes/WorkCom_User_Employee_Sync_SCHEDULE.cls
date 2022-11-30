global class WorkCom_User_Employee_Sync_SCHEDULE implements Schedulable{
    global void execute(SchedulableContext SC) {
       	ID BatchId = Database.executeBatch(new WorkCom_User_Employee_Sync_Batch(), 200);
    }
    
}