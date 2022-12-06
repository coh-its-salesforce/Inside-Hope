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
})