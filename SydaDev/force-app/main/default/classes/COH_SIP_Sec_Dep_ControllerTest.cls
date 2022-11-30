@IsTest

Public Class COH_SIP_Sec_Dep_ControllerTest{

Public Static testMethod Void secDeptControllerTest(){
          List <Department__c> newDep = new List <Department__c>();
          Department__c dep = new Department__c();
          dep.Name= 'Dummy Sec Dep';
          dep.CalendersName__c = 'text calender';
          dep.Department_Additional_Description__c = 'This is a test content 01';
          dep.Department_URL__c = 'www.gmail.com';
          dep.Description__c = 'test';
          newDep.add(dep);
          insert newDep ;
          
          List <Secondary_Department__c> newSecDep = new List <Secondary_Department__c>();
          Secondary_Department__c secDep = new Secondary_Department__c();
          secDep.Name= 'Dummy Sec Dep';
          secDep.MenuItem__c = 'ABOUTUS';
          secDep.Secondary_Department_Content__c = 'This is a test content 01';
          secDep.Secondary_Dep_URL__c = 'www.gmail.com';
          secDep.Title__c = 'test';
          newSecDep.add(secDep);
          insert newSecDep ;
          
          String txt = 'https://www.gmail.com';
          System.currentPageReference().getParameters().put('id', newSecDep[0].id);
          System.currentPageReference().getParameters().put('isSecondary', 'True');
          
          COH_SIP_Secondary_Department_Controller secDepController = new COH_SIP_Secondary_Department_Controller ();
          secDepController.strUrl = txt;
          secDepController.lstDepartment = newDep;

   }

}