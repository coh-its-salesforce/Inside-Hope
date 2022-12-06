global class Scheduler_SurveyFollowupNotification implements Schedulable{
    
    global void execute(SchedulableContext sc) {
      SurveyFollowupNotificationBatch b = new SurveyFollowupNotificationBatch(); 
      database.executebatch(b,50);
   }

}