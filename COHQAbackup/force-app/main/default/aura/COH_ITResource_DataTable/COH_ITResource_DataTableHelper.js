({
	loadData : function(component, helper) {
		var rId = component.get("v.recordId");
        var ITResourceAction = component.get("c.getResourceRecords"); 
        ITResourceAction.setParams({
            "recordId":rId
        });
        ITResourceAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITResourceInfo=Res.getReturnValue();
                component.set("v.ITRRecs",ITResourceInfo);
            }
        });
        $A.enqueueAction(ITResourceAction);
	}
})