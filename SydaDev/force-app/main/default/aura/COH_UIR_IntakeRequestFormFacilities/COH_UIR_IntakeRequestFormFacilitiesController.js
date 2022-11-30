({
    init : function(component, event, helper) {
        helper.getPicklistsClient(component);
        helper.setupCheckboxGroups(component);
    },
    
    validateFields : function(component, event, helper) {
        var fieldsToValidate = component.find('intakeRequestForm');
        var validateStandardComponent = component.find('validateStandardComponent');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
		var validity = validateStandardComponent.validateFields(fieldsToValidate);
        
        if (validity) {
            helper.saveCheckboxGroups(component);            
        }
        
        return validity;
    },
    
    onCheckboxGroupChange : function(component, event, helper) {
        var focusedItem = event.getSource();
        var sourceName = event.getSource().get('v.name');
        var sourceValues = event.getSource().get('v.value');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        var componentToSet = 'v.mSelectedCheckboxGroupValues.' + sourceName;
        
        if ($A.util.hasClass(focusedItem, 'slds-has-error')) {
            $A.util.removeClass(focusedItem, 'slds-has-error');
        }
        component.set(componentToSet, checkboxGroupHelper.createJSONStringFromGroupboxValue(sourceValues));
    }
})