public without sharing class HRPortalCommonController {
    
    @AuraEnabled
    public static string getPageContent(string pageName){
        string content = '';
        if(string.isNotBlank(pageName) || string.isNotEmpty(pageName)){
            List<HR_Portal_Page_Content__c> pages = [Select id, Content__c from HR_Portal_Page_Content__c 
                                                      Where Unique_Page_Name__c =:pageName ];
            if(!pages.isEmpty()){
                content = pages[0].Content__c;
            }
        }
        return content;
    }
    
    
    @AuraEnabled
    public static boolean checkIfManager(){
        boolean manager = false;
        set<Id> managersList = new Set<Id>();
        for(supported_by__c sb:[select Supported_User__c,Supported_By_User__c from supported_by__c  
                                 where Allow_Assistant_to_Nominate_Gift_Card__c=true and Supported_By_User__c =:userinfo.getuserid() and Supported_User__c != null]){
            managersList.add(sb.Supported_User__c);
        }
        List<User> userList = [select id,Per_Status__c, Name,title from user 
                                where (Mgr__c =:userinfo.getUserId() and IsActive=true and Per_Status__c = 'E') 
                                      OR (mgr__c IN: managersList  and IsActive=true and Per_Status__c = 'E')];
        
        return !userList.isEmpty();
       
    }
}