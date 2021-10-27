({
	/* getOCTimelineMenu : function(component, event) {
        var action = component.get("c.getOCTimelineMenu"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.newstype2" ,retrunRes );
                var newstype = component.get("v.newstype2");
            }
        });
        $A.enqueueAction(action);
    }, */
    setTimeLineStory: function(cmp,helper){
        
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.profile1", false);
        cmp.set("v.profile2", false);
        cmp.set("v.MedicalOffice", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openNewsStory", false);
        cmp.set("v.openTimelineStory", true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.openPTNews", false);
        cmp.set("v.openDuNews",false);
        cmp.set("v.openRGNews", false);
        cmp.set("v.openOCNews", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.openDuarteBuildings", false);
        cmp.set("v.displayalerts", false);
        cmp.set('v.CountyMenu',false);
        cmp.set('v.Duarte',false);
        cmp.set('v.Parking',false);
        cmp.set('v.RivergradeOverView',false);
        cmp.set('v.FAQPage',false);
        cmp.set('v.DuarteFAQ',false);
        cmp.set('v.RivergradeFAQ',false);
        cmp.set('v.OCFAQ',false);
        cmp.set("v.Holder", false);
    },
	getAllNews : function(component, event) {
       // var listSource=component.get("v.listSource");
       
        var action = component.get("c.getAllNewsMenu"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrunRes = response.getReturnValue();
                component.set("v.newstype1" ,retrunRes );
                var newstype = component.get("v.newstype1");
				console.log('newstype1.rivergradenews >>> '+ retrunRes.rivergradenews);
                /*
                if(listSource=='Home Page'){
                    component.set("v.newsList",newstype.homepagenews);
                }
                else if(listSource=='Parking and Transportation'){
                    component.set("v.newsList",newstype.ptnews);
                }
                else if(listSource=='Rivergrade'){
                    component.set("v.newsList",newstype.rivergradenews);
                }
                else if(listSource=='Orange County'){
                    component.set("v.newsList",newstype.orangecountynews);
                }
                else if(listSource=='Medical Office Building'){
                    component.set("v.newsList",newstype.medicalofficenews);
                }
                else if(listSource=='Radiology Imaging Center'){
                    component.set("v.newsList",newstype.ricnews);
                }
                else{
                        
                    }
                */
               
               
            }
        });
        $A.enqueueAction(action);
    },
    openSingleRecordhelper: function(component, event) {
        console.log('openSingleRecordhelper')
        window.scrollTo(0,0);        
        console.log('ef')
        var title='Orange County';
        console.log('title',title)
                  
          document.getElementById("squareSecLi1").style.display = 'none';
          document.getElementById("squareSecLi2").style.display = 'none';
          document.getElementById("squareSecLi3").style.display = 'none';
          document.getElementById("squareSecLi4").style.display = 'none';            
              
        component.set("v.Holder", true);
         
          if(title!=null){
         
          var action = component.get("c.getSingleArticle");
          action.setParams({
            "title" : title
          });
          action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state ==='SUCCESS') {
                
            	var recorddata=a.getReturnValue();
                try{
                    //alert(recorddata[0].isFaqExists);
                    component.set("v.isFaQExists", recorddata[0].isFaqExists);
                }catch(e){
                    
                }
                
                
               console.log('recorddata',recorddata) 
            $A.createComponent(
            "c:SingleItemCarousel",
            {
               "ArticlesWrap": recorddata
            },
            function(articles, status, errorMessage){
                
                if (status === "SUCCESS") {
                    var singleCarouselDymamic = component.get("v.singleCarouselDymamic");
                    
                    singleCarouselDymamic.pop();
                    singleCarouselDymamic.push(articles); 
                    console.log('singleCarouselDymamic',singleCarouselDymamic)
                    component.set("v.singleCarouselDymamic", singleCarouselDymamic);
                   
                   
                    
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
                
                //component.set('v.ArticlesWrap2',recorddata);
                component.set('v.Article',recorddata[0].article);
                component.set("v.openBodyArea1", false);
                component.set("v.Holder", true);
                component.set("v.openBodyArea2", true);
                component.set("v.openCarousel2", true);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", true);
                component.set("v.openRGNews", true);
                component.set("v.openDuNews", true);
                component.set("v.openOCNews",true);
                component.set("v.Parking",false);
                component.set('v.Duarte',false);
                component.set('v.CountyMenu',false);
                component.set('v.DuarteFAQ',false);
                component.set('v.openDuarteBuildings',false);
                component.set("v.Menubar", true);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile2',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
                component.set('v.profile6',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.ShuttleSchedule',false);
                component.set('v.RivergradeOverView',false);
                component.set('v.RivergradeFAQ',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
                component.set('v.OCFAQ',false);
                component.set('v.NewApproach',false);
                component.set('v.OCStories',false);
                component.set('v.Events',false);
                component.set('v.FAQPage',false);
                component.set("v.openNewsStory", false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
                 component.set("v.openTimelineStory", false);
                    
              }
        });
        $A.enqueueAction(action);
      } 
    },
    
})