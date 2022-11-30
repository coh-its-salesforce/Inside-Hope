({
    updateDependentPicklistOptions : function(component, event, helper) {
        var updatedDependentOptions = component.get('v.mControllingAndDependentOptionsMap');
        var newControllingValue = component.get('v.mControllingPicklistValue');
        if (updatedDependentOptions && newControllingValue) {
            component.set('v.mDependentPicklistOptions', updatedDependentOptions[newControllingValue]);
        }		
	}
})