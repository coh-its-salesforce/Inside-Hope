({
    /*
     * This method gets the record from the server side controller.
     */ 
    getRecordClient : function(component, event, helper) {
        var action = component.get("c.getRecordServer");
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        action.setParams({recordId : component.get("v.recordId")});
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === 'SUCCESS') { 
            	var intakeRequest = result.getReturnValue();
                //Temp while FY 19 is going on and the rest of the UIR is not available
               	intakeRequest.COH_UIR_SHR_IsBudgetPlanningRequest__c = 'Yes';
                
                component.set("v.mIntakeRequest", intakeRequest);
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_RequestType__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_RequestType__c)); 
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_StrategicInitiative__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_StrategicInitiative__c));
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_ELTSponsor__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_ELTSponsor__c));
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c));
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartments__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_SupportDepartments__c));
                component.set('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartmentsOther__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(intakeRequest.COH_UIR_SHR_SupportDepartmentsOther__c));
                                        
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_RequestType__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_RequestType__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_StrategicInitiative__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_StrategicInitiative__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_ELTSponsor__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_ELTSponsor__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_SupportDepartments__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartments__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_UIR_SHR_SupportDepartmentsOther__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_SHR_SupportDepartmentsOther__c')));
            }
            else if (state === 'ERROR') {
                helper.handleError(result.getError());
            }
            component.set('v.mRecordLoaded', true);
        });
        $A.enqueueAction(action);
    },
    
    /*
     * 
     */ 
    saveRequestClient: function(component, event, helper) {
        // First have to change checkboxgroups into comma delimited groups
        var checkboxGroupMap = component.get('v.mCheckboxGroupValues');
        var intakeRequest =  component.get('v.mIntakeRequest');
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        var clickedBtn = event.getSource();

        intakeRequest.COH_UIR_SHR_RequestType__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_RequestType__c);
        intakeRequest.COH_UIR_SHR_StrategicInitiative__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_StrategicInitiative__c);
        intakeRequest.COH_UIR_SHR_ELTSponsor__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_ELTSponsor__c);
        intakeRequest.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_ProjectEquipmentOPEXLabor__c);
        intakeRequest.COH_UIR_SHR_SupportDepartments__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_SupportDepartments__c);
        intakeRequest.COH_UIR_SHR_SupportDepartmentsOther__c = checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(checkboxGroupMap.COH_UIR_SHR_SupportDepartmentsOther__c);
        
        var action = component.get("c.saveRequestServer");
        action.setParams({ requestToSave: intakeRequest });
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success\n",
                    "message": "Request saved successfully",
                    "type": "success"
                });
                toastEvent.fire();                
            }
            else if (state === "ERROR") {
                var errors = result.getError();
                helper.handleError(errors[0].message);
            }
            clickedBtn.set('v.disabled', false);
        });
        $A.enqueueAction(action);        
    },    
    
    /*
     * This method gets the picklist values for the Project Information section of the form
     */ 
    getPicklistsClient: function(component, event, helper) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'Project Information' });
        
        action.setCallback(this, function(result) {
            component.set("v.mPicklists", JSON.parse(result.getReturnValue()));
        });
        $A.enqueueAction(action);        
    },
    
    /*
     * This method displays the errors returned by the server side controller.
     */
    handleError: function(errorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error" + "\n",
            "message": errorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
    
    onScroll :function (header, sticky) {
        if (window.pageYOffset >= sticky) {
            header.classList.add("sticky");
        } 
        else {
            header.classList.remove("sticky");
        }
    }    
})