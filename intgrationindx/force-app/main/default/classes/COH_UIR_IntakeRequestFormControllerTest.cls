/*
 * Test Class for the COH_UIR_IntakeRequestFormController
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
public class COH_UIR_IntakeRequestFormControllerTest {
    PRIVATE STATIC FINAL STRING UPDATED_REQUEST_NAME = 'COH_UIR_IntakeRequestFromControllerTest Project';
    PRIVATE STATIC FINAL STRING PROJECT_INFORMATION = 'Project Information';
    PRIVATE STATIC FINAL STRING RESOURCE_INVOLVEMENT = 'Resource Involvement';
    PRIVATE STATIC FINAL STRING ADOPTION_IMPACT = 'Adoption Impact';
    PRIVATE STATIC FINAL STRING LABOR_REQUEST = 'Labor Request';
    PRIVATE STATIC FINAL STRING INFOSEC_REQUEST = 'InfoSec Request';
    PRIVATE STATIC FINAL STRING RESEARCH_REQUEST = 'Research Request';
    PRIVATE STATIC FINAL STRING CAPITAL_REQUEST = 'Capital Request';
    PRIVATE STATIC FINAL STRING ITS_REQUEST = 'ITS Request';
    PRIVATE STATIC FINAL STRING FACILITIES_REQUEST = 'Facilities Request';
    PRIVATE STATIC FINAL STRING FY_PLANNING_REQUEST = 'FY Planning Request';
    
    
    @isTest
    public static void test1_getRecordServer_NoId() {
        id nullId = null;
        
        test.startTest();
        COH_UniversalIntakeRequest__c testRecord = COH_UIR_IntakeRequestFormController.getRecordServer(nullId);
        test.stopTest();
        
        System.assertEquals(null, testRecord.id);
    }
    
    @isTest
    public static void test2_getRecordServer_WithId() {
        COH_UniversalIntakeRequest__c newRecord = getNewUniversalIntakeRequest();
		
        test.startTest();        
        COH_UniversalIntakeRequest__c testRecord = COH_UIR_IntakeRequestFormController.getRecordServer(newRecord.id);
        test.stopTest();
        
        System.assertEquals(newRecord.id, testRecord.id);
    }
    
    @isTest
    public static void test3_saveRequestServer() {
        COH_UniversalIntakeRequest__c newRecord = getNewUniversalIntakeRequest();
        
        newRecord.COH_UIR_SHR_RequestName__c = UPDATED_REQUEST_NAME;
        
        test.startTest();
        COH_UIR_IntakeRequestFormController.saveRequestServer(newRecord);
        test.stopTest();
        
        COH_UniversalIntakeRequest__c updatedRecord = [SELECT id, COH_UIR_SHR_RequestName__c FROM COH_UniversalIntakeRequest__c WHERE id =: newRecord.id];        
        System.assertEquals(UPDATED_REQUEST_NAME, updatedRecord.COH_UIR_SHR_RequestName__c);
    }
    
    /*
     * Only tests code coverage. The method returns a JSON string and I cannot think of a good way to dynamically test
     */ 
    @isTest
    public static void test4_getPicklistsServer() {
		String projectInformation = COH_UIR_IntakeRequestFormController.getPicklistsServer(PROJECT_INFORMATION);
        String resourceInvolvement = COH_UIR_IntakeRequestFormController.getPicklistsServer(RESOURCE_INVOLVEMENT);
        String adoptionImpact = COH_UIR_IntakeRequestFormController.getPicklistsServer(ADOPTION_IMPACT);
        String LaborRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(LABOR_REQUEST);
        String infoSecRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(INFOSEC_REQUEST);
        String researchRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(RESEARCH_REQUEST);
        String capitalRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(CAPITAL_REQUEST);
        String itsRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(ITS_REQUEST);
        String facilitiesRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(FACILITIES_REQUEST);
        String fyPlanningRequest = COH_UIR_IntakeRequestFormController.getPicklistsServer(FY_PLANNING_REQUEST);
        
    }
    
    private static COH_UniversalIntakeRequest__c getNewUniversalIntakeRequest() {
        COH_UniversalIntakeRequest__c newRecord = new COH_UniversalIntakeRequest__c();
        
        insert newRecord;
        
        return newRecord;
    }
}