trigger ah_BaseElement_trigger on BMCServiceDesk__BMC_BaseElement__c  (after insert, after update, before delete) {
    actionHub.InternalAdapter ia = new actionHub.InternalAdapter();
    Boolean eventExe = false;
    set<Id> ids = new set<Id>();
    if(trigger.isDelete)
    {
        
        ia.acceptEventData(trigger.old, trigger.old, 'RemedyForce');
    }
    else 
    {
        for(BMCServiceDesk__BMC_BaseElement__c eleList :trigger.new)
        {
            if(eleList.TS_UEID__c !=null)
            {
                eventExe = True;
                ids.add(eleList.Id);
            }
            else
            {
                eventExe = False;
            }
        }
        if(eventExe == true)
        {
            List<BMCServiceDesk__BMC_BaseRelationship__c> records = [Select id, TS_CMDB_Creation__c,BMCServiceDesk__Destination_InstanceName__c, BMCServiceDesk__Destination__c, BMCServiceDesk__Source__c  from BMCServiceDesk__BMC_BaseRelationship__c where BMCServiceDesk__Source__c IN :ids OR BMCServiceDesk__Destination__c IN :ids]; 
            for(BMCServiceDesk__BMC_BaseRelationship__c rec :records)
            {
                rec.TS_CMDB_Creation__c = True;
            }
            update records;
        }
        if(eventExe == false)
        {
            ia.acceptEventData(trigger.new, trigger.old, 'RemedyForce');
        }
    }    
}