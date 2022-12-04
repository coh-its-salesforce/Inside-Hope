/*
 * This class contains the methods for handling trigger events for Data Import Record objects.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */

public class COHDataImportHelper {

    private static final String APPLICATION_NAME = 'Foundation';
    private static final String FOUNDATION_AUTH_TYPE = 'Data Import Authorization Type';
    private static final String NAME_COMMA_DELIMITER = ',';
    private static final String NAME_SPACE_DELIMITER = ' ';
    private static final Integer MIN_NAMES_COUNT = 2;
	private static final Integer LAST_NAME_INDEX = 0;    
	private static final Integer FIRST_NAME_INDEX = 1;     
    private static String mFoundationAuthType;
    
    static {
        mFoundationAuthType = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, FOUNDATION_AUTH_TYPE);
    }
    
    public static void processRecords() {
        if (Trigger.isExecuting) {
			if (Trigger.isInsert) {	
                processRecords(Trigger.new);
            }
        }
    }

    /*
     * This method processes a list of Data_Import_Record__c. They are sorted according to record types,
     * and the resulting lists are processed by other objects.  Then delete all the 
     * Data_Import_Record__c objects.
     * 
     * @param   importRecordList		List of Data_Import_Record__c objects to process.
     * 
     */
    public static void processRecords(List<Data_Import_Record__c> importRecordList) {

        if (COHUtil.isValidList(importRecordList)) {

	        List<Data_Import_Record__c> validFoundationAuthRecords = new List<Data_Import_Record__c>();
    		List<String> validFoundationAuthMRNs = new List<String>();
            List<String> validFoundationAuthFirstNames = new List<String>();
            
			List<Id> recordsToDelete = new List<Id>();
            for (Data_Import_Record__c obj : importRecordList) {
                String processingType = obj.Processing_Type__c;
                if (processingType.equalsIgnoreCase(mFoundationAuthType)) {
                    validFoundationAuthRecords.add(obj);
                    validFoundationAuthMRNs.add(obj.Text_255_02__c);  // MRN number                    
                    
                    //Build a list of first names
                    List<String> namesList = obj.Text_255_03__c.split(NAME_COMMA_DELIMITER);
                    if (COHUtil.isValidList(namesList)) {
                        Integer tokenCount = namesList.size();
                        if (tokenCount == MIN_NAMES_COUNT) {                        
                    		validFoundationAuthFirstNames.add((namesList[FIRST_NAME_INDEX]).trim());  // First Name
                   			System.debug('validFoundationAuthFirstNames add-->' + (namesList[FIRST_NAME_INDEX]).trim());
                        }
                    }                    
                    
                    recordsToDelete.add(obj.Id);
                }  // if more types are processed, they should be added here in another IF block.
            }
            
            //  Invoke the proper methods to process the data and delete the 
            //  Data_Import_Record__c objects afterward.
            if (COHUtil.isValidList(validFoundationAuthRecords)) {
                FAUTHDataImportUtil.processFoundationAuthRecords(validFoundationAuthRecords, validFoundationAuthMRNs, validFoundationAuthFirstNames);
    	       Database.delete(recordsToDelete);
            }  
            
            // if more types are processed, they should be added here in another IF block.
        }
    }
        
}