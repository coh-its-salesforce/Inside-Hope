var mainId,
    inProgress = false,
	eleToFocus,
	eleToFocusTabIndex,
	waitMsg ='',
	condition = '',
	onComplete,
	fieldName,
	lookupValues,
	fieldValue,
	twindownameflag,
	tempnames,
	objId,
	popupId,
	searchField,
	boolMultipleRecords,
	isBlackoutParam,	
	checkFieldExists,
	targetSrc,
	isSLAOwnerLookup = false,
	isCustomField = false,
	taboutPageType,
	customId,
	customFieldIndex = '',
	customVarId = '',
	selectedCatId,
	selectedClientId;
	
function getElementByTabIndexJS(index){
	var nextElement;
	if(index != null && typeof(index) != 'undefined'){
		var allElements = document.getElementsByTagName("*");
		for (var i=0; i < allElements.length; i++)
		{
		   if (allElements[i] != null && allElements[i].tabIndex == index ){
				nextElement = allElements[i];
				break;
			}
		}
	}
	return nextElement;	
}

//***** This part of code is used to trim the spaces from Strings****//
function trim(str, chars) {
	return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}
 
function rtrim(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}
 
function searchElementJS(){
	if(waitMsg != null && waitMsg != '')
        waitMsg.hide();
    //****** All the Ids which contains a perticular syntax are stored in an array*****//
	var itemValue;
	var elements = document.getElementsByTagName('*');
	var element = null;
	var elementID = null;
	var len = elements.length;
	var arrEle = new Array(len);
	while(len!=0){
		element = elements[len];
		if(element!=null){
			elementID = element.id;
			if(elementID.match("_id_")!=null){
				  arrEle.push(elementID);
			}                                      
		}
		len--;
	}              
	//******Code for Populating the fields starts from here *****////////////
	
	if(checkFieldExists){	
		//set remote call flag for client details tooltip
		if(typeof(remoteCallFlag) !== 'undefined' && objId == 'User' && !isCustomField)
			remoteCallFlag = false;
		if(!boolMultipleRecords){
			if (getStrnameiddEleId() != null) {
				var empty = '';
				setStrnameIdEleId(empty);
			}
			//alert('tempnames : ' + tempnames);
			if (tempnames.length > 0) {
				var names = tempnames.split(',');
				for ( var i in names ){
					var tempitm = names[i];
					var itm = tempitm.toString();
					itm = itm.replace('"','').replace('"','').replace('[','').replace(']','');
					//alert('itm : ' + itm);
					if (itm.length > 0) {
						var itmarr = itm.split(':');
						var name = '';
						var val = '';
					
						if (itmarr.constructor.toString().indexOf('Array') != -1) {
							if (typeof(itmarr[0]) == 'string')
										name = trim(itmarr[0]);
							  if (typeof(itmarr[1]) == 'string')
										val = trim(itmarr[1]);
						}
							
						
						//alert('objId : ' + objId);
						for(var j in arrEle){
							 if (typeof(arrEle[j]) == 'string'){
								var partialId = null;
								partialId = objId +'_id_'+ name +customVarId+customFieldIndex;
								//alert('partialId :' + partialId);
								if(!isCustomField){
									if(name == 'IncidentAccountId'){
										partialId = 'Account_id_id';
									}
									if(name == 'IncidentAccountName'){
										partialId = 'Account_id_name';
									}
								}
								var pageId = arrEle[j].substring((arrEle[j].lastIndexOf(':')+1),(arrEle[j].length));
								//alert('pageId : ' + pageId);
								if(pageId == partialId){
									if(val=='null'){
											document.getElementById(arrEle[j]).value = '' ;
											lookupValues[arrEle[j]] = '';       
									}else{
										//alert('calling decodeURIComponent');
										itemValue = decodeURIComponent(val);
										//alert('itemValue : ' + itemValue);
									   while(itemValue.indexOf('%space%') != -1){
											itemValue = itemValue.replace('%space%',' ');
										}
										if(!isCustomField){
											if(name == 'IncidentAccountId' || name == 'IncidentAccountName'){
												while(itemValue.indexOf('+') != -1){
													itemValue = itemValue.replace('+',' ');
												}
												if(typeof(incAccountName) != 'undefined'){
													incAccountName = itemValue;
												}											
											}
										}
										document.getElementById(arrEle[j]).value = itemValue.trim();
										if(partialId == 'User_id_id'){
											if(typeof(IncidentPageComp) != 'undefined' && IncidentPageComp.ComponentVars.TipUserID != null && typeof(IncidentPageComp.ComponentVars.TipUserID) != 'undefined'){
												document.getElementById(IncidentPageComp.ComponentVars.TipUserID).value = itemValue.trim();
											}
										}
										lookupValues[arrEle[j]] = itemValue.trim();
									}
								}
							} 
						}          
					}
				}
			}
		}
		else{  	//*****If multiple records are found this is the code to show pop up*****//
			if(taboutPageType != null && taboutPageType != '' && typeof(taboutPageType) != 'undefined' && taboutPageType == 'custom'){
				
				if(objId=='User' && (isSLAOwnerLookup == 'true' || condition.toLowerCase().indexOf('isstaffuser') != -1)){
				
					openPopup('SearchPage?popupId=null&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&&filterClause=IsStaffUser__c=true&referenceObjectName=' + objId,onCompPopulate);
				}else if(objId.toLowerCase() =='account' && condition.toLowerCase().indexOf('vendor') != -1) {		
					openPopup('SearchPage?popupId=null&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&VENDORFlag=true&referenceObjectName=' + objId,onCompPopulate);					 
				}else if(objId.toLowerCase() =='account' && condition.toLowerCase().indexOf('serviceprovider') != -1) {
						
					openPopup('SearchPage?popupId=null&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&SPFlag=true&referenceObjectName=' + objId,onCompPopulate);					 
				}else if(objId.toLowerCase() =='bmc_businessservice__c') {
					var instanceid = condition.split("INSTANCEID");
					if( condition.toLowerCase().indexOf('subservicelookupinstanceid') != -1){
					openPopup('SearchPage?moduleId=FKBUSINESSSERVICE__C&InstanceID='+instanceid[1]+'&isLookup=true&popupId=null&moduleName=BMC_BUSINESSSERVICE__c&searchField='+searchField+'&fieldValue='+fieldValue,onCompPopulate);					 
				    }
					else{
						openPopup('SearchPage?moduleId=FKBUSINESSSERVICE__C&InstanceID='+instanceid[1]+'&isLookup=true&popupId=null&moduleName=BMC_BUSINESSSERVICE__c&searchField='+searchField+'&fieldValue='+fieldValue+'&filterClause='+condition,onCompPopulate);					 
					}
				}else{		
					if(objId=='SRM_RequestDefinition__c'){
						if(selectedClientId == null || selectedClientId == 'undefined' || typeof(selectedClientId) == 'undefined' )
							selectedClientId = '';
						if(selectedCatId == null || selectedCatId == 'undefined' || typeof(selectedCatId) == 'undefined' )
							selectedCatId = '';	
						openPopup('SearchPage?popupId='+popupId+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&filterClause='+condition+'&clientIdforSrm='+selectedClientId+'&catIdForSrd='+selectedCatId,onCompPopulate);
					}else{
						openPopup('SearchPage?popupId=null&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&referenceObjectName=' + objId,onCompPopulate);					 
					}
				}
				if(targetSrc.getAttribute('isCalledFromTemplate') == 'true'){
					targetSrc.isCalledFromTemplate = 'false';
					onCompPopulate(firstRecordId);
				}
			}else{
				if(targetSrc.getAttribute('isCalledFromTemplate') == 'true'){
					targetSrc.isCalledFromTemplate = 'false';
					onCompPopulate(firstRecordId);
				}else if(condition != null && condition != '' && condition != 'null'){
					if(condition.indexOf('IsActive') > 0 && condition.indexOf('accountId') > 0){
						var splitCondition = condition.split('accountId=');
						var accId = splitCondition[1];
						 openPopup('SearchPage?popupId='+popupId+'&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&filterClause=IsActive=true&accountId='+accId+'&windownameflag='+twindownameflag ,onCompPopulate);						
					}else{
						if(popupId=='SRM_RequestDefinition' || popupId=='SRM_RequestDefinition__c'){
							if(selectedClientId == null || selectedClientId == 'undefined' || typeof(selectedClientId) == 'undefined' )
								selectedClientId = '';
							if(selectedCatId == null || selectedCatId == 'undefined' || typeof(selectedCatId) == 'undefined' )
								selectedCatId = '';	
							openPopup('SearchPage?popupId='+popupId+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&filterClause='+condition+'&clientIdforSrm='+selectedClientId+'&catIdForSrd='+selectedCatId,onCompPopulate);
						}else{
						 openPopup('SearchPage?popupId='+popupId+'&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true&filterClause='+condition+'&windownameflag='+twindownameflag ,onCompPopulate);					 
						} 
					}
				}else{
					 openPopup('SearchPage?popupId='+popupId+'&isBlk='+isBlackoutParam+'&searchField='+searchField+'&fieldValue='+fieldValue+'&isLookup=true',onCompPopulate);					 
				}
			}
		}
			
	}else{
		checkValidityofRecord();
		document.getElementById(mainId).value='';
		document.getElementById(mainId).focus();
	}
	
	inProgress = false;
	eleToFocus = getElementByTabIndexJS(eleToFocusTabIndex);
	if(eleToFocus != null && typeof(eleToFocus) != 'undefined'){
		if(twindownameflag != 'urgencyflag'){
			eleToFocus.focus();
		}
	}
	if(typeof(checkSave) == 'function' && typeof(onComplete) != 'function'){
		checkSave();
	}
	
	if(typeof(onComplete) == 'function'){
		onComplete(lookupValues[mainId]);
	}
}


function showTbData(eventObject,onCompleteFunction,whereClause,windownameflag,isBlackout){
        if(isBlackout != null && isBlackout != ''){
            isBlackoutParam=isBlackout;
        }
        
	if(windownameflag != '' && windownameflag != null){
		twindownameflag = windownameflag ;
	}    
	//alert('inProgress :' + inProgress);
	if(!inProgress){
		isCustomField = false;
		inProgress = true;
		getHiddenTextEle().focus(); 
		var target=eventObject.target;
		if(target == null) 
			target = eventObject.srcElement; 
		targetSrc = target;			
		eleToFocusTabIndex = Number(target.getAttribute('tabindex')) + 1;
		var val = target.value;
		mainId = target.id;
		var lookupValue = lookupValues[mainId];
		var checkUserName = false;
		if(mainId.indexOf('User_id_username') > 0){
			var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
			if(reg.test(val) == false){
				checkUserName = true;
			}
		}
		//alert('lookupValue : ' + lookupValue);
		if(val != lookupValue || checkUserName){
			var idPrefix = mainId.substring(0,mainId.lastIndexOf(":")); 
			var objFld = mainId.substring(mainId.lastIndexOf(":")+1); 
			var objFldArray = objFld.split('_id_');
				
			var ftcId = target.id;
			//Resetting the Custom Variables in case we have standard Fields
			customVarId = customFieldIndex = '';
			if(objFldArray[1].indexOf('__x_') > 0){
				customId = objFld;
				customVarId = '__x_'
				customFieldIndex = customId.substring((customId.lastIndexOf('_')+1),(customId.length));
				isCustomField =true;
				fieldName = objFldArray[1].split('__x_')[0];
			}else if(objFldArray[1].indexOf('__xx_') > 0){ // For service offering lookup in Incident Fieldset
				customId = objFld;
				customVarId = '__xx_'
				customFieldIndex = customId.substring((customId.lastIndexOf('_')+1),(customId.length));
				isCustomField =true;
				fieldName = objFldArray[1].split('__xx_')[0];
			}else {
				fieldName = objFldArray[1];			
			}

			if(typeof(whereClause) != 'undefined')
				condition = whereClause;
		    onComplete = null;
			if(onCompleteFunction!=null){
				onComplete = onCompleteFunction;
			}
			//**** here string values for objects, field on which search is to be made
			// and its corresponding value is set****//
			//alert('val : ' + val);
			if(val!=null && val!='' && val.length >0){
				if(typeof(accountPopupFlag) !== 'undefined' && objFldArray[0] == 'Account' && !isCustomField)
					accountPopupFlag = true;			
  	         	    setStrObjectIdEleVal(objFldArray[0]);					
			    setStrFieldToSearchIdEleVal(fieldName);
			    setStrValueIdEleVal(val);
			    setWhereClauseIdEleVal( whereClause);
				if(typeof(IncidentPageComp) != 'undefined' 
					&& IncidentPageComp.ComponentVars.CategoryID != null && typeof(IncidentPageComp.ComponentVars.CategoryID) != 'undefined' && IncidentPageComp.ComponentVars.CategoryID != 'undefined'
					&& IncidentPageComp.ComponentVars.UserID != null && typeof(IncidentPageComp.ComponentVars.UserID) != 'undefined' && IncidentPageComp.ComponentVars.UserID != 'undefined' && objFldArray[0] == 'SRM_RequestDefinition__c'){
					selectedCatId = document.getElementById(IncidentPageComp.ComponentVars.CategoryID).value;
                    selectedClientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;	
					showdata(selectedClientId, selectedCatId);
				}else{
					showdata();
				}
				waitbox(0);
			}else{
			   condition='';
				if(typeof(accountPopupFlag) !== 'undefined' && objFldArray[0] == 'Account')
					accountPopupFlag = false;			
				inProgress = false;
			}    
		}else{  
			inProgress = false;
		}	  
	 } 
	   // alert('exiting');
        
}

function showalldata(eventObject,onCompleteFunction,whereClause,windownameflag){
                            //alert('windownameflag :' + windownameflag)
    showTbData(eventObject,onCompleteFunction,whereClause,windownameflag,null);
}

function onCompPopulate(val){
	var strnameidEle = getStrnameiddEleId();
	if(strnameidEle != null)
		strnameidEle.value = val;
	waitbox(0);
	showdata();
}

function checkValidityofRecord(){
		msgBox= Ext.MessageBox.show({                                
					title: ' ',
					width:190,
					msg:TaboutComponent.Labels.NoRecordsFound,
					buttons: Ext.MessageBox.OK
				});
}