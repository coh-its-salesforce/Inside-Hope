({
    doInit:function(component, event, helper){
        //Disables Create Epic MRN button and checks to see if all required fields are covered 01/20/2022 LK
        var disableButton = true;
        var action = component.get("c.verifyAccountCreateEpicMRNButton");
        var recordId = component.get("v.recordId");
        action.setParams({"accountId":recordId});
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === "SUCCESS"){
                disableButton = response.getReturnValue();
                let button = component.find('createEpicButton');
                button.set('v.disabled',disableButton);
                
            } else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    /*
     * Create an Epic record.
     * 
     * @param component		Component
     * @param event				Eomponent
     * @param helper			Helper
     * 
     */
    createEpicRecord : function(component, event, helper) {
        var btn = event.getSource();
        btn.set('v.disabled', true);
        //        var action = component.get("c.UpdateDoNotSendFlag");    
        var action = component.get("c.createNewEpicRecordViaAccount");    
        
        var recordId = component.get("v.recordId");
        action.setParams({"accountId":recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                helper.showToast('Success', 'Record saved to Epic', 'success');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();                
                // testing--raymond tam
                var retVal = response.getReturnValue();
            } else {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast('Error', message, 'error');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
            btn.set('v.disabled', false);
        });
        
        $A.enqueueAction(action);
    },
    
    /*
     * Cancel  a record.
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