/*
 * Unit Tests for TimesheetControllerNew
 * Updated by Tim Hughes
 * When possible I tried to leave the preexisting unit test and setupdata alone, and only add unit tests for the code I added to the controller.
 * The setup functions I created rely on other setup functions, the functions they rely on are listed in their descriptions, the user is responsible for calling required functions.
 *
 * Unit tests testing linking Agile Accelerator and ITS Timesheet require a System Admin with the Link Agile Accelerator To Timesheet checkbox checked.
 */
@isTest()
private class TimesheetControllerNewTest {
    // Variables for the running users
    static User admin;

    Static ITS_Activity_Portfolio_New__c mActivityPortfolio1 = new ITS_Activity_Portfolio_New__c ();
    Static ITS_Activity_Portfolio_New__c mActivityPortfolio2 = new ITS_Activity_Portfolio_New__c ();
    Static Timesheet_Week__c mTimesheetWeek1 = new Timesheet_Week__c ();
    Static Timesheet_Week__c mTimesheetWeek2 = new Timesheet_Week__c ();
    Static Time_Record__c mTimeRecord1 = new Time_Record__c();
    Static Time_Record__c mTimeRecord2 = new Time_Record__c();
    Static BLND_DFDT_Project__c pr = new BLND_DFDT_Project__c();
    Static BLND_DFDT_Project__c pr1 = new BLND_DFDT_Project__c();
    Static ITS_Project_Request__c Tpr = new ITS_Project_Request__c();
    Static Project_Task__c Pt = new Project_Task__c ();
    Static PeopleSoft__c Pst= new PeopleSoft__c ();

    static TimesheetcontrollerNew mTimesheetController;

    static Date mStartOfWeek = Date.today().toStartofWeek();
    static Date mEndOfWeek = Date.today().toStartofWeek().addDays(7);

    // Variables added for Timesheet/Agile Accelerator Integration
    static TimesheetControllerNew.DateWrapper mDateWrapper;
    static TimesheetControllerNew.projectWrapper mProjectWrapper;

    static agf__ADM_Epic__c mEpic = new agf__ADM_Epic__c();
    static agf__ADM_Work__c mUserStory1 = new agf__ADM_Work__c();
    static agf__ADM_Work__c mUserStory2 = new agf__ADM_Work__c();
    static agf__ADM_Work__c mUserStory3 = new agf__ADM_Work__c();
    static agf__ADM_Work__c mUserStory4 = new agf__ADM_Work__c();
    static agf__ADM_Task__c mUserStoryTask = new agf__ADM_Task__c();

    static FINAL STRING ACTIVITY_EPIC_NAME = 'PortNew';
    static FINAL STRING INVALID_ACTIVITY_EPIC_NAME = 'Not an Epic';

    static FINAL STRING ACTIVITY_TYPE_NAME = 'Change Management';
    static FINAL STRING ACTIVITY_SUB_TYPE = 'Deployment';

    static FINAL STRING USER_STORY_SUBJECT = 'User Story 1';
    static FINAL STRING USER_STORY_PRODUCT_TAG = 'SalesForce';
    static FINAL STRING USER_STORY_RECORD_TYPE = 'User Story';
    static FINAL INTEGER NUM_USER_STORIES = 2;

    static FINAL STRING USER_STORY_TASK_SUBJECT = 'Task 1';
    static FINAL INTEGER NUM_USER_STORY_TASKS = 1;

    static FINAL STRING NOT_APPLICABLE_LABEL = 'N/A';
    static FINAL STRING SELECT_LABEL = '---Select---';
    static FINAL STRING DAY_NAME = 'Monday';
    static FINAL INTEGER HOURS = 40;

    private static final String NEWUSER = 'Imperial Droid';
    private static final String NEWUSER_EMAIL = 'TESTUSERDISREGARD@coh.org';
    private static final String NEWUSER_EMP_ID = '101010';
    private static final String TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String LOCALE_SID_KEY = 'en_US';
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';

    // Configuration Contstants for ITS_Timesheet Config Objects
    private static final String ITS_PORTFOLIO_NAME = 'ITS Portfolio';
    private static final String TIME_EFFORT_NAME = 'Time / Effort';
    private static final String ITS_TIMESHEET_CONFIG_GROUP = 'ITS Timesheet';
    private static final String PERMISSION_SETS_APPLICATION_NAME = 'Permission Sets';
    private static final String STRING_TYPE = 'String';
    
    // Configuration constants for the number of days to show user stories
	PRIVATE STATIC FINAL STRING NUMBER_OF_DAYS_TO_SHOW_USER_STORIES = 'numberOfDaysToShowUserStories';
    PRIVATE STATIC FINAL STRING TIMESHEET_APPLICATION_NAME = 'Timesheet';
    PRIVATE STATIC FINAL STRING NUMBER_OF_DAYS_TO_SHOW_USER_STORIES_VALUE = '-17';
    PRIVATE STATIC FINAL STRING INTEGER_TYPE = 'Integer';
    
    // Constants for Permission sets that are used in testing 
    private static final String PERMISSION_SET_LABEL = 'Super Secret Permission Set DO NOT USE';
    private static final String PERMISSION_SET_NAME = 'Super_Secret_Permission_Set_DO_NOT_USE';

    // Need three sprints: a, b ,c
    PRIVATE STATIC FINAL DATE CURRENT_SPRINT_START_DATE = Date.today();
    PRIVATE STATIC FINAL DATE CURRENT_SPRINT_END_DATE = Date.today().addDays(11);
    PRIVATE STATIC FINAL DATE PREVIOUS_SPRINT_START_DATE = Date.today().addDays(-14);
    PRIVATE STATIC FINAL DATE PREVIOUS_SPRINT_END_DATE = Date.today().addDays(-3);    
    PRIVATE STATIC FINAL DATE SPRINT_BEFORE_PREVIOUS_SPRINT_START_DATE = Date.today().addDays(-28);
    PRIVATE STATIC FINAL DATE SPRINT_BEFORE_PREVIOUS_SPRINT_END_DATE = Date.today().addDays(-17);
    PRIVATE STATIC FINAL DATE NEXT_SPRINT_START_DATE = Date.today().addDays(14);
    PRIVATE STATIC FINAL DATE NEXT_SPRINT_END_DATE = Date.today().addDays(25);
    private static agf__ADM_Sprint__c mCurrentSprint = new agf__ADM_Sprint__c();
    private static agf__ADM_Sprint__c mPreviousSprint = new agf__ADM_Sprint__c();
    private static agf__ADM_Sprint__c mSprintBeforePreviousSprint = new agf__ADM_Sprint__c();
    private static agf__ADM_Sprint__c mNextSprint = new agf__ADM_Sprint__c();
    
    // Scrum team for sprint
    PRIVATE STATIC FINAL STRING SCRUM_TEAM_NAME = 'Unit Test Scrum Team';
    private static agf__ADM_Scrum_Team__c mScrumTeam = new agf__ADM_Scrum_Team__c();
    private static string mScrumTeamDepartment;
    
    private static id mPermissionSetId;

    static {
        setCOHAppConfiguration();
    }

    /*
     * This is just code coverage
     */
    private static testMethod void myunitTest(){   
        setupdata(false);    
        System.runas(admin) {

           apexpages.currentpage().getparameters().put('recordid' ,mActivityPortfolio1.Name );
            Apexpages.currentPage().getParameters().put('RowOrder','1');
            
            TimesheetcontrollerNew tsc = new TimesheetcontrollerNew();
            
            
            TimesheetcontrollerNew.DateWrapper dw = new TimesheetcontrollerNew.DateWrapper(system.Today(),1);
            dw.weekDate = System.Today();
            dw.dateStr = dw.weekDate.format();
            dw.dayname  = 'Monday';
            dw.order = 1;
            tsc.iseditable = true;
   
            tsc.componentId = '1234';
            tsc.selectedTaskId = '3456';
            tsc.selectedStageId = '7890';
            tsc.selectedActivityType = 'Change Management';
            tsc.selectedActivitySubType = 'Deployment'; 
            tsc.selectedActivity = mActivityPortfolio1.Name;
            tsc.Project_ID = mActivityPortfolio1.Id;
            tsc.dt = system.Today();
            tsc.weekStartDate = Date.today().toStartofWeek();
            tsc.WeekEndDate = tsc.weekStartDate.addDays(7);
            //tsc.weekStartDate = Date.today().addDays(3);
            tsc.WeekEndDate = Date.today().addDays(10);
            tsc.isSubmit = false;
            List<SelectOption>  Tfp = tsc.TasksForProjectsForUser;
            List<SelectOption> Act = tsc.Activities;
            List<SelectOption> Tfpu  = tsc.TasksForProjectsForUser;
            List<SelectOption> Sop  = tsc.StageOfProjects;
            List<SelectOption> Ccp = tsc.CostCentersOfProjects;
            List<SelectOption> Actt = tsc.ActivityTypes; 
            List<SelectOption> Whl = tsc.WorkHoursList; 
            List<SelectOption> AST = tsc.ActivitySubTypes;
            List<SelectOption> App = tsc.Applications;
            TimesheetcontrollerNew.BitSet Bs = new TimesheetcontrollerNew.BitSet();
            
            List<Integer> objBytes = new List<Integer>();
            objBytes.add(1);
            objBytes.add(2);
            objBytes.add(3);
            objBytes.add(4);
            Bs.testBits('test', objBytes);
            tsc.tr.Date__c = Date.today().addDays(-3);
            tsc.isCurretWeek = true;
            tsc.projectRoworder = 0;
            
            Map<date, Time_Record__c> dateWiseTRMap = new Map<date, Time_Record__c>();
            id objId;
            List<TimesheetcontrollerNew.DateWrapper> dwList = new List<TimesheetcontrollerNew.DateWrapper>();
            dwList.add(dw);
            TimesheetcontrollerNew.projectWrapper pw = new TimesheetcontrollerNew.projectWrapper(objId, 'Build', '', dateWiseTRMap, dwList, 0);
            
            TimesheetcontrollerNew.PicklistEntryWrapper PEw = new TimesheetcontrollerNew.PicklistEntryWrapper();
            PEw.active = 'Active';
            PEw.defaultValue ='defaultValue';
            PEw.Value = 'Value';
            
            tsc.findWeek(false);
            tsc.enterCustom();
            tsc.removeRow();
            tsc.checkUserAccess();
            
            tsc.findCustomWeek();
            tsc.gotoPreviousWeek();
            tsc.gotoNextWeek();
            tsc.goToCurrentWeek();
           
            tsc.doSave();
            tsc.doSubmit();
            tsc.checkUserAccess();
            tsc.addRow();
            tsc.gotoNextWeek();
            tsc.removeRow();
            tsc.getActivitySubTypes();
            tsc.getActivityDependents();
            tsc.getDependentOptions('ITS_Activity_Portfolio_New__c','Activity_Type__c','DT_Project_Type__c');
            
            tsc.doSave();
            List<Timesheet_Week__c> tw = [Select id, Name from Timesheet_Week__c ];
            List<Time_Record__c> tr = [Select id, Name from Time_Record__c];
            
            tsc.gotoPreviousWeek();
            tsc.gotoNextWeek();
            tsc.goToCurrentWeek();
            
            
            tsc.doSubmit();
            tsc.enterCustom();
            tsc.removeRow();
            tsc.tr.Date__c = Date.today().addDays(-10);
            tsc.findCustomWeek();
        }
    }

    /*
     * Tests the findWeek() method when the user has pre-existing timerecords for the current week
     * This unit test was added to reach required code coverage, it does not validate data.
     */ 
    private static testMethod void testFindWeek() {
        setupdata(true);
        setupTimesheetController();
        setupAgileAcceleratorVariables();
        setupTimesheetWeek();
        setupTimeRecords();
        
        System.runas (admin) {
            mTimesheetController.findWeek(false);
        }
    }

    /*
     * This tests the getUserStories function of the Timesheet Controller if the Activity has an associated Epic
     */
    private static testMethod void testGetUserStories0() {
        setupdata(true);
        setupTimesheetController();
        setupAgileAcceleratorVariables();

        mTimesheetController.projectWrapperList[0].userStory = mUserStory1.id;
        mTimesheetController.projectWrapperList[0].trObj.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;

        test.startTest();
        System.runas(admin) { 
            mTimesheetController.getUserStories();
            System.debug(mTimesheetController.projectWrapperList[0].userStories);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories.size(), NUM_USER_STORIES + 2);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories[0].getLabel(), SELECT_LABEL);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories[1].getLabel(), NOT_APPLICABLE_LABEL);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories[2].getLabel(), USER_STORY_SUBJECT);
        }
        test.stopTest();
    }

    /*
     * This tests the getUserStories function of the Timesheet Controller if the Activity does not have an associated Epic
     */
    private static testMethod void testGetUserStories1() {
        setupdata(true);
        setupTimesheetController();
        setupAgileAcceleratorVariables();

        mTimesheetController.projectWrapperList[0].userStory = mUserStory1.id; 
        mTimesheetController.projectWrapperList[0].trObj.ITS_Activity_Portfolio_New__c = mActivityPortfolio2.id;


        test.startTest();
        System.runas(admin) { 
            mTimesheetController.getUserStories();
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories.size(), 1);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStories[0].getLabel(), NOT_APPLICABLE_LABEL);
        }
        test.stopTest();
    }

    /*
     * This tests the getUserStoryTasks function of the Timesheet Controller
     */
    private static testMethod void testGetUserStoryTasks0() {
        setupdata(true);
        setupTimesheetController();
        setupAgileAcceleratorVariables();

        mTimesheetController.projectWrapperList[0].userStory = mUserStory1.id; 
        mTimesheetController.projectWrapperList[0].trObj.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;


        test.startTest();
        System.runas(admin) { 
            mTimesheetController.getUserStoryTasks();
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStoryTasks.size(), NUM_USER_STORY_TASKS + 1);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStoryTasks[0].getLabel(), SELECT_LABEL);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStoryTasks[1].getLabel(), USER_STORY_TASK_SUBJECT);
        }
        test.stopTest();
    }

    /*
     * This tests the getUserStoryTasks function of the Timesheet Controller
     */
    private static testMethod void testGetUserStoryTasks1() {
        setupdata(true);
        setupTimesheetController();
        setupAgileAcceleratorVariables();

        mTimesheetController.projectWrapperList[0].userStory = mUserStory2.id; 
        mTimesheetController.projectWrapperList[0].trObj.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;


        test.startTest();
        System.runas(admin) { 
            mTimesheetController.getUserStoryTasks();
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStoryTasks.size(), 1);
            System.assertEquals(mTimesheetController.projectWrapperList[0].userStoryTasks[0].getLabel(), NOT_APPLICABLE_LABEL);
        }
        test.stopTest();
    }

    /*
     * Creates the setup data for the Unit Tests. This method was updated in order to test linking with agile accelerator, but I attempted to leave it as close to the original as possible
     * 
     * @param linkedWithAgileAccelerator                boolean value to determine if the admin selected should have the Link Agile Accelerator To Timesheet checkbox checked. 
     */
    private static void setupdata (boolean linkedWithAgileAccelerator){
        Map<String,ID> profiles = new Map<String,ID>();
        
        List<Profile> ps = [select id, name from Profile where name = 'System Administrator'];        
        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        createTestUser(linkedWithAgileAccelerator);
        if (linkedWithAgileAccelerator) {
            //admin = [SELECT id, name, Link_Agile_Accelerator_To_Timesheet__c  FROM user WHERE profileid =:profiles.get('System Administrator') and isactive = true and Link_Agile_Accelerator_To_Timesheet__c = true Limit 1];
        }
        else {
           //admin = [SELECT Id, name FROM user WHERE profileid =:profiles.get('System Administrator') and isactive = true and name = 'Pavani Vunnam' Limit 1];
        }
                      
        pr.Name = 'Project 1';
        insert pr;
        
        pr1.Name = 'Project 2';
        insert pr1;

        mActivityPortfolio1.Name = ACTIVITY_EPIC_NAME;
        mActivityPortfolio1.Activity_Type__c = 'Change Management';
        mActivityPortfolio1.DT_Project_Type__c = 'Deployment';
        mActivityPortfolio1.DT_Project_Stage__c  = 'Stage1';
        mActivityPortfolio1.Charge_Back_Cost_Center__c = 'Call Centers';
        insert mActivityPortfolio1;

        mActivityPortfolio2.Name = INVALID_ACTIVITY_EPIC_NAME;
        mActivityPortfolio2.Activity_Type__c = 'Change Management';
        mActivityPortfolio2.DT_Project_Type__c = 'Deployment';
        mActivityPortfolio2.DT_Project_Stage__c  = 'Stage1';
        mActivityPortfolio2.Charge_Back_Cost_Center__c = 'Call Centers';
        insert mActivityPortfolio2;

        Pt.Name = 'example';
        Pt.User__c = UserInfo.getUserId();
        pt.ITS_Activity_Portfolio_New__c  = mActivityPortfolio1.id;
        Pt.Type__c = 'Training';
        insert Pt;
        
        mTimesheetWeek1.Status__c = 'open';
        mTimesheetWeek1.Unique_Week_Name__c = 'Uwn_56';
        mTimesheetWeek1.Week_End_Date__c = Date.today().addDays(-5);
        mTimesheetWeek1.Week_Start_Date__c = Date.today().addDays(-11);
        mTimesheetWeek1.User__c = admin.Id;
        insert mTimesheetWeek1;
        
        mTimesheetWeek2.Status__c = 'open';
        mTimesheetWeek2.Unique_Week_Name__c = 'Uwn_75';
        mTimesheetWeek2.Week_End_Date__c = Date.today().addDays(2);
        mTimesheetWeek2.Week_Start_Date__c = Date.today().addDays(-4);
        mTimesheetWeek2.User__c = admin.Id;
        insert mTimesheetWeek2;
        
        Pst.ITLT_Owner__c = admin.id;
        Pst.Persona__c = 'ITS';
        insert Pst;

        mTimeRecord1.Date__c = system.Today() -3;
        mTimeRecord1.Activity_Sub_Type__c = 'Deployment';
        mTimeRecord1.Activity_Type__c = 'Change Management';
        mTimeRecord1.Cost_Center__c = 'Test';
        mTimeRecord1.Hours__c = 40;
        mTimeRecord1.Week__c = mTimesheetWeek1.id;
        mTimeRecord1.Stage__c = 'Planning';
        mTimeRecord1.Project_Task__c = Pt.id;
        mTimeRecord1.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;
        mTimeRecord1.System__c = 'Devices';
        mTimeRecord1.Work_Hours__c = 'Reg Hours';
        insert mTimeRecord1;
        
        mTimeRecord2.Date__c = system.Today() -3;
        mTimeRecord2.Activity_Sub_Type__c = 'Deployment';
        mTimeRecord2.Activity_Type__c = 'Change Management';
        mTimeRecord2.Cost_Center__c = 'Test';
        mTimeRecord2.Hours__c = 40;
        mTimeRecord2.Week__c = mTimesheetWeek2.id;
        mTimeRecord2.Stage__c = 'Planning';
        mTimeRecord2.Project_Task__c = Pt.id;
        mTimeRecord2.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;
        mTimeRecord2.System__c = 'Devices';
        mTimeRecord2.Work_Hours__c = 'Reg Hours';
        insert mTimeRecord2;      

        Apexpages.currentpage().getparameters().put('recordid' ,mActivityPortfolio1.Name );
        Apexpages.currentPage().getParameters().put('RowOrder','0');      
    }
    
    /*
     * Creates Time Record objects for testing. User is responsible for calling setupdata and setupAgileAcceleratorVariables before calling this function
     */
    private static void setupTimeRecords() {
        mTimeRecord1.ITS_Activity_Portfolio_New__c = mActivityPortfolio1.id;
        mTimeRecord1.Activity_Type__c = ACTIVITY_TYPE_NAME;
        mTimeRecord1.Activity_Sub_Type__c = ACTIVITY_SUB_TYPE;
        mTimeRecord1.Work__c = mUserStory1.id;
        mTimeRecord1.Task__c = mUserStoryTask.id;
        mTimeRecord1.Hours__c = HOURS;
        upsert mTimeRecord1;
    }

    /*
     * Creates a Timesheet Week object for the purposes of testing. User is responsible for calling setupdata before this function
     */
    private  static void setupTimesheetWeek() {
       mTimesheetWeek1.Status__c = 'open';
       mTimesheetWeek1.User__c = admin.id;
       mTimesheetWeek1.Week_Start_Date__c = mStartOfWeek;
       mTimesheetWeek1.Week_End_Date__c = mEndOfWeek;
       upsert mTimesheetWeek1;
    }

    /*
     * Sets up the necessary values for the Timesheet Controller for use in testing. User is responsible for calling setupdata before this function
     */
    private static void setupTimesheetController() {
        mTimesheetController = new TimesheetcontrollerNew();

        mTimesheetController.iseditable = true;
        mTimesheetController.selectedActivityType = ACTIVITY_TYPE_NAME;
        mTimesheetController.selectedActivitySubType = ACTIVITY_SUB_TYPE; 
        mTimesheetController.selectedActivity = mActivityPortfolio1.Name;
        mTimesheetController.dt = system.Today();
        mTimesheetController.weekStartDate = mStartOfWeek;
        mTimesheetController.WeekEndDate = mEndOfWeek;
        mTimesheetController.isSubmit = false;
        mTimesheetController.isCurretWeek = true;
        mTimesheetController.projectRoworder = 0;
    }

    /*
     * Creates and sets up the records used when the User is linked to Agile Accelerator. User is responsible for calling setupdata before this function
     */
    private static void setupAgileAcceleratorVariables() {
        mEpic.Name = ACTIVITY_EPIC_NAME;
        insert mEpic;

        mScrumTeam.Name = SCRUM_TEAM_NAME;
        mScrumTeam.agf__Cloud__c = getScrumTeamDepartment();
        insert mScrumTeam;
        
        mCurrentSprint.agf__Start_Date__c = CURRENT_SPRINT_START_DATE;
        mCurrentSprint.agf__End_Date__c = CURRENT_SPRINT_END_DATE;
        mCurrentSprint.agf__Scrum_Team__c = mScrumTeam.id;
        insert mCurrentSprint;        
        
        mPreviousSprint.agf__Start_Date__c = PREVIOUS_SPRINT_START_DATE;
        mPreviousSprint.agf__End_Date__c = PREVIOUS_SPRINT_END_DATE;
        mPreviousSprint.agf__Scrum_Team__c = mScrumTeam.id;
        insert mPreviousSprint;
        
        mSprintBeforePreviousSprint.agf__Start_Date__c = SPRINT_BEFORE_PREVIOUS_SPRINT_START_DATE;
        mSprintBeforePreviousSprint.agf__End_Date__c = SPRINT_BEFORE_PREVIOUS_SPRINT_END_DATE;
        mSprintBeforePreviousSprint.agf__Scrum_Team__c = mScrumTeam.id;
        insert mSprintBeforePreviousSprint;
        
        mNextSprint.agf__Start_Date__c = NEXT_SPRINT_START_DATE;
        mNextSprint.agf__End_Date__c = NEXT_SPRINT_END_DATE;
        mNextSprint.agf__Scrum_Team__c = mScrumTeam.id;
        insert mNextSprint;        
        
        mUserStory1.agf__Subject__c = USER_STORY_SUBJECT;
        mUserStory1.agf__Epic__c = mEpic.id;
        mUserStory1.agf__Assignee__c = admin.id;
        mUserStory1.agf__Sprint__c = mCurrentSprint.id;
        insert mUserStory1;

        mUserStory2.agf__Subject__c = USER_STORY_SUBJECT;
        mUserStory2.agf__Epic__c = mEpic.id;
        mUserStory2.agf__Assignee__c = admin.id;
        mUserStory2.agf__Sprint__c = mPreviousSprint.id;
        insert mUserStory2;
        
        mUserStory3.agf__Subject__c = USER_STORY_SUBJECT;
        mUserStory3.agf__Epic__c = mEpic.id;
        mUserStory3.agf__Assignee__c = admin.id;
        mUserStory3.agf__Sprint__c = mSprintBeforePreviousSprint.id;
        insert mUserStory3;
        
        mUserStory4.agf__Subject__c = USER_STORY_SUBJECT;
        mUserStory4.agf__Epic__c = mEpic.id;
        mUserStory4.agf__Assignee__c = admin.id;
        mUserStory4.agf__Sprint__c = mNextSprint.id;
        insert mUserStory4;

        mUserStoryTask.agf__Subject__c = USER_STORY_TASK_SUBJECT;
        mUserStoryTask.agf__Work__c = mUserStory1.id;
        mUserStoryTask.agf__Assigned_To__c = admin.id;
        insert mUserStoryTask;
    } 
    
    /*
     * returns a random valid scrum team department
     */ 
    private static string getScrumTeamDepartment() {
        String pickListValue;
        Integer randomNumber;
        
        Schema.DescribeFieldResult fieldResult = agf__ADM_Scrum_Team__c.agf__Cloud__c.getDescribe();
   		List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        randomNumber = Math.mod((Integer)Math.random() * 1000, pickListValues.size());
        pickListValue = pickListValues.get(randomNumber).getLabel();
        
        return  picklistValue;
    }
    
    /*
     * Creates a test user for the purposes of testing.
     * 
     * @param boolean linkAgileAccelerator 				whether the LinkTimesheetToAgileAccelerator checkbox should be checked for the created user record.
     */     
    private static void createTestUser(boolean linkAgileAccelerator) {
        Id profileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;

        admin = new User();
        admin.Username = NEWUSER_EMAIL;
        admin.Email = NEWUSER_EMAIL;
        admin.LastName = NEWUSER;
        admin.Alias = NEWUSER.substring(0, 7); // Alias can only be 8 characters 
        admin.CommunityNickname = NEWUSER; 
        admin.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        admin.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
        admin.LocaleSidKey = LOCALE_SID_KEY;
        admin.EmailEncodingKey = EMAIL_ENCODING_KEY;
        admin.ProfileId = profileId;
        admin.IsActive = true;
        admin.EmployeeNumber = NEWUSER_EMP_ID;
        admin.ITS_Timesheet__c = true;
        admin.Link_Agile_Accelerator_To_Timesheet__c = linkAgileAccelerator;
        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];

        System.runas(thisUser) {
            Database.insert(admin);            
        }


    }

    /*
     * Creates a permission set that is used in testing.
     * The function that calls is responsible for calling .startTest() and .stopTest()
     */
    private static void createPermissionSet() {
        PermissionSet testPermissionSet = new PermissionSet(Label = PERMISSION_SET_LABEL, Name= PERMISSION_SET_NAME);
        User thisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(thisUser) {
            insert testPermissionSet;
        }

        mPermissionSetId = testPermissionSet.Id;
    }  

    /*
     * Creates the configuration objects for the test environment.
     * 
     * @param testMode  Indicates the type of test mode.
     * 
     */
    private static void setCOHAppConfiguration() {
        // configObj3 uses the Id of the created permission set
        createPermissionSet();

        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = PERMISSION_SETS_APPLICATION_NAME;
        configObj0.Name = TIME_EFFORT_NAME;
        configObj0.Value__c = mPermissionSetId;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Configuration_Group__c = ITS_TIMESHEET_CONFIG_GROUP;
        configObj0.Active__c = true;
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = TIMESHEET_APPLICATION_NAME;
        configObj1.Name = NUMBER_OF_DAYS_TO_SHOW_USER_STORIES;
        configObj1.Value__c = NUMBER_OF_DAYS_TO_SHOW_USER_STORIES_VALUE;
        configObj1.Value_Type__c = INTEGER_TYPE;
        configObj1.Active__c = true;        

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);

        Database.insert(configList);
    } 
}