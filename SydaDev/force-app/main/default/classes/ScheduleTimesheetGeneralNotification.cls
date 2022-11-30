global class ScheduleTimesheetGeneralNotification implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchTimeSheetNotification b = new BatchTimeSheetNotification('Timesheet_General_Notification'); 
      database.executebatch(b);
   }
}