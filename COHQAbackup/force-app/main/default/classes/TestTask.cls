/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestTask {

    static testMethod void myUnitTest() {
        
        Test.startTest();
        //Need an incident to link to
        BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);
        insert parent;
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent.Id);
        insert child;
        
        BMCServiceDesk__Impact__c impact = [select Id from BMCServiceDesk__Impact__c where BMCServiceDesk__inactive__c = false limit 1];
        BMCServiceDesk__Urgency__c urgency = [select Id from BMCServiceDesk__Urgency__c where BMCServiceDesk__inactive__c = false limit 1];
        
        User client = [select Id from User where IsActive = true limit 1];
        
        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically.
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];
        
        BMCServiceDesk__Incident__c incident = new BMCServiceDesk__Incident__c(Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id, BMCServiceDesk__FKOpenBy__c = client.Id,
                                                                                Parent_Category__c = parent.Id, Sub_Category__c = child.Id, BMCServiceDesk__ClosureCategory__c = 'Solution Applied by IT Analyst',
                                                                                BMCServiceDesk__incidentResolution__c = 'Test',BMCServiceDesk__incidentDescription__c = 'Test',
                                                                                BMCServiceDesk__FKImpact__c = impact.Id,BMCServiceDesk__FKUrgency__c = urgency.Id, ownerid=qSobj.queueid);
         insert incident;
         BMCServiceDesk__Task__c task = new BMCServiceDesk__Task__c(Task_Summary__c = 'Test',BMCServiceDesk__FKClient__c = client.Id,
                                                                    BMCServiceDesk__taskDescription__c = 'Test', BMCServiceDesk__FKIncident__c = incident.Id,
                                                                    BMCServiceDesk__FKImpact__c = impact.Id,BMCServiceDesk__FKUrgency__c = urgency.Id);
         insert task;
         task.BMCServiceDesk__taskDescription__c = 'Updated Description';
         update task;
         task = [select Id, Incident_Owner__c from BMCServiceDesk__Task__c where Id = :task.Id];
         //system.assertEquals(client.Id,task.Incident_Owner__c);
         Test.stopTest();
         
         
    }
}