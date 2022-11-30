({
	
	saveRec : function(component, event, helper) {

    var action = component.get("c.getCMERequestId");    
    var rId = component.get("v.recordId");

    console.log(rId);

    action.setParams({
        "cmid":rId
    });
    action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
        });
    // Queue this action to send to the server
    $A.enqueueAction(action);
},


handleCancel: function(component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
}
})