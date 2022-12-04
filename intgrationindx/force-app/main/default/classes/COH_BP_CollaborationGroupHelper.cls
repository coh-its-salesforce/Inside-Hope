/*
 * This class contains the methods for handling trigger events for CollaborationGroup objects
 * for the COH Blue Pencil application.
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
public class COH_BP_CollaborationGroupHelper {
    
    // COH App Configuration constants
    private static final String COH_BP_CONFIG_GROUP = 'COH_Blue_Pencil_Config_Group__c';
    
	private static final String	CHATTER_BP_APP = 'Chatter BLue Pencil';
    private static final String	CHATTER_BP_DEFAULT_CONFIG_GROUPS_CHATTER = 'Default Config Groups for Chatter';
    private static final String	CHATTER_BP_DELIMITER = ';';
    private static final Integer MAX_STRING_LEN = 131072;
    private static final Integer ID_LEN = 15;
    
    private static List<COH_Blue_Pencil_Config_Group__c> mAllChatterGroupConfigList = new List<COH_Blue_Pencil_Config_Group__c>();

    /*
     * Process new CollaborationGroups.  Assign the new collaboration groups to the default 
     * Chatter Config Groups
     * 
     * @param collaborationGroups			List of new CollaborationGroup objects.
     * 
     */
    public static void processNewCollaborationGroups(List<CollaborationGroup> collaborationGroups) {
        if (COHUtil.isValidList(collaborationGroups)) {
		    List<COH_Blue_Pencil_Config_Group__c> defaultChatterGroupConfigList = null;
            // Retrieve all the default Chatter Group Config objects
            String defaultChatterConfigGroupIDs = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(CHATTER_BP_APP, CHATTER_BP_DEFAULT_CONFIG_GROUPS_CHATTER);
            if (String.isNotBlank(defaultChatterConfigGroupIDs)) {
                List<String> defaultChatterConfigGroupIDList = defaultChatterConfigGroupIDs.split(CHATTER_BP_DELIMITER);
                String getDefaultChatterGroupConfigSOQLQuery = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP) + ' where Id in :defaultChatterConfigGroupIDList and Is_Active__c = true';
                defaultChatterGroupConfigList = Database.query(getDefaultChatterGroupConfigSOQLQuery);
            }
            
            String newCollabGroupIDs = null;
            // Build a list of the newly-created CollaborationGroup IDs
            for (CollaborationGroup collabGroupObj : collaborationGroups) {
                String groupID = collabGroupObj.Id;		
                String groupIDStr = groupID.Left(ID_LEN);
                if (newCollabGroupIDs == null) {
                    newCollabGroupIDs = groupIDStr;
                } else {
                    newCollabGroupIDs += CHATTER_BP_DELIMITER + groupIDStr;
                }
            }

            // Append the list of new CollaborationGroupIDs to the existing one for each Chatter Config Group
            if (COHUtil.isValidList(defaultChatterGroupConfigList)) {
                for (COH_Blue_Pencil_Config_Group__c configGroupObj : defaultChatterGroupConfigList) {
                    String currentCollabGroupIDs = configGroupObj.Chatter_Group_IDs0__c;
                    if (String.isBlank(currentCollabGroupIDs)) {
                        configGroupObj.Chatter_Group_IDs0__c = newCollabGroupIDs;
                    } else {
	                    Integer len = currentCollabGroupIDs.length();
                        if (len < MAX_STRING_LEN - ID_LEN) {
	                        configGroupObj.Chatter_Group_IDs0__c = currentCollabGroupIDs + CHATTER_BP_DELIMITER + newCollabGroupIDs;
                        } else {
                            currentCollabGroupIDs = configGroupObj.Chatter_Group_IDs1__c;
                            if (String.isBlank(currentCollabGroupIDs)) {
		                        configGroupObj.Chatter_Group_IDs1__c = newCollabGroupIDs;
                            } else {
                                len = currentCollabGroupIDs.length();
                                if (len < MAX_STRING_LEN - ID_LEN) {
                                    configGroupObj.Chatter_Group_IDs1__c = currentCollabGroupIDs + CHATTER_BP_DELIMITER + newCollabGroupIDs;
                                } else {
                                    throw new COHException('COH_BP_CollaborationGroupHelper.processNewCollaborationGroups(): reached maximum number for adding collaboration groups');
                                }
                            }
                        }
                    }
                }
                
 	               
                
                try {
                    Database.update(defaultChatterGroupConfigList);
                } catch (Exception e) {
                    throw new COHException('COH_BP_CollaborationGroupHelper.processNewCollaborationGroups(): exception encountered: ' + e.getMessage());
                }
            }
        }
        
    }
    
    /*
     * Process deleted CollaborationGroups.  Remove the collaboration group from the 
     * Chatter Config groups.
     * 
     * @param collaborationGroups			List of deleted CollaborationGroup objects.
     * 
     */
    public static void processDeletedCollaborationGroups(List<CollaborationGroup> collaborationGroups) {
        if (COHUtil.isValidList(collaborationGroups)) {
            String getAllChatterGroupConfigSOQLQuery = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP) + ' where Is_Active__c = true';
            mAllChatterGroupConfigList = Database.query(getAllChatterGroupConfigSOQLQuery);
            
            // Remove the old CollaborationGroupIDs 
            for (CollaborationGroup collabGroupObj : collaborationGroups) {
                Id collabGroupID = collabGroupObj.Id;
                for (COH_Blue_Pencil_Config_Group__c configGroupObj : mAllChatterGroupConfigList) {
                    String currentCollabGroupIDs = configGroupObj.Chatter_Group_IDs0__c;
                    configGroupObj.Chatter_Group_IDs0__c = removeCollaborationID(currentCollabGroupIDs, collabGroupID);
                    currentCollabGroupIDs = configGroupObj.Chatter_Group_IDs1__c;
                    configGroupObj.Chatter_Group_IDs1__c = removeCollaborationID(currentCollabGroupIDs, collabGroupID);
                }
                
            }
            
            try {
	            Database.update(mAllChatterGroupConfigList);
            } catch (Exception e) {
                throw new COHException('COH_BP_CollaborationGroupHelper.processDeletedCollaborationGroups(): exception encountered: ' + e.getMessage());
            }
        }
    }
    
    /*
     * Remove a specific Collaboration Group ID from the list of Collaboration Group IDs.
     * 
     * @param collabGroupIDs			String containing a list of current Collaboration Group IDs.
     * @param collabGroupIDToRemove		The Collaboration Group ID to remove.
     * @return							String containing a list of the remaining Collaboration Group IDs.
     * 
     */
    private static String removeCollaborationID(String collabGroupIDs, Id collabGroupIDToRemove) {
        String newCollabGroupIDs = null;
        if (!String.isBlank(collabGroupIDs)) {
            List<String> collabGroupList = collabGroupIDs.split(CHATTER_BP_DELIMITER);
            for (String cgIDStr : collabGroupList) {
                Id cgID = Id.valueOf(cgIDStr);			// Convert from 15 character to 18 character ID
                if (!cgID.equals(collabGroupIDToRemove)) {
                    if (newCollabGroupIDs != null) {
                        newCollabGroupIDs += CHATTER_BP_DELIMITER + cgIDStr;
                    } else {
                        newCollabGroupIDs = cgIDStr;
                    }
                }
            }
        }
        return newCollabGroupIDs;
    }
}