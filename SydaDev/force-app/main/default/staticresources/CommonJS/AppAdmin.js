var TaskAssignmentPanel = new Ext.Panel({
        id: 'TaskAssignmentPanelId',
        border:false,
        layout:'table',
        //renderTo: 'DefaultAccountNameDiv',
        items:[{
			xtype: "textfield",
			name: "lookupvalue",
			readOnly: true,
			height: 20,
			cls: 'clsInputTextBox',
			id:'TaskQueLookupId',
			value:'{!taskQueue}',
			listeners: {
                specialkey: function(field, e){
					if (e.getKey()==e.BACKSPACE) {
						this.setValue('');
						setBlankValues('task');
					}
                }
            }
		},{
			xtype: "box",
			autoEl: {tag: 'img', src: SDEFStyles+'/SDEFbuttons/b_darrow_D.gif'},			
			name: "TaskQueueLookupBtn",
			id:'TaskQueueLookupButtonId',
			cls:'lookupbuttontest',
			listeners:{
                render: function(c) {
                    
                    c.getEl().on('click', function(){
						popupId = 'Queue';
						var objName = 'task__c';
						QueueAssignment('task');
			  			window.parent.openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Task__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), childProcessQueueAssignment, 580,475);
			   			      	     		
                    });
                 }
             }
             }] 
    });
    
    var CRAssignmentPanel = new Ext.Panel({
        id: 'CRAssignmentPanelId',
        border:false,
        layout:'table',
        //renderTo: 'DefaultAccountNameDiv',
        items:[{
			xtype: "textfield",
			name: "lookupvalue",
			readOnly: true,
			height: 20,
			cls: 'clsInputTextBox',
			id:'CRQueLookupId',
			value:'{!CRQueue}',
			listeners: {
                specialkey: function(field, e){
					if (e.getKey()==e.BACKSPACE) {
						this.setValue('');
						setBlankValues('change request');
					}
                }
            }
		},{
			xtype: "box",
			autoEl: {tag: 'img', src: SDEFStyles+'/SDEFbuttons/b_darrow_D.gif'},			
			name: "CRQueueLookupBtn",
			id:'CRQueueLookupButtonId',
			cls:'lookupbuttontest',
			listeners:{
                render: function(c) {
                    
                    c.getEl().on('click', function(){
						popupId = 'Queue';
						var objName = 'change_request__c';
						QueueAssignment('change request');
			  			window.parent.openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=change_request__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), childProcessQueueAssignment, 580,475);
			   			      	     		
                    });
                 }
             }
             }] 
    });
	
	var enableCustomFieldMappingCheck = new Ext.form.Checkbox({
         id:'enableCustomFieldMapping',
         cls:'checkboxClass' ,
         boxLabel: lblEnableCustomFieldMapping, 
		 checked: propEnableCustomFieldMapping,
         style: 'width:13px;',
		 handler: function() {
            setPropCustomFieldMapping(this.getValue());
         }
	});
	
	var processAssignmentPanel = new Ext.Panel({
        border:false,
        id:'processAssignmentPanelId',
		layout:'table',
		layoutConfig:{ columns: 2},		
        items:[
        	TaskQueueLabel, TaskAssignmentPanel,
        	CRQueueLabel, CRAssignmentPanel
        ]
        
    });
   