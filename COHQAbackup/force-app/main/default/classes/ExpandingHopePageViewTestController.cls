@IsTest
public class ExpandingHopePageViewTestController {
   
    
    public static testMethod void testSoslFixedResults() 
	{
        Campus_Plan_News__c Cnews1 = new Campus_Plan_News__c();
		Cnews1.Title__c = 'test';
        Cnews1.Carousel_Image__c='http://tineye.com/images/widgets/mona.jpg';
        Cnews1.News_Content_Next_to_Image__c='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
        Cnews1.Detailed_Description__c='The Orange County Register';
        Cnews1.Sub_Title__c='orange Register';
		insert Cnews1;
        PageReference myVfPage = Page.ExpandingHopePageViewer;
        myVfPage.getParameters().put('id',Cnews1.id);
		Test.setCurrentPageReference(myVfPage);
            ExpandingHopePageViewerController testSearch = new ExpandingHopePageViewerController();
            testSearch.searchStr='Orange Country';
            testSearch.RichTextImage='http://tineye.com/images/widgets/mona.jpg';
            testSearch.RichTextOutput='The Orange County Register';
            testSearch.Description='testDescription';
        	testSearch.RichTextNextToImage='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
            testSearch.TextTitle='orange Register ';
        	testSearch.TextSubTitle='DailPoint';
            testSearch.year='2016, 12, 9';
            testSearch.DateText='TestDateText';
            testSearch.sObjName='Sobject';           
            testSearch.Question='News And Events';
            testSearch.Answer='Sample';
            testSearch.Name='Gustuser';
            testSearch.soslLookup_method();
  // Values of Campus_Plan_News__c
    Campus_Plan_News__c Cnews = new Campus_Plan_News__c();
		Cnews.Title__c = 'test';
        Cnews.Carousel_Image__c='http://tineye.com/images/widgets/mona.jpg';
        Cnews.News_Content_Next_to_Image__c='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
        Cnews.Detailed_Description__c='The Orange County Register';
        Cnews.Sub_Title__c='orange Register';
		insert Cnews;
       testSearch.NewsItem=Cnews;

        // Values of Campus_Plan_Timeline__c

        Campus_Plan_Timeline__c CTime = new Campus_Plan_Timeline__c();
        
		CTime.Title__c = 'test2';
        CTime.Date_of_Event__c=Date.newInstance(2016, 12, 9);
        CTime.Timeline_Image__c='orange Register';
        CTime.Description__c='The Orange County Register';
        CTime.Date_Text__c='TestDateText';
		insert CTime;
        testSearch.TimelineItem=Ctime;
            
 // Values of Campus_Plan_FAQ__c
        Campus_Plan_FAQ__c CPlan = new Campus_Plan_FAQ__c();
		CPlan.Question__c = 'SampleQuestion';
        CPlan.Answer__c = 'SampleAnswer';
		insert CPlan;
        testSearch.FaqItem=Cplan;
      
 // Inserting the values in to search Result       
    Test.startTest();
    Id [] fixedSearchResults= new Id[3];
		 fixedSearchResults[0] = Cnews.id;
         fixedSearchResults[1] = Ctime.id;
         fixedSearchResults[2] = Cplan.id;
       Test.setFixedSearchResults(fixedSearchResults);
        testSearch.soslLookup_method();  
         
       list<List<SObject>> searchList= [FIND   'Orange Country'  IN ALL FIELDS RETURNING
           Campus_Plan_Timeline__c(id, name, Description__c, Title__c),  
           Campus_Plan_News__c(id, name, News_Content_Next_to_Image__c, Title__c),  
           Campus_Plan_FAQ__c(id, name, Question__c, Answer__c) LIMIT 1];
        System.assertEquals('test', Cnews1.Title__c);
  Test.stopTest();
      }

    public static testMethod void testSoslFixedResults_cplantimeline() 
	{
         Campus_Plan_Timeline__c CTime1 = new Campus_Plan_Timeline__c();
        
		CTime1.Title__c = 'test2';
        CTime1.Date_of_Event__c=Date.newInstance(2016, 12, 9);
        CTime1.Timeline_Image__c='orange Register';
        CTime1.Description__c='The Orange County Register';
        CTime1.Date_Text__c='TestDateText';
		insert CTime1;
        PageReference myVfPage = Page.ExpandingHopePageViewer;
        myVfPage.getParameters().put('id',CTime1.id);
		Test.setCurrentPageReference(myVfPage);
            ExpandingHopePageViewerController testSearch = new ExpandingHopePageViewerController();
            testSearch.searchStr='Orange Country';
            testSearch.RichTextImage='http://tineye.com/images/widgets/mona.jpg';
            testSearch.RichTextOutput='The Orange County Register';
            testSearch.Description='testDescription';
        	testSearch.RichTextNextToImage='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
            testSearch.TextTitle='orange Register ';
        	testSearch.TextSubTitle='DailPoint';
            testSearch.year='2016, 12, 9';
            testSearch.DateText='TestDateText';
            testSearch.sObjName='Sobject';           
            testSearch.Question='News And Events';
            testSearch.Answer='Sample';
            testSearch.Name='Gustuser';
            testSearch.soslLookup_method();
  // Values of Campus_Plan_News__c
    Campus_Plan_News__c Cnews = new Campus_Plan_News__c();
		Cnews.Title__c = 'test';
        Cnews.Carousel_Image__c='http://tineye.com/images/widgets/mona.jpg';
        Cnews.News_Content_Next_to_Image__c='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
        Cnews.Detailed_Description__c='The Orange County Register';
        Cnews.Sub_Title__c='orange Register';
		insert Cnews;
       testSearch.NewsItem=Cnews;

        // Values of Campus_Plan_Timeline__c

        Campus_Plan_Timeline__c CTime = new Campus_Plan_Timeline__c();
        
		CTime.Title__c = 'test2';
        CTime.Date_of_Event__c=Date.newInstance(2016, 12, 9);
        CTime.Timeline_Image__c='orange Register';
        CTime.Description__c='The Orange County Register';
        CTime.Date_Text__c='TestDateText';
		insert CTime;
        testSearch.TimelineItem=Ctime;
            
 // Values of Campus_Plan_FAQ__c
        Campus_Plan_FAQ__c CPlan = new Campus_Plan_FAQ__c();
		CPlan.Question__c = 'SampleQuestion';
        CPlan.Answer__c = 'SampleAnswer';
		insert CPlan;
        testSearch.FaqItem=Cplan;
      
 // Inserting the values in to search Result       
    Test.startTest();
    Id [] fixedSearchResults= new Id[3];
		 fixedSearchResults[0] = Cnews.id;
         fixedSearchResults[1] = Ctime.id;
         fixedSearchResults[2] = Cplan.id;
       Test.setFixedSearchResults(fixedSearchResults);
        testSearch.soslLookup_method();  
         
       list<List<SObject>> searchList= [FIND   'Orange Country'  IN ALL FIELDS RETURNING
           Campus_Plan_Timeline__c(id, name, Description__c, Title__c),  
           Campus_Plan_News__c(id, name, News_Content_Next_to_Image__c, Title__c),  
           Campus_Plan_FAQ__c(id, name, Question__c, Answer__c) LIMIT 1];
        System.assertEquals('test2', CTime.Title__c);
  Test.stopTest();
      }
    
    public static testMethod void testSoslFixedResults_cplanfaq() 
	{
         Campus_Plan_FAQ__c Cfaq1 = new Campus_Plan_FAQ__c();
		Cfaq1.Question__c = 'SampleQuestion';
        Cfaq1.Answer__c = 'SampleAnswer';
		insert Cfaq1;
        PageReference myVfPage = Page.ExpandingHopePageViewer;
        myVfPage.getParameters().put('id',Cfaq1.id);
		Test.setCurrentPageReference(myVfPage);
            ExpandingHopePageViewerController testSearch = new ExpandingHopePageViewerController();
            testSearch.searchStr='Orange Country';
            testSearch.RichTextImage='http://tineye.com/images/widgets/mona.jpg';
            testSearch.RichTextOutput='The Orange County Register';
            testSearch.Description='testDescription';
        	testSearch.RichTextNextToImage='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
            testSearch.TextTitle='orange Register ';
        	testSearch.TextSubTitle='DailPoint';
            testSearch.year='2016, 12, 9';
            testSearch.DateText='TestDateText';
            testSearch.sObjName='Sobject';           
            testSearch.Question='News And Events';
            testSearch.Answer='Sample';
            testSearch.Name='Gustuser';
            testSearch.soslLookup_method();
  // Values of Campus_Plan_News__c
    Campus_Plan_News__c Cnews = new Campus_Plan_News__c();
		Cnews.Title__c = 'test';
        Cnews.Carousel_Image__c='http://tineye.com/images/widgets/mona.jpg';
        Cnews.News_Content_Next_to_Image__c='Check out our latest news and events as we speed our life-saving treatments to the people of Orange County';
        Cnews.Detailed_Description__c='The Orange County Register';
        Cnews.Sub_Title__c='orange Register';
		insert Cnews;
       testSearch.NewsItem=Cnews;

        // Values of Campus_Plan_Timeline__c

        Campus_Plan_Timeline__c CTime = new Campus_Plan_Timeline__c();
        
		CTime.Title__c = 'test2';
        CTime.Date_of_Event__c=Date.newInstance(2016, 12, 9);
        CTime.Timeline_Image__c='orange Register';
        CTime.Description__c='The Orange County Register';
        CTime.Date_Text__c='TestDateText';
		insert CTime;
        testSearch.TimelineItem=Ctime;
            
 // Values of Campus_Plan_FAQ__c
        Campus_Plan_FAQ__c CPlan = new Campus_Plan_FAQ__c();
		CPlan.Question__c = 'SampleQuestion';
        CPlan.Answer__c = 'SampleAnswer';
		insert CPlan;
        testSearch.FaqItem=Cplan;
      
 // Inserting the values in to search Result       
    Test.startTest();
    Id [] fixedSearchResults= new Id[3];
		 fixedSearchResults[0] = Cnews.id;
         fixedSearchResults[1] = Ctime.id;
         fixedSearchResults[2] = Cplan.id;
       Test.setFixedSearchResults(fixedSearchResults);
        testSearch.soslLookup_method();  
         
       list<List<SObject>> searchList= [FIND   'Orange Country'  IN ALL FIELDS RETURNING
           Campus_Plan_Timeline__c(id, name, Description__c, Title__c),  
           Campus_Plan_News__c(id, name, News_Content_Next_to_Image__c, Title__c),  
           Campus_Plan_FAQ__c(id, name, Question__c, Answer__c) LIMIT 1];
        System.assertEquals('SampleQuestion', Cfaq1.Question__c);
  Test.stopTest();
      }

}