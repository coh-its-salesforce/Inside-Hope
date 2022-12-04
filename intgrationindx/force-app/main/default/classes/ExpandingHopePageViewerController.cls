public class ExpandingHopePageViewerController {
    public String currentRecordId {get;set;}
    public Campus_Plan_News__c NewsItem{get;set;}
    public Campus_Plan_Timeline__c TimelineItem{get;set;}
    public Campus_Plan_FAQ__c FaqItem{get;set;}
    public String RichTextImage{get;set;}
    public String RichTextOutput{get;set;}
    public String RichTextNextToImage{get;set;}
    public String TextTitle{get;set;}
    public String TextSubTitle{get;set;}
    Public String Description{get;set;}
    public String DateText{get;set;}
    public String sObjName{get;set;}
    public String Question{get;set;}
    public string Year{get;set;}
    public string Name {get;set;}
    public String Answer{get;set;}
    
    //Variables from SOSLController, Limit SOSL Search to these objects for Expanding Hope
    Public List<Campus_Plan_News__c> newsList {get;set;}
    Public List<Campus_Plan_FAQ__c> faqList{get;set;}
    Public List<Campus_Plan_Timeline__c> timelineList{get;set;}
    Public String searchStr{get;set;}
    //////////////////////////////////
	
 
    //public ExpandingHopePageViewerController(ApexPages.StandardController controller) {
    public ExpandingHopePageViewerController() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        id sObjId = currentRecordId;
        try {
            sObjName = sObjId.getsobjecttype().getDescribe().getName();
        } catch (exception e) {
            sObjName = '';
        }
        System.debug('object name is : '+ sObjName);
        if ( sObjName == 'Campus_Plan_News__c' ) {
        	NewsItem = [Select id, name, News_Content_Next_to_Image__c, Title__c,Sub_Title__c,Detailed_Description__c,Carousel_Image__c from Campus_Plan_News__c where id =:currentRecordId];
            RichTextImage = NewsItem.Carousel_Image__c;
            RichTextNextToImage = NewsItem.News_Content_Next_to_Image__c;
            RichTextOutput = NewsItem.Detailed_Description__c;
            TextTitle = NewsItem.Title__c;
            TextSubTitle = NewsItem.Sub_Title__c;
        } else if ( sObjName == 'Campus_Plan_Timeline__c' )  {
        	TimelineItem = [Select id, name, Year__c, Title__c, Date_Text__c, Description__c, Timeline_Image__c from Campus_Plan_Timeline__c where id =:currentRecordId];
            RichTextImage = TimelineItem.Timeline_Image__c;
            //RichTextNextToImage = TimelineItem.News_Content_Next_to_Image__c;
            RichTextOutput = TimelineItem.Description__c;
            TextTitle = TimelineItem.Title__c;
            DateText = TimelineItem.Date_Text__c;
        } else if ( sObjName == 'Campus_Plan_FAQ__c' )  {
        	FaqItem = [Select id,name, Question__c, Answer__c from Campus_Plan_FAQ__c where id =:currentRecordId];
            Question = FaqItem.Question__c;
            Answer = FaqItem.Answer__c;
        } else {
            sObjName = '';
        }
    }    
    
  Public void soslLookup_method(){
   timelineList = New List<Campus_Plan_Timeline__c>();// #1
   newsList = New List<Campus_Plan_News__c>();// #2
   faqList = New List<Campus_Plan_FAQ__c>();// #3
   if(searchStr.length() > 1){
       String searchStr1 = '*'+searchStr+'*';
       String searchStrlEscape = String.escapeSingleQuotes(searchStr1);//FS CR00035179 20210318 added escapSingleQuotes to mitigate SOSL Injection
       String searchQuery = 'FIND \'' + searchStrlEscape + '\' IN ALL FIELDS RETURNING ' +
           'Campus_Plan_Timeline__c(id, name, Description__c, Title__c), ' + 
           'Campus_Plan_News__c(id, name, News_Content_Next_to_Image__c, Title__c), ' + 
           'Campus_Plan_FAQ__c(id, name, Question__c, Answer__c) LIMIT 50';
       List<List <sObject>> searchList = search.query(searchQuery);
       timelineList = ((List<Campus_Plan_Timeline__c>)searchList[0]);
       newsList = ((List<Campus_Plan_News__c>)searchList[1]);
       faqList  = ((List<Campus_Plan_FAQ__c>)searchList[2]);
       if(timelineList.size() == 0 && faqList.size() == 0 && newsList.size() == 0){
           apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
           return;
       }
   }
   else {
       apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
       return;
		}
  }
    
}