/*
 * This trigger processes CollaborationGroup objects for the COH Blue Pencil application.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
trigger COH_BP_CollaborationGroupTrigger on CollaborationGroup (after insert, after delete) {
    if (Trigger.isInsert) {
		COH_BP_CollaborationGroupHelper.processNewCollaborationGroups(Trigger.new);
    } else if (Trigger.isDelete) {
		COH_BP_CollaborationGroupHelper.processDeletedCollaborationGroups(Trigger.old);
    } 
    
}