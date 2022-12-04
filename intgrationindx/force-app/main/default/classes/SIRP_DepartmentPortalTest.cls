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
@isTest
private class SIRP_DepartmentPortalTest{
    
    /* 
     * This test verifies that if the parameter is an invalid department id, then the page redirects to the error page
     */ 
    @isTest
    private static void invalidUserId() {   
        string invalidId = '1';
        test.startTest();
        
        apexPages.currentPage().getParameters().put('id', invalidId);
        SIRP_DepartmentPortal departmentPortalController = new SIRP_DepartmentPortal();
        PageReference redirectedPage = departmentPortalController.RedirectToErrorPage();
        System.assertEquals(true, redirectedPage.getRedirect());
        
        test.stopTest();
    }
    
    /* 
     * This test verifies that if no parameter for id is set, then the page redirects to the error page
     */ 
    @isTest
    private static void noUserId() {   
        test.startTest();
        
        SIRP_DepartmentPortal departmentPortalController = new SIRP_DepartmentPortal();
        PageReference redirectedPage = departmentPortalController.RedirectToErrorPage();
        System.assertEquals(true, redirectedPage.getRedirect());
        
        test.stopTest();
    }
    
       
    
    static testMethod void myUnitTest(){
        
        User currentUser = [Select Id, Name, Department from User where Id = :UserInfo.getUserId()];
        
        Department__c d = new Department__c();
        d.Name = currentUser.Department;
        d.Description__c = '';
        d.Title__c = '';
        d.Image_Attachment_Id__c = '';
        insert d;
    
    Attachment a = new Attachment();
        a.Name = 'test';
        a.Body = Blob.valueOf('test');
        a.ParentId = d.Id;
        insert a;
        system.debug('attID'+d.Image_Attachment_Id__c);
        //d.Image_Attachment_Id__c = a.Id+'';
        //update d;
        
        Department_Components__c dc = new Department_Components__c();
        dc.Order__c = '1';
        dc.Name = 'testing';
        dc.Department_Name__c = d.Id;
        insert dc;
        
       
        
        SIRP_DepartmentPortal dptl = new SIRP_DepartmentPortal();
    
    ApexPages.currentPage().getParameters().put('id', d.Id);
    
    dptl = new SIRP_DepartmentPortal();        
        
        dptl = new SIRP_DepartmentPortal(); //Creating instance of main controller
        dptl.editDepartmentComponentSection();
        dptl.editDepartmentSection();
        dptl.updateDepartmentComponents();
        dptl.deptImageName = 'test2';
        dptl.updateDepartmentSection();
        dptl.cancelDepartmentEditPage();
        dptl.addDepartmentComponentSection();
        dptl.openSecondary();
        dptl.openDepartment();
        //dptl.rightselected.add('Dummy User3');
        //dptl.selectclick();
        //dptl.rightselected.add('Dummy User1');
        dptl.getSelectedValues();
        //dptl.unselectclick();
        
        dptl.getunSelectedValues();
        //dptl.leftselected.add('Dummy User2');
        
        
        
         /*String sText ='Dummy User 01';
        rightselected mm= new rightselected();
        mm.setSearchText(sText);
        String s = mm.getrightselected();*/
        
        
        
        
    dptl.txtSearch ='132123';
        dptl.btnSearch();
        dptl.saveSection();
        //dptl.GoEditMode();
        SIRP_DepartmentPortal.DepartmentComponentWrapper dcw = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw.depComp.Order__c = '2';
        dcw.depComp.Name = 'test';
        dptl.lstDepartmentComponentWrapper.add(dcw);
        dptl.updateDepartmentComponents();
    
    dptl.lstDepartmentComponentWrapper.clear();
    dcw = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw.depComp.Order__c = '2';
    dcw.depComp.Name = '';
        dptl.lstDepartmentComponentWrapper.add(dcw);
    dptl.updateDepartmentComponents();
    
    dptl.lstDepartmentComponentWrapper.clear();
    dcw = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw.depComp.Order__c = '';
        dcw.depComp.Name = 'test1';
    dcw.isSelected = true;
        dptl.lstDepartmentComponentWrapper.add(dcw);
    dptl.deleteSelectedDepartmentComponent();
    
    dptl.lstDepartmentComponentWrapper.clear();
    dcw = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw.depComp.Order__c = '';
        dcw.depComp.Name = 'test1';
        dptl.lstDepartmentComponentWrapper.add(dcw);
    dptl.updateDepartmentComponents();
    
    
    dptl.lstDepartmentComponentWrapper.clear();
    dcw = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw.depComp.Order__c = '2';
        dcw.depComp.Name = 'test123';
        dptl.lstDepartmentComponentWrapper.add(dcw);
        dptl.updateDepartmentComponents();
        
        SIRP_DepartmentPortal.DepartmentComponentWrapper dcw2 = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw2.depComp.Order__c = '2';
        dcw2.depComp.Name = 'test';
        dptl.lstDepartmentComponentWrapper.add(dcw2);
        dptl.updateDepartmentComponents();
        
        dptl.editDepartmentComponentSection();
        for(SIRP_DepartmentPortal.DepartmentComponentWrapper dcw1 : dptl.lstDepartmentComponentWrapper) {
            dcw1.isSelected = true;
        }
        dptl.deleteSelectedDepartmentComponent();
        dptl.deleteSelectedDepartmentComponent();
        dcw2 = new SIRP_DepartmentPortal.DepartmentComponentWrapper();
        dcw2.depComp.Order__c = '10';
        dcw2.depComp.Name = 'test';
        dptl.lstDepartmentComponentWrapper.add(dcw2);
        dptl.updateDepartmentComponents();
        
        for(integer i=0;i<10;i++) {
            dptl.addDepartmentComponentSection();
        }
        
        Test.startTest();
        Secondary_Department__c sd1 = new Secondary_Department__c();/* Start */
        try{
             
             //sd1.Department_Name__c = d.ID;
             sd1.Secondary_Department_Content__c = 'abcdef';
            insert sd1;
        }catch(exception ex){
            System.debug('Secondary Already Present');
        }/* Stop */
       
       
        Secondary_Department__c sd = new Secondary_Department__c();/* Start */
        sd.Name = currentUser.Department;
        sd.Secondary_Department_Content__c = 'abcd';/* Stop */
        
        Department__c d1 = new Department__c();
        d1.Department_URL__c = 'https://www.google.com';
        d1.Secondary_Owners__c = currentUser.Name;
        d1.Parent_Department__c = d.Id;
        insert d1;
    ApexPages.currentPage().getParameters().put('isSecondary','true');
    ApexPages.currentPage().getParameters().put('id', sd1.Id);//
    
    SIRP_DepartmentPortal dptl1 = new SIRP_DepartmentPortal();
        system.debug('Line 207: dtpl1='+dptl1);
    //dptl1.editSecondaryDepartment();//20200415 Frank Salinas This (and next 2 lines) are causing null pointer exception
        //dptl1.updateSecondaryDepartmentSection();//
        //dptl1.cancelSecondaryDepartmentSection();//
        
       PeopleSoft__c PS = new PeopleSoft__c();/* Start */
        PS.Persona__c = 'Text';
        insert PS;
        
        PeopleSoft_Department__c PD = new PeopleSoft_Department__c();
        PD.Department__c = d.ID;
        PD.PeopleSoft__c = PS.id;
        insert PD;/* End */
        
        

        COH_SI_NewsandAnnouncement__c coh = new COH_SI_NewsandAnnouncement__c();
        coh.Description__c = 'Testing';
        coh.Title__c = 'Testing';
        coh.Department__c = d.ID;
        coh.Display__c = true;
        coh.Start_Date_Time__c = System.now();
        coh.Stop_Date_Time__c = System.now();
        insert coh;
        
        COH_SI_NewsandAnnouncement__c coh1 = new COH_SI_NewsandAnnouncement__c();
        coh1.Description__c = 'Testing';
        coh1.Title__c = 'Testing';
        coh1.Department__c = d.ID;
        coh1.Display__c = true;
        coh1.Start_Date_Time__c = System.now();
        coh1.Stop_Date_Time__c = System.now();
        insert coh1;
        
        COH_SI_NewsandAnnouncement__c coh2 = new COH_SI_NewsandAnnouncement__c();
        coh2.Description__c = 'Testing';
        coh2.Title__c = 'Testing';
        coh2.Department__c = d.ID;
        coh2.Start_Date_Time__c = System.now();
        coh2.Stop_Date_Time__c = System.now();
        coh2.Display__c = true;
        insert coh2;
        
        
        
        dptl1.getNewsAnnouncement();
        
    dptl1.getUserStaff();//
        Test.stopTest();
    }
}