({
	doInit : function(component, event, helper) {
		
        $(document).ready(function() {
             
             $("#owl-demo").owlCarousel({
 
                navigation : false, // Show next and prev buttons
 
                slideSpeed : 300,
                paginationSpeed : 400,
 
                items : 1, 
                itemsDesktop : false,
                itemsDesktopSmall : false,
                itemsTablet: false,
                itemsMobile : false,
                mouseDrag: false,
            });
            
           
         });
         $("#owl-demo").trigger("refresh.owl.carousel");
     },
   /* imageOnClick: function(component, event, helper) {
         var aId=event.target.getAttribute("id");
         var image=event.target.getAttribute("src");
         component.set('v.arecId',aId);
       
        var recoId=component.get("v.arecId");
        if(recoId!=null){
        var action = component.get("c.getArticleStory");
        action.setParams({
            "recId" : recoId
           
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                    component.set("v.articleRecord",a.getReturnValue());
                     var imageURL=component.get('v.articleRecord.ImageURL__c');
                     if(imageURL!=null && imageURL!=''){
                      //  var linkEvent = component.getEvent("ExternalLinkEvent2"); 
                      //  linkEvent.setParams({"siteLink" : imageURL}); 
                      //  linkEvent.fire();
                        window.open(imageURL);
                     }
                     else{
                        var story = component.getEvent("sampleCmpEvent3"); 
                         story.setParams({"SingleArticle" : component.get("v.articleRecord"),"Image":image}); 
                        story.fire();
                     }
                
            }
                    
          });
            $A.enqueueAction(action);
        }
    } */
       
})