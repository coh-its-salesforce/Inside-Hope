/*
 * The helper class for the PhysicianOnboardingTasksTrigger apex trigger
 * Tim Hughes
 */
public class COH_POB_POTasksTriggerHelper {
    private static Map<String, PermissionSetAssignment> mPermissionSetAssignmentMap = new Map<String, PermissionSetAssignment>();
    private static Map<String, String> mPermissionSetIdsMap = new Map<String, String>();
    private static Map<String, String> mRecordTypeIdsMap = new Map<String, String>();
    private static Map<id, User> mReleventUsersMap;
    private static List<id> mReleventPermissionSetIdsList;
    
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_TASK_RECORD_TYPE_NAME = 'Duarte Physician Onboarding Task Record Type';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_NAME = 'Duarte Onboarding Salesforce Permission Set';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME = 'Duarte Onboarding Salesforce Platform Permission Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_TASK_RECORD_TYPE_NAME = 'Community Physician Offboarding Task Record Type';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_NAME = 'Community Offboarding Salesforce Permission Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME = 'Community Offboarding Salesforce Platform Permission Set';    
    PRIVATE STATIC FINAL STRING COH_CONFIG_APP_NAME = 'Physician Onboarding/Offboarding';
    
    PRIVATE STATIC FINAL STRING COH_CONFIG_PERMISSION_SETS_GROUP_NAME = 'Permission Set Ids';
    PRIVATE STATIC FINAL STRING COH_CONFIG_RECORD_TYPES_GROUP_NAME = 'Record Type Ids';
    
    PRIVATE STATIC FINAL STRING SALESFORCE_PLATFORM_LICENSE_NAME = 'Salesforce Platform';
    PRIVATE STATIC FINAL STRING SALESFORCE_LICENSE_NAME = 'Salesforce';
    
    static {
        getConfigurationObjects();
        populatePermissionSetAssignmentMap();
        populateReleventUsersMap();
    }
    
    /*
     * The handler function for the isBefore and isUpdate trigger action
     */ 
    public static void beforeUpdateHandler(List<Physician_Onboarding_Tasks__c> insertedTasks) {
        boolean hasPermissions;
        List<string> permissionSetAssignmentsToInsert = new List<string>();
        
        if (COHUtil.isValidList(insertedTasks)) {
            for (Physician_Onboarding_Tasks__c poTask : insertedTasks) {
                if (poTask.RecordTypeId != null) {
                    User currentUser = mReleventUsersMap.get(poTask.Assigned_To__c);
                    if (currentUser != null)
                    {
                        // Duarte Onboarding Permission Sets   
                        if (poTask.RecordTypeId == mRecordTypeIdsMap.get(DUARTE_ONBOARDING_TASK_RECORD_TYPE_NAME)) {
                            if (currentUser.Salesforce_Licence_Type__c == SALESFORCE_PLATFORM_LICENSE_NAME) {
                                hasPermissions = checkPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME));
                                if (hasPermissions == false) {
                                    permissionSetAssignmentsToInsert.add(JSON.serialize(createPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME))));
                                }
                            }
                            else if (currentUser.Salesforce_Licence_Type__c == SALESFORCE_LICENSE_NAME) {
                                hasPermissions = checkPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_NAME));
                                if (hasPermissions == false) {
                                    permissionSetAssignmentsToInsert.add(JSON.serialize(createPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_NAME))));
                                }
                            }
                        }
                        // Community Offboarding Permission Sets
                        else if (poTask.RecordTypeId == mRecordTypeIdsMap.get(COMMUNITY_OFFBOARDING_TASK_RECORD_TYPE_NAME)) {
                            if (currentUser.Salesforce_Licence_Type__c == SALESFORCE_PLATFORM_LICENSE_NAME) {
                                hasPermissions = checkPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME));
                                if (hasPermissions == false) {
                                    permissionSetAssignmentsToInsert.add(JSON.serialize(createPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME))));
                                }
                            }
                            else if (currentUser.Salesforce_Licence_Type__c == SALESFORCE_LICENSE_NAME) {
                                hasPermissions = checkPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_NAME));
                                if (hasPermissions == false) {
                                    permissionSetAssignmentsToInsert.add(JSON.serialize(createPermissionSetAssignment(currentUser.id, mPermissionSetIdsMap.get(COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_NAME))));
                                }
                            }
                        }
                    }                    
                }
            } 
            insertPermissionSetAssignments(permissionSetAssignmentsToInsert);
        }
    }
    
    
    // -------------------- Private Functions -------------------- //  
    
    /*
     * Checks to see if a user has a permission set
     * 
     * @param userId 			The id of the user to check
     * @param permissionSetId 			The id of the permission set to check
     * 
     * @return							Returns true if the user does have the permission set
     * 									Returns false if the user does not have the permission set
     */ 
    private static boolean checkPermissionSetAssignment(id userId, id permissionSetId){ 
        boolean hasPermissionSet = null;
        
        if (userId != null && permissionSetId != null) {
            if (mPermissionSetAssignmentMap != null) {
                if (mPermissionSetAssignmentMap.get((String)userId + (String)permissionSetId) != null){
                    hasPermissionSet = true;
                }
                else {
                    hasPermissionSet = false;
                }
            }
        }
        
        return hasPermissionSet;
    }
    
    /*
     * Inserts a new PermissionSetAssignment
     * 
     * @param userId						The id of the user who is being assigned a new Permission Set
     * @param permissionSetID				The id of the permission set that should be assigned to the user.
     */ 
    private static PermissionSetAssignment createPermissionSetAssignment(id userId, id permissionSetId) {        
        PermissionSetAssignment newPermissionSetAssignment;
        if (userId != null && permissionSetId != null) {
            newPermissionSetAssignment = new PermissionSetAssignment();
            newPermissionSetAssignment.AssigneeId = userId;
            newPermissionSetAssignment.PermissionSetId = permissionSetId;
        }
        return newPermissionSetAssignment;
    }
    
    /*
     * Populates the mPermissionSetAssignmentMap variable
     * The map contains every permission set assignment that has a permission set id related to the onboarding/offboarding process (determined from the COH APP Config)
     */ 
    private static void populatePermissionSetAssignmentMap() {
        List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId IN :mReleventPermissionSetIdsList]);
        
        for (PermissionSetAssignment currentPermissionSetAssignment : permissionSetAssignmentList) {
            mPermissionSetAssignmentMap.put((String)currentPermissionSetAssignment.AssigneeId + (String)currentPermissionSetAssignment.PermissionSetId, currentPermissionSetAssignment);
        }   
    }
    
    @future
    private static void insertPermissionSetAssignments(List<String> permissionSetAssignmentsToInsertJSON) {
        List<PermissionSetAssignment> permissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
        PermissionSetAssignment tempPermissionSetAssignment;
        Set<string> previousInserts = new Set<string>();
        string currentKey;
        
        if (COHUtil.isValidList(permissionSetAssignmentsToInsertJSON)) {
            for (string currentPermissionSetAssignment : permissionSetAssignmentsToInsertJSON) {
                tempPermissionSetAssignment = (PermissionSetAssignment) JSON.deserialize(currentPermissionSetAssignment, PermissionSetAssignment.class);
                currentKey = (string) tempPermissionSetAssignment.AssigneeId + (string) tempPermissionSetAssignment.PermissionSetId;
                if (!(previousInserts.contains(currentKey))) {
                    permissionSetAssignmentsToInsert.add(tempPermissionSetAssignment);
					previousInserts.add(currentKey);
                }
                
            }
            insert permissionSetAssignmentsToInsert;
        }
    }
    
    /*
     * Populates the mReleventUsersMap variable. 
     * This map contains every user that isActive and has either a Salesforce License or a Salesforce Platform License 
     */
    private static void populateReleventUsersMap(){
		mReleventUsersMap = new Map<id, User>([SELECT id, Salesforce_Licence_Type__c, isActive FROM User WHERE isActive = true AND (Salesforce_Licence_Type__c = 'Salesforce' OR Salesforce_Licence_Type__c = 'Salesforce Platform')]);
    }
    
    /*
     * 
     */
    private static void getConfigurationObjects(){
        List<COH_App_Configuration__c> permissionSetsConfigObjects = COHUtil.getConfigurationGroup(COH_CONFIG_APP_NAME, COH_CONFIG_PERMISSION_SETS_GROUP_NAME);
        List<COH_App_Configuration__c> recordTypeConfigObjects = COHUtil.getConfigurationGroup(COH_CONFIG_APP_NAME, COH_CONFIG_RECORD_TYPES_GROUP_NAME);
        
        // build the maps
        for (COH_App_Configuration__c configObj : permissionSetsConfigObjects) {
            mPermissionSetIdsMap.put(configObj.Name, configObj.Value__c);
        }
        for (COH_App_Configuration__c configObj : recordTypeConfigObjects) {
            mRecordTypeIdsMap.put(configObj.Name, configObj.Value__c);
        }
        
        mReleventPermissionSetIdsList = mPermissionSetIdsMap.values();
    }
}