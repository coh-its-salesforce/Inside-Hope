({
    /*
     * Method called when the page is loaded, calls helper methods to setup AJAX calls to the server controller.
     */     
    init: function(component, event, helper) {
		helper.getPicklistsClient(component, event, helper);
    },
    
    /*
     * This method is called from the parent component when the Submit Request button is clicked
     * Checks the validitiy of the fields
     * 
     * @return boolean validInputItems 			returns true if all fields are valid, otherwise false
     */     
    validateFields: function(component, event, helper) {
        var inputItems = component.find('intakeRequestFormLabor');
        var isValidInput = false;       
        
        if (inputItems) {            
            if ($A.util.isArray(inputItems)) {
                isValidInput = inputItems.reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && inputCmp.get('v.validity').valid;                        
                }, true);
            }
            else {
                inputItems.showHelpMessageIfInvalid();
                isValidInput = inputItems.get('v.validity').valid;                    
            }
        }
                
        return isValidInput;
    }    
})