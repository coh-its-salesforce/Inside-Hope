({
    /*
     * Update an Epic record.
     * 
     * @param component		Component
     * @param event				Eomponent
     * @param helper			Helper
     * 
     */
	updateEpicRecord : function(component, event, helper) {
        var btn = event.getSource();
        btn.set('v.disabled', true);
        var action = component.get("c.updateExistingEpicRecord");    
        var accountID = component.get("v.recordId");
        action.setParams({"accountID":accountID});
        
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                helper.showToast('Success', 'Record updated successfully in Epic: Please note updates made to patient Name, SSN, Gender, Email and Phone will not reflect in EPIC.', 'success');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }  else if (state =='ERROR') {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast('Error', message, 'error');
                $A.get("e.force:closeQuickAction").fire();
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
    }
})