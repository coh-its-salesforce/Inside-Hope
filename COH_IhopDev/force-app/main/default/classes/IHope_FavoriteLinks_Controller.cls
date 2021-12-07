public without sharing class IHope_FavoriteLinks_Controller {
    @AuraEnabled
    public static List<My_Favourite__c> queryMyFavLinks(){
        List<My_Favourite__c> myFavList = new List<My_Favourite__c>();
        
        myFavList =  [SELECT id, Name, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c FROM My_Favourite__c WHERE 
                      Name != null AND User__c =: UserINfo.getUserId() ORDER BY CreatedDate DESC LIMIT 5];
        return myFavList;
    }
}