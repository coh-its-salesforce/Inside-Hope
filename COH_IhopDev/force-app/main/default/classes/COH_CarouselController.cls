public class COH_CarouselController {

    @AuraEnabled
    public static list<cloudx_cms__SS_Carousel__c> dataCarousel(){
       /* list<Carousel__c> carousel = new list<Carousel__c>([SELECT id, Name, CarouselDescription__c, CarouselImageURL__c, CarouselTitle__c, ImageURL__C,
                                                            PageLoadImage__c, (SELECT Id, ContentType FROM Attachments)
                                                            FROM Carousel__c]);*/
        list<cloudx_cms__SS_Carousel__c> carousel = new list<cloudx_cms__SS_Carousel__c>([Select id,
                                                                                                     (SELECT Id, cloudx_cms__Carousel__c, cloudx_cms__Autoplay__c,
                                                                                                      cloudx_cms__Button_Label__c, cloudx_cms__Button_URL__c,
                                                                                                      cloudx_cms__Button_Variant__c, cloudx_cms__Description_Size__c,
                                                                                                      cloudx_cms__Description_Text_Color__c, cloudx_cms__Description__c, 
                                                                                                      cloudx_cms__Height__c, cloudx_cms__Image_URL__c,
                                                                                                      cloudx_cms__Loop_Video__c, cloudx_cms__Raw_MP4_Video_URL__c,
                                                                                                      cloudx_cms__Raw_OGG_Video_URL__c, cloudx_cms__Raw_WEBM_Video_URL__c, 
                                                                                                      cloudx_cms__Show_Video_Controls__c, cloudx_cms__Slide_Order__c,
                                                                                                      cloudx_cms__Text_Alignment__c, cloudx_cms__Text_Height__c,
                                                                                                      cloudx_cms__Text_Overlay_Background__c, cloudx_cms__Text_Position__c,
                                                                                                      cloudx_cms__Title_Text_Color__c, cloudx_cms__Title_Text_Size__c,
                                                                                                      cloudx_cms__Title__c, cloudx_cms__Video_Embed_URL__c ,
                                                                                                      Description__c, URL__c 
                                                                                                      FROM cloudx_cms__Carousel_Slides__r  order by cloudx_cms__Slide_Order__c asc LIMIT 4) from cloudx_cms__SS_Carousel__c] );
        
        return carousel;
    }
}