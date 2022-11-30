({
    getPicklistsClient: function(component, event, helper) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'Labor Request' });
        
        action.setCallback(this, function(a) {
            component.set("v.mPicklists", JSON.parse(a.getReturnValue()));
        });
        $A.enqueueAction(action);        
    },
})