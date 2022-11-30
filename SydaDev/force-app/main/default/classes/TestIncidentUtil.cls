/**
    * @name -- TestIncidentUtil
    * @author : veenesh.vikram
    * @description -- Test Class for IncidentUtil class.
*/
@isTest
Private Class TestIncidentUtil{
private static testmethod void testIncidentFlow(){

        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically.
        // The original author of this test class obviously didn't understand how to use the Tab key.
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];

/*Prepare test data*/
List<BMCServiceDesk__Status__c> statusList = new List<BMCServiceDesk__Status__c>();
//Create Resolved Status
BMCServiceDesk__Status__c resolvedtatus = new BMCServiceDesk__Status__c(Name='RESOLVED',BMCServiceDesk__appliesToIncident__c=true);
statusList.add(resolvedtatus);

//Create a New Status
BMCServiceDesk__Status__c newstatus = new BMCServiceDesk__Status__c(Name='OPEN',BMCServiceDesk__appliesToIncident__c=true);
statusList.add(newstatus);

insert statusList ;

//Crerate Category
BMCServiceDesk__Category__c categoryTest = new BMCServiceDesk__Category__c(Name = 'Test Cat',BMCServiceDesk__AvailableForIncidents__c = True);
insert categoryTest;

//Create an Impact
BMCServiceDesk__Impact__c testImpact = new BMCServiceDesk__Impact__c(name = 'Test Impact');
insert testImpact ;

//Create an urgency
BMCServiceDesk__Urgency__c testUrgency = new BMCServiceDesk__Urgency__c(name = 'Test Urgency');
insert testUrgency ;

//Create a Configuration Item
List<BMCServiceDesk__BMC_BaseElement__c> CIList = new List<BMCServiceDesk__BMC_BaseElement__c>();

BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'testCI',BMCServiceDesk__Name__c='testCI');
CIList.add(ci) ;

//Create a Configuration Item
BMCServiceDesk__BMC_BaseElement__c ci2 = new BMCServiceDesk__BMC_BaseElement__c(name = 'test name more than 25 chars',BMCServiceDesk__Name__c='test name more than 25 chars');
CIList.add(ci2) ;

insert CIList;

//Create a Account.
Account acc = new Account(name = 'testAcc',Default_Account__c = true);
insert acc;

//Create a Custom Setting record which stores the CI to Queue Association.
CItoQueueMapping__c setting = new CItoQueueMapping__c(name='testCI',Queue__c = 'ITSM');
insert setting;
CItoQueueMapping__c setting2 = new CItoQueueMapping__c(name='test name more than 25 ch',Queue__c = 'ITSM');
insert setting2;

//Test Starts
test.StartTest();

//Insert Incident Record.
List<BMCServiceDesk__Incident__c> incidentList = new List<BMCServiceDesk__Incident__c>();

BMCServiceDesk__Incident__c incident= new BMCServiceDesk__Incident__c(
                                                              BMCServiceDesk__FKStatus__c = statusList[1].id,
                                                              BMCServiceDesk__FKImpact__c = testImpact.id,
                                                              BMCServiceDesk__FKUrgency__c = testUrgency.id,
                                                              Summary__c = 'testRecord',
                                                              BMCServiceDesk__incidentDescription__c = 'Test Record',
                                                              BMCServiceDesk__FKBMC_BaseElement__c = CIList[0].id,
                                                              BMCServiceDesk__FKCategory__c = categoryTest.id, 
                                                              ownerId = qSobj.queueid);
incidentList.add(incident);     

BMCServiceDesk__Incident__c incident2= new BMCServiceDesk__Incident__c(
                                                              BMCServiceDesk__FKStatus__c = statusList[1].id,
                                                              BMCServiceDesk__FKImpact__c = testImpact.id,
                                                              BMCServiceDesk__FKUrgency__c = testUrgency.id,
                                                              Summary__c = 'testRecord',
                                                              BMCServiceDesk__incidentDescription__c = 'Test Record',
                                                              BMCServiceDesk__FKBMC_BaseElement__c = CIList[1].id,
                                                              BMCServiceDesk__FKCategory__c = categoryTest.id,
                                                              ownerId = qSobj.queueid);
incidentList.add(incident2);  

insert incidentList;        


//Update Incident record-moving the status to RESOLVED
incident.BMCServiceDesk__FKStatus__c = statusList[0].id;
incident.BMCServiceDesk__ClosureCategory__c='Test Close';
incident.BMCServiceDesk__incidentResolution__c ='Test Resolution';
incident.BMCServiceDesk__FKOpenBy__c = UserInfo.getUserId();
update incident;

//Test Stops     
test.StopTest();
}

}