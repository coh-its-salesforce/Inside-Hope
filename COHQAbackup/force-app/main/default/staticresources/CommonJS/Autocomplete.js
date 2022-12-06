function findIt(sel,divId,field,evt)
    {      
           isAutocomplete= false;
           var selobj = document.getElementById(sel);
		   var divobject = document.getElementById(divId);
           evt=window.event || evt;
            var iKeyCode = evt.keyCode;
            if(iKeyCode == 13){ //return key
                selectId=0;
                SelectValue(selobj, divId);
                return;
            }
           
          // list = null;
           var fldVal = escSpeChars(field.value);
		   var id=''+ field.id;
		   var customLeft= Ext.isIE8 ? 800:797;
           if(id.indexOf('Impact') != -1){
             list = impactData;
			 if(Ext.isIE7){
				divobject.style.top = 62+'px';
				divobject.style.left = 83+'px';
				selobj.style.width = 130+'px';
			 }
			 if(isDormantSection)
			  divobject.style.left = customLeft+'px';
           }else if(id.indexOf('Urgency')!= -1){
             list = urgencyData;
			 if(Ext.isIE7){
				divobject.style.top = 86+'px';
				divobject.style.left = 83+'px';
				selobj.style.width = 130+'px';
			 }
			 if(isDormantSection)
			  divobject.style.left = customLeft+'px';
           }else if(divId.indexOf('Category') != -1){
             if(field.value!='' && field.value!=null){
			  fetchCategoryData(sel,divId,field,iKeyCode,'incident');
			 }else{
			  selobj.style.height ='0px';
              document.getElementById(divId).style.visibility='hidden';
			 }
			 if(Ext.isIE7){
				divobject.style.top = 151+'px';
				divobject.style.left = 91+'px';
				selobj.style.width = 195+'px';
			 }
           }
		   if(divId.indexOf('Category') == -1){
		    findAutoCompleteSelectOptions(sel,divId,field,iKeyCode);
		   }
           
    }
function findAutoCompleteSelectOptions(sel,divId,field,iKeyCode)
 {  
	var selobj = document.getElementById(sel);
           var len = list.length;
           selobj.options.length = 0;
           if(field.value.length > 0){
                
                var reg = new RegExp("^"+field.value,"i");
                var tmp = null;
                var cnt = 0;
                var msg = "";
                for(var i = 0;i < len;i++)
                {
                    var dataObj = list[i];
                    if(reg.test(dataObj['val'])){
                        document.getElementById(divId).style.visibility='visible';
                        tmp=document.createElement("option");
                        tmp.setAttribute("value",dataObj['val']);
                        tmp.setAttribute("id",dataObj['id']); 
                        tmp.setAttribute("class","clsOption")
                        tmp.appendChild(document.createTextNode(dataObj['val']));
                        selobj.appendChild(tmp);
                        cnt++;
                    }
               } 
               if(selobj.options.length >0){
                   
                    if(Ext.isIE7){
                        selobj.style.height = (cnt*15)+4+'px';
                    }else if(Ext.isIE8){
					    selobj.style.height = (cnt*13)+2+'px';
					}else{
                        selobj.style.height = (cnt*15)+4+'px';
					}
                   
               }else{
                    selobj.style.height ='0px';
                    document.getElementById(divId).style.visibility='hidden';
               }
                    
           }else{
                document.getElementById(divId).style.visibility='hidden';
           }
            if(selobj.selectedIndex == -1 && cnt > selectId ) 
            selobj.selectedIndex = selectId;   
            else
               	selobj.selectedIndex = 0;
            switch(iKeyCode){
                case 38: //up arrow
                      if(selectId >0)
                        selobj.selectedIndex = selectId - 1;
                        selectId--;
                     break;
                 case 40: //down arrow
                        
                        if(selectId < selobj.options.length-1){
                            selobj.selectedIndex++;      
                            selectId++; 
                        }else
                            selobj.selectedIndex = selectId; 
                            break;
                 case 13: //return key
                         selectId = 0;
                     SelectValue(selobj, divId)
                     break;
             }
    }
    function disableDiv(divId){
        if(isAutocomplete){
			clientPopupInprogress = true;
            return ; 
		}
        clientPopupInprogress = false;        
        document.getElementById(divId).style.visibility='hidden';
    }
    function findClients(sel,divId,field,evt){
        var selobj = document.getElementById(sel);
        evt=window.event || evt;
        iKeyCodeEvt = evt.keyCode;
        selectIdForAutoCom=sel;
        divIdForAutoCom=divId;
        fieldForAutoCom = field;
        eventFoeAutoCom = evt;
        var clientFor;
        var fldClient = escSpeChars(field.value);
		if(field.value.length >= 2){
            if(iKeyCodeEvt == 13){
               selectClientId=0
               SelectValue(selobj, divId);
               return;
            }
           var id=''+ field.id;
           if(id.indexOf('firstname') != -1){
             clientFor ='f';
           }else if(id.indexOf('lastname')!= -1){
             clientFor ='l';
           }else if(id.indexOf('username') != -1){
             clientFor ='u';
           }
            if(list !='[]' && list!=''){
                var reg = new RegExp("^"+fldClient,"i");
                var useCurrentList = false;
                var len = list.length;
                for(var i = 0;i < len;i++)
                {
                    var dataObj = list[i];
                    if(reg.test(dataObj[clientFor])){
                        useCurrentList=true;
                        break;
                    }
               } 
               if(useCurrentList){
                    findClientOption();
                    useCurrentList = false;         
               }else{
                    document.getElementById(divId).style.visibility='hidden';
                    fetchClientData(clientFor,field.value); 
               }
            }else{
                document.getElementById(divId).style.visibility='hidden'; 
                fetchClientData(clientFor,field.value);
            }    
        }else{
            document.getElementById(divId).style.visibility='hidden';
        }
    }
    function findClientOption()
    {      
           sel = selectIdForAutoCom;
           divId = divIdForAutoCom; 
           field = fieldForAutoCom;
           evt = eventFoeAutoCom;
           isAutocomplete= false;
           var selobj = document.getElementById(sel);
		   var divobj = document.getElementById(divId);
           if(iKeyCodeEvt == 13){
                selectClientId=0;
                SelectValue(selobj, divId);
                return;
            }
           var fldClientOption = escSpeChars(field.value);
		   var clientFor;
           var optionLength= '';
           var id=''+ field.id;
           if(id.indexOf('firstname') != -1){
             clientFor ='f';
           }else if(id.indexOf('lastname')!= -1){
             clientFor ='l';
           }else if(id.indexOf('username') != -1){
             clientFor ='u';
           }
            var len = list.length;
           selobj.options.length = 0;
           if(field.value.length > 0)
           {
                var reg = new RegExp("^"+fldClientOption,"i");
                var tmp = null;
                var count = 0;
                var msg = "";
                var length = 0;
                for(var i = 0;i < len;i++)
                {
                    var dataObj = list[i];
                    if(reg.test(dataObj[clientFor])){
                        document.getElementById(divId).style.visibility='visible';
                        tmp=document.createElement("option");
                        tmp.setAttribute("value",dataObj[clientFor]);
                        tmp.setAttribute("id",dataObj['i']); 
                        if(clientFor == 'l'){
							tmp.setAttribute("title",dataObj['l']+', '+dataObj['f']+' - '+dataObj['u']); 
                            tmp.appendChild(document.createTextNode(dataObj['l']+', '+dataObj['f']+' - '+dataObj['u']));
							if(Ext.isIE7){
								divobj.style.top = 77+'px';
								divobj.style.left = 91+'px';
						    }
                        }else if(clientFor == 'f'){
                        	tmp.setAttribute("title",dataObj['f']+', '+dataObj['l']+' - '+dataObj['u']); 
                            tmp.appendChild(document.createTextNode(dataObj['f']+' '+dataObj['l']+' - '+dataObj['u']));
							if(Ext.isIE7){
								divobj.style.top = 100+'px';
								divobj.style.left = 91+'px';
						    }
                        }else if(clientFor == 'u'){
                        	tmp.setAttribute("title",dataObj['u']+', '+dataObj['l']+' - '+dataObj['f']); 
                            tmp.appendChild(document.createTextNode(dataObj['u']+' - '+dataObj['l']+', '+dataObj['f']));
							if(Ext.isIE7){
								divobj.style.top = 125+'px';
								divobj.style.left = 91+'px';
						    }
                        }
                        selobj.appendChild(tmp);
                        optionLength =dataObj['u']+' - '+dataObj['l']+', '+dataObj['f']; 
						if(length < optionLength.length)
								length = optionLength.length;
                        count++;
                    }
               } 
                //selobj.selectedIndex =selectClientId;
                if(selobj.options.length >0){
                    length = (length*6)+20;
                    if(Ext.isIE){
                        selobj.style.height = (count*13)+2+'px';
						if(Ext.isIE7){
                          selobj.style.height = (count*15)+4+'px';
                        }
                        if(length < 204)
                        	selobj.style.width = 204+'px';
                    else
                        	selobj.style.width = length+'px';
                    }else{
                        selobj.style.height = (count*13)+5+'px';
                        if(length < 204)
                        	selobj.style.width = 204+'px';
                        else
                        	selobj.style.width = length+'px';  // (length*6)+20
                    }
           		}else{
	                    selobj.style.height ='0px';
	                    length=0;
                		document.getElementById(divId).style.visibility='hidden';
           		}
           }else{
           		length = 0;
                document.getElementById(divId).style.visibility='hidden';
           }
           
           if((selobj.selectedIndex == -1 || selobj.selectedIndex == 0) && count > selectClientId ) 
            	selobj.selectedIndex = selectClientId;   
            else
               	selobj.selectedIndex = 0;
            switch(iKeyCodeEvt){
                case 38: //up arrow
                      if(selectClientId >0)
                        selobj.selectedIndex = selectClientId - 1;
                        selectClientId--;
                     break;
                 case 40: //down arrow
                        
                        if(selectClientId < selobj.options.length-1){
                            selobj.selectedIndex++;     
                            selectClientId++; 
                        }else
                            selobj.selectedIndex = selectClientId; 
                            break;
                 case 13: //return key
                         selectClientId = 0;
                     SelectValue(selobj, divId)
                     break;
             }
    }
    function fetchClientData(clientFor, searchString){
        var con = new Ext.data.Connection();
        con.request({
            url: 'apex/ClientDataPage',
            method: 'POST',  
            params: {"clientFor": clientFor, "startString": searchString},
            callback: function(opts, success, response){
	            if (success) {
	             var dq = Ext.DomQuery;
	             var xml = response.responseXML;
	             var node = dq.selectNode('data', xml);
	             if(list != null && node.firstChild != null){
					 list = eval('('+node.firstChild.nodeValue+')');
	                 findClientOption();
	             }
	             return;
	            }
            }
        });  
    }   
  function SelectValue(currentSelect, divId){
        var cIndex = currentSelect.selectedIndex;
        var option ='';
        if (cIndex > -1) {
           option = currentSelect.options[cIndex];
           if(divId.indexOf('Impact') != -1){
                document.getElementById(impId).value=option.value;
				document.getElementById(IncidentPageComp.ComponentVars.ImpactID).value=option.id;
				FetchPriorityHTTP();
            }else if(divId.indexOf('Urgency') != -1){
                 document.getElementById(urgId).value=option.value;
				document.getElementById(IncidentPageComp.ComponentVars.UrgencyID).value=option.id;
				FetchPriorityHTTP();
            }else if(divId.indexOf('Category') != -1){
                 document.getElementById(catId).value =option.value;
				var len = list.length;
                for(var i = 0; i< len; i++){ 
                    var dataObj = list[i];
                    if(dataObj['id'] == option.id){
                        document.getElementById(IncidentPageComp.ComponentVars.CategoryID).value=option.id;
					    document.getElementById(IncidentPageComp.ComponentVars.CategoryFKUrgency).value=dataObj['u'];
						FetchUrgencyHTTP();
						setIncForCategoryEnabled();
					 break;
                    }
                }
            }else if(divId.indexOf('ClientLN') != -1 || divId.indexOf('ClientFN') != -1 || divId.indexOf('ClientUN') != -1){
                 var len = list.length;
                 for(var i = 0; i< len; i++){
                    var dataObj = list[i];
                    if(dataObj['i'] == option.id){
                       document.getElementById(clLname).value =dataObj['l'];
                       document.getElementById(clFname).value =dataObj['f'];
                       document.getElementById(clUname).value =dataObj['u'];
					   if(typeof(clPhone) !== 'undefined')
					   {
					      document.getElementById(clPhone).value= dataObj['p'];
					   }
					   if(typeof(clExtension) !== 'undefined')
					   {
							document.getElementById(clExtension).value= dataObj['e'];
					   }
					   
					   if(dataObj['a'] != 'null'){
							if(typeof(accname) !== 'undefined'){
								if(typeof(accountPopupFlag) !== 'undefined' && accountPopupFlag == false){
									var str = dataObj['a'];
									var straccid = dataObj['ai'];
									//str = str.replace(/\+/g, " ");
									document.getElementById(accname).value = str;
									if(typeof(clAccname) !== 'undefined')
									{
										document.getElementById(clAccname).value=str;
									}
									incAccountName = str;
									var varIncAccountId = document.getElementById(incAccountId);
									if(varIncAccountId != 'undefined' && varIncAccountId != null && varIncAccountId != ''){
										varIncAccountId.value = straccid;
									}
								}
							}
						}
						else
						{
							document.getElementById(accname).value = '';
							if(typeof(clAccname) !== 'undefined')
							{
								document.getElementById(clAccname).value='';
							}

						}
					   document.getElementById(IncidentPageComp.ComponentVars.UserID).value = option.id;
					   document.getElementById(IncidentPageComp.ComponentVars.TipUserID).value = option.id;
					   if(dataObj['urg'] != 'null'){
					   		document.getElementById(IncidentPageComp.ComponentVars.clientFKUrgency).value=dataObj['urg'];
					   }else{
					   		document.getElementById(IncidentPageComp.ComponentVars.clientFKUrgency).value='';
					   }
					   remoteCallFlag = false;
					   FetchUrgencyHTTP();
                       break;  
                    }
                 }
             }
            
          isAutocomplete = true;
        }
        document.getElementById(divId).style.visibility='hidden';
    }    
    
            
