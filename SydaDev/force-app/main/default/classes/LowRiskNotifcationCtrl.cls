public class LowRiskNotifcationCtrl {

    @InvocableMethod(label='Send Low Risk Notification')
    public static void sendLowRiskNotification(List<Id> recordIds){
        ExposureNotifcationHandler.sendNotification(recordIds,[SELECT id FROM EmailTemplate WHERE 
                                   DeveloperName = 'Low_Risk_Employee_Exposure_Notification_Template'].Id);
    }
}