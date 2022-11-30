({
	openNewsStory : function(component, event, helper) {
        var rId=component.get("v.newsInstance.Id");
        
        var action = component.get("c.getNewsStory");
        action.setParams({
            "recId" : rId
          });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var urllink=component.get("v.newsInstance.URL_link__c");
                if(urllink!='' && urllink!=null){
                    
                    window.open(urllink);
                }
                else{
                 var nstory = component.getEvent("NewsEvent"); 
                 nstory.setParams({"newsrecord" : a.getReturnValue()}); 
                 nstory.fire();
                }
            }
        });
        $A.enqueueAction(action);
		
	}
})