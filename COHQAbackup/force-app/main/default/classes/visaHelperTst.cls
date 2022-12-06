@isTest(seeAllData = false)
public class visaHelperTst{
    public testMethod static void unitTest() {
        Test.startTest();
        
        user portaluser = [select id from user where Profile.Name =:'COH International Services' limit 1];

        
        test.stoptest();
        visa__c Visa = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                   Proposed_Individual_Last_Name__c ='Last name',
                                   Case_Type__c= 'Transfer from another Organization',
                                   Community_User_Name__c =userinfo.getuserid(),
                                   Business_Manager_or_Contact_Person__c = portaluser.id,
                                   Supervisor__c = portaluser.id,
                                   of_Business_Manager_Business_Director__c = portaluser.id,
                                   Approver_Department_Head__c = portaluser.id,
                                   VP_ET_Member__c = portaluser.id,
                                   Assigned_ISSO_Member__c = portaluser.id
                                  );
        insert Visa;
        
        }
}