@isTest
public class ErgonomicSelfAssessmentHelper_Test {
    
    private static testmethod void myUnitTest(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testADminUSER001@coh.org', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            EmployeeNumber = '12345',
            Department = 'TEST',
            MGR__c = UserInfo.getUserId(),
            TimeZoneSidKey='America/Los_Angeles', UserName='testADminUSER001@testorg.com');
        insert u;
        
        Ergonomic_Self_Assessment__c esa = new Ergonomic_Self_Assessment__c();
        esa.Employee_ID__c = '12345';
        insert esa;

    }
}