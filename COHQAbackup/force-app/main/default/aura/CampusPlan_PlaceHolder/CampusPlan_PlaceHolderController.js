({
	parkingLots : function(component, event, helper) {
        var action = component.get("c.getParkingInfo"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.ParkingWrap" ,retrunRes );
            }
        });
        $A.enqueueAction(action);
	}
})