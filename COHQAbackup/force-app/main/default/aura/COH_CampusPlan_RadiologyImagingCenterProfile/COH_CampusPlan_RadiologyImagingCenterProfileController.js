({
	goBackToDuarteBuildingPage : function(component, event, helper) {
                  component.set('v.openDuarteBuildings',true);
                  component.set('v.RadiologyImagingCenter',false);
	},
    getContent : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("AboutRadiology");
        if(id){
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRIC',true);
            
        }
    },
    getContent1 : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("AboutRICImpact");
        if(id){
            component.set('v.RadiologyImagingCenter',false);
            component.set('v.aboutRICImpact',true);
            
        }
    }
})