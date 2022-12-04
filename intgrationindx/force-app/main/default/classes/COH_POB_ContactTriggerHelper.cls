/*
 * The helper class for the COH_POB_ContactTrigger apex trigger
 * Tim Hughes
 */
public class COH_POB_ContactTriggerHelper {    
    PRIVATE STATIC FINAL STRING COH_CONFIG_RECORD_TYPES_GROUP_NAME = 'Record Type Ids';    
    PRIVATE STATIC FINAL STRING COH_CONFIG_APP_NAME = 'Physician Onboarding/Offboarding';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_CONTACT_RECORD_TYPE_NAME = 'Duarte Onboarding Contact Record Type';
    
    private static Map<Id, Contact> mContactsWithTasksMap; // Contains all of the updated Contacts with their related Tasks
    private static Map<String, String> mRecordTypeIdsMap = new Map<String, String>();    
    
    static {
        getConfigurationObjects();
    }
    
    /*
     * Updates Physician Onboarding/Offboarding Contacts and their related Physician Onboarding Tasks if the Assign All Tasks To field has been updated.
     * 1) To keep SOQL Queries small, it gets a list of Contact IDs that have been updated, calls populateContactsWithTasksMap() which will get the Physician Onboarding Tasks objects related to each relevant contact
     * 2) Iterates through the updated contacts and updates assigns the Assign All Tasks To field to the Assigned To field in all the related Physician Onboarding Tasks, if necessary.
     * 3) After iterating through the related Physician Onboarding Tasks, the Contact's Assign All Tasks To field is reset to null
     * 4) After iterating through the updated contacts, the Physician Onboarding Tasks that were updated are saved to the Database
     * 
     * @param List<Contact> updatedContacts 				The list of contacts that have been updated
     */ 
    public static void massUpdateHandler(List<Contact> updatedContacts) {
        List<id> contactIdsList = new List<id>();
        List<Physician_Onboarding_Tasks__c> tasksToUpdate = new List<Physician_Onboarding_Tasks__c>();
        
        for (Contact currentContact : updatedContacts) {
            if (currentContact.RecordTypeId == mRecordTypeIdsMap.get(DUARTE_ONBOARDING_CONTACT_RECORD_TYPE_NAME)) { 
                contactIdsList.add(currentContact.id);
            }
        }
        populateContactsWithTasksMap(contactIdsList);
		
        for (Contact currentContact : updatedContacts) {
            if (currentContact.RecordTypeId == mRecordTypeIdsMap.get(DUARTE_ONBOARDING_CONTACT_RECORD_TYPE_NAME)) { // Or any other Record Type that utilizes the Mass Update field for the Physician Onboarding/Offboarding records.
                if(currentContact.Assign_All_Tasks_To__c != null) {
                    Contact contactWithTasks = mContactsWithTasksMap.get(currentContact.id);
                    System.debug('Task: ' + contactWithTasks.Duarte_Onboarding_Task__r.size());
                    for (Physician_Onboarding_Tasks__c currentTask : contactWithTasks.Duarte_Onboarding_Task__r) {
                        if (currentTask.Do_Not_Mass_Update__c == false) {
                            currentTask.Assigned_To__c = currentContact.Assign_All_Tasks_To__c;
                            tasksToUpdate.add(currentTask);                            
                        }
                    }
                    currentContact.Assign_All_Tasks_To__c = null;
                }
            }
        }
        if (COHUtil.isValidList(tasksToUpdate)) {
            update tasksToUpdate;
        }
	}
    
    /*
     * This class populates a Map object with relevent Contact records and their related Physician Onboarding Tasks.
     * 
     * @param List<id> contactIdsList				The list of ids of the Contacts that should populate the mContactsWithTasksMap variable
     */ 
    private static void populateContactsWithTasksMap(List<id> contactIdsList) {
        mContactsWithTasksMap = new Map<Id, Contact>([SELECT id, (SELECT id, Assigned_To__c, Contact__c, Do_Not_Mass_Update__c FROM Duarte_Onboarding_Task__r) FROM Contact WHERE id IN :contactIdsList]);        
    }
    
    /*
     * Populates the recordTypeIdMap using the COH App Config object. 
     */ 
    private static void getConfigurationObjects() {
        List<COH_App_Configuration__c> recordTypeConfigObjects = COHUtil.getConfigurationGroup(COH_CONFIG_APP_NAME, COH_CONFIG_RECORD_TYPES_GROUP_NAME);
        
        for (COH_App_Configuration__c configObj : recordTypeConfigObjects) {
            mRecordTypeIdsMap.put(configObj.Name, configObj.Value__c);
        }
    }    
}