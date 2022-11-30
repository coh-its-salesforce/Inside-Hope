/*
 * This class contains an invocable method that creates the Tasks for Community Physician Onboarding Contacts.
 * 
 * Tim Hughes
 */
public class COH_POB_CreateCommunityOnTasks {
    PRIVATE STATIC FINAL STRING TASK_TEMPLATE_RECORD_TYPE_NAME = 'Community_Physician_Onboarding_Task_Template';
    PRIVATE STATIC FINAL STRING SOBJECT_TYPE_NAME = 'Physician_Onboarding_Tasks__c';
    PRIVATE STATIC FINAL STRING TASK_RECORD_TYPE_NAME = 'Community_Physician_Onboarding_Task';
    
   	/*
   	 * This invocable method creates the taks for Physician Onboarding Contacts. 
   	 * It gets all Phsycian_Onboarding_Tasks__c with a record type developer name 'Community_Physician_Onboarding_Task_Template'. 
   	 * It then creates new Phsycian_Onboarding_Tasks__c for all contacts contained in the parameter List<Contact>, assigning the fields from the template tasks to the newly created tasks.
   	 * 
   	 * **** The method does not validate the Record Type of the contacts in the parameter, that needs to be handled in Process Builder or Apex calling the method ****
   	 * 
   	 * @param List<Contact> contacts				The list of Physician Onboarding Contacts that need to have tasks created for them
   	 */
    @InvocableMethod (label='Create Community Physician Onboarding Tasks' description='Creates Community Physician Onboarding Tasks for the supplied Contacts')
    public static void createCommunityOnboardingTasks(List<Contact> contacts) {
        List<Physician_Onboarding_Tasks__c> tasksToInsert = new List<Physician_Onboarding_Tasks__c>();
        List<Physician_Onboarding_Tasks__c> templateTasks;
        id taskRecordTypeId;
        
        try {
			templateTasks = [SELECT id, Name, Description__c, Accountable__c, Record_Type_Name__c, Task_Order__c FROM Physician_Onboarding_Tasks__c WHERE Record_Type_Name__c =: TASK_TEMPLATE_RECORD_TYPE_NAME ORDER BY Task_Order__c ASC];
			taskRecordTypeId = [SELECT id, DeveloperName from RecordType WHERE sobjecttype=: SOBJECT_TYPE_NAME AND DeveloperName =: TASK_RECORD_TYPE_NAME LIMIT 1].id;
        }
        catch (Exception e) {
            throw new COHException('There was an error querying the Community Physician Onboarding Template Tasks. Please contact your Salesforce administrator. \n' +  
                                   'Class: COH_POB_CreateCommunityOnboardingTasks | Method: createCommunityOnboardingTasks | Line: ' + e.getLineNumber() + ' | Error: ' + e.getMessage());
        }
        if (COHUTIL.isValidList(contacts)) {
            for (Contact newContact : contacts) {
                if(COHUTIL.isValidList(templateTasks)) {
                    for (Physician_Onboarding_Tasks__c templateTask : templateTasks) {
                        Physician_Onboarding_Tasks__c newTask = new Physician_Onboarding_Tasks__c();
                        newTask.Name = templateTask.Name;
                        newTask.Description__c = templateTask.Description__c;
                        newTask.Accountable__c = templateTask.Accountable__c;
                        newTask.Contact__c = newContact.id;
                        newTask.RecordTypeId = taskRecordTypeId;
                        tasksToInsert.add(newTask);
                    }
                }
            }
            try {
                insert tasksToInsert;
            }
            catch (Exception e) {
                throw new COHException('There was an error inserting the Community Physician Onboarding Tasks. Please contact your Salesforce administrator. \n' +
                                       'Class: COH_POB_CreateCommunityOnboardingTasks | Method: createCommunityOnboardingTasks | Line: ' + e.getLineNumber() + ' | Error: ' + e.getMessage());
            }
        }
    }	
}