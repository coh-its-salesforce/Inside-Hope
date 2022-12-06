public with sharing class PatientAccessEpicAccountController {
    @AuraEnabled
    //AuraEnabled for LWC patientAccessAccountEpicAccountDataGuarantor/Insurance component found in the Insurance tab and Guarantor tab on the Account Record for Patient Access.
    public static Epic_Account_Data__c getEpicAccountData(Id accountId){
        system.debug('AccountID : '+ accountId);
        Epic_Account_Data__c[] recEpicAccountDataSet = [SELECT Id from Epic_Account_Data__c where Account__c =: accountId];
        if(recEpicAccountDataSet.size() > 0){
            Epic_Account_Data__c recEpicAccountData = [            										
                										Select Id, 
									                	Name, 
                                                    	AccountMRN__c, 
                                                        Account__c, 
                                                        Account_MRN_Formula__c,
                                                        Insurance_Subscriber_First_Name_1__c,
                                                        Insurance_Subscriber_Last_Name_1__c,
                                                        Insurance_Subscriber_Middle_Name_1__c,
                                                        Insurance_Subscriber_First_Name_2__c,
                                                        Insurance_Subscriber_Last_Name_2__c,
                                                        Insurance_Subscriber_Middle_Name_2__c,
                                                        Insurance_Subscriber_First_Name_3__c,
                                                        Insurance_Subscriber_Last_Name_3__c,
                                                        Insurance_Subscriber_Middle_Name_3__c,
                                                        Insurance_Purchaser_Plan_1__r.name,
                                                        Insurance_Purchaser_Plan_2__r.name,
                                                        Insurance_Purchaser_Plan_3__r.name
                                                         from Epic_Account_Data__c where Account__c =: accountId
                                                      ];
            system.debug('query completed Data : '+recEpicAccountData);
            if(recEpicAccountData.AccountMRN__c == null && recEpicAccountData.Account_MRN_Formula__c !=null){
                recEpicAccountData.AccountMRN__c = recEpicAccountData.Account_MRN_Formula__c;
                update recEpicAccountData;
            }
            return recEpicAccountData;
        } else {
            Epic_Account_Data__c newEpicAccountData = new Epic_Account_Data__c(Account__c = accountId);
            insert newEpicAccountData;
            system.debug('query newEpicAccountData : ' + newEpicAccountData);
            return newEpicAccountData;
        } 
    }
    @AuraEnabled
    //for LWC patientAccessAccountEpicAccountDataInsurance to identify name of the purchaser plan record.
    public static String getPurchaserPlanName(Id purchaserPlanId){
        String purchaserPlanName = '';
        PurchaserPlan recPurchaserPlan = [select Id, name from PurchaserPlan where Id =: purchaserPlanId Limit 1];
        if(recPurchaserPlan != null){
        purchaserPlanName = recPurchaserPlan.name;
        }
        return purchaserPlanName;
    }
}