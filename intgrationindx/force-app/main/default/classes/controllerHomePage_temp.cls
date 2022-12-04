public class controllerHomePage_temp{

    public String keyword { get; set; }
    
    //All the VF page variables
    public string txtSearch{get;set;}
    public List<CollaborationGroup> lstCollaborationGroups{get;set;}
    public user loggedUser{get;set;}
    public Boolean booFeedItem{get;set;}
    public List<CollaborationGroupFeed> lstCollaborationGroupFeed{get;set;}
    public List<Carousel__c> lstCarousel{get;set;}
    public Carousel__c firstCarouselRecord{get;set;}
    public List<WebLink> lstWebLink{get;set;}
    public List<RecentlyViewed> lstRecentViews{get;set;}
    public List<CollaborationGroupFeed> lstCollaborationFeed{get;set;}
    public Map<String,String> dealIdIattachId {get;set;} //Map to store Carousel Id and related Attachment Id.
    public Home_Page_Tile__c tileSpotlight{get;set;}
    public Home_Page_Tile__c tileBreakThroughBlog{get;set;}
    public Id spotLightPicture { get; set; }
    public Id breakThroughPicture { get; set; }
    
    public Boolean booViewed{get;set;}
    public Boolean booVideo{get;set;}
    public Boolean booFood{get;set;}
    public Boolean booClassified{get;set;}
    public Boolean booPhoto{get;set;}
    public Boolean researchPersona {get;set;}
    public Boolean notResearchPersona {get;set;}
    public Boolean booEvent{get;set;}
    public Boolean booFavourite{get;set;}
    public Boolean booChatter{get;set;}
    String Preview = ApexPages.currentPage().getParameters().get('preview');
    
    //----------------------------------------------------------------------
    
    public controllerHomePage_Temp(){
        system.debug('****in contro****');
         dealIdIattachId = new Map<String,String>();
        loggedUser = [select id, FullphotoUrl FROM user where id =: UserInfo.getUserID()];      
        pageInitMethod();
    }
    
    public void pageInitMethod(){
        booEvent = false;
        favouriteSection();
        Groups();
        addingCorosel();
        recentView();
        settingInitialVariable();
        eClassified();
        loadTiles();
    }
    
    public void loadTiles(){
        tileSpotlight = New Home_Page_Tile__c();
        tileBreakThroughBlog = New Home_Page_Tile__c();
        Datetime current = System.now();
        Date d = current.date();
        Time t = current.time();
        Datetime dtLocalDateTime =  Datetime.newInstance(d,t);
        
        try { 
        if(preview=='true')
        {  
        tileSpotlight = [SELECT id, Name, Description__c, Brief_Description__c, Start_Date_Time__c, End_Date_Time__c, Hyperlink__c, Tile_Order__c, Video_Tile__c, View_More_text__c FROM Home_Page_Tile__c Where Tile_Order__c = 5 and Start_Date_Time__c != null and End_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and End_Date_Time__c >= :dtLocalDateTime and Preview__c =true Limit 1];
        }
        else
        {
                    tileSpotlight = [SELECT id, Name, Description__c, Brief_Description__c, Start_Date_Time__c, End_Date_Time__c, Hyperlink__c, Tile_Order__c, Video_Tile__c, View_More_text__c FROM Home_Page_Tile__c Where Tile_Order__c = 5 and Start_Date_Time__c != null and End_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and End_Date_Time__c >= :dtLocalDateTime and Preview__c =false Limit 1];

        }        
            List<attachment> spotLightPictures = [SELECT Id FROM Attachment WHERE parentId = :tileSpotlight.Id LIMIT 1];
            if(spotLightPictures != null && spotLightPictures.size() != 0) {
                spotLightPicture = spotLightPictures.get(0).Id;
            }
        } catch(Exception e) {  
            spotLightPicture = null;
            tileSpotlight.Name = 'Spotlight';
            tileSpotlight.Brief_Description__c = 'Coming Soon';
            tileSpotlight.Hyperlink__c = '#';
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }
        
        try {
        if(preview=='true')
        {
                    tileBreakThroughBlog = [SELECT id, Name, Description__c, Brief_Description__c, Start_Date_Time__c, End_Date_Time__c, Hyperlink__c, Tile_Order__c, Video_Tile__c, View_More_text__c FROM Home_Page_Tile__c Where Tile_Order__c = 7 and Start_Date_Time__c != null and End_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and End_Date_Time__c >= :dtLocalDateTime and Preview__c = true Limit 1];

        }
        else
        {
                    tileBreakThroughBlog = [SELECT id, Name, Description__c, Brief_Description__c, Start_Date_Time__c, End_Date_Time__c, Hyperlink__c, Tile_Order__c, Video_Tile__c, View_More_text__c FROM Home_Page_Tile__c Where Tile_Order__c = 7 and Start_Date_Time__c != null and End_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and End_Date_Time__c >= :dtLocalDateTime and Preview__c = false Limit 1];

        }
            List<attachment> breakThroughPictures = [SELECT Id FROM Attachment WHERE parentId = :tileBreakThroughBlog.Id LIMIT 1];
            if(breakThroughPictures != null && breakThroughPictures.size() != 0) {
                breakThroughPicture = breakThroughPictures.get(0).Id;
            }
        } catch(Exception e) {
            breakThroughPicture = null;
            tileBreakThroughBlog.Name = 'Breakthrough Blog';
            tileBreakThroughBlog.Brief_Description__c = 'Coming Soon';
            tileBreakThroughBlog.Hyperlink__c = '#';
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }
    }
    
    public PageReference loadDefaultLinks()
    {
        try {
            List<My_Favourite__c> favListByUser = new List<My_Favourite__c>();
            favListByUser = [Select id, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c from My_Favourite__c where 
                             User__c =: UserINfo.getUserId() order by Master_Favorite_Link__r.URL__c ASC];
            if(favListByUser == null || favListByUser.size() <= 0)
            {
                system.debug('favListByUser size '+ favListByUser.size());
                String userPersona= '';
                boolean IsPhysician = [Select id, name, Department, Is_Physician__c from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Is_Physician__c;                  
                if(IsPhysician)
                {
                    userPersona = 'Physicians';
                }
                else
                {  
                    String userDepartment = [Select id, name, Department from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Department;
                    List<PeopleSoft__c> userPersonas = [Select Persona__c from PeopleSoft__c where PeopleSoft__c.name = :userDepartment limit 1];
                    if(!userPersonas.isEmpty()){
                        userPersona = userPersonas[0].Persona__c;
                    }
                    else
                    {
                        userPersona = 'Business Support Services';
                        System.debug('userPersona = Business Support Services');    
                    }
                }
                system.debug('userPersona '+userPersona);
                String searchClause= '%' + userPersona + '%';
                List<Master_Favorite_Link__c> lstFavByPersona = [Select id, Name, Link__c, URL__c from Master_Favorite_Link__c where Master_Favorite_Link__c.Persona__c like :searchClause];
                if (lstFavByPersona != null || lstFavByPersona.size() > 0)   
                {
                    system.debug('lstFavByPersona '+ lstFavByPersona.size());
                    for(Master_Favorite_Link__c objFavByPersona : lstFavByPersona){
                        My_Favourite__c mf = new My_Favourite__c();
                        mf.Name = objFavByPersona.URL__c;
                        mf.Show_On_Home__c = true;
                        mf.User__c = UserInfo.getUserId();
                        mf.Master_Favorite_Link__c = objFavByPersona.Id;
                        system.debug('mf.Name '+ mf.Name);
                        favListByUser.add(mf);
                        system.debug('favListByUser' + favListByUser.size());
                    }
                    upsert favListByUser;
                }
            }  
        } catch(Exception e) {            
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }
        return null;
    }
    
    public void settingInitialVariable(){
        try {
            booPhoto = true;
            researchPersona = true;
            notResearchPersona = false;
            Set<String> lstPeopleSoftResearchNames = new Set<String>();
            string userPersona = '';
            String userDepartment = [Select id, name, Department from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Department;         
            boolean IsPhysician = [Select id, name, Department, Is_Physician__c from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Is_Physician__c;              
            If(IsPhysician)
            {
                userPersona = 'Physicians';
            }
            else
            {     
                List<PeopleSoft__c> userPersonas = [Select Persona__c from PeopleSoft__c where PeopleSoft__c.name = :userDepartment limit 1];
                if(!userPersonas.isEmpty()){
                    userPersona = userPersonas[0].Persona__c;
                }
                else
                {
                    userPersona = 'Business Support Services';
                    System.debug('userPersona = Business Support Services');    
                }
            }
            if(userPersona.equalsIgnoreCase('Research'))
            {
                researchPersona = true;
                notResearchPersona = false;
            }
            else
            {
                researchPersona = false;
                notResearchPersona = true;
            }
            booClassified = true;
            booFood = true;
            booVideo = true;
        } catch(Exception e) {            
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }
    }
    public void favouriteSection(){
        lstWebLink = New List<WebLink>();
        lstWebLink = [SELECT id, Name, url FROM WebLink Where createdByid =: UserInfo.getUserID() order by Name ASC LIMIT 7];
        if(!lstWebLink.IsEmpty())
           booFavourite = true;
        else
           booFavourite = false;
           
    }
    public void Groups(){
         lstCollaborationGroups = New List<CollaborationGroup>();
         Set<id> setIds = New Set<id>();
         for(CollaborationGroupMember loopCollaborationGroupMember : [Select id, CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId =: UserInfo.getUserId()])         
               setIds.add(loopCollaborationGroupMember.CollaborationGroupId);         

         if(!setIds.IsEmpty())    
               lstCollaborationGroups = [SELECT ID, Name, FullPhotoUrl FROM CollaborationGroup Where id IN: setIds LIMIT 3];
         if(!lstCollaborationGroups.isEmpty())
               booChatter = true;
         else
               booChatter = false;
    }
    public pageReference btnLearnMore(){
        PageReference page = New PageReference('/');
        return page;
    }
    
    public void addingCorosel(){
        System.debug('system.Today(): ' + system.Today());   
        lstCarousel = New List<Carousel__c>();
        System.debug('Preview: ' + preview); 
        if(preview =='true'){
        System.debug('Preview1: ' + preview); 
            lstCarousel = [SELECT id, Name, CarouselDescription__c, CarouselImageURL__c, CarouselTitle__c, ImageURL__C, PageLoadImage__c, (SELECT Id, ContentType FROM Attachments) FROM Carousel__c where ((PageLoadImage__c = true )) OR ((Display__c = true OR Display__c = false) and start_date__c != null and stop_date__c != null and start_date__c <=: system.Today() and stop_date__c >=: system.today() and Preview__c = true ) order by PageLoadImage__c DESC];
            }
            
        
        else{
        System.debug('Previewdefault: ' + preview); 
            lstCarousel = [SELECT id, Name, CarouselDescription__c, CarouselImageURL__c, CarouselTitle__c, ImageURL__C, PageLoadImage__c, (SELECT Id, ContentType FROM Attachments) FROM Carousel__c where PageLoadImage__c = true OR (Display__c = true and start_date__c != null and stop_date__c != null and start_date__c <=: system.Today() and stop_date__c >=: system.today()  ) order by PageLoadImage__c DESC];
        }
        /*if(lstCarousel.size() < 4) {
            List<Carousel__c> tempList = [SELECT id, Name, CarouselDescription__c, CarouselImageURL__c, CarouselTitle__c, ImageURL__C, PageLoadImage__c, (SELECT Id, ContentType FROM Attachments) FROM Carousel__c where Display__c = false and start_date__c != null and stop_date__c != null and start_date__c <=: system.Today() and stop_date__c >=: system.today() order by PageLoadImage__c DESC LIMIT :(4-lstCarousel.size())];
            lstCarousel.addAll(tempList);
        }*/
        for(Carousel__c loopCarousel: lstCarousel){
            //Fetching attachments related to each Carousel__c. Assuming that each attachment has Content Type of Image with it.
            for(Attachment attach : loopCarousel.Attachments) {
                if (dealIdIattachId.containsKey(loopCarousel.Id)) {
                    break;
                }
                if(attach.ContentType != null && attach.ContentType.contains('image')) {
                    dealIdIattachId.put(loopCarousel.Id, attach.Id);
                    break;
                }
            }
            
            if(!dealIdIattachId.containsKey(loopCarousel.Id)) {
                dealIdIattachId.put(loopCarousel.Id, 'NoImage');
            } 
            
             if (!String.isEmpty(loopCarousel.CarouselDescription__c) && (loopCarousel.CarouselDescription__c).length() > 251)
             {
                     loopCarousel.CarouselDescription__c = (loopCarousel.CarouselDescription__c ).mid(0 , 251) ;
             }
        }
        
    }
    
    public pageReference Search(){
        // Changes Made by sanjay
        // Added page Name and parameter
        PageReference Page = New PageReference('/apex/search?keyword='+txtSearch);
        return page.setRedirect(true);
    }
    
    public void recentView(){
        lstRecentViews = New List<RecentlyViewed>();
        lstRecentViews = [SELECT id, name FROM recentlyViewed ORDER BY LastReferencedDate DESC Limit 7];
        
        if(lstRecentViews.IsEmpty())
            booViewed = false;
        else
            booViewed = true;
    }
    
    public void eClassified(){
        lstCollaborationFeed = New List<CollaborationGroupFeed>();
        List<CollaborationGroup> lstGrpRecord = [Select id from CollaborationGroup Where Name ='Eclassified'];
        if(!lstGrpRecord.isEmpty()) {
            lstCollaborationFeed = [select id, LinkUrl, Title, body, ParentID From CollaborationGroupFeed Where ParentID =: lstGrpRecord[0].Id Limit 5];     
        }
    }
}