@isTest(SeeAllData=false)
public class WorkCom_User_Employee_Sync_BatchTEST {
	
    static testMethod void TestWorkComUserEmployeSync() {
        //Create a Test user
        id profileId;
        profileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        LIST<User> mTestUserList = new LIST<User>();
        for (Integer i=0; i<20;i++) {
            String NEWUSER = 'Connie Covid' + i;
            String NEWUSER_EMAIL = 'TESTUSERDISREGARD'+i+'@coh.org';
            String NEWUSER_EMP_ID = '101010' + i;
            String TIME_ZONE_SID_KEY = 'America/Los_Angeles';
            String LANGUAGE_LOCALE_KEY = 'en_US';
            String LOCALE_SID_KEY = 'en_US';
            String EMAIL_ENCODING_KEY = 'UTF-8';
            User mTestUser;
            mTestUser = new User();
            mTestUser.Username = NEWUSER_EMAIL;
            mTestUser.Email = NEWUSER_EMAIL;
            mTestUser.LastName = NEWUSER;
            mTestUser.Alias = NEWUSER.substring(0, 7); // Alias can only be 8 characters 
            mTestUser.CommunityNickname = NEWUSER; 
            mTestUser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
            mTestUser.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
            mTestUser.LocaleSidKey = LOCALE_SID_KEY;
            mTestUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
            mTestUser.ProfileId = profileId;
            mTestUser.IsActive = true;
            mTestUser.EmployeeNumber = NEWUSER_EMP_ID;
            mTestUserList.add(mTestUser);
        }
        insert mTestUserList;
		system.debug('mTestUserList= '+mTestUserList.Size());
        LIST<User> u = [Select Id From User];
        system.debug('Users Count' + u.size());
        Test.startTest();
        WorkCom_User_Employee_Sync_Batch workcom = new WorkCom_User_Employee_Sync_Batch();
		id jobId = Database.executeBatch(workcom);
        System.debug('jobId='+jobId);
        Test.stopTest();
       LIST<Employee> emp = [Select Id From Employee];
        system.debug('Count of emp is ' + emp.size());
		//system.assert(emp.Size() > 1);
        
        
    }  
}