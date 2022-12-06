   
/*function callLink(){
	if(functionCalled == 'false'){
		functionCalled = 'true';
		link();
	}
	return;
}*/
function searchOnKeyPress(e){     
	var keynum ;

	if(window.event) { //IE
		keynum = e.keyCode;
	}else if(e.which) {
		keynum = e.which; // Netscape/Firefox/Opera
	} 
	if(keynum == 13){                 
		searchCI();                
	}
	else {
	return true;
	}
	return false;
} 
function goOnKeyPress(e,currPage){
	var keynum ;
	var numbers = /^[0-9]+$/;  

	if(window.event) { //IE
		keynum = e.keyCode;
	}else if(e.which) {
		keynum = e.which; // Netscape/Firefox/Opera
	}
	if(!(currPage.match(numbers))){		
		currPage = '1';
	}
	if(keynum == 13){                                              
		goToPage(currPage);              
	}
	else {
	return true;
	}
	return false;                       
}  
     
function setResultListHeightJS()
{    
	var winHeight = window.innerHeight;	
	if(winHeight  > 180){
		winHeight = winHeight - 180;		
		var outputPanelElement = document.getElementById(param);
		var messagePanelElement = document.getElementById(param1).innerHTML;	
		var found = messagePanelElement.indexOf(atleastOneRecord);
		if(outputPanelElement != null && outputPanelElement != undefined && outputPanelElement != '')
		{
			outputPanelElement.style.height= winHeight+'px';
		}
		if(found != -1)
		{
			winHeight = winHeight - 45;			
			outputPanelElement.style.height= winHeight+'px';
		}
	}
} 
function clearLists(){
	selectedCIids='';
	unSelectedCIids='';            
}
function first(){
	firstPage(selectedCIids,unSelectedCIids);
	clearLists();
	
}
function next(){
	nextPage(selectedCIids,unSelectedCIids);
	clearLists();
	
}
function previous(){
	previousPage(selectedCIids,unSelectedCIids);
	clearLists();            
}
function last(){
	lastPage(selectedCIids,unSelectedCIids);
	clearLists();
	
}
function fetchPageJS(pageSize){
	fetchPage(pageSize,selectedCIids,unSelectedCIids);
	clearLists();
}
function goToPage(currPage){
	goToPageJS(currPage,selectedCIids,unSelectedCIids);  
	clearLists();   
}
function setResetSelectAllJS(chkVal){
            clearLists();  
            setResetSelectAll(chkVal);    
        } 	 
  