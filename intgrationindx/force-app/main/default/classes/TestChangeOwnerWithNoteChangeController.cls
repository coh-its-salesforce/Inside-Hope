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
private class TestChangeOwnerWithNoteChangeController {

    static testMethod void myUnitTest() {
       
       PageReference pageRef = Page.COHAssignQueueUserChange; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        Test.startTest();
        
        User client = [select Id from User where IsActive = true limit 1];
        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];
        
        BMCServiceDesk__Change_Request__c Change = new BMCServiceDesk__Change_Request__c(Summary__c = 'Unit Test', BMCServiceDesk__FKInitiator__c = client.Id,
                                                    Back_OutPlan__c = 'TEST',Has_this_change_been_tested_in_a_Dev_Tes__c = 'Yes',BMCServiceDesk__Change_Type__c = 'Normal',
                                                    COH_Description__c = 'Test',Implementation_Tasks__c = 'Test',ownerId = qSobj.queueid,
                                                    Meaningful_Use__c = 'Yes',Post_Implementation_Validation__c = 'Test',Potential_Impact_to_Users__c = 'Test',
                                                    Pre_Implementation_Tasks__c = 'Test',Review_Manager__c = UserInfo.getUserId(), Risk_Impact__c = 'Medium', Device_Outage__c = 'Yes');
        insert Change;
        // Add parameters to page URL  
    
        ApexPages.currentPage().getParameters().put('id', Change.id);

       
      //add additional filters as appropriate

        // Instantiate a new controller with all parameters in the page      
        ApexPages.StandardController std = new ApexPages.StandardController(Change);
        ChangeOwnerWithNoteChangeController controller = new ChangeOwnerWithNoteChangeController(std);
        Change.Notes__c= 'Test';
        List<SelectOption> qList = new List<SelectOption>(controller.QueueList);
        List<User> uList = new List<User>(controller.optUsers);    
        controller.save();
        Test.stopTest();
        
    }
}