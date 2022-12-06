({
   /* goBackToDuarteBuildingPage : function(component, event, helper) {
                  component.set('v.openDuarteBuildings',true);
                  component.set('v.profile6',false);
	}, */
    
   doInit : function(component, event, helper) {
        var action = component.get("c.getApprovedFAQs");
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var result=a.getReturnValue();
                component.set('v.FAQRecs',result);
                var faqrecs=component.get('v.FAQRecs');
                        component.set('v.DCFAQList',faqrecs.dcfaqlist);
                        component.set('v.DCHeader','Duarte Campus');
                		var DUsectionData = faqrecs.sectionMap['Duarte Campus'];
                			//console.log('----sectionData-----'+JSON.stringify(sectionData));
                		  component.set('v.DCHeader','Duarte Campus');
                		  component.set("v.DUsectionData", DUsectionData);
            }
        });
        $A.enqueueAction(action);
    },
    togglePanel1 : function(component, event, helper) {
        helper.toggleAction(component, event, 'CollapseSection1');
    },
    togglePanel2 : function(component, event, helper) {
        helper.toggleAction(component, event, 'CollapseSection2');
    },
})