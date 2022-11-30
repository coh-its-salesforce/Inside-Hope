trigger ah_BaseRelationship_trigger on BMCServiceDesk__BMC_BaseRelationship__c (after insert, after update) {
    set<Id> ids = new set<Id>();
    set<Id> recId = new set<Id>();
    Boolean eventExe = false;
    for(BMCServiceDesk__BMC_BaseRelationship__c relatedList :trigger.new)
    {
       if(relatedList.TS_CMDB_Creation__c == false)
        {
            eventExe = True;
        }
        ids.add(relatedList.BMCServiceDesk__Destination__c);
        ids.add(relatedList.BMCServiceDesk__Source__c);
        
    }
    List<BMCServiceDesk__BMC_BaseElement__c> recd = [Select id, Create_In_TSOM__c, TS_CMDB_Creation__c from BMCServiceDesk__BMC_BaseElement__c where id IN: ids];
        for(BMCServiceDesk__BMC_BaseElement__c r :recd )
        {
            ids =new set<Id>();
            if(r.Create_In_TSOM__c == True)
            {
                ids.add(r.Id); 
            }
        }
    System.debug('ids----------------'+ids);
    if(eventExe == True && !ids.isEmpty())
    {
    System.debug('Test----------------');
       
        for(integer i=0; i<5; i++){
            List<BMCServiceDesk__BMC_BaseRelationship__c> records = [Select id, BMCServiceDesk__Destination_InstanceName__c, BMCServiceDesk__Destination__c, BMCServiceDesk__Source__c  from BMCServiceDesk__BMC_BaseRelationship__c where BMCServiceDesk__Source__c IN :ids OR BMCServiceDesk__Destination__c IN :ids];
            if (!records.isEmpty())
            {
            System.debug('Test----------------');
    
                recId.addAll(ids);
                ids =new set<Id>();
                for(BMCServiceDesk__BMC_BaseRelationship__c rec:records)
                {
                    ids.add(rec.BMCServiceDesk__Destination__c);
                    ids.add(rec.BMCServiceDesk__Source__c);
                    records = new List<BMCServiceDesk__BMC_BaseRelationship__c>();
                }
                recId.addAll(ids);
           }
            else 
                break;
        }
    }
    if(!recId.isEmpty())
    {
    System.debug('Test----------------');
    
        List<BMCServiceDesk__BMC_BaseElement__c> eleId = [Select id, Create_In_TSOM__c, TS_CMDB_Creation__c from BMCServiceDesk__BMC_BaseElement__c where id IN: recId];
        for(BMCServiceDesk__BMC_BaseElement__c eleList :eleId)
        {
            eleList.TS_CMDB_Creation__c = true;
            eleList.Create_In_TSOM__c = true;
        }
        update eleId;
    }
    if(eventExe == false)
    {
    System.debug('Test----------------');
    
        actionHub.InternalAdapter ia = new actionHub.InternalAdapter();
        
        ia.acceptEventData(trigger.new, trigger.old, 'RemedyForce');
    }

}