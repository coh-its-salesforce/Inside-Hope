public class communityController {
    
    @AuraEnabled
    public static List<Campus_Plan_News__c>  carousel(){
        List<Campus_Plan_News__c> campusPlanNewsList = new List<Campus_Plan_News__c>();
        List<Campus_Plan_News__c> campusPlanNews = new List<Campus_Plan_News__c>([SELECT Id,Start_Date__c,Stop_Date__c, Carousel_Image__c, Department_Name__c, Description__c, Image_Attachment_Id__c, Image_URL__c, News_Type__c, Location__c, URL_link__c FROM Campus_Plan_News__c
                                                                                  where Display__c = true order by Order__c ]);
        for(Campus_Plan_News__c rec : campusPlanNews){
            if(rec.Start_Date__c == null && rec.Stop_Date__c == null){
                campusPlanNewsList.add(rec);
            }else{
                if(rec.Start_Date__c<=System.today() && rec.Stop_Date__c>=System.today()){
                    campusPlanNewsList.add(rec);
                }
            }
        }
        return campusPlanNews;
    }
}