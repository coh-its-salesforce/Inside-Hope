public class ProviderSearchController {
    public string keyword {get;set;}
    public List<Contact> result {get; set;}
    public Contact conObj       {get; set;}
    Public Integer noOfRecords  {get; set;}
    Public Integer size         {get; set;}
    public string sortDir       {get; set;}
    public string sortBy        {get; set;}
    
    
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {get; set;}
    
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            if(con != null)
                return con.getHasNext();
            else 
                return false;
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            if(con != null)
                return con.getHasPrevious();
                        else
                return false;
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            if(con != null)
                return con.getPageNumber();
            else
                return 0;
        }
        set;
    }

    // returns the first page of records
    public void first() {
         con.first();
    }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }
    
    public ProviderSearchController(){
        result = new List<Contact>();    
        conObj = new Contact(); 
        size = 20;
        sortDir = '' ;
        sortBy  = '';
    }
    
    
    public pageReference sortRecord(){
        if(sortDir == null || sortDir == ''){
            sortDir = 'ASC';
        }
        
        if(sortDir == 'ASC')
            sortDir = 'DESC';
        else
            sortDir = 'ASC';
            
        createQueryString();
        Search();    
        return null;     
        
    }
    
    
    
    public string createQueryString(){
        
        String query = 'Select id, FirstName, LastName,Email, Specialty__c, Division__c, Phone, MobilePhone, AccountID from contact  where  (Type__c= \'Physician\' or Type__c= \'Extender\') ';
        string whrstr ='';
        
        if(keyword != null && keyword != '' ){
            List<string>  s = String.escapeSingleQuotes(keyword).split(' ');    
            if(s.size() == 2){
                whrstr +=  '( FirstName like \''+  '%'+s[0]+'%' + '\' and LastName Like  \'' + '%'+s[1]+'%'+'\' )';  
            }
            else{
                whrstr +=  '( FirstName like \''+  '%'+keyword +'%'+ '\' OR LastName Like  \'' + '%'+ keyword  +'%'+'\' )';  
            }
        }
        
        if(conObj.Division__c != null && conObj.Division__c != ''){
            if(whrstr != '')
                whrstr += ' and ' ;
            whrstr += ' Division__c =\'' +conObj.Division__c+ '\'';
        }
        
        if(conObj.Specialty__c != null && conObj.Specialty__c != ''){
            
            string condtnStr = '';
            
            for(string str : conObj.Specialty__c.split(';')){
                condtnStr += ',\''+Str+'\'' ;    
            }
            
            IF(condtnStr != ''){
                condtnStr = ' ( '+ condtnStr.substring(1) + ' ) ';
                IF(whrstr != '')
                    whrstr += ' AND ';
                whrstr = ' Specialty__c INCLUDES '+ condtnStr;
            }
            
        }
        system.debug('==whrstr=='+whrstr);
        if(whrstr != '')
            query += ' and ' + whrstr  ;
        
        if(sortBy != null && sortBy != ''){
            query += ' order by  ' + sortBy  ;
        }
        
        if(sortDir != null && sortDir != ''){
            query += ' '+ sortDir;
        }
        
       
        system.debug('====query ====='+query );
        return query;
    }
    
    public pageReference findRecord(){
        sortDir = '' ;
        sortBy  = '';
        
        return Search();
    }
    
    public pageReference Search(){
        result = new List<Contact>();
        if((keyword != null && keyword != '' ) || (conObj.Division__c != null && conObj.Division__c != '') || (conObj.Specialty__c != null && conObj.Specialty__c != '')) {
            String query = createQueryString();
            system.debug('===query===='+query);
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            system.debug('===con===='+con);
            con.setPageSize(size);
            noOfRecords = con.getResultSize();
            createList();
            system.debug('===result===='+result);
            if(result.isEmpty()){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No record Found.'));
            }
          
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please enter detail for search.'));
        }
        return null;
    }
       
    public void createList(){
        result = new List<Contact>();
        for(Contact c : (List<Contact>)con.getRecords()){
            result.add(c);
        }
    } 
}