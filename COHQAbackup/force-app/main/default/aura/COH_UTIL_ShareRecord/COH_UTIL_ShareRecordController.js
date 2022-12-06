({
    /*
     * Method called when the component init event is fired 
     */ 
    init : function(component, event, helper) {
        helper.getDefaultSharingValuesClient(component, helper);
    },
    
    /*
     * Method called when the "Share" button is clicked
     * Disables the share button until processing is complete
     */ 
    shareBtnClick : function(component, event, helper) {
        component.set('v.mDisableShareBtn', true);
        helper.saveShareRecordClient(component, helper);
    },
    
    /*
     * Method called when the "Cancel" button is clicked
     * Closes the modal
     */ 
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }  
})