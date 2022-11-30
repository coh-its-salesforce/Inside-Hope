trigger HeroesofHopetrigger on COH_Heroes_of_Hope__c (before insert) {

Set<Id> userIds = new Set<Id>();
    for(COH_Heroes_of_Hope__c r: Trigger.new){
        if(r.Hero_Name__c != null){
           userIds.add(r.Hero_Name__c); 
        }
    }
    
    /* Start Sanjay 2020/05/13 Populate Manager Field.*/
    
    if(!userIds.isEmpty()){
        Map<Id, User> userMap = new Map<Id, User>([Select id, Mgr__c from User Where id in : userIds ]);
        for(COH_Heroes_of_Hope__c r: Trigger.new){
            if(r.Hero_Name__c != null && userMap.containsKey(r.Hero_Name__c)){
               r.Manager__c = userMap.get(r.Hero_Name__c).Mgr__c;
            }
        }
    }
}