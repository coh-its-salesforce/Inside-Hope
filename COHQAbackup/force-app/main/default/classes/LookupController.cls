public with sharing class LookupController {
    
    private BMCServiceDesk__Incident__c incident = new BMCServiceDesk__Incident__c();
    
    public String accountName {get; set;}
    public Id accountId {get; set;}
    public String callerName {get; set;}
    public Id callerId {get; set;}
	public string selectedImpact { get;set; }
	public string selectedUrgency { get;set; }    
    public List<User> users {get;set;}
    public List<User> callers {get; set;}
    public List<BMCServiceDesk__Incident__c> incidentDetails {get; set;}
    
    public BMCServiceDesk__Incident__c inc {get {return incident;} set{incident = value;}}
    
    ApexPages.StandardController GstdController;

    public LookupController(ApexPages.StandardController controller) {
        GstdController = controller;     
        this.inc = (BMCServiceDesk__Incident__c)GstdController.getRecord();
        this.users = [Select Id, Name from User where Id = :inc.BMCServiceDesk__FKClient__c];

        //this.callers = [Select Id, Name from User where Id = :inc.FKUser1__c];
        if (users.size() > 0)
        {
            this.accountName = users[0].Name;
            this.accountId = users[0].Id;
        }
        /*if (callers.size() > 0)
        {
            this.callerName = callers[0].Name;
            this.callerId = callers[0].Id;
        }*/
    }    

    public List<SelectOption> ImpactList{
        get
        {
            List<SelectOption> items = new List<SelectOption>();
            items.add(new SelectOption('','-- Choose an Impact --'));
            
            for (BMCServiceDesk__Impact__c imp : [Select Id, Name From BMCServiceDesk__Impact__c WHERE BMCServiceDesk__inactive__c = false ORDER BY Name])
                items.add(new SelectOption(imp.Id, imp.Name));
            
            return items;
        }
        set;
    } 
    
    public List<SelectOption> UrgencyList{
        get
        {
            List<SelectOption> items = new List<SelectOption>();
            items.add(new SelectOption('','-- Choose an Urgency --'));
            
            for (BMCServiceDesk__Urgency__c urg : [Select Id, Name From BMCServiceDesk__Urgency__c WHERE BMCServiceDesk__inactive__c = false ORDER BY Name])
                items.add(new SelectOption(urg.Id, urg.Name));
            
            return items;
        }
        set;
    } 
    
    public PageReference mysave()
    {
        if (accountName == '' || accountName == null || inc.BMCServiceDesk__FKClient__c == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a value in the Client Name field.'));

            return null;
        }   
        else
        {
            pageReference ps = GstdController.save();
            pageReference pv = GstdController.view();
            
            return pv;
        }

    }


}