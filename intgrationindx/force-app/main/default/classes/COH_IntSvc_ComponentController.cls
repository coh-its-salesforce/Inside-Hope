/*
 * Controller for the the Custom Components to display sections for the International Services Application
 * Used by COH_IntSvc_SectionSix & COH_IntSvc_SectionSeven
 * 
 * Tim Hughes
 */ 
public class COH_IntSvc_ComponentController {
    PRIVATE STATIC FINAL LIST<STRING> SECTION_SIX = new List<String> {
        'Items_applicant_will_have_access_to__c',
        'Export_Administration_Regulations__c',
        'International_Traffic_in_Arms_Regulation__c',
        'Research_made_publicly_available__c',
        'Access_knowledge_technology_for_purposes__c'
    };
    PRIVATE STATIC FINAL LIST<STRING> SECTION_SEVEN = new List<String> {
        'Cultural_Learning_Opportunities__c',
        'Certified_English_Proficiency__c',
        'Recognized_English_Language_Test__c',
        'Date_of_English_Proficiency_Interview__c',
        'English_Proficiency_Interviewer_Name__c',
        'English_Proficiency_Interview_Duration__c',
        'English_Proficiency_Interview_Conducted__c'
    };
    
    /*
     * This function returns a Visa__c record based on supplied parameters. 
     * 
     * @param id recordId               The record Id of the Visa__c record to return
     * @param String fieldsToQuery      The fields that should be included in the SOQL query. 
     *                                  Also the fields that are available in the Visa__c record that is returned
     * 
     * @return  Visa__c                 The Visa__c record that was obtained in the query. 
     *                                  If the recordId is null or the fieldsToQuery is a empty string/null then return a new Visa__c record.
     */ 
    @AuraEnabled
    public static Visa__c getRecordServer(id recordId, String fieldsToQuery) {
        Visa__c recordToReturn;
        String queryString;
            
        if (recordId != null && COHUtil.isValidStr(fieldsToQuery)) {
            queryString = 'SELECT ' + fieldsToQuery + ' FROM Visa__c ';
            queryString += 'WHERE id =: recordId';
            try {
                recordToReturn = Database.query(queryString);
            }
            catch (Exception e) {
                throw new AuraHandledException('There was an error loading the record | Error: ' + e.getMessage());
            }
        }
        else {
            recordToReturn = new Visa__c();
        }
        return recordToReturn;
    }   

    /*
     * This function returns a JSON string of used in the calling components to populate picklist values
     * 
     * @param String section            Which component to generate picklist values for
     * 
     * @return String                   The JSON generated JSON string. If the section parameter is invalid, returns null.
     */ 
    @AuraEnabled 
    public static String getPicklistsServer(String section) {
        String jsonReturnValue;
            
        if (section == 'Section Six') {
            jsonReturnValue = convertPicklistEntriesToJSON(SECTION_SIX);            
        }
        else if (section == 'Section Seven') {
            jsonReturnValue = convertPicklistEntriesToJSON(SECTION_SEVEN);            
        }
        return jsonReturnValue;
    }

    /*
     * This function upserts a Visa__c record
     * 
     * @param Visa__c visaRecord        The Visa__c record to be upserted
     */ 
    @AuraEnabled
    public static void saveSectionServer(Visa__c visaRecord) {
        try {
        	visaRecord.Section_6_and_7__c = true ;
            upsert visaRecord;
        }
        catch (Exception e) {
            throw new AuraHandledException('There was an error saving the section | Error: ' + e.getMessage());
        }
    }
    
//  ------------  Private Functions  ------------  //

    /*
     * Private function that takes a list of field names, and returns their picklist values as a JSON string. Format is: {[Field Name: {value, label}]}
     *
     * @param List<String> picklistToUse                The list of field names to get picklist values for.
     */ 
    private static String convertPicklistEntriesToJSON(List<String> picklistToUse){
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get('Visa__c').getDescribe().fields.getMap();
        String JSONString;
        JSONGenerator gen = JSON.createGenerator(false);
        
        gen.writeStartobject();
        for (String currentField : picklistToUse) {
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