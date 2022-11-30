trigger GovernmentSurveyTrigger on Government_Survey__c (before insert) {
    if(trigger.isInsert && trigger.isBefore){
        GovernmentSurveyHelper.pupulateUserDetail(trigger.New);
    }
}