/*
 * This class contains utility methods for the COH Blue Pencil application.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHBluePencilUtility {

    private static final String COH_BP_BULK_CONFIG_RECORD = 'COH_Blue_Pencil_Bulk_Config_Record__c';
    private static final String COH_BP_CONFIG_GROUP_RECORD = 'COH_Blue_Pencil_Config_Group__c';
    private static final String COLLABORATION_GROUP = 'CollaborationGroup';


    // Indicates if Profiles and/or User Roles should be added or removed from Configuration Groups.
    private static final String ADD_TO_CONFIG_GROUPS = 'Add';
    private static final String REMOVE_FROM_CONFIG_GROUPS = 'Remove';
    
    private static final String USER_ROLE = 'UserRole';
    private static final String PROFILE = 'Profile';
    private static final String ALL_GROUPS = 'All Groups';
    private static final String ALL_PROFILES = 'All Profiles';
    private static final String ALL_ROLES = 'All Roles';
    
    private static final String DELIMITER = ';';
    private static final Integer ID_LEN = 15;
    
    // Maximum collaboration group IDs (with a delimiter) for each of the configObj.Chatter_Group_IDs0__c
    // and configObj.Chatter_Group_IDs1__c fields.
    private static final Integer MAX_COLLAB_GROUPS = 8192;

    // Maximum collaboration group IDs (with a delimiter) for the configObj.Profile_IDs0__c field
    private static final Integer MAX_PROFILES = 4096;

    // Maximum collaboration group IDs (with a delimiter) for the configObj.User_Role_IDs0__c
    private static final Integer MAX_ROLES = 4096;
    
    private static List<COH_Blue_Pencil_Bulk_Config_Record__c> mBulkConfigList = null;
    
    private static String getCollabGroupBaseQuery = COHUtil.buildSelectAllSOQLStatement(COLLABORATION_GROUP);
    private static String getConfigObjBaseQuery = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP_RECORD);
    private static String getProfileBaseQuery = COHUtil.buildSelectAllSOQLStatement(PROFILE);
    private static String getRoleBaseQuery = COHUtil.buildSelectAllSOQLStatement(USER_ROLE);
    
    static {
        String getBulkConfigQuery = 'select Id, Name, Configuration_Group_ID__c, Collaboration_Group_Name_Pattern__c, Profile_Name_Pattern__c, User_Role_Name_Pattern__c, Processing_Mode__c ' +
            'from COH_Blue_Pencil_Bulk_Config_Record__c where Is_Active__c = true';
        mBulkConfigList = Database.query(getBulkConfigQuery);
    }

    /*
     * Add COH_Blue_Pencil_Config_Group__c IDs to Collaboration Groups, Profiles or Roles. 
     * 
     */    
    public static void processBulkConfiguration() {
        if (COHUtil.isValidList(mBulkConfigList)) {
            for (COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj : mBulkConfigList) {
                String configObjIDStr = bulkConfigObj.Configuration_Group_ID__c;
				String processingMode = bulkConfigObj.Processing_Mode__c;
                if (String.isNotBlank(configObjIDStr)) {
                    // Retrieve the configuration group object.  There should be only one.
                    Id configObjID = Id.valueOf(configObjIDStr);
                    // The status may be inactive when doing an initial bulk config
                    String getConfigObjQuery = getConfigObjBaseQuery + ' where Id = :configObjID';
                    List<COH_Blue_Pencil_Config_Group__c> configObjList = Database.query(getConfigObjQuery);
                    
                    if (COHUtil.isValidList(configObjList)) {
                        COH_Blue_Pencil_Config_Group__c configObj = configObjList.get(0);
                        if (String.isNotEmpty(processingMode)) {
                            if (processingMode == ADD_TO_CONFIG_GROUPS) {
								addBulkConfigurationforCollabGroups(bulkConfigObj, configObj);   
                                addBulkConfigurationforProfiles(bulkConfigObj, configObj);    
                                addBulkConfigurationforRoles(bulkConfigObj, configObj);
                            } else if (processingMode == REMOVE_FROM_CONFIG_GROUPS) {
								removeBulkConfigurationforCollabGroups(bulkConfigObj, configObj);   
                                removeBulkConfigurationforProfiles(bulkConfigObj, configObj);
                                removeBulkConfigurationforRoles(bulkConfigObj, configObj);
                            } else {
                                throw new COHException('COHBlueLightUtility.addBulkConfiguration(): unrecognized processing mode: ' + processingMode);
                            }
                        }
                        Database.update(configObj);
                    } else {
                        throw new COHException('COHBlueLightUtility.processBulkConfiguration(): Could not retrieve configuration object.  Name: ' + configObjIDStr + ' Bulk Config Object ID: ' + bulkConfigObj.Id);
                    }
                }
            }
        }
        
    }
    
    /*
     * Add the bulk configuration for the collaboration groups.  This updates the
     * Chatter_Group_IDs0__c and Chatter_Group_IDs1__c fields to include the new 
     * chatter group IDs.
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void addBulkConfigurationforCollabGroups(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the collaboration groups that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.Collaboration_Group_Name_Pattern__c;
            if (String.isNotEmpty(nameStr)) {
                // Check if all collaboration groups should be retrieved
                String getCollabGroupQuery = getCollabGroupBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_GROUPS)) {
                    nameStr = '%' + nameStr + '%';
                    getCollabGroupQuery += ' where name like :nameStr';
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getCollabGroupQuery += ' order by Id';
                } 
                
                // Retrieve the collaboration groups and assign the IDs to the Configuration Group object
                List<CollaborationGroup> allCollabGroups = Database.query(getCollabGroupQuery);
                if (COHUtil.isValidList(allCollabGroups))  {
                    Integer listSize = allCollabGroups.size();
                    Integer maxSize = 2 * MAX_COLLAB_GROUPS;
                    if (listSize > maxSize) {
                        throw new COHException('COHBlueLightUtility.addBulkConfigurationforCollabGroups(): Too many collaboration groups (' + listSize + ').  The maximum limit is ' + maxSize);
                    }
                    String chatterGroupIDs0 = null;
                    String chatterGroupIDs1 = null;
                    for (Integer recordIndex = 0; recordIndex < listSize; recordIndex++) {
                        CollaborationGroup collabGroupObj = allCollabGroups.get(recordIndex);
                        
                        // Convert to the 15 character length
                        String collabGroupBaseID = collabGroupObj.Id;
                        if (String.isNotEmpty(collabGroupBaseID)) {
                            String collabGroupID = collabGroupBaseID.left(ID_LEN);
                            
                            Integer maxCollabGroupsPerField;
                            if (Test.isRunningTest()) {
                                maxCollabGroupsPerField = 3;
                            } else {
                                maxCollabGroupsPerField = MAX_COLLAB_GROUPS;
                            }
                            
                            if (recordIndex < maxCollabGroupsPerField) {
                                if (chatterGroupIDs0 == null) {
                                    chatterGroupIDs0 = collabGroupID;
                                } else {
                                    chatterGroupIDs0 += DELIMITER + collabGroupID;
                                }
                            } else {
                                if (chatterGroupIDs1 == null) {
                                    chatterGroupIDs1 = collabGroupID;
                                } else {
                                    chatterGroupIDs1 += DELIMITER + collabGroupID;
                                }
                            }
                        }
                    }    
                    if (chatterGroupIDs0 != null) {
                        configObj.Chatter_Group_IDs0__c = chatterGroupIDs0;
                    }
                    if (chatterGroupIDs1 != null) {
                        configObj.Chatter_Group_IDs1__c = chatterGroupIDs1;
                    }
                }
            }
            
        }
    }
    
    /*
     * Add the bulk configuration for the Profiles.  This updates the
     * Profile_IDs0__c field to include the new Profile IDs.
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void addBulkConfigurationforProfiles(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the Profiles that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.Profile_Name_Pattern__c;
            
            if (String.isNotEmpty(nameStr)) {
                // Check if all Profiles should be retrieved
                String getProfilesQuery = getProfileBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_PROFILES)) {
                    nameStr = '%' + nameStr + '%';
                    getProfilesQuery += ' where name like :nameStr';
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getProfilesQuery += ' order by Id';
                } 
                
                // Retrieve the Profiles and assign the IDs to the Configuration Group object
                List<Profile> allProfileGroups = Database.query(getProfilesQuery);
                if (COHUtil.isValidList(allProfileGroups))  {
                    Integer listSize = allProfileGroups.size();
                    if (listSize > MAX_PROFILES) {
                        throw new COHException('COHBlueLightUtility.addBulkConfigurationforProfiles(): Too many profiles (' + listSize + ').  The maximum limit is ' + MAX_PROFILES);
                    }
                    String profileIDs0 = null;
                    for (Integer recordIndex = 0; recordIndex < listSize; recordIndex++) {
                        Profile profileObj = allProfileGroups.get(recordIndex);
                        
                        // Convert to the 15 character length
                        String profileBaseID = profileObj.Id;
                        if (String.isNotEmpty(profileBaseID)) {
                            String profileID = profileBaseID.left(ID_LEN);
                            
                            if (profileIDs0 == null) {
                                profileIDs0 = profileID;
                            } else {
                                profileIDs0 += DELIMITER + profileID;
                            }
                        }
                    }    
                    
                    if (profileIDs0 != null) {
                        configObj.Profile_IDs0__c = profileIDs0;
                    }
                }
            }
        }
    }

    /*
     * Add the bulk configuration for the Roles.  This updates the
     * User_Role_IDs0__c field to include the new Role IDs.
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void addBulkConfigurationforRoles(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the UserRoles that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.User_Role_Name_Pattern__c;
            
            if (String.isNotEmpty(nameStr)) {
                // Check if all UserRoles should be retrieved
                String getRolesQuery = getRoleBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_ROLES)) {
                    nameStr = '%' + nameStr + '%';
                    getRolesQuery += ' where name like :nameStr';
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getRolesQuery += ' order by Id';
                } 
                
                // Retrieve the UserRoles and assign the IDs to the Configuration Group object
                List<UserRole> allRoleGroups = Database.query(getRolesQuery);
                if (COHUtil.isValidList(allRoleGroups))  {
                    Integer listSize = allRoleGroups.size();
                    if (listSize > MAX_ROLES) {
                        throw new COHException('COHBlueLightUtility.addBulkConfigurationforRoles(): Too many roles (' + listSize + ').  The maximum limit is ' + MAX_PROFILES);
                    }
                    String userRoleIDs0 = null;
                    for (UserRole userRoleObj : allRoleGroups) {
                        // Convert to the 15 character length
                        String userRoleBaseID = userRoleObj.Id;
                        if (String.isNotEmpty(userRoleBaseID)) {
                            String userRoleID = userRoleBaseID.left(ID_LEN);
                            
                            if (userRoleIDs0 == null) {
                                userRoleIDs0 = userRoleID;
                            } else {
                                userRoleIDs0 += DELIMITER + userRoleID;
                            }
                        }
                    }    
                    
                    if (userRoleIDs0 != null) {
                        configObj.User_Role_IDs0__c = userRoleIDs0;
                    }
                }
            }
        }
    }

    /*
     * Remove the bulk configuration from the collaboration groups.  This removes
     * Chatter Group IDs from the Chatter_Group_IDs0__c and Chatter_Group_IDs1__c
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void removeBulkConfigurationforCollabGroups(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the collaboration groups that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.Collaboration_Group_Name_Pattern__c;
            if (String.isNotEmpty(nameStr)) {
                // Check if all collaboration groups should be retrieved
                String getCollabGroupQuery = getCollabGroupBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_GROUPS)) {
                    nameStr = '%' + nameStr + '%';
                    getCollabGroupQuery += ' where name like :nameStr';
                } else {
                    configObj.Chatter_Group_IDs0__c = null;
                    configObj.Chatter_Group_IDs1__c = null;
                    return;
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getCollabGroupQuery += ' order by Id';
                } 
                
                // Retrieve the collaboration groups and removes the IDs from each Configuration Group object
                List<CollaborationGroup> allCollabGroups = Database.query(getCollabGroupQuery);
                if (COHUtil.isValidList(allCollabGroups))  {
                    for (CollaborationGroup collabGroupObj : allCollabGroups) {
                        // Convert to the 15 character length
                        String collabGroupBaseID = collabGroupObj.Id;
                        if (String.isNotEmpty(collabGroupBaseID)) {
                            String collabGroupID = collabGroupBaseID.left(ID_LEN);
                            
                            String allChatterGroupIDs = configObj.Chatter_Group_IDs0__c;
                            
                            if (String.isNotEmpty(allChatterGroupIDs)) {
                                String updatedChatterGroupIDs = null;
                                List<String> updatedChatterIDsList = new List<String>();
                                List<String> allChatterGroupIDList = allChatterGroupIDs.split(DELIMITER);
                                for (String tempChatterGroupID : allChatterGroupIDList) {
                                    // Remove the target Chatter Group ID
                                    if (collabGroupID.compareTo(tempChatterGroupID) != 0) {
                                        updatedChatterIDsList.add(tempChatterGroupID);
                                    } else {
                                    }
                                }
                                if (COHUtil.isValidList(updatedChatterIDsList)) {
                                    for (String tempChatterID : updatedChatterIDsList) {
                                        if (updatedChatterGroupIDs == null) {
                                            updatedChatterGroupIDs = tempChatterID;
                                        } else {
                                            updatedChatterGroupIDs += DELIMITER + tempChatterID;
                                        }
                                    }
                                }
                                configObj.Chatter_Group_IDs0__c = updatedChatterGroupIDs;
                            }
                            
                            allChatterGroupIDs = configObj.Chatter_Group_IDs1__c;
                            
                            if (String.isNotEmpty(allChatterGroupIDs)) {
                                String updatedChatterGroupIDs = null;
                                List<String> updatedChatterIDsList = new List<String>();
                                List<String> allChatterGroupIDList = allChatterGroupIDs.split(DELIMITER);
                                for (String tempChatterGroupID : allChatterGroupIDList) {
                                    // Remove the target Chatter Group ID
                                    if (collabGroupID.compareTo(tempChatterGroupID) != 0) {
                                        updatedChatterIDsList.add(tempChatterGroupID);
                                    }
                                }
                                if (COHUtil.isValidList(updatedChatterIDsList)) {
                                    for (String tempChatterID : updatedChatterIDsList) {
                                        if (updatedChatterGroupIDs == null) {
                                            updatedChatterGroupIDs = tempChatterID;
                                        } else {
                                            updatedChatterGroupIDs += DELIMITER + tempChatterID;
                                        }
                                    }
                                }
                                configObj.Chatter_Group_IDs1__c = updatedChatterGroupIDs;
                            }
                        }
                        
                    }    
                }
            }
            
        }
    }
    
    
    /*
     * Remove the bulk configuration for the Profiles.  This removes Profile IDs
     * from the Profile_IDs0__c field.
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void removeBulkConfigurationforProfiles(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the Profiles that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.Profile_Name_Pattern__c;
            if (String.isNotEmpty(nameStr)) {
                // Check if all Profiles should be retrieved
                String getProfilesQuery = getProfileBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_PROFILES)) {
                    nameStr = '%' + nameStr + '%';
                    getProfilesQuery += ' where name like :nameStr';
                } else {
                    configObj.Profile_IDs0__c = null;
                    return;
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getProfilesQuery += ' order by Id';
                } 

                // Retrieve the Profiles and remove the IDs from the Configuration Group object
                List<Profile> allProfileGroups = Database.query(getProfilesQuery);
                if (COHUtil.isValidList(allProfileGroups))  {
                    Integer listSize = allProfileGroups.size();
                    if (listSize > MAX_PROFILES) {
                        throw new COHException('COHBlueLightUtility.addBulkConfigurationforProfiles(): Too many profiles (' + listSize + ').  The maximum limit is ' + MAX_PROFILES);
                    }
                    String profileIDs0 = null;
                    for (Integer recordIndex = 0; recordIndex < listSize; recordIndex++) {
                        Profile profileObj = allProfileGroups.get(recordIndex);
                        
                        // Convert to the 15 character length
                        String profileBaseID = profileObj.Id;
                        if (String.isNotEmpty(profileBaseID)) {
                            String profileID = profileBaseID.left(ID_LEN);
    
                            String allUserProfileIDsStr = configObj.Profile_IDs0__c;
                            if (String.isNotEmpty(allUserProfileIDsStr)) {
                                String newUserProfileIDs = null;
                                List<String> updatedUserProfileIDsList = new List<String>();
                                List<String> allUserProfileIDsList = allUserProfileIDsStr.split(DELIMITER);
                                for (String tempUserProfileID : allUserProfileIDsList) {
                                    // Remove the target profileID
                                    if (profileID.compareTo(tempUserProfileID) != 0) {
                                        updatedUserProfileIDsList.add(tempUserProfileID);
                                    }
                                } 
                                if (COHUtil.isValidList(updatedUserProfileIDsList)) {
                                    for (String tempUserProfileID : updatedUserProfileIDsList) {
                                        if (newUserProfileIDs == null) {
                                            newUserProfileIDs = tempUserProfileID;
                                        } else {
                                            newUserProfileIDs += DELIMITER + tempUserProfileID;
                                        }
                                    }
                                }
                                configObj.Profile_IDs0__c = newUserProfileIDs;
                            }
                        }
                    }    
                }
            }
        }
    }

    
    /*
     * Remove the bulk configuration for the Roles.  This removes Role IDs
     * from the User_Role_IDs0__c field.
     * 
     * @param bulkConfigObj		Bulk configuration object.
     * @param configObj			Configuration group.
     * 
     */
    private static void removeBulkConfigurationforRoles(COH_Blue_Pencil_Bulk_Config_Record__c  bulkConfigObj, COH_Blue_Pencil_Config_Group__c configObj) {
        if (configObj != null)     {
            // Get all the User Roles that have namestr somewhere in the name field
            String nameStr = bulkConfigObj.User_Role_Name_Pattern__c;
            
            if (String.isNotEmpty(nameStr)) {
                // Check if all User Roles should be retrieved
                String getRolesQuery = getRoleBaseQuery;
                if (!nameStr.equalsIgnoreCase(ALL_ROLES)) {
                    nameStr = '%' + nameStr + '%';
                    getRolesQuery += ' where name like :nameStr';
                } else {
                    configObj.User_Role_IDs0__c = null;
                    return;
                }
                
                // The order is important for testing
                if (Test.isRunningTest()) {
                    getRolesQuery += ' order by Id';
                } 
                
                // Retrieve the UserRoles and remove from the IDs to the Configuration Group object
                List<UserRole> allRoleGroups = Database.query(getRolesQuery);
                if (COHUtil.isValidList(allRoleGroups))  {
                    Integer listSize = allRoleGroups.size();
                    if (listSize > MAX_ROLES) {
                        throw new COHException('COHBlueLightUtility.removeBulkConfigurationforRoles(): Too many roles (' + listSize + ').  The maximum limit is ' + MAX_PROFILES);
                    }
                    String userRoleIDs0 = null;
                    for (UserRole userRoleObj : allRoleGroups) {
                        // Convert to the 15 character length
                        String userRoleBaseID = userRoleObj.Id;
                        if (String.isNotEmpty(userRoleBaseID)) {
                            String userRoleID = userRoleBaseID.left(ID_LEN);
                            
                            String allUserRoleIDsStr = configObj.User_Role_IDs0__c;
                            if (String.isNotEmpty(allUserRoleIDsStr)) {
                                String newUserRoleIDs = null;
                                List<String> updatedUserRoleIDsList = new List<String>();
                                List<String> allUserRoleIDsList = allUserRoleIDsStr.split(DELIMITER);
                                for (String tempUserRoleID : allUserRoleIDsList) {
                                    // Remove the target userRoleID
                                    if (userRoleID.compareTo(tempUserRoleID) != 0) {
                                        updatedUserRoleIDsList.add(tempUserRoleID);
                                    }
                                } 
                                if (COHUtil.isValidList(updatedUserRoleIDsList)) {
                                    for (String tempUserRoleID : updatedUserRoleIDsList) {
                                        if (newUserRoleIDs == null) {
                                            newUserRoleIDs = tempUserRoleID;
                                        } else {
                                            newUserRoleIDs += DELIMITER + tempUserRoleID;
                                        }
                                    }
                                }
                                configObj.User_Role_IDs0__c = newUserRoleIDs;
                            }
                        }
                    }    

                }
            }
        }
    }
}