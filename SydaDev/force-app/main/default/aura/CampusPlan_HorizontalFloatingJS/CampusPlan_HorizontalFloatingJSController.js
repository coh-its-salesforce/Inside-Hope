({
	doInit : function(component, event, helper) {
		var tickerLength = $('.alert-news ul li').length;
			  var tickerHeight = $('.alert-news ul li').outerHeight();
			  $('.alert-news ul li:last-child').prependTo('.alert-news ul');
			  //$('.alert-news ul').css('marginTop',-tickerHeight);
			  function moveTop(){
				$('.alert-news ul').animate({
				  top : -tickerHeight
				},600, function(){
				 $('.alert-news ul li:first-child').appendTo('.alert-news ul');
				  $('.alert-news ul').css('top','');
				});
			   }
			  setInterval( function(){
				moveTop();
			  }, 10000);
	}
})