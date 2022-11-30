trigger ITS_Intake_Request_Trigger on TPO_Project_Portfolio__c (after update, after insert) 
{
        if(trigger.isAfter && trigger.isinsert)
    {
        if(trigger.new[0].Check_if_project_is_approved__c == true||trigger.new[0].Check_if_CR_is_approved__c == true) 
        {
            COHITSIntakeTriggerHelper.copyRequestedBudgetToApprovedBudget(Trigger.new);
            //COHITSIntakeTriggerHelper.calculateTotalRemaining(Trigger.new); LK 04/16/2020
        }
    }
    if(trigger.isAfter && trigger.isupdate)
    {
        if((trigger.old[0].Check_if_project_is_approved__c== false && trigger.new[0].Check_if_project_is_approved__c == true)||
           (trigger.old[0].Check_if_CR_is_approved__c == false && trigger.new[0].Check_if_CR_is_approved__c  == true))
        {            
            COHITSIntakeTriggerHelper.copyRequestedBudgetToApprovedBudget(Trigger.new);
            /*COHITSIntakeTriggerHelper.calculateTotalRemaining(Trigger.new);
        } Else {
            COHITSIntakeTriggerHelper.calculateTotalRemaining(Trigger.new);
        } */       
        }    
    }
}