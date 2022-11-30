/*
 * This is a test controller for CampusPlan/Expanding Hope Site apex controller COH_CampusPlanController.
 * 
 * Saidaiah Surisetti
 * City of Hope
 * Copyright (c) 2020
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
private class COH_CampusPlanControllerTest {
    
     
     private static testMethod void expandingHopeTestMethod1() {
         
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sysad', Email='sysadmin@coh.org', 
            EmailEncodingKey='UTF-8', LastName='TestAdmin', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testsysadmin@coh.org');
         
        insert u;
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
           
            test.startTest();
            List<Campus_Plan_Article__c> CPRecordList1=new List<Campus_Plan_Article__c>();
            List<Campus_Plan_Article__c> CPRecordList2=new List<Campus_Plan_Article__c>();
            List<Campus_Plan_Article__c> CPRecordList3=new List<Campus_Plan_Article__c>();
            for(integer i=0;i<70;i++){
        	   Campus_Plan_Article__c CP = new Campus_Plan_Article__c();
               CP.Title__c='Parking and Transportation Test Title '+i;
               CP.IsActiveNavigationLink__c=true;
               CP.Location__c='Duarte';
               CP.Url_Link__c='https://www.facebook.com';
               CP.Start_Date__c=system.today().addDays(-2);
               CP.Stop_Date__c=system.today().addDays(20);
        	   CP.Designative_Type__c = 'Parking and Transportation';
               CP.Article_Date__c=system.today();
        	   CP.Image__c = '<p> Test Description Parking and Transportation <img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img></p>';
        	   CP.Carousel_Image__c ='<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
               CPRecordList1.add(CP);
    	    }
            insert CPRecordList1;
            for(integer i=0;i<70;i++){
        	   Campus_Plan_Article__c CP = new Campus_Plan_Article__c();
               CP.Title__c='Rivergrade Article Test Title '+i;
               CP.IsActiveNavigationLink__c=true;
               CP.Location__c='Rivergrade';
               CP.Url_Link__c='https://www.facebook.com';
               CP.Start_Date__c=system.today().addDays(-2);
               CP.Stop_Date__c=system.today().addDays(20);
        	   CP.Designative_Type__c = 'Rivergrade Article';
               CP.Article_Date__c=system.today();
        	   CP.Image__c = '<p> Test Description Rivergrade <img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img></p>';
        	   CP.Carousel_Image__c ='<img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img>';
               CPRecordList2.add(CP);
    	    }
            insert CPRecordList2;
            for(integer i=0;i<70;i++){
        	   Campus_Plan_Article__c CP = new Campus_Plan_Article__c();
               CP.Title__c='Orange County Test Title '+i;
               CP.IsActiveNavigationLink__c=true;
               CP.Location__c='Orange County';
               CP.Url_Link__c='';
               CP.Start_Date__c=system.today().addDays(-2);
               CP.Stop_Date__c=system.today().addDays(20);
        	   CP.Designative_Type__c = 'Orange County';
               CP.Article_Date__c=system.today();
        	   CP.Image__c = '<p> Test Description Orange County <img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img></p>';
        	   CP.Carousel_Image__c ='<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
               CPRecordList3.add(CP);
    	    }
            insert CPRecordList3;
            
            List<COH_CampusPlanController.SingleArticle> salist=new List<COH_CampusPlanController.SingleArticle>();
            salist=COH_CampusPlanController.getSingleArticle('Parking and Transportation');
            Campus_Plan_Article__c carticle=COH_CampusPlanController.getArticleStory(salist[0].article.id);
            COH_CampusPlanController.getAllArticles();
            //system.assertEquals('http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif',carticle.Image_URLs__c);
            system.assertEquals('Parking and Transportation',carticle.Designative_Type__c);
        
            List<Campus_Plan_News__c> CPRecordNewsList1=new List<Campus_Plan_News__c>();
            List<Campus_Plan_News__c> CPRecordNewsList2=new List<Campus_Plan_News__c>();
            List<Campus_Plan_News__c> CPRecordNewsList3=new List<Campus_Plan_News__c>();
            List<Campus_Plan_News__c> CPRecordNewsList4=new List<Campus_Plan_News__c>();
       		List<Campus_Plan_News__c> CPRecordNewsList5=new List<Campus_Plan_News__c>();
            for(integer i=0;i<70;i++){
              Campus_Plan_News__c CPNews = new Campus_Plan_News__c();
              CPNews.Title__c='Test News '+i;
              CPNews.URL_link__c='https://www.youtube.com';
              CPNews.Start_Date__c=system.today().addDays(-2);
              CPNews.Stop_Date__c=system.today().addDays(20);
              CPNews.Page_Source__c='Home Page';
              CPNews.Carousel_Image__c = '<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
              CPNews.Detailed_Description__c = '<p> Test News and Announcements <img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img></p>';
              CPRecordNewsList1.add(CPNews);
           }
           insert CPRecordNewsList1;
           for(integer i=0;i<70;i++){
              Campus_Plan_News__c CPNews = new Campus_Plan_News__c();
              CPNews.Title__c='Test News '+i;
              CPNews.URL_link__c='';
              CPNews.Page_Source__c='Parking and Transportation';
              CPNews.Start_Date__c=system.today().addDays(-2);
              CPNews.Stop_Date__c=system.today().addDays(20);
              CPNews.Carousel_Image__c = '<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
              CPNews.Detailed_Description__c = '<p> Test News and Announcements <img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img></p>';
              CPRecordNewsList2.add(CPNews);
          }
          insert CPRecordNewsList2;
          for(integer i=0;i<70;i++){
            Campus_Plan_News__c CPNews = new Campus_Plan_News__c();
            CPNews.Title__c='Test News '+i;
            CPNews.URL_link__c='';
            CPNews.Page_Source__c='Orange County';
            CPNews.Start_Date__c=system.today().addDays(-2);
            CPNews.Stop_Date__c=system.today().addDays(20);
            CPNews.Carousel_Image__c = '<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
            CPNews.Detailed_Description__c = '<p> Test News and Announcements <img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img></p>';
            CPRecordNewsList3.add(CPNews);
          }
         insert CPRecordNewsList3;
            for(integer i=0;i<70;i++){
            Campus_Plan_News__c CPNews = new Campus_Plan_News__c();
            CPNews.Title__c='Test News '+i;
            CPNews.URL_link__c='';
            CPNews.Page_Source__c='Duarte';
            CPNews.Start_Date__c=system.today().addDays(-2);
            CPNews.Stop_Date__c=system.today().addDays(20);
            CPNews.Carousel_Image__c = '<img alt="User-added image" src="http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif"></img>';
            CPNews.Detailed_Description__c = '<p> Test News and Announcements <img alt="User-added image" src="https://www.w3schools.com/images/compatible_firefox.gif"></img></p>';
            CPRecordNewsList4.add(CPNews);
          }
         insert CPRecordNewsList4;
            
        COH_CampusPlanController.NewsWrap newswrap=new COH_CampusPlanController.NewsWrap();
        newswrap=COH_CampusPlanController.getAllNews();
        newswrap=COH_CampusPlanController.getAllNewsMenu();
        Campus_Plan_News__c cNews=COH_CampusPlanController.getNewsStory(newswrap.homepagenews[0].id);
        system.assertEquals('http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif',cNews.PhotoURL__c);
        //system.assertEquals('Parking and Transportation',cNews.Designative_Type__c);
        
            List<Campus_Plan_Alert__c> cAlerts=new List<Campus_Plan_Alert__c>();
            for(Integer i=0;i<200;i++){
                Campus_Plan_Alert__c alert=new Campus_Plan_Alert__c();
                alert.IsActive__c=true;
                alert.Title__c=i+' Slots are closing in Lot F, closed for construction vehicles';
                alert.Start_Date__c=system.today().addDays(-2);
                alert.Stop_Date__c=system.today().addDays(20);
                cAlerts.add(alert);
                
            }
            insert cAlerts;
            List<Campus_Plan_Alert__c> caRecords=COH_CampusPlanController.getCampusPlanAlertRecords();
            
            List<Campus_Plan_Home_Page_Info__c> HomeRecs=new List<Campus_Plan_Home_Page_Info__c>();
            for(Integer i=0;i<200;i++){
                Campus_Plan_Home_Page_Info__c HomeInfo=new Campus_Plan_Home_Page_Info__c();
                HomeInfo.Home_Page_Text__c='Test';
                HomeRecs.add(HomeInfo);
            }
            insert HomeRecs;
            List<Campus_Plan_Home_Page_Info__c> HomeRecords=COH_CampusPlanController.getAllInfo();
            
           List<Campus_Plan_Parking_Info__c> cpParkingRecs=new List<Campus_Plan_Parking_Info__c>();
            for(Integer i=0;i<200;i++){
                Campus_Plan_Parking_Info__c cppRec=new Campus_Plan_Parking_Info__c();
                cppRec.Location__c='Duarte';
                cppRec.Notice_Date__c=Date.newInstance(2020, 3, 6);
                cppRec.Start_Date__c=system.today().addDays(-2);
                cppRec.Stop_Date__c=system.today().addDays(20);
                cppRec.Information__c='Test Info '+i;
                cpParkingRecs.add(cppRec);
                }
                insert cpParkingRecs;
            List<COH_CampusPlanController.ParkingWrap> parkingWrap=new List<COH_CampusPlanController.ParkingWrap>();
            parkingWrap=COH_CampusPlanController.getParkingInfo();
            system.assertEquals('March. 6', parkingWrap[0].NoticeDate);
            
            
        Test.stopTest();
       }     
    }
    private static testMethod void expandingHopeTestMethod2() {
        
          // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sysad', Email='sysadmin@coh.org', 
            EmailEncodingKey='UTF-8', LastName='TestAdmin', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testsysadmin@coh.org');
         
        insert u;
        System.runAs(u) {
            Test.startTest();
            
                Campus_Plan_Comment__c cpsqRec1=new Campus_Plan_Comment__c();
                cpsqRec1.Page_Source__c='Parking & Transportation';
                cpsqRec1.Email_Recipient_1__c='test1@gmail.com';
                cpsqRec1.Email_Recipient_2__c='test2@gmail.com';
                cpsqRec1.Email_Recipient_3__c='';
                cpsqRec1.Email_Recipient_4__c='';
                insert cpsqRec1;
            
                Campus_Plan_Comment__c cpsqRec2=new Campus_Plan_Comment__c();
                cpsqRec2.Page_Source__c='Duarte Building';
                cpsqRec2.Email_Recipient_1__c='test1@gmail.com';
                cpsqRec2.Email_Recipient_2__c='test2@gmail.com';
                cpsqRec2.Email_Recipient_3__c='';
                cpsqRec2.Email_Recipient_4__c='';
                insert cpsqRec2;
            
                Campus_Plan_Comment__c cpsqRec3=new Campus_Plan_Comment__c();
                cpsqRec3.Page_Source__c='Rivergrade';
                cpsqRec3.Email_Recipient_1__c='test1@gmail.com';
                cpsqRec3.Email_Recipient_2__c='test2@gmail.com';
                cpsqRec3.Email_Recipient_3__c='';
                cpsqRec3.Email_Recipient_4__c='';
                insert cpsqRec3;
            
                Campus_Plan_Comment__c cpsqRec4=new Campus_Plan_Comment__c();
                cpsqRec4.Page_Source__c='Orange County';
                cpsqRec4.Email_Recipient_1__c='test1@gmail.com';
                cpsqRec4.Email_Recipient_2__c='test2@gmail.com';
                cpsqRec4.Email_Recipient_3__c='test3@gmail.com';
                cpsqRec4.Email_Recipient_4__c='test4@gmail.com';
                insert cpsqRec4;
                
            
            
            for(Integer i=0;i<50;i++){
                
                COH_CampusPlanController.submitAComment('Test Subject '+i,'test'+i+'@gmail.com', 'Test comment '+i,'Parking and Transportation');
               // COH_CampusPlanController.submitAComment('Test Subject '+i,'test'+i+'@gmail.com', 'Test comment '+i,'Duarte Building');
            }
            List<Campus_Plan_FAQ__c> FAQlist1=new List<Campus_Plan_FAQ__c>();
            List<Campus_Plan_FAQ__c> FAQlist2=new List<Campus_Plan_FAQ__c>();
            List<Campus_Plan_FAQ__c> FAQlist3=new List<Campus_Plan_FAQ__c>();
            List<Campus_Plan_FAQ__c> FAQlist4=new List<Campus_Plan_FAQ__c>();
            List<Campus_Plan_FAQ__c> FAQlist5=new List<Campus_Plan_FAQ__c>();
            for(Integer i=0;i<50;i++){
                Campus_Plan_FAQ__c cpFAQ=new Campus_Plan_FAQ__c();
                cpFAQ.Visible__c=true;
                cpFAQ.Question__c='Test Question'+i;
                cpFAQ.Answer__c='<p> <span>TEST ANSWER'+i+' </span></p>';
                cpFAQ.FAQ_Group__c='Duarte Campus';
                cpFAQ.FAQ_Group1__c='Overview';
                FAQlist1.add(cpFAQ);
            }
            for(Integer i=50;i<100;i++){
                Campus_Plan_FAQ__c cpFAQ=new Campus_Plan_FAQ__c();
                cpFAQ.Visible__c=true;
                cpFAQ.Question__c='Test Question'+i;
                cpFAQ.Answer__c='<p> <span>TEST ANSWER'+i+' </span></p>';
                cpFAQ.FAQ_Group__c='Parking and Transportation';
                cpFAQ.FAQ_Group1__c='Overview';
                FAQlist2.add(cpFAQ);
            }
            for(Integer i=100;i<150;i++){
                Campus_Plan_FAQ__c cpFAQ=new Campus_Plan_FAQ__c();
                cpFAQ.Visible__c=true;
                cpFAQ.Question__c='Test Question'+i;
                cpFAQ.Answer__c='<p> <span>TEST ANSWER'+i+' </span></p>';
                cpFAQ.FAQ_Group__c='Rivergrade';
                cpFAQ.FAQ_Group1__c='Overview';
                FAQlist3.add(cpFAQ);
            }
            for(Integer i=150;i<200;i++){
                Campus_Plan_FAQ__c cpFAQ=new Campus_Plan_FAQ__c();
                cpFAQ.Visible__c=true;
                cpFAQ.Question__c='Test Question'+i;
                cpFAQ.Answer__c='<p> <span>TEST ANSWER'+i+' </span></p>';
                cpFAQ.FAQ_Group__c='Orange County';
                cpFAQ.FAQ_Group1__c='Overview';
                FAQlist4.add(cpFAQ);
            }
            
            insert FAQlist1;
            insert FAQlist2;
            insert FAQlist3;
            insert FAQlist4;
           
            COH_CampusPlanController.ParkingFAQs pf=new COH_CampusPlanController.ParkingFAQs();
            pf=COH_CampusPlanController.getApprovedFAQs();
            
            List<Campus_Plan_Timeline__c> timlinelist1=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist2=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist3=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist4=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist5=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist6=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist7=new List<Campus_Plan_Timeline__c>();
            List<Campus_Plan_Timeline__c> timlinelist8=new List<Campus_Plan_Timeline__c>();
            for(integer i=0;i<25;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2020, 4, 21);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2020';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist1.add(t1);

            }
            insert timlinelist1;
            for(integer i=25;i<50;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2021, 11, 13);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2021';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist2.add(t1);

            }
            insert timlinelist2;
            for(integer i=50;i<75;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2022, 10, 19);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2022';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist3.add(t1);

            }
            insert timlinelist3;
            for(integer i=75;i<100;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2023, 9, 9);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2023';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist4.add(t1);

            }
            insert timlinelist4;
            for(integer i=100;i<125;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2024, 6, 23);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2024';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist5.add(t1);

            }
            insert timlinelist5;
            for(integer i=125;i<150;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2025, 3, 9);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2025';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist6.add(t1);

            }
            insert timlinelist6;
            for(integer i=150;i<175;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2026, 4, 9);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2026';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist7.add(t1);

            }
            insert timlinelist7;
            for(integer i=175;i<200;i++){
                Campus_Plan_Timeline__c t1=new Campus_Plan_Timeline__c();
                t1.Title__c='Test Title for Home page'+i;
                t1.Date_of_Event__c=Date.newInstance(2027, 1, 9);
                t1.Description__c='<p> This is test data content </p>';
                t1.Year__c='2027';
                t1.Landing_Page__c='Home';
                t1.Date_Text__c = 'June2020';
                t1.Timeline_Image__c='http://www.diseno-art.com/images_2/for_gt_nav_ffffff-short.gif';
                timlinelist8.add(t1);

            }
            insert timlinelist8;
            COH_CampusPlanController.timelinewrap tw=new COH_CampusPlanController.timelinewrap();
            tw=COH_CampusPlanController.getTimelineInfo('Home');
            system.assertEquals(tw.year2020[0].Date_of_Event__c,Date.parse('4/21/2020'));
            
            Campus_Plan_Timeline__c c=COH_CampusPlanController.getTimelinePage(tw.year2020[0].Id);
            system.assertEquals(c.Year__c,'2020');
            system.assertEquals(c.Description__c,'<p> This is test data content </p>');
           /* String mdtRecordLabel='Campus plan Header Floating';
            COH_CampusPlanController.getCampusPlanMetadata(mdtRecordLabel); 
			*/
            Test.stopTest();
        }
        
    }
}