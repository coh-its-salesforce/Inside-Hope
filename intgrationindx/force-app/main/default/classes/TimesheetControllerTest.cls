@isTest
private class TimesheetControllerTest {
    private static testMethod void myunitTest(){
        BLND_DFDT_Project__c pr = new BLND_DFDT_Project__c();
        pr.Name = 'Project 1';
        insert pr;
        BLND_DFDT_Project__c pr1 = new BLND_DFDT_Project__c();
        pr1.Name = 'Project 2';
        insert pr1;
        
        Timesheetcontroller tsc = new Timesheetcontroller();
        tsc.enterCustom();
        
        tsc.tr.Date__c = Date.today().addDays(10);
        tsc.findCustomWeek();
        tsc.gotoPreviousWeek();
        tsc.gotoNextWeek();
        tsc.goToCurrentWeek();
        tsc.doSave();
        tsc.doSubmit();
        tsc.addRow();
        tsc.projectWrapperList[0].trObj.Project__c = pr.id;
        tsc.projectWrapperList[0].timeRecordmap.get(0).Hours__c = 30;
        tsc.projectWrapperList[1].trObj.Project__c = pr1.id;
        tsc.projectWrapperList[1].timeRecordmap.get(0).Hours__c = 20;
        tsc.doSave();
        List<Timesheet_Week__c> tw = [Select id, Name from Timesheet_Week__c ];
        List<Time_Record__c> tr = [Select id, Name from Time_Record__c];
        
        system.assertEquals(1, tw.size());
        system.assertEquals(2, tr.size());
        
      	tsc.gotoPreviousWeek();
        tsc.gotoNextWeek();
        tsc.goToCurrentWeek();
        
        tsc.projectRoworder = 0;
        tsc.doSubmit();
        List<Timesheet_Week__c> tw1 = [Select id, Name, Status__c from Timesheet_Week__c ];
        system.assertequals('Submitted', tw1[0].Status__c);
        tsc.enterCustom();
        tsc.removeRow();
        tsc.tr.Date__c = Date.today().addDays(-10);
        tsc.findCustomWeek();
    }
}