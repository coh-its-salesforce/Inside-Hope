var pickListArray = new Array(),
	pickListComboStore,
	pickListComboBx;
Ext.onReady(function(){
		logOpeStore = new Ext.data.SimpleStore({
								id:'logOpeStore',
							    data: [
							        ['AND', 'AND'],
							        ['OR', 'OR'],
							        ['NONE','NONE']     
							    ],
							    fields: ['logOpeValue', 'logOpeName']
							});
        logicalOperator= new Ext.form.ComboBox({
								id:'logicalOperatorCombo',
						        store: logOpeStore,
						        mode: 'local',
						        triggerAction: 'all',
						        valueField: 'logOpeValue',
						        displayField: 'logOpeName',
						        selectOnFocus: true,
						        renderTo:'qualLogicalOperatorCombo',
						        editable: false,
								width:103,
								listWidth:120,
								height:13,
								emptyText:logicalConditionHeader
								
						    });
		compStore.text = [['=','='],['!=','!='],['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
	    compStore.number = [['>','>'],['>=','>='],['=','='],['!=','!='],['<','<'],['<=','<=']];
	    compStore.booleanVar = [['=','='],['!=','!=']];
		compStore.reference = [['=','='],['!=','!=']];
		compStore.dateTime = [['>','>'],['>=','>='],['=','='],['!=','!='],['<','<'],['<=','<=']];
		compStore.textArea = [['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
					 
	    comparisonOperator= new Ext.form.ComboBox({
						id:'compareOpCombo',
				        store: compStore.text,
				        mode: 'local',
				        triggerAction: 'all',
				        renderTo: 'compareOpDiv',
				        valueField: 'comOpeValue',
				        displayField: 'comOpeName',
				        editable: false,
						width:68,
						listWidth:85,
						height:13,
				        proxy: new Ext.data.MemoryProxy(compStore),
						emptyText:labelOperator
				    });    	
	    inputsComboStore = new Ext.data.JsonStore({
			        id: 'inputStore',
			        data: inputData,
					proxy: new Ext.data.MemoryProxy(inputData),
					fields: ['id', 'type','label','e']
		        	
			    });
		inputsEditor = new Ext.form.ComboBox({
					id: 'inputCombo',
					store: inputsComboStore,
					mode: 'local',
					triggerAction: 'all',
					valueField: 'id',
					displayField: 'label',
					renderTo:'extFieldList',
					editable: false,
					listWidth:150,
					width:133,
					height:13,
					emptyText:inputHeader,
					listeners:{
						select: function(combo, comboRecord, index){
							comparisonOperator.store.removeAll();
							var fieldType = comboRecord.get('type');
							if(fieldType.indexOf(':') > 0){
								fieldType = fieldType.split(':')[0];
							}else if(fieldType.indexOf(EF) > 0){
								fieldType = fieldType.split(EF)[0];
							}
							
							var idVal = this.store.getAt(index).get('id');
							var label = this.store.getAt(index).get('label');
							var type = this.store.getAt(index).get('type');
							var iValue = this.store.getAt(index).get('e');
							setComparisonOperatorStore(fieldType);
							setAddUpdateOnClick(null);
							setVisibilityData(idVal,iValue, label, type);
						}
					}			        
				});	
		pickListComboStore =new Ext.data.ArrayStore({
							        id: 'pickListFieldStore',
							        data: pickListArray,
							        fields: ['id','val'],
							        sortInfo: {
							                    field: 'val',
							                    direction: 'ASC'
							                }
							  });
						  
		pickListComboBx = new Ext.form.ComboBox({
							id: 'pickListFieldCombo',
							store: pickListComboStore,
							mode: 'local',
							triggerAction: 'all',
							valueField: 'id',
							displayField: 'val',
							selectOnFocus: true,
							editable: false,
							renderTo:'picklistCombo',
							hidden:true,
							width:148,
							listWidth:165
						});  
						
		booleanComboStore =new Ext.data.ArrayStore({
				        id: 'booleanFieldStore',
				        data: booleanArray,
				        fields: ['id','val']
				  });
			  
		booleanComboBx = new Ext.form.ComboBox({
					id: 'booleanFieldCombo',
					store: booleanComboStore,
					mode: 'local',
					triggerAction: 'all',
					valueField: 'id',
					displayField: 'val',
					selectOnFocus: true,
					editable: false,
					renderTo:'booleanCombo',
					hidden:true,
					width:148,
					listWidth:165
				});   						
			
      	var conditionGridColModel = new Ext.grid.ColumnModel({
    	    header: true,
			columns: [
    	              {dataIndex: 'orderIndex', header:conditionHeader, sortable: false,width: 80},
    	              {dataIndex: 'inputId', header:'Input Id', hidden:true},
    	              {dataIndex: 'inputName', header:inputHeader, sortable: false,width: 175},
    	              {dataIndex: 'operatorValue', header: operatorHeader, sortable: false,width: 80},
    	              {dataIndex: 'operandValue', header:operandHeader, sortable: false,width: 190},
    	              {dataIndex: 'ResponseType', hidden:true},
    	              {dataIndex: 'groupingOperator', header:logicalConditionHeader, sortable: false,width: 113}]
     		});
	
     conditionGridStore = new Ext.data.SimpleStore({
    	 fields:['orderIndex', 'inputId','inputName', 'operatorValue', 'operandValue','ResponseType', 'groupingOperator']
     });
	
     ConditionGrid = new Ext.grid.GridPanel({
    	 	 id:'conditionGrid',
	         store: conditionGridStore,
	         cm: conditionGridColModel,
	         columnLines: true,
	         enableHdMenu:false,
	         enableColumnResize: false,
	         enableColumnMove: false,         
	         width:'99%',
			 height:280,
			 border:false,
			 stripeRows:true,
			 layout: 'fit',
			 viewConfig:{forceFit:true,scrollOffset:0 },
			 sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			 listeners:{
				
				rowClick: function(thisGrid, rowIndex, e ){
					setInputDataAndElementsOnRowClick(rowIndex);
				}			
			 }
     });
	  ConditionGrid.render('conditionGridDiv');
	if(window.parent.infixCondition != null && window.parent.infixCondition != '')
		getData(window.parent.infixCondition);
	else
	  loadDataToGrids();
	  
})

	
	function setVisibilityData(idVal,iValue, label, type, elementVal, opVal, groupOp){
		isInList = false;
        var dataLength =  inputData.length;
        selectedApiName = iValue;
		selectedLabel = label;
		
        if(isInList == false ){
			if(type.indexOf(':') > 0){
				selectedTextAreaLength = type.split(':')[1];
				type = type.split(':')[0];
			}
			popUpString = iValue;
			
			//alert('type==>'+type);
			if(type.toLowerCase() == 'text field'){
				assignVisibility('inline','none','none','none','none','none','none',null,1,elementVal);    
			}else if(type.toLowerCase() == 'number'){
				assignVisibility('inline','none','none','none','none','none','none',null,4,elementVal);    	
			}else if(type.toLowerCase() == 'radio button' || type.toLowerCase() == 'picklist'){
				 selectedApiName = idVal;
				setPickListOptions(idVal);
				assignVisibility('none','none','none','none','inline','none','none',null,8,elementVal);
			}else if( type.toLowerCase() == 'check box'){
				assignVisibility('none','none','none','inline','none','none','none',null,2,elementVal);
			}else if(type.toLowerCase() == 'text area' ){
				assignVisibility('none','inline','none','none','none','none','none',null,3,elementVal);
			}else if(type.toLowerCase() == 'lookup'){
				assignVisibility('inline','none','inline','none','none','none','none',iValue,5,elementVal);
			}else if(type.toLowerCase() == 'date/time'){
				assignVisibility('none','none','none','none','none', 'inline', 'none',null,6,elementVal);
			}else if(type.toLowerCase() == 'date'){
				assignVisibility('none','none','none','none','none', 'none', 'inline',null,7,elementVal);
			}
			setAddUpdateOnClick(elementVal);	        
			//document.getElementById("removeButtonId").style.visibility = 'hidden';
	   	}
	   
	   	setComparisonOperatorStore(type);
	   	if(opVal != null && opVal != 'undefined'){
			comparisonOperator.setValue(opVal);
	   	}
	   	if(groupOp != null && groupOp != 'undefined'){
			logicalOperator.setValue(groupOp);
	   	}
		
    } 
    
    

    function setComparisonOperatorStore(fieldType){
		if(fieldType.indexOf(':') > 0){
			fieldType = fieldType.split(':')[0];
		}else if(fieldType.indexOf(EF) > 0){
			fieldType = fieldType.split(EF)[0];
		}
		if(fieldType.toLowerCase() == 'lookup'){
			comparisonOperator.store.loadData(compStore.reference);
		}else if(fieldType.toLowerCase() == 'date/time'){
			comparisonOperator.store.loadData(compStore.dateTime);
		}else if(fieldType.toLowerCase() == 'date'){
			comparisonOperator.store.loadData(compStore.dateTime);
		}else if(fieldType.toLowerCase() == 'text area'){
			comparisonOperator.store.loadData(compStore.textArea);	
		}else if(fieldType.toLowerCase() == 'text field'){
			comparisonOperator.store.loadData(compStore.text);
		}else if(fieldType.toLowerCase() == 'number'){
			comparisonOperator.store.loadData(compStore.number);
		}else if(fieldType.toLowerCase() == 'radio button' || fieldType.toLowerCase() == 'check box' || fieldType.toLowerCase() == 'picklist'){
			comparisonOperator.store.loadData(compStore.booleanVar);
		}
		comparisonOperator.reset();
	}

	function setAddUpdateOnClick(updateBtnCheck){
	
		if(updateBtnCheck != null && updateBtnCheck != 'undefined'){
			getUpdateBtnEle().style.display = 'inline';
			getUpdateBtnEle().style.visibility = 'visible';
			getAddBtnEle().style.display = 'none';
			getAddBtnEle().style.visibility = 'hidden';
			getRemoveBtnEle().disabled = false;
			getRemoveBtnEle().src=getSDFStylesResPath() + '/SDEFbuttons/b_remove.png';
			
			
		}else{
			getUpdateBtnEle().style.display = 'none';
			getUpdateBtnEle().style.visibility = 'hidden';
			getAddBtnEle().style.display = 'inline';
			getAddBtnEle().style.visibility = 'visible';
			getRemoveBtnEle().disabled = true;
			getRemoveBtnEle().src=getSDFStylesResPath()+'/SDEFbuttons/b_remove_disabled.png';
		
		}
	}
	function assignVisibility(iTxt,iTextArea,iLookUp, iRadio,ipickList,isDateTime, isDate, iPopUp, typeNo, elementVal){
	
		var txtEle = getInputTxtEle();
		var txtAreaEle = getInputTextAreaEle();
		var dateTimeInput = getDateTimeInputEle();
		var dateTimePickerImg = getDateTimePickerImg(); 
		var dateInput = getDateInputEle();
		var datePickerImg = getDatePickerImg(); 
		var lookupEle = getLookupEle();
		var radioEle = Ext.getCmp('booleanFieldCombo');
		var txtAreaBtnEle = document.getElementById('inputTxtAreaButtonEle');
		var fieldpicklist = Ext.getCmp('pickListFieldCombo');

		if(txtEle != null && typeof(txtEle) != 'undefined'){
			txtEle.style.display  = iTxt;
			if(iTxt == 'inline' && elementVal != null && elementVal != 'undefined'){
				txtEle.value = elementVal;
			}else{
				txtEle.value  = '';
			}
			txtEle.disabled  = false;
		}
		if(txtAreaEle != null && typeof(txtAreaEle) != 'undefined'){
			txtAreaEle.style.display  = iTextArea;
			if(txtAreaBtnEle != null && typeof(txtAreaBtnEle) != 'undefined'){
				if(iTextArea == 'inline'){
					txtAreaBtnEle.style.display = 'block';
					//alert('txtAreaBtnEle.style.display ' + txtAreaBtnEle.style.display);
				}else{
					txtAreaBtnEle.style.display = 'none';
				}
				if(iTextArea == 'inline' && elementVal != null && elementVal != 'undefined'){
					txtAreaEle.value = elementVal;
				}else{
					txtAreaEle.value = '';
				}
			}
		}
		
		if(dateTimeInput != null && typeof(dateTimeInput) != 'undefined'){
			dateTimeInput.style.display=isDateTime;
			if(dateTimePickerImg != null && typeof(dateTimePickerImg) != 'undefined'){
				dateTimePickerImg.style.display=isDateTime;
			}
			if(isDateTime == 'inline' && elementVal != null && elementVal != 'undefined'){
				dateTimeInput.value = elementVal;
			}else{
				dateTimeInput.value = '';
			}
		}
		if(dateInput != null && typeof(dateInput) != 'undefined'){
			dateInput.style.display=isDate;
			if(datePickerImg != null && typeof(datePickerImg) != 'undefined'){
				datePickerImg.style.display=isDate;
			}
			if(isDate == 'inline' && elementVal != null && elementVal != 'undefined'){
				dateInput.value = elementVal;
			}else{
				dateInput.value = '';
			}
		}
        if(radioEle != null && typeof(radioEle) != 'undefined'){
			if(iRadio == 'inline'){
				radioEle.setVisible(true);
			}else{
				radioEle.hide();
			}
			if(iRadio == 'inline' && elementVal != null && elementVal != 'undefined'){
				radioEle.setValue(elementVal);
			}else{
				radioEle.value = '';
			}
		}	
		// For Picklist
		
		if(fieldpicklist != null && typeof(fieldpicklist) != 'undefined'){
			if(ipickList == 'inline'){
				fieldpicklist.setVisible(true);
			}else{
				fieldpicklist.hide();
				fieldpicklist.reset();
			}
			if(ipickList == 'inline' && elementVal != null && elementVal != 'undefined'){
				setPickListOptions(selectedApiName);
				fieldpicklist.setValue(elementVal);
			}else{
				fieldpicklist.value = '';
			}	
		}
		if(iLookUp == 'inline'){
			if(lookupEle != null && typeof(lookupEle) != 'undefined'){
				lookupEle.disabled = false;
				lookupEle.style.visibility  = 'visible';
				lookupEle.style.display  = 'inline';
				
			}
			if(elementVal != null && elementVal != 'undefined'){
				txtEle.disabled  = elementVal;
			}
            txtEle.disabled  = true;
            popUpEnable = true;
        }else{
			if(lookupEle != null && typeof(lookupEle) != 'undefined'){
				lookupEle.style.visibility  = 'hidden';
				lookupEle.style.display = 'none';
				lookupEle.disabled = true;
			}
		}
         
        compTypeNo = typeNo;
	} 
	
	function upadateCndData(){
		var selectedRec =  ConditionGrid.getSelectionModel().getSelected();
		addUpdateConditionData(selectedRec);		
	}
	function addCndData(){
		addUpdateConditionData();
	}
	function addUpdateConditionData(extRecord){
	   errorStr='';
	   var conditionRecord;
	   var data = conditionGridStore.data.length;
	    if(extRecord == null || extRecord == 'undefined' || typeof(extRecord) == 'undefined'){
			if(data != null && data != ''&& data >0)
				conditionOrderIndex = data+1;
			else{
				conditionOrderIndex =1;
			}
			conditionRecord = new Ext.data.Record();
			conditionRecord.set('orderIndex',conditionOrderIndex);
	   }else{
			conditionRecord = extRecord;
	   }
	   
	   var operandField = fetchConditionComboFieldLabel();
	   if(operandField != null && operandField != '' && operandField != 'undefined'){
		   var operandFieldValue = operandField.get('label');
		  
		   if(operandFieldValue != null && operandFieldValue != '' && operandFieldValue != 'undefined'){
				conditionRecord.set('inputId', operandField.get('id'));
				conditionRecord.set('inputName', operandFieldValue);
				var fType = operandField.get('type');
				if(fType != null && fType.indexOf(':') > 0){
					fType = fType.split(':')[0];
				}
				conditionRecord.set('ResponseType', fType);
		   }
	   }else{
			showExtMsg(OperandErrMsg);
			return;
	   }
	   	   
	   var compariosnOp = comparisonOperator.getValue();
	   if(compariosnOp != null && compariosnOp != '' && compariosnOp != 'undefined'){
			conditionRecord.set('operatorValue', compariosnOp);
	   }else{
			showExtMsg(comOpErrMsg);
			return;
	   }
	   
	   var groupingOp = logicalOperator.getValue();
	   if( groupingOp != null && groupingOp != '' && groupingOp != 'undefined'){
			conditionRecord.set('groupingOperator', groupingOp);
		}else{
			showExtMsg(logicalOpErrMsg);
			return;
		}
	    var operandVal;
	    if(compTypeNo=='1'||compTypeNo=='4'||compTypeNo=='5'){
			var txtEle = getInputTxtEle();
			if(txtEle != null && txtEle != 'undefined'){
				operandVal = txtEle.value;
			}
		}else if(compTypeNo=='2'){
			operandVal = booleanComboBx.getValue();
		}else if(compTypeNo=='3'){
			var txtAreaEle = getInputTextAreaEle();
			if(txtAreaEle != null && txtAreaEle != 'undefined'){
				operandVal = txtAreaEle.value;
			}
	   }else if(compTypeNo=='6'){
			operandVal = getDateTimeInputEle().value;
	   }else if(compTypeNo=='7'){
			operandVal = getDateInputEle().value;
	   }else if(compTypeNo=='8'){
			operandVal = pickListComboBx.getValue();
	   }
	   var errorFlag
	   if(operandVal != null && operandVal != '' && operandVal != 'undefined'){
		errorFlag = validateData(operandVal);
		 if(errorFlag){
			return;
		 }else{
			conditionRecord.set('operandValue', operandVal);
		 }
	   }else{
		showExtMsg(enterVaErrMsg);
		return;
	   }
	   
	   if(extRecord == null || extRecord == 'undefined' || typeof(extRecord) == 'undefined'){
			conditionGridStore.add(conditionRecord);
			conditionOrderIndex = conditionOrderIndex + 1;
			clearCriteria();
		}
		ConditionGrid.getView().refresh();
	   
	 
	}
	  /*Removes the selected row from the Condition Criteria Grid*/
	 function removeSLTQData(){ 
	 	var selectedRow =  ConditionGrid.getSelectionModel().getSelected();
		if(selectedRow != null && selectedRow != 'undefined'){
			ConditionGrid.store.remove(selectedRow);
			if(conditionOrderIndex >0)
				conditionOrderIndex = conditionOrderIndex - 1;
			var storeLength =ConditionGrid.store.getCount();
			for(var i =0; i < storeLength; i++){
				var gridRecord = ConditionGrid.store.getAt(i);
				gridRecord.set('orderIndex',i+1);
			}
			ConditionGrid.render('conditionGridDiv');
			getRemoveBtnEle().src=getSDFStylesResPath()+'/SDEFbuttons/b_remove_disabled.png';
			getRemoveBtnEle().disabled = true;
			inputsEditor.setValue('');
			comparisonOperator.setValue('');
			logicalOperator.setValue('');
			getInputTxtEle().value = '';
			assignVisibility('inline','none','none','none','none','none','none',null,1);
			setAddUpdateOnClick(null);
		}
	  }
	  
	  
	 function fetchConditionComboFieldLabel(){
		 var selectedValue = inputsEditor.getValue();
		 for(var i=0; i < inputsComboStore.data.length; i++){
		    if(selectedValue == inputsComboStore.getAt(i).get('id')){
		         return inputsComboStore.getAt(i);
		         
		    }
		 }
		 return '';
	 }
	 function getPickListOptions(inputId) {
    	var ploptions =new Array();
		var fldObjParts='';
		for (var i=0; i < inputData.length; i++) {
    		var dataObj = inputData[i];
			if(inputId == dataObj['id'] )
				fldObjParts = dataObj['e'].split(PE);
			
    	}
		
		for (var j=0; j < fldObjParts.length; j++) {
			var fldObjLabel = fldObjParts[j].split(EF);
			ploptions.push(fldObjLabel[0]);
			
		}
		
    	return ploptions;
    }
	function setPickListOptions(inputId) { 

		var objpicklist = Ext.getCmp('pickListFieldCombo');
    	if (objpicklist != null) {
    		var plo = getPickListOptions(inputId);
			pickListArray = new Array();
    		for (var i = 0;i < plo.length;i++) {
    			if (plo[i] != '') {
					pickListArray[i] = [plo[i],plo[i]];
                }
    		}
			pickListComboStore.removeAll();
			pickListComboStore.loadData(pickListArray);
			pickListComboBx.setVisible(true);
    	}
    }
	
	function showExtMsg(val){
		errorStr = val;
		Ext.MessageBox.show({
			width: 250,
			msg: val,
			buttons: Ext.MessageBox.OK
		});
	 }
 
	 function validateData(val){
	    var errorFlag = false;
	    if(compTypeNo != 0){
			if(compTypeNo == 4){
				if(isNaN(val)){
					errorFlag = true;
					showExtMsg('Invalid Number : '+val);
				}
			}
		}
		return errorFlag;
	 }

	function setInputDataAndElementsOnRowClick(rowIndex){
		var selectedRec = ConditionGrid.store.getAt(rowIndex);
		var fieldLabel = selectedRec.get('inputName');
		var idVal = selectedRec.get('inputId');
		var fieldValue = selectedRec.get('operandValue');
		var opVal = selectedRec.get('operatorValue');
		var groupOp = selectedRec.get('groupingOperator');
		var fieldType = selectedRec.get('ResponseType');
		var iValue ='';
		if(idVal != null && idVal != 'undefined'){
			inputsEditor.setValue(idVal);
			var fieldData = fetchConditionComboFieldLabel();
			var fType = fieldData.get('type');
			if(fType != null && fType.indexOf(':') > 0){
				var len = 	fType.split(':')[1];
				if(len != null && typeof(len) != 'undefined' && len != ''){
					selectedTextAreaLength = len;
				}
			}
			for(var i=0; i < inputsComboStore.data.length; i++){
			    if(idVal == inputsComboStore.getAt(i).get('id')){
			         iValue = inputsComboStore.getAt(i).get('e');		         
			    }
		 	}
		}
		
		setVisibilityData(idVal,iValue, fieldLabel, fieldType, fieldValue, opVal, groupOp);
		
	}

	// open lookup window 
	function openLookup(){   
			window.parent.parent.openPopup('SearchPage?popupId='+popUpString+'&isLookup=true&idNameForPopUp=true&referenceObjectName='+popUpString+'&hideIncidentCat=true', setReferenceToVal,450, 600, true);
	}

	 /*Clears the criteria editor once the criteria is added/updated/removed in the grid*/
	function clearCriteria(){
		if(compTypeNo=='1'||compTypeNo=='4'|| compTypeNo=='5'){
	   		var txtEle = getInputTxtEle();
			if(txtEle != null && txtEle != 'undefined'){
				txtEle.value = '';
			}
		}else if(compTypeNo=='2'){
	   		operandVal = booleanComboBx.setValue('');
	   	}else if(compTypeNo=='3'){
			var txtAreaEle = getInputTextAreaEle();
			if(txtAreaEle != null && txtAreaEle != 'undefined'){
				txtAreaEle.value = '';
			}
	   	}else if(compTypeNo=='6'){
			var dateTimeInputEle = getDateTimeInputEle();
			if(dateTimeInputEle != null && dateTimeInputEle != 'undefined'){
				dateTimeInputEle.value = ''
			}
		}else if(compTypeNo=='7'){
			var dateInputEle = getDateInputEle();
			if(dateInputEle != null && dateInputEle != 'undefined'){
				dateInputEle.value = '';
			}
		}else if(compTypeNo=='8'){
			operandVal = pickListComboBx.setValue('');
		}
	   	inputsEditor.setValue('');
	   	comparisonOperator.setValue('');
	   	logicalOperator.setValue('');
	}

	// Assign id, name value of lookup field
	function setReferenceToVal(idname){
			if(idname.indexOf(EF) > 0){
				referenceId = idname.split(EF)[0];
				referenceName = idname.split(EF)[1];
			}
			//decode the value for special chars.
			referenceName = decodeVal(referenceName);
			var textboxEle = getInputTxtEle();
			if(textboxEle != null && typeof(textboxEle) != 'undefined'){
				textboxEle.value = referenceName;
				var hiddenIdEle = document.getElementById('referenceID'); 
				if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
					hiddenIdEle.value = referenceId;
				}
			}
	}
	//follow the sequence of special characters while decode.
	function decodeVal(val) {
		val = val.replace("&gt;", ">", "g");
		val = val.replace("&lt;", "<", "g");
		val = val.replace("&quot;", "\"", "g");
		val = val.replace("&amp;", "&", "g");
		return val;
	}
	if(typeof(SDEDateFormat)=='undefined' || SDEDateFormat==null ||  SDEDateFormat=='')
	{
		this.SDEDateFormat =  "m/d/Y h:i A";
	}

	ConditionDatePickerPopup = function(){}
	ConditionDatePickerPopup.prototype = {
	
	    dateFormat : SDEDateFormat,
	    
	    selectHandler : function(dp, date) {
			
	        this.TextField.dom.value = date.format(dp.format);
			var datefieldId =  this.TextField.dom.id;
			if(datefieldId.indexOf("inputDate") > 0){
				var temp = document.getElementById(datefieldId).value;	
				var cdate = temp.split(' ');
				cdateFormat = cdate[1];
				this.TextField.dom.value = cdate[0];
			}		
			dataModifiedFlag = 1;
		    this.TextField = null;
	        dp.hide();
	        dp.winHandle.close();
	    },
	
		Show : function(forFielID) {
		    this.TextField = Ext.get(forFielID);
	        var dp = new Ext.DatePicker({ startDay: 1, 
	                                        listeners: {
	                                            select:this.selectHandler.createDelegate(this)
	                                            }		  
	                                    });
			try{
		        var dateval = Date.parseDate(this.TextField.dom.value, this.dateFormat);
		        dp.setValue(dateval);
			}catch(e)
			{
			}
	        var rgn = this.TextField.getRegion();
	
	        var win = new Ext.Window({ 
	                            x:rgn.right-175,
	                            y:rgn.top-1, 
								cls:'CMDBWindow',
	                            animCollapse:true,
	                            header:true,
	                            modal:true,
	                            autoHeight:true,
								width:177,
	                            layout: 'fit',
			                    frame: false,
			                    closable:false
	                        });
	                        
		    win.add(dp);
		    dp.winHandle=win;
		    win.show();
		}
	}

	var _datePicker = new ConditionDatePickerPopup();
	function showDateTimePicker(){
		var dateTimeInputId = getDateTimeInputEle();
		_datePicker.Show(dateTimeInputId);
	}
	function showDatePicker(){
		var dateInputId = getDateInputEle();
		_datePicker.Show(dateInputId);
	}
	
	function setConditionsData() {
		var infixStr = '';
		
		var count = 0;
		while(conditionGridStore.data.length > count) {
			if(conditionGridStore.data.length -1 != count &&  conditionGridStore.getAt(count).get('groupingOperator') == 'NONE' || 
			   conditionGridStore.data.length -1 == count &&  conditionGridStore.getAt(count).get('groupingOperator') != 'NONE'){
				showExtMsg(conditionOperatorLabel);
				
				break;
			}else{ 
				infixStr = infixStr + conditionGridStore.getAt(count).get('orderIndex') + PE + 
						 conditionGridStore.getAt(count).get('inputId') + PE + 
						 conditionGridStore.getAt(count).get('inputName') + PE + 
						 conditionGridStore.getAt(count).get('operatorValue') + PE +
						 conditionGridStore.getAt(count).get('operandValue') + PE +
						 conditionGridStore.getAt(count).get('ResponseType') + nonPrint;
				if(conditionGridStore.data.length -1 != count &&  conditionGridStore.getAt(count).get('groupingOperator') != 'NONE' ){
						infixStr = infixStr+conditionGridStore.getAt(count).get('groupingOperator') +  nonPrint;
				}
			}
			count++;
		}
		var applySTCondns = getInfixStrEle();
		applySTCondns.value = infixStr;
		
	}
	function okBtnHandler(){
		setConditionsData();
		assignConditionData();
	}
	
	function setCondtionValue(){
		if(errorMsg== '' || errorMsg == 'undefined'){
			if(errorStr == '' || errorStr == 'undefined'){
				var rval=new Array(2);
				rval[0] = getInfixStrEle().value;
				rval[1] = postfixString;
				window.parent.setPopUpVar(rval);
				window.parent.closePopup();
			}
		}else{
			showError();
		}
	}
	
	