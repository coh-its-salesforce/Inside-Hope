({
	
	saveRecOne : function(component, event, helper) {

    var action = component.get("c.getQHERequestIdone");    
    var rId1 = component.get("v.recordId");

    console.log(rId1);

    action.setParams({
        "qhid1":rId1
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


handleCancelOne : function(component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
}
})