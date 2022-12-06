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
                var user_Id=component.get("v.ITPMObj.ITS_Intake_Request__r.Business_Owner__c");
                var alink2='https://cityofhope--intakedev.lightning.force.com/lightning/r/User/'+user_Id+'/view';
                component.set("v.link2",alink2);
                var user_Id1=component.get("v.ITPMObj.ITS_Intake_Request__r.Business_Sponsor__r.Name");
                var alink1='https://cityofhope--intakedev.lightning.force.com/lightning/r/User/'+user_Id1+'/view';
                component.set("v.link3",alink1);
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }
})