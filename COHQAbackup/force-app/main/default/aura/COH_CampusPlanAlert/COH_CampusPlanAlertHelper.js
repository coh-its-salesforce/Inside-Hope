({
    shiftDiv: function(component, event,lWidth) {
        var changeposition = component.get("v.intervalId");
        var floatElement = document.getElementById('tofloat');	  
        if(changeposition < lWidth){
            floatElement.style.left = changeposition+'px';
            changeposition = changeposition + 5;
            component.set("v.intervalId",changeposition);
        }
        //reset the left to 0
        else{
            component.set("v.intervalId",0);
            floatElement.style.left = "0px";
            changeposition = component.get("v.intervalId");//resetting so as to hit the if block again
        }
    }
})