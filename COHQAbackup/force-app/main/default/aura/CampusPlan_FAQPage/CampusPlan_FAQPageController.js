({
   doInit : function(component, event, helper) {
        var action = component.get("c.getApprovedFAQs");
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var result=a.getReturnValue();
                component.set('v.FAQRecs',result);
                var faqrecs=component.get('v.FAQRecs');
                       // component.set('v.DuarteCampusFAQList',faqrecs.dcfaqlist);
                       // component.set('v.DuarteCampusHeader','Duarte Campus');
                   
                       //  component.set('v.RGFAQList',faqrecs.rgfaqlist); 
                       //  component.set('v.RGHeader','Rivergrade');
                   
                           component.set('v.PTFAQList',faqrecs.ptfaqlist);
                           component.set('v.PTHeader','Parking and Transportation');
                		   var sectionData = faqrecs.sectionMap['Parking and Transportation'];
                			//console.log('----sectionData-----'+JSON.stringify(sectionData));
                		   component.set('v.PTHeader','Parking and Transportation');
                		   component.set("v.sectionData", sectionData);
                   
                        //  component.set('v.OCFAQList',faqrecs.ocfaqlist);
                        //  component.set('v.OCHeader','Orange County');
                   
                          // component.set('v.OtherFAQList',faqrecs.otherfaqlist);
                          // component.set('v.OtherHeader','Other');
                		  // var OthersectionData = faqrecs.sectionMap['Other'];
                		//	component.set('v.OtherHeader','Other');
                	//	component.set("v.OthersectionData", OthersectionData);
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