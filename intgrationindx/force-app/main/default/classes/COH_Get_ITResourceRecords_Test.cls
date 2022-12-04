/*
* This Test Class verifies the functionality of COH_Get_IT_ResourceRecords
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2021
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope. 
*  
*/
@isTest
public class COH_Get_ITResourceRecords_Test {
    public static testMethod void ITResourceRecords() {
        // Setup test data
        
        //This code Creates a Manager
        Profile tpoAdmin = [SELECT Id FROM Profile WHERE Name = 'TPO Admin'];
        User recUserManager = new User (Alias = 'UMgr', Email = 'UserManager@coh.org',EmailEncodingKey='UTF-8', 
                                        LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = tpoAdmin.Id, 
                                        TimeZoneSidKey='America/Los_Angeles', UserName='UserManager@coh.org');
        
        // This code Creates a test User.    
        Profile p = [SELECT Id FROM Profile WHERE Name='TPO Admin']; 
        User u = new User(Alias = 'standt', Email='COHGetITResourceTest@coh.org', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Mgr__c = recUserManager.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='COHGetITResourceTest@coh.org');
        
        // This code runs as the User
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
            
            
            Test.startTest();
            IT_Resource__c ITResourceRecs = new IT_Resource__c();
            ITResourceRecs.Employee__c = u.Id;
            ITResourceRecs.OwnerId = u.Id;
            ITResourceRecs.First_Name_Update__c = 'Testupdate1';
            ITResourceRecs.First_Name_Comments__c = 'TestComments';
            ITResourceRecs.First_Name_Override__c = true;
            ITResourceRecs.Last_Name_Comments__c = 'LastComments'; 
            ITResourceRecs.Last_Name_Update__c = 'TestLastUpdate';
            ITResourceRecs.Last_Name_Override__c = false;
            ITResourceRecs.Middle_Initial_Update__c = 'm';
            ITResourceRecs.Middle_Initial_Override__c = true; 
            ITResourceRecs.Middle_Initial_Comments__c = 'middleComments';
            ITResourceRecs.Suffix_Override__c = true; 
            ITResourceRecs.Suffix_Comments__c = 'SuffixCommentss';
            ITResourceRecs.Suffix_Update__c = 'UpdatedSuffix';
            ITResourceRecs.Email_Comments__c = 'EmailComments'; 
            ITResourceRecs.Email_Update__c = 'test@gmail.com'; 
            ITResourceRecs.Override_Email__c = true;
            ITResourceRecs.Job_Title_Comments__c = 'jobTitleComments';
            ITResourceRecs.Job_Title_Update__c = 'UpdateJobTitle'; 
            ITResourceRecs.Job_Title_Override__c = true;
            ITResourceRecs.Role_Override__c = false; 
            ITResourceRecs.Role_Comments__c = 'RoleComments';
            ITResourceRecs.Role_Update__c = 'Project Manager';
            ITResourceRecs.Skillset_Override__c = true; 
            ITResourceRecs.Skillset_Comments__c = 'skillsetComments';
            ITResourceRecs.Skillset_Update__c = 'skillsetUpdated';
            ITResourceRecs.VP_Override__c = true; 
            ITResourceRecs.VP_Comments__c = 'VPComments'; 
            ITResourceRecs.VP_Update__c = 'VPUpdated';
            insert ITResourceRecs;
            COH_Get_IT_ResourceRecords.getResourceRecords(ITResourceRecs.id);
            COH_Get_IT_ResourceListView.getITRecs(ITResourceRecs.Id);
            Test.stopTest();
        }
    }
    
}