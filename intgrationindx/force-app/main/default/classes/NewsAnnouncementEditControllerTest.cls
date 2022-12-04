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
private class NewsAnnouncementEditControllerTest {

    static testMethod void myUnitTest() {
        
        Department__c dept = new Department__c();
        dept.Name = 'Test Department';
        insert dept;
        
        COH_SI_NewsandAnnouncement__c coh = new COH_SI_NewsandAnnouncement__c();
        coh.Description__c = 'Testing';
        coh.Title__c = 'Testing';
        coh.Department__c = dept.Id;
        coh.Start_Date_Time__c = System.now();
        coh.Stop_Date_Time__c = System.now();
        insert coh;
        
        Attachment att = new Attachment();
        att.Name = 'Test COH';
        att.Body = Blob.valueOf('Test COH');
        att.ParentId = coh.Id;
        insert att;
        
        ApexPages.currentPage().getParameters().put('Id', coh.Department__c);
        NewsAnnouncementEditController controller = new NewsAnnouncementEditController();
        controller.getSecondaryDepartment();
        controller.addNewsAnnouncement();
        controller.lstNewsAnnouncementWrapper[0].imageName = 'testing1';
        controller.lstNewsAnnouncementWrapper[0].imageContent = Blob.valueOf('testing123');
        controller.lstNewsAnnouncementWrapper[1].newsAnnouncement.Image_Attachment_Id__c = 'Error';
        controller.customSave();
        controller.lstNewsAnnouncementWrapper[1].newsAnnouncement.Image_Attachment_Id__c = att.Id;
        controller.lstNewsAnnouncementWrapper[1].newsAnnouncement.Title__c = 'title1';
        controller.lstNewsAnnouncementWrapper[1].imageName = 'testing2';
        controller.customSave();
        controller.lstNewsAnnouncementWrapper[1].imageContent = Blob.valueOf('testing456');
        controller.customSave();
        controller.customDelete();
        controller.lstNewsAnnouncementWrapper[1].isSelected = true;
        controller.customDelete();
        controller.cancel();
        
    }
    
    static testMethod void myUnitTest_SecondaryDepartment() {
        
        Secondary_Department__c dept = new Secondary_Department__c();
        dept.Name = 'Test Department';
        insert dept;
        
        COH_SI_NewsandAnnouncement__c coh = new COH_SI_NewsandAnnouncement__c();
        coh.Description__c = 'Testing';
        coh.Title__c = 'Testing';
        coh.Secondary_Department__c = dept.Id;
        coh.Start_Date_Time__c = System.now();
        coh.Stop_Date_Time__c = System.now();
        insert coh;
        
        Attachment att = new Attachment();
        att.Name = 'Test COH';
        att.Body = Blob.valueOf('Test COH');
        att.ParentId = coh.Id;
        insert att;
        
        ApexPages.currentPage().getParameters().put('id',coh.Department__c);
        NewsAnnouncementEditController controller = new NewsAnnouncementEditController();
        
        controller.addNewsAnnouncement();
        controller.lstNewsAnnouncementWrapper[0].imageName = 'testing1';
        controller.lstNewsAnnouncementWrapper[0].imageContent = Blob.valueOf('testing123');
        controller.lstNewsAnnouncementWrapper[1].newsAnnouncement.Title__c = 'title1';
        controller.lstNewsAnnouncementWrapper[1].imageName = 'testing2';
        controller.lstNewsAnnouncementWrapper[1].imageContent = Blob.valueOf('testing456');
        controller.customSave();
        controller.customDelete();
        controller.lstNewsAnnouncementWrapper[1].isSelected = true;
        controller.customDelete();
        controller.cancel();        
        
    }
}