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
                var Internal_capexHrs=component.get("v.ITPMObj.ITS_Intake_Request__r.Approved_Total_Hours__c");
                var Internal_opexHrs=component.get("v.ITPMObj.ITS_Intake_Request__r.Approved_Internal_IT_Labor_Hours_Year_1__c");
                var External_capexHrs=component.get("v.ITPMObj.ITS_Intake_Request__r.Approved_External_IT_Labor_Hours_Year1C__c");
                var External_opexHrs=component.get("v.ITPMObj.ITS_Intake_Request__r.Approved_External_ITS_Hours__c");
                 if(Internal_capexHrs==null){
                    Internal_capexHrs=0;
                }
                if(Internal_opexHrs==null){
                    Internal_opexHrs=0;
                }
                if(Internal_capexHrs==null && Internal_opexHrs==null){
                        Internal_capexHrs=0;
                        Internal_opexHrs=0;
                    }
                 if(External_capexHrs==null){
                    External_capexHrs=0;
                }
                if(External_opexHrs==null){
                    External_opexHrs=0;
                }
                if(External_capexHrs==null && External_opexHrs==null){
                        External_capexHrs=0;
                        External_opexHrs=0;
                    }
                component.set("v.IHrs",Internal_capexHrs+Internal_opexHrs);
                component.set("v.EHrs",External_capexHrs+External_opexHrs);
               
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }
})