@isTest
private class HeaderComponentController_Test {
    
    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    private static testmethod void myUnitTest(){
        HeaderComponentController hdc= new HeaderComponentController();
        hdc.getTabList();
        hdc.LoginPage = true;
        String s = HeaderComponentController.loginUser(UserInfo.getUserName(), 'Test password');
               
//        COHHomeController homecon = new COHHomeController();
//        homecon.validateLogin(); 
    }
     
}