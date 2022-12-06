/* Created By    :  Saidaiah Surisetti
* Created Date  :  8/23/2018
* Description   :  This test controller verifies the functionality of the ITS_Intake_Request Trigger.
* Modified by   :  Larry Kiang
* Modified Date :  04/03/2019
*/
@isTest
private class COHITPMLifecycleHelperTest {
    private static final Boolean mRunITPMLifecycleTimeRecordTest = false;
    private static final Boolean mRunITPMLifecyclebulkTest = false;
    private static final Boolean mRunAllTests = true;    
    
    //variables for creating a new user
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
    
    //variables for creating a Timesheet Week and Time Record Objects
    PRIVATE STATIC FINAL DECIMAL VALID_HOURS = 10;
    PRIVATE STATIC FINAL DECIMAL INVALID_HOURS = 30;	
    PRIVATE STATIC FINAL STRING WEEK_STATUS = 'open';
    PRIVATE STATIC FINAL DATE TIME_RECORD_DATE = Date.today();  
    PRIVATE STATIC FINAL DATE START_OF_WEEK = Date.today().toStartofWeek();
    PRIVATE STATIC FINAL DATE END_OF_WEEK = Date.today().toStartofWeek().addDays(7);
    PRIVATE STATIC Timesheet_Week__c mTimesheetWeek;
    
    //variables for IT PM Lifecycle Records.
    PRIVATE STATIC FINAL Date actualStartDate = date.newInstance(2020, 03, 31);
    PRIVATE STATIC FINAL Date actualEndDate = date.newInstance(2020, 06, 31);
    PRIVATE STATIC FINAL String inProgress = 'In-Progress';
    PRIVATE STATIC FINAL String green = 'Green';
    PRIVATE STATIC FINAL String projectName = 'Simulation Test for Hours Burned Calculation';
    PRIVATE STATIC FINAL String requestType = 'P - Project';
    PRIVATE STATIC FINAL String methodology = 'Agile';
    PRIVATE STATIC FINAL String phase = 'Initiation';
    PRIVATE STATIC Decimal percentComplete = .75;
    PRIVATE STATIC IT_Portfolio_Management__c mITPMLifecycle;

    //Setup environment for testing.
    private static void testSetupEnvironment(){
        createTestUser();
        createITPMLifecycle();        
        createTimesheetWeek();
    }
   
    private testmethod static void ITPMLifecycleTimeRecordTest(){
        if (!mRunAllTests && !mRunITPMLifecycleTimeRecordTest){
            System.debug ('Skipping intakeRequestsTest');
            return;
        }
      Test.startTest();
        testSetupEnvironment();
        //Create Time Records for IT PM Lifecycle Record
        Time_Record__c recTimeRecord = new Time_Record__c();
        recTimeRecord.IT_Portfolio_Management__c = mITPMLifecycle.Id;
        recTimeRecord.Week__c = mTimesheetWeek.Id;
        recTimeRecord.Date__c = TIME_RECORD_DATE;
        recTimeRecord.Hours__c = 8;
        insert recTimeRecord;
       

        Test.stopTest(); 
        IT_Portfolio_Management__c recordTestValue = [select id, Hours_Burned_D__c from IT_Portfolio_Management__c where id =: mITPMLifecycle.Id Limit 1];
        update recordTestValue;
        IT_Portfolio_Management__c verifyTestValue = [select id, Hours_Burned_D__c from IT_Portfolio_Management__c where id =: recordTestValue.Id Limit 1];
        //system.assertEquals(8, verifyTestValue.Hours_Burned_D__c);
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
    //Creates IT PM Lifecycle Record
    private static void createITPMLifecycle(){
        mITPMLifecycle = new IT_Portfolio_Management__c();
        mITPMLifecycle.Actual_Start_Date__c = actualStartDate;
        mITPMLifecycle.Actual_End_Date__c = actualEndDate;
        mITPMLifecycle.Project_Status__c = inProgress;
        mITPMLifecycle.Project_Schedule__c = green;
        mITPMLifecycle.Project_Scope__c = green;
        mITPMLifecycle.Project_Financial__c = green;
        mITPMLifecycle.Project_Resources__c = green;
        mITPMLifecycle.Request_Type__c = requestType;
        mITPMLifecycle.Name = projectName;
        mITPMLifecycle.Request_Type__c = requestType;
        mITPMLifecycle.Methodology__c = methodology;
        mITPMLifecycle.Activity_Type__c = phase;
        mITPMLifecycle.Percentage_Completion__c = percentComplete;
        insert mITPMLifecycle;
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
        timeRecord.IT_Portfolio_Management__c = mITPMLifecycle.Id;
        insert timeRecord;
        
        return timeRecord;
    }  
    
}