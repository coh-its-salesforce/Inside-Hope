/*
 * This test class verifies the functionality of the ITSAssetRequest__c
 * trigger.  
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
public class COHITSAssetRequestTest {
    private static final Boolean mRunVerifyUpdate0 = true;
    private static final Boolean mRunVerifyUpdate1 = false;
    private static final Boolean mRunVerifyUpdate2 = false;
    private static final Boolean mRunVerifyUpdate3 = false;
    private static final Boolean mRunVerifyUpdate4 = false;
    private static final Boolean mRunVerifyUpdate5 = false;
    private static final Boolean mRunVerifyUpdate6 = false;
    private static final Boolean mRunVerifyUpdate7 = false;
    private static final Boolean mRunVerifyUpdate8 = false;
    private static final Boolean mRunVerifyBulkUpdates = false;
    private static final Boolean mRunAllTests = true;

    // Configuration constants
    private static final String ITS_ASSET_REQUEST_APPLICATION = 'ITS Asset Request';
    private static final String RIVERGRADE_LOCATION = 'Rivergrade';
    private static final String RIVERGRADE_LOCATION_VAL = 'Rivergrade';
    private static final String FOUNDATION_LOCATION = 'Mayflower';
    private static final String FOUNDATION_LOCATION_VAL = 'Mayflower';
    private static final String INCIDENT_SOURCE = 'Incident Source';
    private static final String INCIDENT_SOURCE_VAL = 'Email';
    private static final String TEST_MODE = 'Test Mode';
    private static final String TEST_MODE_VAL = 'true';
    private static final String DUARTE_DESKTOP_SUPPORT_QUEUE = 'Duarte Desktop Support';
    private static final String RIVERGRADE_DESKTOP_SUPPORT_QUEUE = 'Rivergrade Desktop Support';
    private static final String FOUNDATION_DESKTOP_SUPPORT_QUEUE = 'Foundation Desktop Support';
    private static final String TELECOM_QUEUE = 'Telecom';
    private static final String ASSET_MANAGEMENT_QUEUE = 'Asset Management';
    private static final String INFORMATION_SECURITY_QUEUE = 'Information Security';
    
    private static final String STRING_TYPE = 'String';
    private static final String BOOLEAN_TYPE = 'Boolean';
    
    // Constants for creating a new ITS Asset Request object
    private static final Boolean USER_ACTIVE_STATUS = true;
    private static final String USER_TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String USER_LOCALE_SID_KEY = 'en_US';
    private static final String USER_EMAIL_ENCODING_KEY = 'ISO-8859-1';
    private static final String USER_LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String USER_TITLE = 'P.I.';
    private static final String USER_EMPLOYEE_NUMBER = '99999999';
    private static final String USER_DEPARTMENT_NAME = 'ITS';

    // ITS Asset Reuqest constants
    private static final String PHONE_EXTENSION = '1111';
    private static final String JUSTIFICATION = 'Test justification';
    private static final String CHART_STRING = 'Test chart string';
    private static final String CHART_STRING_ACCOUNT = 'Test chart string account';
    private static final String COMPUTER_TAG = 'BSS1701C';
	private static final String DESKTOP_SUPPORT_HARDWARE = 'Desktop support: special hardware';
	private static final String ASSET_MANAGEMENT_SOFTWARE = 'test additional software';
	private static final String NETWORK_FOLDER_ACCESS = 'Need a network folder';
    
    // ITS Asset Request picklist constants
    private static final String HARDWARE_DESKTOP_COMPUTER = 'Desktop Computer (All-In-One-Desktop)';
    private static final String HARDWARE_LAPTOP_ONLY = 'Laptop Only (Incl. bag)	';
    private static final String HARDWARE_LAPTOP_ALL = 'Laptop (Include Bag, 24 In. Monitor,Mouse,KeyBoard and Docking Station)';
    private static final String HARDWARE_EXISTING_COMPUTER = 'Existing Computer (Tag # Required)';
    private static final String MOBILE_PHONE_NEW = 'Mobile Phone: New';
    private static final String MOBILE_PHONE_EXISTING = 'Mobile Phone: Existing Phone Available';
    private static final String DESKTOP_PHONE_NEW = 'Desktop Phone New Install';
    private static final String DESKTOP_PHONE_EXISTING = 'Desktop Phone Existing Phone Available';
    
    // User constants
    private static final String USER_FIRST_NAME0 = 'Thomas';
    private static final String USER_LAST_NAME0 = 'Magnum';
    private static final String USER_LOCATION0 = 'Duarte Campus';
    private static final String USER_NAME0 = 'thomassullivanmagnumiv09@coh.org';
    private static final String USER_ALIAS0 = 'tmagXX';
    private static final String USER_EMAIL0 = 'thomassullivanmagnumiv09@coh.org';
    
    private static final String USER_FIRST_NAME1 = 'Maggie';
    private static final String USER_LAST_NAME1 = 'Poole';
    private static final String USER_LOCATION1 = 'Rivergrade Penitentiary';
    private static final String USER_NAME1 = 'maggiepoole09@coh.org';
    private static final String USER_ALIAS1 = 'magXX';
    private static final String USER_EMAIL1 = 'maggiepoole09@coh.org';

    private static final String USER_FIRST_NAME2 = 'Jonathan';
    private static final String USER_LAST_NAME2 = 'Higgins';
    private static final String USER_LOCATION2 = 'Mayflower Bldg.';
    private static final String USER_NAME2 = 'jonqhiggins09@coh.org';
    private static final String USER_ALIAS2 = 'jhiXX';
    private static final String USER_EMAIL2 = 'jqhiggins09@coh.org';
    private static final String USER_PHONE2 = '818-555-1212';
    
    private static final String USER_FIRST_NAME3 = 'COH233';
    private static final String USER_LAST_NAME3 = 'foobar';
    private static final String USER_LOCATION3 = 'Mayflower Bldg.';
    private static final String USER_NAME3 = 'coh233@coh.org';
    private static final String USER_ALIAS3 = 'coh233xx';
    private static final String USER_EMAIL3 = 'coh233xxx@coh.org';
    
    // Constants for testing
	private static final String NUMERIC_CHARS = '0123456789';
    private static final String SPACE = ' ';
    private static final String INCIDENT_OBJ = 'BMCServiceDesk__Incident__c';
    private static final String iar_OBJ = 'ITSAssetRequest__c';
    
    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT2 = 2;
    private static final Integer RECORD_COUNT3 = 3;
    private static final Integer RECORD_COUNT4 = 4;
    private static final Integer RECORD_COUNT5 = 5;
    private static final Integer MAX_RECORDS = 5;
    private static final Boolean BULK_RECORDS_MODE = true;
    private static final Boolean SINGLE_RECORD_MODE = false;
    private static final String FOUNDATION_ACCOUNT = 'Foundation Account';
    private static final String SYSTEM_ACCOUNT = 'System Account';
  
    // values to be retrieved from the database
    private static Id mDesktopSupportQueueIDDuarte;			// Random queue for testing DUARTE desktop support
    private static Id mDesktopSupportQueueIDRivergrade;		// Random queue for testing RIVERGRADE desktop support
    private static Id mDesktopSupportQueueIDFoundation;		// Random queue for testing FOUNDATION desktop support
    private static Id mTelecomQueueID;						// Random queue for testing Telecom
    private static Id mITSAssetManagementQueueID;			// Random queue for testing ITS asset management
    private static String  mInformationSecurityQueueID;			// Random queue for testing Information Security

    private static Id mDepartmentManagerID;
    private static User mixedDMLUser;
    
    private static String mFoundationAccountClientName;
    private static String mGetIncidentSOQLQuery;
    private static String mGetITSAssetRequestSOQLQuery;
    private static String mLaptopCriterion;

    static {
		User foundationUser = [select Id, Name, Username  from user where name = :FOUNDATION_ACCOUNT limit 1];
        mFoundationAccountClientName = foundationUser.Username;
		mDepartmentManagerID = foundationUser.Id;

        mixedDMLUser = [select Id, Name, Username  from user where name = :SYSTEM_ACCOUNT limit 1];
        
        mGetIncidentSOQLQuery = COHUtil.buildSelectAllSOQLStatement(INCIDENT_OBJ);
		mGetITSAssetRequestSOQLQuery = COHUtil.buildSelectAllSOQLStatement(iar_OBJ);
        List<String> criteriaList = COHUtil.getPicklistValues(iar_OBJ, 'Laptop_Criteria_Select_One__c', true);
        if (COHUtil.isValidList(criteriaList)) {
            mLaptopCriterion = criteriaList.get(0);
        } else {
			System.assert(false, 'Laptop criteria not found');
        }
    }    

    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when an 
     * ITSAssetRequest__c object has been inserted.  This is for the Duarte Helpdesk queue.
     * 
     */
    private static testMethod void verifyUpdate0() {
        if (!mRunAllTests && !mRunVerifyUpdate0) {
            System.debug('Skipping verifyUpdate0()');
            return;
        }    

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();    
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME0, USER_LAST_NAME0, USER_LOCATION0, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }

            // Update the ITS Asset Record
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_DESKTOP_COMPUTER;
            iarObj.Laptop_Criteria_Select_One__c = null;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
    
            System.assertEquals(RECORD_COUNT1, incidentList.size());
    
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
    
            System.assertEquals(mDesktopSupportQueueIDDuarte, incidentObj.OwnerId);
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
            System.assertEquals(true, incidentObj.Asset_Request_Created__c);
    
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ONLY;
            iarObj.Justification__c = JUSTIFICATION;
            iarObj.Tag__c = COMPUTER_TAG;
            iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
            
            // Manually reset the iarObj.Desktop_Support_Incident_Created__c field to further testing
            // instead of manually creating more User and ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Desktop_Support_Incident_Created__c = false;
            
            // Update the ITS Asset Record
            iarObj.Laptop_Criteria_Select_One__c = null;
            iarObj.Hardware_Computing_Device__c = null;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
            
            // Update the ITS Asset Record
            iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ONLY;
            iarObj.Justification__c = JUSTIFICATION;
            iarObj.Tag__c = COMPUTER_TAG;
            iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT2, incidentList.size());
            }
            
            // Manually reset the iarObj.Desktop_Support_Incident_Created__c field to further testing
            // instead of manually creating more User and ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Desktop_Support_Incident_Created__c = false;
            
            // Update the ITS Asset Record
            iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ALL;
            iarObj.Justification__c = JUSTIFICATION;
            iarObj.Tag__c = COMPUTER_TAG;
            iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT3, incidentList.size());
            }
            
            // Manually reset the iarObj.Desktop_Support_Incident_Created__c field to further testing
            // instead of manually creating more User and ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Desktop_Support_Incident_Created__c = false;
            
            // Update the ITS Asset Record
            iarObj.Hardware_Computing_Device__c = HARDWARE_EXISTING_COMPUTER;
            iarObj.Laptop_Criteria_Select_One__c = null;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT4, incidentList.size());
            }
            
            // Manually reset the iarObj.Desktop_Support_Incident_Created__c field to further testing
            // instead of manually creating more User and ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Desktop_Support_Incident_Created__c = false;
    
            
            Test.stopTest();
        }
    }
    
    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when an 
     * ITSAssetRequest__c object has been inserted.  This is for the Rivergrade Helpdesk queue.
     * 
     */
    private static testMethod void verifyUpdate1() {
        if (!mRunAllTests && !mRunVerifyUpdate1) {
            System.debug('Skipping verifyUpdate1()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME1, USER_LAST_NAME1, USER_LOCATION1, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            // Update the ITS Asset Record
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_DESKTOP_COMPUTER;
            iarObj.Laptop_Criteria_Select_One__c = null;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            
            System.assertEquals(RECORD_COUNT1, incidentList.size());
    
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
    
            System.assertEquals(mDesktopSupportQueueIDRivergrade, incidentObj.OwnerId);
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
    
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ONLY;
            iarObj.Need_By_Date__c = Date.today();
            iarObj.Tag__c = COMPUTER_TAG;
            iarObj.Justification__c = JUSTIFICATION;
            iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
            
            Test.stopTest();
        }
    }

    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when an 
     * ITSAssetRequest__c object has been inserted.  This is for the Foundation Helpdesk queue.
     * 
     */
    private static testMethod void verifyUpdate2() {
        if (!mRunAllTests && !mRunVerifyUpdate2) {
            System.debug('Skipping verifyUpdate2()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            // Update the first ITS Asset Record
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_DESKTOP_COMPUTER;
            iarObj.Laptop_Criteria_Select_One__c = null;
            Database.update(iarObj);
            
            iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
    
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            
            System.assertEquals(RECORD_COUNT1, incidentList.size());
    
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
    
            System.assertEquals(mDesktopSupportQueueIDFoundation, incidentObj.OwnerId);
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
    
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ONLY;
            iarObj.Tag__c = COMPUTER_TAG;
            iarObj.Justification__c = JUSTIFICATION;
            iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
            
            Test.stopTest();
        }
    }

    /* 
     * Verifies that ***NO*** BMCServiceDesk__Incident__c records have been created when an 
     * ITSAssetRequest__c object has been inserted.  This tests the case where the
     * User name has one or more numbers in it, which indicates it is a computer, not a person.
     * 
     */
    private static testMethod void verifyUpdate3() {
        if (!mRunAllTests && !mRunVerifyUpdate3) {
            System.debug('Skipping verifyUpdate3()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME3, USER_LAST_NAME3, USER_LOCATION3, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + ' BMCServiceDesk__Incident__c object but retrieved ' + incidentList.size());
            }
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.ChartString__c = CHART_STRING;
            iarObj.VP_Approval__c = false;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + ' BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
    
            Test.stopTest();
        }
    }

    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when
     * ITSAssetRequest__c object has been updated for valid Telecom incidents
     * involving Desktop Phones.
     * 
     */
    private static testMethod void verifyUpdate4() {
        if (!mRunAllTests && !mRunVerifyUpdate4) {
            System.debug('Skipping verifyUpdate4()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update the record.  A new Incident record should be created
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Communication_Device__c = DESKTOP_PHONE_NEW;
            iarObj.Extension__c = PHONE_EXTENSION;
            iarObj.Need_By_Date__c = Date.today();
            iarObj.ChartString_Account_for_Charge_Back__c = CHART_STRING_ACCOUNT;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            
            System.assertEquals(RECORD_COUNT1, incidentList.size());
            
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
            
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
            
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Communication_Device__c = DESKTOP_PHONE_EXISTING;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
    
            // Manually reset the iarObj.Desktop_Phone_Telecom_Incident_Created__c field to further testing
            // instead of inserting more ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Desktop_Phone_Telecom_Incident_Created__c = false;
            iarObj.Communication_Device__c = DESKTOP_PHONE_EXISTING;
            Database.update(iarObj);
    
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT2, incidentList.size());
            
            Test.stopTest();
        } 
    }

    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when
     * ITSAssetRequest__c object has been updated for valid Telecom incidents
     * involving Mobile Phones
     * 
     */

    private static testMethod void verifyUpdate5() {
        if (!mRunAllTests && !mRunVerifyUpdate5) {
            System.debug('Skipping verifyUpdate5()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
    
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update the record.  This should not create a new Incident record.
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            System.assertEquals(RECORD_COUNT1, iarList.size());
    
            // Update the record.  This should not create a new Incident record.
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            System.assertEquals(RECORD_COUNT1, iarList.size());
            
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.ChartString__c = CHART_STRING;
            iarObj.Mobile_Device__c = MOBILE_PHONE_NEW;
            iarObj.VP_Approval__c = false;
            iarObj.ChartString_Account_for_Charge_Back__c = CHART_STRING_ACCOUNT;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
    
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT0, incidentList.size());
            
            iarObj.ChartString__c = CHART_STRING;
            iarObj.Mobile_Device__c = MOBILE_PHONE_EXISTING;
            iarObj.Phone_Number__c = USER_PHONE2;
            iarObj.VP_Approval__c = false;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
    
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT0, incidentList.size());
            
            
            // Update the record.  A new Incident record should be created
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.VP_Approval__c = true;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT1, incidentList.size());
            
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
            
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
            
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Mobile_Device__c = MOBILE_PHONE_EXISTING;
            iarObj.Phone_Number__c = USER_PHONE2;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
    
            // Manually reset the iarObj.Mobile_Phone_Telecom_Incident_Created__c field to further testing
            // instead of inserting more ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.Mobile_Phone_Telecom_Incident_Created__c = false;
            iarObj.Mobile_Device__c = MOBILE_PHONE_EXISTING;
            iarObj.Phone_Number__c = USER_PHONE2;
            iarObj.VP_Approval__c = true;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT2, incidentList.size());
            }
    
            
            Test.stopTest();
        } 
    }        

    /* 
     * Verifies that BMCServiceDesk__Incident__c records have been created when
     * ITSAssetRequest__c object has been updated for valid Telecom incidents
     * involving Desktop and Mobile Phones.
     * 
     */
    private static testMethod void verifyUpdate6() {
        if (!mRunAllTests && !mRunVerifyUpdate6) {
            System.debug('Skipping verifyUpdate6()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update the record.  Two Incident records should be created
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Communication_Device__c = DESKTOP_PHONE_NEW;
            iarObj.Extension__c = PHONE_EXTENSION;
            iarObj.Mobile_Device__c = MOBILE_PHONE_EXISTING;
            iarObj.Phone_Number__c = USER_PHONE2;
            iarObj.VP_Approval__c = true;
            iarObj.ChartString__c = CHART_STRING;
            iarObj.ChartString_Account_for_Charge_Back__c = CHART_STRING_ACCOUNT;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            
            System.assertEquals(RECORD_COUNT2, incidentList.size());
            
            Test.stopTest();
        }
    }

    /* 
     * Verifies that a BMCServiceDesk__Incident__c record has been created when an 
     * ITSAssetRequest__c object has been updated for a valid ITS Asset Management incident.
     * 
     */
    private static testMethod void verifyUpdate7() {
        if (!mRunAllTests && !mRunVerifyUpdate7) {
            System.debug('Skipping verifyUpdate7()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update the ITS Asset Record
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Additional_Software_Requested__c = ASSET_MANAGEMENT_SOFTWARE;
            iarObj.Need_By_Date__c = Date.today();
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT1, incidentList.size());
            
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarObj = iarList.get(0);
            iarObj.Special_Order_Hardware__c = DESKTOP_SUPPORT_HARDWARE;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
    
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
            System.assertEquals(mFoundationAccountClientName, incidentObj.BMCServiceDesk__clientId__c);
            System.assertEquals(INCIDENT_SOURCE_VAL, incidentObj.BMCServiceDesk__contactType__c);
            String descr = incidentObj.BMCServiceDesk__incidentDescription__c;
            System.assert(!String.isEmpty(descr), 'Expected a non-empty description but retrieved : ' + descr);
    
            // Manually reset the iarObj.ITS_Asset_Incident_Created__c field to further testing
            // instead of inserting more ITSAssetRequest objects
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            iarObj = iarList.get(0);
            iarObj.ITS_Asset_Management_Incident_Created__c = false;
            
            iarObj.Additional_Software_Requested__c = null;
            iarObj.Special_Order_Hardware__c = DESKTOP_SUPPORT_HARDWARE;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT2, incidentList.size());
            
            Test.stopTest();
        }
    }
    
    /* 
     * Verifies that a BMCServiceDesk__Incident__c record has been created when an 
     * ITSAssetRequest__c object has been updated for a valid Network Security incident.
     * 
     */
    private static testMethod void verifyUpdate8() {
        if (!mRunAllTests && !mRunVerifyUpdate8) {
            System.debug('Skipping verifyUpdate8()');
            return;
        }

        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
            
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME2, USER_LAST_NAME2, USER_LOCATION2, SINGLE_RECORD_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
            
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update the ITS Asset Record
            ITSAssetRequest__c iarObj = iarList.get(0);
            iarObj.Network_Folder_Access__c = NETWORK_FOLDER_ACCESS;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(RECORD_COUNT1, incidentList.size());
            BMCServiceDesk__Incident__c incidentObj = incidentList.get(0);
            System.assertEquals(mInformationSecurityQueueID, incidentObj.OwnerId);
            
            // Verify that after the incident has been created for this queue, another
            // incident won't be created if a relevant field has been updated.
    
            iarObj.Network_Folder_Access__c = NETWORK_FOLDER_ACCESS + NETWORK_FOLDER_ACCESS;
            Database.update(iarObj);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assertEquals(RECORD_COUNT1, incidentList.size(), 'Error: new Incident was created but should not have been');
            }
    
            Test.stopTest();
        }
    }
    
    /* 
     * Verifies bulk inserts.
     * 
     */
    private static testMethod void verifyBulkUpdates() {
        if (!mRunAllTests && !mRunVerifyBulkUpdates) {
            System.debug('Skipping verifyBulkUpdates()');
            return;
        }
        
        System.runAs(mixedDMLUser) {
            Test.startTest();
    
            setCOHAppConfiguration();
            createUser();
    
            List<ITSAssetRequest__c> iarList = createITSAssetRequestRecords(USER_FIRST_NAME0, USER_LAST_NAME0, USER_LOCATION0, BULK_RECORDS_MODE);
            if (COHUtil.isValidList(iarList)) {
                Database.insert(iarList);
            }
    
            List<BMCServiceDesk__Incident__c> incidentList = Database.query(mGetIncidentSOQLQuery);
            if (COHUtil.isValidList(incidentList)) {
                System.assert(false, 'Expected ' + RECORD_COUNT0 + 'BMCServiceDesk__Incident__c objects but retrieved ' + incidentList.size());
            }
            
            // Update all the records
            iarList = Database.query(mGetITSAssetRequestSOQLQuery);
            System.assertEquals(MAX_RECORDS, iarList.size());
            for (ITSAssetRequest__c iarObj: iarList) {
                iarObj.Hardware_Computing_Device__c = HARDWARE_LAPTOP_ONLY;
                iarObj.Tag__c = COMPUTER_TAG;
                iarObj.Justification__c = JUSTIFICATION;
                iarObj.Laptop_Criteria_Select_One__c = mLaptopCriterion;
            }        
            
            Database.update(iarList);
            
            incidentList = Database.query(mGetIncidentSOQLQuery);
            System.assertEquals(MAX_RECORDS, incidentList.size());
            
            
            Test.stopTest();
        }
    }

    /*
     * Create ITSAssetRequest__c record(s) for testing.
     * 
     * @param firstName				First name for the record
     * @param lastName				Last name for the record
     * @param location				Location
     * @param testTypeMode			Indicates if the records are being tested in Single or Bulk Mode.
     * @return						List of objects to insert.
     * 
     */
    private static List<ITSAssetRequest__c> createITSAssetRequestRecords(String firstName, String lastName, 
                                                                         String location, Boolean testTypeMode) {

        // The Foundation Account should be in prodcopy and prod
        String userSOQLQuery = 'select Id from User where name = \'Foundation Account\'';
    	List<User> userList = Database.query(userSOQLQuery);
        User userObj = userList.get(0);
        Id userID = userObj.Id;
            
        // The System Account should be in prodcopy and prod
        String vpSOQLQuery = 'select Id from User where name = \'System Account\'';
    	userList = Database.query(vpSOQLQuery);
        userObj = userList.get(0);
        Id userManagerID = userObj.Id;
        ID userVPID = userObj.Id;			// not really used

        List<ITSAssetRequest__c> iarObjectsToInsert = new List<ITSAssetRequest__c>();
                                                                             
		Integer numOfRecordsToInsert;
        if (testTypeMode == SINGLE_RECORD_MODE) {
            numOfRecordsToInsert = 1;
        } else {
            numOfRecordsToInsert = MAX_RECORDS;
        }
        for (Integer i = 0; i < numOfRecordsToInsert; i++) {
			ITSAssetRequest__c newiarObj = new ITSAssetRequest__c();
			newiarObj.Employee_Name__c = firstName + SPACE + lastName;
			newiarObj.Position__c = USER_TITLE;
			newiarObj.Dept_Manager__c= userManagerID;
			newiarObj.Dept_VP__c = userVPID;
			newiarObj.Employee__c = userID;
			newiarObj.Employee_ID_No__c = USER_EMPLOYEE_NUMBER;
			newiarObj.Work_Location__c = location;
			newiarObj.Dept_ID__c = USER_DEPARTMENT_NAME;
			iarObjectsToInsert.add(newiarObj);
		}
        return (iarObjectsToInsert);
    }
    
    /*
     * Create BMCServiceDesk__Incident__c record
     * 
     */
    private static BMCServiceDesk__Incident__c createIncidentRecord(Id queueID) {
        BMCServiceDesk__Incident__c incidentObj = new BMCServiceDesk__Incident__c();
        incidentObj.OwnerId = queueID;
        return incidentObj;
    }

    /*
     *  Creates the configuration objects for the test environment.
     */

	private static void setCOHAppConfiguration() {
        
		// Select six random queues.  If there aren't enough, reuse them in more than one place.
        
        List<QueueSobject> queueList = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject];
        if (COHUtil.isValidList(queueList)) {
            Integer queueSize = queueList.size();
            QueueSobject queueObj0;
            QueueSobject queueObj1;
            QueueSobject queueObj2;
            QueueSobject queueObj3;
            QueueSobject queueObj4;
            QueueSobject queueObj5;
            if (queueSize >= 6) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(1);
                queueObj2 = queueList.get(2);
                queueObj3 = queueList.get(3);
                queueObj4 = queueList.get(4);
                queueObj5 = queueList.get(5);
            } else  if (queueSize >= 5) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(1);
                queueObj2 = queueList.get(2);
                queueObj3 = queueList.get(3);
                queueObj4 = queueList.get(4);
                queueObj5 = queueList.get(4);
            } else if (queueSize == 4) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(1);
                queueObj2 = queueList.get(2);
                queueObj3 = queueList.get(3);
                queueObj4 = queueList.get(3);
                queueObj5 = queueList.get(3);
            } else if (queueSize == 3) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(1);
                queueObj2 = queueList.get(2);
                queueObj3 = queueList.get(2);
                queueObj4 = queueList.get(2);
                queueObj5 = queueList.get(2);
            } else if (queueSize == 2) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(1);
                queueObj2 = queueList.get(1);
                queueObj3 = queueList.get(1);
                queueObj4 = queueList.get(1);
                queueObj5 = queueList.get(1);
            } else if (queueSize == 1) {
                queueObj0 = queueList.get(0);
                queueObj1 = queueList.get(0);
                queueObj2 = queueList.get(0);
                queueObj3 = queueList.get(0);
                queueObj4 = queueList.get(0);
                queueObj5 = queueList.get(0);
            }
            mDesktopSupportQueueIDDuarte = queueObj0.QueueId;
            mDesktopSupportQueueIDRivergrade = queueObj1.QueueId;
            mDesktopSupportQueueIDFoundation = queueObj2.QueueId;
            mTelecomQueueID = queueObj3.QueueId;
            mITSAssetManagementQueueID = queueObj4.QueueId;
            mInformationSecurityQueueID = queueObj5.QueueId;
        } else {
            System.assert(false, 'Error: no queues were retrieved for testing.');
        }
        
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj0.Name = RIVERGRADE_LOCATION;
        configObj0.Value__c = RIVERGRADE_LOCATION_VAL;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Active__c = true;

        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj1.Name = FOUNDATION_LOCATION;
        configObj1.Value__c = FOUNDATION_LOCATION_VAL;
        configObj1.Value_Type__c = STRING_TYPE;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj2.Name = INCIDENT_SOURCE;
        configObj2.Value__c = INCIDENT_SOURCE_VAL;
        configObj2.Value_Type__c = STRING_TYPE;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj4.Name = DUARTE_DESKTOP_SUPPORT_QUEUE;
        configObj4.Value__c = mDesktopSupportQueueIDDuarte;
        configObj4.Value_Type__c = STRING_TYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
        configObj5.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj5.Name = RIVERGRADE_DESKTOP_SUPPORT_QUEUE;
        configObj5.Value__c = mDesktopSupportQueueIDRivergrade;
        configObj5.Value_Type__c = STRING_TYPE;
        configObj5.Active__c = true;

        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
        configObj6.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj6.Name = FOUNDATION_DESKTOP_SUPPORT_QUEUE;
        configObj6.Value__c = mDesktopSupportQueueIDFoundation;
        configObj6.Value_Type__c = STRING_TYPE;
        configObj6.Active__c = true;

        COH_App_Configuration__c configObj7 = new COH_App_Configuration__c();
        configObj7.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj7.Name = TELECOM_QUEUE;
        configObj7.Value__c = mTelecomQueueID;
        configObj7.Value_Type__c = STRING_TYPE;
        configObj7.Active__c = true;

        COH_App_Configuration__c configObj8 = new COH_App_Configuration__c();
        configObj8.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj8.Name = ASSET_MANAGEMENT_QUEUE;
        configObj8.Value__c = mITSAssetManagementQueueID;
        configObj8.Value_Type__c = STRING_TYPE;
        configObj8.Active__c = true;

        COH_App_Configuration__c configObj9 = new COH_App_Configuration__c();
        configObj9.Application_Name__c = ITS_ASSET_REQUEST_APPLICATION;
		configObj9.Name = INFORMATION_SECURITY_QUEUE;
        configObj9.Value__c = mInformationSecurityQueueID;
        configObj9.Value_Type__c = STRING_TYPE;
        configObj9.Active__c = true;

        
        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj4);
        configList.add(configObj5);
        configList.add(configObj6);
        configList.add(configObj7);
        configList.add(configObj8);
        configList.add(configObj9);
		Database.insert(configList);
        
        mDesktopSupportQueueIDDuarte = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, DUARTE_DESKTOP_SUPPORT_QUEUE);
        mDesktopSupportQueueIDRivergrade = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, RIVERGRADE_DESKTOP_SUPPORT_QUEUE);
        mDesktopSupportQueueIDFoundation = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, FOUNDATION_DESKTOP_SUPPORT_QUEUE);
        mTelecomQueueID = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, TELECOM_QUEUE);
        mITSAssetManagementQueueID = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, ASSET_MANAGEMENT_QUEUE);
    }
    
    /*
     * Create a user object for testing.
     * 
     */
	private static void createUser() {
		String getSupervisorSOQLQuery = 'select id, Name, EmployeeNumber, Title from User where IsActive = true limit 1';
    	List<User> userSupervisorList = Database.query(getSupervisorSOQLQuery);
        User supervisorObj = userSupervisorList.get(0);
		String defaultSupervisorID = supervisorObj.EmployeeNumber;
        
    	List<User> userProfileIDList = [select ProfileId from User where name = :FOUNDATION_ACCOUNT];
        User userObj = userProfileIDList.get(0);
        String defaultProfileID = userObj.ProfileId;
            
		User newUserObj0 = new User();
        newUserObj0.IsActive = USER_ACTIVE_STATUS;
        newUserObj0.FirstName = USER_FIRST_NAME0;
        newUserObj0.LastName = USER_LAST_NAME0;
        newUserObj0.Supervisor_ID__c = defaultSupervisorID;
        newUserObj0.Username = USER_NAME0;
        newUserObj0.Alias = USER_ALIAS0;
        newUserObj0.Email = USER_EMAIL0;
        newUserObj0.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj0.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj0.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj0.ProfileId = defaultProfileID;
        newUserObj0.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj0.Mgr__c = mDepartmentManagerID;

		User newUserObj1 = new User();
        newUserObj1.IsActive = USER_ACTIVE_STATUS;
        newUserObj1.FirstName = USER_FIRST_NAME1;
        newUserObj1.LastName = USER_LAST_NAME1;
        newUserObj1.Supervisor_ID__c = defaultSupervisorID;
        newUserObj1.Username = USER_NAME1;
        newUserObj1.Alias = USER_ALIAS1;
        newUserObj1.Email = USER_EMAIL1;
        newUserObj1.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj1.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj1.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj1.ProfileId = defaultProfileID;
        newUserObj1.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj1.Mgr__c = mDepartmentManagerID;

		User newUserObj2 = new User();
        newUserObj2.IsActive = USER_ACTIVE_STATUS;
        newUserObj2.FirstName = USER_FIRST_NAME2;
        newUserObj2.LastName = USER_LAST_NAME2;
        newUserObj2.Supervisor_ID__c = defaultSupervisorID;
        newUserObj2.Username = USER_NAME2;
        newUserObj2.Alias = USER_ALIAS2;
        newUserObj2.Email = USER_EMAIL2;
        newUserObj2.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj2.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj2.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;

        newUserObj2.ProfileId = defaultProfileID;
        newUserObj2.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj2.Mgr__c = mDepartmentManagerID;

		User newUserObj3 = new User();
        newUserObj3.IsActive = USER_ACTIVE_STATUS;
        newUserObj3.FirstName = USER_FIRST_NAME3;
        newUserObj3.LastName = USER_LAST_NAME3;
        newUserObj3.Supervisor_ID__c = defaultSupervisorID;
        newUserObj3.Username = USER_NAME3;
        newUserObj3.Alias = USER_ALIAS3;
        newUserObj3.Email = USER_EMAIL3;
        newUserObj3.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj3.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj3.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj3.ProfileId = defaultProfileID;
        newUserObj3.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj3.Mgr__c = mDepartmentManagerID;

        List<User> userList = new List<User> {newUserObj0, newUserObj1, newUserObj2, newUserObj3};
        Database.insert(userList);
    }    
}