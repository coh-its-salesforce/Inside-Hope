/*
 * This class contains the implements the Schedulable interface in order to
 * run scheduled jobs to check the users' timesheet subqueues. It should be 
 * invoked from an Apex class to schedule all the jobs.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2018
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public with sharing class COHTimesheetSubqueue implements Schedulable {
    private String mStartLettersRange;
    private String mEndLettersRange;
    
    /* 
     * Default constructor.
     * 
     * @param startRangeLetters		Starting range for letters of the last names to process.
     * @param endRangeLetters		Ending range for letters of the last names to process.
     * 
     */
    public COHTimesheetSubqueue(String startRangeLetters, String endRangeLetters) {
        if (String.isNotEmpty(startRangeLetters) && String.isNotEmpty(endRangeLetters)) {
        	mStartLettersRange = startRangeLetters;
        	mEndLettersRange = endRangeLetters;
        } else {
            String msg = 'COHTimesheetSubqueue constructor: None of the arguments can be null.\n' +
                'startRangeLetters: ' + startRangeLetters + ', endRangeLetters: ' + endRangeLetters;
            
        	throw new COHException(msg);
        }
    }
    
    /*
     * Execute the method.
     * 
     */
	public void execute(SchedulableContext SC) {
       COHCheckTimesheetHelper ccth = new COHCheckTimesheetHelper();
       ccth.processUserSubqueue(mStartLettersRange, mEndLettersRange);
	}
}