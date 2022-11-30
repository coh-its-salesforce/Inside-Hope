/*
 * This test class verifies the functionality of the UpdateSupervisor trigger.  
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
public class UpdateSupervisorTest {
    private static final Boolean mRunVerifySupervisorUpdate = true;
    private static final Boolean mRunAllTests = false;
	
    private static final String NEWUSER = 'Imperial Droid';
    private static final String NEWUSER_EMAIL = 'droid@testorg.com';
    private static final String NEWUSER_EMP_ID = '101010';
    private static final String USER = 'Stromtrooper';
    private static final String USER_EMAIL = 'TESTUSERDISREGARD@coh.org';
    private static final String USER_EMP_ID = '999999';
    private static final String MANAGER = 'Grand Moff Tarkin';
    private static final String MANAGER_EMAIL = 'grandmofftarkin@testorg.com';
    private static final String MANAGER_EMP_ID = '888888';
    private static final String DIRECTOR = 'Darth Vader';
    private static final String DIRECTOR_EMAIL = 'darthvader@testorg.com';
    private static final String DIRECTOR_EMP_ID = '777777';
    private static final String VP = 'Emperor Palpatine';
    private static final String VP_EMAIL = 'emperorpalpatine@testorg.com';
    private static final String VP_EMP_ID = '666666';
    private static final String TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String LOCALE_SID_KEY = 'en_US';
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';
    private static final String PROFILE = 'Standard User';
    
    private static final String NEW_TITLE = 'Darth Vader';
    
    private static final String VPApplicationName = 'COH User Trigger VPs';
    private static String VPValue; // Set by getTestUsers()
    private static final String stringType = 'String';
    private static final String VPConfigurationGroup = 'COHUserTriggerVPs';
    
    private static List<COH_App_Configuration__c> VPConfigurationList;
    private static List<User> testUsers;
    private static Integer VPConfigurationObjectSize = 1;  
    private static Integer testUsersSize = 5;
 
    // The Foundation Account must have a value for the Supervisor_ID__c field.
    private static final String SOQL_QUERY = 'select Id, name, isActive, title, federationidentifier, Supervisor_ID__c, Timesheet_Submitted__c, Timesheet_Verification_Timestamp__c  from User where name = \'Foundation Account\'';

    /*
     * Creates and returns the COH_App_Configuration objects used for the 
     * updateSupervisor/FindDirectorRecursive/FindDirectorVPRecursive functions
     */ 
    private static List<COH_App_Configuration__c> getVPConfigurationList() {
        if (VPConfigurationList != null) {
            return VPConfigurationList;
        } else
        {
            if (VPValue == null)
                getTestUsers();
            VPConfigurationList = new List<COH_App_Configuration__c>();
            COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
            configObj1.Name = VP;
            configObj1.Application_Name__c = VPApplicationName;
            configObj1.Value__c = VPValue;
            configObj1.Value_Type__c = stringType;
            configObj1.Active__c = true;
            configObj1.Configuration_Group__c = VPConfigurationGroup;
            
            VPConfigurationList.add(configObj1);
            
            return VPConfigurationList;
        }
    }
    
	/*
     * Insert COH_App_Configuration objects used for the 
     * updateSupervisor/FindDirectorRecursive/FindDirectorVPRecursive functions.  
     * Test.startTest() and Test.stopTest() must be invoked by the caller.
     */
    private static void setVPConfigurationList() {
		List<COH_App_Configuration__c> configList = getVPConfigurationList();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(VPConfigurationObjectSize, listSize);
        
        for (COH_App_Configuration__c configObj : configList)         {
            insert configObj;
        }
    }
    
    /*
     * Creates and inserts Users for testing the FindDirectorRecursive/FindDirectorVPRecursive functions
     * I insert after creating a User so that I can use the Record Id for the next user, which is only 
     * created after inserting.
     * Test.startTest() and Test.stopTest() must be invoked by the caller.
     */ 
    
    private static List<User> getTestUsers() {
        if (testUsers != null) {
            return testUsers;
        } else
        {
            testUsers = new List<User>();
         	Profile testProfile = [SELECT id FROM Profile WHERE Name=: PROFILE];
 			User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()]; // Have to seperate insertation of Setup Object(User) and non-setup item (COH_App_Configuration)
            System.runAs(thisUser)
            {
                User testUser1 = new User(Username = VP_EMAIL, 
                                         Email = USER_EMAIL, 
                                         LastName = VP, 
                                         Alias = VP.substring(0, 7), // Alias can only be 8 characters 
                                         CommunityNickname = VP, 
                                         TimeZoneSidKey = TIME_ZONE_SID_KEY,
                                         LanguageLocaleKey = LANGUAGE_LOCALE_KEY,
                                         LocaleSidKey = LOCALE_SID_KEY,
                                         EmailEncodingKey = EMAIL_ENCODING_KEY,
                                         ProfileId = testProfile.id,
                                         IsActive = true,
                                         EmployeeNumber = VP_EMP_ID
                                        );
                insert testUser1;
                VPValue = testUser1.Id;
                
                User testUser2 = new User(Username = DIRECTOR_EMAIL, 
                                         Email = USER_EMAIL, 
                                         LastName = DIRECTOR, 
                                         Alias = DIRECTOR.substring(0, 7), // Alias can only be 8 characters 
                                         CommunityNickname = DIRECTOR, 
                                         TimeZoneSidKey = TIME_ZONE_SID_KEY,
                                         LanguageLocaleKey = LANGUAGE_LOCALE_KEY,
                                         LocaleSidKey = LOCALE_SID_KEY,
                                         EmailEncodingKey = EMAIL_ENCODING_KEY,
                                         Mgr__c = testUser1.id,
                                         ProfileId = testProfile.id,
                                         IsActive = true,
                                         EmployeeNumber = DIRECTOR_EMP_ID
                                        );
                insert testUser2;
                
                User testUser3 = new User(Username = MANAGER_EMAIL, 
                                         Email = USER_EMAIL, 
                                         LastName = MANAGER, 
                                         Alias = MANAGER.substring(0, 7), // Alias can only be 8 characters  
                                         CommunityNickname = MANAGER, 
                                         TimeZoneSidKey = TIME_ZONE_SID_KEY,
                                         LanguageLocaleKey = LANGUAGE_LOCALE_KEY,
                                         LocaleSidKey = LOCALE_SID_KEY,
                                         EmailEncodingKey = EMAIL_ENCODING_KEY,
                                         Mgr__c = testUser2.id,
                                         ProfileId = testProfile.id,
                                         IsActive = true,
                                         EmployeeNumber = MANAGER_EMP_ID
                                        );
                insert testUser3;
                
                User testUser4 = new User(Username = USER_EMAIL, 
                                         Email = USER_EMAIL, 
                                         LastName = USER, 
                                         Alias = USER.substring(0, 7), // Alias can only be 8 characters 
                                         CommunityNickname = USER, 
                                         TimeZoneSidKey = TIME_ZONE_SID_KEY,
                                         LanguageLocaleKey = LANGUAGE_LOCALE_KEY,
                                         LocaleSidKey = LOCALE_SID_KEY,
                                         EmailEncodingKey = EMAIL_ENCODING_KEY,
                                         Mgr__c = testUser3.id,
                                         ProfileId = testProfile.id,
                                         IsActive = true,
                                         EmployeeNumber = USER_EMP_ID
                                        );
                insert testUser4;   
                System.debug('Stormtrooper Record ID: ' + testUser4.id);
                
                User testUser5 = new User(Username = NEWUSER_EMAIL, 
                                         Email = USER_EMAIL, 
                                         LastName = NEWUSER, 
                                         Alias = NEWUSER.substring(0, 7), // Alias can only be 8 characters 
                                         CommunityNickname = NEWUSER, 
                                         TimeZoneSidKey = TIME_ZONE_SID_KEY,
                                         LanguageLocaleKey = LANGUAGE_LOCALE_KEY,
                                         LocaleSidKey = LOCALE_SID_KEY,
                                         EmailEncodingKey = EMAIL_ENCODING_KEY,
                                         ProfileId = testProfile.id,
                                         IsActive = true,
                                         EmployeeNumber = NEWUSER_EMP_ID
                						);
                insert testUser5;
                
                testUsers.add(testUser1);
                testUsers.add(testUser2);
                testUsers.add(testUser3);
                testUsers.add(testUser4);  
                testUsers.add(testUser5);
            } 
        	return testUsers;        
        }
    }
    
    /*
     * Used to verify that the testUsers list was created correctly.
     * 
     */  
    private static void checkTestUsers() {
		List<User> configList = getTestUsers();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(testUsersSize, listSize);   
    }
    
    /*
     * Test FindDirectorRecursive()
     * Tests to see if the method returns when valid input is entered
     */ 
    private static testMethod void FindDirectorRecursiveTest0() {
		User testDirector;   
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();    
        
		User expectedDirector = testUsers[1];
        User testEmployee = testUsers[3];
        
        testDirector = COHUserHelper.FindDirectorRecursive(testEmployee);
        if (testDirector != null) 
        {
			Boolean val = testDirector.Id == expectedDirector.id ? true : false;       
			System.assertEquals(true, val);
        }
        else
            System.assertEquals(true, false, 'FindDirectorRecursiveTest0: The method returned null, when it should not have');

        test.stopTest();
    }
    
    /*
     * Test FindDirectorRecursive()
     * Tests to see if the method returns null correctly when the COH_App_Configuration is not correctly set
     */ 
    private static testMethod void FindDirectorRecursiveTest1() {
		User testDirector;   
        
        test.startTest();
        checkTestUsers();
        
		User expectedDirector = null;
        User testEmployee = testUsers[3];
        
        testDirector = COHUserHelper.FindDirectorRecursive(testEmployee);
        if (testDirector == expectedDirector) 
			System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorRecursiveTest1: The method returned a value, when it should returned null');

        test.stopTest();
    }
    
    /* 
     * Test FindDirectorRecursive()
     * Tests to see if the method returns null correctly when the parameters supplied are null
     */ 
    private static testMethod void FindDirectorRecursiveTest2() {
        User testDirector;
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        User expectedDirector = null;
        User testEmployee = null;
        
        testDirector = COHUserHelper.FindDirectorRecursive(testEmployee);
        if (testDirector == expectedDirector)
           	System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorRecursiveTest1: The method returned a value, it should have returned null');
        
        test.stopTest();
    }
    
    /* 
     * Test FindDirectorRecursive()
     * Tests to see if the method returns null when the the Employee does not have a Mgr
     */ 
    private static testMethod void FindDirectorRecursiveTest3() {
        User testDirector;
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        User expectedDirector = null;
        User testEmployee = testUsers[0];
        
        testDirector = COHUserHelper.FindDirectorRecursive(testEmployee);
        if (testDirector == expectedDirector)
           	System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorRecursiveTest3: The method returned a value, it should have returned null');
        
        test.stopTest();
    }  
    
    /*
     * Test FindDirectorVPRecursive()
     * Tests to see if the method returns when valid input is entered
     */
    private static testMethod void FindDirectorVPRecursiveTest0() {
        User testVP;
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        User expectedVP = testUsers[0];
        User testEmployee = testUsers[3];
        
        testVP = COHUserHelper.FindDirectorVPRecursive(testEmployee);
		if (testVP != null) 
        {
			Boolean val = testVP.Id == expectedVP.id ? true : false;       
			System.assertEquals(true, val);
        }
        else
            System.assertEquals(true, false, 'FindDirectorVPRecursiveTest: The method returned null, when it should not have');

        test.stopTest();
    }
    
    /*
     * Test FindDirectorVPRecursive()
     * Tests to see if the method returns null correctly when the COH_App_Configuration is not correctly set
     */ 
    private static testMethod void FindDirectorVPRecursiveTest1() {
		User testDirector;   
        
        test.startTest();
        checkTestUsers();
        
		User expectedDirector = null;
        User testEmployee = testUsers[3];
        
        testDirector = COHUserHelper.FindDirectorVPRecursive(testEmployee);
        if (testDirector == expectedDirector) 
			System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorVPRecursiveTest1: The method returned a value, when it should returned null');

        test.stopTest();
    }
    
    /* 
     * Test FindDirectorVPRecursive()
     * Tests to see if the method returns null correctly when the parameters supplied are null
     */ 
    private static testMethod void FindDirectorVPRecursiveTest2() {
        User testDirector;
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        User expectedDirector = null;
        User testEmployee = null;
        
        testDirector = COHUserHelper.FindDirectorVPRecursive(testEmployee);
        if (testDirector == expectedDirector)
           	System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorVPRecursiveTest1: The method returned a value, it should have returned null');
        
        test.stopTest();
    }
    
    /* 
     * Test FindDirectorVPRecursive()
     * Tests to see if the method returns null when the the Employee does not have a Mgr
     */ 
    private static testMethod void FindDirectorVPRecursiveTest3() {
        User testDirector;
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        User expectedDirector = null;
        testUsers[3].Mgr__c = null;
        update testUsers[3];
        User testEmployee = testUsers[3];
        
        testDirector = COHUserHelper.FindDirectorVPRecursive(testEmployee);
        if (testDirector == expectedDirector)
           	System.assertEquals(true, true);
        else
            System.assertEquals(true, false, 'FindDirectorVPRecursiveTest3: The method returned a value, it should have returned null');
        
        test.stopTest();
    }      
    
    /* 
     * Tests updateSupervisor()
     * updates 1 record and ensures that updateSupervisor updated it correctly. 
     * Ensures records that should not have been updated were not updated.
     */
    private static testMethod void updateSupervisorTest0() {
        if (!mRunAllTests && !mRunVerifySupervisorUpdate) {
            System.debug('Skipping verifySupervisorUpdate()');
            return;
        }
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
		
        List<User> userList = new List<User>(testUsers);
        
        System.assertEquals(userList[4].Mgr__c, null);    
        userList[4].Supervisor_Id__c = userList[3].EmployeeNumber;    
        
        if (COHUtil.isValidList(userList))
        {			
            COHUserHelper.updateSupervisor(userList);
            System.assertEquals(userList[0].Mgr__c, null);
            System.assertEquals(userList[1].Mgr__c, userList[0].id);
            System.assertEquals(userList[2].Mgr__c, userList[1].id);
            System.assertEquals(userList[3].Mgr__c, userList[2].id);
            System.assertEquals(userList[4].Mgr__c, userList[3].id);
                // testing--raymond tam
                // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//            System.assertEquals(userList[4].VP_SVP_CTO__c, userList[0].id);
            System.assertEquals(userList[4].Director__c, userList[1].id);
        }		
        
        test.stopTest();
    }
    
    /* 
     * Tests updateSupervisor()
     * tests the case of the CEO being his own supervisor
     * attempts to update a user with their own Emp Num as Supervisor_Id__c, no change should be made.
     */
    private static testMethod void updateSupervisorTest1() {
        if (!mRunAllTests && !mRunVerifySupervisorUpdate) {
            System.debug('Skipping verifySupervisorUpdate()');
            return;
        }
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
		
        List<User> userList = new List<User>(testUsers);
        
        System.assertEquals(userList[0].Mgr__c, null);    
        userList[0].Supervisor_Id__c = userList[0].EmployeeNumber;    
        
        if (COHUtil.isValidList(userList))
        {			
            COHUserHelper.updateSupervisor(userList);
			System.assertEquals(userList[0].Mgr__c, null);
            System.assertEquals(userList[0].Supervisor_Id__c, userList[0].EmployeeNumber);
        }		
        
        test.stopTest();
    }
    
    /* 
     * Tests updateSupervisor()
     * Attempts to call updateSupervisor with a empty list and a null list as a parameter
     */
    private static testMethod void updateSupervisorTest2() {
        if (!mRunAllTests && !mRunVerifySupervisorUpdate) {
            System.debug('Skipping verifySupervisorUpdate()');
            return;
        }
        
        test.startTest();
        checkTestUsers();
        setVPConfigurationList();
        
        List<User> userList;
        if (userList == null)
            System.assertEquals(true, true);
        else
            System.assertEquals(true, false);
        COHUserHelper.updateSupervisor(userList);
        
        userList = new List<User>();
        System.assertEquals(userList.size(), 0);
        COHUserHelper.updateSupervisor(userList);
        
        test.stopTest();
    }
    
        /* 
     * Verifies that User object has been updated.  
     * This is mainly for code coverage reasons.
     * 
     */
    private static testMethod void verifySupervisorUpdate() {
        if (!mRunAllTests && !mRunVerifySupervisorUpdate) {
            System.debug('Skipping verifySupervisorUpdate()');
            return;
        }
        
        test.startTest();
		List<User> userList = Database.query(SOQL_QUERY);
        if (COHUtil.isValidList(userList)) {
	        User userObj = userList.get(0);
            userObj.Title = NEW_TITLE;
            Database.update(userObj);
            
			userList = Database.query(SOQL_QUERY);
	        userObj = userList.get(0);
            System.assertEquals(NEW_TITLE, userObj.Title);
            System.assertEquals(false, userObj.Timesheet_Submitted__c);
        } else {
            System.assert(false, 'Expected at least one user record but retrieved none');
        }
        
        
        test.stopTest();
    }
}