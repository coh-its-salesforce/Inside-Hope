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
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }
})