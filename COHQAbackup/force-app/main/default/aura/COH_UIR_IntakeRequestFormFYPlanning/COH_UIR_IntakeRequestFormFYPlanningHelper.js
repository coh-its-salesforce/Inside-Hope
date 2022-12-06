({
    getPicklistsClient: function(component) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'FY Planning Request' });
        
        action.setCallback(this, function(response) {
            component.set("v.mPicklists", JSON.parse(response.getReturnValue()));
        });
        $A.enqueueAction(action);
    },
    
    setupCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');        
        component.set('v.mCheckboxGroupValues.COH_UIR_FY_StrategicInitiative__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FY_StrategicInitiative__c')));        
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FY_StrategicInitiative__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FY_StrategicInitiative__c')));       
    },
    
    saveCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        component.set('v.mIntakeRequest.COH_UIR_FY_StrategicInitiative__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FY_StrategicInitiative__c')));
    },
    
    /*
     * Lightning:textareas are having some side effect when the sObject they are related to is created in APEX and no default value is set
     * They are being populated with "undefined" when a lookup field is updated. This is a work around until the issue with the lookup fields
     * can be addressed
     */ 
    setupTextareas  : function (component) {
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_ProblemStatement__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_ProblemStatement__c', '');
        }
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_Scope__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_Scope__c', '');
        }
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_ImpactedDepartments__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_ImpactedDepartments__c', '');
        }
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_RequestedCapitalAmount__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_RequestedCapitalAmount__c', '');
        }
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_RequestedOPEXAmount__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_RequestedOPEXAmount__c', '');
        }
        if (!component.get('v.mIntakeRequest.COH_UIR_FY_ImpactConnectHopeDetail__c')) {
            component.set('v.mIntakeRequest.COH_UIR_FY_ImpactConnectHopeDetail__c', '');
        }
    }    
})