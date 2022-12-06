trigger IncidentBeforeEventListener on BMCServiceDesk__Incident__c (before insert, before update, after update) {

    IncidentUtil handler = new IncidentUtil();
    if (trigger.isInsert && trigger.isBefore) {handler.onBeforeInsert(trigger.new);}    
    if (trigger.isUpdate && trigger.isBefore) {handler.onBeforeUpdate(trigger.old, trigger.new);}    
    if (trigger.isUpdate && trigger.isAfter) {
        handler.onAfterInsert(trigger.new);
    }
    /*
    if (trigger.isInsert) {handler.onBeforeInsert(trigger.new);}
    if (trigger.isUpdate && trigger.isBefore) {handler.onBeforeUpdate(trigger.old, trigger.new);}
    if (trigger.isUpdate && trigger.isAfter)
    {
        handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    */
}