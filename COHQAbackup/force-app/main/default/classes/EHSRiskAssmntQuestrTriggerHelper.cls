public class EHSRiskAssmntQuestrTriggerHelper {

    public static void dobeforeInsert(list<EHS_Risk_Assessment_Questionaire__c> triggerNew){
        populateEmployeefield(triggerNew);
    }
    
    public static void populateEmployeefield(list<EHS_Risk_Assessment_Questionaire__c> triggerNew){
        set<Id> parentIds = new set<Id>();
        for(EHS_Risk_Assessment_Questionaire__c s : triggerNew){
            parentIds.add(s.Employee_Crisis_Assessment__c);
        }
        
        map<Id, EmployeeCrisisAssessment> ecaMap = new map<Id, EmployeeCrisisAssessment>([SELECT Id, EmployeeId, CrisisId, Case__c ,
                    Employee.Email, Employee.Name,Employee.EmployeeNumber, Employee.MiddleName,
                    Employee.ManagerId__r.Email, Employee.ManagerId__r.FirstName,Employee.ManagerId__c, Employee.ManagerId__r.Name, Employee.ManagerId__r.EmployeeNumber
                    FROM EmployeeCrisisAssessment where id in :parentIds ]);
        
        for(EHS_Risk_Assessment_Questionaire__c s : triggerNew){
            if(ecaMap.containsKey(s.Employee_Crisis_Assessment__c)){
                s.Employee_Name__c = ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.Name;
                s.Employee_Email__c = ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.Email;
                s.Employee_Number__c = ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.EmployeeNumber;
                if(ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.ManagerId__c != null){
                    s.Emplyee_Manager_Name__c = ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.ManagerId__r.Name;
                    s.Employee_Manager_Email__c = ecaMap.get(s.Employee_Crisis_Assessment__c).Employee.ManagerId__r.Email ;
                }
            }
        }
    }
}