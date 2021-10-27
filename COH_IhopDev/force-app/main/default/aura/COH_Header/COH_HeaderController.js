({
    doInit : function(component, event, helper) {
        
        component.set("v.imageaddr",$A.get("$Label.c.COH_CityofHopeLogo")); 
        component.set("v.imageaddr1",$A.get("$Label.c.COH_TrumbaCalendarLogo")); 
        component.set("v.imageaddrBreakthroughs",$A.get("$Label.c.COH_CityofBreakthroughs"));
        
        
        var device = $A.get("$Browser.formFactor");
        
        var isTablet = $A.get("$Browser.isTablet");
        component.set("v.isTablet",isTablet);
        
        if(device == 'DESKTOP') {
            component.set("v.isDesktop",true);    
        }else{
            component.set("v.isMobile",true);    
        }
        var action = component.get("c.currentUserDetailMethod");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                // console.log('storeResponse',storeResponse)
                if(storeResponse.Persona__c!=null){
                    var innAct = component.get("c.shortCutsDefault");
                    innAct.setParams({ Persona : storeResponse.Persona__c });
                    innAct.setCallback(this, function(a) {
                        var stat = a.getState();
                        //  console.log('stat',stat)
                        if(stat=== "SUCCESS") {
                            var resp = a.getReturnValue();
                            console.log('resp',resp)
                            if(resp!=undefined&&resp!=''&&resp!=null){
                                component.set("v.ShorcutVal",resp.Id);
                                // trigger shortcuts Event
                                var appEvent = $A.get("e.c:COH_NavigationBarMenuEvent");
                                appEvent.setParams({"shortcutVal":resp.Id});
                                appEvent.fire();
                            }
                        }
                    });
                    $A.enqueueAction(innAct);
                }
                
                
            }
        });
        $A.enqueueAction(action);
        
        
        var action1 = component.get("c.shortCuts");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse',storeResponse)
                component.set("v.shortcuts", storeResponse);
            }
        });
        $A.enqueueAction(action1);
        
        
    },
    handleClickexp: function(component, event, helper) {
        window.open($A.get("$Label.c.COH_ExtendingHope"), '_blank');    
    },
    handleClickOrg: function(component, event, helper) {
        
        window.open($A.get("$Label.c.COH_OrangeCountry"), '_blank');    
    },
    handleClickHopewrks: function(component, event, helper) {
        
        window.open($A.get("$Label.c.COH_HopeWorks"), '_blank');     
    },
    
    
    OpenModal: function(component, event, helper) {
        component.set('v.isOpen',true);
    },
    
    OpenModalBreakthroughs: function(component,event,helper){
        component.set('v.isOpenBreakthroughs', true);
    },
    
    redirectToVfpage: function(component, event, helper) {
        window.open($A.get("$Label.c.COH_AddEvent"),'_blank');
        component.set('v.isOpen',false);
    },
    redirectToCalendar: function(component, event, helper) {
        window.open($A.get("$Label.c.COH_ViewAllCalendar"),'_blank');
        component.set('v.isOpen',false);
    },
    closeModel: function(component, event, helper) {
        component.set('v.isOpen',false);
    },
    closeModalBreakthroughs: function(component, event, helper){
        component.set('v.isOpenBreakthroughs',false);
    }
    ,
    CustomSearch : function(component, event, helper){
        console.log('dsf')
        console.log(event.which)
        if(event.which == 13){
            
            // window.location.href = "http://stackoverflow.com";
            var search = component.get('v.SearchText');
            if(search==null||search==undefined||search=='')
                return;
            var searchURL = $A.get("$Label.c.COH_Searchurl ")
            //prod url
            // window.open('https://cityofhope--c.na118.visual.force.com/apex/search?keyword='+search,'_blank');
            // sandbox url 
            window.open(searchURL+search,'_blank');
            
            
        }
    },
    
    callShortcut: function(component, event, helper){
        
        var appEvent = $A.get("e.c:COH_NavigationBarMenuEvent");
        appEvent.setParams({"shortcutVal":component.get('v.ShorcutVal')});
        appEvent.fire();
    }
    
})