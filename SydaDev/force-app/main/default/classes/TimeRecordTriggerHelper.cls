/*
 * This is the helper function for the TimeRecrodTrigger Salesforce trigger
 * Tim Hughes
 */
public class TimeRecordTriggerHelper {
	private Map<Id, agf__ADM_Task__c> mTasksMap;
	PRIVATE FINAL STRING AGF_HOURS_REMAINING_C = 'agf__Hours_Remaining__c';
	PRIVATE FINAL STRING AGF_ACTUAL_HOURS_C = 'agf__Actual_Hours__c';
	PRIVATE FINAL STRING TIMESHEET_REMAINING_HOURS_C = 'Timesheet_Remaining_Hours__c';


	public TimeRecordTriggerHelper() {
		mTasksMap = new Map<Id, agf__ADM_Task__c>([
			SELECT id, Name, agf__Subject__c, agf__Starting_Hours__c, Timesheet_Remaining_Hours__c, agf__Hours_Remaining__c, agf__Actual_Hours__c, (SELECT id, Hours__c FROM Time_Records__r)
			FROM agf__ADM_Task__c
		]);
	}

	/*
	 * The handler function for the isAfter && isInsert trigger
	 *
	 * @param insertedTimeRecordsList		The list of inserted time records from the TimeRecordTrigger trigger
	 */
	public void upsertHandler(List<Time_Record__c> upsertedTimeRecordsList) {
		updateTimes(upsertedTimeRecordsList);
	}

	/*
	 * The handler for the isDelete trigger
	 * Since mTasksMap will contain the deleted records even when the trigger is isAfter, we need to update
	 * mTasksMap's Time_Records__r field manually before calling updateTimeRecordList. The indices in Time_Records__r 
	 * cannot be removed, so I edit the hours of the removed Time Record to 0, so that is does not affect the sum.
	 * 
	 * Something in the Controller is causing different behavior if the Time_Record__c is the last record for a specific task in a Timesheet_Week__c. 
	 * (The deletedTimeRecord is not in the mTasksMap's Time_Records__r list, in other situations it is)
	 * To handle this behavior I set the indexToRemove to -1 for every deletedTimeRecord, so that I will know if the deletedTimeRecord is not found in the mTasksMap's Time_Records__r list.
	 *
	 * @param deletedTimeRecordsList		The list of deleted time records from the TimeRecordTrigger trigger	 
	 */
	public void deleteHandler(List<Time_Record__c> deletedTimeRecordsList) {
		Integer indexToRemove = -1;
		List<Time_Record__c> tempTimeRecordsList;

		// Get the task associated with each time record.
		if (COHUtil.isValidList(deletedTimeRecordsList)) {
			for (Time_Record__c deletedTimeRecord : deletedTimeRecordsList) {
				if (deletedTimeRecord.Task__c != null) {
					tempTimeRecordsList = mTasksMap.get(deletedTimeRecord.Task__c).Time_Records__r;
					// Remove the time record from the task's Time_Records__r list
					for (Integer i = 0; i < tempTimeRecordsList.size(); i++ ) {
						if (deletedTimeRecord.id == tempTimeRecordsList.get(i).id) {
							indexToRemove = i;
						}
					}
					if (indexToRemove != -1) {
						mTasksMap.get(deletedTimeRecord.Task__c).Time_Records__r.get(indexToRemove).Hours__c = 0;
					}
					indexToRemove = -1;
				}
			}	
		}
		updateTimes(deletedTimeRecordsList);
	}	

	/*
	 * This function takes a list of Timerecords and creates a set of their related tasks. It then passes the tasks to the calculateTimes() function to determine the
	 * hours remaining and actual hours for the task, and then saves the task with the updated hours.
	 * 
	 * @param updatedTimeRecordList			The list of time records whose times need to be updated.
	 */
	private void updateTimes(List<Time_Record__c> updatedTimeRecordList) {
		Set<id> tasksToUpdateSet = new Set<id>();
		List<agf__ADM_Task__c> updatedTasksList = new List<agf__ADM_Task__c>();

		if (COHUtil.isValidList(updatedTimeRecordList)){
			// Get a list of the Tasks that are related to the tasks in updatedTimeRecordList
			for (Time_Record__c timeRecord : updatedTimeRecordList) {
				if (timeRecord.Task__c != null) {
					if (!(tasksToUpdateSet.contains(timeRecord.Task__c))) {
						tasksToUpdateSet.add(timeRecord.Task__c);
					}
				} 
			}
			// Update the task's hours
			for (id taskId : tasksToUpdateSet) {
				agf__ADM_Task__c tempTask = mTasksMap.get(taskId);
				if (tempTask != null && tempTask.agf__Starting_Hours__c != null) {
					Map<String, Decimal> timesMap = calculateTimes(taskId);
					tempTask.agf__Hours_Remaining__c = timesMap.get(AGF_HOURS_REMAINING_C);
					tempTask.agf__Actual_Hours__c = timesMap.get(AGF_ACTUAL_HOURS_C);
					tempTask.Timesheet_Remaining_Hours__c = timesMap.get(TIMESHEET_REMAINING_HOURS_C);
					updatedTasksList.add(tempTask);					
				}
			}
			// Save the updated tasks
			if (COHUtil.isValidList(updatedTasksList)) {
				Database.update(updatedTasksList);
			}
		}
	}

	/*
	 * Calculates a task's agf__Hours_Remaining__c, agf__Actual_Hours__c, and Timesheet_Remaining_Hours__c.
	 * If the remaining hours are < 0, the agf__Hours_Remaining__c field is set to its previous value.
	 *
	 * @param taskId	 					The id of the task whose remaining hours to calculate
	 *
	 * @return timesMap 					A map containing the calculate times. 
	 *										The keys are global variables to avoid the possibility of entering them incorrectly.
	 */
	private Map<String, Decimal> calculateTimes(id taskId) {
		agf__ADM_Task__c task = mTasksMap.get(taskId);
		Map<String, Decimal> timesMap = new Map<String, Decimal>();
		Decimal totalHours = 0;
		Decimal remainingHours;
		Integer numRecords = task.Time_Records__r.size();

		for (Time_Record__c timeRecord : task.Time_Records__r) {
            if (timeRecord.Hours__c != null) {
                totalHours += timeRecord.Hours__c;   
            }
		}
		
        remainingHours = task.agf__Starting_Hours__c - totalHours;            
        
        if (task.agf__Hours_Remaining__c != 0) {
            if (remainingHours > 0) {
                timesMap.put(AGF_HOURS_REMAINING_C, remainingHours);
            }
            else {
                timesMap.put(AGF_HOURS_REMAINING_C, task.agf__Hours_Remaining__c);
            }            
        }
        else {
            timesMap.put(AGF_HOURS_REMAINING_C, task.agf__Hours_Remaining__c);            
        }

		timesMap.put(AGF_ACTUAL_HOURS_C, totalHours);
		timesMap.put(TIMESHEET_REMAINING_HOURS_C, remainingHours);

		return timesMap;
	}
}