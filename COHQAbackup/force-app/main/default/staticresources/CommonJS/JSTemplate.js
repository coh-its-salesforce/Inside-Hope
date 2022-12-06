 function setTemplVal(fldId, fldVal){          
    var fieldValue=''+fldVal;
    var fieldId=fldId;
	if(fldId == 'FKClient__c'){
        fieldId = 'User_id_username';
    }
    if(fldId == 'FKBroadcast__c'){
                fieldId = 'Broadcasts__c_id_name';
        }
	if(fldId == 'FKBusinessService__c'){
	    fieldId ='BMC_BusinessService__c_id_instance_name__c';
		}else if(fldId == 'FKServiceOffering__c'){
			fieldId ='BMC_BusinessService__c_id_instance_name__c__x_1';
		}else if(fldId == 'BMC_BusinessService__c_id_fkbmc_baseelement__c__xx_1'){
			fieldId = 'BMC_BusinessService__c_id_fkbmc_baseelement__c__x_1';
	}	
    if(fldId == 'FKAccount__c'){
	    fieldId ='Account_id_name';
	}
	if(fldId == 'Account__c_id_id'){
	    fieldId ='Account_id_id';
	}
    var sss=fieldId.substring(0,2);
            if(sss=='FK'){
                fieldId=fieldId.substring(2);
                fieldId=fieldId+'_id_name';
           }
            var element = null;
            var elementsforText=null;
            var elementID = null;
            var elements = document.getElementsByTagName('*');
            var len = elements.length;
            var arrEle = new Array(len);
                while(len!=0){
                    element = elements[len];
                    if(element!=null){
                       elementID = element.id;
					   if(elementID.match(fieldId)!=null){
						   if(elements[len].type=='checkbox'){
                                document.getElementById(elementID).checked = fieldValue;
                            }else{
									if((fldId == 'FKBusinessService__c' && elementID.indexOf('BMC_BusinessService__c_id_instance_name__c__x_1') != -1) || (fldId=='BMC_BusinessService__c_id_fkbmc_baseelement__c' && elementID.indexOf('BMC_BusinessService__c_id_fkbmc_baseelement__c__x_1') != -1)){
										len--;
										continue;
									}
                                document.getElementById(elementID).value = fieldValue;
								// This code is added to populate the hidden element with id "clientHiddnenInput" on IncidentPage. This is required bcz if this elem is not populated
								// bing last elem bind to FKClient it's value is assigned to incidnet.FKClient__c
								if(fieldId == 'User_id_id'){
									if(typeof(IncidentPageComp) != 'undefined' && IncidentPageComp.ComponentVars.TipUserID != null && typeof(IncidentPageComp.ComponentVars.TipUserID) != 'undefined'){
										document.getElementById(IncidentPageComp.ComponentVars.TipUserID).value = fieldValue;
									}
								}
                                if(typeof(document.getElementById(elementID).onblur)=='function'){
					//.focus() gives an  error when we try to focus an invisible field like Broadcast ID,hence exclude the broadcast from focus()
								  if(elementID!=IncidentPageComp.ComponentVars.BroadcastIDName){
									try{
                                    document.getElementById(elementID).focus();
                                    document.getElementById(elementID).blur();
									document.getElementById(elementID).isCalledFromTemplate = 'true';
									}catch(e){}
								  }
                                }
							}
                        }                                      
                    }
                    len--;
                } 
            
            }
			
 function setTaskTemplVal(fldId, fldVal){          
			   var fieldValue=''+fldVal;
			   var fieldId=fldId;
			   if(fldId == 'FKClient__c'){
			        fieldId = 'User_id_username';
			   }
			   if(fldId == 'FKBroadcast__c'){
			        fieldId = 'Broadcasts__c_id_name';
			   }
    			var sss=fieldId.substring(0,2);
            	if(sss=='FK'){
                	fieldId=fieldId.substring(2);
                	fieldId=fieldId+'_id_name';
            	}
            var element = null;
            var elementsforText=null;
            var elementID = null;
            var elements = document.getElementsByTagName('*');
            var len = elements.length;
            var arrEle = new Array(len);
                while(len!=0){
                    element = elements[len];
                    if(element!=null){
                       elementID = element.id;
                       if(elementID.match(fieldId)!=null){
							//alert('elementID == fieldId  : ' + elementID + '  ' + fieldId );   
							if(document.getElementById(elementID).getAttribute('infieldset') == 'true'){
								//alert('elements[len].nextSibling.tagName : ' + elements[len].nextSibling.tagName);
								if(elements[len].nextSibling.tagName == 'SCRIPT'){
									//alert('1');
                       				if(elements[len].nextSibling.nextSibling.tagName == 'INPUT'){
                       					//alert('2')
                       					//alert('elements[len].nextSibling.nextSibling.tagName : ' + elements[len].nextSibling.nextSibling.tagName);
                       					//alert('3');
                       					//alert('elements[len].nextSibling.nextSibling.type ' + elements[len].nextSibling.nextSibling.type);
                       					//alert('4');
                       					if(elements[len].nextSibling.nextSibling.type == 'checkbox'){
                       						//alert('5');
                       						elements[len].nextSibling.nextSibling.checked = fieldValue;
                       						//alert('6');
                       					}else{
                       						//alert('7');
                       						elements[len].nextSibling.nextSibling.value = fieldValue;
                       						//alert('8');
                       					}	
                       				}else if(elements[len].nextSibling.nextSibling.tagName == 'SELECT'){
                       					elements[len].nextSibling.nextSibling.value = fieldValue;
                       				}else if(elements[len].nextSibling.nextSibling.tagName == 'DIV'){	
                       					//alert('elements[len].nextSibling.className  ' + elements[len].nextSibling.className);
	                       				if(elements[len].nextSibling.nextSibling.className == 'requiredInput'){
	                       					if(elements[len].nextSibling.nextSibling.childNodes[1] != null && typeof(elements[len].nextSibling.nextSibling.childNodes[1]) != 'undefined'){
	                       						elements[len].nextSibling.nextSibling.childNodes[1].value = fieldValue;
	                       					}
	                       				}
                       				}
                       			}else if(elements[len].nextSibling.tagName == 'DIV'){
                       				//alert('9');
                       				if(elements[len].nextSibling.className == 'requiredInput'){
                       					if(elements[len].nextSibling.childNodes[1] != null && typeof(elements[len].nextSibling.childNodes[1]) != 'undefined'){
                       						elements[len].nextSibling.childNodes[1].value = fieldValue;
                       					}
                       					//childNodes[1].childNodes[2]
                       				}
                       			
                       			}else{
                       				if(elements[len].nextSibling.type == 'checkbox' ){
                       					elements[len].nextSibling.checked = fieldValue;
                       				}else{
                       					elements[len].nextSibling.value = fieldValue;
                       				}
                       				
                       			}
							}else{
		                          if(elements[len].type=='checkbox'){
		                               document.getElementById(elementID).checked = fieldValue;
		                           }else{
		                           	   //alert('elementID : ' + elementID);	
		                               document.getElementById(elementID).value = fieldValue;
		                               	if(typeof(document.getElementById(elementID).onblur)=='function'){
		                               		//alert('in if');
		                					//.focus() gives an  error when we try to focus an invisible field like Broadcast ID,hence exclude the broadcast from focus()
			                           		try{	
												document.getElementById(elementID).focus();
			                                	//alert('2');
			                                	document.getElementById(elementID).blur();
			                                	//alert('3');
			                                	document.getElementById(elementID).isCalledFromTemplate = 'true';
			                            	}catch(e){}
										}
		                           	}
	                          }
                        }                                      
                    }
                    len--;
                } 
            
            }
			
function setChangeTemplVal(fldId, fldVal){      
          	//alert('in :   fldId  :' +  fldId + ' fldVal  :' + fldVal);    
	        var fieldValue=''+fldVal;
	        var fieldId=fldId;
	        if(fldId == 'FKInitiator__c'){
	            fieldId = 'User_id_username';
	        }
	        var substr = fieldId.substring(0,2);
	           if(substr=='FK'){
	                fieldId=fieldId.substring(2);
	                fieldId=fieldId+'_id_name';
	           }
	           var element = null;
	           var elementID = null;
	           var elements = document.getElementsByTagName('*');
	           var len = elements.length;
	           var arrEle = new Array(len);
	               while(len!=0){
	                   element = elements[len];
	                   if(element!=null){
	                      elementID = element.id;
						if(elementID.match(fieldId)!=null){
						//alert('elementID == fieldId  : ' + elementID + '  ' + fieldId );   
							if(document.getElementById(elementID).getAttribute('infieldset') == 'true'){
								//alert('elements[len].nextSibling.tagName : ' + elements[len].nextSibling.tagName);
								if(elements[len].nextSibling.tagName == 'SCRIPT'){
									//alert('1');
                       				if(elements[len].nextSibling.nextSibling.tagName == 'INPUT'){
                       					//alert('2')
                       					//alert('elements[len].nextSibling.nextSibling.tagName : ' + elements[len].nextSibling.nextSibling.tagName);
                       					//alert('3');
                       					//alert('elements[len].nextSibling.nextSibling.type ' + elements[len].nextSibling.nextSibling.type);
                       					//alert('4');
                       					if(elements[len].nextSibling.nextSibling.type == 'checkbox'){
                       						//alert('5');
                       						elements[len].nextSibling.nextSibling.checked = fieldValue;
                       						//alert('6');
                       					}else{
                       						//alert('7');
                       						elements[len].nextSibling.nextSibling.value = fieldValue;
                       						//alert('8');
                       					}	
                       				}else if(elements[len].nextSibling.nextSibling.tagName == 'SELECT'){
                       					elements[len].nextSibling.nextSibling.value = fieldValue;
                       				}else if(elements[len].nextSibling.nextSibling.tagName == 'DIV'){	
                       					if(elements[len].nextSibling.nextSibling.className == 'requiredInput'){
	                       					if(elements[len].nextSibling.nextSibling.childNodes[1] != null && typeof(elements[len].nextSibling.nextSibling.childNodes[1]) != 'undefined'){
	                       						elements[len].nextSibling.nextSibling.childNodes[1].value = fieldValue;
	                       					}
	                       				}
                       				}
                       			}else if(elements[len].nextSibling.tagName == 'DIV'){
                       				if(elements[len].nextSibling.className == 'requiredInput'){
                       					if(elements[len].nextSibling.childNodes[1] != null && typeof(elements[len].nextSibling.childNodes[1]) != 'undefined'){
                       						elements[len].nextSibling.childNodes[1].value = fieldValue;
                       					}
                       				}
                       			
                       			}else{
                       				if(elements[len].nextSibling.type == 'checkbox' ){
                       					elements[len].nextSibling.checked = fieldValue;
                       				}else{
                       					elements[len].nextSibling.value = fieldValue;
                       				}
                       				
                       			}
							}else{
		                          if(elements[len].type=='checkbox'){
		                               document.getElementById(elementID).checked = fieldValue;
		                           }else{
		                           	   //alert('elementID : ' + elementID);	
		                               document.getElementById(elementID).value = fieldValue;
		                               	if(typeof(document.getElementById(elementID).onblur)=='function'){
		                               		//alert('in if');
		                					//.focus() gives an  error when we try to focus an invisible field like Broadcast ID,hence exclude the broadcast from focus()
			                           		if(elementID != rolloutComponent && elementID != backoutComponent && elementID != resonforChangeComponent){
			                                	try{
												document.getElementById(elementID).focus();
			                                	//alert('2');
			                                	document.getElementById(elementID).blur();
			                                	//alert('3');
			                                	document.getElementById(elementID).isCalledFromTemplate = 'true';
											}catch(e){}
			                              	}
			                            }
		                           	}
	                          }
	                       }                                      
	                   }
	                   len--;
	               } 
            
            }
	//This js function is add in order to add the value to the dependent picklist field. 	
function setChangeVal(fldId, fldVal){  
	        var fieldValue=''+fldVal;
	        var fieldId=fldId;
	           var element = null;
	           var elementID = null;
	           var elements = document.getElementsByTagName('*');
	           var len = elements.length;
	           var arrEle = new Array(len);
	               while(len!=0){
				   
	                 element = elements[len-1];
	                   if(element!=null){
	                      elementID = element.id;
						if(elementID.match(fieldId)!=null){
							if(document.getElementById(elementID).getAttribute('infieldset') == 'true'){
								if(elements[len-1].nextSibling.tagName == 'SPAN'){
									elements[len-1].nextSibling.childNodes[0].value = fieldValue;
								}
							  }
							 }
	                       }                                     
	                   
	                   len--;
					  }
	              } 
function setTemplValForCustInc(fldId, fldVal){          
	var fieldValue=''+fldVal;
	var fieldId=fldId;
	if(fldId == 'FKClient__c'){
		fieldId = 'User_id_username';
	}
	if(fldId == 'FKBroadcast__c'){
		fieldId = 'Broadcasts__c_id_name';
	}
	if(fldId == 'FKBusinessService__c'){
	    fieldId ='BMC_BusinessService__c_id_instance_name__c';
	}else if(fldId == 'FKServiceOffering__c'){
		fieldId ='BMC_BusinessService__c_id_instance_name__c__xx_1';
	}
	if(fldId == 'FKAccount__c'){
	    fieldId ='Account_id_name';
	}
	if(fldId == 'Account__c_id_id'){
	    fieldId ='Account_id_id';
	}
	var sss=fieldId.substring(0,2);
	if(sss=='FK'){
		fieldId=fieldId.substring(2);
		fieldId=fieldId+'_id_name';
	}
	var element = null;
	var elementsforText=null;
	var elementID = null;
	var elements = document.getElementsByTagName('*');
	var len = elements.length;
	var arrEle = new Array(len);
	while(len!=0){
		element = elements[len];
		if(element!=null){
			elementID = element.id;
			if(elementID.match(fieldId)!=null){
				if(document.getElementById(elementID).getAttribute('fieldType') == 'Custom'){
					if(elements[len].nextSibling!=null && elements[len].nextSibling.type=='textarea'  ){
							elements[len].nextSibling.value = fieldValue;
					}else if(elements[len].previousSibling != null){
						var checkboxEle =  elements[len].previousSibling.previousSibling;
						if(checkboxEle != null && checkboxEle.type == 'checkbox'){
							elements[len].previousSibling.previousSibling.checked = fieldValue;
						}else{
						//alert('5');
							if(Ext.isIE){
								if(elements[len].previousSibling.tagName == 'DIV' && elements[len].previousSibling.className == 'requiredInput'){
									if(elements[len].previousSibling.childNodes[1] != null &&  typeof(elements[len].previousSibling.childNodes[1]) != 'undefined'){
										elements[len].previousSibling.childNodes[1].value = fieldValue;
									}
								}else{
									elements[len].previousSibling.previousSibling.value = fieldValue;
								}
							}else{
								//alert('11');
								if(elements[len].previousSibling.previousSibling.tagName == 'DIV'){
									//alert('22');
									if(elements[len].previousSibling.previousSibling.className == 'requiredInput'){
										//alert('33');
										if(elements[len].previousSibling.previousSibling.childNodes[1] != null && typeof(elements[len].previousSibling.previousSibling.childNodes[1]) != 'undefined'){
											//alert('44');
											elements[len].previousSibling.previousSibling.childNodes[1].value = fieldValue;
										}
									}
								}else{
									elements[len].previousSibling.previousSibling.value = fieldValue;
								}
							}
						}
					 }
				}else{
					if(elements[len].type=='checkbox'){
						document.getElementById(elementID).checked = fieldValue;
					}else{
						// This code block is added to skip population of Service Offering value with Service lookup value
						if((fldId == 'FKBusinessService__c' && elementID == 'BMC_BusinessService__c_id_instance_name__c__xx_1') || (fldId=='BMC_BusinessService__c_id_fkbmc_baseelement__c' && elementID=='BMC_BusinessService__c_id_fkbmc_baseelement__c__xx_1')){
							len--;
							continue;
						}
						document.getElementById(elementID).value = fieldValue;
						// This code is added to populate the hidden element with id "clientHiddnenInput" on IncidentPageCustom. This is required bcz if this elem is not populated
						// bing last elem bind to FKClient it's value is assigned to incidnet.FKClient__c
						if(fieldId == 'User_id_id'){
							if(typeof(IncidentPageComp) != 'undefined' && IncidentPageComp.ComponentVars.TipUserID != null && typeof(IncidentPageComp.ComponentVars.TipUserID) != 'undefined'){
								document.getElementById(IncidentPageComp.ComponentVars.TipUserID).value = fieldValue;
							}
						}
						if(typeof(document.getElementById(elementID).onblur)=='function'){
							//.focus() gives an  error when we try to focus an invisible field like Broadcast ID,hence exclude the broadcast from focus()
							if(elementID!=IncidentPageComp.ComponentVars.BroadcastIDName){
								try{
									document.getElementById(elementID).focus();
									document.getElementById(elementID).blur();
									document.getElementById(elementID).isCalledFromTemplate = 'true';
									}catch(e){}
							}
						}
					}
				}
			}                                      
		}
		len--;
	} 
}
