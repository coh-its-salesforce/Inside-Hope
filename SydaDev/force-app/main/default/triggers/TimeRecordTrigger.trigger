/*
 * This is a trigger for the TimeRecord__c Salesforce cusotm object.
 * Tim Hughes
 */
trigger TimeRecordTrigger on Time_Record__c (after insert, after update, after delete) {
    List<Time_Record__c> newTimeRecordList = new List<Time_Record__c>();
    List<Time_Record__c> oldTimeRecordList = new List<Time_Record__c>();
    TimeRecordTriggerHelper newHelper = new TimeRecordTriggerHelper();

    if (Trigger.isInsert && Trigger.isAfter) {
        for (Time_Record__c timeRecord : Trigger.New) {
            newTimeRecordList.add(timeRecord);
        }
        if (COHUtil.isValidList(newTimeRecordList)) {
            newHelper.upsertHandler(newTimeRecordList);            
        }
    }    

    if (Trigger.isUpdate && Trigger.isAfter) {        
        for (Time_Record__c timeRecord : Trigger.New) {
            // For an update there may be situations where a time record is changed from one task to another. Need to update the old task's Hours Remaining as well
            if (Trigger.oldMap.get(timeRecord.id).Task__c != timeRecord.Task__c){
                oldTimeRecordList.add(Trigger.oldMap.get(timeRecord.id));
            }
            newTimeRecordList.add(timeRecord);
        }
        // If time records have changed tasks, we need to update the old task's Remaining Hours. (The old relationships has been deleted, so I utilize the afterDeleteHandler)
        if (COHUtil.isValidList(oldTimeRecordList)) {
            newHelper.deleteHandler(oldTimeRecordList);
        }
        if (COHUtil.isValidList(newTimeRecordList)) {
            newHelper.upsertHandler(newTimeRecordList);            
        }
    }

    if (Trigger.isDelete && Trigger.isAfter) {
        for (Time_Record__c oldTimeRecord : Trigger.Old) {
            oldTimeRecordList.add(oldTimeRecord);
        }
        if (COHUtil.isValidList(oldTimeRecordList)) {
            newHelper.deleteHandler(oldTimeRecordList);            
        }
    }
}