global class ScheduleTimesheetNonCompNotification implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchTimeSheetNotification b = new BatchTimeSheetNotification('Timesheet_Non_Compliance_Notification'); 
      database.executebatch(b);
   }
}