@isTest
public class HRPortalCommonControllerTest {
	
    @testsetup
    static void init(){
        HR_Portal_Page_Content__c cp = new HR_Portal_Page_Content__c();
        cp.Name = 'Test';
        cp.Unique_Page_Name__c = 'Test_123';
        cp.Content__c = 'TEST';
        insert cp;
    }
    
    @isTest
    static void myunittest(){
        test.startTest();
        string content = HRPortalCommonController.getPageContent('Test_123');
        boolean isManager= HRPortalCommonController.checkIfManager();
        test.stopTest();
        system.assertEquals('TEST', content);
    }
}