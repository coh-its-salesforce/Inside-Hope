({
    init : function(component, event, helper) {
        helper.initClient(component, helper);  
    },
    
    onDepartmentChange : function(component, event, helper) {
    	helper.getServiceLineValuesClient(component, helper);
    },
    
    onServiceLineChange : function(component, event, helper) {
        helper.getSpecialtyValuesClient(component, helper);
    },
    
    onSpecialtyChange : function(component, event, helper) {
    	helper.getPhysiciansClient(component, helper);
    },
    
    saveButtonClicked : function(component,event,helper) {
      	helper.saveCOHCasePhysicianTabClient(component, helper);
    },
})