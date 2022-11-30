({
	 goBackToOrangeCounty : function(component, event, helper) {
                  var openOC = component.getEvent("OpenOrangeCounty"); 
                  openRH.setParams({"OpenOrangeCounty" : true}); 
                  openRH.fire();
	},
    openMileStonePage: function(cmp, event, helper) {
        var id = event.currentTarget.id;
        if(id=='milestone1'){
            cmp.set('v.milestonepage1',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone2'){
            cmp.set('v.milestonepage2',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone3'){
            cmp.set('v.milestonepage3',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone4'){
            cmp.set('v.milestonepage4',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone5'){
            cmp.set('v.milestonepage5',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone6'){
            cmp.set('v.milestonepage6',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone7'){
            cmp.set('v.milestonepage7',true);
            cmp.set('v.Milestone',false);
        }
        else if(id=='milestone8'){
            cmp.set('v.milestonepage8',true);
            cmp.set('v.Milestone',false);
        }
        else{
                
            }
    }
})