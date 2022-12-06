trigger CA_updateClientInfo on BMCServiceDesk__Incident__c (before insert,before Update) {
    
    if(Label.CA_ExecuteTrigger=='True')
    {
        List<BMCServiceDesk__Incident__c> incInstanceList=new List<BMCServiceDesk__Incident__c>();
        List<Id> ClientIdList=new List<Id>();
        
        for(BMCServiceDesk__Incident__c inc: trigger.new)
        {        
            if(inc.BMCServiceDesk__FKClient__c!=null && Trigger.isInsert )
            {
                ClientIdList.add(inc.BMCServiceDesk__FKClient__c);
                incInstanceList.add(inc);
            }
            if(inc.BMCServiceDesk__FKClient__c!=null && Trigger.isupdate && inc.BMCServiceDesk__FKClient__c!= Trigger.oldMap.get(inc.Id).BMCServiceDesk__FKClient__c)
            {
                ClientIdList.add(inc.BMCServiceDesk__FKClient__c);
                incInstanceList.add(inc);
            }
            
        }
        
        if(!ClientIdList.isEmpty())
        {
            Map<Id,User> userInstanceMap=new Map<Id,User>([Select id,VP_SVP_CTO__c,Mgr__c,Director__c from user where id = : ClientIdList]);
            
            for(BMCServiceDesk__Incident__c inc: incInstanceList)
            {                            
                inc.Client_Director__c = userInstanceMap.get(inc.BMCServiceDesk__FKClient__c).Director__c;
                inc.Client_VP__c= userInstanceMap.get(inc.BMCServiceDesk__FKClient__c).VP_SVP_CTO__c;
                inc.COH_Client_Manager__c=userInstanceMap.get(inc.BMCServiceDesk__FKClient__c).Mgr__c;
            }
        }
    } 
}