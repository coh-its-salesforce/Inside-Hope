/*
 * This test class is for the IMSInjuryReportController class
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class IMSInjuryReportControllerTest {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyIMSInjuryReportController = true;
    private static final Boolean mRunExistingVerifyIMSInjuryReportController = true;

    private static String ACTIVE_STATUS = 'Active';
    private static String INCIDENT_NAME0 = 'Hostage Situation';
	private static String CATEGORY0 = 'Earthquake; Fire';
    private static String STAFF_CATEGORY = 'Staff';
    private static String PATIENT_CATEGORY = 'Patient';

    private static String PARENT_ID_PARAM = 'param';
    private static String RECORD_TYPE_PARAM = 'recordTypeParam';
    private static String INJURY_OBJ_ID_PARAM = 'objIDParam';
    private static String FIRST_NAME = 'Thomas';
    private static String LAST_NAME = 'Magnum';
    
    private static Integer INITIAL_INJURY_REPORT_SIZE = 1;
    private static Integer UPDATED_INJURY_REPORT_SIZE = 2;

    private static Id mIncidentID0;
    private static Id mStatusReportFormID = null;
    private static Id mExistingInjuryReportID = null;
    private static String mClinicalRecordType = 'Clinical';
    private static String mClinicalRecordTypeID;
    
    //
    //  Verify processing of a new record
    //  
    
    private static testMethod void verifyIMSInjuryReportController() {
        if (!mRunAllTests && !mRunVerifyIMSInjuryReportController) {
            System.debug('Skipping verifyIMSInjuryReportController()');
            return;
        }
        
        createObjects();
		IMS_Injury_Report__c injuryReportObj = new IMS_Injury_Report__c();
		ApexPages.CurrentPage().getparameters().put(PARENT_ID_PARAM, mStatusReportFormID);   
		ApexPages.CurrentPage().getparameters().put(RECORD_TYPE_PARAM, mClinicalRecordType);   
        IMSInjuryReportController iRController = new IMSInjuryReportController(new ApexPages.StandardController(injuryReportObj));
        
        iRController.injuryReportObj.First_Name__c = FIRST_NAME;
        iRController.injuryReportObj.Last_Name__c = LAST_NAME;
        iRController.saveRecord();
        
        // Check the number of injury reports
        List<IMS_Injury_Report__c> injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(UPDATED_INJURY_REPORT_SIZE, injuryReportList.size());
        
        iRController.saveAndNewRecord();
    }    

    //
    //  Verify processing of an existing record
    //  
    
    private static testMethod void verifyExistingIMSInjuryReportController() {
        if (!mRunAllTests && !mRunExistingVerifyIMSInjuryReportController) {
            System.debug('Skipping mRunExistingVerifyIMSInjuryReportController()');
            return;
        }
        createObjects();
		IMS_Injury_Report__c injuryReportObj = new IMS_Injury_Report__c();
		ApexPages.CurrentPage().getparameters().put(PARENT_ID_PARAM, mStatusReportFormID);   
		ApexPages.CurrentPage().getparameters().put(INJURY_OBJ_ID_PARAM, mExistingInjuryReportID);   
        IMSInjuryReportController iRController = new IMSInjuryReportController(new ApexPages.StandardController(injuryReportObj));
        
        List<IMS_Injury_Report__c> injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(INITIAL_INJURY_REPORT_SIZE, injuryReportList.size());
//        System.debug('Tracer0: injuryReportList.size())--> ' + injuryReportList.size());
//        iRController.injuryReportObj.First_Name__c = FIRST_NAME;
//        iRController.injuryReportObj.Last_Name__c = LAST_NAME;
//        iRController.cancelRecord();
        
        // Check the number of injury reports
//        injuryReportList = [select Id from IMS_Injury_Report__c];
//        System.debug('Tracer1: injuryReportList.size())--> ' + injuryReportList.size());
//        System.assertEquals(INITIAL_INJURY_REPORT_SIZE, injuryReportList.size());
        
    }    

    //
    // Create objects for testing
    // 

    private static void createObjects() {

        COHUtilTester.setIMSConfiguration();
        
        IMS_Incident__c incident0 = new IMS_Incident__c();
        incident0.Name = INCIDENT_NAME0;
        incident0.Incident_Category__c = CATEGORY0;
        incident0.Status__c = ACTIVE_STATUS;
        incident0.Start_Date_Time__c = Date.today();
        insert incident0;
        
        mIncidentID0 = incident0.Id;

        IMS_Status_Report_Form__c statusReportFormObj = new IMS_Status_Report_Form__c();
        statusReportFormObj.Incident_Name__c = mIncidentID0;
        insert statusReportFormObj;
        
		mStatusReportFormID = statusReportFormObj.Id;
    
        IMS_Injury_Report__c injuryReport0 = new IMS_Injury_Report__c();
        injuryReport0.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport0.Person_Category__c = STAFF_CATEGORY;
        mClinicalRecordTypeID = [select Id,name from RecordType where name = :mClinicalRecordType and SObjectType = 'IMS_Injury_Report__c' limit 1].Id;
		injuryReport0.RecordTypeId = mClinicalRecordTypeID;
        insert injuryReport0;
        
        mExistingInjuryReportID = injuryReport0.Id;
        
    }

}