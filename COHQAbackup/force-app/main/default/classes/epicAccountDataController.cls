public with sharing class epicAccountDataController {
    
    @AuraEnabled(cacheable=false)   
    public static String createEpicRecord(Epic_Account_Data__c epicRecord,String accId){
        system.debug(logginglevel.debug, 'Start clsQuoteRevisionLWC = Quote            ' +  epicRecord);
        try{
            insert epicRecord;
            system.debug('AccountId-----'+accId);
            Account accRecord= [Select id,IsRead__c from Account Where id=:accId];
            accRecord.IsRead__c=false;
            update accRecord;
            return String.valueOf(epicRecord.Id);
        }
        catch(Exception ex){
            System.debug(ex.getMessage()+ex.getStackTraceString()+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        
        
    }
    
    @AuraEnabled(cacheable=false)   
    public static String updateEpicRecord(Epic_Account_Data__c epicRecord, String epicRecordId){
        String result ='FAILED';
        epicRecord.Id=epicRecordId;
        try{
            update epicRecord;
            result='SUCCESS';
            return result;
        }
        catch(Exception ex){
            system.debug(ex.getMessage()+ex.getStackTraceString()+Ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        
        
    }
    @AuraEnabled(cacheable=false)   
    public static Account getAccountDetails(String accountRecordId){
        try{
            Account accList=[SELECT Id, Name,Patient_First_Name__c,Patient_Last_Name__c,
                             Middle_Name__c,MiddleName,Gender__pc,Patient_Street1__c,Patient_City__c,COH_PA_State__c,Patient_Postal_Code__c,Primary_Phone_Number__c,
                             COH_Account_PatientAccess_SSN__c,PersonBirthdate,COH_PA_Country__c
                             FROM Account Where id=:accountRecordId];
            return accList;
            //return JSON.serialize(accList);
            
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled(cacheable=false)   
    public static Epic_Account_Data__c getEpicRecordDetails(String ObjRecId){
        String selectedObj;
        Epic_Account_Data__c epicRecord;
        Schema.SObjectType AccountObject = Schema.Account.getSObjectType();
        Schema.SObjectType record = Id.valueOf(ObjRecId).getSObjectType();
        
        If(record == AccountObject){
            selectedObj='Account__c';
        }else{
            //String Accountid = 
            selectedObj='Account__c';
            ObjRecId = [Select id,AccountId from Case where id =:ObjRecId LIMIT 1].AccountId;
        }
        
        
        
        try{
            String accQuery='Select id from Epic_Account_Data__c where ' +selectedObj+'=\'' + ObjRecId + '\'';
            System.debug('accQuery query --------'+accQuery);
            List<Epic_Account_Data__c> epicRec =Database.query(accQuery);
            
            if(!epicRec.isEmpty()){
                String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Epic_Account_Data__c') + ' where Id =\''+ epicRec[0].Id+ '\'';
                System.debug('epic query --------'+soqlQuery);
                Epic_Account_Data__c[] epicList = Database.query(soqlQuery);
                
                //List<Epic_Account_Data__c> epicList = Database.query(soqlQuery);
                if (epicList.size() > 0){
                    epicRecord = epicList[0]; 
                }
            }
               
        }
        catch(Exception ex){
            System.debug(ex.getLineNumber()+ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
            
        }
        return epicRecord;
    }
    
}