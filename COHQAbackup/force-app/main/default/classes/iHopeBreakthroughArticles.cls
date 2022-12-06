public without sharing class iHopeBreakthroughArticles {
@AuraEnabled(cacheable=true)
    public static List<SObject> breakthroughArticles(String searchParam, String numberofRecords){
        Id userId = UserInfo.getUserId();
        String likeParam = '%' + searchParam + '%';
        String Query = '';
        if(searchParam != null || numberofRecords!= null){
            Query = 'Select Id, TitleRTF__c, Name, Release_Date__c, BlogAuthor__c, ImageURL__c, FeaturedImageURL__c, MetaKeywords__c, MetaTitle__c, Property__c, Profile_Image__c, Link_to_Full_Article__c from Breakthrough__c order by Release_Date__c desc Limit ' + numberofRecords;
        } else {
            Query = 'Select Id, TitleRTF__c, Name, Release_Date__c, BlogAuthor__c, ImageURL__c, FeaturedImageURL__c, MetaKeywords__c, MetaTitle__c, Property__c, Profile_Image__c, Link_to_Full_Article__c  from Breakthrough__c order by Release_Date__c desc Limit 8';
        }
        system.debug('Query | '+ Query);
        List<SObject> sObjectList=Database.query(Query);
        return sObjectList;
    }
}