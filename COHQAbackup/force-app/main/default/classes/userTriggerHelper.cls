/*Helper Class for checking Manager*/

public class userTriggerHelper{
    @future
    public static void updateVIA(Map<String,String> managerEmpMap){
        List<Values_In_Action__c> viaList = new List<Values_In_Action__c>();
        viaList = [select id,Employee_ID__c from Values_In_Action__c where Employee_ID__c IN:managerEmpMap.keySet()];
        for(Values_In_Action__c via : viaList){
            if(managerEmpMap.containskey(via.Employee_ID__c)){
                via.Employee_ID__c = managerEmpMap.get(via.Employee_ID__c);             
            }
            
        }
        if(viaList.size()>0){
            update viaList;
        }
    }
    
    private static final set<String> OFFICER_CODES = new Set<string>{'0', '1', '2', '3', '4', '5', '6', '7', '8','B'};
    public static void checkManagerFieldUpdate(List<user> users , map<Id, user> oldUser){
        set<Id> userIdsToUpdate = new set<Id>();
        for(User u : users){
            if(oldUser == null   || 
               (oldUser != null && (u.officer_cd__c != oldUser.get(u.Id).officer_cd__c || u.PER_Status__c  != oldUser.get(u.Id).PER_Status__c ))){
                u.Is_Manager__c = u.officer_cd__c != null && OFFICER_CODES.contains(u.officer_cd__c) && u.PER_Status__c  != null && u.PER_Status__c.equalsIgnoreCase('E');
                
            }
        }
        
    }
}