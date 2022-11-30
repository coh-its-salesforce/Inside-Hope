/*
 * This trigger is for the Physician_Onboarding_Task__c 
 * Tim Hughes
 */ 
trigger COH_POB_POTasksTrigger on Physician_Onboarding_Tasks__c (before update) {    
    List<Physician_Onboarding_Tasks__c> mTasksList = new List<Physician_Onboarding_Tasks__c>();
  
	if (Trigger.isUpdate && Trigger.isBefore) {
        for (Physician_Onboarding_Tasks__c updatedTask : Trigger.New) {     
            mTasksList.add(updatedTask);
        }
        COH_POB_POTasksTriggerHelper.beforeUpdateHandler(mTasksList); 
    }
}