trigger EmployeeCrisisAssessmentTrigger on EmployeeCrisisAssessment (before insert, before update) {
    if(trigger.isInsert && trigger.isBefore){
        EmployeeCrisisAssessmentTriggerHelper.doBeforeInsert(Trigger.New);
    }
    if(trigger.isUpdate && trigger.isBefore){
        EmployeeCrisisAssessmentTriggerHelper.doBeforeUpdate(Trigger.New, Trigger.oldMap);
    }
}