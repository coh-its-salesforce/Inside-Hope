({
	doInit : function(component, event, helper) {
		 var device = $A.get("$Browser.formFactor");
        
        //var isTablet = $A.get("$Browser.isTablet");
       // component.set("v.isTablet",isTablet);
        console.log('device',device)
        if(device == 'DESKTOP') {
        	component.set("v.isDesktop",true);    
        }else{
            component.set("v.isMobile",true);    
        }
	}
})