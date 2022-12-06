({
	/* loadData : function(component, helper) {
		var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITIntakeInfo=Res.getReturnValue();
                component.set("v.ITIntakeRecs",ITIntakeInfo);
            }
        });
        $A.enqueueAction(ITPMRecAction);
	} */
})