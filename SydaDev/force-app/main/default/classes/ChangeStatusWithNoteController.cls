public with sharing class ChangeStatusWithNoteController {

    public final BMCServiceDesk__Status__c status {get;set;}
    public final String statusName {get;set;}
    public final String note {get;set;}
    
    public BMCServiceDesk__Incident__c incident { get;set; }
    public String sStatus {get; set;}
    
     public ChangeStatusWithNoteController(ApexPages.StandardController controller) {
        
        //this.incident = (BMCServiceDesk__Incident__c)controller.getRecord();
        statusName = ApexPages.currentPage().getParameters().get('statusName');
        incident = [SELECT Id, Name, BMCServiceDesk__incidentResolution__c,BMCServiceDesk__firstCallResolution__c,
                            BMCServiceDesk__ClosureCategory__c, TempNote__c
                        FROM BMCServiceDesk__Incident__c 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                        
        if(statusName == 'With_3rd_Party'){
            status = [SELECT Id, Name FROM BMCServiceDesk__Status__c where name = 'With 3rd Party' and BMCServiceDesk__appliesToIncident__c = true ];
        }
        else{
            status = [SELECT Id, Name FROM BMCServiceDesk__Status__c where name = 'With Customer' and BMCServiceDesk__appliesToIncident__c = true ];
        } 
    }
    
    
    public PageReference save() {
    
        if(status != null){
            incident.BMCServiceDesk__FKStatus__c = status.Id;
        }
        
        try{
            // add a new incident history note
            BMCServiceDesk__Action__c action = [select Id from BMCServiceDesk__Action__c where Name = 'Notes'];
            BMCServiceDesk__IncidentHistory__c note = new BMCServiceDesk__IncidentHistory__c();
            addNote(incident.TempNote__c, status.Name, incident.Id, action.Id);
            /*
            note.BMCServiceDesk__Note__c = incident.TempNote__c;
            note.BMCServiceDesk__Description__c = 'Reason for ' + status.Name;
            note.BMCServiceDesk__FKIncident__c = incident.Id;
            note.BMCServiceDesk__FKAction__c = action.Id;
            insert note;
            */
            incident.TempNote__c = '';
            update incident;
            
            sStatus = 'saved';
        }catch(DmlException d){
            sStatus = 'unsaved';
        }
        
        
        
        return null;
    }
    
    @future
    public static void addNote(string sNote, string sDesc, Id incidentId, Id actionId){
        BMCServiceDesk__IncidentHistory__c note = new BMCServiceDesk__IncidentHistory__c();
            note.BMCServiceDesk__Note__c = sNote;
            note.BMCServiceDesk__Description__c = 'Reason for ' + sDesc;
            note.BMCServiceDesk__FKIncident__c = incidentId;
            note.BMCServiceDesk__FKAction__c = actionId;
            insert note;        
    }
}