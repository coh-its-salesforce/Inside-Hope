/*
 * This test class is for the IMSResourceRequestController class
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
public class IMSResourceRequestControllerTest {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyIMSResourceRequestController = true;
    private static final Boolean mRunExistingVerifyIMSResourceRequestController = true;
    
    private static String PARENT_ID_PARAM = 'param';
    private static String RESOURCE_OBJ_ID_PARAM = 'objIDParam';
    private static String ACTIVE_STATUS = 'Active';
    private static String DEFAULT_STATUS = 'Pending Review';
    private static String INCIDENT_NAME0 = 'Hostage Situation';
	private static String CATEGORY0 = 'Earthquake; Fire';
    private static String RESOURCE_CATEGORY0 = 'Staff';

    private static Decimal RESOURCE_QUANTITY0 = 2;

    private static Integer INITIAL_RESOURCE_REQUEST_SIZE = 1;
    private static Integer UPDATED_RESOURCE_REQUEST_SIZE = 2;
    
    private static Id mIncidentID0;
    private static Id mStatusReportFormID = null;
    private static Id mExistingResourceRequestID = null;
    
    //
    //  Verify processing of a new record
    //  
    
    private static testMethod void verifyIMSResourceRequestController() {
        if (!mRunAllTests && !mRunVerifyIMSResourceRequestController) {
            System.debug('Skipping mRunVerifyIMSResourceRequestController()');
            return;
        }
        
        createObjects();
        IMS_Resource_Request__c resourceRequestObj = new IMS_Resource_Request__c();
		ApexPages.CurrentPage().getparameters().put(PARENT_ID_PARAM, mStatusReportFormID);   
        IMSResourceRequestController rRController = new IMSResourceRequestController(new ApexPages.StandardController(resourceRequestObj));
        rRController.resourceRequestObj.Status__c = DEFAULT_STATUS;
        rRController.resourceRequestObj.Category__c = RESOURCE_CATEGORY0;
        rRController.resourceRequestObj.Quantity__c = RESOURCE_QUANTITY0;
        rRController.saveRecord();
        
        // Check the number of resource reports
        List<IMS_Resource_Request__c> resourceRequestList = [select Id from IMS_Resource_Request__c];
        if (COHUtil.isValidList(resourceRequestList)) {
            System.assertEquals(UPDATED_RESOURCE_REQUEST_SIZE, resourceRequestList.size());
        }
        
        rRController.saveAndNewRecord();
    }

    //
    //  Verify processing of an existing record
    //  
    
    private static testMethod void verifyExistingIMSResourceRequestController() {
        if (!mRunAllTests && !mRunExistingVerifyIMSResourceRequestController) {
            System.debug('Skipping mRunExistingVerifyIMSResourceRequestController()');
            return;
        }
        createObjects();
        IMS_Resource_Request__c resourceRequestObj = new IMS_Resource_Request__c();
		ApexPages.CurrentPage().getparameters().put(PARENT_ID_PARAM, mStatusReportFormID);   
		ApexPages.CurrentPage().getparameters().put(RESOURCE_OBJ_ID_PARAM, mExistingResourceRequestID);   
        IMSResourceRequestController rRController = new IMSResourceRequestController(new ApexPages.StandardController(resourceRequestObj));
        rRController.resourceRequestObj.Status__c = RESOURCE_CATEGORY0;
        rRController.resourceRequestObj.Quantity__c = RESOURCE_QUANTITY0;
        
        rRController.cancelRecord();
        
        // Check the number of resource reports
        List<IMS_Resource_Request__c> resourceRequestList = [select Id from IMS_Resource_Request__c];
        if (COHUtil.isValidList(resourceRequestList)) {
            System.assertEquals(INITIAL_RESOURCE_REQUEST_SIZE, resourceRequestList.size());
        }
        
    }
    
    //
    // Create objects for testing
    // 

    private static void createObjects() {
        
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
        
        IMS_Resource_Request__c resourceRequest0 = new IMS_Resource_Request__c();
        resourceRequest0.IMS_Status_Report_Form__c = mStatusReportFormID;
        resourceRequest0.Status__c = RESOURCE_CATEGORY0;
        resourceRequest0.Quantity__c = RESOURCE_QUANTITY0;
        insert resourceRequest0; 
        
        mExistingResourceRequestID = resourceRequest0.Id;
    }


}