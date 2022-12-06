/*
* This test class verifies the functionality of the COHEpicLightningController.  
* 
* Raymond Tam
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
@isTest
public class COHEpicLightningControllerTest {
    
    private static final Boolean mRunAllTests = true;
    private static final Boolean mRunVerifyCreateNoURL = true;
    private static final Boolean mRunVerifyCreateWithURL = true;
    private static final Boolean mRunVerifyUpdateNoURL = true;
    private static final Boolean mRunVerifyUpdateWithURL = true;
    
    private static final String INVALID_CASE_ID = '10009000004aGSUAA2';
    private static final String DUMMY_URL  = 'www.flandersfieldsXYZ.com';
    private static final String DUMMY_USERNAME  = 'test$username';
    private static final String DUMMY_PASSWORD  = 'carneasada';
    
    
    // Account constants
    private static final String ACCOUNT_PATIENT_STATUS_NEW = 'New';
    private static final String ACCOUNT_PATIENT_STATUS_IN_PROGRESS = 'In Progress';
    private static final String ACCOUNT_STATUS_REASON = 'This is a test';   // To comply with a Validation Rule
    
    // Case constants
    private static final String CASE_ORIGIN = 'ACD';
    private static final String CASE_ACTION_TAKEN = 'EMAIL SENT';
    private static final String CASE_STATUS_NEW = 'New';
    private static final String CASE_STATUS_CLOSED = 'Closed';
    private static final String CASE_APPLICATION_TAKEN = 'APPLICATION TAKEN';
    private static final String CASE_WARM_HANDOFF_YES = 'Yes';
    
    private static final String EPIC_CREATE_URL_KEY = 'Epic_Create_Patient_Endpoint_URL';
    private static final String EPIC_UPDATE_URL_KEY = 'Epic_Update_Patient_Endpoint_URL';
    
    // Test constants
    private static final Id mPSUAccountRecordType = [select Id,name from RecordType where name = 'Patient (Screen Unification)' and SObjectType = 'Account' limit 1].Id;
    private static final Id mPRSCaseRecordType = [select Id,name from RecordType where name = 'Patient Referral Services' and SObjectType = 'Case' limit 1].Id;
    private static final Id mContractsCaseRecordType = [select Id,name from RecordType where name = 'Contracts' and SObjectType = 'Case' limit 1].Id;
    
    // Field constants
    private static final String FIRST_NAME0 = 'MaggieTest';
    private static final String LAST_NAME0 = 'Poole';
    private static final String FIRST_NAME1 = 'ThomasTest';
    private static final String LAST_NAME1 = 'Magnum';
    private static final String FIRST_NAME2 = 'JonathanTest';
    private static final String LAST_NAME2 = 'Higgins';
    private static final String FIRST_NAME3 = 'ThomasTest';
    private static final String LAST_NAME3 = 'Calvin';
    private static final String DEPARTMENT_ID = 'COHCC';
    private static final String DEPARTMENT_TYPE = 'DEPID';
    private static final String MALE = 'Male';
    private static final String FEMALE = 'Female';
    private static final String STREET = '22131 Robyn Lane';
    private static final String CITY = 'Honolulu';
    private static final String STATE = 'Hawaii';               
    private static final String POSTAL_CODE = '99999';
    private static final String COUNTY = 'Oahu';
    private static final String COUNTRY = 'United States of America';
    private static final String EMAIL0 = 'mpoole6@robynsnest.com';
    private static final String EMAIL1 = 'tmagnum5@robynsnest.com';
    private static final String HOME_PHONE_TYPE = 'Home Phone';
    private static final String HOME_PHONE0 = '222-555-1212';
    private static final String HOME_PHONE1 = '222-555-1233';
    private static final String WORK_PHONE_TYPE = 'Work Phone';
    private static final String WORK_PHONE0 = '333-555-1313';
    private static final String WORK_PHONE1 = '333-555-1344';
    private static final String MOBILE_PHONE_TYPE = 'Mobile';
    private static final String MOBILE_PHONE0 = '444-555-1414';
    private static final String MOBILE_PHONE1 = '444-555-1455';
    private static final String MRN1 = '991219X';
    private static final String PRIMARY_PHONE_HOME = 'Home';
    private static final Integer RECORD_COUNT1 = 1;
    
    private static Id mCaseObjectID0;
    private static Id mCaseObjectID1;
    private static Id mCaseObjectID2;
    private static Id mCaseObjectID3;
    private static Id mAccountObjectID0;
    private static Id mAccountObjectID1;
    private static Id mAccountObjectID2;
    private static Date mDOB0 = Date.newInstance(2018, 2, 12);
    private static Date mDOB1 = Date.newInstance(2009, 1, 13);
    private static String mSSN0;
    private static String mSSN1;
    private static String mSSN2;
    
    /*
* Verify the creation of an Epic record where there is no URL for creating the record.
* 
*/
    private static testMethod void verifyCreateNoURL() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        if (!mRunAllTests && !mRunVerifyCreateNoURL) {
            System.debug('Skipping verifyCreateNoURL()');
            return;
        }
        
        Test.startTest();
        
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(null, null);
        
        Boolean exceptionFlag = false;
        try {
            COHEpicLightningController.createNewEpicRecord(null);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        System.assertEquals(false, exceptionFlag);  // Changed because throwing the exception was
        // temporarily commented out.
        
        // Random ID of a non-existent record
        exceptionFlag = false;
        try {
            COHEpicLightningController.createNewEpicRecord(INVALID_CASE_ID);
        } catch (Exception e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        // temporarily removed
        // Case does not have a parent Account
        /*
exceptionFlag = false;
try {
COHEpicLightningController.createNewEpicRecord(mCaseObjectID2);
} catch (AuraHandledException e) {
exceptionFlag = true;
}
System.assertEquals(true, exceptionFlag);  
*/
        // For code coverage because webservice callouts are not supported during tests.
        String mrn = COHEpicLightningController.createNewEpicRecord(mCaseObjectID0);
        System.assertEquals('true', mrn);
        
        // Already has a MRN assigned        
        exceptionFlag = false;
        try {
            mrn = COHEpicLightningController.createNewEpicRecord(mCaseObjectID1);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        // Yet more code coverage
        exceptionFlag = false;
        try {
            COHEpicLightningController.simpleTextPost(mCaseObjectID0, 'test'); 
        } catch (Exception e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        COHEpicLightningController.PatientIDs foo = new COHEpicLightningController.PatientIDs();
        foo.ID = 'test0';
        foo.Type_z = 'test1';
        COHEpicLightningController.PatientInformation bar =  new COHEpicLightningController.PatientInformation();
        bar.PatientIDs = new List<COHEpicLightningController.PatientIDs>{foo};
            
            Test.stopTest();
    }
    
    /*
* Verify the creation of an Epic record where there is an existing URL for updating the record.
* 
*/
    private static testMethod void verifyCreateWithURL() {
        
        if (!mRunAllTests && !mRunVerifyCreateWithURL) {
            System.debug('Skipping verifyCreateWithURL()');
            return;
        }
        
        Test.startTest();
        
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(DUMMY_URL, DUMMY_URL);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean exceptionFlag = false;
        try {
            COHEpicLightningController.createNewEpicRecord(null);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        // Random ID of a non-existent record
        exceptionFlag = false;
        try {
            COHEpicLightningController.createNewEpicRecord(INVALID_CASE_ID);
        } catch (Exception e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        // Case does not have a parent Account
        exceptionFlag = false;
        try {
            COHEpicLightningController.createNewEpicRecord(mCaseObjectID2);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        // For code coverage because webservice callouts are not supported during tests.
        
        /* String mrn = COHEpicLightningController.createNewEpicRecord(mCaseObjectID0);

System.assertEquals(null, mrn);*/
        
        // Already has a MRN assigned        
        exceptionFlag = false;
        try {
            COHEpicLightningController.setTestEpicLoginCredentials(DUMMY_USERNAME, DUMMY_PASSWORD);
            String    mrn = COHEpicLightningController.createNewEpicRecord(mCaseObjectID1);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        Test.stopTest();
        String mrn = COHEpicLightningController.createNewEpicRecord(mCaseObjectID0);
        COHEpicLightningController.SplitArray('Test;Test;');
        // System.assertEquals(null, mrn);
        
    }
    
    /*
* Verify the update of an Epic record  where there is no URL for creating the record.
* 
*/
    private static testMethod void verifyUpdateNoURL() {
        if (!mRunAllTests && !mRunVerifyUpdateNoURL) {
            System.debug('Skipping verifyUpdateNoURL()');
            return;
        }
        
        Test.startTest();
        
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(null, null);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(null);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        String epicUpdateURL = COHEpicLightningController.getTextConfigurationValue(EPIC_UPDATE_URL_KEY);
        
        System.assertEquals(false, exceptionFlag);
        
        // Invalid ID
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(INVALID_CASE_ID);
        } catch (Exception e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID2);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        // No MRN was supplied, so it should not be updated
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID0);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        // Case does not have a parent Account
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mCaseObjectID2);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID1);
        
        Test.stopTest();
    }
    
    /*
* Verify the update of an Epic record  where there is an existing URL for updating the record.
* 
*/
    private static testMethod void verifyUpdateWithURL() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        if (!mRunAllTests && !mRunVerifyUpdateWithURL) {
            System.debug('Skipping verifyUpdateWithURL()');
            return;
        }
        
        Test.startTest();
        
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(DUMMY_URL, DUMMY_URL);
        
        Boolean exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(null);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        String epicUpdateURL = COHEpicLightningController.getTextConfigurationValue(EPIC_UPDATE_URL_KEY);
        
        System.assertEquals(true, exceptionFlag);
        
        // Invalid ID
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(INVALID_CASE_ID);
        } catch (Exception e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID2);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        // No MRN was supplied, so it should not be updated
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID0);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        
        System.assertEquals(true, exceptionFlag);
        
        // Case does not have a parent Account
        exceptionFlag = false;
        try {
            COHEpicLightningController.updateExistingEpicRecord(mCaseObjectID2);
        } catch (AuraHandledException e) {
            exceptionFlag = true;
        }
        System.assertEquals(true, exceptionFlag);
        
        COHEpicLightningController.setTestEpicLoginCredentials(DUMMY_USERNAME, DUMMY_PASSWORD);
        COHEpicLightningController.updateExistingEpicRecord(mAccountObjectID1);
        
        Test.stopTest();
    }
    
    //START: changes by Sanjay 03/01/2022
    private static testMethod void createNewEpicRecordViaAccountTest() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Test.startTest();
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(null, null);
        UPDATE new Account(COH_MRN__c=null,Id=mAccountObjectID1);
        String mrn = COHEpicLightningController.createNewEpicRecordViaAccount(mAccountObjectID1);
        System.assertEquals('true', mrn);
        UPDATE new Account(Patient_Street1__c='sample',PersonEmail='abc@gmail.com',
                           Patient_City__c='sample',
                           COH_PA_State__c='Alabama',
                           Patient_Postal_Code__c='sample',Relationship_to_Patient__c='Brother',
                           COH_Account_PatientAccess_Marital_Status__c='Single ',
                           COH_PA_Country__c='United States of America',Id=mAccountObjectID1);
        INSERT new Epic_Account_Data__c(Account__c=mAccountObjectID1,
                                        Authorization_number_1__c='54646',
                                        //Patient_Relationship_to_Subscriber_1__c='Self',
                                        Subscriber_ID_1__c = '12312',
                                        Insurance_Street_1__c = '12312',
                                        Insurance_Subscriber_First_Name_1__c   = 'TestFirstName',
                                        Insurance_Subscriber_Last_Name_1__c  = 'TestLastName',
                                        Insurance_City_1__c   = 'asdas',
                                        //Insurance_State_1__c  = 'California',                                        
                                        Group_Number_1_c__c   = 'asdas',
                                        //Insurance_Country_1__c = 'United States of America',
                                        Insurance_SSN_1__c='123-45-4567',
                                        Insurance_PostalCode_1__c = '20001',
                                        Insurance_Gender_1__c = 'Male',
                                        Insurance_Birth_Date_1__c = Date.today().addYears(-20),
                                        Guarantor1_FirstName__c   = 'asd',
                                        Guarantor1_LastName__c = 'adas',
                                        Guarantor1_SSN__c='123-45-4568',          
                                        Guarantor1_Street__c  = 'dsasd',
                                        //Guarantor1_State__c   = 'California',  
                                        //Guarantor1_Country__c = 'United States of America'          
                                        Guarantor1_City__c  = 'Duarte',     
                                        Guarantor1_PostalCode__c  = '20001');
        COHEpicLightningController.verifyAccountCreateEpicMRNButton(mAccountObjectID1);
        Test.stopTest();
    }
    
    private static testMethod void createNewEpicRecordViaAccountTest2() {   
        createRecords();    
        Test.startTest();   
        COHEpicLightningController.setTestEpicEndPointURLS(DUMMY_URL, DUMMY_URL);   
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());   
        try{    
            COHEpicLightningController.createNewEpicRecordViaAccount(mAccountObjectID0);    
        } catch(Exception e){   
                
        }   
            
        Test.stopTest();    
    }
    private static testMethod void verifyCreateEpicMRNButtonTest() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Test.startTest();
        createRecords();
        COHEpicLightningController.setTestEpicEndPointURLS(null, null);
        UPDATE new Account(COH_MRN__c=null,Id=mAccountObjectID1);
        String mrn = COHEpicLightningController.createNewEpicRecordViaAccount(mAccountObjectID1);
        System.assertEquals('true', mrn);
        UPDATE new Account(Patient_Street1__c='sample',PersonEmail='abc@gmail.com',
                           Patient_City__c='sample',
                           COH_PA_State__c='Alabama',
                           Patient_Postal_Code__c='sample',Relationship_to_Patient__c='Brother',
                           COH_Account_PatientAccess_Marital_Status__c='Single ',
                           COH_PA_Country__c='United States of America',Id=mAccountObjectID1);
        INSERT new Epic_Account_Data__c(Account__c=mAccountObjectID1,
                                        Authorization_number_1__c='54646',
                                        //Patient_Relationship_to_Subscriber_1__c='Self',
                                        Subscriber_ID_1__c = '12312',
                                        Insurance_Street_1__c = '12312',
                                        Insurance_Subscriber_First_Name_1__c   = 'TestFirstname2',
                                        Insurance_Subscriber_Last_Name_1__c   = 'TestLastname2',
                                        Insurance_City_1__c   = 'asdas',
                                        Group_Number_1_c__c   = 'asdas',
                                        //Insurance_State_1__c  = 'California',
                                        Insurance_Country_1__c = 'United States of America',
                                        Insurance_SSN_1__c='123-45-4567',
                                        Insurance_PostalCode_1__c = '20001',
                                        Insurance_Gender_1__c = 'Male',
                                        Insurance_Birth_Date_1__c = Date.today().addYears(-20),
                                        Guarantor1_FirstName__c   = 'asd',
                                        Guarantor1_LastName__c = 'adas',
                                        Guarantor1_SSN__c='123-45-4568',          
                                        Guarantor1_Street__c  = 'dsasd',
                                        //Guarantor1_State__c   = 'California',            
                                        Guarantor1_City__c  = 'Duarte',    
                                        //Guarantor1_Country__c = 'United States of America',
                                        Guarantor1_PostalCode__c  = '20001');
        COHEpicLightningController.verifyCreateEpicMRNButton(mCaseObjectID1);
        Test.stopTest();
    }
    //END: changes by Sanjay 03/01/2022  
    
    
    
    
    /*
* Create the Account and Case objects for testing.
* 
*/
    private static void createRecords() {
        
        // Create unique SSNs
        Datetime curDatetime = Datetime.now();
        String msStr = String.valueOf(curDatetime.getTime());
        String baseSSN = msStr.right(9);
        mSSN0 = baseSSN.substring(0, 3) + '-' + baseSSN.substring(3, 5) + '-' + baseSSN.substring(5, 9);
        
        curDatetime = Datetime.now();
        msStr = String.valueOf(curDatetime.getTime());
        baseSSN = msStr.right(9);
        mSSN1 = baseSSN.substring(0, 3) + '-' + baseSSN.substring(3, 5) + '-' + baseSSN.substring(5, 9);
        
        curDatetime = Datetime.now();
        msStr = String.valueOf(curDatetime.getTime());
        baseSSN = msStr.right(9);
        mSSN2 = baseSSN.substring(0, 3) + '-' + baseSSN.substring(3, 5) + '-' + baseSSN.substring(5, 9);
        
        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = mPSUAccountRecordType;
        accountObj0.FirstName = FIRST_NAME0;
        accountObj0.LastName = LAST_NAME0;
        accountObj0.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj0.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj0.COH_Account_PatientAccess_SSN__c = mSSN0;       
        accountObj0.PersonBirthdate = mDOB0;
        accountObj0.Gender__pc = FEMALE;
        accountObj0.street__pc = STREET;
        accountObj0.City__pc = CITY;
        accountObj0.State__pc = STATE;
        accountObj0.Postal_Code__pc = POSTAL_CODE;
        accountObj0.Country__pc = COUNTRY;
        accountObj0.Email__c = EMAIL0;
        accountObj0.PersonHomePhone = HOME_PHONE0;
        accountObj0.Phone = WORK_PHONE0;
        accountObj0.PersonMobilePhone = MOBILE_PHONE0;
        accountObj0.Primary_Phone_Number__c = PRIMARY_PHONE_HOME;
        
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = mPSUAccountRecordType;
        accountObj1.FirstName = FIRST_NAME1;
        accountObj1.LastName = LAST_NAME1;
        accountObj1.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj1.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj1.COH_Account_PatientAccess_SSN__c = mSSN1;
        accountObj1.PersonBirthdate = mDOB1;
        accountObj1.Gender__pc = MALE;
        accountObj1.street__pc = STREET;
        accountObj1.City__pc = CITY;
        accountObj1.State__pc = STATE;
        accountObj1.Postal_Code__pc = POSTAL_CODE;
        accountObj1.Country__pc = COUNTRY;
        accountObj1.Email__c = EMAIL0;
        accountObj1.PersonHomePhone = HOME_PHONE1;
        accountObj1.Phone = WORK_PHONE1;
        accountObj1.PersonMobilePhone = MOBILE_PHONE1;
        accountObj1.COH_MRN__c = MRN1;
        accountObj1.Primary_Phone_Number__c = PRIMARY_PHONE_HOME;
        
        Account accountObj2 = new Account();
        accountObj2.RecordTypeId = mPSUAccountRecordType;
        accountObj2.FirstName = FIRST_NAME2;
        accountObj2.LastName = LAST_NAME2;
        accountObj2.Patient_Status__c = ACCOUNT_PATIENT_STATUS_IN_PROGRESS;
        accountObj2.Status_Reason__c = ACCOUNT_STATUS_REASON;
        accountObj2.COH_Account_PatientAccess_SSN__c = mSSN2;
        accountObj2.PersonBirthdate = mDOB1;
        accountObj2.Gender__pc = MALE;
        accountObj2.street__pc = STREET;
        accountObj2.City__pc = CITY;
        accountObj2.State__pc = STATE;
        accountObj2.Postal_Code__pc = POSTAL_CODE;
        accountObj2.Country__pc = COUNTRY;
        accountObj2.Email__c = EMAIL0;
        accountObj2.PersonHomePhone = HOME_PHONE1;
        accountObj2.Phone = WORK_PHONE1;
        accountObj2.PersonMobilePhone = MOBILE_PHONE1;
        accountObj2.Primary_Phone_Number__c = PRIMARY_PHONE_HOME;
        
        List<Account> accountsToInsert = new List<Account> {accountObj0, accountObj1, accountObj2};
            insert accountsToInsert;
        
        mAccountObjectID0 = accountObj0.Id;
        mAccountObjectID1 = accountObj1.Id;
        mAccountObjectID2 = accountObj2.Id;
        
        // Contact ID is required because of a validation rule.  The rule checks for 
        // Contact.Account.COH_MRN__c.  The validation rule checks for the MRN in the 
        // parent object because the COH_MRN__c field will not be copied until after
        // the Case is saved. 
        Contact contactObj0 = [select Id, AccountId from Contact where AccountId = :mAccountObjectID0 limit 1];
        Contact contactObj1 = [select Id, AccountId from Contact where AccountId = :mAccountObjectID1 limit 1];
        Contact contactObj2= [select Id, AccountId from Contact where AccountId = :mAccountObjectID2 limit 1];
        
        Case caseObj0 = new Case();
        caseObj0.RecordTypeId = mPRSCaseRecordType;
        caseObj0.Origin = CASE_ORIGIN;       
        caseObj0.Action_Taken__c = CASE_ACTION_TAKEN;               
        caseObj0.Status = CASE_STATUS_NEW;
        caseObj0.Caller_First_Name__c = FIRST_NAME2;
        caseObj0.Caller_Last_Name__c = LAST_NAME2;
        caseObj0.AccountId = mAccountObjectID0;
        caseObj0.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj0.ContactId = contactObj0.Id;
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = mPRSCaseRecordType;
        caseObj1.Origin = CASE_ORIGIN;       
        caseObj1.Action_Taken__c = CASE_ACTION_TAKEN;
        caseObj1.Status = CASE_STATUS_NEW;
        caseObj1.Caller_First_Name__c = FIRST_NAME3;
        caseObj1.Caller_Last_Name__c = LAST_NAME3;
        caseObj1.AccountId = mAccountObjectID1;
        caseObj1.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj1.ContactId = contactObj1.Id;
        
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = mPRSCaseRecordType;
        caseObj2.Origin = CASE_ORIGIN;       
        caseObj2.Action_Taken__c = CASE_ACTION_TAKEN;
        caseObj2.Status = CASE_STATUS_NEW;
        caseObj2.Caller_First_Name__c = FIRST_NAME2;
        caseObj2.Caller_Last_Name__c = LAST_NAME3;
        caseObj2.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        
        Case caseObj3 = new Case();
        caseObj3.RecordTypeId = mPRSCaseRecordType;
        caseObj3.Origin = CASE_ORIGIN;       
        caseObj3.Action_Taken__c = CASE_ACTION_TAKEN;
        caseObj3.Status = CASE_STATUS_NEW;
        caseObj3.Caller_First_Name__c = FIRST_NAME3;
        caseObj3.Caller_Last_Name__c = LAST_NAME3;
        caseObj3.AccountId = mAccountObjectID2;
        caseObj3.Warm_Handoff__c = CASE_WARM_HANDOFF_YES;
        caseObj3.ContactId = contactObj2.Id;
        List<Case> casesToInsert = new List<Case>{caseObj0, caseObj1, caseObj2, caseObj3};
            insert casesToInsert;
        
        mCaseObjectID0 = caseObj0.Id;
        mCaseObjectID1 = caseObj1.Id;
        mCaseObjectID2 = caseObj2.Id;
        mCaseObjectID3 = caseObj3.Id;
    }
    
}