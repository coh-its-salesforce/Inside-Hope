/*
 * This is the controller for the IMS Resource Request Visualforce page.
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

public class IMSResourceRequestController {
    
    public IMS_Resource_Request__c resourceRequestObj {get; set;}
    public Boolean isExistingRecord {get; set;}
    public String resourceRequestObjID {get; set;}			// object ID of an existing IMS_Resource_Request__c object
    public String parentIMSStatusReportFormID {get; set;}
    public String windowName {get; set;}
    
    private static String PENDING_REVIEW = 'Pending Review';
    private static String RESOURCE_REQUEST = 'IMS_Resource_Request__c';
    private static String PARENT_ID_PARAM = 'param';
    private static String RESOURCE_OBJ_ID_PARAM = 'objIDParam';
    private static String WINDOW_NAME_PARAM = 'windowNameParam';
    private String retrieveResourceRequestChildSoqlQuery = null;
    
    private ApexPages.StandardController localController =  null;
    
    /*
     * Constructor
     * 
     * @param	controller	Standard controller instance.
     * 
     */
    public IMSResourceRequestController(ApexPages.StandardController controller) {
        initialize(controller);
    }
    
    /* 
     * Initialize variables.  A new instance of a IMS_Resource_Request__c object is created.
     * 
     * @param	controller		Instance of a standard controller.
     * 
     */
    private void initialize(ApexPages.StandardController controller) {
        
        localController = controller;
		
        System.PageReference pageRef = ApexPages.currentPage();
        Map<String, String> paramMap = pageRef.getParameters();
        parentIMSStatusReportFormID = paramMap.get(PARENT_ID_PARAM);
        windowName = paramMap.get(WINDOW_NAME_PARAM);
        resourceRequestObjID = paramMap.get(RESOURCE_OBJ_ID_PARAM);
        if (COHUtil.isValidStr(resourceRequestObjID)) {		// load existing record
            isExistingRecord = true;
            if (retrieveResourceRequestChildSoqlQuery == null) {
                retrieveResourceRequestChildSoqlQuery = COHUtil.buildSelectAllSOQLStatement(RESOURCE_REQUEST);
                retrieveResourceRequestChildSoqlQuery += 'where id = :resourceRequestObjID';
            }
            List<IMS_Resource_Request__c> resourceRequestObjList = Database.query(retrieveResourceRequestChildSoqlQuery);
            if (COHUtil.isValidList(resourceRequestObjList)) {
                resourceRequestObj = resourceRequestObjList.get(0);
            }
        } else {											// create new record
            resourceRequestObj = new IMS_Resource_Request__c();
            resourceRequestObj.IMS_Status_Report_Form__c = parentIMSStatusReportFormID;
        } 
    }
    
    /* 
     * Save the record
     * 
     */
    public void saveRecord() {
        resourceRequestObj.IMS_Status_Report_Form__c = parentIMSStatusReportFormID;
        Database.upsert(resourceRequestObj);
    }
    
    /* 
     * Save the record and allow user to enter another one
     *
     */ 
    public void saveAndNewRecord() {
 		saveRecord();
        resourceRequestObj = new IMS_Resource_Request__c();
        resourceRequestObj.Status__c = PENDING_REVIEW;
    }
    
    /* 
     * Cancel the record and remove it from the database.
     * 
     */
    public void cancelRecord() {
        if (resourceRequestObj.Id != null) {
        	Database.delete(resourceRequestObj);
        }
	}
}