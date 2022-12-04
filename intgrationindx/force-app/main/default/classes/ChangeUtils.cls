public with sharing class ChangeUtils {
    private Map<String,Id> mapAction;

    public void onAfterInsert(List<BMCServiceDesk__Change_Request__c> changes){
        
    }
    
    public void onAfterUpdate(List<BMCServiceDesk__Change_Request__c> oldChanges, List<BMCServiceDesk__Change_Request__c> newChanges){
        AddNotes(oldChanges,newChanges);
    }
    
    public void onBeforeUpdate(List<BMCServiceDesk__Change_Request__c> oldChanges, List<BMCServiceDesk__Change_Request__c> newChanges){

    }
    
    private void setupActionMap(){
        if (mapAction == null){
            mapAction = new Map<String,Id>();
            List<BMCServiceDesk__Action__c> actions = [select Id, Name from BMCServiceDesk__Action__c where BMCServiceDesk__appliesToChange__c = true];
            
            for(BMCServiceDesk__Action__c action : actions){
                String value = action.Name;
                mapAction.put(value.toLowerCase(), action.Id);
            }
        }
        
    }
    
    private void AddNotes(List<BMCServiceDesk__Change_Request__c> oldChanges, List<BMCServiceDesk__Change_Request__c> newChanges){
    /*
    * @author: Matt Graves
    * @updated: 2/21/2014
    * @Description: This method will add notes to the Task History object when entering notes using the Task Note field
    */

            setupActionMap();
            String notesId = mapAction.get('notes');
            List<BMCServiceDesk__Change_History__c> chgHist = new List<BMCServiceDesk__Change_History__c>();
            List<BMCServiceDesk__Change_Request__c> chgUpdate = new List<BMCServiceDesk__Change_Request__c>();
    
            for(integer i=0; i < newChanges.size(); i++)
            {
                BMCServiceDesk__Change_Request__c newChange = newChanges[i];
                BMCServiceDesk__Change_Request__c oldChange = oldChanges[i];

                if (newChange.Notes__c != null)
                {
                    chgHist.add(new BMCServiceDesk__Change_History__c(BMCServiceDesk__FKCreated_By__c = UserInfo.getUserId(),BMCServiceDesk__Note__c = newChange.Notes__c, BMCServiceDesk__FKChange__c = newChange.Id, BMCServiceDesk__FKAction__c = notesId));
                    chgUpdate.add(new BMCServiceDesk__Change_Request__c(Notes__c = '', Id = newChange.Id));      
                }   
            }
            if (chgHist.size() > 0)
                insert chgHist;
            if (chgUpdate.size() > 0)
                update chgUpdate;

    }    
    
}