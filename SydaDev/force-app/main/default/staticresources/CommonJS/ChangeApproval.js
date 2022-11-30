var clickedOnce = false;
var idset;
var networklatency = '';
var emailFlag = '';
var CIFlag = 1, CAFlag = 1;
function handleChange(){
	if(!clickedOnce){
		clickedOnce = true;
		window.parent.registerChange(wid);
	}
}
		
function handleResetChange(){
	if(clickedOnce){
		clickedOnce = false;
		window.parent.registerSave(wid);
	}
}

function NextBtnHandler(){
	if(document.getElementById('nextId').disabled!=true){
		var idSetString='';
		var i=0;
		if(idset.length > 0){
			idSetString = idset;
		}
		nextApprovalBtnHandler(idSetString);
	}        
}

function PreviousBtnHandler(){
	if(document.getElementById('prevId').disabled!=true){
		var idSetString='';
		var i=0;
		if(idset.length > 0){
			idSetString = idset;
		}
		previousApprovalBtnHandler(idSetString);
	}        
}

Ext.onReady(function(){
	//Performance Metrics
	windowloaddate = new Date();
	networklatencystart = windowloaddate.getTime();
	networklatency = networklatencystart - networkstart;
	data += ChangeApprovalPage.Labels.NetwokLatency;
	data += networklatency; 
	data += '<br>';

	Ext.QuickTips.init();
	
	var ApproveBtnHandler = function(button,event){ 
		window.parent.ApprovalNeedsRefresh = true;
		var action = 'Approve';
		ApproveChange(action);
	}
	var RejectBtnHandler = function(button,event){ 
		window.parent.ApprovalNeedsRefresh = true;
		var action = 'Reject';
		RejectChange(action);
	}
			
	var SamplePanel = Ext.extend(Ext.Panel, {
		renderTo: 'CAToolBarTD',
		defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
	});
	
	new SamplePanel({
		title: '',
		cls:'toolSpCls',
		bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
		tbar: [{
			scale: 'medium',
			iconCls: 'bmcApprove',
			tooltipType : 'title',
			tooltip: ChangeApprovalPage.Labels.Approve,
			id:'approveId',
			handler: ApproveBtnHandler
		},' ',{
				scale: 'medium',
				iconCls: 'bmcReject',
				tooltipType : 'title',
				tooltip: ChangeApprovalPage.Labels.Reject,
				id:'rejectId',
				handler: RejectBtnHandler
			   
		},' ','-',' ',{
			scale: 'medium',
			iconCls: 'bmcCIExplorer',
			tooltipType : 'title',
			tooltip: ChangeApprovalPage.Labels.LaunchCIExplorer,
			id:'CIExpId',
			listeners: {
			   mouseover: function(){
				  this.setIconClass('bmcCIExplorerOn');    
			   },
			   mouseout: function(){
				   this.setIconClass('bmcCIExplorer');          
			   }
			},
			handler: ShowCIExplorer               
		  
		},new Ext.Toolbar.Fill(),{
			xtype : 'box',
			id    : 'prevId',
			autoEl:  {tag: 'img', 
					 src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif'),   
					 title: ChangeApprovalPage.Labels.PreviousRecord
					 },                          
			cls:'cursorCls',
			listeners : { 
				render: function(f){f.el.on('click', PreviousBtnHandler);}
			}
		},{              
			xtype : 'box',
			id    : 'nextId',
			autoEl:  {tag: 'img', 
					  src: getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
					  title: ChangeApprovalPage.Labels.NextRecord },
			cls:'cursorSpaceCls',
			listeners : { 
				render: function(f){f.el.on('click', NextBtnHandler)}
			}
		}]
	});
	
	 var approverInformationPanel = new Ext.Panel({
		header : true,
		id:'approverInformationPanel',
		title: ChangeApprovalPage.Labels.ApproverInformation,
		renderTo: 'ApproverInformationDiv',
		height: 130,
		width : '100%',
		contentEl:'ApproverInfoPanel',
		labelStyle : 'clsRowBlueBgPanel',
		border : false,
		collapsible : true,
		collapsed : true
		
	});  
 
	getIncidentInformationPanel();
	
	var changeApprovalPanel = new Ext.Panel({
		header : true,
		id:'approvalpanel',
		title: ChangeApprovalPage.Labels.ChangeRequestApproval,
		renderTo: 'changeApprovalInfoDiv1',
		width : '100%',
		contentEl:'approvalInfo',
		labelStyle : 'clsRowBlueBgPanel',
		border : false,
		collapsible : true,
		collapsed : false,
		listeners: {
			expand:function(c){
				if(CIFlag == 1 && CAFlag == 0){
					Ext.getCmp('approvalpanel').setHeight(150);
					Ext.getCmp('infopanelInc').setHeight(250);					
					document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).style.height = 85+"px";
					changeTextareaHeight("85px");
				}else if(CIFlag == 0 && CAFlag == 0){
					Ext.getCmp('approvalpanel').setHeight(380);
					document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).style.height = 315+"px";                        
				}
				CAFlag = 1;
			},
			collapse:function(c){
				if(CIFlag == 1 && CAFlag == 1){
				Ext.getCmp('infopanelInc').setHeight(480);				
				changeTextareaHeight("310px");
				}
				CAFlag = 0; 
			}
		}      
	});
	
	if(recordType=='Incident__c'){			
		changeApprovalPanel.setTitle(ChangeApprovalPage.Labels.IncidentApproval);	
	}
	if(recordType=='Change_Request__c'){	
				Ext.getCmp('infopanelInc').setTitle(ChangeApprovalPage.Labels.ChangeRequestInformation);			
			}
	
	
	var actionButtonPanel = new Ext.Panel({
		id: 'actionButtonPanel',
		title: '',
		renderTo: 'actionButtonsDiv',
		width : '100%',
		border : false,
		items:[{
			id: 'approveBtn',
			xtype: 'tbbutton',
			cls: 'bgBtnGrey',
			icon: getSDFStylesResPath() + '/SDEFicons/icon_approve_change.png',
			text: ChangeApprovalPage.Labels.Approve,
			tooltip: ChangeApprovalPage.Labels.Approve,
			tooltipType: 'title',
			handler: ApproveBtnHandler
		},
		{
			id: 'rejectBtn',
			xtype: 'tbbutton',
			cls: 'bgBtnGrey',
			icon: getSDFStylesResPath() + '/SDEFicons/icon_reject_change.png',
			text: ChangeApprovalPage.Labels.Reject,
			tooltip: ChangeApprovalPage.Labels.Reject,
			tooltipType: 'title',
			handler: RejectBtnHandler
		}]
	});
	
	applyPermissions();
	emailFlag = getEmailLinkFlag();
	if(emailFlag != 'true'){
		checkIDSet();
		handleElemEvent();
	}	
	
	//Page-load time
	data += ChangeApprovalPage.Labels.PageLoad;
	var pageloadstartdate = new Date() ; 
	var time1 = pageloadstartdate.getTime();	
	var pagerendertime =(time1 - networklatencystart);
	
	data += pagerendertime;
});



function getIncidentInformationPanel(){
                componentFlag=1;
				renderUI();
				var incidentInformationPanel = new Ext.Panel({
					header : true,
					id:'infopanelInc',
					title: ChangeApprovalPage.Labels.IncidentApproveInformation,
					renderTo: 'changeApprovalInfoDiv',
					height:265,
					width : '100%',		
					labelStyle : 'clsRowBlueBgPanel',
					border : false,
					contentEl:ChangeApprovalPageComp.ComponentVars.incidentInformation,
					collapsible : true,
					collapsed : false,
					listeners: {
						expand:function(c){
						
							if(CIFlag == 0 && CAFlag == 1){
								Ext.getCmp('infopanelInc').setHeight(265);
								Ext.getCmp('approvalpanel').setHeight(150);
								document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).style.height = 85+"px";
								changeTextareaHeight("85px");
							} else if(CIFlag == 0 && CAFlag == 0){
								Ext.getCmp('infopanelInc').setHeight(480);
								changeTextareaHeight("310px");
							}
							CIFlag = 1;                
						},
						collapse:function(c){
							if(CIFlag == 1 && CAFlag == 1){
								Ext.getCmp('approvalpanel').setHeight(380);
								document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).style.height = 315+"px";
							} 
							CIFlag = 0;
						}
					}
					
				}); 
	
}

function applyPermissions(){
	var flag = getPermission();
	if(flag == 'true'){
		Ext.getCmp('approveBtn').enable();
		Ext.getCmp('rejectBtn').enable();
		Ext.getCmp('approveId').enable();
		Ext.getCmp('rejectId').enable();
		//Ext.getCmp('approveId').setIconClass('bmcApprove');
		//Ext.getCmp('rejectId').setIconClass('bmcReject');
		document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).readonly = false;
		
	}else{
		Ext.getCmp('approveBtn').disable();
		Ext.getCmp('rejectBtn').disable();
		Ext.getCmp('approveId').disable();
		Ext.getCmp('rejectId').disable();
		Ext.getCmp('approveId').setIconClass('bmcApproveDisable');
		Ext.getCmp('rejectId').setIconClass('bmcRejectDisable');
		document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).readOnly = true;
		document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).className = 'clsCommentsInputTextAreaReadOnly';
	}
	//For CI Explorer Button
	if(getEnableCILinkBtn()){
		Ext.getCmp('CIExpId').setDisabled(false);
		Ext.getCmp('CIExpId').setIconClass('bmcCIExplorer');
	} else {
		Ext.getCmp('CIExpId').setDisabled(true);
		Ext.getCmp('CIExpId').setIconClass('bmcCIExplorerDisable');
	}
	document.getElementById(ChangeApprovalPageComp.ComponentVars.LastName).readOnly = true;
	document.getElementById(ChangeApprovalPageComp.ComponentVars.FirstName).readOnly = true;
	document.getElementById(ChangeApprovalPageComp.ComponentVars.Phone).readOnly = true;
	document.getElementById(ChangeApprovalPageComp.ComponentVars.Extension).readOnly = true;
	document.getElementById(ChangeApprovalPageComp.ComponentVars.Approver).readOnly = true;
	document.getElementById(ChangeApprovalPageComp.ComponentVars.Queue).readOnly = true;
	//Display BMC title if opened from email link
	emailFlag = getEmailLinkFlag();
	if(emailFlag == 'true'){
		Ext.getCmp('CIExpId').setDisabled(true);
		Ext.getCmp('CIExpId').setIconClass('bmcCIExplorerDisable');
		Ext.getCmp('nextId').setDisabled(true);
		Ext.getCmp('prevId').setDisabled(true);
	}
	/* To Disable Next-Prev buttons if record opened fron SI*/
	var nFlag = getNavFlag();
	if(nFlag == 'TRUE'){
		Ext.getCmp('prevId').setDisabled(false);
		Ext.getCmp('nextId').setDisabled(false);
	}else{
		Ext.getCmp('prevId').setDisabled(true);
		Ext.getCmp('nextId').setDisabled(true);
	}	
	
}

function ShowCIExplorerJS(title, lblCIExplorer) {
	var linkci,url;
	if(recordType=='Change_Request__c'){
		linkci= escape('CIExplorerLauncher?Module=Change_Request__c&RecordSequence=' + ChangeRequestid + '&id='+ ChangeRequestid );
		url = "NavigatorPage?title="+ title +"&target=" + linkci;
		window.parent.parent.addNewTab('CIExplorerLauncher', lblCIExplorer, url );
	}
	if(recordType=='Incident__c'){
		linkci = escape('CIExplorerLauncher?Module=Incident__c&RecordSequence=' + ChangeRequestid + '&id='+ ChangeRequestid );
		url = "NavigatorPage?title="+ title +"&target=" + linkci;
		window.parent.parent.addNewTab('CIExplorerLauncher', lblCIExplorer, url );
	}
}

function closeWindow(){
	if(emailFlag == 'true'){
		Ext.getCmp('approveBtn').disable();
		Ext.getCmp('rejectBtn').disable();
		Ext.getCmp('approveId').disable();
		Ext.getCmp('rejectId').disable();
		Ext.getCmp('approveId').setIconClass('bmcApproveDisable');
		Ext.getCmp('rejectId').setIconClass('bmcRejectDisable');
		document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).readOnly = true;
		document.getElementById(ChangeApprovalPageComp.ComponentVars.ApproverComments).className = 'clsCommentsInputTextAreaReadOnly';
	}else{
		window.parent.refreshList();
		window.parent.closeTab(wid);    
	}
	
}