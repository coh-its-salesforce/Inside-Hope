({
    /*
     * Method called when the page is loaded, calls helper methods to setup AJAX calls to the server controller.
     */     
    init: function(component, event, helper) {
		// Get picklist values
        helper.getPicklistsClient(component, event, helper);
		helper.setupCheckboxGroups(component);
    },
    
    onChange: function(component, event, helper) {
        var focusedItem = event.getSource();
        var sourceName = event.getSource().get('v.name');
        var sourceValues = event.getSource().get('v.value');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        var componentToSet = 'v.mSelectedDepartments.' + sourceName;
        
        if ($A.util.hasClass(focusedItem, 'slds-has-error')) {
            $A.util.removeClass(focusedItem, 'slds-has-error');
        }
        component.set(componentToSet, checkboxGroupHelper.createJSONStringFromGroupboxValue(sourceValues));     
    },
    
    /*
     * This method is called from the parent component when the Submit Request button is clicked
     * Checks the validitiy of the fields
     * 
     * @return boolean validInputItems 			returns true if all fields are valid, otherwise false
     */     
    validateFields: function(component, event, helper) {
        var fieldsToValidate = component.find('intakeRequestForm');
        var validateStandardComponent = component.find('validateStandardComponent');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
		var validity = validateStandardComponent.validateFields(fieldsToValidate)
        
        if (validity) {
            component.set('v.mIntakeRequest.COH_UIR_IRC_WhichDeptsResourcesImpacted__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_IRC_WhichDeptsResourcesImpacted__c')));
        }
        
        return validity;
    },
})