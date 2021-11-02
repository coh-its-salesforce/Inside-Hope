({
   
    toggleClass: function(component, event, helper) { 
        console.debug('##inside toggle');
        var cmpTarget = component.find('linkObj');
        //var favlinkTarget = component.find('linksPallet');
        $A.util.toggleClass(cmpTarget, 'sidenavTest');
        //$A.util.toggleClass(favlinkTarget, 'favoriteLink');
        //$A.util.addClass(cmpTarget, 'sidenavTest');
        
        var action = component.get("c.queryMyLinks");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.mylinkLst", response.getReturnValue());           
        });
        $A.enqueueAction(action);
    },    
    handleClick : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL"); 
        urlEvent.setParams({ 
            "url":"https://cityofhope--dxinsidhpe--c.visualforce.com/apex/COH_SIRP_Favorite_News" 
        }); 
        urlEvent.fire(); 
    }
 
 })