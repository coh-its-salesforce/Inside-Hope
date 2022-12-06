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
                component.set("v.mCheckboxGroupValues.Export_Administration_Regulations__c", COH_Util_CheckboxGroupHelper.multipleSelectPicklistToJSONArray(returnValue.Export_Administration_Regulations__c));
                component.set("v.mCheckboxGroupValues.International_Traffic_in_Arms_Regulation__c", COH_Util_CheckboxGroupHelper.multipleSelectPicklistToJSONArray(returnValue.International_Traffic_in_Arms_Regulation__c));
                component.set("v.mCheckboxGroupValues.Research_made_publicly_available__c", COH_Util_CheckboxGroupHelper.multipleSelectPicklistToJSONArray(returnValue.Research_made_publicly_available__c));
                component.set("v.mCheckboxGroupValues.Access_knowledge_technology_for_purposes__c", COH_Util_CheckboxGroupHelper.multipleSelectPicklistToJSONArray(returnValue.Access_knowledge_technology_for_purposes__c));
                component.set("v.mVisaRecord", returnValue);  
                component.set("v.mLoading", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getPicklistsClient: function(component) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'section' : 'Section Six' });
        
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
        
        visaRecord.Export_Administration_Regulations__c = COH_Util_CheckboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupValues.Export_Administration_Regulations__c);
        visaRecord.International_Traffic_in_Arms_Regulation__c = COH_Util_CheckboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupValues.International_Traffic_in_Arms_Regulation__c);
        visaRecord.Research_made_publicly_available__c = COH_Util_CheckboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupValues.Research_made_publicly_available__c);
        visaRecord.Access_knowledge_technology_for_purposes__c = COH_Util_CheckboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupValues.Access_knowledge_technology_for_purposes__c);
        
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
            else if (state === 'ERROR') {
                var errors = response.getError();
                helper.handleError(errors[0].message);                
            }            
            component.find('submitBtn').set('v.disabled', false);
        });
        $A.enqueueAction(action);
    },
    
    getFormValidity : function (component, showErrorMessages) {
        var validInputItems = component.find('sectionSixFormInput').reduce(function (validSoFar, inputCmp) {
            if (showErrorMessages) {
                inputCmp.showHelpMessageIfInvalid();
            }
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        var validCheckboxGroups = component.find('sectionSixFormCheckboxGroup').reduce(function (validSoFar, inputCmp) {
            if (!inputCmp.checkValidity() && showErrorMessages) {
                $A.util.addClass(inputCmp, 'slds-has-error');
            }
            return validSoFar && inputCmp.checkValidity();
        }, true);        
        
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