var objName;
var idset;
var ownerIdString;
var duration=0,
	insideNote= false,
	clickedOnce = false,
	changeDone = false,
	networklatencystart = '',
	startTime = new Date(),
	windowloaddate = '',
	networklatency = '',
	isDormantSection=false,
	isNoteEnableFlag=true,
	hideCustomFieldAccordion=true,
	closedStageName,
	durationError=0;	
	document.onclick = activateWindow; 
	
var resizeGrid= function resizeGrid(){
	if(Ext.getCmp('southPanelSI')!=undefined)
 		Ext.getCmp('southPanelSI').setWidth(Ext.getCmp('southPanelSI').getWidth());
};
var NewBtnHandler = function(){ 
	openPage("ChangeRequestPageCustom",ChangeRequestHeader,ChangeRequestHeader); activeAllWindowFlag=false;
	activeAllWindowFlag=false;
}
function OpenHelpUrl(link){
	if(link.toLowerCase().indexOf('changerequestservicetarget') != -1)
	{
		OpenHelppage('ServiceTransaction','module','form');
	}
	else if(link.toLowerCase().indexOf('composeemailpage') != -1)
	{
		OpenHelppage('EmailConversationChange','module','form');
	}
}
var SaveBtnHandler = function(){
    if(!inProgress){
		var changeDescriptionData = document.getElementById(changeDescriptionComponent).value;
		var rolloutComponentData = document.getElementById(rolloutComponent).value.trim();
		var backoutComponentData = document.getElementById(backoutComponent).value.trim();		 
		var resonforChangeComponentData = document.getElementById(backoutComponent).value.trim();
		
		var countDescription = changeDescriptionData.length;
		if(!Ext.isIE && changeDescriptionData != null ){
							if(null != changeDescriptionData.match(/[^\n]*\n[^\n]*/gi)){
								countDescription = countDescription + changeDescriptionData.match(/[^\n]*\n[^\n]*/gi).length;
							}
						}
		
							
		if(countDescription> 32000 ){
			Ext.MessageBox.show({ msg: labelChangeDescription + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}		
		if(rolloutComponentData.length > 255){
			Ext.MessageBox.show({ msg: labelRolloutPlan + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}
		if(backoutComponentData.length > 255){
			Ext.MessageBox.show({ msg: labelBackoutPlan + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}
		if(resonforChangeComponentData.length > 255 ){
			Ext.MessageBox.show({ msg: labelReasonForChange + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}
		
		var validate = ValidateForm(); 
		if(validate == true)
		{
			Ext.getCmp('saveId').setDisabled(true);
			var chkBoxValue=Ext.getCmp('change_inactive__c').getValue();
			waitbox(0);
			save(chkBoxValue); }
	}	
}
var CopyBtnHandler = function(){ callCopyPage(); activeAllWindowFlag=false;}
var DeleteBtnHandler = function(){
		Ext.MessageBox.confirm(labelDelete, DeletedRecord, function(btn){
                                                         if(btn === 'yes'){
                                                                   deleteChangeRequest();
                                                          }
														  })}
var ResetBtnHandler  = function(){resetChangeRequest();}
var CloseBtnHandler = function(button,event) {closeChangeRequest();}  
var RespondedBtnHandler = function (button,event) { window.parent.registerChange(wid);respondedBtnHandler();};
var disableTrue = function(){}

function senddata(){return data;}

Ext.onReady(function(){
	if(closedStageName == 'CLOSED' || closedStageName =='Closed'){
		
		Ext.MessageBox.show({title: Information , msg:ClosedStage, buttons: Ext.MessageBox.OK, icon: Ext.MessageBox.INFO});
	}
getapplyTemp();
disableDateField();
if(hideCustomFieldAccordion){
				document.getElementById(ChangePageComp.ComponentVars.customFieldAccordionPanelId).style.display = 'none';
			}
		windowloaddate = new Date();
		networklatencystart = windowloaddate.getTime();
		networklatency = networklatencystart - networkstart;
		Ext.QuickTips.init();
		createControlMap();
		renderElementsByType(); 
			var SamplePanel = Ext.extend(Ext.Panel, {
			renderTo: 'btnToolbar',
			defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
		});
		
	var AssignToStaffHandler = function(button,event){
		openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true',preAssignChangeTOStaff);
	}
	
	var AssignToQueueHandler = function(button,event) {
		openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Change_Request__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), preAssignChangeTOQueue);
	};
	
	var AssignToMyselfHandler = function(button,event){
		waitbox(0);
		assignTOMyself();
		handleChange();
	}
	var AssignToMemberOfHandler = function(button,event){
		openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("profileid='"+profileId+"' And IsStaffUser__c=true")+'&isAssignTo=true',preAssignChangeTOStaff);
	}

	var ReopenBtnHandler = function(button,event) {reopenChange();}
	
	var TemplateBtnHandler = function (button, event){
            var templateBtn = Ext.getCmp('templateBtnId');
			if (changeId != null && changeId !='' && overwrite =='true') {
				Ext.MessageBox.confirm('',OverwriteWarning, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Change Request'"),fetchChangeTemplates)
					}
				  });
			}  
			else if((changeId != null && changeId !='' && overwrite =='false'&& changeDone == true) || (changeId == null||changeId =='' && overwrite =='false'&& templateBtn.disabled == false && changeDone == true)) {
			    Ext.MessageBox.confirm('',replaceUnsaved, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Change Request'"),fetchChangeTemplates)
                  }});
			}
			else
                if(templateBtn.disabled == false ){
				openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Change Request'"),fetchChangeTemplates)
				} 
			};	
		
	 var PreviousBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(previousChangeBtnHandler1);				
			} else {  if(document.getElementById('prevId').disabled!=true) 
				        previousChangeBtnHandler1();}
			}
	var NextBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(nextChangeBtnHandler1);				
			} else {  if(document.getElementById('nextId').disabled!=true) 
				        nextChangeBtnHandler1();}
			}
	var ChangeProcBtnHandler = function (button,event){ getChangeProcBtnHandler()};
    updateTitle();
	converdisabletoreadonly();
	handleElemEvent();
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
	checkIDSet(); 
	function previousChangeBtnHandler1(){
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
        previousChangeBtnHandler(idSetString);
	}	
	function nextChangeBtnHandler1(){
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
        nextChangeBtnHandler(idSetString);
	}
		
		new SamplePanel({
			id:'toolBarId',
			title: '',
			 cls:'toolSpCls',
			 bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',             
			tbar: [{
				scale: 'medium',
				iconCls: 'bmcNew',
				tooltipType : 'title',
				tooltip:labelNew,
				id:'newId',
				handler:NewBtnHandler
			 
			},' ',{
				scale: 'medium',
				iconCls: 'bmcSave',
				tooltipType : 'title',
				tooltip: labelSave,
				id:'saveId',
				handler:SaveBtnHandler
			   
			},' ',{
				scale: 'medium',
				iconCls: 'bmcCopy',
				tooltipType : 'title',
				tooltip: labelCopy,
				id:'copyId',
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
				handler:ResetBtnHandler
				
			},' ',separator,' ',{
				id:'assignToId',
				scale: 'medium',
				iconCls: 'bmcAssign1',
				tooltipType : 'title',
				tooltip: labelAssignTo,
				menu: [
				{text:labelIncidentsStaff,
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', id:'assignToStaffButtonId',
				 handler:AssignToStaffHandler
				 },				
				{text:labelIncidentMyself,
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToMyselfButtonId',
				 handler:AssignToMyselfHandler
				 },
				{text:labelIncidentMemberofProfName, id:'assignToMemberOfAdminButtonId',
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',
				 handler:AssignToMemberOfHandler
				 },
				{text:labelChangeQueue, icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'assignToQueueButtonId', 
					handler:AssignToQueueHandler
                }
				]
			},' ',{
				id:'actionId',
				scale: 'medium',
				iconCls: 'bmcAction1',
				tooltipType : 'title',
				tooltip: labelActions,
				menu: [ {text:labelIncidentClose, id:'closeButtonId', icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',handler:CloseBtnHandler},
				{text:labelReopenChange, id:'reopenButtonId',icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', handler:ReopenBtnHandler},
				{text:labelResponded, icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',id:'respondedButtonId',handler:RespondedBtnHandler},{text:Print,disabled:IsNewRecord(changeId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',   id:'printButtonId', handler:PrintBtnHandler},{ text:PrintPDF, disabled:IsNewRecord(changeId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'printPdfButtonId', handler:PrintPDFBtnHandler},'-',customActionJsonString]
	
			},' ',{
				scale:'medium',
				iconCls: 'bmcTemplate',
				tooltipType : 'title',
				tooltip:labelTemplate,
				id:'templateBtnId',
				handler:TemplateBtnHandler,
				listeners: {
						disable: function(){
							this.setIconClass('bmcTemplateDisable');    
						},
						enable: function(){
							this.setIconClass('bmcTemplate');          
						}
					}
		
			},' ',{
                scale:'medium',
                iconCls: 'bmcAPM',
                tooltipType : 'title',
                tooltip:labelChangeMgmtProcess,
                id:'changeProcButton',
                handler:ChangeProcBtnHandler
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
				} ,handler: ShowCIExplorer
			},' ', {
                    scale: 'medium',
                    iconCls: 'bmcEmailMessage',
                    tooltipType : 'title',
                    tooltip: labelEmailMessage,
                    id:'emailId',
					disabled: false,
					handler:sendEmailBtnHandler,
					listeners: {
						disable: function(){
							this.setIconClass('bmcEmailMessageDisable');    
						},
						enable: function(){
							this.setIconClass('bmcEmailMessage');          
						}
					}
			},' ', {
                    scale: 'medium',
                    iconCls: 'bmcServiceTargets',
                    tooltipType : 'title',
                    tooltip: labelServiceTargets,
                    id:'servicetargets',
					disabled: !hasServiceTargets,
					listeners: {
						disable: function(){
							this.setIconClass('bmcServiceTargetsDisable');    
						},
						enable: function(){
							this.setIconClass('bmcServiceTargets');          
						}
					},
                    handler:ServiceTargetsBtnHandler                                
            },
			new Ext.Toolbar.Fill(),
			{
				  id :'change_inactive__c',
			   xtype  : 'checkbox',
			   width  : 93,
			   color :'#004376',
			   align:'top',
			   checked: false,
			   boxLabel:'<span class="checkboxLabelCls" id="inactiveLabel">'+labelInactive+'</span>'
			}, {
			   xtype : 'box',
			   id: 'prevId', 
				autoEl:  {tag: 'img', 
						  src:getSDFStylesResPath() +'/SDEFbuttons/b_previous.gif',
						   title:labelPreviousRecord
						 },
						  
				cls:'cursorCls',
			   listeners : { render: function(f){f.el.on('click', PreviousBtnHandler);}}
							 
			},{
				xtype : 'box',
				id: 'nextId', 
				autoEl:  {tag: 'img', 
						  src:getSDFStylesResPath() +'/SDEFbuttons/b_next.gif',
						   title:labelNextRecord},
						  cls:'cursorSpaceCls',
						 listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
			   
				
			}
			
			] 
		});
		new Ext.ToolTip({
			target: 'change_inactive__c',	
			anchor: 'left',	
			html: labelTooltipChangeInactive	
		});
		document.getElementById('capsule').style.display = 'block';
	   var canvasPanel = new Ext.Panel({
			 layout:'border',
			height:Ext.isIE7 ? 670: Ext.isIE ? 674:Ext.isSafari ? 695:680,
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
					height:465, 
					cls:'northPanelCls',
																 
					region: 'center',                   
					contentEl : Ext.isIE ? 'capsule' : changeFormComponent 
					
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
					height:Ext.isIE7 ? 275: Ext.isIE ? 250:245,  // *****************************************
					minHeight:Ext.isIE ?170:200,
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
								window.frames.SIIframeID.setSouthPanelHeight(adjHeight);
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
		ChangeBtnStatus(cilink_record);

	 if(changeId  == null || changeId  == ''){
	   document.getElementById('linkSIAvailTD').style.display = 'none';
       document.getElementById('noSIAvailTD').style.display = 'block';
	}else{
		 var isCookiePresent = displaySI(cookieName, iFrameSrc);
				if(!isCookiePresent){
					if(document.getElementById('noSIAvailTD')!=null)
						document.getElementById('noSIAvailTD').style.display = 'none';
					if(document.getElementById('linkSIAvailTD')!=null)
						document.getElementById('linkSIAvailTD').style.display = 'block';
		   }
	}
	if(isRecordDeleted()) 
		{
		Ext.Msg.alert(Information,labelRecordDeleted, function(){
		if((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!= 'undefined'))
			window.parent.popUpWindow.close();
		closeWindow();
		});
	}
	changeId = getChangeId();
	ChangeCloseState = getChangeCloseState();
	assignMyselfState =  getAssignMyselfState();
	isChangeCreatable = getIsChangeCreatable();
    isChangeDeletable =getIsChangeDeletable();
	isChangeUpdateable = getisChangeUpdateable();
	if(changeId == null || changeId  == ''){
		Ext.getCmp('emailId').setDisabled(true);
        Ext.getCmp('emailId').setIconClass('bmcEmailMessageDisable');
		
		document.getElementById('linkSIAvailTD').style.display = 'none';
        document.getElementById('noSIAvailTD').style.display = 'block';
		
		Ext.getCmp('deleteId').setDisabled(true);
            Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
            Ext.getCmp('copyId').setDisabled(true);
            Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
            Ext.getCmp('prevId').setDisabled(true);
            Ext.getCmp('nextId').setDisabled(true);
            Ext.getCmp('resetId').setDisabled(true);
			Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
			Ext.getCmp('closeButtonId').setDisabled(true);
			Ext.getCmp('reopenButtonId').setDisabled(true);
			Ext.getCmp('respondedButtonId').setDisabled(true);
			
		if(isChangeCreatable != null && isChangeCreatable == 'false'){
			Ext.getCmp('saveId').setDisabled(true);
            //Ext.getCmp('saveId').setIconClass('bmcSaveDisable');	
			Ext.getCmp('newId').setDisabled(true);
			Ext.getCmp('assignToStaffButtonId').setDisabled(true);
			Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
			Ext.getCmp('templateBtnId').setDisabled(true);
			Ext.getCmp('templateBtnId').setIconClass('bmcTemplateDisable'); 
			Ext.getCmp('respondedButtonId').setDisabled(true);
			Ext.getCmp('assignToQueueButtonId').setDisabled(true);
	     	}
			
	}else{
		//For Defect 62918 : Vishal Shinde
		if(setcheckforTemplate == 'true'){
			if(ChangeCloseState == 'false')
				Ext.getCmp('templateBtnId').setDisabled(true);
			else
				Ext.getCmp('templateBtnId').setDisabled(false);
		}
		else
		{
			Ext.getCmp('templateBtnId').setDisabled(true);
		}	
	if(getAssignMyselfState() == 'true'){
	  Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
	}
	if(getChangeCloseState() == 'false'){
         Ext.getCmp('closeButtonId').setDisabled(true);
         Ext.getCmp('reopenButtonId').setDisabled(false); 
          Ext.getCmp('saveId').setDisabled(true);
        Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
		Ext.getCmp('assignToStaffButtonId').setDisabled(true);
		Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
		Ext.getCmp('assignToQueueButtonId').setDisabled(true);
		Ext.getCmp('respondedButtonId').setDisabled(true);
		Ext.getCmp('emailId').setDisabled(true);
     }
     if(getChangeCloseState() == 'true'){
         Ext.getCmp('closeButtonId').setDisabled(false);
         Ext.getCmp('reopenButtonId').setDisabled(true); 
          Ext.getCmp('saveId').setDisabled(false);
		  Ext.getCmp('respondedButtonId').setDisabled(false);
        Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
		Ext.getCmp('assignToStaffButtonId').setDisabled(false);
		Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(false);
		Ext.getCmp('assignToQueueButtonId').setDisabled(false);
		Ext.getCmp('emailId').setDisabled(false);
     }
			 if(isChangeCreatable != null && isChangeCreatable == 'false'){
				Ext.getCmp('saveId').setDisabled(true);
				//Ext.getCmp('saveId').setIconClass('bmcSaveDisable');	
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');			
				Ext.getCmp('copyId').setDisabled(true);
				Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
				Ext.getCmp('resetId').setDisabled(true);
				Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
				Ext.getCmp('closeButtonId').setDisabled(true);
				Ext.getCmp('reopenButtonId').setDisabled(true);
				Ext.getCmp('newId').setDisabled(true);
				Ext.getCmp('assignToStaffButtonId').setDisabled(true);
				Ext.getCmp('assignToQueueButtonId').setDisabled(true);
				Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
				Ext.getCmp('respondedButtonId').setDisabled(true);
				Ext.getCmp('templateBtnId').setDisabled(true);
				
			}
			 if(isChangeDeletable != null && isChangeDeletable == 'true'){
				Ext.getCmp('deleteId').setDisabled(false);
				Ext.getCmp('deleteId').setIconClass('bmcDelete');
			}
			if(isChangeDeletable != null && isChangeDeletable == 'false'){
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
			}
			if(isChangeUpdateable != null && isChangeUpdateable == 'false'){
				Ext.getCmp('saveId').setDisabled(true);
				Ext.getCmp('closeButtonId').setDisabled(true);
				Ext.getCmp('reopenButtonId').setDisabled(true);
				Ext.getCmp('assignToStaffButtonId').setDisabled(true);
				Ext.getCmp('assignToQueueButtonId').setDisabled(true);
				Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
				Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
				Ext.getCmp('respondedButtonId').setDisabled(true);
				Ext.getCmp('templateBtnId').setDisabled(true);
			}
            
	}
	

	renderAddNoteButton();
	if(typeof(getIsCopySaved) == 'function'  && getIsCopySaved()=='false'){
		var chkBoxValue=getChangeInactive();
		Ext.getCmp('saveId').setDisabled(true);
		save(chkBoxValue); 
	}
	var changeInactiveVal = getChangeInactive();	
	Ext.getCmp('change_inactive__c').setValue(changeInactiveVal);

	var pageloadstartdate = new Date() ;
	var t1 = pageloadstartdate.getTime();
	var pagerendertime =(t1 - networklatencystart);
	data +=labelPM_netwokLatency;
    data +=networklatency; 
    data += '<br>';
	data += labelPM_PageLoad;
    data += pagerendertime;	
	if(window.parent.refreshGridSI!=undefined)
		window.parent.refreshGridSI(wid,resizeGrid);
var isInactiveDisable = getInactiveDisable();
if(isInactiveDisable){
	Ext.getCmp('change_inactive__c').setDisabled(isInactiveDisable);
}
var ChatterdAccordionEle=document.getElementById(ChangePageComp.ComponentVars.ChatterdAccordionPanelId);
if(ChatterdAccordionEle!=null){
ChatterdAccordionEle.title=ChangeChatterFeed;
ChatterdAccordionEle.childNodes[0].innerHTML=Ext.util.Format.ellipsis(ChangeChatterFeed,42);
}
ChangeServiceTargetButtonState();


});

 var sendEmailBtnHandler = function (button, event){
                openPopupWithTitle('ComposeEmailPage?recordId='+getChangeId()+'&isNew=true&objectName=Change_Request__c',composeMailOnCompleteIn,labelMsgPageHeader+changeRequestName,getEmailWinHt(),getEmailWinWidth(),false);
            } 
			
function composeMailOnCompleteIn(){
var isDisplay = document.getElementById('SIIframeID').style.display;
	if(window.frames.SIIframeID != null && typeof(window.frames.SIIframeID) != 'undefined'){
		if(isDisplay != 'none'){
			document.getElementById('SIIframeID').contentWindow.composeMailOnComplete();
		}
	}
}

function preAssignChangeTOQueue(queueId){
	waitbox(0);
	assignChangeTOQueue(queueId);
	if(queueId!=null && queueId!='undefined' && queueId != '')
	{
		handleChange();
	}
}

function ChangeServiceTargetButtonState(){
  if(typeof(Ext.getCmp('servicetargets'))!='undefined' && Ext.getCmp('servicetargets')!=null)  {
	if(!hasServiceTargets){
		Ext.getCmp('servicetargets').disable();
	} else {
		Ext.getCmp('servicetargets').enable();
	}
  }
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
                        }else if(objName == 'closeComments'){
							recordId =getCloseComments();
							assignTheCommentValue();
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

function closeWindow(){
			   window.parent.refreshList();
                window.parent.closeTab(wid);
       
}
function handleResetChange(){
    if(clickedOnce){
       clickedOnce = false;
	   changeDone = false;
       window.parent.registerSave(wid2);
    }
	if(hideCustomFieldAccordion){
				document.getElementById(ChangePageComp.ComponentVars.customFieldAccordionPanelId).style.display = 'none';
	}
}

//Function called from changePage and SupportInformationComponent
function ChangeBtnStatus(link_Record){
	if(link_Record=='true'){
		Ext.getCmp('ciExplorerBtn').enable();
	}else{
		Ext.getCmp('ciExplorerBtn').disable();
	}
}  
function ShowCIExplorer(){
	var title = labelCIExpCIExplorer; 
	//Will add labels and classes to this
	var linkci = escape('CIExplorerLauncher?Module=Change_Request__c&RecordSequence='+changeId+'&id='+changeId);
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
	window.parent.parent.addNewTab('CIExplorerLauncher', labelConfigurationItemsExplorer, url );
}


function displayActiveTextArea(btnObj, textSize){

    	var btnArray = new Array(4);
    	btnArray[0]={btnId:'changeDescriptionBtn',textAreaCompId:changeDescriptionComponent,textLabel:labelChangeDescription};
    	btnArray[1]={btnId:'rolloutPlanBtn',textAreaCompId:rolloutComponent,textLabel:labelRolloutPlan};
    	btnArray[2]={btnId:'reasonForChangeBtn',textAreaCompId:resonforChangeComponent,textLabel:labelReasonForChange};
    	btnArray[3]={btnId:'backoutPlanBtn',textAreaCompId:backoutComponent,textLabel:labelBackoutPlan};
    	activeBtnId = btnObj.id;
		txtSize = textSize;
    	for(var i =0; i< btnArray.length; i++){
    	  if(activeBtnId== btnArray[i].btnId){
                activeBtnTitle = btnArray[i].textLabel;
                activeTextAreaId = btnArray[i].textAreaCompId;
   	  			document.getElementById(btnArray[i].btnId).style.fontWeight = 'bold';
                document.getElementById(btnArray[i].textAreaCompId).style.display = 'block';
		  
       	  }else{
       	  		document.getElementById(btnArray[i].btnId).style.fontWeight = 'normal';
                document.getElementById(btnArray[i].textAreaCompId).style.display = 'none';
			}
		}
 }
 
 function formCSZString(city,state,zip){
	var formattedstr='';
	if(city != ''){
	   formattedstr= ellipse(city,33) + ', ';
	}  
	if(state != ''){
	   formattedstr= formattedstr + ellipse(state,33) +' ';
	}
	if(zip != ''){
	   formattedstr= formattedstr + ellipse(zip,33);
	}   
	return formattedstr;
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

function ellipse(fieldstring,maxlength){
     //var maxlength = 35;
     if(fieldstring.length > maxlength )
     {
        return fieldstring.substr(0, maxlength-3) + '...';
     }
     return fieldstring;
}

function updateFieldsOnSave(recTitle) {
 recTitle = '#'+recTitle 
  if(recTitle == '#'){
  recTitle = ChangeRequestHeader;
 }
 window.parent.changeTitle(wid,recTitle,recTitle);
 //window.parent.needsRefresh = true;
 
}
function refreshparentList() {
	window.parent.needsRefresh = true;
}
        

function getChangeProcBtnHandler(){
	var changeProcPage = 'NavigatorPage?title='+ChangeProcess+'&target=ChangeProcMgmtPage?id=1002';						 
	window.parent.parent.addNewTab(ChangeProcess, AlignabilityProcessModel, changeProcPage, 'false');
}

function writeCookie(){
   if(document.getElementById('configureSIId').checked){
    createSICookie(cookieName,'true');
    var isCookiePresent = displaySI(cookieName, iFrameSrc);
   }
  } 
  function changeMenuHandler(assignMyselfState, saveId, closedState){
                  if(saveId != null && saveId != ''){
				        var changeInactiveVal = getChangeInactive();
				        Ext.getCmp('change_inactive__c').setValue(changeInactiveVal);
					    Ext.getCmp('deleteId').setDisabled(false);
						Ext.getCmp('deleteId').setIconClass('bmcDelete');
						Ext.getCmp('copyId').setDisabled(false);
						Ext.getCmp('copyId').setIconClass('bmcCopy');
						
						var isInactiveDisable = getInactiveDisable();
						if(isInactiveDisable){
							Ext.getCmp('change_inactive__c').setDisabled(isInactiveDisable);
							Ext.getCmp('prevId').setDisabled(isInactiveDisable);
							Ext.getCmp('nextId').setDisabled(isInactiveDisable);
						}else{
							Ext.getCmp('prevId').setDisabled(false);
							Ext.getCmp('nextId').setDisabled(false);
						}
						Ext.getCmp('resetId').setDisabled(false);
						if(setcheckforTemplate == 'true'){
								Ext.getCmp('templateBtnId').setDisabled(closedState);
						}else
						{
							Ext.getCmp('templateBtnId').setDisabled(true);
							Ext.getCmp('templateBtnId').setIconClass('bmcTemplateDisable'); 
						}
					
						if(assignMyselfState == 'true'){
					    Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
						}else{
						  Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
						}
						if(closedState == 'true'){
				        Ext.getCmp('closeButtonId').setDisabled(true);
				        Ext.getCmp('reopenButtonId').setDisabled(false); 
				        Ext.getCmp('saveId').setDisabled(true);
						Ext.getCmp('assignToStaffButtonId').setDisabled(true);
						Ext.getCmp('assignToQueueButtonId').setDisabled(true);
						Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(true);
						Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
						Ext.getCmp('respondedButtonId').setDisabled(true);
				       }else{
				         Ext.getCmp('closeButtonId').setDisabled(false);
				         Ext.getCmp('reopenButtonId').setDisabled(true); 
						 Ext.getCmp('respondedButtonId').setDisabled(false);
				         Ext.getCmp('saveId').setDisabled(false);
						}
					}
				   else
				   {
						Ext.getCmp('saveId').setDisabled(false);	
				   }
            }
	
 function buttonValidator() {
 
     if(changeId  != null && changeId  != ''){ 
		Ext.getCmp('emailId').setDisabled(false);
		Ext.getCmp('emailId').setIconClass('bmcEmailMessage');
		var isDisplay = document.getElementById('SIIframeID').style.display;
            if(cookieValue =='true' && isDisplay =='none' ){
                SIComp('/apex/SIContainerPage?oid='+changeId +'&otype=Change_Request__c&wid='+wid+'&stateofIncident='+closeState+ '&isChangeCreatable='+getIsChangeCreatable()+'&isInactive='+isInactive);
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
}
	function setAssignedToJS(){
		if(ownerIdString != null && ownerIdString != '' && ownerIdString != 'undefined'){
			setAssignedTo(ownerIdString);
		}
		taboutFlag=false;
	}
	 
	 function renderAddNoteAfterClose_JS(elem,elemduration){
			 if(elem != null){
				elem.disabled = true;
				elem.className = 'clsInputTextAreaDisabledNote';
				var btn = document.getElementById('addNoteBtn');
				btn.disabled= true; btn.className = 'AddButtonOff';
			 }
			 
			 if(elemduration != null){
				elemduration.disabled = true;
				elemduration.className = 'clsDurationTextBoxDisable';
			 }
        }

function renderAddNoteButton_JS(elem,elemduration,state, recordId){
            if(elem != null){
                var btn = document.getElementById('addNoteBtn');
	            var val = elem.value.trim();
	            if(recordId == null || recordId == '' || val==null || val =='' || state == 'false'){
                    btn.disabled= true; btn.className = 'AddButtonOff';
	            }else{
                    btn.disabled= false;  btn.className = 'AddNoteButton';
	            }
	            if(recordId == null || recordId == '' || state == 'false'){
	            	elem.disabled = true;
                    elem.className = 'clsInputTextAreaDisabledNote';    
	        		elemduration.disabled = true;
	        		elemduration.className = 'clsDurationTextBoxDisable';   
	            }else{
				    if(isNoteEnableFlag){
                     elem.value='';
                     isNoteEnableFlag=false;
                    }
	            	elem.disabled = false;
                    elem.className = 'clsInputTextAreaNote';
	        		elemduration.disabled = false;
	        		elemduration.className = 'clsDurationTextBox';   
	            }
	        }
	    }

function validateDuration_JS(durationElem){
			var duration = durationElem.value;
           if(duration != ''){
				var split = duration.split(':');
				if(split[0].length == 1){
					duration = '0'+duration;
					durationElem.value = duration;
					durationError = 0;
				}			
				var timePat = /^([0-9]{2}):([0-9]{2})$/;
  	            var matchArray = duration.match(timePat);
				if (matchArray == null) {
					durationError = 1;
					Ext.MessageBox.show({ msg: AddNote.Labels.DurationError, buttons: Ext.MessageBox.OK});
					durationElem.value = '00:00';
				}                   
           }
       }

function enableAddNote_JS(){
            if(errormsg == AddNote.Labels.DurationError){
                var btn = document.getElementById('addNoteBtn');
                btn.disabled= false; btn.className = 'AddNoteButton';             
	            var note = document.getElementById(AddNoteComp.ComponentVars.Notes);
	            note.disabled = false;
                note.className = 'clsInputTextAreaNote';    
	        	var elemduration = document.getElementById(AddNoteComp.ComponentVars.Duration);
	           	elemduration.disabled = false;
         		elemduration.className = 'clsDurationTextBox'; 	
         		elemduration.value = '00:00';
       		}
       }
	   
function disableAddNote_JS(note,duration) {
		   validateDuration(duration);
		   if(durationError != 1){
	           if(note.length > 32000){                       
	                Ext.MessageBox.show({ msg: AddNote.Labels.Note + ' : ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
	           }else{          
                   var btn = document.getElementById('addNoteBtn');
                   btn.disabled= true; btn.className = 'AddButtonOff';
	               saveNote(note,duration);
	           }		   
		   }
		   durationError = 0;
       }
	   
 function renderNote_JS(){
			
            if(errormsg == AddNote.Labels.DurationError){
                Ext.MessageBox.show({ msg: errormsg, buttons: Ext.MessageBox.OK});
			}else {
	        	var elem = document.getElementById(AddNoteComp.ComponentVars.Notes);
	        	if(elem != null){
		            elem.disabled = false;
                    elem.className = 'clsInputTextAreaNote';
		           	elem.value = '';
					if(insideNote == false){
						clickedOnce = true;  
						handleResetChange(); 
					}
				}
	        	var elemduration = document.getElementById(AddNoteComp.ComponentVars.Duration);
		       	if(elemduration != null){
		            	elemduration.disabled = false;
		           		elemduration.value = '00:00'; 	
		        }
	        } 
	   }
function afterAddNote(){
		 var isDisplay = document.getElementById('SIIframeID').style.display;
		 
		if(cookieValue !='true' && (isDisplay =='none')){
			SIComp(iFrameSrc);
		}else if(isDisplay !='none'){ 
			window.frames.SIIframeID.refreshDocs(); 
		}
	}
	
function handleChange(){
	if(!clickedOnce){ 
		clickedOnce = true;
		changeDone = true;
		window.parent.registerChange(wid2);
	}
} 
function openCategoryPage(returnValues){ 
            if(returnValues != null || returnValues != '')
            {
		
                if(returnValues[0] != null ||returnValues[0] !='' ) {
				
                     	var Category__c_id_id=returnValues[3];
						categoryName=returnValues[0];
						
						if(returnValues[4] != null && returnValues != 'undefined'){
							
							document.getElementById(ChangePageComp.ComponentVars.CategoryFKUrgency).value = returnValues[4];
	}
						setCatData(Category__c_id_id, categoryName);
						
                    }
						
		}
			 
            
	}
	
	function showErrorMsgCR(errorMsg){
			Ext.MessageBox.show({ msg: errorMsg , buttons: Ext.MessageBox.OK});         
	}
	
	function ServiceTargetsBtnHandler(button, event){
		openPopupForServiceTarget('SearchPage?popupId=ChangeRequestServiceTarget&isLookup=true&amp;filterClause=' + escape('FKChangeRequest__c=\''+ changeRequestId+'\''), ('#'+changeRequestName + ' ' + labelServiceTargets));	
	}
function preAssignChangeTOStaff(saveId){
	waitbox(0);
	assignChangeTOStaff(saveId);
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange();
	}
}
function getCustomActionURL(customId){
	var changeId = getChangeId();
	eval(orgNamespace).JSRemoteActions.getCustomActionURL( 'Change_Request', changeId,customId, function(result, event){
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
function OpenServiceRequest(pageName){
	var parentWid = getWID();
	var id;
	var target;
	if (pageName == 'IncidentPage') {
		id = getServiceRequestId();
		//getServiceRequestNameEle().style.color = '#800080'; 
		target = pageName+escape('?id='+id+'&parentWid='+parentWid+'&isDirect=true&columnField=name&direction=DESC');
		if(id != null && id != 'undefined' && typeof(id) != 'undefined'){
			window.parent.parent.addNewTab(pageName, labelIncidentPlural, "NavigatorPage?title="+ getServiceRequestName() + "&tabTitle=" + getServiceRequestName() + "&target=" + target);
		}
	}
} 
function disableDateField(){
	var spans = window.document.getElementsByTagName("span");
	for (var i = 0; i < spans.length; i++) {
		var className = spans[i].getAttribute("class");
		if (className == "dateInput"){
			var date = spans[i].childNodes[0];
			if(date != null ){
				var readOnlyDate = date.getAttribute("class");
				if(readOnlyDate != null && readOnlyDate == 'clsPanelInputTextboxReadOnly'){
					date.disabled = true;
				}
			}
		}
	}
}