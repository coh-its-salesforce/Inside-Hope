trigger trCreateGroup on TASKRAY__Project_Task__c (before insert, before update) {

    //get the trigger record
    TASKRAY__Project_Task__c[] newTask = Trigger.new;
    //loop through all records that fired
    if (newTask != null) {
        TaskRay_Chatter_Settings__c tcsettings = TaskRay_Chatter_Settings__c.getInstance('chatterlink');
        String TCS_LINK_URL = null;
        String TASKRAY_LINK_URL = null;
        if (tcsettings  != null) {
            TCS_LINK_URL = tcsettings.Task_ChatterGroup_Link__c;
            TASKRAY_LINK_URL = tcsettings.ChatterGroup_TaskRay_Link__c;
        } 
        for (TASKRAY__Project_Task__c t :newTask) {
    
            //check if chatter group is selected && Chatter group not already created
            if (t.taskray_chatter_group__c != null && t.taskray_collaboration_group__c == null) {
                if (t.taskray_chatter_group__c) {
                    //build group name
                    TASKRAY__Project__c project = [select taskray_project_number__c, taskray_requestor_email__c, taskray_client_email__c from TASKRAY__Project__c where ID = :t.TASKRAY__Project__c]; 
                    if (project != null) {
                        String chatterGroupName = project.taskray_project_number__c + '-' + t.Name;
                        chatterGroupName = chatterGroupName.left(39);
                        String ownerId = t.OwnerId;
                
                        //create group
                        CollaborationGroup grp = TaskRayTriggers.CreateChatterGroup(chatterGroupName,ownerId);
                        if (grp  != null) {
                            //add second owner
                            if (t.taskray_Secondary_Owner__c != null)
                            {
                                String member = t.taskray_Secondary_Owner__c;
                                TaskRayTriggers.AddChatterMember(grp, member);
                            }
                    
                            //add third task owner
                            if (t.taskray_third_owner__c != null)
                            {
                                String member = t.taskray_third_owner__c;
                                TaskRayTriggers.AddChatterMember(grp, member);
                            }
                    
                            //add requestor
                            User[] requestorId = [select Id from User where Email = :project.taskray_requestor_email__c];
                            if (requestorId.size() > 0)
                            {
                                TaskRayTriggers.AddChatterMember(grp, requestorId[0].Id);
                            }
                    
                            //add approver
                            User[] approverId = [select User.Id from User where Email = :project.taskray_client_email__c];
                            if (approverId.size() > 0)
                            {
                                TaskRayTriggers.AddChatterMember(grp, approverId[0].Id);
                            }
                            //set chatter group id and update
                            if (grp.Id != null)
                            {
                                if (TASKRAY_LINK_URL != null) {
                                    TaskRayTriggers.AddDescription(grp.Id, 'For TaskRay users only: '+TASKRAY_LINK_URL+t.Id);
                                }
                                t.taskray_collaboration_group__c = grp.Id;
                                if (TCS_LINK_URL != null) {
                                    t.taskray_collaboration_group_link__c = TCS_LINK_URL+grp.Id;
                                }
                            } 
                        }    
                    }
                }  
            }  
        }
    }
}