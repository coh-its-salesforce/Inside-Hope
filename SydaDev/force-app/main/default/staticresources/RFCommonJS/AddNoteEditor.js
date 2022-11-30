function getOpener(){
	var opener = null;
	if (window.dialogArguments){ // Internet Explorer supports window.dialogArguments 
		opener = window.dialogArguments;
   	} 
    else{ // Firefox, Safari, Google Chrome and Opera supports window.opener
		if (window.opener) {
        	opener = window.opener;
       	}
	}
	return opener;
}

Ext.onReady(function(){
	getOpener().setIsPopUpDisplayed(true);
	var parentNoteComp = getOpener().document.getElementById(noteFldId);
	var txtEditComp = document.getElementById('noteEditor');
	if(parentNoteComp != null && parentNoteComp != 'undefined' && typeof(parentNoteComp) != ' undefined'
	&& txtEditComp != null && txtEditComp != 'undefined' && typeof(txtEditComp) != 'undefined'){
		txtEditComp.value = parentNoteComp.value;
		
		if(Ext.isIE7 || Ext.isIE8){
			txtEditComp.rows = "20";
			txtEditComp.cols = "80";
		}
		else if(Ext.isIE && !Ext.isIE7 && !Ext.isIE8){ //IE9
			txtEditComp.rows = "29";
			txtEditComp.cols = "80";
		}
		else if(Ext.isChrome){
			txtEditComp.rows = "27";
			txtEditComp.cols = "200";
		}
		else{
			txtEditComp.rows = "25";
			txtEditComp.cols = "100";
		}
	}
}); 

window.onbeforeunload = function (evt) {	
  	getOpener().setIsPopUpDisplayed(false);
}
 
function CopyTextInParent(){
	var parentNoteComp = getOpener().document.getElementById(noteFldId);
	var txtEditComp = document.getElementById('noteEditor');
	
	//Validate length and chop off extra chars
   	if(txtEditComp != null && txtEditComp.value != null && txtEditComp.value.length > VALID_LENGTH){
		txtEditComp.value = txtEditComp.value.substr(0, VALID_LENGTH);
	}
	if(parentNoteComp != null && parentNoteComp != 'undefined' && typeof(parentNoteComp) != ' undefined'
	&& txtEditComp != null && txtEditComp != 'undefined' && typeof(txtEditComp) != 'undefined' 
	&& txtEditComp.value != null && txtEditComp.value.length > 0){
		parentNoteComp.value = txtEditComp.value;
		getOpener().renderAddNoteButton();
	}
	window.close();
}