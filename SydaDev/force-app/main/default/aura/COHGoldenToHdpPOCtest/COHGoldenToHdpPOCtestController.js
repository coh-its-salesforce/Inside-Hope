({
	sendRecord : function(component, event) {
	var action = component.get("c.creatPlaneOfCareSection");    
    var artId = component.get("v.recordId");
	var button = event.getSource();
    button.set('v.disabled',true); 
         component.set("v.spinner", true);
	action.setParams({
        "planID":artId
    });
    action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } component.set("v.spinner", false);
        	button.set('v.disabled',false);
        });
    $A.enqueueAction(action);
	},
	handleCancel: function(component, event) {
    $A.get("e.force:closeQuickAction").fire();   
	}
})