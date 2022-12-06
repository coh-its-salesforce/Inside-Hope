({
    init : function(component, event, helper) {
        var investmentCategoryHelp = 'Maintenance \n• Keep the lights on \n• Compliance \n\nIncremental Improvement \n• Continuous process improvement \n• Efficiency \n\nStrategic \n• New revenue stream \n• Significant external exposure \n\nOption Creation \n• Fail fast \n• New business model';
        
        helper.getPicklistsClient(component);
        helper.setupCheckboxGroups(component);
        helper.setupTextareas(component);
        component.set("v.mHelpText.COH_UIR_FY_InvestmentCategory__c", investmentCategoryHelp);        
    },
    
    validateFields : function(component, event, helper) {
        var fieldsToValidate = component.find('intakeRequestForm');
        var validateStandardComponent = component.find('validateStandardComponent');
        var childComponents = component.find('childComponent');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
		var validity = validateStandardComponent.validateFields(fieldsToValidate);
        
        if (childComponents) {
            if ($A.util.isArray(childComponents)) {
                validity = childComponents.reduce(function (validSoFar, inputCmp) {
                    return inputCmp.validateFields() && validSoFar;
                }, true) && validity;
            }
            else {
                validity = childComponents.validateFields() && validity;
            }
        }        

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