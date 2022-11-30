trigger ChangeEventListener on BMCServiceDesk__Change_Request__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    Map<String,String> StatusIdMap = new Map<String,String>();
    for(BMCServiceDesk__Status__c stat : [Select name,Id from BMCServiceDesk__Status__c where BMCServiceDesk__appliesToChange__c = True]){
        StatusIdMap.put(stat.Name,stat.ID);
    } 
 
    ChangeUtils handler = new ChangeUtils();
    
    if (trigger.isInsert && trigger.isAfter) {handler.onAfterInsert(trigger.new);}
    if (trigger.isUpdate && trigger.isAfter) {handler.onAfterUpdate(trigger.old, trigger.new);}
    if (trigger.isUpdate && trigger.isBefore) {handler.onBeforeUpdate(trigger.old, trigger.new);
    /*    for(BMCServiceDesk__Change_Request__c cr : trigger.new){
        if(cr.isSubmitted__C == True && cr.BMCServiceDesk__FKStatus__c != StatusIdMap.get('DRAFT') && cr.Change_Executor__c == null){
            cr.adderror('Change Executor is required for the record to be Approved.');
        }
    }*/
    }
    if (trigger.isInsert && trigger.isBefore) {
        for(BMCServiceDesk__Change_Request__c cr : trigger.new){
            cr.BMCServiceDesk__FKStatus__c = StatusIdMap.get('DRAFT');
        }
    }
    
}