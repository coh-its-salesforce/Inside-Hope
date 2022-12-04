@isTest
public class Covid19ScreeningTemperatureTEST {
 @isTest
	static void TestCOVID19RestApi(){
        id profileId;
        
        profileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        String NEWUSER = 'Bob BlahBlah';
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
        
		COVID_19_Employee_Screening__c covid= new COVID_19_Employee_Screening__c();
        covid.Date__c = Date.today();
        Datetime dt = Datetime.now() + 2;
        covid.Pass_Valid_Until__c = dt;
        covid.Employee_Number__c = '229815';
        covid.Employee__c = mTestUser.Id;
        covid.Status__c = 'Pass';
        
		insert covid;
        system.debug('covid record: ' + covid);
		
        String covidId = covid.id;
        system.debug('covidId='+covidId);
        String DeviceName = 'Helford';
        Double temp = 98.6;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/temperaturecheck/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        COVID_19_Employee_Screening__c CovidRec = Covid19ScreeningTemperature.doPost(covidId, temp, DeviceName);
        system.assertEquals(CovidRec.Status__c, 'Pass');
		
	}

    
    
}