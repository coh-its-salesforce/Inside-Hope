/***
 * @author........... Sanjay Singh 
 * @version.......... 1.0.0
 * @description...... Trigger for creating and updating Base Element Record(Managed)
 *                    Once the new Request get Approved.
 *
 **/ 
trigger ApplicationRequestTrigger on New_Application_Request__c (after update)  { 
    ApplicationRequestTrigHelper.doOnApprove(Trigger.New, Trigger.oldMap);
}