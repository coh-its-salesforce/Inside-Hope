@isTest
public class COH_HRPortalCarouselControllerTest {
    @isTest
    static void myUnitTest(){
        test.startTest();
        HR_Portal_Carousel__c c = new HR_Portal_Carousel__c();
        c.Inactive__c = false;
        c.Heading__c = 'test';
        c.Image_URL__c = 'http://test.com';
        c.Order__c = 0;
        c.Description__c = 'test';
        insert c;
        
        List<HR_Portal_Carousel__c> rec = COH_HRPortalCarouselController.getCarouselImages();
        
        test.stopTest();
        system.assertEquals(1, rec.size());
    }
    
 
}