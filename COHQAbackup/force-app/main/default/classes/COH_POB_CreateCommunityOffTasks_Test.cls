@isTest
public class COH_POB_CreateCommunityOffTasks_Test {
    PRIVATE STATIC FINAL INTEGER NUM_CONTACTS_TO_CREATE = 1;
    PRIVATE STATIC FINAL INTEGER NUM_CONTACTS_TO_CREATE_BULK = 200;
	PRIVATE STATIC FINAL INTEGER NUM_TEMPLATE_TASKS_TO_CREATE = 40;
    PRIVATE STATIC FINAL STRING SOBJECT_TYPE_NAME = 'Physician_Onboarding_Tasks__c';
    PRIVATE STATIC FINAL STRING TASK_RECORD_TYPE_NAME = 'Community_Physician_Offboarding_Task';
    PRIVATE STATIC FINAL STRING TASK_TEMPLATE_RECORD_TYPE_NAME = 'Community_Physician_Offboarding_Task_Template';    
    private static id mTaskRecordTypeId;
    private static id mTaskTemplateRecordTypeId;
    private static List<Contact> mContacts;
    
    /*
     * This method gets the record IDs that will be used in the tests
     */ 
    private static void testSetup() {
        try {
            mTaskRecordTypeId = [SELECT id, DeveloperName from RecordType WHERE sobjecttype=:SOBJECT_TYPE_NAME AND DeveloperName =:TASK_RECORD_TYPE_NAME LIMIT 1].id;
            System.debug('Task Record Type ID --->' + mTaskRecordTypeId);
            mTaskTemplateRecordTypeId = [SELECT id, DeveloperName from RecordType WHERE sobjecttype=:SOBJECT_TYPE_NAME AND DeveloperName =:TASK_TEMPLATE_RECORD_TYPE_NAME LIMIT 1].id;
            System.debug('Task Template Record Type ID --->' + mTaskTemplateRecordTypeId);
        }    	
        catch (Exception e) {
            Throw new COHException('Class: COH_POB_CreateCommunityOnTasks_Test | Method: setup | Line: ' + e.getLineNumber() + ' | Error: ' + e.getMessage());
        }
    }    

	/*
	 * This method tests the standard flow of the createCommunityOnboardingTasks method. 
	 */
    @isTest
    public static void test1_StandardFlow() {
        testSetup();
        createContacts(NUM_CONTACTS_TO_CREATE);
        createTaskTemplates(NUM_TEMPLATE_TASKS_TO_CREATE);

        test.startTest(); {
            COH_POB_CreateCommunityOffTasks.createCommunityOffboardingTasks(mContacts);
        }
        test.stopTest();
        
        List<Physician_Onboarding_Tasks__c> createdTasks = [SELECT id, Community_Offboarding_Contact__c FROM Physician_Onboarding_Tasks__c WHERE Community_Offboarding_Contact__c IN: mContacts];
        System.assertEquals(NUM_CONTACTS_TO_CREATE * NUM_TEMPLATE_TASKS_TO_CREATE, createdTasks.size(), 'Class: COH_POB_CreateCommunityOnTasks_Test | Method: test1_StandardFlow | Error: Failed to create the correct number of Tasks');
    }
    
    /*
     * This method tests the createCommunityOnboardingTasks method when there are no Task Templates records created
     */
    @isTest
    public static void test2_NoTemplateTasks() {
        testSetup();
        createContacts(NUM_CONTACTS_TO_CREATE);

        test.startTest(); {
            COH_POB_CreateCommunityOffTasks.createCommunityOffboardingTasks(mContacts);
        }
        test.stopTest();
        
        List<Physician_Onboarding_Tasks__c> createdTasks = [SELECT id, Community_Offboarding_Contact__c FROM Physician_Onboarding_Tasks__c WHERE Community_Offboarding_Contact__c IN: mContacts];
        System.assertEquals(0, createdTasks.size(), 'Class: COH_POB_CreateCommunityOnTasks_Test | Method: test1_StandardFlow | Error: Failed to create the correct number of Tasks');
    }    
    
    /*
     * This method tests the createCommunityOnboardingTasks method when there are no contact records created. 
     * It checks to see if any additional Physician_Onboarding_Tasks__c have been created, besides the template tasks that were created in the setup
     */
    @isTest
    public static void test3_NoContacts() {
        testSetup();
        createTaskTemplates(NUM_TEMPLATE_TASKS_TO_CREATE);
        Contact testContact = new Contact();

        test.startTest(); {
            COH_POB_CreateCommunityOffTasks.createCommunityOffboardingTasks(mContacts);
        }
        test.stopTest();
        
        List<Physician_Onboarding_Tasks__c> createdTasks = [SELECT id, Community_Offboarding_Contact__c FROM Physician_Onboarding_Tasks__c];
        System.assertEquals(NUM_TEMPLATE_TASKS_TO_CREATE, createdTasks.size(), 'Class: COH_POB_CreateCommunityOnTasks_Test | Method: test1_StandardFlow | Error: Failed to create the correct number of Tasks');
    }    
    
    /*
     * This method creates contact records to be used in the tests.
     * 
     * @param Integer numToCreate 				The number of contact records to create
     */ 
    private static void createContacts(Integer numToCreate) {
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 0; i < numToCreate; i++) {
        	Contact tempContact = new Contact();
            tempContact.LastName = 'Test' + i;
            contactsToInsert.add(tempContact);
        }

        try {
            insert contactsToInsert;
        }
        catch (Exception e) {
            throw new COHException('Class: COH_POB_CreateCommunityOnTasks_Test | Method: createContacts | Line: ' + e.getLineNumber() + ' | Error:  ' + e.getMessage());            
        }
        mContacts = new List<Contact>([SELECT id FROM Contact]);
        System.assertEquals(numToCreate, mContacts.size(), 'Class: COH_POB_CreateCommunityOnTasks_Test | Method: createContacts | Error: Failed to create the correct amount of contacts');              
    }
    
    /*
     * This method creates Physician_Onboarding_Tasks__c template records to be used in the tests
     * 
     * @param numToCreate					The number of records to create
     */ 
    private static void createTaskTemplates(Integer numToCreate) {
        List<Physician_Onboarding_Tasks__c> tasksToInsert = new List<Physician_Onboarding_Tasks__c>();
        for (Integer i = 0; i < numToCreate; i++) {
            Physician_Onboarding_Tasks__c newTask = new Physician_Onboarding_Tasks__c();
            newTask.Name = 'Name';
            newTask.Description__c = 'Description';
            newTask.RecordTypeId = mTaskTemplateRecordTypeId;
            tasksToInsert.add(newTask);
        }
        try {
            insert tasksToInsert;
        }
        catch (Exception e) {
            throw new COHException('Class: COH_POB_CreateCommunityOnTasks_Test | Method: createTaskTemplates | Line: ' + e.getLineNumber() + ' | Error:  ' + e.getMessage());            
        }
        List<Physician_Onboarding_Tasks__c> createdTasks = new List<Physician_Onboarding_Tasks__c>([SELECT id FROM Physician_Onboarding_Tasks__c]);
        System.assertEquals(numToCreate, createdTasks.size(), 'Class: COH_POB_CreateCommunityOnTasks_Test | Method: createTaskTemplates | Error: Failed to create the correct amount of tasks');        
    }
}