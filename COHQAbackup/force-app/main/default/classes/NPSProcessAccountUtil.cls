/*
 * This class contains utility methods for the New Patient Services project.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  Test Class: NPSProcessAccountTester
 */
public class NPSProcessAccountUtil {
    
    private static final String SCHEDULED_STATUS = 'Appointment Scheduled';
    private static final String COMPLETED_STATUS = 'completed';
    private static final String CLOSED_STATUS = 'closed';
    private static final String NEW_STATUS = 'New';

    private static final String mGetCasesSOQLQuery = 'select id, status from case where RecordTypeId = :mNPSRecordTypeID and AccountId in :completedAccountIDs';
    private static Id mNPSRecordTypeID;
    
    static {
		mNPSRecordTypeID = [select Id, name from RecordType where name = 'New Patient Services' and SObjectType = 'Case' limit 1].Id;
    }
    
    /*
     * Default constructor
     * 
     */
    public NPSProcessAccountUtil() {
    }
    
    /*
     * This is the main entry point for the New Patient Services project.  This method processes a 
     * list of Accounts.  When the patient_status is changed to COMPLETED_STATUS or SCHEDULED_STATUS, 
     * the status field will be set to CLOSED_STATUS in all corresponding Case objects.
     * 
     * @param   accountObjectsList      List of Accounts to process.
     * 
     */
    public static void processCompletedAccounts(List<Account> accountObjectsList) {
        
        if (COHUtil.isValidList(accountObjectsList)) {
            List<Id> completedAccountIDs = new List<Id>();
            for (Account accountObj : accountObjectsList) {
                String patientStatus = accountObj.Patient_Status__c;
                if (patientStatus != null && 
	                    (patientStatus.equalsIgnoreCase(COMPLETED_STATUS) ||
    	                 patientStatus.equalsIgnoreCase(SCHEDULED_STATUS))) {
                    completedAccountIDs.add(accountObj.Id);
                }
            }
            List<Case> caseObjsToUpdate = Database.query(mGetCasesSOQLQuery);
            if (COHUtil.isValidList(caseObjsToUpdate)) {
                for (Case caseObj : caseObjsToUpdate) {
                    caseObj.status = CLOSED_STATUS;
                }
                List<Database.SaveResult> saveResult = Database.update(caseObjsToUpdate);
                for (Database.SaveResult saveResultObj : saveResult) {
                    if (!saveResultObj.isSuccess()) {
                        throw new NPSException('Error: NPRProcessAccountUtil.processCompletedAccounts() could not update Case objects');
                    }
                }
            }
            
        }
    }

    /*
     * Process NPS Account records when the Case.Action_Taken__c field has been updated to 
     * 'Application Taken' Case.  The value of the Account.Patient_Status__c field should
     * be changed to NEW_STATUS. This is called by COHCaseTrigger.   
     * 
     * @param	casesList		List of Accounts to process.
     * 
     */
    public static void processCaseStatusUpdates(List<Id> accountIDList) { 
        if (Trigger.isExecuting) {
            // testing--raymond tam
			System.debug('Tracer: processCaseStatusUpdates');
            List<Account> accountsList = [select Id, Patient_Status__c from Account where Id in : accountIDList];
            List<Account> accountObjsToUpdate = new List<Account>();
                                        
			for (Account accountObj : accountsList) {
            	accountObj.Patient_Status__c = NEW_STATUS;
                accountObjsToUpdate.add(accountObj);
            }
                                        
			if (COHUtil.isValidList(accountObjsToUpdate)) {
                List<Database.SaveResult> saveResult = Database.update(accountObjsToUpdate);
                for (Database.SaveResult saveResultObj : saveResult) {
                    if (!saveResultObj.isSuccess()) {
                        throw new NPSException('Error: NPRProcessAccountUtil.processCaseStatusUpdates() could not update Account objects');
                    }
                }

            }
        } 
    } 
       
}