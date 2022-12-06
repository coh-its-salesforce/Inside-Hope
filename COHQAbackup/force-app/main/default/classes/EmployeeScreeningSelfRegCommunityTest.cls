/*
 * Test method for the EmployeeScreeningSelfRegCommunity. 
 */ 
@isTest(Seealldata=true)
public class EmployeeScreeningSelfRegCommunityTest {
    private static testmethod void myUnitTest(){

        Account recEmployeeScreeningAccount = [select id from Account where name ='Employee Screening - Contractors' Limit 1];
		Profile recProfile = [select id from Profile where name = 'Employee Screening Contractors' Limit 1];
        string accountId = String.valueOf(recEmployeeScreeningAccount.Id).subString(0,15);
        string profileId = String.valueOf(recProfile.Id).subString(0,15);
        String password = 'Community#1!';
        Map<sObjectField, String> registrationAttributes = new Map<sObjectField, String>{};
        registrationAttributes.put(User.firstName, 'Don');
        registrationAttributes.put(User.lastName, 'Rickles');
        registrationAttributes.put(User.Username, null);
        registrationAttributes.put(User.CommunityNickname,null);
        registrationAttributes.put(User.MobilePhone,null);
        registrationAttributes.put(User.email, 'drickles@sbcglobal.net');
        
        //Create Second Self Registration
        string password2 = 'cAd';
        Map<sObjectField, String> registrationAttributes2 = new Map<sObjectField, String>{};
        registrationAttributes2.put(User.firstName, 'Longname');
        registrationAttributes2.put(User.lastName, 'GoesOver8Characters');
        registrationAttributes2.put(User.email, null);
        
        string password3 = '';
        Map<sObjectField, String> registrationAttributes3 = new Map<sObjectField, String>{};
            
        EmployeeScreeningSelfRegCommunity ESSRC = new EmployeeScreeningSelfRegCommunity();
        test.startTest();
		ESSRC.createUser(accountId, profileId, registrationAttributes, password);
        ESSRC.createUser(accountId, profileId, registrationAttributes2, password2);
        ESSRC.createUser(accountId, profileId, registrationAttributes3, password3);
        test.stopTest();
    }
}