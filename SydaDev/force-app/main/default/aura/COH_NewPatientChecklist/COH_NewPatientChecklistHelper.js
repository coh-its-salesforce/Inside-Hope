({
    getCaseObjectClient : function(component) {
        var action = component.get('c.getCaseObjectServer');
        var recordId = component.get('v.recordId');       
        action.setParams({recordId:  recordId});
        action.setCallback(this, function(response) {
            console.log('CASE RECORD',response.getReturnValue().Case)
            component.set('v.mCase', response.getReturnValue().Case);
            component.set('v.mCaseLoaded', true);
        });
        $A.enqueueAction(action);
    },
})