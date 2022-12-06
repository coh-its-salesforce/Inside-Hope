/* 
 * This class migrates custom settings for the COHCasePhysicianDecisionTree. If you want to 
 * modify it for other Custom Settings, you will probably need to do the following:
 * 
 * 1. Change the key in the mapNameToCustomSetting map to a unique identifier.
 * 2. Change the fields that need to be copied.
 * 3. Change the values added to the validCustomSettingNames list.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2019
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public with sharing class COHCustomSettingPhysicianTreeMigration {

    public static void migrateCustomSettings() {
        
        // Map of Names to COHCasePhysicianDecisionTree__c records
		Map<String, COHCasePhysicianDecisionTree__c> mapNameToCustomSetting = new Map<String, COHCasePhysicianDecisionTree__c>();
        
        // List of Names for valid COHCasePhysicianDecisionTree__c records
		List<String> validCustomSettingNames = new List<String>();
        
        // Retrieve the existing values and store them in a map
		List<COHCasePhysicianDecisionTree__c> curCustomSettings = Database.query('select  id, name, department__c, Campus__c, Physician__c, Service_Line__c, Specialty__c, Subgroup_Num__c from COHCasePhysicianDecisionTree__c order by Name ');        
        if (COHUtil.isValidList(curCustomSettings)) {
            for (COHCasePhysicianDecisionTree__c customSettingObj : curCustomSettings) {
                mapNameToCustomSetting.put(customSettingObj.Name, customSettingObj);
            }
        } else {
            throw new COHException('Error: no current custom settings for COHCasePhysicianDecisionTree__c');
        }
        
        // For new custom settings
        List<COHCasePhysicianDecisionTree__c> newCustomSettings = new List<COHCasePhysicianDecisionTree__c>();
        
        // Retrieve new values from the customsettingtemp__c records
        List<customsettingtemp__c> customSettingUpdates = Database.query('select  id, name, department__c, Campus__c, Physician__c, Service_Line__c, Specialty__c, Subgroup_Num__c from customsettingtemp__c');
        
        if (COHUtil.isValidList(customSettingUpdates)) {
            for (customsettingtemp__c newCustomSettingObj : customSettingUpdates) {
                COHCasePhysicianDecisionTree__c curCSObj = mapNameToCustomSetting.get(newCustomSettingObj.Name);
                if (curCSObj != null) {
                    // Update the existing custom setting. I use a map just in case
                    // there are duplicate Names. The last record will be kept.
                    curCSObj.Department__c = newCustomSettingObj.Department__c;
                    curCSObj.Physician__c = newCustomSettingObj.Physician__c;
                    curCSObj.Service_Line__c = newCustomSettingObj.Service_Line__c;
                    curCSObj.Specialty__c = newCustomSettingObj.Specialty__c;
                    curCSObj.Subgroup_Num__c = newCustomSettingObj.Subgroup_Num__c; 
                    mapNameToCustomSetting.put(newCustomSettingObj.Name, curCSObj);
                    validCustomSettingNames.add(newCustomSettingObj.Name);
                } else { 
                    // new custom setting
                    COHCasePhysicianDecisionTree__c newCSObj = new COHCasePhysicianDecisionTree__c();
                    newCSObj.Name = newCustomSettingObj.Name;
                    newCSObj.Department__c = newCustomSettingObj.Department__c;
                    newCSObj.Physician__c = newCustomSettingObj.Physician__c;
                    newCSObj.Service_Line__c = newCustomSettingObj.Service_Line__c;
                    newCSObj.Specialty__c = newCustomSettingObj.Specialty__c;
                    newCSObj.Subgroup_Num__c = newCustomSettingObj.Subgroup_Num__c;
                    newCustomSettings.add(newCSObj);
                }
            }
            
            if (COHUtil.isValidList(validCustomSettingNames)) {
                
                // Update valid records and delete them from the map
                List<COHCasePhysicianDecisionTree__c> customSettingsToUpsert = new List<COHCasePhysicianDecisionTree__c>();
                for (String CSName : validCustomSettingNames ) {
                    COHCasePhysicianDecisionTree__c csObjToUpdate = mapNameToCustomSetting.get(CSName);
                    if (csObjToUpdate != null) {
                        customSettingsToUpsert.add(csObjToUpdate);
                        mapNameToCustomSetting.remove(CSName);
                    }
                }

                // testing--raymond tam
                System.debug('Tracer: updating records --> ' + customSettingsToUpsert.size());
				// Update the existing custom settings                
				if (COHUtil.isValidList(customSettingsToUpsert)) {
                    try {
                        Database.upsert(customSettingsToUpsert);
                    } catch (Exception e) {
                        throw new COHException('Error in upserting existing records: ' + e.getMessage());
                    }
                }
            }
                // Add new custom settings
            
            // testing--raymond tam
            System.debug('Tracer: inserting records --> ' + newCustomSettings.size());
            if (COHUtil.isValidList(newCustomSettings)) {
                try {
                    Database.insert(newCustomSettings);
                } catch (Exception e) {
                    throw new COHException('Error in inserting existing records: ' + e.getMessage());
                }
            }                
            
            // Delete obsolete custom settings
            List<COHCasePhysicianDecisionTree__c> CSToDelete= mapNameToCustomSetting.values();
            // testing--raymond tam
            System.debug('Tracer: deleting records --> ' + CSToDelete.size());
            if (COHUtil.isValidList(CSToDelete)) {
                try {
                    Database.delete(CSToDelete);
                } catch (Exception e) {
                    throw new COHException('Error in inserting existing records: ' + e.getMessage());
                }
            }
        } else {
            throw new COHException('Error: no new custom settings');
        }
    }
}