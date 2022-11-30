@IsTest

Public Class COH_SIP_Search_ControllerTest{

Public Static testMethod Void CreateNewContact(){

   PageReference pageRef = Page.search;

   Test.setCurrentPage(pageRef);

   COH_SIP_Search_Controller controller = new COH_SIP_Search_Controller();
   controller.search();
   }

}