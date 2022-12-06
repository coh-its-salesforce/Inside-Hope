({
    doInit : function(cmp,event,helper) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.carousel");
       // action.setParams({ firstName : cmp.get("v.firstName") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('CAROUSEL',response.getReturnValue())
                cmp.set('v.carouselList',response.getReturnValue())
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
                //helper.showSlides(cmp,0,helper);
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
    currentSlide1: function(cmp,event,helper){
        helper.showSlides(cmp,0,helper);
    },
    currentSlide2: function(cmp,event,helper){
        helper.showSlides(cmp,1,helper);
    },
    currentSlide3: function(cmp,event,helper){
        helper.showSlides(cmp,2,helper);
    },
    currentSlide4: function(cmp,event,helper){
        helper.showSlides(cmp,3,helper);
    },
    currentSlide5: function(cmp,event,helper){
        helper.showSlides(cmp,4,helper);
    },
    currentSlide6: function(cmp,event,helper){
        helper.showSlides(cmp,5,helper);
    }
})