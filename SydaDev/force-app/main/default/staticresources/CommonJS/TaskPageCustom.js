var servertime='',
	taskdata = '',
	changeDone = false,
	clickedOnce = false,
	userHasAccesToInc,
	taboutFlag=true,
	selectedModuleName,
	keyName,
	keyValue,
	dueDateOpt,
	ownerIdString,
	doSave = false,
	saveFunctionRef,
	networklatencystart = '',
	windowloaddate = '',
	addStageProgression=window.parent.addStageProgression,
	taskCategory,  
	taskId,
	taskState,
	taskName,
	closedStage,
	errormsg,
	chkBoxValue,
	isTaskPriorityChanged,
	impact,
	urgency,
	isCalcPriority,
	previousPriority = '',
	currentPriority = '',
	categoryIdForClose = '',
	taskResolutionForClose = '',
	link_Record,
	separator,
	disableTrue = true,
	isNoteEnableFlag=true,
	taskIdSet;
    insideNote = false; 
	document.onclick = activateWindow,
	hideCustomFieldAccordion = true,
	recId = '',
	displayIncEle = true,
	displayChangeEle = true,
	displayProblemEle = true;
	isError = false;
	var objName;
	
Ext.onReady(function(){    
	if(closedStage == 'CLOSED' || closedStage =='Closed'){
		Ext.MessageBox.show({title: Information , msg:ClosedStage, buttons: Ext.MessageBox.OK, icon: Ext.MessageBox.INFO});
	}
	getapplyTemplateCheckboxvalue();

// Changed by Manish to display Load times
	windowloaddate = new Date();
	networklatencystart = windowloaddate.getTime();
	var networklatency = networklatencystart - etime;
	taskdata += labelPM_netwokLatency;
	taskdata += networklatency;
	taskdata += '<br>';
 //Change ends
	
    if(hideCustomFieldAccordion){
		var elem = document.getElementById(TaskPageComp.ComponentVars.additionalFieldsPanelId);
		if(elem != null){
			elem.style.display = 'none';	
		}
	}
	
	
	
 Ext.QuickTips.init(); 
 if(isLookup){
	separator = '';
	disableTrue = true;
  }else{ 
  disableTrue = false;
  separator = '-'; }
// This function renders a block of buttons
var NewBtnHandler = function(button,event) {  
	var isCreateable = getIsCreateable();
	var isDeletable = getIsDeletable();
	var isUpdateable = getIsUpdateable();

	openPage('TaskPageCustom?isCreateable='+isCreateable+'&isDeletable='+isDeletable+'&isUpdateable='+isUpdateable,labelTaskWindowHeaderSearchPage,labelTaskWindowHeaderSearchPage);activeAllWindowFlag=false;
};
var isValid ='True';
function isValidDate(){
	isValid ='True';
	var taskDuedatetimeId = getTaskDuedatetimeId();
	var temp = document.getElementById(taskDuedatetimeId).value;            
		/*if(temp!=null && temp!=''){
			var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
			if (!(temp.match(RegExPattern))) {
				isValid ='False';
			} else {
				isValid ='True';                    
			}                    
		}*/
}
function saveBeforeCloseRecords(){
	chkBoxValue=Ext.getCmp('task_inactive__c').getValue(); //new one
	isValidDate();
	if(isValid=='True'){                
		saveBeforeCloseTask(chkBoxValue);
	}else{
		Ext.MessageBox.show({ msg: labelValidDateTime, buttons: Ext.MessageBox.OK});
	}
} 
var SaveBtnHandler = function(button,event) { 
		
	if(!inProgress){    
		doSave = false;
		Ext.getCmp('saveId').setDisabled(true);
		chkBoxValue=Ext.getCmp('task_inactive__c').getValue();
		var impactNameId = getImpactNameId();
		var impactNameEle = document.getElementById(impactNameId);
		var impactName = '';
		if(impactNameEle != null)
			impactName = impactNameEle.value; 
			
		var urgencyNameId = getUrgencyNameId();
		var urgencyNameEle = document.getElementById(urgencyNameId);
		var urgencyName = '';
		if(urgencyNameEle != null)
			urgencyName = urgencyNameEle.value;
		var isPriorityChangedValId = getIsPriorityChangedValId();	
		var isPriorityChanged = document.getElementById(isPriorityChangedValId).value;
		var dueDateCalculationOptionId = getDueDateCalculationOptionId();
		dueDateOpt = document.getElementById(dueDateCalculationOptionId);
		if(isPriorityChanged != 'false' && taskId != '' && taskId != null && impactName != '' && urgencyName != ''){
			if(!automaticupdateduedate)
				{
					openPopup('recalculateDueDate', showit, 190, 300);
				}
				else
				{
					 //document.getElementById(dueDateCalculationOptionJS).value = 2; 
					 //saveRecords();
					 if(dueDateOpt == null || dueDateOpt == 'null' || typeof(dueDateOpt) == 'undefined'){
						var dueDateCalculationOptionId = getDueDateCalculationOptionId();
						dueDateOpt = document.getElementById(dueDateCalculationOptionId);
						dueDateOpt.value = 2;
					}else{
						dueDateOpt.value = 2;
					}
					waitbox(0);
					saveTask(chkBoxValue);
				}
		}else{
			//isValidDate();
			if(isValid=='True'){
				waitbox(0);
				saveTask(chkBoxValue);
			}else{
				Ext.MessageBox.show({ msg: labelValidDateTime, buttons: Ext.MessageBox.OK});
			}   
		}
	}else{
		doSave = true;
	} 
};

saveFunctionRef = SaveBtnHandler;

var CopyBtnHandler = function(button,event) {  activeAllWindowFlag=false;callCopyPage();};
var DeleteBtnHandler = function(button,event) {  
												Ext.MessageBox.confirm(labelDelete, labelDeleteTaskPage, function(btn){
												   if(btn === 'yes'){
														  deleteTask();
												   }});
												 };
var taskDuedatetimeId = getTaskDuedatetimeId();												 
var ResetBtnHandler = function(button,event) { //document.getElementById(taskDuedatetimeId).value = ''; 
resetTask(); };

var AssignToStaffHandler = function(button,event) { 
	openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true',preAssignTaskTOStaff);
}
var AssignToMemberOfHandler= function(button,event) { 
	openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("profileid='"+profileId+"' And IsStaffUser__c=true")+'&isAssignTo=true',preAssignTaskTOStaff);
}
var AssignToSuggestedStaffHandler = function(button,event) { 
	selectedModuleName = 'staff';
	openPopup('SearchPage?popupId=SuggestedStaff&isLookup=true&isSuggestExpert=true&queueFor=Task__c&isQueurorUser=true&isActiveUser=true&categoryId='+taskCategory+'&filterClause='+escape("FKUser__r.IsStaffUser__c=true"),preAssignTaskTOSuggestedStaff);
}
var AssignToMyselfHandler = function(button,event) {
	waitbox(0);
	assignTOMyself();
	handleChange(null);	
}
var AssignToQueueHandler = function(button,event) {  
	//openPopupWithTitle('QueueListPage?sObjectType=Task__c',preAssignTaskTOQueue,labelSelectFrom+' '+labelQueue,550, 670);
	openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Task__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), preAssignTaskTOQueue);
};

var TemplateBtnHandler = function (button, event){
            var templateBtn = Ext.getCmp('templateBtnId');
			if (taskId != null && taskId !='' && overwrite =='true') {
				Ext.MessageBox.confirm('',OverwriteWarning, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Task'"),fetchTaskTemplates)
					}
				  });
			}  
			else if((taskId != null && taskId !='' && overwrite =='false'&& changeDone == true) || (taskId == null||taskId =='' && overwrite =='false'&& templateBtn.disabled == false && changeDone == true)) {
			    Ext.MessageBox.confirm('',replaceUnsaved, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Task'"),fetchTaskTemplates)
                  }});
			}
			else
                if(templateBtn.disabled == false ){
				openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Task'"),fetchTaskTemplates)
				} 
			};
var CloseBtnHandler= function(button,event){ 
	chkBoxValue=Ext.getCmp('task_inactive__c').getValue(); //new one
	waitbox(0);
	saveBeforeCloseTask(chkBoxValue);
};

var QuickCloseBtnHandler = function(button,event) { 
	quickCloseTaskNext();
}
var ReopenBtnHandler = function(button,event) {reopenTask();}
var PreviuosBtnHandler = function (button,event) {	getNoteIdVal().value = '';
			if (window.parent.changeArray[wid] != null && typeof(window.parent.changeArray[wid]) != 'undefined' && window.parent.changeArray[wid] != -1 ){				
					checkLoseChanges(previousTaskBtnHandler1);				
			} else {  if(document.getElementById('prevId').disabled!=true) 
				        previousTaskBtnHandler1();}
			}
var NextBtnHandler = function (button,event) {	getNoteIdVal().value = '';
			if (window.parent.changeArray[wid] != null && typeof(window.parent.changeArray[wid]) != 'undefined' && window.parent.changeArray[wid] != -1 ){				
					checkLoseChanges(nextTaskBtnHandler1);				
			} else {  if(document.getElementById('nextId').disabled!=true) 
				        nextTaskBtnHandler1();}
			}

var SamplePanel = Ext.extend(Ext.Panel, {
	renderTo: 'btnToolbar',
	defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
});

new SamplePanel({
	id:'toolBarId',
	title: '',
	 cls:'toolSpCls',
	 bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',             
	tbar: [{
		scale: 'medium',
		iconCls: 'bmcNew',
		tooltipType : 'title',
		tooltip: labelNew,
		id:'newId',
		hidden:disableTrue,
		handler:NewBtnHandler
	 
	},' ',{
		scale: 'medium',
		iconCls: 'bmcSave',
		tooltipType : 'title',
		tooltip: labelSave,
		id:'saveId',
		disabled : saveState,
		handler:SaveBtnHandler
	   
	},' ',{
		scale: 'medium',
		iconCls: 'bmcCopy',
		tooltipType : 'title',
		tooltip: labelCopy,
		id:'copyId',
		hidden:disableTrue,
		handler:CopyBtnHandler
	   
	},' ','-',' ',{
		scale: 'medium',
		iconCls: 'bmcDelete',
		tooltipType : 'title',
		tooltip: labelDelete,
		id:'deleteId',
		handler:DeleteBtnHandler
	   
	},' ',{
		scale: 'medium',
		iconCls: 'bmcRefreshDasboard',
		tooltipType : 'title',
		tooltip: labelReset,
		id:'resetId',
		hidden:disableTrue,
		handler:ResetBtnHandler
		
	},' ',separator,' ',{
		id:'assignToId',
		scale: 'medium',
		iconCls: 'bmcAssign1',
		tooltipType : 'title',
		tooltip: labelAssignTo,
		hidden:disableTrue,
		menu: [ 
				{text:labelIncidentsStaff,
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', id:'assignToStaffButtonId',
				 disabled:assignStaffState,handler:AssignToStaffHandler},
				{text:labelSuggestedExperts,icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToSuggestedStaffButtonId',disabled:assignSuggestedStaffState,handler:AssignToSuggestedStaffHandler},
				{text:labelIncidentMyself, 
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToMyselfButtonId', 
				 disabled:assignMyselfState, handler:AssignToMyselfHandler},
				{text:labelIncidentMemberofProfName, id:'assignToMemberOfAdminButtonId', 
				 disabled:assignSuggestedStaffState, icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',handler:AssignToMemberOfHandler
				 },
				{text:labelQueue, 
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToQueueButtonId', handler:AssignToQueueHandler
				 }]
	},' ',{
		id:'actionId',
		scale: 'medium',
		iconCls: 'bmcAction1',
		tooltipType : 'title',
		tooltip: labelActions,
		hidden:disableTrue,
		menu: [ {text:labelIncidentClose, id:'closeButtonId', icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', disabled:closeState,  handler:CloseBtnHandler },
				{text:labelIncidentQuickClose, id:'quickCloseButtonId', icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', disabled:closeState, handler:QuickCloseBtnHandler },
				{text:labelReopenTask, id:'reopenButtonId',icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', disabled:reOpenState, handler:ReopenBtnHandler},{text:Print, disabled:IsNewRecord(taskId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',   id:'printButtonId', handler:PrintBtnHandler},{ text:PrintPDF, disabled:IsNewRecord(taskId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'printPdfButtonId', handler:PrintPDFBtnHandler},'-',customActionJsonString]
	},' ',{
		scale:'medium',
		iconCls: 'bmcTemplate',
		tooltipType : 'title',
		tooltip:labelTemplate,
		id:'templateBtnId',
		disabled:templateFlag,
		hidden:disableTrue,
		handler:TemplateBtnHandler,
		listeners: {
						disable: function(){
							this.setIconClass('bmcTemplateDisable');    
						},
						enable: function(){
							this.setIconClass('bmcTemplate');          
						}
					}

	},' ','-',' ',{
		scale: 'medium',
		iconCls: 'bmcCIExplorer',
		tooltipType : 'title',
		tooltip: labelLaunchCIExplorer, 
		id:'ciExplorerBtn',
		listeners: {
			mouseover: function(){
				this.setIconClass('bmcCIExplorerOn');    
			},
			mouseout: function(){
				this.setIconClass('bmcCIExplorer');          
			},
			disable: function(){
				this.setIconClass('bmcCIExplorerDisable');    
			},
			enable: function(){
				this.setIconClass('bmcCIExplorer');          
			}
		},
		handler: ShowCIExplorer 
	},
	{
		scale: 'medium',
		iconCls: 'bmcEmailMessage',
		tooltipType : 'title',
		tooltip: labelEmailMessage,
		id:'emailId',
		hidden:disableTrue,
		handler:sendEmailBtnHandler,
		listeners: {
				disable: function(){
					this.setIconClass('bmcEmailMessageDisable');    
				},
				enable: function(){
					this.setIconClass('bmcEmailMessage');          
				}
			}					
	},
	new Ext.Toolbar.Fill(),
	{
		  id :'task_inactive__c',
	   xtype  : 'checkbox',
	   width  : 93,
	   color :'#004376',
	   align:'top',
	   checked: false,
	   boxLabel:'<span class="checkboxLabelCls">'+labelInactive+'</span>'
	}, {
	   xtype : 'box',
	   id: 'prevId', 
		autoEl:  {tag: 'img', 
				  src:getSDFStylesResPath() +'/SDEFbuttons/b_previous.gif',   
				 title:labelPreviousRecord
				 },
				  
		cls:'cursorCls',
	   listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
					 
	},{
		xtype : 'box',
		id: 'nextId', 
		autoEl:  {tag: 'img', 
				  src:getSDFStylesResPath() +'/SDEFbuttons/b_next.gif',
				  title:labelNextRecord },
		cls:'cursorSpaceCls',
		listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
	   
		
	}
	
	] 
});

new Ext.ToolTip({
	target: 'task_inactive__c',			
	anchor: 'left',			
	html: labelAPMTaskInactive						  
});
		
if(isInactive){                 
Ext.getCmp('task_inactive__c').setDisabled(true);
}

if(copymetrue){  
Ext.getCmp('saveId').setDisabled(true);
}
var taskInactiveVal = getTaskInactive();
Ext.getCmp('task_inactive__c').setValue(taskInactiveVal);
taskId = getTaskId();    
taskState = getTaskState();    
if(taskId == null || taskId == ''){                
Ext.getCmp('deleteId').setDisabled(true);
 Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
Ext.getCmp('copyId').setDisabled(true);
Ext.getCmp('prevId').setDisabled(true);
Ext.getCmp('nextId').setDisabled(true);
Ext.getCmp('resetId').setDisabled(true);
Ext.getCmp('emailId').setDisabled(true);
} else if(taskId != null && taskState == 'false'){
		  if(typeof(isSILoaded) != 'undefined')
			disableAll(); }

			
			
	if(taskId == null || taskId == ''){
		Ext.getCmp('templateBtnId').setDisabled(false);
	}else
	if(taskId != null){
		if(setcheckboxvalueforTemplate == 'true'){
			Ext.getCmp('templateBtnId').setDisabled(closeState);
		}else
		{
			Ext.getCmp('templateBtnId').setDisabled(true);
		}
	}
	
	checkPermissions();
	
///////////// // IE7-8 Related Changes
       document.getElementById('capsule').style.display = 'block';
	   var canvasPanel = new Ext.Panel({
			 layout:'border',
			// width:'auto',    
			height:Ext.isIE7 ? 670: Ext.isIE ? 674:Ext.isSafari ?695:680,
			 border:false, 
			 id:'canvasPanelId',
			cls:'canvasPanelCls',
			 items:[{  
					xtype: 'panel', // TabPanel itself has no title    
					  layout: 'fit',                                                   
					overflow:'auto',
					autoScroll:true,
					split:false,
					width:'auto',    
					height:485, 
					cls:'northPanelCls',
																 
					region: 'center',                   
				   // margins:'2 4 2 0',
										 
					contentEl : Ext.isIE ? 'capsule' : taskFormComponent
					
			},{                                                         
					xtype: 'panel', // TabPanel itself has no title
					layout: 'fit',  
					overflow:'auto',
					 border:false, 
					 id:'southPanelSI',
					autoScroll:true,
					split:true,
					collapsible: true,
					collapseMode: 'mini',
					width:'auto',    
					 height:Ext.isIE ?182:180, // *****************************************
					 minHeight:Ext.isIE ?120:150,
					animCollapse:false,												  
					region: 'south',
				   listeners : {
						resize:function( obj,adjWidth,adjHeight,rawWidth,rawHeight ) { 
							 if(typeof(adjHeight) =='number')
											document.getElementById('detailsDivSI').style.height=adjHeight+ "px";
								var isDisplay = document.getElementById('SIIframeID').style.display;
							 if(isDisplay !='none')
							{ 
										
								if(typeof(window.frames.SIIframeID.setSouthPanelHeight) == 'function')
								window.frames.SIIframeID.setSouthPanelHeight(adjHeight,adjWidth);
							} 
					   },
					   collapse:function(){
						      this.setWidth('auto');
						}
				   },
				  
				   contentEl :'detailsDivSI' 
			}],
			listeners: {
				afterlayout: function(c) {
					c.layout.south.miniSplitEl.dom.qtip = labelDragResizeClickCollapse;
					c.layout.south.getCollapsedEl();
					c.layout.south.miniCollapsedEl.dom.qtip = labelClickToExpand;
				},
				single: true
			}
			
		   
			 
		   
	});

		 var viewport = new Ext.Viewport({
		 layout:'anchor',
	  
		 width:'auto',
		 id:'viewportId',
		 border:false, 
		 cls:'viewportCanvasCls',          
		 items:[{anchor: '100%', layout:'fit', items:canvasPanel} ]
		}); 
/////////////// // End IE7-8 Related Changes
		ChangeBtnStatus(cilink_record);
		/*------------Code To Handle Changes in Page Data---------*/
			
		handleElemEvent();
		converdisabletoreadonly();
	  
	  /*----------------------------*/
	var NoRightsToViewEdit = getNoRightsToViewEditVal();
	if(isRecordDeleted()){
		Ext.Msg.alert(Information, DeletedRecord, function(){
		if((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!= 'undefined'))
			window.parent.popUpWindow.close();
		closeWindow();
		});
	}
	else if (NoRightsToViewEdit)
	{
		Ext.Msg.alert('', labelMsgNoAccessPerm, function(){
		if ((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!='undefined'))
				window.parent.popUpWindow.close();
		closeWindow();
		});
		
	}
   if(taskId == null || taskId == ''){
		var userLastname = getUserLastname();
		var uname= document.getElementById(userLastname).value;
		if(uname == null || uname == ''){
			try{
			  document.getElementById(userLastname).focus();
			}catch(e){	
			}
		}
		document.getElementById('linkSIAvailTD').style.display = 'none';
        document.getElementById('noSIAvailTD').style.display = 'block';
	}else{
		var isCookiePresent = displaySI(cookieName, iFrameSrc);
		if(!isCookiePresent){displaySI(cookieName, iFrameSrc);
			if(document.getElementById('noSIAvailTD') != null)
				document.getElementById('noSIAvailTD').style.display = 'none';
		    if(document.getElementById('noSIAvailTD') != null)
				document.getElementById('linkSIAvailTD').style.display = 'block';
		}
		Ext.getCmp('emailId').setDisabled(closeState);
	}
	
	if(copymetrue){  
		copyCommit(chkBoxValue);
	}	
	
   //Added by Manish to Display Load Times

	var pageloadstartdate =   new Date() ;
			 
	var finalTime = pageloadstartdate.getTime();
  
	var pagerendertime =(finalTime - networklatencystart);
	taskdata += labelPM_PageLoad;
	taskdata += pagerendertime; 
	taskdata += '<br>';
	//document.getElementById('taskpm').innerHTML = taskdata; 
});    

function OpenHelpUrl(link){
	if(link.toLowerCase().indexOf('composeemailpage') != -1){
		OpenHelppage('EmailConversationTask','module','form');
	}
} 

 function handleChange(obj){
	if(obj!=null)
	{
		var target = obj.target || obj.srcElement;
		if(target != 'undefined' && target.id.match("taskNote__c") == null && target.id.match("addNoteBt") == null){
			insideNote= true;
		}
	}
	if(!clickedOnce){
		clickedOnce = true;
		changeDone = true;
		window.parent.registerChange(wid);
	}
}
function handleResetChange(){
	if(clickedOnce){
		clickedOnce = false;
		changeDone = false;
		window.parent.registerSave(wid);
	}
}
function checkSave(){
	if(doSave){
		saveFunctionRef();
	}
}
function afterSaveAction(){ 
	var modName = getModuleName();  
	var parentWid = getParentWid();
	if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && parentWid != '' && typeof(parentWid) != 'undefined' && errormsg==labelSavedSuccessfully){
	   return true;
	}else{
		showError();
	}
}
function afterResetSI(){
	var modName = getModuleName();  
	var parentWid = getParentWid();
	if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && parentWid != '' && typeof(parentWid) != 'undefined' && (errormsg==labelSavedSuccessfully || errormsg == '')){
		window.parent.registerSave(wid);
		window.parent.parent.refreshSupportingInformation(parentWid,modName);
	}
 }
function afterDelteAction(){ 
	var modName = getModuleName();  
	var parentWid = getParentWid();
	if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && parentWid != '' && typeof(parentWid) != 'undefined'){
		window.parent.parent.refreshSupportingInformation(parentWid,modName);
	}
}
function afterSaveCloseAction(){ 
    waitMsg.hide();
	if(errormsg==labelSavedSuccessfully){            
		openPopupWithTitle('CloseTask?taskId='+getTaskId()+'&isLookup=true' + '&categoryId='+ categoryIdForClose + '&taskResolution=' + taskResolutionForClose ,closeTaskNext,labelCloseTask,380,600);
	}else {
		showError();
	}
} 
function senddata(){
	var tdata = taskdata;
	return tdata;
} 
function FetchUrgency(){
	FetchUrgencyDetails();
}
function fetchUrgencyForCategory(){	
	var categoryNameId = getCategoryNameId();
	var categoryName = document.getElementById(categoryNameId).value;
	var categoryIdVal = getCategoryIdVal();
	var categoryId = document.getElementById(categoryIdVal).value;
	var categoryFKUrgency = getCategoryFKUrgency();
	var categoryUrgency = document.getElementById(categoryFKUrgency).value;
	var urgencyIdVal= getUrgencyIdVal();
	var urgenycId = document.getElementById(urgencyIdVal).value
	
	if(categoryName != null && categoryName != '' && categoryId != null && categoryId != '' && categoryUrgency != null && categoryUrgency != '' && categoryUrgency != urgenycId){
		 setCategoryNext(categoryName);
	}    
}
function calculatePriority(){

	var impactNameIdVal = getImpactNameId();
	var impactNameEle = document.getElementById(impactNameIdVal);
	var impactName = '';
	if(impactNameEle != null)
		impactName = impactNameEle.value; 
		
	var urgencyNameIdVal = getUrgencyNameId();
	var urgencyNameEle = document.getElementById(urgencyNameIdVal);
	var urgencyName = '';
	if(urgencyNameEle != null)
		urgencyName = urgencyNameEle.value;
		
	var impactIdVal = getImpactIdVal();
	var impactIdEle = document.getElementById(impactIdVal);
	var impactId = '';
	if(impactIdEle != null)
		impactId = impactIdEle.value 
		
	var urgencyIdval = getUrgencyIdVal();
	var urgencyIdEle = document.getElementById(urgencyIdval);
	var urgencyId = '';
	if(urgencyIdEle != null)
		urgencyId = urgencyIdEle.value;     
	
	if( impactName != '' && urgencyName != '' && impactId != '' && urgencyId != '' ){
		calculatePriorityNext();
	}   
}
function openImpactLookup(impactId ){            
		if(impactId != null && impactId != '' ){
				 setImpactNext(impactId );
		}               
}
function openUrgencyLookup(urgenycId ){            
		if(urgenycId != null && urgenycId != '' ){
				 setUrgencyNext(urgenycId);
		}               
}
function selectImpactOnName(){
	var impactIdVal = getImpactIdVal();
	var impactId = document.getElementById(impactIdVal).value;
	if(impactId != null && impactId != ''){
		FetchPriorityHTTP();
	}
}
function selectUrgencyOnName(){
	var urgencyIdVal = getUrgencyIdVal();
	var urgencyId = document.getElementById(urgencyIdVal).value;
	if(urgencyId != null && urgencyId != ''){
		calculatePriority();
	}
}
//Function called from TaskPage and SupportInformationComponent
function ChangeBtnStatus(link_Record){
	if(link_Record=='false'){
		Ext.getCmp('ciExplorerBtn').disable();
	}else{
		Ext.getCmp('ciExplorerBtn').enable();
	}
}  
function ShowCIExplorer(){
	var newTaskId = AssignNewTaskId();
	var title = labelCIExpCIExplorer; 
	//Will add labels and classes to this
	var linkci = escape('CIExplorerLauncher?Module=Task__c&RecordSequence='+newTaskId+'&id='+newTaskId);
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
	window.parent.parent.addNewTab('CIExplorerLauncher', labelConfigurationItemsExplorer, url );
}
var sendEmailBtnHandler = function (button, event){
               openPopupWithTitle('ComposeEmailPage?recordId='+taskId+'&isNew=true&objectName=Task__c',composeMailOnCompleteIn, labelComposeEmailPageHeader+taskName, getEmailWinHt(), getEmailWinWidth(), false);
            }
function getTSKid(tskId,isSave){
	if(errormsg == null||errormsg ==''||errormsg==labelSavedSuccessfully){
		if(isLookup){
		  //window.parent.refreshDocs();
			
		  window.frames.SIIframeID.setId(tskId,isSave);
	   }else{
		   window.frames.SIIframeID.setId(tskId,isSave);
	   }
	}   
}
function callCopyPage(){
	var isCreateable = getIsCreateable();
	var isDeletable = getIsDeletable();
	var isUpdateable = getIsUpdateable();
	
	window.parent.addTab("TaskPageCustom?copyId=" + taskId + '&isCreateable='+isCreateable+'&isDeletable='+isDeletable+'&isUpdateable='+isUpdateable,labelTaskWindowHeaderSearchPage,labelTaskWindowHeaderSearchPage);
}
function closeWindow(){
	if(isLookup){
		window.parent.refreshDocs();                
		window.parent.closePopup();
	}else{
		window.parent.refreshList();
		window.parent.closeTab(wid);
	}
}
function showit(selectedOption){
		if(dueDateOpt == null || dueDateOpt == 'null' || typeof(dueDateOpt) == 'undefined'){
			var dueDateCalculationOptionId = getDueDateCalculationOptionId();
			dueDateOpt = document.getElementById(dueDateCalculationOptionId);
			dueDateOpt.value = selectedOption;
		}else{
			dueDateOpt.value = selectedOption;
		}
		var chkBoxValue=Ext.getCmp('task_inactive__c').getValue();
		waitbox(0);
		saveTask(chkBoxValue);
}
function previousTaskBtnHandler1(){
	var idSetString='';
	var i=0;
	while(taskIdSet.length > i){
		if(idSetString==''){
			idSetString=taskIdSet[i];
		}else{
			idSetString=idSetString+','+taskIdSet[i];
		}
		i++;
	}
	previousTaskBtnHandler(idSetString);        
}
function nextTaskBtnHandler1(){
	var idSetString='';
	var i=0;
	while(taskIdSet.length > i){
		if(idSetString==''){
			idSetString=taskIdSet[i];
		}else{
			idSetString=idSetString+','+taskIdSet[i];
		}
		i++;
	}
	nextTaskBtnHandler(idSetString);

}
function showData(event,onCompleteFunction,whereClause,windownameflag){
	if(taboutFlag!=true){
		if(typeof(onCompleteFunction)!='undefined' && typeof(whereClause)!='undefined'){
			if(typeof(windownameflag) != 'undefined'){
				 
				showalldata(event,onCompleteFunction,whereClause,windownameflag);
			}else{
				showalldata(event,onCompleteFunction,whereClause);
			}   
		}
		else if(typeof(onCompleteFunction)!='undefined' && typeof(whereClause) =='undefined'){
			showalldata(event,onCompleteFunction);
		}                
		else{
			showalldata(event);
		}               
	}else{
		if(typeof(onCompleteFunction)!='undefined'){
			onCompleteFunction();
		}
	}
}
function buttonValidator() {
   
   if(((categoryRequired=='false') || (taskCategory != null && taskCategory != ''))&&(errormsg == null||errormsg ==''||errormsg==labelSavedSuccessfully)){   

	Ext.getCmp('deleteId').setDisabled(false);
	Ext.getCmp('deleteId').setIconClass('bmcDelete');
	Ext.getCmp('copyId').setDisabled(false);
	Ext.getCmp('printButtonId').setDisabled(false);
	Ext.getCmp('printPdfButtonId').setDisabled(false);;
	if(setcheckboxvalueforTemplate == 'true'){
		Ext.getCmp('templateBtnId').setDisabled(false);
		Ext.getCmp('templateBtnId').setIconClass('bmcTemplate');
	}else{
		Ext.getCmp('templateBtnId').setDisabled(true);
		Ext.getCmp('templateBtnId').setIconClass('bmcTemplateDisable');
	}
	Ext.getCmp('emailId').setDisabled(false);
	Ext.getCmp('resetId').setDisabled(false);
	var isDisplay = document.getElementById('SIIframeID').style.display;
	if(cookieValue =='true' && isDisplay =='none' ){
		SIComp(iFrameSrc);
	}else{
		if(isDisplay == 'none') {
		     document.getElementById('noSIAvailTD').style.display = 'none';
					if(Ext.isChrome){
					document.getElementById('onDemandSITableId').style.display = 'inline-table';
					 document.getElementById('linkSIAvailTD').style.display = 'table-cell';
					}else{
			        document.getElementById('onDemandSITableId').style.display = 'block';
					document.getElementById('linkSIAvailTD').style.display = 'block';
					}
		}
	}
   }  
   checkPermissions();
   
 }

function checkPermissions(){
	var createT = getIsCreateable();
	var deleteTask = getIsDeletable();
	var updateT = getIsUpdateable();
	
	if(getIsCreateable() == 'false'){
		Ext.getCmp('newId').setDisabled(true);
		Ext.getCmp('copyId').setDisabled(true);
	}
	if(getIsDeletable() == 'false'){
		Ext.getCmp('deleteId').setDisabled(true);
		Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
	}
	if(getIsUpdateable() == 'false'){
		Ext.getCmp('closeButtonId').setDisabled(true);
	    Ext.getCmp('reopenButtonId').setDisabled(true); 
	    Ext.getCmp('quickCloseButtonId').setDisabled(true);
	    Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
		Ext.getCmp('assignToStaffButtonId').setDisabled(true);
		Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
		Ext.getCmp('assignToQueueButtonId').setDisabled(true);
		Ext.getCmp('assignToSuggestedStaffButtonId').setDisabled(true);
	}
	if(getIsCreateable() == 'false' && getIsUpdateable() == 'false'){
		Ext.getCmp('saveId').setDisabled(true);
	}
	//IF user has only create permission.
	var taskId = getTaskId();
	
	if(getIsCreateable() == 'true' && getIsUpdateable() == 'false' && taskId != null && taskId != ''){
		Ext.getCmp('saveId').setDisabled(true);
	}
 }
function openCategoryPage(returnValues){    
	if(returnValues != null || returnValues != '')
	{
		if(returnValues[0] != null ||returnValues[0] !='' ) {
			setCategoryNext(returnValues[0]); //Calling Action Function
								}
			if(returnValues[1] != null || returnValues[1] != '') {
				   setDescriptionNext(returnValues[1]); //Calling Action Function
			}
			if(returnValues[2] != null || returnValues[2] != ''){
				setResolutionNext(returnValues[2]); //Calling Action Function
			}
	 }	
}

function reopenTask(){
	reopenTaskNext();
}
function showInfoPopup(eventObject, divId , objName){
	var recordId = '';
		var target=eventObject.target;
		if(target == null) 
			target = eventObject.srcElement; 
		
	if(objName == 'staff'){
		var staffHiddeninput = getStaffHiddeninput();
		recordId = document.getElementById(staffHiddeninput).value;
			tooltipforstaff();
		}
	if(recordId != '' && recordId != null){
		   var tooltipforclientstaff = new Ext.ToolTip({
				target: target.id,
				title : '',
				anchor: 'right',
				width: 200,
				trackMouse: true,
				shadow :'sides',
				bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
				dismissDelay: 20000,
				html: document.getElementById(divId).innerHTML
			});    
		  
		 
	}
 }
function callByChild(){
	var taskResolutionId = getTaskResolutionId();
  return document.getElementById(taskResolutionId).value;
}
function ellipse(fieldstring,maxlength){
     //var maxlength = 35;
     if(fieldstring.length > maxlength )
     {
        return fieldstring.substr(0, maxlength-3) + '...';
     }
     return fieldstring;
}
function formCSZString(city,state,zip){
//alert("formatting");
var formattedstr='';
if(city != '')
{
   formattedstr= ellipse(city,33) + ', ';
}  
if(state != '')
{
   formattedstr= formattedstr + ellipse(state,33) +' ';
}
if(zip != '')
{
   formattedstr= formattedstr + ellipse(zip,33);
}   
return formattedstr;
}
function handleSaveJs(id){
	window.parent.handleSave(wid, id);
}
function resizeGridProgressionJS(StageHTML,objPluralType){
	var resizeGrid= function resizeGrid(){
        if(Ext.getCmp('southPanelSI')!=undefined)
         Ext.getCmp('southPanelSI').setWidth(Ext.getCmp('southPanelSI').getWidth());
        };
	if(window.parent.refreshGridSI!=undefined)
		window.parent.refreshGridSI(wid,resizeGrid);
		
    //Sridhar: Added for Stage Progression
    if(!isLookup){
        window.parent.addStageProgression(wid, StageHTML);
    }      
    if(isLookup){
		window.parent.changePopUpTitle(objPluralType);
    }
}
function taskIdSetJS(isDirect_Par,wid_Par,id_Par){	
    if(taskIdSet == null || taskIdSet == ''){
		if(isDirect_Par == ''){
			if(typeof(window.parent.returnListOfId)=='function')
				taskIdSet=window.parent.returnListOfId();
		}else{
			if(typeof(window.parent.parent.getIdArray)=='function')
			taskIdSet=window.parent.parent.getIdArray();
			handleSave(wid_Par,id_Par);
			//alert('taskIdSet='+taskIdSet);
		}
	}
}
function checkLoogedInUserHasAccessJS(userHasAccesToInc){
	if(userHasAccesToInc == 'false' && taskId != '' && taskId != null && taskId != 'null'){
		window.parent.refreshList();
		window.parent.closeTab(wid);
	}
}
function assignNewTaskIdJS(newTaskId){
	return newTaskId;
}
function checkEnableJS(assignMyselfState,assignToQueueState,assignStaffState,assignSuggestedStaffState,closeState,saveState,reOpenState){
	if((errormsg == null || errormsg == '' || errormsg == labelSavedSuccessfully) && !isError){
		Ext.getCmp('assignToMyselfButtonId').setDisabled(assignMyselfState);
		Ext.getCmp('assignToQueueButtonId').setDisabled(assignToQueueState);
		Ext.getCmp('assignToStaffButtonId').setDisabled(assignStaffState);
		Ext.getCmp('assignToSuggestedStaffButtonId').setDisabled(assignSuggestedStaffState);
		Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(assignSuggestedStaffState);
		Ext.getCmp('quickCloseButtonId').setDisabled(closeState);
		Ext.getCmp('closeButtonId').setDisabled(closeState);
		Ext.getCmp('reopenButtonId').setDisabled(reOpenState);
		Ext.getCmp('emailId').setDisabled(closeState);
	}
	Ext.getCmp('saveId').setDisabled(saveState);
	Ext.getCmp('templateBtnId').setDisabled(getApplyTemplate(saveState));
}
function initTaskJS(taskName_p,taskCategory_p,taskId_p,isTaskPriorityChanged_p,impact_p,urgency_p,isCalcPriority_p,currentPriority_p,categoryIdForClose_p,taskResolutionForClose_p){
	taskName =taskName_p;
	taskCategory = taskCategory_p;
	taskId = taskId_p;
	isTaskPriorityChanged = isTaskPriorityChanged_p;
	impact = impact_p;
	urgency = urgency_p;
	isCalcPriority = isCalcPriority_p;
	currentPriority = currentPriority_p;
	categoryIdForClose = categoryIdForClose_p;
	taskResolutionForClose = taskResolutionForClose_p;
}
function setSelectedModuleName(modNameFS){
	selectedModuleName = modNameFS;
}
function refreshRelatedPortletsJS(){
	if(typeof(window.parent.parent.refreshPortletByTitle) == 'function')
		window.parent.parent.refreshPortletByTitle('Action Items');
}
function resetSupportingInformationJS(taskState, newTaskId, isSave){
   var isDisplay = document.getElementById('SIIframeID').style.display;
	if(isDisplay !='none'){
		if(!taskState){ 
			window.frames.SIIframeID.disableAll();
		}else{
			window.frames.SIIframeID.enableAll();
		}	
		getTSKid(newTaskId,isSave);
	}
}
function changeTitleAddStageProgressionJS(newTitle,StageHTML,labelTaskwithHash,labelTask){
	if(newTitle == labelTaskwithHash){
		newTitle = labelTask;
	}                       
	window.parent.changeTitle(wid,newTitle,newTitle);
	//Sridhar: Added for Stage Progression
	window.parent.addStageProgression(wid, StageHTML);	
	//performance fix
	//window.parent.refreshList();
	window.parent.needsRefresh = true;                 
}
function tooltipforstaffJS(userName,userTitle,cszstringuser,userCountry,userPhone,userEmail){
	strSingleLineText = document.getElementById('userAddressforttdivId').innerHTML.replace(new RegExp( "\\n", "g" ), ' ');
	document.getElementById('userAddressforttdivId').innerHTML = ellipse(strSingleLineText,33);
	document.getElementById('userNameforttdivId').innerHTML = ellipse(userName,50);
	document.getElementById('userTitleforttdivId').innerHTML = ellipse(userTitle,40);	
	document.getElementById('userCSZforttdivId').innerHTML = cszstringuser ;
	document.getElementById('userCountryforttdivId').innerHTML = ellipse(userCountry,33);
	document.getElementById('userPhoneforttdivId').innerHTML = ellipse(userPhone,33);
	document.getElementById('userEmailforttdivId').innerHTML = '<a href="'+userEmail+'" class="clsCmdLinkTooltip">'+ellipse(userEmail,33)+'</a>';                          
}
function setAssignedToJS(){
	taboutFlag=false;
	if(ownerIdString != null && ownerIdString != '' && ownerIdString != 'undefined'){
		setAssignedTo(ownerIdString);
	}
}
function setTaskDataJS(taskend){
	servertime = taboutservertime +  vservertime +  siservertime + (taskend - taskstart);
	taskdata += servertime;
	taskdata += '<br>';
}

function writeCookie(){
		if(document.getElementById('configureSIId').checked){
			createSICookie(cookieName,'true');
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
			
		}
}
function afterAddNote(){
	 var isDisplay = document.getElementById('SIIframeID').style.display;
	if(cookieValue !='true' && isDisplay =='none'){
		SIComp(iFrameSrc);
	}else if(isDisplay !='none'){ 
		window.frames.SIIframeID.refreshDocs(); 
	}
	
}
function siControlBack(){
	var cookieval =Ext.util.Cookies.get(cookieName);
	var isDisplay = document.getElementById('SIIframeID').style.display;
	if((cookieval == null || cookieval == 'false' )&& isDisplay =='none'){
		afterResetSI();
	}
}
function SetTaskCategory(categoryId){
	var categoryNameId = getCategoryNameId();
	if(categoryId != null && categoryId != ''){
		taskCategory  = document.getElementById(categoryNameId).value;
	}
}
function preAssignTaskTOStaff(saveId){
	waitbox(0);
	assignTaskTOStaff(saveId);
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange(null);
	}	
}
function preAssignTaskTOSuggestedStaff(saveId){
	waitbox(0);
	if(selectedModuleName == 'queue'){
		assignTaskTOQueue(saveId);
	}else{
		assignTaskTOSuggestedStaff(saveId);
	}
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange(null);
	}

}
function preAssignTaskTOQueue(queueId){
	waitbox(0);
	assignTaskTOQueue(queueId);
	if(queueId!=null && queueId!='undefined' && queueId != '')
	{
		handleChange(null);
	}
}
function getClientTypeAndRecordId(){
	if(document.getElementById(userId) != null)
		recId = document.getElementById(userId).value;
	 clientType = 'User';
	 if(recId == ''){
		if(document.getElementById(contactId) != null)
			recId = document.getElementById(contactId).value;
		clientType = 'Contact';
	 }
	 if(recId == ''){
		if(document.getElementById(leadId) != null)
			recId = document.getElementById(leadId).value;
		clientType = 'Lead';
	 }
}

function showClientDetails(eventObject){
	var target=eventObject.target;
	if(target == null) 
		target = eventObject.srcElement; 
	getClientTypeAndRecordId();
	 var tooltipHtmlResult = '';
	 if(!remoteCallFlag && recId != ''){
		remoteCallFlag = true;
		eval(orgNamespace).ClientInfo.getClientInfo( recId, clientType, accName, function(result, event){
			if(event.status) {
				tooltipHtmlResult = '';
				if(result != '' && result != null){
					var fieldLabels = result['oblectFieldLabels'];
					var fieldDisplayLabels = result['displayFieldLabels'];
					tooltipHtmlResult = '<table cellpadding=4 cellspacing=3 border=0 width="290" style="table-layout:fixed; font-size:11px;">';
					var fieldListArray = fieldLabels.split(';'); 
					var fieldDisplayArray = fieldDisplayLabels.split(';'); 
					var i=0;
					for(i=0; i<fieldListArray.length-1;i++){
						if(result[fieldListArray[i]] != undefined){
							if(fieldListArray[i] == 'Name'){
								tooltipHtmlResult +='<tr><td width="40%" style="font-weight:bold; word-wrap:break-word;">'+fieldDisplayArray[i]+'</td><td style="white-space:normal; font-weight:bold; word-wrap:break-word;">' + result[fieldListArray[i]] + '</td></tr>';
							} else {
								if(fieldListArray[i] == 'Email'){
									tooltipHtmlResult +='<tr><td style="font-weight:bold; word-wrap:break-word;" >' + fieldDisplayArray[i] + '</td><td style="word-wrap:break-word;" class="clsCmdLinkTooltip">' + result[fieldListArray[i]] +'</td></tr>';
								} else {							
									tooltipHtmlResult +='<tr><td style="font-weight:bold; word-wrap:break-word;" >' + fieldDisplayArray[i] + '</td><td style="word-wrap:break-word;">' + result[fieldListArray[i]] + '</td></tr>';
								}
							}
						}
					}
					tooltipHtmlResult += '</table>';
					tooltipforclient = new Ext.QuickTip({
						target: target.id,
						anchor: 'left',
						width:Ext.isIE ? Ext.isIE7 ? 305:295:308,
						trackMouse: false,
						bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
						hideDelay:3000,
						dismissDelay: 5000,
						html: tooltipHtmlResult //document.getElementById('clientTooltipDiv').innerHTML
					 });   
					 
				Ext.sequence(Ext.QuickTip.prototype, 'afterRender', function () {
					this.mon(this.el, 'mouseover', function () {
						this.clearTimer('hide');
						this.clearTimer('dismiss');
					}, this);
				
					this.mon(this.el, 'mouseout', function () {
						this.clearTimer('show');
						if (this.autoHide !== false) {
							this.delayHide();
						}
					}, this);
				}); 

					tooltipforclient.show();
				  }           			
			} else if (event.type === 'exception') {    
				alert(event.message);
			}
		}, {escape:true});
	} else {
		if(tooltipforclient != null){
			tooltipforclient.show();
		}
	}            			
}
function getCustomActionURL(customId){
	var taskId = getTaskId();
	eval(orgNamespace).JSRemoteActions.getCustomActionURL( 'Task', taskId,customId, function(result, event){
		if(event.status) {
			if(result != '' && result != null){
				urlStringVar = result;
				openUrl();
			  }           			
		} else if (event.type === 'exception') {    
			Ext.Msg.alert('', event.message);
		}			
	}, {escape:true});
}
function OpenRecord(pageName){
	var parentWid = getWID();
	var id;
	var moduleName = getModuleName();
	var target;
			
	if (pageName == 'IncidentPage') {
		id = getIncId();
		getIncNameEle().style.color = '#800080'; 
		target = pageName+escape('?id='+id+'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true&columnField=name&direction=DESC');
		if(id != null && id != 'undefined' && typeof(id) != 'undefined'){
			window.parent.parent.addNewTab(pageName, labelIncidentPlural, "NavigatorPage?title="+ getIncidentName() + "&tabTitle=" + getIncidentName() + "&target=" + target);
		}
	}else if (pageName == 'ChangeRequestPage'){
		id = getCRId();
		getCRNameEle().style.color = '#800080';
		target = pageName+escape('?id='+id+'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true&columnField=name&direction=DESC');
		if(id != null && id != 'undefined' && typeof(id) != 'undefined'){
			window.parent.parent.addNewTab(pageName, labelCRPlural, "NavigatorPage?title="+ getCRName() + "&tabTitle=" + getCRName() + "&target=" + target);
		}
	}else if (pageName == 'ProblemPage'){
		id = getProblemId();
		getProblemNameEle().style.color = '#800080';
		target = pageName+escape('?id='+id+'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true&columnField=name&direction=DESC');
		if(id != null && id != 'undefined' && typeof(id) != 'undefined'){
			window.parent.parent.addNewTab(pageName, labelProblemPlural, "NavigatorPage?title="+ getProblemName() + "&tabTitle=" + getProblemName() + "&target=" + target);
		}
	}
}
function hideIncChangeProbEle(){
	var incEle = document.getElementById('incidentEle');
	if(displayIncEle && incEle != null){
		incEle.style.display = 'none';
	}
	var changeEle = document.getElementById('changeEle');
	if(displayChangeEle && changeEle != null){
		changeEle.style.display = 'none';
	}
	var problemEle = document.getElementById('problemEle');
	if(displayProblemEle && problemEle != null){
		problemEle.style.display = 'none';
	}
}
function getApplyTemplate(saveedState)
{
	if(taskId != null && taskId != ''){
		if(setcheckboxvalueforTemplate == 'true'){	
			return (saveedState);
		}	
		else{
			return true;
		}
	}
return true;
}
function composeMailOnCompleteIn(){
var isDisplay = document.getElementById('SIIframeID').style.display;
	if(window.frames.SIIframeID != null && typeof(window.frames.SIIframeID) != 'undefined'){
		if(isDisplay != 'none'){
			document.getElementById('SIIframeID').contentWindow.composeMailOnComplete();
		}
	}
}
function refreshDesc(){
	var descid = document.getElementById("task_taskDescription__c");
	if(descid != null && typeof(descid)!='undefined'){
		descid.value = taskDesc;
		descid.nextSibling.value = taskDesc;
	}
}
function refreshResolution(){
	var resoid = document.getElementById("task_taskResolution__c");
	if(resoid != null && typeof(resoid)!='undefined'){
		resoid.value = taskResolution;
		resoid.nextSibling.value = taskResolution;
	}
}