({
	init : function(component,event,helper) {                        
        var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getITProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMObj",ITProjectIntakeInfo);
                var UId1=component.get("v.ITPMObj.ITS_Intake_Request__r.Assigned_Technical_Analyst__c");
                var alink1='/lightning/r/User/'+UId1+'/view';
                component.set("v.link1",alink1);
            }
        });                        
        $A.enqueueAction(ITPMRecAction); 
    }
})