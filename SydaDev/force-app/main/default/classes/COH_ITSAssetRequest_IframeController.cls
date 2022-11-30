/*
 * Server side controller for the COH_ITSAssetRequest_IFrame Component
 * 
 * Tim Hughes
 */ 
public class COH_ITSAssetRequest_IframeController {
	
    /*
     * Method to get the employee id for the Dept. Manager and Employee. The id is multiplied by 3.14159 as a form of encryptioni
     * 
     * @param id recordId				The salesforce Id for the ITS Asset request
     * 
     * retrn ITSAssetRequest__c			The ITS Asset request record with its employee ids adjusted.
     */ 
    @AuraEnabled
    public static ITSAssetRequest__c getITSAssetRecordServer(Id recordId){
        String employeeId;
        ITSAssetRequest__c currentRequest;

        try {
             currentRequest = [SELECT Employee__r.EmployeeNumber FROM ITSAssetRequest__c WHERE id=:recordId];
        }
        catch (Exception e) {
            throw new AuraHandledException('Invalid Salesforce Id. Please contact your Salesforce Administrator');
        }

        employeeId = currentRequest.Employee__r.EmployeeNumber;

        if (employeeId != null && employeeId.isNumeric()) {
            currentRequest.Employee__r.EmployeeNumber = String.valueOf(Integer.valueOf(employeeId) * 3.14159);
        }
        else {
            throw new AuraHandledException('The Employee contains an invalid Employee Id. Please contact your Salesforce Administrator');
        }
        return currentRequest;
    }
}