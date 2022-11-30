({
    getArticles : function(component, event, helper) {
    	var action = component.get("c.getAllArticles");
         action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state ==='SUCCESS') {
            	var recorddata=a.getReturnValue();
                component.set('v.Articles', recorddata);
                //console.log(component.get('v.Articles'))
            }
             });
        $A.enqueueAction(action);
    },
    
    getHomeInfo : function(component, event, helper) {
    	var action = component.get("c.getAllInfo");
         action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state ==='SUCCESS') {
            	var recordHomedata=a.getReturnValue();
                component.set('v.HomeData', recordHomedata);
            }
             });
        $A.enqueueAction(action);
    },
       
   openSingleRecord: function(component, event, helper) {
       try{
          // console.log("----openSingleRecord---");
          var title=event.target.getAttribute("id");
          component.set('v.arecId',title); 
          var recoId=component.get("v.arecId");
          // console.log("----title---");
          if(title!=null){
         
          var action = component.get("c.getSingleArticle");
          action.setParams({
            "title" : title
          });
          action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state ==='SUCCESS') {
                
            	var recorddata=a.getReturnValue();
                component.set('v.SingleArticleWrap',a.getReturnValue());
                       
                       component.set("v.isOpen", true);
                       component.set("v.OpenHeroArea", false);
                       var articles = component.get("v.SingleArticleWrap");
                      
                       var cmpEvent = component.getEvent("sampleCmpEvent"); 
                       cmpEvent.setParams({"ArticlesWrapper": articles,"openBody1": false,"openBody2":true}); 
                       cmpEvent.fire();
                    
              }
        });
        $A.enqueueAction(action);
          // Navigate to URL    
         
    		
      //	window.location= 'https://cityofhope--expandhope--c.visualforce.com/apex/COH_ResourcesToHelp';
    	    
         
      }
           }catch(e){
           alert(e);
       }
    },
    openvfDuarteBuildingPage: function(component, event, helper) {
                    var duarteEvent = component.getEvent("DuarteBuildingEvent"); 
                    duarteEvent.setParams({"openDuarteBuilding" : true}); 
                    duarteEvent.fire();
                    //window.open('https://cityofhope--empappsdev--c.cs65.visual.force.com/apex/vfDuarteBuildingDirectory');
    } 
})