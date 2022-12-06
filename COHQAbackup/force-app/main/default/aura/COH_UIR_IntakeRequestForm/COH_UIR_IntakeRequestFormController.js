({
    /*
     * Method called when the page is loaded, calls helper methods to setup AJAX calls to the server controller.
     */ 
	init : function(component, event, helper) {
        helper.getPicklistsClient(component, event, helper);
        helper.getRecordClient(component, event, helper);        
	},
    
    /*
     * Method called when the Submit Request button is clicked.
     * Checks the validitiy of the fields, checkboxGroups must be checked seperately because they do not have a validity attribute, or a showHelperMessageIfInvalid methond
     * If all inputs are valid, then call the helper method to make an AJAX request to the server controller.
     */ 
    submitRequestClick: function(component, event, helper) {
        var clickedBtn = event.getSource();
        clickedBtn.set('v.disabled', true);
        var validChildComponents = true;
        var childComponents = component.find('childComponent');
        var validInputItems = component.find('intakeRequestForm');
        var validCheckboxGroups = component.find('intakeRequestFormCheckboxGroup');
        var validity = true;
        
        if(validInputItems) {
            validity = validInputItems.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true) && validity;
        }
        
        if(validCheckboxGroups) {
            validity = validCheckboxGroups.reduce(function (validSoFar, inputCmp) {
                if (!inputCmp.checkValidity()) {
                    $A.util.addClass(inputCmp, 'slds-has-error');
                }
                return validSoFar && inputCmp.checkValidity();
            }, true) && validity;
        }

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
    
    /*
     * Method called when a checkboxGroup component is changed. Checks to see if the component that called the function has the CSS class 'slds-has-error'. If it does, then the class is removed
     * This is to remove the class when it is set from the submitRequestClick function. If the field is required, and the value is updated to have NO selected items, then the component's built in error
     * handling will handle adding/removing the class.
     */ 
    clearCheckboxGroupErrorMessage: function (component, event, helper) {
        var focusedItem = event.getSource();
        var sourceName = event.getSource().get('v.name');
        var sourceValues = event.getSource().get('v.value');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        var componentToSet = 'v.mSelectedCheckboxGroupValues.' + sourceName;
        
        if ($A.util.hasClass(focusedItem, 'slds-has-error')) {
            $A.util.removeClass(focusedItem, 'slds-has-error');
        }
        component.set(componentToSet, checkboxGroupHelper.createJSONStringFromGroupboxValue(sourceValues));             
        
/*        
        
        var focusedItem = event.getSource();
        var sourceName = event.getSource().get('v.name');
        
        if ($A.util.hasClass(focusedItem, 'slds-has-error')) {
            $A.util.removeClass(focusedItem, 'slds-has-error');
        }

        if(sourceName === 'COH_UIR_SHR_RequestType__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_RequestType__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedRequestTypes', jsonString);    
        }
        else if(sourceName == 'COH_UIR_SHR_ProjectEquipmentOPEXLabor__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedProjectEquipmentOPEXLabor', jsonString);
        }
        else if(sourceName == 'COH_UIR_SHR_SupportDepartments__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartments__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedSupportDepartments', jsonString);
        }
        else if(sourceName == 'COH_UIR_SHR_SupportDepartmentsOther__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartmentsOther__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedSupportDepartmentsOther', jsonString);
        } 
        else if(sourceName == 'COH_UIR_SHR_StrategicInitiative__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_StrategicInitiative__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedStrategicInitiativeOther', jsonString);
        }
        else if(sourceName == 'COH_UIR_SHR_ELTSponsor__c') {
            var checkboxValues = component.get('v.mCheckboxGroupValues.COH_UIR_SHR_ELTSponsor__c');
            var jsonString = helper.createJSONStringFromGroupboxValue(checkboxValues);
            component.set('v.mSelectedELTSponsor', jsonString);
        }
*/
    },
        
    /*
     * This method is used to toggle the visibility of the alternative options sections
     */ 
    toggleAlternativeOption : function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var alternatives = component.get("v.mShowAlternatives");
        alternatives[index] = !alternatives[index];
        component.set("v.mShowAlternatives", alternatives);
    },
    
    updateRequestName : function(component, event, helper) {
        var requestName = event.getSource().get('v.value');
        component.set('v.mIntakeRequest.COH_UIR_ITS_ProposedRequestName__c', requestName);
    }
})