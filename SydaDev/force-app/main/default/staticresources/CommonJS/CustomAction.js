 var clickedOnce = false; 
 
 Ext.onReady(function(){
        Ext.QuickTips.init();
        if(CustomActionPageComp.ComponentVars.isRecDeleted){
            Ext.Msg.alert(CustomAction.Labels.Information, CustomAction.Labels.DeletedRecord, function(){
                if ((typeof(window.parent) != 'undefined') && (typeof(window.parent.popUpWindow) != 'undefined'))
                    window.parent.popUpWindow.close();
                    closeWindow();
            });
        }
           
        // This function renders a block of buttons
        var NewBtnhandler = function(button,event) { activeAllWindowFlag=false; openPage("CustomActionPage",customActionHeader,customActionHeader); };
        var SaveBtnHandler = function(button,event) {  
            var abc = document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).checked;
            var record = Ext.getCmp('selectedListId').store;
            var rowCount=record.data.length;
            var i=0;
            selectedValues='';
            while(rowCount>i){
                var rec = record.getAt(i); 
                // var rec1 = comboStore.getById(rec.get('type'));
                if(i == 0)
                    selectedValues = selectedValues +rec.get('value');
                else
                    selectedValues = selectedValues + ','+rec.get('value'); 
                i++;
            }
            if(rowCount == 0 && document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).checked == true)
                selectedValues = 'everyone';
            if(rowCount == 0 && document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).checked == false){
                Ext.Msg.alert('', CustomAction.Labels.selectedProfileListEmpty); 
            }else{ 
                chkBoxValue=Ext.getCmp('idInactive').getValue();
                waitbox(0);
                var paramList = createPramList();   
                save(selectedValues, paramList,chkBoxValue);
            }
         };
        var CopyBtnHandler = function(button,event) { activeAllWindowFlag=false; callCopyPage(); };
        var ResetBtnHandler = function(button,event) {  var url = window.location.href;
        if(url.indexOf('&id=') == -1 && url.indexOf('?id=') == -1)
            		url=url+'&id='+customActionId;
            		window.location.replace (url);
        };
        var DeleteBtnHandler = function(button,event) { 
                                                        Ext.MessageBox.confirm(CustomAction.Labels.Delete, CustomAction.Labels.DeleteConfirmMessage, function(btn){
                                                           if(btn === 'yes'){
                                                                  deleteCustomAction();
                                                           }});
         };
        var SendNotificationBtnHandler= function(button,event) {  /*deleteIncident();*/ };
        var OpenBtnHandler= function(button,event) {  /*deleteIncident();*/ };
        var NextBtnHandler = function (button,event) {if(document.getElementById('nextId').disabled!=true) nextBtnHandler1();};
        var PreviuosBtnHandler = function (button,event) {if(document.getElementById('prevId').disabled!=true) previousBtnHandler1();};  
        
        
         var toolBar= new Ext.Toolbar({
            title: '',
            renderTo: 'btnToolbar',
            cls:'toolSpCls',
            items: [ {
                scale: 'medium',
                iconCls: 'bmcNew',
                tooltipType : 'title',
                tooltip: CustomAction.Labels.New,
                id:'newId',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcNewOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcNew');          
                     }
                },                
                handler:NewBtnhandler
            } ,' ', {
                scale: 'medium',
                iconCls: 'bmcSave',
                tooltipType : 'title',
                id:'saveId',
                 tooltip:CustomAction.Labels.Save,
                 listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcSaveOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcSave');          
                     }
                },                 
                handler:SaveBtnHandler
            },' ',{
                scale: 'medium',
                tooltipType : 'title',
                 tooltip: CustomAction.Labels.Copy,
                iconCls: 'bmcCopy',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcCopyOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcCopy');          
                     }
                },                
                id:'copyId',
                handler:CopyBtnHandler
            },' ','-',' ',{
                scale: 'medium',
                iconCls: 'bmcDelete',
                tooltipType : 'title',
                 tooltip: CustomAction.Labels.Delete,
                 id:'deleteId',
                 listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcDeleteOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcDelete');          
                     }
                },                 
                handler:DeleteBtnHandler
            },' ',{
                scale: 'medium',
                iconCls: 'bmcRefreshDasboard',
                tooltipType : 'title',
                 tooltip: CustomAction.Labels.Reset,
                  id:'resetId',
                             
                handler:ResetBtnHandler
            }, 
            new Ext.Toolbar.Fill(), 
            {
                  id :'idInactive',
               xtype  : 'checkbox',
               width  : 'auto',
               align:'top',
               checked: false,
               boxLabel:CustomAction.Labels.Inactive,
               cls:'chkStyle',
               boxLabel:'<span class="checkboxLabelCls">'+CustomAction.Labels.Inactive+'</span>',
               /*modified to fix the tooltip bug*/
               listeners:{
                    render:function(){
                        Ext.QuickTips.register({
                            target:this,
                            dismissDelay: 20000,
                            text:CustomAction.Labels.Inactive
                        });
                    }   /* modification done*/            
                    }               
              
            },{
               
               
                  xtype : 'box',
                  id    : 'prevId',
                autoEl:  {tag: 'img', 
                          src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif'),   
                         title: CustomAction.Labels.PreviousRecord
                         },
                          
                cls:'cursorCls',
               listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
                             
            },{
               
                xtype : 'box',
                id    : 'nextId',
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
                          title: CustomAction.Labels.NextRecord},
                cls:'cursorSpaceCls',
                listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
               
                
            }
            ] 
        });
        
        if(customActionId == null ||customActionId == ''){                
        Ext.getCmp('deleteId').setDisabled(true);
        Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
        Ext.getCmp('copyId').setDisabled(true);
        Ext.getCmp('resetId').setDisabled(true);
        Ext.getCmp('prevId').setDisabled(true);
        Ext.getCmp('nextId').setDisabled(true);
        document.getElementById(CustomActionPageComp.ComponentVars.ActionNameID).focus();
        }
        
        var dataSourceData = new Array();
            showTable();  
              
            //setDataSourceName('');
                    
            var fieldList = new Array();
            var profileList = new Array();
            var listDataGrid = new Array();        
            setData();   
            ds = new Ext.data.ArrayStore({
                data: fieldList,
                fields: ['value','text'],
                sortInfo: {
                    field: 'text',
                    direction: 'ASC'
                }
            });
            
            ds1 = new Ext.data.ArrayStore({
                data: profileList,
                fields: ['value','text'],
                sortInfo: {
                    field: 'text',
                    direction: 'ASC'
                }
            });
             Ext.getCmp('idInactive').setValue(isIncInactive); 
            /*
            ** Ext.ux.form.ItemSelector Example Code
            */
            var path=getSDFStylesResPath() + '/SDEFimages/';
            var path1=getSDFStylesResPath() + '/SDEFbuttons/';
           var isForm = new Ext.Panel({
                id: 'form',
                title: '',
                width:250,
                border: false,
               
                cls: 'fontCls',
                renderTo: 'itemselector',
                    items:[{
                        xtype: 'itemselector',
                        name: 'itemselector',
                        iconLeft:'b_darrow_L_new.gif',
                        iconRight:'b_darrow_R_new.gif',
                        drawUpIcon:false,
                        drawDownIcon:false,
                        drawLeftIcon:true,
                        drawRightIcon:true,
                        drawTopIcon:false,
                        drawBotIcon:false,
                        fieldLabel: '',
                        imagePath: path1,
                        multiselects: [{
                            id:'profileListId',
                            legend:false,
                            width:107,
                            height: 400,
                            store: ds1,
                            displayField: 'text',
                            valueField: 'value',
                            listeners: {
                                render: function(multi) {
                                   
                                     new Ext.ToolTip({
                                        target: multi.el,
                                        renderTo: document.body,
                                        delegate: 'dl',
                                        trackMouse: true,
                                        anchor: 'right',
                                        listeners: {
                                            beforeshow: function(tip) {
                                                var rec = multi.view.getRecord(tip.triggerElement);
                                                tip.body.dom.innerHTML =rec.get('text');
                                            }
                                        }
                                    });
                                },
                                afterrender:function(){
                                    setTimeout('toggleItemSelector()',1000);
                                }
                           }
                           
                        },{
                            id:'selectedListId',
                            width:107,
                            legend:'',
                            height: 400,
                            legend:false,
                            store: ds,
                            displayField: 'text',
                            valueField: 'value',
                            listeners: {
                                render: function(multi) {
                                    new Ext.ToolTip({
                                        target: multi.el,
                                        renderTo: document.body,
                                        delegate: 'dl',
                                        trackMouse: true,
                                        anchor: 'right',
                                        listeners: {
                                            beforeshow: function(tip) {
                                                    var rec = multi.view.getRecord(tip.triggerElement);
                                                    if(rec != null && rec != 'null' && rec != 'undefined'){
                                                        tip.body.dom.innerHTML =rec.get('text');
                                                    }
                                            }
                                        }
                                    });
                                }
                           }
                            
                        }],
                        listeners: {
                                change: function(){                                   
                                   if(ds.data.length==0){
                                       document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).disabled =false;
                                       toggleItemSelector();
                                   }else{
                                    document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).checked = false;
                                    document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).disabled =true;
                                     Ext.getCmp('form').getEl().unmask(); 
                                   }
                                }
                        }
                    }]
                    
                }); 
                fetchModuleFieldStore();
                var gridWidth=Ext.getCmp('grid').getWidth();
				var eleWidth=document.getElementById('paramConstVal').clientWidth;
				var tdWidth=document.getElementById('paramConstVal').parentNode.clientWidth;
				combowidth = tdWidth*0.97;
				combowidth = Ext.isIE8 ? combowidth : Ext.isIE7 ? combowidth-10 : combowidth;
				
                 moduleFieldCombo = new Ext.form.ComboBox({
                    id:'moduleFieldCombo',
                    store: moduleFieldStore,
                   
                    width:combowidth, 
                    height:10,
                    emptyText: CustomAction.Labels.SelectField,
                    displayField:'lable',
                    renderTo: 'moduleFldsCombo',
                    valueField:'apiName',
                    typeAhead: true,
                    mode: 'local',
                    forceSelection:true,
                    triggerAction: 'all',
                    selectOnFocus:true,
                    tooltip: CustomAction.Labels.ModuleType,
                    cls: 'fontCls',
                    //triggerClass : Ext.isIE7 ? 'qvCmbTriggerClsIE' : 'qvCmbTriggerCls',
                    listeners:{
                        'select': function(combo, record, index) {
                           comboFldIndex = index;
                           // refreshChart(index);
                         }
                    }
            
                });
                
           setData2();
           //loadPreview();
           generatePreviewUrl();
        handleElemEvent(); 
    });
    
 
    function handleChange(){
            if(!clickedOnce){
                clickedOnce = true;
                window.parent.registerChange(wid2);
            }
        }
            
	function handleResetChange(){
		if(clickedOnce){
		   clickedOnce = false;
		   window.parent.registerSave(wid2);
		}
	}
    function closeWindow(){
			window.parent.refreshList();
			window.parent.closeTab(wid);
	}
	function urldecode(str){ 
		return decodeURIComponent((str + '').replace(/\+/g, '%20')); 
	}
	function urlencode(str){ 
		return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
	}
	function createPramList(){
		var record = Ext.getCmp('grid').store;
		var rowCount=record.data.length;
		var i=0;
		var paramList ='';
		while(rowCount>i){
			var rec = record.getAt(i); 
			var paramWithVal='';
			if(rec.get('isDynamic')== 'true')
				paramWithVal = urlencode(rec.get('field'))+'=<'+urlencode(rec.get('apiName'))+'>';
			else
				paramWithVal = urlencode(rec.get('field'))+'='+urlencode(rec.get('constValue'));  
			if(i == 0)
				paramList = paramList +paramWithVal;
			else
				paramList = paramList +'&'+paramWithVal;
				
			i++;
		}
		return paramList;
	}
	function enableValidation(){
             if(typeof(document.getElementById('txtBoxRd')) != null && document.getElementById('txtBoxRd').checked == true){
                document.getElementById('paramConstVal').disabled = false;
                Ext.getCmp('moduleFieldCombo').setValue('');
                Ext.getCmp('moduleFieldCombo').disable();
                defaultConstVal();
             }else{
                Ext.getCmp('moduleFieldCombo').enable();
                document.getElementById('paramConstVal').disabled = true;
                defaultConstVal();
                isEnterConst = 1;
             }
        }
	function generatePreviewUrl(){
		var i=0;
		var paramStr = '';
		var strForEachparam;
		while(listDataGrid.length > i){
			strForEachparam ='';
			if(listDataGrid[i][3] == 'true'){
				strForEachparam = listDataGrid[i][0]+'=<'+listDataGrid[i][1]+'>';
			}else if(listDataGrid[i][3] == 'false'){
				strForEachparam = listDataGrid[i][0]+'='+listDataGrid[i][1];
			}
			if(paramStr == '')
				paramStr = paramStr+strForEachparam;
			else
				paramStr = paramStr+'&'+strForEachparam;
		   i++;     
		}
		var url = document.getElementById(CustomActionPageComp.ComponentVars.URLId).value;
		if(url != null && url != ''){
		if(url.indexOf("?") == -1){
			document.getElementById('previewText').value = url +'?' + paramStr;
		}else{
			if(url.lastIndexOf("?") == url.length-1){
				document.getElementById('previewText').value = url +paramStr;
			}else
				document.getElementById('previewText').value = url +'&' + paramStr;
		}
		}else if(paramStr != ''){
				document.getElementById('previewText').value = '?' + paramStr;
		}else document.getElementById('previewText').value = '';
	}
	function isParamUnique(record, paramName){
            var rowCount=record.data.length;
            var i=0;
            while(rowCount>i){
                var rec = record.getAt(i); 
                if(rec.get('field')== paramName)
                    return false;
                i++;    
            }
            return true;
        }
	 function addParameter(){
		var record = Ext.getCmp('grid').store;
		var rowCount=record.data.length;
		var paramName = document.getElementById('paramName').value;
		if(isfocus == 0 || (isEnterConst == 0 && document.getElementById('txtBoxRd').checked == true)){
			if(isfocus == 0){
				Ext.Msg.alert('', CustomAction.Labels.parameterNameEmpty);
				defaultPrameterName();
			}else{
				Ext.Msg.alert('', CustomAction.Labels.EmptyConstantValue);
				defaultConstVal();
			}
		}else{
			if(paramName != null && paramName.trim() != '' && isParamUnique(record ,paramName )){
				addRecordToDataGrid(rowCount);
				generatePreviewUrl();
			}else{
				if(paramName.trim() == '')
					Ext.Msg.alert('', CustomAction.Labels.parameterNameEmpty);
				else
					Ext.Msg.alert('', CustomAction.Labels.parameterNameUnique);
			}
			enableRdTxtPanel();
			isException = false;
        }
    }
	function updateParameter(){
		var record = Ext.getCmp('grid').store;
		var rowCount=record.data.length;
		var paramName = document.getElementById('paramName').value;
		if(isEnterConst == 0){
			Ext.Msg.alert('', CustomAction.Labels.EmptyConstantValue);
			defaultConstVal();
			isException = true;
		}else{ 
			if(pNameForUpdate != paramName){
				if(paramName != null && paramName.trim() != '' && isParamUnique(record ,paramName )){
					addRecordToDataGrid(selectedRow);
					generatePreviewUrl();
				}else{
					if(paramName.trim() == ''){
						Ext.Msg.alert('', CustomAction.Labels.parameterNameEmpty);
						isException = true;
					}else{
						Ext.Msg.alert('', CustomAction.Labels.parameterNameUnique);
						isException = true;
					}
				}
			}else{
				if(paramName == ''){
					Ext.Msg.alert('', CustomAction.Labels.parameterNameEmpty);
					isException = true;
				}else{
					addRecordToDataGrid(selectedRow);
					generatePreviewUrl();
				}               
			}
		}     
		enableRdTxtPanel();
		if(!isException){
			document.getElementById("okButtonId").style.display = 'inline';
			document.getElementById("updateButtonId").style.display = 'none';
			document.getElementById('removeButtonId').disabled = true;
		}else{ isException = false;}
    }
	function addRecordToDataGrid(rowIndex){
		var record = Ext.getCmp('grid').store;
		var rowCount=record.data.length;
		var comboRecord =Ext.getCmp('moduleFieldCombo').store;
		var paramName = document.getElementById('paramName').value;
		var selectedComboRcd;
		if(rowCount == rowIndex){
			selectedRow = rowCount;
			listDataGrid[rowCount] = new Array(4);
		}
		if(typeof(document.getElementById('comboRd')) != null && document.getElementById('comboRd').checked == true){
		   if(Ext.getCmp('moduleFieldCombo').getValue()!=''){
		   if(typeof(comboFldIndex) !='undefined' && comboFldIndex != -1){
			   selectedComboRcd = comboRecord.getAt(comboFldIndex);
			   listDataGrid[selectedRow][0]= paramName;
			   listDataGrid[selectedRow][1]=selectedComboRcd.get('lable');
			   listDataGrid[selectedRow][2]=selectedComboRcd.get('apiName');
			   listDataGrid[selectedRow][3]='true';
			   setData();
			   }else{
					listDataGrid[selectedRow][0]= paramName;
					//listDataGrid[selectedRow][1]=selectedComboRcd.get('lable');
					//listDataGrid[selectedRow][2]=selectedComboRcd.get('apiName');
					//listDataGrid[selectedRow][3]='true';
					setData();
			   }
		   }else{
				Ext.Msg.alert('', CustomAction.Labels.EmptyModuleFieldValue);
				isException = true;
		   }
	    }else{
		   var paramConstVal =  document.getElementById('paramConstVal').value;
		   if(paramConstVal != null && paramConstVal.trim()!= ''){
		   selectedComboRcd = comboRecord.getAt(comboFldIndex);
		   listDataGrid[selectedRow][0] = paramName;
		   listDataGrid[selectedRow][1] = paramConstVal;
		   listDataGrid[selectedRow][2] = '';
		   listDataGrid[selectedRow][3]='false';
		   setData();
			}else{
				Ext.Msg.alert('', CustomAction.Labels.EmptyConstantValue);
				isException = true;
			}   
	   }
	   selectedRow = 0; 
	}
	function removeParameter(){
		listDataGrid.splice(selectedRow,1);
		setData();
		generatePreviewUrl();
		document.getElementById("okButtonId").style.display = 'inline';
		document.getElementById("updateButtonId").style.display = 'none';
		document.getElementById('removeButtonId').disabled = true;
		enableRdTxtPanel();
	} 
	function enableRdTxtPanel(){
		if(!isException){
			defaultPrameterName();
		}
		if(document.getElementById('comboRd').checked == true){
			Ext.getCmp('moduleFieldCombo').enable();
			moduleFieldCombo.setValue('');
			defaultConstVal();
			isEnterConst = 1;
			document.getElementById('paramConstVal').disabled = true;
		}else{
			document.getElementById('paramConstVal').disabled = false;
			defaultConstVal(); 
			moduleFieldCombo.setValue('');
			Ext.getCmp('moduleFieldCombo').disable();
		}
    }
	function callCopyPage(){
        window.parent.addTab("CustomActionPage?copyId=" + customActionId,customActionHeader,customActionHeader);
    }
    
    function completeDelete(){
                if(errormsg == CustomAction.Labels.InsufficentDeletePrivilege){
                    showError();
                }else{
                     closeWindow();
                }
     }
     function onRowClkofParamGrid(record){
        pNameForUpdate = record.get('field');
        document.getElementById('paramName').style.color='#000000';
        document.getElementById('paramName').value =record.get('field');
        document.getElementById("okButtonId").style.display = 'none';
        document.getElementById("updateButtonId").style.display = 'inline';
        document.getElementById('updateButtonId').disabled = false;
        document.getElementById('removeButtonId').disabled = false;
        
        if(record.get('isDynamic') == 'false'){
            document.getElementById('paramConstVal').style.color='#000000';
            document.getElementById('paramConstVal').value =record.get('constValue');
            document.getElementById('paramConstVal').disabled = false;
            document.getElementById('txtBoxRd').checked = true;
			isEnterConst = 1;
            moduleFieldCombo.setValue('');
            moduleFieldCombo.disable();
        }else{
            moduleFieldCombo.enable();
            document.getElementById('paramConstVal').disabled = true;
            document.getElementById('comboRd').checked = true;
            defaultConstVal();
            isEnterConst = 1;
            moduleFieldCombo.setValue(record.get('constValue'));
        }
        
    }
    function toggleItemSelector(){
		var checkState = document.getElementById(CustomActionPageComp.ComponentVars.radFCR8).checked;
		//if(!isLookup) { 
			 if(Ext.getCmp('form')!=null && Ext.getCmp('profileListId')!=null && Ext.getCmp('selectedListId')!=null){
				/*Ext.getCmp('form').setDisabled(checkState);          
				Ext.getCmp('profileListId').setDisabled(checkState);
				Ext.getCmp('selectedListId').setDisabled(checkState);*/
				if(checkState )   
				  Ext.getCmp('form').getEl().mask();
				else
				 Ext.getCmp('form').getEl().unmask();  
			 }
		//}
    }
	function previousBtnHandler1(){
            var idSetString='';
            var i=0;
            while(cusActionIdSet.length > i){
                if(idSetString==''){
                    idSetString=cusActionIdSet[i];
                }else{
                    idSetString=idSetString+','+cusActionIdSet[i];
                }
                i++;
            } 
            previousBtnHandler(idSetString);
        
        }

    function nextBtnHandler1(){
		var idSetString='';
		var i=0;
		while(cusActionIdSet.length > i){
			if(idSetString==''){
				idSetString=cusActionIdSet[i];
			}else{
				idSetString=idSetString+','+cusActionIdSet[i];
			}
			i++;
		}
		nextBtnHandler(idSetString);
	
	}
	function defaultPrameterName(){
		document.getElementById('paramName').style.color='#B5B8C8';
		document.getElementById('paramName').value = CustomAction.Labels.parameterName;
		isfocus = 0;
	}
	function defaultConstVal(){
		document.getElementById('paramConstVal').style.color='#B5B8C8';
		document.getElementById('paramConstVal').value = CustomAction.Labels.EnterConstant;
		isEnterConst = 0;
	}	