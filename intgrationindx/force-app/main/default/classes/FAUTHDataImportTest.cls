/*
 * This test class verifies the processing of Foundation Authorization recrds
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class FAUTHDataImportTest {
	// COH Config constants    
    private static final String APPLICATION_NAME = 'Foundation';
    private static final String FOUNDATION_AUTH_TYPE = 'Data Import Authorization Type';
    private static final String FOUNDATION_AUTH_TYPE_VAL = 'Foundation Authorization';
    private static final String FOUNDATION_AUTH_DEFAULT_OWNER = 'Default Authorization Owner';
    private static final String FOUNDATION_AUTH_DEFAULT_OWNER_VAL = 'rtam';
    private static final String FOUNDATION_AUTH_DEFAULT_STATUS_VAL = 'New';
    private static final String FOUNDATION_CONFIG_GROUP = 'Locations';
    private static final String STRING_TYPE = 'String';
    private static final String FOUNDATION_LOCATION0 = 'Antelope Valley';
    private static final String FOUNDATION_LOCATION1 = 'Arcadia';
    private static final String FOUNDATION_LOCATION2 = 'Corona';
    private static final String FOUNDATION_LOCATION3= 'Glendora';
    private static final String FOUNDATION_LOCATION4 = 'Mission Hills';
    private static final String FOUNDATION_LOCATION5 = 'Pasadena Clinic-S Raymond';
    private static final String FOUNDATION_LOCATION6 = 'Rancho Cucamonga';
    private static final String FOUNDATION_LOCATION7 = 'Santa Clarita';
    private static final String FOUNDATION_LOCATION8 = 'Simi Valley';
    private static final String FOUNDATION_LOCATION9 = 'South Pasadena - Fair Oaks Drive';
    private static final String FOUNDATION_LOCATION10 = 'West Covina';
    
    private static final Integer CONFIGURATION_OBJ_COUNT = 13;
    
    // Account and Contact constants

    private static final String COH_ACCOUNT_NAME = 'City of Hope National Medical Center';
    private static final String COH_ACCOUNT_TYPE = 'COH Business Accounts';
    private static final String COH_CONTACT_TYPE = 'COH Contacts';
    private static final String COH_FOUNDATION_TYPE = 'Foundation';
    private static final String CONTACT_EMAIL = 'dummyaddress@coh.org';
    private static final String CONTACT_TYPE = 'Physician';
    private static final String CONTACT_DIVISION = 'Hematology';
    private static final String PHYSICIAN_FIRST_NAME0 = 'Elizabeth';
    private static final String PHYSICIAN_LAST_NAME0 = 'Bernardi';
    private static final String PHYSICIAN_FIRST_NAME1 = 'Ji Lian';
    private static final String PHYSICIAN_LAST_NAME1 = 'Cai';
    private static final String PHYSICIAN_FIRST_NAME2 = 'Stanley';
    private static final String PHYSICIAN_LAST_NAME2 = 'Livinigston';
 
        
    // Data Import Records constants
    
    private static final String PROCESSING_TYPE = 'Foundation Authorization';
    private static final String IGNORE_PROCESSING_TYPE = 'New Patient Services';
    
    private static final String ORDER_CREATED = '20151214';
    private static final String PLAN_NAME0 = 'ANTHEM BLUE CROSS/ BLUE SHIELD';
    private static final String PLAN_NAME1 = 'HEALTHCARE PARTNERS - CAP';
    private static final String INSURANCE_NAME0 = 'BlueCross';
    private static final String INSURANCE_NAME1 = 'HCP MED GROUP/PA CONTRACT SPCC';
    private static final String INSURANCE_NAME2 = 'AETNA PPO';		// Not a real value
    private static final String POLICY_NUMBER0 = 'ZZEAN4122199';
    private static final String POLICY_NUMBER1 = 'ZZZ944A63825';
// testing--raymond tam
//    private static final String PRIMARY_INSURANCE_PLAN0 = 'BX-B276';
//    private static final String PRIMARY_INSURANCE_PLAN1 = 'HCPCAP-HCP1';
    private static final String ORDER_NAME0 = 'Follow-up visit in 6 months';
	private static final String ORDER_NAME1 = 'Transrectal US Guided Prostate Bx';
    private static final String ORDER_NAME2 = 'Consult Gastroenterology';
    private static final String PATIENT_MRN0 = '90009254';
    private static final String PATIENT_MRN1 = '99008254';
    private static final String PATIENT_MRN2 = '97708333';
    private static final String PATIENT_MRN3 = '97708888';
    private static final String PATIENT_DOB0 = '19610221';
    private static final String PATIENT_DOB1 = '19610730';
    // testing--raymond tam
    private static final String PATIENT_DOB3 = '19610221';
    private static final String PATIENT_DOB4 = '19600410';

    private static final String PATIENT_NAME0 = 'Calvin, Theodore';
    private static final String PATIENT_FIRST_NAME0 = 'Theodore';
    private static final String PATIENT_LAST_NAME0 = 'Calvin';
    private static final String PATIENT_NAME1 = 'Poole, Maggie';
    private static final String PATIENT_FIRST_NAME1 = 'Maggie';
    private static final String PATIENT_LAST_NAME1 = 'Poole';
    private static final String PATIENT_EXTENDED_NAME1 = 'Poole, Maggie Kimberly Lisa';
    private static final String PATIENT_MIDDLE_NAMES1 = 'Kimberly Lisa';
    private static final String PATIENT_FIRST_NAME2 = 'Jonathan';
    private static final String PATIENT_LAST_NAME2 = 'Higgins';
    // testing--raymond tam
    private static final String PATIENT_FIRST_NAME3 = 'Theodore';
    private static final String PATIENT_LAST_NAME3 = 'Calvin';
    private static final String PATIENT_NAME3 = 'Calvin, Theodore';
    private static final String PATIENT_FIRST_NAME4 = 'Buck';
    private static final String PATIENT_LAST_NAME4 = 'Greene';
    private static final String PATIENT_NAME4 = 'Greene, Buck';
    
    private static final String APPOINTMENT_DATE = '20160215';
    private static final String INITIAL_FACILITY_NAME0 = 'COHMF - Arcadia';
    private static final String INITIAL_FACILITY_NAME1 = 'COHMF - Corona';
    private static final String INITIAL_FACILITY_NAME2 = 'COHMF - Glendora';
    private static final String PERFORMING_COMMENTS0 = 'Comment0';
    private static final String PERFORMING_COMMENTS1 = 'Comment1';
	private static final String AUTH_STATUS0 = 'Needed';
// testing--raymond tam
//  private static final Integer DATA_IMPORT_RECORD_COUNT = 5;
    private static final Integer DATA_IMPORT_RECORD_COUNT_MRN = 5;
    private static final Integer DATA_IMPORT_RECORD_COUNT_COMPOSITE_KEY = 5;

	// Miscellaneous constants

    private static final String MAPPED_INSURANCE_NAME0 = 'Blue Cross Blue Shield PPO';
    private static final String MAPPED_INSURANCE_NAME1 = 'HealthCare Partners';
    private static final String MAPPED_AUTH_STATUS0 = 'Auth. Needed';
    private static final String ACCOUNT = 'Account';
    private static final Integer ACCOUNT_RECORD_COUNT = 3;
    private static final Integer CASE_RECORD_COUNT = 4;
    private static final Integer YEAR_LEFT = 4;
    private static final Integer MONTH_LEFT = 4;
    private static final Integer MONTH_RIGHT = 6;
    private static final Integer DAY_RIGHT = 2;

    private static Id mFoundationAccountID = null;
    private static Id mCOHAccountID = null;
	private static Integer MAX_RECORDS = 203;

    // test flow

    // testing--raymond tam
	private static final Integer MRN_TEST = 0;
	private static final Integer COMPOSITE_KEY_TEST = 1;
    
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyNewRecordsMRN = false;
    private static final Boolean mRunVerifyNewRecordsComposite = true;
    private static final Boolean mRunVerifyBulkLoad = false;

    /*
     * Verifies that the new records were done correctly where the MRN is supplied
     */
    private static testMethod void verifyNewRecordsMRN() {
        if (!mRunAllTests && !mRunVerifyNewRecordsMRN) {
            System.debug('Skipping mRunVerifyNewRecordsMRN()');
            return;
        }
        
        Test.startTest();

// testing--raymond tam        
//        setContacts();
        setContacts(MRN_TEST);
        
        setFoundationAuthorizationConfiguration();

		List<Data_Import_Record__c> dataImportRecordsList = getDataImportRecords();
        Boolean val = COHUtil.isValidList(dataImportRecordsList);
        System.assertEquals(true, val);
        Integer listSize = dataImportRecordsList.size();
        System.assertEquals(DATA_IMPORT_RECORD_COUNT_MRN, listSize);
        Database.insert(dataImportRecordsList);

        // testing--raymond tam
//        String accountSoqlQuery = 'select Id, FirstName, LastName, Middle_Name__c, Insurance__c, COH_MRN__c, PersonBirthdate, ID__c, Medical_Group_IPA__c ' + 
//            'from Account where Id != \'' + mCOHAccountID + '\' order by Id';
        String accountSoqlQuery = 'select Id, FirstName, LastName, Middle_Name__c, Insurance__c, COH_MRN__c, PersonBirthdate, ID__c, Medical_Group_IPA__c ' + 
            'from Account where COH_MRN__c != null and Id != \'' + mCOHAccountID + '\' order by Id';
        List<Account> accountList = Database.query(accountSoqlQuery);
        val = COHUtil.isValidList(accountList);
        System.assertEquals(true, val);
        listSize = accountList.size();
        System.assertEquals(ACCOUNT_RECORD_COUNT, listSize);
        
        Account accountObj = accountList.get(0);
        
        String firstName = accountObj.FirstName;
        String lastName = accountObj.LastName;
        String healthPlan = accountObj.Insurance__c;
        String mrn = accountObj.COH_MRN__c;
        Date dob = accountObj.PersonBirthdate;
        String policyNumber = accountObj.ID__c;
		String medicalGroup = accountObj.Medical_Group_IPA__c;
        
        System.assertEquals(PATIENT_FIRST_NAME2, firstName);	// should have been added as a case to an existing account
        System.assertEquals(PATIENT_LAST_NAME2, lastName);
        System.assertEquals(PATIENT_MRN0, mrn);

        accountObj = accountList.get(1);
        
        firstName = accountObj.FirstName;
        lastName = accountObj.LastName;
        healthPlan = accountObj.Insurance__c;
        mrn = accountObj.COH_MRN__c;
        dob = accountObj.PersonBirthdate;
        policyNumber = accountObj.ID__c;
        medicalGroup = accountObj.Medical_Group_IPA__c;
        
        
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(MAPPED_INSURANCE_NAME1, healthPlan);
        System.assertEquals(PATIENT_MRN1, mrn);
        System.assertEquals(POLICY_NUMBER1, policyNumber);
        System.assertEquals(PLAN_NAME0, medicalGroup);
        
		Date correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob);

        accountObj = accountList.get(2);
        
        firstName = accountObj.FirstName;
        lastName = accountObj.LastName;
        String middleName = accountObj.Middle_Name__c;
        healthPlan = accountObj.Insurance__c;
        mrn = accountObj.COH_MRN__c;
        dob = accountObj.PersonBirthdate;
        policyNumber = accountObj.ID__c;
		medicalGroup = accountObj.Medical_Group_IPA__c;
  
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(PATIENT_MIDDLE_NAMES1, middleName);
        System.assertEquals(INSURANCE_NAME2, healthPlan);
        System.assertEquals(PATIENT_MRN2, mrn);
        System.assertEquals(POLICY_NUMBER1, policyNumber);
        System.assertEquals(PLAN_NAME0, medicalGroup);
        
		correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob);

		// Order by ID to get them sorted by the insertion order        
        String casesSoqlQuery = 'select Id, Caller_First_Name__c, Caller_Last_Name__c, CC_Primary_insurance__c, ' + 
            'COH_MRN__c, DOB__c, Auth_Status__c, FAUTH_Order_Name__c, Ordering_Physician__c, ' + 
            'Location__c, Appt_Date__c, Notes__c ' +
            'from Case order by Id';

        List<Case> casesList = Database.query(casesSoqlQuery);
        val = COHUtil.isValidList(casesList);
        System.assertEquals(true, val);
        listSize = casesList.size();
        System.assertEquals(CASE_RECORD_COUNT, listSize);

        Case caseObj = casesList[0];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        mrn = caseObj.COH_MRN__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        String authStatus = caseObj.Auth_Status__c;
        String orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME0, orderName);
		String mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION1, mappedLocation);
        Date appointmentDate = caseObj.Appt_Date__c;
		correctDate = createDateObject(APPOINTMENT_DATE);
        System.assertEquals(correctDate, appointmentDate);
        String notes = caseObj.Notes__c;
        System.assertEquals(PERFORMING_COMMENTS0, notes);
		        
        Id physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        List<Contact> physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        Boolean physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME0) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME0)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        // First case had an existing account with no health plan, authorization status,
        // DOB, or service type
        System.assertEquals(PATIENT_FIRST_NAME0, firstName);
        System.assertEquals(PATIENT_LAST_NAME0, lastName);
        System.assertEquals(PATIENT_MRN0, mrn);
        
        // verify the Contact record was successfully associated with the Case
        Case tempCaseObj = [select AccountId, ContactId, Id, Caller_First_Name__c, Caller_Last_Name__c from case where Id = :caseObj.Id limit 1];
        if (tempCaseObj == null) {
            System.assert(false, 'Unable to retrieve the case object');
        }
        Contact tempContactObj = [select AccountId, Id from contact where AccountId = :tempCaseObj.AccountId limit 1];
        System.assertEquals(tempContactObj.Id, tempCaseObj.ContactId);

        caseObj = casesList[1];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        mrn = caseObj.COH_MRN__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        authStatus = caseObj.Auth_Status__c;
        orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME1, orderName);
		mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION2, mappedLocation);
        appointmentDate = caseObj.Appt_Date__c;
		correctDate = createDateObject(APPOINTMENT_DATE);
        System.assertEquals(correctDate, appointmentDate);
        notes = caseObj.Notes__c;
        System.assertEquals(PERFORMING_COMMENTS1, notes);

        physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME1) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME1)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(PATIENT_MRN1, mrn);
        System.assertEquals(MAPPED_INSURANCE_NAME1, healthPlan);
        System.assertEquals(MAPPED_AUTH_STATUS0, authStatus);

		correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob); 

        // verify the Contact record was successfully associated with the Case
        tempCaseObj = [select AccountId, ContactId, Id, Caller_First_Name__c, Caller_Last_Name__c from case where Id = :caseObj.Id limit 1];
        if (tempCaseObj == null) {
            System.assert(false, 'Unable to retrieve the case object');
        }
        tempContactObj = [select AccountId, Id from contact where AccountId = :tempCaseObj.AccountId limit 1];
        System.assertEquals(tempContactObj.Id, tempCaseObj.ContactId);

        
        caseObj = casesList[2];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        mrn = caseObj.COH_MRN__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        authStatus = caseObj.Auth_Status__c;
        orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME2, orderName);
		mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION3, mappedLocation);
        appointmentDate = caseObj.Appt_Date__c;
        System.assertEquals(appointmentDate, null);
        notes = caseObj.Notes__c;
        System.assertEquals(null, notes);
		
        physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME1) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME1)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(PATIENT_MRN1, mrn);
        System.assertEquals(MAPPED_INSURANCE_NAME1, healthPlan);
        System.assertEquals(MAPPED_AUTH_STATUS0, authStatus);

		correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob); 
        
        caseObj = casesList[3];
        
		physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId == null);
        
        // Verify that the original Data_Import_Record__c objects have been deleted
        List<Data_Import_Record__c> dirList = [select id from Data_Import_Record__c];
        if (COHUtil.isValidList(dirList)) {
            System.assert(true, 'Expected 0 records, retrieved: " + dirList.size()');
        }
        Test.stopTest();
    }
    
    /*
     * Verifies that the new records were done correctly where the MRN is NOT supplied.
     * Instead, a composite unique key is used.  This key consists of the first name, last name,
     * and birthdate.
     */
    private static testMethod void verifyNewRecordsComposite() {
        if (!mRunAllTests && !mRunVerifyNewRecordsComposite) {
            System.debug('Skipping mRunVerifyNewRecordsComposite()');
            return;
        }
        
        Test.startTest();

        setContacts(COMPOSITE_KEY_TEST);
        setFoundationAuthorizationConfiguration();
        
        List<Data_Import_Record__c> dataImportRecordsList = getDataImportRecords();
        Boolean val = COHUtil.isValidList(dataImportRecordsList);
        System.assertEquals(true, val);
        Integer listSize = dataImportRecordsList.size();
        System.assertEquals(DATA_IMPORT_RECORD_COUNT_COMPOSITE_KEY, listSize);
        Database.insert(dataImportRecordsList);

        String accountSoqlQuery = 'select Id, FirstName, LastName, Middle_Name__c, Insurance__c, COH_MRN__c, PersonBirthdate, ID__c, Medical_Group_IPA__c ' + 
            'from Account where COH_MRN__c = null and FirstName = \'' + PATIENT_FIRST_NAME3 + '\' and Id != \'' + mCOHAccountID + '\' order by Id';
        List<Account> accountList = Database.query(accountSoqlQuery);
        val = COHUtil.isValidList(accountList);
        System.assertEquals(true, val);
        listSize = accountList.size();
        System.assertEquals(1, listSize);
        
        Account accountObj = accountList.get(0);
        
        String firstName = accountObj.FirstName;
        String lastName = accountObj.LastName;
        String healthPlan = accountObj.Insurance__c;
        Date dob = accountObj.PersonBirthdate;
        String policyNumber = accountObj.ID__c;
		String medicalGroup = accountObj.Medical_Group_IPA__c;
        
        System.assertEquals(PATIENT_FIRST_NAME3, firstName);	// should have been added as a case to an existing account
        System.assertEquals(PATIENT_LAST_NAME3, lastName);
		Date correctDate = createDateObject(PATIENT_DOB3);
        System.assertEquals(correctDate, dob);
        

        // Order by ID to get them sorted by the insertion order        
        String casesSoqlQuery = 'select Id, Caller_First_Name__c, Caller_Last_Name__c, CC_Primary_insurance__c, ' + 
            'COH_MRN__c, DOB__c, Auth_Status__c, FAUTH_Order_Name__c, Ordering_Physician__c, ' + 
            'Location__c, Appt_Date__c, Notes__c ' +
            'from Case order by Id';

        List<Case> casesList = Database.query(casesSoqlQuery);
        val = COHUtil.isValidList(casesList);
        System.assertEquals(true, val);
        listSize = casesList.size();
        System.assertEquals(CASE_RECORD_COUNT, listSize);

        Case caseObj = casesList[0];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        String authStatus = caseObj.Auth_Status__c;
        String orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME0, orderName);
		String mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION1, mappedLocation);
        Date appointmentDate = caseObj.Appt_Date__c;
		correctDate = createDateObject(APPOINTMENT_DATE);
        System.assertEquals(correctDate, appointmentDate);
        String notes = caseObj.Notes__c;
        System.assertEquals(PERFORMING_COMMENTS0, notes);
		        
        Id physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        List<Contact> physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        Boolean physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME0) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME0)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        // First case had an existing account with no health plan, authorization status,
        // DOB, or service type
        System.assertEquals(PATIENT_FIRST_NAME0, firstName);
        System.assertEquals(PATIENT_LAST_NAME0, lastName);
        
        // verify the Contact record was successfully associated with the Case
        Case tempCaseObj = [select AccountId, ContactId, Id, Caller_First_Name__c, Caller_Last_Name__c from case where Id = :caseObj.Id limit 1];
        if (tempCaseObj == null) {
            System.assert(false, 'Unable to retrieve the case object');
        }
        Contact tempContactObj = [select AccountId, Id from contact where AccountId = :tempCaseObj.AccountId limit 1];
        System.assertEquals(tempContactObj.Id, tempCaseObj.ContactId);

        caseObj = casesList[1];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        authStatus = caseObj.Auth_Status__c;
        orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME1, orderName);
		mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION2, mappedLocation);
        appointmentDate = caseObj.Appt_Date__c;
		correctDate = createDateObject(APPOINTMENT_DATE);
        System.assertEquals(correctDate, appointmentDate);
        notes = caseObj.Notes__c;
        System.assertEquals(PERFORMING_COMMENTS1, notes);

        physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME1) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME1)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(MAPPED_INSURANCE_NAME1, healthPlan);
        System.assertEquals(MAPPED_AUTH_STATUS0, authStatus);

		correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob); 

        // verify the Contact record was successfully associated with the Case
        tempCaseObj = [select AccountId, ContactId, Id, Caller_First_Name__c, Caller_Last_Name__c from case where Id = :caseObj.Id limit 1];
        if (tempCaseObj == null) {
            System.assert(false, 'Unable to retrieve the case object');
        }
        tempContactObj = [select AccountId, Id from contact where AccountId = :tempCaseObj.AccountId limit 1];
        System.assertEquals(tempContactObj.Id, tempCaseObj.ContactId);

        
        caseObj = casesList[2];
        
        firstName = caseObj.Caller_First_Name__c;
        lastName = caseObj.Caller_Last_Name__c;
        dob = caseObj.DOB__c;
        healthPlan = caseObj.CC_Primary_insurance__c;
        authStatus = caseObj.Auth_Status__c;
        orderName = caseObj.FAUTH_Order_Name__c;
		System.assertEquals(ORDER_NAME2, orderName);
		mappedLocation = caseObj.Location__c;
		System.assertEquals(FOUNDATION_LOCATION3, mappedLocation);
        appointmentDate = caseObj.Appt_Date__c;
        System.assertEquals(appointmentDate, null);
        notes = caseObj.Notes__c;
        System.assertEquals(null, notes);
		
        physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId != null);
        
        physicianList = [select Id, FirstName, LastName from Contact where Id = :physicianId];
        if (!COHUtil.isValidList(physicianList)) {
            System.assert(false, 'No physician matched: ' + physicianId);
        }
        physicianFound = false;
        for (Contact physicianObj : physicianList) {
            String physicianFirstName = physicianObj.FirstName;
            String physicianLastName = physicianObj.LastName;
			if (physicianFirstName.equalsIgnoreCase(PHYSICIAN_FIRST_NAME1) &&
                physicianLastName.equalsIgnoreCase(PHYSICIAN_LAST_NAME1)) {
                    physicianFound = true;
                    break;
            }        
        }
        
        if (!physicianFound) {
            String msg = 'No physician matching name found for ID: ' + physicianId +
                '\nFirst Name: ' + PHYSICIAN_FIRST_NAME1 +
                '\nLast Name: ' + PHYSICIAN_LAST_NAME1;
            System.assert(false, msg);
        }
        
        System.assertEquals(PATIENT_FIRST_NAME1, firstName);
        System.assertEquals(PATIENT_LAST_NAME1, lastName);
        System.assertEquals(MAPPED_INSURANCE_NAME1, healthPlan);
        System.assertEquals(MAPPED_AUTH_STATUS0, authStatus);

		correctDate = createDateObject(PATIENT_DOB1);
        System.assertEquals(correctDate, dob); 
        
        caseObj = casesList[3];
        
		physicianId = caseObj.Ordering_Physician__c;
        System.assert(physicianId == null);
        
        // Verify that the original Data_Import_Record__c objects have been deleted
        List<Data_Import_Record__c> dirList = [select id from Data_Import_Record__c];
        if (COHUtil.isValidList(dirList)) {
            System.assert(true, 'Expected 0 records, retrieved: " + dirList.size()');
        }
        Test.stopTest();
    }
    
    /*
     * Verifies that the bulk load of new records were done correctly.
     */
    private static testMethod void verifyBulkLoad() {
        if (!mRunAllTests && !mRunVerifyBulkLoad) {
            System.debug('Skipping verifyBulkLoad()');
            return;
        }
        
        Test.startTest();

// testing--raymond tam        
//        setContacts();
        setContacts(MRN_TEST);
        
        setFoundationAuthorizationConfiguration();
        
        List<Data_Import_Record__c> dataImportRecordsList = getBulkDataImportRecords();
        Boolean val = COHUtil.isValidList(dataImportRecordsList);
        System.assertEquals(true, val);
        Integer listSize = dataImportRecordsList.size();
        System.assertEquals(MAX_RECORDS, listSize);
        Database.insert(dataImportRecordsList);

    }

    /*
     * Create a Date object from a String.  The String will be in this format:  YYYYMMDD
     * 
     * @param	dateString		String representation of the date
     * @return					Date object created from the dateString argument.
     * 
     */
    private static Date createDateObject(String dateString) {
		Date dateObj = null;
        if (COHUtil.isValidStr(dateString)) {
            Integer year = Integer.valueOf(dateString.left(YEAR_LEFT));
            Integer month = Integer.valueOf(dateString.substring(MONTH_LEFT, MONTH_RIGHT));
            Integer day = Integer.valueOf(dateString.right(DAY_RIGHT));
            dateObj = Date.newInstance(year, month, day);
        }
        return dateObj;
    }
    
    
    /*
     * Create the Data Import Record objects for testing.  
     * 
     * THESE ARE INTEGRALLY LINKED WITH THE "FOUNDATION_AUTH_MAP.SDL" MAPPING
     * FILE USED BY THE DATALOADER FOR LOADING FOUNDATION AUTHORIZATION RECORDS.
     * 
     */
    private static List<Data_Import_Record__c> getDataImportRecords() {
        
        Data_Import_Record__c dirObj0 = new Data_Import_Record__c();
        dirObj0.Processing_Type__c = PROCESSING_TYPE;
        dirObj0.Text_255_00__c = PHYSICIAN_FIRST_NAME0 + ' ' + PHYSICIAN_LAST_NAME0;
        dirObj0.Text_255_01__c = ORDER_CREATED;
        dirObj0.Text_255_02__c = PATIENT_MRN0;
        dirObj0.Text_255_03__c = PATIENT_NAME0;
        dirObj0.Text_255_04__c = PATIENT_DOB0;
        dirObj0.Text_255_05__c = INITIAL_FACILITY_NAME0;
        dirObj0.Text_255_06__c = POLICY_NUMBER0;
        dirObj0.Text_255_07__c = INSURANCE_NAME0;
		dirObj0.Text_255_08__c = APPOINTMENT_DATE;        
        dirObj0.Text_2048_00__c = AUTH_STATUS0;
        dirObj0.Text_2048_01__c = ORDER_NAME0;  
        dirObj0.Text_2048_02__c = PLAN_NAME0;  
        dirObj0.Text_16384_00__c = PERFORMING_COMMENTS0;
        
        Data_Import_Record__c dirObj1 = new Data_Import_Record__c();
        dirObj1.Processing_Type__c = PROCESSING_TYPE;
        dirObj1.Text_255_00__c = PHYSICIAN_FIRST_NAME1.toLowerCase() + ' ' + PHYSICIAN_LAST_NAME1;
        dirObj1.Text_255_01__c = ORDER_CREATED;
        dirObj1.Text_255_02__c = PATIENT_MRN1;
        dirObj1.Text_255_03__c = PATIENT_NAME1;
        dirObj1.Text_255_04__c = PATIENT_DOB1;
        dirObj1.Text_255_05__c = INITIAL_FACILITY_NAME1;
        dirObj1.Text_255_06__c = POLICY_NUMBER1;
        dirObj1.Text_255_07__c = INSURANCE_NAME1;
		dirObj1.Text_255_08__c = APPOINTMENT_DATE;        
        dirObj1.Text_2048_00__c = AUTH_STATUS0;
        dirObj1.Text_2048_01__c = ORDER_NAME1;  
        dirObj1.Text_2048_02__c = PLAN_NAME0;  
        dirObj1.Text_16384_00__c = PERFORMING_COMMENTS1;

        Data_Import_Record__c dirObj2 = new Data_Import_Record__c();
        dirObj2.Processing_Type__c = PROCESSING_TYPE;
        dirObj2.Text_255_00__c = PHYSICIAN_FIRST_NAME1 + ' ' + PHYSICIAN_LAST_NAME1;
        dirObj2.Text_255_01__c = ORDER_CREATED;
        dirObj2.Text_255_02__c = PATIENT_MRN1;
        dirObj2.Text_255_03__c = PATIENT_NAME1;
        dirObj2.Text_255_04__c = PATIENT_DOB1;
        dirObj2.Text_255_05__c = INITIAL_FACILITY_NAME2;
        dirObj2.Text_255_06__c = POLICY_NUMBER1;
        dirObj2.Text_255_07__c = INSURANCE_NAME1;
        dirObj2.Text_2048_00__c = AUTH_STATUS0;
        dirObj2.Text_2048_01__c = ORDER_NAME2;  
        dirObj2.Text_2048_02__c = PLAN_NAME1;  

        Data_Import_Record__c dirObj3 = new Data_Import_Record__c();
        dirObj3.Processing_Type__c = PROCESSING_TYPE;
        // This physician should not be found in the Contacts
        dirObj3.Text_255_00__c = PHYSICIAN_FIRST_NAME2 + ' ' + PHYSICIAN_LAST_NAME2;
        dirObj3.Text_255_01__c = ORDER_CREATED;
        dirObj3.Text_255_02__c = PATIENT_MRN2;
        dirObj3.Text_255_03__c = PATIENT_EXTENDED_NAME1;
        dirObj3.Text_255_04__c = PATIENT_DOB1;
        dirObj3.Text_255_06__c = POLICY_NUMBER1;
        dirObj3.Text_255_07__c = INSURANCE_NAME2;
        dirObj3.Text_2048_00__c = AUTH_STATUS0;
        dirObj3.Text_2048_01__c = ORDER_NAME1;  
        dirObj3.Text_2048_02__c = PLAN_NAME0;  
        
        // This one should be ignored
        Data_Import_Record__c dirObj4 = new Data_Import_Record__c();
        dirObj4.Processing_Type__c = IGNORE_PROCESSING_TYPE;
        // This physician should not be found in the Contacts
        dirObj4.Text_255_00__c = PHYSICIAN_FIRST_NAME2 + ' ' + PHYSICIAN_LAST_NAME2;
        dirObj4.Text_255_01__c = ORDER_CREATED;
        dirObj4.Text_255_02__c = PATIENT_MRN3;
        dirObj4.Text_255_03__c = PATIENT_EXTENDED_NAME1;
        dirObj4.Text_255_04__c = PATIENT_DOB1;
//        dirObj4.Text_255_05__c = PRIMARY_INSURANCE_PLAN1;
        dirObj4.Text_255_06__c = POLICY_NUMBER1;
        dirObj4.Text_255_07__c = INSURANCE_NAME0;
        dirObj4.Text_2048_00__c = AUTH_STATUS0;
        dirObj4.Text_2048_01__c = ORDER_NAME1;  
        dirObj4.Text_2048_02__c = PLAN_NAME0;  

		// testing--raymond tam
        Data_Import_Record__c dirObj5 = new Data_Import_Record__c();
        dirObj5.Processing_Type__c = PROCESSING_TYPE;
        dirObj5.Text_255_00__c = PHYSICIAN_FIRST_NAME1 + ' ' + PHYSICIAN_LAST_NAME1;
        dirObj5.Text_255_01__c = ORDER_CREATED;
        dirObj5.Text_255_03__c = PATIENT_NAME3;
        dirObj5.Text_255_04__c = PATIENT_DOB3;
        dirObj5.Text_255_05__c = INITIAL_FACILITY_NAME2;
        dirObj5.Text_255_06__c = POLICY_NUMBER1;
        dirObj5.Text_255_07__c = INSURANCE_NAME1;
        dirObj5.Text_2048_00__c = AUTH_STATUS0;
        dirObj5.Text_2048_01__c = ORDER_NAME2;  
        dirObj5.Text_2048_02__c = PLAN_NAME1;  
        
        
		List<Data_Import_Record__c> dataImportRecordsList = new List<Data_Import_Record__c>();
        dataImportRecordsList.add(dirObj0);
        dataImportRecordsList.add(dirObj1);
        dataImportRecordsList.add(dirObj2);
        dataImportRecordsList.add(dirObj3);
        dataImportRecordsList.add(dirObj4);
        
        return dataImportRecordsList;
    }

    /*
     * Create the Data Import Record objects for bulk testing.  
     * 
     * THESE ARE INTEGRALLY LINKED WITH THE "FOUNDATION_AUTH_MAP.SDL" MAPPING
     * FILE USED BY THE DATALOADER FOR LOADING FOUNDATION AUTHORIZATION RECORDS.
     * 
     */
    private static List<Data_Import_Record__c> getBulkDataImportRecords() {
        
        List<Data_Import_Record__c> dataImportRecordsList = new List<Data_Import_Record__c>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            String mrn = String.valueOf(i);
            Data_Import_Record__c dirObj = new Data_Import_Record__c();
            dirObj.Processing_Type__c = PROCESSING_TYPE;
            dirObj.Text_255_00__c = PHYSICIAN_FIRST_NAME0 + ' ' + PHYSICIAN_LAST_NAME0;
            dirObj.Text_255_01__c = ORDER_CREATED;
            dirObj.Text_255_02__c = mrn;
            dirObj.Text_255_03__c = PATIENT_NAME0;
            dirObj.Text_255_04__c = PATIENT_DOB0;
            dirObj.Text_255_06__c = POLICY_NUMBER0;
            dirObj.Text_255_07__c = INSURANCE_NAME0;
            dirObj.Text_2048_00__c = AUTH_STATUS0;
            dirObj.Text_2048_01__c = ORDER_NAME0;  
            dirObj.Text_2048_02__c = PLAN_NAME0;  
            dataImportRecordsList.add(dirObj);
        }
        return dataImportRecordsList;
    }
    
    /*
     * Create and insert all Contacts for testing.
     * 
     */
	// testing--raymond tam    
/*
    private static void setContacts() {
        // testing--raymond tam
//        Account accountObj = getFoundationAccountRecords();
//        Database.insert(accountObj);
        List<Account> accountObjList = getFoundationAccountRecords();
        Database.insert(accountObjList);
        Account COHaccountObj = getCOHAccountRecord();
        Database.insert(COHaccountObj);
        mCOHAccountID = COHaccountObj.Id;
        List<Contact> contactRecordsList = getContactRecords(mCOHAccountID);
        Database.insert(contactRecordsList);
    }
*/  

    private static void setContacts(Integer testType) {
        List<Account> accountObjList = getFoundationAccountRecords(testType);
        Database.insert(accountObjList);
        Account COHaccountObj = getCOHAccountRecord();
        Database.insert(COHaccountObj);
        mCOHAccountID = COHaccountObj.Id;
        List<Contact> contactRecordsList = getContactRecords(mCOHAccountID);
        Database.insert(contactRecordsList);
    }
    
    /*
     * Create the COH Account object for testing.  
     * 
     */
    private static Account getCOHAccountRecord() {
        
        Id accountTypeID = COHUtil.getRecordType('Account', COH_ACCOUNT_TYPE);
        Account accountObj = new Account();
        accountObj.RecordTypeId = accountTypeID;
        accountObj.Name = COH_ACCOUNT_NAME;
        return accountObj;
    }        

    
    /*
     * Create the Person Account objects for testing.  
     * 
     */
// testing--raymond tam
/*
    private static List<Account> getFoundationAccountRecords() {
        
        List<Account> accountObjList = new List<Account>();
        Id accountTypeID = COHUtil.getRecordType('Account', COH_FOUNDATION_TYPE);

        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = accountTypeID;
        accountObj0.FirstName = PATIENT_FIRST_NAME2;
        accountObj0.LastName = PATIENT_LAST_NAME2;
       	accountObj0.COH_MRN__c = PATIENT_MRN0;
        
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = accountTypeID;
        accountObj1.FirstName = PATIENT_FIRST_NAME3;
        accountObj1.LastName = PATIENT_LAST_NAME3;
        accountObj1.PersonBirthdate = createDateObject(PATIENT_DOB3);
        
        Account accountObj2 = new Account();
        accountObj2.RecordTypeId = accountTypeID;
        accountObj2.FirstName = PATIENT_FIRST_NAME4;
        accountObj2.LastName = PATIENT_LAST_NAME4;
        accountObj2.PersonBirthdate = createDateObject(PATIENT_DOB4);
        
        accountObjList.add(accountObj0);
        accountObjList.add(accountObj1);
        accountObjList.add(accountObj2);
        
        return accountObjList;
    }            
*/

    private static List<Account> getFoundationAccountRecords(Integer testType) {
        List<Account> accountObjList = new List<Account>();
        Id accountTypeID = COHUtil.getRecordType('Account', COH_FOUNDATION_TYPE);

        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = accountTypeID;
        accountObj0.FirstName = PATIENT_FIRST_NAME2;
        accountObj0.LastName = PATIENT_LAST_NAME2;
        if (testType == MRN_TEST) {
       		accountObj0.COH_MRN__c = PATIENT_MRN0;
        }
        
        Account accountObj1 = new Account();
        accountObj1.RecordTypeId = accountTypeID;
        accountObj1.FirstName = PATIENT_FIRST_NAME3;
        accountObj1.LastName = PATIENT_LAST_NAME3;
        accountObj1.PersonBirthdate = createDateObject(PATIENT_DOB3);
        
        Account accountObj2 = new Account();
        accountObj2.RecordTypeId = accountTypeID;
        accountObj2.FirstName = PATIENT_FIRST_NAME4;
        accountObj2.LastName = PATIENT_LAST_NAME4;
        accountObj2.PersonBirthdate = createDateObject(PATIENT_DOB4);
        
        accountObjList.add(accountObj0);
        accountObjList.add(accountObj1);
        accountObjList.add(accountObj2);
        
        return accountObjList;
    }            
    
    /*
     * Create the Contact objects for testing. 
     * 
     * @param	accountRecordID		ID of the parent COH account. 
     * 
     */
    private static List<Contact> getContactRecords(Id accountRecordID) {
        
        Id contactRecordTypeID = COHUtil.getRecordType('Contact', COH_CONTACT_TYPE);
            
        Contact contactObj0 = new Contact();
        contactObj0.AccountId = accountRecordID;
        contactObj0.RecordTypeId = contactRecordTypeID;
        contactObj0.FirstName = PHYSICIAN_FIRST_NAME0;
        contactObj0.LastName = PHYSICIAN_LAST_NAME0;
        contactObj0.Email = CONTACT_EMAIL;
        contactObj0.Type__c = CONTACT_TYPE;
        contactObj0.Division__c = CONTACT_DIVISION;

        Contact contactObj1 = new Contact();
        contactObj1.AccountId = accountRecordID;
        contactObj1.RecordTypeId = contactRecordTypeID;
        contactObj1.FirstName = PHYSICIAN_FIRST_NAME1;
        contactObj1.LastName = PHYSICIAN_LAST_NAME1;
        contactObj1.Email = CONTACT_EMAIL;
        contactObj1.Type__c = CONTACT_TYPE;
        contactObj1.Division__c = CONTACT_DIVISION;

        List<Contact> contactRecordsList = new List<Contact>();
        contactRecordsList.add(contactObj0);
        contactRecordsList.add(contactObj1);
        
        return contactRecordsList;
    }    
    
    /*
     * Insert configuration objects for the Foundation Authorization test environment.  
     * Test.startTest() and Test.stopTest() must be invoked by the caller.
     */
    private static void setFoundationAuthorizationConfiguration() {
        List<COH_App_Configuration__c> configList = getCOHAppConfiguration();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(CONFIGURATION_OBJ_COUNT, listSize);
        Database.insert(configList);
    }
        
    /*
     *  Creates and retrieves the configuration objects for the Foundation Authorization test environment.
     */
    private static List<COH_App_Configuration__c> getCOHAppConfiguration() {
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = APPLICATION_NAME;
		configObj0.Name = FOUNDATION_AUTH_TYPE;
        configObj0.Value__c = FOUNDATION_AUTH_TYPE_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;

        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = APPLICATION_NAME;
		configObj1.Name = FOUNDATION_AUTH_DEFAULT_OWNER;
        configObj1.Value__c = FOUNDATION_AUTH_DEFAULT_OWNER_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = APPLICATION_NAME;
		configObj2.Name = FOUNDATION_LOCATION0;
        configObj2.Value__c = FOUNDATION_LOCATION0;		// Dummy value isn't used
        configObj2.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = APPLICATION_NAME;
		configObj3.Name = FOUNDATION_LOCATION1;
        configObj3.Value__c = FOUNDATION_LOCATION1;		// Dummy value isn't used
        configObj3.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj3.Value_Type__c = STRING_TYPE;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = APPLICATION_NAME;
		configObj4.Name = FOUNDATION_LOCATION2;
        configObj4.Value__c = FOUNDATION_LOCATION2;		// Dummy value isn't used
        configObj4.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = APPLICATION_NAME;
		configObj5.Name = FOUNDATION_LOCATION3;
        configObj5.Value__c = FOUNDATION_LOCATION3;		// Dummy value isn't used
        configObj5.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj5.Value_Type__c = STRING_TYPE;
        configObj5.Active__c = true;

        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
        configObj6.Application_Name__c = APPLICATION_NAME;
		configObj6.Name = FOUNDATION_LOCATION4;
        configObj6.Value__c = FOUNDATION_LOCATION4;		// Dummy value isn't used
        configObj6.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj6.Value_Type__c = STRING_TYPE;
        configObj6.Active__c = true;

        COH_App_Configuration__c configObj7 = new COH_App_Configuration__c();
        configObj7.Application_Name__c = APPLICATION_NAME;
		configObj7.Name = FOUNDATION_LOCATION5;
        configObj7.Value__c = FOUNDATION_LOCATION5;		// Dummy value isn't used
        configObj7.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj7.Value_Type__c = STRING_TYPE;
        configObj7.Active__c = true;

        COH_App_Configuration__c configObj8 = new COH_App_Configuration__c();
        configObj8.Application_Name__c = APPLICATION_NAME;
		configObj8.Name = FOUNDATION_LOCATION6;
        configObj8.Value__c = FOUNDATION_LOCATION6;		// Dummy value isn't used
        configObj8.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj8.Value_Type__c = STRING_TYPE;
        configObj8.Active__c = true;

        COH_App_Configuration__c configObj9 = new COH_App_Configuration__c();
        configObj9.Application_Name__c = APPLICATION_NAME;
		configObj9.Name = FOUNDATION_LOCATION7;
        configObj9.Value__c = FOUNDATION_LOCATION7;		// Dummy value isn't used
        configObj9.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj9.Value_Type__c = STRING_TYPE;
        configObj9.Active__c = true;

        COH_App_Configuration__c configObj10 = new COH_App_Configuration__c();
        configObj10.Application_Name__c = APPLICATION_NAME;
		configObj10.Name = FOUNDATION_LOCATION8;
        configObj10.Value__c = FOUNDATION_LOCATION8;		// Dummy value isn't used
        configObj10.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj10.Value_Type__c = STRING_TYPE;
        configObj10.Active__c = true;

        COH_App_Configuration__c configObj11 = new COH_App_Configuration__c();
        configObj11.Application_Name__c = APPLICATION_NAME;
		configObj11.Name = FOUNDATION_LOCATION9;
        configObj11.Value__c = FOUNDATION_LOCATION9;		// Dummy value isn't used
        configObj11.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj11.Value_Type__c = STRING_TYPE;
        configObj11.Active__c = true;

        COH_App_Configuration__c configObj12 = new COH_App_Configuration__c();
        configObj12.Application_Name__c = APPLICATION_NAME;
		configObj12.Name = FOUNDATION_LOCATION10;
        configObj12.Value__c = FOUNDATION_LOCATION10;		// Dummy value isn't used
        configObj12.Configuration_Group__c = FOUNDATION_CONFIG_GROUP;
        configObj12.Value_Type__c = STRING_TYPE;
        configObj12.Active__c = true;

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);        
        configList.add(configObj4);        
        configList.add(configObj5);        
        configList.add(configObj6);        
        configList.add(configObj7);        
        configList.add(configObj8);        
        configList.add(configObj9);        
        configList.add(configObj10);        
        configList.add(configObj11);        
        configList.add(configObj12);        
        return configList;
        
    }
}