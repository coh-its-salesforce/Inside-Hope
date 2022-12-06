/*
 * This is the APEX controller for the COH_UIR (Universal Intake Request form) lightning components.
 * 
 * Tim Hughes
 */
public class COH_UIR_IntakeRequestFormController {
    // List of picklists for the various sections in the forms. 
    // Could be moved to COH App Config, but any changes in the values of the lists would need to be updated in the Lightning Components anyways.
    PRIVATE STATIC FINAL LIST<STRING> PROJECT_INFORMATION_PICKLISTS = new List<String> {
        'COH_UIR_SHR_ProjectEquipmentOPEXLabor__c',
        'COH_UIR_SHR_RequestType__c',
        'COH_UIR_SHR_SupportDepartments__c',
        'COH_UIR_SHR_SupportDepartmentsOther__c',
        'COH_UIR_SHR_SupportStrategicInitiative__c',
        'COH_UIR_SHR_StrategicInitiative__c',
        'COH_UIR_SHR_ExistingOPEXOrCAPEX__c',
        'COH_UIR_SHR_SwappedForExistingRequest__c',
        'COH_UIR_SHR_RequestPreAllocated__c',
        'COH_UIR_SHR_RequestFundedOrSeekingFunds__c',
        'COH_UIR_SHR_TotalCapitalCost__c',
        'COH_UIR_SHR_TotalOPEXCost__c',    
        'COH_UIR_SHR_AdditionalLaborRequired__c',
        'COH_UIR_SHR_ELTSponsor__c',
        'COH_UIR_IRC_AffectMainCampusAndAffiliate__c',
        'COH_UIR_SHR_MultiYearProject__c',
        'COH_UIR_SHR_StartYear__c',
        'COH_UIR_SHR_EndYear__c',
        'COH_UIR_SHR_CarryoverProject__c',
        'COH_UIR_SHR_ImpactConnectHope__c',
        'COH_UIR_SHR_ComplianceOrRegulatoryImpact__c',
        'COH_UIR_SHR_IsThisAFacilityRequest__c',
        'COH_UIR_SHR_IsBudgetPlanningRequest__c'

	};
    PRIVATE STATIC FINAL LIST<STRING> RESOURCE_INVOLVEMENT_PICKLISTS = new List<String> {
        'COH_UIR_SHR_InvAccess__c',
        'COH_UIR_SHR_OtherDeptsResourcesImpacted__c',
		'COH_UIR_IRC_WhichDeptsResourcesImpacted__c'            
    };
    PRIVATE STATIC FINAL LIST<STRING> ADOPTION_IMPACT_PICKLISTS = new List<String> {
        'COH_UIR_SHR_ImpAccess__c',
        'COH_UIR_SHR_OtherDeptsAdoptionImpact__c',
        'COH_UIR_SHR_WhichDeptsAdoptionImpact__c'
    };
    PRIVATE STATIC FINAL LIST<STRING> LABOR_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_LBR_NeedForPosition__c',
        'COH_UIR_LBR_FixedOrFlex__c'
    };
    PRIVATE STATIC FINAL LIST<STRING> INFOSEC_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_ISC_AccessData__c',
        'COH_UIR_ISC_AccessPHI__c',
        'COH_UIR_ISC_BAARequired__c',
        'COH_UIR_ISC_AccessPII__c',
        'COH_UIR_ISC_AccessPCIDSS__c',
        'COH_UIR_ISC_ContainIP__c',
        'COH_UIR_ISC_AccessOtherSesitiveInfo__c',
        'COH_UIR_ISC_WebsiteWithLogin__c',
        'COH_UIR_ISC_InvolveConsultantWithPHI__c',
        'COH_UIR_ISC_InvolveVendorWorkstation__c',
        'COH_UIR_ISC_DeviceConnectedToNetwork__c',
        'COH_UIR_ISC_SesitiveDataOnVendorDevice__c',
        'COH_UIR_ISC_SensitiveDataOnCOHDevice__c',
        'COH_UIR_ISC_SoftwareInstalledOnCOHDevice__c',
        'COH_UIR_ISC_InvolveConnectivityToCOH__c',
        'COH_UIR_ISC_DataOnCloudOrUtilizeSaaS__c',
        'COH_UIR_ISC_InvolveProcessOutsourcing__c',
        'COH_UIR_ISC_InvolveITOutsourcing__c',
        'COH_UIR_ISC_InvolveDataCenterOutsourcing__c',
        'COH_UIR_ISC_InvolvePhysicalSecurity__c',
        'COH_UIR_ISC_InvolveSoftwareDevelopment__c'
    };
	PRIVATE STATIC FINAL LIST<STRING> RESEARCH_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_RSH_FundedBy__c',
        'COH_UIR_RSH_ResearchRequestApproved__c',
        'COH_UIR_RSH_BudgetedPerAward__c',
        'COH_UIR_RSH_GrantFederallyFunded__c',
        'COH_UIR_RSH_AccomplishedInFiscalYear__c'
    };
	PRIVATE STATIC FINAL LIST<STRING> CAPITAL_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_CPT_CustomerService__c',
        'COH_UIR_CPT_EstimatedSavings__c',
        'COH_UIR_CPT_AnticipatedInvestment__c',
        'COH_UIR_CPT_ResourceEfficiency__c',
        'COH_UIR_CPT_ComplianceRiskMitigation__c',
        'COH_UIR_CPT_EaseToImplement__c'
    };
	PRIVATE STATIC FINAL LIST<STRING> ITS_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_ITS_BudgetCategory__c',
        'COH_UIR_ITS_ExpeditedRequestReason__c',
        'COH_UIR_ITS_FundingSource__c',
        'COH_UIR_ITS_FundingType__c',
        'COH_UIR_ITS_FundSourceSubCategory__c',
        'COH_UIR_ITS_Program__c',
        'COH_UIR_ITS_ProjectSize__c',
        'COH_UIR_ITS_Regulatory__c',
        'COH_UIR_ITS_RequestCategory__c',
        'COH_UIR_ITS_RequesterPriority__c'
    };
    PRIVATE STATIC FINAL LIST<STRING> FACILITIES_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_FSC_FacilityRequestType__c',
        'COH_UIR_FSC_MoveOrNewHires__c',
        'COH_UIR_FSC_ME_DesiredLocInDepartment__c',
        'COH_UIR_FSC_ME_AvailableSpace__c',
        'COH_UIR_FSC_ME_ReconfigRequiredMove__c',
        'COH_UIR_FSC_ME_MoveRequirements__c',
        'COH_UIR_FSC_ME_ReconfigRequiredExit__c',
        'COH_UIR_FSC_NH_DesiredLocInDepartment__c',
        'COH_UIR_FSC_NH_AvailableSpace__c',
        'COH_UIR_FSC_NH_ReconfigRequiredNewHire__c',
        'COH_UIR_FSC_NH_RelatedItems__c',
        'COH_UIR_FSC_SubRequestFurnitureArtwork__c',
        'COH_UIR_FSC_FurnitureLocation__c',
        'COH_UIR_FSC_DesiredFurnitureClinic__c',
        'COH_UIR_FSC_DesiredFurnitureOffice__c',
        'COH_UIR_FSC_ArtworkForMultipleLocations__c',
        'COH_UIR_FSC_RequireNewLease__c',
        'COH_UIR_FSC_RequireRenovation__c',
        'COH_UIR_FSC_ProjectFunded__c',
        'COH_UIR_FSC_ProgramNeedsNewConst__c',
        'COH_UIR_FSC_ProgramItems__c',
        'COH_UIR_FSC_ReconfigGoals__c',
        'COH_UIR_FSC_ProgramNeedsReconfig__c',
        'COH_UIR_FSC_SubRequestSpacePlanning__c',
        'COH_UIR_FSC_ME_NumberOfPeopleToBeMoved__c',
        'COH_UIR_FSC_NH_NumberOfNewHires__c',
        'COH_UIR_FSC_PiecesOfArtwork__c'
    };
    PRIVATE STATIC FINAL LIST<STRING> FY_PLANNING_REQUEST_PICKLISTS = new List<String> {
        'COH_UIR_FY_IsLinkedToStrategicInitiative__c',
        'COH_UIR_FY_StrategicInitiative__c',
        'COH_UIR_FY_ImpactOtherDepartments__c',
        'COH_UIR_FY_ImpactConnectHope__c',
        'COH_UIR_FY_AnyOPEXCost__c',
        'COH_UIR_FY_AssetClass__c',
        'COH_UIR_FY_InvestmentCategory__c',
        'COH_UIR_FY_Entity__c',
        'COH_UIR_FY_StartMonth__c',
        'COH_UIR_FY_StartYear__c',
        'COH_UIR_FY_EndMonth__c',
        'COH_UIR_FY_EndYear__c'
    };
        
                    
    
    /*
     * This method returns a COH_UniversalIntakeRequest. If a record id is supplied it returns that record, otherwise it returns a new record
     * 
     * @param id recordId 							The record id of the record to return, if null returns a new record
     * 
     * @return COH_UniversalIntakeRequest__c		The COH_UniversalIntakeRequest that is being returned
     */ 
    @AuraEnabled 
    public static COH_UniversalIntakeRequest__c getRecordServer(id recordId) {
        COH_UniversalIntakeRequest__c recordToReturn;
        
        if (recordId == null) {
            recordToReturn = new COH_UniversalIntakeRequest__c();
            recordToReturn.COH_UIR_SHR_RequesterName__c = UserInfo.getUserId();
            recordToreturn.COH_UIR_SHR_RequestDate__c = Date.today();
        }
        else {
            string queryString = COHUtil.buildSelectAllSOQLStatement('COH_UniversalIntakeRequest__c');
            queryString += 'WHERE id=\'' + recordId + '\'';
            try {
                recordToReturn = Database.query(queryString);
            }
            catch (Exception e){
                throw new AuraHandledException('There was an error loading the record.');
            }
        }
        return recordToReturn;
    }
    
    /*
     * This method returns all the picklist values as for the Project Information section as a JSON string
     * 
     * @param String formSection			A parameter passed by the client side controller, indicating which section of the form to return picklists for.
     * 										Which global variable to use is determined by this parameter
     */ 
    @AuraEnabled
    public static String getPicklistsServer(String formSection) {
        String returnValue = null;
        
        if (formSection == 'Project Information') {
            returnValue =  convertPicklistEntriesToJSON(PROJECT_INFORMATION_PICKLISTS);            
        }
        else if (formSection == 'Resource Involvement') {
            returnValue =  convertPicklistEntriesToJSON(RESOURCE_INVOLVEMENT_PICKLISTS);
        } 
        else if (formSection == 'Adoption Impact') {
            returnValue =  convertPicklistEntriesToJSON(ADOPTION_IMPACT_PICKLISTS);
        }
        else if (formSection == 'Labor Request') {
            returnValue = convertPicklistEntriesToJSON(LABOR_REQUEST_PICKLISTS);
        }
        else if (formSection == 'InfoSec Request') {
            returnValue =  convertPicklistEntriesToJSON(INFOSEC_REQUEST_PICKLISTS);
        }
        else if (formSection == 'Research Request') {
            returnValue = convertPicklistEntriesToJSON(RESEARCH_REQUEST_PICKLISTS);
        }
        else if (formSection == 'Capital Request') {
            returnValue = convertPicklistEntriesToJSON(CAPITAL_REQUEST_PICKLISTS);
        }
        else if (formSection == 'ITS Request') {
            returnValue = convertPicklistEntriesToJSON(ITS_REQUEST_PICKLISTS);
        }
        else if (formSection == 'Facilities Request') {
            returnValue = convertPicklistEntriesToJSON(FACILITIES_REQUEST_PICKLISTS);
        }
        else if (formSection == 'FY Planning Request') {
            returnValue = convertPicklistEntriesToJSON(FY_PLANNING_REQUEST_PICKLISTS);
        }
        
		return returnValue;
    }
    
    /*
     * This method saves a COH_UniversalIntakeRequest__c object
     * 
     * @param COH_UniversalIntakeRequest__c requestToSave 				The COH_UniversalIntakeRequest object to save
     */ 
    @AuraEnabled
    public static void saveRequestServer(COH_UniversalIntakeRequest__c requestToSave){
        try {
            upsert requestToSave;
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
    

//  ------------  Private Functions  ------------  //

    /*
     * Private function that takes a list of field names, and returns their picklist values as a JSON string. Format is: {[Field Name: {value, label}]}
	 *
	 * @param List<String> picklistToUse				The list of field names to get picklist values for.
     */ 
    private static String convertPicklistEntriesToJSON(List<String> picklistToUse){
		Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get('COH_UniversalIntakeRequest__c').getDescribe().fields.getMap();
        String JSONString;
        JSONGenerator gen = JSON.createGenerator(false);
        
        gen.writeStartobject();
        for (String currentField : picklistToUse) {
            System.debug(currentField);
			List<Schema.PicklistEntry> picklistEntries = fieldsMap.get(currentField).getDescribe().getPicklistValues();
            gen.writeFieldName(currentField);
            gen.writeStartArray();
            for (Schema.PicklistEntry i: picklistEntries) {
                gen.writeStartObject();
                gen.writeStringField('label', i.getLabel());
                gen.writeStringField('value', i.getValue());
                gen.writeEndObject();
            }
            gen.writeEndArray();             
        } 
        gen.writeEndObject();
       	JSONString =  gen.getAsString();
        gen.close();
        
        return JSONString;
    }
}