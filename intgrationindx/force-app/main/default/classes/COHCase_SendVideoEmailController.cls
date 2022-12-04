public class COHCase_SendVideoEmailController {

    @AuraEnabled
    public static void sendVideoEmail(string recordId){
        COHCaseInsuranceTabController.sendVideoEmail(recordId);
        Case data = [SELECT Id, AccountId,Account.Email_Video_Sent__c  FROM Case WHERE Id=:recordId];
        if(data.Account <> null && !data.Account.Email_Video_Sent__c) UPDATE new Account(Email_Video_Sent__c=TRUE,Id=data.AccountId);
    }
}