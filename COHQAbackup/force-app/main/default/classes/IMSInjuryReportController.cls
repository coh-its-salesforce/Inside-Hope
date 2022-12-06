/*
 * This is the controller for the IMS Injury Report Visualforce page.
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
public class IMSInjuryReportController {
    
    public IMS_Injury_Report__c injuryReportObj {get; set;}
    public Boolean isExistingRecord {get; set;}
    public String parentIMSStatusReportFormID {get; set;}
    public String injuryReportObjID {get; set;}			// object ID of an existing IMS_Injury_Report object
    public String windowName {get; set;}
    public String recordType {get; set;}
    
    private static String OTHER_NON_PATIENT = 'Other (Non-Patient)';
    private static String OTHER = 'Other';
    private static String PATIENT = 'Patient';
    private static String INJURY_REPORT = 'IMS_Injury_Report__c';
    private static String PARENT_ID_PARAM = 'param';
    private static String WINDOW_NAME_PARAM = 'windowNameParam';
    private static String RECORD_TYPE_PARAM = 'recordTypeParam';
    private static String INJURY_OBJ_ID_PARAM = 'objIDParam';
        
    private String retrieveInjuryReportChildSoqlQuery = null;
	private static String IMS_APPLICATION = 'Incident Management System';
    private static String NON_CLINICAL_RECORD_TYPE = 'Non-clinical';
    private static String CLINICAL_RECORD_TYPE = 'Clinical';
	private static String recordTypeNonClinical;
	private static String recordTypeClinical;
	private static Id nonClinicalRecordID;
	private static Id clinicalRecordID;
    
    private ApexPages.StandardController localController =  null;

    
    /* 
     * Initialize some variables.
     * 
     */
    static {
        recordTypeNonClinical = (String) COHUtil.getConfigurationValue(IMS_APPLICATION, NON_CLINICAL_RECORD_TYPE);
        recordTypeClinical = (String) COHUtil.getConfigurationValue(IMS_APPLICATION, CLINICAL_RECORD_TYPE);
        nonClinicalRecordID = COHUtil.getRecordType(INJURY_REPORT, NON_CLINICAL_RECORD_TYPE);
        clinicalRecordID = COHUtil.getRecordType(INJURY_REPORT, CLINICAL_RECORD_TYPE);
    }
    
    /*
     * Constructor
     * 
     * @param	controller	Standard controller instance.
     * 
     */
    public IMSInjuryReportController(ApexPages.StandardController controller) {
        initialize(controller);
    }
    
    /* 
     * Initialize variables.  A new instance of a IMS_Injury_Report__c object is created.
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
        injuryReportObjID = paramMap.get(INJURY_OBJ_ID_PARAM);
        recordType = paramMap.get(RECORD_TYPE_PARAM);
        if (COHUtil.isValidStr(injuryReportObjID)) {		// load existing record
            isExistingRecord = true;
            if (retrieveInjuryReportChildSoqlQuery == null) {
                retrieveInjuryReportChildSoqlQuery = COHUtil.buildSelectAllSOQLStatement(INJURY_REPORT);
                retrieveInjuryReportChildSoqlQuery += 'where id = :injuryReportObjID';
            }
            List<IMS_Injury_Report__c> injuryObjList = Database.query(retrieveInjuryReportChildSoqlQuery);
            if (COHUtil.isValidList(injuryObjList)) {
                injuryReportObj = injuryObjList.get(0);
            }
        } else {											// create new record
            injuryReportObj = new IMS_Injury_Report__c();
            injuryReportObj.IMS_Status_Report_Form__c = parentIMSStatusReportFormID;
            if (recordType.equalsIgnoreCase(recordTypeNonClinical)) {
                injuryReportObj.RecordTypeId = nonClinicalRecordID;
            } else if (recordType.equalsIgnoreCase(recordTypeClinical)) {
                injuryReportObj.RecordTypeId = clinicalRecordID;
            } else {
                // testing--raymond tam
                // throw exception here for unrecognized type
            }
        }
    }
    
    /* 
     * Save the record.  Clinical and Non-Clinical users will have different person categories, 
     * and the value chosen must be saved to the Person_Category__c field.  The
     * OTHER_NON_PATIENT value for Non-Clinical users must be converted to the OTHER value.
     * 
     */
    public void saveRecord() {
        injuryReportObj.IMS_Status_Report_Form__c = parentIMSStatusReportFormID;
        setPersonCategory();
        Database.upsert(injuryReportObj);
    }
    
    /* 
     * Save the record and allow user to enter another one.  Clinical and Non-Clinical users 
     * have different person categories, and the value chosen must be saved to the 
     * Person_Category__c field.  The OTHER_NON_PATIENT value for Non-Clinical users must be 
     * converted to the OTHER value.
     *
     */ 
    public void saveAndNewRecord() {
        saveRecord();
        injuryReportObj = new IMS_Injury_Report__c();
        injuryReportObj.IMS_Status_Report_Form__c = parentIMSStatusReportFormID;
    }

    /* 
     * Cancel the record and remove it from the database.
     * 
     */
    public void cancelRecord() {
        if (injuryReportObj.Id != null) {
        	Database.delete(injuryReportObj);
        }
	}
    /*
     * Sets the person category.  If the user is Non-Clinical, and the person category is OTHER_NON_PATIENT,
     * the value of Person_Category__c will be set to OTHER in order to keep it consistent with the 
     * stored values for Clinical users.
     * 
     */
    private void setPersonCategory() {
        String originalPersonCategory = injuryReportObj.Person_Category_Non_Clinical__c;
        if (COHUtil.isValidStr(originalPersonCategory)) {

            //  Convert the OTHER_NON_PATIENT category to OTHER for Non-Clinical users
            if (originalPersonCategory.equalsIgnoreCase(OTHER_NON_PATIENT)) {
                originalPersonCategory = OTHER;
            } 
        } else {
            originalPersonCategory = PATIENT;
        }
        injuryReportObj.Person_Category__c = originalPersonCategory;
    }
    
}