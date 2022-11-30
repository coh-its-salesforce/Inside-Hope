/*
 * Test class for COH_IntSvc_ComponentController
 * In order to make effective tests this class uses picklist values that were valid at the time of creation. If tests are failing check to see if the picklist value in the global variable EXPORT_ADMIN_VALUES and UPDATED_EXPORT_ADMIN_VALUES are still valid
 * 
 * Tim Hughes  
 */ 
@isTest
public class COH_IntSvc_ComponentControllerTest {
    private static Visa__c mTestRecord01;
    PRIVATE STATIC FINAL STRING EXPORT_ADMIN_VALUES = 'Nuclear materials, facilities and equipment;Chemicals, microorganisms and toxins;Materials processing;Marine systems';
    PRIVATE STATIC FINAL STRING UPDATED_EXPORT_ADMIN_VALUES = 'Nuclear materials, facilities and equipment';
    PRIVATE STATIC FINAL STRING INVALID_EXPORT_ADMIN_VALUES = 'I really hope this value is invalid';
	PRIVATE STATIC FINAL STRING FIELDS_TO_QUERY = 'Export_Administration_Regulations__c';
    PRIVATE STATIC FINAL STRING INVALID_FIELDS_TO_QUERY = 'HELLO_I_AM_AN_INVALID_FIELD__c';
    PRIVATE STATIC FINAL ID INVALID_ID = [SELECT id FROM User LIMIT 1].id; //Get any user Id... it will be invalid for the Visa__c object and our testing purposes

    /*
     * This method tests the standard flow of the getRecordServer method. 
     * Passes the method valid parameters
     */ 
    @isTest
    static void test01_getRecordServer_StandardFlow() {
        createRecord();
        
        test.startTest();
        Visa__c returnedRecord = COH_IntSvc_ComponentController.getRecordServer(mTestRecord01.Id, FIELDS_TO_QUERY);
        System.assertEquals(mTestRecord01.id, returnedRecord.Id);
        System.assertEquals(mTestRecord01.Export_Administration_Regulations__c, returnedRecord.Export_Administration_Regulations__c);
        test.stopTest();
    }
    
    /*
     * This method tests the case of passing an invalid recordId paramter
     * Tests that when an invalid id is entered, we are handling the exception correctly.
     */ 
    @isTest
    static void test02_getRecordServer_InvalidRecordId() {
        Boolean auraHandledExceptionOccured = false;
        createRecord();
        
        test.startTest();
        try {
            Visa__c returnedRecord = COH_IntSvc_ComponentController.getRecordServer(INVALID_ID, FIELDS_TO_QUERY);            
        }
        catch (AuraHandledException e){
            auraHandledExceptionOccured = true;
        }
        
        System.assert(auraHandledExceptionOccured);
    }
    
    /*
     * This method tests the case of passing an invalid fieldsToQuery parameter
     * Tests that when an fieldsToQuery is entered, we are handling the exception correctly.
     */     
    @isTest
    static void test03_getRecordServer_InvalidFieldsToQuery() {
        Boolean auraHandledExceptionOccured = false;
        createRecord();
        
        test.startTest();
        try {
            Visa__c returnedRecord = COH_IntSvc_ComponentController.getRecordServer(mTestRecord01.Id, INVALID_FIELDS_TO_QUERY);            
        }
        catch (AuraHandledException e){
            auraHandledExceptionOccured = true;
        }
        
        System.assert(auraHandledExceptionOccured);        
    }
    
    /*
     * This method tests the case of passing a null recordId parameter
     */ 
    @isTest
    static void test04_getRecordServer_NullRecordId() {
        createRecord();
        
        test.startTest();
        Visa__c returnedRecord = COH_IntSvc_ComponentController.getRecordServer(null, FIELDS_TO_QUERY);
        
        // If the returnedRecord does not have a id, it has not been inserted, therefore is a new Visa__c record
        System.assertEquals(returnedRecord.id, null);
    }
    
    /*
     * This method tests the case of passing an invalid fieldsToQuery parameter
     * Tests that when an fieldsToQuery is entered, we are handling the exception correctly.
     */     
    @isTest
    static void test05_getRecordServer_NullFieldsToQuery() {
        Boolean auraHandledExceptionOccured = false;
        createRecord();
        
        test.startTest();
        try {
            Visa__c returnedRecord = COH_IntSvc_ComponentController.getRecordServer(mTestRecord01.Id, INVALID_FIELDS_TO_QUERY);            
        }
        catch (AuraHandledException e){
            auraHandledExceptionOccured = true;
        }
        
        // If the returnedRecord does not have a id, it has not been inserted, therefore is a new Visa__c record
        System.assert(auraHandledExceptionOccured);        
    }    
    
    /*
     * This test just checks that the string returned is a valid string.
     */ 
    @isTest
    static void test06_getPicklistServer_SectionSix() {
        test.startTest();
		String returnedString = COH_IntSvc_ComponentController.getPicklistsServer('Section Six');
        test.stopTest();
        
        System.assert(COHUtil.isValidStr(returnedString));
    }
    
    /*
     * This test just checks that the string returned is a valid string.
     */ 
    @isTest
    static void test07_getPicklistServer_SectionSeven() {
        test.startTest();
		String returnedString = COH_IntSvc_ComponentController.getPicklistsServer('Section Seven');
        test.stopTest();
        
        System.assert(COHUtil.isValidStr(returnedString));
    }
    
    /*
     * This test checks that an invalid string returns null
     */ 
    @isTest
    static void test08_getPicklistServer_InvalidSection() {
        test.startTest();
		String returnedString = COH_IntSvc_ComponentController.getPicklistsServer('Invalid Section');
        test.stopTest();
        
        System.assert(!COHUtil.isValidStr(returnedString));
    } 
    
    /*
     * This method tests that the saveSectionServer method saves a record correctly
     */ 
    @isTest
    static void test09_saveSectionServer_StandardFlow() {
     	createRecord();
        Visa__c testRecord = mTestRecord01;
        System.assertEquals(testRecord.Export_Administration_Regulations__c, EXPORT_ADMIN_VALUES);
        
        testRecord.Export_Administration_Regulations__c = UPDATED_EXPORT_ADMIN_VALUES;
        
        test.startTest();
        COH_IntSvc_ComponentController.saveSectionServer(testRecord);
        test.stopTest();
        
        Visa__c savedRecord = [SELECT Export_Administration_Regulations__c FROM Visa__c WHERE id=:testRecord.Id];
        System.assertEquals(UPDATED_EXPORT_ADMIN_VALUES, savedRecord.Export_Administration_Regulations__c);
    }
    
    /*
     * This method tests that the saveSectionServer method correctly throws an error if there is a problem saving the record and that the record is not updated
     */ 
    @isTest
    static void test10_saveSectionServer_InvalidRecord() {
        Boolean auraHandledExceptionOccured = false;
        
     	createRecord();
        Visa__c testRecord = mTestRecord01;
        System.assertEquals(testRecord.Export_Administration_Regulations__c, EXPORT_ADMIN_VALUES);
        
        testRecord.Export_Administration_Regulations__c = INVALID_EXPORT_ADMIN_VALUES;
        
        test.startTest();
        try {
            COH_IntSvc_ComponentController.saveSectionServer(testRecord);
        }
        catch (AuraHandledException e) {
            auraHandledExceptionOccured = true;
        }
        test.stopTest();
        
        System.assert(auraHandledExceptionOccured);
        Visa__c savedRecord = [SELECT Export_Administration_Regulations__c FROM Visa__c WHERE id=:testRecord.Id];
        System.assertEquals(EXPORT_ADMIN_VALUES, savedRecord.Export_Administration_Regulations__c);
    }    
    
    /*
     * This method creates a Visa__c record for the purposes of testing
     */ 
    private static void createRecord() {
        Visa__c testRecord = new Visa__c();
        testRecord.Export_Administration_Regulations__c = EXPORT_ADMIN_VALUES;
    	insert testRecord;
        mTestRecord01 = testRecord;
    }
}