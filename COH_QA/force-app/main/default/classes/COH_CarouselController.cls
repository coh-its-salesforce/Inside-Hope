public without sharing class COH_CarouselController {
    
    @AuraEnabled
    public static list<Carousel__c> dataCarousel(){
        /* list<Carousel__c> carousel = new list<Carousel__c>([SELECT id, Name, CarouselDescription__c, CarouselImageURL__c, CarouselTitle__c, ImageURL__C,
PageLoadImage__c, (SELECT Id, ContentType FROM Attachments)
FROM Carousel__c]);*/
        Date todayDate = System.today();
        list<Carousel__c> carousel = new list<Carousel__c>([SELECT Id, 
                                                            CarouselDescription__c, CarouselImageURL__c,
                                                            CarouselTitle__c, ImageURL__c, PageLoadImage__c, Display__c, 
                                                            Image_Attachment_Id__c, Start_Date__c, Stop_date__c, Tile_Name__c,
                                                            Preview__c,RecordType.name ,
                                                            (Select id ,Slide_Order__c, Carousel__c, Image_URL__c, Clickable_Image_URL__c, Start_Date__c,
                                                             Stop_Date__c, Carousel_Slide_Name__c, 
                                                             Carousel_Slide_Description__c, Active__c from Carousel_Slides__r where Start_Date__c<=:todayDate  and Stop_Date__c >=:todayDate and Active__c=true order by Slide_Order__c ASC LIMIT 4)
                                                            FROM Carousel__c 
                                                            where RecordType.Name = 'Inside Hope Carousel']);        
        return carousel;
    }
    
    @AuraEnabled
    public static list<Knowledge__Kav> ArtcleData(String UrlName){
        return [SELECT Id, Summary, AssignmentNote, Article__c, Exceptions__c, Keywords__c, Script__c, Supporting_Docs_Info__c, Title,
                overview__c, Additional_Actors_Users_Roles__c, Workflow__c, Permission_Sets_Profile_Assignments__c,
                Assumptions_Miscellaneous_Items__c, Note__c, Internal_Notes__c, Administrator_s_Notes__c FROM Knowledge__kav where URLName=:UrlName];
    }
    
}