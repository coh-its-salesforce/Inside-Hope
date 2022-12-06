({
	handleSubmit : function(component, event, helper) {
		component.find('saveBtn').set('v.disabled',true);
	},
    
	handleSuccess : function(component, event, helper) {
        var title = "Bed Placement Information Saved";
        var type = "success";
        var message = "The record has been updated successfully.";
		helper.showToast(title,type,message);
        component.find('saveBtn').set('v.disabled',false);
        $A.get('e.force:refreshView').fire();
	},

	handleError : function(component, event, helper) {
        var error = event.getParams().error;
        var title = "Bed Placement Failed to Saved";
        var type = "error";
        var message = error.errorCode + ': ' + error.message;
		helper.showToast(title,type,message);
        component.find('saveBtn').set('v.disabled',false);
	}    
})