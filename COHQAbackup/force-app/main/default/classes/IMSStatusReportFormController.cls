/*
 * This is the controller for the IMS Status Report Visualforce page.
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

public class IMSStatusReportFormController {

    public IMS_Status_Report_Form__c statusReportFormObj {get; set;}
    public List<IMS_Injury_Report__c> staffInjuriesList {get; set;}
    public List<IMS_Injury_Report__c> patientInjuriesList {get; set;}
    public List<IMS_Resource_Request__c> resourceRequestsList {get; set;}
    public List<User> usersList {get; set;}
    public List<Id> userIDsList {get; set;}
    public String nameToSearch {get; set;}    
    public String selectedUserName {get; set;}
    public String namesOfUsers {get; set;}
    public String editButtonMessage {get; set;}
    public String recordType {get; set;}    
//    public String sfdcBaseURL {get; set;}
    
    public Id selectedUserID {get; set;}
    public Id currentStatusReportFormID {get; set;}
    
    public Id selectedInjuriesReportID {get; set;}
    public Id selectedResourceRequestID {get; set;}
    public Integer staffType {get; set;}
    
    public Boolean isStartReportDisabled {get; set;}
    public Boolean isSubmitReportDisabled {get; set;}
    public Boolean isOccupantInjuryReportRefreshRequired {get; set;}
    public Boolean isPatientInjuryReportRefreshRequired {get; set;}
    public Boolean isResourceRequestRefreshRequired {get; set;}
    public Boolean isExistingRecord {get; set;}
    public Boolean renderPageBlockSections {get; set;}
    public Boolean renderRemainingOperationHours {get; set;}
    public Boolean statusReportSelected {get; set;}
    
	private static final String STATUS_REPORT_FORM = 'IMS_Status_Report_Form__c';
	private static final String IMS_APPLICATION = 'Incident Management System';
    private static final String CLINICAL_RECORD_TYPE = 'Clinical';
    private static final String NON_CLINICAL_RECORD_TYPE = 'Non-clinical';
    private static final String START_NEW_REPORT = 'Start New Report';
    private static final String EDIT_CURRENT_REPORT = 'Edit Current Report';
	private static final String NEW_STATUS = 'New';
	private static final String YES = 'Yes';
    
    private ApexPages.StandardController localController =  null;
    private List<String> userNames;
    private IMS_Status_Report_Form__c originalStatusReportFormObj = null;
    private List<IMS_Injury_Report__c> originalInjuryReportObjList = null;
    private List<IMS_Resource_Request__c>  originalResourceRequestObjList = null;
    private String userSearchSoqlQuery = 'select Name, Email, Department, Division from User ';
    private String occupantInjuriesSearchSoqlQuery = null;
    private String patientInjuriesSearchSoqlQuery = null;
    private String resourceRequestsSearchSoqlQuery = null;
    private String retrieveIMStatusReportObjectSoqlQuery = null;
    private String retrieveInjuryReportChildSoqlQuery = 'select Id from IMS_Injury_Report__c where IMS_Status_Report_Form__c = :currentStatusReportFormID';
    private String retrieveResourceRequestChildSoqlQuery = 'select Id from IMS_Resource_Request__c where IMS_Status_Report_Form__c = :currentStatusReportFormID';
    
    /*
     * Constructor
     * 
     * @param	controller	Standard controller instance.
     * 
     */
    public IMSStatusReportFormController(ApexPages.StandardController controller) {
        initialize(controller);
    }

    /* 
     * Initialize variables.  A new instance of a IMS_Injury_Report__c object is created.
     * 
     */
    private void initialize(ApexPages.StandardController controller) {
        if (localController == null) {
            localController = controller;
			statusReportSelected = false;
            
            renderPageBlockSections = false;			// default value when landing on this page
            renderRemainingOperationHours = true;		// should actually be set to false initially
            											// but the logic for rendering it will be done later
            
//	        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

            // Retrieve the object ID if editing or viewing an existing object.
            System.PageReference pageRef = ApexPages.currentPage();
            Map<String, String> paramMap = pageRef.getParameters();
            String existingIMSStatusReportFormID = paramMap.get('id');
            if (COHUtil.isValidStr(existingIMSStatusReportFormID)) {
                isExistingRecord = true;
                retrieveIMStatusReportObjectSoqlQuery = COHUtil.buildSelectAllSOQLStatement(STATUS_REPORT_FORM);
                retrieveIMStatusReportObjectSoqlQuery += 'where id = :existingIMSStatusReportFormID';
				List<IMS_Status_Report_Form__c> statusReportFormObjList = Database.query(retrieveIMStatusReportObjectSoqlQuery);
                if (COHUtil.isValidList(statusReportFormObjList)) {
                    statusReportFormObj = statusReportFormObjList.get(0);
					currentStatusReportFormID = statusReportFormObj.Id;
                  	searchOccupantInjuries();
                    searchPatientInjuries();
                    originalInjuryReportObjList = new List<IMS_Injury_Report__c>();
                    originalInjuryReportObjList.addAll(patientInjuriesList);
                    originalInjuryReportObjList.addAll(staffInjuriesList);
                    
                    searchResourceRequests();
					originalResourceRequestObjList = resourceRequestsList;                
                }
                // create a copy to check if the fields have changed
	            originalStatusReportFormObj = statusReportFormObj;
				editButtonMessage = EDIT_CURRENT_REPORT;
                setReportButtonsExistingRecord();
            } else {
                isExistingRecord = false;
				editButtonMessage = START_NEW_REPORT;
                resetReportButtons();
            }
    	}
    }
    
    /*
     * Resets the child objects as the most up-to-date list so that they will not be deleted
     * when the record is canceled in the future.
     * 
     */
    private void resetChildObjects() {
        searchOccupantInjuries();
        searchPatientInjuries();
        originalInjuryReportObjList = new List<IMS_Injury_Report__c>();
        originalInjuryReportObjList.addAll(patientInjuriesList);
        originalInjuryReportObjList.addAll(staffInjuriesList);
        
        searchResourceRequests();
        originalResourceRequestObjList = resourceRequestsList;                
        
    }    

    /*
     * Sets the statusReportSelected to true.  This occurs when the user
     * selects a status report type from the IMS_Select_Status_Report_Form_Type
     * VisualForce page.  This is used by that page to determine how many pages
     * to go back when the user clicks on the "Finished" button.
     * 
     */
    public void setStatusReportTrue() {
        statusReportSelected = true;
    }
    
    /*
     * Sets the statusReportSelected to false.  
     * 
     */
    public void setStatusReportFalse() {
        statusReportSelected = false;
    }
    
    /* 
     * Search user names and assign the results to the usersList variable.
     * 
     */
    public void searchUserNames() {
        String finalSoqlQuery = userSearchSoqlQuery;
        if (COHUtil.isValidStr(nameToSearch)) {
            finalSoqlQuery += 'where Name like \'%' +  nameToSearch + '%\'';
	        usersList = Database.query(finalSoqlQuery);
        } 
    }

	/* 
	 * Add non-patient, occupant injury record after refreshing the current list of injuries  
	 * 
	 */
    public void addOccupantInjuries() {
		searchOccupantInjuries();
        isOccupantInjuryReportRefreshRequired = true;  // set to false in searchOccupantInjuries; reset to true.
    }

	/* 
	 * Get the list of non-patient occupant injuries.
	 * 
	 */
    public void searchOccupantInjuries() {
        if (occupantInjuriesSearchSoqlQuery == null) {
			occupantInjuriesSearchSoqlQuery = buildOccupantInjuryReportSOQLStatement();
        }
        staffInjuriesList = Database.query(occupantInjuriesSearchSoqlQuery);
        setOccupantInjuryReportRefreshRequiredToFalse();
        
        if (COHUtil.isValidList(staffInjuriesList)) {
            statusReportFormObj.Number_Of_Injured_People__c = staffInjuriesList.size();
        }
	}
    
    /*
     * Set the isOccupantInjuryReportRefreshRequired variable to true.
     * 
     */
    public void setOccupantInjuryReportRefreshRequiredToTrue() {
        isOccupantInjuryReportRefreshRequired = true;
    }
    
    /*
     * Set the isOccupantInjuryReportRefreshRequired variable to false.
     * 
     */
    public void setOccupantInjuryReportRefreshRequiredToFalse() {
        isOccupantInjuryReportRefreshRequired = false;
    }
    
	/* 
	 * Add patient  injury record after refreshing the current list of injuries  
	 * 
	 */
    public void addPatientInjuries() {
		searchPatientInjuries();
        isPatientInjuryReportRefreshRequired = true;  // set to false in searchPatientInjuries; reset to true.
    }

	/* 
	 * Get the list of patient injuries.
	 * 
	 */
    public void searchPatientInjuries() {
        if (patientInjuriesSearchSoqlQuery == null) {
			patientInjuriesSearchSoqlQuery = buildPatientInjuryReportSOQLStatement();
        }
        patientInjuriesList = Database.query(patientInjuriesSearchSoqlQuery);
        isPatientInjuryReportRefreshRequired = false;
        
        if (COHUtil.isValidList(patientInjuriesList)) {
            statusReportFormObj.Number_Of_Injured_Patients__c = patientInjuriesList.size();
        }
	}

    /*
     * Set the isPatientInjuryReportRefreshRequired variable to true.
     * 
     */
    public void setPatientInjuryReportRefreshRequiredToTrue() {
        isPatientInjuryReportRefreshRequired = true;
    }
    
    /*
     * Set the isPatientInjuryReportRefreshRequired variable to false.
     * 
     */
    public void setPatientInjuryReportRefreshRequiredToFalse() {
        isPatientInjuryReportRefreshRequired = false;
    }
    
    /*
     * Enables the "Refresh List" button for occupant injuries after a record is edited.  
     * The actual editing is done in a Javascript popup window.
     * 
     */
    public void editOccupantInjuryReport() {
		setOccupantInjuryReportRefreshRequiredToTrue();	// force a reload later
        selectedInjuriesReportID = null;				// clear it for the next usage
    }
    
    /*
     * Enables the "Refresh List" button for patient injuries after a record is edited.  
     * The actual editing is done in a Javascript popup window.
     * 
     */
    public void editPatientInjuryReport() {
		setPatientInjuryReportRefreshRequiredToTrue();	// force a reload later
        selectedInjuriesReportID = null;				// clear it for the next usage
    }
    
    /* 
     * Delete the occupant injury report in a row.
     * 
     */
    public void deleteOccupantInjuryReport() {
        if (selectedInjuriesReportID != null) {
            Database.delete(selectedInjuriesReportID);
            searchOccupantInjuries();
        }
        selectedInjuriesReportID = null;
    }
    
    /* 
     * Delete the patient injury report in a row.
     * 
     */
    public void deletePatientInjuryReport() {
        if (selectedInjuriesReportID != null) {
            Database.delete(selectedInjuriesReportID);
            searchPatientInjuries();
        }
        selectedInjuriesReportID = null;
    }
    
    /*
     * Set the value of isResourceRequestRefreshRequired to true.
     * 
     */
    public void setResourceRequestRefreshRequiredToTrue() {
        isResourceRequestRefreshRequired = true;
    }
    
    /*
     * Set the value of isResourceRequestRefreshRequired to false.
     * 
     */
    public void setResourceRequestRefreshRequiredToFalse() {
        isResourceRequestRefreshRequired = false;
    }
    
	/* 
	 * Get the list of resource requests.
	 * 
	 */
    public void searchResourceRequests() {
        if (resourceRequestsSearchSoqlQuery == null) {
			resourceRequestsSearchSoqlQuery = buildResourceRequestSOQLStatement();
        }
        resourceRequestsList = Database.query(resourceRequestsSearchSoqlQuery);
		setResourceRequestRefreshRequiredToFalse();
    }
    
    /*
     * Enables the "Refresh List" button for resource requests after a record is edited.  
     * The actual editing is done in a Javascript popup window.
     * 
     */
    public void editResourceRequest() {
        setResourceRequestRefreshRequiredToTrue();
        selectedResourceRequestID = null;		// Clear it for the next usage
    }
    
    /* 
     * Delete the resource request in a row.
     * 
     */
    public void deleteResourceRequest() {
        if (selectedResourceRequestID != null) {
            Database.delete(selectedResourceRequestID);
            searchResourceRequests();
        }
        selectedResourceRequestID = null;
    }
    
	/*
	 * Start a new Clinical Status Report Form object.  
	 * 
	 */
    public void startNewClinicalReport() {
        if (!isExistingRecord) {
            statusReportFormObj = new IMS_Status_Report_Form__c();
			statusReportFormObj.RecordTypeId = COHUtil.getRecordType(STATUS_REPORT_FORM, CLINICAL_RECORD_TYPE);
            recordType = (String) COHUtil.getConfigurationValue(IMS_APPLICATION, CLINICAL_RECORD_TYPE);
            Database.insert(statusReportFormObj);
        }
        startNewReportHelper();
    }

	/*
	 * Start a new Non-Clinical Status Report Form object.  
	 * 
	 */
    public void startNewNonClinicalReport() {
        if (!isExistingRecord) {
			statusReportFormObj = new IMS_Status_Report_Form__c();
			statusReportFormObj.RecordTypeId = COHUtil.getRecordType(STATUS_REPORT_FORM, NON_CLINICAL_RECORD_TYPE);
            recordType = (String) COHUtil.getConfigurationValue(IMS_APPLICATION, NON_CLINICAL_RECORD_TYPE);
			Database.insert(statusReportFormObj);
        }
        startNewReportHelper();
    }

    /*
     * Saves a record to the database.
     * 
     */
    public void submitReport() {
        // testing--raymond tam
        // Should we check to make sure the Incident Name has been entered
        if (isExistingRecord == false) {
        	statusReportFormObj.Status__c = NEW_STATUS;
        }
        Database.update(statusReportFormObj);
        resetReportButtons();
        resetChildObjects();
        editButtonMessage = EDIT_CURRENT_REPORT;		
        isExistingRecord = true;
    }

	/*
	 * Cancels the current Status Report Form object by deleting it and any child objects that are 
	 * Status Report Form or Resource Request objects.
	 * 
	 */
    public void cancelReport() {
        if (statusReportFormObj != null && statusReportFormObj.Id != null) {
            List<IMS_Injury_Report__c> allInjuryReportObjects = Database.query(retrieveInjuryReportChildSoqlQuery);            
            List<IMS_Resource_Request__c> allResourceRequestObjects = Database.query(retrieveResourceRequestChildSoqlQuery);            
            
            // If it's a new record, delete all injury report objects, resource request objects, and
            // the status report form because they were added in the session.
			if (!isExistingRecord) {
                Database.delete(allInjuryReportObjects);
                Database.delete(allResourceRequestObjects);
    	        Database.delete(statusReportFormObj);
	            statusReportFormObj = null;
            } else {
                
                // Delete only the newly-added injury report objects and
                // keep the pre-existing ones.
                List<IMS_Injury_Report__c> injuryReportObjectsToDelete = (List<IMS_Injury_Report__c>) getChildObjectsToDeleteList(originalInjuryReportObjList, allInjuryReportObjects);
                if (COHUtil.isValidList(injuryReportObjectsToDelete)) {
                    Database.delete(injuryReportObjectsToDelete);
                }
                
            	// Delete only the newly-added resource request objects and
                // keep the pre-existing ones.
                List<IMS_Resource_Request__c> resourceReqeustObjectsToDelete = (List<IMS_Resource_Request__c>) getChildObjectsToDeleteList(originalResourceRequestObjList, allResourceRequestObjects);
                if (COHUtil.isValidList(resourceReqeustObjectsToDelete)) {
                    Database.delete(resourceReqeustObjectsToDelete);
                }
            }            

        }
        resetReportButtons();
    }

	/*
	 * Start a new Status Report Form object.  This must be called before any updates can be
	 * done to that object.
	 * 
	 */
    private void startNewReportHelper() {
        currentStatusReportFormID = statusReportFormObj.Id;

    	isStartReportDisabled = true;
    	isSubmitReportDisabled = false;
        renderPageBlockSections = true;
        searchOccupantInjuries();
        searchPatientInjuries();
        searchResourceRequests();
		setUtilityDefaultValue();
        
    }

    
    /* 
     * Builds a list of all child objects to delete when the Cancel button is clicked.
     * This will be used to remove the child objects that were added in the current 
     * editing session.
     * 
     * @param existingObjects	List of existing child object that were not added in the 
     * 							current editing session.
     * @param allObjects		List of all child objects
     * @return					List of child objects that were added in the current editing session.
     * 
     */
    private List<SObject> getChildObjectsToDeleteList(List<SObject> existingObjects, List<SObject> allObjects) {
        if (!COHUtil.isValidList(allObjects)) {		// None of the existing objects need to be deleted.
            return null;
        }
        
        if (!COHUtil.isValidList(existingObjects)) {	// Delete all newly-added objects
            return allObjects;
        }
        
        //  Delete only the newly-added objects
        List<SObject> objectsToDelete = new List<SObject>();
        for (SObject currentObj : allObjects) {
            Id currentID = currentObj.Id;
            Boolean preExistingObject = false;
            for (SObject existingObject : existingObjects) {
                Id existingID = existingObject.Id;
                if (currentID.equals(existingID)) {
		            preExistingObject = true;
                    break;
                }
            }   
            if (preExistingObject == false) {
                objectsToDelete.add(currentObj);
            }
        }
        if (objectsToDelete.size() > 0) {
        	return objectsToDelete;
        } else {
            return null;
        }
    }
    
    /*
     * Reset the command buttons.
     * 
     */
    private void resetReportButtons() {
        isStartReportDisabled = false;
    	isSubmitReportDisabled = true;
        renderPageBlockSections = false;
    }
    
    /*
     * Set the command buttons for an existing record.
     * 
     */
    private void setReportButtonsExistingRecord() {
        isStartReportDisabled = true;
    	isSubmitReportDisabled = false;
        renderPageBlockSections = true;
    }
    /*
     * Get the object key prefix for the specific object type.
     * 
     * @param	objectType	Integer indicating the object type.
     * @return				String representing the object key prefix.
     * 
     */
/*    
    public String getObjKeyPrefix(Integer objectType){
        Schema.DescribeSObjectResult dsor;
        if (objectType == INJURY_REPORT_OBJECT_TYPE) {
			dsor = IMS_Injury_Report__c.sObjectType.getDescribe();
        } else if (objectType == RESOURCE_REQUEST_OBJECT_TYPE) {
            dsor = IMS_Resource_Request__c.sObjectType.getDescribe();
        }
    
        if (dsor != null) {
			return dsor.getKeyPrefix();
        } else {
            return null;
        }
    }
    
    // get the object prefix for the IMS_Injury_Report__c object
    public String getInjuryReportObjectPrefix() {
        return injuryReportObjectPrefix;
    }
    
    // get the object prefix for the IMS_Resource_Request__c object
    public String getResourceRequestObjectPrefix() {
        return resourceRequestObjectPrefix;
    }

*/    
    /*
     * Builds the SOQL query to retrieve all non-patient, occupant injury reports.
     * 
     * @return			SOQL query string to execute.
     * 
     */
    private String buildOccupantInjuryReportSOQLStatement() {
        String soqlString = COHUtil.buildSelectAllSOQLStatement('IMS_Injury_Report__c');
        soqlString += 'where Person_Category__c <> \'Patient\' and isdeleted = false and IMS_Status_Report_Form__c = :currentStatusReportFormID';
        return soqlString;
    }
    
    /*
     * Builds the SOQL query to retrieve all patient injury reports.
     * 
     * @return			SOQL query string to execute.
     * 
     */
    private String buildPatientInjuryReportSOQLStatement() {
        String soqlString = COHUtil.buildSelectAllSOQLStatement('IMS_Injury_Report__c');
        soqlString += 'where Person_Category__c = \'Patient\' and isdeleted = false and IMS_Status_Report_Form__c = :currentStatusReportFormID';
        return soqlString;
    }
    
    /*
     * Builds the SOQL query to retrieve all resource requests reports.
     * 
     * @return			SOQL query string to execute.
     * 
     */
    private String buildResourceRequestSOQLStatement() {
        String soqlString = COHUtil.buildSelectAllSOQLStatement('IMS_Resource_Request__c');
        soqlString += 'where isdeleted = false and IMS_Status_Report_Form__c = :currentStatusReportFormID';
        return soqlString;
    }

    /*
     * Set the default values for the utility picklists
     * 
     */
    private void setUtilityDefaultValue() {
        statusReportFormObj.Telephone_Fax_Available__c = YES;
        statusReportFormObj.Water_Available__c = YES;
        statusReportFormObj.Computer_Network_Available__c = YES;
        statusReportFormObj.Sewer_System_Available__c = YES;
        statusReportFormObj.Air_Conditioning_HVAC_Available__c = YES;
        statusReportFormObj.Oxygen_Available__c = YES;
        statusReportFormObj.Computers_Printers_Fax_Available__c = YES;
        statusReportFormObj.Door_Access__c = YES;
        statusReportFormObj.Cell_Phone_Available__c = YES;
        statusReportFormObj.Electricity_Available__c = YES;
        statusReportFormObj.Elevator_Available__c = YES;
        statusReportFormObj.Natural_Gas_Available__c = YES;
        statusReportFormObj.Clinical_Information_System_Available__c = YES;
        statusReportFormObj.Medical_Vacuum_Aavailable__c = YES;
        statusReportFormObj.Pharmacy_Medications_Access_Available__c = YES;
        statusReportFormObj.Call_Light_System__c = YES;
    }

}