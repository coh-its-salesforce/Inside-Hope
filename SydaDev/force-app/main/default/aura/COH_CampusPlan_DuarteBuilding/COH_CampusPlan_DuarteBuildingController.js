({
	getContent : function(component, event, helper) {
        
        var id=event.target.getAttribute("id");
        if(id=='cpMedicalOfficeBuilding'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile1',true);
            
        }
        else if(id=='RadiologyImagingCenter'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile2',true);
        }
        else if(id=='NewHopeVillage'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile3',true);
        }
        else if(id=='DuarteOutpatientClinic'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile4',true);
            
        }
        else if(id=='PatientParkingStructure'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile5',true);
        }
        else if(id=='DuarteFAQ'){
            component.set('v.DuarteBuildings',false);
            component.set('v.profile6',true);
        }
        else{
                
        }
		
	},
    
})