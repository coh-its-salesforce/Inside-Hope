/*
 * Contains unit tests for the COH_POB_ContactTrigger and COH_POB_ContactTriggerHelper classes.
 * Tim Hughes
 */ 
@isTest()
public class COH_POB_ContactTriggerTest {

	// Variables used to setup COH App Config Objects for testing    
    PRIVATE STATIC FINAL STRING COH_CONFIG_RECORD_TYPES_GROUP_NAME = 'Record Type Ids';
    PRIVATE STATIC FINAL STRING COH_CONFIG_APP_NAME = 'Physician Onboarding/Offboarding';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_CONTACT_RECORD_TYPE_LABEL = 'Duarte Onboarding Contact Record Type';
    PRIVATE STATIC FINAL STRING DUARTE_ONBOARDING_RECORD_TYPE_NAME = 'Duarte_Physician_Onboarding';
    PRIVATE STATIC FINAL STRING STRING_TYPE = 'string';
    private static id mRecordTypeId;
    
    
    // Variables for setting up a new Physician Onboarding Task
    PRIVATE STATIC FINAL STRING PHYSICIAN_ONBOARDING_TASK_STATUS = 'Not Started';    
    
    // Variables for setting up a new Contact
  	PRIVATE STATIC FINAL STRING CONTACT_LAST_NAME = 'Howser';
    
    private static User mThisUser;
    
    static {
        mThisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        // Get Record Id for Physician Onboarding
        List<RecordType> physicianOnboardingTasksRecordTypes = new List<RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType='Contact' AND DeveloperName=:DUARTE_ONBOARDING_RECORD_TYPE_NAME]);
		System.assertEquals(true, physicianOnboardingTasksRecordTypes.size() > 0, 'No record types are found.');
        mRecordTypeId = physicianOnboardingTasksRecordTypes[0].id;        
    }
    
    // Test 1 - Standard Flow
    @isTest
    private static void test01StandardFlow() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(mRecordTypeId);
        createPhysicianOnboardingTasks(60, testContact.Id);
        testContact = createContact(mRecordTypeId);
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = mThisUser.id;
        update testContact;
        Test.stopTest();
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(mThisUser.id, currentTask.Assigned_To__c);
        }
    }
    
    // Test 2 - No Tasks
    @isTest
    private static void test02NoTasks() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(mRecordTypeId);
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        delete relatedTasksList;
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);        
        System.assertEquals(0, relatedTasksList.size());
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = mThisUser.id;
        update testContact;
        Test.stopTest();        
    }
    
    // Test 3 - 200 tasks
    @isTest
    private static void test03BulkTasks() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(mRecordTypeId);
        createPhysicianOnboardingTasks(200, testContact.Id);
        testContact = createContact(mRecordTypeId);
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = mThisUser.id;
        update testContact;
        Test.stopTest();
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(mThisUser.id, currentTask.Assigned_To__c);
        }
        
    }
    
    // Test 4 - No record Type
    @isTest
    private static void test04NoRecordType() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(null);
		System.assertEquals(null, testContact.RecordTypeId);      
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = mThisUser.id;
        update testContact;
        Test.stopTest(); 
    }
    
    // Test 5 - Assign All To is not set
    @isTest
    private static void test05AssignAllNotSet() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(mRecordTypeId);
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = null;
        update testContact;
        Test.stopTest();  
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }        
    }
    
    // Test 6 - Tasks have Do Not Mass Assign Checked
    @isTest
    private static void test06DoNotMassAssignChecked() {
        Contact testContact;
        createCOHAppConfiguration();
        testContact = createContact(mRecordTypeId);
        createPhysicianOnboardingTasks(60, testContact.Id);
        testContact = createContact(mRecordTypeId);
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c, Do_Not_Mass_Update__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Integer i = 0; i < relatedTasksList.size() / 2; i++) {
            relatedTasksList.get(i).Do_Not_Mass_Update__c = true;
        }
        update relatedTasksList;
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c, Do_Not_Mass_Update__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Integer i = 0; i < relatedTasksList.size() / 2; i++) {
            System.assertEquals(true, relatedTasksList.get(i).Do_Not_Mass_Update__c);
        }
        for (Integer i = relatedTasksList.size() / 2; i < relatedTasksList.size(); i++) {
            System.assertEquals(false, relatedTasksList.get(i).Do_Not_Mass_Update__c);
        }        
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = mThisUser.id;
        update testContact;
        Test.stopTest();
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Integer i = 0; i < relatedTasksList.size() / 2; i++) {
            System.assertEquals(true, relatedTasksList.get(i).Assigned_To__c == null);
        }
        for (Integer i = relatedTasksList.size() / 2; i < relatedTasksList.size(); i++) {
            System.assertEquals(true, relatedTasksList.get(i).Assigned_To__c == mThisUser.id);
        }            
    }
    
    //Test 7 - No COH App Config
    private static void test07NoCOHAppConfig() {
        Contact testContact;
        testContact = createContact(mRecordTypeId);
        
        List<Physician_Onboarding_Tasks__c> relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }
        
        Test.startTest();
        testContact.Assign_All_Tasks_To__c = null;
        update testContact;
        Test.stopTest();  
        
        relatedTasksList = new List<Physician_Onboarding_Tasks__c>([
            SELECT id, Assigned_To__c
            FROM Physician_Onboarding_Tasks__c
            WHERE Contact__c =: testContact.Id
        ]);
        for (Physician_Onboarding_Tasks__c currentTask : relatedTasksList) {
            System.assertEquals(null, currentTask.Assigned_To__c);
        }             
    }
    
    
    //------------ Setup Functions ------------//
    
    
    /*
     * Creates a contact object for the purposes of testing
     * 
     * @param id recordTypeId			The record type id of the contact being created
     * 
     * @return Contact 					The contact that was created
     */
    private static Contact createContact(id recordTypeId) {
        Contact newContact = new Contact();
        if (recordTypeId != null) {
            newContact.RecordTypeId = recordTypeId;
        }
        newContact.LastName = CONTACT_LAST_NAME;
        System.runAs(mThisUser) {
            insert newContact;
        }
        return newContact;
    }
    
    /*
     * Creates a Physician Onboarding Task object for the purposes of testing
     * 
     * @param id contactId				The id of the Contact that the Tasks should be related to
     */ 
    private static void createPhysicianOnboardingTasks(Integer numToCreate, id contactId) {
        List<Physician_Onboarding_Tasks__c> tasksToInsert = new List<Physician_Onboarding_Tasks__c>();
        for (Integer i = 0; i < numToCreate; i++) {
            Physician_Onboarding_Tasks__c tempTask = new Physician_Onboarding_Tasks__c();
            tempTask.Status__c = PHYSICIAN_ONBOARDING_TASK_STATUS;
            tempTask.Contact__c = contactId;
            tasksToInsert.add(tempTask);
        }
        System.assertEquals(numToCreate, tasksToInsert.size());
        
        System.runAs(mThisUser) {
            insert tasksToInsert;
        }
    }
    
	/*
     * Creates the configuration objects for the test environment.
     */
    private static void createCOHAppConfiguration() {       
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = COH_CONFIG_APP_NAME;
        configObj0.Name = DUARTE_ONBOARDING_CONTACT_RECORD_TYPE_LABEL;
        configObj0.Value__c = mRecordTypeId;
        configObj0.Value_Type__c = STRING_TYPE;
        configObj0.Configuration_Group__c = COH_CONFIG_RECORD_TYPES_GROUP_NAME;
        configObj0.Active__c = true;        

        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        
        System.runAs(mThisUser) {
			insert(configList);
        }
	}
}