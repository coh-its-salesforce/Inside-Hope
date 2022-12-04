/**
    * @name -- setAutoCloseOnIncidents 
    * @author : veenesh.vikram
    * @description -- Batch Apex Class to Close all Resolved Incidents after a time period of 6 days.
*/
global class SetAutoCloseOnIncidents implements Database.Batchable<sObject>
{

     global Database.QueryLocator start(Database.BatchableContext BC)
     {
        Date today = System.today();
        //Query all RESOLVED Incidents to be CLOSED.
        string query = 'SELECT Id,BMCServiceDesk__Status_ID__c,AutoCloseFlag__c,AutoCloseDate__c FROM BMCServiceDesk__Incident__c WHERE BMCServiceDesk__Status_ID__c = ' +'\'RESOLVED\''+' AND AutoCloseFlag__c = True AND AutoCloseDate__c <= '+':today';
        System.debug(query);
        return Database.getQueryLocator(query);

     }

     global void execute(Database.BatchableContext BC, List<BMCServiceDesk__Incident__c>scope )
     {  
        if(scope.size()>0){
            //Update Status of Incident to "CLOSED".
            for(BMCServiceDesk__Incident__c incident : scope){
                incident.BMCServiceDesk__FKStatus__c = label.ClosedStatusID;
            }
        //Update Incidents.
        update Scope;            
        }
        
     }
   
     global void finish(Database.BatchableContext BC)
     {
         
     }
}