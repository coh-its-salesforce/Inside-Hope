({
	updateEpicRecord : function(component, event, helper) {
        var btn = event.getSource();
        var action = component.get("c.updateExistingEpicRecord");    
        var accountID = component.get('v.recordId');
        action.setParams({'accountID':accountID});
        
        btn.set('v.disabled', true);
        
        action.setCallback(this, function(response){            
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
				var retVal = response.getReturnValue();
                helper.showToast('Success', 'Record updated successfully in Epic', 'success');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }  else if (state =='ERROR') {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast('Error', message, 'error');
            } 
            btn.set('v.disabled', false);
        });
        
        $A.enqueueAction(action);
	},
    
    /*
     * Cancel a record.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */
	cancelRecord: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    /*
     * Display a message.
     * 
     * @param title					Title.
     * @param message		Message to display.
     * @param type					Message type.
     * 
     */
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})