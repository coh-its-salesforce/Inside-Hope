({
   doInit : function(component, event, helper) {
        var action = component.get("c.getApprovedFAQs");
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var result=a.getReturnValue();
                component.set('v.FAQRecs',result);
                var faqrecs=component.get('v.FAQRecs');
                          component.set('v.OCFAQList',faqrecs.ocfaqlist);
                          component.set('v.OCHeader','Orange County');
                		  var OCsectionData = faqrecs.sectionMap['Orange County'];
                			//console.log('----sectionData-----'+JSON.stringify(sectionData));
                		  component.set('v.PTHeader','Orange County');
                		  component.set("v.OCsectionData", OCsectionData);
                   
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