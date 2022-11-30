({
	doInit : function(component, event, helper) {
		var action = component.get("c.getPageContent"); 
        var pName = component.get("v.pageName");
        console.log('=====pName==='+pName);
        action.setParams( {'pageName':pName});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.content" ,retrunRes );
            }
        });
        $A.enqueueAction(action);
    }
})