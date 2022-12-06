({ 

 
    handleEdit: function(component){
        component.set("v.viewScreen",false);
        component.set("v.editScreen",true);
    },
     
	handleSubmit : function(component, event, helper) { 
        event.preventDefault();
        var fields = event.getParam("fields"); 
		component.find('createITPMForm').submit(fields); // Submit form 
        component.set("v.editScreen",false);
        component.set("v.viewScreen",true); 
        
    },
    handleSuccess: function(cmp, event, helper) {
        
    },
    handleLoad: function(cmp, event, helper) {
        
    },
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
               
                var sharePURL=component.get("v.ITPMObj.Sharepoint_URL__c");
                var alink1=sharePURL;
                component.set("v.link1",alink1);
                //alert(sharePURL);
                
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }
    
      
})