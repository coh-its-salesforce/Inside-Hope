public class ext_NewsAnnouncement{
    
    public List<COH_SI_NewsandAnnouncement__c> lstNewsList1{get;set;}
    public List<COH_SI_NewsandAnnouncement__c> lstNews{get;set;}
    public List<COH_SI_NewsandAnnouncement__c> lstNewsList2{get;set;}
    public String txtSearch{get;set;}
    public boolean booHomePage{get;set;}
    public boolean boodepartment{get;set;}    
    public string pageName{get;set;}
    public DateTime CreationDate;
    public ext_NewsAnnouncement(){
        String Preview = ApexPages.currentPage().getParameters().get('preview');
        Datetime current = System.now();
        Date d = current.date();
        Time t = current.time();
        Datetime dtLocalDateTime =  Datetime.newInstance(d,t);
        lstNews = New List<COH_SI_NewsandAnnouncement__c>();
        lstNewsList1 = New List<COH_SI_NewsandAnnouncement__c>();
        lstNewsList2 = New List<COH_SI_NewsandAnnouncement__c>();
        
        if(Preview == 'true')
        {
            lstNews = [Select id, title__C, preview__c, description__C, Image_URL__c,PhotoURL__C, Image_Attachment_Id__c, CreatedDate FROM COH_SI_NewsandAnnouncement__c where Preview__c = true and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC LIMIT 6];
        }
        else
        {
            lstNews = [Select id, title__C, preview__c , description__C, Image_URL__c,PhotoURL__C, Image_Attachment_Id__c, CreatedDate FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = true and Display__c = true and Preview__c = false and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC LIMIT 6];
        }
        
        for(COH_SI_NewsandAnnouncement__c loopNews : lstNews)
        {
             if(lstNewsList1.size() <= 2)
                   lstNewsList1.add(loopNews);
              else
                   lstNewsList2.add(loopNews);
            
              /*if((loopNews.title__C != null) && (loopNews.title__C).length() > 10)
                  loopNews.title__C = (loopNews.title__C).mid(0 , 40) + '...';
                  
              if((loopNews.description__C != null) && (loopNews.description__C).length() > 10)
                  loopNews.description__C = (loopNews.description__C).mid(0 , 200) + '...';*/
        }
        if(pageName == 'Home Page'){
           booHomePage = false;
           boodepartment = true;
        }
        else if(pageName == 'Department'){
           booHomePage = true;
           boodepartment = false;
        }
           
    }
    
    public ext_NewsAnnouncement(ApexPages.StandardController controller){}
    
    public void btnSearch(){}
}