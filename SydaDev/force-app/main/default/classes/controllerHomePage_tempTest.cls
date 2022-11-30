@isTest
public class controllerHomePage_tempTest {
  
    public testMethod static void unitTest() {
        
        Department__c dept = new Department__c();
        dept.Name = 'Test Department';
        dept.MenuItem__c = 'dep1;dep2;dep3';
        insert dept;
        
        Attachment att = new Attachment();
        att.Name = 'Test COH';
        att.Body = Blob.valueOf('Test COH');
        att.ParentId = dept.Id;
        insert att;
        
        Carousel__c c1 = new Carousel__c();
        c1.CarouselTitle__c = 'test';
        c1.Display__c = true;
        c1.Image_Attachment_Id__c = att.Id;
        c1.CarouselDescription__c = 'sfdsfd';
        insert c1;
        
        controllerHomePage_temp ctr = new controllerHomePage_temp();
        ctr.search();
        ctr.btnLearnMore();
        
    }
    
     public testMethod static void ext_NewsAnnouncementTest(){
        ext_NewsAnnouncement ex = new ext_NewsAnnouncement();
        
    }
}