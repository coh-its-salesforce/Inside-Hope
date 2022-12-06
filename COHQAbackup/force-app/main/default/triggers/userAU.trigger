Trigger userAU on User (After update){
    Map<id,id> managerMap = new Map<id,id>();
    Map<string,string> managerEmpMap = new Map<string,string>();
    List<id> mgrIdList = new List<id>();
    List<id> oldmgrIdList = new List<id>();
    List<Values_In_Action__c> viaList = new List<Values_In_Action__c>();
    for(User u :trigger.new){
        User oldU = trigger.oldMap.get(u.id);
        if(u.mgr__c != null && oldU.mgr__c != null && u.mgr__c != oldU.mgr__c){
            managerMap.put(oldU.mgr__c,u.mgr__c);
            oldmgrIdList.add(oldU.mgr__c);
            mgrIdList.add(u.mgr__c);
            mgrIdList.add(oldU.mgr__c);
        }
    }
    if(!mgrIdList.isEmpty()){
        Map<id,USer> mgrMap = new Map<id,User>([select id,EmployeeNumber from user where id IN:mgrIdList]);
        for(id uId : managerMap.keySet()){
            managerEmpMap.put(mgrMap.get(uId).EmployeeNumber,mgrMap.get(managerMap.get(uId)).EmployeeNumber);
        }
        UserTriggerHelper.updateVIA(managerEmpMap);
      /*  viaList = [select id,Employee_ID__c from Values_In_Action__c where Employee_ID__c IN:managerEmpMap.keySet()];
        for(Values_In_Action__c via : viaList){
            if(managerEmpMap.containskey(via.Employee_ID__c)){
                via.Employee_ID__c = managerEmpMap.get(via.Employee_ID__c);             
            }
            
        }
        update viaList;*/
    }
}