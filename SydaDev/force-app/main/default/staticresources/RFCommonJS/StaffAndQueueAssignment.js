	
	// clear Queue lookup text & reset queue id
    function resetQueueText(){
    	if(isEnabled == true){
	        document.getElementById('QueueId').value = '';
	        queueId = '';        
	        resetQueueId();
        }
    } 
    
    // clear Staff lookup text & reset staff id
    function resetStaffText(){
    	if(isEnabled == true){
	        document.getElementById('StaffId').value = '';
	        staffId = '';
	        resetStaffId();
        }
    }
    
    // set selected Queue and/or staff as owner  
    function ApplyStaffAndQueue(){
    	if(isEnabled == true){
	        // check if either Queue or Staff selected
	        // if not display message telling to select one.
	        if((queueId == undefined || queueId == null || queueId == '' ) && (staffId == undefined || staffId == null || staffId == '')){
	            alert(QueueOrUserNotSelectedLabel);
	        }else{
	            // if Queue is not selected
	            if(queueId == undefined || queueId == null || queueId == '' ){
	                // And Staff is selected -- Assign Staff as Owner
	                // Owner --> user  & Staff --> user
	                if(staffId != undefined || staffId != null || staffId != '') {
	                    AssignStaffOnly(staffId);
	                }                                 
	            }
	            // If Queue is selected --
	            else{
	                // And Staff is not selected -- Assign Queue as Owner
	                // Owner --> Queue  & Staff --> null
	                if(staffId == undefined || staffId == null || staffId == '') {
	                    AssignQueueOnly(queueId);               
	                }
	                // Else Populate Staff along with Queue Owner --
	                // Owner --> Queue  & Staff --> user
	                else{    
	                    AssignStaffAndQueue(staffId,queueId);
	                }
	            } 
	        }
        }
    }
    
    // Populate Staff user name in Staff lookup text
    function setStaffName(stname){   
        document.getElementById('StaffId').value = stname;       
    }

    // Populate Queue user name in Queue lookup text
    function setQueueName(qnm , isValidMember ){
       
        document.getElementById('QueueId').value = qnm;
        // check whether staff selected is a member of a Queue or not.
        // If not reset staff details
        if(isValidMember == false){
            resetStaffText();
        }        
    }
    
    // Launch Queue lookup to display all Queues for 'objName' object 
    function openQueueLookup(objName,qFor){
		if(isEnabled == true){
	        if((objName != undefined || objName != null || objName != '') && (qFor != undefined || qFor != null || qFor != '')){         
	            var url = '/apex/SearchPage?id='+recordId+'&popupId=Queue&objName='+objName+'&popupFor=QueueAssignment&standardLayout=true&isQueurorUser=true&isLookup=true&queueFor='+ qFor +'&isOnlyQueueList=true&additional_columns=Queue.Name,QueueId&filterClause='+escape("sobjectType=\'"+qFor + "\'");
	            window.open(url,null,"height=400,width=600,left=350, right=350, top=200");
	        }
	    }       
    }
    
    // Launch Staff lookup for all user
    function openStaffLookup(){
        if(isEnabled == true){
	        var qnm = document.getElementById('QueueId').value;
	        
	        // if Queue is not selected -- display all the user
	        if((queueId == undefined || queueId == null || queueId == '' ) && (qnm == undefined || qnm == null || qnm == '' )){            
	            var url = '/apex/SearchPage?popupId=Client&popupFor=QueueAssignment&standardLayout=true&isLookup=true&additional_columns=name,username,firstname,lastname,phone,extension,email,ProfileId,Profile.Name&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true';
	            window.open(url,null,"height=400,width=600,left=350, right=350, top=200");
	        }
	        // else fetch the members associated with selected Queue
	        else{
	            getQueueMembersList(queueId);
	        }
    	}
    }
    
    // Launch Staff lookup for Queue members
    function openQueueMemberLookup(){     
        
        if(qMemberJSON == undefined|| qMemberJSON  == null || qMemberJSON == ''){
            qMemberJSON = '\'\'';
        }
        var url = '/apex/SearchPage?popupId=Client&popupFor=QueueAssignment&standardLayout=true&isLookup=true&additional_columns=name,username,firstname,lastname,phone,extension,email,ProfileId,Profile.Name&isAssignTo=true&filterClause=Id IN ('+qMemberJSON+') AND '+escape("IsStaffUser__c=true");
        window.open(url,null,"height=400,width=600,left=350, right=400, top=200");   
    } 
    
    // Reload page 
    function refreshPage(){      
        window.parent.location.href = '/'+recordId;
    }
    
    // display error message
    function showErrorMsg(err){
        alert(err);
        resetStaffText();
        resetQueueText();
    }
    