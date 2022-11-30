public with sharing class myNewsCompController {
    /*public List<My_News__c> newsList {get; set;}
    public Integer linkorder {get; set;}
    public boolean editFlag {get; set;}   
    public boolean saveBtnFlag {get; set;}
    public List<NewsWrapper> myNewsList {get; set;}
    public boolean msgFlag{get; set;}
    public string msg{get; set;}
    public string msgType{get; set;}
    public myNewsCompController(){
       
        queryMyNewsLinks();
        string s = apexpages.currentPage().getparameters().get('editmode');
        editFlag = false;
        msgFlag = false;
        saveBtnFlag  = false;
        if(s == '1'){
            editFlag = true;
        }
    } 
    
    public void queryMyNewsLinks(){
         myNewsList = new List<NewsWrapper>();
         
         for(My_News__c mNs : [Select id, Name, URL__c, Show_On_Home__c from My_News__c where 
                                          User1__c =: UserINfo.getUserId() order by Name ASC]){
             myNewsList.add(new NewsWrapper(mNs,myNewsList.size()));
         }
    }
    
    public void doEdit(){
        editFlag = true;
        saveBtnFlag = true;
        msgFlag = false;
    }
  
    public void removeLink(){
        system.debug('============='+linkorder );
        if(linkorder != null){
            try{
                if(myNewsList[linkorder].news.id != null){
                    delete new My_News__c(id=myNewsList[linkorder].News.id);
                }
                myNewsList.remove(linkorder);
                integer i=0;
                for(NewsWrapper f :myNewsList){
                    f.order= i;
                    i++;
                }
                msgFlag = true;
                msgType = 'success';
                msg = 'Row deleted successfully'; 
            }catch(Exception e){
                editFlag = true;
                msgFlag = true;
                msgType = 'error';
                msg = e.getMessage(); 
                msg = '';  
            }    
        }
    }
    
    public pagereference doSave(){
        
        try{
            List<My_News__c> NewsList = new List<My_News__c>();
            integer counter = 0;
            boolean errorFlag = false;
            Set<string> tempSet = new Set<string>();
            for(NewsWrapper Ns: myNewsList){
              boolean er = false;
              if(Ns.News.show_on_Home__c)  {
                 counter ++; 
              }
                  msg ='';
                  if(Ns.News.Name=='' || Ns.News.Name==null || Ns.News.URL__c=='' || Ns.News.URL__c==null){
                      if(Ns.News.Name=='' || Ns.News.Name==null) {
                      errorFlag = true;
                      er = true;
                      msgFlag = true;
                      msgType = 'error';
                      msg = 'Please Specify a Name.';
    
                  }   if(Ns.News.URL__c=='' || Ns.News.URL__c==null) {
                      errorFlag = true;
                      er = true;
                      msgFlag = true;
                      msgType = 'error';
                      msg = msg + 'Please Specify the URL';
    
                  }
                  break;
              }

                  NewsList.add(Ns.News);
            }
           
            if(counter  > 4){
                errorFlag = true; 
                msgFlag = true;
                msgType = 'error';
                msg = 'Only 4 linkes can be selected at a time.';
               
            }
            if(errorFlag ){
                 msgFlag = true;
                 msgType = 'error';
                return null;
            }
            upsert NewsList;
            
            editFlag = false;
            saveBtnFlag= false;
            msgFlag = true;
            msg = 'Link saved successfully.';
            msgType = 'success';
            queryMyNewsLinks();
        }catch(Exception e){
            editFlag = true;
            msgFlag = true;
            msgType = 'error';
            msg = e.getMessage();            
            
        }
        return null;
    }
    
    public void addNew(){
        myNewsList.add(new NewsWrapper(new My_News__c(User1__c = UserInfo.getUserId()), myNewsList.size()));
        saveBtnFlag = true;
        msgFlag = false;
        msgType = '';
        msg =''; 
    }
    
    public void doCancel(){
        editFlag = false;
        saveBtnFlag = false;
        List<NewsWrapper> temp = new List<NewsWrapper>();
        for(NewsWrapper mNs:myNewsList){
            if(mNs.News.id != null){
                temp.add(mNs);
            }
        }
        myNewsList.clear();
        myNewsList = temp ;
        
    }
    
    public List<NewsWrapper> getMyNewslinks(){
        List<NewsWrapper> linkList = new List<NewsWrapper>();
        for(My_News__c mN : [Select id, Name, URL__c, Show_On_Home__c from My_News__c where 
                                          User1__c =: UserINfo.getUserId() and Show_On_Home__c = true order by Name ASC]){
            linkList.add(new NewsWrapper(mN,linkList.size()));
        }
        
        return linkList;
    }
        
    public class NewsWrapper {
        public string label   {get;set;}
        public string linkURL {get;set;}
        public string Name {get;set;}
        public My_News__c News {get; set;}
        public integer order {get; set;}
        public boolean isChecked {get;set;}
        public NewsWrapper(My_News__c N, integer i){
            this.label = N.Name;
            this.order = i;
            this.linkURL = N.URL__c ;
            this.Name = N.Name ;
            this.News = N;
            this.isChecked = false;
        }
    }    */
}