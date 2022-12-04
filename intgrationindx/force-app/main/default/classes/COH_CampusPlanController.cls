/*
 * This controller is for CampusPlan/Expanding Hope Site.
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
public class COH_CampusPlanController {
    
    /*
     * Retrieves the News records from the Campus Plan News object and updates the campus plan Nwes records to extract
     * image url from richtext field(Carousel Image) for news carousel images & Description from News content field.
     * 
     * @return  :  Returns the six News records.
     * 
     */
     
  /*  @AuraEnabled    
    public static TimelineMenuWrap getOCTimelineMenu(){//20200616 FSalinas
        TimelineMenuWrap tlmWrp=new TimelineMenuWrap();
        List<Campus_Plan_Timeline__c> orangecountynews=new List<Campus_Plan_Timeline__c>(); 
        try 
        {
             List<Campus_Plan_Timeline__c> TimeRecs=[Select c.Id, c.Year__c, c.Title__c, c.Name, c.Landing_Page__c, c.Description__c, c.Date_of_Event__c, c.Date_Text__c, c.Timeline_Image__c From Campus_Plan_Timeline__c c Where c.Landing_Page__c = 'Orange County'];
             if(TimeRecs.size()>0){
                for(Campus_Plan_Timeline__c cn:TimeRecs){
                      orangecountynews.add(cn);
                 }
               }     
        } catch (Exception e) {
               System.debug('An Exception has occured while processing getOCTimelineMenu records: ' + e.getMessage());
        }
                
       	tlmWrp.orangecountytimeline = orangecountynews;
        return tlmWrp;
    } */
    
    @AuraEnabled    
    public static NewsWrap getAllNews(){
        try 
        {
             List<Campus_Plan_News__c> CPNRecs=[select PhotoURL__c,Full_Description__c,Carousel_Image__c,Description__c,Detailed_Description__c from Campus_Plan_News__c];
             list<Campus_Plan_News__c> updateNewsList=new list<Campus_Plan_News__c>();
             if(CPNRecs.size()>0){
                for(Campus_Plan_News__c cn:CPNRecs){
                      List<string> richTextContent=cn.Carousel_Image__c.split('<img');
                      list<string> rawurls=new list<string>();
                      for(String s:richTextContent)
                      {
                         if(s.substringBetween( ' src="', '"' )!=null)
                         {
                           rawurls.add(s.substringBetween( ' src="', '"' ).replace('amp;', ''));
                         }
                      }
                      String allurls=String.valueOf(rawurls);
                      cn.PhotoURL__c=(allurls.replace('(','')).replace(')','');
                      /*String description = cn.Detailed_Description__c.replaceAll('\\<.*?\\>', '');
                     //cn.Full_Description__c=description;
            
                      Integer maxSize = 255;
                      if(description.length() > maxSize ){
                        description = description.substring(0, maxSize);
                       }
                       cn.Description__c=description;*/
                       updateNewsList.add(cn);
                 }
               }     
               update updateNewsList;
        
             
           
        } 
        catch(Exception e)
        {
               System.debug('An Exception has occured while processing records: ' + e.getMessage());
        }
         List<Campus_Plan_News__c> homepagenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> ptnews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> Dunews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> rivergradenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> orangecountynews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> medicalofficenews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> ricnews=new List<Campus_Plan_News__c>();
        
        List<Campus_Plan_News__c> lstNews = New List<Campus_Plan_News__c>();
        lstNews = [Select id, title__c,Page_Source__c, Display_on_Menu__c, Is_Redirect__c, Location__c, preview__c,Sub_Title__c,News_Content_Next_to_Image__c,Full_Description__c,URL_link__c,Carousel_Image__c,description__C, Image_URL__c,PhotoURL__c, Image_Attachment_Id__c, CreatedDate,Detailed_Description__c FROM Campus_Plan_News__c where Start_Date__c <= TODAY AND Stop_Date__c >=TODAY  ORDER BY News_Menu_Sequence_Formula__c];//FSalinas 20200603 added sorting field News_Menu_Sequence_Formula__c
        if(lstNews.size()>0){
            NewsWrap nw=new NewsWrap();
            // List<Campus_Plan_Timeline__c> cptimelines =[select id,URL__c,Title__c,Date_of_Event__c,Description__c,Timeline_Image__c,Year__c,Landing_Page__c,Date_Text__c,Timeline_Seq_Num__c from Campus_Plan_Timeline__c where Landing_Page__c= 'Orange County' ORDER BY Date_of_Event__c ASC limit 100];
            for(Campus_Plan_News__c c:lstNews){
                
                if(c.Page_Source__c=='Home Page'){
                   homepagenews.add(c); 
                }
                else if(c.Page_Source__c=='Parking and Transportation'){
                    ptnews.add(c);
                }
                else if(c.Page_Source__c=='Duarte'){
                    Dunews.add(c);
                }
                else if(c.Page_Source__c=='Rivergrade'){
                    rivergradenews.add(c);
                }
                else if(c.Page_Source__c=='Orange County'){
                    orangecountynews.add(c);
                }
                else if(c.Page_Source__c=='Medical Office Building'){
                    medicalofficenews.add(c);
                }
                else if(c.Page_Source__c=='Radiology Imaging Center'){
                    ricnews.add(c);
                }
                else{
                    
                }
                nw.homepagenews=homepagenews;
                nw.ptnews=ptnews;
                nw.Dunews=Dunews;
                nw.rivergradenews=rivergradenews;
                nw.orangecountynews=orangecountynews;
                nw.medicalofficenews=medicalofficenews;
                nw.ricnews=ricnews;
                //nw.cpTimelines=[select id,URL__c,Title__c,Date_of_Event__c,Description__c,Timeline_Image__c,Year__c,Landing_Page__c,Date_Text__c,Timeline_Seq_Num__c from Campus_Plan_Timeline__c where Landing_Page__c= 'Orange County' ORDER BY Date_of_Event__c ASC limit 100];
            	//nw.cpTimelines=cptimelines;
            }
            return nw;
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static list<Campus_Plan_Article__c> getAllArticles(){
        list<Campus_Plan_Article__c> articlelist = [select id, Menu_Name__c, Article_Order__c, Hide_Landing_Page__c, Designative_Type__c from Campus_Plan_Article__c Where Article_Order__c != null Order By Article_Order__c ASC];
        //system.debug('articlelist TestArticle '+articlelist);
           return articlelist; 
    }
    
    @AuraEnabled
    public static list<Campus_Plan_Home_Page_Info__c> getAllInfo(){
        list<Campus_Plan_Home_Page_Info__c> pageList = [select id, Name, Home_Page_Text__c from Campus_Plan_Home_Page_Info__c];
        return pageList;
    }
    
    @AuraEnabled    
    public static NewsWrap getAllNewsMenu(){
        try 
        {
             List<Campus_Plan_News__c> CPNRecs=[select PhotoURL__c,Full_Description__c,Carousel_Image__c,Description__c,Detailed_Description__c from Campus_Plan_News__c];
             list<Campus_Plan_News__c> updateNewsList=new list<Campus_Plan_News__c>();
             if(CPNRecs.size()>0){
                for(Campus_Plan_News__c cn:CPNRecs){
                      List<string> richTextContent=cn.Carousel_Image__c.split('<img');
                      list<string> rawurls=new list<string>();
                      for(String s:richTextContent)
                      {
                         if(s.substringBetween( ' src="', '"' )!=null)
                         {
                           rawurls.add(s.substringBetween( ' src="', '"' ).replace('amp;', ''));
                         }
                      }
                      String allurls=String.valueOf(rawurls);
                      cn.PhotoURL__c=(allurls.replace('(','')).replace(')','');
                      /*String description = cn.Detailed_Description__c.replaceAll('\\<.*?\\>', '');
                     //cn.Full_Description__c=description;
            
                      Integer maxSize = 255;
                      if(description.length() > maxSize ){
                        description = description.substring(0, maxSize);
                       }
                       cn.Description__c=description;*/
                       updateNewsList.add(cn);
                 }
               }     
               update updateNewsList;
        
             
           
        } 
        catch(Exception e)
        {
               System.debug('An Exception has occured while processing records: ' + e.getMessage());
        }
         List<Campus_Plan_News__c> homepagenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> ptnews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> Dunews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> rivergradenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> orangecountynews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> medicalofficenews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> ricnews=new List<Campus_Plan_News__c>();
        
        List<Campus_Plan_News__c> lstNews = New List<Campus_Plan_News__c>();
        lstNews = [Select id, title__c,Page_Source__c, Display_on_Menu__c, Is_Redirect__c, Location__c, preview__c,Sub_Title__c,News_Content_Next_to_Image__c,Full_Description__c,URL_link__c,Carousel_Image__c,description__C, Image_URL__c,PhotoURL__c, Image_Attachment_Id__c, CreatedDate,Detailed_Description__c FROM Campus_Plan_News__c where Display_on_Menu__c = True AND Start_Date__c <= TODAY AND Stop_Date__c >=TODAY  ORDER BY News_Menu_Sequence_Formula__c];//FSalinas 20200603 added sorting field News_Menu_Sequence_Formula__c
        if(lstNews.size()>0){
            NewsWrap nw=new NewsWrap();
            List<Campus_Plan_Timeline__c> cptimelines =[select id,URL__c,Title__c,Date_of_Event__c,Description__c,Timeline_Image__c,Year__c,Landing_Page__c,Date_Text__c,Timeline_Seq_Num__c from Campus_Plan_Timeline__c where Landing_Page__c= 'Orange County' ORDER BY Date_of_Event__c ASC];
            for(Campus_Plan_News__c c:lstNews){
                
                if(c.Page_Source__c=='Home Page'){
                   homepagenews.add(c); 
                }
                else if(c.Page_Source__c=='Parking and Transportation'){
                    ptnews.add(c);
                }
                else if(c.Page_Source__c=='Duarte'){
                    Dunews.add(c);
                }
                else if(c.Page_Source__c=='Rivergrade'){
                    rivergradenews.add(c);
                }
                else if(c.Page_Source__c=='Orange County'){
                    orangecountynews.add(c);
                }
                else if(c.Page_Source__c=='Medical Office Building'){
                    medicalofficenews.add(c);
                }
                else if(c.Page_Source__c=='Radiology Imaging Center'){
                    ricnews.add(c);
                }
                else{
                    
                }
                nw.homepagenews=homepagenews;
                nw.ptnews=ptnews;
                nw.Dunews=Dunews;
                nw.rivergradenews=rivergradenews;
                nw.orangecountynews=orangecountynews;
                nw.medicalofficenews=medicalofficenews;
                nw.ricnews=ricnews;
            	nw.cpTimelines=cptimelines;
            }
            return nw;
        }
        else{
            return null;
        }
    }
    
    
    
     /*
     * Retrieves the News records from the Campus Plan News object and updates the campus plan Nwes records to extract
     * image url from richtext field(Carousel Image) for news carousel images & Description from News content field.
     * 
     * @return  :  Returns the six News records.
     * Vesion	:  1.1
     * 
     */
   /* @AuraEnabled    
    public static NewsWrap getAllNewsLatest(){
        try 
        {
             List<Campus_Plan_News__c> CPNRecs=[select PhotoURL__c,Full_Description__c,Carousel_Image__c,Description__c,Detailed_Description__c from Campus_Plan_News__c];
             list<Campus_Plan_News__c> updateNewsList=new list<Campus_Plan_News__c>();
             if(CPNRecs.size()>0){
                for(Campus_Plan_News__c cn : CPNRecs){
                      List<string> richTextContent=cn.Carousel_Image__c.split('<img');
                      list<string> rawurls=new list<string>();
                      for(String s:richTextContent)
                      {
                         if(s.substringBetween( ' src="', '"' )!=null)
                         {
                           rawurls.add(s.substringBetween( ' src="', '"' ).replace('amp;', ''));
                         }
                      }
                      String allurls=String.valueOf(rawurls);
                      cn.PhotoURL__c=(allurls.replace('(','')).replace(')','');
                      String description = cn.Detailed_Description__c.replaceAll('\\<.*?\\>', '');
                     //cn.Full_Description__c=description;
            
                      //Integer maxSize = 255;
                      //if(description.length() > maxSize ){
                      //  description = description.substring(0, maxSize);
                       }
                      // cn.Description__c=description;
                       updateNewsList.add(cn);
                 }
               }     
               update updateNewsList;
        } 
        catch(Exception e) 
        {
               System.debug('An Exception has occured while processing records: ' + e.getMessage());
        }
         List<Campus_Plan_News__c> homepagenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> ptnews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> Dunews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> rivergradenews=new List<Campus_Plan_News__c>();
         List<Campus_Plan_News__c> orangecountynews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> medicalofficenews=new List<Campus_Plan_News__c>(); 
         List<Campus_Plan_News__c> ricnews=new List<Campus_Plan_News__c>();
         Map<Id, List<Campus_Plan_News__c>> DuartemMap = new Map<Id, List<Campus_Plan_News__c>>();
        
        List<Campus_Plan_News__c> lstNews = New List<Campus_Plan_News__c>();
        //lstNews = [Select id, title__c,Page_Source__c, 	Is_Redirect__c, Location__c, preview__c,Sub_Title__c,News_Content_Next_to_Image__c,Full_Description__c,URL_link__c,Carousel_Image__c,description__C, Image_URL__c,PhotoURL__c, Image_Attachment_Id__c, CreatedDate,Detailed_Description__c FROM Campus_Plan_News__c where Start_Date__c <= TODAY AND Stop_Date__c >=TODAY];// Order By LastModifiedDate DESC limit 6 ];
        
        //List<Campus_Plan_News__c> CampusPlanNewsList;
        lstNews = [SELECT Id, Related_To__c, Name, title__c, Page_Source__c, Is_Redirect__c, Location__c, preview__c, Sub_Title__c, News_Content_Next_to_Image__c, Full_Description__c, URL_link__c, Carousel_Image__c, description__C, Image_URL__c, PhotoURL__c, Image_Attachment_Id__c, CreatedDate, 
                                                        Detailed_Description__c, (Select Id, Related_To__c, Name, title__c, Page_Source__c, Is_Redirect__c, Location__c, preview__c, Sub_Title__c, News_Content_Next_to_Image__c, Full_Description__c, URL_link__c, Carousel_Image__c, description__C, 
                                                        Image_URL__c, PhotoURL__c, Image_Attachment_Id__c, CreatedDate, Detailed_Description__c FROM Campus_Plan_News__r Where Related_To__c != null) 
                                                        FROM Campus_Plan_News__c where Related_To__c = null AND Start_Date__c <= TODAY AND Stop_Date__c >=TODAY ];
        
        for(Campus_Plan_News__c CPN : lstNews){
             if(CPN.Page_Source__c == 'Duarte'){  
                 DuartemMap.put(CPN.id, CPN.Campus_Plan_News__r);
                 Dunews.add(CPN);
                } 
        }
        
        if(lstNews.size()>0){
            NewsWrap nw=new NewsWrap();
            for(Campus_Plan_News__c c:lstNews){
                
                if(c.Page_Source__c=='Home Page'){
                   homepagenews.add(c); 
                }
                else if(c.Page_Source__c=='Parking and Transportation'){
                    ptnews.add(c);
                }
                else if(c.Page_Source__c=='Duarte'){
                  //  Dunews.add(c);
                }
                else if(c.Page_Source__c=='Rivergrade'){
                    rivergradenews.add(c);
                }
                else if(c.Page_Source__c=='Orange County'){
                    orangecountynews.add(c);
                }
                else if(c.Page_Source__c=='Medical Office Building'){
                    medicalofficenews.add(c);
                }
                else if(c.Page_Source__c=='Radiology Imaging Center'){
                    ricnews.add(c);
                }
                else{
                    
                }
                nw.homepagenews=homepagenews;
                nw.ptnews=ptnews;
                nw.Dunews=Dunews; 
                nw.DuartemMap = DuartemMap; // Parents with multiple childs.
                nw.rivergradenews=rivergradenews;
                nw.orangecountynews=orangecountynews;
                nw.medicalofficenews=medicalofficenews;
                nw.ricnews=ricnews;
                
              //  system.debug('rivergradenews >>>'+rivergradenews);
            }
            return nw;
        }
        else{
            return null;
        }
    }
    */
    
    
    
    /*
     * Retrieves the Alert records from the Campus Plan Alerts object where the alert in between start & end date.
     * 
     * @return  :  Returns all the Alert records.
     * 
     */
    @AuraEnabled
     public static List<Campus_Plan_Alert__c> getCampusPlanAlertRecords(){
     List<Campus_Plan_Alert__c> CPARecords= [select id, Title__c from Campus_Plan_Alert__c where IsActive__c =true AND Start_Date__c <= TODAY AND Stop_Date__c >=TODAY];
         if(CPARecords.size()>0){
              return CPARecords;
         }
         else{
             return null;
         }      
    }
    
     /*
     * Retrieves the Alert records from the Campus Plan Alerts object where the alert in between start & end date.
     * 
     * @return  :  Returns all the Alert records.
     * 
     */
   /* @AuraEnabled(cacheable = true)
     public static CampusPlanHorizontalFloating__mdt getCampusPlanMetadata(string mdtRecordLabel){
    
         CampusPlanHorizontalFloating__mdt cMDTRecord = [SELECT Id, DeveloperName, Label, QualifiedApiName, Duration__c, Gap__c, delayBeforeStart__c, direction__c, duplicated__c 
                                                              		FROM CampusPlanHorizontalFloating__mdt WHERE Label =: mdtRecordLabel LIMIT 1];
         if(cMDTRecord != null){
              return cMDTRecord;
         }
         else{
             return null;
         }      
    } */
    
    
    /*
     * Retrieves a list of SingleArticle wrapper. When clicks on heroarea image it will fecth the article records. 
     * 
     * @return  :  Returns the related article records if the heroarea title and article title matches.
     * 
     */
    @AuraEnabled
    public static List<SingleArticle> getSingleArticle(String title){
       
        List<SingleArticle> salist=new List<SingleArticle>();        
        List<Campus_Plan_Article__c> arecords=[select id, Article_Date__c,Carousel_Image__c, Article_Sequence__c, Article_Title__c,Name,
              						      Content__c,Title__c,Location__c,ImageURL__c, Create_Date__c,Description__c,Designative_Type__c, Article_Content_Next_to_Image__c, Image__c, Status__c, Url_Link__c, Image_URLs__c,Landing_Page_Title__c,Menu_Name__c 
                                          from Campus_Plan_Article__c where Designative_Type__c=:title ORDER BY LastModifiedDate DESC limit 5 ];
        Boolean isFaqExists = false;
        if(title == 'Duarte Building'){
          List<Campus_Plan_FAQ__c> FAQlist=[select FAQ_Group__c,FAQ_Group1__c,Question__c,Answer__c, Answer_Sequence_No__c from Campus_Plan_FAQ__c where Visible__c=true AND FAQ_Group__c = 'Duarte Campus'];  
            if(!FAQlist.IsEmpty()){
                isFaqExists= true;
            }
        }
        
                   
        if(arecords.size()>0){
           
         for(Campus_Plan_Article__c c:arecords){
             
             SingleArticle sa=new SingleArticle();
             if(c.Designative_Type__c == 'Duarte Building'){
                 sa.isFaqExists = isFaqExists;
             }
              List<string> richTextContent=c.Carousel_Image__c.split('<img');
              list<string> rawurls=new list<string>();
              for(String s:richTextContent)
              {
                     if(s.substringBetween( ' src="', '"' )!=null && s.substringBetween( ' src="', '"' )!='')
                     {
                          rawurls.add(s.substringBetween( ' src="', '"' ));
                     }
                     else{
                          
                         
                     }
                    
              }
            
             String allurls=String.valueOf(rawurls);
             String str=(allurls.replace('(','')).replace(')','');
             String imageURL=str.replace('amp;', '');
             sa.articleImage=imageURL;
             sa.article=c;
             sa.articleIndexZeroRec=arecords[0];
             salist.add(sa);
                 
         }  
            
         }
        
        return salist;
    }
     /*
     * Retrieves a single article story, when clicks on article carousel image if the article does not have a external link. 
     * 
     * @return  :  Returns a single article story.
     * 
     */
    @AuraEnabled
    public static Campus_Plan_Article__c getArticleStory(String recId){
       
              Campus_Plan_Article__c arecord=[select id, Article_Date__c, Article_Sequence__c, Article_Title__c,Name,
              						      Content__c,Title__c,Location__c,ImageURL__c,Designative_Type__c, Create_Date__c,Description__c, Image__c, Status__c, Url_Link__c, Image_URLs__c,Menu_Name__c
                                          from Campus_Plan_Article__c where id=:recId];
              if(arecord!=null){
                  return arecord;
              }
              else{
                   return null;
              }
        
        
    }
    /*
     * Retrieves a single news story, when clicks on news & announcements carousel anchor link (Read more>>). 
     * 
     * @return  :  Returns a single news story.
     * 
     */
    @AuraEnabled    
    public static Campus_Plan_News__c getNewsStory(String recId){
        Campus_Plan_News__c cpnRecord= [Select id, Title__c,Sub_Title__c, Full_Description__c,Carousel_Image__c,Detailed_Description__c,URL_link__c, News_Content_Next_to_Image__c,Location__c, description__C,PhotoURL__c FROM Campus_Plan_News__c where id=:recId];
        if(cpnRecord!=null){
            
            return cpnRecord;
        }
        else{
            
            return null;
        }
    }
     /*
     * Retrieves a list of parking lots records. 
     * 
     * @return  :  Returns a list of parking lots.
     * 
     */
   
    @AuraEnabled
    public static List<ParkingWrap> getParkingInfo(){
        
        List<ParkingWrap> pwlist=new List<ParkingWrap>();
        List<Campus_Plan_Parking_Info__c> piRecs=[select Name, Information__c, Location__c,Notice_Date__c from Campus_Plan_Parking_Info__c where Active_Flag__c=true AND Start_Date__c <= TODAY AND Stop_Date__c >=TODAY limit 5 ];
        if(piRecs.size()>0){
          for(Campus_Plan_Parking_Info__c pi:piRecs){
            ParkingWrap pw=new ParkingWrap();
            Integer day = pi.Notice_Date__c.day();
            Integer Month = pi.Notice_Date__c.month();
            Integer yr = pi.Notice_Date__c.year();
            DateTime DT = DateTime.newInstance(yr, Month, day);
            String MonthName=DT.format('MMMMM');
            String NoticeDate=MonthName+'. '+String.valueOf(day);
            pw.Information=pi.Information__c;
            pw.NoticeDate=NoticeDate;
            pwlist.add(pw);
          }
        }     
        return pwlist;
    }
     /*
     * Create a case record if user submits a comment in the submit a question/comment box.
     * 
     * @Param 1  :  Subject for the comment.
     * @Param 2  :  Submitter's email.
     * @Param 3  :  Comment/concern which user does have.
     * @Param 4  :  Designative Type.
     * 
     */
    @AuraEnabled
    @future
    public static void submitAComment(string subject,string email,string comment,string PageSource ){
        try 
        {
            ID recordTypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Submit a Question').getRecordTypeId();
            Case c=new Case();
            c.Subject=subject;
            c.Subject__c=subject;
            c.SuppliedEmail=email;
            c.Question_Title__c=comment;
            c.Status='New';
            c.Origin='Online Request';
            c.Priority='Routine';
            c.Page_Source__c=PageSource;
            if(PageSource=='Parking and Transportation'){
               Campus_Plan_Comment__c sqRecord=[select Email_Recipient_1__c,Email_Recipient_2__c,Email_Recipient_3__c,Email_Recipient_4__c from Campus_Plan_Comment__c where Page_Source__c='Parking & Transportation' limit 1];
               c.Email_Recipient_1__c=sqRecord.Email_Recipient_1__c;
               c.Email_Recipient_2__c=sqRecord.Email_Recipient_2__c;
               c.Email_Recipient_3__c=sqRecord.Email_Recipient_3__c;
               c.Email_Recipient_4__c=sqRecord.Email_Recipient_4__c;
               c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'Parking_Transportation'].Id;

            }
            else if(PageSource=='Duarte Building'){
               Campus_Plan_Comment__c sqRecord1=[select Email_Recipient_1__c,Email_Recipient_2__c,Email_Recipient_3__c,Email_Recipient_4__c from Campus_Plan_Comment__c where Page_Source__c='Duarte Building' limit 1];
               c.Email_Recipient_1__c=sqRecord1.Email_Recipient_1__c;
               c.Email_Recipient_2__c=sqRecord1.Email_Recipient_2__c;
               c.Email_Recipient_3__c=sqRecord1.Email_Recipient_3__c;
               c.Email_Recipient_4__c=sqRecord1.Email_Recipient_4__c;
               c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'Duarte_Building'].Id;

            }
            else if(PageSource=='Rivergrade Article'){
               Campus_Plan_Comment__c sqRecord2=[select Email_Recipient_1__c,Email_Recipient_2__c,Email_Recipient_3__c,Email_Recipient_4__c from Campus_Plan_Comment__c where Page_Source__c='Rivergrade' limit 1];
               c.Email_Recipient_1__c=sqRecord2.Email_Recipient_1__c;
               c.Email_Recipient_2__c=sqRecord2.Email_Recipient_2__c;
               c.Email_Recipient_3__c=sqRecord2.Email_Recipient_3__c;
               c.Email_Recipient_4__c=sqRecord2.Email_Recipient_4__c;
               c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'River_Grade'].Id;

            }
            else if(PageSource=='Orange County'){
               Campus_Plan_Comment__c sqRecord3=[select Email_Recipient_1__c,Email_Recipient_2__c,Email_Recipient_3__c,Email_Recipient_4__c from Campus_Plan_Comment__c where Page_Source__c='Orange County' limit 1];
               c.Email_Recipient_1__c=sqRecord3.Email_Recipient_1__c;
               c.Email_Recipient_2__c=sqRecord3.Email_Recipient_2__c;
               c.Email_Recipient_3__c=sqRecord3.Email_Recipient_3__c;
               c.Email_Recipient_4__c=sqRecord3.Email_Recipient_4__c;
               c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'Orange_County'].Id;

            }
            /*else if(PageSource=='Duarte Buildings'){
                c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'Duarte_Building'].Id;
            }
            else if(PageSource=='River Grade Buildings'){
                c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'River_Grade'].Id;
            }
            else if(PageSource=='Orange County roads'){
                c.OwnerId =[select Id from Group where  Type = 'Queue' AND DeveloperNAME  = 'Orange_County'].Id;
            }*/
            else{
            
            }
        
            c.RecordTypeId=recordTypeID;
            insert c;
        } 
        catch(Exception e) 
        {
               System.debug('An Exception has occured while inserting the case record: ' + e.getMessage());
        }
       
     }
     /*
     * Retrieves a list of comment records only if the reviewer approved.
     * 
     * @return  :  Returns a list of approved comments.
     * 
     */
    /*@AuraEnabled
    public static List<Campus_Plan_Comment__c> getApprovedComments(string recId){
        
        Campus_Plan_Article__c arecord=[select Article_Title__c,Title__c from Campus_Plan_Article__c where id=:recId];
        List<Campus_Plan_Comment__c> ctlist=[select Name,Comment__c,Reply__c,Comment_Group__c from Campus_Plan_Comment__c where Site_Visible__c=true AND Comment_Group__c=:arecord.Title__c];
        if(ctlist.size()>0){
            return ctlist;
        }
        else{
           
            return null;
        }
        
    }*/
    @AuraEnabled
    public static ParkingFAQs getApprovedFAQs(){
        
        List<Campus_Plan_FAQ__c> FAQlist=[select FAQ_Group__c,FAQ_Group1__c,Question__c,Answer__c, Answer_Sequence_No__c from Campus_Plan_FAQ__c where Visible__c=true order by FAQ_Group_Sequence_Formula__c Asc, Answer_Sequence_No__c Asc];
        List<Campus_Plan_FAQ__c> FAQlist1=new List<Campus_Plan_FAQ__c>();
        List<Campus_Plan_FAQ__c> FAQlist2=new List<Campus_Plan_FAQ__c>();
        List<Campus_Plan_FAQ__c> FAQlist3=new List<Campus_Plan_FAQ__c>();
        List<Campus_Plan_FAQ__c> FAQlist4=new List<Campus_Plan_FAQ__c>();
        List<Campus_Plan_FAQ__c> FAQlist5=new List<Campus_Plan_FAQ__c>();
		
		Map<String, SectionData> sectionMap=new Map<String, SectionData>();
		SectionData sd;
        if(FAQlist.size()>0){
            ParkingFAQs pf=new ParkingFAQs();
            for(Campus_Plan_FAQ__c c:FAQlist){
				if(String.isNotBlank(c.FAQ_Group__c)){
					sd = sectionMap.get(c.FAQ_Group__c);
					if(sd==null){
						sd=new SectionData();
						sd.sectionName = c.FAQ_Group__c;
						sectionMap.put(c.FAQ_Group__c, sd);
					}
					sd.addFaq(c);
				}	
                
                if(c.FAQ_Group__c=='Duarte Campus'){
                   FAQlist1.add(c);
                }
                else if(c.FAQ_Group__c=='Parking and Transportation'){
                   FAQlist2.add(c);
                }
                else if(c.FAQ_Group__c=='Rivergrade'){
                     FAQlist3.add(c);
                }
                else if(c.FAQ_Group__c=='Orange County'){
                   FAQlist4.add(c);
                }
                else if(c.FAQ_Group__c=='Other'){
                   FAQlist5.add(c);
                }
                else{
                    
                }
                pf.dcfaqlist=FAQlist1;
                pf.ptfaqlist=FAQlist2;
                pf.rgfaqlist=FAQlist3;
                pf.ocfaqlist=FAQlist4;
                pf.otherfaqlist=FAQlist5;
              
            }
			
			for(SectionData secd: sectionMap.values()){
				secd.arrangeGroupInfo();
			}
			
			pf.sectionMap = sectionMap;
			system.debug('----sectionMap---pf---'+JSON.serialize(pf));
           return pf;
        }
        else{
            
            return null;
        }
    }
    @AuraEnabled
    public static timelinewrap getTimelineInfo(String pagesource){
        
        List<Campus_Plan_Timeline__c> timelinelist=[select id,URL__c,Title__c,Date_of_Event__c,Description__c,Timeline_Image__c,Year__c,Landing_Page__c,Date_Text__c,Timeline_Seq_Num__c from Campus_Plan_Timeline__c where Landing_Page__c=:pagesource ORDER BY Date_of_Event__c ASC];
        List<Campus_Plan_Timeline__c> year2018=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2019=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2020=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2021=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2022=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2023=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2024=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2025=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2026=new List<Campus_Plan_Timeline__c>();
        List<Campus_Plan_Timeline__c> year2027=new List<Campus_Plan_Timeline__c>();
		
		
        if(timelinelist.size()>0){
            timelinewrap tw=new timelinewrap();
            for(Campus_Plan_Timeline__c t:timelinelist){
				
                 if(t.Year__c=='2018'){
                   year2018.add(t);
                }
                 else if(t.Year__c=='2019'){
                   year2019.add(t);
                }
                
                else if(t.Year__c=='2020'){
                   year2020.add(t);
                }
                else if(t.Year__c=='2021'){
                   year2021.add(t);
                }
                else if(t.Year__c=='2022'){
                     year2022.add(t);
                }
                else if(t.Year__c=='2023'){
                   year2023.add(t);
                }
                else if(t.Year__c=='2024'){
                   year2024.add(t);
                }
                else if(t.Year__c=='2025'){
                   year2025.add(t);
                }
                else if(t.Year__c=='2026'){
                   year2026.add(t);
                }
                else if(t.Year__c=='2027'){
                   year2027.add(t);
                }
                else{
                    
                }
                tw.year2018=year2018;
                tw.year2019=year2019;
                tw.year2020=year2020;
                tw.year2021=year2021;
                tw.year2022=year2022;
                tw.year2023=year2023;
                tw.year2024=year2024;
                tw.year2025=year2025;
                tw.year2026=year2026;
                tw.year2027=year2027;
              
            }
			
			
           return tw;
        }
        else{
            
            return null;
        }
    }
    
    @AuraEnabled
    public static Campus_Plan_Timeline__c getTimelinePage(String recId){
         Campus_Plan_Timeline__c cptRec=[select id,URL__c,Title__c,Date_of_Event__c,Description__c,Timeline_Image__c,Year__c,Date_Text__c,Landing_Page__c from Campus_Plan_Timeline__c where id=:recId];
        return cptRec;
    }
    
    @AuraEnabled
    public static User FetchUserEmail(){
        User u = [select id,Name,Email from User where id =: userInfo.getUserId()];
        return u;
    }
    
    public class ArticleWrap{
        @AuraEnabled
        public string Image{set;get;}
        @AuraEnabled
        public String recId {set;get;}
        @AuraEnabled
        public String title {set;get;}
        @AuraEnabled
        public String location {set;get;}
       
    }
  
    public class SingleArticle{
        @AuraEnabled
        public String articleImage{set;get;}
        @AuraEnabled
        public Campus_Plan_Article__c articleIndexZeroRec {set;get;}
        @AuraEnabled
        public Campus_Plan_Article__c article {set;get;}
        @AuraEnabled
        public boolean isFaqExists {set;get;}
        
    }
    public class ParkingWrap{
        @AuraEnabled
        public String Information{set;get;}
        @AuraEnabled
        public String NoticeDate {set;get;}
        
    }
    public class ParkingFAQs{
        @AuraEnabled
        public List<Campus_Plan_FAQ__c> dcfaqlist{set;get;}
        @AuraEnabled
        public List<Campus_Plan_FAQ__c> ptfaqlist {set;get;}
        @AuraEnabled
        public List<Campus_Plan_FAQ__c> rgfaqlist{set;get;}
        @AuraEnabled
        public List<Campus_Plan_FAQ__c> ocfaqlist {set;get;}
        @AuraEnabled
        public List<Campus_Plan_FAQ__c> otherfaqlist {set;get;}
		
		@AuraEnabled public Map<String, SectionData> sectionMap; //sectionName=>SectionData
		
        public ParkingFAQs(){
			sectionMap=new Map<String, SectionData>();
		}
        
    }
   /* public class TimelineMenuWrap{//2020.06.16 FSalinas
        @AuraEnabled
        public List<Campus_Plan_Timeline__c> orangecountytimeline{set;get;}
    } */
    public class NewsWrap{
        @AuraEnabled
        public List<Campus_Plan_News__c> homepagenews{set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> ptnews {set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> Dunews {set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> rivergradenews{set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> orangecountynews {set;get;}
        @AuraEnabled 
        public List<Campus_Plan_Timeline__c> cpTimelines {set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> medicalofficenews {set;get;}
        @AuraEnabled
        public List<Campus_Plan_News__c> ricnews {set;get;}
        
        @AuraEnabled
        public Map<Id, List<Campus_Plan_News__c>> DuartemMap {set;get;}
        
        
        
        
    }
    public class timelinewrap{
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2018{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2019{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2020{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2021{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2022{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2023{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2024{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2025{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2026{set;get;}
        @AuraEnabled public List<Campus_Plan_Timeline__c> year2027{set;get;}
    }
	public class SectionData{
		@AuraEnabled public String sectionName;
		@AuraEnabled public list<GroupData> groupList;
		@AuraEnabled public Map<String, GroupData> gDataMap;
		String groupName;
		list<String> groups;
		public SectionData(){
			groupList=new list<GroupData>();
			sectionName = '';
			gDataMap=new Map<String, GroupData>();
		}
		public void addFaq(Campus_Plan_FAQ__c faq){
			if(String.isNotBlank(faq.FAQ_Group1__c)){
				groupName = faq.FAQ_Group1__c;//split(';');
				groups = groupName.split(';');
				for(String gp:groups){
					GroupData gd = gDataMap.get(gp);
					if(gd==null){
						gd=new GroupData();
						gDataMap.put(gp, gd);
						gd.groupName = gp;
					}
					gd.gQuestions.add(faq);
				}
			}
		}
		public void arrangeGroupInfo(){
            system.debug('---arrangeGroupInfo--'+gDataMap.values());
			groupList.addAll(gDataMap.values());
		}
	}
	
	public class GroupData{
		@AuraEnabled public String groupName;
		@AuraEnabled public list<Campus_Plan_FAQ__c> gQuestions;
		public GroupData(){
			groupName = '';
			gQuestions=new list<Campus_Plan_FAQ__c>();
		}
	}
   
   
}