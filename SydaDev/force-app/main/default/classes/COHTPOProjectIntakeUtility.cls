/*
 * This class contains utility methods for the TOP Project Intake.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2018
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public with sharing class COHTPOProjectIntakeUtility {
    
    public static final String TPO_PROJ_APP = 'TPO Project Intake';
    public static final String DEFAULT_REQUEST_ID_TYPE = 'Default Request ID Type';
    private static final String TPO_PROJ_OBJ = 'TPO_Project_Portfolio__c';
    // Mapping TPO values to ITPM equivalents
    /*private static final String TPO_FUNDING_TYPE_CAPEX = 'Capex';
    private static final String ITPM_FUNDING_TYPE_CAPEX = 'Capex Project';
    private static final String TPO_SIZE_SMALL = 'Small';
    private static final String ITPM_SIZE_SMALL = '4-Small';
    private static final String TPO_SIZE_MEDIUM = 'Medium';
    private static final String ITPM_SIZE_MEDIUM = '3-Medium';
    private static final String TPO_SIZE_LARGE = 'Large';
    private static final String ITPM_SIZE_LARGE = '2-Large';
    private static final String TPO_SIZE_X_LARGE = 'X-Large';
    private static final String ITPM_SIZE_X_LARGE = '1-X-Large';*/
    
    /*
     * Hook for Lightning component to create an IT_Portfolio_Management__c object 
     * from an TPO_Project_Portfolio__c object.
     * 
     * @param recordIds		List of TPO_Project_Portfolio__c IDs.
     * 
     */
    @InvocableMethod (label='Create Project Management Record' description='Project management records for the supplied TPO requests')
    public static List<IT_Portfolio_Management__c> createProjectManagementRecord(List<id> recordIds) {
        List<IT_Portfolio_Management__c> ITPMList = new List<IT_Portfolio_Management__c>();
        if (COHUtil.isValidList(recordIds)) {//RecordType.Name
            for (Id recordId : recordIds) {
                IT_Portfolio_Management__c ITPMObj = createITPMObjFromId(recordId);
                if (ITPMObj != null) {
                    ITPMList.add(ITPMObj);
                }
            }
        }
        return ITPMList;
    }
    
    /*
     * Create an IT_Portfolio_Management__c object from an TPO_Project_Portfolio__c object
     * when the latter has an ID.
     * 
     * @param TPOProjObjID		Object ID of the TPO_Project_Portfolio__c object.
     * @return					True if no problems were encountered, false otherwise.
     * 
     */
    public static IT_Portfolio_Management__c createITPMObjFromID(Id TPOProjObjID) {
        IT_Portfolio_Management__c ITPMObj = null;
        if (String.isNotEmpty(TPOProjObjID)) {
            String soqlQuery = buildSelectAllSOQLStatement(TPO_PROJ_OBJ) + ' where Id = :TPOProjObjID';
	        List<TPO_Project_Portfolio__c> objList = Database.query(soqlQuery);
            if (COHUtil.isValidList(objList)) {
                ITPMObj = createITPMObjFromObj(objList.get(0));
            }
        }
        return ITPMObj;
    }
    
    public static String buildSelectAllSOQLStatement (String objectApiName)  {
        if (!COHUtil.isValidStr(objectApiName)) {
            return null;
        }
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectApiName).getDescribe().fields.getMap();
 
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if (commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            } else {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        String soqlQuery = 'select ' + commaSepratedFields+','+'RecordType.Name' + ' from ' + objectApiName + ' ';
        System.debug('soqlQuery-->'+soqlQuery);
        return soqlQuery;
    }
    
    /*
     * Create an IT_Portfolio_Management__c object from an TPO_Project_Portfolio__c object.
     * 
     * @param TPOProjObj		TPO_Project_Portfolio__c object
     * @return					The newly-created object if no problems were encountered, false otherwise.
     * 
     */
    public static IT_Portfolio_Management__c createITPMObjFromObj(TPO_Project_Portfolio__c TPOProjObj) {
        IT_Portfolio_Management__c ITPMObj = null;
        String RecordTypeName = String.valueOf(TPOProjObj.RecordType.Name);
        system.debug('Recordtype Name = ' + RecordTypeName);
       	id InitiationRecordTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get(String.valueOf(TPOProjObj.RecordType.Name)).getRecordTypeId();
        if (TPOProjObj != null) {
            ITPMObj = new IT_Portfolio_Management__c();
    
            //Abhishek added code to synch project ID
            ITPMobj.Actual_Monthly_Bundle_Pat_Care_only__c = TPOProjObj.Assigned_Release_monthly_bundle__c;
            ITPMobj.Benefits__c = TPOProjObj.Short_Term_Benefits__c;
            ITPMobj.Current_State_Revised__c = TPOProjObj.Current_State__c;
			ITPMobj.Executive_Summary__c = TPOProjObj.Executive_Summary__c;
            ITPMobj.In_Scope_Revised__c = TPOProjObj.Scope_Considerations__c;
            ITPMObj.Impacted_Applications__c = TPOProjObj.Impacted_Applications__c;
            ITPMObj.IT_Functional_Area__c = TPOProjObj.IT_Functional_Area__c;
            ITPMObj.IT_Functional_Sub_Area__c = TPOProjObj.IT_Functional_Sub_Area__c;
            ITPMObj.Name = TPOProjObj.Request_Name__c;
            ITPMobj.Out_of_Scope_Revised__c = TPOProjObj.Out_of_Scope__c; 
            ITPMObj.Request_ID__c = createRequestID(TPOProjObj);
            ITPMObj.Request_ID__c = TPOProjObj.Calculated_Project_ID__c; 
            ITPMObj.Request_Type__c = TPOProjObj.Request_Type__c;
            ITPMObj.Primary_ISC__C = TPOProjObj.Primary_ISC__C;
            ITPMobj.Problem_Statement__c = TPOProjObj.Project_Background__c;
            ITPMObj.RecordTypeId = InitiationRecordTypeId;
            ITPMObj.Project_Size_Business__c = TPOProjObj.Project_Size__c;
            ITPMObj.Project_Status__c = 'Ready';
            if(TPOProjObj.Assigned_Technical_Analyst__c!=null){
                ITPMObj.OwnerId = 		TPOProjObj.Assigned_Technical_Analyst__c;
                ITPMObj.Analyst__c = 	TPOProjObj.Assigned_Technical_Analyst__c;                
            }
            if(TPOProjObj.IT_Project_Manager__c != null)
            {
                ITPMObj.IT_Project_Manager__c = TPOProjObj.IT_Project_Manager__c;
            }
			ITPMObj.ITS_Intake_Request__c = TPOProjObj.Id;
           
            if(RecordTypeName == 'Enhancement Request' || RecordTypeName =='Enhancement - Technical Review'){
                ITPMobj.Request_Type__c = 'Enhancement'; 
                ITPMobj.Methodology__c = 'Enhancement';
                ITPMobj.Activity_Type__c = 'N/A';
                ITPMobj.DT_Project_Type__c ='N/A';
                ITPMobj.Project_Status__c = 'In-Progress';
                TPOProjObj.Created_Lifecycle__c = True;
                update TPOProjObj;
            }        
            if(RecordTypeName == 'Initiation' && TPOProjObj.Request_Type__c =='WO - Work Order'){
                ITPMobj.Request_Type__c = 'WO - Work Order'; 
                ITPMobj.Methodology__c = 'WO - Work Order';
                ITPMobj.Activity_Type__c = 'N/A';
                ITPMobj.DT_Project_Type__c ='N/A';
                ITPMobj.Project_Status__c = 'Ready';
                ITPMobj.OwnerId = TPOProjObj.CreatedById;
                ITPMobj.IT_Project_Manager__c = TPOProjObj.CreatedById;
                TPOProjObj.Created_Lifecycle__c = True;
                TPOProjObj.IT_Project_Manager__c = TPOProjObj.CreatedById;
                update TPOProjObj;
            }              
            Database.insert(ITPMObj);
        }
        
        return ITPMObj;
    }
    
    
    /*
     * Create the Request ID for the IT_Portfolio_Management__c object from an TPO_Project_Portfolio__c object.
     * 
     * @param TPOProjObj		TPO_Project_Portfolio__c object
     * @return 					Request ID
     * 
     */
    private static String createRequestID(TPO_Project_Portfolio__c TPOProjObj) {
        String retVal = null;
        if (TPOProjObj != null) {
    		String defaultReqIDType = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(TPO_PROJ_APP, DEFAULT_REQUEST_ID_TYPE);
            String fiscalYear = TPOProjObj.Fiscal_Year_Start__c;
            String oldRequestID = TPOProjObj.Name;
            retVal = defaultReqIDType + '-' + fiscalYear + '-' + oldRequestID;
        } 
        return retVal;
    }

   
}