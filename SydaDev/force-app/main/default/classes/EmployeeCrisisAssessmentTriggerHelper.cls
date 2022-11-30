public class EmployeeCrisisAssessmentTriggerHelper {
    public static void doBeforeInsert(List<EmployeeCrisisAssessment> triggerNew){
        populateEmployeeUserDetail(triggerNew, null);
    }
    
    public static void doBeforeUpdate(List<EmployeeCrisisAssessment> triggerNew, map<Id,EmployeeCrisisAssessment> oldMap ){
        populateEmployeeUserDetail(triggerNew, oldMap);
    }
    
    /**** 
     * Method to update User lookup based on employee Number
     **/
    private static void populateEmployeeUserDetail(List<EmployeeCrisisAssessment> triggerNew, map<Id,EmployeeCrisisAssessment> oldMap ){
        set<Id> employeeId = new set<Id>();
        set<string> employeeNumberId = new set<string>();
        List<EmployeeCrisisAssessment> recordToProcess = new List<EmployeeCrisisAssessment>();
        for(EmployeeCrisisAssessment eca : triggerNew){
            if(oldMap == null || (oldMap != null && eca.EmployeeId != oldMap.get(eca.Id).EmployeeId)){
                employeeId.add(eca.EmployeeId);
            	recordToProcess.add(eca);
            }
            if(oldMap == null){
				eca.AssessmentDate = system.now();
            }
        }
        
        if(!recordToProcess.isEmpty()){
            Map<Id, Employee> employeeMap = new Map<Id, Employee>([SELECT Id, Name, FirstName, LastName, EmployeeNumber,ManagerId, Manager.EmployeeNumber FROM Employee where id in : employeeId]);
            for(EmployeeCrisisAssessment eca : recordToProcess){
                if(employeeMap.containsKey(eca.EmployeeId) && string.isNotBlank(employeeMap.get(eca.EmployeeId).EmployeeNumber)){
                    employeeNumberId.add(employeeMap.get(eca.EmployeeId).EmployeeNumber);
                    if(employeeMap.get(eca.EmployeeId).ManagerId != null && string.isNotBlank(employeeMap.get(eca.EmployeeId).Manager.EmployeeNumber)){
                        employeeNumberId.add(employeeMap.get(eca.EmployeeId).Manager.EmployeeNumber);
                    }
                }
            }
            if(!employeeNumberId.isEmpty()){
                Map<string, User> userMap = new Map<string, User>();
                for(User u : [SELECT Id, CompanyName, Email, ProfileId, LastLoginDate, EmployeeNumber FROM User where EmployeeNumber in : employeeNumberId]){
                    userMap.put(u.EmployeeNumber, u);
                }
                
                for(EmployeeCrisisAssessment eca : recordToProcess){
                    if(employeeMap.containsKey(eca.EmployeeId) && string.isNotBlank(employeeMap.get(eca.EmployeeId).EmployeeNumber) ){
                        eca.Employee_User__c = userMap.containsKey(employeeMap.get(eca.EmployeeId).EmployeeNumber) ? userMap.get(employeeMap.get(eca.EmployeeId).EmployeeNumber).Id : null;
                        if(employeeMap.get(eca.EmployeeId).ManagerId != null && string.isNotBlank(employeeMap.get(eca.EmployeeId).Manager.EmployeeNumber)){
                            eca.Employee_Manager__c = userMap.containsKey(employeeMap.get(eca.EmployeeId).Manager.EmployeeNumber) ? userMap.get(employeeMap.get(eca.EmployeeId).Manager.EmployeeNumber).Id : null;
                        }
                    }
                }
            }
		}
     }
}