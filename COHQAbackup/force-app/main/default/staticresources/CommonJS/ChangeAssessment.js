var AssessmentId,
	inactiveChkBox,
	errormsg,
	idset,
	windownameflag =0,
	startTime = new Date(),
	networklatencystart = '',
	networklatency = '',
	windowloaddate = '',
	taboutFlag = false;

var clickedOnce = false;  
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
function ShowCIExplorerJS(title, lblCIExplorer) {
	var linkci = escape('CIExplorerLauncher?Module=Change_Request__c&RecordSequence=' + ChangeRequestid + '&id='+ ChangeRequestid );
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
	window.parent.parent.addNewTab('CIExplorerLauncher', lblCIExplorer, url );
}

function senddata(){return data;}
    
Ext.onReady(function()
{

	windowloaddate = new Date();
	networklatencystart = windowloaddate.getTime();
	networklatency = networklatencystart - networkstart;
	Ext.QuickTips.init();
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.UserPhone).readOnly=true;
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.UserExtension).readOnly=true;
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.AssessmentCompletionDate).readOnly=true;
	
	function SaveBtnHandler(){
		if(!inProgress){
			inactiveChkBox = Ext.getCmp('change_assessment_inactive').getValue();
			var assessorId = document.getElementById(ChangeAssessmentPageComp.ComponentVars.Username);
			if(assessorId != null){
				if(assessorId.value.trim() == ''){
					showMsg('', ChangeAssessmentPage.Labels.AssessorIDError);
					return;                 
				}
			}
			var BenefitsData = document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).value.trim();
			var CommentData = document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).value.trim();
			if(CommentData.length > 32000){
				showMsg('', ChangeAssessmentPage.Labels.TextCommentsOverflow);
				return;           
			}
			
			if(BenefitsData.length > 255){
				showMsg('', ChangeAssessmentPage.Labels.TextBenefitsOfChangeOverflow);
				return;
			}
			Ext.getCmp('saveId').setDisabled(true);
			waitbox(0);	
			saveAssessment(inactiveChkBox);         
		}
	}

	function CopyBtnHandler(){
		callCopyPage();
	}   
	
	function ResetBtnHandler(){
		resetAssessment();
	}
	 
	function PreviuosBtnHandler(){
		if(document.getElementById('prevId').disabled!=true){
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
			previousAssessmentBtnHandler(idSetString);		
		}
	}
	
	function NextBtnHandler(){
		if(document.getElementById('nextId').disabled!=true){	
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
			nextAssessmentBtnHandler(idSetString);
		}
	}
				
	var SamplePanel = Ext.extend(Ext.Panel, {
		renderTo: 'btnToolbar',
		defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
	});
	
	new SamplePanel({
		title: '',
		cls:'toolSpCls',
		bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
		tbar: [{
			scale: 'medium',
			iconCls: 'bmcSave',
			tooltipType : 'title',
			tooltip: ChangeAssessmentPage.Labels.Save,
			id:'saveId',
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
			iconCls: 'bmcCopy',
			tooltipType : 'title',
			tooltip: ChangeAssessmentPage.Labels.Copy,
			id:'copyId',
			listeners: {
				mouseover: function(){
					this.setIconClass('bmcCopyOn');    
				},
				mouseout: function(){
					this.setIconClass('bmcCopy');          
				}
			},
			handler:CopyBtnHandler
		},' ','-',' ',{
			scale: 'medium',
			iconCls: 'bmcDelete',
			tooltipType : 'title',
			tooltip: ChangeAssessmentPage.Labels.Delete,
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
			iconCls: 'bmcReset',
			tooltipType : 'title',
			tooltip: ChangeAssessmentPage.Labels.Reset,
			id:'resetId',
			listeners: { 
			   mouseover: function(){
				  this.setIconClass('bmcResetOn');    
			   },
			   mouseout: function(){
				   this.setIconClass('bmcReset');          
			   }
			},
			handler:ResetBtnHandler                
		  
		},' ','-',' ',{
			scale: 'medium',
			iconCls: 'bmcCIExplorer',
			tooltipType : 'title',
			tooltip: ChangeAssessmentPage.Labels.LaunchCIExplorer,
			id:'CIExpId',
			listeners: {
			   mouseover: function(){
				  this.setIconClass('bmcCIExplorerOn');    
			   },
			   mouseout: function(){
				   this.setIconClass('bmcCIExplorer');          
			   }
			},
			handler:ShowCIExplorer                
		  
		},new Ext.Toolbar.Fill(),{
		   id :'change_assessment_inactive',
		   xtype  : 'checkbox',
		   width  : 93,
		   align:'top',
		   checked: false,
		   boxLabel:ChangeAssessmentPage.Labels.Inactive,
		   cls:'chkStyle',
		   boxLabel:'<span class="checkboxLabelCls">'+ChangeAssessmentPage.Labels.Inactive+'</span>'
		},{
			xtype : 'box',
			id    : 'prevId',
			autoEl:  {tag: 'img', 
					 src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif'),   
					 title:ChangeAssessmentPage.Labels.PreviousRecord
					 },                          
			cls:'cursorCls',
			listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
		},{               
			xtype : 'box',
			id    : 'nextId',
			autoEl:  {tag: 'img', 
					  src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
					  title:ChangeAssessmentPage.Labels.NextRecord
					 },
			cls:'cursorSpaceCls',
			listeners : { render: function(f){f.el.on('click', NextBtnHandler);}}
		}] 
	});

	new Ext.ToolTip({
		target: 'change_assessment_inactive',			
		anchor: 'left',			
		html: ChangeAssessmentPage.Labels.InactiveTooltip					  
	});
	
	Ext.getCmp('change_assessment_inactive').setValue(getInactiveChkBox());
	AssessmentId = getChangeAssessmentID();
	inactiveChkBox = getInactiveChkBox();
	wid = getWID();
	if(isRecordDeleted()) 
	{
		Ext.Msg.alert(ChangeAssessmentPage.Labels.Information,ChangeAssessmentPage.Labels.DeletedRecord, function(){
		if((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!= 'undefined'))
			window.parent.popUpWindow.close();
		closeWindow();
		});
	} else {
		if(getNoRightsToViewEdit()){
			Ext.Msg.alert('', ChangeAssessmentPage.Labels.MsgNoAccessPerm, function(){
			if ((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!='undefined'))
				window.parent.popUpWindow.close();
			closeWindow();	
			});
		}	
	}
	
	var CIFlag = 1, CAFlag = 1;
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.display = 'none';
	
	var changeInformationPanel = new Ext.Panel({
		header : true,
		id:'infopanel',
		title: ChangeAssessmentPage.Labels.ChangeInformation,
		renderTo: 'changeAssessmentInfoDiv',
		height:250,
		width : '100%',
		contentEl:'changeAssessmentComponent',
		labelStyle : 'clsRowBlueBgPanel',
		border : false,
		collapsible : true,
		collapsed : false,
		listeners: {
			expand:function(c){
				if(CIFlag == 0 && CAFlag == 1){
					Ext.getCmp('infopanel').setHeight(250);
					Ext.getCmp('assessmentpanel').setHeight(250);
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.height = 90+"px";
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.height = 90+"px";
					changeTextareaHeight("75px");
				} else if(CIFlag == 0 && CAFlag == 0){
					Ext.getCmp('infopanel').setHeight(480);
					changeTextareaHeight("315px");
				}
				CIFlag = 1;             
			},
			collapse:function(c){
				if(CIFlag == 1 && CAFlag == 1){
					Ext.getCmp('assessmentpanel').setHeight(480);
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.height = 320+"px";
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.height = 320+"px";
				} 
				CIFlag = 0;
			}
		}
	}); 
	
	var changeAssessmentPanel = new Ext.Panel({
		header : true,
		id:'assessmentpanel',
		title: ChangeAssessmentPage.Labels.ChangeAssessment,
		renderTo: 'changeAssessmentInfoDiv',
		width : '100%',
		height:250,
		contentEl:'assessmentInfo',
		labelStyle : 'clsRowBlueBgPanel',
		border : false,
		collapsible : true,
		collapsed : false,
		listeners: {
			expand:function(c){
				if(CIFlag == 1 && CAFlag == 0){
					Ext.getCmp('assessmentpanel').setHeight(250);
					Ext.getCmp('infopanel').setHeight(250);                        
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.height = 90+"px";
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.height = 90+"px";
					changeTextareaHeight("75px");
				}else if(CIFlag == 0 && CAFlag == 0){
					Ext.getCmp('assessmentpanel').setHeight(480);
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.height = 320+"px";
					document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.height = 320+"px";
				}
				CAFlag = 1;
			},
			collapse:function(c){
				if(CIFlag == 1 && CAFlag == 1){
					Ext.getCmp('infopanel').setHeight(480);
					changeTextareaHeight("315px");
				}
				CAFlag = 0; 
			}
	}       
 });  

 buttonValidator();
 
 if(!getEnableDeleteCopyBtn()){
	/*document.getElementById(ChangeAssessmentPageComp.ComponentVars.Username).readOnly=true;
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.FirstName).readOnly=true;
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.LastName).readOnly=true;       
	document.getElementById('AssessorLastNameLookup_Id').disabled=true;     
	document.getElementById('AssessorFirstNameLookup_Id').disabled=true;     
	document.getElementById('AssessorIDLookup_Id').disabled=true;     
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.Username).className='clsIdInputTextBoxReadOnly';
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.FirstName).className='clsIdInputTextBoxReadOnly';
	document.getElementById(ChangeAssessmentPageComp.ComponentVars.LastName).className='clsIdInputTextBoxReadOnly';   */
	}

	checkIDSet();
	handleElemEvent();
	var pageloadstartdate = new Date() ;
	var t1 = pageloadstartdate.getTime();
	var pagerendertime =(t1 - networklatencystart);
	data +=ChangeAssessmentPage.Labels.PM_netwokLatency;
    data +=networklatency; 
    data += '<br>';
	data += ChangeAssessmentPage.Labels.PM_PageLoad;
    data += pagerendertime;	
});

var DeleteBtnHandler = function(button,event) {                                                            
	 Ext.MessageBox.confirm(ChangeAssessmentPage.Labels.Delete, ChangeAssessmentPage.Labels.DeleteIncidentPage, function(btn){
		 if(btn === 'yes'){
			deleteChangeAssesmentRecord();
		 }
	 });
};
	
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
	   }else{
		   showalldata(event);
	   }               
   }else{
	   if(typeof(onCompleteFunction)!='undefined'){
		   onCompleteFunction();
	   }
   }
}    

function callCopyPage(){
	//alert(AssessmentId);
	window.parent.addTab("ChangeAssessmentPage?copyId=" + AssessmentId,ChangeAssessmentPage.Labels.ChangeAssessment,ChangeAssessmentPage.Labels.ChangeAssessment);
} 
	
function assignBenefitsOrCommentsValue(type){
	if(type == 'BenefitsOfChange'){
		document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.display = 'none';
		document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.display = '';
		document.getElementById('BenefitsOfChange').className="clickedButton";
		document.getElementById('Comment').className="AddButton";
	} else if(type == 'Comment'){
		document.getElementById(ChangeAssessmentPageComp.ComponentVars.BenefitsOfChange).style.display = 'none';
		document.getElementById(ChangeAssessmentPageComp.ComponentVars.Comments).style.display = '';
		document.getElementById('BenefitsOfChange').className="AddButton";
		document.getElementById('Comment').className="clickedButton";       
	}
}
	
function userInfoComplete(){
	//inProgress = false;
	//alert('userInfoComplete');
}   
	
function showMsg(msgtitle, msg){
	Ext.MessageBox.show({
		width: 250,
		title: msgtitle,
		msg: msg,
		buttons: Ext.MessageBox.OK
	});         
}        
	
function closeWindow(){
	window.parent.refreshList();
	window.parent.closeTab(wid);    
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

function buttonValidator(){
	if(AssessmentId == null || AssessmentId == ''){
		Ext.getCmp('deleteId').setDisabled(true);
		Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
		Ext.getCmp('copyId').setDisabled(true);         
		Ext.getCmp('resetId').setDisabled(true);
		Ext.getCmp('prevId').setDisabled(true);
		Ext.getCmp('nextId').setDisabled(true);  
		Ext.getCmp('saveId').setDisabled(false);          
		
		if(getEnableCILinkBtn()){
			Ext.getCmp('CIExpId').setDisabled(false);
		} else {
			Ext.getCmp('CIExpId').setDisabled(true);
			Ext.getCmp('CIExpId').setIconClass('bmcCIExplorerDisable');
		}
	 } else {
		if(getEnableDeleteCopyBtn()){
			Ext.getCmp('deleteId').setDisabled(false);
			Ext.getCmp('deleteId').setIconClass('bmcDelete');
			//Ext.getCmp('copyId').setDisabled(false);                    
		} else {
			Ext.getCmp('deleteId').setDisabled(true);
			Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
			//Ext.getCmp('copyId').setDisabled(true);                            
		}
		if(getEnableCopyBtn()){
			Ext.getCmp('copyId').setDisabled(false);                    
		} else {
			Ext.getCmp('copyId').setDisabled(true);                            
		}
		
		if(getEnableSaveBtn()){
			Ext.getCmp('saveId').setDisabled(false);
		} else {
			Ext.getCmp('saveId').setDisabled(true);        
		}
		
		if(getEnableCILinkBtn()){
			Ext.getCmp('CIExpId').setDisabled(false);
		} else {
			Ext.getCmp('CIExpId').setDisabled(true);
			Ext.getCmp('CIExpId').setIconClass('bmcCIExplorerDisable');
		}
		Ext.getCmp('resetId').setDisabled(false);
		Ext.getCmp('prevId').setDisabled(false);
		Ext.getCmp('nextId').setDisabled(false);        
	 } 
	 document.getElementById(ChangeAssessmentPageComp.ComponentVars.AssessmentCompletionDate).readOnly=true;
}
function enableSaveButton()
{
	if(getEnableSaveBtn()){
		Ext.getCmp('saveId').setDisabled(false);          
	} 
}