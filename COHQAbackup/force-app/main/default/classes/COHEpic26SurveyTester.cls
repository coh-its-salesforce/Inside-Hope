/*
 * This test class verifies that when the Epic26Survey__c.dateTimeSubmitted
 * field has been updated to a non-null value, the Survey_Submitted__c field has
 * been updated in the corresponding Account object.
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
@isTest 
public class COHEpic26SurveyTester {
    private static final Boolean mRunAllTests = true;
    private static final Boolean mRunVerifyUpdate = true;
    private static final Boolean mRunVerifyTriggerLimits = false;	// Not used because a single lookup must be
																	// made for each record, so this will every time.
	// Test constants and variables
    private static final String mFirstName0 = 'Thomas';
    private static final String mLastName0 = 'Magnum';
    private static final String mCOHMRN0 = '12345678901234';
    private static final String mCOHMRN1 = '43210987654321';
    private static final String mCOHMRNBase = '4321098765';
    private static Id accountId0;

    private static final String mFirstName1 = 'Jonathan';
    private static final String mLastName1 = 'Higgins';
    private static Id accountId1;

    private static Id surveyObjId0;
    private static Id surveyObjId1;
    private static Integer mMaxElements = 205;
    
    //
    // Verify the updates
    // 
    private static testMethod void verifyUpdate() {
        if (!mRunAllTests && !mRunVerifyUpdate) {
            System.debug('Skipping verifyUpdate()');
            return;
        }
        
        createUpdateTestCases();
        
        // verify that the initial conditions are correct
        EPIC26Survey__c surveyObj = [select Id, DateSubmitted__c, COH_MRN__c from EPIC26Survey__c where Id = :surveyObjId0 limit 1] ;
        System.assertEquals(null, surveyObj.DateSubmitted__c);
        System.assertEquals(mCOHMRN0, surveyObj.COH_MRN__c);
        Account accountObj = [select Id, Survey_Submitted__c from Account where Id = :accountId0 limit 1];
        System.assertEquals(null, accountObj.Survey_Submitted__c);
        
        // update the EPIC26Survey__c.DateSubmitted__c field to the current value
        Datetime newDateTime = Datetime.now();
        surveyObj.DateSubmitted__c = newDateTime;
        update(surveyObj);
        accountObj = [select Id, Survey_Submitted__c from Account where Id = :accountId0 limit 1];
        System.assertEquals(accountObj.Survey_Submitted__c, newDateTime);
        
        delete surveyObj;
        delete accountObj;
        
        // verify that the initial conditions are correct
        
        surveyObj = [select Id, DateSubmitted__c from EPIC26Survey__c where Id = :surveyObjId1 limit 1];
        System.assertEquals(surveyObj.DateSubmitted__c, null);
        accountObj = [select Id, Survey_Submitted__c from Account where Id = :accountId1 limit 1];
        System.assertEquals(accountObj.Survey_Submitted__c, null);
        
        // update the EPIC26Survey__c.DateSubmitted__c field to the current value
        
        surveyObj.DateSubmitted__c = null;
        update(surveyObj);
        accountObj = [select Id, Survey_Submitted__c from Account where Id = :accountId1 limit 1];
        System.assertEquals(accountObj.Survey_Submitted__c, null);
        
        delete surveyObj;
        delete accountObj;
        
    }

    //
	// Verify bulk processing    
	// 
    private static testMethod void verifyBulkUpdates() {
        if (!mRunAllTests && !mRunVerifyTriggerLimits) {
            System.debug('Skipping verifyBulkUpdates()');
            return;
        }
        createBulkTestCases();
		List<EPIC26Survey__c> bulkSurveyList = [select Id, DateSubmitted__c from EPIC26Survey__c];
		Datetime newDatetime = Datetime.now();
        for (EPIC26Survey__c surveyObj : bulkSurveyList) {
            surveyObj.DateSubmitted__c = newDatetime;
        }
        update bulkSurveyList;
        
        List<Account> bulkAccountList = [select Id, Survey_Submitted__c from Account];
        if (COHUtil.isValidList(bulkAccountList)) {
            System.assertEquals(bulkSurveyList.size(), bulkAccountList.size());
            for (Account accountObj : bulkAccountList) {
                System.assertEquals(newDatetime, accountObj.Survey_Submitted__c);
            }
        }
    }
    
    //
    // Create test case for the verifyUpdate test
    // 
    private static void createUpdateTestCases() {
        Account accountObj0 = new Account();
        accountObj0.FirstName = mFirstName0;
        accountObj0.LastName = mLastName0;
        accountObj0.COH_MRN__c = mCOHMRN0;
        insert accountObj0;
        accountId0 = accountObj0.Id;
        
        Account accountObj1 = new Account();
        accountObj1.FirstName = mFirstName1;
        accountObj1.LastName = mLastName1;
        accountObj1.COH_MRN__c = mCOHMRN1;
        insert accountObj1;
        accountId1 = accountObj1.Id;
        
        EPIC26Survey__c surveyObj0 = new EPIC26Survey__c();
        surveyObj0.IsPulled__c = false;
        surveyObj0.DateSubmitted__c = null;
        surveyObj0.EPIC26_AccountID__c = accountId0;
        insert surveyObj0;
        surveyObjId0 = surveyObj0.Id;
        
        EPIC26Survey__c surveyObj1 = new EPIC26Survey__c();
        surveyObj1.IsPulled__c = false;
        surveyObj1.DateSubmitted__c = null;
        surveyObj1.EPIC26_AccountID__c = accountId1;
        insert surveyObj1;
        surveyObjId1 = surveyObj1.Id;
    }
    
    //
    // Create test cases for the mRunVerifyTriggerLimits test
    // 
	private static List<EPIC26Survey__c> createBulkTestCases() {
		List<Account> bulkAccountList = new List<Account>();
		for (Integer i = 0; i < mMaxElements; i++) {
            Account accountObj = new Account();
            String suffix = generateNumberString(i);
            accountObj.FirstName = mFirstName0 + suffix;
            accountObj.LastName = mLastName0 + suffix;
            accountObj.Survey_Submitted__c = null;
           accountObj.COH_MRN__c = mCOHMRNBase + suffix;
            bulkAccountList.add(accountObj);
        }
        insert bulkAccountList;
        
		List<EPIC26Survey__c> bulkSurveyList = new List<EPIC26Survey__c>();
		for (Integer i = 0; i < mMaxElements; i++) {
            EPIC26Survey__c surveyObj = new EPIC26Survey__c();
            surveyObj.IsPulled__c = false;
            surveyObj.DateSubmitted__c = null;
            Account accountObj = bulkAccountList.get(i);
            surveyObj.EPIC26_AccountID__c = accountObj.Id;
            bulkSurveyList.add(surveyObj);
        }
        insert bulkSurveyList;
        
        return bulkSurveyList;
    }
    
    //
    // Generate a String for use as a suffix.  For example:
    // 1-->   '0001'
    // 13-->  '0013'
    // 136--> '0137'
    // 
    private static String generateNumberString(Integer val) {
        if (val >= 0 && val < 10) {
            return '00' + val;
        } else if (val >= 10 && val < 100) {
            return '0' + val;
        } else if (val >= 100 && val < 1000) {
            return '0' + val;
        }
        return null;
    }
}