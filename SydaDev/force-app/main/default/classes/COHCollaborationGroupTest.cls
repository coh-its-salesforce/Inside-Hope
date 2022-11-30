/* 
 * This test class verifies the functionality of COHCollaborationGroupHelper
 * for Blue Pencil.
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
public class COHCollaborationGroupTest {
/*    
    private static final Boolean mRunVerifyCollabGroupCreation = true;
    private static final Boolean mRunVerifyCollabGroupDeletion = true;
    private static final Boolean mRunVerifyBulkCreationDeletion = false;
    private static final Boolean mRunAllTests = false;

    // Configuration constants
	private static final String	CHATTER_BP_APP = 'Chatter Blue Pencil';
    private static final String	CHATTER_BP_DEFAULT_CONFIG_GROUPS = 'Default Config Groups for Chatter';
    private static final String	CHATTER_BP_DELIMITER = ';';

    // CollaborationGroup constants    
    private static final String CHATTER_GROUP_NAME0 = 'ChatterGroupName0';
    private static final String CHATTER_GROUP_NAME1 = 'ChatterGroupName1';
    private static final String CHATTER_GROUP_NAME2 = 'ChatterGroupName2';
    private static final String CHATTER_GROUP_NAME3 = 'ChatterGroupName3';
    
    private static final String CHATTER_BP_VIOLATION = '******';
    private static final String CHATTER_GROUP_CONFIG_NAME0 = 'ChatterGroupConfig0';
    private static final String CHATTER_GROUP_CONFIG_NAME1 = 'ChatterGroupConfig1';
    private static final String CHATTER_GROUP_CONFIG_NAME2 = 'ChatterGroupConfig2';
    private static final String CHATTER_GROUP_CONFIG_ID0 = '0F9n00000008xpl';
    
    
    private static final String PUBLIC_COLLABORATION_TYPE = 'Public';
    private static final String RULE_NAME0 = 'Rule0';
    private static final String RULE_SSN_REGEX = '\\d{3}-?\\s*\\d{2}-?\\s*\\d{4}';		// SSN check
    
	// Miscellaneous constants    
    private static final String COH_BP_CONFIG_GROUP = 'COH_Blue_Pencil_Config_Group__c';
    private static final String STRING_TYPE = 'String';
	private static final Boolean SINGLE_RECORD_MODE = true;
	private static final Boolean BULK_RECORD_MODE = false;
    
    private static final Integer MAX_STR_LEN = 131072;
    private static final Integer MAX_RECORDS = 202;
    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT2 = 2;
    private static final Integer RECORD_COUNT3 = 3;
    private static final Integer ID_LEN = 15;

	private static String mDefaultConfigObjIDs = null;
	private static String mChatterIDForPadding = null;		// 15 character ID for padding
*/    
    /*
     * Verify the creation of CollaborationGroups.
     * 
     */
/*    
    private static testMethod void verifyCollabGroupCreation() {
        if (!mRunAllTests && !mRunVerifyCollabGroupCreation) {
            System.debug('Skipping verifyCollabGroupCreation()');
            return;
        }
        
        Test.startTest();
        
		setConfiguration();
		setCOHAppConfiguration();
        createChatterGroups(SINGLE_RECORD_MODE);
            
		// Retrieve the new chatter groups.  Their IDs should be in the default config group objects
        List<String> chatterGroupNames = new List<String> {CHATTER_GROUP_NAME0, CHATTER_GROUP_NAME1, CHATTER_GROUP_NAME2};
        List<CollaborationGroup> chatterGroupList = [select Id, Name From CollaborationGroup where Name in :chatterGroupNames  order by Id];
		System.assertEquals(RECORD_COUNT3, chatterGroupList.size());		
        String expectedCollabGroupIDs = null;
        for (CollaborationGroup collabGroupObj : chatterGroupList) {
            String collabGroupID = collabGroupObj.Id;
            if (expectedCollabGroupIDs == null) {
                expectedCollabGroupIDs = collabGroupID.left(ID_LEN);
            } else {
                expectedCollabGroupIDs += CHATTER_BP_DELIMITER + collabGroupID.left(ID_LEN);
            }
        }
        
        String getChatterGroupConfig = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP);
        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigList= Database.query(getChatterGroupConfig);
        
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigList) {
            String cgcoName = chatterGroupConfigObj.Name;
            if (cgcoName == CHATTER_GROUP_CONFIG_NAME0) {
				Integer len = (chatterGroupConfigObj.Chatter_Group_IDs0__c).length();
                System.assertEquals(MAX_STR_LEN - 1, len);
				System.assertEquals(expectedCollabGroupIDs, chatterGroupConfigObj.Chatter_Group_IDs1__c);                
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME1) {
				System.assertEquals(CHATTER_GROUP_CONFIG_ID0 + CHATTER_BP_DELIMITER + expectedCollabGroupIDs, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME2) {
                System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                recCount++;
            }
        }
		System.assertEquals(RECORD_COUNT3, recCount);
        
		Test.stopTest();
    }        
*/
    /*
     * Verify the deletion of CollaborationGroups.
     * 
     */
/*    
    private static testMethod void verifyCollabGroupDeletion() {
        
        if (!mRunAllTests && !mRunVerifyCollabGroupDeletion) {
            System.debug('Skipping verifyCollabGroupDeletion()');
            return;
        }
        
        Test.startTest();
        
		setConfiguration();
		setCOHAppConfiguration();
        createChatterGroups(SINGLE_RECORD_MODE);
  
        Id chatterGroupIDtoDelete = null;
        
		// Retrieve the new chatter groups.  Their IDs should be in the default config group objects
        List<String> chatterGroupNames = new List<String> {CHATTER_GROUP_NAME0, CHATTER_GROUP_NAME1, CHATTER_GROUP_NAME2};
        List<CollaborationGroup> chatterGroupList = [select Id, Name From CollaborationGroup where Name in :chatterGroupNames  order by Id];
		System.assertEquals(RECORD_COUNT3, chatterGroupList.size());		
        String expectedCollabGroupIDs = null;
        for (CollaborationGroup collabGroupObj : chatterGroupList) {
            String collabGroupID = collabGroupObj.Id;
            if (expectedCollabGroupIDs == null) {
                expectedCollabGroupIDs = collabGroupID.left(ID_LEN);
                chatterGroupIDtoDelete  = collabGroupID.left(ID_LEN);
            } else {
                expectedCollabGroupIDs += CHATTER_BP_DELIMITER + collabGroupID.left(ID_LEN);
            }
        }
        
        String getChatterGroupConfig = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP);
        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigList= Database.query(getChatterGroupConfig);
        
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigList) {
            String cgcoName = chatterGroupConfigObj.Name;
            if (cgcoName == CHATTER_GROUP_CONFIG_NAME0) {
				System.assertEquals(expectedCollabGroupIDs, chatterGroupConfigObj.Chatter_Group_IDs1__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME1) {
				System.assertEquals(CHATTER_GROUP_CONFIG_ID0 + CHATTER_BP_DELIMITER + expectedCollabGroupIDs, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                recCount++;
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME2) {
				System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
                recCount++;
            }
        }
		System.assertEquals(RECORD_COUNT3, recCount);
        
        // Delete the chatter group
        Database.delete(chatterGroupIDtoDelete);

		// Verify deletion of the chatter group        
        chatterGroupList = [select Id, Name From CollaborationGroup WHERE Name = :CHATTER_GROUP_NAME0];
		System.assertEquals(RECORD_COUNT0, chatterGroupList.size());

        chatterGroupConfigList= Database.query(getChatterGroupConfig);
        System.assertEquals(RECORD_COUNT3, chatterGroupConfigList.size());
        
        for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigList) {
            String cgcoName = chatterGroupConfigObj.Name;
            if (cgcoName == CHATTER_GROUP_CONFIG_NAME0) {
                String updateChatterGroupIDs = chatterGroupConfigObj.Chatter_Group_IDs0__c;
				System.assertEquals(MAX_STR_LEN - 1, updateChatterGroupIDs.length());
                
		        recCount = 0;
                updateChatterGroupIDs = chatterGroupConfigObj.Chatter_Group_IDs1__c;
                List<String> chatterGroupIDList = updateChatterGroupIDs.split(CHATTER_BP_DELIMITER);
                for (String objId : chatterGroupIDList) {
                    if (objId != chatterGroupIDtoDelete) {
                        recCount++;
                    }
                }
				System.assertEquals(RECORD_COUNT2, recCount);
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME1) {
		        recCount = 0;
                String updateChatterGroupIDs = chatterGroupConfigObj.Chatter_Group_IDs0__c;
                List<String> chatterGroupIDList = updateChatterGroupIDs.split(CHATTER_BP_DELIMITER);
                for (String objId : chatterGroupIDList) {
                    if (objId != chatterGroupIDtoDelete) {
                        recCount++;
                    }
                }
				System.assertEquals(RECORD_COUNT3, recCount);
            } else if (cgcoName == CHATTER_GROUP_CONFIG_NAME2) {
				System.assertEquals(null, chatterGroupConfigObj.Chatter_Group_IDs0__c);
            }
        }
        
		Test.stopTest();
    }        
*/
    
    /*
     * Verify the bulk creation and deletion of CollaborationGroups.
     * 
     */
/*    
    private static testMethod void verifyBulkCreationDeletion() {
        if (!mRunAllTests && !mRunVerifyBulkCreationDeletion) {
            System.debug('Skipping verifyBulkCreationDeletion()');
            return;
        }
        
        Test.startTest();
        
		setConfiguration();
		setCOHAppConfiguration();
        createChatterGroups(BULK_RECORD_MODE);
        
        List<CollaborationGroup> chatterGroupList = [select Id, Name From CollaborationGroup WHERE CollaborationType = :PUBLIC_COLLABORATION_TYPE];
		System.assertEquals(MAX_RECORDS + 1, chatterGroupList.size());	// Extra collaborationGroup is 
        																// the dummy one created in setConfiguration()

        Database.delete(chatterGroupList);
        chatterGroupList = [select Id, Name From CollaborationGroup WHERE CollaborationType = :PUBLIC_COLLABORATION_TYPE];
		System.assertEquals(RECORD_COUNT0, chatterGroupList.size());
        
        Test.stopTest();
    }        
*/
    
    /*
     * Create new Chatter groups for testing.
     * 
     * @param testMode		Indicates the test mode for creating the correct number of Chatter Groups.
     * 
     */
/*    
    private static void createChatterGroups(Boolean testMode) {
        
        List<CollaborationGroup> collabGroupList = new List<CollaborationGroup>();
        
        if (testMode != BULK_RECORD_MODE) {
            CollaborationGroup group0 = new CollaborationGroup();
            group0.Name = CHATTER_GROUP_NAME0;
            group0.CollaborationType = PUBLIC_COLLABORATION_TYPE;
            
            CollaborationGroup group1 = new CollaborationGroup();
            group1.Name = CHATTER_GROUP_NAME1;
            group1.CollaborationType = PUBLIC_COLLABORATION_TYPE;
            
            CollaborationGroup group2 = new CollaborationGroup();
            group2.Name = CHATTER_GROUP_NAME2;
            group2.CollaborationType = PUBLIC_COLLABORATION_TYPE;
            
	        collabGroupList.add(group0);
	        collabGroupList.add(group1);
	        collabGroupList.add(group2);
        } else {
            for (Integer i = 0; i < MAX_RECORDS; i++)             {
                String suffix = COHUtil.generateNumberString(i);
                CollaborationGroup group0 = new CollaborationGroup();
                group0.Name = CHATTER_GROUP_NAME0 + suffix;
                group0.CollaborationType = PUBLIC_COLLABORATION_TYPE;
                collabGroupList.add(group0);
            }
        }
        Database.insert(collabGroupList);
        
    }
*/
    /*
     * Create configuration objects for testing.  
     * 
     * @param	testMode		Indicates if the records should be created for creation or deletion tests.
     * 
     * CHATTER_GROUP_CONFIG_NAME0
     * 				|--> RULE_NAME0
     * 
     * CHATTER_GROUP_CONFIG_NAME1
     * 				|--> <No rules>
     * 
     * CHATTER_GROUP_CONFIG_NAME2
     * 				|--> <No rules>
     * 
     */
/*    
    private static void setConfiguration() {

        // Create an unused collaboration group so we can use its ID for testing 
        // when the CM_CG_Chatter_Group_IDs0__c field has reached its limit.
        CollaborationGroup group0 = new CollaborationGroup();
        group0.Name = CHATTER_GROUP_NAME3;
        group0.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        Database.insert(group0);
        
        CollaborationGroup collabGroupObj = [select Id, Name from CollaborationGroup where name = :CHATTER_GROUP_NAME3 limit 1];
        if (collabGroupObj != null) {
            String baseID = collabGroupObj.Id;
            mChatterIDForPadding = baseID.left(ID_LEN);
        } else {
            mChatterIDForPadding = null;
        }
        
        COH_Blue_Pencil_Rule__c rule0 = new COH_Blue_Pencil_Rule__c();
        rule0.Description__c = null;
        rule0.Name = RULE_NAME0;
        rule0.Regular_Expression__c = RULE_SSN_REGEX;
        rule0.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule0.Match_Whole_Words__c = false;
        rule0.Literal_Search__c = false;
		rule0.Is_Active__c = true;
        
        // Select the FoundationAccount user and set it in the config objects
        List<User> userList = [select id, name from user where firstname = 'Foundation' and lastname = 'Account'];
		System.assertEquals(RECORD_COUNT1, userList.size());
        User userObj = userList.get(0);
            
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup0 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup0.Chatter_Group_IDs0__c = getFillerString();
        chatterConfigGroup0.Chatter_Group_IDs1__c = null;	    
        chatterConfigGroup0.Contact_Person__c = null;
        chatterConfigGroup0.Description__c = 'test0';
        chatterConfigGroup0.Name = CHATTER_GROUP_CONFIG_NAME0;
        chatterConfigGroup0.Rule_Names__c = RULE_NAME0;
		chatterConfigGroup0.Is_Active__c = true;
		chatterConfigGroup0.Enable_Notification__c = false;
        chatterConfigGroup0.Enable_Audit_Trail__c = false;

        COH_Blue_Pencil_Config_Group__c chatterConfigGroup1 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup1.Chatter_Group_IDs0__c = CHATTER_GROUP_CONFIG_ID0;
        chatterConfigGroup1.Contact_Person__c = null;
        chatterConfigGroup1.Description__c = 'test0';
        chatterConfigGroup1.Name = CHATTER_GROUP_CONFIG_NAME1;
        chatterConfigGroup1.Rule_Names__c = null;
		chatterConfigGroup1.Is_Active__c = true;
		chatterConfigGroup1.Enable_Notification__c = false;
        chatterConfigGroup1.Enable_Audit_Trail__c = false;

		// This config group should not be assigned to the new Chatter Group
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup2 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup2.Chatter_Group_IDs0__c = null;
        chatterConfigGroup2.Contact_Person__c = null;
        chatterConfigGroup2.Description__c = 'test0';
        chatterConfigGroup2.Name = CHATTER_GROUP_CONFIG_NAME2;
        chatterConfigGroup2.Rule_Names__c = null;
		chatterConfigGroup2.Is_Active__c = true;
		chatterConfigGroup2.Enable_Notification__c = false;
        chatterConfigGroup2.Enable_Audit_Trail__c = false;

        Database.insert(rule0);
        
        List<COH_Blue_Pencil_Config_Group__c> configRecordList = new List<COH_Blue_Pencil_Config_Group__c>();
        configRecordList.add(chatterConfigGroup0);
        configRecordList.add(chatterConfigGroup1);
        configRecordList.add(chatterConfigGroup2);
        Database.insert(configRecordList);
        
    	// Set the config group IDs
        String getConfigGroupQuery = 'select Id, Name from COH_Blue_Pencil_Config_Group__c where Is_Active__c = true';
        List<COH_Blue_Pencil_Config_Group__c> allConfigGroups = Database.query(getConfigGroupQuery);
        Integer recCount = 0;
        for (COH_Blue_Pencil_Config_Group__c configObject : allConfigGroups) {
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME0) {
                recCount++;
            }
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME1) {
                recCount++;
            }
            if (configObject.Name == CHATTER_GROUP_CONFIG_NAME2) {
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT3, recCount);
    }
*/
    
    /*
     * Creates the configuration objects for the test environment.  The createChatterGroups() 
     * and setConfiguration() methods must be called before this should be called.  This method
     * sets the default Configuration Groups that should be assigned to each Chatter group.
     * 
     */
/*    
    private static void setCOHAppConfiguration() {

        String getConfigGroupQuery = 'select Id from COH_Blue_Pencil_Config_Group__c where Is_Active__c = true and ' +
            'Name != :CHATTER_GROUP_CONFIG_NAME2';
        
        List<COH_Blue_Pencil_Config_Group__c> allConfigGroups = Database.query(getConfigGroupQuery);
        
        System.assertEquals(RECORD_COUNT2, allConfigGroups.size());
        COH_Blue_Pencil_Config_Group__c configGroupObj0 = allConfigGroups.get(0);
        String configGroupObjID0 = configGroupObj0.Id;
        COH_Blue_Pencil_Config_Group__c configGroupObj1 = allConfigGroups.get(1);
        String configGroupObjID1 = configGroupObj1.Id;
        mDefaultConfigObjIDs = configGroupObjID0 + CHATTER_BP_DELIMITER + configGroupObjID1; 
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = CHATTER_BP_APP;
		configObj0.Name = CHATTER_BP_DEFAULT_CONFIG_GROUPS;
        configObj0.Value__c = mDefaultConfigObjIDs;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;
            
        Database.insert(configObj0);
    }
*/
    /*
     * Create a long string to completely fill CM_CG_Chatter_Group_IDs0__c (MAX_STR_LEN characters).
     * 
     * @return		The 128K character long string.
     * 
     */
/*    
    public static String getFillerString() {
        Integer maxIterations = MAX_STR_LEN / 16;	// 16 is the length of the mChatterIDForPadding variable plus delimiter
        String finalStr = null;
        for (Integer i = 0; i < maxIterations; i++) {
            if (finalStr == null) {
                finalStr = mChatterIDForPadding;
            } else {
                finalStr += CHATTER_BP_DELIMITER + mChatterIDForPadding;
            }
        }
        return finalStr;
    }    
*/
}