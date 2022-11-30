public with sharing class ChangeOwnerWithNoteController {
	private ApexPages.StandardController controller {get; set;}
    public final String queueName {get;set;}
    public final String staffName {get; set;}
    public final String note {get;set;}
    
    public Group grp {get; set;}
    public User usr {get; set;}
    public BMCServiceDesk__Incident__c incident { get;set; }
    public String sStatus {get; set;}
	public string selectedQueue { get;set; }
	public string selectedStaff { get;set; }
	public String notes {get; set;}
	public String errMsg {get; set;}
	// Storage for User Group Mapping
	public Map<Id, Group> groupMap {get; set;}
	public List<GroupMember> groupMembers {get; set;}
	public Set<Id> userOrGroupIds {get; set;}
	public Map<Id, User> userMap {get; set;}
	public Map<Id, List<User>> groupIdToUsers {get; set;}
	
	
	

    public ChangeOwnerWithNoteController(ApexPages.StandardController controller) {
        
        this.controller = controller;
        this.incident = (BMCServiceDesk__Incident__c)controller.getRecord();
        //this.incident = (BMCServiceDesk__Incident__c)controller.getRecord();
        incident = [SELECT Id, Name, BMCServiceDesk__incidentResolution__c,BMCServiceDesk__firstCallResolution__c,
                            BMCServiceDesk__ClosureCategory__c, BMCServiceDesk__note__c, OwnerId, BMCServiceDesk__FKOpenBy__c, TempNote__c
                        FROM BMCServiceDesk__Incident__c 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('id')];

        
        groupMap = new Map<Id, Group>([Select Id, Name From Group Where Type='Queue']);
        groupMembers = [Select GroupId, UserOrGroupId From GroupMember Where GroupId In :groupMap.keySet()];
        userOrGroupIds = new Set<Id>();
		for (GroupMember member : groupMembers) {
		    userOrGroupIds.add(member.UserOrGroupId);
		}
		userMap = new Map<Id, User>([Select Id, Name From User Where Id In :userOrGroupIds]);
		groupIdToUsers = new Map<Id, List<User>>();
		for (Id groupId : groupMap.keySet()) {
		    groupIdToUsers.put(groupId, new List<User>());
		}

		for (GroupMember member : groupMembers) {
		    if (userMap.containsKey(member.UserOrGroupId)) {
		        groupIdToUsers.get(member.GroupId).add(userMap.get(member.UserOrGroupId));
		    }
		}
        selectedQueue = incident.OwnerId;
        selectedStaff = incident.BMCServiceDesk__FKOpenBy__c;        
    }

    public List<SelectOption> QueueList{
        get
        {
            List<SelectOption> items = new List<SelectOption>();
            items.add(new SelectOption('','-- Choose a Queue --'));
            
            for (QueueSobject grp : [Select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' order by Queue.Name])
                items.add(new SelectOption(grp.QueueId,grp.Queue.Name));
            
            return items;
        }
        set;
    }   	

	public List<User> optUsers {
		get{
			List<User> users = new List<User>();
			Id i = Id.valueOf(selectedQueue);
			//Use selectedQueue
			if (selectedQueue != '')
				users = groupIdToUsers.get(i);
			return users;
		}
		set;
	}

    public List<SelectOption> StaffList{
        get
        {
            List<SelectOption> items = new List<SelectOption>();
            items.add(new SelectOption('','-- Choose a Staff Member --'));
            if (null != optUsers){
	            for (User u : optUsers)
	                items.add(new SelectOption(u.Id,u.Name));            	
            }
            
            return items;
        }
        set;
    }

    public PageReference save() {
	    	if (selectedQueue != '')
	    		incident.OwnerId = selectedQueue;

	    	if (selectedStaff != '')
	    		incident.BMCServiceDesk__FKOpenBy__c = selectedStaff;
	     
	        try{
	            update(incident); 
	        }catch(DmlException d){
	            ApexPages.addMessages(d);
	            return null;
	        }
			return (new ApexPages.Standardcontroller(incident)).view();
    	//}
        //return null;
    }


}