({
	init : function(component, event, helper) {
        component.set('v.mCaseLoaded', false);
        helper.getCaseObjectClient(component);
	}
})