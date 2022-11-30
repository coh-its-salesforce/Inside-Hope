 function setDate(dateId){
            var dateFieldEle = document.getElementById('date_'+dateId);
            var divEle = document.getElementById(dateId);
            divEle.previousSibling.previousSibling.value = dateFieldEle.value;
       }
       
       function validateNumber(inpTxt,flag){
           var re = new RegExp('^[0-9]*$');
           if(!inpTxt.value.match(re)){
               msg = numberErrorMsg ;
               Ext.MessageBox.show({ msg: msg, buttons: Ext.MessageBox.OK,width:300,height:'auto'});
                  
           }else{
               if(flag == 'true'){
                   checkVisibility(flag);
               }
           }
       }
      var popupId;
      function setPopupId(id){
           popupId = id;
      }
     
      function lookupValue(idname){
           var EF =inputValuesInfoSeperator; //(separator)
           var referenceId;
           var referenceName;
           if(idname.indexOf(EF) > 0){
            referenceId = idname.split(EF)[0]; // Id of the record
            referenceName = idname.split(EF)[1]; // Name of the record.
           }
           var inpRef = document.getElementById('lookup_'+popupId);
           if(inpRef != null && idname!=null && idname!='' ){
               inpRef.value = idname;
                if(referenceName != undefined){
                   inpRef.previousSibling.previousSibling.value = decodeSpecialChar(referenceName);
                   inpRef.previousSibling.previousSibling.previousSibling.value = decodeSpecialChar(referenceName) ;
                   inpRef.previousSibling.previousSibling.previousSibling.previousSibling.value = referenceId ;
                   inpRef.previousSibling.previousSibling.previousSibling.onchange();
                }
           }
       }
       function setRefName(referenceName ){
          var inpRef = document.getElementById('lookup_'+popupId);
          if(inpRef != null){
             if(referenceName != undefined){
                inpRef.previousSibling.previousSibling.value = decodeSpecialChar(referenceName);
                inpRef.previousSibling.previousSibling.previousSibling.value = decodeSpecialChar(referenceName) ;
             }
          }
       }
        function checkVisibility(isCheckRequire){
            if(isCheckRequire == true || isCheckRequire =='true'){
                checkConditions();
            }
        }
        function setTextArea(id){
             var areaEle = document.getElementById(id);
             areaEle.previousSibling.previousSibling.value= areaEle.value;
        } 
        function getSelectedOptions(id,containerId){
            var fieldEle = document.getElementsByName(id);
            var val='';
            for( i = 0; i < fieldEle.length; i++ ){
                if(fieldEle[i].checked == true ){
                       val = fieldEle[i].value;
                     break;
                }   
            }
            var resArray = val.split(inputValuesInfoSeperator);
            var divEle = document.getElementById(containerId);
            if(resArray !=null && resArray.length==2){
                divEle.previousSibling.previousSibling.value = unescape(resArray[0]);
                divEle.previousSibling.previousSibling.previousSibling.value = unescape(resArray[1]);
            }
       }
	    function dynamicAssignApexErrorMessage(){
            if(msg == null || msg == ''){ // Condition if there is no error message to display from server side.
                msg = document.getElementById('dynamicApexMessageErrorPanelDiv').innerHTML;
                 msg = msg.substring(0,msg.toLowerCase().indexOf('</li>'));
                if(msg!=null && msg!=''){
                    Ext.MessageBox.show({ msg: msg, buttons: Ext.MessageBox.OK,width:300,height:'auto'});
                    return; 
                }
            }
        }
		function getSelectedPicklistOption(id, containerId) {
			var fieldEle = document.getElementById(id);
			if(!fieldEle) return; 
			var sIndex = fieldEle.selectedIndex;
            var val= fieldEle.options[sIndex].value;
            var resArray = val.split(inputValuesInfoSeperator);
            var divEle = document.getElementById(containerId);
            if(resArray !=null && resArray.length==2 && typeof(divEle) != 'undefined' && divEle != null){
                divEle.previousSibling.previousSibling.value = unescape(resArray[0]);
                divEle.previousSibling.previousSibling.previousSibling.value = unescape(resArray[1]);
            }
		}
  
     function createRadioInput(inpValues,resValue,id,isChangeNeedRefresh){
        	  var valArray='';
              if(inpValues != null && inpValues !=''){
                 valArray = inpValues.split(inputValuesSeperator);
              }
              var selectedFlag = false;
              var radioString='';
              for(var i = 0 ; i < valArray.length ; i++){
                    selectedFlag = false;
                    var inputInfo = valArray[i].split(inputValuesInfoSeperator);
                    if(resValue==null || resValue==''){
                        selectedFlag = inputInfo[2];
                        }
                    if(inputInfo[1]!=null && resValue!=null && resValue.trim()==inputInfo[0].trim()){
                        selectedFlag = true;
                    }
                    radioString +='<input type="radio" name="selectRadio_'+id+'" value="'+(escape(inputInfo[0])+inputValuesInfoSeperator+escape(inputInfo[1]))+'" id="selectRadio_'+id+'" onclick="getSelectedOptions(\'selectRadio_'+id+'\',\''+id+'\');checkVisibility(\''+isChangeNeedRefresh+'\');" ';
                    if(selectedFlag == true || selectedFlag =='true' ) 
                    radioString +=' checked ';
                    if(isViewMode==true || isViewMode=='true'){
                      radioString +=' disabled="'+isViewMode+'"';
                    }
                    radioString +='/><label for="selectRadio_'+id+'" class="clsPanelCheckBoxLabel">'+inputInfo[0]+'</label><br/>';
               }
              document.getElementById(id).innerHTML = radioString ;
              getSelectedOptions('selectRadio_'+id,id);
        }
        function createPickListInput(inpValues,resValue,id,isChangeNeedRefresh){
    	     var valArray='';
             if(inpValues != null && inpValues !=''){
                valArray = inpValues.split(inputValuesSeperator).sort();
               }
          
             var selectedFlag = false;
             var picklistString ='<select id="selectOption_'+id+'" class="picklistInputCls" onchange="getSelectedPicklistOption(\'selectOption_'+id+'\',\''+id+'\');checkVisibility(\''+isChangeNeedRefresh+'\');">';
             for(var i = 0 ; i < valArray.length ; i++){
                   selectedFlag = false;
                   var inputInfo = valArray[i].split(inputValuesInfoSeperator);
                   if(resValue==null || resValue==''){
                       selectedFlag = inputInfo[2];
                       }
                   if(inputInfo[1]!=null && resValue!=null && resValue.trim()==inputInfo[0].trim()){
                       selectedFlag = true;
                   }
                   picklistString +='<option value="'+(escape(inputInfo[0])+inputValuesInfoSeperator+escape(inputInfo[1]))+'"';
                   if(selectedFlag == true || selectedFlag =='true' ) 
                   picklistString +=' selected '; 
                   picklistString +='>'+inputInfo[0]+'</option>';
              }
             document.getElementById(id).innerHTML = picklistString ;
             getSelectedPicklistOption('selectOption_'+id,id);
        }
		
	  A4J.AJAX.XMLHttpRequest.prototype._copyAttribute = function (src, dst, attr) {
			var value = src.getAttribute(attr);
			if (value) {
				try {
					dst.setAttribute(attr, value);
				} catch (err) {
					//alert('Error with Salesforce: ' + err.description + '\nattr: ' + attr + '\n');
				}
			}
		};
	
      
       