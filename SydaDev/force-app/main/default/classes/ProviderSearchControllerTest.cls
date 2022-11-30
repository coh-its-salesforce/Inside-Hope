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
 *description : test class for class ProviderSearchController
 */
@isTest
public class ProviderSearchControllerTest {
    static testMethod void myUnitTest(){
        
        Contact Secretary= new contact(
            Firstname = 'Secretary',
            LastName = 'xyz',
            Page_Email__c = '81349999922@test.com'
           
         );
        insert Secretary;
        
        Contact con = new contact(
            Firstname = 'TestFirst',
            LastName = 'TestLast',
            Page_Email__c = '8199999922@test.com',
            Type__c = 'Physician',
            Division__c = 'Plastic Surgery',
            Specialty__c = 'Non Surgeon-Dermatology',
            Secretary__c = Secretary.id
        );
        insert con;
        
        ProviderSearchController psc = new ProviderSearchController();
        psc.keyword = 'test';
        psc.conObj.Division__c = 'Plastic Surgery';
        psc.conObj.Specialty__c = 'Non Surgeon-Dermatology';
        psc.Search();
        system.assertEquals(false, psc.hasNext );
        system.assertEquals(false, psc.hasPrevious );
        psc.first();
        psc.last();
        psc.next();
        psc.previous();
        system.assertEquals(1, psc.noOfRecords);
        integer pageNo = psc.pageNumber;
        psc.sortBy = 'FirstName';
        psc.sortDir = 'ASC';
        psc.sortRecord();
        psc.findRecord();
    }
}