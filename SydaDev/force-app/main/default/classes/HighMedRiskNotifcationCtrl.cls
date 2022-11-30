public class HighMedRiskNotifcationCtrl {

    @InvocableMethod(label='Send High or Medium Risk Notification')
    public static void sendHighOrMediumRiskNotification(List<Id> recordIds){
        ExposureNotifcationHandler.sendNotification(recordIds,[SELECT id FROM EmailTemplate WHERE 
                                   DeveloperName = 'Medium_or_High_Risk_Employee_Exposure_Notification_Template'].Id);
    }
}