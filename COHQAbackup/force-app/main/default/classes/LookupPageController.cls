public with sharing class LookupPageController {
    
    public Boolean render1 { get; set; }
    
    List<User> records=new List<User>();
    
    public String searchvalue { get; set; }
    
    public LookupPageController()
    {
        try
        {
            searchvalue=ApexPages.currentPage().getParameters().get('searchTerm');
            if(String.IsNotBlank(searchvalue)&& searchvalue.length() > 3){
                render1=true;
                records=[Select Id,Name from User where Name like :+searchvalue+'%' order by Name asc];
            }
        }catch(Exception e)
        {
        }
    }
    
    public List<User> getRecords() {
        if(records.size()!=0)
        {
            return records;
        }else
        {
            return null;
        }
    }
    
    public PageReference onkeyupAction() {
        searchAction();
        return null;
    }
    
    public PageReference searchAction() {
        if(String.isNotBlank(searchvalue) && searchvalue.length() > 3){
            render1=true;
            records=[Select Id,Name from User where Name like :+searchvalue+'%' order by Name asc];
            if(records.isEmpty())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'No Records Found'));
            }
        }
        return null;
    }
    
}