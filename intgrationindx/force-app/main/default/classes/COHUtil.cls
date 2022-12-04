/*
 * This the contains utility methods.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2014
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHUtil {
    
    public static final String STRING_TYPE = 'String';
    public static final String BOOLEAN_TYPE = 'Boolean';
    public static final String DECIMAL_TYPE = 'Decimal';
    public static final String DATE_TYPE = 'Date';
    public static final String INTEGER_TYPE = 'Integer';
    public static final String BOOLEAN_YES_NO_TYPE = 'Boolean Yes No';  // convert a Yes/No field into a Boolean used by WTPProcessLeadUtil.
    public static final Integer GUI_ID_LENGTH = 15;

    // Error log levels
    public static final String INFO = 'INFO';
    public static final String DEBUG = 'DEBUG';
    public static final String WARN = 'WARN';
    public static final String ERROR = 'ERROR';
    public static final String FATAL = 'FATAL';

    // Regular expression constants
    private static final String REGEX_WORD_BOUNDARY = '\\b';
    private static final String REGEX_ESCAPE = '\\';
    private static final String EMPTY_DELIMITER = '';
    private static final String REGEX_IGNORE_CASE = '(?i)';
    
    public static final String DIRECTOR = 'Director';
    public static final String DIR = 'Dir,';
    public static final String SVP_ITS = 'Gary Ahwah';
    public static final String CTO = 'Jason Roos';
    public static final String VP_CTO_INFRA = 'Jeffrey Randall';
    
    public static final Integer MAX_DELAY = 5000;       // milliseconds
    
    /*
     * DEPRECATED
     * 
     * Checks if a String is not null and has a length greater than 0.
     * 
     * @param   str     String to check.
     * @return          True if the String is valid, false otherwise.
     * 
     */
    public static Boolean isValidStr(String str) {
        if (str != null && str.length() > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    /*
     * Checks if a List is not null and is not empty.
     * 
     * @param   str     List to check.
     * @return          True if the List is valid, false otherwise.
     * 
     */
    public static Boolean isValidList(List<Object> lst) {
        if (lst != null && !lst.isEmpty() && lst.size() > 0) {
            return true;
        } else {
            return false;
        }
    }

    /*
     * Builds the equivalent of a "select * from <objectApiName> ".
     * 
     * @param   objectApiName       The object API name for the standard or custom object.
     * @return                      The SOQL string.
     * 
     */
    public static String buildSelectAllSOQLStatement (String objectApiName)  {
        if (!isValidStr(objectApiName)) {
            return null;
        }
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectApiName).getDescribe().fields.getMap();
 
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if (commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            } else {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        String soqlQuery = 'select ' + commaSepratedFields + ' from ' + objectApiName + ' ';
        return soqlQuery;
    }
    
    /*
     * Retrieves a list of active configuration objects that belong to a configuration group.
     * 
     * @param   applicationName         Name of the application where the configuration value will be used.
     * @param   configurationGroupName  Name of the configuration group for which the configuration 
     *                                  objects are being retrieved.
     * @return                          Returns a list of the configuration objects that belong to the
     *                                  configuration group.  If no such configuration objects are 
     *                                  found, null is returned.
     * 
     */
    public static List<COH_App_Configuration__c> getConfigurationGroup(String applicationName, String configurationGroupName) {
        if (!isValidStr(applicationName) || !isValidStr(configurationGroupName)) {
            return null;
        }
        List<COH_App_Configuration__c> objectList = null;
        try {
            objectList = [select Name, Value__c, Value_Type__c from COH_App_Configuration__c where Active__c = true and Configuration_Group__c = :configurationGroupName and Application_Name__c = :applicationName];
        } catch (Exception e) {
            return objectList;
        }
        return objectList;
    }        
    
    /*
     * Retrieve a configuration value from the active COH App Config object.
     * 
     * @param   applicationName     Name of the application where the configuration value will be used.
     * @param   configurationName   Name of the configuration property for which a value is requested.
     * @return                      Returns the configuration value for the configurationName property.
     *                              If the configuration value doesn't exist, null is returned.
     * 
     */
    public static Object getConfigurationValue(String applicationName, String configurationName) {
        if (!isValidStr(applicationName) || !isValidStr(configurationName)) {
            return null;
        }
        Object retVal = null;
        COH_App_Configuration__c configObj = null;
        try {
            configObj = [select Value__c, Value_Type__c from COH_App_Configuration__c where Active__c = true and Name = :configurationName and Application_Name__c = :applicationName limit 1];
            if (configObj != null) {
                String valueType = configObj.Value_Type__c;
                String value = configObj.Value__c;
                if (valueType.equalsIgnoreCase(STRING_TYPE)) {
                    retVal = value;
                } else if (valueType.equalsIgnoreCase(BOOLEAN_TYPE)) {
                    retVal = Boolean.valueOf(value);
                } else if (valueType.equalsIgnoreCase(DECIMAL_TYPE)) {
                    retVal = Decimal.valueOf(value);
                } else if (valueType.equalsIgnoreCase(DATE_TYPE)) {
                    retVal = Date.valueOf(value);
                } else if (valueType.equalsIgnoreCase(INTEGER_TYPE)) {
                    retVal = Integer.valueOf(value);
                } else {
                    return null;
                }
            }
        } catch (Exception e) {
            return null;
        }
        return retVal;
    }

    /*
     * Set a configuration value for an active COH App Config object.
     * 
     * @param   applicationName     Name of the application where the configuration value will be used.
     * @param   configurationName   Name of the configuration property for which a value is requested.
     * @param   newVal              New configuration value
     * 
     */
    public static void setConfigurationValue(String applicationName, String configurationName, Object newVal) {
        if (isValidStr(applicationName) && isValidStr(configurationName)) {
            COH_App_Configuration__c configObj = null;
            configObj = [select Id, Value__c, Value_Type__c from COH_App_Configuration__c where Active__c = true and Name = :configurationName and Application_Name__c = :applicationName limit 1];
            if (configObj != null) {
                String valueType = configObj.Value_Type__c;
                String value = configObj.Value__c;
                if (valueType.equalsIgnoreCase(STRING_TYPE)) {
                    configObj.Value__c = (String) newVal;
                } else if (valueType.equalsIgnoreCase(BOOLEAN_TYPE)) {
                    if (Boolean.valueOf(newVal)) {
                        configObj.Value__c = 'true';
                    } else {
                        configObj.Value__c = 'false';
                    }
                } else if (valueType.equalsIgnoreCase(DECIMAL_TYPE) ||
                           valueType.equalsIgnoreCase(DATE_TYPE) ||
                           valueType.equalsIgnoreCase(INTEGER_TYPE)){
                    configObj.Value__c = String.valueOf(newVal);
                } else {
                    throw new COHException ('COHUtil.setConfigurationValue() error: unrecorgnized valueType--> ' + valueType);
                }

                try {
                    Database.update(configObj);
                } catch (Exception e) {
                    throw new COHException ('COHUtil.setConfigurationValue() error: ' + e.getMessage());
                }
            }
        }
    }

    
    /*
     * Retrieve the name of an object with the given object ID.
     * 
     * @param   objectID    Object ID to search.
     * @return              Name of the object.
     * 
     */

    public static String getObjectName(Id objectID) {
        if (objectID == null) {
            return null;
        } else {
            Schema.SObjectType token = objectID.getSObjectType();
            Schema.DescribeSObjectResult dr = token.getDescribe();
            return(dr.getName());
        }
    }
    
    /*
     * Retrieve the record type ID for a given object type and the specific record type label.
     * 
     * @param   objectType          The object type 
     * @param   recordTypeLabel     The label used to identify the record type
     * @return                      The record type ID for the given object type and the type label
     * 
     */
    public static ID getRecordType(String objectType, String RecordTypeLabel)  {   
        SObject OBJ;  
        // Schema description
        Schema.SObjectType Res = Schema.getGlobalDescribe().get(objectType);
         
        if (Res != null)  {  
            OBJ = Res.newSObject();  
            // Object description
            Schema.DescribeSObjectResult DesRes = OBJ.getSObjectType().getDescribe();   
            if (DesRes != null)  {  
                Map<String, Schema.recordtypeinfo> RecordTypeMap =   DesRes.getRecordTypeInfosByName(); 
                
                if (RecordTypeMap != null) {  
                    Schema.RecordTypeInfo RecordTypeRes = RecordTypeMap.get(RecordTypeLabel); 
                    
                    if (RecordTypeRes != null)   {  
                        return RecordTypeRes.getRecordTypeId();  
                    }  
                }  
            }
        }
        return null;  
    }

    /*
     * DEPRECATED: replaced by standardizeIntegerLeft().
     * 
     * Generates a three character long String representation of a number.  For example, if 1 is passed
     * in as an argument, '001' is returned.  If 21 is passed in as an argument, '021' is returned.
     * 
     * @param   num     Numeric value from which a String is to be created.
     * @return          String representation of a number.
     * 
     */
    public static String generateNumberString(Integer num) {
        return standardizeIntegerLeft(num, '0', 3);
    }

    /*
     * Standardize an Integer by prepending characters where required.
     * 
     * @param   baseInteger     Integer to standardize.
     * @param   c               Character to add
     * @param   finalLength     Final length of the string
     * @return                  Standardized string form of the Integer.  if the Integer 
     *                          has more digits than the finalLength parameter, the String form of 
     *                          the original Integer is returned.
     * 
     */
    public static String standardizeIntegerLeft(Integer baseInteger, String c, Integer finalLength) {
        if (String.isNotEmpty(c)) {
            if (baseInteger >= 0 && finalLength > 0) {
                String intStr = String.valueOf(baseInteger);
                return intStr.leftPad(finalLength, c);
            } else {
                return String.valueOf(baseInteger);
            }
        } else {
            return null;
        }
    }        

    /*
     * Standardize an Integer by appending a character one or more times.
     * 
     * @param   baseInteger     Integer to standardize.
     * @param   c               Character to add
     * @param   finalLength     Final length of the string
     * @return                  Standardized string form of the Integer.  if the Integer 
     *                          has more digits than the finalLength parameter, the String form of 
     *                          the original Integer is returned.
     * 
     */
    public static String standardizeIntegerRight(Integer baseInteger, String c, Integer finalLength) {
        String retStr = null;
        if (String.isNotEmpty(c) && baseInteger >= 0 && finalLength > 0) {
            String intStr = String.valueOf(baseInteger);
            retStr = intStr.rightPad(finalLength, c);
        }
        return retStr;
    }        

    /*
     * Log a message. 
     * 
     * DO NOT USE THIS DIRECTLY.  THIS IS KEPT FOR BACKWARDS-COMPATIBILITY.
     * Use logInfoMessage, logDebugMessage, logWarnMessage, logErrorMessage,
     * or logFatanMessage instead.
     * 
     * @param application       Name of the application that generated the log message
     * @param level             Logging level
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logMessage(String application, String level, String location, String message) {
        COH_Log__c logObj = new COH_Log__c();
        logObj.Application_Name__c = application;
        logObj.Level__c = level;
        logObj.Location__c = location;
        logObj.Message__c = message;
        Database.insert(logObj, false);
    }
    
    /*
     * Log an INFO message.
     * 
     * @param application       Name of the application that generated the log message
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logInfoMessage(String application, String location, String message) {
        logMessage(application, INFO, location, message);
    }

    /*
     * Log a DEUBG message.
     * 
     * @param application       Name of the application that generated the log message
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logDebugMessage(String application, String location, String message) {
        logMessage(application, DEBUG, location, message);
    }

    /*
     * Log a WARN message.
     * 
     * @param application       Name of the application that generated the log message
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logWarnMessage(String application, String location, String message) {
        logMessage(application, WARN, location, message);
    }

    /*
     * Log a ERROR message.
     * 
     * @param application       Name of the application that generated the log message
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logErrorMessage(String application, String location, String message) {
        logMessage(application, ERROR, location, message);
    }

    /*
     * Log a FATAL message.
     * 
     * @param application       Name of the application that generated the log message
     * @param location          Location in the code where the log message was generated.
     * @param message           Log message.
     * 
     */
    
    public static void logFatalMessage(String application, String location, String message) {
        logMessage(application, FATAL, location, message);
    }

    /*
     * Implement a delay in the code execution.  The delay may actually be longer 
     * due to system or network reasons.
     * 
     * @param duration      Duration of the delay in milliseconds.
     * 
     */

    public static void delay(Long duration) {
        if (duration > MAX_DELAY) {
            throw new COHException ('Error: delay duration (' + duration + ') exceeds maximum value allowed--> ' + MAX_DELAY);
        }
        Long startTime = System.currentTimeMillis();
        while (true) {
            for (Integer j = 0; j < 1000; j++) {  // empty loop
            }
            Long currentTime = System.currentTimeMillis();
            Long currentDelay = currentTime - startTime;
            if (currentDelay >= duration) {
                break;
            }
        }
    }

    /*
     * Create a regular expression for literal search string by adding escapes for 
     * non-alphanumeric characters. If the matcheWholeWords parameter is true, 
     * add regular expressions for a whole word search.  For example, 
     * "[abc]*" would be transformed into "\[abc\]\*".
     * 
     * @param sourceStr         Original source string.
     * @param matchWholeWords   true if a whole word search is requested, false otherwise.
     * @param ignoreCase        true if the search is case-insensitive, false otherwise.
     * @return                  Regular expression search string with escapes for non-alphanumeric
     *                          characters and word boundaries as necessary.
     * 
     */
    public static String createLiteralRegExprSearchString(String sourceStr, Boolean matchWholeWords, Boolean ignoreCase) {
        String searchString = null;
        if (String.isNotBlank(sourceStr))  {
            List<String> chars = sourceStr.split(EMPTY_DELIMITER);
            chars.remove(0);        // Remove the first element.  It's an empty character.
            Integer maxLen = chars.size();
            for (Integer i = 0; i < maxLen; i++) {  
                String newChar = chars.get(i);
                // Add an escape character to non-alphanumeric or space characters
                if (newChar.isAlphanumericSpace()) {
                    chars.set(i, newChar);
                } else {
                    chars.set(i, REGEX_ESCAPE + newChar);
                }
            }
            if (matchWholeWords) {
                chars.add(0, REGEX_WORD_BOUNDARY);
                chars.add(REGEX_WORD_BOUNDARY);
            } 
            if (ignoreCase) {
                chars.add(0, REGEX_IGNORE_CASE);
            }
            searchString = String.join(chars, EMPTY_DELIMITER);
        }      
        return searchString;
    }

    /*
     * Ensures that an ID string is 18 characters long for Apex.  IDs obtained
     * from the GUI are 15 characters long
     * 
     * @param idToCheck         ID String to check.
     * @return                  18 character-length ID.
     * 
     */
    public static ID getLongID (String baseID) {
        Id longID = null;
        if (String.isNotEmpty(baseID)) {
            if (baseID.length() == GUI_ID_LENGTH) {
                longID = Id.valueOf(baseID);
            } else {
                longID = baseID;
            }
        }
        return longID;
    }

    /*
     * Puts a value into the field of an arbitrary SObject instance.
     * 
     * @param   sObj        Name of the application where the configuration value will be used.
     * @param   fieldName   Name of the field where the value will be stored.
     * @param   value       Value to be stored.
     * @param   valueType   Data type of the value to be stored.
     * 
     */
    public static void putSObjectValue(SObject sObj, String fieldName, String value, String valueType) {
        if (sObj != null && String.isNotEmpty(fieldName) && String.isNotEmpty(value) && String.isNotEmpty(valueType)) {
            if (valueType.equalsIgnoreCase(STRING_TYPE)) {
                sObj.put(fieldName, value);
            } else if (valueType.equalsIgnoreCase(BOOLEAN_TYPE)) {
                sObj.put(fieldName, Boolean.valueOf(value));
            } else if (valueType.equalsIgnoreCase(DECIMAL_TYPE)) {
                sObj.put(fieldName, Decimal.valueOf(value));
            } else if (valueType.equalsIgnoreCase(DATE_TYPE)) {
                sObj.put(fieldName, Date.valueOf(value));
            } else if (valueType.equalsIgnoreCase(INTEGER_TYPE)) {
                sObj.put(fieldName, Integer.valueOf(value));
            } else {
                throw new COHException('Error: COHUtil.putValue(): unrecognized valueType: ' + valueType);
            }
        } else {
            throw new COHException('Error: COHUtil.putValue(): invalid parameter');
        }
    }    
        

    /*
     * Convert a String 'Yes' or 'True' value to true.  Convert a String 'No'
     * or 'False' value to false. This is case-insensitive.
     * 
     * @param val   String value to convert.
     * @return      Boolean true if val is 'Yes', false otherwise.
     * 
     */
    public static Boolean convertToBoolean(String val) {
        Boolean retCode = false;
        if (String.isNotEmpty(val)) {
            String standardizedVal = val.toLowerCase();
            retCode = (standardizedVal == 'yes'  || standardizedVal == 'true' ? true : false);
        }
        return retCode;
    }
    
 
    /*
     * Create an email message
     * 
     * @param toUser				User object for the email recipient.  The email address
     * 								in the object takes precedent over the emailReplyToAddr
     * 								parameter.
     * @param replyToUser			User object for the email sender.  The email address
     * 								in the object takes precedent over the emailToAddr
     * 								parameter.
     * @param emailReplyToAddr		Email address for the sender.
     * @param emailToAddr			Email address for the recipient.
     * @param subject				Subject line of the email.
     * @param textBody				HTML text body of the email.
     * @return                      The email object that will be sent out.
     * 
     */
    public static Messaging.SingleEmailMessage createEmailMessage(User toUser,
                                                                  User replyToUser,
                                                                  String emailReplyToAddr,  
                                                                  String[] emailToAddr, 
                                                                  String subject,
                                                                  String textBody) {
        
        Messaging.SingleEmailMessage email = null;
		if ((toUser != null || COHUtil.isValidList(emailToAddr)) && 
            		(replyToUser != null || String.isNotEmpty(emailReplyToAddr)) &&
            		subject != null && textBody != null && emailReplyToAddr != null) {
                        
            email = new Messaging.SingleEmailMessage();
            String fromAddress = (replyToUser == null ? emailReplyToAddr : replyToUser.Email);
            email.setReplyTo(fromAddress);
            String[] toAddress = (toUser == null ? emailToAddr : new String[] {toUser.Email});
            email.setToAddresses(toAddress); 
            email.Subject = subject;
            email.setHTMLBody(textBody);
        }
        return email;
    }
 
	/*
	 * Return a list of picklist values for a field in an object.
	 * This was originally found in a Salesforce forum but modified.
	 * 
	 * @param  objectName				Name of the object.
	 * @param  fieldName					Name of the field.
	 * @param getOnlyActiveValues	True if only active values are to be retrieved, false otherwise.
	 * @return										List of picklist values for the field.
	 * 
	 */
   public static List<String> getPicklistValues(String objectName, String fieldName, Boolean getOnlyActiveValues) {
      List<String> values = new List<String>();
       if (String.isNotEmpty(objectName) && String.isNotEmpty(fieldName) )  {
           List<String> types = new List<String> {objectName};
          Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
          for(Schema.DescribeSobjectResult res : results) {
             for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                 if (getOnlyActiveValues) {
                     if (entry.isActive()) {
                    	values.add(entry.getValue());  
                     }
                 } else {
					values.add(entry.getValue());  
                 }
             }
          }
       }
      return values;
	}    

// testing--raymond tam
    /*
     * Retrieve the picklist values for a field
     * 
     * @return			List of mappings of picklist labels and values
     * 
     */
    public static List<Map<String, String>> getPicklistValuesMap(String objectName, String fieldName, Boolean getOnlyActiveValues) {
        List<Map<String, String>> valuesMapList = new List<Map<String, String>>();
        
        if (String.isNotEmpty(objectName) && String.isNotEmpty(fieldName) )  {
            List<String> types = new List<String> {objectName};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            for(Schema.DescribeSobjectResult res : results) {
                for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                    if (entry.isActive()) {
                        Map<String, String> tempMap = new Map<String, String>();
                        tempMap.put('label', entry.getLabel());
                        tempMap.put('value', entry.getValue());
                        valuesMapList.add(tempMap);
                    }
                }
            }
        }
        return valuesMapList;
    }
    
    
    /*
     * Retrieves all the dependent picklist values for a field.
     * 
     * @param sObjectName		Object Name.
     * @param fieldName				Name of the dependent field.
     * @return 								Map where the key is the Controlling field and the value is a list of Schema.PicklistEntry entries for the Controlling field.
     * 
     */
    public static Map<Object, List<Schema.PicklistEntry>> getDependentPicklistValues(String sObjectName, String fieldName) 
    {
        
        Map<Object,List<Schema.PicklistEntry>> dependentPicklistValues = null;
        if (String.isNotEmpty(sObjectName) && String.isNotEmpty(fieldName)) {
	        Schema.sObjectField dependentToken = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName);
            
            Schema.DescribeFieldResult depend = dependentToken.getDescribe();
            Schema.sObjectField controlToken = depend.getController();
            if (controlToken != null) {
                Schema.DescribeFieldResult control = controlToken.getDescribe();
                List<Schema.PicklistEntry> controlEntries = (control.getType() == Schema.DisplayType.Boolean ? null : control.getPicklistValues());
                
                String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
                dependentPicklistValues = new Map<Object,List<Schema.PicklistEntry>>();
                for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
                    if (entry.isActive()) {
                        List<String> base64chars =
                                String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
        
                        // Remove any empty values in the list. They mess up the processing.  
                        // Iterate in a reverse manner to avoid index out of bounds problem.
                        if (COHUtil.isValidList(base64chars)) {
                            Integer lastIndex = base64chars.size() - 1;
                            for (Integer i = lastIndex; i >= 0; i--) {
                                if (String.isEmpty(base64chars.get(i))) {
                                    base64chars.remove(i);
                                }
                            }
                        }
                        
                        for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ ) {
                            Object controlValue = (controlEntries == null ? (Object) (index == 1) : (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null));
                            Integer bitIndex = index / 6;
                            Integer bitShift = 5 - Math.mod( index, 6 );
                            if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ]) & (1 << bitShift)) == 0) {
                                continue;
                            }
                            if (!dependentPicklistValues.containsKey(controlValue)) {
                                dependentPicklistValues.put(controlValue, new List<Schema.PicklistEntry>());
                            }
                            dependentPicklistValues.get(controlValue).add(entry);
                        }
                    }
                }
            }
        }
        return dependentPicklistValues;
    }
    
    //Abhisheks Code for identifying the director & VP - 01/15/2017   
    public static User FindDirectorRecursive(User Employee) {
        if(Employee.Title.contains(DIR) || Employee.Title.contains(DIRECTOR))
        {
            return Employee;
        }
        else
        {
            if(Employee.ManagerId != null)
            {
                User objEmployeeDirector = [Select id, Name, ManagerId, Title from User where Id = :Employee.ManagerId and IsActive=true limit 1];
                if(objEmployeeDirector.Title.contains(DIRECTOR))
                {
                    return objEmployeeDirector;
                }
                else 
                {
                    if(objEmployeeDirector.ManagerId != null)
                    {
                        return(FindDirectorRecursive(objEmployeeDirector));
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            else
            {
                return null;
            }
        }
    }
    
    public static User FindDirectorVPRecursive(User Employee) {
        if(Employee.name == SVP_ITS || Employee.name == CTO)
        {
            return Employee;
        }
        else
        {
            if(Employee.ManagerId != null)
            {
                User objEmployeeVP = [Select id, Name, ManagerId, Title from User where Id = :Employee.ManagerId and IsActive=true limit 1];
                if(objEmployeeVP.name == SVP_ITS || objEmployeeVP.name == CTO)
                {
                    return objEmployeeVP;
                }
                else 
                {
                    if(objEmployeeVP.ManagerId != null)
                    {
                        return(FindDirectorVPRecursive(objEmployeeVP));
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            else
            {
                return null;
            }
        }
    }
    
     /*
     * It will calculate the days difference between two date & time fields exclude the weekends & Holidays.
     * 
     * @param startDate    :	startDate.
     * @param endDate	   :	endDate.
     * @return 			   :    returns the working days between the startDate & endDate exclude weekends & Holidays.					.
     * 
     */
 
     public static Integer calculateWorkingDays(Date startDate, Date endDate)  
     {          
        Set<Date> holidaysSet = new Set<Date>();  
       
        for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
        {  
            holidaysSet.add(currHoliday.Holiday_Date__c);  
        }  
         
        Integer workingDays = 0;  
         
        for(integer i=0; i <= startDate.daysBetween(endDate); i++)  
        {  
            Date dt = startDate + i;  
            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = currDate.format('EEEE');  
            if(todayDay != 'Saturday' && todayDay !='Sunday' && (!holidaysSet.contains(dt)))  
                {  
                    workingDays = workingDays + 1;  
                }     
               
        }  
              
         
        return workingDays;  
    }  
    
    
    //End of Code 03/26/2019
}