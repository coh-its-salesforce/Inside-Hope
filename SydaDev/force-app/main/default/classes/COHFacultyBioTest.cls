/*
 * This class contains utility methods for the New Patient Services project.
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
public class COHFacultyBioTest {

    // Control flow
    private static final Boolean mRunAllTests = true;
    private static final Boolean mRunVerifyUpdate = false;
    private static final Boolean mRunVerifyBulkUpdates = false;
    private static final Boolean mRunVerifyInsert = true;
    private static final Boolean mRunVerifyBulkInserts = false;

    // Test values for the temporary Faculty Bio object

    private static final String EMPLOYEE_ID1 = '8675309';
    private static final String EMPLOYEE_ID2 = '1234567890';
    private static final String TEMP_ABSTRACT = 'abtract value';
    private static final String TEMP_ADD_CHANGES = 'additional changes';
	private static final String TEMP_AWARDS = 'awards';
	private static final String TEMP_BOARD_CERT = 'board certs';
	private static final String TEMP_CARE_TEAM = 'Anesthesiology';
	private static final String TEMP_CLINICAL_FOCUS = 'clinical focus';
	private static final String TEMP_CLINICAL_OVERVIEW = 'clinical overview';
	private static final String TEMP_CLINICAL_SPECIALTIES = 'Anatomic and Clinical Pathology';
    private static final String TEMP_CLINICAL_RESEARCHER = 'Researcher';
	private static final String TEMP_CREDENTIALS = 'D.O.';
	private static final String TEMP_DEGREES = 'MS';
	private static final String TEMP_DISPLAY_EMAIL = 'N';
	private static final String TEMP_EDUCATION = 'US Naval Academy';
	private static final String TEMP_EMAIL_ADDRESS = 'tmagnum@robinsnest.org';
	private static final String TEMP_EXPERT_VOICE = 'expert voice';
	private static final String TEMP_FELLOWSHIPS = 'Cross of Lorraine';
	private static final String TEMP_FIRST_NAME = 'Thomas';
	private static final String TEMP_INTERNSHIPS = 'interships';
	private static final String TEMP_GENDER = 'F';
	private static final String TEMP_LAB_MEMBERS = 'Dr. Jekyll';
    private static final String TEMP_TITLES = 'title';
    private static final String TEMP_COH_INSTITUTION1 = 'Beckman Research Institute';
    private static final String TEMP_COH_INSTITUTION2 = 'COH Medical Center';
    private static final String TEMP_COH_INSTITUTION3 = 'Comprehensive Cancer Center';
    private static final String TEMP_COH_INSTITUTION4 = 'Diabetes & Metabolism Research Institute	';
	private static final String TEMP_LABORATORY = 'laboratory';
	private static final String TEMP_LANGUAGES_SPOKEN = 'Polish';
	private static final String TEMP_LAST_NAME = 'Magnum';
	private static final String TEMP_MEMBERSHIPS = 'memberships';
    private static final String TEMP_MIDDLE_NAME = 'Sullivan';
	private static final String TEMP_OFFICE_PHONE = '555-555-5555';
    private static final String TEMP_PHONE = '555-555-1234';
    private static final String TEMP_POST_DOC_FELLOWSHIPS = 'post doc fellowships';
	private static final String TEMP_PREFERRED_NAME = 'Thomas';
	private static final String TEMP_PRIMARY_LOCATION = 'Arcadia';
    private static final String TEMP_PROFESSIONAL_EXPERIENCE = 'professional experience';
    private static final String TEMP_PUB_MED_URL = 'http://www.magnumpi.com';
	private static final String TEMP_PUBLICATIONS_TEXT = 'publications text';
	private static final String TEMP_RESEARCH_FOCUS = 'research focus';
    private static final String TEMP_RESEARCH_TEAM = 'Cancer Etiology';
    private static final String TEMP_RESEARCH_TEXT = 'research text';
	private static final String TEMP_RESIDENCIES = 'residencies';
    private static final String TEMP_LEFT_COH1 = 'Y';
    private static final String TEMP_LEFT_COH2 = 'N';
    private static final Date TEMP_END_DATE = null;
    private static final Date TEMP_START_DATE = Date.newInstance(2113, 3, 3);
    private static final Date TEMP_START_DATE2 = Date.newInstance(2115, 5, 5);
    
    // Test values for the final Faculty Bio object

    private static final String FINAL_ABSTRACT = 'abtract value1';
    private static final String FINAL_ADD_CHANGES = 'additional changes1';
	private static final String FINAL_AWARDS = 'awards1';
	private static final String FINAL_BOARD_CERT = 'board certs1';
	private static final String FINAL_CARE_TEAM = 'Antelope Valley';
	private static final String FINAL_CLINICAL_FOCUS = 'clinical focus1';
	private static final String FINAL_CLINICAL_OVERVIEW = 'clinical overview1';
	private static final String FINAL_CLINICAL_SPECIALTIES = 'Cardiology';
    private static final String FINAL_CLINICAL_RESEARCHER = 'Staff';
	private static final String FINAL_CREDENTIALS = 'F.A.A.P.';
	private static final String FINAL_DEGREES = 'MS1';
	private static final String FINAL_DISPLAY_EMAIL = 'Y';
	private static final String FINAL_EDUCATION = 'US Naval Academy1';
	private static final String FINAL_EMAIL_ADDRESS = 'tmagnum1@robinsnest.org';
	private static final String FINAL_EXPERT_VOICE = 'expert voice1';
	private static final String FINAL_FELLOWSHIPS = 'Cross of Lorraine1';
	private static final String FINAL_FIRST_NAME = 'ThomasX';
	private static final String FINAL_GENDER = 'M';
	private static final String FINAL_INTERNSHIPS = 'interships1';
	private static final String FINAL_LAB_MEMBERS = 'Mr. Hyde';
	private static final String FINAL_RESIDENCIES = 'residencies1';
	private static final String FINAL_TITLES = 'title1';
    private static final String FINAL_COH_INSTITUTION1 = 'COH Medical Center';
    private static final String FINAL_COH_INSTITUTION2 = 'Comprehensive Cancer Center';
    private static final String FINAL_COH_INSTITUTION3 = 'Diabetes & Metabolism Research Institute';
    private static final String FINAL_COH_INSTITUTION4 = '	Research Shared Resources & Services';
	private static final String FINAL_LABORATORY = 'laboratory1';
	private static final String FINAL_LANGUAGES_SPOKEN = 'Vietnamese';
	private static final String FINAL_LAST_NAME = 'MagnumX';
	private static final String FINAL_MEMBERSHIPS = 'memberships1';
    private static final String FINAL_MIDDLE_NAME = 'Sullivan1';
	private static final String FINAL_OFFICE_PHONE = '555-555-5551';
    private static final String FINAL_PHONE = '555-555-1235';
    private static final String FINAL_POST_DOC_FELLOWSHIPS = 'post doc fellowships1';
	private static final String FINAL_PREFERRED_NAME = 'ThomasX';
	private static final String FINAL_PRIMARY_LOCATION = 'Colton';
    private static final String FINAL_PROFESSIONAL_EXPERIENCE = 'professional experience1';
    private static final String FINAL_PUB_MED_URL = 'http://www.magnumpi1.com';
	private static final String FINAL_PUBLICATIONS_TEXT = 'publications text1';
    private static final String FINAL_RESEARCH_TEAM = 'Comparative Medicine';
	private static final String FINAL_RESEARCH_FOCUS = 'research focus1';
    private static final String FINAL_RESEARCH_TEXT = 'research text1';
    private static final String FINAL_LEFT_COH = 'N';
    private static final Date FINAL_END_DATE = null;
    private static final Date FINAL_START_DATE = Date.newInstance(2114, 4, 4);

	// Miscellaneous values for testing
    	
    private static final String TEST_MODE = 'Test Mode';
    private static final String FOUNDATION = 'Foundation';
    private static final String BOOLEAN_TYPE = 'Boolean';
    private static final String APPROVED_STATUS = 'Approved';
    private static final String PRE_PROCESSING_STATUS = null;		// testing--raymond tam  check on this later
    private static final String FIRST_NAME_FIELD_NAME = 'coh2_firstname__c';
    private static final String DELETE_MARKER_STRING = '<deleted>';
    private static final Date DELETE_MARKER_DATE = Date.newInstance(1800, 1, 1);
    private static final Integer DELETE_MARKER_INTEGER = -99999;
    private static final Integer TEMP_RECORDS_COUNT = 1;
    private static final Integer FINAL_RECORDS_COUNT = 2;
    private static final Integer CONFIG_OBJ_COUNT = 1;
    private static final Integer MAX_RECORDS = 205;
    private static final Integer FACULTY_HISTORY_REC_COUNT = 8;
    
    private static List<COH2_Faculty__c> mTempFacultyObjList = new List<COH2_Faculty__c>();
    private static List<COH2_Faculty_Final__c> mFinalFacultyObjList = new List<COH2_Faculty_Final__c>();
    private static List<COH_App_Configuration__c> mConfigList = new List<COH_App_Configuration__c>();
    
	private static String mGetAllTempFacultyObjListSOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty__c');
	private static String mGetAllFinalFacultyObjListSOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty_Final__c');
    
    /*
     * Verify updates are handled correctly.
     * 
     */
    private static testMethod void verifyUpdate() {
        if (!mRunAllTests && !mRunVerifyUpdate) {
            System.debug('Skipping verifyUpdate()');
            return;
        } 
        
        Test.startTest();

        setConfiguration();
        COHFacultyBioUtil dummyObj = new COHFacultyBioUtil();	// for code coverage
        createFinalRecords();

        // check the list size

		List<COH2_Faculty_Final__c> finalFacultyObjList = Database.query(mGetAllFinalFacultyObjListSOQLQuery);
        if (COHUtil.isValidList(finalFacultyObjList)) {
            Integer recCount = finalFacultyObjList.size();
            System.assertEquals(FINAL_RECORDS_COUNT, recCount);
        } else {
            System.assert(false, 'Expected ' + FINAL_RECORDS_COUNT + ' final records but retrieved no records');
        }
        
        //  insert the temp object

        COH2_Faculty__c tempFacultyBioObj = new COH2_Faculty__c();

        // These values are the same as the final Faculty object
    	tempFacultyBioObj.Name = EMPLOYEE_ID1;
        tempFacultyBioObj.coh2_lastname__c = FINAL_LAST_NAME;
        tempFacultyBioObj.coh2_firstname__c = FINAL_FIRST_NAME;
        tempFacultyBioObj.coh2_gender__c = FINAL_GENDER;
        tempFacultyBioObj.coh2_languagesspoken__c = FINAL_LANGUAGES_SPOKEN;
        tempFacultyBioObj.coh2_memberships__c = FINAL_MEMBERSHIPS;
        tempFacultyBioObj.coh2_preferredname__c = FINAL_PREFERRED_NAME;

        Database.insert(tempFacultyBioObj);
        
        // Update the existing object but without the PENDING_APPROVAL status.
        // Nothing should be updated
        
        tempFacultyBioObj.coh2_firstname__c = TEMP_FIRST_NAME;
        tempFacultyBioObj.coh2_gender__c = TEMP_GENDER;
        tempFacultyBioObj.coh2_languagesspoken__c = DELETE_MARKER_STRING;
        tempFacultyBioObj.coh2_memberships__c = FINAL_MEMBERSHIPS;
        tempFacultyBioObj.coh2_preferredname__c = null;
        tempFacultyBioObj.left_coh__c = TEMP_LEFT_COH1;
        tempFacultyBioObj.start_date__c = TEMP_START_DATE;
        tempFacultyBioObj.status__c = PRE_PROCESSING_STATUS;
        tempFacultyBioObj.coh2_awards__c = TEMP_AWARDS;
        Database.update(tempFacultyBioObj);
        
		String emplid = tempFacultyBioObj.Name;
        
        // verify the changes
        
        String getFinalFacultyObjListSOQLQuery = mGetAllFinalFacultyObjListSOQLQuery + 'where Name = \'' + emplid + '\'';
		finalFacultyObjList = Database.query(getFinalFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(finalFacultyObjList)) {
            System.assert(false, 'Expected a final Faculty object but did not retrieve one');
        }
        
        COH2_Faculty_Final__c finalFacultyObj = finalFacultyObjList.get(0);

        // these should NOT have been updated
        System.assertEquals(FINAL_FIRST_NAME, finalFacultyObj.coh2_firstname__c);
        System.assertEquals(FINAL_GENDER, finalFacultyObj.coh2_gender__c);
        System.assertEquals(FINAL_LANGUAGES_SPOKEN, finalFacultyObj.coh2_languagesspoken__c);
        System.assertEquals(FINAL_LEFT_COH, finalFacultyObj.left_coh__c);
        System.assertEquals(FINAL_MEMBERSHIPS, finalFacultyObj.coh2_memberships__c);
        System.assertEquals(FINAL_START_DATE, finalFacultyObj.start_date__c);
        System.assertEquals(FINAL_AWARDS, finalFacultyObj.coh2_awards__c);

		//  Set the status__c field to PENDING_APPROVAL to invoke the trigger
		
        String mGetTempFacultyObjListSOQLQuery = mGetAllTempFacultyObjListSOQLQuery + 'where Name = \'' + emplid + '\'';
		List<COH2_Faculty__c> tempFacultyObjList = Database.query(mGetTempFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(tempFacultyObjList)) {
            System.assert(false, 'Expected a temp Faculty object but did not retrieve one');
        }
        tempFacultyBioObj = tempFacultyObjList.get(0);
        tempFacultyBioObj.status__c = APPROVED_STATUS;

        Database.update(tempFacultyBioObj);
       
         // verify the changes
        
		finalFacultyObjList = Database.query(getFinalFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(finalFacultyObjList)) {
            System.assert(false, 'Expected a final Faculty object but did not retrieve one');
        }
        
        finalFacultyObj = finalFacultyObjList.get(0);

		// these should have been updated
       
        System.assertEquals(TEMP_DISPLAY_EMAIL, finalFacultyObj.coh2_display_email__c);
        System.assertEquals(TEMP_FIRST_NAME, finalFacultyObj.coh2_firstname__c);
        System.assertEquals(TEMP_GENDER, finalFacultyObj.coh2_gender__c);
        System.assertEquals(null, finalFacultyObj.coh2_languagesspoken__c);
        System.assertEquals(TEMP_LEFT_COH1, finalFacultyObj.left_coh__c);
        System.assertEquals(TEMP_START_DATE, finalFacultyObj.start_date__c);
            
        // these should NOT have been updated
        System.assertEquals(FINAL_LAST_NAME, finalFacultyObj.coh2_lastname__c);
        System.assertEquals(FINAL_PREFERRED_NAME, finalFacultyObj.coh2_preferredname__c);
        System.assertEquals(FINAL_RESEARCH_FOCUS, finalFacultyObj.coh2_researchfocus__c);
        
        // Check the history records

		String historySOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty_History__c');
		List<COH2_Faculty_History__c> historyObjectList = Database.query(historySOQLQuery);
        if (COHUtil.isValidList(historyObjectList)) {
            Integer historyListSize = historyObjectList.size();
	        System.assertEquals(FACULTY_HISTORY_REC_COUNT, historyListSize);
        	COH2_Faculty_History__c historyObj = historyObjectList.get(0);
        	System.assertEquals(finalFacultyObj.Id, historyObj.COH2_Faculty_Approved__c);
        } else {
            System.assert(false, 'Error: expected one history object but retrieved none');
        }

		Boolean recordFound = false;        
        for (COH2_Faculty_History__c facultyHistoryObj: historyObjectList) {
            String fieldName = facultyHistoryObj.COH2_Field__c;
            if (COHUtil.isValidStr(fieldName) && fieldName.equalsIgnoreCase(FIRST_NAME_FIELD_NAME)) {
                recordFound = true;
                String oldName = facultyHistoryObj.COH2_Old_Value__c;
                String newName = facultyHistoryObj.COH2_New_Value__c;
                System.assertEquals(FINAL_FIRST_NAME, oldName);
                System.assertEquals(TEMP_FIRST_NAME, newName);
                break;
            }
        }

        if (!recordFound) {
            System.assert(false, 'Error: field name not found--> ' + FIRST_NAME_FIELD_NAME);
        }
        
		// check more values

		tempFacultyObjList = Database.query(mGetTempFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(tempFacultyObjList)) {
            System.assert(false, 'Expected a temp Faculty object but did not retrieve one');
        }
        tempFacultyBioObj = tempFacultyObjList.get(0);
        tempFacultyBioObj.status__c = APPROVED_STATUS;
        tempFacultyBioObj.start_date__c = DELETE_MARKER_DATE;
        
        Database.update(tempFacultyBioObj);

        // verify the changes
        
		finalFacultyObjList = Database.query(getFinalFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(finalFacultyObjList)) {
            System.assert(false, 'Expected a final Faculty object but did not retrieve one');
        }
        
        finalFacultyObj = finalFacultyObjList.get(0);
        System.assertEquals(null, finalFacultyObj.start_date__c);
          
        Test.stopTest();
    }
 
    /*
     * Verify bulk updates are handled correctly.
     * 
     */
    private static testMethod void verifyBulkUpdates() {
        if (!mRunAllTests && !mRunVerifyBulkUpdates) {
            System.debug('Skipping verifyBulkUpdates()');
            return;
        }
        
        Test.startTest();

		setConfiguration();
        createBulkRecords();
            
		List<COH2_Faculty__c> tempFacultyObjList = Database.query(mGetAllTempFacultyObjListSOQLQuery);
        for (COH2_Faculty__c tempFacultyBioObj : tempFacultyObjList) {
	        tempFacultyBioObj.status__c = APPROVED_STATUS;
        }
        Database.update(tempFacultyObjList);
                        
        // check the list size

		List<COH2_Faculty_Final__c> finalFacultyObjList = Database.query(mGetAllFinalFacultyObjListSOQLQuery);
        if (COHUtil.isValidList(finalFacultyObjList)) {
            Integer recCount = finalFacultyObjList.size();
            System.assertEquals(MAX_RECORDS, recCount);
        } else {
            System.assert(false, 'Expected ' + FINAL_RECORDS_COUNT + ' final records but retrieved no records');
        }
        
        // these should  have been updated
        for (COH2_Faculty_Final__c finalFacultyObj : finalFacultyObjList) {
            System.assertEquals(TEMP_GENDER, finalFacultyObj.coh2_gender__c);
            System.assertEquals(TEMP_LANGUAGES_SPOKEN, finalFacultyObj.coh2_languagesspoken__c);
            System.assertEquals(null, finalFacultyObj.coh2_memberships__c);
        }   
        Test.stopTest();
    }
    
     /*
     * Verify inserts are handled correctly.
     * 
     */
    private static testMethod void verifyInsert() {
        if (!mRunAllTests && !mRunVerifyInsert) {
            System.debug('Skipping verifyInsert()');
            return;
        }

        Test.startTest();

        setConfiguration();
        
        //  insert the temp object

        COH2_Faculty__c tempFacultyBioObj = new COH2_Faculty__c();
        
    	tempFacultyBioObj.Name = EMPLOYEE_ID1;
        tempFacultyBioObj.coh2_firstname__c = TEMP_FIRST_NAME;
        tempFacultyBioObj.coh2_lastname__c = TEMP_LAST_NAME;
        tempFacultyBioObj.coh2_gender__c = TEMP_GENDER;
        tempFacultyBioObj.coh2_languagesspoken__c = TEMP_LANGUAGES_SPOKEN;
        tempFacultyBioObj.coh2_memberships__c = TEMP_MEMBERSHIPS;
        tempFacultyBioObj.coh2_awards__c = TEMP_AWARDS;
        tempFacultyBioObj.status__c = APPROVED_STATUS;
        Database.insert(tempFacultyBioObj);
        
         // verify the changes
        
		List<COH2_Faculty_Final__c> finalFacultyObjList = Database.query(mGetAllFinalFacultyObjListSOQLQuery);
        if (!COHUtil.isValidList(finalFacultyObjList)) {
            System.assert(false, 'Expected a final Faculty object but did not retrieve one');
        }
        
        COH2_Faculty_Final__c finalFacultyObj = finalFacultyObjList.get(0);

		// these should have been updated
       
        System.assertEquals(TEMP_FIRST_NAME, finalFacultyObj.coh2_firstname__c);
        System.assertEquals(TEMP_LAST_NAME, finalFacultyObj.coh2_lastname__c);
        System.assertEquals(TEMP_GENDER, finalFacultyObj.coh2_gender__c);
        System.assertEquals(TEMP_LANGUAGES_SPOKEN, finalFacultyObj.coh2_languagesspoken__c);
        System.assertEquals(TEMP_MEMBERSHIPS, finalFacultyObj.coh2_memberships__c);
        System.assertEquals(EMPLOYEE_ID1,finalFacultyObj.Name );
        System.assertEquals(TEMP_AWARDS, finalFacultyObj.coh2_awards__c);
        // TEMP_FIRST_NAME should have been assigned to the preferred name because the preferred name
        // field is empty.
        System.assertEquals(TEMP_FIRST_NAME, finalFacultyObj.coh2_preferredname__c);
        System.assertEquals(null, finalFacultyObj.coh2_researchfocus__c);
        
        // Check the history records
         
		String historySOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty_History__c');
		List<COH2_Faculty_History__c> historyObjectList = Database.query(historySOQLQuery);
        if (COHUtil.isValidList(historyObjectList)) {
            Integer historyListSize = historyObjectList.size();
	        System.assertEquals(FACULTY_HISTORY_REC_COUNT, historyListSize);
        	COH2_Faculty_History__c historyObj = historyObjectList.get(0);
        	System.assertEquals(finalFacultyObj.Id, historyObj.COH2_Faculty_Approved__c);
        } else {
            System.assert(false, 'Error: expected one history object but retrieved none');
        }

		Boolean recordFound = false;        
        for (COH2_Faculty_History__c facultyHistoryObj: historyObjectList) {
            String fieldName = facultyHistoryObj.COH2_Field__c;
            if (COHUtil.isValidStr(fieldName) && fieldName.equalsIgnoreCase(FIRST_NAME_FIELD_NAME)) {
                recordFound = true;
                String oldName = facultyHistoryObj.COH2_Old_Value__c;
                String newName = facultyHistoryObj.COH2_New_Value__c;
                System.assertEquals(null, oldName);
                System.assertEquals(TEMP_FIRST_NAME, newName);
                break;
            }
        }

        if (!recordFound) {
            System.assert(false, 'Error: field name not found--> ' + FIRST_NAME_FIELD_NAME);
        }
        
        Test.stopTest();
        
    }   
    /*
     * Create the final Faculty objects for testing.
     * 
     */
    private static void createFinalRecords() {
        
        COH2_Faculty_Final__c finalFacultyBioObj1 = new COH2_Faculty_Final__c();

        finalFacultyBioObj1.Name = EMPLOYEE_ID1;
        finalFacultyBioObj1.coh2_abstract__c = FINAL_ABSTRACT;
        finalFacultyBioObj1.additional_changes__c = FINAL_ADD_CHANGES;
        finalFacultyBioObj1.coh2_awards__c = FINAL_AWARDS;
        finalFacultyBioObj1.coh2_boardcerttext__c = FINAL_BOARD_CERT;
        finalFacultyBioObj1.coh2_careteam__c = FINAL_CARE_TEAM;
        finalFacultyBioObj1.coh2_clinicalfocus__c = FINAL_CLINICAL_FOCUS;
        finalFacultyBioObj1.coh2_overviewtext__c = FINAL_CLINICAL_OVERVIEW;
        finalFacultyBioObj1.coh2_clinicalspecialties__c = FINAL_CLINICAL_SPECIALTIES;
        finalFacultyBioObj1.coh2_clinicianorresearcher__c = FINAL_CLINICAL_RESEARCHER;
        finalFacultyBioObj1.coh2_credentials__c = FINAL_CREDENTIALS;
        finalFacultyBioObj1.coh2_degrees2__c = FINAL_DEGREES;
        finalFacultyBioObj1.coh2_display_email__c = FINAL_DISPLAY_EMAIL;
        finalFacultyBioObj1.coh2_education_text__c = FINAL_EDUCATION;
        finalFacultyBioObj1.coh2_emailaddress__c = FINAL_EMAIL_ADDRESS;
        finalFacultyBioObj1.coh2_expert_voice_text__c = FINAL_EXPERT_VOICE;
        finalFacultyBioObj1.coh2_fellowships__c = FINAL_FELLOWSHIPS;
        finalFacultyBioObj1.coh2_firstname__c = FINAL_FIRST_NAME;
        finalFacultyBioObj1.coh2_gender__c = FINAL_GENDER;
        finalFacultyBioObj1.coh2_internships__c = FINAL_INTERNSHIPS;
        finalFacultyBioObj1.coh2_lab_members_text__c = FINAL_LAB_MEMBERS;
        finalFacultyBioObj1.coh2_laboratory_text__c = FINAL_LABORATORY;
        finalFacultyBioObj1.coh2_languagesspoken__c = FINAL_LANGUAGES_SPOKEN;
        finalFacultyBioObj1.coh2_lastname__c = FINAL_LAST_NAME;
        finalFacultyBioObj1.coh2_memberships__c = FINAL_MEMBERSHIPS;
        finalFacultyBioObj1.coh2_middlename__c = FINAL_MIDDLE_NAME;
        finalFacultyBioObj1.coh2_office_phone_no__c = FINAL_OFFICE_PHONE;
        finalFacultyBioObj1.coh2_phoneno__c = FINAL_PHONE;
        finalFacultyBioObj1.coh2_postdocfellowships__c = FINAL_POST_DOC_FELLOWSHIPS;
        finalFacultyBioObj1.coh2_preferredname__c = FINAL_PREFERRED_NAME;
        finalFacultyBioObj1.coh2_primarylocations__c = FINAL_PRIMARY_LOCATION;
        finalFacultyBioObj1.coh2_professional_exp__c = FINAL_PROFESSIONAL_EXPERIENCE;
        finalFacultyBioObj1.coh2_pubmed_url__c = FINAL_PUB_MED_URL;
        finalFacultyBioObj1.coh2_publications_text__c = FINAL_PUBLICATIONS_TEXT;
        finalFacultyBioObj1.coh2_researchfocus__c = FINAL_RESEARCH_FOCUS;
        finalFacultyBioObj1.coh2_researchteam__c = FINAL_RESEARCH_TEAM;
        finalFacultyBioObj1.coh2_researchtext__c = FINAL_RESEARCH_TEXT;
        finalFacultyBioObj1.coh2_residencies__c = FINAL_RESIDENCIES;
        finalFacultyBioObj1.coh2_titles__c = FINAL_TITLES;
        finalFacultyBioObj1.coh_institution_1__c = FINAL_COH_INSTITUTION1;
        finalFacultyBioObj1.coh_institution_2__c = FINAL_COH_INSTITUTION2;
        finalFacultyBioObj1.coh_institution_3__c = FINAL_COH_INSTITUTION3;
        finalFacultyBioObj1.coh_institution_4__c = FINAL_COH_INSTITUTION4;
        finalFacultyBioObj1.end_date__c = FINAL_END_DATE;
        finalFacultyBioObj1.start_date__c = FINAL_START_DATE;
        finalFacultyBioObj1.left_coh__c = FINAL_LEFT_COH;
        finalFacultyBioObj1.status__c = PRE_PROCESSING_STATUS;
        
//        finalFacultyBioObj1.coh_dept_div_prog_center_1__c, coh_dept_div_prog_center_1__c;
//        finalFacultyBioObj1.coh_dept_div_prog_center_2__c, coh_dept_div_prog_center_2__c;
//        finalFacultyBioObj1.coh_dept_div_prog_center_3__c, coh_dept_div_prog_center_3__c;
//        finalFacultyBioObj1.coh_dept_div_prog_center_4__c, coh_dept_div_prog_center_4__c;

        Database.insert(finalFacultyBioObj1);

        COH2_Faculty_Final__c finalFacultyBioObj2 = new COH2_Faculty_Final__c();
        finalFacultyBioObj2.Name = EMPLOYEE_ID2;
        finalFacultyBioObj2.coh2_abstract__c = FINAL_ABSTRACT;
        finalFacultyBioObj2.additional_changes__c = FINAL_ADD_CHANGES;
        finalFacultyBioObj2.coh2_awards__c = FINAL_AWARDS;
        finalFacultyBioObj2.coh2_boardcerttext__c = FINAL_BOARD_CERT;
        finalFacultyBioObj2.coh2_careteam__c = FINAL_CARE_TEAM;
        finalFacultyBioObj2.coh2_clinicalfocus__c = FINAL_CLINICAL_FOCUS;
        finalFacultyBioObj2.coh2_overviewtext__c = FINAL_CLINICAL_OVERVIEW;
        
        Database.insert(finalFacultyBioObj2);
        
    }

    /*
     * Create the Faculty objects for bulk testing.
     * 
     */
    private static void createBulkRecords() {
        
        List<COH2_Faculty__c> tempFacultyObjList = new List<COH2_Faculty__c>();
        
        List<COH2_Faculty_Final__c> finalFacultyObjList = new List<COH2_Faculty_Final__c>();
        
        for (Integer i = 0; i < MAX_RECORDS; i++) {

            COH2_Faculty_Final__c finalFacultyBioObj1 = new COH2_Faculty_Final__c();
            
            String suffix = COHUtil.generateNumberString(i);
            finalFacultyBioObj1.Name = '0001' + suffix;
            finalFacultyBioObj1.coh2_firstname__c = FINAL_FIRST_NAME  + suffix;
            finalFacultyBioObj1.coh2_gender__c = FINAL_GENDER;
            finalFacultyBioObj1.coh2_lastname__c = FINAL_LAST_NAME + suffix;
            finalFacultyBioObj1.coh2_middlename__c = FINAL_MIDDLE_NAME + suffix;
            finalFacultyBioObj1.coh2_gender__c = FINAL_GENDER;
            finalFacultyBioObj1.coh2_languagesspoken__c = FINAL_LANGUAGES_SPOKEN;
            finalFacultyBioObj1.coh2_memberships__c = FINAL_MEMBERSHIPS;
            finalFacultyBioObj1.end_date__c = FINAL_END_DATE;
            finalFacultyBioObj1.start_date__c = FINAL_START_DATE;
            finalFacultyBioObj1.left_coh__c = FINAL_LEFT_COH;            

			finalFacultyObjList.add(finalFacultyBioObj1);
        }		
        Database.insert(finalFacultyObjList);

        for (Integer i = 0; i < MAX_RECORDS; i++) {
            
            COH2_Faculty__c tempFacultyBioObj = new COH2_Faculty__c();
            
            String suffix = COHUtil.generateNumberString(i);
            tempFacultyBioObj.Name = '0001' + suffix;
            tempFacultyBioObj.coh2_firstname__c = TEMP_FIRST_NAME  + suffix;
            tempFacultyBioObj.coh2_gender__c = TEMP_GENDER;
            tempFacultyBioObj.coh2_lastname__c = TEMP_LAST_NAME + suffix;
            tempFacultyBioObj.coh2_middlename__c = TEMP_MIDDLE_NAME + suffix;
            tempFacultyBioObj.coh2_gender__c = TEMP_GENDER;
            tempFacultyBioObj.coh2_languagesspoken__c = TEMP_LANGUAGES_SPOKEN;
            tempFacultyBioObj.coh2_memberships__c = DELETE_MARKER_STRING;
            tempFacultyBioObj.end_date__c = TEMP_END_DATE;
		    tempFacultyBioObj.start_date__c = TEMP_START_DATE;
            tempFacultyBioObj.left_coh__c = TEMP_LEFT_COH1;            
	        tempFacultyBioObj.status__c = APPROVED_STATUS;

            tempFacultyObjList.add(tempFacultyBioObj);
        }
        Database.insert(tempFacultyObjList);
        

    }

    /*
     *  Creates and retrieves the configuration objects for the test environment.
     */
    private static void setConfiguration() {
        
        List<COH_App_Configuration__c> appConfigList = new List<COH_App_Configuration__c>();
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        
		configObj1.Name = TEST_MODE;
        configObj1.Application_Name__c = FOUNDATION;
        configObj1.Value__c = 'true';
        configObj1.Value_Type__c = BOOLEAN_TYPE;
        configObj1.Active__c = true;

        appConfigList.add(configObj1);
        Database.insert(appConfigList);
        
        List<COH_App_Configuration__c> configList = [select Id from COH_App_Configuration__c where active__c = true];
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(CONFIG_OBJ_COUNT, listSize);
        
    }
}