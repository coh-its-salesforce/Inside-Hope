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
 ****************************************************************************************
 *description : test class for class ProviderDetailController
 */
@isTest
private class ProviderDetailController_Test {

    static testMethod void myUnitTest(){
        // TO DO: implement unit test
        
        Contact con = new contact(
            Firstname = 'TestFirst',
            LastName = 'TestLast',
            Page_Email__c = '8199999922@test.com'
            
        );
        
        insert con;
        Id RecTypeId = [Select id , Name from REcordType where Name='COH Contacts' and sObjectType = 'Contact'].id;
                
        Contact nppaCon = new contact(
            Firstname = 'TestFirst',
            LastName = 'NPPATestLast',
            recordTYpeID = RecTypeId,
            Page_Email__c = '8199999234@test.com'
        );
        
        insert nppaCon;
        
                
        Contact adminCOn = new contact(
            Firstname = 'TestFirst',
            LastName = 'admin',
            Type__c  = 'Admin Support',
            recordTYpeID = RecTypeId,
            Page_Email__c = '8190099234@test.com'
            
        );
        insert adminCon;
        
        COH_SC_NP_PA__c nppa = new COH_SC_NP_PA__c();
        nppa.COH_SC_Provider__c = con.id;
        nppa.COH_SC_NP_PA__c = nppaCon.id;
        nppa.COH_SC_Location__c = 'LOC1';
        insert nppa;
        
        COH_SC_Admin_Support__c admin = new COH_SC_Admin_Support__c();
        admin.COH_SC_Admin__c = adminCOn.id;
        admin.coh_SC_Provider__c = con.id;
        insert admin;
        
        COH_SC_Availability_Detail__c avd = new COH_SC_Availability_Detail__c();
        avd.COH_SC_Clinic_Location__c = 'LOC1';
        avd.COH_SC_Day__c = 'Monday';
        avd.COH_SC_Start_Time_AM__c = '09:00';
        avd.COH_SC_End_Time_AM__c = '11:45';
        avd.COH_SC_Start_Time_PM__c ='13:00';
        avd.COH_SC_End_Time_PM__c = '18:00';
        avd.COH_SC_Provider__c = con.id;
        insert avd;
        
        ProviderSearchController psc = new ProviderSearchController();
        psc.keyword = 'test';
        psc.Search();
        
        
        Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(con);
        ProviderDetailController pdc = new ProviderDetailController(controller);
        pdc.getLocations();
        pdc.selectedLocation = 'LOC1';
        pdc.queryDetails();
        pdc.onchaneLocationPopulateDetails();
        pdc.doEdit();
        pdc.doSave();
        pdc.addNPPARow();
        pdc.addAdminRowRow();
        pdc.addAvailDetailRow();
        pdc.addNewProviderInstructions();
        pdc.adminRow = 1;
        pdc.nppaRow = 1;
        pdc.availDetRow = 1;
        pdc.instructionOrder = 1;
        pdc.populateValuesOnselectadminSupport();
        pdc.populateValuesOnselectNPPA();
        pdc.populateDetails(pdc.nppaWrapper, 1, con.id);
        pdc.delAdminSupportRow();
        pdc.delAvailRow();
        pdc.delNppaRow();
        pdc.doCancel();
        pdc.delProviderInstructionRow();
        pdc.showAllLocation();
        system.assert(pdc.nppaWrapper != null);
         
    }
}