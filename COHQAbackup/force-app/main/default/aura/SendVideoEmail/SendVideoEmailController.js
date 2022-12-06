({
    doInit : function(component, event, helper) {
        var action = component.get("c.sendEmail");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": response.getError() && response.getError().length ? response.getError()[0].message : 'Unknown error occurred!'
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": 'Email has been sent successfully!'
                });
                toastEvent.fire();
            }
            $A.get("e.force:refreshView").fire();
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})