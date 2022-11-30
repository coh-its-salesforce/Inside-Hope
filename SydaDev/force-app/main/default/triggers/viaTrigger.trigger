trigger viaTrigger on Values_In_Action__c (before insert, before update) {
    if(trigger.new[0].Type__c == 'gift card'){
        string temp = label.Gift_Card_Values;
        Map<String,Integer> gfValueMap = new Map<String,Integer>();
        for(string s : temp.split(',')){
            List<string> value = s.split(':');
            gfValueMap.put(value[0],Integer.ValueOf(value[1]));
        } 
        system.debug('gfValueMap'+gfValueMap);
        if(trigger.old == null || trigger.old[0].Gift_Card_Amount__c!= trigger.new[0].Gift_Card_Amount__c){
            Integer totalFiftval = gfValueMap.get(trigger.new[0].Gift_Card_Amount__c);
            for(Values_In_Action__c via : [select id, Gift_Card_Amount__c,ownerId from Values_In_Action__c where Employee__c=: trigger.new[0].Employee__c 
            and LastModifiedDate =THIS_YEAR and Type__c ='Gift Card']){
                system.debug('via.Gift_Card_Amount__c'+via.Gift_Card_Amount__c);
                if(trigger.new[0].Id != via.Id ){
                    totalFiftval  += gfValueMap.get(via.Gift_Card_Amount__c);
                }
                
            }
            system.debug('totalFiftval '+totalFiftval);
            if(totalFiftval > 75){
                system.debug('errored out');
                trigger.new[0].Gift_Card_Amount__c.addError('gift card value exceeded $75');
            }
        }
    }
}