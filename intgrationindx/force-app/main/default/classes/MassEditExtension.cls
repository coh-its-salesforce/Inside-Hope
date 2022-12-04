public with sharing class MassEditExtension {
    private final BMCServiceDesk__Incident__c inc;
    private List<BMCServiceDesk__Status__c> stat{get; set;}
    public List<SelectOption> selCloseCat {get; set;}
    public String selectedClosureCat {get; set;}
    public String resolution {get; set;}
    public transient List<BMCServiceDesk__Incident__c> selIncidents {get; set;}
    private ApexPages.StandardSetController standardController;
    

    public MassEditExtension(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
        selectedClosureCat = '';
    }

    public void getStatus(){
        List<BMCServiceDesk__Status__c> status = new List<BMCServiceDesk__Status__c>();
        status = [SELECT Id,Name FROM BMCServiceDesk__Status__c WHERE Name = 'CLOSED'];
        if (null != status)
            stat = status;
    }
    
    public void getCloseCat(){
        List<SelectOption> options = new List<SelectOption>();
        
            Schema.DescribeFieldResult fieldResult = BMCServiceDesk__Incident__c.BMCServiceDesk__ClosureCategory__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for (Schema.PicklistEntry f: ple){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }    
        if (options != null)
            selCloseCat = options;
        
    }
    
    public PageReference retrieveIncidents(){
        //Get the selected records
        List<BMCServiceDesk__Incident__c> selectedIncidents = (List<BMCServiceDesk__Incident__c>) standardController.getSelected();
        if (stat == null)
            getStatus();
        if (selCloseCat == null)
            getCloseCat();

        return null;
    }

    public PageReference updateIncidents(){
    List<BMCServiceDesk__Incident__c> selectedIncidents = (List<BMCServiceDesk__Incident__c>) standardController.getSelected();
        for (BMCServiceDesk__Incident__c selInc : selectedIncidents){
            selInc.BMCServiceDesk__FKStatus__c = stat[0].Id;
            selInc.BMCServiceDesk__incidentResolution__c = resolution;
            selInc.BMCServiceDesk__ClosureCategory__c = selectedClosureCat;
        }
    
        return standardController.save();
    }

}