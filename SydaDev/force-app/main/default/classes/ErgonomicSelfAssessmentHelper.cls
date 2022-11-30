public class ErgonomicSelfAssessmentHelper {
    
    public static void pupulateUserDetail(List<Ergonomic_Self_Assessment__c> newList){
        set<string> empIds = new Set<String>();
        List<Ergonomic_Self_Assessment__c> recToProcess = new List<Ergonomic_Self_Assessment__c>();
        Set<string> mgrEmail = new Set<string>();
        
        for(Ergonomic_Self_Assessment__c s : newList){
            if(string.isNotBlank(s.Employee_ID__c)){
                recToProcess.add(s);
                empIds.add(s.Employee_ID__c);
            }
            
            if(string.isNotBlank(s.Admin_Email__c)){
                mgrEmail.add(s.Admin_Email__c);
            }
            
            for(Schema.FieldSetMember fsm : SObjectType.Ergonomic_Self_Assessment__c.FieldSets.Fields_To_Validate_for_No_Option.getFields()){
                if(s.get(fsm.getFieldPath())!=null && 'No'.equalsIgnoreCase(string.ValueOf(s.get(fsm.getFieldPath())))){
                    s.Send_Report__c = true;
                    break;
                }
            }    
        }
        
        if(!empIds.isEmpty()){
            Map<String, User> userMap = new Map<String, User>();
            Map<String, User> supervisorMap = new Map<String, User>();
            for(User u : [Select id,Name,Email, Mgr__c,Mgr__r.Name,  Supervisor__c,EmployeeNumber,  Department from User 
                            Where (EmployeeNumber in : empIds or Email in: mgrEmail) and isActive = true  order by Name ASC] ){
                userMap.put(u.EmployeeNumber, u);
                supervisorMap.put(u.Email, u);
               
            }
            
            if(!userMap.isEmpty()){
                for(Ergonomic_Self_Assessment__c s : recToProcess){
                    if(userMap.containsKey(s.Employee_ID__c)){
                        s.Department_Name__c = userMap.get(s.Employee_ID__c).Department;
                        s.Your_Name__c = userMap.get(s.Employee_ID__c).Name;
                        //s.Supervisor_Name__c = userMap.get(s.Employee_ID__c).Mgr__c != null ? userMap.get(s.Employee_ID__c).Mgr__r.Name : '';
                        s.Supervisor_lookup__c = userMap.get(s.Employee_ID__c).Mgr__c;
                        s.USer__c= userMap.get(s.Employee_ID__c).Id;
                        if(string.isNotBlank(s.Admin_Email__c) && supervisorMap.containsKey(s.Admin_Email__c)){
                            s.Secondary_Supervisor__c =supervisorMap.get(s.Admin_Email__c).Id ;
                        }
                    }
                }
            }
        }
    }

}