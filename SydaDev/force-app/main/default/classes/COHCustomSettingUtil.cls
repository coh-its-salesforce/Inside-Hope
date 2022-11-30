/*
 * This the contains utility methods for accessing Custom Setting objects
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2018
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHCustomSettingUtil {
    
    public static final String STRING_TYPE = 'String';
    public static final String BOOLEAN_TYPE = 'Boolean';
    public static final String DECIMAL_TYPE = 'Decimal';
    public static final String DATE_TYPE = 'Date';
    public static final String INTEGER_TYPE = 'Integer';
    
    /*
     * Retrieves a list of active Custom Setting objects that belong to a configuration group.
     * 
     * @param	applicationName			Name of the application where the configuration value will be used.
     * @param	configurationGroupName	Name of the configuration group for which the Custom Setting 
     * 									objects are being retrieved.
     * @return							Returns a list of the Custom Setting objects that belong to the
     * 									configuration group.  If no such Custom Setting objects are 
     * 									found, null is returned.
     * 
     */
    public static List<COH_Config_Setting__c> getCustomSettingConfigurationGroup(String applicationName, String configurationGroupName) {
        List<COH_Config_Setting__c> objectList = null;
        if (String.isNotEmpty(applicationName) && String.isNotEmpty(configurationGroupName)) {
            try {
                objectList = [select Name, Value__c, Value_Type__c from COH_Config_Setting__c where Active__c = true and Configuration_Group__c = :configurationGroupName and Application_Name__c = :applicationName];
            } catch (Exception e) {
                return objectList;
            }
        }
        return objectList;
    }        

    /*
     * Retrieve a configuration value from the active Custom Setting object.
     * 
     * @param	applicationName		Name of the application where the configuration value will be used.
     * @param	configurationName	Name of the configuration property for which a value is requested.
     * @return						Returns the configuration value for the configurationName property.
     * 								If the configuration value doesn't exist, null is returned.
     * 
     */
    public static Object getCustomSettingConfigurationValue(String applicationName, String configurationName) {
        Object retVal = null;
        COH_Config_Setting__c configObj = null;
        if (String.isNotEmpty(applicationName) && String.isNotEmpty(configurationName)) {
            try {
                configObj = [select Value__c, Value_Type__c from COH_Config_Setting__c where Active__c = true and Name = :configurationName and Application_Name__c = :applicationName limit 1];
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
        }
		return retVal;
    }
}