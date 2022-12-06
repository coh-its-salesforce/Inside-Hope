({
	doInit : function(component, event, helper) {
		var action = component.get("c.getCarouselImages"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.carouselList" ,retrunRes );
            }
        });
        $A.enqueueAction(action);
    },
    onClick : function(component, event, helper) {
        var urlval = event.getSource().get("v.id");
        window.open(urlval, '_blank');
    }
})