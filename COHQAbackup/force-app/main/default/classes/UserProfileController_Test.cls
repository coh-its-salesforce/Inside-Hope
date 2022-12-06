/*
 * Test method for the UserProfileController. Updated by Tim to meet code coverage after adding error catching if a user is inActive.
 */ 
@isTest(Seealldata=true)
public class UserProfileController_Test {
    private static testmethod void myUnitTest(){
        
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@coh.org', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test1234@coh.org',
            Linkedin_Profile__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
            Duarte_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
            Communities_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
            RiverGrade_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
            managerId = UserInfo.getUserId());
        insert u;
        
        User su = new User(Alias= 'testSup', email = 'testSupportUser1234@coh.org',EmailEncodingKey='UTF-8', 
                                  LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testSupportUser1234@coh.org',
                                  Linkedin_Profile__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
                                  Duarte_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
                                  Communities_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
                                  RiverGrade_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
                                  managerId = UserInfo.getUserId());
         insert su;
        
        Profile sa = [select Id from Profile where name = 'System Administrator'];
        User sysadmin = new User(Alias = 'admin', email = 'sysadmin1234@coh.org',EmailEncodingKey='UTF-8', 
                                  LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = SA.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin1234@coh.org',
                                  Linkedin_Profile__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
                                  Duarte_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
                                  Communities_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations', 
                                  RiverGrade_Map__c = 'http://www.cityofhope.org/about-city-of-hope/locations',
                                  managerId = UserInfo.getUserId());
        insert sysadmin;
       
        
        system.assert(u.id != null);
        system.runAs(u){
        Supported_By__c sp = new Supported_By__c(
            Supported_User__c = u.id,
            Supported_By_User__c = su.id
        );
            insert sp;}
        system.runAs(sysadmin){
        apexPages.currentPage().getParameters().put('uID', u.id);
        UserProfileController upc = new UserProfileController();
        system.assertEquals(false, upc.isSameUser);
        upc.checkForFollow();
        system.assertEquals(false, upc.isFollowing);
        upc.doUpdateUser();
        upc.toggleFollow();
        system.assertEquals(true, upc.isFollowing);
        upc.toggleFollow();
        UserProfileController.sendChatteMessage(u.id, 'test');
            test.stopTest();}
    }
    
    /*
     * Test to ensure that when the profile that is being viewed is set to inactive, the user is redirected to the homepage
     */ 
    private static testMethod void InActiveUserTest() {   
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> u = new List<User>([
            SELECT id, isActive
            FROM User
            WHERE isActive = false
            LIMIT 1
        ]);
        
        apexPages.currentPage().getParameters().put('uID', u[0].id);
        UserProfileController upc = new UserProfileController();
        PageReference redirectedPage = upc.RedirectToErrorPage();
        System.assertEquals(true, redirectedPage.getRedirect());
        test.stopTest();
    }
    
    private static testmethod void myUnitTestChatterContrller(){
        collaborationgroup cg = new collaborationgroup(name ='test' + System.now(),CollaborationType='Public');
        insert cg;
         // Create Chatter Post
         FeedItem testFeed1 = new FeedItem(Body='Test Feed 1 Post', ParentId = cg.Id, Type='TextPost');
         insert testFeed1;
                
         // Create Chatter Comment
         FeedComment testFeed1Comment = new FeedComment(CommentBody='Test Feed 1 Comment', FeedItemId=testFeed1.Id, CommentType='TextComment');
         insert testFeed1Comment;
                
         // Create Chatter Post
         FeedItem testFeed2 = new FeedItem(Body='Test Feed 2 Post', ParentId = cg.Id, Type='TextPost');
         insert testFeed2;
                
         // Create Chatter Comment
         FeedComment testFeed2Comment = new FeedComment(CommentBody='#answer Test Feed 2 Comment', FeedItemId=testFeed2.Id, CommentType='TextComment');
         insert testFeed2Comment;
         // Build a simple feed item
         ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
         //testPage.items = testItemList;
         // Specify values for Action Link bindings
        Map<String, String> bindingMap = new Map<String, String>();
        bindingMap.put('deviceId', 'yourdeviceid');
        bindingMap.put('accessToken', 'youraccesstoken');
        bindingMap.put('percent', '50');
        bindingMap.put('durationMs', '10000');
        List<ConnectApi.ActionLinkTemplateBindingInput> bindingInputs = new List<ConnectApi.ActionLinkTemplateBindingInput>();
        for (String key : bindingMap.keySet()) {
            ConnectApi.ActionLinkTemplateBindingInput bindingInput = new ConnectApi.ActionLinkTemplateBindingInput();
            bindingInput.key = key;
            bindingInput.value = bindingMap.get(key);
            bindingInputs.add(bindingInput);
        }
         
        // Create an Action Link Group definition based on the template and bindings
       // Create the post and utilise the Action Link Group created above
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = 'Click to Send to the Device.';
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        feedItemInput.subjectId = 'me';
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput> { textSegmentInput };
        feedItemInput.capabilities = new ConnectApi.FeedElementCapabilitiesInput();
          test.startTest();
        // Post the feed item.
         ConnectApi.FeedElement feedElement =
         ConnectApi.ChatterFeeds.postFeedElement( Network.getNetworkId(), feedItemInput, null);
         connectAPi.ChatterFeeds.setTestGetFeedElementsFromFeed(ChatterFeedController.communityId, connectApi.FeedType.company,String.valueOf(userInfo.getUserId()) , testPage);
         testPage.elements = new List<ConnectApi.FeedElement>{feedElement};
        // Set the test data
        
         ChatterFeedController ch = new ChatterFeedController();
         ch.m_subjectid = userInfo.getUserId();
         //ch.getFeedElementPage();
         
         //connectAPi.ChatterFeeds.setTestGetFeedElementsFromFeed(ChatterFeedController.communityId, ConnectApi.FeedType.Company,String.valueOf(userInfo.getUserId()) , testPage);
        
         ch.m_subjectid = userInfo.getUserId();
         //ch.getFeedElementPage();
         ChatterFeedController.getUsers('test');
         chatterFeedController.postFeedData(cg.id, 'test');
         
         chatterFeedController.postCommentData(cg.id, testFeed1.Id, 'test');
         //chatterFeedController.likeFeedItem(UserInfo.getUserId(), feedElement.id);
        
         //chatterFeedController.unlikeFeedItem(UserInfo.getUserId(), feedElement.capabilities.chatterLikes.myLike.id);
         //chatterFeedController.getFeedData(cg.id);
         
         test.stopTest();
    }
    
}