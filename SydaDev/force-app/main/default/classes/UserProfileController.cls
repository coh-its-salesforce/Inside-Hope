public with sharing class UserProfileController {
   
    public String uID          {get; set;}
    public String UserImageURL {get; set;}
    public boolean isFollowing {get; set;}
    public user userObj        {get; set;}
    public user UserAdministrator {get; set;}
    public user UserManager {get; set;}    
    public connectAPI.UserDetail userDetail {get; set;}
    public connectAPI.UserDetail managerDetail {get; set;}
    public string managerPhoto {get; set;}
    public string networkId {get; set;}
    public List<SupportUserWrapper> supportedByUsers {get; set;}
    public UserWrapper Administrator {get; set;}
    public UserWrapper Manager {get; set;}
    public boolean isSameUser {get; set;}
    /* changes made by Pavani*/
    public string userJob {get;set;}
    public string userPager {get;set;}
    public string userSupervisor {get;set;}
    public string userFax {get;set;}
    public string userlinkedIn {get;set;}
    public boolean userMemberships {get;set;}
    public string userMapSite {get;set;}
    public string userRiverGradeMapSite {get;set;}
    public string userCommunitiesMapSite {get;set;}    
    public Date userYearAdmitted {get;set;} 
    public string userCurrentYear {get;set;}   
    /* end of changes by Pavani*/
    private boolean mRedirectToHomepage = false;         // This variable is used if there is an error in the contructor, it redirects the user to the iHope Homepage. 
    private string mErrorMessage;
    private string mException; 

    public string placeholderText {get;set;}
    
    /*
    public ConnectApi.FeedItemPage feedItemPage{get;set;}
    
    public Object TextSegmentType{
        get{
        return ConnectApi.MessageSegmentType.Text;
        }
    }    
    public Object MentionSegmentType{
        get{
            return ConnectApi.MessageSegmentType.Mention;
        }
    }
    */
    
    /*
     * The binary data of the image uploaded by the user
     */
    public transient Blob blobValue { get; set; }
    
    /*
     * The content type, determined by Salesforce, of
     * the image uploaded by the user
     */
    public transient String contentType { get; set; }
    
    /*
     * The name of the image file uploaded by the user
     */
    public transient String filename { get; set; }
    
    /*
     * @return the URL for the large profile photo of the specified
     *         user in the current community
     */
    public String getLargePhotoUrl() {
        return ConnectApi.ChatterUsers.getPhoto(
            Network.getNetworkId(), UserInfo.getUserId()).largePhotoUrl;
    }
    
    public UserProfileController(){
        uId = ApexPages.currentPage().getParameters().get('UId');
        userObj= new User();
        networkId = Network.getNetworkId();
        isFollowing = false;
        supportedByUsers = new List<SupportUserWrapper>();
        isSameUser = false;
        userSupervisor = '';
        userCurrentYear = '';
        if(!String.isBlank(uId)){
            if(uId == UserInfo.getUserId())
                isSameUser = true;
            
             List<user> userList = new List<user>([Select id, AboutMe, Phone, Extension, MobilePhone, 
                                                   Academic_Office_NO_PATIENT_CALLS__c, BCEL__c, Call_Center_PATIENT_CALLS__c,
                                                   Home_Phone__c, Work_Phone__c, Work_Mobile__c, ManagerId, Supervisor__c, 
                                                   Job_Title__c, Show_Biography__c,Show_Education_Training__c,Show_Honours_Awards__c,
                                                   secondary_supervisor__c, Mgr__c, Show_Memberships_Certifications__c, Show_Professional_experience__c,
                                                   Show_Publications__c,name, FirstName, Lastname, Displayname__c, Suffix__c, Department, FullPhotoUrl,
                                                   Division_Program__c, Clinical_Area__c, Sub_Specialties__c, Location__c,Primary_Specialties__c,                    
                                                   (Select Id, name, Supported_User__c, Supported_By_User__c, Supported_By_User__r.Name, 
                                                    Supported_By_User__r.Displayname__c from Supported_By__r),                 
                                                   Professional_Experience__c, Video_Link__c, Education_Training__c, Honours_Awards__c, 
                                                   Memberships_Certifications__c, Publications__c,Linkedin_Profile__c,Duarte_Map__c,Communities_Map__c,
                                                   RiverGrade_Map__c,BMCServiceDesk__pager__c,Fax__c,Year_Admitted__c from User where id=: uId ]);
            
            //Setting up LinkedIn profile and Map considering the first user as the User Profile page always displays one record
           /*  changes made by Pavani*/
            try {
                userJob = userList[0].Job_Title__c;
                userPager = userList[0].BMCServiceDesk__pager__c ;
                userFax = userList[0].Fax__c;
                if(userList[0].Year_Admitted__c != null)
                {
                    userYearAdmitted = userList[0].Year_Admitted__c;
                    Decimal dDaysbetween = userYearAdmitted.daysBetween(Date.today());
                    Integer intDateDiff = (integer)Math.ceil(dDaysbetween/365);
                    system.debug(intDateDiff);
                    Integer modResult = Math.mod(intDateDiff, 10);        
                    if (modResult == 1) { 
                        userCurrentYear = modResult +  'st Year'; 
                    } else if (modResult == 2) { 
                        userCurrentYear = modResult +  'nd Year'; 
                    } else if (modResult == 3) { 
                        userCurrentYear = modResult +  'rd Year'; 
                    } else { 
                        userCurrentYear = modResult +  'th Year'; 
                    }
                }
                // Abhisheks code to show Supervisors
                //Comment code because we now have to show secondary supervisor and the manager.
                /*boolean IsPhysician;
                IsPhysician  = [Select id, name, Department, Is_Physician__c from User where Id = :uId and IsActive=true limit 1].Is_Physician__c;
                if(IsPhysician) {
                    userSupervisor = '';
                }
                else {  
                    userSupervisor = userList[0].Supervisor__c;
                }*/
                
                //Code to show secondary supervisor & manager
                if(!(userList.isEmpty()) && userList.size() > 0)
                {                    
                    boolean IsPhysician;
                    IsPhysician  = [Select id, name, suffix__c, Displayname__c, Department, Is_Physician__c from User where Id = :uId and IsActive=true limit 1].Is_Physician__c;
                    
                    if(!(userList.isEmpty()) && userList.size() > 0 && userList[0].secondary_supervisor__c != null)
                    {
                        /*if(IsPhysician) {
                            Manager = null;
                        }
                        else { 
                            Manager = new UserWrapper(userList[0].secondary_supervisor__c,networkId);
                        }*/
                        Manager = new UserWrapper(userList[0].secondary_supervisor__c,networkId);
                        UserManager = [select id, Displayname__c from user where id=:userList[0].secondary_supervisor__c];
                        if(!(userList.isEmpty()) && userList.size() > 0 && userList[0].Mgr__c != null)
                        {
                            Administrator = new UserWrapper(userList[0].Mgr__c,networkId);
                            UserAdministrator = [select id, Name, Displayname__c from user where id=:userList[0].Mgr__c];
                            system.debug('Administrator ='+ Administrator);
                            system.debug('Mgr__c = '+userList[0].Mgr__c);
                            system.debug('administrator = '+userAdministrator);
                            system.debug('Administrator displayname = '+UserAdministrator.displayname__c);
                            system.debug('UserList[0] = '+userList[0]);
                            system.debug('networkID ='+networkID);
                        }
                        else
                        {
                            Administrator = null;
                        }
                    }
                    else
                    {
                        if(!(userList.isEmpty()) && userList.size() > 0 && userList[0].Mgr__c != null)
                        {
                            Manager = new UserWrapper(userList[0].Mgr__c,networkId);
                            UserManager = [select id, Displayname__c from user where id=:userList[0].Mgr__c];
                        }
                        else
                        {
                            Manager = null;
                        }
                    }
                }                
            }
            catch (Exception e) {
                mErrorMessage = 'Unable to load the profile for User Id: ' + uId;
                mException = e.getMessage() + '  :  ' + e.getStackTraceString();
        mRedirectToHomepage = true;
                return;
            }
            
             userlinkedIn = userList[0].Linkedin_Profile__c; //'https://www.linkedin.com/profile/view?id=AAIAABrDE_QBNFGGP2QS4jryLm-fb7XxvVGCOJs&trk=nav_responsive_tab_profile'
             userMapSite = 'https://cityofhope.my.salesforce.com/069d0000001WElG'; //userList[0].Map__c;
             userRiverGradeMapSite = 'https://cityofhope.my.salesforce.com/069d0000001WElL';
             userCommunitiesMapSite = 'https://www.google.com/maps/d/viewer?mid=zganws14pNrk.k48frPwZTGPY';
             
            if(userlinkedIn != null && userlinkedIn != '')
             {
             if(userlinkedIn.indexOf('http') == -1){
                 userlinkedIn = 'https://'+userlinkedIn;
             } 
             }  
             /* end of changes by Pavani*/
            
            userDetail = ConnectApi.ChatterUsers.getUser(Network.getNetworkId(), uId);
           
            if(!String.isBlank(userDetail.managerId)){
               managerDetail =  ConnectApi.ChatterUsers.getUser(Network.getNetworkId(), userDetail.managerId);
                ConnectApi.Photo photo = ConnectApi.ChatterUsers.getPhoto(Network.getNetworkId(), userDetail.managerId);
                system.debug('======photo==='+photo);
                managerPhoto =photo.standardEmailPhotoUrl;
            }
            system.debug('======managerPhoto==='+managerPhoto);
            system.debug('========='+userDetail);
            if(!userList.isEmpty()){
                userObj = userList[0];
                //Abhisheks code to show message to the user, if details are not filled.
                placeholderText = '';
                if(!userObj.Show_Biography__c && !userObj.Show_Professional_experience__c &&
                   !userObj.Show_Education_Training__c && !userObj.Show_Honours_Awards__c &&
                   !userObj.Show_Memberships_Certifications__c && !userObj.Show_Publications__c)
                {
                    placeholderText = 'Please fill in your details.';
                }
                //End Abhisheks code
                
                if(!String.isBlank(userObj.FullPhotoUrl)){
                    UserImageURL = userObj.FullPhotoUrl ;
                }
                if(!userObj.Supported_By__r.isEmpty()){
                    
                    for(Supported_By__c sb: userObj.Supported_By__r){
                        supportedByUsers.add(new SupportUserWrapper(sb,networkId));    
                    } 
                }
                checkForFollow();
            }
           // fetchUserFeed();
        }
    } 
    /*
    public void fetchUserFeed(){
        //code to get chatter newsfeed
        feedItemPage = ConnectApi.ChatterFeeds.getFeedItemsFromFeed(Network.getNetworkId(), ConnectApi.FeedType.UserProfile, uId);                                     
        system.debug('======'+feedItemPage.items);
    } */                                
                                     
    public void checkForFollow(){
        List<EntitySubscription> followers =  [select id, subscriberid, subscriber.name from EntitySubscription
                                                        where parentid =:uid and subscriberid =: UserInfo.getUserId() limit 1000] ;
        
        system.debug('======='+followers); 
        if(!followers.isEmpty()){
            isFollowing = true;
        }else{
            isFollowing = false;
        }
    }
    
public pageReference doUpdateUser(){
        try{
        if(blobValue!=null && contentType!= null && filename !=null){
            ConnectApi.BinaryInput photoFileInput =
                new ConnectApi.BinaryInput(blobValue, contentType, filename);
            
           ConnectApi.ChatterUsers.setPhoto(
                Network.getNetworkId(), UserInfo.getUserId(), photoFileInput);
                /*  changes made by Pavani*/
                              userObj.Job_Title__c = userJob;
                              userObj.BMCServiceDesk__pager__c = userPager;
                              userObj.Fax__c = userFax;
                              userObj.Linkedin_Profile__c = userlinkedIn;
               userObj.Duarte_Map__c = userMapSite;
               
               userobj.Show_Memberships_Certifications__c = userMemberships;
} 


         /* end of changes by Pavani*/
           
            update userObj;

        }catch(Exception e){
            apexpages.addMessages(e);
            return null;
        }

        pageReference cpage = page.userProfile;
        cpage.getParameters().put('uid',userObj.id);
        return cpage.setRedirect(true);
    }

    public PageReference toggleFollow(){
        system.debug('====='+uID);
        if(!String.isEmpty(uID)){
            
            String communityId = Network.getNetworkId();
            system.debug('=communityId===='+communityId);
            if(!isFollowing){
               // ConnectApi.ChatterUsers.follow(null, 'me', ''+uID);
                EntitySubscription e = new EntitySubscription();
                e.subscriberId = UserInfo.getUserId();
                e.parentId = uID;
                e.NetworkId = Network.getNetworkId();
                insert e;
            }else{
                List<EntitySubscription> listEntitySub = new List<EntitySubscription>();
                listEntitySub = [SELECT Id FROM EntitySubscription WHERE ParentId =: uId AND SubscriberId =: 
                                        UserInfo.getUserId() limit 1000];
                system.debug('===='+listEntitySub.size() );
                if(listEntitySub.size() > 0) {
                    delete listEntitySub;
                }//ConnectApi.Chatter.deleteSubscription(null,''+ uID);
            }
            checkForFollow();
        }
        return null;
    }
    
    @remoteaction
    public static string sendChatteMessage(string userID, string postText){
        string s = '';
        try{
           system.debug('postText====='+postText);
            /*ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(
                Network.getNetworkId(), 
                userID,ConnectApi.FeedElementType.FeedItem,postText);
           */
            //ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;
            ConnectApi.FeedItemInput input = ConnectAPIHElper.parseChatterPostWithMentions(postText);
            ConnectApi.FeedElementInput inputMain = (ConnectApi.FeedItemInput)input;
            inputMain.subjectId = userID;
            ConnectApi.FeedElement feedItemRep = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), inputMain, null);

            //ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), userID,postText);
        }catch(Exception e){
            s =  'Error:'+e.getMessage();       
            system.debug('====='+e.getMessage());
        }
          
        return  s ;
    } 
    
    public class SupportUserWrapper {
        public connectAPI.UserDetail supportuser{get; set;}
        public Supported_By__c supportedBy {get; set;}
        public string UserPhoto {get; set;}
        public SupportUserWrapper(Supported_By__c s, Id networkId){
            this.supportedBy = s;
            if(s.supported_By_User__c != null){
                this.UserPhoto = ConnectApi.ChatterUsers.getPhoto(networkId, s.supported_By_User__c).standardEmailPhotoUrl;
                this.supportuser = ConnectApi.ChatterUsers.getUser(networkId, s.supported_By_User__c);
                system.debug('support by user = '+s.Supported_By_User__c);
            }
                
        }   
    }
    
    public class UserWrapper {
        public connectAPI.UserDetail chatterUser{get; set;}
        public string UserPhoto {get; set;}
        public UserWrapper(Id iUser, Id networkId){
            if(iUser != null){
                this.UserPhoto = ConnectApi.ChatterUsers.getPhoto(networkId, iUser).standardEmailPhotoUrl;
                this.chatterUser = ConnectApi.ChatterUsers.getUser(networkId, iUser);
            }            
        }   
    }
    
    public PageReference RedirectToErrorPage() {
        if (mRedirectToHomepage) {
            PageReference retURL = new PageReference('/apex/COH_SIP_Error');
            retURL.getParameters().put('errorMessage', mErrorMessage);
            retURL.getParameters().put('exception', mException);
            retURL.setRedirect(true);
            return retURL;            
        }
        return null;
    }
    
}