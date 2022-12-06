/*
 * This class contains the methods for handling trigger events for Epic26Survey__c
 * objects.  A util class is not used for this because the use of the 
 * Epic26Survey__c object is very limited.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHEpic26SurveyHelper {
    
    /*
     * This method handles all trigger calls for the Epic26Survey__c object.
     * 
     */
    public static void processSurveys() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isUpdate) {
	            // Updates the account when the correspond survey is completed
    	        processAllSurveys(Trigger.new);
            }
        }
    }
    
    /*
     * Processes all survey results.  If the DateSubmitted__c field has been updated
     * to a value that is NOT null, the value of the Survey_Submitted__c field in the
     * corresponding Account object is changed to the value of the DateSubmitted__c 
     * field.
     * 
     * @param	surveysList		List of Epic26Survey__c objects from the trigger (e.g. Trigger.nex)
     * 
     */
    private static void processAllSurveys(List<Epic26Survey__c> surveysList) {
        if (COHUtil.isValidList(surveysList)) {
            Map<Id, Datetime> accountIDDatesMap = new Map<Id, Datetime>();
            for (Epic26Survey__c surveyObj : surveysList) {
                Datetime dateTimeSubmitted = surveyObj.DateSubmitted__c;
                if (dateTimeSubmitted != null) {
                    Id accountObjId = surveyObj.EPIC26_AccountID__c;
                    accountIDDatesMap.put(accountObjId, dateTimeSubmitted);
                }
            }
            List<Account> accountList = buildAccountObjectsList(accountIDDatesMap);
            if (COHUtil.isValidList(accountList)) {
                Database.update(accountList);
            }
        }
    }
    
    /*
     * Builds a list of Account objects that need to be updated
     * 
     * @param	accountIDDatesMap		Map of Account IDs to the new value of the 
     * 									Survey_Submitted__c field.
     * 
     */
    private static List<Account> buildAccountObjectsList(Map<Id, Datetime> accountIDDatesMap) {

        if (accountIDDatesMap == null || accountIDDatesMap.isEmpty() == true) {
            return null;
        }

        String soqlQuery = 'select Id, Survey_Submitted__c from Account where Id in :allAccountObjIDs';

        Set<Id> allAccountObjIDs = accountIDDatesMap.keySet();
        List<Account> accountObjectsList = Database.query(soqlQuery);
        
        if (COHUtil.isValidList(accountObjectsList)) {
            for (Account accountObj : accountObjectsList)   {
                Datetime dateTimeSubmitted = accountIDDatesMap.get(accountObj.Id);
                accountObj.Survey_Submitted__c = dateTimeSubmitted;
            }      
        }
        return accountObjectsList;
    }
}