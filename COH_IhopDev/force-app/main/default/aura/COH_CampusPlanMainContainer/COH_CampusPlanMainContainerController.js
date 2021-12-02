({
	// Initialization Action
    getAlerts : function(component, event, helper) {
        var action = component.get("c.getCampusPlanAlertRecords");
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state === 'SUCCESS') {
                console.log('a.getReturnValue()',a.getReturnValue());
                component.set('v.displayalerts',true);
                component.set("v.Announcements", a.getReturnValue());
                console.log('HELlo!',component.get('v.Orange'));
                var orgn = component.get('v.Orange');
                console.log('orgn',orgn);
                if(orgn == 'Yes'){
                    window.setTimeout(
                        $A.getCallback(function(){
                            helper.openSingleRecordhelper(component, event);
                        }),200
                    );
                    
                }
                
            }
        });
        $A.enqueueAction(action);
        // disable right click
    	//window.document.addEventListener('contextmenu', ev => ev.preventDefault()); 
    	
        //	22.04.2020
    		helper.getAllNews(component, event);
        	//helper.getOCTimelineMenu(component, event);//20200616 FSalinas
    	//
    	
    	window.history.forward();
        var action2 = component.get('c.topScrolling');
        $A.enqueueAction(action2);
          //var mainContainer = component.find('mainContainer').getElement();
          //var mainSectionTop = component.find('mainSectionTop').getElement();
          //mainContainer.style.paddingTop = mainSectionTop.style.height+'px';
          //window.document.getElementsByClassName(".banner-container").style.marginTop = window.document.getElementById("mainSectionTop").style.height+'px';
    },


    activateChatbot:function(component){
        var chatboatUrl='https://4fbh.la4-c1cs-dfw.salesforceliveagent.com/content/s/chat?language=en_US&org_id=00Dq0000000E2FX&deployment_id=572q00000004DwG&sid=8727d03a-bd40-4183-9e0c-e8bafbba2a86#deployment_id=572q00000004DwG&org_id=00Dq0000000E2FX&button_id=573q00000004Eg9&session_id=8727d03a-bd40-4183-9e0c-e8bafbba2a86';
        component.set('v.isModalOpen',true);
        component.set('v.chatbotURL',chatboatUrl);
       
    },
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
    },
    
    
    redirectToCoHSite: function(component){
        // window.location='https://cityofhope--expandhope--c.visualforce.com/apex/COH_CampusPlanHeroAreaVFPage';
   		window.location='/apex/COH_CampusPlanHeroAreaVFPage';
    },
    
    getArticles : function(component, event, helper) {
    	var action = component.get("c.getAllArticles");
         action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state ==='SUCCESS') {
            	var recorddata=a.getReturnValue();
                component.set('v.Articles', recorddata);
                console.log('HELdsdsd')
            }
             });
        $A.enqueueAction(action);
    },
        
    
    /*
    handleEventFromHero : function(component, event,helper) { 
        alert('handleEventFromHero');
        var LandingPage = event.getParam("LandingPage");
        component.set('v.LandingPage', LandingPage);
        
    }, */
    
    
    parentComponentEvent : function(cmp, event,helper) { 
		
        var articles = event.getParam("ArticlesWrapper");
        var body1 = event.getParam("openBody1");
        var body2 = event.getParam("openBody2");
        //Set the handler attributes based on event data 
       
        cmp.set("v.ArticlesWrap",articles);
      
        
        cmp.set("v.Article",articles[0].article);
        cmp.set("v.openBodyArea1", body1);
        cmp.set("v.openBodyArea2", body2);
        cmp.set("v.openCarousel1",true);
        cmp.set("v.openPTNews",true);
        cmp.set("v.openDuNews",true);
        cmp.set("v.openRGNews",true);
        cmp.set("v.openOCNews",true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
    },
    carouselComponentEvent : function(cmp, event) { 
        //Get the event message attribute
        var articles = event.getParam("SingleArticle");
        cmp.set("v.Article",articles);
    },
    getStory : function(cmp, event) { 
        //Get the event message attribute
        var articles = event.getParam("SingleArticle");
        var image = event.getParam("Image");
        cmp.set("v.storyimage",image);
        cmp.set("v.ContentStory",articles);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openPTNews", false);
        cmp.set("v.openStory", true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.openRGNews",false);
        cmp.set("v.openDuNews",false);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
        cmp.set("v.openOCNews", false);
        
    },
    getNewsStory : function(cmp, event) { 
       
        var newsrec = event.getParam("newsrecord");
        cmp.set("v.newsrec", newsrec);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.profile1", false);
        cmp.set("v.profile2", false);
        cmp.set("v.MedicalOffice", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openNewsStory", true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.openPTNews", false);
        cmp.set("v.openRGNews", false);
        cmp.set("v.openDuNews",true);
        cmp.set("v.openOCNews", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.openDuarteBuildings", false);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
        cmp.set("v.Holder", false);
        
         var cmpTarget = cmp.find('faqFooter');
         $A.util.addClass(cmpTarget, 'slds-hide');
         $A.util.removeClass(cmpTarget, 'slds-show');
        
    },
    openTimeLIne: function(component, event, helper){
        
        try{
            
        var timeLIneInd = event.target.getAttribute("id");
           // console.log("----timeLIneInd----"+timeLIneInd);
        var cpTimeLines = component.get("v.newstype1.cpTimelines");
           // console.log("----cpTimeLInes---"+cpTimeLines);
        var cpTimeLinesLength = cpTimeLines.length;
           // console.log("----cpTimeLinesLength---"+cpTimeLinesLength);
        var timelinerec;
        for(var ind=0; ind<cpTimeLinesLength; ind++){
            if(ind == timeLIneInd){
                timelinerec = cpTimeLines[ind];
                component.set("v.timelinerec", timelinerec);
       			helper.setTimeLineStory(component, helper);
                
            }
        }
            //console.log("----timelinerec---"+timelinerec);
            
        }catch(e){
            alert(e);
        }
    },
    getTimelineStory : function(cmp, event, helper) { 
       
        var timelinerecord = event.getParam("timelinerecord");
        cmp.set("v.timelinerec", timelinerecord);
        helper.setTimeLineStory(cmp, helper);
    },
    recordExternalLink : function(cmp,event) { 
        var externalLink = event.getParam("siteLink");
        cmp.set("v.ExternalLink",externalLink);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openExternalLink",true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
    },
    getExternalLink : function(cmp,event) { 
        var externalLink = event.getParam("siteLink");
        cmp.set("v.ExternalLink",externalLink);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openExternalLink",true);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.openTimelineStory", false);
    },
    openDuarteBuilding: function(cmp,event) { 
        var openDuarteBuildingLink = event.getParam("openDuarteBuilding");
        cmp.set('v.openDuarteBuildings',openDuarteBuildingLink);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.openNewsStory", false);
        cmp.set("v.Menubar", true);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
    },
    
    handleClick: function(cmp) {
        cmp.set('v.searchIcon',false);
        cmp.set('v.searchBar',true);
    },
    handleSelect: function (cmp, event, helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        var selectedMenuItemValue = event.getParam("value");
    },
    
    getFAQPage : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("FAQ");
        if(id){            
            component.set('v.FAQPage',true);
            component.set("v.Holder", false);
            component.set('v.openPTNews',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set('v.openDuarteBuildings',false);
            component.set("v.displayalerts", false);
             component.set("v.openTimelineStory", false);
           
        }
    },
    
    getDUFAQ : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("DUFAQ");
        if(id){
            
            component.set('v.DuarteFAQ',true);
            component.set("v.Holder", false);
            component.set('v.openPTNews',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openDuNews",false);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
             component.set("v.openTimelineStory", false);
          
        }
    },
    
    getRGFAQ : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("RGFAQ");
        if(id){
            component.set('v.RivergradeFAQ',true);
            component.set("v.Holder", false);
            component.set('v.openPTNews',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
             component.set("v.openTimelineStory", false);
          
        }
    },
    
    OrangeCountyFAQ : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("CountyFAQ");
        if(id){
            component.set('v.OCFAQ',true);
            component.set("v.Holder", false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
             component.set("v.openTimelineStory", false);
        }
    },
    openRHArea: function(cmp, event) {
        window.scrollTo(0,0);       
        var openRHarea = event.getParam("openResourcestoHelp");
        cmp.set('v.openPTNews',true);
        cmp.set('v.openBodyArea2',true);
        cmp.set('v.openCarousel1',true);
        cmp.set('v.openCarousel2',false);
        cmp.set('v.openBodyArea1',false);
        cmp.set('v.ShuttleFrequency',false);
        cmp.set('v.StackedEmployee',false);
        cmp.set("v.openNewsStory", false);
        cmp.set('v.telecommoverview',false);
        cmp.set("v.displayalerts", false);
         cmp.set("v.openTimelineStory", false);
          
    },
    openRGArea:function(cmp, event) {
        window.scrollTo(0,0);              
        var openRHarea = event.getParam("openRivergrade");
        cmp.set('v.openPTNews',false);
        cmp.set("v.openRGNews",true);
        cmp.set('v.openBodyArea2',true);
        cmp.set('v.openCarousel1',true);
        cmp.set('v.openCarousel2',false);
        cmp.set('v.openBodyArea1',false);
        cmp.set('v.ShuttleFrequency',false);
        cmp.set('v.StackedEmployee',false);
        cmp.set('v.ShuttleSchedule',false);
        cmp.set('v.EmployeeDisc',false);
        cmp.set("v.openNewsStory", false);
        cmp.set('v.telecommoverview',false);
        cmp.set("v.displayalerts", false);
         cmp.set("v.openTimelineStory", false);
          
    },
    openRHArea2: function(cmp, event) {
        window.scrollTo(0,0);    
        var openRHarea = event.getParam("openResourcestoHelp");
        cmp.set('v.openPTNews',true);
        cmp.set('v.openBodyArea2',true);
        cmp.set('v.openCarousel1',false);
        cmp.set('v.openCarousel2',true);
        cmp.set('v.openBodyArea1',false);
        cmp.set('v.ShuttleFrequency',false);
        cmp.set('v.StackedEmployee',false);
        cmp.set("v.openNewsStory", false);
        cmp.set('v.telecommoverview',false);
        cmp.set("v.displayalerts", false);
         cmp.set("v.openTimelineStory", false);
          
    },
    openRGArea2:function(cmp, event) {
        window.scrollTo(0,0);       
        var openRHarea = event.getParam("openRivergrade");
        cmp.set('v.openPTNews',false);
        cmp.set("v.openRGNews",true);
        cmp.set('v.openBodyArea2',true);
        cmp.set('v.openCarousel1',false);
        cmp.set('v.openCarousel2',true);
        cmp.set('v.openBodyArea1',false);
        cmp.set('v.ShuttleFrequency',false);
        cmp.set('v.StackedEmployee',false);
        cmp.set('v.ShuttleSchedule',false);
        cmp.set('v.RivergradeOverView',false);
        cmp.set('v.EmployeeDisc',false);
        cmp.set("v.openNewsStory", false);
        cmp.set('v.telecommoverview',false);
        cmp.set("v.displayalerts", false);
         cmp.set("v.openTimelineStory", false);
          
    },
    openSingleRecord: function(component, event, helper) {
        console.log('openSingleRecord')
        window.scrollTo(0,0);        
        
        var title=event.target.getAttribute("id");
        console.log('title',title)
        if(title == 'Parking and Transportation'){
          document.getElementById("squareSecLi1").style.display = 'block';
          document.getElementById("squareSecLi2").style.display = 'block';
          document.getElementById("squareSecLi3").style.display = 'block';
          document.getElementById("squareSecLi4").style.display = 'block';
          
        }
        else{            
          document.getElementById("squareSecLi1").style.display = 'none';
          document.getElementById("squareSecLi2").style.display = 'none';
          document.getElementById("squareSecLi3").style.display = 'none';
          document.getElementById("squareSecLi4").style.display = 'none';            
        }        
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
     
   /* openDCPage: function(cmp,event) { 
        window.scrollTo(0,0);
       
        cmp.set('v.openDuarteBuildings',true);
        cmp.set("v.openBodyArea1", false);
        cmp.set("v.openBodyArea2", false);
        cmp.set("v.openSearchBox", false);
        cmp.set("v.openPTNews", false);
        cmp.set("v.openRGNews", false);
        cmp.set("v.openNewsStory", false);
        cmp.set("v.Menubar", true);
        cmp.set('v.ShuttleFrequency',false);
        cmp.set('v.StackedEmployee',false);
        cmp.set('v.ShuttleSchedule',false);
        cmp.set('v.RivergradeOverView',false);
        cmp.set('v.RivergradeFAQ',false);
        cmp.set('v.DuarteFAQ',false);
        cmp.set('v.EmployeeDisc',false);
        cmp.set('v.Transformation',false);
        cmp.set('v.Milestone',false);
        cmp.set('v.OCFAQ',false);
        cmp.set('v.NewApproach',false);
        cmp.set('v.FAQPage',false);
        cmp.set('v.OCStories',false);
        cmp.set('v.Events',false);
        cmp.set("v.openOCNews",false);
        cmp.set('v.profile1',false);
        cmp.set('v.profile2',false);
        cmp.set('v.profile3',false);
        cmp.set('v.profile4',false);
        cmp.set('v.profile5',false);
       // cmp.set('v.profile6',false);
        cmp.set("v.openStory", false);
        cmp.set('v.telecommoverview',false);
        cmp.set('v.milestonepage1',false);
        cmp.set('v.milestonepage2',false);
        cmp.set('v.milestonepage3',false);
        cmp.set('v.milestonepage4',false);
        cmp.set('v.milestonepage5',false);
        cmp.set('v.milestonepage6',false);
        cmp.set('v.milestonepage7',false);
        cmp.set('v.milestonepage8',false);
        cmp.set("v.displayalerts", false);
        cmp.set("v.openTimelineStory", false);
    }, */
   /* toggleMenu: function(cmp,event) { 
        var x = document.getElementById("Demo");
        if (x.className.indexOf("w3-show") == -1) {
         x.className += " w3-show";
        } 
        else { 
              x.className = x.className.replace(" w3-show", "");
             }
    },*/
    getProfilesPage : function(component, event, helper) {
        window.scrollTo(0,0);
        var Id = event.target.getAttribute("id");
         var newstype = component.get("v.newstype1");
        	//alert('Id'+Id.length + ' '+Id);
        // For Page souce type Revergrade
        if(newstype.Dunews != null && Id.length >= 15){
            var newDUlst =[];
            var redirecteDULst =[];
            var DUId =[];
            for(var i=0; i <= newstype.Dunews.length-1 ; i++){
               
                    if( Id == newstype.Dunews[i].Id && newstype.Dunews[i].Is_Redirect__c == false ){
                          newDUlst.push(newstype.Dunews[i]);
                          DUId.push(newstype.Dunews[i].Id);
                         break;
                    }
                   else if( Id == newstype.Dunews[i].Id && newstype.Dunews[i].Is_Redirect__c == true){
                          redirecteDULst.push(newstype.Dunews[i]);
                          //RDId.push(newstype.rivergradenews[i].Id); 
                          DUId ='';  
                    }
                    else{}
             
                
            	
            }
            // Loop ends here
            	
            if(redirecteDULst.length > 0 && redirecteDULst.length != null && redirecteDULst.length != undefined){
                window.open(redirecteDULst[0].URL_link__c);  
            }
            else{
                component.set('v.duNewsRecord', newDUlst[0]);
            	console.log("duNewsRecord >>> "+ component.get("v.duNewsRecord").News_Content_Next_to_Image__c);
            }  
        }
        
        if(DUId != undefined && DUId == Id){
            // Record Data should be passed to ParkingMenu Template Component.
			component.set('v.Duarte',true);
            component.set("v.openTimelineStory", false);
            component.set('v.Parking',false);
            component.set("v.Holder", false);
            component.set('v.CountyMenu',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        
      /*  var id=event.target.getAttribute("id");
        if(id=='cpMedicalOfficeBuilding'){
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
                component.set("v.Menubar", true);
                component.set('v.profile1',true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set("v.openNewsStory", false);
            	component.set('v.OCFAQ',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
                component.set('v.FAQPage',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
             component.set("v.openTimelineStory", false);
               
            
        }
        else if(id=='RadiologyImagingCenter'){
            
                component.set('v.profile2',true);
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
                component.set("v.Menubar", true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            //	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',true);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set("v.openOCNews",false);
            	component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
            	component.set('v.OCFAQ',false);
            	component.set('v.NewApproach',false);
            	component.set('v.OCStories',false);
            	component.set('v.Events',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.openTimelineStory", false);
               
        }
        else if(id=='NewHopeVillage'){
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
                component.set("v.Menubar", true);
                component.set('v.profile3',true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set('v.profile2',false);
                component.set('v.profile1',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            //	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
            	component.set("v.openOCNews",false);
            	component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
            	component.set('v.OCFAQ',false);
            	component.set('v.NewApproach',false);
            	component.set('v.OCStories',false);
            	component.set('v.Events',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
           		component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.openTimelineStory", false);
               
        }
        else if(id=='DuarteOutpatientClinic'){
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
                component.set("v.Menubar", true);
                component.set('v.profile4',true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set("v.openNewsStory", false);
                component.set('v.profile2',false);
                component.set('v.profile3',false);
                component.set('v.profile1',false);
                component.set('v.profile5',false);
            //	component.set('v.profile6',false);
            	component.set("v.openOCNews",false);
            	component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
            	component.set('v.OCFAQ',false);
            	component.set('v.Events',false);
            	component.set('v.NewApproach',false);
            	component.set('v.OCStories',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.openTimelineStory", false);
                
            
        }
        else if(id=='PatientParkingStructure'){
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
                component.set("v.Menubar", true);
                component.set('v.profile5',true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set('v.profile2',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile1',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
            	component.set("v.openOCNews",false);
            	component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
            	component.set('v.OCFAQ',false);
            	component.set('v.Events',false);
            	component.set('v.OCStories',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.openTimelineStory", false);
                
        } */
        else if(Id=='DuarteFAQ'){
                component.set("v.openBodyArea1", false);
                component.set("v.openBodyArea2", false);
            	component.set("v.Holder", false);
            	component.set("v.openTimelineStory", false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openSearchBox", false);
                component.set("v.openPTNews", false);
                component.set("v.openRGNews", false);
            	component.set("v.openDuNews", false);
                component.set("v.Menubar", true);
                component.set('v.profile5',false);
            //	component.set('v.profile6',true);
            	component.set('v.DuarteFAQ',true);
                component.set('v.openDuarteBuildings',false);
                component.set("v.openStory", false);
                component.set('v.profile2',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile1',false);
                component.set("v.openNewsStory", false);
            	component.set("v.openOCNews",false);
            	component.set('v.OrangeCounty',false);
                component.set('v.Transformation',false);
                component.set('v.Milestone',false);
            	component.set('v.OCFAQ',false);
            	component.set('v.OCStories',false);
            	component.set('v.Events',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            	component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.openTimelineStory", false);
            component.set('v.Duarte',false);
            component.set('v.Parking',false);
            component.set('v.CountyMenu',false);
                
        }
        else{
                
        }
		
	},
  /*  getOCTimelinePage : function(component, event, helper) {
        
        var Id = event.target.getAttribute("id");
        var newstype = component.get("v.newstype2");
        if(newstype.orangecountytimeline != null && Id.length >= 15){
            var newOClst =[];
            var redirecteOCLst =[];
            var OCId =[];
            for(var i=0; i <= newstype.orangecountytimeline.length-1 ; i++){
                        newOClst.push(newstype.orangecountytimeline[i]);
                        OCId.push(newstype.orangecountytimeline[i].Id);
                        break;
            }            
        }
        component.set('v.ocTimelineRecord', newOClst[0]);
        console.log("ocTimelineRecord >>> "+ component.get("v.ocTimelineRecord").Title__c);
        //alert(component.get("v.ocTimelineRecord").Title__c);
			component.set('v.CountyTimelineMenu',true);
            component.set("v.Description__c", true);
            component.set('v.Timeline_Image__c',true);
            component.set('v.Title__c',true);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        
        
    }, */
	
    getOCPage : function(component, event, helper) {
        
        var Id = event.target.getAttribute("id");
         var newstype = component.get("v.newstype1");
        	//alert('Id'+Id.length + ' '+Id);
        // For Page souce type Revergrade
        if(newstype.orangecountynews != null && Id.length >= 15){
            var newOClst =[];
            var redirecteOCLst =[];
            var OCId =[];
            for(var i=0; i <= newstype.orangecountynews.length-1 ; i++){
               
                    if( Id == newstype.orangecountynews[i].Id && newstype.orangecountynews[i].Is_Redirect__c == false){
                          newOClst.push(newstype.orangecountynews[i]);
                          OCId.push(newstype.orangecountynews[i].Id);
                         break;
                    }
                   else if( Id == newstype.orangecountynews[i].Id && newstype.orangecountynews[i].Is_Redirect__c == true){
                          redirecteOCLst.push(newstype.orangecountynews[i]);
                          //RDId.push(newstype.rivergradenews[i].Id); 
                          OCId ='';  
                    }
                    else{}
            }
            // Loop ends here
            	
            if(redirecteOCLst.length > 0 && redirecteOCLst.length != null && redirecteOCLst.length != undefined){
                window.open(redirecteOCLst[0].URL_link__c);  
            }
            else{
                component.set('v.ocNewsRecord', newOClst[0]);
            	console.log("ocNewsRecord >>> "+ component.get("v.ocNewsRecord").News_Content_Next_to_Image__c);
            }  
        }

        if(OCId != undefined && OCId == Id){
            // Record Data should be passed to ParkingMenu Template Component.
			component.set('v.CountyMenu',true);
            component.set("v.openTimelineStory", false);
            component.set("v.Holder", false);
            component.set('v.Parking',false);
            component.set('v.Duarte',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
       /* var id=event.target.getAttribute("id");
        if(id=='ocmenuitem1'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',true);
            component.set('v.Transformation',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            //	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        else if(id=='ocmenuitem2'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',true);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        else if(id=='ocmenuitem3'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',true);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem1'){
        	component.set('v.milestonepage1',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem2'){
        	component.set('v.milestonepage2',true);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
               component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem3'){
        	component.set('v.milestonepage3',true);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem4'){
        	component.set('v.milestonepage4',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem5'){
        	component.set('v.milestonepage5',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem6'){
        	component.set('v.milestonepage6',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem7'){
        	component.set('v.milestonepage7',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage8',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        }
        else if(id=='ocsubitem8'){
        	component.set('v.milestonepage8',true);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage1',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
                component.set('v.telecommoverview',false);
                component.set("v.displayalerts", false);
        } */
        else if(Id=='ocmenuitem4'){
            component.set('v.OCStories',false);
            component.set("v.openTimelineStory", false);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set("v.Holder", false);
            component.set('v.OCFAQ',true);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set('v.CountyMenu',false);
        }
       /* else if(id=='ocmenuitem5'){
            component.set('v.OCStories',true);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.OCFAQ',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
            component.set("v.openCarousel2", false);
            component.set("v.openCarousel1", false);
            component.set("v.openStory", false);
            component.set('v.profile1',false);
            component.set('v.profile3',false);
            component.set('v.profile4',false);
            component.set('v.profile5',false);
           // component.set('v.profile6',false);
            component.set("v.openNewsStory", false);
            component.set('v.openDuarteBuildings2',false);
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRIC',false);
            component.set("v.aboutRICImpact", false);
            component.set('v.NewApproach',false);
            component.set('v.RivergradeOverView',false);
            component.set('v.RivergradeFAQ',false);
            component.set('v.DuarteFAQ',false);
            component.set('v.ShuttleSchedule',false);
            component.set('v.ShuttleFrequency',false);
            component.set('v.StackedEmployee',false);
            component.set('v.FAQPage',false);
            component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        else if(id=='ocmenuitem6'){
            component.set('v.Events',true);
            component.set('v.OCStories',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.OCFAQ',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
            component.set("v.openCarousel2", false);
            component.set("v.openCarousel1", false);
            component.set("v.openStory", false);
            component.set('v.profile1',false);
            component.set('v.profile3',false);
            component.set('v.profile4',false);
            component.set('v.profile5',false);
            //component.set('v.profile6',false);
            component.set("v.openNewsStory", false);
            component.set('v.openDuarteBuildings2',false);
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRIC',false);
            component.set("v.aboutRICImpact", false);
            component.set('v.NewApproach',false);
            component.set('v.RivergradeOverView',false);
            component.set('v.RivergradeFAQ',false);
            component.set('v.DuarteFAQ',false);
            component.set('v.ShuttleSchedule',false);
            component.set('v.ShuttleFrequency',false);
            component.set('v.StackedEmployee',false);
            component.set('v.FAQPage',false);
            component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        } */
        else{
                
            }
        
    },
    getRHPage: function(component,event,helper){
        component.set('v.Parking',true);
        component.set("v.openTimelineStory", false);
            component.set('v.Duarte',false);
            component.set('v.CountyMenu',false);
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
            component.set("v.Holder", false);
         var Id = event.target.getAttribute("id");
         var newstype = component.get("v.newstype1");
        	//alert('Id'+Id.length + ' '+Id);
        // For Page souce type Revergrade
        if(newstype.ptnews != null && Id.length >= 15){
            var newPTlst =[];
            var redirectePTLst =[];
            var PTId =[];
            for(var i=0; i <= newstype.ptnews.length-1 ; i++){
                    if( Id == newstype.ptnews[i].Id && newstype.ptnews[i].Is_Redirect__c == false ){
                          newPTlst.push(newstype.ptnews[i]);
                          PTId.push(newstype.ptnews[i].Id);
                         break;
                    }
                   else if( Id == newstype.ptnews[i].Id && newstype.ptnews[i].Is_Redirect__c == true){
                          redirectePTLst.push(newstype.ptnews[i]);
                          //RDId.push(newstype.rivergradenews[i].Id); 
                          PTId ='';  
                    }
            }
            // Loop ends here
            if(redirectePTLst.length > 0 && redirectePTLst.length != null && redirectePTLst.length != undefined){
                window.open(redirectePTLst[0].URL_link__c);  
            }
            else{
                component.set('v.ptNewsRecord', newPTlst[0]);
            	console.log("ptNewsRecord >>> "+ component.get("v.ptNewsRecord").News_Content_Next_to_Image__c);
            }  
        }
    },
    
    getRHPageFAQ: function(component,event,helper){
       //  var idVal = event.target.getAttribute("id");
        //if(idVal == 'rhmenuitem3'){            
          document.getElementById("squareSecLi1").style.display = 'none';
          document.getElementById("squareSecLi2").style.display = 'none';
          document.getElementById("squareSecLi3").style.display = 'none';
          document.getElementById("squareSecLi4").style.display = 'none';  
            component.set('v.OCFAQ',false);
        	component.set("v.openTimelineStory", false);
            component.set('v.Holder',false);
            component.set('v.Events',false);
            component.set('v.OCStories',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set("v.Parking",false);
            component.set('v.Duarte',false);
            component.set('v.CountyMenu',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',true);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
       // }
	},
    gotoSquareSections: function(component,event,helper){
       //  var idVal = event.target.getAttribute("id");
        var elmnt = document.getElementById("holderId");
  		 elmnt.scrollIntoView();
	},
    getRGPage: function(component,event,helper){
        //debugger;
         var Id = event.target.getAttribute("id");
         var newstype = component.get("v.newstype1");
        	//alert('Id'+Id.length + ' '+Id);
        // For Page souce type Revergrade
        if(newstype.rivergradenews != null && Id.length >= 15){
            var newRDlst =[];
            var redirecteRDLst =[];
            var RDId =[];
            for(var i=0; i <= newstype.rivergradenews.length-1 ; i++){
               
                    if( Id == newstype.rivergradenews[i].Id && newstype.rivergradenews[i].Is_Redirect__c == false ){
                          newRDlst.push(newstype.rivergradenews[i]);
                          RDId.push(newstype.rivergradenews[i].Id);
                         break;
                    }
                   else if( Id == newstype.rivergradenews[i].Id && newstype.rivergradenews[i].Is_Redirect__c == true){
                          redirecteRDLst.push(newstype.rivergradenews[i]);
                          //RDId.push(newstype.rivergradenews[i].Id); 
                          RDId ='';  
                    }
                    else{}
             
                
            	
            }
            // Loop ends here
            	
            if(redirecteRDLst.length > 0 && redirecteRDLst.length != null && redirecteRDLst.length != undefined){
                window.open(redirecteRDLst[0].URL_link__c);  
            }
            else{
                component.set('v.rgNewsRecord', newRDlst[0]);
            	console.log("rgNewsRecord >>> "+ component.get("v.rgNewsRecord").News_Content_Next_to_Image__c);
            }  
        }
        
        if(RDId != undefined && RDId == Id){
            // Record Data should be passed to Rivergrade Template Component.

            component.set('v.OCFAQ',false);
            component.set("v.openTimelineStory", false);
            component.set("v.Holder", false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set("v.Parking",false);
            component.set('v.Duarte',false);
            component.set('v.CountyMenu',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	//component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',true);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.DuarteFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        
        
        
        
       // debugger;
      /*  var id=event.target.getAttribute("id");
        if(id=='rgmenuitem1'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.ShuttleSchedule',true);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        else if(id=='rgmenuitem2'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",true);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',false);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.ShuttleSchedule',false);
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
                window.open('https://cityofhope--c.na118.visual.force.com/apex/DepartmentPortal?id=a6Gd0000000L4UyEAK');
           
        }
        else if(id=='rgmenuitem3'){
            component.set('v.OCFAQ',false);
            component.set('v.OCStories',false);
            component.set('v.Events',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.Milestone',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
                component.set("v.openCarousel2", false);
                component.set("v.openCarousel1", false);
                component.set("v.openStory", false);
                component.set('v.profile1',false);
                component.set('v.profile3',false);
                component.set('v.profile4',false);
                component.set('v.profile5',false);
            	component.set('v.profile6',false);
                component.set("v.openNewsStory", false);
                component.set('v.openDuarteBuildings2',false);
                component.set('v.RadiologyImagingCenter',false);
                component.set('v.aboutRIC',false);
                component.set("v.aboutRICImpact", false);
            	component.set('v.NewApproach',false);
            	component.set('v.RivergradeOverView',true);
            	component.set('v.RivergradeFAQ',false);
            	component.set('v.ShuttleSchedule',false); 
                component.set('v.ShuttleFrequency',false);
                component.set('v.StackedEmployee',false);
                component.set('v.FAQPage',false);
                component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        */
         
        else if(Id=='rgmenuitem4'){
            component.set('v.OCStories',false);
            component.set("v.openTimelineStory", false);
            component.set("v.Holder", false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.OCFAQ',false);
            component.set('v.Events',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set("v.openDuNews",false);
            component.set("v.Parking",false);
            component.set('v.Duarte',false);
            component.set('v.CountyMenu',false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
            component.set("v.openCarousel2", false);
            component.set("v.openCarousel1", false);
            component.set("v.openStory", false);
            component.set('v.profile1',false);
            component.set('v.profile3',false);
            component.set('v.profile4',false);
            component.set('v.profile5',false);
           // component.set('v.profile6',false);
            component.set("v.openNewsStory", false);
            component.set('v.openDuarteBuildings2',false);
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRIC',false);
            component.set("v.aboutRICImpact", false);
            component.set('v.NewApproach',false);
            component.set('v.RivergradeOverView',false);
            component.set('v.RivergradeFAQ',true);
            component.set('v.DuarteFAQ',false);
            component.set('v.ShuttleSchedule',false);
            component.set('v.ShuttleFrequency',false);
            component.set('v.StackedEmployee',false);
            component.set('v.FAQPage',false);
            component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set('v.telecommoverview',false);
            component.set("v.displayalerts", false);
        }
        
       
       
        else{
                
            }
        
    },
   /* openTelecommuteOverviewPage: function(component){
            component.set('v.telecommoverview',true);
            component.set('v.OCStories',false);
            component.set('v.Milestone',false);
            component.set('v.OrangeCounty',false);
            component.set('v.Transformation',false);
            component.set('v.OCFAQ',false);
        	component.set('v.Events',false);
            component.set('v.openPTNews',false);
            component.set("v.openOCNews",false);
            component.set('v.openBodyArea2',false);
            component.set('v.openBodyArea1',false);
            component.set("v.openSearchBox", false);
            component.set("v.Menubar", true);
            component.set("v.openRGNews",false);
            component.set('v.openDuarteBuildings',false);
            component.set('v.profile2',false);
            component.set("v.openCarousel2", false);
            component.set("v.openCarousel1", false);
            component.set("v.openStory", false);
            component.set('v.profile1',false);
            component.set('v.profile3',false);
            component.set('v.profile4',false);
            component.set('v.profile5',false);
            //component.set('v.profile6',false);
            component.set("v.openNewsStory", false);
            component.set('v.openDuarteBuildings2',false);
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRIC',false);
            component.set("v.aboutRICImpact", false);
            component.set('v.NewApproach',false);
            component.set('v.RivergradeOverView',false);
            component.set('v.RivergradeFAQ',false);
        	component.set('v.DuarteFAQ',false);
            component.set('v.ShuttleSchedule',false);
            component.set('v.ShuttleFrequency',false);
            component.set('v.StackedEmployee',false);
            component.set('v.FAQPage',false);
            component.set('v.EmployeeDisc',false);
            component.set('v.milestonepage1',false);
            component.set('v.milestonepage2',false);
            component.set('v.milestonepage3',false);
            component.set('v.milestonepage4',false);
            component.set('v.milestonepage5',false);
            component.set('v.milestonepage6',false);
            component.set('v.milestonepage7',false);
            component.set('v.milestonepage8',false);
            component.set("v.displayalerts", false);
    }, */
    topScrolling: function(cmp,helper){
        var mybutton = window.document.getElementById("myBtn");
        
        // When the user scrolls down 20px from the top of the document, show the button
        window.onscroll = function() {
            var action1 = cmp.get('c.scrollFunction');
            $A.enqueueAction(action1);
        };
        
        
        var action2 = cmp.get('c.topFunction');
        $A.enqueueAction(action2);
    },
    scrollFunction: function(cmp){
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            window.document.getElementById("myBtn").style.display = "block";
            
          } else {
            window.document.getElementById("myBtn").style.display = "none";
          }
    },
    topFunction : function(cmp){
         setTimeout(function(){
              window.scrollTo(0,0);
            }, 500);
        
    }
    
})