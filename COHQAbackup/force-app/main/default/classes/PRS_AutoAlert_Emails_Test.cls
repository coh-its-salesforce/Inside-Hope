@isTest
public class PRS_AutoAlert_Emails_Test {
/*
    static testMethod void testPRS_AutoAlert_Email() {
        //Test for: PRS_AutoAlert_Emails.class
        //PRS_AutoAlert_Emails is an invocable class that is used by process builder PRS_Auto_Alert 
        //The key test is to create a Case that will meet the entry criteria for the process builder PRS_Auto_Alert
    	Account acct = new Account();
        acct.LastName = 'Alert';
        acct.FirstName = 'Auto';
        acct.Phone = '818-555-1212';
        acct.PersonMobilePhone = '818-446-1212';
        acct.COH_MRN__c = '123456789';
        acct.PersonEmail = 'auto.alert@prs.com';
        acct.Primary_Phone_Number__c = 'Mobile';
        acct.PersonBirthdate = Date.parse('10/08/1958');
        acct.SSN__c = '999-99-9999';
        acct.PersonMailingStreet = '4920 Rivergrade Road';
        acct.PersonMailingCity = 'Irwindale';
        acct.PersonMailingState = 'CA';
        acct.PersonMailingPostalCode = '91706';
        insert acct;
        system.debug('acct='+acct);
        Date dt = Date.today();
        Datetime dtime = Datetime.now();
        Case c = new Case();
        c.AccountId = acct.Id;
        c.Appt_Date__c = dt;
        c.Appt_Date_Time__c = dtime;
        c.Cancer_Status__c = 'Newly Diagnosed';
        c.PRSpecialist_Assignment__c = 'Admitting';
        c.Department_Case__c = 'MED ONC';
        c.Service_Line__c = 'BREAST';
        c.Specialty__c = 'Invasive Lobular Carcinoma/in SITU';
        c.Physician_Decision_Tree__c = 'Joanne Mortimer, MD (F)';
        insert c;
        system.Test.startTest();
        c.Imaging_Status__c = 'All Received';
        update c;
        system.assert(c.Physician_Decision_Tree__c != null);
        
        system.Test.stopTest();
        
        	
            
    }
*/
    static testMethod void testPRS_AutoAlert_Email_PBCreateCaseDirectly() {
        //Test for: PRS_AutoAlert_Emails.class
        //PRS_AutoAlert_Emails is an invocable class that is used by process builder PRS_Auto_Alert 
        //This test creates the case and passes the case to the invocable method directly
      Account acct = new Account();
        acct.LastName = 'Alert';
        acct.FirstName = 'Auto';
        acct.Phone = '818-555-1212';
        acct.PersonMobilePhone = '818-446-1212';
        acct.COH_MRN__c = '123456789';
        acct.PersonEmail = 'auto.alert@prs.com';
        acct.Primary_Phone_Number__c = 'Mobile';
        acct.PersonBirthdate = Date.parse('10/08/1958');
        acct.SSN__c = '999-99-9999';
        acct.PersonMailingStreet = '4920 Rivergrade Road';
        acct.PersonMailingCity = 'Irwindale';
        acct.PersonMailingState = 'CA';
        acct.PersonMailingPostalCode = '91706';
        insert acct;
        system.debug('acct='+acct);
        Date dt = Date.today();
        Datetime dtime = Datetime.now();
        Case c = new Case();
        c.AccountId = acct.Id;
        c.Appt_Date__c = dt;
        c.Appt_Date_Time__c = dtime;
        c.Cancer_Status__c = 'Newly Diagnosed';
        c.PRSpecialist_Assignment__c = 'Admitting';
        c.Department_Case__c = 'MED ONC';
        c.Service_Line__c = 'BREAST';
        c.Specialty__c = 'Invasive Lobular Carcinoma/in SITU';
        c.Physician_Decision_Tree__c = 'Joanne Mortimer, MD (F)';
        c.Imaging_Status__c = 'All Received';
        c.OwnerId = UserInfo.getUserId();
        insert c;
        system.Test.startTest();
        list<Case> clist = new list<Case>();
        clist.add(c);
        //PRS_AutoAlert_Emails.SendEmailTemplate(clist);
        PRS_AutoAlert_Emails.SendEmailTemplate(New Case[]{c});
        //clist[0].Imaging_Status__c = 'All Received';
        system.debug('clist[0]..Account_Name_Formula__c: ' + clist[0].Account_Name_Formula__c );
        //update c;
        Case cresult = [Select Id, Physician_Decision_Tree__c From Case Where Id = :c.Id];
        system.assert(cresult.Physician_Decision_Tree__c != null);
        
        system.Test.stopTest();            
    }
    
    
}