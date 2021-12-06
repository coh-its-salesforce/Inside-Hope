({
    shiftDiv: function(component, event,lWidth) {
        try{
        var changeposition = component.get("v.intervalId");
        var floatElement = document.getElementById('tofloat');	
        if(changeposition < lWidth){
            floatElement.style.left = changeposition+'px';
            changeposition = changeposition +5;
            component.set("v.intervalId",changeposition);
        }
        //reset the left to 0
        else{
			var currentAnouncment = component.get("v.currentAnouncment");
			var AnnouncementList = component.get("v.AnnouncementList");
		if(currentAnouncment+1 < AnnouncementList.length){
				component.set("v.Announcement",AnnouncementList[currentAnouncment+1]);
				component.set("v.currentAnouncment",currentAnouncment+1);
			}else{
				component.set("v.Announcement",AnnouncementList[0]);
				component.set("v.currentAnouncment",0);
			}
            component.set("v.intervalId",0);
            floatElement.style.left = "0px";
            changeposition = component.get("v.intervalId");//resetting so as to hit the if block again
        }
        }catch(e){
            console.log(e);
        }
        
    }    
    
})