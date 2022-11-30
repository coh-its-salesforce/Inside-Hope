function fetchData(){
        //alert('{!message}');
        //var msg = '{!message}';
        if(msg == '.')
            document.getElementById('tickerdiv1').innerHTML = msg;    
        else
            document.getElementById('tickerdiv').innerHTML = msg;        
}    
Ext.onReady(function(){
    fetchData(); 
    if(!Ext.isIE && !Ext.isChrome && !isSafari){
        var marObj = document.getElementById('marqueeId');
        marObj.behavior="alternate";
    }
});
function onBounceHandler(obj){
	if(!Ext.isIE){
	  obj.behavior="scroll";
	  obj.direction="right";
	  obj.direction="left";
    }
}