trigger ah_Incident_trigger on BMCServiceDesk__Incident__c (after insert, after update) {

    actionHub.InternalAdapter ia = new actionHub.InternalAdapter();
    
    ia.acceptEventData(trigger.new, trigger.old, 'RemedyForce');
    
}