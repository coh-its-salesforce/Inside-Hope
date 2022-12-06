public without sharing class IHope_CurrentUserInfo {
  @AuraEnabled 
    public static user currentUserDetailMethod(){    
      User currentUserObj = [select Id,Name,FirstName,LastName,Username,Country,Email, IsActive, Alias,TimeZoneSidKey, IsPortalEnabled, Profile.Name,UserRole.Name,persona__c From User Where Id=:userInfo.getUserId()];
       system.debug('currentUserObj:::'+currentUserObj);
        return currentUserObj;
    }
    
    
    @AuraEnabled
    public static list<Campus_Plan_Alert__c> showAnnouncement(){
        
        DateTime nowTime = System.now();
       return [ SELECT Id, Content__c FROM Campus_Plan_Alert__c 
               where IsActive__c = true and (Start_Date__c <=:nowTime and Stop_Date__c >=:nowTime)
              and Recordtype.name = 'Ihope Intranet Announcement'];
    } 
    
    
    
    @AuraEnabled
    public static List<MenuWrapper> menuData(){
       // list<menu__c> menuheaderList= [Select id,Name, Desktop_Label__c, Mobile_Label__c, Menu_Order__c,Parent_MenuId__c,Menu_URL__c,Sub_Menu__c from menu__c where Parent_MenuId__c = null order by Menu_Order__c ASC];
        map<Id,list<menu__c>> childMenusMap = new Map<Id,list<menu__c>>();
       // String headerdata= System.URL.getSalesforceBaseUrl().get('delegate');
        
       // String urlvalue=Apexpages.currentPage().getUrl();
        
       // String url='https://' + headerdata+ urlvalue;
        for(menu__c inx : [Select id,Name, Desktop_Label__c, Mobile_Label__c, Menu_Order__c,
                           Parent_MenuId__c, Department__c, Secondary_Department__c, Menu_URL__c,Sub_Menu__c 
                           from menu__c 
                           where Parent_MenuId__c != null 
                           order by Name ASC]){
                               
                               if(inx.Menu_URL__c == NULL){
                                   inx.Menu_URL__c = System.label.domainURL +'apex/DepartmentPortal?id='+inx.Department__c;
                               }
                               
                               if(!childMenusMap.containskey(inx.Parent_MenuId__c)){
                                   childMenusMap.put(inx.Parent_MenuId__c,new list<menu__c>());
                               }
                               childMenusMap.get(inx.Parent_MenuId__c).add(inx);
        }
        
        list<MenuWrapper> mnuWrpr = new list<MenuWrapper>();
        
        for(menu__c inx: [Select id,Name, Desktop_Label__c, Mobile_Label__c, Menu_Order__c,Parent_MenuId__c,Menu_URL__c,Sub_Menu__c 
                          from menu__c where Parent_MenuId__c = null order by Menu_Order__c ASC]){
                              MenuWrapper rec = new MenuWrapper();
                              rec.ParentMenu = inx;
                              if(childMenusMap.containskey(inx.Id))
                              rec.childMenus = childMenusMap.get(inx.Id);
                              
                              mnuWrpr.add(rec);
                          }
        
        
        
        return mnuWrpr;
    }
    
    
    
    @AuraEnabled
    public static list< ShortCut_Link_Group__c> shortCuts(){
        return [select id, Group_Name__c, Group_Order__c, Link__c from ShortCut_Link_Group__c];
    }
    
    @AuraEnabled
    public static ShortCut_Link_Group__c shortCutsDefault(String Persona){
        system.debug('Persona'+Persona);
        return [select id, Group_Name__c, Group_Order__c, Link__c from ShortCut_Link_Group__c where Group_Name__c=:Persona];
    }
    @AuraEnabled
    public static list< ShortCut_Link__c> childShortcuts( String shorcutSelc){
        return [SELECT Id,Name, Group__c, Link_ID__c, Link_Url__c, Order__c, Mobile_link__c, Show_Mobile_class__c 
                FROM ShortCut_Link__c where Group__c =:shorcutSelc.trim()];
    }
  
    
    public class MenuWrapper{
        @AuraEnabled
        public Menu__c ParentMenu;
        @AuraEnabled
        public list<Menu__c> childMenus = new list<Menu__c>();
    }
}