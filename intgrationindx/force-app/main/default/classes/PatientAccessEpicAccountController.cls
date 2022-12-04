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
                                                        Account__c, 
                										AccountMRN__c,
                                                        Account__r.PersonBirthdate,
                                                        Account__r.COH_Account_PatientAccess_SSN__c,
                                                        Account__r.Gender__pc,
                                                        Account__r.FirstName,
                                                        Account__r.LastName,
                                                        Account__r.MiddleName,
                                                        Account__r.PersonHomePhone,
                                                        Account__r.PersonMobilePhone,
                                                        Account__r.PersonOtherPhone,
                                                        Account__r.SSN__c,
                                                        Account__r.Patient_Street1__c,
                                                        Account__r.COH_PA_State__c,
                                                        Account__r.COH_PA_Country__c,
                                                        Account__r.Patient_City__c,
                                                        Account__r.Patient_Postal_Code__c,
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
                                                        Insurance_Purchaser_Plan_3__r.name,
                                                        Patient_Relationship_to_Subscriber_1__c,
                                                        Patient_Relationship_to_Subscriber_2__c,
                                                        Patient_Relationship_to_Subscriber_3__c,
                                                        Subscriber_ID_1__c,
                                                        Subscriber_ID_2__c,
                                                        Subscriber_ID_3__c
                                                        from Epic_Account_Data__c where Account__c =: accountId Limit 1
                                                      ];
            system.debug('query completed Data : '+recEpicAccountData);
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