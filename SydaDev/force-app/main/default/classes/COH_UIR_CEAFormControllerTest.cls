/*
 * Test Class for the COH_UIR_CEAFormController
 *
 * Tim Hughes
 * City of Hope
 * Copyright (c) 2018
 *
 * No portion of this code may be copied, transferred, or transmitted 
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope
 */ 
@isTest
public class COH_UIR_CEAFormControllerTest {
PRIVATE STATIC FINAL STRING UPDATED_REQUEST_NAME = 'COH_UIR_CEAFormControllerTest Project';
    PRIVATE STATIC FINAL STRING PROJECT_INFORMATION = 'CEA Form';
    
    @isTest
    public static void test1_getRecordServer_NoId() {
        id nullId = null;
        
        test.startTest();
        COH_CEAForm__c testRecord = COH_UIR_CEAFormController.getRecordServer(nullId);
        test.stopTest();
        
        System.assertEquals(null, testRecord.id);
    }
    
    @isTest
    public static void test2_getRecordServer_WithId() {
        COH_CEAForm__c newRecord = getNewCEAForm();
		
        test.startTest();        
        COH_CEAForm__c testRecord = COH_UIR_CEAFormController.getRecordServer(newRecord.id);
        test.stopTest();
        
        System.assertEquals(newRecord.id, testRecord.id);
    }
    
    @isTest
    public static void test3_saveRequestServer() {
        COH_CEAForm__c newRecord = getNewCEAForm();
        
        newRecord.COH_CEA_RequestName__c = UPDATED_REQUEST_NAME;
        
        test.startTest();
        COH_UIR_CEAFormController.saveRecordServer(newRecord);
        test.stopTest();
        
        COH_CEAForm__c updatedRecord = [SELECT id, COH_CEA_RequestName__c FROM COH_CEAForm__c WHERE id =: newRecord.id];        
        System.assertEquals(UPDATED_REQUEST_NAME, updatedRecord.COH_CEA_RequestName__c);
    }
    
    /*
     * Only tests code coverage. The method returns a JSON string and I cannot think of a good way to dynamically test
     */ 
    @isTest
    public static void test4_getPicklistsServer() {
		String CEAFormPicklistsJSON = COH_UIR_CEAFormController.getPicklistsServer(PROJECT_INFORMATION);
        
    }
    
    private static COH_CEAForm__c getNewCEAForm() {
        COH_CEAForm__c newRecord = new COH_CEAForm__c();
        
        insert newRecord;
        
        return newRecord;
    }
}