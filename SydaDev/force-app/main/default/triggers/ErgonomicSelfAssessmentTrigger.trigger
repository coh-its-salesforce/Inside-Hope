trigger ErgonomicSelfAssessmentTrigger on Ergonomic_Self_Assessment__c (before insert) {

    if(trigger.isInsert && trigger.isBefore){
        ErgonomicSelfAssessmentHelper.pupulateUserDetail(trigger.New);
    }
}