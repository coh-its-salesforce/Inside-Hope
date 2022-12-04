/*
 * This class contains the implements the Schedulable interface in order to
 * run scheduled jobs to create controllers that in turn create scheduled jobs
 * to check users' timesheets. COHTimesheetController instances are created by 
 * executing the COHCheckTimesheetHelper.createControllers() method that can 
 * be called from an Execute Anonymous Window.
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
public with sharing class COHTimesheetController implements Schedulable {
	private List<String> mLettersToProcess;		// List of First letters of last names to process
    
    /*
     * Default constructor
     */
    public COHTimesheetController(List<String> lettersToProcess) {
        if (COHUtil.isValidList(lettersToProcess)) {
	        mLettersToProcess = lettersToProcess;
        } else {
        	throw new COHException('COHTimesheetController: parameter cannot be null or an empty list');
        }
    }
    
    /*
     * Execute the method.
     * 
     */
	public void execute(SchedulableContext SC) { 
       COHCheckTimesheetHelper ccth = new COHCheckTimesheetHelper();
       ccth.processUsersForTimesheets(mLettersToProcess);
	}
    
}