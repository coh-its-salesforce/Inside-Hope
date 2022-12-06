trigger trgContactTraceLoader on Contact_Trace_Loader__c (before insert) {
   SET<String> EmplNumList = new SET<String>();
   String BatchId;
   String IP_Tracer_Number;
   for(Contact_Trace_Loader__c ctl : Trigger.New) {
       EmplNumList.add(ctl.Employee_Number__c);
       IP_Tracer_Number = ctl.IP_Tracer_Number__c;
    }   
    LIST<user> u = [Select Id, EmployeeNumber, Mgr__r.Email, Mgr__r.Name, Mgr__r.Id From User Where EmployeeNumber in :EmplNumList];
    MAP<String, Id> mapUser = new MAP<String, Id>();
    MAP<String, String> mapUserManagerEmail = new MAP<String, String>();
    MAP<String, Id> mapUserManagerId = new MAP<String, Id>();
    for(User u1 : u) {
       mapUser.put(u1.EmployeeNumber, u1.Id);
       mapUserManagerEmail.put(u1.EmployeeNumber, u1.Mgr__r.Email);
       mapUserManagerId.put(u1.EmployeeNumber, u1.Mgr__r.Id);
    } 
    if (Trigger.isInsert) { 
       for(Contact_Trace_Loader__c ctl : Trigger.New) {
           
       }
        Contact_Tracer_Source_Reference__c ctsr = new Contact_Tracer_Source_Reference__c();
        ctsr.IP_Tracer_Number__c = IP_Tracer_Number;
        insert ctsr;
        BatchId = ctsr.Id;
        
       for(Contact_Trace_Loader__c ctl : Trigger.New) {
           ctl.Lookup_User__c = mapUser.get(ctl.Employee_Number__c);
           ctl.Manager_Email__c = mapUserManagerEmail.get(ctl.Employee_Number__c);
           ctl.Manager_Id__c = mapUserManagerId.get(ctl.Employee_Number__c);
           if (mapUserManagerId.get(ctl.Employee_Number__c) != null ) {
           	ctl.OwnerId = mapUserManagerId.get(ctl.Employee_Number__c);
           }
           ctl.Contact_Tracer_Source_Reference__c = BatchId;   
        }   
    }
    
}