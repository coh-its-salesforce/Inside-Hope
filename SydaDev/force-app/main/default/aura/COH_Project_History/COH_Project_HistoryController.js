({ 

    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    
    handleEdit: function(component){
        component.set("v.viewScreen",false);
        component.set("v.editScreen",true);
    },
        
    handleSubmit : function(component, event, helper) {

                event.preventDefault();
                var fields = event.getParam("fields");
                component.find('createevalForm').submit(fields); // Submit form
                component.set("v.editScreen",false);
                component.set("v.viewScreen",true);
	},
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },
        
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    
      
})