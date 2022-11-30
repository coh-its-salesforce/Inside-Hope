var isChanged=false;

    function onSaveComplete(){
    	if(errMsg != null || errMsg !=''){
    		if(errMsg == saveMsg){
    			window.parent.bmcFpError = '';
    		}else{
    			window.parent.bmcFpError = errMsg; 
    		}
    		window.parent.isComplete();
    	}
    }
    function showValidationMsg(){
	    if(errMsg != null || errMsg !=''){
	    	if(errMsg == validCreds){
	            window.parent.showACErrMsg(errMsg,false);
	        }else{
	        	window.parent.showACErrMsg(errMsg,true);
	        }
	    }
    }
    function SaveBtnHandler(){
		window.parent.bmcFpError = '';
    	setGridData();
		var isTimevalid = setProcessorData();
		if(isTimevalid){
			if(isChanged){
				handleAcSave();
			}else{
				handleACMappingSave();
			}
		}else{
			window.parent.isComplete();
		}
    };
    function handleAcSave(){
   		var enableACchk = getACEnableEle();
   		if(enableACchk != null){
   			if(enableACchk.checked){
				var allValuesValid = checkAllValuesValid();
   				if(allValuesValid){
	   				saveAcConfig();	
	    		}else if(!allValuesValid){
					window.parent.bmcFpError = acConfMissing;
	    			window.parent.isComplete();
	    		}
	   		}else{ 
	   			upsertEnableAC();
	   		}
   		} 
    }
	function handleACMappingSave(){
    	var enableACchk = getACEnableEle();
		if(enableACchk != null){
   			if(enableACchk.checked){
				saveAcMapping();
			}else{
				window.parent.isComplete();
			}
		}
    }
	function allValuesEntered(){
    	var acServerName = getAcServerNameEle();
 		var acServerPort = getACPortEle();
 		var acUserName = getACUserNameEle();
 		var acPassword = getACPwdEle();
 		if((acServerName != null && acServerName.value != '') && (acServerPort != null && acServerPort.value != '') && (acUserName != null && acUserName.value != '') && (acPassword != null && acPassword.value != '')){
 			return true;
 		}else{
			return false;
		}
	}
    function checkAllValuesValid(){
 		if(allValuesEntered()){
 			return true;
 		}else{
			var enableACchk = getACEnableEle().checked;
			if(enableACchk){
				showExtJSmessage(acConfMissing);
				return false;
			}else{
				return true;
			}
 			
 		}
    }
    
 	function validateACcredsJS(){
 		var allValuesValid  = checkAllValuesValid();
 		if(allValuesValid){
 			validateACcreds();
 		}
 	}
 	 
	function toggleAC(isEnabled){
    	if(isEnabled){
    		var acServerName = getAcServerNameEle();
    		if(acServerName != null)
    			acServerName.disabled = false;
    		var acServerPort = getACPortEle();
    		if(acServerPort != null)
    			acServerPort.disabled = false;
    		var acUserName = getACUserNameEle();
    		if(acUserName != null)
    			acUserName.disabled = false;
    		var acPassword = getACPwdEle();
    		if(acPassword != null)
    			acPassword.disabled = false;
			
			Ext.getCmp('MappingGrid').setDisabled(false);
			Ext.getCmp('processorhourFieldsId').setDisabled(false);
			Ext.getCmp('processorminuteFieldId').setDisabled(false);
			Ext.getCmp('processorbutton').setDisabled(false); 
    	}else{
    		var acServerName = getAcServerNameEle();
    		if(acServerName != null)
    			acServerName.disabled = true;
    		var acServerPort = getACPortEle();
    		if(acServerPort != null)
    			acServerPort.disabled = true;
    		var acUserName = getACUserNameEle();
    		if(acUserName != null)
    			acUserName.disabled = true;
    		var acPassword = getACPwdEle();
    		if(acPassword != null)
    			acPassword.disabled = true;
				
			Ext.getCmp('MappingGrid').setDisabled(true);
			Ext.getCmp('processorhourFieldsId').setDisabled(true);
			Ext.getCmp('processorminuteFieldId').setDisabled(true);
			Ext.getCmp('processorbutton').setDisabled(true);
			
    	}
    }
    function checkNumbers(evt){
	    if (window.event != null && typeof(window.event) != 'undefined'){ 
	    	var charCode = window.event.keyCode; 
	    }else if(evt != null){ 
	    	var charCode = evt.which; 
	    }else{
	    	 return true; 
	    }
	    if (charCode > 31 && (charCode < 48 || charCode > 57)) { return false; }
	    return true;
	}
	function chkToEnableValidateBtn(){
		var validateCredentialsBtn = document.getElementById('validateCredentialsBtn');
		if(getACEnableEle().checked && getAcServerNameEle().value != '' && getACPortEle().value != '' && getACUserNameEle().value != '' && getACPwdEle().value != ''){
			validateCredentialsBtn.disabled = false;	
    		validateCredentialsBtn.style.color='#004376';
		}else{
			validateCredentialsBtn.disabled = true;	
    		validateCredentialsBtn.style.color='#808080';
		}
	}
	
	 Ext.onReady(function(){
		 
		orStore = new Ext.data.ArrayStore({
            fields:[
                {name:'OR_Status'},
                {name:'OR_StatusValue'},
                {name:'Status'},
                {name:'Status_ID'}]
        });
        
        orStore.loadData(orData);
		
		function getText(data, metadata, record, rowIndex, columnIndex, store){
			
			return '<table style="width: 99%"><tr>'+
				'<td style="width: 203px"><input readonly="readonly" id= "'+record.get('OR_StatusValue')+'" onkeypress="return statusBoxKeyPressed(event,'+rowIndex+')" class= "clsInputTextBox" type="text" value="'+data+'" /></td>'+
				'<td><input type="button" class="lookupIconOn" onClick="gridrowIndex = '+rowIndex+'; openStatusLookup()" />'+
				'</tr></table>';
		}
		
		
		
	 	var mappingGrid =new Ext.grid.GridPanel({
            id:'MappingGrid',
            renderTo:'mappingGrid',
	        store:orStore,
	        height:212,
			width:470,
	        columns:[{id:'OR_Status',header: ORStatusLabel, width: 220, sortable: false,menuDisabled: true, dataIndex: 'OR_Status'},
	        		 {id:'OR_StatusValue',header: "OR Status Value",  hidden:true, width: 220, sortable: false, menuDisabled: true,dataIndex: 'OR_StatusValue'},
	            	 {id:'Status',header:taskStatusLabel , width: 230, sortable: false,menuDisabled: true, dataIndex: 'Status',renderer :getText},
	            	 {id:'Status_ID',header: "Status_ID", hidden:true, sortable: false,menuDisabled: true, dataIndex: 'Status_ID'}],
	        stripeRows: true,
	        autoScroll:false,
	        autoExpandColumn: 'Status',
	        border:true,
			viewConfig:{
	               forceFit:true,
	               scrollOffset:0 
	           },
	        listeners: {
                  rowClick :function(grid,a,b){
                      gridrowIndex = a;
                  }
              }
        });
     	
     	
     	statusBoxKeyPressed = function(e,rowIndex){
			if(e.keyCode == Ext.EventObject.BACKSPACE || e.keyCode == Ext.EventObject.DELETE) {
				gridrowIndex = rowIndex;
				var rec = Ext.getCmp('MappingGrid').store.getAt(rowIndex);
				rec.set('Status_ID','');
				document.getElementById(rec.get('OR_Status')).value = ''; 
			}
		}
		
		
		
		//AC processor spinner Fields    
         		 
		ProcessorhourField = new Ext.ux.form.SpinnerField({
			id:'processorhourFieldsId',
			value:processordefaulthourvalue,
			minValue: 0,
			maxValue: 99,
			width:50,
			renderTo:'processorhourFieldTD',
			enableKeyEvents : true,
			maxLength:2,
			allowDecimals: false,
			autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
			listeners: {
				keydown :function( obj, e) {
					if(e.getKey()==109)
						e.stopEvent();
				},
				keyup :function( obj, e) {
					validateSpinnerField(obj, e);
				}
			}
		});
       
        processorminuteField = new Ext.ux.form.SpinnerField({
            id: 'processorminuteFieldId',
            type: 'spinnerfield',
            name: 'processorminuteFieldId',
            minValue: 0,         
            maxValue: 59,
			maxLength:2,
			autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
            value:processordefaultminutevalue,
            allowDecimals: false,
            enableKeyEvents : true,
            incrementValue: 1,
			renderTo:'processorminuteFieldTD',
            width:55,             
			listeners: {
				keydown :function( obj, e) {
					if(e.getKey()==109)
						e.stopEvent();
				},
				keyup :function( obj, e) {
					validateSpinnerField(obj, e);
				}
			}              
        });
          
		processorButton = new Ext.Button({
			id: 'processorbutton',
			name: 'processorbutton',
			text:'',
			renderTo:'processorButtonTD',
			width:200,
			handler: function(){
				
				if(processorButton.getText()==startbuttontext){
					var count = 0;
					var MappingAvailable = false;
					while(orStore.data.length > count) {
						if(orStore.getAt(count).get('Status_ID') != null && orStore.getAt(count).get('Status_ID') != ''){
							MappingAvailable = true; break;
						}
						count++;
					}
					
					if(!MappingAvailable){
						showACWarnMsg(processorWarningMsg);
					}else{
						Ext.getCmp('processorbutton').setText(stopbuttontext);
						Ext.getCmp('processorbutton').setDisabled(true);
						ScheduleJob();
					}
				}else{
					Ext.getCmp('processorbutton').setText(startbuttontext);
					Ext.getCmp('processorbutton').setDisabled(true);
					StopJob();
				} 
			}
		});   
        
       
		//Checking Any scheduled job is running or not 
  
       	if(!jobstatusflag)
       		Ext.getCmp('processorbutton').setText(startbuttontext);
        else
			Ext.getCmp('processorbutton').setText(stopbuttontext);
       		
        var enableAC = getACEnableEle();
			if(enableAC != null){
				toggleAC(enableAC.checked)
		}         
    });
    
    function openStatusLookup(){
       var record = Ext.getCmp('MappingGrid').store.getAt(gridrowIndex);
    	openPopup('SearchPage?popupId=Status&isLookup=true&idNameForPopUp=true&filterClause='+escape('inactive__c = false and appliesToTask__c = true'),setStatusValue,570,670,true);
    
    }
    
    function setStatusValue(statusId){
    	var grid=Ext.getCmp('MappingGrid');
    	if(statusId.indexOf(EF) > 0){
            var rec = grid.store.getAt(gridrowIndex);
            rec.set('Status_ID',statusId.split(EF)[0]);
            var obj = rec.get('OR_StatusValue');
            document.getElementById(obj).value = decodeVal(statusId.split(EF)[1]);
        }
    }
    
    
    function setGridData() {
		var gridStr = '';
		var count = 0;
		var statusId= '';
		while(orStore.data.length > count) {
			
			statusId =orStore.getAt(count).get('Status_ID');
			gridStr = gridStr + orStore.getAt(count).get('OR_StatusValue') + PE +statusId + nonPrint;

			count++;
		}
		
		document.getElementById(mappingGridDataComponent).value = gridStr;
	}
	function decodeVal(val) {
		val = val.replace("&gt;", ">", "g");
		val = val.replace("&lt;", "<", "g");
		val = val.replace("&quot;", "\"", "g");
		val = val.replace("&amp;", "&", "g");
		return val;
	}
	function setProcessorData(){
	    var processorInetervalData = 0;
        var processorhour ;
        var processormin ;
	    
	    if(ProcessorhourField.getValue()=== '' ){
        	window.parent.bmcFpError = timeMandatoryError; 
			window.parent.showACErrMsg(timeMandatoryError,false);
           	return false;
        }else{             
        	processorhour = ProcessorhourField.getValue();
        }
        if(processorminuteField.getValue()=== '' ){
        	window.parent.bmcFpError = timeMandatoryError; 
			window.parent.showACErrMsg(timeMandatoryError,false);
              return false;
        }else{ 
        	processormin = processorminuteField.getValue();
        }
         
        if (ProcessorhourField.getValue()== 0 && processorminuteField.getValue()== 0){
	        window.parent.bmcFpError = timeMandatoryError; 
			window.parent.showACErrMsg(timeMandatoryError,false);
	        return false;
        }
        processorInetervalData  = (parseInt(processorhour)*60) + parseInt(processormin);
        document.getElementById(processorIntervalDataComp).value = processorInetervalData;
		return true;
    }
	function showACWarnMsg(msg){
		Ext.Msg.show({
			msg: msg,
			buttons: Ext.Msg.YESNO,
			fn:  function(btn){
				if (btn == 'yes'){							
					Ext.getCmp('processorbutton').setText(stopbuttontext);
					Ext.getCmp('processorbutton').setDisabled(true);
					ScheduleJob();
					return true;
				}
			},
			icon: Ext.MessageBox.WARNING
		});
		return false; //always return false					
	}
