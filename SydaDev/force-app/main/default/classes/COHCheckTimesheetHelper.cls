/*
 * This class contains the methods for checking the users' timesheets.
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
public with sharing class COHCheckTimesheetHelper {
    
    // For testing purposes only--check the COHCheckTimesheetTest class.
    private static final String USER_DEPARTMENT_NAME = 'Magnum PI ITS';
    
    // COH App Configuration constants
    public static final String TIMESHEET_APPLICATION = 'Timesheet';
    private static final String PROCESSING_QUEUE = 'Processing Queue';
    
    // Scheduling constants
    public static final String SCHEDULING_SECONDS = 'Scheduling Seconds';
    public static final String SCHEDULING_MINUTES = 'Scheduling Minutes';
    public static final String SCHEDULING_HOURS = 'Scheduling Hours';
    public static final String SCHEDULING_DAY_OF_MONTH = 'Scheduling Day of Month';
    public static final String SCHEDULING_MONTH = 'Scheduling Month';
    public static final String SCHEDULING_DAY_OF_WEEK = 'Scheduling Day of Week';
    public static final String SCHEDULING_SUBQUEUES = 'Scheduling Subqueues';
    public static final String SCHEDULING_INTERVAL = 'Scheduling Interval';
	public static final String SCHEDULING_SUBQUEUE_JOB_PREFIX = 'Scheduling Job Prefix';
    public static final String SCHEDULING_CONTROLLER_PREFIX = 'Scheduling Controller Prefix';
    public static final String SCHEDULING_CONTROLLERS = 'Scheduling Controllers';
    
    public static final String SCHEDULING_MAX_TRIES = 'Scheduling Max Tries';
	private static final String SCHEDULING_APEX_JOBTYPE = '7';
	private static final String SCHEDULING_JOB_STATUS_COMPLETE = 'COMPLETE';
    private static final Integer MAX_SUBQUEUES = 26;
    private static final Integer MAX_CONTROLLERS = 26;
    
    private static final Integer DEFAULT_SECONDS = 0;
    private static final Integer DEFAULT_MINUTES = 0;
    private static final Integer DEFAULT_HOURS = 2;
    private static final String DEFAULT_DAY_OF_MONTH = '?';
    private static final String DEFAULT_MONTH = '*';
    private static final String DEFAULT_DAY_OF_WEEK = 'FRI';
    private static final String DEFAULT_SUBQUEUE_JOB_PREFIX = 'COHTimesheetSubqueue';
    private static final String DEFAULT_CONTROLLER_JOB_PREFIX = 'COHTimesheetController';
    
	private static final Integer DEFAULT_CONTROLLER_START_INTERVAL = 2;
    private static final Integer DEFAULT_CONTROLLERS = 3;
    private static final Integer DEFAULT_SUBQUEUES = 1;
    private static final Integer DEFAULT_INTERVAL = 5;		// 5 seconds
    private static final Integer DEFAULT_RETRIES = 20;
    private static final String SPACE = ' ';
    
    private static Integer mSchedInterval;
    private static Integer mSchedSeconds;
    private static Integer mSchedMinutes;
    private static Integer mSchedHours;
	private static Integer mSubqueues;
	private static Integer mSchedControllers;
    private static Integer mExecutionTimePerController;
    
    private static Integer mSchedMaxTries;
    private static String mSchedDayOfMonth;
    private static String mSchedMonth;
    private static String mSchedDayOfWeek;
	private static String mSubqueueJobName;
    private static String mControllerJobName;

    /*
	 * Default constructor.
	 * 
	 */
    public COHCheckTimesheetHelper() {
        initializeConfiguration();
    }
    
    /*
     * Initialize configuraable values.  This is required in order to deal with
     * Mixed-DML problems when testing.
     * 
     */
    public void initializeConfiguration() {
        mSchedSeconds = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_SECONDS);
        mSchedSeconds = (mSchedSeconds == null ? DEFAULT_SECONDS : mSchedSeconds);
        
        mSchedMinutes = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_MINUTES);
        mSchedMinutes = (mSchedMinutes == null? DEFAULT_MINUTES : mSchedMinutes);
        
        mSchedHours = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_HOURS);
        mSchedHours = (mSchedHours == null? DEFAULT_HOURS : mSchedHours);
        
        mSchedDayOfMonth = (String) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_DAY_OF_MONTH);
        mSchedDayOfMonth = (mSchedDayOfMonth == null? DEFAULT_DAY_OF_MONTH : mSchedDayOfMonth);
        
        mSchedMonth = (String) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_MONTH);
        mSchedMonth = (mSchedMonth == null? DEFAULT_MONTH : mSchedMonth);
        
        mSchedDayOfWeek = (String) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_DAY_OF_WEEK);
        mSchedDayOfWeek = (mSchedDayOfWeek == null? DEFAULT_DAY_OF_WEEK : mSchedDayOfWeek);

        mSchedInterval = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_INTERVAL);
        if (mSchedInterval > DEFAULT_INTERVAL) {	// Can't be longer than DEFAULT_INTERVAL seconds
            mSchedInterval = DEFAULT_INTERVAL;
        } else {
	        mSchedInterval = (mSchedInterval == null? DEFAULT_INTERVAL : mSchedInterval);
        }

        mSubqueues = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_SUBQUEUES);
        if (mSubqueues == null) {
            mSubqueues = DEFAULT_SUBQUEUES;
        } else if (mSubqueues > MAX_SUBQUEUES) { // Can't have more than MAX_SUBQUEUES subqueues
			mSubqueues = MAX_SUBQUEUES;
		}
        
        mSubqueueJobName = (String) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_SUBQUEUE_JOB_PREFIX);
        mSubqueueJobName = (mSubqueueJobName == null? DEFAULT_SUBQUEUE_JOB_PREFIX : mSubqueueJobName);

        mSchedMaxTries = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_MAX_TRIES);
        mSchedMaxTries = (mSchedMaxTries == null? DEFAULT_RETRIES : mSchedMaxTries);
        
        mControllerJobName = (String) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_CONTROLLER_PREFIX);
        mControllerJobName = (mSubqueueJobName == null? DEFAULT_CONTROLLER_JOB_PREFIX : mControllerJobName);
        
        mSchedControllers = (Integer) COHUtil.getConfigurationValue(TIMESHEET_APPLICATION, SCHEDULING_CONTROLLERS);
        if (mSchedControllers == null) {
            mSchedControllers = DEFAULT_CONTROLLERS;
        } else if (mSubqueues > MAX_CONTROLLERS) { // Can't have more than MAX_CONTROLLERS controllers
			mSchedControllers = MAX_CONTROLLERS;
		}

        Decimal lettersPerController = (26.0 / mSubqueues);      // force decimal division
        lettersPerController = lettersPerController.round(System.RoundingMode.UP);
        mExecutionTimePerController = (Integer) (lettersPerController * mSubqueues * mSchedInterval);
        
    }
    
    /*
     * Setup and schedule the parent controller jobs.  This should be called from an 
     * Execute Anonymous Window.
     * 
     */
    public void createControllers() {
        
        // remove old controller jobs
        deleteScheduledControllerJobs();
        
        Integer startSeconds =  mSchedSeconds;
        Integer startMinutes =  mSchedMinutes;
        Integer startHours = mSchedHours;
        
        // The actual number of contollers won't always be equal to the value of the 
        // mSchedControllers variable because of number of letters is often not evenly divisible.

        Decimal tempCount = (26.0 / mSchedControllers);   // force decimal division
        tempCount = tempCount.round(System.RoundingMode.UP);
        Integer lettersPerController = Integer.valueOf(tempCount);
        Integer letterVal = 65;			// start from 'A'
        
        // Assign the letters to the controllers
        for (Integer controllerCount = 0; controllerCount < mSchedControllers; controllerCount++) {
            List<String> lettersToProcessList = new List<String>();
            if (letterVal > 90) {	// 'Z' reached.  No controllers needed
                break;			
            } else {
                for (Integer j = 0; j < lettersPerController; j++) {
                    lettersToProcessList.add(String.fromCharArray(new Integer[]{letterVal}));
                    letterVal++;
                    if (letterVal > 90) {	// 'Z' reached.  No more letters to add
                        break;			
                    }
                }
            }
            
            COHTimesheetController cctcObj = new COHTimesheetController(lettersToProcessList);

            // schedule the cctcObj task
                                         
            // try to schedule the job
            for (Integer k = 0; k <= mSchedMaxTries; k++) {
                String scheduleStr = generateControllerScheduleStr(controllerCount);
                DateTime ds = DateTime.now();
                Integer mn = ds.minute();
                Integer ms = ds.millisecond();
                String jobName = mControllerJobName + String.valueOf(mn) + String.valueOf(ms);
                
                try {
                    System.schedule(jobName, scheduleStr, cctcObj); 
                    break;
                } catch (Exception e) {
                    if (k == mSchedMaxTries) {
                        throw e;
                    } 
                    k++;
                }
            }
            startMinutes += DEFAULT_CONTROLLER_START_INTERVAL;		// for the next scheduled job
            if (startMinutes > 59) {
                startMinutes = 0;
                startHours++;
            }
            if (startHours > 23) {
                startHours = 0;
            }

        }
    }

    /*
     * Process user records to check if timesheets have been submitted.  This method
     * creates scheduled jobs that check a range of user records based on the beginning 
     * characters of their last names. 
     * 
     * @param queueIDs		List of First letter of the last names of the users to process.
     * 
     */
    public void processUsersForTimesheets(List<String> queueIDs) {
        
        if (COHUtil.isValidList(queueIDs)) {
            // Remove old scheduled jobs
            deleteScheduledTimesheetJobs();
            
            // Loop to go through all the letters (capital) and schedule jobs for each letter's subqueue
             
            Integer startSeconds =  mSchedSeconds;
            Integer startMinutes =  mSchedMinutes;
            Integer startHours = mSchedHours;
            
            Integer subqueueCount = 2;		// Used to schedule Timesheet jobs after the Controller jobs execute.
            								// This ensures that the job will be scheduled correctly to be executed.
            for (String startFirstLetterQueueID : queueIDs) {
    
                // Create subqueueIDs
    
                List<SubqueueIDs> subqueuesList = getAlphabetQueues(startFirstLetterQueueID);
                
                // Schedule subqueue processing
                for (SubqueueIDs subqueueIDsObj : subqueuesList) {
    
                    String startQueueID = subqueueIDsObj.startID;
                    String endQueueID = subqueueIDsObj.endID;
                    
                    COHTimesheetSubqueue ctsObj = new COHTimesheetSubqueue(startQueueID, endQueueID);
                    String scheduleStr = generateTimesheetScheduleStr(subqueueCount);
                    subqueueCount++;
    
                    // try to schedule the job
                    for (Integer i = 0; i <= mSchedMaxTries; i++) {
                        DateTime ds = DateTime.now();
                        Integer mn = ds.minute();
                        Integer ms = ds.millisecond();
                        String jobName = mSubqueueJobName + String.valueOf(mn) + String.valueOf(ms);
                        try {
                            System.schedule(jobName, scheduleStr, ctsObj); 
                            break;
                        } catch (Exception e) {
                            if (i == mSchedMaxTries) {
                                throw e;
                            } 
                            i++;
                        }
                    }
                    
                    startSeconds += mSchedInterval;		// for the next scheduled job
                    if (startSeconds > 59) {
                        startSeconds = 0;
                        startMinutes++;
                    }
                    if (startMinutes > 59) {
                        startMinutes = 0;
                        startHours++;
                    }
                    if (startHours > 23) {
                        startHours = 0;
                    }
                }
            }
        }
        
    }
    
    /*
     * Check if the timesheet has been submitted for a set of users.  Some of this code
     * was originally taken from the UpdateSupervisor trigger.
     * 
     * @param startCharacters		Indicates the starting characters of the last names
     * 								of the records to process. If this is 'Ba', it would 
     * 								process records with last names where the beginning
     * 								characters are greater than or equal to 'Ba'.
     * @param endCharacters			Indicates the starting characters of the last names
     * 								of the records that won't be processed. If this is 'Bd', 
     * 								it would process records with last names where the end
     * 								characters are less than or equal to 'Bd'.
     * 
     */
    public void processUserSubqueue(String startCharacters, String endCharacters) {

        if (String.isEmpty(startCharacters) || String.isEmpty(endCharacters)) {
            String msg = 'COHCheckTimesheetHelper.processUserSubqueues(). Invalid arguments. ' +
                'startCharacters: ' + startCharacters + ', endCharacters: ' + endCharacters;
            throw new COHException(msg);
        }

        // Calculate the week start date for the previous week
        Date lastWeekDate = Date.today() - 7;
        Date weekStart = lastWeekDate.toStartOfWeek(); 
        
        // Some fields are not accessible, so use this instead of COHUtil.buildSelectAllSOQLStatement()
        String getUserSOQLQuery = 'select Id, EmployeeNumber, Start_Date__c, isActive, Timesheet_Submitted__c, ' +
            'Timesheet_Verification_Timestamp__c, Mgr__c, Supervisor_ID__c, FirstName, LastName, ' + 
            'Name, ManagerId, Director__c, VP_SVP_CTO__c, Title from User where isActive = true';
        
        // For testing purposes, use only records where the Department = USER_DEPARTMENT_NAME.
        // Otherwise, the number of records may fluctuate and cause the test to fail.
        if (Test.isRunningTest()) {
            getUserSOQLQuery += ' and Department = :USER_DEPARTMENT_NAME';
        } 
        
        // Process records in sets organized by the first letter of the last name
        // in order to avoid a Remedyforce problem where more than 100 queries were executed.

        getUserSOQLQuery += ' and LastNameLetters__c >= :startCharacters and LastNameLetters__c <= :endCharacters ';
        
		List<User> userList = Database.query(getUserSOQLQuery);
        
        if (COHUtil.isValidList(userList)) {
            
            // Retrieve the valid records
            List<User> validUserList = new List<User>();
            List<Id> validUserIDList = new List<Id>();

            for(User userObj: userList) {
                validUserList.add(userObj);
                validUserIDList.add(userObj.Id);
            }
            
            Map<Id, Timesheet_Week__c> userIDtoTimesheetMap = new Map<Id, Timesheet_Week__c>();		// map user IDs to their timesheets
            
            List<Timesheet_Week__c> tswList = [select Id, Week_Start_Date__c, User__c from Timesheet_Week__c where User__c in :validUserIDList and Week_Start_Date__c = :weekStart and Status__c = 'Submitted'];


            if (COHUtil.isValidList(tswList)) {
                for (Timesheet_Week__c timesheetObj : tswList) {
                    userIDtoTimesheetMap.put(timesheetObj.User__c, timesheetObj);
                }
            }

            for(User u: validUserList) {
                // Check if the user submitted a timesheet for the previous week.  This is done
                // by checking if a Timesheet_Week__c object has been created for that time period.

                Timesheet_Week__c tswObj = userIDtoTimesheetMap.get(u.Id);

                if (tswObj != null || u.Start_Date__c > weekStart) {
                   u.Timesheet_Submitted__c = true;
                    u.Timesheet_Verification_Timestamp__c = (tswObj != null ? tswObj.Week_Start_Date__c : weekStart);
                        
                } else {
                    u.Timesheet_Submitted__c = false;
                }
                
            }
            try {
                Database.update(validUserList, false);
            } catch (COHException e) {
                System.debug('COHCheckTimesheetHelper.processUsers() exception: ' + e.getMessage()); 
                throw e;
            }
        }
    }    
    
    /*
     * Deletes existing instances of Scheduled timesheet jobs
     * 
     */
    @TestVisible
    private void deleteScheduledTimesheetJobs() {
        
        String subqueueNameCriterion = mSubqueueJobName + '%';
        String soqlQuery = 'select Id from CronTrigger where CronJobDetail.JobType = :SCHEDULING_APEX_JOBTYPE ' +
            'and CronJobDetail.Name like :subqueueNameCriterion';
        
        List<CronTrigger> cronTimesheetJobsList = Database.query(soqlQuery);
        if (COHUtil.isValidList(cronTimesheetJobsList)) {
            for (CronTrigger cronTrigTimesheetObj : cronTimesheetJobsList) {
                try {
			        System.abortJob(cronTrigTimesheetObj.Id);
                } catch (Exception e) {
                    // ignore it because it may have been canceled by another process
                }
            }
        }
    }
    
    /*
     * Deletes existing instances of Timesheet Controller jobs
     * 
     */
    @TestVisible
    private void deleteScheduledControllerJobs() {
        
        String controllerCriterion = mControllerJobName + '%';
        String soqlQuery = 'select Id from CronTrigger where CronJobDetail.JobType = :SCHEDULING_APEX_JOBTYPE ' +
            'and CronJobDetail.Name like :controllerCriterion';
        
        
        List<CronTrigger> cronControllerJobsList = Database.query(soqlQuery);
        if (COHUtil.isValidList(cronControllerJobsList)) {
            for (CronTrigger cronTrigSchControllerObj : cronControllerJobsList) {
                try {
			        System.abortJob(cronTrigSchControllerObj.Id);
                } catch (Exception e) {
                    // ignore it because it may have been canceled by another process
                }
            }
        }
    }
	
    /*
     * Generate the schedule string for a controller jobs.
     * 
     * @param controllerJobCount	The number of controllers that have already been 
     * 								generated prior to this one.
     * @return						Schedule string for this job to be used bye System.schedule().
     * 
     */
    private String generateControllerScheduleStr(Integer controllerJobCount) {
        String scheduleStr;
        if (controllerJobCount >= 0) {
            String startDayOfWeek = mSchedDayOfWeek;
            Integer startSeconds = mSchedSeconds;
            Integer startHours = mSchedHours;
			Integer startMinutes = (controllerJobCount * mExecutionTimePerController) + mSchedMinutes;
            if (startMinutes > 59) {				// adjust the starting times
                startHours = (startMinutes / 60) + mSchedHours;
                startMinutes = Math.mod(startMinutes, 60);
                if (startHours > 23) {
                    startHours = Math.mod(startHours + mSchedMinutes, 23);
                    startDayOfWeek = getNextStartDayOfWeek(mSchedDayOfWeek);
                }
            } 
            scheduleStr = String.valueOf(startSeconds) + SPACE + String.valueOf(startMinutes) +
                    SPACE + String.valueOf(startHours) + SPACE + mSchedDayOfMonth + SPACE + 
                    mSchedMonth + SPACE + startDayOfWeek;
        } else {
            throw new COHException('COHCheckTimesheetHelper.generateControllerScheduleStr(): invalid controllerJobCount argument: ' + controllerJobCount);
        }
		return scheduleStr;
                                   
    }

    /*
     * Generate the schedule string for a Timesheet jobs.
     * 
     * @param controllerJobCount	The number of controllers that have already been 
     * 								generated prior to this one.
     * @return						Schedule string for this job to be used bye System.schedule().
     * 
     */
    private String generateTimesheetScheduleStr(Integer subqueueCount) {
        String scheduleStr;
        if (subqueueCount >= 0) {
            
  
			Datetime dt = Datetime.now();
			Integer startSeconds = (subqueueCount * mSchedInterval) + dt.second();
			Integer startMinutes = dt.minute() + mSchedInterval;	// Ensure that the start time will be after the 
            														// time this class is executed.
            Integer startHours = dt.hour(); 
            String startDayOfWeek = mSchedDayOfWeek;

            if (startSeconds > 59) {				// adjust the starting times
                startMinutes += (startSeconds / 60);
                startSeconds = Math.mod(startSeconds, 60);
                if (startMinutes > 59) {
	                startHours = startMinutes / 60;
                    startMinutes = Math.mod(startMinutes, 60);
                    if (startHours > 23) {
                    	startDayOfWeek = getNextStartDayOfWeek(mSchedDayOfWeek);    
                    }
                    
                }
            } 
            scheduleStr = String.valueOf(startSeconds) + SPACE + String.valueOf(startMinutes) +
                    SPACE + String.valueOf(startHours) + SPACE + mSchedDayOfMonth + SPACE + 
                    mSchedMonth + SPACE + startDayOfWeek;
        } else {
            throw new COHException('COHCheckTimesheetHelper.generateTimesheetScheduleStr(): invalid subqueueCount argument: ' + subqueueCount);
        }
		return scheduleStr;
                                   
    }

  	/*
	 * Gets the next day of the week..
	 * 
	 * @param curSchedDayOfWeek		Current scheduled day of the week.
	 * @return						String for the next day of the week.
	 */
	@TestVisible
    private String getNextStartDayOfWeek(String curSchedDayOfWeek) {
        String retVal = null;
        if (curSchedDayOfWeek == 'Sun') {
            retVal = 'Mon';
        } else if (curSchedDayOfWeek == 'Mon') {
            retVal = 'Tue';
        } else if (curSchedDayOfWeek == 'Tue') {
            retVal = 'Wed';
        } else if (curSchedDayOfWeek == 'Wed') {
            retVal = 'Thu';
        } else if (curSchedDayOfWeek == 'Thu') {
            retVal = 'Fri';
        } else if (curSchedDayOfWeek == 'Fri') {
            retVal = 'Sat';
        } else if (curSchedDayOfWeek == 'Sat') {
            retVal = 'Sun';
        } 
        return retVal;
    }

     /*
	 * Retrieves the list of starting letters of the last names to process.  For example,
	 * if 3 subqueues were specified, it would return this list of SubqueueIDs 
	 * objects for the letter A:
	 * A, AI[
	 * AJ, AR[
	 * AS, A[
	 * 
	 * The '[' character comes immediately after the 'Z' character in the ISO 8859-1 table.
	 * 
	 * @return		Next alpha character to process.
	 * 
	 */ 
    @TestVisible
    private List<SubqueueIDs> getAlphabetQueues(String startQueueID) {

        List<SubqueueIDs> newSubqueueIDsList = new List<SubqueueIDs>();
        if (String.isNotBlank(startQueueID)) {
    
            // Case for 3 subqueues
            // 1: 65 start, value of 'A'; 73 'AI[' end
            // 2: 74 start, 'AJ'; 82 'AR[' end
            // 3: 83 start, 'AS'; 90 'A[' end
            
            // The actual number of subqueues won't always be equal to the value of the 
            // subqueues variable because of number of letters is often not evenly divisible.
            // In practice, the maximum number of subqueues is 13.
            
            if (mSubqueues >= 1) {
                Decimal interval = (26.0 / mSubqueues);      // force decimal division
                interval = interval.round(System.RoundingMode.UP);
                for (Integer i = 0; i < mSubqueues; i++) {
                    // Start characters
                    String startStr = null;
                    Integer startSecondLetterVal = -1;
                    if (i == 0) {
                        startStr = startQueueID; 	// First instance needs only the first letter
                        							// Avoid a bug in the data where there is a 'B .'
                                                    // because '.' comes before 'A" in the ISO-8859-1 table
                        startSecondLetterVal = 65;
                    } else {
                        Integer tempLetterVal = (Integer) (65 + (i * (interval + 1)));
                        startSecondLetterVal = (tempLetterVal > 90 ? 90 : tempLetterVal);  // If the value is greater than 'Z', set it to 'Z'
	                    String startSecondLetter = String.fromCharArray(new Integer[]{startSecondLetterVal});
                        startStr = startQueueID + startSecondLetter;
                    }
                                       
                    // End characters
                    // If the value is greater than 'Z', set it to '[' because it comes after 'Z' in the ISO 8859-1 table
                    Integer endSecondLetterVal = (Integer) (startSecondLetterVal + interval);
                    endSecondLetterVal = (endSecondLetterVal > 90 ? 90 : endSecondLetterVal);  
                    String endSecondLetter = String.fromCharArray(new Integer[]{endSecondLetterVal});
                    String endStr = startQueueID + endSecondLetter  + '[';
                    SubqueueIDs subqueueIDobj = new SubqueueIDs(startStr, endStr);
                    newSubqueueIDsList.add(subqueueIDobj);
                    if (endSecondLetterVal >= 90) {
                        break;			// no more subqueues needed
                    }
                }
                
	        }
            
        }            
        return newSubqueueIDsList;
    }   

    /*
     * Subclass for storing the String characters for the SOQL query on the User object.
     * 
     */
    public class SubqueueIDs {
        public SubqueueIDs(String startStr, String endStr) {
            startID = startStr;
            endID = endStr;
        }
        public String startID {get; set;}
        public String endID {get; set;}
    }
    
}