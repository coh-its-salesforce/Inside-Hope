/*
 * This is the APEX controller for the COH_UIR (Universal Intake Request form) lightning components.
 * 
 * Tim Hughes
 */
public class COH_UIR_CEAFormController {
    // List of picklists for the various sections in the forms. 
    // Could be moved to COH App Config, but any changes in the values of the lists would need to be updated in the Lightning Components anyways.
    PRIVATE STATIC FINAL LIST<STRING> CEA_FORM_PICKLISTS = new List<String> {
        'COH_CEA_Funding__c',
        'COH_CEA_ProjectCategory__c',
        'COH_CEA_OtherClassificationUpgrades__c',
        'COH_CEA_ProjectClassification__c',
        'COH_CEA_DispositionReason__c',
        'COH_CEA_ReviewedByLegalFinance__c',
        'COH_CEA_AssetClassification__c',
        'COH_CEA_GrantCategory__c',
        'COH_CEA_NeedElectronicTrackingTag__c',
        'COH_CEA_RenderedObsolete__c',
        'COH_CEA_CannotBeLeased__c',
        'COH_CEA_ApprovedInBudgetProcess__c',
        'COH_CEA_ReplacingApprovedItem__c',
        'COH_CEA_UrgetRushRequest__c',
        'COH_CEA_InHouseMaintenance__c',
        'COH_CEA_TransferDepartment__c',
        'COH_CEA_CoordinatedWithITSFacilities__c',
        'COH_CEA_RequestType__c',
        'COH_CEA_ApprovedByCapitalGovernance__c',
        'COH_CEA_IsNewRequest__c',
        'COH_CEA_ApprovedDuringBudgetProcess__c',
        'COH_CEA_FundingSource__c',
        'COH_CEA_VettedByEIC__c'
    };
    
    /*
     * This method returns a COH_UniversalIntakeRequest. If a record id is supplied it returns that record, otherwise it returns a new record
     * 
     * @param id recordId 							The record id of the record to return, if null returns a new record
     * 
     * @return COH_UniversalIntakeRequest__c		The COH_UniversalIntakeRequest that is being returned
     */ 
    @AuraEnabled 
    public static COH_CEAForm__c getRecordServer(id recordId) {
        COH_CEAForm__c recordToReturn;
        
        if (recordId == null) {
            recordToReturn = new COH_CEAForm__c();
        }
        else {
            string queryString = COHUtil.buildSelectAllSOQLStatement('COH_CEAForm__c');
            queryString += 'WHERE id=\'' + recordId + '\'';
            try {
                recordToReturn = Database.query(queryString);
            }
            catch (Exception e){
                throw new AuraHandledException('There was an error loading the record.');
            }
        }
        return recordToReturn;
    }
    
    @AuraEnabled
    public static void saveRecordServer(COH_CEAForm__c recordToSave) {
        try {
            upsert recordToSave;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*
     * This method returns all the picklist values as for the Project Information section as a JSON string
     * 
     * @param String formSection			A parameter passed by the client side controller, indicating which section of the form to return picklists for.
     * 										Which global variable to use is determined by this parameter
     */ 
    @AuraEnabled
    public static String getPicklistsServer(String formSection) {
        String returnValue = null;
        if (formSection == 'CEA Form') {
            returnValue = convertPicklistEntriesToJSON(CEA_FORM_PICKLISTS);
        }        
        
		return returnValue;
    }
  
//  ------------  Private Functions  ------------  //

    /*
     * Private function that takes a list of field names, and returns their picklist values as a JSON string. Format is: {[Field Name: {value, label}]}
	 *
	 * @param List<String> picklistToUse				The list of field names to get picklist values for.
     */ 
    private static String convertPicklistEntriesToJSON(List<String> picklistToUse){
		Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get('COH_CEAForm__c').getDescribe().fields.getMap();
        String JSONString;
        JSONGenerator gen = JSON.createGenerator(false);
        
        gen.writeStartobject();
        for (String currentField : picklistToUse) {
            System.debug(currentField);
			List<Schema.PicklistEntry> picklistEntries = fieldsMap.get(currentField).getDescribe().getPicklistValues();
            gen.writeFieldName(currentField);
            gen.writeStartArray();
            for (Schema.PicklistEntry i: picklistEntries) {
                gen.writeStartObject();
                gen.writeStringField('label', i.getLabel());
                gen.writeStringField('value', i.getValue());
                gen.writeEndObject();
            }
            gen.writeEndArray();             
        } 
        gen.writeEndObject();
       	JSONString =  gen.getAsString();
        gen.close();
        
        return JSONString;
    }
}