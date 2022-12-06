trigger EHSRiskAssessmentQuestionaireTrigger on EHS_Risk_Assessment_Questionaire__c (before insert) {
    
    if(trigger.isBefore && trigger.isInsert){
        EHSRiskAssmntQuestrTriggerHelper.dobeforeInsert(Trigger.New);
    }

}