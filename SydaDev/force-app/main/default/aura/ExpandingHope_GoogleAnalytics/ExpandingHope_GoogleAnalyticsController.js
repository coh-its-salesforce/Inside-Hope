({
	doInit : function(component, event, helper) {
        
        var analyticsUrl = $A.get('$Resource.GoogleAnalytics');
          
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                })(window,document,'script',analyticsUrl,'ga');
        ga('create', 'UA-3289688-32', 'auto');
        ga('send', 'pageview');
		
	}
})