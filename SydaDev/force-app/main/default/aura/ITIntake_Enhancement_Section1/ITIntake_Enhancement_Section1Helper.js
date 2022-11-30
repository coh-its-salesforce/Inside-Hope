({
	loadData : function(component, helper) {
		var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITIntakeInfo=Res.getReturnValue();
                component.set("v.ITIntakeRecs",ITIntakeInfo);
                var UId1=component.get("v.ITIntakeRecs.Requester_Name__c");
                var alink1='/lightning/r/User/'+UId1+'/view';
                component.set("v.link1",alink1);
            }
        });
        $A.enqueueAction(ITPMRecAction);
	}
})