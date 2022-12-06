({
	init : function(component, event, helper) {
		helper.getRecordClient(component);
        helper.getPicklistsClient(component);
	},
    
    onSubmitBtnClick : function(component, event, helper) {
        var submitBtn = component.find('submitBtn').set('v.disabled', true);
        if (helper.getFormValidity(component, true)) {
            helper.saveSectionClient(component, helper);
        }
        else {
            component.find('submitBtn').set('v.disabled', false);
            component.set("v.mShowErrorMessage", true);
        }
    },
    
    onRequiredFieldUpdate : function (component, event, helper) {
        if (helper.getFormValidity(component, false)) {
            component.set("v.mShowErrorMessage", false);
        }
    }
})