({
	doInit : function(component, event, helper) {
		var action = component.get("c.getpanelLinkList"); 
        var pName = component.get("v.PanelName");
        console.log('=====pName==='+pName);
        action.setParams( {'panelname':pName});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.linkList" ,retrunRes );
            }
        });
        $A.enqueueAction(action);
    }

})