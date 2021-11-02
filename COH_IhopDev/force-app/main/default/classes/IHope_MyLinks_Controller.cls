public without sharing class IHope_MyLinks_Controller {
    @AuraEnabled
    public static List<My_News__c> queryMyLinks(){
        List<My_News__c> myLinkList = new List<My_News__c>();
        
        myLinkList =  [Select id, Name, URL__c, Show_On_Home__c from My_News__c where 
                                        Name != null /*AND  User1__c =: UserINfo.getUserId()*/ order by Name ASC];
        return myLinkList;
    }
}