/* 
 * This class contains the methods for working on Notes
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
public class COHNoteUtility {
    
	private static final String ACCOUNT = 'Account';
    private static final String CAUSE_MARKETING_RECORD_TYPE = 'Cause Marketing';
    
    private static Id mCauseMarketingRecordType;

    static {
        mCauseMarketingRecordType = COHUtil.getRecordType(ACCOUNT, CAUSE_MARKETING_RECORD_TYPE);
    }
    
    /*
     * Process the notes for Accounts.  
     * 
     * @param noteList	List of notes for Accounts
     * 
     */
    public static void processAccountNotes(List<Note> noteList) {
        List<Id> accountIDList = new List<Id>();

		if (COHUtil.isValidList(noteList)) {
            for (Note noteObj : noteList)  {
                Id parentID = noteObj.ParentId;
                accountIDList.add(parentID);
            }
        }
        
        // Retrieve the parent Account records
        
		String getAccountsUserSOQLQuery = 'select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordType and Id in :accountIDList';
        List<Account> accountCauseMarketingList = Database.query(getAccountsUserSOQLQuery);
        processCauseMarket(accountCauseMarketingList);
    }
    
    /*
     * Process Account records with the CAUSE_MARKETING_RECORD_TYPE record ID.  The Force_Update__c
     * field is toggled in order to  force an update in the LastModifiedDate field, which is read-only.
     * 
     * @param accountCauseMarketingList		List of Account records with the CAUSE_MARKETING_RECORD_TYPE record ID.
     * 
     */
    private static void processCauseMarket(List<Account> accountCauseMarketingList) {
        if (COHUtil.isValidList(accountCauseMarketingList)) {
            for (Account accountObj : accountCauseMarketingList) {
                accountObj.Force_Update__c = !accountObj.Force_Update__c;
            }
            try {
				Database.update(accountCauseMarketingList);          
            } catch (Exception e) {
				throw new COHException('processNewUsers(): Could not update Cause Marketing records: ' + e.getMessage());
            }
        }
    }
    
}