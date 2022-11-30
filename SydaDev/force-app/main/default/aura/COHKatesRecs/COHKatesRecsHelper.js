({
    getCaseObjectClient : function(component) {
        var action = component.get('c.getCaseObjectServer');
        var recordId = component.get('v.recordId');
        
        action.setParams({recordId:  recordId});
        action.setCallback(this, function(response) {
            component.set('v.mCase', response.getReturnValue().Case);
            if (response.getReturnValue().DaysSinceLastAuthStatusUpdate < 7) {
             	component.set('v.mAuthChanged', true);   
            }
            component.set('v.mCaseLoaded', true);
        });
        $A.enqueueAction(action);
    },
})