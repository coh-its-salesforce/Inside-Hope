({
	handleLoad : function(component, event, helper) {
		console.log('handle handleLoad');
        component.set("v.showSpinner", false);
	},
    handleSubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        
        component.find('createFAQForm').submit(fields); // Submit form
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message:'Record has been updated successfully !!' ,
            type : 'success'
        });
        toastEvent.fire();
		console.log('handle handleSubmit');
	},
	handleSuccess : function(component, event, helper) {
		console.log('record updated successfully');
        component.set("v.showSpinner", false);
	},
})