@isTest
private class ScheduleAutoCloseOnIncidents_Test{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
    Test.startTest();
    
    // Schedule the test job
    String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, new ScheduleAutoCloseOnIncidents());

    Test.stopTest();
    }
}