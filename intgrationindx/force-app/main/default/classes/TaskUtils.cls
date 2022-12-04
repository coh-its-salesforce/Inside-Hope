public with sharing class TaskUtils {
    private Map<String,Id> mapAction;

    public void onAfterInsert(List<BMCServiceDesk__Task__c> tasks){
        
    }
    
    public void onAfterUpdate(List<BMCServiceDesk__Task__c> oldTasks, List<BMCServiceDesk__Task__c> newTasks){
        AddNotes(oldTasks,newTasks);
    }
    
    public void onBeforeUpdate(List<BMCServiceDesk__Task__c> oldTasks, List<BMCServiceDesk__Task__c> newTasks){
        system.debug('*********************************** On Before Update');
        setIncidentOwner(oldTasks,  newTasks);
    }
    
    private void setIncidentOwner(List<BMCServiceDesk__Task__c> oldTasks, List<BMCServiceDesk__Task__c> newTasks){
        system.debug('*********************************** setIncidentOwnerIfClosed');
        Set<Id> incidentsWithTasks = new Set<Id>();
        for (BMCServiceDesk__Task__c task : newTasks) {incidentsWithTasks.add(task.BMCServiceDesk__FKIncident__c);}
        
        // get a smaller list
        List<BMCServiceDesk__Incident__c> incidents = [SELECT Id, Name, BMCServiceDesk__FKOpenBy__c
                                                        FROM BMCServiceDesk__Incident__c where Id IN :incidentsWithTasks];
                                                        
        Map<Id,BMCServiceDesk__Incident__c> incidentMap = new Map<Id,BMCServiceDesk__Incident__c>();
        for(BMCServiceDesk__Incident__c incident:incidents){
            incidentMap.put(incident.Id,incident);
        }
        
        for(BMCServiceDesk__Task__c t : newTasks){
            system.debug('*********************************** task: ' + t.Name);
            if(incidentMap.get(t.BMCServiceDesk__FKIncident__c) != null){
                t.Incident_Owner__c = incidentMap.get(t.BMCServiceDesk__FKIncident__c).BMCServiceDesk__FKOpenBy__c;
            }
        }
        
    }
    
    private void setupActionMap(){
        if (mapAction == null){
            mapAction = new Map<String,Id>();
            List<BMCServiceDesk__Action__c> actions = [select Id, Name from BMCServiceDesk__Action__c where BMCServiceDesk__appliesToTask__c = true];
            
            for(BMCServiceDesk__Action__c action : actions){
                String value = action.Name;
                mapAction.put(value.toLowerCase(), action.Id);
            }
        }
        
    }
    
    private void AddNotes(List<BMCServiceDesk__Task__c> oldTasks, List<BMCServiceDesk__Task__c> newTasks){
    /*
    * @author: Matt Graves
    * @updated: 2/19/2014
    * @Description: This method will add notes to the Task History object when entering notes using the Task Note field
    */
        //if (!TriggerHelper.hasAlreadyUpdated())
        //{
            setupActionMap();
            String notesId = mapAction.get('notes');
            List<BMCServiceDesk__TaskHistory__c> tskHist = new List<BMCServiceDesk__TaskHistory__c>();
            List<BMCServiceDesk__Task__c> tskUpdate = new List<BMCServiceDesk__Task__c>();
    
            for(integer i=0; i < newTasks.size(); i++)
            {
                BMCServiceDesk__Task__c newTask = newTasks[i];
                BMCServiceDesk__Task__c oldTask = oldTasks[i];

                //if ((newIncident.BMCServiceDesk__FKStatus__c != oldIncident.BMCServiceDesk__FKStatus__c) && newIncident.BMCServiceDesk__note__c == null)
                    //newIncident.addError('You must enter a Note');    

                if (newTask.BMCServiceDesk__note__c != null)
                {
                    tskHist.add(new BMCServiceDesk__TaskHistory__c(BMCServiceDesk__FKUser__c = UserInfo.getUserId(), BMCServiceDesk__date__c = System.now(),BMCServiceDesk__note__c = newTask.BMCServiceDesk__note__c, BMCServiceDesk__FKWO__c = newTask.Id, BMCServiceDesk__FKAction__c = notesId));
                    tskUpdate.add(new BMCServiceDesk__Task__c(BMCServiceDesk__note__c = '', Id = newTask.Id));      
                }   
            }
            TriggerHelper.setAlreadyUpdated();
            if (tskHist.size() > 0)
                insert tskHist;
            if (tskUpdate.size() > 0)
                update tskUpdate;
        //}
    }    
    
}