public class COH_SIP_controllerHomePage_temp{

    public String keyword { get; set; }
    
    //All the VF page variables
    public string txtSearch{get;set;}
    public user loggedUser{get;set;}
    public List<RecentlyViewed> lstRecentViews{get;set;}
    public Map<String,String> dealIdIattachId {get;set;} //Map to store Carousel Id and related Attachment Id.
    public Boolean booViewed{get;set;}
    public Boolean booEvent{get;set;}
    
    
    public COH_SIP_controllerHomePage_Temp(){
        system.debug('****in contro****');
         dealIdIattachId = new Map<String,String>();
        loggedUser = [select id, FullphotoUrl FROM user where id =: UserInfo.getUserID()];      
        pageInitMethod();
    }
    
    public void pageInitMethod(){
        booEvent = false;
        recentView();
        
    }
    
     public pageReference Search(){
        // Changes Made by sanjay
        // Added page Name and parameter
        PageReference Page = New PageReference('/apex/search?keyword='+txtSearch);
        return page.setRedirect(true);
    }
    
    public void recentView(){
        lstRecentViews = New List<RecentlyViewed>();
        lstRecentViews = [SELECT id, name FROM RecentlyViewed ORDER BY LastReferencedDate DESC limit 1000];
        
        if(lstRecentViews.IsEmpty())
            booViewed = false;
        else
            booViewed = true;
    }
}