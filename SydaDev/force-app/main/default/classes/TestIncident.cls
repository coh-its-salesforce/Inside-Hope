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

private class TestIncident {
}
/**
    // Name:        TestIncident
    // Version:     1.0
    // Author:      Kev Coomber  
    // Date:        9/1/2013
    // Tests the triggers created for Incident.
    // Updated by H. White 2014.06.27 - added 2 asserts to check "notes" trigger, query/assert to test for notes in BMCServiceDesk__action__c
    
    static testMethod void myUnitTest() {
        Test.startTest();
        BMCServiceDesk__SYSTemplate__c template = new BMCServiceDesk__SYSTemplate__c(Name = 'Test1');
        template.BMCServiceDesk__templateFor__c = 'Incident';
        insert template;
 //       BMCServiceDesk__SYSTemplateFieldInfo__c tparent = new BMCServiceDesk__SYSTemplateFieldInfo__c(BMCServiceDesk__fieldName__c = 'Parent_Category_Text__c', BMCServiceDesk__fieldValue__c = 'Parent');
 //       tparent.BMCServiceDesk__FKSYSTemplate__c = template.Id;
 //       BMCServiceDesk__SYSTemplateFieldInfo__c tchild = new BMCServiceDesk__SYSTemplateFieldInfo__c(BMCServiceDesk__fieldName__c = 'Sub_Category_Text__c', BMCServiceDesk__fieldValue__c = 'Child');
//        tchild.BMCServiceDesk__FKSYSTemplate__c = template.Id;
        
//        insert tparent;
//        insert tchild;
        
        BMCServiceDesk__Status__c status = [select Id from BMCServiceDesk__Status__c where Name = 'OPEN' and BMCServiceDesk__appliesToIncident__c = true];
        BMCServiceDesk__Impact__c impact = [SELECT Id from BMCServiceDesk__Impact__c where Name = 'User'];
        BMCServiceDesk__Urgency__c urgency = [SELECT Id from BMCServiceDesk__Urgency__c where Name = 'Standard'];
        BMCServiceDesk__Category__c category = [select id, BMCServiceDesk__FKParentCategory__c from  BMCServiceDesk__Category__c WHERE BMCServiceDesk__AvailableForIncidents__c = true AND BMCServiceDesk__inactive__c = false LIMIT 1];
       
 //       BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);
//        insert parent;
//        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
 //                                                                         BMCServiceDesk__FKParentCategory__c = parent.Id);
//        insert child;
        
        User client = [select Id from User where IsActive = true limit 1];
        
 //       BMCServiceDesk__SupportAssignments__c sppAss = new BMCServiceDesk__SupportAssignments__c(BMCServiceDesk__FKCategory__c = child.Id,
//                                                                                  BMCServiceDesk__FKUser__c = client.Id);
        
       // insert sppAss;
        
        BMCServiceDesk__Incident__c incident = new BMCServiceDesk__Incident__c(Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id,BMCServiceDesk__FKImpact__c = impact.Id,
                                                                                 BMCServiceDesk__FKUrgency__c = urgency.Id,BMCServiceDesk__incidentResolution__c = 'Test', 
                                                                               BMCServiceDesk__incidentDescription__c = 'Test', BMCServiceDesk__FKCategory__c = category.Id,
                                                                               Parent_Category__c = category.BMCServiceDesk__FKParentCategory__c,Sub_Category__c = category.Id,
                                                                               BMCServiceDesk__Note__c = 'Unit Test Note'); 
//      check notes is NOT NULL prior to insert
        system.assertNotEquals(null,incident.BMCServiceDesk__note__c); 
        
//      assert there's at least one note
        List<BMCServiceDesk__action__c> incNote = new List<BMCServiceDesk__action__c>();
        incNote.addAll([SELECT Id,Name FROM BMCServiceDesk__action__c WHERE BMCServiceDesk__appliesToIncident__c = true]);
        system.assertNotEquals(null,incNote[0]);
        
        BMCServiceDesk__Incident__c incident2 = new BMCServiceDesk__Incident__c(Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id,BMCServiceDesk__FKImpact__c = impact.Id,
                                                                                 BMCServiceDesk__FKUrgency__c = urgency.Id,BMCServiceDesk__incidentResolution__c = 'Test', 
                                                                               BMCServiceDesk__incidentDescription__c = 'Test Incident 2', BMCServiceDesk__FKCategory__c = category.Id,
                                                                               Parent_Category__c = category.BMCServiceDesk__FKParentCategory__c,Sub_Category__c = category.Id,
                                                                               BMCServiceDesk__Note__c = 'Unit Test Note');
        incident2.BMCServiceDesk__FKTemplate__c = template.Id;
    
 //         system.assertEquals(null,incident.BMCServiceDesk__FKCategory__c);
                                                                    
        insert incident;
        insert incident2;
        
        incident.Workflow_Status__c = 'OPEN';
        update incident;
        
        incident = [select Id,BMCServiceDesk__FKCategory__c,BMCServiceDesk__Status_ID__c, BMCServiceDesk__Note__c from BMCServiceDesk__Incident__c where Id = :incident.Id];
        
//      check notes is NULL following insert                
        //system.assertEquals(null,incident.BMCServiceDesk__note__c); 
        
        
        Test.stopTest();
    }
}
*/