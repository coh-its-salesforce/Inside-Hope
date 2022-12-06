({
    getRecordClient : function(component) {
        var action = component.get("c.getRecordServer");
        var recordId = component.get("v.recordId");
        var fieldsUsed = component.get("v.mFieldsUsed");
        var COH_Util_CheckboxGroupHelper = component.find('COH_Util_CheckboxGroupHelper');        
        
        action.setParams({recordId: recordId,fieldsToQuery:fieldsUsed});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.mVisaRecord", returnValue);
                component.set("v.mCheckboxGroupValues.Cultural_Learning_Opportunities__c", COH_Util_CheckboxGroupHelper.multipleSelectPicklistToJSONArray(returnValue.Cultural_Learning_Opportunities__c));
                component.set("v.mLoading", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getPicklistsClient: function(component) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'section' : 'Section Seven' });
        
        action.setCallback(this, function(response) {
            component.set("v.mPicklists", JSON.parse(response.getReturnValue()));
        });
        $A.enqueueAction(action);        
    },
    
    saveSectionClient : function(component, helper) {
        var action = component.get("c.saveSectionServer");
        var visaRecord = component.get("v.mVisaRecord");
        var checkboxGroupValues = component.get("v.mCheckboxGroupValues");
        var COH_Util_CheckboxGroupHelper = component.find('COH_Util_CheckboxGroupHelper');
        
        visaRecord.Cultural_Learning_Opportunities__c = COH_Util_CheckboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupValues.Cultural_Learning_Opportunities__c);
        
        action.setParams({visaRecord: visaRecord});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success\n",
                    "message": "Section saved successfully",
                    "type": "success"
                });
                toastEvent.fire();                
            }
            else if (state === "ERROR") {
                console.log('Error Recieved');
                var errors = response.getError();
                helper.handleError(errors[0].message);                
            }
            
            var submitBtn = component.find('submitBtn').set('v.disabled', false);
        });
        $A.enqueueAction(action);
    },
    
    getFormValidity : function (component, showErrorMessages) {
        var validInputItems = component.find('sectionSevenFormInput').reduce(function (validSoFar, inputCmp) {
            if (showErrorMessages){
                inputCmp.showHelpMessageIfInvalid();
            }
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        var validCheckboxGroups;
        var checkboxGroupCmp = component.find('sectionSevenFormCheckboxGroup');
        if (!checkboxGroupCmp.checkValidity() && showErrorMessages) {
            $A.util.addClass(checkboxGroupCmp, 'slds-has-error');
            
        }
        validCheckboxGroups = checkboxGroupCmp.checkValidity();
           
        return validInputItems && validCheckboxGroups;
    },
    
    /*
     * This method displays the errors returned by the server side controller.
     */
    handleError: function(errorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error\n",
            "message": errorMessage,
            "type": "error"
        });
        toastEvent.fire();
    }    
})