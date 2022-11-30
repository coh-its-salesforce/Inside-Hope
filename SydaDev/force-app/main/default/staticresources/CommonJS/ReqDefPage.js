var g_loadTime = new Date(),
	startTime = new Date(),
	test = '',
	durationError = 0,
	serverTime = "39",
	networklatencystart = '',
	windowloaddate = '';
var respTypeTxt='text field', respTypeTxtArea='text area',respTypeCheckBox='check box', 
	respTypeRadioBtn='radio button', respTypePicklist='picklist', respTypeNumber='number',
	respTypeDate='date', respTypeDateTime='date/time', respTypeLookup='lookup', 
	respImpact='impact__c',respUrgency='urgency__c',respCategory='category__c';		
var daysSpinner,
	hoursSpinner,
	accLeftStore,
	accRightStore,
	profileLeftStore,
	profileRightStore,
	idset,
	clickedOnce = false;
var isCustomPage=true;
var accLeftStoreData;
var accRightStoreData;
var profileRightStoreData;
var profileLeftStoreData;
//Data for Request Fulfillment
var processGrid, inputGrid, questionGrid, mappingGrid, processVarStore, processVarGrid, processOptions;
var questionStore, mappingStore;
var processDataArray=[], inputDataArray=[]; 
var processDataStore, inputDataStore;
var fulfillmentTabPanel;
var reqDefId;
var fulfillmentWinObj;
var conditionWinObj;	
var NewBtnHandler = function(){ 
	openPage("RequestDefPage",reqDefWindowHeader,reqDefWindowHeader);
}
var SaveBtnHandler = function(){
	var reqdefDescription = null;
	if(getRefDefDescriptionEle() != null && getRefDefDescriptionEle() != ''){
		reqdefDescription = getRefDefDescriptionEle().value;
	var countDescription = reqdefDescription.length;
	if(!Ext.isIE && reqdefDescription != null ){
		if(null != reqdefDescription.match(/[^\n]*\n[^\n]*/gi)){
			countDescription = countDescription + reqdefDescription.match(/[^\n]*\n[^\n]*/gi).length;
		}
	}
	}
	if(countDescription <= 32000){
	var DaysTargetHiddenEle=getDaysTargetHiddenEle(),
    HoursTargetHiddenEle=getHoursTargetHiddenEle();
	
	DaysTargetHiddenEle.value=daysSpinner.getValue();
	HoursTargetHiddenEle.value=hoursSpinner.getValue();
	
	//Assign selected accounts and profiles.
	assignEntitlementValues();
	
	//Data for request fulfillment input order 
	var reqInputOrder = '';
	if(isInputOrderChanged) {
		var store = inputGrid.getStore();
		for(var index = 0; index < store.getCount(); index++) {
			reqInputOrder = reqInputOrder + (reqInputOrder == '' ? '' : ',') + store.getAt(index).data.id; 
		}
		document.getElementById(reqInputOrderCompId).value= reqInputOrder;
		isInputOrderChanged = false;
	} 
	
	var chkBoxValue=Ext.getCmp('Req_inactive__c').getValue();

	save(chkBoxValue); 
	}else{
		if(countDescription > 32000){
            Ext.MessageBox.show({ msg:  Description + ': ' + TextAreaOverflow, width: 300, buttons: Ext.MessageBox.OK});         
        }
	}
}

function assignEntitlementValues() {
	var selectedAccStore = Ext.getCmp('rightAccStore').store;
	
	var count = 0;
	var accounts = '';
	while(selectedAccStore.data.length > count) {
		accounts = accounts + selectedAccStore.getAt(count).get('value')+','
		count++;
	}
	document.getElementById('thePage:ReqDefForm:selectedAccounts').value = accounts;
	
	var selectedProStore = Ext.getCmp('rightProfileStore').store;
	count = 0;
	var profiles = '';
	while(selectedProStore.data.length > count) {
		profiles = profiles + selectedProStore.getAt(count).get('value')+','
		count++;
	}
	document.getElementById('thePage:ReqDefForm:selectedProfiles').value = profiles;

}

function openCategoryPage(returnValues)
{
    if(returnValues != null && returnValues != '')
    {
        if(returnValues[0] != null && returnValues[0] !='' ) 
		{
			var Category__c_id_id=returnValues[3];  
			var Category__c_id_name = returnValues[0];
			setCatData(Category__c_id_id,Category__c_id_name,'');		
        }
		else
		{
			setCatData('','','');
		}    
    }
}     

var CopyBtnHandler = function(){ callCopyPage();}

var DeleteBtnHandler = function(){
	Ext.MessageBox.confirm(labelDelete, labelDeleteConfirm, function(btn){
		if(btn === 'yes'){
			   deleteReqDefObj();
		}
	});
}

var ResetBtnHandler  = function(){resetReqDefObj();}

//Reset process variable list on change of process option
var selectedOption = '';
var resetProcessVariables = function(combo, value, index) {
     var newOption = combo.getValue();
     if(newOption != selectedOption) {
         selectedOption = newOption;                 
         updateProcessVarAction(newOption);
         waitbox(0); 
     }
}	
function updateProcessOptions() {
 if(typeof(deletedProcessId) != 'undefined' && 
	deletedProcessId != null && deletedProcessId != '')  {
	if(deletedProcessId == selectedOption) {
		resetProcessOption();
		if(processVarStore != null && typeof(processVarStore) != 'undefined'){
			processVarStore.removeAll();
		}
	}
 }
}
function PreviousBtnHandler(){
	if (window.parent.changeArray[getWID()] != null && typeof(window.parent.changeArray[getWID()]) != 'undefined' && window.parent.changeArray[getWID()] != -1 ){				
		checkLoseChanges(previousReqDefBtnHandler);				
	} else {  
			if(document.getElementById('prevId').disabled != true) 
		        previousReqDefBtnHandler();
	}
	
}
	
function NextBtnHandler(){
	if (window.parent.changeArray[getWID()] != null && typeof(window.parent.changeArray[getWID()]) != 'undefined' && window.parent.changeArray[getWID()] != -1 ){				
		checkLoseChanges(nextReqDefBtnHandler);				
	} else {
			if(document.getElementById('nextId').disabled!=true) 
		        nextReqDefBtnHandler();	
	}
}
function previousReqDefBtnHandler(){
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
   previousReqDef(idSetString);
}
function nextReqDefBtnHandler(){
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
   nextReqDef(idSetString);
}

function checkIDSet(){
	if(idset == null || idset == ''){
		if(getIsDirect() == ''){
			if(typeof(window.parent.returnListOfId)=='function')
				idset = window.parent.returnListOfId();
		}else{
			if(typeof(window.parent.parent.getIdArray)=='function')
				idset =window.parent.parent.getIdArray();
				window.parent.handleSave(getWID(),getID());
		}
	}
}
//Update input data store after adding new input from Input Detail Popup
function updateInputList(recid) {
    waitbox(0); 
	updateInputDataAction();
}

//Request Fulfillment Functions
var delInputBtnHandler = function() {
	var inputId = inputGrid.getSelectionModel().getSelected().data.id
	if(inputId != null && inputId != '') {
		Ext.MessageBox.confirm(labelDelete,labelInputDeleteConfirmMsg,function(btn){
			if(btn === 'yes'){removeRequestInputAction(inputId);waitbox(0);} 
	   });
    }

}


var addInputBtnHandler = function (){
	openPopupWithTitle('FulfillmentInputDetailPage?requestId='+reDefId+'&isInputCreateable='+isInputCreateable,updateInputList,fulfillmentInputWindowHeader,Ext.isIE7 ? 505:492,Ext.isIE7 ?620:630,false);
	fulfillmentWinObj=popUpWindow;
 
}
var editInputBtnHandler = function (){
	var record = inputGrid.getSelectionModel().getSelected();
	if(record) {
		var inputId = record.data.id;
		openPopupWithTitle('FulfillmentInputDetailPage?Id='+inputId+'&isInputUpdateable='+isInputUpdateable,updateInputList,fulfillmentInputWindowHeader,Ext.isIE7 ? 505:492,Ext.isIE7 ?620:630,false);
		fulfillmentWinObj=popUpWindow;
	}	 
}

function closeFulfillmentPopup(){
	fulfillmentWinObj.close();
}
function closeConditionPopup(){
	conditionWinObj.close();
}
/*
	Add new process/template button handler, opens template list view and 
	creates a process template record on selection of a template
*/
var newProcessBtnHandler = function (button, event){
								var templateBtn = Ext.getCmp('newTemplateBtn');
								if(templateBtn.disabled == false){
									openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+processFilterClause,addProcessTemplateAction,500,625);
								} 
						   };
var delProcesBtnHandler = function(button, event) {
	var processId = processGrid.getSelectionModel().getSelected().data.id;
	if(processId != null && processId != '') {
		    Ext.MessageBox.confirm(labelDelete,labelProcessDeleteConfirmMsg,function(btn){
				if(btn === 'yes'){
					removeProcessAction(processId);
					waitbox(0);
					Ext.getCmp('delTemplateBtn').setDisabled(true);
					Ext.getCmp('delTemplateBtn').setIconClass('bmcDeleteSLTDisable');  
					 if(processOptions != null && typeof(processOptions) != 'undefined'){
						if(processId == selectedOption) {
							processOptions.clearValue();
							selectedOption = '';
							if(processVarStore != null && typeof(processVarStore) != 'undefined'){
								processVarStore.removeAll();
							}
						}
					}
				} 
		    });
	}
}
/*
	This function is used to reset the selected process option on prev/next call
	in mappings tab 
*/
function resetProcessOption() {
	if(processOptions != null && typeof(processOptions) != 'undefined'){
		processOptions.clearValue();
		selectedOption = '';
	}
	applyFilterOnMappingStore();
}
var deleteInputMapHandler = function() {
	removeInputMappingAction(mappingGrid.getSelectionModel().getSelected().data.id);
	waitbox(0); 
	Ext.getCmp('delMappingBtn').setDisabled(true);
	Ext.getCmp('delMappingBtn').setIconClass('bmcDeleteSLTDisable'); 
}


/*
	Initiate request processes/templates grid
*/
function reloadData() {
}

function setTaskTemplateOrder(){   
            		var height = 400;
            		var width =  420;
	           		if(Ext.isIE7 || Ext.isSafari){
            			 height = 250;
            		}
					if(Ext.isIE7 || Ext.isIE8){
            			width = 420;
            		}
					openPopupWithTitle('ChildTemplateHierarchy?reqDefId='+reDefId, reloadData,taskTemplateExecutionOrder, height, width, false);
            }
function showProcessTable() {

	processDataStore = new Ext.data.ArrayStore({
							data : processDataArray,
							fields : ['id','readOnly','name','description']
					});                 
	var colModel = new Ext.grid.ColumnModel([
												{
													header : 'ID',
													dataIndex : 'id',
													hidden: true 
												},
												{
													header : 'readOnly',
													dataIndex : 'readOnly',
													hidden: true 
												},
												{
													header : labelProcessNameHeader,
													dataIndex : 'name',
													sortable:false,
													width: 200 
												},
												{
													header : labelProcessDescHeader,
													dataIndex : 'description',
													sortable:false,
													width: 250
												}
									]);         
	var gridView = new Ext.grid.GridView({forceFit:true, scrollOffset: 0}); 
	var selModel = new Ext.grid.RowSelectionModel({ 
						singleSelect : true
					})
	var tbar = { 
					items : [
								{
									tooltip : labelAdd,
									id: 'newTemplateBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : (isProcessCreateable == 'true' ? 'bmcNewSLT' : 'bmcNewSLTDisable'),
									handler: newProcessBtnHandler,
									disabled: (isProcessCreateable == 'true' ? false : true)
								},
								{
									tooltip : labelDelete,
									id: 'delTemplateBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : 'bmcDeleteSLTDisable',
									handler: delProcesBtnHandler,
									disabled:true
								},
								{
									tooltip : taskTemplateExecutionOrder,
									id: 'exeOrderBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : 'bmcSetOrder',
									handler: setTaskTemplateOrder,
									disabled: false
								}
						]
				};              
	processGrid = new Ext.grid.GridPanel({
										store : processDataStore, 
										view : gridView,
										columnLines:true,
										stripeRows:true,
										autoScroll: true,
										colModel : colModel,
										enableHdMenu:false,
										selModel : selModel,
										tbar: tbar
							}); 
	
	processGrid.on('rowclick', function(grid, rowIndex, e){
	                var record = processGrid.getStore().getAt(rowIndex);
					if(record) {
						if(record.data.readOnly == 'true' || record.data.readOnly == true) {
							Ext.getCmp('delTemplateBtn').setDisabled(true);
							Ext.getCmp('delTemplateBtn').setIconClass('bmcDeleteSLTDisable');    
						} else {
						    if(isProcessDeleteable == 'true') {
								Ext.getCmp('delTemplateBtn').setDisabled(false);
								Ext.getCmp('delTemplateBtn').setIconClass('bmcDeleteSLT');      
							}
					}
					}
					    
	});
}


/*
	Initiate request inputs grid
*/
function showInputTable() {
					
	inputDataStore = new Ext.data.ArrayStore({
							data : inputDataArray,
							fields : ['id', 'order', 'PromptQuestion', 'Response Type', 'Required', 'Hidden']
					});                 
	var colModel = new Ext.grid.ColumnModel([
												{
													header : 'ID',
													dataIndex : 'id',
													hidden: true
												},
												{
													header : '#',
													dataIndex : 'order',
													sortable:false,
													hidden: true
												},
												{
													header : labelInputPromptHeader,
													dataIndex : 'PromptQuestion',
													sortable:false,
													width: 200 
												},
												{
													header : labelResponseTypeHeader,
													dataIndex : 'Response Type',
													sortable:false,
													width: 200 
												},
												{
													header : labelRequiredHeader,
													dataIndex : 'Required',
													sortable:false,
													width: 100 
												},
												{
													header : labelHiddenHeader,
													dataIndex : 'Hidden',
													sortable:false,
													width: 100 
												}
									]);     
	var gridView = new Ext.grid.GridView({forceFit:true, scrollOffset: 0}); 
	var selModel = new Ext.grid.RowSelectionModel({ 
						singleSelect : true
					})
	var tbar = { 
					items : [
								{
									tooltip : labelAdd,
									id: 'newInputBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : (isInputCreateable == 'true' ? 'bmcNewSLT' : 'bmcNewSLTDisable'),
									handler: addInputBtnHandler,
									disabled:(isInputCreateable == 'true' ? false : true)
								},
								{
									tooltip : labelEdit,
									id: 'editInputBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : 'bmcEditSLTDisable',
									handler: editInputBtnHandler,
									disabled:true
								},
								{
									tooltip : labelDelete,
									id: 'delInputBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : 'bmcDeleteSLTDisable',
									handler: delInputBtnHandler,
									disabled:true
								}
								
						]
				};              
	inputGrid = new Ext.grid.GridPanel({
										store : inputDataStore, 
										view : gridView,
										columnLines:true,
										stripeRows:true,
										autoScroll: true,
										colModel : colModel,
										enableHdMenu:false,
										selModel : selModel,
										renderTo: 'grid',
										tbar: tbar
							}); 
	
	inputGrid.on('rowclick', function(grid, rowIndex, e){
					validateUpDownButtons();
					if(isInputDeleteable == 'true') {
					Ext.getCmp('delInputBtn').setDisabled(false);
					Ext.getCmp('delInputBtn').setIconClass('bmcDeleteSLT');
					}
					Ext.getCmp('editInputBtn').setDisabled(false);
					Ext.getCmp('editInputBtn').setIconClass('bmcEditSLT');              
					
	});

	
	var GridSelectionChanged = function(selectionModel) {
		   var record = selectionModel.getSelected();
		   validateUpDownButtons();
		   if(!record) {
			  Ext.getCmp('delInputBtn').setDisabled(true);
			  Ext.getCmp('delInputBtn').setIconClass('bmcDeleteSLTDisable');
			  Ext.getCmp('editInputBtn').setDisabled(true);
			  Ext.getCmp('editInputBtn').setIconClass('bmcEditSLTDisable');
		   } else {
		   	   if(isInputDeleteable == 'true') {
			      Ext.getCmp('delInputBtn').setDisabled(false);
			      Ext.getCmp('delInputBtn').setIconClass('bmcDeleteSLT');
			   } 
			  Ext.getCmp('editInputBtn').setDisabled(false);
			  Ext.getCmp('editInputBtn').setIconClass('bmcEditSLT');
	}
	}
	inputGrid.getSelectionModel().on('selectionchange', GridSelectionChanged);
	inputGrid.on('rowdblclick', editInputBtnHandler);
}

function validateUpDownButtons() {
	 var record = inputGrid.getSelectionModel().getSelected();
   	 if(record) {
	     /*
	     	Enable Disable up/down arrow for reordering
	     */
	      var store = inputGrid.getStore()
		  var index = store.indexOf(record);
		  var count = store.getCount();
		  if(index > 0 && index < (count-1)) {
		  	document.getElementById('btnUpId').className = 'btnArrowUp';
		  	document.getElementById('btnUpId').disabled = false;
		  	document.getElementById('btnDownId').className = 'btnArrowDown';
		  	document.getElementById('btnDownId').disabled = false;
		  } else if(index == 0) {
		  	document.getElementById('btnUpId').className = 'btnArrowUpDisable';
		  	document.getElementById('btnUpId').disabled = true;
		  	if(index == count-1) {
		  		document.getElementById('btnDownId').className = 'btnArrowDownDisable';
		  		document.getElementById('btnDownId').disabled = true;
		  	} else {
		  		document.getElementById('btnDownId').className = 'btnArrowDown';;
		  		document.getElementById('btnDownId').disabled = false;
		  	}
		  } else if(index == count-1) {
		  	document.getElementById('btnDownId').className = 'btnArrowDownDisable';
		  	document.getElementById('btnDownId').disabled = true;
		  	document.getElementById('btnUpId').className = 'btnArrowUp';;
		  	document.getElementById('btnUpId').disabled = false;
		  }
	} else {
		document.getElementById('btnDownId').className = 'btnArrowDownDisable';
		document.getElementById('btnDownId').disabled = true;
		document.getElementById('btnUpId').className = 'btnArrowUpDisable';
		document.getElementById('btnUpId').disabled = true;
	}
}


function setProcessDataStore(listData){
	if(processDataStore!= null && typeof(processDataStore) != 'undefined'){
		processDataStore.removeAll();
		processDataStore.loadData(listData);
	}
	enableDisableExeOrderBTN();
	
}
function setInputDataStore(listData){
	if(inputDataStore != null && typeof(inputDataStore) != 'undefined'){
		inputDataStore.removeAll();
		inputDataStore.loadData(listData);
	}
}


/*
   Utility method to move selected row up/down
*/
function moveSelectedRow(direction) {
	var record = inputGrid.getSelectionModel().getSelected();
	if (!record) {
		return;
	}
	var store = inputGrid.getStore()
	var index = store.indexOf(record);
	if (direction < 0) {
		index--;                
		if (index < 0) {
			return;
		}
	} else {
		index++;
		if (index >= store.getCount()) {
			return;
		}
	}
	isInputOrderChanged = true;
	var selectedRowIndex = index;
	store.remove(record);
	store.insert(index, record);
	record.data.order = index + 1;
	/*
		update index for all records
	*/
	if(direction < 0) {
		for(var rowIndex = (index +1); rowIndex < store.getCount(); rowIndex++) {
			store.getAt(rowIndex).data.order = (++index) + 1;
		}
	} else {
		for(var rowIndex = (index - 1); rowIndex >= 0; rowIndex--) {
			store.getAt(rowIndex).data.order = (--index) + 1;
		}
	}
	inputGrid.getView().refresh();

	inputGrid.getSelectionModel().selectRow(selectedRowIndex , true);
	
}


/*
	Fulfillment mappings input prompts/question table
*/
function showQuestionTable() {

	questionStore = new Ext.data.ArrayStore({
							data : questionData,
							fields : ['id', 'prompt', 'respType', 'respRefType']
					});                 
	var colModel = new Ext.grid.ColumnModel([
												{
													header : 'ID',
													dataIndex : 'id',
													hidden: true
												},
												{
													header : labelRequestInputHeader,
													dataIndex : 'prompt',
													sortable:false,
													width: 200 
												},{
													header : '',
													dataIndex : 'respType',
													hidden: true
												},{
													header : '',
													dataIndex : 'respRefType',
													hidden: true
												} 
									]);     
	var gridView = new Ext.grid.GridView({forceFit:true, scrollOffset: 0}); 
	var selModel = new Ext.grid.RowSelectionModel({ 
						singleSelect : false
					})
	questionGrid = new Ext.grid.GridPanel({
										store : questionStore, 
										view : gridView,
										columnLines:true,
										stripeRows:true,
										autoScroll: true,
										colModel : colModel,
										enableHdMenu:false,
										selModel : selModel,
										//width: 235,
										//height: 150,
										renderTo: 'reqInputGrid'
							});
							
	questionGrid.getSelectionModel().on('selectionchange', filterOutputField);				
}
/*
	Fulfillment mapping process variable table
*/ 
function showProcessVarTable() {
	processVarStore = new Ext.data.ArrayStore({
							data : processVarData,
							fields : ['id', 'required',  'localname', 'dataType', 'refTo']
					});                 
	var colModel = new Ext.grid.ColumnModel([
												{
													header : 'Id',
													dataIndex : 'id',
													hidden: true 
												},
												{   header : '.',
													dataIndex : 'required',
													width: 40,
													renderer: function(value, metaData, record, rowIndex, colIndex, store) {
															if(value == 'true') {
																return '<img src=\"'+ getSDFStylesResPath() +'\/SDEFicons\/svt-warning.png\"/>';
															} else {
																return '';
															} 
															
													}
												},
												{
													header : labelProcessVariableHeader,
													dataIndex : 'localname',
													width: 200 
												},{
													header : '',
													dataIndex : 'dataType',
													hidden: true 
												},{
													header : '',
													dataIndex : 'refTo',
													hidden: true 
												}
									]);      
	var gridView = new Ext.grid.GridView({forceFit:true, scrollOffset: 0}); 
	var selModel = new Ext.grid.RowSelectionModel({  
						singleSelect : true
					})
					
	processOptions = new Ext.form.ComboBox( {
	                        store:new Ext.data.ArrayStore({
									data : processOptionData,
									fields : ['id','name']
							}),
							//store:processOptionData,
							typeAhead: true,
							mode: 'local',editable: false,
							triggerAction: 'all',
							emptyText:labelNone,
							disabled:false,
							displayField:'name',
							valueField:'id',
							value:selectedOption,
							listWidth : 180,
							width: 180,
							selectOnFocus:true,
							listeners :{select: resetProcessVariables}, 
							id: 'processOptions'
						});

	var tbar = { 
					items : [
							processOptions  
						]
				};  
	
	processVarGrid = new Ext.grid.GridPanel({
										store : processVarStore, 
										view : gridView,
										columnLines:true,
										stripeRows:true,
										autoScroll: true,
										colModel : colModel,
										enableHdMenu:false,
										selModel : selModel,
										style:{
											textAlign:'left'
										},
										//width: 235,
										//height: 150,
										renderTo: 'processVarGrid',
										tbar: tbar
							});
												
}

function setProcessOptionStore(listData) {
	 if(processOptions != null && typeof(processOptions) != 'undefined'){
		var store = processOptions.getStore();
		//processOptions.clearValue();
		store.removeAll();
		store.loadData(listData);
	}
}
function setQuestionDataStore(listData) {
	if(questionStore != null && typeof(questionStore) != 'undefined'){
		questionStore.removeAll();
		questionStore.loadData(listData);
	}
}
/*
	Fulfillment mapping table
*/
function showMappingTable() {
	mappingStore = new Ext.data.ArrayStore({
							data : mappingData,
							fields : ['id', 'promptId', 'processId', 'processVarApiName', 'prompt', 'processVarLabel']
					});                 
	var colModel = new Ext.grid.ColumnModel([
												{
													header : '',
													dataIndex : 'id',
													hidden: true
												},
												{
													header : '',
													dataIndex : 'promptId',
													hidden: true
												},
												{
													header : '',
													dataIndex : 'processId',
													hidden: true
												},
												{
													header : '',
													dataIndex : 'processVarApiName',
													hidden: true
												},
												{
													header : labelRequestInputCaption,
													dataIndex : 'prompt',
													sortable:false,
													width: 200 
												},
												{
													header : labelProcessVariableCaption,
													dataIndex : 'processVarLabel',
													sortable:false,
													width: 200 
												}
									]);     
	var gridView = new Ext.grid.GridView({forceFit:true, scrollOffset: 0}); 
	var selModel = new Ext.grid.RowSelectionModel({ 
						singleSelect : true
					})
	var tbar = { 
					items : [
								{
									tooltip : labelDelete,
									id: 'delMappingBtn',
									tooltipType: 'title', 
									scale: 'medium',
									iconCls : 'bmcDeleteSLTDisable',
									handler: deleteInputMapHandler,
									disabled:true
								}
						]
				};  
	
	mappingGrid = new Ext.grid.GridPanel({
										store : mappingStore, 
										view : gridView,
										columnLines:true,
										stripeRows:true,
										autoScroll: true,
										colModel : colModel,
										enableHdMenu:false,
										selModel : selModel,
										renderTo: 'mappingGrid',
										height: 150,
										tbar: tbar
							});
	mappingGrid.on('rowclick', function(grid, rowIndex, e){
	               if(isMappingDeleteable == 'true') {
					Ext.getCmp('delMappingBtn').setDisabled(false);
					Ext.getCmp('delMappingBtn').setIconClass('bmcDeleteSLT');       		
				   }
	});
}

function setProcessVarDataStore(listData) {
	if(processVarStore != null && typeof(processVarStore) != 'undefined'){
		processVarStore.removeAll();
		processVarStore.loadData(listData);
		filterOutputField();
	}
}

function addFulfillmentMapping() {
	var processVar = processVarGrid.getSelectionModel().getSelected();
	var promptArray = questionGrid.getSelectionModel().getSelections();
	if(!processVar) {
		showMessage(labelSelectProcessVarError);
		return false;
	}
	if(!promptArray || promptArray.length < 1) {
		showMessage(labelSelectInputError);
		return false;
	}
	var promptIds = '';
	
	for(var qIndex = 0; qIndex < promptArray.length;  qIndex++) {
		promptIds = promptIds + (promptIds.length > 0 ? ',' : '') + promptArray[qIndex].data.id;
	}
	addMappingAction(selectedOption, promptIds,  processVar.data.id);
	waitbox(0); 
	
}

function setInputMappingDataStore(listData) {
	if(mappingStore != null && typeof(mappingStore) != 'undefined'){
		mappingStore.removeAll();
		mappingStore.loadData(listData);
		applyFilterOnMappingStore();
	}
}

function applyFilterOnMappingStore() {
	if(mappingStore != null && typeof(mappingStore) != 'undefined'){	
		/*var selectedProcessId = ''
		if(processOptions != null && typeof(processOptions) != 'undefined') {
			selectedProcessId = processOptions.getValue();
		}*/
		mappingStore.filterBy(function(record, id) {
			if(record.get('processId') == selectedOption) { 
				return true
			  } else return false;
			 }
		);
	}
}
/**** function for performance icon data	 ****/
function senddata(){return data;}
/**** function for performance icon data	 ****/
//End of Request Fulfillment Functions
//Start of search and pagination methods
var displayMessageBox = false;
function msgbox(msg, title, icon){
    var msgIcon = Ext.MessageBox.INFO;//Default
    if(title==null) title='';
    if(icon==3){
        msgIcon = Ext.MessageBox.QUESTION;
        if(title=='') title=labelQuestion ;
    }else if(icon==2){
        msgIcon = Ext.MessageBox.WARNING;
        if(title=='') title=labelWarning ;
    }else if(icon==1){
        msgIcon = Ext.MessageBox.ERROR;
        if(title=='') title=labelError ;
    }
    if(title=='') title=labelInfo ;
    Ext.MessageBox.show({
       title: title,
       msg: msg,
       width:300,
       buttons: Ext.MessageBox.OK,
       //fn: clkHandler,
       icon: msgIcon
   });
}
function loadLeftData(){
	Ext.getCmp('accBtnPrevId').setDisabled(getPreFirstBtn());
	Ext.getCmp('accBtnNextId').setDisabled(getNextLastBtn());
	
		tempAccLeftStore = new Ext.data.ArrayStore({
            data: accLeftStoreData,
            fields: ['value','text','display'],
            sortInfo: { 
                field: 'display',
                direction: 'ASC'
            }
		});
	
		accLeftStore.removeAll();
		var totalCount = tempAccLeftStore.getTotalCount();		
		if(totalCount == 0)
		{    						
			if(displayMessageBox == true){
				msgbox(labelNoRecord , '', 2);
				resetSearch();
			}		
		}
		else
		{
			for(var i=0;i<tempAccLeftStore.getTotalCount();i++){
				accLeftStore.add(tempAccLeftStore.getAt(i));				
			}		
		}	
	displayMessageBox = false;	
}
function blurfun() {
	checkforsearch = false;
	if(document.getElementById('txtSrch').value.trim().length == 0)
	{		
		checkforsearch = true;
	}
}

function txtSearch(){ 
	var j;
	var searchstring = document.getElementById('txtSrch').value;
	j=parseInt(searchstring.length-1);
	
	if(searchstring[j] == '*')
	{
		searchstring = searchstring.replace('*','');
		document.getElementById('txtSrch').value = searchstring;
	}
	
	
	searchstring = searchstring.replace('\\','\\\\');
	searchstring = searchstring.replace('\'','');
	document.getElementById('txtSrch').value = searchstring;	
	blurfun();	
	
	if(checkforsearch)
	{    
		if(searchstring==labelSrch){//0=searchstring.length || 
			msgbox(labelMinChar , '', 2);
			return;
		}
		checkforsearch = false;
	}
	else
	{
		if(searchstring==labelSrch){//0=searchstring.length || 
			//msgbox(labelMinChar , '', 2);
			return;
		}
	
	}	
	var rightData = '';
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightAccStore').store;
	while(selectedAccStore.data.length > count) {		
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('value')+'\','
		count++;
	}	
	displayMessageBox = true;
	getSearchAccounts(searchstring,rightData);
	
}
function resetSearch(){
	var searchstring = '';
	var rightData = '';	
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightAccStore').store;
	while(selectedAccStore.data.length > count) {
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('value')+'\','
		count++;
	}
	getSearchAccounts(searchstring,rightData);
	document.getElementById('txtSrch').value = labelSrch;
}
var PrevBtnHandler = function (button,event) { 	
	
	if(document.getElementById('accBtnPrevId').disabled!=true){
		
		var rightData = '';
		var count = 0;
		var selectedAccStore = Ext.getCmp('rightAccStore').store;
		while(selectedAccStore.data.length > count) {
			rightData = rightData + '\''+selectedAccStore.getAt(count).get('value')+'\','
			count++;
		}			
		prevAccounts(rightData);
	} 
}
var NextBtnHandler1 = function (button,event) {  
	
	if(document.getElementById('accBtnNextId').disabled!=true){
		
		var rightData = '';
		var count = 0;
		var selectedAccStore = Ext.getCmp('rightAccStore').store;
		while(selectedAccStore.data.length > count) {
			rightData = rightData + '\''+selectedAccStore.getAt(count).get('value')+'\','
			count++;
		}			
		nextAccounts(rightData);
	} 
}


function refreshAccountsList(){
	var j;
	var searchstring = document.getElementById('txtSrch').value;
	j=parseInt(searchstring.length-1);
	if(searchstring[j] == '*')
	{
		searchstring = searchstring.replace('*','');
		document.getElementById('txtSrch').value = searchstring;
	}
	searchstring = searchstring.replace('\'','');
	searchstring = searchstring.replace('\\','\\\\');
		
	if(2>searchstring.length || searchstring==labelSrch){
		searchstring = '';
	}
	
	var rightData = '';
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightAccStore').store;
	while(selectedAccStore.data.length > count) {
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('value')+'\','
		count++;
	}		
	getSearchAccounts(searchstring,rightData);
}
//End of search and pagination methods


Ext.onReady(function(){
	Ext.QuickTips.init();
	/**** preparing data for performance icon 	 ****/
	windowloaddate = new Date();
            networklatencystart = windowloaddate.getTime();

        
             var networklatency = networklatencystart - etime;
                
             data +=RequestDefPage.Labels.PM_netwokLatency;
             data +=networklatency; 
             data += '<br>';
	/**** preparing data for performance icon 	 ****/		 
	
	var SamplePanel = Ext.extend(Ext.Panel, {
		renderTo: 'btnToolbar',
		defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
	});
	
	new SamplePanel({
		id: 'toolBarId',
		title: '',
		cls: 'toolSpCls',
		bodyStyle: 'border:0px;padding:0px;margin:0px;zoom:0px;',             
		tbar: [{
			scale: 'medium',
			iconCls: 'bmcNew',
			tooltipType : 'title',
			tooltip:labelNew,
			id: 'newId',
			handler: NewBtnHandler
		 
		},' ',{
			scale: 'medium',
			iconCls: 'bmcSave',
			tooltipType : 'title',
			tooltip: labelSave,
			id: 'saveId',
			handler: SaveBtnHandler
		   
		},' ',{
			scale: 'medium',
			iconCls: 'bmcCopy',
			tooltipType : 'title',
			tooltip: labelCopy,
			id: 'copyId',
			handler: CopyBtnHandler
		   
		},' ','-',' ',{
			scale: 'medium',
			iconCls: 'bmcDelete',
			tooltipType : 'title',
			tooltip: labelDelete,
			id: 'deleteId',
			handler: DeleteBtnHandler
		   
		},' ',{
			scale: 'medium',
			iconCls: 'bmcRefreshDasboard',
			tooltipType : 'title',
			tooltip: labelRefresh,
			id: 'resetId',
			handler: ResetBtnHandler
			
		},
		new Ext.Toolbar.Fill(),
		{
			id :'Req_inactive__c',
			xtype  : 'checkbox',
			width  : 93,
			color :'#004376',
			align: 'top',
			checked: isInActive,
			boxLabel: '<span class="checkboxLabelCls">'+labelInactive+'</span>'
		},{
		    xtype : 'box',
		    id: 'prevId', 
		    autoEl: {
				tag: 'img', 
				src: getSDFStylesResPath() +'/SDEFbuttons/b_previous.gif',
				title: labelPreviousRecord
			},
			cls: 'cursorCls',
		    listeners : { render: function(f){f.el.on('click', PreviousBtnHandler);}}
						 
		},{
			xtype : 'box',
			id: 'nextId', 
			autoEl: {
				tag: 'img', 
				src: getSDFStylesResPath() +'/SDEFbuttons/b_next.gif',
				title: labelNextRecord},
				cls: 'cursorSpaceCls',
				listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
		}] 
	});	
	 daysSpinner=new Ext.ux.form.SpinnerField({
                id:'daysSpinner',
                value:targetInDays,
                minValue: 0,
                maxValue: 99,
                width:70,
				maxLength:2,
				allowDecimals: false,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
                renderTo:'days-ct',
			   enableKeyEvents : true,
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
	     hoursSpinner=new Ext.ux.form.SpinnerField({
                id:'hoursSpinner',
                value:targetInHours,
                minValue: 0,
                maxValue: 23,
                width:70,
				maxLength:2,
				allowDecimals: false,
				autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
                renderTo:'hours-ct'   ,
				enableKeyEvents : true,
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
				  				
	//getAccounts();
	accLeftStore = new Ext.data.ArrayStore({
            data:accLeftStoreData,			
            fields: ['value','text','display'],
            sortInfo: {
                field: 'display',
                direction: 'ASC'
            }
    });
    accRightStore = new Ext.data.ArrayStore({
            data: accRightStoreData,
            fields: ['value','text','display']
    });
	
	//getProfiles();
	profileLeftStore = new Ext.data.ArrayStore({
            data: profileLeftStoreData,
            fields: ['value','text'],
            sortInfo: {
                field: 'text',
                direction: 'ASC'
            }
    });
    profileRightStore = new Ext.data.ArrayStore({
            id: 'profileRightStore',
			data: profileRightStoreData,
            fields: ['value','text',]
    });
	var path = getSDFStylesResPath()+'/SDEFbuttons/';
	document.getElementById('ReqDef_EntitlementTab').style.display = 'block';
	var toolBar= new Ext.Toolbar({
        renderTo: 'toolBar',
        cls:'toolSpCls',
		id:'paginationToolbar', 		
		width: 275,
        items: [
                {
                    scale: 'medium',
                    xtype: 'textfield',
                    tooltipType : 'title',
					emptyText:labelSrch ,
					width:150,
                    id:'txtSrch' ,
					listeners: {
						specialkey: function(field, e){
							// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
							// e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
							if (e.getKey() == e.ENTER) {
									txtSearch();
							}
						}
					}
                   
                },'',
				{
					iconCls: 'bmcSearch', 
					tooltip: labelSrch, 
					tooltipType: 'title',
					id:'searchBtn',
					handler: txtSearch										
				},
                {
                    scale: 'medium',
                    iconCls: 'bmcResetOn',
					tooltip: labelReset,
                    tooltipType : 'title',
                    id:'accBtnResetId',
					handler: resetSearch
				
                },'->',
				{
					xtype : 'box',
					id    : 'accBtnPrevId',
					disabled:getPreFirstBtn(),
					autoEl:  {tag: 'img', 
							  src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif') , 
							  title:labelPrevious
							 },
							  
					cls:'cursorCls',
					listeners : { render: function(f){f.el.on('click', PrevBtnHandler);}}
					
								 
				},{
				   
					xtype : 'box',
					id    : 'accBtnNextId', 
					disabled:getNextLastBtn(),
					autoEl:  {tag: 'img', 
							  src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
							  title:labelNext 
							 },
					  cls:'cursorSpaceCls'  ,
					  listeners : { render: function(f){f.el.on('click', NextBtnHandler1)}}
					  
				}
        ]
    });
  
	var accountSelector = new Ext.Panel({
		id: 'accountSelector',
        title: '',
		layout:'fit',				       
        height:'auto',		
		//hidden: false,
		width:577,
		renderTo: 'accountSelectorDiv',		
        border: false,
        cls: 'fontCls',
		mask: true,
        items:[{
            xtype: 'itemselector',
            name: 'accountselector',
            fieldLabel: '',
			drawUpIcon:false,
			drawDownIcon:false,
			drawLeftIcon:true,
			drawRightIcon:true,
			drawTopIcon:false,
			drawBotIcon:false,			
            iconLeft:'b_darrow_L_new.gif',
            iconRight:'b_darrow_R_new.gif',
            imagePath: path,
			listeners: {
				change: function(){                                   
					refreshAccountsList();
				}
            },
            multiselects: [{
                id: 'leftAccStore',				
                width:275,
                height: 140,
                store: accLeftStore,
                displayField: 'display',									
                valueField: 'value',
				multiSelect : true,
                legend:false,
                listeners: {
                            render: function(multi) {
                                 Ext.QuickTips.register({ 
                    				target: this, 
                    				text: AvailableAccounts 
                				  });
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
                              }
                           }
                
            },{
                id: 'rightAccStore',				
                width:275,
				height: 140,
                tooltip: SelectedAccounts,                
                store: accRightStore,
                displayField: 'display',
                valueField: 'value',
				multiSelect : true,
                legend:false,
                listeners: {
                           render: function(multi) {
                                Ext.QuickTips.register({ 
                   				target: this, 
                   				text: SelectedAccounts 
               				  });
                                new Ext.ToolTip({
                                   target: multi.el,
                                   renderTo: document.body,
                                   delegate: 'dl',
                                   trackMouse: true,
                                   anchor: 'right',
                                   listeners: {
                                         beforeshow: function(tip) {
                                             var rec = multi.view.getRecord(tip.triggerElement);
                                             tip.body.dom.innerHTML = rec.get('text');
                                         }
                                     }
                                 });
                             }
                          }
            }]
        }]

        
    });
	callToggleAccountSelector();
	var profileSelector = new Ext.Panel({
		id: 'profileSelector',
        title: '',
		layout:'fit',				       
        height:'auto',
		width:'577',
		renderTo: 'profileSelectorDiv',
        border: false,
        cls: 'fontCls',
		maskDisabled: callToggleProfileSelector(),
        items:[{
            xtype: 'itemselector',
            name: 'profileselector',
            fieldLabel: '',
			drawUpIcon:false,
			drawDownIcon:false,
			drawLeftIcon:true,
			drawRightIcon:true,
			drawTopIcon:false,
			drawBotIcon:false,
            iconLeft:'b_darrow_L_new.gif',
            iconRight:'b_darrow_R_new.gif',
            imagePath: path,
            multiselects: [{
                id: 'leftProfileStore',
                width: 275,
                height: 140,
                store: profileLeftStore,
                displayField: 'text',
                valueField: 'value',
                legend:false,
                listeners: {
                            render: function(multi) {
                                 Ext.QuickTips.register({ 
                    				target: this, 
                    				text: AvailableProfile 
                				  });
                                 new Ext.ToolTip({
                                    target: multi.el,
                                    renderTo: document.body,
                                    delegate: 'dl',
                                    trackMouse: true,
                                    anchor: 'right',
                                    listeners: {
                                          beforeshow: function(tip) {
                                              var rec = multi.view.getRecord(tip.triggerElement);
                                              tip.body.dom.innerHTML =AvailableProfile;
                                          }
                                      }
                                  });
                              }
                           }
                
            },{
                id: 'rightProfileStore',
                width: 275,
                tooltip: SelectedProfile,
                height: 140,
                store: profileRightStore,
                displayField: 'text',
                valueField: 'value',
                legend:false,
                listeners: {
                           render: function(multi) {
                                Ext.QuickTips.register({ 
                   				target: this, 
                   				text: SelectedProfile
               				  });
                                new Ext.ToolTip({
                                   target: multi.el,
                                   renderTo: document.body,
                                   delegate: 'dl',
                                   trackMouse: true,
                                   anchor: 'right',
                                   listeners: {
                                         beforeshow: function(tip) {
                                             var rec = multi.view.getRecord(tip.triggerElement);
                                             tip.body.dom.innerHTML = SelectedProfile;
                                         }
                                     }
                                 });
                             }
                          }
            }]
        }]

        
    });
	callToggleProfileSelector();
	document.getElementById('ReqDef_EntitlementTab').style.display = 'none';
	
	
	//Request Fulfillment Function Calls
	showInputTable();
	showProcessTable();
	showQuestionTable();
	showProcessVarTable();
	questionStore.loadData(questionData);
	setProcessVarDataStore(processVarData);
	//processVarStore.loadData(processVarData);
	showMappingTable();  //Store will be loaded after selection of a process
	
	//Tab Panel on Fulfillment Div
	fulfillmentTabPanel =  new Ext.ux.TabPanel({
		//renderTo: 'ReqDef_FulfillmentTabPanel',
		id:'fulfillmentTabPanel',
		deferredRenderer:false,
		layoutOnTabChange: true,
		tabPosition:'left',  //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs
		textAlign:'right',
		tabWidth: '16%',
		//tabHeight:160,
		activeTab:0,
		items:[{
			id: 'processTab',
			cls: 'tabContainer',
			title: labelProcessTab,
			border:false,
			layout:'fit',
			style: {padding: 0},
			defaults: {border:false},
			items:[processGrid]
		},{
			id: 'inputsTab',
			cls: 'tabContainer', 
			title: labelInputTab,
			border:false,
			layout:'fit',
			contentEl: 'inputListDiv',
			listeners : {
					resize: function(obj, adjWidth, adjHeight, rawWidth, rawHeight ){ 
					  inputGrid.setHeight(adjHeight - 160);	
					  inputGrid.setWidth(adjWidth - 60);
					  inputGrid.doLayout(true, true);	
					}
				}
		},{
			id: 'mappingsTab',
			cls: 'tabContainer',
			title: labelMappingTab,
			border:false,
			layout: 'fit',
			contentEl: 'inputMappingDiv', 
			listeners : {
					resize: function(obj, adjWidth, adjHeight, rawWidth, rawHeight ){ 
					  questionGrid.setHeight(adjHeight - 300);	
					  questionGrid.setWidth((adjWidth/2) - 24);
					  questionGrid.doLayout(true, true);
					  
					  processVarGrid.setHeight(adjHeight - 300);	
					  processVarGrid.setWidth((adjWidth/2) - 24);
					  processVarGrid.doLayout(true, true);
					  
					  mappingGrid.setHeight(adjHeight - 335);	
					  mappingGrid.setWidth(adjWidth - 24);
					  mappingGrid.doLayout(true, true);	
					}
				}
		}]          
	});
	 checkIDSet();
	 handleElemEvent();
	 setProcessData();
	 setInputData();
	 setInputMappingData();
	 
	 if(reDefId != null && reDefId != '' && newTitle != null && newTitle != ''){
     	window.parent.changeTitle(getWID(),newTitle,newTitle);
	 }
	 
	 /*
	 	Button validators for new and edit mode
	 */
	 if(reDefId == null || reDefId == '') {
		 if(isRequestDefCreatable == 'false'){
			 Ext.getCmp('newId').setDisabled(true);
			 Ext.getCmp('saveId').setDisabled(true);
		 }
	 	  Ext.getCmp('deleteId').setDisabled(true);
          Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
			Ext.getCmp('copyId').setDisabled(true);
			Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
			Ext.getCmp('prevId').setDisabled(true);
            Ext.getCmp('nextId').setDisabled(true);
          Ext.getCmp('resetId').setDisabled(true);
		}else{
			if(isRequestDefCreatable == 'false'){
				 Ext.getCmp('newId').setDisabled(true);
				 Ext.getCmp('saveId').setDisabled(true);
				 Ext.getCmp('copyId').setDisabled(true);
				 Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
				 Ext.getCmp('resetId').setDisabled(true);
			 }
			if(isrequestDefUpdateble == 'false'){
				 Ext.getCmp('newId').setDisabled(true);
				 Ext.getCmp('saveId').setDisabled(true);
				 Ext.getCmp('copyId').setDisabled(true);
				 Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
				 Ext.getCmp('resetId').setDisabled(true);
			 }
			if(isRequestDefDeletable == 'false'){
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
			 }
			
		}
/**** preparing data for performance icon 	 ****/
	pageloadstartdate = 0 ;
        pageloadstartdate = new Date() ;
	
        var t1 = pageloadstartdate.getTime();
        var t2 = windowloaddate.getTime();
        //var pagerendertime =(t1 - t2);
 	var pagerendertime =(t1 - renderingstartitme);
      	data += RequestDefPage.Labels.PM_PageLoad;
        data += pagerendertime;	
	/**** end of preparing data for performance icon 	 ****/
	
	
}); //END OF EXT.ONREADY
	function datePickerPosition(event){
		var datePickerObj =  document.getElementById('datePicker');
		
		var topValue = event.clientY+10;
		var cssStr = '#datePicker{ top:'+topValue+'px !important; }';     
		var styleJS = document.getElementById('styles_js');		
		if(styleJS != null){
			styleJS.nodeValue = "";
		}
		var style = document.createElement("style");
		style.setAttribute("type", "text/css");
		style.setAttribute("id", "styles_js");		
		if(Ext.isIE){// IE
			if(styleJS != null){
				styleJS.styleSheet.cssText = '';
				styleJS.styleSheet.cssText = cssStr;
			} else {
				document.getElementsByTagName('head')[0].appendChild(style);
				style.styleSheet.cssText = cssStr;			
			}				
		} else {// w3c
			document.getElementsByTagName('head')[0].appendChild(style);
			var cssText = document.createTextNode(cssStr);
			style.appendChild(cssText);
		}    
		
	}	
function displayActiveTab(btnObj){
	var btnArray = new Array(4);
	btnArray[0]={btnId:'ReqDef_GeneralInfo', textAreaCompId:'ReqDef_GeneralInfoTab', textLabel:'General Information'};
	btnArray[1]={btnId:'ReqDef_Fulfillment', textAreaCompId:'ReqDef_FulfillmentTab', textLabel:'Fulfillment'};
	btnArray[2]={btnId:'ReqDef_Entitlement', textAreaCompId:'ReqDef_EntitlementTab', textLabel:'Entitlement'};
	btnArray[3]={btnId:'ReqDef_Options', textAreaCompId:'ReqDef_OptionsTab', textLabel:LabelOptions};
	
	var activeBtnId = btnObj.id;
	for(var i = 0; i < btnArray.length; i++){
		if(activeBtnId == btnArray[i].btnId){
			document.getElementById(btnArray[i].btnId).style.fontWeight = 'bold';
			document.getElementById(btnArray[i].textAreaCompId).style.display = 'block';
			if(activeBtnId == 'ReqDef_Fulfillment' && fulfillmentTabPanel) {
				fulfillmentTabPanel.render('ReqDef_FulfillmentTab'); 
				enableDisableExeOrderBTN();
			}
		}else{
			document.getElementById(btnArray[i].btnId).style.fontWeight = 'normal';
			document.getElementById(btnArray[i].textAreaCompId).style.display = 'none';
		}
	}
}

function enableDisableExeOrderBTN()
{
		var exeOrderBtnComponent=Ext.getCmp('exeOrderBtn');
		if(disableReorderBTN=='true' || disableReorderBTN== true)
		{
			if(typeof(exeOrderBtnComponent) != 'undefined')
				{
					exeOrderBtnComponent.setDisabled(true);
					exeOrderBtnComponent.setIconClass('bmcSetOrderDisable');
				}
		}
		else
		{	
			if(typeof(exeOrderBtnComponent) != 'undefined')
				{
					exeOrderBtnComponent.setDisabled(false);
					exeOrderBtnComponent.setIconClass('bmcSetOrder');
				}
		}
}

	function toggleAccountSelector(checkState){
		if(Ext.getCmp('accountSelector')!=null){
			if(checkState.toLowerCase()=='true')  { 
				Ext.getCmp('accountSelector').getEl().mask();
				Ext.getCmp('paginationToolbar').getEl().mask();
			}	
			else{
				Ext.getCmp('accountSelector').getEl().unmask();
				Ext.getCmp('paginationToolbar').getEl().unmask();				
			}	
		}
	}
	
	function toggleProfileSelector(checkState){
		if(Ext.getCmp('profileSelector')!=null){
			if(checkState.toLowerCase()=='true')   
				Ext.getCmp('profileSelector').getEl().mask();
			else
				Ext.getCmp('profileSelector').getEl().unmask();  
		}
	}
	
	function closeWindow(){
		if (isReqDefDeleted) 
		{
			showMessage(errormsg);
			return;
		}
		var wid = getWID();
		window.parent.refreshList();
		window.parent.closeTab(wid);
	}
	
	function setTurnaroundTime(){
		daysSpinner.setValue(getDaysTargetHiddenEle().value);
		hoursSpinner.setValue(getHoursTargetHiddenEle().value);
	}
	
	function setBtnState(){
		if(reDefId != null && reDefId != ''){
			Ext.getCmp('copyId').setDisabled(false);
			Ext.getCmp('deleteId').setDisabled(false);
			Ext.getCmp('resetId').setDisabled(false);
			Ext.getCmp('prevId').setDisabled(false);
            Ext.getCmp('nextId').setDisabled(false);
			
			Ext.getCmp('copyId').setIconClass('bmcCopy');
			Ext.getCmp('deleteId').setIconClass('bmcDelete');
		}
	}
	
	function handleChange(){
		if(!clickedOnce){ 
			clickedOnce = true;
			window.parent.registerChange(getWID());
		}
	}
	
	function handleResetChange(){
		if(clickedOnce){
			clickedOnce = false;
			window.parent.registerSave(getWID());
		}
	}
	/*
		Apply permissons on add mapping button
	*/
	function checkPermissions() {
		var addMappingBtn = document.getElementById('addMappingBtn');
		if(isMappingCreateable == 'true') {
			addMappingBtn.disabled = false;
			addMappingBtn.style.color = '#004376';
		} else {
			addMappingBtn.disabled = true;
			addMappingBtn.style.color='#808080';
		}
	}

	function ImgError(source){  
		var parentDiv=source.parentNode;
		parentDiv.className='EnclosingDiv';
		//source.src = "";  
		source.onerror = "";  
		source.style.display='none';
		return true; 
	 } 
	 
	 
	function filterOutputField() {
		var respType,respRefType,dataType,refToObject; 
		var prompts = questionGrid.getSelectionModel().getSelections();
		if(!processVarStore) return;
		processVarStore.filterBy(function(outFieldRec, id) {
			dataType = outFieldRec.get('dataType').toLowerCase();
			refToObject = outFieldRec.get('refTo').toLowerCase();
			if(!prompts || prompts.length == 0) return true;
			if(prompts.length > 1) {
				if(dataType == dispTypeTxt)  {
				   var isValidDataType = true;
				    for(var index = 0; index < prompts.length; index++) {
					    var respType2 = prompts[index].get('respType').toLowerCase();
					    if(respType2 == respTypeTxtArea) {
							isValidDataType = false;
							break;
						} 
					}
					return isValidDataType; 
				} else if(dataType == dispTypeTxtArea){
					return true;
				}  else {
					return false;
				} 
			} else {
				respType = prompts[0].get('respType').toLowerCase();
				respRefType = prompts[0].get('respRefType').toLowerCase();
			}
			if(dataType != dispTypeTxtArea) {
				if(dataType == dispTypeTxt) {
					if(respType == respTypeTxtArea) {
						return false;
					} else {
						return true;
					}
				}else if(dataType == dispTypeDate || dataType == dispTypeDateTime) {
					return (respType == respTypeDate || respType == respTypeDateTime);
				} else if(dataType == dispTypeInt || dataType == dispTypeDouble || dataType == dispTypeCurr) {
					return (respType == respTypeNumber);
				} else if(dataType == dispTypePicklist) {
					return (respType == respTypeRadioBtn || respType == respTypePicklist);
				} else if(dataType == dispTypeBoolean) {
					return (respType == respTypeCheckBox);
				} else if(dataType == dispTypeReference && refToObject == refTypeImpact) {
					return (respType == respTypeLookup && respRefType == respImpact);
				}  else if(dataType == dispTypeReference && refToObject == refTypeUrgency) {
					return (respType == respTypeLookup && respRefType == respUrgency);
				} else if(dataType == dispTypeReference && refToObject == refTypeCategory) {
					return (respType == respTypeLookup && respRefType == respCategory);
				} else {
					return false;
				}
			} else {
				return true;
			}
		});
	}
	function setExecutionOrder(setOrderVal){
		var exeOrderEle = getExecOrderEle();
		if(exeOrderEle != null){
			exeOrderEle.value = setOrderVal;
		}	
    }
