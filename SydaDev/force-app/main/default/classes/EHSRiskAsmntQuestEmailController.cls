public class EHSRiskAsmntQuestEmailController {

    @AuraEnabled
    public static void updateNotification(Id recordId){
        update new EHS_Risk_Assessment_Questionaire__c(Id=recordId,  Notify_Employee__c = true);
    }
}