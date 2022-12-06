/*
 * This test class is for the IMSStatusReportFormController class
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
public class IMSStatusReportFormControllerTest {
   
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyIMSInjuryReportControllerClinical = true;
    private static final Boolean mRunVerifyIMSInjuryReportControllerNonClinical = true;
    private static final Boolean mRunVerifyExistingIMSInjuryReportControllerNonClinical = true;
    
    private static String ACTIVE_STATUS = 'Active';
    private static String PENDING_STATUS = 'Pending';
    private static String INCIDENT_NAME0 = 'Hostage Situation';
    private static String INCIDENT_NAME1 = 'Earthquake';
    private static String INCIDENT_NAME2 = 'Drill';
	private static String CATEGORY0 = 'Earthquake; Fire';
	private static String CATEGORY1 = 'Active Shooter';
	private static String CATEGORY2 = 'Environmental Systems; Flood';
	private static String CATEGORY3 = 'All';
    private static String STAFF_CATEGORY = 'Staff';
    private static String PATIENT_CATEGORY = 'Patient';
    private static String OTHER_CATEGORY = 'Other';
    private static String RESOURCE_STATUS = 'Pending Review';
    private static String RESOURCE_CATEGORY0 = 'Personnel';
    private static String RESOURCE_CATEGORY1 = 'Other';

    private static Decimal RESOURCE_QUANTITY0 = 2;
    private static Decimal RESOURCE_QUANTITY1 = 2.5;

    private static Integer INITIAL_INJURY_REPORT_SIZE = 3;
    private static Integer INITIAL_RESOURCE_REQUEST_SIZE = 2;
    private static Integer UPDATED_INJURY_REPORT_SIZE = 1;
    private static Integer UPDATED_RESOURCE_REQUEST_SIZE = 1;
    private static Integer CLINICAL = 0;
    private static Integer NON_CLINICAL = 1;
    
    private static Id mStatusReportFormID = null;
    private static Id mIncidentID0 = null;
    private static Id mIncidentID1 = null;
	private static Id mResourceRequestToDeleteID = null;
	private static Id mPatientInjuryReportToDeleteID = null;
	private static Id mOccupantInjuryReportToDeleteID = null;
    
    //
    //  Verify processing clinical status report forms
    //  
    
    private static testMethod void verifyIMSInjuryReportControllerClinical() {
        if (!mRunAllTests && !mRunVerifyIMSInjuryReportControllerClinical) {
            System.debug('Skipping verifyIMSInjuryReportControllerClinical()');
            return;
        }
		IMS_Status_Report_Form__c statusReportFormBaseObj = new IMS_Status_Report_Form__c();
        IMSStatusReportFormController sRFController = new IMSStatusReportFormController(new ApexPages.StandardController(statusReportFormBaseObj));
        createObjects();
        createSpecializedObjects(mIncidentID0, CLINICAL, sRFController);
        sRFController.submitReport();
        
        // Check the number of injury reports
        List<IMS_Injury_Report__c> injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(INITIAL_INJURY_REPORT_SIZE, injuryReportList.size());
        
		System.debug('Tracer0: injuryReportList.size()--> ' + injuryReportList.size());        
        //  Delete a patient injury report
        sRFController.selectedInjuriesReportID = mPatientInjuryReportToDeleteID;
        sRFController.deletePatientInjuryReport();
        sRFController.selectedInjuriesReportID = mOccupantInjuryReportToDeleteID;
        sRFController.deleteOccupantInjuryReport();
        
        injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(UPDATED_INJURY_REPORT_SIZE, injuryReportList.size());
        
        // Check the number of  resource requests
        List<IMS_Resource_Request__c> resourceRequestList = [select Id from IMS_Resource_Request__c];
        if (COHUtil.isValidList(resourceRequestList)) {
            System.assertEquals(INITIAL_RESOURCE_REQUEST_SIZE, resourceRequestList.size());
        }
                 
		sRFController.selectedResourceRequestID = mResourceRequestToDeleteID;
        sRFController.deleteResourceRequest();
        
        resourceRequestList = [select Id from IMS_Resource_Request__c];
        System.assertEquals(UPDATED_RESOURCE_REQUEST_SIZE, resourceRequestList.size());

        
        sRFController.nameToSearch = 'Wong';
        sRFController.searchUserNames();
        System.assertNotEquals(0, sRFController.usersList.size());
		System.debug('Tracer0:sRFController.usersList.size()--> ' + sRFController.usersList.size());        
        
        sRFController.isOccupantInjuryReportRefreshRequired = false;
        sRFController.addOccupantInjuries();
        System.assertEquals(true, sRFController.isOccupantInjuryReportRefreshRequired);
        
        sRFController.setOccupantInjuryReportRefreshRequiredToFalse();
        System.assertEquals(false, sRFController.isOccupantInjuryReportRefreshRequired);

        sRFController.isPatientInjuryReportRefreshRequired = false;
        sRFController.addPatientInjuries();
        System.assertEquals(true, sRFController.isPatientInjuryReportRefreshRequired);
        
        sRFController.setPatientInjuryReportRefreshRequiredToFalse();
        System.assertEquals(false, sRFController.isPatientInjuryReportRefreshRequired);
        
        sRFController.isOccupantInjuryReportRefreshRequired = false;
        sRFController.editOccupantInjuryReport();
        System.assertEquals(true, sRFController.isOccupantInjuryReportRefreshRequired);
        
        sRFController.isPatientInjuryReportRefreshRequired = false;
        sRFController.editPatientInjuryReport();
        System.assertEquals(true, sRFController.isPatientInjuryReportRefreshRequired);

        sRFController.isResourceRequestRefreshRequired = true;
        sRFController.searchResourceRequests();
        System.assertEquals(false, sRFController.isResourceRequestRefreshRequired);
        
        sRFController.isResourceRequestRefreshRequired = false;
        sRFController.editResourceRequest();
        System.assertEquals(true, sRFController.isResourceRequestRefreshRequired);
        
        // These are setters and getters--no need to do extensive testing.
	    sRFController.userIDsList = new List<Id>();
		sRFController.selectedUserName = 'test value';
		sRFController.namesOfUsers = 'test value';
		sRFController.selectedUserID = null;
		sRFController.staffType = 1;
        
    }
    
    //
    //  Verify processing non-clinical status report forms
    //  
    
    private static testMethod void verifyIMSInjuryReportControllerNonClinical() {
        if (!mRunAllTests && !mRunVerifyIMSInjuryReportControllerNonClinical) {
            System.debug('Skipping verifyIMSInjuryReportControllerNonClinical()');
            return;
        }
		IMS_Status_Report_Form__c statusReportFormBaseObj = new IMS_Status_Report_Form__c();
        IMSStatusReportFormController sRFController = new IMSStatusReportFormController(new ApexPages.StandardController(statusReportFormBaseObj));
        createSpecializedObjects(mIncidentID1, NON_CLINICAL, sRFController);
        sRFController.submitReport();
        
        // Check the number of injury reports
        List<IMS_Injury_Report__c> injuryReportList = [select Id from IMS_Injury_Report__c];
        System.debug('Tracer3: injuryReportList.size()--> ' + injuryReportList.size());
        System.assertEquals(INITIAL_INJURY_REPORT_SIZE, injuryReportList.size());
        
        //  Delete a patient injury report
        sRFController.selectedInjuriesReportID = mPatientInjuryReportToDeleteID;
        sRFController.deletePatientInjuryReport();
        sRFController.selectedInjuriesReportID = mOccupantInjuryReportToDeleteID;
        sRFController.deleteOccupantInjuryReport();
        injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(UPDATED_INJURY_REPORT_SIZE, injuryReportList.size());
        
        // Check the number of  resource requests
        List<IMS_Resource_Request__c> resourceRequestList = [select Id from IMS_Resource_Request__c];
        System.assertEquals(INITIAL_RESOURCE_REQUEST_SIZE, resourceRequestList.size());
                 
		sRFController.selectedResourceRequestID = mResourceRequestToDeleteID;
        sRFController.deleteResourceRequest();
        
        resourceRequestList = [select Id from IMS_Resource_Request__c];
        System.assertEquals(UPDATED_RESOURCE_REQUEST_SIZE, resourceRequestList.size());
        
        sRFController.nameToSearch = 'Wong';
        sRFController.searchUserNames();
        System.assertNotEquals(0, sRFController.usersList.size());
        
        sRFController.isOccupantInjuryReportRefreshRequired = false;
        sRFController.addOccupantInjuries();
        System.assertEquals(true, sRFController.isOccupantInjuryReportRefreshRequired);
        
        sRFController.setOccupantInjuryReportRefreshRequiredToFalse();
        System.assertEquals(false, sRFController.isOccupantInjuryReportRefreshRequired);

        sRFController.isPatientInjuryReportRefreshRequired = false;
        sRFController.addPatientInjuries();
        System.assertEquals(true, sRFController.isPatientInjuryReportRefreshRequired);
        
        sRFController.setPatientInjuryReportRefreshRequiredToFalse();
        System.assertEquals(false, sRFController.isPatientInjuryReportRefreshRequired);
        
        sRFController.isOccupantInjuryReportRefreshRequired = false;
        sRFController.editOccupantInjuryReport();
        System.assertEquals(true, sRFController.isOccupantInjuryReportRefreshRequired);
        
        sRFController.isPatientInjuryReportRefreshRequired = false;
        sRFController.editPatientInjuryReport();
        System.assertEquals(true, sRFController.isPatientInjuryReportRefreshRequired);

        sRFController.isResourceRequestRefreshRequired = true;
        sRFController.searchResourceRequests();
        System.assertEquals(false, sRFController.isResourceRequestRefreshRequired);
        
        sRFController.isResourceRequestRefreshRequired = false;
        sRFController.editResourceRequest();
        System.assertEquals(true, sRFController.isResourceRequestRefreshRequired);

    }

    //
    //  Verify processing existing non-clinical status report forms
    //  
    
    private static testMethod void verifyExistingIMSInjuryReportControllerNonClinical() {
        if (!mRunAllTests && !mRunVerifyExistingIMSInjuryReportControllerNonClinical) {
            System.debug('Skipping verifyExistingIMSInjuryReportControllerNonClinical()');
            return;
        }
		
        IMS_Status_Report_Form__c statusReportFormBaseObj = createSpecializedObjectsPreExisting(mIncidentID0);
		ApexPages.CurrentPage().getparameters().put('id', mStatusReportFormID);   
        IMSStatusReportFormController sRFController = new IMSStatusReportFormController(new ApexPages.StandardController(statusReportFormBaseObj));

        IMS_Injury_Report__c injuryReport = new IMS_Injury_Report__c();
        injuryReport.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport.Person_Category__c = OTHER_CATEGORY;
        insert injuryReport;
        
        sRFController.cancelReport();
        // Check the number of injury reports
        List<IMS_Injury_Report__c> injuryReportList = [select Id from IMS_Injury_Report__c];
        System.assertEquals(INITIAL_INJURY_REPORT_SIZE, injuryReportList.size());
        System.debug('Tracer7: injuryReportList.size()-->' + injuryReportList.size());
        
	}
    
    //
    // Create common objects for testing
    // 

    private static void createObjects() {
        
        IMS_Incident_Document__c incidentDocument0 = new IMS_Incident_Document__c();
//		incidentDocument0.Active__c = true;
        incidentDocument0.Category__c = CATEGORY0;
        insert incidentDocument0;
        
        IMS_Incident_Document__c incidentDocument1 = new IMS_Incident_Document__c();
        incidentDocument1.Category__c = CATEGORY1;
        insert incidentDocument1;
        
        IMS_Incident_Document__c incidentDocument2 = new IMS_Incident_Document__c();
        incidentDocument2.Category__c = CATEGORY2;
        insert incidentDocument2;
        
        IMS_Incident_Document__c incidentDocument3 = new IMS_Incident_Document__c();
        incidentDocument3.Category__c = CATEGORY3;
        insert incidentDocument3;
        
        IMS_Incident_Document__c incidentDocument4 = new IMS_Incident_Document__c();
        incidentDocument4.Category__c = CATEGORY3;
        insert incidentDocument4;
        
        IMS_Incident__c incident0 = new IMS_Incident__c();
        incident0.Name = INCIDENT_NAME0;
        incident0.Incident_Category__c = CATEGORY1;
        incident0.Status__c = ACTIVE_STATUS;
        incident0.Start_Date_Time__c = Date.today();
        insert incident0;
        
        mIncidentID0 = incident0.Id;

        incident0.Incident_Category__c = CATEGORY0;
        update incident0;
        
        IMS_Incident__c incident1 = new IMS_Incident__c();
        incident1.Name = INCIDENT_NAME1;
        incident1.Incident_Category__c = CATEGORY2;
        incident1.Status__c = PENDING_STATUS;
        incident1.Start_Date_Time__c = Date.today();
        insert incident1;
        
        mIncidentID1 = incident1.Id;

    }

    //
	// Create specialized objects for testing clinical and non-clinical status report forms.
	// 

    private static void createSpecializedObjects(Id incidentID, Integer reportType, IMSStatusReportFormController sRFController) {
        
        if (reportType == CLINICAL) {
	        sRFController.startNewClinicalReport();
        } else if (reportType == NON_CLINICAL) {
	        sRFController.startNewNonClinicalReport();
        } else {
            System.assert(false, 'Unrecognized report type: ' + reportType);
        }
        
        IMS_Status_Report_Form__c statusReportFormObj = sRFController.statusReportFormObj;
        statusReportFormObj.Incident_Name__c = incidentID;
		mStatusReportFormID = statusReportFormObj.Id;
    
        IMS_Injury_Report__c injuryReport0 = new IMS_Injury_Report__c();
        injuryReport0.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport0.Person_Category__c = STAFF_CATEGORY;
        insert injuryReport0;
        
        IMS_Injury_Report__c injuryReport1 = new IMS_Injury_Report__c();
        injuryReport1.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport1.Person_Category__c = PATIENT_CATEGORY;
        insert injuryReport1;

        mOccupantInjuryReportToDeleteID = injuryReport0.Id;		// mark for deletion
		mPatientInjuryReportToDeleteID = injuryReport1.Id;		// mark for deletion

        IMS_Injury_Report__c injuryReport2 = new IMS_Injury_Report__c();
        injuryReport2.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport2.Person_Category__c = OTHER_CATEGORY;
        insert injuryReport2;
        
        IMS_Resource_Request__c resourceRequest0 = new IMS_Resource_Request__c();
        resourceRequest0.IMS_Status_Report_Form__c = mStatusReportFormID;
        resourceRequest0.Status__c = RESOURCE_STATUS;
        resourceRequest0.Category__c = RESOURCE_CATEGORY0;
        resourceRequest0.Quantity__c = RESOURCE_QUANTITY0;
        insert resourceRequest0;
        
        IMS_Resource_Request__c resourceRequest1 = new IMS_Resource_Request__c();
        resourceRequest1.IMS_Status_Report_Form__c = mStatusReportFormID;
        resourceRequest0.Status__c = RESOURCE_STATUS;
        resourceRequest1.Status__c = RESOURCE_CATEGORY1;
        resourceRequest1.Quantity__c = RESOURCE_QUANTITY1;
        insert resourceRequest1;
        
        mResourceRequestToDeleteID = resourceRequest1.Id;		// mark for deletion
    }    

	//
	// Create objects for testing existing Non-clinical IMS Status Report Form object
	// 

    private static IMS_Status_Report_Form__c createSpecializedObjectsPreExisting(Id incidentID) {
        IMS_Status_Report_Form__c statusReportFormObj = new IMS_Status_Report_Form__c();
        statusReportFormObj.Incident_Name__c = incidentID;
        insert statusReportFormObj;
        
		mStatusReportFormID = statusReportFormObj.Id;
    
        IMS_Injury_Report__c injuryReport0 = new IMS_Injury_Report__c();
        injuryReport0.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport0.Person_Category__c = STAFF_CATEGORY;
        insert injuryReport0;
        
        IMS_Injury_Report__c injuryReport1 = new IMS_Injury_Report__c();
        injuryReport1.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport1.Person_Category__c = PATIENT_CATEGORY;
        insert injuryReport1;

        IMS_Injury_Report__c injuryReport2 = new IMS_Injury_Report__c();
        injuryReport1.IMS_Status_Report_Form__c = mStatusReportFormID;
        injuryReport1.Person_Category__c = OTHER_CATEGORY;
        insert injuryReport2;
        
        IMS_Resource_Request__c resourceRequest0 = new IMS_Resource_Request__c();
        resourceRequest0.IMS_Status_Report_Form__c = mStatusReportFormID;
        resourceRequest0.Status__c = RESOURCE_CATEGORY0;
        resourceRequest0.Quantity__c = RESOURCE_QUANTITY0;
        insert resourceRequest0;
        
        IMS_Resource_Request__c resourceRequest1 = new IMS_Resource_Request__c();
        resourceRequest1.IMS_Status_Report_Form__c = mStatusReportFormID;
        resourceRequest1.Status__c = RESOURCE_CATEGORY1;
        resourceRequest1.Quantity__c = RESOURCE_QUANTITY1;
        insert resourceRequest1;
        
        mResourceRequestToDeleteID = resourceRequest1.Id;		// mark for deletion
        
        return statusReportFormObj;
    }
}