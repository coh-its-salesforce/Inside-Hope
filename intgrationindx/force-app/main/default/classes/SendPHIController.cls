/*
* This class handles send the PHI Release Forms for Lightning components.
* 
* Ashok
* City of Hope 
* Copyright (c) 2017
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
public class SendPHIController {
    @AuraEnabled
    public static account getacc(string accId){
        Account acc=[select id, name,PersonEmail, LastName, FirstName,COH_Account_ID__c from Account where id = :accId];
        return acc;
    }
    @AuraEnabled
    public static Case getcase(String caseId){
        Case ca=[select id, Contact_Email__c,contact.id, Contact.LastName, Contact.FirstName from Case where id = :caseId];
        return ca;
    }
    @AuraEnabled
    public static Case getFoundationCaseServer(string caseId){
        Case caseRecord = [SELECT id, Account.PersonEmail, Account.FirstName, Account.LastName, Account.COH_Account_Id__c FROM Case WHERE id = :caseId];
        return caseRecord;
    }    
}