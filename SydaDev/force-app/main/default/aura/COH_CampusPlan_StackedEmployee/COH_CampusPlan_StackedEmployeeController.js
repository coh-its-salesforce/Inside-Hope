({
	goBackToResourceToHelp : function(component, event, helper) {
				  var openRH = component.getEvent("openResourcestoHelp"); 
                  openRH.setParams({"openResourcestoHelp" : true}); 
                  openRH.fire();
	}
})