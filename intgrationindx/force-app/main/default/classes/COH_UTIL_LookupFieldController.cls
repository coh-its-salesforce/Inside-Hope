/*
 * This is ther server side controller for the COH_UTIL_LookupField component
 * Tim Hughes
 */ 
public class COH_UTIL_LookupFieldController {
    
    /*
	 * This method builds a SOQL query based on the supplied parameters can returns a JSON string of the form [{'id':recordId,'primaryField':SObjectfield,'secondaryField':SObjectfield},{...}]
	 * Each object in the array in the JSON string is a record found in the SOQL query
     * 
     * @params String searchString						This string is prepended/appeneded with % to make the searchKey in the SOQL statements WHERE condition
     * @params String SObjectAPIName					The name of the SObject to search in the SOQL statement's FROM
     * @params String primaryFieldAPIName						This is the field that is searched in the SOQL statement's WHERE condition. The value of this field is also returned in the JSON string
     * @params String secondaryFieldAPIName					This is an additional field that is returned in the JSON string
     * @params Integer numberOfRecordsToShow			This is the number of records to return in the SOQL query.
     * @params String additionalSearchConditions		This string will be appended to the SOQL query's WHERE condtion. **Fields in this string must either be the primaryField, secondaryField, id, or declared in the additionalSelectFields parameter**
     * @params String additionalSelectFields			This string will be appeneded to the SOQL query's SELECT clause.
     * 
     * @return String									The JSON String representing the list of records returned from the SOQL query
     */ 
    @AuraEnabled
    public static String fetchLookUpValues(String searchString, String SObjectAPIName, String primaryFieldAPIName, String secondaryFieldAPIName, Integer numberOfRecordsToShow, String additionalSearchConditions, String additionalSelectFields) {
        String searchKey = '%' + String.escapeSingleQuotes(searchString) + '%';
        String returnString;
        
        if (COHUTIL.isValidStr(primaryFieldAPIName) && COHUTIL.isValidStr(SObjectAPIName)) {
            List<SObject> lstOfRecords;
            String queryString =  'SELECT id, ' + String.escapeSingleQuotes(primaryFieldAPIName);
            if (COHUTIL.isValidStr(secondaryFieldAPIName)) {
                queryString += ', ' + String.escapeSingleQuotes(secondaryFieldAPIName);
            }
            if (COHUTIL.isValidStr(additionalSelectFields)) {
                queryString += ', ' + String.escapeSingleQuotes(additionalSelectFields);
            }
            queryString += ' FROM ' + String.escapeSingleQuotes(SObjectAPIName) + ' WHERE ' + String.escapeSingleQuotes(primaryFieldAPIName) + ' LIKE: searchKey '; 
            if (COHUTIL.isValidStr(additionalSearchConditions)) {
                queryString += additionalSearchConditions;
            }
            queryString += ' ORDER BY createdDate DESC limit ' + numberOfRecordsToShow;
            
            try {
                System.debug(queryString);
                lstOfRecords = Database.query(queryString);   
            }
            catch (Exception e) {
                AuraHandledException auraException = new AuraHandledException('Class:COH_UTIL_LookupFieldController Method:fetchLookUpValues Error:There was an error querying the database');
                auraException.setMessage('Class:COH_UTIL_LookupFieldController Method:fetchLookUpValues Error:There was an error querying the database');
                throw auraException;
            }
            returnString = convertListToJSON(lstOfRecords, primaryFieldAPIName, secondaryFieldAPIName);
        }
        else {
                AuraHandledException auraException = new AuraHandledException('Class:COH_UTIL_LookupFieldController Method:fetchLookUpValues Error:Invalid parameters. primaryField and SObjectAPIName are required');
                auraException.setMessage('Class:COH_UTIL_LookupFieldController Method:fetchLookUpValues Error:Invalid parameters. primaryFieldAPIName and SObjectAPIName are required');
                throw auraException;
        }
        
        return returnString;
    }           
    
    /*
     * This method builds a SOQL query based on supplied parameters. It returns the value of a single field
     * 
     * @params id recordId								The recordId of the record to query. Used in the SOQL queries WHERE clause
     * @params String primaryField						The API name of the field to return
     * @params String SObjectAPIName					The API name of the object to query.
     * 
     * @return Object									The value of the field to return
     */ 
    @AuraEnabled
    public static Object getPrimaryFieldServer(String recordId, String primaryFieldAPIName, String SObjectAPIName) {
        String queryString = 'SELECT id, ' + String.escapeSingleQuotes(primaryFieldAPIName) + ' FROM ' + String.escapeSingleQuotes(SObjectAPIName) + ' WHERE id =: recordId LIMIT 1';
        SObject queryObject;
        
        if (!isValidId(recordId)) {
            AuraHandledException auraException = new AuraHandledException('Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:Invalid Id');
            auraException.setMessage('Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:Invalid Id');
            throw auraException;
        }
        
        try {
            queryObject = Database.query(queryString);   
        }
        catch (Exception e) {
            AuraHandledException auraException = new AuraHandledException('Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:There was an error querying the database');
            auraException.setMessage('Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:There was an error querying the database');
            throw auraException;            
        }
        
        return queryObject.get(primaryFieldAPIName);
    }
    
	/*
	 * This method takes a List of SObjects and converts in to a JSON string of the form [{'id':Object,'primaryField':Object,'secondaryField':Object},{...}].
	 * 
	 * @params List<SObject> listOfRecords					The list of SObjects to build into the JSON string
	 * @params String primaryField							The APIName of the field whose value should be put into the 'primaryField' field of the JSON objects
	 * @params String secondaryField						The APIName of the field whose value should be put into the 'secondaryField' field of the JSON objects. If no value should be put in the 'secondayrField' field, then this should be an empty string
	 * 
	 * @return String										The created JSON string
	 */     
    private static String convertListToJSON(List<SObject> listOfRecords, String primaryFieldAPIName, String secondaryFieldAPIName) {
        String JSONString;        
        JSONGenerator gen = JSON.createGenerator(false);
        
        gen.writeStartArray();
        for (SObject obj : listOfRecords) {
			gen.writeStartObject();
			gen.writeObjectField('id', obj.get('id'));
            gen.writeObjectField('primaryField', obj.get(primaryFieldAPIName));
            if (COHUTIL.isValidStr(secondaryFieldAPIName) && obj.get(secondaryFieldAPIName) != null) {
                gen.writeObjectField('secondaryField', obj.get(secondaryFieldAPIName));                
            }
            else {
                gen.writeObjectField('secondaryField', '');
            }                
            gen.writeEndObject();
        }
        gen.writeEndArray();
       	JSONString =  gen.getAsString();
        gen.close();        
        
        return JSONString;
    }
    
    /*
     * This method determines whether the supplied string is a possible Salesforce Id
     * 
     * @param String possibleId				The string that should be tested to determine if it is a possible Salesforce Id
     * 
     * @return boolean						returns true if the String is a possible Salesforce Id, otherwise false.
     */ 
    private static boolean isValidId(String possibleId) {
        return possibleId instanceOf Id;
    }
}