public with sharing class PatientAccessCaseAccountController {
    @AuraEnabled
    //AuraEnabled for LWC patientAccessCaseAccountDetails
    public static Account getAccountData(Id caseId){
        Case recCase = [SELECT Id, accountId from Case where Id =: caseId];        
        Account recAccount = [SELECT ID from account where Id =: recCase.accountId];
            return recAccount;      
    }
}