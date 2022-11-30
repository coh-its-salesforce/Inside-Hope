trigger UpdateNotificatoin on COH2_Faculty__c (after update) {
    FacultyUtill.doAfterfacultyUpdate(trigger.new, trigger.newMap, trigger.oldMap);
    
    
}