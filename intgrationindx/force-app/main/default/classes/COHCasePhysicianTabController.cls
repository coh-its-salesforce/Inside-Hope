public with sharing class COHCasePhysicianTabController {

    /*
     * This method initializes the COHCase Physican lightning Component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * A user must have Read access to the fields listed in the fieldsToAccess variable or the method will throw an exception
     * 
     * @parameter Id recordId 				The id of the Case record to return
     * 
     * @return Map<String, Object> 			A Map containing the Case record associated with the recordId.
     * 										Also contains the Selectlist values for Case record. These values are populated from the COHCasePhysicianDecisionTree__c custom setting
     */
    @AuraEnabled
    public static Map<String, Object> initCOHCasePhysicianTab(id recordId) {
        Map<String, Object> returnValue = New Map<String, Object>();
        List<String> fieldsToAccess = New List<String> {'id', 'Department_Case__c', 'Service_Line__c', 'Specialty__c', 'Physician_Decision_Tree__c', 'Accepting_MD__c', 'Attending_MD__c'};
		Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Case.fields.getMap();
        
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldsMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        Case caseToReturn = [SELECT id, Department_Case__c, Service_Line__c, Specialty__c, Physician_Decision_Tree__c, Accepting_MD__c, Attending_MD__c FROM Case WHERE id =:recordId];
        returnValue.put('Case', caseToReturn);
        returnValue.put('Departments', getDepartmentValuesServer());
        returnValue.put('Service_Lines', getServiceLineValuesServer(caseToReturn.Department_Case__c));
        returnValue.put('Specialties', getSpecialtyValuesServer(caseToReturn.Department_Case__c, caseToReturn.Service_Line__c));
        returnValue.put('Physicians', getPhysiciansServer(caseToReturn.Department_Case__c, caseToReturn.Service_Line__c, caseToReturn.Specialty__c));
       
        return returnValue;
    }
    
    /*
     * Method to get all possible Departments in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @return List<Map<String, String>> 			the possible values of Department
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getDepartmentValuesServer() {
		List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctDepartments = [SELECT Department__c FROM COHCasePhysicianDecisionTree__c GROUP BY Department__c];
        
        returnValue = buildSelectList(distinctDepartments, 'Department__c');
        
        return returnValue;
    }
    
    /*
     * Method to get all possible Service Lines in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department							the value of department
     * 
     * @return List<Map<String, String>> 			the possible values of Service Line
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getServiceLineValuesServer(String department) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctServiceLines = [SELECT Service_Line__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department GROUP BY Service_Line__c];
        
        returnValue = buildSelectList(distinctServiceLines, 'Service_Line__c');
        
        return returnValue;
    }
    
    /*
     * Method to get all possible Specialties in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department							the value of department
     * @param serviceLine							the value of serviceLine
     * 
     * @return List<Map<String, String>> 			the possible values of Specialty
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getSpecialtyValuesServer(String department, String serviceLine) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctSpecialties = [SELECT Specialty__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department AND Service_Line__c=:serviceLine GROUP BY Specialty__c];
        
        returnValue = buildSelectList(distinctSpecialties, 'Specialty__c');
        
        return returnValue;
    }
    
    /*
     * Method to get all possible Physicians in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department							the value of department
     * @param serviceLine							the value of serviceLine
     * @param specialty								the value of specialty
     * 
     * @return List<Map<String, String>> 			the possible values of Physician
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getPhysiciansServer(String department, String serviceLine, String specialty) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctPhysicians = [SELECT Physician__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department AND Service_Line__c=:serviceLine AND Specialty__c=:specialty GROUP BY Physician__c];
        
        returnValue = buildSelectList(distinctPhysicians, 'Physician__c');
        
        return returnValue;
    }        
        
    /*
     * Method to save the caseRecord
     * 
     * @param Case caseRecord			The case record to save
     
    @AuraEnabled
    public static void saveCOHCasePhysicianTabServer(Case caseRecord) {
        try {
            upsert caseRecord;
        }
        catch (Exception e) {
            throw new AuraHandledException('Failed to save record');
        } 
    }
    */
    
    /*
     * Private method to convert agregateresults from a query using GROUP BY into a List<Map<String,String>> (which is used to populate the Select Lists in the javascript controller).
     * 
     * @param List<AggregateResult> aggregateResultList								The List of AggregateResults
     * @param String fieldAPIName													The API Name of the field the Aggregate Result was grouped by in the Query that created the List<AggregateResult>
     */ 
    private static List<Map<String, String>> buildSelectList(List<AggregateResult> aggregateResultList, String fieldAPIName) {
		List<Map<String, String>> returnValue = new List<Map<String, String>>();        
        
        for(AggregateResult i : aggregateResultList) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get(fieldAPIName));
            tempMap.put('value', (String) i.get(fieldAPIName));
            returnValue.add(tempMap);
        }
        
        return returnValue;
    }    
}