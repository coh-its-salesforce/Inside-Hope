document.getElementById('searchtxt').title = searchboxtooltip;
document.getElementById('searchbtn').value = searchbtntext;
document.getElementById('searchbtn').title = searchbtntext;
   
var stdLayoutScreenWidth = 671;
var stdLayoutScreenHeight = 400;
function stdScreenLeft(){ 
   return parseInt((screen.availWidth/2) - (stdLayoutScreenWidth/2));
}function stdScreenTop(){   
    return parseInt((screen.availHeight/2) - (stdLayoutScreenHeight/2));
}  
function search(){
    
    var desc =document.getElementById('searchtxt').value;
    
    if(desc!=null && desc!=undefined && textTrim(desc) !='' &&  desc.length >=2){
    	
    	window.open('/apex/KnowledgeSearch?enableSelfClosing=false&calledFromForm=true&standardLayout=true&search='+desc,'_blank',"status = 1, height ="+stdLayoutScreenHeight +", width ="+stdLayoutScreenWidth +",left="+stdScreenLeft()+",top="+stdScreenTop()+", resizable = 1, scrollbars=no");
    }else{
    	alert(searchboxerrormsg);
    }
}

function onEnter( evt, frm ) {
	var keyCode = null;
	
	if( evt.which ) {
	keyCode = evt.which;
	} else if( evt.keyCode ) {
	keyCode = evt.keyCode;
	}
	if( 13 == keyCode ) 
	{
	    search();
	    return false;
	}
	return true;
}
// This function is written to remove blank spaces at the end of string.
function textTrim( val ){
	 val = val.replace(/^\s+|\s+$/g, "");
	return val;
}
