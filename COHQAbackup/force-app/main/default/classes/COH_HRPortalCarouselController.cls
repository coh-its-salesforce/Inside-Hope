public class COH_HRPortalCarouselController {

    @AuraEnabled
    public static List<HR_Portal_Carousel__c> getCarouselImages(){
        return [Select id, Description__c, Heading__c, Image_URL__c, Order__c, Redirect_URL__c from HR_Portal_Carousel__c 
               Where Inactive__c = false order by Order__c ASC];
    }
}