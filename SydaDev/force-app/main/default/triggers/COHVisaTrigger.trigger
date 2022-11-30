trigger COHVisaTrigger on Visa__c (after update) {
    if(trigger.isafter && trigger.isupdate)
    {
       // COHVisaHelper.scanVisastoDeactivate(Trigger.new);
    }
    
}