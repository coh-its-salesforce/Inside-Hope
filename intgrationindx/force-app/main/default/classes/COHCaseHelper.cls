/* 
 * This class contains the methods for working on Cases
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
public class COHCaseHelper {
    
	private static final String APPLICATION_TAKEN = 'APPLICATION TAKEN';
    
    /*
     * Process NPS Account records when the Case.Action_Taken__c field has been 
     * updated to APPLICATION TAKEN.
     * 
     * @param newCaseObj	New Case object
     * @param oldCaseObj	Old Case object
     * @param isUpdate		Indicates if the Trigger is an update trigger
     * @param isInsert		Indicates if the Trigger is an insert trigger
     * @return				ID of the Account object that was modified
     * 
     */
    public static Id processNPSCase(Case newCaseObj, Case oldCaseObj, Boolean isUpdate, Boolean isInsert) {
		Id accountObjID = null;
            if (isUpdate) {
                String oldStatus = oldCaseObj.Action_Taken__c;
                String newStatus = newCaseObj.Action_Taken__c;
                if (COHUtil.isValidStr(oldStatus) && COHUtil.isValidStr(newStatus) && 
                    !oldStatus.equalsIgnoreCase(newStatus) && newStatus.equalsIgnoreCase(APPLICATION_TAKEN)) {
                        
                        accountObjID = newCaseObj.AccountId;
				}
            } else if (isInsert) {
                String newStatus = newCaseObj.Action_Taken__c;
                if (COHUtil.isValidStr(newStatus)) {
                    if (newStatus.equalsIgnoreCase(APPLICATION_TAKEN)) {
                        accountObjID = newCaseObj.AccountId;
                    }
                }
            }
        
		return accountObjID;
    }


}