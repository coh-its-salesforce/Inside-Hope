({
    getPicklistsClient: function(component, event, helper) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'Resource Involvement' });
        
        action.setCallback(this, function(a) {
            component.set("v.mPicklists", JSON.parse(a.getReturnValue()));
        });
        $A.enqueueAction(action);        
    },
    
    setupCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');        
        component.set('v.mCheckboxGroupValues.COH_UIR_IRC_WhichDeptsResourcesImpacted__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_IRC_WhichDeptsResourcesImpacted__c')));
        component.set('v.mSelectedDepartments.COH_UIR_IRC_WhichDeptsResourcesImpacted__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_IRC_WhichDeptsResourcesImpacted__c')));
    },        
    
})