global class COH_InactiveInsuranceMatrixBatch implements Database.Batchable<sObject>,schedulable {
    
     global void execute(SchedulableContext sc) {
        Database.executebatch(new COH_InactiveInsuranceMatrixBatch());
    }

    global Database.QueryLocator  start(Database.BatchableContext bc) {
        
        Date todayDate = system.today();
        string query = 'SELECT Id, inactive__c, Term_Date__c FROM Insurance_Matrix__c where inactive__c = false and  Term_Date__c!=null and Term_Date__c <=:todayDate';
        return database.getqueryLocator(query);
        // collect the batches of records or objects to be passed to execute
    }
    global void execute(Database.BatchableContext bc, List<Insurance_Matrix__c> records){
        // process each batch of records
        for(Insurance_Matrix__c record : records){
            record.inactive__c = true;
        }
        
        update records;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}