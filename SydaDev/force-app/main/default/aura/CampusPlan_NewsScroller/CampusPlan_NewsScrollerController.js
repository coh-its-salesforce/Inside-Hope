({
	doInit : function(component, event, helper) {
		jQuery(function($) {
           $('#mySlider').slick({
               autoplay: false,
               autoplaySpeed: 4000,
               infinite: true,
               speed: 300,
               slidesToShow: 3,
               slidesToScroll: 1,
               responsive: [
                   {
                       breakpoint: 1024,
                       settings: {
                           slidesToShow: 3,
                           slidesToScroll: 3,
                           infinite: true,
                           dots: true
                       }
                   },
                   {
                       breakpoint: 600,
                       settings: {
                           slidesToShow: 2,
                           slidesToScroll: 2
                       }
                   },
                   {
                       breakpoint: 480,
                       settings: {
                           slidesToShow: 1,
                           slidesToScroll: 1
                       }
                   },
                   {
                       breakpoint: 375,
                       settings: {
                           slidesToShow: 1,
                           slidesToScroll: 1
                       }
                   }
               ]
           });
       });
	}
})