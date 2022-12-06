({
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
        var inputItems = component.find('intakeRequestFormITS');
        var childComponents = component.find('intakeRequestFormChildComponent');
        var isValidInput = false;
        var isValidChildComponents = false;
        
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
        
        if (childComponents) { 
            if ($A.util.isArray(childComponents)) {
                isValidChildComponents = childComponents.reduce(function (validSoFar, inputCmp) {
                    return inputCmp.validateFields() && validSoFar;
                }, true);
            }
            else {
                isValidChildComponents = childComponents.validateFields();
            }        
        }
                
        return isValidInput && isValidChildComponents;
    }
})