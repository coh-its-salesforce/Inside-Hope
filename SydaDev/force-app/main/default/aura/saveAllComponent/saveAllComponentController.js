({
	
    saveAll: function (component) {
         component.set('v.spinner',true);
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.publishEvent");
        action.setParams({ recordId : component.get("v.recordId") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var timer = component.get('v.timer');
                clearTimeout(timer);
                
                var timer = setTimeout(function(){
                    component.set('v.spinner',false);
                    clearTimeout(timer);
                    component.set('v.timer', null);
                }, 20000);
                
                component.set('v.timer', timer);
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
    },
    
    saveAllAppEvent : function(cmp, event,helper) { 
        //Get the event using event name. 
        var appEvent = $A.get("e.c:callSaveAll"); 
        //Set event attribute value
        appEvent.setParams({"message" : "Welcome"}); 
        appEvent.fire(); 
    }
    
})