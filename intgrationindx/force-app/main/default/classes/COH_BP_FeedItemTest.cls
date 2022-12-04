/* 
 * This test class verifies the functionality of COH_BP_FeedItemHelper for 
 * the COH Blue Pencil application.
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
public class COH_BP_FeedItemTest {
    private static final Boolean mRunVerifyNoSanitizing = false;
    private static final Boolean mRunVerifyInsertSanitizing0 = false;
    private static final Boolean mRunVerifyInsertSanitizing1 = false;
    private static final Boolean mRunVerifyInsertSanitizing2 = false;
    private static final Boolean mRunVerifyInsertSanitizing3 = false;
    private static final Boolean mRunVerifyInsertSanitizing4 = false;
    private static final Boolean mRunVerifyInsertSanitizing5 = false;
    private static final Boolean mRunVerifyInsertSanitizing6 = false;
    private static final Boolean mRunVerifyInsertSanitizing7 = false;
    private static final Boolean mRunVerifyInsertSanitizing8 = true;
    private static final Boolean mRunVerifyInsertSanitizing9 = false;
    private static final Boolean mRunVerifyBulkInserts = false;
    private static final Boolean mRunAllTests = true;

    // Configuration constants
    private static final String CHATTER_BP_VIOLATION = '******';
    private static final String RULE_NAME0 = 'Rule0';
    private static final String RULE_NAME1 = 'Rule1';
    private static final String RULE_NAME2 = 'Rule2';
    private static final String RULE_NAME3 = 'Rule3';
    private static final String RULE_NAME4 = 'Rule4';
    private static final String RULE_NAME5 = 'Rule5';
    private static final String RULE_SSN_REGEX = '\\d{3}-?\\s*\\d{2}-?\\s*\\d{4}';		// SSN check
    private static final String RULE_MRN_REGEX = '([Mm]{1}[Rr]{1}[Nn]{1})*\\s*#*\\s*[0-9]{7}[0-9]?';		// MRN check
    private static final String RULE_PHONE_REGEX = 'Phone';				// only for literal search
    private static final String RULE_PROFANITY0_REGEX = 'Stupid';		// only for literal search
    private static final String RULE_VISA_REGEX = '4[0-9]{3}\\s*\\-*[0-9]{4}\\s*\\-*[0-9]{4}\\s*\\-*[0-9]{4}';	// Visa check
    private static final String RULE_PROFANITY1_REGEX = 'Idiot';		// only for suppression of FeedItem posts
    
    private static final String CHATTER_GROUP_CONFIG_NAME0 = 'ChatterGroupConfig0';
    private static final String CHATTER_GROUP_CONFIG_NAME1 = 'ChatterGroupConfig1';
    private static final String CHATTER_GROUP_CONFIG_NAME2 = 'ChatterGroupConfig2';
    private static final String CHATTER_GROUP_CONFIG_NAME3 = 'ChatterGroupConfig3';
    private static final String CHATTER_GROUP_CONFIG_NAME4 = 'ChatterGroupConfig4';

	// CollaborationGroup constants    
    private static final String CHATTER_GROUP0_PHI = 'Chatter Group0 PHI Enabled';
    private static final String CHATTER_GROUP1_NO_PHI = 'Chatter Group1 PHI Disabled';
    private static final String CHATTER_GROUP2_NO_PHI = 'Chatter Group2 PHI Disabled';
    private static final String CHATTER_GROUP3_NO_PHI = 'Chatter Group3 PHI Disabled';
    private static final String CHATTER_GROUP4_NO_PHI = 'Chatter Group4 PHI Disabled';
    private static final String PUBLIC_COLLABORATION_TYPE = 'Public';
    
    // FeedItem constants
	private static final String QUESTION_POST_TYPE = 'QuestionPost';	// The only Type that  allows updates to both the Title and Body fields
    
    // COH App Configuration
	private static final String	CHATTER_BP_APP = 'Chatter Blue Pencil';
    private static final String	CHATTER_BP_EMAIL_SUBJECT = 'Chatter Blue Pencil Email Subject';
    private static final String	CHATTER_BP_EMAIL_SUBJECT_VAL = 'Chatter Blue Pencil Violation';
    private static final String	CHATTER_BP_VIOLATION_EMAIL = 'Chatter Blue Pencil Violation Email';
    private static final String	CHATTER_BP_VIOLATION_EMAIL_VAL = 'mfabricius@coh.org';
	private static final String CHATTER_BP_VIOLATION_ADMIN_NAME = 'Chatter Blue Pencil Admin Email Name';
	private static final String CHATTER_BP_VIOLATION_ADMIN_NAME_VAL = 'Salesforce Chatter Administrator';
	private static final String CHATTER_BP_ADD_ERROR_MESSAGE = 'Chatter Blue Pencil addError Message';
	private static final String CHATTER_BP_ADD_ERROR_MESSAGE_VAL = 'Chatter Blue Pencil has suppressed a post due to a rule violation';
    private static final String CHATTER_BP_LOG_INTRO = 'Chatter Log Intro';
    private static final String CHATTER_BP_LOG_INTRO_VAL = 'A Chatter violation has occurred. ';

    private static final String CHATTER_BP_ENABLE_USER_PROFILE_MONITORING = 'Enable User Profile Monitoring';
    private static final String CHATTER_BP_ENABLE_USER_ROLE_MONITORING = 'Enable User Role Monitoring';
	private static final String CHATTER_BP_ENABLE_MONITORING =  'true';
	private static final String CHATTER_BP_DISABLE_MONITORING =  'false';

    // Testing constants
	private static final String TITLE0 = 'SSN 123-67-8907, Stupid telephone MRN # 12345678';
	private static final String TITLE1 = 'xxxx4012-1234-7890 5511';
	private static final String TITLE2 = 'Telephone issues';
	private static final String TITLE3 = 'Credit Card Visa';
	private static final String TITLE4 = 'Mrn 12345678';
	private static final String TITLE5 = 'Idiot spotted';
	private static final String BODY0 = '123 67-8907, Stupid telephone and mobile Phone works. MRN # 12345678';
	private static final String BODY1 = 'Stupid stupid Phone stupidly Stupid crazy 4012-1234-7890 5511 Visa 4012123478905511 Stupid';
	private static final String BODY2 = 'Telephones are not working.  Relying on mobile phone.';
	private static final String BODY3 = 'Visa number: 4012-1234-7890 5511';
	private static final String BODY4 = 'Phone works. 4012-1234-7890 5511 Medical Record Number 12345678';
	private static final String BODY5 = 'I think I spotted an Idiot';
    
    private static final Integer ID_LEN = 15;
    
    private static final String ID_DELIMITER = ';';
    private static final Integer RECORD_COUNT7 = 7;
    private static final Integer RECORD_COUNT6 = 6;
    private static final Integer RECORD_COUNT4 = 4;
    private static final Integer RECORD_COUNT5 = 5;
    private static final Integer RECORD_COUNT3 = 3;
    private static final Integer RECORD_COUNT2 = 2;
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer MAX_RECORDS = 202;
	private static final Boolean SINGLE_RECORD_MODE = true;
	private static final Boolean BULK_RECORD_MODE = false;
    private static final Boolean STANDARD_TESTING = true;
    private static final Boolean EXCEPTION_TESTING = false;

    // values to be retrieved from the database
    private static Id mUserManager;
    private static Id mUserVP;
    private static String mDefaultProfileID;
    private static String mDefaultSupervisorID;
    
	private static User roleTestUserObj0;
	private static User roleTestUserObj1;
    
    private static Date mStartDate;
    
    private static ID mChatterGroupPHI0ID;
    private static ID mChatterGroupNoPHI1ID;
    private static ID mChatterGroupNoPHI2ID;
    private static ID mChatterGroupNoPHI3ID;
    private static ID mChatterGroupNoPHI4ID;
    
    /*
     * Verify the insertion and update of a FeedItem for a Chatter 
     * group where NO sanitizing is required (mChatterGroupPHI0ID).  
     * 
     */
    private static testMethod void verifyNoSanitizing() {
        if (!mRunAllTests && !mRunVerifyNoSanitizing) {
            System.debug('Skipping verifyNoSanitizing()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
		createFeedItem(mChatterGroupPHI0ID, TITLE0, BODY0, SINGLE_RECORD_MODE);	
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());
        
        // Verify the Insert operation did not set off the Chatter Monitor Trigger.
        FeedItem feedItem = feedItemList.get(0);
        System.assertEquals(mChatterGroupPHI0ID, feedItem.ParentId);
        System.assertEquals(TITLE0, feedItem.Title);
        System.assertEquals(BODY0, feedItem.Body);

        // Verify the Update operation did not set off the Chatter Monitor Trigger.

        feedItem.Body = BODY2;
        Database.update(feedItem);

        System.assertEquals(RECORD_COUNT1, feedItemList.size());
        
        feedItem = feedItemList.get(0);
        System.assertEquals(mChatterGroupPHI0ID, feedItem.ParentId);
        System.assertEquals(BODY2, feedItem.Body);

        Test.stopTest();
    }

    /*
     * Verify the insertion of a FeedItem for a Chatter group where sanitizing 
     * is required (mChatterGroupNoPHI2ID).  This Chatter group has one
     * Chatter Group Config Object associated with it: CHATTER_GROUP_CONFIG_NAME1.  
     * These rules are tested: RULE_NAME0, and RULE_NAME1.
     * 
     */
    private static testMethod void verifyInsertSanitizing0() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing0) {
            System.debug('Skipping verifyInsertSanitizing0()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        createFeedItem(mChatterGroupNoPHI1ID, TITLE0, BODY0, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(mChatterGroupNoPHI1ID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertNotEquals(TITLE0, titleStr);
        Integer violationCount = countSubstringOccurrences(titleStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT2, violationCount);

        String bodyStr = feedItem.Body;
        System.assertNotEquals(BODY0, bodyStr);
        violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT2, violationCount);

        // Verify the Update operation set off the Chatter Monitor Trigger.
		feedItem.Title = TITLE4;
        feedItem.Body = BODY4;
        Database.update(feedItem);

        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        feedItem = feedItemList.get(0);
        titleStr = feedItem.Title;
        System.assertNotEquals(TITLE4, titleStr);
        violationCount = countSubstringOccurrences(titleStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT1, violationCount);

        bodyStr = feedItem.Body;
        System.assertNotEquals(BODY4, bodyStr);
        violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT1, violationCount);
        
        // Verify the Update operation did NOT set off the Chatter Monitor Trigger.
		feedItem.Title = TITLE3;
        feedItem.Body = BODY3;
        Database.update(feedItem);

        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        feedItem = feedItemList.get(0);
        titleStr = feedItem.Title;
        System.assertEquals(TITLE3, titleStr);
  
        bodyStr = feedItem.Body;
        System.assertEquals(BODY3, bodyStr);
        
        // No audit log messages should have been created
		List<COH_Log__c> auditLogList = [select Id, Application_Name__c from COH_Log__c where Application_Name__c = :CHATTER_BP_APP];
        System.assertEquals(RECORD_COUNT6, auditLogList.size());
        
        Test.stopTest();
    }
    
    /*
     * Verify the insertion of a FeedItem for a Chatter group where sanitizing 
     * is required (mChatterGroupNoPHI2ID).  This Chatter group has two
     * Chatter Group Config Objects associated with it: CHATTER_GROUP_CONFIG_NAME1
     * and CHATTER_GROUP_CONFIG_NAME2.  These rules are tested: RULE_NAME0, RULE_NAME1, 
     * and RULE_NAME2.
     * 
     */
    private static testMethod void verifyInsertSanitizing1() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing1) {
            System.debug('Skipping verifyInsertSanitizing1()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        createFeedItem(mChatterGroupNoPHI2ID, TITLE0, BODY0, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(mChatterGroupNoPHI2ID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertNotEquals(TITLE0, titleStr);
        Integer violationCount = countSubstringOccurrences(titleStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT3, violationCount);

        String bodyStr = feedItem.Body;
        System.assertNotEquals(BODY0, bodyStr);
        violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT4, violationCount);

		// Audit log messages should have been created
		List<COH_Log__c> auditLogList = [select Id, Application_Name__c from COH_Log__c where Application_Name__c = :CHATTER_BP_APP];
        System.assertEquals(RECORD_COUNT4, auditLogList.size());
        
        Test.stopTest();
    }
    
    /*
     * Verify the insertion of a FeedItem for a Chatter group where sanitizing 
     * is required (mChatterGroupNoPHI3ID).  This Chatter group has one
     * Chatter Group Config Object associated with it: CHATTER_GROUP_CONFIG_NAME3.
     * These rules are tested: RULE_NAME2, RULE_NAME3, and RULE_NAME4.
     * 
     */
    private static testMethod void verifyGroupSanitizing2() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing2) {
            System.debug('Skipping verifyGroupSanitizing2()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        createFeedItem(mChatterGroupNoPHI3ID, TITLE1, BODY1, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(mChatterGroupNoPHI3ID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertEquals(TITLE1, titleStr);

        String bodyStr = feedItem.Body;
        System.assertNotEquals(BODY1, bodyStr);
        Integer violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT7, violationCount);

        Test.stopTest();
    }

    /*
     * Verify the insertion of a FeedItem for a Chatter group where sanitizing 
     * is required (mChatterGroupNoPHI3ID).  This checks for the whole word
     * match.  This Chatter group has one Chatter Group Config Object associated
     * with it: CHATTER_GROUP_CONFIG_NAME3. These rules are tested: 
     * RULE_NAME2, RULE_NAME3, and RULE_NAME4.
     * 
     */
    private static testMethod void verifyGroupSanitizing3() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing3) {
            System.debug('Skipping verifyGroupSanitizing3()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        createFeedItem(mChatterGroupNoPHI3ID, TITLE3, BODY3, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(mChatterGroupNoPHI3ID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertEquals(TITLE3, titleStr);

        String bodyStr = feedItem.Body;
        System.assertNotEquals(BODY3, bodyStr);
        Integer violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT1, violationCount);

        Test.stopTest();
    }

    /*
     * Verify the insertion of a FeedItem for a Chatter group where sanitizing 
     * is required (mChatterGroupNoPHI4ID).  This Chatter group has one
     * Chatter Group Config Objects associated with it: CHATTER_GROUP_CONFIG_NAME4.
     * This rule is tested: RULE_NAME5.  This Chatter Group suppresses posting if a violation
     * is caught.
     * 
     */
    private static testMethod void verifyGroupSanitizing4() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing4) {
            System.debug('Skipping verifyGroupSanitizing4()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
  
        // Inserting an invalid record.  An exception should be thrown.
        Boolean exceptionCaught = false;
        try {
	        createFeedItem(mChatterGroupNoPHI4ID, TITLE5, BODY5, SINGLE_RECORD_MODE);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        System.assertEquals(true, exceptionCaught);

		// No audit log message should have been created because of the thrown exception
		List<COH_Log__c> auditLogList = [select Id, Application_Name__c from COH_Log__c];
        System.assertEquals(RECORD_COUNT0, auditLogList.size());
    }

    /*
     * Verify that an exception is thrown when a rule name is mispelled.
     * 
     */
    private static testMethod void verifyGroupSanitizing5() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing5) {
            System.debug('Skipping verifyGroupSanitizing5()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        createChatterGroups();
        setConfiguration(EXCEPTION_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
  
        Boolean exceptionCaught = false;
        try {
	        createFeedItem(mChatterGroupNoPHI2ID, TITLE5, BODY5, SINGLE_RECORD_MODE);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        System.assertEquals(true, exceptionCaught);
        
    } 


    /*
     * Verify the insertion of a FeedItem directly to other users or
     * to followers.  This tests monitoring based on the User Profile 
     * when the feature has been enabled.
     * 
     */
    private static testMethod void mRunVerifyInsertSanitizing6() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing6) {
            System.debug('Skipping runVerifyInsertSanitizing6()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_PROFILE_MONITORING, CHATTER_BP_ENABLE_MONITORING);
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_ROLE_MONITORING, CHATTER_BP_DISABLE_MONITORING);

        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        // Choose the Foundation Account as the FeedItem owner because it has
        // the COH Foundation Automation profile.  This replicates the situation
        // where a user is sending a message to the Foundation Account user or
        // where the Foundation Account user makes a post for followers.
        User foundationAccount = [select Id, Alias from User where Alias = 'faccount' limit 1];
        System.assertNotEquals(foundationAccount, null);
        
        Id foundationAccountID = foundationAccount.Id;
        createFeedItem(foundationAccountID, TITLE3, BODY3, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(foundationAccountID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertEquals(TITLE3, titleStr);

        String bodyStr = feedItem.Body;
        System.assertNotEquals(BODY3, bodyStr);
        Integer violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT1, violationCount);

        Test.stopTest();
    }

    /*
     * Verify the insertion of a FeedItem directly to other users or
     * to followers.  This tests monitoring based on the User Profile 
     * when the feature has been disabled.
     * 
     */
    private static testMethod void mRunVerifyInsertSanitizing7() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing7) {
            System.debug('Skipping runVerifyInsertSanitizing7()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_PROFILE_MONITORING, CHATTER_BP_DISABLE_MONITORING);
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_ROLE_MONITORING, CHATTER_BP_DISABLE_MONITORING);
        
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        // Choose the Foundation Account as the FeedItem owner because it has
        // the COH Foundation Automation profile.  This replicates the situation
        // where a user is sending a message to the Foundation Account user or
        // where the Foundation Account user makes a post for followers.
        User foundationAccount = [select Id, Alias from User where Alias = 'faccount' limit 1];
        System.assertNotEquals(foundationAccount, null);
        
        Id foundationAccountID = foundationAccount.Id;
        createFeedItem(foundationAccountID, TITLE3, BODY3, SINGLE_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(foundationAccountID, feedItem.ParentId);
        String titleStr = feedItem.Title;

        System.assertEquals(TITLE3, titleStr);

        String bodyStr = feedItem.Body;
        System.assertEquals(BODY3, bodyStr);
        Integer violationCount = countSubstringOccurrences(bodyStr, CHATTER_BP_VIOLATION);
        System.assertEquals(RECORD_COUNT0, violationCount);

        Test.stopTest();
    }

    /*
     * Verify the insertion of a FeedItem directly to other users or
     * to followers.  This tests monitoring based on the User Role
     * when the feature has been enabled.
     * 
     */
    private static testMethod void mRunVerifyInsertSanitizing8() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing8) {
            System.debug('Skipping runVerifyInsertSanitizing8()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_PROFILE_MONITORING, CHATTER_BP_DISABLE_MONITORING);
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_ROLE_MONITORING, CHATTER_BP_ENABLE_MONITORING);
        
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        String baseRoleId = roleTestUserObj0.Id;       
		Id userRoleID = baseRoleId.left(ID_LEN);
        Boolean exceptionCaught = false;
        try {
	        createFeedItem(userRoleID, TITLE5, BODY5, SINGLE_RECORD_MODE);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        System.assertEquals(true, exceptionCaught);
        
        // test another Role ID that should not be monitored

        baseRoleId = roleTestUserObj1.Id;       
		userRoleID = baseRoleId.left(ID_LEN);
        createFeedItem(userRoleID, TITLE5, BODY5, SINGLE_RECORD_MODE);
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(userRoleID, feedItem.ParentId);
        String titleStr = feedItem.Title;
        System.assertEquals(TITLE5, titleStr);

        String bodyStr = feedItem.Body;
        System.assertEquals(BODY5, bodyStr);

        Test.stopTest();
        

    }

    /*
     * Verify the insertion of a FeedItem directly to other users or
     * to followers.  This tests monitoring based on the User Role
     * when the feature has been disabled.
     * 
     */
    private static testMethod void mRunVerifyInsertSanitizing9() {
        if (!mRunAllTests && !mRunVerifyInsertSanitizing9) {
            System.debug('Skipping runVerifyInsertSanitizing9()');
            return;
        }
        
        Test.startTest();
        
        setCOHConfigSetting();
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_PROFILE_MONITORING, CHATTER_BP_DISABLE_MONITORING);
        updateCOHConfigSetting(CHATTER_BP_ENABLE_USER_ROLE_MONITORING, CHATTER_BP_DISABLE_MONITORING);

        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        String baseRoleId = roleTestUserObj0.Id;       
		Id userRoleID0 = baseRoleId.left(ID_LEN);

        createFeedItem(userRoleID0, TITLE5, BODY5, SINGLE_RECORD_MODE);
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT1, feedItemList.size());

        FeedItem feedItem = feedItemList.get(0);
        
        System.assertEquals(userRoleID0, feedItem.ParentId);
        String titleStr = feedItem.Title;
        System.assertEquals(TITLE5, titleStr);

        String bodyStr = feedItem.Body;
        System.assertEquals(BODY5, bodyStr);

        Test.stopTest();

    }

    
    /*
     * Verify bulk inserts.
     * 
     */
    private static testMethod void verifyBulkInserts() {
        if (!mRunAllTests && !mRunVerifyBulkInserts) {
            System.debug('Skipping verifyBulkInserts()');
            return;
        }
        
        Test.startTest();

        setCOHConfigSetting();
        createChatterGroups();
		setConfiguration(STANDARD_TESTING);
        
        List<FeedItem> feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(RECORD_COUNT0, feedItemList.size());
        
        createFeedItem(mChatterGroupNoPHI2ID, TITLE0, BODY0, BULK_RECORD_MODE);
        
        feedItemList = [select Id, ParentId, Body, Title from FeedItem];
        System.assertEquals(MAX_RECORDS, feedItemList.size());

        Test.stopTest();
    }    
    
    /*
     * Create FeedItem object(s) for testing.
     * 
     * @param parentID		ID of the Collaboration Group to where this FeedItem will be added.
     * @param title			Title of the FeedItem.
     * @param body			Body of the FeedItem.
     * @param mode			Test mode.
     * 
     */
    private static void createFeedItem(Id parentID, String title, String body, Boolean mode) {
        List<FeedItem> feedItemList = new List<FeedItem>();
        if (parentID != null) {
            Integer recordsToCreate;
            if (mode == SINGLE_RECORD_MODE) {
                recordsToCreate = 1;
            } else {
                recordsToCreate = MAX_RECORDS;
            }

            for (Integer i = 0; i < recordsToCreate; i++) {
                FeedItem feedItemObj = new FeedItem();
                feedItemObj.ParentId = parentID;
                feedItemObj.Title = title;
                feedItemObj.Body = body;
                feedItemObj.Type = QUESTION_POST_TYPE;
                feedItemList.add(feedItemObj);
            } 
            
            Database.insert(feedItemList);
        } else {
            throw new COHException('Error: parentID not supplied for the FeedItem');
        }
    }
    
    /*
     * Create two FeedItem objects for testing insertion of valid and invalid FeedItem objects.
     * 
     * @param parentID		ID of the Collaboration Group to where this FeedItem will be added.
     * @param validTitle	Valid title of a FeedItem.
     * @param validBody		Valid body of a FeedItem.
     * @param invalidTitle	Invalid title of a FeedItem.
     * @param invalidBody	Invalid body of a FeedItem.
     * 
     */
    private static void createMixedModeFeedItems(Id parentID, String validTitle, String validBody,
                                                 String invalidTitle, String invalidBody) {
        List<FeedItem> feedItemList = new List<FeedItem>();
        if (parentID != null) {
            FeedItem feedItemObj0 = new FeedItem();
            feedItemObj0.ParentId = parentID;
            feedItemObj0.Title = invalidTitle;
            feedItemObj0.Body = invalidBody;
            feedItemObj0.Type = QUESTION_POST_TYPE;

            FeedItem feedItemObj1 = new FeedItem();
            feedItemObj1.ParentId = parentID;
            feedItemObj1.Title = validTitle;
            feedItemObj1.Body = validBody;
            feedItemObj1.Type = QUESTION_POST_TYPE;

            feedItemList.add(feedItemObj0);
            feedItemList.add(feedItemObj1);
           	Database.SaveResult[] results = Database.insert(feedItemList, false);
/*            
            for (Database.SaveResult resultObj : results) {
                for(Database.Error objErr : resultObj.getErrors()) {
                    System.debug('Tracer: objErr.getMessage()--> ' + objErr.getMessage());
                }                
            }
*/
        } else {
            throw new COHException('Error: parentID not supplied for the FeedItem');
        }
    }
    
    /*
     * Count the number of a substring within a candidate string.
     * 
     * @param candidateStr	String to search.
     * @param searchStr		Substring to search for in the candidateStr parameter.
     * @return				Number occurrences of searchStr parameter found in the candidateStr parameter.
     * 
     */
    private static Integer countSubstringOccurrences(String candidateStr, String searchString) {
        Integer violationCount = 0;
        if (String.isNotEmpty(candidateStr)) {
            Integer maxIndex = candidateStr.length() - 1;
	        Integer searchStringLen = searchString.length();
	        Integer index = 0;
            while (index >= 0 && index < maxIndex) {
                index = candidateStr.indexOf(searchString, index);
                if (index >= 0) {
                    violationCount++;
                    index += searchStringLen;
                }
            }
        }
        return violationCount;
    }
 
    /*
     * Updates the value of COH App Configuration objects
     * 
     * @param configName		Name of the configuration object to update.
     * @parem newValue			New value for the configuration object.
     * 
     */
    private static void updateCOHConfigSetting(String configName, String newValue) {
        if (String.isNotEmpty(configName) && String.isNotEmpty(newValue)) {
			String soqlQuery = 'select id, Value__c from COH_Config_Setting__c ' +
                ' where Application_Name__c = :CHATTER_BP_APP and Active__c = true and Name = :configName';
            List<COH_Config_Setting__c> configObjectList = Database.query(soqlQuery);
            if (COHUtil.isValidList(configObjectList)) {
                COH_Config_Setting__c configObj = configObjectList.get(0);
		        configObj.Value__c = newValue;
                Database.update(configObj);
            }
        }
    }
    
    /*
     * Create configuration objects for testing.
     * 
     * @param testMode		Set to STANDARD_TESTING for normal testing.  Otherwise, it is for testing
     * 						when an exception is thrown if a rule name is mispelled.
     * 
     * mChatterGroupPHI0ID----------> no sanitizing 
     * 
     * mChatterGroupNoPHI1ID--------> CHATTER_GROUP_CONFIG_NAME1
     * 											|--> RULE_NAME0;RULE_NAME1
     * 									
     * 
     * mChatterGroupNoPHI2ID--------> CHATTER_GROUP_CONFIG_NAME1
     * 							|				|--> RULE_NAME0;RULE_NAME1
     * 							|		
     * 							|---> CHATTER_GROUP_CONFIG_NAME2
     * 											|--> RULE_NAME2
     * 
     * mChatterGroupNoPHI3ID--------> CHATTER_GROUP_CONFIG_NAME3
     * 											|--> RULE_NAME2;RULE_NAME3;RULE_NAME4
     * 
     * mChatterGroupNoPHI4ID--------> CHATTER_GROUP_CONFIG_NAME4
     * 											|--> RULE_NAME5
     * 
     */
    private static void setConfiguration(Boolean testMode) {

        COH_Blue_Pencil_Rule__c rule0 = new COH_Blue_Pencil_Rule__c();
        rule0.Description__c = null;
        rule0.Name = RULE_NAME0;
        rule0.Regular_Expression__c = RULE_SSN_REGEX;
        rule0.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule0.Match_Whole_Words__c = false;
        rule0.Literal_Search__c = false;
		rule0.Is_Active__c = true;
        
        COH_Blue_Pencil_Rule__c rule1 = new COH_Blue_Pencil_Rule__c();
        rule1.Description__c = null;
        rule1.Name = RULE_NAME1;
        rule1.Regular_Expression__c = RULE_MRN_REGEX;
        rule1.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule1.Match_Whole_Words__c = false;
        rule1.Literal_Search__c = false;
		rule1.Is_Active__c = true;
        
        COH_Blue_Pencil_Rule__c rule2 = new COH_Blue_Pencil_Rule__c();
        rule2.Description__c = null;
        rule2.Name = RULE_NAME2;
        rule2.Regular_Expression__c = RULE_PHONE_REGEX;
        rule2.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule2.Match_Whole_Words__c = false;
        rule2.Literal_Search__c = true;
		rule2.Is_Active__c = true;

        COH_Blue_Pencil_Rule__c rule3 = new COH_Blue_Pencil_Rule__c();
        rule3.Description__c = null;
        rule3.Name = RULE_NAME3;
        rule3.Regular_Expression__c = RULE_PROFANITY0_REGEX;
        rule3.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule3.Match_Whole_Words__c = true;
        rule3.Literal_Search__c = true;
		rule3.Is_Active__c = true;
        
        COH_Blue_Pencil_Rule__c rule4 = new COH_Blue_Pencil_Rule__c();
        rule4.Description__c = null;
        rule4.Name = RULE_NAME4;
        rule4.Regular_Expression__c = RULE_VISA_REGEX;
        rule4.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule4.Match_Whole_Words__c = true;
        rule4.Literal_Search__c = false;
		rule4.Is_Active__c = true;

        COH_Blue_Pencil_Rule__c rule5 = new COH_Blue_Pencil_Rule__c();
        rule5.Description__c = null;
        rule5.Name = RULE_NAME5;
        rule5.Regular_Expression__c = RULE_PROFANITY1_REGEX;
        rule5.Substitution_Phrase__c = CHATTER_BP_VIOLATION;
        rule5.Match_Whole_Words__c = false;
        rule5.Literal_Search__c = true;
		rule5.Is_Active__c = true;
        
        // Select the FoundationAccount user and set it in the config objects
        List<User> userList = [select id, name from user where firstname = 'Foundation' and lastname = 'Account'];
		System.assertEquals(RECORD_COUNT1, userList.size());
        User userObj = userList.get(0);
            
        // Select a user with a Role that isn't from Salesforce
		String getUserRoleSOQLQuery = 'select id, Name from UserRole where name like \'ITS%\' limit 2';
    	List<UserRole> userRoleList = Database.query(getUserRoleSOQLQuery);
        UserRole roleID0 = userRoleList.get(0); 
        UserRole roleID1 = userRoleList.get(1); 
        Id userRoleID0 = roleID0.Id;
        Id userRoleID1 = roleID1.Id;
        
        userList = [select Id, Name, UserRoleId from User where UserRoleId = :userRoleID0 limit 1];
        roleTestUserObj0 = userList.get(0);
        userList = [select Id, Name, UserRoleId from User where UserRoleId = :userRoleID1 limit 1];
        roleTestUserObj1 = userList.get(0);

        // No sanitizing required
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup0 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup0.Chatter_Group_IDs0__c = mChatterGroupPHI0ID;
        chatterConfigGroup0.Contact_Person__c = null;
        chatterConfigGroup0.Description__c = 'test0';
        chatterConfigGroup0.Name = CHATTER_GROUP_CONFIG_NAME0;
        chatterConfigGroup0.Rule_Names__c = null;
		chatterConfigGroup0.Is_Active__c = true;
		chatterConfigGroup0.Enable_Notification__c = false;
        chatterConfigGroup0.Enable_Audit_Trail__c = false;
 
        // Sanitizing required
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup1 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup1.Chatter_Group_IDs0__c = mChatterGroupNoPHI1ID + ID_DELIMITER + mChatterGroupNoPHI2ID;
        chatterConfigGroup1.Contact_Person__c = userObj.Id;
        chatterConfigGroup1.Description__c = 'test1';
        chatterConfigGroup1.Name = CHATTER_GROUP_CONFIG_NAME1;
        chatterConfigGroup1.Rule_Names__c = RULE_NAME0 + ID_DELIMITER + RULE_NAME1;
		chatterConfigGroup1.Is_Active__c = true;
		chatterConfigGroup1.Enable_Notification__c = true;
        chatterConfigGroup1.Enable_Audit_Trail__c = true;
        // Assign the Foundation Account's Profile ID to this config group
        User foundationAccount = [select Id, Alias, ProfileId from User where Alias = 'faccount' limit 1];
        
		// Sanitizing required
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup2 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup2.Chatter_Group_IDs1__c = mChatterGroupNoPHI2ID;
        chatterConfigGroup2.Contact_Person__c = userObj.Id;
        chatterConfigGroup2.Description__c = 'test2';
        chatterConfigGroup2.Name = CHATTER_GROUP_CONFIG_NAME2;
        if (testMode == EXCEPTION_TESTING) {
            // cause an exception
	        chatterConfigGroup2.Rule_Names__c = RULE_NAME2 + 'fsda';
        } else {
	        chatterConfigGroup2.Rule_Names__c = RULE_NAME2;
        }
		chatterConfigGroup2.Is_Active__c = true;
		chatterConfigGroup2.Enable_Notification__c = false;
        chatterConfigGroup2.Enable_Audit_Trail__c = false;
        
		// Sanitizing required        
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup3 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup3.Chatter_Group_IDs0__c = mChatterGroupNoPHI3ID;
        chatterConfigGroup3.Contact_Person__c = null;
        chatterConfigGroup3.Description__c = 'test3';
        chatterConfigGroup3.Name = CHATTER_GROUP_CONFIG_NAME3;
        chatterConfigGroup3.Rule_Names__c = RULE_NAME2 + ID_DELIMITER + RULE_NAME3 + ID_DELIMITER + RULE_NAME4;
		chatterConfigGroup3.Is_Active__c = true;
		chatterConfigGroup3.Enable_Notification__c = true;
        chatterConfigGroup3.Enable_Audit_Trail__c = false;
        // Assign the Foundation Account's Profile ID to this config group
        chatterConfigGroup3.Profile_IDs0__c = foundationAccount.ProfileId;

		// Sanitizing required        
        COH_Blue_Pencil_Config_Group__c chatterConfigGroup4 = new COH_Blue_Pencil_Config_Group__c();
        chatterConfigGroup4.Chatter_Group_IDs0__c = mChatterGroupNoPHI4ID;
        chatterConfigGroup4.Contact_Person__c = null;
        chatterConfigGroup4.Description__c = 'test4';
        chatterConfigGroup4.Name = CHATTER_GROUP_CONFIG_NAME4;
        chatterConfigGroup4.Rule_Names__c = RULE_NAME5;
		chatterConfigGroup4.Is_Active__c = true;
		chatterConfigGroup4.Enable_Notification__c = true;
        chatterConfigGroup4.Enable_Audit_Trail__c = true;
		chatterConfigGroup4.Suppress_Post_on_Breach__c = true;
        // For monitoring based on Roles
        String baseRoleId = roleTestUserObj0.UserRoleId;       
		chatterConfigGroup4.User_Role_IDs0__c = baseRoleId.left(ID_LEN);
        
        List<COH_Blue_Pencil_Rule__c> rulesList = new List<COH_Blue_Pencil_Rule__c>();
        rulesList.add(rule0);
        rulesList.add(rule1);
        rulesList.add(rule2);
        rulesList.add(rule3);
        rulesList.add(rule4);
        rulesList.add(rule5);
        Database.insert(rulesList);
        
        List<COH_Blue_Pencil_Config_Group__c> configGroupList = new List<COH_Blue_Pencil_Config_Group__c>();
        configGroupList.add(chatterConfigGroup0);
        configGroupList.add(chatterConfigGroup1);
        configGroupList.add(chatterConfigGroup2);
        configGroupList.add(chatterConfigGroup3);
        configGroupList.add(chatterConfigGroup4);
        Database.insert(configGroupList);
    }
    
    /*
     * Create new Chatter groups for testing.
     * 
     */
    private static void createChatterGroups() {
        
        CollaborationGroup group0 = new CollaborationGroup();
        group0.Name = CHATTER_GROUP0_PHI;
        group0.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group1 = new CollaborationGroup();
        group1.Name = CHATTER_GROUP1_NO_PHI;
        group1.CollaborationType = PUBLIC_COLLABORATION_TYPE;
        
        CollaborationGroup group2 = new CollaborationGroup();
        group2.Name = CHATTER_GROUP2_NO_PHI;
        group2.CollaborationType = PUBLIC_COLLABORATION_TYPE;

        CollaborationGroup group3 = new CollaborationGroup();
        group3.Name = CHATTER_GROUP3_NO_PHI;
        group3.CollaborationType = PUBLIC_COLLABORATION_TYPE;

        CollaborationGroup group4 = new CollaborationGroup();
        group4.Name = CHATTER_GROUP4_NO_PHI;
        group4.CollaborationType = PUBLIC_COLLABORATION_TYPE;

        List<CollaborationGroup> collabGroupList = new List<CollaborationGroup>();
        collabGroupList.add(group0);
        collabGroupList.add(group1);
        collabGroupList.add(group2);
        collabGroupList.add(group3);
        collabGroupList.add(group4);
        Database.insert(collabGroupList);

		collabGroupList = [SELECT Id, Name From CollaborationGroup];
        System.assertEquals(RECORD_COUNT5, collabGroupList.size());

		// Retrieve and store the Collaboration Group IDs for later use
        CollaborationGroup collabGroup = collabGroupList.get(0);
        mChatterGroupPHI0ID = collabGroup.Id;
        collabGroup = collabGroupList.get(1);
        mChatterGroupNoPHI1ID = collabGroup.Id;
        collabGroup = collabGroupList.get(2);
        mChatterGroupNoPHI2ID = collabGroup.Id;
        collabGroup = collabGroupList.get(3);
        mChatterGroupNoPHI3ID = collabGroup.Id;
        collabGroup = collabGroupList.get(4);
        mChatterGroupNoPHI4ID = collabGroup.Id;

    }
    
    /*
     *  Creates the configuration objects for the test environment.
     */
    private static void setCOHConfigSetting() {
       
        COH_Config_Setting__c configObj0 = new COH_Config_Setting__c();
        configObj0.Application_Name__c = CHATTER_BP_APP;
		configObj0.Name = CHATTER_BP_VIOLATION_EMAIL;
        configObj0.Value__c = CHATTER_BP_VIOLATION_EMAIL_VAL;
        configObj0.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj0.Active__c = true;
            
        COH_Config_Setting__c configObj1 = new COH_Config_Setting__c();
        configObj1.Application_Name__c = CHATTER_BP_APP;
		configObj1.Name = CHATTER_BP_VIOLATION_ADMIN_NAME;
        configObj1.Value__c = CHATTER_BP_VIOLATION_ADMIN_NAME_VAL;
        configObj1.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj1.Active__c = true;

        COH_Config_Setting__c configObj2 = new COH_Config_Setting__c();
        configObj2.Application_Name__c = CHATTER_BP_APP;
		configObj2.Name = CHATTER_BP_EMAIL_SUBJECT;
        configObj2.Value__c = CHATTER_BP_EMAIL_SUBJECT_VAL;
        configObj2.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj2.Active__c = true;
 
        COH_Config_Setting__c configObj3 = new COH_Config_Setting__c();
        configObj3.Application_Name__c = CHATTER_BP_APP;
		configObj3.Name = CHATTER_BP_ADD_ERROR_MESSAGE;
        configObj3.Value__c = CHATTER_BP_ADD_ERROR_MESSAGE_VAL;
        configObj3.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj3.Active__c = true;

        COH_Config_Setting__c configObj4 = new COH_Config_Setting__c();
        configObj4.Application_Name__c = CHATTER_BP_APP;
		configObj4.Name = CHATTER_BP_LOG_INTRO;
        configObj4.Value__c = CHATTER_BP_LOG_INTRO_VAL;
        configObj4.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj4.Active__c = true;
        
        COH_Config_Setting__c configObj5 = new COH_Config_Setting__c();
        configObj5.Application_Name__c = CHATTER_BP_APP;
		configObj5.Name = CHATTER_BP_ENABLE_USER_PROFILE_MONITORING;
        configObj5.Value__c = CHATTER_BP_DISABLE_MONITORING;		// default value
        configObj5.Value_Type__c = COHCustomSettingUtil.BOOLEAN_TYPE;
        configObj5.Active__c = true;

        COH_Config_Setting__c configObj6 = new COH_Config_Setting__c();
        configObj6.Application_Name__c = CHATTER_BP_APP;
		configObj6.Name = CHATTER_BP_ENABLE_USER_ROLE_MONITORING;
        configObj6.Value__c = CHATTER_BP_DISABLE_MONITORING;		// default value
        configObj6.Value_Type__c = COHCustomSettingUtil.BOOLEAN_TYPE;
        configObj6.Active__c = true;
        
        List<COH_Config_Setting__c> configList = new List<COH_Config_Setting__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);
        configList.add(configObj5);
        configList.add(configObj6);
        
        Database.insert(configList);
    }
    
}