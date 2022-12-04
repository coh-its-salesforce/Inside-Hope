/* 
 * This test class verifies the functionality of COH_BP_Utility.  
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
@isTest
public class COH_BP_UtilityTest {
    private static final Boolean mRunVerifyAddingBulkConfiguration = false;
    private static final Boolean mRunVerifyRemovingBulkConfiguration = true;
    private static final Boolean mRunAllTests = true;

    // Configuration constants
    private static final String CHATTER_BP_APP = 'Chatter Blue Pencil';
    private static final String CHATTER_BP_DELIMITER = ';';
    
    // Processing modes
    private static final String ADD_TO_CONFIG_GROUPS = 'Add';
    private static final String REMOVE_FROM_CONFIG_GROUPS = 'Remove';

    // CollaborationGroup constants    
    private static final String CHATTER_GROUP_NAME0 = 'Test Irwindale Fine Dining Club';
    private static final String CHATTER_GROUP_NAME1 = 'Test Scottforce';
    private static final String CHATTER_GROUP_NAME2 = 'Test Salesforce Admin';
    private static final String CHATTER_GROUP_NAME3 = 'Test May the Force be with you';
    private static final String CHATTER_GROUP_NAME4 = 'Test ITS';
    private static final String CHATTER_GROUP_NAME5 = 'Test Accounting';

    private static final String CHATTER_BP_VIOLATION = '******';
    private static final String CHATTER_GROUP_CONFIG_NAME0 = 'ChatterGroupConfig0';
    private static final String CHATTER_GROUP_CONFIG_NAME1 = 'ChatterGroupConfig1';
    private static final String CHATTER_GROUP_CONFIG_NAME2 = 'ChatterGroupConfig2';
    private static final String CHATTER_GROUP_CONFIG_NAME3 = 'ChatterGroupConfig3';
    
    private static final String PUBLIC_COLLABORATION_TYPE = 'Public';
    private static final String RULE_SSN_REGEX = '\\d{3}-?\\s*\\d{2}-?\\s*\\d{4}';      // SSN check

    private static final String BULK_CONFIG_DESCR = 'Test bulk configuration';
    private static final String BULK_CONFIG_CG_NAME_PATTERN0 = 'force';
    private static final String BULK_CONFIG_CG_NAME_PATTERN1 = 'Dining';
    private static final String BULK_CONFIG_CG_NAME_PATTERN2 = 'ITS';
    private static final String BULK_CONFIG_CG_NAME_PATTERN3 = 'All Groups';
    
    private static final String BULK_CONFIG_PROFILE_NAME_PATTERN1 = 'System Administrator';
    private static final String BULK_CONFIG_PROFILE_NAME_PATTERN2 = 'r789238jfd8s';
    private static final String BULK_CONFIG_PROFILE_NAME_PATTERN3 = 'All Profiles';
    
    private static final String BULK_CONFIG_ROLE_NAME_PATTERN1 = 'r789238jfd8s';
    private static final String BULK_CONFIG_ROLE_NAME_PATTERN2 = 'All Roles';
    
    
    // Miscellaneous constants    
    private static final String COH_BP_BULK_CONFIG_RECORD = 'COH_Blue_Pencil_Bulk_Config_Record__c';
    private static final String COH_BP_CONFIG_RECORD = 'COH_Blue_Pencil_Config_Group__c';
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT2 = 2;
    private static final Integer RECORD_COUNT4 = 4;
    private static final Integer RECORD_COUNT6 = 6;
    private static final Integer ID_LEN = 15;

    private static Id mConfigGroupObjID0;
    private static Id mConfigGroupObjID1;
    private static Id mConfigGroupObjID2;
    private static Id mConfigGroupObjID3;
    
    private static String mCollabGroupID0;
    private static String mCollabGroupID1;
    private static String mCollabGroupID2;
    private static String mCollabGroupID3;
    private static String mCollabGroupID4;
    private static String mCollabGroupID5;

	private static String mAllCollabGroupIDs = null;
    private static String mDefaultConfigObjIDs = null;
    private static String mProfileIDList1;
    private static String mAllProfileIDs = null;
    private static String mAllRoleIDs = null;
    private static String mRoleID0;
    private static String mRoleID1;
    private static String mRoleID2;
	private static String mRoleName0;
	private static String mRoleName1;
	private static String mRoleName2;
    
    /*
     * Verify the rules for adding bulk configuration criteria.
     * 
     */
    private static testMethod void verifyAddingBulkConfiguration() {
        if (!mRunAllTests && !mRunVerifyAddingBulkConfiguration) {
            System.debug('Skipping verifyAddingBulkConfiguration()');
            return;
        }
        
        Test.startTest();
        
		setProfileRoleIDStrings();
        setConfiguration(ADD_TO_CONFIG_GROUPS);
        createChatterGroups();
        createBulkConfiguration(ADD_TO_CONFIG_GROUPS);
            
		COH_BP_Utility.processBulkConfiguration();

        String getChatterGroupConfig = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_RECORD);
        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigList= Database.query(getChatterGroupConfig);
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigList) {
            String cgcoName = chatterGroupConfigObj.Name;
            if (cgcoName == CHATTER_GROUP_CONFIG_NAME0) {
                String expectedStr = mCollabGroupID1 + CHATTER_BP_DELIMITER + mCollabGroupID2 + CHATTER_BP_DELIMITER + mCollabGroupID3;
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME1) {
                System.assertEquals(mCollabGroupID0, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(mProfileIDList1, chatterGroupConfigObj.Profile_IDs0__c);
                System.assertEquals(mRoleID0, chatterGroupConfigObj.User_Role_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME2) {
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(null, chatterGroupConfigObj.Profile_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME3) {
                String expectedStr = mCollabGroupID0 + CHATTER_BP_DELIMITER + mCollabGroupID1 + CHATTER_BP_DELIMITER + mCollabGroupID2;
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                expectedStr = mCollabGroupID3 + CHATTER_BP_DELIMITER + mCollabGroupID4 + CHATTER_BP_DELIMITER + mCollabGroupID5;
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(mAllProfileIDs, chatterGroupConfigObj.Profile_IDs0__c);
                System.assertEquals(mAllRoleIDs, chatterGroupConfigObj.User_Role_IDs0__c);
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT4, recCount);
        
        Test.stopTest();
    }        

    /*
     * Verify the rules for removing bulk configuration criteria.
     * 
     */
    private static testMethod void verifyRemovingBulkConfiguration() {
        if (!mRunAllTests && !mRunVerifyRemovingBulkConfiguration) {
            System.debug('Skipping verifyRemovingBulkConfiguration()');
            return;
        }
        
        Test.startTest();
        
		setProfileRoleIDStrings();
        setConfiguration(REMOVE_FROM_CONFIG_GROUPS);
        createChatterGroups();
        updateConfiguration(mAllCollabGroupIDs);
        createBulkConfiguration(REMOVE_FROM_CONFIG_GROUPS);
            
		COH_BP_Utility.processBulkConfiguration();

        String getChatterGroupConfig = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_RECORD);
        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigList= Database.query(getChatterGroupConfig);
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigList) {
            String cgcoName = chatterGroupConfigObj.Name;
            if (cgcoName == CHATTER_GROUP_CONFIG_NAME0) {
                String expectedStr = mCollabGroupID0 + CHATTER_BP_DELIMITER + mCollabGroupID4 + CHATTER_BP_DELIMITER + mCollabGroupID5;
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME1) {
                String expectedStr = mCollabGroupID1 + CHATTER_BP_DELIMITER + mCollabGroupID2 + CHATTER_BP_DELIMITER + mCollabGroupID3 +
                    CHATTER_BP_DELIMITER +mCollabGroupID4 + CHATTER_BP_DELIMITER + mCollabGroupID5;
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(expectedStr, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(null, chatterGroupConfigObj.Profile_IDs0__c);
				expectedStr = mRoleID1 + CHATTER_BP_DELIMITER + mRoleID2;
                System.assertEquals(expectedStr, chatterGroupConfigObj.User_Role_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME2) {
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(null, chatterGroupConfigObj.Profile_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME3) {
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                System.assertEquals(null, chatterGroupConfigObj.Profile_IDs0__c);
                System.assertEquals(null, chatterGroupConfigObj.User_Role_IDs0__c);
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT4, recCount);
        
        Test.stopTest();
    }        

    /*
     * Create Chatter groups
     * 
     */
    private static void createChatterGroups() {
        
        List<CollaborationGroup> collabGroupList = new List<CollaborationGroup>();
        
        CollaborationGroup group0 = new CollaborationGroup();
        group0.Name = CHATTER_GROUP_NAME0;
        group0.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group1 = new CollaborationGroup();
        group1.Name = CHATTER_GROUP_NAME1;
        group1.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group2 = new CollaborationGroup();
        group2.Name = CHATTER_GROUP_NAME2;
        group2.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group3 = new CollaborationGroup();
        group3.Name = CHATTER_GROUP_NAME3;
        group3.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group4 = new CollaborationGroup();
        group4.Name = CHATTER_GROUP_NAME4;
        group4.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group5 = new CollaborationGroup();
        group5.Name = CHATTER_GROUP_NAME5;
        group5.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        collabGroupList.add(group0);
        collabGroupList.add(group1);
        collabGroupList.add(group2);
        collabGroupList.add(group3);
        collabGroupList.add(group4);
        collabGroupList.add(group5);
        
        Database.insert(collabGroupList);
        List<CollaborationGroup> savedCollabGroupList = [select Id, Name from CollaborationGroup];
        
        Integer recCount = 0;
        for (CollaborationGroup collabGroupObj : savedCollabGroupList) {
            String name = collabGroupObj.Name;
            String baseID = collabGroupObj.Id;
            if (name == CHATTER_GROUP_NAME0) {
                mCollabGroupID0 = baseID.left(ID_LEN);
                recCount++;
            } else if (name == CHATTER_GROUP_NAME1) {
                mCollabGroupID1 = baseID.left(ID_LEN);
                recCount++;
            } else if (name == CHATTER_GROUP_NAME2) {
                mCollabGroupID2 = baseID.left(ID_LEN);
                recCount++;
            } else if (name == CHATTER_GROUP_NAME3) {
                mCollabGroupID3 = baseID.left(ID_LEN);
                recCount++;
            } else if (name == CHATTER_GROUP_NAME4) {
                mCollabGroupID4 = baseID.left(ID_LEN);
                recCount++;
            } else if (name == CHATTER_GROUP_NAME5) {
                mCollabGroupID5 = baseID.left(ID_LEN);
                recCount++;
            } 
        }
        System.assertEquals(RECORD_COUNT6, recCount);
        
        mAllCollabGroupIDs = mCollabGroupID0 + CHATTER_BP_DELIMITER + mCollabGroupID1 + CHATTER_BP_DELIMITER + mCollabGroupID2 + CHATTER_BP_DELIMITER
            + mCollabGroupID3 + CHATTER_BP_DELIMITER+ mCollabGroupID4 + CHATTER_BP_DELIMITER+ mCollabGroupID5;
    }

    /*
     * Create configuration objects for testing.  
     * 
     * @param processingMode		Indicates if bulk configuration rules are used to add or remove
     * 								Profile IDs and/or User Role IDs from configuration groups.
     * 
     */
    private static void setConfiguration(String processingMode) {

        COH_Blue_Pencil_Config_Group__c chatterConfigGroup0 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup0.Contact_Person__c = null;
        chatterConfigGroup0.Description__c = 'test0';
        chatterConfigGroup0.Name = CHATTER_GROUP_CONFIG_NAME0;
        chatterConfigGroup0.Rule_Names__c = null;
        chatterConfigGroup0.Is_Active__c = true;
        chatterConfigGroup0.Enable_Notification__c = false;
        chatterConfigGroup0.Enable_Audit_Trail__c = false;

        COH_Blue_Pencil_Config_Group__c chatterConfigGroup1 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup1.Contact_Person__c = null;
        chatterConfigGroup1.Description__c = 'test0';
        chatterConfigGroup1.Name = CHATTER_GROUP_CONFIG_NAME1;
        chatterConfigGroup1.Rule_Names__c = null;
        chatterConfigGroup1.Is_Active__c = true;
        chatterConfigGroup1.Enable_Notification__c = false;
        chatterConfigGroup1.Enable_Audit_Trail__c = false;
        if (processingMode == REMOVE_FROM_CONFIG_GROUPS) {
            chatterConfigGroup1.Profile_IDs0__c = mProfileIDList1;
            chatterConfigGroup1.User_Role_IDs0__c = mRoleID0 + CHATTER_BP_DELIMITER + mRoleID1 + CHATTER_BP_DELIMITER + mRoleID2;
        }

        COH_Blue_Pencil_Config_Group__c chatterConfigGroup2 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup2.Contact_Person__c = null;
        chatterConfigGroup2.Description__c = 'test0';
        chatterConfigGroup2.Name = CHATTER_GROUP_CONFIG_NAME2;
        chatterConfigGroup2.Rule_Names__c = null;
        chatterConfigGroup2.Is_Active__c = true;
        chatterConfigGroup2.Enable_Notification__c = false;
        chatterConfigGroup2.Enable_Audit_Trail__c = false;

        COH_Blue_Pencil_Config_Group__c chatterConfigGroup3 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup3.Contact_Person__c = null;
        chatterConfigGroup3.Description__c = 'test0';
        chatterConfigGroup3.Name = CHATTER_GROUP_CONFIG_NAME3;
        chatterConfigGroup3.Rule_Names__c = null;
        chatterConfigGroup3.Is_Active__c = true;
        chatterConfigGroup3.Enable_Notification__c = false;
        chatterConfigGroup3.Enable_Audit_Trail__c = false;
        if (processingMode == REMOVE_FROM_CONFIG_GROUPS) {
            chatterConfigGroup3.Profile_IDs0__c = mAllProfileIDs;
            chatterConfigGroup3.User_Role_IDs0__c = mRoleID0 + CHATTER_BP_DELIMITER + mRoleID1;
        }


        List<COH_Blue_Pencil_Config_Group__c> configRecordList = new List<COH_Blue_Pencil_Config_Group__c>();
        configRecordList.add(chatterConfigGroup0);
        configRecordList.add(chatterConfigGroup1);
        configRecordList.add(chatterConfigGroup2);
        configRecordList.add(chatterConfigGroup3);
        Database.insert(configRecordList);
        
        // Set the config group IDs
        String getConfigGroupQuery = 'select Id, Name from COH_Blue_Pencil_Config_Group__c where Is_Active__c = true';
        List<COH_Blue_Pencil_Config_Group__c> allConfigGroups = Database.query(getConfigGroupQuery);
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c configObject : allConfigGroups) {
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME0) {
                mConfigGroupObjID0 = configObject.Id;
                recCount++;
            }
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME1) {
                mConfigGroupObjID1 = configObject.Id;
                recCount++;
            }
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME2) {
                mConfigGroupObjID2 = configObject.Id;
                recCount++;
            }
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME3) {
                mConfigGroupObjID3 = configObject.Id;
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT4, recCount);
    }

    /*
     * Updates the COH_Blue_Pencil_Config_Group__c objects.  This is needed for testing removals.  
     * The Chatter Groups require the COH_Blue_Pencil_Config_Group__c to be created first.  However, 
     * the removal testing requires Chatter Group IDs to be assigned to these COH_Blue_Pencil_Config_Group__c
     * groups.
     * 
     * The setConfiguration() and createChatterGroups() methods must be called in that order before this
     * should be called.
     * 
     * @param collabGroupIDLIst		List of Collaboration Group IDs to assign to a COH_Blue_Pencil_Config_Group__c
     * 								object.
     * 
     */
    private static void updateConfiguration(String collabGroupIDLIst) {

        System.assertNotEquals(null, collabGroupIDLIst);

        String getConfigGroupQuery = 'select Id, Name, Chatter_Group_IDs0__c, Chatter_Group_IDs1__c from COH_Blue_Pencil_Config_Group__c where Is_Active__c = true order by Id ';
        List<COH_Blue_Pencil_Config_Group__c> allConfigGroups = Database.query(getConfigGroupQuery);
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c configObject : allConfigGroups) {
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME0 || configObject.Name == CHATTER_GROUP_CONFIG_NAME1) {
                configObject.Chatter_Group_IDs0__c = collabGroupIDLIst;
                configObject.Chatter_Group_IDs1__c = collabGroupIDLIst;
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT2, recCount);
        Database.update(allConfigGroups);
    }

    
    /*
     * Create Bulk Configuration objects.  This should be called after setConfiguration() is called.
     * 
     * @param processingMode		Indicates if bulk configuration rules are used to add or remove
     * 								Profile IDs and/or User Role IDs from configuration groups.
     * 
     */
    private static void createBulkConfiguration(String processingMode) {


        COH_Blue_Pencil_Bulk_Config_Record__c bulkConfig0 = new COH_Blue_Pencil_Bulk_Config_Record__c();
        bulkConfig0.Is_Active__c = true;
        bulkConfig0.Processing_Mode__c = processingMode;
        bulkConfig0.Configuration_Group_ID__c = mConfigGroupObjID0;
        bulkConfig0.Collaboration_Group_Name_Pattern__c = BULK_CONFIG_CG_NAME_PATTERN0;
        
        COH_Blue_Pencil_Bulk_Config_Record__c bulkConfig1 = new COH_Blue_Pencil_Bulk_Config_Record__c();
        bulkConfig1.Is_Active__c = true;
        bulkConfig1.Processing_Mode__c = processingMode;
        bulkConfig1.Configuration_Group_ID__c = mConfigGroupObjID1;
        bulkConfig1.Collaboration_Group_Name_Pattern__c = BULK_CONFIG_CG_NAME_PATTERN1;
		bulkConfig1.Profile_Name_Pattern__c = BULK_CONFIG_PROFILE_NAME_PATTERN1;
        bulkConfig1.User_Role_Name_Pattern__c = mRoleName0;

        // should be ignored        
        COH_Blue_Pencil_Bulk_Config_Record__c bulkConfig2 = new COH_Blue_Pencil_Bulk_Config_Record__c();
        bulkConfig2.Is_Active__c = false;
        bulkConfig2.Processing_Mode__c = processingMode;
        bulkConfig2.Configuration_Group_ID__c = mConfigGroupObjID2;
        bulkConfig2.Collaboration_Group_Name_Pattern__c = BULK_CONFIG_CG_NAME_PATTERN2;
		bulkConfig2.Profile_Name_Pattern__c = BULK_CONFIG_PROFILE_NAME_PATTERN2;
        bulkConfig2.User_Role_Name_Pattern__c = BULK_CONFIG_ROLE_NAME_PATTERN1;
        
        COH_Blue_Pencil_Bulk_Config_Record__c bulkConfig3 = new COH_Blue_Pencil_Bulk_Config_Record__c();
        bulkConfig3.Is_Active__c = true;
        bulkConfig3.Processing_Mode__c = processingMode;
        bulkConfig3.Configuration_Group_ID__c = mConfigGroupObjID3;
        bulkConfig3.Collaboration_Group_Name_Pattern__c = BULK_CONFIG_CG_NAME_PATTERN3;
		bulkConfig3.Profile_Name_Pattern__c = BULK_CONFIG_PROFILE_NAME_PATTERN3;
        bulkConfig3.User_Role_Name_Pattern__c = BULK_CONFIG_ROLE_NAME_PATTERN2;
        
        List<COH_Blue_Pencil_Bulk_Config_Record__c> bulkConfigRecordList = new List<COH_Blue_Pencil_Bulk_Config_Record__c>();
        bulkConfigRecordList.add(bulkConfig0);
        bulkConfigRecordList.add(bulkConfig1);
        bulkConfigRecordList.add(bulkConfig2);
        bulkConfigRecordList.add(bulkConfig3);
        Database.insert(bulkConfigRecordList);
        
    }
    
    /*
     * Set the Profile and Role ID strings.  This should be called before the other
     * confiugrations methods are called.
     * 
     */
    private static void setProfileRoleIDStrings() {

        // Set the Profile IDs
        String getProfileQuery = 'select Id, Name from Profile where Name like :profileNamePattern order by Id';

        // The wildcard is used in COH_BP_Utility
        String profileNamePattern = '%' + BULK_CONFIG_PROFILE_NAME_PATTERN1 + '%';
        List<Profile> profileList = Database.query(getProfileQuery);
        String profileStr = null;
        for (Profile profileObj : profileList) {
	        String baseID = profileObj.Id;
            String profileID = baseID.left(ID_LEN);
            if (profileStr == null) {
                profileStr = profileID;
            } else {
                profileStr += CHATTER_BP_DELIMITER + profileID;
            }
        }
        mProfileIDList1 = profileStr;
        System.assertNotEquals(null, mProfileIDList1);
    
        String getAllProfileQuery = 'select Id, Name from Profile order by Id';

        profileList = Database.query(getAllProfileQuery);
        for (Profile newProfileObj : profileList) {
            String tempProfileID = newProfileObj.Id;
            String newProfileID = tempProfileID.left(ID_LEN);
            if (mAllProfileIDs == null) {
                mAllProfileIDs = newProfileID;
            } else {
                mAllProfileIDs += CHATTER_BP_DELIMITER + newProfileID;
            }
        }
        System.assertNotEquals(null, mAllProfileIDs);
        
        // Set the Role IDs
        // Select a user with a Role that isn't from Salesforce

        String getUserRoleSOQLQuery = 'select id, Name from UserRole where not name like \'%Universal Systems LLC Customer%\' order by id limit 3';
    	List<UserRole> userRoleList = Database.query(getUserRoleSOQLQuery);
        
        String roleStr = null;
        UserRole useRoleObj =  userRoleList.get(0);
        String baseID = useRoleObj.Id;
        String roleID = baseID.left(ID_LEN);
        mRoleID0 = roleID;
        mRoleName0 = useRoleObj.Name;
        
        useRoleObj =  userRoleList.get(1);
        baseID = useRoleObj.Id;
        roleID = baseID.left(ID_LEN);
        mRoleID1 = roleID;
        mRoleName1 = useRoleObj.Name;
        
        useRoleObj =  userRoleList.get(2);
        baseID = useRoleObj.Id;
        roleID = baseID.left(ID_LEN);
        mRoleID2 = roleID;
        mRoleName2 = useRoleObj.Name;
		
        String getAllUserRolesQuery = 'select Id, Name from UserRole order by Id';

        userRoleList = Database.query(getAllUserRolesQuery);
        for (UserRole newUseRoleObj : userRoleList) {
            String tempBaseID = newUseRoleObj.Id;
            String newRoleID = tempBaseID.left(ID_LEN);
            if (mAllRoleIDs == null) {
                mAllRoleIDs = newRoleID;
            } else {
                mAllRoleIDs += CHATTER_BP_DELIMITER + newRoleID;
            }
        }
        System.assertNotEquals(null, mAllRoleIDs);
        
    }
    
}