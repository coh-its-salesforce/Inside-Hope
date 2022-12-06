({
   
    toggleClass: function(component, event, helper) { 
        console.debug('##inside toggle');
        var cmpTarget = component.find('favObj');
        var favlinkTarget = component.find('linksPallet');
        if(component.get('v.isDesktop')){
            $A.util.toggleClass(cmpTarget, 'sidenavTest');
        }else{
            $A.util.toggleClass(cmpTarget, 'sidenavMobile');
        }
        $A.util.toggleClass(favlinkTarget, 'favoriteLink');
        //$A.util.addClass(cmpTarget, 'sidenavTest');
        
        var action = component.get("c.queryMyFavLinks");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = JSON.stringify(response.getReturnValue());
            console.log('result',JSON.parse(result))
            if (component.isValid() && state === "SUCCESS")
                component.set("v.favLst", response.getReturnValue());
           // $A.util.toggleClass('sidenavTest', component.get("v.favLst"));
        });
        $A.enqueueAction(action);
    },
    
    handleClick : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL"); 
        urlEvent.setParams({ 
            "url":"https://cityofhope--c.na118.visual.force.com/apex/Favourite" 
        }); 
        urlEvent.fire(); 
    },
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