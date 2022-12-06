function validateDuration(durationVal){
	if(durationVal == null || durationVal == 'undefined' || durationVal.length > 0)
		durationVal = document.getElementById(durationCompId).value;
		
	if(durationVal != ''){
		var split = durationVal.split(':');
		if(split[0].length == 1){
			durationVal = '0' + durationVal;
			document.getElementById(durationCompId).value = durationVal;
			durationErrorFlg = 0;
		}			
		var timePat = /^([0-9]{2}):([0-9]{2})$/;
		var matchArray = durationVal.match(timePat);
		if (matchArray == null) {
			durationErrorFlg = 1;
			Ext.MessageBox.show({ msg: durationErrorLabel, buttons: Ext.MessageBox.OK});
			document.getElementById(durationCompId).value = '00:00';
		}                  
	}
}
   
function renderAddNoteAfterClose(){
	var elem = document.getElementById(notesCompId);
	var elemduration = document.getElementById(durationCompId);
	if(elem != null){
		elem.disabled = true;
		elem.className = 'clsInputTextAreaDisabledNote';
		var btn = document.getElementById('addNoteBtn');
		btn.disabled= true; btn.className = 'AddButtonOff';
	}
	 
	if(elemduration != null){
		elemduration.disabled = true;
		elemduration.className = 'clsDurationTextBoxDisable';
	}
}

function disableAddNote() {
	var noteVal = document.getElementById(notesCompId).value;
	var durationVal = document.getElementById(durationCompId).value;
	validateDuration(durationVal);
	if(durationErrorFlg != 1){
		if(noteVal.length > 32000){                       
			Ext.MessageBox.show({ msg: noteLabel + ': ' + overflowLabel, buttons: Ext.MessageBox.OK});         
		}else{          
			var btn = document.getElementById('addNoteBtn');
			btn.disabled= true; 
			btn.className = 'AddButtonOff';
			saveNote();
		}		   
	}
	durationErrorFlg = 0;
}

function renderNote(){
	if(errormsg == durationErrorLabel){
		Ext.MessageBox.show({ msg: errormsg, buttons: Ext.MessageBox.OK});
	} else {
		var elem = document.getElementById(notesCompId);
		if(elem != null){
			elem.disabled = false;
			elem.className = 'clsInputTextAreaNote';
			elem.value = '';
			if(insideNote == false){
				clickedOnce = true;  
				handleResetChange(); 
			}
		}
		var elemduration = document.getElementById(durationCompId);
		if(elemduration != null){
			elemduration.disabled = false;
			elemduration.value = '00:00'; 	
		}
	} 
}
   
function renderAddNoteButton(){
	var elem = document.getElementById(notesCompId);
	var elemduration = document.getElementById(durationCompId);

	if(elem != null){
		var btn = document.getElementById('addNoteBtn');
		var val = elem.value.trim();
		if(recordId == null || recordId == '' || val == null || val == '' || recordState == 'false'){
			   btn.disabled= true; 
			   btn.className = 'AddButtonOff';
		}else{
			   btn.disabled= false;  
			   btn.className = 'AddButton';
		}
		if(recordId == null || recordId == '' || recordState == 'false'){
			elem.disabled  = true;
			elem.className = 'clsInputTextAreaDisabledNote';    
			elemduration.disabled = true;
			elemduration.className = 'clsDurationTextBoxDisable';   
		}else{
			elem.disabled  = false;
			elem.className = 'clsInputTextAreaNote';
			elemduration.disabled = false;
			elemduration.className = 'clsDurationTextBox';   
		}
	}
}

 Ext.onReady(function(){
	if(recordId == null || recordId == '' || recordState == 'false'){
		enableDisableAddNote(true);
	}
	else{
		enableDisableAddNote(false);
		var btn = document.getElementById('addNoteBtn');
		btn.disabled= true; 
		btn.className = 'AddButtonOff';
	}
});

function enableDisableAddNote(disableNote){
	var noteComp = document.getElementById(notesCompId);
	if(noteComp != null && noteComp != 'undefined'){
		noteComp.disabled = disableNote;
		noteComp.className = !disableNote?'clsInputTextAreaNote':'clsInputTextAreaDisabledNote';    
	}
	
	var elemduration = document.getElementById(durationCompId);
	if(elemduration != null && elemduration != 'undefined'){
		elemduration.disabled = disableNote;
		elemduration.className = !disableNote?'clsDurationTextBox':'clsDurationTextBoxDisable'; 	
		elemduration.value = '00:00';
	}
	
	var inputTxtAreaButtonComp = document.getElementById('inputTxtAreaButton');
	if(inputTxtAreaButtonComp != null && inputTxtAreaButtonComp != 'undefined'){
		inputTxtAreaButtonComp.disabled = disableNote;
	}
	
	var btn = document.getElementById('addNoteBtn');
	if(btn != null && btn != 'undefined'){
		if(noteComp != null && (noteComp.val == null || noteComp.val == ''))
			disableNote = true;
		btn.disabled = disableNote;
		btn.className = !disableNote?'clsDurationTextBox':'clsDurationTextBoxDisable'; 	
	}
}

function refreshPage(){
	if(objectName == 'Incident__c'){
		refreshIncident();
	}
	else if(objectName == 'Task__c'){
		refreshTask();
	}
	if(objectName == 'Change_Request__c'){
		refreshChangeRequest();
	}
	if(objectName == 'Problem__c'){
		refreshProblem();
	}
	if(objectName == 'Release__c'){
		refreshRelease();
	}
}

var isPopUpDisplayed = false;
function showTextEditor(noteFldId){
	if(!isPopUpDisplayed && recordId != null && recordId != '' && recordState != 'false'){
		if(Ext.isIE7 || Ext.isIE8){
			window.showModalDialog('/apex/AddNoteTextEditor?noteFldId='+noteFldId,window,'toolbar=no;directories=no;menubar=no;scrollbars=no;location=no;titlebar=no;dialogWidth:800px;dialogHeight:400px;left=350;top=250;status=no');
		}
		else if(window.showModalDialog){
			window.showModalDialog('/apex/AddNoteTextEditor?noteFldId='+noteFldId,window,'toolbar=no;directories=no;menubar=no;scrollbars=no;location=no;titlebar=no;dialogWidth:800px;dialogHeight:500px;left=350;top=250;status=no');
		}
	}
}

function setIsPopUpDisplayed(isPopUpDisplayedVal){
	isPopUpDisplayed = isPopUpDisplayedVal;
}