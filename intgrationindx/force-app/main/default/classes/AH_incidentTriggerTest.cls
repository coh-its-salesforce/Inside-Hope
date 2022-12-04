@isTest
public class AH_incidentTriggerTest{
    public static testMethod void insertTest(){
        
          User usr = [Select id from User where Id = :UserInfo.getUserId()];
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
          
          BMCServiceDesk__Impact__c imp= new BMCServiceDesk__Impact__c(Name = '4 - Minor / Localized');
          insert imp;
          
          BMCServiceDesk__Urgency__c urg= new BMCServiceDesk__Urgency__c(Name = '4 - Low');
          insert urg;
          
          BMCServiceDesk__Status__c st_opened = new BMCServiceDesk__Status__c(Name='OPENED', BMCServiceDesk__inactive__c=false,BMCServiceDesk__appliesToIncident__c=True,BMCServiceDesk__appliesToTask__c=True);    
          insert st_opened;
          
          BMCServiceDesk__Category__c cat=new BMCServiceDesk__Category__c(Name='Test_Category', BMCServiceDesk__AvailableForIncidents__c=True);
          insert cat;
          
          BMCServiceDesk__BMC_BaseElement__c ci= new BMCServiceDesk__BMC_BaseElement__c(BMCServiceDesk__Name__c = 'Test',Name = 'Test_CI');
          insert ci;
          
          Group testGroup = new Group(Name='test group', Type='Queue');
          insert testGroup;
          
         
          System.runAs(thisUser )
          {   
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'BMCServiceDesk__Incident__c');
                insert testQueue;
                      
                BMCServiceDesk__Incident__c Inc =new BMCServiceDesk__Incident__c(); 
                Inc.BMCServiceDesk__FKCategory__c = cat.id;
                inc.BMCServiceDesk__FKClient__c =usr.id;
                inc.BMCServiceDesk__incidentDescription__c = 'Test';
                inc.BMCServiceDesk__contactType__c ='Event';
                inc.Summary__c='Test';
                inc.BMCServiceDesk__FKBMC_BaseElement__c = ci.id;
                inc.BMCServiceDesk__FKImpact__c = imp.id;
                inc.BMCServiceDesk__FKUrgency__c = urg.id;
                inc.BMCServiceDesk__FKStatus__c = st_opened.id;
                inc.OwnerId = testGroup.id;
                Test.StartTest();
                insert Inc;
                Test.StopTest();     
          }
     }
 }