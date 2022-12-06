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
private class TestResolveIncidentController {

    static testMethod void myUnitTest() {
       
       PageReference pageRef = Page.COHResolveIncident; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        Test.startTest();
        //Add test data. For example, create a set of test Opportunities
        BMCServiceDesk__SYSTemplate__c template = new BMCServiceDesk__SYSTemplate__c(Name = 'Test1');
        template.BMCServiceDesk__templateFor__c = 'Incident';
        insert template;
        BMCServiceDesk__SYSTemplateFieldInfo__c tparent = new BMCServiceDesk__SYSTemplateFieldInfo__c(BMCServiceDesk__fieldName__c = 'Parent_Category_Text__c', BMCServiceDesk__fieldValue__c = 'Parent');
        tparent.BMCServiceDesk__FKSYSTemplate__c = template.Id;
        BMCServiceDesk__SYSTemplateFieldInfo__c tchild = new BMCServiceDesk__SYSTemplateFieldInfo__c(BMCServiceDesk__fieldName__c = 'Sub_Category_Text__c', BMCServiceDesk__fieldValue__c = 'Child');
        tchild.BMCServiceDesk__FKSYSTemplate__c = template.Id;
        
        insert tparent;
        insert tchild;
        
        //BMCServiceDesk__Status__c status = new BMCServiceDesk__Status__c(Name = 'RESOLVED', BMCServiceDesk__appliesToIncident__c = true);
        //insert status;
       
        BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);
        insert parent;
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent.Id);
        insert child;
        
        User client = [select Id from User where IsActive = true limit 1];
        
        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically.
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];
        
        BMCServiceDesk__Incident__c incident = new BMCServiceDesk__Incident__c(Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id,
                                                                                Parent_Category__c = parent.Id, Sub_Category__c = child.Id, ownerId = qSobj.queueid);
        insert incident;
        // Add parameters to page URL  
    
        ApexPages.currentPage().getParameters().put('id', incident.id);
       
      //add additional filters as appropriate

        // Instantiate a new controller with all parameters in the page      
        ApexPages.StandardController std=new ApexPages.StandardController(incident);
        ResolveIncidentController controller = new ResolveIncidentController(std);
        controller.selectedCategory = 'Solution Applied by IT Analyst';
        incident = controller.getIncident();
        incident.BMCServiceDesk__incidentResolution__c = 'Test';
        controller.save();
        Test.stopTest();
        
    }
}