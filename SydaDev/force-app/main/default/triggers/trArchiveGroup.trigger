trigger trArchiveGroup on TASKRAY__Project__c (after update) {

    //get the trigger records
    TASKRAY__Project__c[] oldProjects = Trigger.old;
    
    //loop through all records that fired
    for (TASKRAY__Project__c p :oldProjects){
    
        //check if project isArchived
        if (p.TASKRAY__Status__c)
        {
    
            TASKRAY__Project_Task__c[] taskList = [select id, taskray_collaboration_group__c from TASKRAY__Project_Task__c where TASKRAY__Project__c = :p.ID]; 
            
            //loop through all task records for each project
            for (TASKRAY__Project_Task__c t :taskList) {
        
                //check for collaboration group and archive
                if (t.taskray_collaboration_group__c != null)
                {
                    TaskRayTriggers.ArchiveChatterGroup(t.taskray_collaboration_group__c);
                }       
            }
        }
    }
}