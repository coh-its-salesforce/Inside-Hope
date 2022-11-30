/* 
 * This test class verifies the functionality of COHCheckTimesheetHelper.  
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
public class COHCheckTimesheetTest {
    private static final Boolean mVerifyControllerJobs = false;
    private static final Boolean mVerifyScheduledJobs = false;
    private static final Boolean mVerifyProcessSubqueues = true;
    private static final Boolean mRunAllTests = true;

    // Constants for subqueues and scheduling
    private static final String SUBQUEUES_VAL = '3';
    private static final String INTERVALS_VAL = '1';
    private static final String SECONDS_VAL = '0';
    private static final String MINUTES_VAL = '61';		// unusual value for code coverage reason
    private static final String HOURS_VAL = '23';
    private static final String DAY_OF_MONTH_VAL = '?';
    private static final String MONTH_VAL = '*';
    private static final String DAY_OF_WEEK_VAL = 'Fri';
	private static final String SUBQUEUE_JOB_PREFIX_VAL = 'COHTimesheetJob';
    private static final String MAX_SCHED_TRIES_VAL = '20';
    private static final String SCHEDULING_CONTROLLER_PREFIX_VAL = 'COHTimesheetContrXTest';
    private static final String SCHEDULING_CONTROLLERS_VAL = '4';
        
    // Constants for creating a new user
    private static final String USER_OBJ = 'User';
    private static final String USER_FIRST_NAME = 'Thomas';
    private static final String USER_LAST_NAME0 = 'Zebulon';
    private static final String USER_LAST_NAME1 = 'Andrews';
    private static final String USER_LAST_NAME2 = 'Brannigan';
    private static final String USER_LAST_NAME3 = 'Fung';
    private static final String USER_LAST_NAME4 = 'Dang';
    
    private static final String USER_TITLE = 'P.I.';
    private static final String USER_NAME0 = 'thomaszebulon@coh.org';
    private static final String USER_NAME1 = 'thomasandrews@coh.org';
    private static final String USER_NAME2 = 'thomasbrannigan@coh.org';
    private static final String USER_NAME3 = 'thomasfung@coh.org';
    private static final String USER_NAME4 = 'thomasdang@coh.org';
    private static final String USER_ALIAS0 = 'thomas0';
    private static final String USER_ALIAS1 = 'thomas1';
    private static final String USER_ALIAS2 = 'thomas2';
    private static final String USER_ALIAS3 = 'thomas3';
    private static final String USER_ALIAS4 = 'thomas4';
    private static final String USER_EMAIL = 'thomassullivanmagnumiv@coh.org';
    private static final String USER_TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String USER_LOCALE_SID_KEY = 'en_US';
    private static final String USER_EMAIL_ENCODING_KEY = 'ISO-8859-1';
    private static final String USER_LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String USER_EMPLOYEE_NUMBER = '99999999';
    private static final String USER_LOCATION = 'Duarte';
    private static final String USER_DEPARTMENT_NAME = 'Magnum PI ITS';
	private static final String USER_BASE_NAME = 'tmagnum';
	private static final String USER_BASE_ORGANZATION = '@coh.org';
    private static final Boolean USER_STATUS = true;
        
    // Constants for creating Timesheet 
    private static final String TS_SUBMITTED_STATUS = 'Submitted';
    
	// Miscellaneous test constants
    private static final String GET_USER_SOQL_QUERY = 'select IsActive, FirstName, LastName, Title, Username, Alias, Email, TimeZoneSidKey, ' +
            'LocaleSidKey, EmailEncodingKey, LanguageLocaleKey, EmployeeNumber, Location__c, Department, Supervisor_ID__c, '+
            'ProfileId, VP_SVP_CTO__c, Mgr__c, ManagerId, Timesheet_Submitted__c, Timesheet_Verification_Timestamp__c ' +
            'from User where isActive = true and Department = :USER_DEPARTMENT_NAME';

    private static final String GET_TIMESHEET_SOQL_QUERY_PREFIX = 'select Id, User__c, Week_Start_Date__c, Status__c ' +
        'from Timesheet_Week__c';

	private static final String SCHEDULING_APEX_JOBTYPE = '7';
	private static final String JOB_STATUS_WAITING = 'WAITING';
    
    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer RECORD_COUNT3 = 3;
    private static final Integer RECORD_COUNT4 = 4;
    private static final Integer RECORD_COUNT5 = 5;
    private static final Integer RECORD_COUNT15 = 15;
    private static final Integer RECORD_COUNT78 = 78;		

    
    // values to be retrieved from the database
    private static Id mUserManager;
    private static Id mUserVP;
    private static String mDefaultProfileID;
    private static String mDefaultSupervisorID;

    /*
     * Verify the controller jobs
     * 
     */
    private static testMethod void verifyControllerJobs() {
        if (!mRunAllTests && !mVerifyControllerJobs) {
            System.debug('Skipping verifyControllerJobs');
            return;
        }
        
        Test.startTest();

        createUser();
        
        List<User> userList = Database.query(GET_USER_SOQL_QUERY);
        User userObj0;
        User userObj1;
        User userObj2;
        User userObj3;
        User userObj4;
        Id userObjID0;
        Id userObjID1;
        Id userObjID2;
        Id userObjID3;
        Id userObjID4;
		System.assertEquals(RECORD_COUNT5, userList.size());
        for (User userObj: userList) {
            Id userID = userObj.Id;
            String userName = userObj.Username;
            System.assertNotEquals('', userName);
            if (userName.equalsIgnoreCase(USER_NAME0)) {
				userObj0 = userObj;
                userObjID0 = userObj0.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME1)) {
				userObj1 = userObj;
                userObjID1 = userObj1.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME2)) {
				userObj2 = userObj;
                userObjID2 = userObj2.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME3)) {
				userObj3 = userObj;
                userObjID3 = userObj3.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME4)) {
				userObj4 = userObj;
                userObjID4 = userObj4.Id;
            }
            
        }

        User sAccountUsr = [select id, name from user where alias = 'saccount' limit 1];
        System.runAs(sAccountUsr) {
            
            setCOHAppConfiguration();        
	        COHCheckTimesheetHelper ccthObj = new COHCheckTimesheetHelper();

            createTimesheet(userObj0.Id);
            createTimesheet(userObj1.Id);
            createTimesheet(userObj2.Id);
            createTimesheet(userObj3.Id);
            createTimesheet(userObj4.Id);
    
            String subqueueNameCriterion = SUBQUEUE_JOB_PREFIX_VAL + '%';
            String soqlQuery = 'select Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, ' + 
                					'state, nextfiretime, starttime, CronExpression from CronTrigger ' + 
                					'where CronJobDetail.JobType = :SCHEDULING_APEX_JOBTYPE and state = :JOB_STATUS_WAITING ' +
                					'and CronJobDetail.Name like :subqueueNameCriterion';

            String controllerCriterion = SCHEDULING_CONTROLLER_PREFIX_VAL + '%';
            soqlQuery = 'select Id from CronTrigger where CronJobDetail.JobType = :SCHEDULING_APEX_JOBTYPE ' +
                'and CronJobDetail.Name like :controllerCriterion';
            
            List<CronTrigger> cronControllerJobsList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT0, cronControllerJobsList.size());
           
            ccthObj.createControllers();

            cronControllerJobsList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT4, cronControllerJobsList.size());
            
			// This should delete previous jobs
            
            ccthObj.createControllers();

            cronControllerJobsList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT4, cronControllerJobsList.size());
            
            ccthObj.deleteScheduledControllerJobs();
            cronControllerJobsList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT0, cronControllerJobsList.size());
        }        
        
		Test.stopTest();
    }

    /*
     * Verify the scheduled jobs for a set of users with last names starting with the same letter.
     * 
     */
    private static testMethod void verifyScheduledJobs() {
        if (!mRunAllTests && !mVerifyScheduledJobs) {
            System.debug('Skipping verifyScheduledJobs');
            return;
        }
        
        Test.startTest();

        createUser();
        
        List<User> userList = Database.query(GET_USER_SOQL_QUERY);
        User userObj0;
        User userObj1;
        User userObj2;
        User userObj3;
        User userObj4;
        Id userObjID0;
        Id userObjID1;
        Id userObjID2;
        Id userObjID3;
        Id userObjID4;
		System.assertEquals(RECORD_COUNT5, userList.size());
        for (User userObj: userList) {
            Id userID = userObj.Id;
            String userName = userObj.Username;
            System.assertNotEquals('', userName);
            if (userName.equalsIgnoreCase(USER_NAME0)) {
				userObj0 = userObj;
                userObjID0 = userObj0.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME1)) {
				userObj1 = userObj;
                userObjID1 = userObj1.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME2)) {
				userObj2 = userObj;
                userObjID2 = userObj2.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME3)) {
				userObj3 = userObj;
                userObjID3 = userObj3.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME4)) {
				userObj4 = userObj;
                userObjID4 = userObj4.Id;
            }
            
        }

        User sAccountUsr = [select id, name from user where alias = 'saccount' limit 1];
        System.runAs(sAccountUsr) {
            
            setCOHAppConfiguration();        

            COHCheckTimesheetHelper ccthObj = new COHCheckTimesheetHelper();

            createTimesheet(userObj0.Id);
            createTimesheet(userObj1.Id);
            createTimesheet(userObj2.Id);
            createTimesheet(userObj3.Id);
            createTimesheet(userObj4.Id);
    
            List<String> queueIDs = new List<String>{'A', 'B', 'C', 'D', 'E'};
            ccthObj.processUsersForTimesheets(queueIDs);

            // Cycle through all the letters from 'A' to 'G' inclusive.
            // The Thomas Fung and Thomas Zebulon records should not have been processed.
            String subqueueNameCriterion = SUBQUEUE_JOB_PREFIX_VAL + '%';
            String soqlQuery = 'select Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, ' + 
                					'state, nextfiretime, starttime, CronExpression from CronTrigger ' + 
                					'where CronJobDetail.JobType = :SCHEDULING_APEX_JOBTYPE and state = :JOB_STATUS_WAITING ' +
                					'and CronJobDetail.Name like :subqueueNameCriterion';

            List<CronTrigger> cronTriggerList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT15, cronTriggerList.size());

            userList = Database.query(GET_USER_SOQL_QUERY);
            System.assertEquals(RECORD_COUNT5, userList.size());

            // Delete the subqueue processing jobs
            ccthObj.deleteScheduledTimesheetJobs();
            cronTriggerList = Database.query(soqlQuery);
            System.assertEquals(RECORD_COUNT0, cronTriggerList.size());
        }        
        
		Test.stopTest();
    }

    

    /*
     * Verify the processing of subqueues.
     * 
     */
    private static testMethod void verifyProcessSubqueues() {
        if (!mRunAllTests && !mVerifyProcessSubqueues) {
            System.debug('Skipping verifyProcessSubqueues');
            return;
        }
        
        Test.startTest();

        createUser();
        
        List<User> userList = Database.query(GET_USER_SOQL_QUERY);
        User userObj0;
        User userObj1;
        User userObj2;
        User userObj3;
        User userObj4;
        Id userObjID0;
        Id userObjID1;
        Id userObjID2;
        Id userObjID3;
        Id userObjID4;
		System.assertEquals(RECORD_COUNT5, userList.size());
        for (User userObj: userList) {
            Id userID = userObj.Id;
            String userName = userObj.Username;
            System.assertNotEquals('', userName);
            if (userName.equalsIgnoreCase(USER_NAME0)) {
				userObj0 = userObj;
                userObjID0 = userObj0.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME1)) {
				userObj1 = userObj;
                userObjID1 = userObj1.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME2)) {
				userObj2 = userObj;
                userObjID2 = userObj2.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME3)) {
				userObj3 = userObj;
                userObjID3 = userObj3.Id;
            } else if (userName.equalsIgnoreCase(USER_NAME4)) {
				userObj4 = userObj;
                userObjID4 = userObj4.Id;
            }
            
        }
        
        userList = Database.query(GET_USER_SOQL_QUERY);
        System.assertEquals(RECORD_COUNT5, userList.size());
        

        User sAccountUsr = [select id, name from user where alias = 'saccount' limit 1];
        System.runAs(sAccountUsr) {
            
            setCOHAppConfiguration();        

            COHCheckTimesheetHelper ccthObj = new COHCheckTimesheetHelper();

            // For code coverage reasons
            
            Boolean exceptionCaught = false;
            try {
                ccthObj.processUserSubqueue(null, ' ');
            } catch (COHException e) {
                exceptionCaught = true;
            }
            System.assertEquals(true, exceptionCaught);
            exceptionCaught = false;
            try {
                COHTimesheetSubqueue foo = new COHTimesheetSubqueue(null, null);
            } catch (COHException e) {
                exceptionCaught = true;
            }
            System.assertEquals(true, exceptionCaught);
            
            createTimesheet(userObj0.Id);
            createTimesheet(userObj1.Id);
            createTimesheet(userObj2.Id);
            createTimesheet(userObj3.Id);
            createTimesheet(userObj4.Id);
    
          	// Nothing should be processed
            ccthObj.processUserSubqueue('A', 'AM[');

            userList = Database.query(GET_USER_SOQL_QUERY);
            System.assertEquals(RECORD_COUNT5, userList.size());
            
            Date lastWeekDate = Date.today() - 7;
            Date weekStart = lastWeekDate.toStartOfWeek();
            for (User userObj : userList) {
                Date verificationTimestamp = userObj.Timesheet_Verification_Timestamp__c;
                System.assertNotEquals(weekStart, verificationTimestamp);
            }

          	// USER_LAST_NAME1 record should be processed
            ccthObj.processUserSubqueue('AM', 'AZ[');

            userList = Database.query(GET_USER_SOQL_QUERY);
            System.assertEquals(RECORD_COUNT5, userList.size());


            for (User userObj : userList) {
                Id userObjID = userObj.Id;
                Date verificationTimestamp = userObj.Timesheet_Verification_Timestamp__c;
                if (userObjID == userObjID1) {
                    System.assertEquals(weekStart, verificationTimestamp);
                } else {
                    System.assertNotEquals(weekStart, verificationTimestamp);
                }
            }

        }        
        
		Test.stopTest();
    }

    
    /*
     * Create user object(s) for testing. 
     * 
     */
    private static void createUser() {

        // The Foundation Account should be in prodcopy and prod
        String managerSOQLQuery = 'select Id, ProfileID from User where name = \'Foundation Account\'';
    	List<User> userList = Database.query(managerSOQLQuery);
        User userObj = userList.get(0);
        mUserManager = userObj.Id;
		mDefaultProfileID = userObj.ProfileId;
            
        // The System Account should be in prodcopy and prod
        String vpSOQLQuery = 'select Id from User where name = \'System Account\'';
    	userList = Database.query(vpSOQLQuery);
        userObj = userList.get(0);
        mUserVP = userObj.Id;
            
		String getSupervisorSOQLQuery = 'select id, EmployeeNumber, Title from User where IsActive = true limit 1';
    	userList = Database.query(getSupervisorSOQLQuery);
        userObj = userList.get(0);
		mDefaultSupervisorID = userObj.EmployeeNumber;
        
		Date startDate = Date.today() - 21;
        
        List<User> userObjectsToInsert = new List<User>();
        
        User newUserObj0 = new User();
        newUserObj0.IsActive = USER_STATUS;
        newUserObj0.FirstName = USER_FIRST_NAME;
        newUserObj0.LastName = USER_LAST_NAME0;
        newUserObj0.Title = USER_TITLE;
        newUserObj0.Username = USER_NAME0;
        newUserObj0.Alias = USER_ALIAS0;
        newUserObj0.Email = USER_EMAIL;
        newUserObj0.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj0.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj0.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj0.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj0.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj0.Location__c = USER_LOCATION;
        newUserObj0.Department = USER_DEPARTMENT_NAME;
        newUserObj0.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj0.ProfileId = mDefaultProfileID;
        newUserObj0.VP_SVP_CTO__c = mUserVP;
        newUserObj0.Mgr__c = mUserManager;
        newUserObj0.Start_Date__c = startDate;
        userObjectsToInsert.add(newUserObj0);
        
        User newUserObj1 = new User();
        newUserObj1.IsActive = USER_STATUS;
        newUserObj1.FirstName = USER_FIRST_NAME;
        newUserObj1.LastName = USER_LAST_NAME1;
        newUserObj1.Title = USER_TITLE;
        newUserObj1.Username = USER_NAME1;
        newUserObj1.Alias = USER_ALIAS1;
        newUserObj1.Email = USER_EMAIL;
        newUserObj1.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj1.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj1.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj1.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj1.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj1.Location__c = USER_LOCATION;
        newUserObj1.Department = USER_DEPARTMENT_NAME;
        newUserObj1.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj1.ProfileId = mDefaultProfileID;
        newUserObj1.VP_SVP_CTO__c = mUserVP;
        newUserObj1.Mgr__c = mUserManager;
        newUserObj1.Start_Date__c = startDate;
        userObjectsToInsert.add(newUserObj1);
        
        User newUserObj2 = new User();
        newUserObj2.IsActive = USER_STATUS;
        newUserObj2.FirstName = USER_FIRST_NAME;
        newUserObj2.LastName = USER_LAST_NAME2;
        newUserObj2.Title = USER_TITLE;
        newUserObj2.Username = USER_NAME2;
        newUserObj2.Alias = USER_ALIAS2;
        newUserObj2.Email = USER_EMAIL;
        newUserObj2.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj2.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj2.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj2.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj2.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj2.Location__c = USER_LOCATION;
        newUserObj2.Department = USER_DEPARTMENT_NAME;
        newUserObj2.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj2.ProfileId = mDefaultProfileID;
        newUserObj2.VP_SVP_CTO__c = mUserVP;
        newUserObj2.Mgr__c = mUserManager;
        newUserObj2.Start_Date__c = startDate;
        userObjectsToInsert.add(newUserObj2);
        
        User newUserObj3 = new User();
        newUserObj3.IsActive = USER_STATUS;
        newUserObj3.FirstName = USER_FIRST_NAME;
        newUserObj3.LastName = USER_LAST_NAME3;
        newUserObj3.Title = USER_TITLE;
        newUserObj3.Username = USER_NAME3;
        newUserObj3.Alias = USER_ALIAS3;
        newUserObj3.Email = USER_EMAIL;
        newUserObj3.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj3.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj3.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj3.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj3.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj3.Location__c = USER_LOCATION;
        newUserObj3.Department = USER_DEPARTMENT_NAME;
        newUserObj3.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj3.ProfileId = mDefaultProfileID;
        newUserObj3.VP_SVP_CTO__c = mUserVP;
        newUserObj3.Mgr__c = mUserManager;
        newUserObj3.Start_Date__c = startDate;
        userObjectsToInsert.add(newUserObj3);

        User newUserObj4 = new User();
        newUserObj4.IsActive = USER_STATUS;
        newUserObj4.FirstName = USER_FIRST_NAME;
        newUserObj4.LastName = USER_LAST_NAME4;
        newUserObj4.Title = USER_TITLE;
        newUserObj4.Username = USER_NAME4;
        newUserObj4.Alias = USER_ALIAS4;
        newUserObj4.Email = USER_EMAIL;
        newUserObj4.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj4.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj4.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj4.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj4.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj4.Location__c = USER_LOCATION;
        newUserObj4.Department = USER_DEPARTMENT_NAME;
        newUserObj4.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj4.ProfileId = mDefaultProfileID;
        newUserObj4.VP_SVP_CTO__c = mUserVP;
        newUserObj4.Mgr__c = mUserManager;
        newUserObj4.Start_Date__c = Date.today() ;		// this user should be ignored
        userObjectsToInsert.add(newUserObj4);

		Database.insert(userObjectsToInsert);
        
    }

    /*
     * Create a timesheet object for a user and commits it to the database.
     * 
     * @param userID	User ID 
     * 
     */
    private static void createTimesheet(Id userID) {
        if (userID == null) {
            throw new COHException('COHCheckTimesheetTest: userID cannot be null.');
        }
        
        // Calculate the week start date for the previous week
        Date lastWeekDate = Date.today() - 7;
        Date weekStart = lastWeekDate.toStartOfWeek();
		Timesheet_Week__c timesheetObj = new Timesheet_Week__c();
        timesheetObj.User__c = userID;
        timesheetObj.Week_Start_Date__c = weekStart;
        timesheetObj.Week_End_Date__c = weekStart + 6;
        timesheetObj.Status__c = TS_SUBMITTED_STATUS;

        Database.insert(timesheetObj);
    }

    /*
     *  Creates the configuration objects for the test environment.
     */
    private static void setCOHAppConfiguration() {

        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj1.Name = COHCheckTimesheetHelper.SCHEDULING_SUBQUEUES;
        configObj1.Value__c = SUBQUEUES_VAL;
        configObj1.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj2.Name = COHCheckTimesheetHelper.SCHEDULING_INTERVAL;
        configObj2.Value__c = INTERVALS_VAL;
        configObj2.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj3.Name = COHCheckTimesheetHelper.SCHEDULING_SECONDS;
        configObj3.Value__c = SECONDS_VAL;
        configObj3.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj4.Name = COHCheckTimesheetHelper.SCHEDULING_MINUTES;
        configObj4.Value__c = MINUTES_VAL;
        configObj4.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj5.Name = COHCheckTimesheetHelper.SCHEDULING_HOURS;
        configObj5.Value__c = HOURS_VAL;
        configObj5.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj5.Active__c = true;

        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
        configObj6.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj6.Name = COHCheckTimesheetHelper.SCHEDULING_DAY_OF_MONTH;
        configObj6.Value__c = DAY_OF_MONTH_VAL;
        configObj6.Value_Type__c = COHUtil.STRING_TYPE;
        configObj6.Active__c = true;

        COH_App_Configuration__c configObj7 = new COH_App_Configuration__c();
        configObj7.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj7.Name = COHCheckTimesheetHelper.SCHEDULING_MONTH;
        configObj7.Value__c = MONTH_VAL;
        configObj7.Value_Type__c = COHUtil.STRING_TYPE;
        configObj7.Active__c = true;

        COH_App_Configuration__c configObj8 = new COH_App_Configuration__c();
        configObj8.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj8.Name = COHCheckTimesheetHelper.SCHEDULING_DAY_OF_WEEK;
        configObj8.Value__c = DAY_OF_WEEK_VAL;
        configObj8.Value_Type__c = COHUtil.STRING_TYPE;
        configObj8.Active__c = true;

        COH_App_Configuration__c configObj9 = new COH_App_Configuration__c();
        configObj9.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj9.Name = COHCheckTimesheetHelper.SCHEDULING_SUBQUEUE_JOB_PREFIX;
        configObj9.Value__c = SUBQUEUE_JOB_PREFIX_VAL;
        configObj9.Value_Type__c = COHUtil.STRING_TYPE;
        configObj9.Active__c = true;

        COH_App_Configuration__c configObj10 = new COH_App_Configuration__c();
        configObj10.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj10.Name = COHCheckTimesheetHelper.SCHEDULING_MAX_TRIES;
        configObj10.Value__c = MAX_SCHED_TRIES_VAL;
        configObj10.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj10.Active__c = true;

        COH_App_Configuration__c configObj11 = new COH_App_Configuration__c();
        configObj11.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj11.Name = COHCheckTimesheetHelper.SCHEDULING_CONTROLLER_PREFIX;
        configObj11.Value__c = SCHEDULING_CONTROLLER_PREFIX_VAL;
        configObj11.Value_Type__c = COHUtil.STRING_TYPE;
        configObj11.Active__c = true;

        COH_App_Configuration__c configObj12 = new COH_App_Configuration__c();
        configObj12.Application_Name__c = COHCheckTimesheetHelper.TIMESHEET_APPLICATION;
		configObj12.Name = COHCheckTimesheetHelper.SCHEDULING_CONTROLLERS;
        configObj12.Value__c = SCHEDULING_CONTROLLERS_VAL;
        configObj12.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj12.Active__c = true;
    
         List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);
        configList.add(configObj5);
        configList.add(configObj6);
        configList.add(configObj7);
        configList.add(configObj8);
        configList.add(configObj9);
        configList.add(configObj10);
        configList.add(configObj11);
        configList.add(configObj12);
        Database.insert(configList);
        
    }
}