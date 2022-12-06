({
    doInit : function(component) {
        var device = $A.get("$Browser.formFactor");
        window.addEventListener('resize', $A.getCallback(function(){
            if(component.isValid()) {
                if(document.documentElement.clientWidth <= 1000){
                    //component.set("v.isRowsIcon",true);
                    component.set("v.screenType",'PHONE')  
                    component.set("v.contextBarCss",'');
                    component.set("v.navBarCss",'slds-nav-vertical');
                    component.set("v.ulDivCss",'slds-nav-vertical__section');
                }else{
                    component.set("v.isRowsIcon",false);
                    component.set("v.screenType",'DESKTOP')
                    component.set("v.contextBarCss",'slds-context-bar');
                    component.set("v.navBarCss",'slds-context-bar__secondary');
                    component.set("v.contextBarCss",'slds-context-bar');
                }
            }
        }));
        console.log('do init');
        component.set("v.screenType",device)
        if(device == 'PHONE' || device == 'TABLET'){
            component.set("v.isRowsIcon",true);
            component.set("v.navBarCss",'slds-nav-vertical');
            component.set("v.ulDivCss",'slds-nav-vertical__section');
        }else{
            component.set("v.isRowsIcon",false);
            component.set("v.navBarCss",'slds-context-bar__secondary');
            component.set("v.contextBarCss",'slds-context-bar');
        }
        //alert("You are using a " + device);
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.menuData");
        // action.setParams({ firstName : cmp.get("v.firstName") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("From server: ", response.getReturnValue());
                component.set('v.menus',response.getReturnValue())
                
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
                            console.log("Error message: " , 
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
    
    shorcutcalled : function(component,event) {
        var showTab=component.find('changeItnew');
        console.log('v.showTab',showTab);
        $A.util.removeClass(showTab,'slds-is-open')
        var action = component.get("c.childShortcuts");
        action.setParams({ 'shorcutSelc' :  event.getParam('shortcutVal')});
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state',state)
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("From server: ", response.getReturnValue());
                component.set('v.shortCutList',response.getReturnValue())
                //component.set('v.menus',response.getReturnValue())
                
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
                            console.log("Error message: " , 
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
    
    openOrClose :  function(component) {
        // console.log('Called!')
        var showTab=component.find('changeItnew');
        // console.log('v.showTab',showTab);
        $A.util.toggleClass(showTab,'slds-is-open')
    },
    
    focusOut : function(component, event, helper) {
        // console.log('HELL!');
        var showTab=component.find('changeItnew');
        $A.util.removeClass(showTab,'slds-is-open');
    },
    showNavigation: function(component, event, helper) {
          component.set('v.isRowsIcon',false)
    },
    hideNavigation: function(component, event, helper) {
          component.set('v.isRowsIcon',true)
    },
    
    menuURL: function(component, event, helper) {
         var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        console.log('data Name = ', Name);
        if(Name)
        window.open(Name);
    }
})