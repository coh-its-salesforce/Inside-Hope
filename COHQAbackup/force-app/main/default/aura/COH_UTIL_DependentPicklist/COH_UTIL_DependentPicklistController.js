({
	init : function(component, event, helper) {
		var action = component.get('c.getPicklistOptionsServer');
        var controllingPicklistValue = component.get('v.mControllingPicklistValue');
        if (controllingPicklistValue) {
            component.set('v.mPreviousControllingPicklistValue', controllingPicklistValue);
        }        

        action.setParams({
            "sObjectAPIName": component.get('v.mSObjectAPIName'),
            "controllingFieldAPIName": component.get('v.mControllingFieldAPIName'),
            "dependentFieldAPIName": component.get('v.mDependentFieldAPIName')
        });
        action.setCallback(this, function(response) {
            component.set('v.mControllingAndDependentOptionsMap', response.getReturnValue());
            helper.updateDependentPicklistOptions(component, event, helper);
        });
        $A.enqueueAction(action); 
	},
    
    updateControllingPicklistValue: function(component, event, helper) {
        var oldValue = component.get('v.mPreviousControllingPicklistValue');
        var newValue = component.get('v.mControllingPicklistValue');
        
        if (newValue != oldValue){                     
            component.set('v.mControllingPicklistValue', newValue);
            helper.updateDependentPicklistOptions(component, event, helper);
            component.set('v.mDependentPicklistValue', '');
			component.set('v.mPreviousControllingPicklistValue', newValue);                     
        }                       
    },    
    
    validateFields: function(component, event, helper) {
        var inputItems = component.find('dependentPicklist');
        var isValidInput = false;               
    
        inputItems.showHelpMessageIfInvalid();
        isValidInput = inputItems.get('v.validity').valid;
                
        return isValidInput;
    }
})