@isTest
public class WorkCom_User_Employee_Sync_SCHEDULE_TEST {
 	static testmethod void testFunc() {
		Test.StartTest();
		WorkCom_User_Employee_Sync_SCHEDULE sh1 = new WorkCom_User_Employee_Sync_SCHEDULE();
        String sch = '0 0 23 * * ?';
        system.schedule('Test schexample', sch, sh1);
        Test.stopTest();
	}    

}