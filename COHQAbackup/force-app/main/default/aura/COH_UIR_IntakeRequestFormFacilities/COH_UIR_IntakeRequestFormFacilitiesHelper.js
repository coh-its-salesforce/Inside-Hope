({
    getPicklistsClient: function(component) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'Facilities Request' });
        
        action.setCallback(this, function(response) {
            component.set("v.mPicklists", JSON.parse(response.getReturnValue()));
        });
        $A.enqueueAction(action);
    },
    
    setupCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');        
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_MoveOrNewHires__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_MoveOrNewHires__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_ME_MoveRequirements__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_ME_MoveRequirements__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_NH_RelatedItems__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_NH_RelatedItems__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_ProgramItems__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_ProgramItems__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_ReconfigGoals__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_ReconfigGoals__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestFurnitureArtwork__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_SubRequestFurnitureArtwork__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureClinic__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_DesiredFurnitureClinic__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureOffice__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_DesiredFurnitureOffice__c')));
        component.set('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestSpacePlanning__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mIntakeRequest.COH_UIR_FSC_SubRequestSpacePlanning__c')));
        
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_MoveOrNewHires__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_MoveOrNewHires__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_ME_MoveRequirements__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ME_MoveRequirements__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_NH_RelatedItems__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_NH_RelatedItems__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_ProgramItems__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ProgramItems__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_ReconfigGoals__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ReconfigGoals__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_SubRequestFurnitureArtwork__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestFurnitureArtwork__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureClinic__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureClinic__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureOffice__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureOffice__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_UIR_FSC_SubRequestSpacePlanning__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestSpacePlanning__c')));        
    },
    
    saveCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        component.set('v.mIntakeRequest.COH_UIR_FSC_MoveOrNewHires__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_MoveOrNewHires__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_ME_MoveRequirements__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ME_MoveRequirements__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_NH_RelatedItems__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_NH_RelatedItems__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_ProgramItems__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ProgramItems__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_ReconfigGoals__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_ReconfigGoals__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_SubRequestFurnitureArtwork__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestFurnitureArtwork__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_DesiredFurnitureClinic__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureClinic__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_DesiredFurnitureOffice__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_DesiredFurnitureOffice__c')));
        component.set('v.mIntakeRequest.COH_UIR_FSC_SubRequestSpacePlanning__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_UIR_FSC_SubRequestSpacePlanning__c')));
    }
})