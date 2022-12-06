({
    /*
     * Method called when the Record Edit Form is done loading
     */ 
    onRecordEditFormLoad : function(component, event, helper) {
        component.set('v.mLoading', false);
    },
    
    /*
     * Method called to handle the init event for the component
     */ 
    init : function(component, event, helper) {
        helper.initCOHCaseProcurementTabClient(component);
    },
    
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the "Procurement_Tab_Complete__c" field and then resubmits
     */ 
    saveProcurementClick : function(component, event, helper) {
		event.preventDefault();
        helper.saveProcurementTabServer(component, event, helper);
    },
    
    /*
     * Method called when the Record edit form successfully submits a record
     */ 
    onSuccess : function(component, event, helper) {
        helper.showToast();
        $A.get('e.force:refreshView').fire();
    }
    
})