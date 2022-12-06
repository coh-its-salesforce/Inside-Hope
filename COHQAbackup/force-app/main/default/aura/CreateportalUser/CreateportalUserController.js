({
    /*
     * Component Init function
     * Passes the RecordId to the APEX Controller. Displays any return message into the component attribute mMessage
     */ 
    init : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var action = component.get("c.createPortaluser");
        action.setParams({
            "ConId": recId            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
               	var message = response.getReturnValue();
                component.set('v.mMessage', message);
                $A.get('e.force:refreshView').fire();
                component.set('v.mLoading', false);
            }
        });
        $A.enqueueAction(action);
    }
})