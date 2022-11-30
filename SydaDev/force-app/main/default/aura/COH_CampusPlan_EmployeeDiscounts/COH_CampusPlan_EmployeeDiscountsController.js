({
	goBackToResourceToHelp : function(component, event, helper) {
				  var openRH = component.getEvent("openRivergrade"); 
                  openRH.setParams({"openRivergrade" : true}); 
                  openRH.fire();
	}
})