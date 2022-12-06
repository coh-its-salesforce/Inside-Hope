({
   
    queryNews : function(component, event, helper) {
      
        var pagesource=component.get("v.pagesource");
        var action = component.get("c.getAllNews"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.newstype" ,retrunRes );
                var newstype=component.get("v.newstype");
                if(pagesource=='Home Page'){
                    component.set("v.newsList",newstype.homepagenews);
                }
                else if(pagesource=='Parking and Transportation'){
                    component.set("v.newsList",newstype.ptnews);
                }
                else if(pagesource=='Duarte'){
                    component.set("v.newsList", newstype.Dunews);

                }
                else if(pagesource=='Rivergrade'){
                    component.set("v.newsList",newstype.rivergradenews);
                }
                else if(pagesource=='Orange County'){
                    component.set("v.newsList",newstype.orangecountynews);
                }
                else if(pagesource=='Medical Office Building'){
                    component.set("v.newsList",newstype.medicalofficenews);
                }
                else if(pagesource=='Radiology Imaging Center'){
                    component.set("v.newsList",newstype.ricnews);
                }
                else{
                        
                    }
                
                   $A.createComponent(
                    "c:CampusPlan_NewsScroller",
                    {
                        "newsList": component.get("v.newsList")
                    },
                    function(comp, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            var body = component.get("v.body");
                            body.push(comp);
                           
                            component.set("v.body", body);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            // Show offline error
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            // Show error message
                        }
                    }
                ); 
               
            }
        });
        $A.enqueueAction(action);
        
     
        
    },
    
  //  getChildNews : function(component, event, helper) {
        
       /* var newsrec = event.getParam("newsrecord");
        var newstype = component.get("v.newstype");
        var pagesource=component.get("v.pagesource");
		var childNews = [];
          if(pagesource =='Duarte' ){
              debugger;
              	
        
              	var childNew =  newstype.DuartemMap[newsrec.Id];
              	console.log('childNew >>> '+childNew);
				//alert('Childs from MAP >> '+ newstype.DuartemMap[newsrec.Id]);
              	component.set("v.newsList", '');
              	var test12 =  component.get("v.newsList");
                component.set("v.newsList", newstype.DuartemMap[newsrec.Id]);
                var test12 =  component.get("v.newsList");  
				
           }
        */
        
        		/* $A.createComponent(
                    "c:CampusPlan_NewsScroller",
                    {
                        "newsList": component.get("v.newsList")
                    },
                    function(comp, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            var body1 = component.get("v.body1");
                            body1.push(comp);
                           
                            component.set("v.body1", body1);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            // Show offline error
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            // Show error message
                        }
                    }
                );  */
                
  //  },
    
})