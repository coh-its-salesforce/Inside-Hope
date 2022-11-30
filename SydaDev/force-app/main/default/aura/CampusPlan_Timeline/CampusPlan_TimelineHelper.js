({
    timelinejs:function(component, event, helper) {
        $(function () {  
         $('.timeline-wrapper ul li').on('click', function () {
             
               $('.timeline-wrapper ul li').removeClass('active');

                  $(this).addClass('active');
              });
        });
    },
    
    getTimelineRecs : function(component, event, helper) {
        
        
    var action = component.get("c.getTimelineInfo");
        action.setParams({
            pagesource:component.get("v.LandingPage")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state === 'SUCCESS') {
                
                component.set("v.timelinewrap", a.getReturnValue());
                var tlrecs=component.get('v.timelinewrap');
                if( component.get("v.LandingPage") == 'Home'){
                    
                    //component.set("v.year2018", null);
                    //component.set("v.year2019", null);
                    
                    component.set("v.year2020",tlrecs.year2020);
                    component.set("v.year2021",tlrecs.year2021);
                    component.set("v.year2022",tlrecs.year2022);
                    component.set("v.year2023",tlrecs.year2023);
                    component.set("v.year2024",tlrecs.year2024);
                    component.set("v.year2025",tlrecs.year2025);
                    component.set("v.year2026",tlrecs.year2026);
                    component.set("v.year2027",tlrecs.year2027);
                    
                     var year2026 = component.find('year2018');
                    $A.util.removeClass(year2026, 'slds-show');
					$A.util.addClass(year2026, 'slds-hide');
                    var year2027 = component.find('year2019');
        			$A.util.removeClass(year2027, 'slds-show');
					$A.util.addClass(year2027, 'slds-hide');
                    
                   
                }
                else if(component.get("v.LandingPage") == 'Orange County'){
                    component.set("v.year2018",tlrecs.year2018);
                    component.set("v.year2019",tlrecs.year2019);
                    component.set("v.year2020",tlrecs.year2020);
                    component.set("v.year2021",tlrecs.year2021);
                    component.set("v.year2022",tlrecs.year2022);
                    component.set("v.year2023",tlrecs.year2023);
                    component.set("v.year2024",tlrecs.year2024);
                    component.set("v.year2025",tlrecs.year2025);

                            var year2026 = component.find('year2026');
                    		$A.util.removeClass(year2026, 'slds-show');
							$A.util.addClass(year2026, 'slds-hide');
                            var year2027 = component.find('year2027');
        					$A.util.removeClass(year2027, 'slds-show');
							$A.util.addClass(year2027, 'slds-hide');
                    		var year2020 = component.find('year2020');
                    		$A.util.removeClass(year2020, 'active');
                    
                    
                    
                    
                } else{
                    
                }
               
                
                
            }
        });
        $A.enqueueAction(action);
    }   
})