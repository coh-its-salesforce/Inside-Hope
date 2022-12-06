@isTest
public class CarouselEditControllerTest {
    public testMethod static void unitTest() {
        
        Carousel__c c = new Carousel__c();
        c.CarouselTitle__c = 'test';
        c.Display__c = true;
        insert c;
        
        Attachment att = new Attachment();
        att.Name = 'Test COH';
        att.Body = Blob.valueOf('Test COH');
        att.ParentId = c.Id;
        insert att;
        
        Carousel__c c1 = new Carousel__c();
        c1.CarouselTitle__c = 'test';
        c1.Display__c = true;
        c1.Image_Attachment_Id__c = att.Id;
        insert c1;
        
        CarouselEditController ctr = new CarouselEditController();
        ctr.addCarousel();
        ctr.lstCarouselWrapper[0].imageName = 'test';
        ctr.lstCarouselWrapper[0].imageContent = Blob.valueOf('Test COH');
        ctr.lstCarouselWrapper[1].imageName = 'test';
        ctr.lstCarouselWrapper[1].imageContent = Blob.valueOf('Test COH');
        ctr.cancel();
        ctr.customSave();
        ctr.lstCarouselWrapper[0].carousel.PageLoadImage__c = true;
        ctr.lstCarouselWrapper[1].carousel.PageLoadImage__c = true;
        ctr.customSave();
        ctr.lstCarouselWrapper[1].carousel.PageLoadImage__c = false;
        ctr.customSave();
        ctr.customDelete();
        ctr.lstCarouselWrapper[0].isSelected = true;
        ctr.customDelete();
    }
}