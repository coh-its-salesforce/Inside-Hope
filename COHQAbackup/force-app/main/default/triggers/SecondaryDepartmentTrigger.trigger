trigger  SecondaryDepartmentTrigger on Secondary_Department__c (before insert) {
    if(trigger.isInsert && Trigger.isBefore){
        DepartmentOperations.mutipleSecondaryCheck(Trigger.new);
    }
    

}