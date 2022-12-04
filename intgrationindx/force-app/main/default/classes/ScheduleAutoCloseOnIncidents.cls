/**
    * @name -- ScheduleAutoCloseOnIncidents 
    * @author : veenesh.vikram
    * @description -- Schedulable Apex Class to Schedule Batch Class "SetAutoCloseOnIncidents".
*/
global class ScheduleAutoCloseOnIncidents implements Schedulable {

   global void execute(SchedulableContext sc) {
      SetAutoCloseOnIncidents batch = new SetAutoCloseOnIncidents(); 
      database.executebatch(batch);
   }
   
}