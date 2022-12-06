public with sharing class ResolveIncidentController {
	
	//private final BMCServiceDesk__Incident__c incident;
	private final BMCServiceDesk__Status__c status;
	
	public BMCServiceDesk__Incident__c incident { get;set; }
	
	public string selectedCategory { get;set; }
	public List<SelectOption> categoryOptions { get;set; } 
	public String sStatus {get; set;}
	
	 public ResolveIncidentController(ApexPages.StandardController controller) {
	 	
	 	this.incident = (BMCServiceDesk__Incident__c)controller.getRecord();
	 	
        incident = [SELECT Id, Name, BMCServiceDesk__incidentResolution__c,BMCServiceDesk__firstCallResolution__c,BMCServiceDesk__ClosureCategory__c
        			 	FROM BMCServiceDesk__Incident__c 
                   		WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                   		
        
        status = [SELECT Id FROM BMCServiceDesk__Status__c where name = 'RESOLVED' and BMCServiceDesk__appliesToIncident__c = true ];
                   
        Schema.DescribeFieldResult statusFieldDescription = BMCServiceDesk__Incident__c.BMCServiceDesk__ClosureCategory__c.getDescribe();
        categoryOptions = new list<SelectOption>();
        
        categoryOptions.add(new SelectOption('',''));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            categoryOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
    }
	
	
	public BMCServiceDesk__Incident__c getIncident() {
        return incident;
    }

    public PageReference save() {
    
    	incident.BMCServiceDesk__ClosureCategory__c = selectedCategory;
    	if(status != null){
    		incident.BMCServiceDesk__FKStatus__c = status.Id;
    	}
    	
    	try{
    		update incident;
    		sStatus = 'saved';
        }catch(DmlException d){
			sStatus = 'unsaved';
		}
        
        return null;
    }
    
    
}