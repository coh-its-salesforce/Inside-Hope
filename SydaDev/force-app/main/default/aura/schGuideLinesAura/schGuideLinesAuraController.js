({
    handleNoValidation : function(component, event, helper) {

        var appEvent = $A.get("e.c:announceErrors"); 
        appEvent.setParams({"message" : 'Error',
                            "formName" : 'SCH Guidelines'}); 
        appEvent.fire(); 
       // helper.showToast("Patient Appointment Information Saved", "error", "The record has been updated successfully.");
                   
    },
    handleError : function(component, event, helper) {
        var appEvent = $A.get("e.c:announceErrors"); 
        appEvent.setParams({"message" : 'Please fill all Information on SCH Guidelines',
                            "formName" : 'SCH Guidelines'}); 
        appEvent.fire(); 
        helper.showToast("Patient Appointment Information Not Saved", "error", "Please fill all Information on SCH Guidelines");
    },
    
    init : function (component, event, helper) {
       var appEvent = $A.get("e.c:initCount"); 
        appEvent.fire(); 
    },
    
})