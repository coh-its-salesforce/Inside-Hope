({
   
    toggleClass: function(component, event, helper) { 
        console.debug('##inside toggle');
        var cmpTarget = component.find('favObj');
        var favlinkTarget = component.find('linksPallet');
        $A.util.toggleClass(cmpTarget, 'sidenavTest');
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
            "url":"https://cityofhope--dxinsidhpe--c.visualforce.com/apex/Favourite" 
        }); 
        urlEvent.fire(); 
    }
 
 })