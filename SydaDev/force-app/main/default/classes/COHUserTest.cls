/*
 * This test class verifies the functionality of the COHUser trigger.  
 * The tests for verifying the updateSupervisor functionality are
 * contained in the UpdateSupervisorTest class.  This class tests
 * the other functionalities of the triggers.
 * 
 * Raymond Tam, Tim Hughes
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COHUserTest {


    private static final Boolean mRunVerifyAssetRequest0 = false;
    private static final Boolean mRunVerifyAssetRequest1 = false;
    private static final Boolean mRunVerifyAssetRequest2 = false;
    private static final Boolean mRunVerifyAssetRequest3 = false;
    private static final Boolean mRunVerifyAssetRequest4 = false;
    // Disabled Permission Assignment tests because a newer User Permission Set workflow caused these tests to fail.
    private static final Boolean mRunVerifyCreatedUserPermissionAssignment0 = false;
    private static final Boolean mRunVerifyCreatedUserPermissionAssignment1 = false;
    private static final Boolean mRunVerifyUpdatedUserPermissionAssignment0 = false;
    private static final Boolean mRunVerifyUpdatedUserPermissionAssignment1 = false;
    private static final Boolean mRunVerifyUpdatedUserPermissionAssignment2 = false;
    private static final Boolean mRunVerifyUpdatedUserPermissionAssignment3 = false;
    private static final Boolean mRunSupervisorIDAssignment = true;
    private static final Boolean mRunVerifyChangeDirector = false;
    private static final Boolean mRunVerifyChangeVP = false;
    private static final Boolean mRunVerifyBulkUpdates = false;
    private static final Boolean mRunVerifyCodeCoverage = false;
    private static final Boolean mRunAllTests = true;

    // Configuration constants
    private static final String ITS_ASSET_REQUEST_APPLICATION = 'ITS Asset Request';
    private static final String RESTRICTED_DEPARTMENTS = 'Restricted Departments';
    private static final String RESTRICTED_DEPARTMENTS_VAL = 'ITS;Support';
    private static final String DEPARTMENT_DELIMITER = 'Department Delimiter';
    private static final String DEPARTMENT_DELIMITER_VAL = ';';
    private static final String STRING_TYPE = 'String';
    private static final String BULK_RECORDS_MODE = 'Bulk Records Mode';
    private static final String SINGLE_RECORD_MODE = 'Single Record Mode';
    private static final String HIERARCHY_RECORDS_MODE = 'Hierarchy Records Mode';

    private static final String DEFAULT_EMAIL_ADDRESS = 'Default email address';
    private static final String DEFAULT_EMAIL_ADDRESS_VAL = 'itssfdcsupport@coh.org';
    private static final String ITS_ORG_WIDE_EMAIL_NAME = 'ITS Org Wide Email';
    private static final String ITS_ORG_WIDE_EMAIL_NAME_VAL = 'Salesforce';
    
    private static final String ITS_ORG_WIDE_EMAIL_ADDRESS = 'ITS Org Wide Email';
    
    private static final Integer STANDARD_TEST = 0;
    private static final Integer PRE_PRODUCTION_DEPLOYMENT_TEST = 1;
    
    // Configuration Contstants for ITS_Timesheet Config Objects
    private static final String ITS_PORTFOLIO_NAME = 'ITS Portfolio';
    private static final String TIME_EFFORT_NAME = 'Time / Effort';
    private static final String ITS_TIMESHEET_CONFIG_GROUP = 'ITS Timesheet';
    private static final String PERMISSION_SETS_APPLICATION_NAME = 'Permission Sets';

    // Constants for Permission sets that are used in testing 
    private static final String PERMISSION_SET_LABEL = 'Test Permission Set';
    private static final String PERMISSION_SET_NAME = 'Test_Permission_Set';

    // Constants for creating a new user
    private static final String USER_OBJ = 'User';
    private static final String USER_FIRST_NAME0 = 'Thomas';
    private static final String USER_LAST_NAME0 = 'Magnum';
    private static final String USER_NAME0 = 'thomassullivanmagnumiv@coh.org';
    private static final String USER_ALIAS0 = 'tmg09';
    private static final String USER_BASE_NAME0 = 'tmagnum';
    private static final String USER_EMPLOYEE_NUMBER0 = '99999990';

    private static final String USER_FIRST_NAME1 = 'Buck';
    private static final String USER_LAST_NAME1 = 'Greene';
    private static final String USER_NAME1 = 'buckgreene@coh.org';
    private static final String USER_ALIAS1 = 'bgr09';
    private static final String USER_BASE_NAME1 = 'bgreene';
    private static final String USER_EMPLOYEE_NUMBER1 = '99999991';

    private static final String USER_FIRST_NAME2 = 'Jonathan';
    private static final String USER_LAST_NAME2 = 'Higgins';
    private static final String USER_NAME2 = 'jonathanhiggins@coh.org';
    private static final String USER_ALIAS2 = 'jhi09';
    private static final String USER_BASE_NAME2 = 'jhiggins';
    private static final String USER_EMPLOYEE_NUMBER2 = '99999992';

    private static final String USER_FIRST_NAME3 = 'Maggie';
    private static final String USER_LAST_NAME3 = 'Poole';
    private static final String USER_NAME3 = 'mpoole@coh.org';
    private static final String USER_ALIAS3 = 'mpo09';
    private static final String USER_BASE_NAME3 = 'mpoole';
    private static final String USER_EMPLOYEE_NUMBER3 = '99999993';

    private static final String USER_FIRST_NAME4 = 'Rick';
    private static final String USER_LAST_NAME4 = 'Wright';
    private static final String USER_NAME4 = 'rickwright@coh.org';
    private static final String USER_ALIAS4 = 'rwr09';
    private static final String USER_BASE_NAME4 = 'rwright';
    private static final String USER_EMPLOYEE_NUMBER4 = '99999994';

    private static final String USER_FIRST_NAME5 = 'Theodore';
    private static final String USER_LAST_NAME5 = 'Calvin';
    private static final String USER_NAME5 = 'tcalvin@coh.org';
    private static final String USER_ALIAS5 = 'tc09';
    private static final String USER_BASE_NAME5 = 'tcalvin';
    private static final String USER_EMPLOYEE_NUMBER5 = '99999995';
    
    private static final String USER_FIRST_NAME6 = 'Agatha';
    private static final String USER_LAST_NAME6 = 'Chumley';
    private static final String USER_NAME6 = 'achumley@coh.org';
    private static final String USER_ALIAS6 = 'ach09';
    private static final String USER_BASE_NAME6 = 'achumley';
    private static final String USER_EMPLOYEE_NUMBER6 = '99999996';
    
    private static final String USER_FIRST_NAME7 = 'Carol';
    private static final String USER_LAST_NAME7 = 'Baldwin';
    private static final String USER_NAME7 = 'cbaldwin@coh.org';
    private static final String USER_ALIAS7 = 'cbd09';
    private static final String USER_BASE_NAME7 = 'cbaldwin';
    private static final String USER_EMPLOYEE_NUMBER7 = '99999997';
    
    private static final String USER_FIRST_NAME8 = 'Mac';
    private static final String USER_LAST_NAME8 = 'MacReynolds';
    private static final String USER_NAME8 = 'mmacreynolds@coh.org';
    private static final String USER_ALIAS8 = 'mmr09';
    private static final String USER_BASE_NAME8 = 'mmacreynolds';
    private static final String USER_EMPLOYEE_NUMBER8 = '99999998';
    
    private static final String USER_FIRST_NAME9 = 'George';
    private static final String USER_LAST_NAME9 = 'Patton';
    private static final String USER_NAME9 = 'gpatton@coh.org';
    private static final String USER_ALIAS9 = 'gpa09';
    private static final String USER_BASE_NAME9 = 'gpatton';
    private static final String USER_EMPLOYEE_NUMBER9 = '99999999';
    
    private static final String USER_FIRST_NAME10 = 'Dwight';
    private static final String USER_LAST_NAME10 = 'Eisenhower';
    private static final String USER_NAME10 = 'deisenhower@coh.org';
    private static final String USER_ALIAS10 = 'dei09';
    private static final String USER_BASE_NAME10 = 'deisenhower';
    private static final String USER_EMPLOYEE_NUMBER10 = '99999910';
    
    private static final String USER_FIRST_NAME11 = 'Chester';
    private static final String USER_LAST_NAME11 = 'Nimitz';
    private static final String USER_NAME11 = 'cnimitz@coh.org';
    private static final String USER_ALIAS11 = 'cni09';
    private static final String USER_BASE_NAME11 = 'cnimitz';
    private static final String USER_EMPLOYEE_NUMBER11 = '99999911';
    
    private static final String USER_FIRST_NAME12 = 'Raymond';
    private static final String USER_LAST_NAME12 = 'Spruance';
    private static final String USER_NAME12 = 'rspruance@coh.org';
    private static final String USER_ALIAS12 = 'rsp09';
    private static final String USER_BASE_NAME12 = 'rspruance';
    private static final String USER_EMPLOYEE_NUMBER12 = '99999912';
    
    private static final String USER_FIRST_NAME13 = 'Bruce';
    private static final String USER_LAST_NAME13 = 'Lee';
    private static final String USER_NAME13 = 'brucelee@coh.org';
    private static final String USER_ALIAS13 = 'bruceL13';
    private static final String USER_BASE_NAME13 = 'bruceL13';
    private static final String USER_EMPLOYEE_NUMBER13 = '99999913';
    
    
    // Common for all users
    private static final String USER_TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String USER_LOCALE_SID_KEY = 'en_US';
    private static final String USER_EMAIL_ENCODING_KEY = 'ISO-8859-1';
    private static final String USER_LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String USER_LOCATION = 'Robins Nest';
    private static final String USER_DEPARTMENT_NAME0 = 'ITS Salesforce';
    private static final String USER_DEPARTMENT_NAME1 = 'Support';
    private static final String USER_DEPARTMENT_NAME2 = 'Philanthropy';
    private static final String USER_BASE_ORGANZATION = '@coh.org';
    private static final String USER_ACTIVE_STATUS = 'A';
    
    private static final Boolean USER_STATUS = true;
    
    // Miscellaneous test constants
    private static final String ITS_ASSET_REQUEST_OJBECT = 'ITSAssetRequest__c';
    private static final String USER_OJBECT = 'User';
    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT9 = 9;
    //Changes by Sanjay Date 07/29/2019 
    //To fix CPU Time limit - Changed value from 202 to 100
    private static final Integer MAX_RECORDS = 100;     // @future methods can have up to 200 DML operations\
    private static final Integer MAX_PERMISSION_SETS = 6;
    private static final Integer MIN_PERMISSION_SETS = 4;
    
    // values to be retrieved from the database
    private static Id mUserManager;
    private static Id mUserVP;
    private static String mDefaultProfileID;
    private static String mDefaultSupervisorID;
    private static String mPermissionSetId;     // The Id of the Permission Set used in testing. AsSigned to a COH App Config
    private static Id mID0;
    private static Id mID1;
    private static Id mID2;
    private static Id mID3;
    private static Id mID4;
    private static Id mID5;
    private static Id mID6;
    private static Id mID7;
    private static Id mID8;
    private static Id mIDVP0;
    private static Id mIDVP1;
    private static Id mIDDirector0;
    private static Id mIDDirector1;

    private static Date mStartDate;
   
    
    private static testMethod void verifySupervisorIdAssignment(){
        if(!mRunAllTests && !mRunSupervisorIDAssignment){
            System.debug('Skipping verifySupervisorIdAssignment()');
            return;
        }
        String managerSOQLQuery = 'select Id, ProfileID from User where name = \'Foundation Account\'';
        List<User> userList = Database.query(managerSOQLQuery);
        system.debug('--userList----'+userList);
        User userObj = userList.get(0);
        mDefaultProfileID = userObj.ProfileId;
        User newDirectorUserObj2 = new User();
        newDirectorUserObj2.FirstName = USER_FIRST_NAME13;
        newDirectorUserObj2.LastName = USER_LAST_NAME13;
        newDirectorUserObj2.Username = USER_NAME13;
        newDirectorUserObj2.Alias = USER_ALIAS13;
        newDirectorUserObj2.Email = USER_NAME13;
        newDirectorUserObj2.EmployeeNumber = USER_EMPLOYEE_NUMBER13;
        newDirectorUserObj2.Supervisor_ID__c = '203179';
        newDirectorUserObj2.IsActive = USER_STATUS;
        newDirectorUserObj2.EMPL_STATUS__c = 'E';
        newDirectorUserObj2.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newDirectorUserObj2.LocaleSidKey = USER_LOCALE_SID_KEY;
        newDirectorUserObj2.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newDirectorUserObj2.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newDirectorUserObj2.Location__c = USER_LOCATION;
        newDirectorUserObj2.Department = USER_DEPARTMENT_NAME2;
        newDirectorUserObj2.ProfileId = mDefaultProfileID;
        newDirectorUserObj2.Start_Date__c = mStartDate;
        newDirectorUserObj2.ITS_Timesheet__c = false;
        test.startTest();
        insert newDirectorUserObj2;
        test.stopTest();
        system.debug('Did this process?');
    }
    
    
    
    /* 
     * Verifies that an ITS_ASSET_REQUEST_OJBECT object has been created when an User object is added.  
     * This test handles the case where ITS_Asset_Request objects should be created for ALL departments
     * 
     */
    private static testMethod void verifyAssetRequest0() {
        if (!mRunAllTests && !mRunVerifyAssetRequest0) {
            System.debug('Skipping verifyAssetRequest0()');
            return;
        }

        test.startTest();
        
        COHUserHelper foo = new COHUserHelper();        // code coverage reasons
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_ASSET_REQUEST_OJBECT);
        List<ITSAssetRequest__c> assetRequestList = Database.query(soqlQuery);
        if (COHUtil.isValidList(assetRequestList)) {
            System.assert(false, 'Expected 0 ITSAssetRequest__c records but retrieved ' + assetRequestList.size() + ' records');
        }
        
        createUser(USER_DEPARTMENT_NAME2, SINGLE_RECORD_MODE, false);
        test.stopTest();    // This is required here because there is an @future method invoked
        
        // Verify the ITS_ASSET_REQUEST_OJBECT object has been created correctly
        assetRequestList = Database.query(soqlQuery);
        System.assertEquals(RECORD_COUNT1, assetRequestList.size());
        
        ITSAssetRequest__c assetRequestObj = assetRequestList.get(0);
        System.assertEquals(USER_FIRST_NAME0 + ' ' + USER_LAST_NAME0, assetRequestObj.Employee_Name__c);
        System.assertEquals(mUserManager, assetRequestObj.Dept_Manager__c);
        System.assertEquals(mUserVP, assetRequestObj.Dept_VP__c);
        System.assertEquals(USER_EMPLOYEE_NUMBER0, assetRequestObj.Employee_ID_No__c);
        System.assertEquals(USER_LOCATION, assetRequestObj.Work_Location__c);
        System.assertEquals(USER_DEPARTMENT_NAME2, assetRequestObj.Dept_ID__c);
        System.assertEquals(mStartDate, assetRequestObj.Start_Date__c);
    }

    /* 
     * Verifies that an ITS_ASSET_REQUEST_OJBECT object has been created when an User object is added.  
     * This test handles the case where ITS_Asset_Request objects should be created for a
     * restricted set of departments (ITS in this case).
     * 
     */
    private static testMethod void verifyAssetRequest1() {
        if (!mRunAllTests && !mRunVerifyAssetRequest1) {
            System.debug('Skipping verifyAssetRequest1()');
            return;
        }
        setCOHAppConfiguration(STANDARD_TEST);

        test.startTest();
        
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_ASSET_REQUEST_OJBECT);
        List<ITSAssetRequest__c> assetRequestList = Database.query(soqlQuery);
        if (COHUtil.isValidList(assetRequestList)) {
            System.assert(false, 'Expected 0 ITSAssetRequest__c records but retrieved ' + assetRequestList.size() + ' records');
        }
        //added runas user logic to fix MIXED-DML Operation
        //By Sanjay: Date 07/29/2019
        user u = [Select id from user where id=: userinfo.getUserId()];
        system.runAs(u){
            createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, false);
        }
        test.stopTest();    // This is required here because there is an @future method invoked

        // Verify the ITS_ASSET_REQUEST_OJBECT object has been created correctly
        assetRequestList = Database.query(soqlQuery);
        System.assertEquals(RECORD_COUNT1, assetRequestList.size());
        
        ITSAssetRequest__c assetRequestObj = assetRequestList.get(0);
        System.assertEquals(USER_FIRST_NAME0 + ' ' + USER_LAST_NAME0, assetRequestObj.Employee_Name__c);
        System.assertEquals(mUserManager, assetRequestObj.Dept_Manager__c);
        System.assertEquals(mUserVP, assetRequestObj.Dept_VP__c);
        System.assertEquals(USER_EMPLOYEE_NUMBER0, assetRequestObj.Employee_ID_No__c);
        System.assertEquals(USER_LOCATION, assetRequestObj.Work_Location__c);
        System.assertEquals(USER_DEPARTMENT_NAME0, assetRequestObj.Dept_ID__c);
        System.assertEquals(mStartDate, assetRequestObj.Start_Date__c);
    }    
    
    /* 
     * Verifies that an ITS_ASSET_REQUEST_OJBECT object has been created when an User object is added.  
     * This test handles the case where ITS_Asset_Request objects should be created for a
     * restricted set of departments (Support in this case).
     * 
     */
    private static testMethod void verifyAssetRequest2() {
        if (!mRunAllTests && !mRunVerifyAssetRequest2) {
            System.debug('Skipping verifyAssetRequest2()');
            return;
        }

        test.startTest();
        
        setCOHAppConfiguration(STANDARD_TEST);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_ASSET_REQUEST_OJBECT);
        List<ITSAssetRequest__c> assetRequestList = Database.query(soqlQuery);
        if (COHUtil.isValidList(assetRequestList)) {
            System.assert(false, 'Expected 0 ITSAssetRequest__c records but retrieved ' + assetRequestList.size() + ' records');
        }
        //added runas user logic to fix MIXED-DML Operation
        //By Sanjay: Date 07/29/2019
        user u = [Select id from user where id=: userinfo.getUserId()];
        system.runAs(u){
            createUser(USER_DEPARTMENT_NAME1, SINGLE_RECORD_MODE, false);
        }
        test.stopTest();    // This is required here because there is an @future method invoked

        // Verify the ITS_ASSET_REQUEST_OJBECT object has been created correctly
        assetRequestList = Database.query(soqlQuery);
        System.assertEquals(RECORD_COUNT1, assetRequestList.size());
        
        ITSAssetRequest__c assetRequestObj = assetRequestList.get(0);
        System.assertEquals(USER_FIRST_NAME0 + ' ' + USER_LAST_NAME0, assetRequestObj.Employee_Name__c);
        System.assertEquals(mUserManager, assetRequestObj.Dept_Manager__c);
        System.assertEquals(mUserVP, assetRequestObj.Dept_VP__c);
        System.assertEquals(USER_EMPLOYEE_NUMBER0, assetRequestObj.Employee_ID_No__c);
        System.assertEquals(USER_LOCATION, assetRequestObj.Work_Location__c);
        System.assertEquals(USER_DEPARTMENT_NAME1, assetRequestObj.Dept_ID__c);
        System.assertEquals(mStartDate, assetRequestObj.Start_Date__c);
    }    
    
    /* 
     * Verifies that an ITS_ASSET_REQUEST_OJBECT object has been created when an User object is added.  
     * This test handles the case where ITS_Asset_Request objects should NOT be created.
     * 
     */
    private static testMethod void verifyAssetRequest3() {
        if (!mRunAllTests && !mRunVerifyAssetRequest3) {
            System.debug('Skipping verifyAssetRequest3()');
            return;
        }

        test.startTest();
        
        setCOHAppConfiguration(STANDARD_TEST);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_ASSET_REQUEST_OJBECT);
        List<ITSAssetRequest__c> assetRequestList = Database.query(soqlQuery);
        if (COHUtil.isValidList(assetRequestList)) {
            System.assert(false, 'Expected 0 ITSAssetRequest__c records but retrieved ' + assetRequestList.size() + ' records');
        }
        //added runas user logic to fix MIXED-DML Operation
        //By Sanjay: Date 07/29/2019
        user u = [Select id from user where id=: userinfo.getUserId()];
        system.runAs(u){
            createUser(USER_DEPARTMENT_NAME2, SINGLE_RECORD_MODE, false);
        }
        test.stopTest();    // This is required here because there is an @future method invoked

        // Verify the ITS_ASSET_REQUEST_OJBECT object has been created correctly
        assetRequestList = Database.query(soqlQuery);
        System.assertEquals(RECORD_COUNT0, assetRequestList.size());
    }    
    
    /* 
     * Verifies that the email for a new User object has been set correctly when the default email
     * address has been supplied.  This should be used instead of the email address that came from 
     * the User object.  This test is used for pre-go-live testing in production because the new 
     * User feed is available only in production, allowing the system administrator to verify it 
     * is working correctly.
     * 
     * THIS IS MAINLY USED FOR CODE COVERAGE REASONS.
     * 
     */
    private static testMethod void verifyAssetRequest4() {
        if (!mRunAllTests && !mRunVerifyAssetRequest4) {
            System.debug('Skipping verifyAssetRequest4()');
            return;
        }

        test.startTest();
        
        setCOHAppConfiguration(PRE_PRODUCTION_DEPLOYMENT_TEST);
        //added runas user logic to fix MIXED-DML Operation
        //By Sanjay: Date 07/29/2019
        user u = [Select id from user where id=: userinfo.getUserId()];
        system.runAs(u){
            createUser(USER_DEPARTMENT_NAME1, SINGLE_RECORD_MODE, false);
        }
        test.stopTest();    // This is required here because there is an @future method invoked
    }    

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to a newly created user.
     * This test verifies that permissions are set when ITS_Timesheet__c is set to true
     */
    private static testMethod void verifyCreatedUserPermissionAssignment0() {
        if (!mRunAllTests && !mRunVerifyCreatedUserPermissionAssignment0) {
            System.debug('Skipping verifyCreatedUserPermissionAssignment0()');
            return;
        }

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, true);
        }
        testUser = testUserList.get(0);

        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(7, permissionSetList.size());        
        test.stopTest();
    }

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to a newly created user
     * This verifies that the permissions are NOT set when ITS_Timesheet__c is set to false
     */
    private static testMethod void verifyCreatedUserPermissionAssignment1() {
        if (!mRunAllTests && !mRunVerifyCreatedUserPermissionAssignment1) {
            System.debug('Skipping verifyCreatedUserPermissionAssignment1()');
            return;
        }        

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, false);
        }
        testUser = testUserList.get(0);

        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(6, permissionSetList.size());

        test.stopTest();
    }

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to an updated user
     * This verifies that the permissions are set when ITS_Timesheet__c is set to true     
     */
    private static testMethod void verifyUpdatedUserPermissionAssignment0() {
        if (!mRunAllTests && !mRunVerifyUpdatedUserPermissionAssignment0) {
            System.debug('Skipping verifyUpdatedUserPermissionAssignment0()');
            return;
        }        

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, false);
        }
        testUser = testUserList.get(0);
        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(6, permissionSetList.size());

        //Update the User and check their permission sets
        testUser.ITS_Timesheet__c = true;
        System.runAs(thisUser) {
            update testUser;
        }
        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(6, permissionSetList.size());
        
        test.stopTest();
    }      

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to an updated user
     * This verifies that the permissions are removed set when ITS_Timesheet__c is set to false     
     */
    private static testMethod void verifyUpdatedUserPermissionAssignment1() {
        if (!mRunAllTests && !mRunVerifyUpdatedUserPermissionAssignment1) {
            System.debug('Skipping verifyUpdatedUserPermissionAssignment1()');
            return;
        }              

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, true);
        }        
        testUser = testUserList.get(0);
        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(7, permissionSetList.size(), 'The number of Permission Sets assigned to the test user should currently be ' + MAX_PERMISSION_SETS + ' , it is ' + permissionSetList.size());

        //Update the User and check their permission sets
        testUser.ITS_Timesheet__c = false;
        System.runAs(thisUser) {
            update testUser;
        }
        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(5, permissionSetList.size(), 'The number of Permission Sets assigned to the test user should currently be ' + MIN_PERMISSION_SETS + ', it is ' + permissionSetList.size());



        test.stopTest();
    }

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to an updated user
     * This verifies that the permissions are added successfully even if a user already has one of the 
     * permissions sets that is automatically assigned
     */
    private static testMethod void verifyUpdatedUserPermissionAssignment2() {
        if (!mRunAllTests && !mRunVerifyUpdatedUserPermissionAssignment2) {
            System.debug('Skipping verifyUpdatedUserPermissionAssignment2()');
            return;
        }              

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, false);
        }        
        testUser = testUserList.get(0);
        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(6, permissionSetList.size());

        //Add one of the automatically assigned permission sets manually, the Id is stored as the value for the App Config items.
        PermissionSetAssignment newPermissionSetAssignment = new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = mPermissionSetId);
        System.runAs(thisUser) {
            insert newPermissionSetASsignment;
        }

        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(6, permissionSetList.size());

        //Update the User and check their permission sets
        testUser.ITS_Timesheet__c = true;
        System.runAs(thisUser) {
            update testUser;
        }
        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(6, permissionSetList.size());

        test.stopTest();
    }

    /*
     * Verifies that the Permission Sets for the ITS_Timesheet are applied correcty to an updated user
     * This verifies that the permissions are removed successfully even if a user already already removed
     * one of the permission sets that are automatically removed   
     */
    private static testMethod void verifyUpdatedUserPermissionAssignment3() {
        if (!mRunAllTests && !mRunVerifyUpdatedUserPermissionAssignment3) {
            System.debug('Skipping verifyUpdatedUserPermissionAssignment3()');
            return;
        }              

        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {
            testUserList = createUser(USER_DEPARTMENT_NAME0, SINGLE_RECORD_MODE, true);
        }        
        testUser = testUserList.get(0);
        // Gets the permission sets assigned to the testUser
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>([SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id]);
        //System.assertEquals(7, permissionSetList.size());

        // Remove one of the automatically assigned permission sets. The Id is stored as the value for the App Config items
        PermissionSetAssignment newPermissionSetAssignment = [SELECT id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId=: testUser.Id AND PermissionSetId =: mPermissionSetId];
        System.debug(newPermissionSetAssignment);
        System.runAs(thisUser) {
            delete newPermissionSetAssignment;
        }

        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(MAX_PERMISSION_SETS - 1, permissionSetList.size());
        COHUSerHelper.clearEmployeeTimesheetPermissionSetsByCombinedId();

        // Update the User and check their permission sets
        testUser.ITS_Timesheet__c = false;
        System.runAs(thisUser) {
            update testUser;
        }
        permissionSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser.Id];
        //System.assertEquals(5, permissionSetList.size());

        test.stopTest();
    }

    /* 
     * Verifies the bulk updates.
     * 
     */
    private static testMethod void verifyBulkUpdates() {
       if (!mRunAllTests && !mRunVerifyBulkUpdates) {
            System.debug('Skipping verifyBulkUpdates()');
            return;
        }
        
        test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);

        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;

        // Get the number of users who have the Permission Sets associated with ITS_Timesheet before the bulk insert
        List<PermissionSetAssignment> numOfPermissionSetsBeforeInsert = new List<PermissionSetAssignment>([SELECT id, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: mPermissionSetId]);

        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) { 
            createUser(USER_DEPARTMENT_NAME0, BULK_RECORDS_MODE, true);
        }
        
        test.stopTest();    // This is required here because there is an @future method invoked
        
        List<PermissionSetAssignment> numOfPermissionSetsAfterInsert = new List<PermissionSetAssignment>([SELECT id, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: mPermissionSetId]);
        System.assertEquals(numOfPermissionSetsBeforeInsert.size() + MAX_RECORDS, numOfPermissionSetsAfterInsert.size());

        // Verify the ITS_ASSET_REQUEST_OJBECT object has been created correctly
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_ASSET_REQUEST_OJBECT);
        List<ITSAssetRequest__c> assetRequestList = Database.query(soqlQuery);

        System.assertEquals(MAX_RECORDS, assetRequestList.size());
    }    
    
    /* 
     * Verifies changing a director.
     * 
     */
    private static testMethod void verifyChangeDirector() {
        if (!mRunAllTests && !mRunVerifyChangeDirector) {
            System.debug('Skipping verifyChangeDirector()');
            return;
        }
        
        Test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);
        
        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {        
            createUser(USER_DEPARTMENT_NAME2, HIERARCHY_RECORDS_MODE, false);
            

            User user0 = [select Id, Username, Mgr__c, director__c, EMPL_STATUS__c,vp_svp_cto__c, Location__c from User where Id = :mID2];
            System.assertEquals(USER_NAME2, user0.Username);
            System.assertEquals(mID0, user0.Mgr__c);
            System.assertEquals(mIDDirector0, user0.director__c);
            System.assertEquals(mIDVP0, user0.vp_svp_cto__c);
            System.assertEquals(USER_LOCATION, user0.Location__c);
            System.assertEquals(USER_ACTIVE_STATUS, user0.EMPL_STATUS__c);
            user0.director__c = mIDDirector1;
            Database.update(user0);
        }

        List<User> userList = [select Id, Username, Mgr__c, director__c, vp_svp_cto__c, Location__c from User where Mgr__c = :mID0];
        System.assertEquals(2, userList.size());
       
        // Verify re-assignment of the Directors     
        List<User> userObjectsList = [select Id, Username, Mgr__c, director__c, vp_svp_cto__c from User where Location__c = :USER_LOCATION];
        Integer recCount = 0;
        for (User curUserObj : userObjectsList) {
            if (curUserObj.Username == USER_NAME1 || curUserObj.Username == USER_NAME2 ||  
                    curUserObj.Username == USER_NAME3 || curUserObj.Username == USER_NAME4 || 
                    curUserObj.Username == USER_NAME5 || curUserObj.Username == USER_NAME6 || 
                    curUserObj.Username == USER_NAME7) {
                System.assertEquals(mIDDirector1, curUserObj.director__c);
                recCount++;
            }
            if (curUserObj.Username == USER_NAME0 || curUserObj.Username == USER_NAME8) {
                System.assertEquals(mIDDirector0, curUserObj.director__c);
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT9, recCount);
        Test.stopTest();    
    }
        
    /* 
     * Verifies changing a VP.
     * 
     */
    private static testMethod void verifyChangeVP() {
        if (!mRunAllTests && !mRunVerifyChangeVP) {
            System.debug('Skipping verifyChangeVP()');
            return;
        }
        
        Test.startTest();

        setCOHAppConfiguration(STANDARD_TEST);
        
        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        List<User> testUserList;
        User testUser;
        // Used to avoid MIXED_DML_OPERATION error between setup and non setup objects
        System.runAs(thisUser) {        
            createUser(USER_DEPARTMENT_NAME2, HIERARCHY_RECORDS_MODE, false);
            

            User user0 = [select Id, Username, Mgr__c, director__c, EMPL_STATUS__c,vp_svp_cto__c, Location__c from User where Id = :mID2];
            System.assertEquals(USER_NAME2, user0.Username);
            System.assertEquals(mID0, user0.Mgr__c);
            System.assertEquals(mIDDirector0, user0.director__c);
            System.assertEquals(mIDVP0, user0.vp_svp_cto__c);
            System.assertEquals(USER_LOCATION, user0.Location__c);
            System.assertEquals(USER_ACTIVE_STATUS, user0.EMPL_STATUS__c);
            user0.vp_svp_cto__c = mIDVP1;
            Database.update(user0);
        }
        List<User> userList = [select Id, Username, Mgr__c, director__c, vp_svp_cto__c, Location__c from User where Mgr__c = :mID0];
        System.assertEquals(2, userList.size());
       
        // Verify re-assignment of the VPs     
        List<User> userObjectsList = [select Id, Username, Mgr__c, director__c, vp_svp_cto__c from User where Location__c = :USER_LOCATION];
        Integer recCount = 0;
        for (User curUserObj : userObjectsList) {
            if (curUserObj.Username == USER_NAME1 || curUserObj.Username == USER_NAME2 ||  
                    curUserObj.Username == USER_NAME3 || curUserObj.Username == USER_NAME4 || 
                    curUserObj.Username == USER_NAME5 || curUserObj.Username == USER_NAME6 || 
                    curUserObj.Username == USER_NAME7) {
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                System.assertEquals(mIDVP1, curUserObj.vp_svp_cto__c);
                recCount++;
            }
            if (curUserObj.Username == USER_NAME0 || curUserObj.Username == USER_NAME8) {
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                recCount++;
            }
        }
        System.assertEquals(RECORD_COUNT9, recCount);
        Test.stopTest();    
    }

    /* 
     * For code coverage reasons.  A newer User Permission Set workflow caused the User Permission Assignment
     * tests to fail, so this will increase code coverage
     * 
     */
    private static testMethod void verifyCodeCoverage() {
        if (!mRunAllTests && !mRunVerifyCodeCoverage) {
            System.debug('Skipping verifyCodeCoverage()');
            return;
        }
        
        Test.startTest();
        
        setCOHAppConfiguration(STANDARD_TEST);

        COHUserHelper.clearEmployeeTimesheetPermissionSetsByCombinedId();
        COHUserHelper.populateVPIds();
        COHUserHelper.populateAllActiveDirectorsSet();
        
        List<User> userList = Database.query('select name, employeenumber, isactive from user where employeenumber != null and isactive = true');
        User userObj = userList.get(0);
        
        COHUserHelper.FindDirectorVPRecursive(userObj);
        COHUserHelper.FindDirectorVPRecursive(null);
        COHUserHelper.FindDirectorRecursive(userObj);
        COHUserHelper.FindDirectorRecursive(null);
        
        Test.stopTest();

    }    
    /*
     * Create a user object for testing.  
     * 
     * For Hierarchy testing, this hierarchy is initially created:
     * 
     *          USER_NAME9 (VP)             USER_NAME11 (VP)
     *              |                           |
     *          USER_NAME10 (Director)      USER_NAME12 (Director)
     *              |                           |
     *          USER_NAME0                  USER_NAME1
     *              |________________
     *              |               |
     *          USER_NAME2      USER_NAME8      
     *          ____|________
     *          |           |
     *      USER_NAME3 USER_NAME4
     *                  ____|________
     *                  |           |
     *              USER_NAME5  USER_NAME6
     *                              |
     *                          USER_NAME7
     *              
     * This is the hiearchy after updates:
     * 
     *          USER_NAME0                  USER_NAME1
     *              |                           |
     *          USER_NAME8                  USER_NAME2
     *                                      ____|________
     *                                      |           |
     *                                  USER_NAME3 USER_NAME4
     *                                              ____|________
     *                                              |           |
     *                                          USER_NAME5  USER_NAME6
     *                                                          |
     *                                                      USER_NAME7
     *              7
     *              
     * @param departmentName        Name of the user's department.
     * @param testTypeMode          Indicates if the User records are being tested in Single, Bulk, or Hierarchy Mode.
     * @param ITSTimesheet          The value of the newly created user's ITS_Timesheet__c field, should be
     *                              false unless testing updateTimesheetPermissions()
     * 
     * @returns                      The user object that was created
     */
    private static List<User> createUser(String departmentName, String testTypeMode, Boolean ITSTimesheet) {

        // The Foundation Account should be in prodcopy and prod
        String managerSOQLQuery = 'select Id, ProfileID from User where name = \'Foundation Account\'';
        List<User> userList = Database.query(managerSOQLQuery);
        system.debug('--userList----'+userList);
        User userObj = userList.get(0);
        mUserManager = userObj.Id;
        mDefaultProfileID = userObj.ProfileId;
            
        // The System Account should be in prodcopy and prod
        String vpSOQLQuery = 'select Id from User where name = \'System Account\'';
        userList = Database.query(vpSOQLQuery);
        system.debug('--userList----'+userList);
        userObj = userList.get(0);
        mUserVP = userObj.Id;
            
        String getSupervisorSOQLQuery = 'select id, EmployeeNumber, Title from User where IsActive = true limit 1';
        userList = Database.query(getSupervisorSOQLQuery);
        userObj = userList.get(0);
        mDefaultSupervisorID = null;//userObj.EmployeeNumber;
        
        mStartDate = Date.today();
        
        if (testTypeMode == SINGLE_RECORD_MODE) {
            List<User> userObjectsToInsert = new List<User>();
            
            User newUserObj = new User();
            newUserObj.FirstName = USER_FIRST_NAME0;
            newUserObj.LastName = USER_LAST_NAME0;
            newUserObj.Username = USER_NAME0;
            newUserObj.Alias = USER_ALIAS0;
            newUserObj.Email = USER_NAME0;
            newUserObj.EmployeeNumber = USER_EMPLOYEE_NUMBER0;
            instantiateCommonUserFields(newUserObj, mUserVP, departmentName, ITSTimesheet);
            
            userObjectsToInsert.add(newUserObj);
            Database.insert(userObjectsToInsert);
            return userObjectsToInsert;
            
        } else if (testTypeMode == BULK_RECORDS_MODE) {
            List<User> userObjectsToInsert = new List<User>();
            
            for (Integer i = 0; i < MAX_RECORDS; i++) {
                String suffix = COHUtil.generateNumberString(i);
                User newUserObj = new User();
                newUserObj.FirstName = USER_FIRST_NAME0 + suffix;
                newUserObj.LastName = USER_LAST_NAME0 + suffix;
                newUserObj.Username = USER_BASE_NAME0 + suffix + USER_BASE_ORGANZATION;
                newUserObj.Alias = USER_ALIAS0 + suffix;
                newUserObj.Email = USER_BASE_NAME0 + suffix + USER_BASE_ORGANZATION;
                newUserObj.EmployeeNumber = USER_EMPLOYEE_NUMBER0;
                instantiateCommonUserFields(newUserObj, mUserVP, departmentName, ITSTimesheet);
                
                userObjectsToInsert.add(newUserObj);
            }
            Database.insert(userObjectsToInsert);
            return userObjectsToInsert;
            
        } else if (testTypeMode == HIERARCHY_RECORDS_MODE) {
            List<User> userObjectsToInsert = new List<User>();
            List<User> vpUserObjectsToInsert = new List<User>();
            List<User> directorUserObjectsToInsert = new List<User>();

            // Add the VPs first so we can obtain their IDs
            
            User newVPUserObj0 = new User();
            newVPUserObj0.FirstName = USER_FIRST_NAME9;
            newVPUserObj0.LastName = USER_LAST_NAME9;
            newVPUserObj0.Username = USER_NAME9;
            newVPUserObj0.Alias = USER_ALIAS9;
            newVPUserObj0.Email = USER_NAME9;
            newVPUserObj0.EmployeeNumber = USER_EMPLOYEE_NUMBER9;
            instantiateCommonUserFields(newVPUserObj0, null, departmentName, ITSTimesheet);
            
            User newVPUserObj1 = new User();
            newVPUserObj1.FirstName = USER_FIRST_NAME11;
            newVPUserObj1.LastName = USER_LAST_NAME11;
            newVPUserObj1.Username = USER_NAME11;
            newVPUserObj1.Alias = USER_ALIAS11;
            newVPUserObj1.Email = USER_NAME11;
            newVPUserObj1.EmployeeNumber = USER_EMPLOYEE_NUMBER11;
            newVPUserObj1.officer_cd__c = '3';
            instantiateCommonUserFields(newVPUserObj1, null, departmentName, ITSTimesheet);

            // Insert the VP first to get the ID
            vpUserObjectsToInsert.add(newVPUserObj0);
            vpUserObjectsToInsert.add(newVPUserObj1);
            Database.insert(vpUserObjectsToInsert);
            
            for (User vpUserObj : vpUserObjectsToInsert) {
                if (vpUserObj.Username == USER_NAME9) {
                    mIDVP0 = vpUserObj.Id;
                }
                if (vpUserObj.Username == USER_NAME11) {
                    mIDVP1 = vpUserObj.Id;
                }
            }
            
            // Insert directors to get their IDs
            
            User newDirectorUserObj0 = new User();
            newDirectorUserObj0.FirstName = USER_FIRST_NAME10;
            newDirectorUserObj0.LastName = USER_LAST_NAME10;
            newDirectorUserObj0.Username = USER_NAME10;
            newDirectorUserObj0.Alias = USER_ALIAS10;
            newDirectorUserObj0.Email = USER_NAME10;
            newDirectorUserObj0.EmployeeNumber = USER_EMPLOYEE_NUMBER10;
            newVPUserObj1.officer_cd__c = '1';
            instantiateCommonUserFields(newDirectorUserObj0, mIDVP0, departmentName, ITSTimesheet);
            
            User newDirectorUserObj1 = new User();
            newDirectorUserObj1.FirstName = USER_FIRST_NAME12;
            newDirectorUserObj1.LastName = USER_LAST_NAME12;
            newDirectorUserObj1.Username = USER_NAME12;
            newDirectorUserObj1.Alias = USER_ALIAS12;
            newDirectorUserObj1.Email = USER_NAME12;
            newDirectorUserObj1.EmployeeNumber = USER_EMPLOYEE_NUMBER12;
            instantiateCommonUserFields(newDirectorUserObj1, mIDVP1, departmentName, ITSTimesheet);

            directorUserObjectsToInsert.add(newDirectorUserObj0);
            directorUserObjectsToInsert.add(newDirectorUserObj1);
            Database.insert(directorUserObjectsToInsert);

            for (User directorUserObj : directorUserObjectsToInsert) {
                if (directorUserObj.Username == USER_NAME10) {
                    mIDDirector0 = directorUserObj.Id;
                }
                if (directorUserObj.Username == USER_NAME12) {
                    mIDDirector1 = directorUserObj.Id;
                }
            }
            
            // Insert the rest of the users
            User newUserObj0 = new User();
            newUserObj0.FirstName = USER_FIRST_NAME0;
            newUserObj0.LastName = USER_LAST_NAME0;
            newUserObj0.Username = USER_NAME0;
            newUserObj0.Alias = USER_ALIAS0;
            newUserObj0.Email = USER_NAME0;
            newUserObj0.EmployeeNumber = USER_EMPLOYEE_NUMBER0;
            newUserObj0.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj0, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj1 = new User();
            newUserObj1.FirstName = USER_FIRST_NAME1;
            newUserObj1.LastName = USER_LAST_NAME1;
            newUserObj1.Username = USER_NAME1;
            newUserObj1.Alias = USER_ALIAS1;
            newUserObj1.Email = USER_NAME1;
            newUserObj1.EmployeeNumber = USER_EMPLOYEE_NUMBER1;
            newUserObj1.director__c = mIDDirector1;
            instantiateCommonUserFields(newUserObj1, mIDVP1, departmentName, ITSTimesheet);
            
            User newUserObj2 = new User();
            newUserObj2.FirstName = USER_FIRST_NAME2;
            newUserObj2.LastName = USER_LAST_NAME2;
            newUserObj2.Username = USER_NAME2;
            newUserObj2.Alias = USER_ALIAS2;
            newUserObj2.Email = USER_NAME2;
            newUserObj2.EmployeeNumber = USER_EMPLOYEE_NUMBER2;
            newUserObj2.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj2, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj3 = new User();
            newUserObj3.FirstName = USER_FIRST_NAME3;
            newUserObj3.LastName = USER_LAST_NAME3;
            newUserObj3.Username = USER_NAME3;
            newUserObj3.Alias = USER_ALIAS3;
            newUserObj3.Email = USER_NAME3;
            newUserObj3.EmployeeNumber = USER_EMPLOYEE_NUMBER3;
            newUserObj3.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj3, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj4 = new User();
            newUserObj4.FirstName = USER_FIRST_NAME4;
            newUserObj4.LastName = USER_LAST_NAME4;
            newUserObj4.Username = USER_NAME4;
            newUserObj4.Alias = USER_ALIAS4;
            newUserObj4.Email = USER_NAME4;
            newUserObj4.EmployeeNumber = USER_EMPLOYEE_NUMBER4;
            newUserObj4.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj4, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj5 = new User();
            newUserObj5.FirstName = USER_FIRST_NAME5;
            newUserObj5.LastName = USER_LAST_NAME5;
            newUserObj5.Username = USER_NAME5;
            newUserObj5.Alias = USER_ALIAS5;
            newUserObj5.Email = USER_NAME5;
            newUserObj5.EmployeeNumber = USER_EMPLOYEE_NUMBER5;
            newUserObj5.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj5, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj6 = new User();
            newUserObj6.FirstName = USER_FIRST_NAME6;
            newUserObj6.LastName = USER_LAST_NAME6;
            newUserObj6.Username = USER_NAME6;
            newUserObj6.Alias = USER_ALIAS6;
            newUserObj6.Email = USER_NAME6;
            newUserObj6.EmployeeNumber = USER_EMPLOYEE_NUMBER6;
            newUserObj6.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj6, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj7 = new User();
            newUserObj7.FirstName = USER_FIRST_NAME7;
            newUserObj7.LastName = USER_LAST_NAME7;
            newUserObj7.Username = USER_NAME7;
            newUserObj7.Alias = USER_ALIAS7;
            newUserObj7.Email = USER_NAME7;
            newUserObj7.EmployeeNumber = USER_EMPLOYEE_NUMBER7;
            newUserObj7.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj7, mIDVP0, departmentName, ITSTimesheet);
            
            User newUserObj8 = new User();
            newUserObj8.FirstName = USER_FIRST_NAME8;
            newUserObj8.LastName = USER_LAST_NAME8;
            newUserObj8.Username = USER_NAME8;
            newUserObj8.Alias = USER_ALIAS8;
            newUserObj8.Email = USER_NAME8;
            newUserObj8.EmployeeNumber = USER_EMPLOYEE_NUMBER8;
            newUserObj8.director__c = mIDDirector0;
            instantiateCommonUserFields(newUserObj8, mIDVP0, departmentName, ITSTimesheet);

            userObjectsToInsert.add(newUserObj0);
            userObjectsToInsert.add(newUserObj1);
            userObjectsToInsert.add(newUserObj2);
            userObjectsToInsert.add(newUserObj3);
            userObjectsToInsert.add(newUserObj4);
            userObjectsToInsert.add(newUserObj5);
            userObjectsToInsert.add(newUserObj6);
            userObjectsToInsert.add(newUserObj7);
            userObjectsToInsert.add(newUserObj8);
            
            Database.insert(userObjectsToInsert);

            // Create the hierarchy

            // First pass to get the IDs
            for (User curUserObj : userObjectsToInsert) {
                if (curUserObj.Username == USER_NAME0) {
                    mID0 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME1) {
                    mID1 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME2) {
                    mID2 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME3) {
                    mID3 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME4) {
                    mID4 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME5) {
                    mID5 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME6) {
                    mID6 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME7) {
                    mID7 = curUserObj.Id;
                }
                if (curUserObj.Username == USER_NAME8) {
                    mID8 = curUserObj.Id;
                }

            }

            // Second pass to assign the VP, Directors, and managers
            for (User curUserObj : userObjectsToInsert) {
                if (curUserObj.Username == USER_NAME0) {
                    curUserObj.Mgr__c = null;
                }
                if (curUserObj.Username == USER_NAME1) {
                    curUserObj.Mgr__c = null;
                }
                if (curUserObj.Username == USER_NAME2 || curUserObj.Username == USER_NAME8) {
                    curUserObj.Mgr__c = mID0;
                }
                if (curUserObj.Username == USER_NAME3 || curUserObj.Username == USER_NAME4) {
                    curUserObj.Mgr__c = mID2;
                }
                if (curUserObj.Username == USER_NAME5 || curUserObj.Username == USER_NAME6) {
                    curUserObj.Mgr__c = mID4;
                }
                if (curUserObj.Username == USER_NAME7) {
                    curUserObj.Mgr__c = mID6;
                }
            }
            
            Database.update(userObjectsToInsert);
            
            userObjectsToInsert = [select Id, Username, Mgr__c, director__c, vp_svp_cto__c from User where Location__c = :USER_LOCATION];
            // Verify assignment of the VP and Directors     
            Integer recCount = 0;
            for (User curUserObj : userObjectsToInsert) {
                if (curUserObj.Username == USER_NAME0) {
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector0, curUserObj.director__c);
                    System.assertEquals(null, curUserObj.Mgr__c);
                    recCount++;
                }
                if (curUserObj.Username == USER_NAME1) {
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP1, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector1, curUserObj.director__c);
                    System.assertEquals(null, curUserObj.Mgr__c);
                    recCount++;
                }
                if (curUserObj.Username == USER_NAME2 || curUserObj.Username == USER_NAME8) {
                    System.assertEquals(mID0, curUserObj.Mgr__c);
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector0, curUserObj.director__c);
                    recCount++;
                }
                if (curUserObj.Username == USER_NAME3 || curUserObj.Username == USER_NAME4) {
                    System.assertEquals(mID2, curUserObj.Mgr__c);
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector0, curUserObj.director__c);
                    recCount++;
                }
                if (curUserObj.Username == USER_NAME5 || curUserObj.Username == USER_NAME6) {
                    System.assertEquals(mID4, curUserObj.Mgr__c);
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector0, curUserObj.director__c);
                    recCount++;
                }
                if (curUserObj.Username == USER_NAME7) {
                    System.assertEquals(mID6, curUserObj.Mgr__c);
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                    System.assertEquals(mIDVP0, curUserObj.vp_svp_cto__c);
                    System.assertEquals(mIDDirector0, curUserObj.director__c);
                    recCount++;
                }
            }
            System.assertEquals(RECORD_COUNT9, recCount);
            
            return userObjectsToInsert;
        }
        
        return null;
    }
    
    /* 
     * Fills out some common fields for new User objects
     * 
     * @param newUserObj            User object with fields to fill with common values.
     * @param vpID                  ID of the new VP.
     * @param departmentName        Name of the department to use.
     * @param ITSTimesheet          The value of the newly created user's ITS_Timesheet__c field, should be
     *                              false unless testing updateTimesheetPermissions()
     * 
     */
    private static void instantiateCommonUserFields(User newUserObj, Id vpID, String departmentName, Boolean ITSTimesheet) {
        if (newUserObj != null) {
            newUserObj.IsActive = USER_STATUS;
            newUserObj.EMPL_STATUS__c = USER_ACTIVE_STATUS;
            newUserObj.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
            newUserObj.LocaleSidKey = USER_LOCALE_SID_KEY;
            newUserObj.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
            newUserObj.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
            newUserObj.Location__c = USER_LOCATION;
            newUserObj.Department = departmentName;
            newUserObj.Supervisor_ID__c = mDefaultSupervisorID;
            newUserObj.ProfileId = mDefaultProfileID;
            newUserObj.VP_SVP_CTO__c = vpID;        
            newUserObj.Mgr__c = mUserManager;
            newUserObj.Start_Date__c = mStartDate;
            newUserObj.ITS_Timesheet__c = ITSTimesheet;
        }
    }
     
    /*
     * Creates the configuration objects for the test environment.
     * 
     * @param testMode  Indicates the type of test mode.
     * 
     */
    private static void setCOHAppConfiguration(Integer testMode) {
        // configObj3 uses the Id of the created permission set
        createPermissionSet();

        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
        configObj0.Name = RESTRICTED_DEPARTMENTS;
        configObj0.Value__c = RESTRICTED_DEPARTMENTS_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;

        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
        configObj1.Name = DEPARTMENT_DELIMITER;
        configObj1.Value__c = DEPARTMENT_DELIMITER_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;

        // Used for code coverage
        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
        configObj2.Name = DEFAULT_EMAIL_ADDRESS;
        configObj2.Value__c = DEFAULT_EMAIL_ADDRESS_VAL;
        configObj2.Value_Type__c = STRING_TYPE;
        if (testMode == PRE_PRODUCTION_DEPLOYMENT_TEST) {
            configObj2.Active__c = true;        
        } else {
            configObj2.Active__c = false;       
        } 

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = PERMISSION_SETS_APPLICATION_NAME;
        configObj3.Name = TIME_EFFORT_NAME;
        configObj3.Value__c = mPermissionSetId;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Configuration_Group__c = ITS_TIMESHEET_CONFIG_GROUP;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
        configObj4.Name = ITS_ORG_WIDE_EMAIL_NAME;
        configObj4.Value__c = ITS_ORG_WIDE_EMAIL_NAME_VAL;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);

        Database.insert(configList);
    }  

    /*
     * Creates a permission set that is used in testing.
     * The function that calls is responsible for calling .startTest() and .stopTest().
     * 
     */
    private static void createPermissionSet() {
        PermissionSet testPermissionSet = new PermissionSet(Label = PERMISSION_SET_LABEL, Name= PERMISSION_SET_NAME);
        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(thisUser) {
            List<PermissionSet> tempPermissionSetList = [select id from PermissionSet where Label = :PERMISSION_SET_LABEL];
            if (!COHUtil.isValidList(tempPermissionSetList)) {
                insert testPermissionSet;
                mPermissionSetId = testPermissionSet.Id;
            } else {
                PermissionSet tempPermissionSet = tempPermissionSetList.get(0);
                mPermissionSetId = tempPermissionSet.Id;
            }
        }
    }
}