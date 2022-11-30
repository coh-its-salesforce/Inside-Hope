/*
 * This class contains the unit tests for the Salesforce trigger TimeRecordTrigger
 * Tim Hughes
 */
@isTest()
private class TimeRecordTriggerTest {
	
	// Variables for creating a new user
	PRIVATE STATIC FINAL STRING EMAIL = 'TESTUSERDISREGARD@coh.org';
	PRIVATE STATIC FINAL STRING LAST_NAME = 'Wayne';
	PRIVATE STATIC FINAL STRING ALIAS = 'Batman';
	PRIVATE STATIC FINAL STRING TIME_ZONE_SID_KEY = 'America/Los_Angeles';
	PRIVATE STATIC FINAL STRING LANGUAGE_LOCALE_KEY = 'en_US';
	PRIVATE STATIC FINAL STRING LOCALE_SID_KEY = 'en_US';
	PRIVATE STATIC FINAL STRING EMAIL_ENCODING_KEY = 'UTF-8';
	PRIVATE STATIC FINAL STRING EMPLOYEE_NUMBER = '123456';
	private static User mTestUser;
	private static id mProfileId;

	// Variables for creating Timesheet Week and Time Record objects
	PRIVATE STATIC FINAL DECIMAL VALID_HOURS = 10;
	PRIVATE STATIC FINAL DECIMAL INVALID_HOURS = 30;	
	PRIVATE STATIC FINAL STRING WEEK_STATUS = 'open';
	PRIVATE STATIC FINAL DATE TIME_RECORD_DATE = Date.today();  
	PRIVATE STATIC FINAL DATE START_OF_WEEK = Date.today().toStartofWeek();
	PRIVATE STATIC FINAL DATE END_OF_WEEK = Date.today().toStartofWeek().addDays(7);
	private static Timesheet_Week__c mTimesheetWeek;

	// Variables for creating Epic, Work, and Tasks
	PRIVATE STATIC FINAL STRING WORK_SUBJECT = 'Very cool and fun User Story';
	PRIVATE STATIC FINAL STRING EPIC_NAME = 'Super exciting Epic';
	PRIVATE STATIC FINAL STRING TASK_SUBJECT = 'Awesome Task';
	PRIVATE STATIC FINAL DECIMAL STARTING_HOURS = 20;
	private static agf__ADM_Work__c mWork;
	private static agf__ADM_Epic__c mEpic;
	private static agf__ADM_Task__c mTask0;
	private static agf__ADM_Task__c mTask1;
    private static agf__ADM_Task__c mTask2;

	/*
	 * Calls createTestUser, createTimesheetWeek and createEpicAndWork functions to setup data for the tests
	 */
	private static void testSetup() {
		createTestUser();
		createTimesheetWeek();
		createAgileAcceleratorObjects();
	}

	/*
	 * Tests insert trigger when Time Record's Remaining Hours > 0
	 */
	@isTest 
	private static void createTimeRecordTest0() {

		Test.startTest();
		testSetup();	
		createTimeRecord(mTask0.id, VALID_HOURS);

		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];

		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask0.agf__Actual_Hours__c);

		Test.stopTest();
	}

	/*
	 * Test insert trigger when Time Record's Remaining Hours < 0
	 */
	@isTest 
	private static void createTimeRecordTest1() {

		Test.startTest();
		testSetup();		
		createTimeRecord(mTask0.id, INVALID_HOURS);

		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];

		System.assertEquals(STARTING_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - INVALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(INVALID_HOURS, mTask0.agf__Actual_Hours__c);

		Test.stopTest();
	}

	/*
	 * Test insert trigger when Time Record's task == null
	 */
	@isTest 
	private static void createTimeRecordTest2() {

		Test.startTest();
		testSetup();

		createTimeRecord(null, VALID_HOURS);

		Test.stopTest();
	}

	/*
	 * Test delete trigger
	 */
	@isTest
	private static void deleteTimeRecordTest0() {
		Time_Record__c timeRecord;
		Test.startTest();
		testSetup();

		// Create a record
		timeRecord = createTimeRecord(mTask0.id, VALID_HOURS);
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask0.agf__Actual_Hours__c);

		// Delete the record
		delete timeRecord;
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(0, mTask0.agf__Actual_Hours__c);
	}

	/*
	 * Tests delete trigger when Time Record's related task == null
	 */
	@isTest
	private static void deleteTimeRecordTest1() {
		Time_Record__c timeRecord;
		Test.startTest();
		testSetup();

		// Create a record
		timeRecord = createTimeRecord(null, VALID_HOURS);


		// Delete the record
		delete timeRecord;
	}

	/*
	 * Test update trigger when a Time Record's hours are changed
	 */
	@isTest
	private static void updateTimeRecordTest0() {
		Time_Record__c timeRecord;

		Test.startTest();
		testSetup();	

		// Create a Time Record
		timeRecord = createTimeRecord(mTask0.id, VALID_HOURS);
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask0.agf__Actual_Hours__c);

		// Update a Time Record
		timeRecord.Hours__c = INVALID_HOURS;
		update timeRecord;
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - INVALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(INVALID_HOURS, mTask0.agf__Actual_Hours__c);

		Test.stopTest();		
	}

	/*
	 * Tests update trigger when Time Record's task is changed
	 */
	@isTest
	private static void updateTimeRecordTest1() {
		Time_Record__c timeRecord;

		Test.startTest();
		testSetup();	

		// Insert the Time Record
		timeRecord = createTimeRecord(mTask0.id, VALID_HOURS);
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask0.agf__Actual_Hours__c);

		mTask1 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask1.id LIMIT 1];
		System.assertEquals(STARTING_HOURS, mTask1.agf__Hours_Remaining__c);
		System.assertEquals(null, mTask1.Timesheet_Remaining_Hours__c);
		System.assertEquals(null, mTask1.agf__Actual_Hours__c);	

		// Update the Time Record with the new task
		timerecord.Task__c = mTask1.id;
		update timeRecord;
		mTask0 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask0.id LIMIT 1];
		System.assertEquals(STARTING_HOURS, mTask0.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS, mTask0.Timesheet_Remaining_Hours__c);
		System.assertEquals(0, mTask0.agf__Actual_Hours__c);

		mTask1 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask1.id LIMIT 1];
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask1.agf__Hours_Remaining__c);
		System.assertEquals(STARTING_HOURS - VALID_HOURS, mTask1.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask1.agf__Actual_Hours__c);		

		Test.stopTest();		
	}
    
	/*
	 * Tests update trigger when Time Record's task is changed
	 */
	@isTest
	private static void updateTimeRecordTest2() {
		Time_Record__c timeRecord;

		Test.startTest();
		testSetup();	

		// Create a Time Record
		timeRecord = createTimeRecord(mTask2.id, VALID_HOURS);
		mTask2 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask2.id LIMIT 1];
		System.assertEquals(0, mTask2.agf__Hours_Remaining__c);
		System.assertEquals(0 - VALID_HOURS, mTask2.Timesheet_Remaining_Hours__c);
		System.assertEquals(VALID_HOURS, mTask2.agf__Actual_Hours__c);

		// Update a Time Record
		timeRecord.Hours__c = INVALID_HOURS;
		update timeRecord;
		mTask2 = [SELECT id, agf__Hours_Remaining__c, Timesheet_Remaining_Hours__c, agf__Actual_Hours__c FROM agf__ADM_Task__c WHERE id =: mTask2.id LIMIT 1];
		System.assertEquals(0, mTask2.agf__Hours_Remaining__c);
		System.assertEquals(0 - INVALID_HOURS, mTask2.Timesheet_Remaining_Hours__c);
		System.assertEquals(INVALID_HOURS, mTask2.agf__Actual_Hours__c);

		Test.stopTest();	
	}    
	
	/*
	 * Creates a Time Record object for testing
	 *
	 * @param pHours 				The decimal that should be entered for the time record's Hours__c field
	 * 
	 * return timeRecord 			The newly created Time_Record__c object
	 */
    private static Time_Record__c createTimeRecord(id taskId, Decimal pHours) {
		Time_Record__c timeRecord = new Time_Record__c();
		timeRecord.Date__c = TIME_RECORD_DATE;
		timeRecord.Task__c = taskId;
		timeRecord.Week__c = mTimesheetWeek.id;
		timeRecord.Hours__c = pHours;
		insert timeRecord;

		return timeRecord;
    }

	/*
	 * Creates a test user for use in testing
	 */
    private static void createTestUser() {
		Id mProfileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;

		mTestUser = new User();
		mTestUser.Username = EMAIL;
		mTestUser.Email = EMAIL;
		mTestUser.LastName = LAST_NAME;
		mTestUser.Alias = ALIAS;
		mTestUser.CommunityNickname = LAST_NAME; 
		mTestUser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
		mTestUser.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
		mTestUser.LocaleSidKey = LOCALE_SID_KEY;
		mTestUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
		mTestUser.ProfileId = mProfileId;
		mTestUser.IsActive = true;
		mTestUser.EmployeeNumber = EMPLOYEE_NUMBER;
		//mTestUser.ITS_Timesheet__c = true;

		User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
		System.runas(thisUser) {
			Database.insert(mTestUser);            
		}
    }

    /*
     * Creates a Timesheet Week object for the purposes of testing.
     */
    private static void createTimesheetWeek() {
    	mTimesheetWeek = new Timesheet_Week__c();
		mTimesheetWeek.Status__c = WEEK_STATUS;
		mTimesheetWeek.Week_Start_Date__c = START_OF_WEEK;
		mTimesheetWeek.Week_End_Date__c = END_OF_WEEK;
		mTimesheetWeek.User__c = mTestUser.id;
		insert mTimesheetWeek;
    }	

	/*
	 * Creates a agf__ADM_Work__c object for the purposes of testing
	 */
	private static void createAgileAcceleratorObjects() {
		mEpic = new agf__ADM_Epic__c();
		mWork = new agf__ADM_Work__c();
		mTask0 = new agf__ADM_Task__c();
		mTask1 = new agf__ADM_Task__c();
        mTask2 = new agf__ADM_Task__c();

		mEpic.Name = EPIC_NAME;
		insert mEpic;

		mWork.agf__Subject__c = WORK_SUBJECT;
		mWork.agf__Epic__c = mEpic.id;
		mWork.agf__Assignee__c = mTestUser.id;
		insert mWork;

		mTask0.agf__Subject__c = TASK_SUBJECT;
		mTask0.agf__Starting_Hours__c = STARTING_HOURS;
		mTask0.agf__Hours_Remaining__c = STARTING_HOURS;
		mTask0.agf__Work__c = mWork.id;
		mTask0.agf__Assigned_To__c = mTestUser.id;
		insert mTask0;

		mTask1.agf__Subject__c = TASK_SUBJECT;
		mTask1.agf__Starting_Hours__c = STARTING_HOURS;
		mTask1.agf__Hours_Remaining__c = STARTING_HOURS;
		mTask1.agf__Work__c = mWork.id;
		mTask1.agf__Assigned_To__c = mTestUser.id;
		insert mTask1;		
        
        mTask2.agf__Subject__c = TASK_SUBJECT;
		mTask2.agf__Starting_Hours__c = 0;
		mTask2.agf__Hours_Remaining__c = 0;
		mTask2.agf__Work__c = mWork.id;
		mTask2.agf__Assigned_To__c = mTestUser.id;
		insert mTask2;		
	}
}