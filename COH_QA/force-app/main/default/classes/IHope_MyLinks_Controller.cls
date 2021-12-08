public without sharing class IHope_MyLinks_Controller {
    @AuraEnabled
    public static List<My_News__c> queryMyLinks(){
        List<My_News__c> myLinkList = new List<My_News__c>();
        
        myLinkList =  [Select id, Name from My_News__c order by createddate ASC LIMIT 10];
        /*myLinkList =  [Select id, Name, URL__c, Show_On_Home__c from My_News__c where 
                                        Name != null  order by Name ASC]; */
        return myLinkList;
    }
}