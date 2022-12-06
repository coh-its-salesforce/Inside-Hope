function setPlaceHolder(ele){
	if(ele != null){
		ele.style.color = '#808080';
		ele.style.fontFamily = 'Tahoma,Ms Sans Serif';
		ele.style.fontSize = '13px';
		ele.value = feedbackPlaceHolder;
	}
}
function clearPlaceHolder(ele){
	if(!commentsEntered){
		ele.value='';
		ele.style.color = '#000000';
		ele.style.fontFamily = 'Tahoma,Ms Sans Serif';
		ele.style.fontSize = '13px';
	}
}
function checkPlaceHoder(ele){
	if(ele.value==''){
		commentsEntered=false;
		setPlaceHolder(ele);
	}
}
function submitFeedbackJS(){
	var opt = getSelectedFeedbackOption();
	if(opt != null){
		if(commentsEntered){
			if(ele != null){
				var feedbackVal = encodeURIComponent(ele.value); 
				submitFeedback(opt,feedbackVal);
			}
		}else{
			submitFeedback(opt,'');
		}
	}
	
}
function getSelectedFeedbackOption(){
	var feedbackOpts = document.getElementsByName('feedbackOption');
	for (var x = 0; x < feedbackOpts.length; x ++) {        
		if (feedbackOpts[x].checked) {
			return feedbackOpts[x].value;
		}
	}
	return null;
}