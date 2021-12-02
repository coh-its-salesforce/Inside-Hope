({
    doInit : function(component, event, helper) {
        
        var device = $A.get("$Browser.formFactor");
        
        var isTablet = $A.get("$Browser.isTablet");
        component.set("v.isTablet",isTablet);
        
        if(device == 'DESKTOP') {
        	component.set("v.isDesktop",true);    
        }else{
            component.set("v.isMobile",true);    
        }
        
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.showAnnouncement");
        // action.setParams({ firstName : component.get("v.firstName") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("From server: " , response.getReturnValue());
                if(response.getReturnValue().length>0){
                    component.set('v.showAnnouncement',true);
                    
                    component.set('v.Announcement',response.getReturnValue()[0]);
                    var lWidth = window.innerWidth ;//Get the window's width
                    var counter = 0;
                    //The setInterval() method calls a function or 
                    //evaluates an expression at specified intervals (in milliseconds).
                    var dur = component.get('v.Duration');
                    if(dur==undefined||dur==null||dur==''){
                        dur=10;
                    }
                    window.setInterval($A.getCallback(function() { 
                        
                        helper.shiftDiv(component, event,lWidth);
                    } ), dur);
                }else{
                    component.set('v.showAnnouncement',false);
                    component.set('v.Announcement','No Announcement');
                }
                
                
                
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
})