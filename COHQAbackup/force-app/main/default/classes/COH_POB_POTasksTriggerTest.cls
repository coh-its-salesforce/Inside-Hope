/*
 * This class contains the units tests for the PhysicianOnboardingTasksTrigger and PhysicianOnboardingTasksTriggerHelper apex trigger/class
 */
@isTest()
private class COH_POB_POTasksTriggerTest {

    // Variables for setting up a new User
    private static final String NEWUSER = 'Bob BlahBlah';
    private static final String NEWUSER_EMAIL = 'TESTUSERDISREGARD@coh.org';
    private static final String NEWUSER_EMP_ID = '101010';
    private static final String TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String LOCALE_SID_KEY = 'en_US';
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';
    
    // Variables for setting up a new permission set for testing
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_LABEL = 'Duarte Onboarding Salesforce Permission Set';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_NAME = 'Duarte_Onboarding_Salesforce_Permission_Set';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL = 'Duarte Onboarding Salesforce Platform Permission Set';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME = 'Duarte_Onboarding_Salesforce_Platform_Permission_Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_NAME = 'Community_Offboarding_Salesforce_Permission_Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME = 'Community_Offboarding_Salesforce_Platform_Permission_Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_LABEL = 'Community Offboarding Salesforce Permission Set';
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL = 'Community Offboarding Salesforce Platform Permission Set';      
    PRIVATE STATIC FINAL STRING IS_TEST = 'Is_Test';
    private static id mDuarteOnboardingSalesforcePermissionSetId;
    private static id mDuarteOnboardingSalesforcePlatformPermissionSetId;
    private static id mCommunityOffboardingSalesforcePermissionSetId;
    private static id mCommunityOffboardingSalesforcePlatformPermissionSetId;    
    
    // Variables for setting up new COH App Config Objects for testing
    PRIVATE STATIC FINAL STRING COH_CONFIG_APP_NAME = 'Physician Onboarding/Offboarding';
    PRIVATE STATIC FINAL STRING COH_CONFIG_PERMISSION_SETS_GROUP_NAME = 'Permission Set Ids';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_TASK_RECORD_TYPE_NAME = 'Duarte Physician Onboarding Task';  
    PRIVATE STATIC FINAL STRING COMMUNITY_ONBOARDING_TASK_RECORD_TYPE_NAME = 'Community Physician Onboarding Task';    
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_TASK_RECORD_TYPE_NAME = 'Community Physician Offboarding Task';      
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_TASK_COH_CONFIG_NAME = 'Duarte Physician Onboarding Task Record Type';  
    PRIVATE STATIC FINAL STRING COMMUNITY_ONBOARDING_TASK_COH_CONFIG_NAME = 'Community Physician Onboarding Task Record Type';    
    PRIVATE STATIC FINAL STRING COMMUNITY_OFFBOARDING_TASK_COH_CONFIG_NAME = 'Community Physician Offboarding Task Record Type';    
    PRIVATE STATIC FINAL STRING COH_CONFIG_RECORD_TYPES_GROUP_NAME = 'Record Type Ids';
    PRIVATE STATIC FINAL STRING STRING_TYPE = 'String';
    
    // Variables for setting up a new Physician Onboarding Task
    PRIVATE STATIC FINAL STRING PHYSICIAN_ONBOARDING_TASK_STATUS = 'Not Started';

    private static User mTestUser;
    private static id mDuarteOnboardingTaskRecordTypeId;
    private static id mCommunityOnboardingTaskRecordTypeId;
    private static id mCommunityOffboardingTaskRecordTypeId;
    private static User mThisUser;
    private static string mLicenseType;
    
    static {
        mThisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
    }
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Record Type is 'Duarte Physician Onboarding Task'
     */
    @isTest
    private static void testDuarteOnboarding0() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mDuarteOnboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        test.stopTest();
        
        System.assertEquals(true, updateResult.isSuccess());

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());  
    }
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce Platform' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Record Type is 'Duarte Physician Onboarding Task'
     */
    @isTest
    private static void testDuarteOnboarding1() {
        
        createTestUser(false);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce Platform', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mDuarteOnboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePlatformPermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        System.assertEquals(true, updateResult.isSuccess());

        test.stopTest();

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePlatformPermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());  
    }    
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce' License
     * 2) The Assigned To User already has the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Record Type is 'Duarte Physician Onboarding Task'
     */
    @isTest
    private static void testDuarteOnboarding2() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mDuarteOnboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());        
        
        PermissionSetAssignment newAssignment = new PermissionSetAssignment();
        newAssignment.AssigneeId = mTestUser.Id;
        newAssignment.PermissionSetId = mDuarteOnboardingSalesforcePermissionSetId;
        System.runAs(mThisUser) {
         	insert newAssignment;   
        }
        
        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        System.assertEquals(true, updateResult.isSuccess());

        test.stopTest();

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());  
    }
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are not configured correctly
     * 5) The Physician Onboarding Tasks' record type is blank
     * 
     * The correct flow is that if there is no COH App Config, then the record should update with no issues, and permission should not be added.
     */
    @isTest
    private static void testDuarteOnboarding3() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(null);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);        
        test.stopTest();
        
        System.assertEquals(true, updateResult.isSuccess());
        string assignedToUser = [SELECT id, Assigned_To__c from Physician_Onboarding_Tasks__c WHERE id =: testTask.id].Assigned_To__c;
        System.assertEquals(mTestUser.id, assignedToUser);
        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());  
    }   
         
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User is null
     *
	 * The correct flow is that the record updates succesfully
     */
    @isTest
    private static void testDuarteOnboarding4() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mDuarteOnboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = null;
        testTask.Description__c = 'New Description';
        Database.SaveResult updateResult = Database.Update(testTask);
        System.assertEquals(true, updateResult.isSuccess());

		string newDescription = [SELECT id, Description__c from Physician_Onboarding_Tasks__c WHERE id =: testTask.id].Description__c;
        System.assertEquals('New Description', newDescription);
        
        test.stopTest();
    }
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Physician Onboarding Tasks' record type is blank
     * 
     * Currently the only Physician Onboarding Task without a record type is the Community Physician Onboarding process, which does not require the use of this trigger
     * The inteded flow is for the record to update successfully and no permissionset are assigned.
     */
    @isTest
    private static void testDuarteOnboarding5() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(null);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        System.assertEquals(true, updateResult.isSuccess());

        test.stopTest();

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mDuarteOnboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());  
    }  
	
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Record Type is 'Community Physician Offboarding Task'
     */
    @isTest
    private static void testCommunityOffboarding0() {
        
        createTestUser(true);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mCommunityOffboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mCommunityOffboardingSalesforcePermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        test.stopTest();
        
        System.assertEquals(true, updateResult.isSuccess());

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mCommunityOffboardingSalesforcePermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());  
    }
    
    /*
     * Tests the PhysicianOnboardingTasksTrigger when:
     * 1) The Assigned To User has a 'Salesforce Platform' License
     * 2) The Assigned To User does NOT have the necessary permissions
     * 4) The COH App Config objects are configured correctly
     * 5) The Record Type is 'Community Physician Offboarding Task'
     */
    @isTest
    private static void testCommunityOffboarding1() {
        
        createTestUser(false);
       	mLicenseType = [SELECT id, Salesforce_Licence_Type__c FROM User WHERE id =: mTestUser.id].Salesforce_Licence_Type__c;
        System.assertEquals('Salesforce Platform', mLicenseType);
        
        createPermissionSet();
        createCOHAppConfiguration();
        Physician_Onboarding_Tasks__c testTask =  createPhysicianOnboardingTask(mCommunityOffboardingTaskRecordTypeId);
        
        List<PermissionSetAssignment> testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mCommunityOffboardingSalesforcePlatformPermissionSetId]);
        System.assertEquals(0, testUserPermissions.size());
        
        test.startTest();
        
        testTask.Assigned_To__c = mTestUser.id;
        Database.SaveResult updateResult = Database.Update(testTask);
        System.assertEquals(true, updateResult.isSuccess());

        test.stopTest();

        testUserPermissions = new List<PermissionSetAssignment>([SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: mTestUser.id AND PermissionSetId =: mCommunityOffboardingSalesforcePlatformPermissionSetId]);
        System.assertEquals(1, testUserPermissions.size());  
    }    
   
   
    
    // -------------------- Private Functions -------------------- //  
    
    
    /*
     * Creates a new user for testing purposes
     */ 
    private static void createTestUser(Boolean SalesforceLicense) {
        id profileId;
        
        if (SalesforceLicense) {
            profileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        }
    	else {
            profileId = [SELECT id, name FROM Profile WHERE name = 'ServiceDesk2' LIMIT 1].id;
        }
        
        mTestUser = new User();
        mTestUser.Username = NEWUSER_EMAIL;
        mTestUser.Email = NEWUSER_EMAIL;
        mTestUser.LastName = NEWUSER;
        mTestUser.Alias = NEWUSER.substring(0, 7); // Alias can only be 8 characters 
        mTestUser.CommunityNickname = NEWUSER; 
        mTestUser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mTestUser.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
        mTestUser.LocaleSidKey = LOCALE_SID_KEY;
        mTestUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mTestUser.ProfileId = profileId;
        mTestUser.IsActive = true;
        mTestUser.EmployeeNumber = NEWUSER_EMP_ID;                    

        System.runas(mThisUser) {
            insert(mTestUser);            
        }
    }

    /*
     * Creates a permission set that is used in testing.
     * The function that calls is responsible for calling .startTest() and .stopTest()
     */
    private static void createPermissionSet() {
        List<PermissionSet> newPermissionSets = new List<PermissionSet>();
        
        PermissionSet testPermissionSet0 = new PermissionSet(Label = DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_LABEL + IS_TEST, Name= DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_NAME + IS_TEST);
        PermissionSet testPermissionSet1 = new PermissionSet(Label = DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL + IS_TEST, Name= DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME + IS_TEST);
        PermissionSet testPermissionSet2 = new PermissionSet(Label = COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_LABEL + IS_TEST, Name= COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_NAME + IS_TEST);
        PermissionSet testPermissionSet3 = new PermissionSet(Label = COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL + IS_TEST, Name= COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_NAME + IS_TEST);        
        
        newPermissionSets.add(testPermissionSet0);
        newPermissionSets.add(testPermissionSet1);
        newPermissionSets.add(testPermissionSet2);
        newPermissionSets.add(testPermissionSet3);
        
        System.runAs(mThisUser) {
            insert newPermissionSets;
        }

        mDuarteOnboardingSalesforcePermissionSetId = testPermissionSet0.id;
        mDuarteOnboardingSalesforcePlatformPermissionSetId = testPermissionSet1.id;
        mCommunityOffboardingSalesforcePermissionSetId = testPermissionSet2.id;
        mCommunityOffboardingSalesforcePlatformPermissionSetId = testPermissionSet3.id;
    }  

    /*
     * Creates the configuration objects for the test environment.
     * 
     * @param testMode  Indicates the type of test mode.
     * 
     */
    private static void createCOHAppConfiguration() {
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj0.Name = DUARTE_ONBOARDING_SALSESFORCE_PERMISSION_SET_LABEL;
        configObj0.Value__c = mDuarteOnboardingSalesforcePermissionSetId;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Configuration_Group__c = COH_CONFIG_PERMISSION_SETS_GROUP_NAME;
        configObj0.Active__c = true;
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj1.Name = DUARTE_ONBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL;
        configObj1.Value__c = mDuarteOnboardingSalesforcePlatformPermissionSetId;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Configuration_Group__c = COH_CONFIG_PERMISSION_SETS_GROUP_NAME;
        configObj1.Active__c = true;
        
        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj2.Name = COMMUNITY_OFFBOARDING_SALSESFORCE_PERMISSION_SET_LABEL;
        configObj2.Value__c = mCommunityOffboardingSalesforcePermissionSetId;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Configuration_Group__c = COH_CONFIG_PERMISSION_SETS_GROUP_NAME;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj3.Name = COMMUNITY_OFFBOARDING_SALSESFORCE_PLATFORM_PERMISSION_SET_LABEL;
        configObj3.Value__c = mCommunityOffboardingSalesforcePlatformPermissionSetId;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Configuration_Group__c = COH_CONFIG_PERMISSION_SETS_GROUP_NAME;
        configObj3.Active__c = true;        
        
        // Get Record Type Ids for the various Physician Onboarding Tasks Record Types
        Map<string, Schema.RecordTypeInfo> recordTypeInfo = Physician_Onboarding_Tasks__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        mDuarteOnboardingTaskRecordTypeId = recordTypeInfo.get(DUARTE_ONBOARDING_TASK_RECORD_TYPE_NAME).getRecordTypeId();
        mCommunityOnboardingTaskRecordTypeId = recordTypeInfo.get(COMMUNITY_ONBOARDING_TASK_RECORD_TYPE_NAME).getRecordTypeId();
        mCommunityOffboardingTaskRecordTypeId = recordTypeInfo.get(COMMUNITY_OFFBOARDING_TASK_RECORD_TYPE_NAME).getRecordTypeId();
        
        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj4.Name = DUARTE_ONBOARDING_TASK_COH_CONFIG_NAME;
        configObj4.Value__c = mDuarteOnboardingTaskRecordTypeId;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Configuration_Group__c = COH_CONFIG_RECORD_TYPES_GROUP_NAME;
        configObj4.Active__c = true;        
        
        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj5.Name = COMMUNITY_ONBOARDING_TASK_COH_CONFIG_NAME;
        configObj5.Value__c = mCommunityOnboardingTaskRecordTypeId;
        configObj5.Value_Type__c = STRING_TYPE;
        configObj5.Configuration_Group__c = COH_CONFIG_RECORD_TYPES_GROUP_NAME;
        configObj5.Active__c = true;  

        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
        configObj6.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj6.Name = COMMUNITY_OFFBOARDING_TASK_COH_CONFIG_NAME;
        configObj6.Value__c = mCommunityOffboardingTaskRecordTypeId;
        configObj6.Value_Type__c = STRING_TYPE;
        configObj6.Configuration_Group__c = COH_CONFIG_RECORD_TYPES_GROUP_NAME;
        configObj6.Active__c = true;          

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);
        configList.add(configObj5);
        configList.add(configObj6);

        System.runAs(mThisUser) {
			insert(configList);
        }
	}
    
    /*
     * Creates a Physician Onboarding Task object for the purposes of testing
     */ 
    private static Physician_Onboarding_Tasks__c createPhysicianOnboardingTask(id recordTypeId) {
        Physician_Onboarding_Tasks__c newTask = new Physician_Onboarding_Tasks__c();
        newTask.Status__c = PHYSICIAN_ONBOARDING_TASK_STATUS;
        if (recordTypeId != null) {
            newTask.RecordTypeId = recordTypeId;            
        }        
        insert newTask;
        return newTask;
    }
}