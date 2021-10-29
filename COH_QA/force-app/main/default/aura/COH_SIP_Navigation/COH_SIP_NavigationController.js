({
    openOrClose : function(component, event, helper) {
        var showTab=component.find('changeIt');
        $A.util.toggleClass(showTab,'slds-is-open');
        
        var dsktpLbl = component.get('v.rec');
        var appEvent = $A.get("e.c:COH_CloseNavigationBar"); 
        //Set event attribute value
        appEvent.setParams({"TabName" :dsktpLbl.ParentMenu.Desktop_Label__c}); 
        appEvent.fire();
    },
    
    component2Event : function(component, event, helper) {
        // Logic to close all other tabs
        var message = event.getParam("TabName"); 
        
        var dsktpLbl = component.get('v.rec');
        if(message != dsktpLbl.ParentMenu.Desktop_Label__c){
            var showTab=component.find('changeIt');
            $A.util.removeClass(showTab,'slds-is-open');
        }
    },
    
    focusOut : function(component, event, helper) {
        console.log('HELL!');
        var showTab=component.find('changeIt');
            $A.util.removeClass(showTab,'slds-is-open');
    }
})