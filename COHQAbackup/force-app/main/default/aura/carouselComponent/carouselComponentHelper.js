({
    showSlides : function(component,slideIndex,helper) {
        if(component.get("v.currentId")){
            clearTimeout(component.get("v.currentId"));
        }
         
        let i;
        let slides = component.find("mySlides");
        for (i = 0; i < slides.length; i++) {
            $A.util.addClass(slides[i], 'slds-hide');
            $A.util.removeClass(slides[i], 'slds-show');
            //slides[i].style.display = "none";
        }
        slideIndex++;
        if (slideIndex > slides.length) {slideIndex = 1};
        $A.util.addClass(slides[slideIndex-1], 'slds-show');
        $A.util.removeClass(slides[slideIndex-1], 'slds-hide');
        //slides[slideIndex-1].style.display = "block";
        var currentId = setTimeout(
    		$A.getCallback(function() {
            	helper.showSlides(component,slideIndex,helper);
        	}), 3000
		);
        component.set("v.currentId",currentId);
    }
})