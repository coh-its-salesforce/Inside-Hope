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
private class TestChangeOwnerWithNoteTaskController {

    static testMethod void myUnitTest() {
       
       PageReference pageRef = Page.COHAssignQueueUserTask; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        Test.startTest();
        
        BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);
        insert parent;
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent.Id);
        insert child;
        
        User client = [select Id from User where IsActive = true limit 1];
        
        BMCServiceDesk__Task__c Task = new BMCServiceDesk__Task__c(Task_Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id,BMCServiceDesk__taskDescription__c = 'Test');
        insert Task;
        // Add parameters to page URL  
    
        ApexPages.currentPage().getParameters().put('id', Task.id);

       
      //add additional filters as appropriate

        // Instantiate a new controller with all parameters in the page      
        ApexPages.StandardController std = new ApexPages.StandardController(Task);
        ChangeOwnerWithNoteTaskController controller = new ChangeOwnerWithNoteTaskController(std);
        Task.BMCServiceDesk__Note__c= 'Test';
        List<SelectOption> qList = new List<SelectOption>(controller.QueueList);
        List<User> uList = new List<User>(controller.optUsers);    
        controller.save();
        Test.stopTest();
        
    }
}