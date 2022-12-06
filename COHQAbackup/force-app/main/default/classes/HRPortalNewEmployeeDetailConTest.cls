@isTest
public class HRPortalNewEmployeeDetailConTest {
	
    @isTest
    private static void unittest(){
        Test.startTest();
        user u = HRPortalNewEmployeeDetailController.getUserDetails();
        Test.stopTest();
        system.assert(u != null);
    }
}