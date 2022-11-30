/* 
 * This test class verifies the functionality of the COHNoteTrigger.  
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
@isTest
public class COHNoteTest {
    private static final Boolean mRunVerifyCauseMarketing = true;
    private static final Boolean mRunVerifyBulkCauseMarketing = false;
    private static final Boolean mRunAllTests = true;

    private static final String ACCOUNT = 'Account';
    private static final String ACCOUNT_NAME = 'Thomas Magnum';
    private static final String CAUSE_MARKETING_RECORD_TYPE = 'Cause Marketing';
    private static final Id mCauseMarketingRecordTypeID = COHUtil.getRecordType(ACCOUNT, CAUSE_MARKETING_RECORD_TYPE);
    private static final Integer SINGLE_MODE = 0;
    private static final Integer BULK_MODE = 1;
    private static final Integer MAX_RECORDS = 202;
    private static final Integer DELAY = 2000;				// milliseconds
	private static final Integer RECORD_COUNT1 = 1;

    /* 
     * Verifies processing Accounts with the Cause Marketing record type.
     * 
     */
    private static testMethod void verifyCauseMarketing() {
        if (!mRunAllTests && !mRunVerifyCauseMarketing) {
            System.debug('Skipping verifyCauseMarketing()');
            return;
        }
        
        test.startTest();
        
		List<Account> accountList = createRecordsCauseMarketing(SINGLE_MODE);
        Database.insert(accountList);
        
        if (COHUtil.isValidList(accountList)) {
	        System.assertEquals(RECORD_COUNT1, accountList.size());
	        List<Account> accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
            Account accountObj = accountList1.get(0);
            Datetime originalDateTime = accountObj.LastModifiedDate;

            // Force a delay
            COHUtil.delay(DELAY);
            
            // Add Note
            Note noteObj = createNoteObject(accountObj.Id);
            Database.insert(noteObj);
            
	        accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
            accountObj = accountList1.get(0);
            Datetime newDateTime = accountObj.LastModifiedDate;
            
            System.assert(newDateTime.getTime() >= (originalDateTime.getTime() + DELAY), 
                          'Error: newDatetime (' + newDateTime + ') should be at least ' + DELAY + 
                          			' milliseconds greater than originalDateTime (' + originalDateTime + ')');
        } else {
            System.assert(false, 'Expected ' + RECORD_COUNT1 + ' records, but retrieved nothing');
        }
        test.stopTest();
    }    
    
    /*
     * Verifies bulk processing Accounts with the Cause Marketing record type.
     * 
     */
    private static testMethod void verifyBulksCauseMarketing() {
        if (!mRunAllTests && !mRunVerifyBulkCauseMarketing) {
            System.debug('Skipping verifyBulksCauseMarketing()');
            return;
        }
        
        test.startTest();

		List<Account> accountList = createRecordsCauseMarketing(BULK_MODE);
        Database.insert(accountList);
        
		List<Account> accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
        if (COHUtil.isValidList(accountList1)) {
	        System.assertEquals(MAX_RECORDS, accountList1.size());
        }
        Account accountObj = accountList1.get(0);
        Datetime originalDateTime = accountObj.LastModifiedDate;
        
        COHUtil.delay(DELAY);
        
        // Add Notes
        List<Note> noteList = new List<Note>();
        for (Account tempAccountObj : accountList) {
	        Note noteObj = createNoteObject(tempAccountObj.Id);
            noteList.add(noteObj);
        }

        Database.insert(noteList);
        
		accountList1 = [select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordTypeID];
        if (COHUtil.isValidList(accountList1)) {
	        System.assertEquals(MAX_RECORDS, accountList1.size());
            accountObj = accountList1.get(0);
            Datetime newDateTime = accountObj.LastModifiedDate;
            
            System.assert(newDateTime.getTime() >= (originalDateTime.getTime() + DELAY), 
                          'Error: newDatetime (' + newDateTime + ') should be at least ' + DELAY + 
                          			' milliseconds greater than originalDateTime (' + originalDateTime + ')');
        } else {
            System.assert(false, 'Expected ' + MAX_RECORDS + ' records, but retrieved nothing');
        }
        test.stopTest();
    }
    
    /*
     * Create an Note object and assign it the ID of the parent Case object.
     * 
     * @param	parentObjectID	ID of the parent object.
     * @return					Note object
     * 
     */
    private static Note createNoteObject(Id parentObjectID) {
        Note noteObj = new Note();
        noteObj.Title = 'Note Title';
        noteObj.Body = 'Now I know what you\'re thinking...';
        noteObj.ParentId = parentObjectID;   
        return noteObj;
    }
    
    /*
     * Create the Account(s) for Cause Marketing testing.
     * 
     * @param testMode		Indicates if the test mode is for single objects 
     * 						or for bulk testing.
     * @return				List of Account object(s) to insert.
     * 
     */
    private static List<Account> createRecordsCauseMarketing(Integer testMode) {
        
        List<Account> accountList = new List<Account>();
        
        if (testMode == SINGLE_MODE) {
            Account accountObj = new Account();
            accountObj.RecordTypeId = mCauseMarketingRecordTypeID;
            accountObj.Name = ACCOUNT_NAME;
            accountList.add(accountObj); 
        } else {
            for (Integer i = 0; i < MAX_RECORDS; i++) {
                Account accountObj = new Account();
                accountObj.RecordTypeId = mCauseMarketingRecordTypeID;
                accountObj.Name = ACCOUNT_NAME;
                accountList.add(accountObj);
            }
        }
        return accountList;
    }
    
}