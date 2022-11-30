trigger COHITPMLifecycleTrigger on IT_Portfolio_Management__c (before update) {
    if(trigger.isbefore && trigger.isupdate){
        COHITPMLifecycleHelper.calculateHoursBurned(Trigger.new);
    }
}