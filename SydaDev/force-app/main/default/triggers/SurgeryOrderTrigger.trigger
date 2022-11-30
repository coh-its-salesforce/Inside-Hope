trigger SurgeryOrderTrigger on Surgery_Order__c (before insert, before update) {
    // before insert
    SurgeryOrderTriggerHelper.validateMRNNumber(trigger.New, Trigger.oldMap);
}