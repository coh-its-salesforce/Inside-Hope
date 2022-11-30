@isTest
public class COH2_FacultyTriggerTest {
    static testmethod void myUnitTest(){
        
        FacultyProfileSetting__c fs = new FacultyProfileSetting__c(Profile_Name__c = 'System Administrator');
        insert fs;
        User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'tes0012@coh.org',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
    );
       
    insert u;
        COH2_Faculty__c faculty = new COH2_Faculty__c();
        faculty.Name = 'Test';
        faculty.COH2_FirstName__c = 'FirstName';
        insert faculty;
        faculty.COH2_Gender__c = 'M';
        faculty.COH2_Delegate_User__c = u.id;
        update faculty;
    
    //Test1 data
        
        faculty.Name = 'Test1';
        faculty.COH2_Gender__c = 'F';
        faculty.COH2_FirstName__c = 'fName';
        faculty.COH2_MiddleName__c = 'mName';
        faculty.COH2_LastName__c ='LName';
        faculty.COH2_Gender__c = 'F';
        faculty.COH2_EmailAddress__c = 'A@b.c';
        faculty.COH2_PhoneNo__c = '98989';
        faculty.COH2_Titles__c = 'Mr';
        faculty.COH2_LanguagesSpoken__c = 'English';
        faculty.COH2_Residencies__c = '656';
        faculty.COH2_Degrees2__c = 'MD';
        faculty.COH2_CareTeam__c = 'ss';
        faculty.COH2_ClinicalSpecialties__c ='Cancer';
        faculty.COH2_PostDocFellowships__c = 'sass';
        faculty.COH2_Fellowships__c = 'aaaa';
        faculty.COH2_Awards__c = 'SSSS';
        faculty.COH2_ClinicianOrResearcher__c = 'ddd';
        faculty.COH2_PrimaryLocations__c = 'NYK';
        faculty.COH2_ResearchFocus__c = 'sd';
        faculty.COH2_ClinicalFocus__c = 'qwer';
        faculty.COH2_BoardCertText__c = 'sda';
        
        
        update faculty;
        
    }
}