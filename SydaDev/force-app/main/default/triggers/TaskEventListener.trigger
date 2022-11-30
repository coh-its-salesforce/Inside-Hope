trigger TaskEventListener on BMCServiceDesk__Task__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	TaskUtils handler = new TaskUtils();
	
	if (trigger.isInsert && trigger.isAfter) {handler.onAfterInsert(trigger.new);}
	if (trigger.isUpdate && trigger.isAfter) {handler.onAfterUpdate(trigger.old, trigger.new);}
	if (trigger.isUpdate && trigger.isBefore) {handler.onBeforeUpdate(trigger.old, trigger.new);}

}