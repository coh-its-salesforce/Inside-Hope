public class COHHopeAssistController {

    @AuraEnabled
    public static Map<String, Object> getCaseObjectServer(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();
        Date currentDate = Date.today();  
        Integer daysSinceLastAuthStatusUpdate;
        String queryString = COHUtil.buildSelectAllSOQLStatement('Case') + 'WHERE id = \'' + recordId + '\'';
		queryString = queryString.replace(' from ', ', RecordType.DeveloperName FROM ');
        Case queriedCase = Database.query(queryString);
        
        if (queriedCase != null) {        
            returnValue.put('Case', queriedCase);
            /* This code is not currently used
            if (queriedCase.Auth_Status_Timestamp__c != null) {
                daysSinceLastAuthStatusUpdate = currentDate.daysBetween(Date.valueOf(queriedCase.Auth_Status_Timestamp__c));
                returnValue.put('DaysSinceLastAuthStatusUpdate', daysSinceLastAuthStatusUpdate);                
            }
			*/
        }
        return returnValue;
    }
/* This code is not currently used
    @AuraEnabled
    public static Contact getContactObjectServer(Id recordId) {
        String queryString = COHUtil.buildSelectAllSOQLStatement('Contact') + 'WHERE id = \'' + recordId + '\'';
        Contact returnValue = Database.query(queryString);
        
        return returnValue;
    }

    @AuraEnabled
    public static Integer getDaysUntilAppointmentServer(Id recordId) {
        Integer daysUntilAppointment;
        Date currentDate = Date.today();  
        String queryString = COHUtil.buildSelectAllSOQLStatement('Case') + 'WHERE id = \'' + recordId + '\'';        
        Case queriedCase = Database.query(queryString);
        Integer returnValue;
        
        if (queriedCase != null) {
            if (queriedCase.Appt_Date__c != null) {
                daysUntilAppointment = currentDate.daysBetween(Date.valueOf(queriedCase.Appt_Date__c));
                returnValue = daysUntilAppointment;
            }
        }
        return returnValue;
    }

    @AuraEnabled
    public static List<String> getRecommendedPhysiciansServer(String department, String serviceLine, String specialty) {
		List<String> returnValue = new List<String>();
        List<Account_Physician_Decision_Tree__c> physicianObjects; 
        
        try {
         	physicianObjects = [SELECT Department__c, Service_Line__c, Specialty__c, Physician__c FROM Account_Physician_Decision_Tree__c WHERE Department__c =: department AND Service_Line__c =: serviceLine AND Specialty__c =: specialty];   
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        for (Account_Physician_Decision_Tree__c i : physicianObjects) {
            returnValue.add(i.Physician__c);
        }
        
        return returnValue;
    }
    
    @AuraEnabled
    public static List<String> getRecommendedLocationServer(String recordId, String insuranceProvider, String insuranceType, String medicalGroup) {
		List<String> returnValue = new List<String>();
        List<COHAccountInsuranceDecisionTree__c> locationObjects;
        
        try {
            locationObjects = [SELECT Insurance_Provider__c, Insurance_Type__c, Location__c, Medical_Group__c FROM COHAccountInsuranceDecisionTree__c WHERE Insurance_Provider__c =: insuranceProvider AND Insurance_Type__c =: insuranceType AND Medical_Group__c =: medicalGroup];   
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        for (COHAccountInsuranceDecisionTree__c i : locationObjects) {
         	returnValue.add(i.Location__c); 
        }
        
        return returnValue;
    }
*/    
}