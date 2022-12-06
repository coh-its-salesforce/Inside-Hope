var fldData = '[]',
    offeringClause,
	fkService,
	flag,
	selectedLabel,
	selectedApiName,
	listData,
	isInList = false,
	selectedTextAreaLength = 0,
	disableMilestoneTab,
	popUpString = '',
	popUpEnable = false,
	isCustomPage=true,
	compTypeNo = 0,
	fieldsComboStore,
	fieldsEditor,
	pickListArray = new Array(),
	pickListComboStore,
	pickListComboBx,
	booleanComboStore,
	booleanComboBx,
	booleanArray = [['True', 'True'],['False', 'False']],
	labelField,
	labelOperator,
	comparisonOperator,
	daysSpinner,
	hoursSpinner,
	minutesSpinner,
	businessDaysSpinner,
	isInBusinessDays,
	startOpComboBx,
	pasueOpComboBx,
    stopOpComboBx,
	moduleName,
	DZHE,
	EF,
	referenceId,
	referenceName,
	startClockGrid,
	startClockStore,
	listDataForStartClockGrid = new Array(),
	pauseClockGrid,
	pauseClockStore,
	listDataForPasueClockGrid = new Array(),
	stopClockGrid,
	stopClockStore,
	listDataForStopClockGrid = new Array(),
	idset,
	logicalOperator,
	qualificationGridStore,
	QualificationGrid,
	mutualExcWhereClause='',
	filterClauseforStopClock='',
	startlogOpComboBx,
	pauselogOpComboBx,
	stoplogOpComboBx,
	logOpeStore,
	sltId,
	selectedRowIndexStart,
	selectedRowIndexPause,
	selectedRowIndexStop,
	milestonetore,
	milestoneGrid,
	actionStore,
	actionGrid,
	JsonMilestone,
	JsonAction,
	selectedRowMilestone,
	selectedRowAction,
	milestoneToolbar,
	actionToolbar,
	isCopied=false,
	qualificationOrderIndex =1,
	serviceTargetWindow,
	clickedOnce= false,
	isMilestoneCreatable,
	isMilestoneDeletable,
	isMilestoneActionDeletable,
	isMilestoneUpdateble;
	isUpdateble = true;
var compStore = new Object();	 
function getServiceId(){
        if( window.parent.getServiceId != null  && typeof(window.parent.getServiceId) == 'function'){
             fkService = window.parent.getServiceId();
	         if(fkService != null && fkService != ''){
			 OfferingClause = escape('(serviceType__c = \'Offering\') And (FKBusinessService__c =\'' + fkService + '\')');
	            }
            }
    }	
function handleModuleChange(obj){
       populateTargetTypeFields(obj.value);
	   
}
var SaveBtnHandler = function(button,event) {
Ext.getCmp('saveId').setDisabled(true);
var DaysTargetHiddenEle=getDaysTargetHiddenEle(),
    HoursTargetHiddenEle=getHoursTargetHiddenEle(),
	MinutesTargetHiddenEle=getMinutesTargetHiddenEle(),
	BusinessDaysTargetHiddenEle=getBusinessDaysTargetHiddenEle();
	DaysTargetHiddenEle.value=daysSpinner.getValue();
	HoursTargetHiddenEle.value=hoursSpinner.getValue();
	MinutesTargetHiddenEle.value=minutesSpinner.getValue();
	BusinessDaysTargetHiddenEle.value=businessDaysSpinner.getValue();
	if(validateCriteria()){
	  Ext.getCmp('saveId').setDisabled(false);	
	 return;
    }
	setConditionsData();
	var inactiveValue=Ext.getCmp('st_inactive__c').getValue();
	save(inactiveValue);
     
}
function checkIDSet(){
	
    if(idset == null || idset == ''){
        if(typeof(window.parent.frames.SLTframe.returnListOfId) == 'function')
              idset=window.parent.frames.SLTframe.returnListOfId();
	}
	
}
checkIDSet();
var ResetBtnHandler = function(button,event) { reset();};
var PreviuosBtnHandler = function (button,event) { if(document.getElementById('prevId').disabled!=true) 
previousSLTBtnHandler();};
var NextBtnHandler = function (button,event) {if(document.getElementById('nextId').disabled!=true) nextSLTBtnHandler();};
function previousSLTBtnHandler(){
        var idSetString='';
        var i=0;
        while(idset.length > i){
            if(idSetString==''){
                idSetString=idset[i];
            }else{
                idSetString=idSetString+','+idset[i];
            }
            i++;
        }
       previousSLT(idSetString);
}
function nextSLTBtnHandler(){
	    var idSetString='';
        var i=0;
        while(idset.length > i){
            if(idSetString==''){
                idSetString=idset[i];
            }else{
                idSetString=idSetString+','+idset[i];
            }
            i++;
        }
       nextSLT(idSetString);
}
function setConditionsData() {
	var applySTStr = '';
	var startClockStr = '';
	var stopClockStr = '';
	var pauseClockStr = '';
	//data format => '1¬Category_Id__c¬=¬Hardware¬text¬AND?2¬Priority_id__c¬!=¬1¬text¬NONE';
    
	//Apply ST
	var count = 0;
	while(qualificationGridStore.data.length > count) {
		applySTStr = applySTStr + qualificationGridStore.getAt(count).get('orderIndex') + nonPrint + 
					 qualificationGridStore.getAt(count).get('operatorFieldAPIName') + nonPrint + 
					 qualificationGridStore.getAt(count).get('operatorValue') + nonPrint +
					 qualificationGridStore.getAt(count).get('operandValue') + nonPrint +
					 qualificationGridStore.getAt(count).get('operandFieldType') + nonPrint +
					 qualificationGridStore.getAt(count).get('groupingOperator') + nonPrint +
					 qualificationGridStore.getAt(count).get('qualId') + PE;
		count++;
	}
	var applySTCondns = getApplySTStrEle();
	applySTCondns.value = applySTStr;
	
	//Start clock
	count = 0;
	while(startClockStore.data.length > count) {
		startClockStr = startClockStr+ startClockStore.getAt(count).get('condition') + nonPrint + 
						'fkStatus__c' + nonPrint + 
						startClockStore.getAt(count).get('operator') + nonPrint +
						startClockStore.getAt(count).get('value') + nonPrint +
						'reference' + nonPrint +
						startClockStore.getAt(count).get('logicalOperator') + nonPrint +
						startClockStore.getAt(count).get('sfRecord') + PE;
		count++;
	}
	var startClockCondns = getStartClockStrEle();
	startClockCondns.value = startClockStr; 
	
	//Stop clock
	count = 0;
	while(stopClockStore.data.length > count) {
		stopClockStr =  stopClockStr + stopClockStore.getAt(count).get('stcondition') + nonPrint + 
						'fkStatus__c' + nonPrint + 
						stopClockStore.getAt(count).get('stoperator') + nonPrint +
						stopClockStore.getAt(count).get('stvalue') + nonPrint +
						'reference' + nonPrint +
						stopClockStore.getAt(count).get('stlogicalOperator') + nonPrint +
						stopClockStore.getAt(count).get('stsfRecord') + PE;
		count++;
	}
	var stopClockCondns = getStopClockStrEle();
	stopClockCondns.value = stopClockStr; 
	
	//Pause clock
	count = 0;
	while(pauseClockStore.data.length > count) {
		pauseClockStr = pauseClockStr + pauseClockStore.getAt(count).get('pcondition') + nonPrint + 
						'fkStatus__c' + nonPrint + 
						pauseClockStore.getAt(count).get('poperator') + nonPrint +
						pauseClockStore.getAt(count).get('pvalue') + nonPrint +
						'reference' + nonPrint +
						pauseClockStore.getAt(count).get('plogicalOperator') + nonPrint +
						pauseClockStore.getAt(count).get('psfRecord') + PE;
		count++;
	}
	var pauseClockCondns = getPauseClockStrEle();
	pauseClockCondns.value = pauseClockStr; 
	
}
 Ext.onReady(function(){
    var toolBar= new Ext.Toolbar({
        renderTo: 'toolBar',
         cls:'toolSpCls',
		id:'SLToolbar',
         items: [
                {
                    scale: 'medium',
                    iconCls: 'bmcSave',
                    tooltipType : 'title',
                    tooltip: ServiceTargetPage.Labels.Save,
                    id:'saveId' ,
                    handler:SaveBtnHandler   
                 },'',
                 {
                    scale: 'medium',
                    iconCls: 'bmcResetOn',
                    tooltipType : 'title',
                    tooltip: ServiceTargetPage.Labels.Reset,
                    id:'resetId',
					handler:ResetBtnHandler
                },'->',
                {
               id :'st_inactive__c',
               xtype  : 'checkbox',
               width  : 93,
               color :'#004376',
               align:'top',
               checked: false,
               boxLabel:'<span class="checkboxLabelCls" style="font-family: Tahoma, MS Sans Serif;font-size: 11px;">' + ServiceTargetPage.Labels.Inactive  +'</span>',
			   autoCreate: {tag: "input", type: "checkbox",title:ServiceTargetPage.Labels.TooltipIncidentInactive}  
            },
            {
                xtype : 'box',
                id    : 'prevId',
                autoEl:  {tag: 'img', 
                          src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif') , 
                          title:ServiceTargetPage.Labels.PreviousRecord
                         },
                          
                cls:'cursorCls',
				listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
                
                             
            },{
               
                xtype : 'box',
                id    : 'nextId', 
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
                          title:ServiceTargetPage.Labels.NextRecord 
                         },
                  cls:'cursorSpaceCls'  ,
				  listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
				  
            }
         ]
    });
  
  daysSpinner=new Ext.ux.form.SpinnerField({
                id:'daysSpinner',
                value:targetInDays,
                minValue: 0,
                maxValue: 99,
                width:55,
				maxLength:2,
				allowDecimals: false,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
                renderTo:'days-ct',
			   enableKeyEvents : true,
                listeners: {
                    spin: function() {
					 getDurationFieldEle().value=getDuration();
					},
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					getDurationFieldEle().value=getDuration();
					},
					keydown :function( obj, e) {
					if(e.getKey()==109)
					 e.stopEvent();
					}
          
                 }   
     });
    hoursSpinner=new Ext.ux.form.SpinnerField({
                id:'hoursSpinner',
                value:targetInHours,
                minValue: 0,
                maxValue: 23,
                width:55,
				maxLength:2,
				allowDecimals: false,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
                renderTo:'hours-ct'   ,
				enableKeyEvents : true,
				listeners: {
                    spin: function() {
					 getDurationFieldEle().value=getDuration();
					},
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					getDurationFieldEle().value=getDuration();
					},
					keydown :function( obj, e) {
					if(e.getKey()==109)
					 e.stopEvent();
					}
          
                 }   				
     });
     minutesSpinner=new Ext.ux.form.SpinnerField({
                id:'minutesSpinner',
                value:targetInMinutes,
                minValue: 0,
                maxValue: 59,
                width:55,
				maxLength:2,
				allowDecimals: false,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
                renderTo:'minutes-ct' ,
				enableKeyEvents : true,
				listeners: {
                    spin: function() {
					 getDurationFieldEle().value=getDuration();
					},
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					getDurationFieldEle().value=getDuration();
					},
					keydown :function( obj, e) {
					if(e.getKey()==109)
					 e.stopEvent();
					}
          
                 }   				
     });
     businessDaysSpinner=new Ext.ux.form.SpinnerField({
                id:'businessDaysSpinner',
                value: targetInBusinessDays,
                minValue: 0,
                maxValue: 99,
                width:55,
				maxLength:5,
				allowDecimals: true,
            	decimalPrecision: 2,
            	incrementValue: 0.25,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '5'},
                renderTo:'businessdays-ct',
			   enableKeyEvents : true,
                listeners: {
                    spin: function() {
					 getDurationFieldEle().value=getDuration();
					},
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					getDurationFieldEle().value=getDuration();
					},
					keydown :function( obj, e) {
					if(e.getKey()==109)
					 e.stopEvent();
					}
          
                 }   
     });
	 if(copyId != null && copyId != ''){
		isCopied=true;
     }
	 EnablingAndDisablingButtons();
	 initTargetFields();  
	 hideStopClockPanel();
	 logOpeStore = new Ext.data.SimpleStore({
								id:'logOpeStore',
							    data: [
							        ['AND', labelAND],
							        ['OR', labelOR],
							        ['NONE',labelNONE]     
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
								emptyText:labelLogicalOperator
								
						    });
	compStore.text = [['=','='],['!=','!='],['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
    compStore.phone = [['=','='],['!=','!=']];
    compStore.currency = [['=','='],['!=','!=']];
    compStore.percent = [['>','>'],['>=','>='],['=','='],['!=','!='],['<','<'],['<=','<=']];
    compStore.number = [['>','>'],['>=','>='],['=','='],['!=','!='],['<','<'],['<=','<=']];
    compStore.booleanVar = [['=','='],['!=','!=']];
    compStore.email = [['=','='],['!=','!='],['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
	compStore.reference = [['=','='],['!=','!=']];
	compStore.dateTime = [['>','>'],['>=','>='],['=','='],['!=','!='],['<','<'],['<=','<=']];
	compStore.textArea = [['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
	compStore.picklist = [['=','='],['!=','!='],['LIKE','LIKE'],['NOT LIKE','NOT LIKE']];
				 
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
    fieldsComboStore = new Ext.data.JsonStore({
						        id: 'fieldsStore',
						        data: fldData,
								proxy: new Ext.data.MemoryProxy(fldData),
								fields: ['id', 'type','label','e'],
					        	sortInfo: {
						                    field: 'label',
						                    direction: 'ASC'
						                  }
						    });
	fieldsEditor = new Ext.form.ComboBox({
						id: 'fieldsCombo',
						store: fieldsComboStore,
						mode: 'local',
						triggerAction: 'all',
						valueField: 'id',
						displayField: 'label',
						renderTo:'extFieldList',
						editable: false,
						listWidth:150,
						width:133,
						height:13,
						emptyText:labelField,
						listeners:{
							select: function(combo, comboRecord, index){
								comparisonOperator.store.removeAll();
								var fieldType = comboRecord.get('type');
								if(fieldType.indexOf(':') > 0){
									fieldType = fieldType.split(':')[0];
								}else if(fieldType.indexOf(EF) > 0){
									fieldType = fieldType.split(EF)[0];
								}
								
								var apiName = this.store.getAt(index).get('id');
								var label = this.store.getAt(index).get('label');
								var type = this.store.getAt(index).get('type');
								setComparisonOperatorStore(fieldType);
								setAddUpdateOnClick(null);
								setVisibilityData(apiName, label, type);
								/*var gridRecord = setAddOrUpdateButton(apiName);
								if(gridRecord != null && gridRecord != 'undefined'){
									var fieldValue = gridRecord.get('operandValue');
									var opVal = gridRecord.get('operatorValue');
									var groupOp = gridRecord.get('groupingOperator');
									setVisibilityData(apiName, label, type, fieldValue, opVal, groupOp);
								}else{
									setVisibilityData(apiName, label, type);
								}*/
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
			createMOperatorCombo();	
	        createStartClockGrid();				
			createPauseClockGrid();
			createStopClockGrid();
			disableStartRemoveBtn();
			disablePauseRemoveBtn();
			disableStopRemoveBtn();
      	var qualificationGridColModel = new Ext.grid.ColumnModel({
    	    header: true,
			columns: [
    	              {dataIndex: 'orderIndex', header:ServiceTargetPage.Labels.servicetargetOrder, sortable: false,width: 80},
    	              {dataIndex: 'operandFieldLabel', header:ServiceTargetPage.Labels.FieldName, sortable: false,width: 175},
    	              {dataIndex: 'operatorValue', header: ServiceTargetPage.Labels.serviceTargetOperator, sortable: false,width: 80},
    	              {dataIndex: 'operandValue', header: ServiceTargetPage.Labels.operandValue, sortable: false,width: 190},
    	              {dataIndex: 'groupingOperator', header: ServiceTargetPage.Labels.LogicalOperator, sortable: false,width: 113},
					  {dataIndex: 'operatorFieldAPIName', hidden:true},
					  {dataIndex: 'operandFieldType', hidden:true},
					  {dataIndex: 'qualId', hidden:true}
    	              ]
     });
	
     qualificationGridStore = new Ext.data.SimpleStore({
    	 fields:['orderIndex', 'operandFieldLabel', 'operatorValue', 'operandValue', 'groupingOperator', 'operatorFieldAPIName','operandFieldType','qualId']
     });
	
     QualificationGrid = new Ext.grid.GridPanel({
    	 id:'qualificationCriteriaGrid',
         store: qualificationGridStore,
         cm: qualificationGridColModel,
         columnLines: true,
         enableHdMenu:false,
         enableColumnResize: false,
         enableColumnMove: false,         
         width:640,
		 height:220,
		 border:false,
		 stripeRows:true,
		  viewConfig:{forceFit:true,scrollOffset:0 },
		 sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		 listeners:{
			rowClick: function(thisGrid, rowIndex, e ){
				setInputDataAndElementsOnRowClick(rowIndex);
			}			
		 }
     });
	  QualificationGrid.render('qualificationGridDiv');
	  loadDataToGrids();
	  
	  getMilestonegrid();
	  getMiletoneToolbar();	
	  loadDatatoMilestonetore();
	  getActionrid();
	  getActionToolbar();
	  loadDatatoActionstore();	
	  getWaitbox();
	  disableMilestoneAndActionTab();
	  if(isRecDeleted) {
		Ext.Msg.alert(ServiceTargetPage.Labels.Information,ServiceTargetPage.Labels.DeletedRecord, function(){
		var stWindowObj=window.parent.Ext.getCmp('popupWindowId1');
		if((typeof(stWindowObj)!='undefined')&&(typeof(stWindowObj)!= 'undefined'))
			stWindowObj.close();
		});
	 }
	 handleElemEvent();
	 serviceTargetWindow = window.parent.Ext.getCmp('popupWindowId1');
	 serviceTargetWindow.pendingClose = false;
	 serviceTargetWindow.on('beforeclose',function(){
		if(serviceTargetWindow.pendingClose == false){
				if(clickedOnce== true){				 
					window.parent.confirmClose(serviceTargetWindow);
					return false;
				}
				
			}
		});
	 
	if (Ext.isMac && Ext.isSafari)
	{
  		document.getElementById('extFieldList').firstChild.style.width = '135px';
  		document.getElementById('compareOpDiv').firstChild.style.width = '85px';
		document.getElementById('booleanCombo').firstChild.style.width = '150px';
  		document.getElementById('qualLogicalOperatorCombo').firstChild.style.width = '120px';
  		document.getElementById('startOpComboDiv').firstChild.style.width = '85px';
  		document.getElementById('startlogOpComboDiv').firstChild.style.width = '85px';
		document.getElementById('pauseOpComboDiv').firstChild.style.width = '85px';
  		document.getElementById('pauselogOpComboDiv').firstChild.style.width = '85px';
		document.getElementById('stopOpComboDiv').firstChild.style.width = '85px';
  		document.getElementById('stoplogOpComboDiv').firstChild.style.width = '85px';
		document.getElementById('picklistCombo').firstChild.style.width = '150px';
		
  	} 
 });
	 function getMilestonegrid(){
		 var idx;
		 var milestoneGridColModel = new Ext.grid.ColumnModel({
				header: false,
				columns: [
							{dataIndex: 'Condition', header:'Condition',renderer: renderTooltip,sortable: false,width: 260},
							{dataIndex: 'ConditionId', header:'ConditionId',renderer: renderTooltip,sortable: false,hidden:true}
						 ]
		 });
		/* root-The name of the property which contains data for the grid */
		milestonetore = new Ext.data.SimpleStore({
			 fields: [  {
                            name: 'Condition',
                            type: 'string'
                        },{
                            name: 'ConditionId',
                            type: 'string'
                        }
					]
			 
		 });
		milestoneGrid = new Ext.grid.GridPanel({
		  store:milestonetore,
		  id:'milestoneGridId',
		  cm:milestoneGridColModel,
		  border:false,
		  listeners:{
			rowDblClick: function(thisGrid, rowIndex, e ){
				window.parent.openPopupWithTitle('SLAMilestonePage?appliesToId='+escape(appliesTo)+'&SLTId='+escape(sltId)+'&Id='+getcurrSelectedMilestoneID().value,reloadMilestones,labelMilestoneandActionsTitle+' - ' + SLTTitle,Ext.isIE?490:485,662);
			}			
		 },
		  sm: new Ext.grid.RowSelectionModel({
												singleSelect:true,
												listeners:{ 
															rowselect:function(){
															    showWaitbox();
																selectedRowMilestone = milestoneGrid.getSelectionModel().getSelected();
																getcurrSelectedMilestoneID().value=selectedRowMilestone.get('ConditionId');
																getcurrSelectedMilestoneCondition().value=selectedRowMilestone.get('Condition');
																var milestoneId = getcurrSelectedMilestoneID().value;
																var milestoneCond = getcurrSelectedMilestoneCondition().value;
																
																getActions(milestoneId,milestoneCond);
																idx=milestoneGrid.store.indexOf(selectedRowMilestone);
																if(idx!=0 && flag){
															    Ext.get(milestoneGrid.getView().getRow(0)).removeClass('x-grid3-row-selected');
																flag=false;
																}
															}
														  }
											}),
		  width:260,
		  height:170,
		  stripeRows:true,
		  viewConfig:{
						forceFit:true,
						scrollOffset:0
					 }
		 
		
		});
		milestoneGrid.render('avaiMilestonediv');
	}
	function getActionrid(){
	     var i,ActionIds;
		var actionGridColModel = new Ext.grid.ColumnModel({
				header: false,
				columns: [
							{dataIndex: 'ActionLabel', header:'Action',renderer: addToolTip,sortable: false,width: 360},
							{dataIndex: 'ActionId', header:'ActionId',renderer: addToolTip,sortable: false,hidden:true}
						 ]
		 });
		
		actionStore = new Ext.data.SimpleStore({
			 fields: [  
						{
                            name: 'ActionLabel',
                            type: 'string'
                        },{
                            name: 'Action',
                            type: 'string'
                        },{
                            name: 'ActionId',
                            type: 'string'
                        }
					]
			 
			});
		
		actionGrid = new Ext.grid.GridPanel({
		  store:actionStore,
		  id:'actionGridId',
		  cm:actionGridColModel,
		  border:false,
		  sm: new Ext.grid.RowSelectionModel({
												
												listeners:{ 
															rowselect:function(){
																if(isMilestoneActionDeletable != null && isMilestoneActionDeletable == 'false'){
																	Ext.getCmp('btnRemoveAct').setDisabled(true);
																	Ext.getCmp('btnRemoveAct').setIconClass('bmcDeleteSLTDisable');
																}else{
																ActionIds='';
																selectedRowAction = actionGrid.getSelectionModel().getSelections();
																for(i=0;i<selectedRowAction.length;i++){
																	if(i==0)
																		ActionIds+=selectedRowAction[i].get('ActionId');																	
																	else
																		ActionIds+=','+selectedRowAction[i].get('ActionId');
																
																}
															    getcurrSelectedActionID().value=ActionIds;	
															     Ext.getCmp('btnRemoveAct').setDisabled(false);
																  Ext.getCmp('btnRemoveAct').setIconClass('bmcDeleteSLT');
																 
																//document.images['btnRemoveAct'].src= SdefStyles+'/SDEFbuttons/btn_delete.png';
																}											
																
															} 
														  }
											}),
		  width:360,
		  height:170,      
		  stripeRows:true,
		  viewConfig:{
				  forceFit:true,
				  scrollOffset:0 
			  }		
		});
		actionGrid.render('corrActionsdiv');
	}
	function loadDatatoMilestonetore(){
			//alert(JsonMilestone);
			if(JsonMilestone!=null){
					milestonetore.removeAll();
					Ext.getCmp('milestoneGridId').getView().refresh();
					milestonetore.loadData(JsonMilestone);
					Ext.getCmp('milestoneGridId').getView().refresh();
			}
				
			 if(isMilestoneCreatable != null && isMilestoneCreatable == 'false'){
				Ext.getCmp('btnAdd').setDisabled(true);
				Ext.getCmp('btnAdd').setIconClass('bmcNewSLTDisable');
				
				// Select the first row of Milestoen on load
				selectedRowMilestone=milestonetore.getAt(0);
				milestoneGrid.getSelectionModel().selectFirstRow();
				flag=true;
			}else{
				Ext.getCmp('btnAdd').setDisabled(false);
				Ext.getCmp('btnAdd').setIconClass('bmcNewSLT');
				EnableAddRemovebtns();
			}		
			if(!isMilestoneUpdateble){
				Ext.getCmp('btnEdit').setDisabled(true);
				Ext.getCmp('btnEdit').setIconClass('bmcEditSLTDisable');	
			}
			if(isMilestoneDeletable != null && isMilestoneDeletable == 'false'){
				Ext.getCmp('btnRemove').setDisabled(true);
				Ext.getCmp('btnRemove').setIconClass('bmcDeleteSLTDisable');
			}	
				
} 
function loadDatatoActionstore(){	
				//alert(JsonAction)
			    if(JsonAction!=null){
					actionStore.removeAll();
					Ext.getCmp('actionGridId').getView().refresh();
					actionStore.loadData(JsonAction);
					Ext.getCmp('actionGridId').getView().refresh();
			    }  
				  disableDeletebtn();
}

function EnableAddRemovebtns(){
       var btnDelete=Ext.getCmp('btnRemove');
	   var btnEdit=Ext.getCmp('btnEdit');
	   if(milestonetore.data.length<=0){
		    /*
			if there are no milestone disable EDIT and DELETE button
			*/
			
			btnDelete.setDisabled(true);
			btnDelete.setIconClass('bmcDeleteSLTDisable');			
			
			btnEdit.setDisabled(true);
			btnEdit.setIconClass('bmcEditSLTDisable');		
			
		}
		else{
			btnDelete.setDisabled(false);
			btnDelete.setIconClass('bmcDeleteSLT');
		
		  	btnEdit.setDisabled(false);
		    btnEdit.setIconClass('bmcEditSLT');	
            /*
			
			This code is to highlight the first row for the first time.This is necessary to avoid the post call.
			for the first time.
			*/
			selectedRowMilestone=milestonetore.getAt(0);
		    milestoneGrid.getSelectionModel().selectFirstRow();
			flag=true;
			
		}
		if(!isMilestoneUpdateble){
			Ext.getCmp('btnEdit').setDisabled(true);
			Ext.getCmp('btnEdit').setIconClass('bmcEditSLTDisable');	
		}

}

function disableDeletebtn()
{
		var btnDeleteAct=Ext.getCmp('btnRemoveAct');  
		btnDeleteAct.setDisabled(true);
		btnDeleteAct.setIconClass('bmcDeleteSLTDisable');	
}

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
	 function showWaitbox()
	{
		if(Ext.getCmp('waitMsggId')!=null)
			Ext.getCmp('waitMsggId').show();
    }
	
	function hideWaitbox()
	{
		if(Ext.getCmp('waitMsggId')!=null)
			Ext.getCmp('waitMsggId').hide();
    }
	
	function disableMilestoneAndActionTab(){
	   var milestoneActionBtn=document.getElementById('milestones_actions_id');
	   if(milestoneActionBtn!=null){
			   if(disableMilestoneTab) { 			            
					document.getElementById('milestones_actions_id').style.color ='#808080';			    		
					milestoneActionBtn.disabled=true;                        	
						
			   }
			   else{
					 milestoneActionBtn.disabled=false; 
					 document.getElementById('milestones_actions_id').style.color='#004376';
					 
			   }
			   
		}
   }
   
   function getMiletoneToolbar(){
           milestoneToolbar=new Ext.Toolbar({
        	id:'milestoneToolbarId',
			cls:'toolSpCls',			
			items: [
			      {
                 
   				    scale: 'medium',
                    iconCls: 'bmcNewSLT',
                    tooltipType : 'title',                   
					tooltip :ServiceTargetPage.Labels.labelAdd,
                    id:'btnAdd' ,
                    handler:function(){window.parent.openPopupWithTitle('SLAMilestonePage?appliesToId='+escape(appliesTo)+'&SLTId='+escape(sltId),reloadMilestones,labelMilestoneandActionsTitle+' - ' + SLTTitle,490,720,false);}   
                 }, {
				   
                    scale: 'medium',
                    iconCls: 'bmcEditSLT',
                    tooltipType : 'title',                   
				    tooltip :ServiceTargetPage.Labels.labelEdit,
                    id:'btnEdit' ,
                    handler:function(){window.parent.openPopupWithTitle('SLAMilestonePage?appliesToId='+escape(appliesTo)+'&SLTId='+escape(sltId)+'&Id='+getcurrSelectedMilestoneID().value,reloadMilestones,labelMilestoneandActionsTitle+' - ' + SLTTitle,490,720);}
                 }, {
				   
                    scale: 'medium',
                    iconCls: 'bmcDeleteSLT',
                    tooltipType : 'title',                   
					tooltip :ServiceTargetPage.Labels.labelDelete,
                    id:'btnRemove' ,
                    handler:ConfrimDeleteMilestone
                 }		 
                
                ]
		});		
   milestoneToolbar.render('milestoneToolbardiv');
   
   }
   
    function getActionToolbar(){
   
            actionToolbar = new Ext.Toolbar({
			cls:'toolSpCls',
        	id:'actionToolBarId',		
			items: [ {	
                    xtype:'button',		
                    scale: 'medium',
                    iconCls: 'bmcDeleteSLTDisable',
                    tooltipType : 'title',                   
					tooltip :ServiceTargetPage.Labels.labelDelete,	
                    id:'btnRemoveAct' ,
                    handler:ConfrimDeleteAction
                 }	
                
                ]
		});	
actionToolbar.render('actionToolbardiv');		
   
   }
	
	
	 function renderTooltip(value, metaData, record, rowIndex, colIndex, store) { 
    	   // var header = QualificationGrid.getColumnModel().getColumnTooltip(colIndex);
    	    metaData.attr = 'title="'+value+'"';
    	    return value;     
    	}
    
	function addToolTip(data, cell, record, rowIndex, columnIndex, store) {
		cell.attr = 'title="'+Ext.util.Format.htmlEncode(record.data.Action)+'"';
        return data;
    }	
    
function setAddOrUpdateButton(apiName){
	var storeLength =QualificationGrid.store.getCount();
	for(var i =0; i < storeLength; i++){
		var gridRecord = QualificationGrid.store.getAt(i);
		var addedApiName = gridRecord.get('operatorFieldAPIName');
		if(addedApiName == apiName){
			QualificationGrid.getSelectionModel().selectRow(i,false,false);
			var selectedRec = QualificationGrid.getSelectionModel().getSelected();
			setAddUpdateOnClick(true);
			return selectedRec;
		}
	}
	var temp;	
	setAddUpdateOnClick(temp);
	return temp;
}
function getRemoveBtnEle(){
	return document.getElementById('removeButtonId');
}
 function setVisibilityData(apiName, label, type, elementVal, opVal, groupOp){
		isInList = false;
        var dataLength =  fldData.length;
        selectedApiName = apiName;
		selectedLabel = label;
		
        if(isInList == false ){
			if(type.indexOf(':') > 0){
				selectedTextAreaLength = type.split(':')[1];
				type = type.split(':')[0];
			}else if(type.indexOf(EF) > 0){
				popUpString = type.split(EF)[1];
				type = type.split(EF)[0];
			}
			
			if(type == 'text'){
				assignVisibility('inline','none','none','none','none','none','none',null,1,elementVal);    
			}else if(type == 'phone'){
				assignVisibility('inline','none','none','none','none','none','none',null,10,elementVal);  
			}else if(type == 'currency'){
				assignVisibility('inline','none','none','none','none','none','none',null,11,elementVal);  
			}else if(type == 'percent'){
				assignVisibility('inline','none','none','none','none','none','none',null,9,elementVal);  
			}else if(type == 'email'){
				assignVisibility('inline','none','none','none','none','none','none',null,8,elementVal);  
			}else if(type == 'number'){
				assignVisibility('inline','none','none','none','none','none','none',null,7,elementVal);    	
			}else if(type == 'boolean'){
				assignVisibility('none','none','none','inline','none','none','none',null,2,elementVal);
			}else if(type == 'textarea'){
				assignVisibility('none','inline','none','none','none','none','none',null,3,elementVal);
			}else if(type == 'picklist'){
				setPickListOptions(selectedApiName);
				assignVisibility('none','none','none','none','inline','none','none',null,4,elementVal);
			}else if(type == 'reference'){
				assignVisibility('inline','none','inline','none','none','none','none',apiName,5,elementVal);
			}else if(type == 'reference1'){ //Added for user lookup custom field
				assignVisibility('inline','none','inline1','none','none','none', 'none',apiName,6,elementVal);
			}else if(type == 'datetime'){
				assignVisibility('none','none','none','none','none', 'inline', 'none',null,12,elementVal);
			}else if(type == 'date'){
				assignVisibility('none','none','none','none','none', 'none', 'inline',null,13,elementVal);
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
			//txtAreaEle.value  = '';
			//alert('txtAreaBtnEle type: ' + txtAreaBtnEle.type);
			//alert('iTextArea: *' + iTextArea +'*');
			if(txtAreaBtnEle != null && typeof(txtAreaBtnEle) != 'undefined'){
				if(iTextArea == 'inline'){
					txtAreaBtnEle.style.display = 'block';
					//alert('txtAreaBtnEle.style.display ' + txtAreaBtnEle.style.display);
				}else{
					txtAreaBtnEle.style.display = 'none';
				}
				/*if(iTextArea == 'none'){
					txtAreaBtnEle.style.visibility  = 'hidden';
				}else{
					txtAreaBtnEle.style.visibility  = 'visible';
				}*/
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
			//alert('iLookUp : ' + iLookUp);
			//alert('lookupEle : ' + lookupEle);
			if(lookupEle != null && typeof(lookupEle) != 'undefined'){
				//alert('1');
				//alert('1 : lookupEle.disabled : ' + lookupEle.disabled);
				lookupEle.disabled = false;
				lookupEle.style.visibility  = 'visible';
				lookupEle.style.display  = 'inline';
				
				//lookupEle.disabled = 'false';
				//alert('2 : lookupEle.disabled : ' + lookupEle.disabled);
			}
			if(elementVal != null && elementVal != 'undefined'){
				txtEle.disabled  = elementVal;
			}
            //document.getElementById('{!$Component.templateFormId.lookUpUser}').style.display='none';
            txtEle.disabled  = true;
            popUpEnable = true;
        }else{
			if(lookupEle != null && typeof(lookupEle) != 'undefined'){
				lookupEle.style.visibility  = 'hidden';
				lookupEle.style.display = 'none';
				lookupEle.disabled = true;
			}
		}
         if(iLookUp == 'inline1'){ //Added for user lookup custom field
            //document.getElementById('{!$Component.templateFormId.lookUpUser}').disabled  = false;
            //document.getElementById('{!$Component.templateFormId.lookUpUser}').style.display='inline';
            lookupEle.style.display='none';
            txtEle.disabled  = true;
            txtEle.value  = '';
            popUpEnable = true;
        }
		
		/*if(isDateTime == 'inline'){
				dateTimeInput.disabled  = false;
				dateTimeInput.style.display='inline';
				dateTimePickerImg.disabled  = false;
				dateTimePickerImg.style.display='inline';
				//var datePicker = new Ext.DatePicker({renderTo:'dateValue'});
			}*/
		//document.getElementById('{!$Component.lookUpPanel}').rendered  = true;
        compTypeNo = typeNo;
	} 
    function displayTabPanel(btnObj){
        var btnArray = new Array(4);
        btnArray[0]={btnId:'Service_target_Id',textAreaCompId:'serviceTargetPanel'};
        btnArray[1]={btnId:'qualification_id',textAreaCompId:'qualificationPanel'};
        btnArray[2]={btnId:'measurement_id',textAreaCompId:'measurementPanel'};
        btnArray[3]={btnId:'milestones_actions_id',textAreaCompId:'milestoneActionPanel'};
        activeBtnId = btnObj.id;
       
        for(var i =0; i< btnArray.length; i++){
          if(activeBtnId== btnArray[i].btnId){
                document.getElementById(btnArray[i].btnId).style.fontWeight = 'bold';
               document.getElementById(btnArray[i].textAreaCompId).style.display = 'block';
          
          }else{
                document.getElementById(btnArray[i].btnId).style.fontWeight = 'normal';
                document.getElementById(btnArray[i].textAreaCompId).style.display = 'none';
            }
        }
		QualificationGrid.getView().refresh();
		startClockGrid.getView().refresh();
   }   
	 function getPickListOptions(fieldname) {
    	for (var i=0; i < fldData.length; i++) {
    		var dataObj = fldData[i];
        	var fldObjParts = dataObj['e'].split(EF);
        	var fldObjLabel = fldObjParts[0];
        	if (fldObjLabel == fieldname) {
        		var ploptions = fldObjParts[1].split(DZHE);
        		return ploptions;
        	}
    	}
    	return null;
    }
    
    function setPickListOptions(fld) {    	
    	var objpicklist = Ext.getCmp('pickListFieldCombo');
    	if (objpicklist != null) {
    		var plo = getPickListOptions(fld);
    		//objpicklist.length=0;
			pickListArray = new Array();
    		for (var i = 0;i < plo.length;i++) {
    			//var op=document.createElement("option");
				if (plo[i] != '') {
					//var listEle = [plo[i],plo[i]];
                	//op.text=plo[i];
                	//op.value = plo[i];
	    			pickListArray[i] = [plo[i],plo[i]];
                }
    		}
			pickListComboStore.removeAll();
			pickListComboStore.loadData(pickListArray);
			pickListComboBx.setVisible(true);
    	}
    }
	function populateQualFieldsData(){
		fieldsComboStore.removeAll();
		fieldsComboStore.loadData(fldData);
		assignVisibility('inline','none','none','none','none','none','none',null,1);
		fieldsEditor.reset();
		pickListComboBx.reset();
		booleanComboBx.reset();
		comparisonOperator.reset();
		loadDataToGrids();
		hideStopClockPanel();
	}
	
	
//var SDEDateFormat =  "m/d/Y h:i A";
if(typeof(SDEDateFormat)=='undefined' || SDEDateFormat==null ||  SDEDateFormat=='')
{
	this.SDEDateFormat =  "m/d/Y h:i A";
}
Date.useStrict = true;
var dataModifiedFlag = 0;
var cdateFormat = '';

function getDataModifiedFlag(){
	return dataModifiedFlag;
}

function setDataModifiedFlag(){
	dataModifiedFlag = 0;
}

QualDatePickerPopup = function(){}
QualDatePickerPopup.prototype = {

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
                            x:rgn.right-180,
                            y:rgn.top-110, 
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

var _datePicker = new QualDatePickerPopup();

function changedateformat(){
	//alert('&&&');
	if(document.getElementById('{!$Component.custominputDate}')){
		var temp = document.getElementById('{!$Component.inputDate}').value;          
		var cdate = temp.split(' ');
		//alert('cdate[0] : ' + cdate[0]);
		document.getElementById('{!$Component.inputDate}').value = cdate[0];
	}
}

function openQualLookup(){   
    //alert('popUpString :' + popUpString);
	if(popUpString == 'BMC BaseElement'){
		popUpString  = 'BMC_BaseElement';
	}else if(popUpString == 'User' || popUpString == 'Group'){
		openPopup('SearchPage?popupId=Client&isQueurorUser=true&isLookup=true&idNameForPopUp=true', setReferenceToVal, 450, 600, true);
	}else if(popUpString == 'SYSTemplate__c'){
		var templateForEle = getAppliesToEle();
		if(templateForEle != null && typeof(templateForEle) != 'undefined'){
			var templateFor = templateForEle.value;
			//alert('templateFor : ' + templateFor);
			if(templateFor == 'Incident__c'){
				openPopup('SearchPage?popupId=SYSTemplate__c&isLookup=true&idNameForPopUp=true&referenceObjectName=SYSTemplate__c&filterClause='+escape("templateFor__c='Incident'"), setReferenceToVal, 450, 600, true);
			}else if(templateFor == 'Change_Request__c'){
				openPopup('SearchPage?popupId=SYSTemplate__c&isLookup=true&idNameForPopUp=true&referenceObjectName=SYSTemplate__c&filterClause='+escape("templateFor__c='Change Request'"), setReferenceToVal, 450, 600, true);
			}
		}
		
	}else if(popUpString == 'BMC_BaseElement__c'){
		openPopup('SearchPage?popupId=BMC_BusinessService__c&isLookup=true&idNameForPopUp=true&referenceObjectName=BMC_BusinessService__c&filterClause='+OfferingClause, setReferenceToVal,450, 600, true);
    }else{
		openPopup('SearchPage?popupId='+popUpString+'&isLookup=true&idNameForPopUp=true&referenceObjectName='+popUpString, setReferenceToVal,450, 600, true);
	}
}
function setReferenceToVal(idname){
	//if(popUpString != 'Category__c'){
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
	//}
}
//follow the sequence of special characters while decode.
function decodeVal(val) {
	val = val.replace("&gt;", ">", "g");
	val = val.replace("&lt;", "<", "g");
	val = val.replace("&quot;", "\"", "g");
	val = val.replace("&amp;", "&", "g");
	return val;
}
function padNumberToTwodigit(number) {
     return (number < 10 ? '0' : '') + number;
   
}
function getDuration() {
	var days=padNumberToTwodigit(daysSpinner.getValue()),
		hours=padNumberToTwodigit(hoursSpinner.getValue()),
		minutes=padNumberToTwodigit(minutesSpinner.getValue()),
		businessdays=padNumberToTwodigit(businessDaysSpinner.getValue());
	var duration=days +' '+ ServiceTargetPage.Labels.Days+' '+hours+':'+minutes+' '+ServiceTargetPage.Labels.HHMM;
	if(isInBusinessDays){
		duration = businessdays +' '+ ServiceTargetPage.Labels.BusinessDays;
 	}
 return duration;

}
function setCatData(id, name, catUrgency) {
	var textboxEle = getInputTxtEle();
	textboxEle.value = name;
	var hiddenIdEle = document.getElementById('referenceID'); 
	hiddenIdEle.value = id;
}
function setDescriptionNext(){

}
function setResolutionNext(){

}
function addSLTQData(){
	addUpdateSLTQData();
}
function addUpdateSLTQData(extRecord){
 // 
   var qualificationRecord;
   if(extRecord == null || extRecord == 'undefined' || typeof(extRecord) == 'undefined'){
		qualificationRecord = new Ext.data.Record();
		qualificationRecord.set('orderIndex',qualificationOrderIndex);
   }else{
		qualificationRecord = extRecord;
   }
   
   
   //alert(fieldsEditor.getValue());
   var operandField = fetchQualificationComboFieldLabel();
   if(operandField != null && operandField != '' && operandField != 'undefined'){
	   var operandFieldValue = operandField.get('label');
	   if(operandFieldValue != null && operandFieldValue != '' && operandFieldValue != 'undefined'){
			qualificationRecord.set('operandFieldLabel', operandFieldValue);
			qualificationRecord.set('operatorFieldAPIName', operandField.get('id'));
			var fType = operandField.get('type');
			if(fType != null && fType.indexOf(':') > 0){
				fType = fType.split(':')[0];
			}
			qualificationRecord.set('operandFieldType', fType);
	   }
   }else{
		showExtMsg(ServiceTargetPage.Labels.SelectFieldErrMsg);
		return;
   }
   var compariosnOp = comparisonOperator.getValue();
   if(compariosnOp != null && compariosnOp != '' && compariosnOp != 'undefined'){
		qualificationRecord.set('operatorValue', compariosnOp);
   }else{
		showExtMsg(ServiceTargetPage.Labels.SelectCmpOpMsg);
		return;
   }
   
   //qualificationRecord.set('operandFieldLabel', 'tet');
   var groupingOp = logicalOperator.getValue();
   if( groupingOp != null && groupingOp != '' && groupingOp != 'undefined'){
		qualificationRecord.set('groupingOperator', groupingOp);
	}else{
		showExtMsg(ServiceTargetPage.Labels.SelectLogOpMsg);
		return;
	}
   //qualificationRecord.set('operatorFieldAPIName', fieldsEditor.getValue());
   //alert(compTypeNo);
   var operandVal;
   if(compTypeNo=='1'||compTypeNo=='10'||compTypeNo=='11'||compTypeNo=='7'||compTypeNo=='8'||compTypeNo=='9'||compTypeNo=='5'){
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
   }else if(compTypeNo=='4'){
   		operandVal = pickListComboBx.getValue();
   }else if(compTypeNo=='12'){
		operandVal = getDateTimeInputEle().value;
   }else if(compTypeNo=='13'){
		operandVal = getDateInputEle().value;
   }
   var errorFlag
   if(operandVal != null && operandVal != '' && operandVal != 'undefined'){
	errorFlag = validateData(operandVal);
	 if(errorFlag){
		return;
	 }else{
		qualificationRecord.set('operandValue', operandVal);
	 }
   }else{
	showExtMsg(ServiceTargetPage.Labels.EnterValMsg);
	return;
   }
   
   if(extRecord == null || extRecord == 'undefined' || typeof(extRecord) == 'undefined'){
		qualificationGridStore.add(qualificationRecord);
		qualificationOrderIndex = qualificationOrderIndex + 1;
		clearQualificationCriteria();
	}
	QualificationGrid.getView().refresh();
   
   
   //getRemoveBtnEle().disabled= false;
   // function call to clear data once the values are added to the grid
   
 
 }
 /* Fetches the field Api name for the selected field*/
 function fetchQualificationComboFieldLabel(){
  var selectedValue = fieldsEditor.getValue();
  for(var i=0; i < fieldsComboStore.data.length; i++){
    if(selectedValue == fieldsComboStore.getAt(i).get('id')){
         return fieldsComboStore.getAt(i);
         
    }
  }
  return '';
 }
 /*Removes the selected row from the Qualification Criteria Grid*/
 function removeSLTQData(){ 
  var selectedRow =  QualificationGrid.getSelectionModel().getSelected();
  if(selectedRow != null && selectedRow != 'undefined'){
	QualificationGrid.store.remove(selectedRow);
    qualificationOrderIndex = qualificationOrderIndex - 1;
	var storeLength =QualificationGrid.store.getCount();
	for(var i =0; i < storeLength; i++){
		var gridRecord = QualificationGrid.store.getAt(i);
		gridRecord.set('orderIndex',i+1);
	}
	QualificationGrid.render('qualificationGridDiv');
	getRemoveBtnEle().src=getSDFStylesResPath()+'/SDEFbuttons/b_remove_disabled.png';
	getRemoveBtnEle().disabled = true;
	fieldsEditor.setValue('');
   	comparisonOperator.setValue('');
   	logicalOperator.setValue('');
	pickListComboStore.removeAll();
	pickListComboBx.setValue('');
	getInputTxtEle().value = '';
	assignVisibility('inline','none','none','none','none','none','none',null,1);
	setAddUpdateOnClick(null);
  }
   
 }
 /*Clears the criteria editor once the criteria is added/updated/removed in the grid*/
function clearQualificationCriteria(){
	if(compTypeNo=='1'||compTypeNo=='10'||compTypeNo=='11'||compTypeNo=='7'||compTypeNo=='8'||compTypeNo=='9'|| compTypeNo=='5'){
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
   	}else if(compTypeNo=='4'){
   		operandVal = pickListComboBx.setValue('');
   	}else if(compTypeNo=='12'){
		var dateTimeInputEle = getDateTimeInputEle();
		if(dateTimeInputEle != null && dateTimeInputEle != 'undefined'){
			dateTimeInputEle.value = ''
		}
	}else if(compTypeNo=='13'){
		var dateInputEle = getDateInputEle();
		if(dateInputEle != null && dateInputEle != 'undefined'){
			dateInputEle.value = '';
		}
	}else if(compTypeNo=='6'){
		var textboxEle = getInputTxtEle();
		if(textboxEle != null && typeof(textboxEle) != 'undefined'){
			textboxEle.value = '';
			var hiddenIdEle = document.getElementById('referenceID'); 
			if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
				hiddenIdEle.value = '';
			}
		}
	}
   	fieldsEditor.setValue('');
   	comparisonOperator.setValue('');
   	logicalOperator.setValue('');
}
function createStartClockGrid(){
        startClockStore = new Ext.data.ArrayStore({
            fields: ['condition','fieldName','operator','value','logicalOperator','sfRecord'],
            data : []
        });
 startClockGrid = new Ext.grid.GridPanel({
              renderTo:'startClockGridDiv',
              id:'startClockGridId',
              width:'100%',
			  height:170,
              border:false,
			  sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
              store: startClockStore,
              columns: [{
	  id:'colConditionId',header:ServiceTargetPage.Labels.servicetargetOrder, width:80, sortable: false,
	  dataIndex: 'condition'},
	 {header: ServiceTargetPage.Labels.FieldName,  id:'colfieldNameId',width:175, sortable: false, 
	  dataIndex: 'fieldName'},
	 {header: ServiceTargetPage.Labels.serviceTargetOperator,id:'colOperatorId',width:80,sortable: false,
	  dataIndex: 'operator'},
	 {header: ServiceTargetPage.Labels.operandValue,id:'colValueId',width:190, sortable: false,
	  dataIndex: 'value'},
	{ header:ServiceTargetPage.Labels.LogicalOperator,id:'colLogicalOperatorId',width:110, sortable: false, 
	  dataIndex: 'logicalOperator'},
	{ id:'colSfRecord',width:5, sortable: false,hidden: true, dataIndex: 'sfRecord'}],
		 stripeRows : true,
		  columnLines: true,
	 enableHdMenu:false,
	 enableColumnResize: false,
	 enableColumnMove: false, 
          viewConfig:{
              forceFit:true,
              scrollOffset:0 
          },
          
              listeners: {
                  rowClick :function(grid,a,b){
                      var record = grid.store.getAt(a);
					  selectedRowIndexStart=a;
                      field=record.get('fieldName');
					  comOperator=record.get('operator');
					  logOperator=record.get('logicalOperator');
                      value=record.get('value');
					  populateValuesOnRowClick([value,comOperator,logOperator],[getStartStatusEle(),'updateStart_id','addStart_id'],[startOpComboBx,startlogOpComboBx]);

					  enableStartRemoveBtn();
                  }
              }        
      });
}
function createPauseClockGrid(){
 pauseClockStore = new Ext.data.ArrayStore({
            fields: ['pcondition','pfieldName','poperator','pvalue','plogicalOperator','psfRecord'],
            data : []
 });
 pauseClockGrid = new Ext.grid.GridPanel({
	renderTo:'pauseClockGridDiv',
	id:'pauseClockGridId',
	width:'100%',
	height:170,
	border:false,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	store: pauseClockStore,
	columns:[{id:'pcolConditionId',header:ServiceTargetPage.Labels.servicetargetOrder , width:80, sortable: false, dataIndex: 'pcondition'}
		 ,{id:'pcolfieldNameId',header: ServiceTargetPage.Labels.FieldName,width:175, sortable: false, dataIndex: 'pfieldName'}
		 ,{id:'pcolOperatorId',header: ServiceTargetPage.Labels.serviceTargetOperator,width:80,  sortable: false,dataIndex: 'poperator'}
		 ,{id:'pcolValueId', header: ServiceTargetPage.Labels.operandValue ,width:190, sortable: false,dataIndex: 'pvalue'}
	   ,{id:'colLogicalOperatorId',header:ServiceTargetPage.Labels.LogicalOperator,width:110,sortable:false,dataIndex: 'plogicalOperator'}
	    ,{ id:'colSfRecord', width:5,sortable: false,hidden: true,dataIndex: 'psfRecord'}
	],
	stripeRows : true,
	 columnLines: true,
	 enableHdMenu:false,
	 enableColumnResize: false,
	 enableColumnMove: false, 
    viewConfig:{forceFit:true,scrollOffset:0 },
	listeners: {
	  rowClick :function(grid,a,b){
		  var record = grid.store.getAt(a);
		  selectedRowIndexPause=a;
		  field=record.get('pfieldName');
		  comOperator=record.get('poperator');
		  logOperator=record.get('plogicalOperator');
		  value=record.get('pvalue');
		  populateValuesOnRowClick([value,comOperator,logOperator],[getPauseStatusEle(),'updatePause_id','addPause_id'],[pasueOpComboBx,pauselogOpComboBx]);
		  enablePauseRemoveBtn();
	  }
   }  
   });
}

function createStopClockGrid(){
stopClockStore = new Ext.data.ArrayStore({
            fields: ['stcondition','stfieldName','stoperator','stvalue','stlogicalOperator','stsfRecord'],
            data : []
});
stopClockGrid = new Ext.grid.GridPanel({
	renderTo:'stopClockGridDiv',
	id:'stopClockGridId',
	width:'100%',
	height:170,
	border:false,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	store: stopClockStore,
	columns:[{id:'stcolConditionId',header:ServiceTargetPage.Labels.servicetargetOrder , width:80, sortable: false, dataIndex: 'stcondition'}
		 ,{id:'stcolfieldNameId',header:ServiceTargetPage.Labels.FieldName, width:175, sortable: false, dataIndex: 'stfieldName'}
		 ,{id:'stcolOperatorId',header: ServiceTargetPage.Labels.serviceTargetOperator,width:80,  sortable: false,dataIndex: 'stoperator'}
		 ,{id:'stcolValueId', header: ServiceTargetPage.Labels.operandValue,width:190, sortable: false,dataIndex: 'stvalue'}
	 ,{id:'stcolLogicalOperatorId',header:ServiceTargetPage.Labels.LogicalOperator,width:110,sortable:false,dataIndex: 'stlogicalOperator'}
	    ,{ id:'stcolSfRecord', width:5,sortable: false,hidden: true,dataIndex: 'stsfRecord'}
	],
	stripeRows : true,
	 columnLines: true,
	 enableHdMenu:false,
	 enableColumnResize: false,
	 enableColumnMove: false, 
    viewConfig:{forceFit:true,scrollOffset:0 },
	listeners: {
	  rowClick :function(grid,a,b){
		  var record = grid.store.getAt(a);
		  selectedRowIndexStop=a;
		  field=record.get('stfieldName');
		  comOperator=record.get('stoperator');
		  logOperator=record.get('stlogicalOperator');
		  value=record.get('stvalue');
		  value=record.get('stvalue');
		  populateValuesOnRowClick([value,comOperator,logOperator],[getStopStatusEle(),'updateStop_id','addStop_id'],[stopOpComboBx,stoplogOpComboBx]);		  
		  enableStopRemoveBtn();
                  }
              }        
      });
}
function addRecordToStartClockGrid(){
   var operator = startOpComboBx.getValue();
	if(operator == null || operator == '' || operator == 'undefined'){
	 showExtMsg(ServiceTargetPage.Labels.SelectCmpOpMsg);
	 return;
	}
	var statusVal= getStartStatusEle().value;
	
	if(statusVal == null || statusVal == '' || statusVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.EnterValMsg);
	  return;
  }
  var logicalOpVal=startlogOpComboBx.getValue();
  if(logicalOpVal == null || logicalOpVal == '' || logicalOpVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.SelectLogOpMsg);
	  return;
  }
  var record = Ext.getCmp('startClockGridId').store;
  var rowCount=record.data.length;
  
  listDataForStartClockGrid[rowCount] = new Array(6);
  listDataForStartClockGrid[rowCount][0]= rowCount+1;
  listDataForStartClockGrid[rowCount][1]= getStartStatusLabelEle().value;
  listDataForStartClockGrid[rowCount][2]=startOpComboBx.getValue();
  listDataForStartClockGrid[rowCount][3]=getStartStatusEle().value;
  listDataForStartClockGrid[rowCount][4]=startlogOpComboBx.getValue();
  listDataForStartClockGrid[rowCount][5]=null;
  loadDatatoStartClockStore();
  setDefaultValueToStartClockFields();
}
function addRecordToPauseClockGrid(){
	var operator = pasueOpComboBx.getValue();
	if(operator == null || operator == '' || operator == 'undefined'){
	 showExtMsg(ServiceTargetPage.Labels.SelectCmpOpMsg);
	 return;
	}
	var statusVal= getPauseStatusEle().value;
	if(statusVal == null || statusVal == '' || statusVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.EnterValMsg);
	  return;
	}
	var logicalOpVal=pauselogOpComboBx.getValue();
  if(logicalOpVal == null || logicalOpVal == '' || logicalOpVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.SelectLogOpMsg);
	  return;
  }
  var record = Ext.getCmp('pauseClockGridId').store;
  var rowCount=record.data.length;
  
  listDataForPasueClockGrid[rowCount] = new Array(6);
  listDataForPasueClockGrid[rowCount][0]= rowCount+1;
  listDataForPasueClockGrid[rowCount][1]= getPauseStatusLabelEle().value;
  listDataForPasueClockGrid[rowCount][2]=pasueOpComboBx.getValue();
  listDataForPasueClockGrid[rowCount][3]=getPauseStatusEle().value;
  listDataForPasueClockGrid[rowCount][4]=pauselogOpComboBx.getValue();
  listDataForPasueClockGrid[rowCount][5]=null;
  loadDatatoPauseClockStore();
 setDefaultValueToPauseClockFields();
}
function addRecordToStopClockGrid(){
   var operator = stopOpComboBx.getValue();
	if(operator == null || operator == '' || operator == 'undefined'){
	 showExtMsg(ServiceTargetPage.Labels.SelectCmpOpMsg);
	 return;
	}
	var statusVal= getStopStatusEle().value;
	if(statusVal == null || statusVal == '' || statusVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.EnterValMsg);
	  return;
  }
  var logicalOpVal=stoplogOpComboBx.getValue();
  if(logicalOpVal == null || logicalOpVal == '' || logicalOpVal == 'undefined') {
	  showExtMsg(ServiceTargetPage.Labels.SelectLogOpMsg);
	  return;
  }
  var record = Ext.getCmp('stopClockGridId').store;
  var rowCount=record.data.length;
 
  listDataForStopClockGrid[rowCount] = new Array(6);
  listDataForStopClockGrid[rowCount][0]= rowCount+1;
  listDataForStopClockGrid[rowCount][1]= getStopStatusLabelEle().value;
  listDataForStopClockGrid[rowCount][2]=stopOpComboBx.getValue();
  listDataForStopClockGrid[rowCount][3]=getStopStatusEle().value;
  listDataForStopClockGrid[rowCount][4]=stoplogOpComboBx.getValue();
  listDataForStopClockGrid[rowCount][5]=null;
  loadDatatoStopClockStore();
  setDefaultValueToStopClockFields();
}
function loadDatatoStartClockStore(){
                startClockStore.removeAll();
                Ext.getCmp('startClockGridId').getView().refresh();
                startClockStore.loadData(listDataForStartClockGrid);
                Ext.getCmp('startClockGridId').getView().refresh();
				disableStartRemoveBtn();
}
                
function loadDatatoPauseClockStore(){
                pauseClockStore.removeAll();
                Ext.getCmp('pauseClockGridId').getView().refresh();
                pauseClockStore.loadData(listDataForPasueClockGrid);
                Ext.getCmp('pauseClockGridId').getView().refresh();
				disablePauseRemoveBtn();
}  
function loadDatatoStopClockStore(){
                stopClockStore.removeAll();
                Ext.getCmp('stopClockGridId').getView().refresh();
                stopClockStore.loadData(listDataForStopClockGrid);
                Ext.getCmp('stopClockGridId').getView().refresh();
			    disableStopRemoveBtn();
}    
function createMOperatorCombo(){
 startOpComboBx=	new Ext.form.ComboBox({
							id:'startOpCombo',
							store: compStore.reference,
							mode: 'local',
							triggerAction: 'all',
							renderTo: 'startOpComboDiv',
							valueField: 'comOpeValue',
							displayField: 'comOpeName',
							editable: false,
	width:75,
	listWidth:92,
							proxy: new Ext.data.MemoryProxy(compStore),
							emptyText:labelOperator
 });   
 pasueOpComboBx=	new Ext.form.ComboBox({
							id:'pauseOpCombo',
							store: compStore.reference,
							mode: 'local',
							triggerAction: 'all',
							renderTo: 'pauseOpComboDiv',
							valueField: 'comOpeValue',
							displayField: 'comOpeName',
							editable: false,
	width:75,
	listWidth:92,
							proxy: new Ext.data.MemoryProxy(compStore),
							emptyText:labelOperator
 });   
 stopOpComboBx=	new Ext.form.ComboBox({
							id:'stopOpCombo',
							store: compStore.reference,
							mode: 'local',
							triggerAction: 'all',
							renderTo: 'stopOpComboDiv',
							valueField: 'comOpeValue',
							displayField: 'comOpeName',
							editable: false,
	width:75,
	listWidth:92,
							proxy: new Ext.data.MemoryProxy(compStore),
							emptyText:labelOperator
 });   
startlogOpComboBx= new Ext.form.ComboBox({
	id:'startlogOpComboBx',
	store: logOpeStore,
	mode: 'local',
	triggerAction: 'all',
	valueField: 'logOpeValue',
	displayField: 'logOpeName',
	selectOnFocus: true,
	renderTo:'startlogOpComboDiv',
	editable: false,
	width:75,
	listWidth:92,
	height:13
	
}); 
startlogOpComboBx.setValue('NONE');

pauselogOpComboBx= new Ext.form.ComboBox({
	id:'pauselogOpComboBx',
	store: logOpeStore,
	mode: 'local',
	triggerAction: 'all',
	valueField: 'logOpeValue',
	displayField: 'logOpeName',
	selectOnFocus: true,
	renderTo:'pauselogOpComboDiv',
	editable: false,
	width:75,
	listWidth:92,
	height:13
	
}); 
pauselogOpComboBx.setValue('NONE');
stoplogOpComboBx= new Ext.form.ComboBox({
	id:'stoplogOpComboBx',
	store: logOpeStore,
	mode: 'local',
	triggerAction: 'all',
	valueField: 'logOpeValue',
	displayField: 'logOpeName',
	selectOnFocus: true,
	renderTo:'stoplogOpComboDiv',
	editable: false,
	width:75,
	listWidth:92,
	height:13
	
}); 
stoplogOpComboBx.setValue('NONE');
 }     
 function showExtMsg(val){
	Ext.MessageBox.show({
		width: 250,
		msg: val,
		buttons: Ext.MessageBox.OK
	});
 }
function openStartStatusLookUp(){
   createMutuallyExclusiveCriteria();
  
	if(moduleName=='Incident__c'){
        openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToIncident__c = true and State__c = true ')+'&mutualExclusionFilter='+mutualExcWhereClause,setStartReferenceToVal,450,600);
       }else if(moduleName=='Change_Request__c'){
	   openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToChange__c = true and State__c = true ')+'&mutualExclusionFilter='+mutualExcWhereClause,setStartReferenceToVal,450,600);
       }else if( moduleName=='Problem__c'){
	    openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToProblem__c = true and State__c = true ')+'&mutualExclusionFilter='+mutualExcWhereClause,setStartReferenceToVal,450,600);
       }
   }
function setStartReferenceToVal(idname){
		if(idname.indexOf(EF) > 0){
			referenceId = idname.split(EF)[0];
			referenceName = idname.split(EF)[1];
		}
		var mStatusEle = getStartStatusEle();
		if(mStatusEle != null && typeof(mStatusEle) != 'undefined'){
			if(typeof(referenceName)!='undefined' && referenceName!=null) {
				referenceName = decodeVal(referenceName);
				mStatusEle.value = referenceName;
			}
			var hiddenIdEle = document.getElementById('startReferenceID'); 
			if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
				hiddenIdEle.value = referenceId;
			}
	}
}
function openPauseStatusLookUp(){
   createMutuallyExclusiveCriteria();
	if(moduleName=='Incident__c'){
        openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToIncident__c = true and State__c = true')+'&mutualExclusionFilter='+mutualExcWhereClause,setPauseReferenceToVal,450,600);
       }else if(moduleName=='Change_Request__c'){
	   openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToChange__c = true and State__c = true')+'&mutualExclusionFilter='+mutualExcWhereClause,setPauseReferenceToVal,450,600);
       }else if( moduleName=='Problem__c'){
	    openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToProblem__c = true and State__c = true' )+'&mutualExclusionFilter='+mutualExcWhereClause,setPauseReferenceToVal,450,600);
       }
   }
function setPauseReferenceToVal(idname){
		if(idname.indexOf(EF) > 0){
			referenceId = idname.split(EF)[0];
			referenceName = idname.split(EF)[1];
		}
		var mStatusEle = getPauseStatusEle();
		if(mStatusEle != null && typeof(mStatusEle) != 'undefined'){
			if(typeof(referenceName)!='undefined' && referenceName!=null) {
				referenceName = decodeVal(referenceName);
				mStatusEle.value = referenceName;
			}
			var hiddenIdEle = document.getElementById('pauseReferenceID'); 
			if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
				hiddenIdEle.value = referenceId;
			}
	}
} 
function openStopStatusLookUp(){
    createMutuallyExclusiveCriteria();
	if(moduleName=='Incident__c'){
        openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToIncident__c = true' )+'&mutualExclusionFilter='+mutualExcWhereClause,setStopReferenceToVal,450,600);
       }else if(moduleName=='Change_Request__c'){
	   openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToChange__c = true')+'&mutualExclusionFilter='+mutualExcWhereClause,setStopReferenceToVal,450,600);
       }else if( moduleName=='Problem__c'){
	    openPopup('SearchPage?popupId=Status__c&isLookup=true&&idNameForPopUp=true&referenceObjectName=Status__c&filterClause='+escape('inactive__c = false and appliesToProblem__c = true')+'&mutualExclusionFilter='+mutualExcWhereClause,setStopReferenceToVal,450,600);
       }
   }
function setStopReferenceToVal(idname){
		if(idname.indexOf(EF) > 0){
			referenceId = idname.split(EF)[0];
			referenceName = idname.split(EF)[1];
		}
		var mStatusEle = getStopStatusEle();
		if(mStatusEle != null && typeof(mStatusEle) != 'undefined'){
			if(typeof(referenceName)!='undefined' && referenceName!=null) {
				referenceName = decodeVal(referenceName);
				mStatusEle.value = referenceName;
			}
			var hiddenIdEle = document.getElementById('stopReferenceID'); 
			if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
				hiddenIdEle.value = referenceId;
			}
	}
} 
function createMutuallyExclusiveCriteria(){
   mutualExcWhereClause='';
   var noOfRowStart =startClockStore.data.length;
   var start_param='';
   var pause_param='';
   var stop_param='';
   for(var i=0;i <= noOfRowStart -1;i++){
    var record = startClockGrid.getStore().getAt(i); 
	var statusVal=record.get('value');
	  start_param +=encodeURIComponent(statusVal)+nonPrint;
   } 
   var noOfRowPause =pauseClockStore.data.length;
   for(var i=0;i <= noOfRowPause-1;i++){
    var record = pauseClockGrid.getStore().getAt(i); 
	var statusVal=record.get('pvalue');
	   pause_param +=encodeURIComponent(statusVal)+nonPrint;
   }     
   var noOfRowStop =stopClockStore.data.length;
   for(var i=0;i <= noOfRowStop-1;i++){
    var record = stopClockGrid.getStore().getAt(i); 
	var statusVal=record.get('stvalue');
	  stop_param +=encodeURIComponent(statusVal)+nonPrint;
   } 
	
  mutualExcWhereClause=start_param+pause_param+stop_param;
  mutualExcWhereClause=mutualExcWhereClause.substring(0,mutualExcWhereClause.length-1);

 return mutualExcWhereClause;
}
function setSupportHoursReferenceToVal(idname){
        if(idname.indexOf(EF) > 0){
            referenceId = idname.split(EF)[0];
            referenceName = idname.split(EF)[1];
        }
        var textboxEle = getSupportHoursEle();
        if(textboxEle != null && typeof(textboxEle) != 'undefined'){
            textboxEle.value = referenceName;
            var hiddenIdEle = getSupportHoursHiddenEle(); 
            if(hiddenIdEle != null && typeof(hiddenIdEle) != 'undefined'){
                hiddenIdEle.value = referenceId;
            }
        } 
}
 
 function setInputDataAndElementsOnRowClick(rowIndex){
	var selectedRec = QualificationGrid.store.getAt(rowIndex);
	var fieldLabel = selectedRec.get('operandFieldLabel');
	var fieldApiName = selectedRec.get('operatorFieldAPIName');
	var fieldValue = selectedRec.get('operandValue');
	var opVal = selectedRec.get('operatorValue');
	var groupOp = selectedRec.get('groupingOperator');
	var fieldType = selectedRec.get('operandFieldType');
	if(fieldApiName != null && fieldApiName != 'undefined'){
		fieldsEditor.setValue(fieldApiName);
		var fieldData = fetchQualificationComboFieldLabel();
		var fType = fieldData.get('type');
		if(fType != null && fType.indexOf(':') > 0){
			var len = 	fType.split(':')[1];
			if(len != null && typeof(len) != 'undefined' && len != ''){
				selectedTextAreaLength = len;
			}
		}
	}
	
	setVisibilityData(fieldApiName, fieldLabel, fieldType, fieldValue, opVal, groupOp);
}

function setComparisonOperatorStore(fieldType){
	if(fieldType.indexOf(':') > 0){
		fieldType = fieldType.split(':')[0];
	}else if(fieldType.indexOf(EF) > 0){
		fieldType = fieldType.split(EF)[0];
	}
	if(fieldType == 'reference'){
		comparisonOperator.store.loadData(compStore.reference);
	}else if(fieldType == 'datetime'){
		comparisonOperator.store.loadData(compStore.dateTime);
	}else if(fieldType == 'date'){
		comparisonOperator.store.loadData(compStore.dateTime);
	}else if(fieldType == 'textarea'){
		comparisonOperator.store.loadData(compStore.textArea);	
	}else if(fieldType == 'text'){
		comparisonOperator.store.loadData(compStore.text);
	}else if(fieldType == 'phone'){
		comparisonOperator.store.loadData(compStore.phone);
	}else if(fieldType == 'currency'){
		comparisonOperator.store.loadData(compStore.currency);
	}else if(fieldType == 'percent'){
		comparisonOperator.store.loadData(compStore.percent);
	}else if(fieldType == 'number'){
		comparisonOperator.store.loadData(compStore.number);
	}else if(fieldType == 'boolean'){
		comparisonOperator.store.loadData(compStore.booleanVar);
	}else if(fieldType == 'email'){
		comparisonOperator.store.loadData(compStore.email);
	}else if(fieldType == 'picklist'){
		comparisonOperator.store.loadData(compStore.picklist);
	}
	comparisonOperator.reset();
}
function getUpdateBtnEle(){
	return document.getElementById('updateButtonId');
}
function getAddBtnEle(){
	return document.getElementById('addButtonId');
}
function reomveRecordFromStartClockGrid(){
     var selectedRecord =  startClockGrid.getSelectionModel().getSelected();
     listDataForStartClockGrid.splice(selectedRowIndexStart ,1);
     startClockGrid.store.remove(selectedRecord);
     var rowCount=startClockStore.data.length;
     for(var i =0; i < rowCount; i++){
        var gridRecord = selectedRecord.store.getAt(i);
        gridRecord.set('condition',i+1);
        listDataForStartClockGrid[i][0]= i+1;
        gridRecord.commit();
     }
	 disableStartRemoveBtn();
	 setDefaultValueToStartClockFields();
	 document.getElementById('updateStart_id').style.display='none';
	 document.getElementById('addStart_id').style.display='inline';
}
function reomveRecordFromPauseClockGrid(){
     var selectedRecord =  pauseClockGrid.getSelectionModel().getSelected();
     listDataForPasueClockGrid.splice(selectedRowIndexPause ,1);
     pauseClockGrid.store.remove(selectedRecord);
     var rowCount=pauseClockStore.data.length;
     for(var i =0; i < rowCount; i++){
        var gridRecord = selectedRecord.store.getAt(i);
        gridRecord.set('condition',i+1);
        listDataForPasueClockGrid[i][0]= i+1;
        gridRecord.commit();
     }
	 disablePauseRemoveBtn();
	 setDefaultValueToPauseClockFields();
	  document.getElementById('updatePause_id').style.display='none';
	  document.getElementById('addPause_id').style.display='inline';
 }
   function reomveRecordFromStopClockGrid(){
     var selectedRecord =  stopClockGrid.getSelectionModel().getSelected();
     listDataForStopClockGrid.splice(selectedRowIndexStop ,1);
     stopClockGrid.store.remove(selectedRecord);
     var rowCount=stopClockStore.data.length;
     for(var i =0; i < rowCount; i++){
        var gridRecord = selectedRecord.store.getAt(i);
        gridRecord.set('condition',i+1);
        listDataForStopClockGrid[i][0]= i+1;
        gridRecord.commit();
     }
   disableStopRemoveBtn();
   setDefaultValueToStopClockFields();
   document.getElementById('updateStop_id').style.display='none';
   document.getElementById('addStop_id').style.display='inline';
 }
function hideStopClockPanel(){
       var targetTypeVal=getTargetTypeEle().value;
		var stopClockPanelBar=getStopClockPanelBarEle();
		if(targetTypeVal =='ResponseTime'){
		  stopClockPanelBar.style.display='none';
		}else{
		  stopClockPanelBar.style.display='block';
		}
}
function disableStartRemoveBtn(){
 document.getElementById('removeStart_id').disabled=true;
 document.getElementById('removeStart_id').src=getSDFStylesResPath()+'/SDEFbuttons/b_remove_disabled.png';
}
function disablePauseRemoveBtn(){
 document.getElementById('removePause_id').disabled=true;
 document.getElementById('removePause_id').src=getSDFStylesResPath() + '/SDEFbuttons/b_remove_disabled.png';
}
function disableStopRemoveBtn(){
  document.getElementById('removeStop_id').disabled=true;
  document.getElementById('removeStop_id').src=getSDFStylesResPath() + '/SDEFbuttons/b_remove_disabled.png';
}
function enableStartRemoveBtn(){
 document.getElementById('removeStart_id').disabled=false;
 document.getElementById('removeStart_id').src=getSDFStylesResPath() + '/SDEFbuttons/b_remove.png';
}
function enablePauseRemoveBtn(){
 document.getElementById('removePause_id').disabled=false;
 document.getElementById('removePause_id').src=getSDFStylesResPath() + '/SDEFbuttons/b_remove.png';

}
function enableStopRemoveBtn(){
  document.getElementById('removeStop_id').disabled=false;
  document.getElementById('removeStop_id').src=getSDFStylesResPath() + '/SDEFbuttons/b_remove.png';
 
}

function upadateSLTQData(){
	var selectedRec =  QualificationGrid.getSelectionModel().getSelected();
	addUpdateSLTQData(selectedRec);		
	setAddUpdateOnClick(null);
	QualificationGrid.getSelectionModel().clearSelections();
	clearQualificationCriteria();	
}
function  resetSLTForm(){
     daysSpinner.setValue(targetInDays);
     hoursSpinner.setValue(targetInHours);
     minutesSpinner.setValue(targetInMinutes);
     businessDaysSpinner.setValue(targetInBusinessDays);
	 EnablingAndDisablingButtons();
	 initTargetFields();
	 setDefaultValueToStartClockFields();
	 setDefaultValueToStopClockFields();
	 setDefaultValueToPauseClockFields();
	 loadDataToGrids();
	 hideStopClockPanel();
 }
function validateData(val){
    var errorFlag = false;
    if(compTypeNo != 0){
	  
	if(compTypeNo == 7){
		if(isNaN(val)){
			errorFlag = true;
			Ext.MessageBox.show({
				width: 250,
				msg: 'Invalid Number : '+val,
				buttons: Ext.MessageBox.OK
			});
		}
	}
	else if(compTypeNo == 8){
		var emailRegEx = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		if(!val.match(emailRegEx)){
			errorFlag = true;
			Ext.MessageBox.show({
				width: 250,
				msg: 'Invalid Email address : '+val,
				buttons: Ext.MessageBox.OK
			});
		}
	}else if(compTypeNo == 9){
		if (isNaN(val) || val < 0 || val > 100) {
			errorFlag = true;
			Ext.MessageBox.show({
				width: 250,
				msg: 'Invalid Percent : '+val,
				buttons: Ext.MessageBox.OK
			});
		}
	}else if(compTypeNo == 11){
		var currencyRegEx = /^-?\d+(\.\d+)?$/;
		if(!val.match(currencyRegEx)){
			errorFlag = true;
			Ext.MessageBox.show({
				width: 250,
				msg: 'Invalid Currency :  '+val,
				buttons: Ext.MessageBox.OK
			});
		}
	}else if(compTypeNo == 10){
		var phoneRegEx = /^[-]?\d*?\d*$/;
		if(!val.match(phoneRegEx)){
			errorFlag = true;
			Ext.MessageBox.show({
				width: 250,
				msg: 'Invalid Phone : '+val,
				buttons: Ext.MessageBox.OK
			});
		}
	}
	}
	return errorFlag;
}
function gridHasDupesNONE(grid) {  
    var store = grid.store;
	var gridId=grid.id;                       
	var i, j, n;
	n=store.data.length;   
	for (i=0; i<n; i++) {                       
		for (j=i+1; j<n; j++) { 
            var recordI = store.getAt(i);	
            var recordJ = store.getAt(j);	
		    if(grid.id== 'startClockGridId'){
				  if (recordI.get('logicalOperator')==recordJ.get('logicalOperator') && recordI.get('logicalOperator')== 'NONE') return true;
			}else if(grid.id== 'pauseClockGridId'){
				  if (recordI.get('plogicalOperator')==recordJ.get('plogicalOperator') && recordI.get('plogicalOperator')== 'NONE') return true;
			}else if(grid.id== 'stopClockGridId'){
				  if (recordI.get('stlogicalOperator')==recordJ.get('stlogicalOperator') && recordI.get('stlogicalOperator')== 'NONE') return true;
			}else if(grid.id== 'qualificationCriteriaGrid'){
				  if (recordI.get('groupingOperator')==recordJ.get('groupingOperator') && recordI.get('groupingOperator')== 'NONE') return true;
			}		
					
		}	
			
	}
	return false;
}
function validateCriteria(){
    
    var stopClockPanelBar=getStopClockPanelBarEle();
	if(getServiceTitleEle().value=='' || getServiceTitleEle().value==null){
	 showExtMsg(ServiceTargetPage.Labels.serviceTargetTitleEmpty);
		return true;
	}
	if(daysSpinner.getValue()<=0 && hoursSpinner.getValue()<=0 && minutesSpinner.getValue()<=0 && businessDaysSpinner.getValue()<=0 && businessDaysSpinner.getValue()<=0){
		showExtMsg(ServiceTargetPage.Labels.TargetEmpty);
		return true;
	}
	if(gridHasDupesNONE(QualificationGrid)){
		showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForQual);
		return true;
	}else if(gridHasDupesNONE(startClockGrid)){
		showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
		return true;
	}else if(gridHasDupesNONE(stopClockGrid) && stopClockPanelBar.style.display !='none'){
		showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
		return true;
	}else if(gridHasDupesNONE(pauseClockGrid)){
	  showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
		return true;
	}
	if(startClockStore.data.length == 0){
	showExtMsg(ServiceTargetPage.Labels.ValidateMandatoryMeasurements);
	return true;
	}
	if(stopClockStore.data.length == 0 && stopClockPanelBar.style.display !='none'){
	 showExtMsg(ServiceTargetPage.Labels.ValidateMandatoryMeasurements);
	 return true;
	}
	var qualiLastRowRecord = QualificationGrid.getStore().getAt(qualificationGridStore.data.length-1);
	if(qualiLastRowRecord != null && qualiLastRowRecord != '' && typeof(qualiLastRowRecord) != 'undefined'){
    var qualiLogOpValue=qualiLastRowRecord.get('groupingOperator');
	if(qualiLogOpValue != 'NONE'){
	  showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForQual);
	   return true;
	}
	}
    var startLastRowRecord = startClockGrid.getStore().getAt(startClockStore.data.length-1);
	if(startLastRowRecord != null && startLastRowRecord != '' && typeof(startLastRowRecord) != 'undefined'){
    var startLogOpValue=startLastRowRecord.get('logicalOperator');
	if( startLogOpValue != 'NONE'){
	showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
	 return true;
	}
	}
	var stopLastRowRecord = stopClockGrid.getStore().getAt(stopClockStore.data.length-1);
	if(stopLastRowRecord != null && stopLastRowRecord != '' && typeof(stopLastRowRecord) != 'undefined'){
	var stopLogOpValue=stopLastRowRecord.get('stlogicalOperator');
	if(stopLogOpValue != 'NONE' && stopClockPanelBar.style.display !='none'){
	showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
	   return true;
	}
	}
	var pauseLastRowRecord = pauseClockGrid.getStore().getAt(pauseClockStore.data.length-1);
	if(pauseLastRowRecord != null && pauseLastRowRecord != '' && typeof(pauseLastRowRecord) != 'undefined'){
    var pauseLogOpValue=pauseLastRowRecord.get('plogicalOperator');
	if(pauseLogOpValue != 'NONE'){
	  showExtMsg(ServiceTargetPage.Labels.ValidateLogicalOperatorForMeasurement);
	   return true;
	}
	}
	
	return false;
}
function loadDataToGrids(){
	 qualificationGridStore.loadData(listData);
	 qualificationOrderIndex = listData.length + 1;
    if(arrayOfSTCBeanForStartClock != null && arrayOfSTCBeanForStartClock.size() > 0)
	{
		listDataForStartClockGrid = arrayOfSTCBeanForStartClock;
		loadDatatoStartClockStore();
	}
	if(arrayOfSTCBeanForStopClock != null && arrayOfSTCBeanForStopClock.size() > 0)
	{
		listDataForStopClockGrid = arrayOfSTCBeanForStopClock;
		loadDatatoStopClockStore();
	}
	if(arrayOfSTCBeanForPauseClock != null)
	{
		listDataForPasueClockGrid = arrayOfSTCBeanForPauseClock;
		loadDatatoPauseClockStore();
	}
}
function updateRecordOfStartClockGrid(){
	 listDataForStartClockGrid[selectedRowIndexStart][0]= selectedRowIndexStart+1;
	 listDataForStartClockGrid[selectedRowIndexStart][1]= getStartStatusLabelEle().value;
	 listDataForStartClockGrid[selectedRowIndexStart][2]=startOpComboBx.getValue();
	 listDataForStartClockGrid[selectedRowIndexStart][3]=getStartStatusEle().value;
	 listDataForStartClockGrid[selectedRowIndexStart][4]=startlogOpComboBx.getValue();
	 listDataForStartClockGrid[selectedRowIndexStart][5]=startClockStore.getAt(selectedRowIndexStart).get('sfRecord')
	 loadDatatoStartClockStore();
	 setDefaultValueToStartClockFields();
	 document.getElementById('updateStart_id').style.display='none';
	 document.getElementById('addStart_id').style.display='inline';
	 
}
function updateRecordOfPauseClockGrid(){
      listDataForPasueClockGrid[selectedRowIndexPause][0]= selectedRowIndexPause+1;
	  listDataForPasueClockGrid[selectedRowIndexPause][1]= getPauseStatusLabelEle().value;
	  listDataForPasueClockGrid[selectedRowIndexPause][2]=pasueOpComboBx.getValue();
	  listDataForPasueClockGrid[selectedRowIndexPause][3]=getPauseStatusEle().value;
	  listDataForPasueClockGrid[selectedRowIndexPause][4]=pauselogOpComboBx.getValue();
	  listDataForPasueClockGrid[selectedRowIndexPause][5]=pauseClockStore.getAt(selectedRowIndexPause).get('psfRecord');
	  loadDatatoPauseClockStore();
	  setDefaultValueToPauseClockFields();
	  document.getElementById('updatePause_id').style.display='none';
	  document.getElementById('addPause_id').style.display='inline';

 }
function updateRecordOfStopClockGrid(){
      var selectedRecord =  stopClockGrid.getSelectionModel().getSelected();
	  listDataForStopClockGrid[selectedRowIndexStop][0]= selectedRowIndexStop+1;
	  listDataForStopClockGrid[selectedRowIndexStop][1]= getStopStatusLabelEle().value;
	  listDataForStopClockGrid[selectedRowIndexStop][2]=stopOpComboBx.getValue();
	  listDataForStopClockGrid[selectedRowIndexStop][3]=getStopStatusEle().value;
	  listDataForStopClockGrid[selectedRowIndexStop][4]=stoplogOpComboBx.getValue();
	  listDataForStopClockGrid[selectedRowIndexStop][5]=stopClockStore.getAt(selectedRowIndexStop).get('stsfRecord');
	  loadDatatoStopClockStore();
	  setDefaultValueToStopClockFields();
	  document.getElementById('updateStop_id').style.display='none';
	  document.getElementById('addStop_id').style.display='inline';
 }
 function populateValuesOnRowClick(gridRecordArray,fieldObjArray,comboBoxObjArray){
  if(gridRecordArray !=null && typeof(gridRecordArray)!='undefined' && fieldObjArray !=null && typeof(fieldObjArray)!='undefined'){
   fieldObjArray[0].value=gridRecordArray[0];
   document.getElementById(fieldObjArray[1]).style.display='inline';
   document.getElementById(fieldObjArray[2]).style.display='none';
  }
  if(comboBoxObjArray !=null && typeof(comboBoxObjArray)!='undefined'){
   comboBoxObjArray[0].setValue(gridRecordArray[1]);
   comboBoxObjArray[1].setValue(gridRecordArray[2]);
  }
 }
 function RefreshGrid(){
  startClockGrid.getView().refresh();
  stopClockGrid.getView().refresh();
  pauseClockGrid.getView().refresh();
 }
 
function toggleAdvanceExpression(divHideAsClickedOn,divShowAsToggled){
		document.getElementById(divHideAsClickedOn).style.display = 'none';
		document.getElementById(divShowAsToggled).style.display = 'block';
}
function populateTextArea(gridData,textAreaID){
	var store = gridData;
	var textAreaObj = document.getElementById(textAreaID);
	
	var inFixExpression = ''; 
	
	for(i=0;i<store.data.length;i++)
	{
		var record = store.getAt(i);
		inFixExpression = inFixExpression + record.get('orderIndex') + ' ' +record.get('groupingOperator') + ' '; 
	}
	textAreaObj.value = inFixExpression;
}
function validateInput(evt){
	 var charCode = (evt.which) ? evt.which : evt.keyCode;
	 if (charCode <= 41 && charCode >= 35)
		return true;

	 return false;
}
function populateAdvExpTextArea(grid,textAreaID){
    var store = grid.store;
	var textAreaObj = document.getElementById(textAreaID);
	var inFixExpression = ''; 
	var gridId=grid.id;
	for(i=0;i<store.data.length;i++)
	{
		var record = store.getAt(i);
		if(grid.id== 'startClockGridId'){
		  inFixExpression = inFixExpression + record.get('condition') + ' ' +record.get('logicalOperator') + ' '; 
		}else if(grid.id== 'pauseClockGridId'){
		  inFixExpression = inFixExpression + record.get('pcondition') + ' ' +record.get('plogicalOperator') + ' '; 
		}else if(grid.id== 'stopClockGridId'){
		  inFixExpression = inFixExpression + record.get('stcondition') + ' ' +record.get('stlogicalOperator') + ' '; 
		}
		
	}
   
	textAreaObj.value = inFixExpression;
}
function ConfrimDeleteMilestone()
	{
	 if(!Ext.getCmp('btnRemove').disabled){
	 Ext.MessageBox.confirm(ServiceTargetPage.Labels.labelDelete,ServiceTargetPage.Labels.labelDeleteMilestone,function(btn){
		if(btn === 'yes'){deleteMilestonefromStore();} 
	});
	}
	}
function ConfrimDeleteAction()
	{
	 if(!Ext.getCmp('btnRemoveAct').disabled){	 
	 var deleteMessage='';
	 if(selectedRowAction.length==1){
	   deleteMessage=ServiceTargetPage.Labels.labelDeleteAction ;
	   } else {deleteMessage=ServiceTargetPage.Labels.labelDeleteActions ;}
		 Ext.MessageBox.confirm(ServiceTargetPage.Labels.labelDelete,deleteMessage,function(btn){
			if(btn === 'yes'){deleteActionfromStore();} 
		});
	 }
	}
function deleteMilestonefromStore(){
		/*
		 1. remove element from store.
		 2. refresh view of grid.
		 3. call to action function
		 4. handle title change and select some other record
		 5. refresh the Action  
	
		*/
  
		milestoneGrid.store.remove(selectedRowMilestone);
		milestoneGrid.getView().refresh(); 
		actionGrid.store.removeAll();
		actionGrid.getView().refresh(); 
		delMilestone();
		milestoneGrid.getSelectionModel().selectFirstRow();		
	   if(milestonetore.data.length<=0){		    /*
			if there are no milestone disable EDIT and DELETE button
			*/			
			Ext.getCmp('btnRemove').setDisabled(true);
			Ext.getCmp('btnRemove').setIconClass('bmcDeleteSLTDisable');		
			
			Ext.getCmp('btnEdit').setDisabled(true);
			Ext.getCmp('btnEdit').setIconClass('bmcEditSLTDisable');			
		}

}
function deleteActionfromStore(){
		/*
		 1. remove elements from store.
		 2. refresh view of grid.
		 3. call to action function
		*/
        for(i=0;i<selectedRowAction.length;i++){
		 actionGrid.store.remove(selectedRowAction[i]);					
		}
		actionGrid.getView().refresh(); 
		delAction();

}
function ChangeActionLabel(){   
   if(milestonetore.getCount()==0){   
    getActionLabel().innerHTML=ServiceTargetPage.Labels.labelAction+' : ';
   }   
}
function validateQAdvExpression(){
	var applySTStr = '';
	var count = 0;
	while(qualificationGridStore.data.length > count) {
	applySTStr = applySTStr + qualificationGridStore.getAt(count).get('orderIndex') + nonPrint + 
				 qualificationGridStore.getAt(count).get('operatorFieldAPIName') + nonPrint + 
				 qualificationGridStore.getAt(count).get('operatorValue') + nonPrint +
				 qualificationGridStore.getAt(count).get('operandValue') + nonPrint +
				 qualificationGridStore.getAt(count).get('operandFieldType') + nonPrint +
				 qualificationGridStore.getAt(count).get('groupingOperator') + nonPrint +
				 qualificationGridStore.getAt(count).get('qualId') + PE;
		count++;
	}
	var applySTCondns = getApplySTStrEle();
	applySTCondns.value = applySTStr;
	var advExprBox = getQAdvExprTextArea();
	advExprBox.value = advExprBox.value;
	validateAdvExpression('0');
}
function resetQAdvExpression(){
	populateTextArea(QualificationGrid.store, getQAdvExprTextArea().id);
}
function milestoneInvalidated(){

		if(errorFlag==true)
			Ext.Msg.alert('',ServiceTargetPage.Labels.milestoneInvalidated,function(){DisplayAfterSaveMessage(); });
		else
			DisplayAfterSaveMessage();
			
}
function DisplayAfterSaveMessage(){
	  Ext.getCmp('saveId').setDisabled(false);	
	  if(errormsg==ServiceTargetPage.Labels.labelSavedSuccessfully ){
	   getAppliesToEle().disabled =true;
	   Ext.getCmp('resetId').setDisabled(false);
		if(!isUpdateble && sltId != null && sltId != '' ){
			Ext.getCmp('saveId').setDisabled(true);
		}
	  }
	  updateTitle();
	   showError();
  }
  
  function updateTitle(){
	  var stWindowObj=window.parent.Ext.getCmp('popupWindowId1');
	  var stWindowHeader=Ext.util.Format.ellipsis(ServiceTargetHeader+getServiceTitleValue(), 80)
	  if(stWindowObj!=null && typeof(stWindowObj) !='undefined' && stWindowHeader!='')
	  stWindowObj.setTitle(stWindowHeader);
  }
  function refreshSLTList(){
	window.parent.reloadIframe();
  }
  function validateInputFF(evt){
	 	if(!Ext.isIE){
	 		var charCode = (evt.which) ? evt.which : evt.keyCode;
	 		if (charCode <= 41 && charCode >= 35)
				return true;
		 	return false;
		 }
		 return;
	}
	function validateInputIE(evt){
		if(Ext.isIE){
	 		var charCode = (evt.which) ? evt.which : evt.keyCode;
	 		if ((charCode <= 41 && charCode >= 35) || (charCode == 57 || charCode == 48))
				return true;
	 		return false;
	 	}
	 	return;
   }
 function EnablingAndDisablingButtons(){
     var resetBtn=Ext.getCmp('resetId');
	 var nextBtn=Ext.getCmp('nextId');
	 var prevBtn=Ext.getCmp('prevId');
	 var saveBtn=Ext.getCmp('saveId');
	 if(getSLACopyId() != null && getSLACopyId() != ''){
	     resetBtn.setDisabled(true);
		 nextBtn.setDisabled(true);
	     prevBtn.setDisabled(true);
		 saveBtn.setDisabled(true);
	 }else if(sltId == null || sltId == '' || isCopied==true){
	 getDurationFieldEle().value=getDuration();
		 resetBtn.setDisabled(true);
		 nextBtn.setDisabled(true);
	     prevBtn.setDisabled(true);
		 saveBtn.setDisabled(false);
	 }else{
	   getAppliesToEle().disabled=true;
		Ext.getCmp('st_inactive__c').setValue(getSLTInactive());
		getAppliesToEle().disabled =true;
		resetBtn.setDisabled(false);
        nextBtn.setDisabled(false);
		prevBtn.setDisabled(false);
		saveBtn.setDisabled(false);
	 }
	 if(!isUpdateble && sltId != null && sltId != '' ){
		saveBtn.setDisabled(true);
	 }  
	 isCopied=false;
}

function callInitMilestone(retValue){
	initMilestone();
}
function setDefaultValueToStartClockFields(){
     startOpComboBx.setValue('');
     startlogOpComboBx.setValue('NONE');
     getStartStatusEle().value='';

}

function setDefaultValueToStopClockFields(){
   stopOpComboBx.setValue('');
   stoplogOpComboBx.setValue('NONE');
   getStopStatusEle().value='';

}

function setDefaultValueToPauseClockFields(){
	 pasueOpComboBx.setValue('');
	  pauselogOpComboBx.setValue('NONE');
	  getPauseStatusEle().value='';
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
function enableDisableTargetFields(){
	if (document.getElementById('daysSpinner') && document.getElementById('hoursSpinner') && document.getElementById('minutesSpinner') && document.getElementById('businessDaysSpinner')) {
         isInBusinessDays = document.getElementById('bd-radio').checked ? true : false;
	     if(isInBusinessDays){
	 	    daysSpinner.setValue(0);hoursSpinner.setValue(0);minutesSpinner.setValue(0);
	 	    daysSpinner.setDisabled(true);hoursSpinner.setDisabled(true);minutesSpinner.setDisabled(true);businessDaysSpinner.setDisabled(false);
	 	    document.getElementById('daysSpinner').readOnly=true;
	 	    document.getElementById('hoursSpinner').readOnly=true;
	 	    document.getElementById('minutesSpinner').readOnly=true;
	 	    document.getElementById('businessDaysSpinner').readOnly=false;
	     }else{
	 	    businessDaysSpinner.setValue(0);
     	    daysSpinner.setDisabled(false);hoursSpinner.setDisabled(false);minutesSpinner.setDisabled(false);businessDaysSpinner.setDisabled(true);
     	    document.getElementById('daysSpinner').readOnly=false;
	 	    document.getElementById('hoursSpinner').readOnly=false;
	 	    document.getElementById('minutesSpinner').readOnly=false;
	 	    document.getElementById('businessDaysSpinner').readOnly=true;
	     }
	    getDurationFieldEle().value=getDuration();
    }
}
function initTargetFields(){
	if(getIsBusinessDays()){
		document.getElementById('bd-radio').checked=true;
	}else{
		document.getElementById('dhm-radio').checked=true;
	}
	enableDisableTargetFields();
}
