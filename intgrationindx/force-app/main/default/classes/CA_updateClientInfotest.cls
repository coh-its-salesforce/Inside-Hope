@isTest(SeeallData=false)
public class CA_updateClientInfotest {
    
    public static testMethod void Test()
    {
        
        User usr = [Select id from User where Id=:UserInfo.getUserId()];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ServiceDesk System Administrator']; 
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'BMCServiceDesk__Incident__c');
        insert testQueue;
        
        
        /*
User u = new User(ManagerId=Userinfo.getUserId(),DelegatedApproverId=Userinfo.getUserId(),BMCServiceDesk__Account_ID__c=acc.id, BMCServiceDesk__Account_Name__c= acc.name, Alias = 'xyzt', Email='xyz@coh.org', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='xyz@testorg.com');
insert u; */
        
        
        system.runas(new user(id = userinfo.getuserid()))
        {  
            
            Account acc= new Account(Name='Test');
            insert acc;
            
            BMCServiceDesk__Category__c cat=new BMCServiceDesk__Category__c(Name='Test_Category', BMCServiceDesk__AvailableForIncidents__c=True);
            insert cat;
            
            BMCServiceDesk__Status__c st_opened = new BMCServiceDesk__Status__c(Name='OPENED', BMCServiceDesk__inactive__c=false,BMCServiceDesk__appliesToIncident__c=True,BMCServiceDesk__appliesToTask__c=True);    
            insert st_opened;
            
            Group queueId= [SELECT Id FROM Group where Name='test group' limit 1];
            BMCServiceDesk__Incident__c Inc =new BMCServiceDesk__Incident__c(); 
            Inc.BMCServiceDesk__FKCategory__c = cat.id;
            inc.BMCServiceDesk__FKClient__c =Userinfo.getuserid();
            inc.BMCServiceDesk__FKAccount__c = acc.Id;
            Inc.OwnerId=queueId.id;
            inc.BMCServiceDesk__incidentDescription__c = 'Test';
            Test.StartTest();
            insert Inc;
            
            Test.StopTest();
        }
    }
    
    
}