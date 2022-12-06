({
	doInit : function(component, event, helper) {
    	helper.getResourceRecord(component); // Calling Helper method
    },
    handleEdit: function(component,event,helper){
        component.set("v.isEdit", true);
    },
    handleCancel: function(component,event,helper){
        component.set("v.isEdit", false);
    },
    handleSuccess: function(component,event,helper){
        var parentId = component.get("v.parentId");
        
        
        helper.getResourceRecord(component, helper);
        component.set("v.isEdit", false);
        //alert("record saved successfullty.");
        var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({
                        "title": "",
                        "message": "Record updated successfully",
                        "type": "success"
                    });
                toastEvent.fire();
    },
    
    
   handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.ITRRecs.Id")
        });
        navEvt.fire();
    } 
})