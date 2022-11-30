public with sharing class ChangeOwnerWithNoteTaskController {
	private ApexPages.StandardController controller {get; set;}
    public final String queueName {get;set;}
    public final String staffName {get; set;}
    public final String note {get;set;}
    
    public Boolean state {get; set;}
    public Group grp {get; set;}
    public User usr {get; set;}
    public BMCServiceDesk__Task__c task { get;set; }
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
	
	
	

    public ChangeOwnerWithNoteTaskController(ApexPages.StandardController controller) {
        
        this.controller = controller;
        this.task = (BMCServiceDesk__Task__c)controller.getRecord();
        //this.incident = (BMCServiceDesk__Incident__c)controller.getRecord();
        task = [SELECT Id, Name, BMCServiceDesk__taskResolution__c,
                            BMCServiceDesk__note__c, OwnerId, BMCServiceDesk__FKOpenBy__c,BMCServiceDesk__state__c
                        FROM BMCServiceDesk__Task__c 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('id')];

        state = task.BMCServiceDesk__state__c;
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
        selectedQueue = task.OwnerId;
        selectedStaff = task.BMCServiceDesk__FKOpenBy__c;        
    }

    public List<SelectOption> QueueList{
        get
        {
            List<SelectOption> items = new List<SelectOption>();
            items.add(new SelectOption('','-- Choose a Queue --'));
            
            for (QueueSobject grp : [Select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'BMCServiceDesk__Task__c' order by Queue.Name])
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
        System.debug('### Entering SelectedQueue: ' + selectedQueue);
	    	if (selectedQueue != '')
	    		task.OwnerId = selectedQueue;
		System.debug('### Entering SelectedStaff: ' + selectedStaff);
	    	if (selectedStaff != '')
	    		task.BMCServiceDesk__FKOpenBy__c = selectedStaff;
	     
	        try{
	            update(task); 
	        }catch(DmlException d){
	            ApexPages.addMessages(d);
	            return null;
	        }
			return (new ApexPages.Standardcontroller(task)).view();
    	//}
        //return null;
    }


}