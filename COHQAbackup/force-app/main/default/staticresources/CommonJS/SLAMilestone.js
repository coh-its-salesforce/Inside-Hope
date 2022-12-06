var grid,
	store,
	actionData,
	selectedRowIndex,
	actionIndex,
	percentSpinner,
	daySpinner,
	hourSpinner,
	minuteSpinner,
	conditionListValue,
	actionListValue,
	emailListValue,
	data,
	percent,
	day,
	hour,
	min,
	milestoneId,
	errormsg,
	actionRec,
	milestoneWindow,
	milestoneOncompletefunction,
	clickedOnce = false,
	isMilestoneCreatable;
	
	Ext.onReady(function(){
			Ext.QuickTips.init ();
			
            var toolBar= new Ext.Toolbar({
                renderTo: 'milestoneToolBar',
                 cls:'toolSpCls',
                id:'SLToolbar',
                 items: [
                        {
                            scale: 'medium',
                            iconCls: 'bmcSave',
                            tooltipType : 'title',
                            tooltip: labelSave,
                           // disabled : getSaveState(),
                            id:'mileSaveId',
                            handler:SaveBtnHandler   
                         },'',
                         {
                            scale: 'medium',
                            iconCls: 'bmcReset',
                            tooltipType : 'title',
                            tooltip: labelReset,
                            id:'mileResetId',
							handler:ResetBtnHandler
                        }
                 ]
            });
            
            percentSpinner = new Ext.ux.form.SpinnerField({
                    id:'percentSpinner',
                    value:percent,
                    minValue: 0,
                    maxValue: 100,
                    width:50,
                    renderTo:'percentSpinnerDiv',
					enableKeyEvents : true,
					maxLength:3,
					allowDecimals: false,
			        autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '3'},
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
            
            daySpinner = new Ext.ux.form.SpinnerField({
                    id:'daySpinner',
                    value:day,
                    minValue: 0,
                    maxValue: 99,
                    width:50,
                    renderTo:'daySpinnerDiv',
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
							var condition = getSelectedId().value.toLowerCase();
							if(condition == 'time remaining'){
								reSetHourMin();
							}
						},
						spin :function(){
							var condition = getSelectedId().value.toLowerCase();
							if(condition == 'time remaining'){
								reSetHourMin();
							}	
						}
					}
            });
            
            hourSpinner = new Ext.ux.form.SpinnerField({
                    id:'hourSpinner',
                    value:hour,
                    minValue: 0,
                    maxValue: 23,
                    width:50,
                    renderTo:'hourSpinnerDiv',
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
							var condition = getSelectedId().value.toLowerCase();
							if(condition == 'time remaining'){
								reSetMin();
							}
						},
						spin :function(){
							var condition = getSelectedId().value.toLowerCase();
							if(condition == 'time remaining'){
								reSetMin();
							}
						} 
					}
            });
            
            minuteSpinner = new Ext.ux.form.SpinnerField({
                    id:'minuteSpinner',
                    value:min,
                    minValue: 0,
                    maxValue: 59,
                    width:50,
                    renderTo:'minuteSpinnerDiv',
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
         
            store = new Ext.data.SimpleStore({
            fields: [
                        {
                            name: 'id',
                            type: 'string'
                        },{
                            name: 'index',
                            type: 'string'
                        },{
                            name: 'actionType',
                            type: 'string'
                        },{
                            name: 'emailTemplateID',
                            type: 'string'
                        },{
                            name: 'tofield',
                            type: 'string'
                        },{
                            name: 'ccfield',
                            type: 'string'
                        },{
                            name: 'actionValue',
                            type: 'string'
                        },{
                            name: 'actionLabel',
                            type: 'string'
                        }
                    ]
                          
            });
            
            //actionData = [['rajan','Action 1'],['The King','Action 2'],['Anil','Action 3'],['Sumit','Action 4']];
            //data = getActionData();
			//actionData = [data];
            //if(actionData != null && actionData != ''){
            	store.loadData(actionData);
			//}
            actionIndex = store.getCount();
            
            var cm = new Ext.grid.ColumnModel({
                  defaults: {
                      sortable: true        
                  },
                  columns: [
                      
                      { id: 'ActionData',
                        dataIndex: 'actionLabel',
						renderer: addToolTip
                      }
                  ]
            });
            
            
            grid = new Ext.grid.GridPanel({
                id: 'actionDataGrid',
                store: store,
                renderTo: 'actionGrid',
                header: false,
                cm: cm,
                stripeRows: true,
                selModel: new Ext.grid.RowSelectionModel({singleSelect : true}),
                height: 236,
				width: 325,
                border:false,
                autoWidth: true,
                viewConfig: {
                        forceFit:true,
                        scrollOffset: 0
                },
                listeners: {
                    rowclick:function(grid, r, e) {
						if(isMilestoneCreatable != null && isMilestoneCreatable != 'false'){
	                       selectedRowIndex = r;
						   actionRec = grid.store.getAt(r);
						   getActionListId().value = actionRec.get('actionType');
						   getTemplateId().value = actionRec.get('emailTemplateID');
						   getActionTo().value = actionRec.get('tofield');
						   getActionCC().value = actionRec.get('ccfield');
						   
						   showUpdatebtn();
						}   
                    },
                    render: function(grid) {
                        grid.getView().el.select('.x-grid3-header').setStyle('display', 'none');
                    } 
                }       
            });
    
		getWaitbox();
		getBtnState();
		
        document.getElementById('equalId').style.display = 'none';
        document.getElementById('percentageId').style.display = 'none';
        document.getElementById('daysId').style.display = 'none';
        
		document.getElementById('updateDivId').style.display = 'none';
		document.getElementById('cancelDivId').style.display = 'none';
        
		getDuration();
		conditionListValue = getSelectedId().value;
        actionListValue = getActionListId().value;
        emailListValue = getTemplateId().value;
		handleElemEvent();
		milestoneWindow = window.parent.popUpWindow;
		milestoneWindow.pendingClose = false;
		milestoneOncompletefunction = window.parent.onCompleteFunction;
		milestoneWindow.on('beforeclose',function(){
			if(milestoneWindow.pendingClose == false){
					if(clickedOnce== true){
						window.parent.confirmClose(milestoneWindow);
						return false;
					}
			}		
		});
		isMilestoneCreatable = getIsMilestoneCreatable();
		if(isMilestoneCreatable != null && isMilestoneCreatable == 'false'){
			Ext.getCmp('mileSaveId').setDisabled(true);
            Ext.getCmp('mileSaveId').setIconClass('bmcSaveDisable');
			Ext.getCmp('mileResetId').setDisabled(true);
            Ext.getCmp('mileResetId').setIconClass('bmcResetDisable');
		}
    });
	
	function getWaitbox(){ 
		    var  waitMsg = new Ext.Window({ 
	            id:'waitMsggId',
	            height:100, 
	            width:200, 
	            resizable:false, 
	            closable : false, 
	            header:false,
	            frame:false, 
	            shadow :false, 
	            modal:true,
				items:[{ 
					xtype:'panel', 
					height:100, 
					modal:false,
					width:200, 
					bodyStyle:'background-color:transparent;border:none;',     
					html:'<div align="center"><img src="'+extJsResource+'/resources/images/default/shared/blue-loading.gif"/></div>' 
					
	           }] 
	        
	     }); 

    }
	
	function showWaitbox(){
		if(Ext.getCmp('waitMsggId')!=null)
			Ext.getCmp('waitMsggId').show();
    }
	
	function hideWaitbox(){
		if(Ext.getCmp('waitMsggId')!=null)
			Ext.getCmp('waitMsggId').hide();
    }
	
	function addToolTip(data, cell, record, rowIndex, columnIndex, store) {
		cell.attr = 'title="'+Ext.util.Format.htmlEncode(record.data.actionValue.replace(/;/gi,"; "))+'"';
        return data;
    }
	
	function getBtnState(){
		milestoneId = getMilestoneId();
		if(milestoneId != null && milestoneId != ''){
			Ext.getCmp('mileResetId').setDisabled(false);
			Ext.getCmp('mileResetId').setIconClass('bmcReset');
		}else{
			Ext.getCmp('mileResetId').setDisabled(true);
			Ext.getCmp('mileResetId').setIconClass('bmcResetDisable');
		}
	}

	var SaveBtnHandler = function(button,event) {  
    						beforeSave = true;  
    						var perValue = document.getElementById('percentageId').style.display;
    						var daysValue = document.getElementById('daysId').style.display;
    						var duration = 0;
    						if(perValue != 'none'){
    								duration = percentSpinner.getValue();
    						}else{
    							if(daysValue != 'none'){
    									duration = (daySpinner.getValue()*24*60)+(hourSpinner.getValue()*60)+(minuteSpinner.getValue());
    								}
        
                        }
                        	conditionListValue = getSelectedId().value;
                        	selectedRowIndex = null;
                        	actionRec = null;
    						save(duration);
   						 };
   						 
   var ResetBtnHandler = function(button,event) {
   							beforeSave = true;
   							beforeReset = true;
   							getSelectedId().value = conditionListValue; 
   							selectedRowIndex = null;
   							reset();
   						};
						
	function showSpinner(){
    	percent = 0;
    	day =0;
    	hour = 0;
    	min = 0;
    	percentSpinner.maxValue = 100;
    	percentSpinner.setValue(percent);
    	minuteSpinner.setValue(min);
		hourSpinner.setValue(hour);
		daySpinner.setValue(day);
        
        var condition = getSelectedId().value.toLowerCase();
        document.getElementById('equalId').style.display = 'none';
        document.getElementById('percentageId').style.display = 'none';
        document.getElementById('daysId').style.display = 'none';
    
        if(condition == 'percentage of time elapsed' || condition== 'percentage of time remaining'){
            document.getElementById('equalId').style.display = 'inline-block';
            document.getElementById('percentageId').style.display = 'inline-block';
            if(condition== 'percentage of time remaining'){
	    			percentSpinner.maxValue = 100;
    		}
            
        }else if(condition == 'time elapsed' || condition == 'time remaining'){
            document.getElementById('equalId').style.display = 'inline-block';
            document.getElementById('daysId').style.display = 'inline-block';
            if(condition == 'time remaining'){
            	setMaxLimit();
            }else{
            	minuteSpinner.maxValue = 59;
				hourSpinner.maxValue = 23;
				daySpinner.maxValue = 99;
            }
        }
    }
    
    function getDuration(){
    	percent =0;
    	day =0;
    	hour = 0;
    	min = 0;
    	if(duration != null && duration != ''){
	    	var time = parseFloat(duration);
        var condition = getSelectedId().value.toLowerCase();
        
	    	if(condition == 'percentage of time elapsed' || condition== 'percentage of time remaining'){
	    		
	    		percent = Math.floor(time);
	    		if(condition== 'percentage of time remaining'){
	    			percentSpinner.maxValue = 99;
	    		}
	    	}else{
		    	if(time != 0){
		    			day =  Math.floor((time/(24*60)));
		    			hour = Math.floor((time/60)%24);
		    			min = Math.floor((time%(24*60))%60);
		    	}
		    	
		    }
	    }
	    
		minuteSpinner.setValue(min);
		hourSpinner.setValue(hour);
		daySpinner.setValue(day);
		percentSpinner.setValue(percent);
        
        document.getElementById('equalId').style.display = 'none';
        document.getElementById('percentageId').style.display = 'none';
        document.getElementById('daysId').style.display = 'none';
    
        if(condition == 'percentage of time elapsed' || condition== 'percentage of time remaining'){
            document.getElementById('equalId').style.display = 'inline-block';
            document.getElementById('percentageId').style.display = 'inline-block';
            
        }else if(condition == 'time elapsed' || condition == 'time remaining'){
            document.getElementById('equalId').style.display = 'inline-block';
            document.getElementById('daysId').style.display = 'inline-block';
            
            if(condition == 'time remaining'){
				setMaxLimit();
            	
            }
        }
    }
    
	function setMaxLimit(){
		
            	if(maxDuration != null && maxDuration != ''){
		    	var maxDay, maxHour, maxMinutes;
		    	maxDay = maxHour = maxMinutes = 0;
		    	var time = parseFloat(maxDuration);
		    		if(time != 0){
		    			maxDay =  Math.floor((time/(24*60)));
		    			maxHour = Math.floor((time/60)%24);
				maxMinutes = Math.floor((time%(24*60))%60);
		    			
						daySpinner.maxValue = maxDay;
						hourSpinner.maxValue = maxHour;
		    			minuteSpinner.maxValue = maxMinutes;
						
						if(maxDay != null && maxDay > 0){
							hourSpinner.maxValue = 23;
							minuteSpinner.maxValue = 59;
						}
						if(maxHour != null && maxHour > 0){
							minuteSpinner.maxValue = 59;
						}
			    	}
	    		}
            }
	
	function reSetHourMin(){
		if(daySpinner.getValue() < daySpinner.maxValue){
			hourSpinner.maxValue = ((daySpinner.maxValue - daySpinner.getValue())*24 > 23)? 23: (daySpinner.maxValue-daySpinner.getValue())*24;
			minuteSpinner.maxValue = ((daySpinner.maxValue - daySpinner.getValue())*24*60 > 59)? 59: (daySpinner.maxValue-daySpinner.getValue())*24*60;
		}else{
			if(daySpinner.maxValue > 0){
				hour = 0;
				min = 0;
				minuteSpinner.setValue(min);
				hourSpinner.setValue(hour);
				var time = parseFloat(maxDuration);
				if(time != 0){
					maxHour = Math.floor((time/60)%24);
					maxMinutes = Math.floor((time%(24*60))%60);
					hourSpinner.maxValue = maxHour;
					minuteSpinner.maxValue = maxMinutes;
				}
        	}
    	}
    }
    
	function reSetMin(){
		if(hourSpinner.getValue() < hourSpinner.maxValue){
			minuteSpinner.maxValue = ((hourSpinner.maxValue - hourSpinner.getValue())*60 > 59)? 59: (daySpinner.maxValue-daySpinner.getValue())*60;
		}else{
			if(hourSpinner.maxValue > 0){
				if(daySpinner.getValue() == daySpinner.maxValue){
					min = 0;
					minuteSpinner.setValue(min);
					var time = parseFloat(maxDuration);
					if(time != 0){
						maxMinutes = Math.floor((time%(24*60))%60);
						minuteSpinner.maxValue = maxMinutes;
					}
				}
			}	
		}
	}
    function clearActionFields(){
        if(isMilestoneCreatable != null && isMilestoneCreatable != 'false'){
	        getActionListId().value = actionListValue;
	        getTemplateId().value = emailListValue;
	        getActionTo().value = '';
	        getActionCC().value = '';
    	}
    }
    
    function addActionToGrid(){
    	if(errormsg == null || errormsg == '' || errormsg == labelSavedSuccessfully){
        var action = getActionListId().value;
		var actionLabel = getActionListId()[getActionListId().selectedIndex].innerHTML;
        var template = getTemplateId()[getTemplateId().selectedIndex].innerHTML;
	        var templateID = getTemplateId().value;
        var toValue = getActionTo().value;
        var ccValue = getActionCC().value;
        
        var gridAction,gridActionLabel;
        if(ccValue != null && ccValue != ''){    
        	gridAction = actionLabel + ' \"' + template + '\" to ' + toValue + ','+ ccValue;
        }else{
        	gridAction = actionLabel + ' \"' + template + '\" to ' + toValue;
        }	
        if(gridAction.length > 80){
        	gridActionLabel = 	gridAction.substring(0,80) + '...';
        }else{
        	gridActionLabel = gridAction;
        }	
       
	       	if(actionRec != null && typeof(actionRec) != 'undefined'){
				actionRec.set('actionType',action);
				actionRec.set('emailTemplateID',templateID);
				actionRec.set('tofield',toValue);
				actionRec.set('ccfield',ccValue);
				actionRec.set('actionValue',gridAction);
				actionRec.set('actionLabel',gridActionLabel);
				
				actionRec.commit();
				grid.getSelectionModel().deselectRow(selectedRowIndex);
				selectedRowIndex = null;
				actionRec = null;
	    	}else{
	    		//Increment the index only after record is validated and added to grid
	    		var aIndex = actionIndex + 1;
	    		++actionIndex;
        var newRecord = {
            id: null,
		            index:aIndex,
		            actionType: action,
		            emailTemplateID: templateID,
		            tofield: toValue,
		            ccfield: ccValue,
            actionValue:gridAction,
            actionLabel: gridActionLabel
        };
        var r = new store.recordType(newRecord); // create new record
        store.add(r); // insert a new record into the store
		     }
		     	showAddbtn();
	        clearActionFields();
       } 
    }
    
    function addActionHandler(){
		if(isMilestoneCreatable != null && isMilestoneCreatable != 'false'){
	    	showWaitbox();
	    	
	    	if(actionRec != null && typeof(actionRec) != 'undefined'){
	    		addAction(actionRec.get('index'));
	    	}else{
		        
		        var aIndex = actionIndex + 1;
	        	addAction(aIndex);
	    	}
	    }
    }
    
    function removeActionFromGrid(button, event){
			if(button=='ok'){
			if(selectedRowIndex != null && typeof(selectedRowIndex) != 'undefined'){
	        	var delRecord = Ext.getCmp('actionDataGrid').getStore().getAt(selectedRowIndex);
	        	var delId = delRecord.get('id');
		        	var delIndex = delRecord.get('index');
	        	Ext.getCmp('actionDataGrid').getStore().remove(delRecord);
					showWaitbox();
					showAddbtn();
	        	if(delId != null && delId != '' && delId != 'undefined'){
		        		deleteAction(delId,delIndex);
	        	}else{
		        		removeActionfromList(delIndex);
	        	}
	        	selectedRowIndex = null;
		        	actionRec = null;
        }
        	}else if (button=='cancel'){
            			return;
        	}
    }
    
    function removeActionHandler(button, event){
    	if(isMilestoneCreatable != null && isMilestoneCreatable != 'false'){
	    	if(selectedRowIndex != null && typeof(selectedRowIndex) != 'undefined'){
		    	Ext.Msg.show({
		            cls:'messagePopup',
		            title:labelRemoveAction,
		            msg: DeleteMessage,
		            buttons: Ext.Msg.OKCANCEL,
		            fn: removeActionFromGrid,
		            width: 300,
		            icon: Ext.MessageBox.WARNING ,
		            frame:false
		         });
	         }else{
	         	Ext.Msg.show({
		            cls:'messagePopup',
		            title:labelRemoveAction,
		            msg: selectRowMsg,
		            buttons: Ext.Msg.OKCANCEL,
		            width: 300,
		            icon: Ext.MessageBox.WARNING ,
		            frame:false
	         	});
	         }
		}	
    }
    
    function showAddbtn(){
    	document.getElementById('addDivId').style.display = 'inline';
    	document.getElementById('clearDivId').style.display = 'inline';
	    document.getElementById('updateDivId').style.display = 'none';
	    document.getElementById('cancelDivId').style.display = 'none';
    }
    
    function showUpdatebtn(){
    	document.getElementById('addDivId').style.display = 'none';
    	document.getElementById('clearDivId').style.display = 'none';
	    document.getElementById('updateDivId').style.display = 'inline';
	    document.getElementById('cancelDivId').style.display = 'inline';
    }
    
    function refreshParent(){
    	// As no need to pass any ID, passed string to call Parent function as passing argument is mandatory. 
    	//window.parent.setPopUpVar('callParent');
    }
	/*button Id of To / CC is passed to the function to enable and disable accordingly*/
    var enabledButtonNameVal; 
    function openSelectEmailRecipient(buttonId){ 
    	if(buttonId=='toButtonIdMilestonePage'){
    		enabledButtonNameVal = 'to';
    	}else if(buttonId=='ccButtonIdMilestonePage'){
    		enabledButtonNameVal = 'cc';
    	}
		window.parent.toEmailRecipientAddress = getActionTo().value;
    	window.parent.ccEmailRecipientAddress = getActionCC().value;
    	var link = 'SLAMileStoneEmailRecipients?enabledButtonName='+enabledButtonNameVal+'&appliesTo='+appliesTo+'&slaId='+window.parent.getSLAId()+'&businessServiceId='+window.parent.businessServiceId;
		window.parent.openPopupWithTitle(link,populateAddressFields,labelSelectEmailRecipients,573,755);
    }
    function populateAddressFields(returnVal){
    	    var toAndccString = returnVal.split(DZHE);
    	    if(toAndccString!=null && toAndccString!='' && toAndccString!= DZHE){
	    		getActionTo().value =  toAndccString[0];
	    		getActionCC().value =  toAndccString[1];
    	}
	}					
	function cancelAction(){
		showAddbtn();
		clearActionFields();
		grid.getSelectionModel().deselectRow(selectedRowIndex);
		selectedRowIndex = null;
		actionRec = null;
	}
	function handleResetChange(){
		if(clickedOnce){
		   clickedOnce = false;		   
		}
	}    
	function handleChange(obj){
		if(!clickedOnce){ 
			clickedOnce = true;			
		}
	}
	function setReturnValue(){
		window.parent.setOnCompleteFunction(milestoneOncompletefunction);
		window.parent.setPopUpVar('dummy');
	}
