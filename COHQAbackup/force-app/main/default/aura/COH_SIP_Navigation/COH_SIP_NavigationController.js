({
    openOrClose : function(component, event, helper) {
        console.log('CALLED')
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
    },
    
    menuURL: function(component, event, helper) {
        console.log('QWERTY');
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        console.log('data Name = ', Name);
        if(Name)
        window.open(Name);
        //var item = event.getSource().getElement().getAttribute('data-record');
        //console.log('item',item)
    }
})