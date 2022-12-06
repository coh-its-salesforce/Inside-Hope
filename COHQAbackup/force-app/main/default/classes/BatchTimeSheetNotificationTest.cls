@isTest
public class BatchTimeSheetNotificationTest {
    @testSetup
    static void dataSetup(){
        BLND_DFDT_Project__c pr = new BLND_DFDT_Project__c();
        pr.Name = 'Project 1';
        insert pr;
	}
    
    @isTest
    private static void myUnitTest1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='utest@coh.org', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='utest@coh.org');

        insert u;
        system.runas(u){
            
            group g = [Select id from group where developerName='Timesheet_Users' limit 1];
            GroupMember gm = new GroupMember();
            gm.GroupId = g.id;
            gm.UserOrGroupId = u.id;
            insert gm;
            test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('test', CRON_EXP, new ScheduleTimesheetGeneralNotification() );   
            test.stopTest();
        }
    }
    
    @isTest
    private static void myUnitTest2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='utest@coh.org', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='utest@coh.org');
		insert u;
        system.runas(u){
            group g = [Select id from group where developerName='Timesheet_Users' limit 1];
            GroupMember gm = new GroupMember();
            gm.GroupId = g.id;
            gm.UserOrGroupId = u.id;
            insert gm;
            test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('test', CRON_EXP, new ScheduleTimesheetNonCompNotification() );   
            test.stopTest();
        }
    }
}