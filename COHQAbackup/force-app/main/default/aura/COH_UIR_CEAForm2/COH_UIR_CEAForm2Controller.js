({
    init : function(component, event, helper) {
        component.set('v.mRecordLoaded', false);
        helper.getPicklistsClient(component, helper);
        //helper.getRecordClient(component, event, helper);
    },
    
    saveCEAFormClick : function(component, event, helper) {
        var clickedBtn = event.getSource();
        clickedBtn.set('v.disabled', true);        
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
            helper.saveRequestClient(component, event, helper);
        } 
        else {
			clickedBtn.set('v.disabled', false);            
        }
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
        
        if (sourceName==='COH_CEA_RequestType__c'){
            helper.showHideCEAFields(component);
        }
    },
    
    unitCostChange : function(component, event, helper) {
        helper.updateTotalUnitCost(component);
        helper.updateTotalInitialCost(component);
	},
    
    totalCostChange : function(component, event, helper) {
        helper.updateTotalInitialCost(component);
    },
    
    opexCostChange : function(component, event, helper) {
        helper.updateTotalOpexCost(component);
    },
})