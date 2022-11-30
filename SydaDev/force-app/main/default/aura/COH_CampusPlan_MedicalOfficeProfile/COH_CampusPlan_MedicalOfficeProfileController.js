({
	goBackToDuarteBuildingPage : function(component, event, helper) {
                  component.set('v.openDuarteBuildings',true);
                  component.set('v.MedicalOffice',false);
	},
    getContent : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("AboutcpMedical");
        if(id){
            component.set('v.MedicalOffice',false);
            component.set('v.aboutMedical',true);
            
        }
    },
    getContent1 : function(component, event, helper) {
        //var id=event.target.getAttribute("id");
        window.scrollTo(0,0);
        var id= document.getElementById("AboutMOBConstruction");
        if(id){
            component.set('v.MedicalOffice',false);
            component.set('v.aboutMOB',true);
            
        }
    }
})