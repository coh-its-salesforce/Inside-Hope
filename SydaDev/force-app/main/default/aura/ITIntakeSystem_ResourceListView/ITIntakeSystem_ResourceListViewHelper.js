/*({
       getResourceRecord : function( component ) {
       var action = component.get("c.getITRecs");
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
            component.set("v.ResLst", response.getReturnValue());   
        });
        $A.enqueueAction(action);
   }
})*/

({
	getResourceRecord : function(component, helper) {
		var rId = component.get("v.recordId");
        var ITRecAction = component.get("c.getITRecs"); 
        ITRecAction.setParams({
            "recordId":rId
        });
        ITRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITRRecs",ITProjectIntakeInfo);
            }
        });
        $A.enqueueAction(ITRecAction);
	}
})