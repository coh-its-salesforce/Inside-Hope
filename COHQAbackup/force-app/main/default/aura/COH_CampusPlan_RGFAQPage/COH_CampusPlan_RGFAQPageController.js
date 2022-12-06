({
   /* goBackToRiverGrade : function(component, event, helper) {
				  var openRH = component.getEvent("openRivergrade"); 
                  openRH.setParams({"openRivergrade" : true}); 
                  openRH.fire();
	}, */
    
   doInit : function(component, event, helper) {
        var action = component.get("c.getApprovedFAQs");
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var result=a.getReturnValue();
                component.set('v.FAQRecs',result);
                var faqrecs=component.get('v.FAQRecs');
                         component.set('v.RGFAQList',faqrecs.rgfaqlist); 
                         component.set('v.RGHeader','Rivergrade');
                		var RGsectionData = faqrecs.sectionMap['Rivergrade'];
                			//console.log('----sectionData-----'+JSON.stringify(sectionData));
                			 component.set('v.RGHeader','Rivergrade');
                		component.set("v.RGsectionData", RGsectionData);
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