@isTest(seeAllData=false)
public class createPortalUserCtlTst{
  public testMethod static void unitTest() {
      Account acc = new Account(Name='Immigration Services');
insert acc;
      visa__c Visa = new visa__c(Proposed_Individual_First_Name__c='apFirst134578',Proposed_Individual_Last_Name__c='Last name134578', Proposed_Visa_Start_Date__c= system.today(), Proposed_Visa_End_Date__c= system.today().adddays(3),Applicant_Email_Id__c='pytfgfg34578@dfg.com',Community_User_Name__c = userinfo.getuserId());
      insert Visa;
      
      createPortalUserCtl.createPortaluser(Visa.id);
      Id ConId = [select id from contact where Dependents_Info__c =:Visa.id].id;

Test.startTest();
String cronExp = '0 0 0 3 9 ? 2022';
system.schedule('test job', cronExp, new createPortalUserSch());
/*createPortalUserBat cb = new createPortalUserBat();
Database.executeBatch(cb);*/
Test.stopTest();

  }
}