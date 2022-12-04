global class COH_EmailEscalatetoManagerSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
       /* COH_EmailEscalatetoManagerBatch exp = new COH_EmailEscalatetoManagerBatch();
       	String sch = '0 5 * * * ?';
       	string jobID = System.schedule('EscalateManager',sch,exp); */
       	ID BatchId = Database.executeBatch(new COH_EmailEscalatetoManagerBatch(), 200);
     /* 
        System.schedule('EscalateManager 1', '0 00 * * * ?', new COH_EmailEscalatetoManagerSchedule());
		System.schedule('EscalateManager 2', '0 05 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 3', '0 10 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 4', '0 15 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 5', '0 20 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 6', '0 25 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 7', '0 30 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 8', '0 35 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 9', '0 40 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 10', '0 45 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 11', '0 50 * * * ?', new COH_EmailEscalatetoManagerSchedule());
        System.schedule('EscalateManager 12', '0 55 * * * ?', new COH_EmailEscalatetoManagerSchedule());
       */
    }
}