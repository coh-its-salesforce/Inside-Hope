/* 
 * This test class verifies the functionality of COHCheckTimesheetHelper.  
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
public class COHUpdatePeopleSoftDepartmentsHelperTest {
    
    // Flow Control
    private static final Boolean mVerifyRecords0 = false;
    private static final Boolean mRunAllTests = true;

    // Constants for creating a new user
    private static final String USER_OBJ = 'User';
    private static final String USER_FIRST_NAME = 'Thomas';
    private static final String USER_LAST_NAME0 = 'Zebulon';
    private static final String USER_LAST_NAME1 = 'Andrews';
    private static final String USER_LAST_NAME2 = 'Brannigan';
    private static final String USER_LAST_NAME3 = 'Fung';
    private static final String USER_LAST_NAME4 = 'Dang';

    private static final String USER_TITLE = 'P.I.';
    private static final String USER_NAME0 = 'thomaszebulon@coh.org';
    private static final String USER_NAME1 = 'thomasandrews@coh.org';
    private static final String USER_NAME2 = 'thomasbrannigan@coh.org';
    private static final String USER_NAME3 = 'thomasfung@coh.org';
    private static final String USER_NAME4 = 'thomasdang@coh.org';
    private static final String USER_ALIAS0 = 'thomas0';
    private static final String USER_ALIAS1 = 'thomas1';
    private static final String USER_ALIAS2 = 'thomas2';
    private static final String USER_ALIAS3 = 'thomas3';
    private static final String USER_ALIAS4 = 'thomas4';
    private static final String USER_EMAIL = 'thomassullivanmagnumiv@coh.org';
    private static final String USER_TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    private static final String USER_LOCALE_SID_KEY = 'en_US';
    private static final String USER_EMAIL_ENCODING_KEY = 'ISO-8859-1';
    private static final String USER_LANGUAGE_LOCALE_KEY = 'en_US';
    private static final String USER_EMPLOYEE_NUMBER = '99999999';
    private static final String USER_LOCATION = 'Duarte';
    private static final String USER_DEPARTMENT_NAME0 = 'Magnum PI ITS';
    private static final String USER_DEPARTMENT_NAME1 = 'Island Hoppers';
    private static final String USER_DEPARTMENT_NAME2 = 'King Kamehameha Club';
    private static final String USER_DEPARTMENT_NAME3 = 'Rick\'s Club';
    private static final String USER_BASE_NAME = 'tmagnum';
    private static final String USER_BASE_ORGANZATION = '@coh.org';
    private static final Boolean USER_STATUS = true;

    private static final Integer RECORD_COUNT0 = 0;
    private static final Integer RECORD_COUNT1 = 1;
    private static final Integer RECORD_COUNT2 = 2;
    private static final Integer RECORD_COUNT4 = 4;
    private static final Integer USER_COUNT0 = 0;
    private static final Integer USER_COUNT1 = 1;
    private static final Integer USER_COUNT4 = 4;
    
    // values to be retrieved from the database
    private static Id mUserManager;
    private static Id mUserVP;
    private static String mDefaultProfileID;
    private static String mDefaultSupervisorID;
    
    /*
     * Verify the insertion of a User record without a Timesheet_Week__c
     * object.  
     * 
     */
    private static testMethod void verifyRecords0() {
        if (!mRunAllTests && !mVerifyRecords0) {
            System.debug('Skipping verifyRecords0()');
            return;
        }
        
        Test.startTest();
        
        createPSRecords();
        
        String queryStr0 = 'select id, name, User_Count__c from Peoplesoft__c where name = :USER_DEPARTMENT_NAME0';
        List<Peoplesoft__c> psObjects = Database.query(queryStr0);
        System.assertEquals(RECORD_COUNT0, psObjects.size());
        
        String queryStr1 = 'select id, name, User_Count__c from Peoplesoft__c where name = :USER_DEPARTMENT_NAME1';
        psObjects = Database.query(queryStr1);
        System.assertEquals(RECORD_COUNT1, psObjects.size());
        Peoplesoft__c existingPSObj = psObjects.get(0);
        System.assertEquals(USER_COUNT4, existingPSObj.User_Count__c);
        
        String queryStr2 = 'select id, name, User_Count__c from Peoplesoft__c where name = :USER_DEPARTMENT_NAME2 or name = :USER_DEPARTMENT_NAME3';
        psObjects = Database.query(queryStr2);
        System.assertEquals(RECORD_COUNT2, psObjects.size());
        for (Peoplesoft__c psObj : psObjects) {
            String deptName = psObj.Name;
            Integer userCount = Integer.valueOf(psObj.User_Count__c);
            if (deptName.equalsIgnoreCase(USER_DEPARTMENT_NAME2)) {
                System.assertEquals(USER_COUNT1, userCount);
            } else if (deptName.equalsIgnoreCase(USER_DEPARTMENT_NAME3)) {
                System.assertEquals(USER_COUNT4, userCount);
            } else {
                System.assert(false, 'Unexpected department name encountered: ' + deptName);
            }
        }
        
        createUsers();

        COHUpdatePeopleSoftDepartmentsHelper cupsdhObj = new COHUpdatePeopleSoftDepartmentsHelper();
        cupsdhObj.updateDepartments();

        // Check USER_DEPARTMENT0 records
        psObjects = Database.query(queryStr0);
        System.assertEquals(RECORD_COUNT1, psObjects.size());
        
        Peoplesoft__c psObj = psObjects.get(0);
        System.assertEquals(USER_COUNT4, psObj.User_Count__c);
        
        // Check USER_DEPARTMENT1 records
        psObjects = Database.query(queryStr1);
        System.assertEquals(RECORD_COUNT1, psObjects.size());
        
        psObj = psObjects.get(0);
        System.assertEquals(USER_COUNT1, psObj.User_Count__c);
        
        // Check existing records
        psObjects = Database.query(queryStr2);
        System.assertEquals(RECORD_COUNT2, psObjects.size());
        for (Peoplesoft__c psObj1 : psObjects) {
            String deptName = psObj1.Name;
            Integer userCount = Integer.valueOf(psObj1.User_Count__c);
            if (deptName.equalsIgnoreCase(USER_DEPARTMENT_NAME2)) {
                System.assertEquals(USER_COUNT0, userCount);
            } else if (deptName.equalsIgnoreCase(USER_DEPARTMENT_NAME3)) {
                System.assertEquals(USER_COUNT0, userCount);
            } 
        }

        Test.stopTest();
    }
    
    /*
     * Create Peoplesoft__c object for testing.
     * 
     */
    private static void createPSRecords() {
        PeopleSoft__c psObj0 = new PeopleSoft__c();
        psObj0.Name = USER_DEPARTMENT_NAME2;
        psObj0.User_Count__c = USER_COUNT1;
        
        PeopleSoft__c psObj1 = new PeopleSoft__c();
        psObj1.Name = USER_DEPARTMENT_NAME3;
        psObj1.User_Count__c = USER_COUNT4;

        PeopleSoft__c psObj2 = new PeopleSoft__c();
        psObj2.Name = USER_DEPARTMENT_NAME1;
        psObj2.User_Count__c = USER_COUNT4;
        
        List<PeopleSoft__c> psObjects = new List<PeopleSoft__c>();
        psObjects.add(psObj0);
        psObjects.add(psObj1);
        psObjects.add(psObj2);
        
        Database.insert(psObjects);
    }
    
    /*
     * Create user objects for testing. 
     * 
     */
    private static void createUsers() {

        // The mUserManager, mDefaultProfileID, mUserVP, and  mDefaultSupervisorID probably aren't needed,
        // but I'm keeping them here for reference in case they are needed for other test classes.
        
        // The Foundation Account should be in prodcopy and prod
        String managerSOQLQuery = 'select Id, ProfileID from User where name = \'Foundation Account\'';
        List<User> userList = Database.query(managerSOQLQuery);
        User userObj = userList.get(0);
        mUserManager = userObj.Id;
        mDefaultProfileID = userObj.ProfileId;
            
        // The System Account should be in prodcopy and prod
        String vpSOQLQuery = 'select Id from User where name = \'System Account\'';
        userList = Database.query(vpSOQLQuery);
        userObj = userList.get(0);
        mUserVP = userObj.Id;
            
        String getSupervisorSOQLQuery = 'select id, EmployeeNumber, Title from User where IsActive = true limit 1';
        userList = Database.query(getSupervisorSOQLQuery);
        userObj = userList.get(0);
        mDefaultSupervisorID = userObj.EmployeeNumber;
        
        List<User> userObjectsToInsert = new List<User>();
        
        User newUserObj0 = new User();
        newUserObj0.IsActive = USER_STATUS;
        newUserObj0.FirstName = USER_FIRST_NAME;
        newUserObj0.LastName = USER_LAST_NAME0;
        newUserObj0.Title = USER_TITLE;
        newUserObj0.Username = USER_NAME0;
        newUserObj0.Alias = USER_ALIAS0;
        newUserObj0.Email = USER_EMAIL;
        newUserObj0.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj0.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj0.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj0.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj0.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj0.Location__c = USER_LOCATION;
        newUserObj0.Department = USER_DEPARTMENT_NAME0;
        newUserObj0.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj0.ProfileId = mDefaultProfileID;
        newUserObj0.VP_SVP_CTO__c = mUserVP;
        newUserObj0.Mgr__c = mUserManager;
        newUserObj0.Start_Date__c = Date.today();
        userObjectsToInsert.add(newUserObj0);
        
        User newUserObj1 = new User();
        newUserObj1.IsActive = USER_STATUS;
        newUserObj1.FirstName = USER_FIRST_NAME;
        newUserObj1.LastName = USER_LAST_NAME1;
        newUserObj1.Title = USER_TITLE;
        newUserObj1.Username = USER_NAME1;
        newUserObj1.Alias = USER_ALIAS1;
        newUserObj1.Email = USER_EMAIL;
        newUserObj1.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj1.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj1.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj1.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj1.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj1.Location__c = USER_LOCATION;
        newUserObj1.Department = USER_DEPARTMENT_NAME0;
        newUserObj1.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj1.ProfileId = mDefaultProfileID;
        newUserObj1.VP_SVP_CTO__c = mUserVP;
        newUserObj1.Mgr__c = mUserManager;
        newUserObj1.Start_Date__c = Date.today();
        userObjectsToInsert.add(newUserObj1);
        
        User newUserObj2 = new User();
        newUserObj2.IsActive = USER_STATUS;
        newUserObj2.FirstName = USER_FIRST_NAME;
        newUserObj2.LastName = USER_LAST_NAME2;
        newUserObj2.Title = USER_TITLE;
        newUserObj2.Username = USER_NAME2;
        newUserObj2.Alias = USER_ALIAS2;
        newUserObj2.Email = USER_EMAIL;
        newUserObj2.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj2.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj2.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj2.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj2.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj2.Location__c = USER_LOCATION;
        newUserObj2.Department = USER_DEPARTMENT_NAME0;
        newUserObj2.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj2.ProfileId = mDefaultProfileID;
        newUserObj2.VP_SVP_CTO__c = mUserVP;
        newUserObj2.Mgr__c = mUserManager;
        newUserObj2.Start_Date__c = Date.today();
        userObjectsToInsert.add(newUserObj2);
        
        User newUserObj3 = new User();
        newUserObj3.IsActive = USER_STATUS;
        newUserObj3.FirstName = USER_FIRST_NAME;
        newUserObj3.LastName = USER_LAST_NAME3;
        newUserObj3.Title = USER_TITLE;
        newUserObj3.Username = USER_NAME3;
        newUserObj3.Alias = USER_ALIAS3;
        newUserObj3.Email = USER_EMAIL;
        newUserObj3.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj3.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj3.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj3.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj3.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj3.Location__c = USER_LOCATION;
        newUserObj3.Department = USER_DEPARTMENT_NAME0;
        newUserObj3.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj3.ProfileId = mDefaultProfileID;
        newUserObj3.VP_SVP_CTO__c = mUserVP;
        newUserObj3.Mgr__c = mUserManager;
        newUserObj3.Start_Date__c = Date.today();
        userObjectsToInsert.add(newUserObj3);

        // This user record has a different department name
        User newUserObj4 = new User();
        newUserObj4.IsActive = USER_STATUS;
        newUserObj4.FirstName = USER_FIRST_NAME;
        newUserObj4.LastName = USER_LAST_NAME4;
        newUserObj4.Title = USER_TITLE;
        newUserObj4.Username = USER_NAME4;
        newUserObj4.Alias = USER_ALIAS4;
        newUserObj4.Email = USER_EMAIL;
        newUserObj4.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY;
        newUserObj4.LocaleSidKey = USER_LOCALE_SID_KEY;
        newUserObj4.EmailEncodingKey = USER_EMAIL_ENCODING_KEY;
        newUserObj4.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY;
        newUserObj4.EmployeeNumber = USER_EMPLOYEE_NUMBER;
        newUserObj4.Location__c = USER_LOCATION;
        newUserObj4.Department = USER_DEPARTMENT_NAME1;     
        newUserObj4.Supervisor_ID__c = mDefaultSupervisorID;
        newUserObj4.ProfileId = mDefaultProfileID;
        newUserObj4.VP_SVP_CTO__c = mUserVP;
        newUserObj4.Mgr__c = mUserManager;
        newUserObj4.Start_Date__c = Date.today() ;      
        userObjectsToInsert.add(newUserObj4);

        Database.insert(userObjectsToInsert);
        
    }

    
}