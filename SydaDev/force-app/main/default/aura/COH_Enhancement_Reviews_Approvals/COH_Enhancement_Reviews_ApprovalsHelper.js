({
	loadData : function(component, event, helper) {
		var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getSummaryRecords"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMRecs",ITProjectIntakeInfo);
            }
           // else if(Res.getState() == "ERROR"){
           // }
        });
        $A.enqueueAction(ITPMRecAction);
	}
})