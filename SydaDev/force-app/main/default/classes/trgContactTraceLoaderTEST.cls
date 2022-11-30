@isTest
public class trgContactTraceLoaderTEST {
  @isTest
    static void TestContactTraceLoader_Load() {
        //Create a Test user
        id profileId;
        profileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        String NEWUSER = 'Connie Covid';
        String NEWUSER_EMAIL = 'TESTUSERDISREGARD@coh.org';
        String NEWUSER_EMP_ID = '101010';
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
        //Create the Contact Tracer Loader record now
        contact_trace_Loader__c ctl = new contact_trace_Loader__c();
        Datetime dt1 = Datetime.now();
        Datetime dt2 = Datetime.now()+15;
		ctl.First_Exposure_Date__c = dt1;
        ctl.Last_Exposure_Date__c = dt2;
        ctl.IP_Tracer_Number__c = 'Tracer-0001';
        ctl.Employee_Number__c = NEWUSER_EMP_ID;
        //ctl.Employee_Name__c .Employee_Name__c = NEWUSER;
        insert ctl;

        system.debug('ctl record: ' + ctl);
		
        String ctlId = ctl.id;
        system.debug('ctlId='+ctlId);
        LIST<contact_trace_Loader__c> ctlList = [Select Id, Employee_Number__c From contact_trace_Loader__c Where id = :ctlId];
        system.assertEquals(ctlList[0].Employee_Number__c, NEWUSER_EMP_ID);
        
    }  
}