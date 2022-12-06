({
	doInit : function(component, event, helper) {
       
       helper.timelinejs(component, event, helper);
       helper.getTimelineRecs(component, event, helper);
       
        
	},
    openTimelinePage:function(component, event, helper) {
        var recordId=event.target.getAttribute("id");
        
        var action = component.get("c.getTimelinePage");
        action.setParams({
            recId:recordId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state === 'SUCCESS') {
                
                component.set("v.tlRec",a.getReturnValue());
                var urllink=component.get("v.tlRec.URL__c");
                if(urllink!='' && urllink!=null){
                    
                    
                    window.open(urllink);
                }
                else{
                 var tstory = component.getEvent("TimelineEvent");
                    
                 tstory.setParams({"timelinerecord" : a.getReturnValue()}); 
                 tstory.fire();
                }
                
                               
            }
        });
        $A.enqueueAction(action);
    
    },
    doActive : function(component, event, helper) {
        
        
    },
})