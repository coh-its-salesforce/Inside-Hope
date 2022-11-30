({
    
	doInit : function(component,event,helper) {                        
        helper.loadData(component, helper);
        helper.displayButton(component, helper);
    },
    handleEdit: function(component,event,helper){
        component.set("v.isEdit", true);
    },
    handleCancel: function(component,event,helper){
        component.set("v.isEdit", false);
    },
    handleSuccess: function(component,event,helper){
        var parentId = component.get("v.parentId");
        
        
        helper.loadData(component, helper);
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
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
      
})