public without sharing class GovernmentSurveyHelper {
    
    public static void pupulateUserDetail(List<Government_Survey__c> newList){
        set<string> empIds = new Set<String>();
        List<Government_Survey__c> recToProcess = new List<Government_Survey__c>();
        
        for(Government_Survey__c s : newList){
            if(string.isNotBlank(s.Employee_ID__c)){
                recToProcess.add(s);
                empIds.add(s.Employee_ID__c);
            }
        }
        if(!empIds.isEmpty()){
            Map<String, User> userMap = new Map<String, User>();
            for(User u : [Select id,Name,Email, Mgr__c,Mgr__r.Name,Start_date__c,  Supervisor__c,EmployeeNumber,  Department from User 
                            Where (EmployeeNumber in : empIds) and isActive = true  order by Name ASC] ){
                userMap.put(u.EmployeeNumber, u);
               
            }
            
            if(!userMap.isEmpty()){
                for(Government_Survey__c s : recToProcess){
                    if(userMap.containsKey(s.Employee_ID__c)){
                        s.Employee__c = userMap.get(s.Employee_ID__c).Id;
                    }
                }
            }
        }
    }

}