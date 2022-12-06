({
    getPicklistsClient: function(component, event, helper) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'ITS Request' });
		action.setStorable();
        
        action.setCallback(this, function(response) {
            component.set("v.mPicklists", JSON.parse(response.getReturnValue()));
        });
        $A.enqueueAction(action);        
    }
})