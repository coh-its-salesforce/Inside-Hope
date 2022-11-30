var disableTrue = false,
isDormantSection=false;
var idset;
var problemState;
var assignedToMyselfState=true;
var loggedInUserId='', problemOwnerId='',disableNextPrev=false;
var duration=0,
	insideNote= false,
	clickedOnce = false,
	isNoteEnableFlag=true,
	durationError=0;
	document.onclick = activateWindow; 
var windowloaddate = 0, pagerenderstart = 0, networklatencystart = 0 ;	

var resizeGrid= function resizeGrid(){
	if(Ext.getCmp('southPanelSI')!=undefined)
 		Ext.getCmp('southPanelSI').setWidth(Ext.getCmp('southPanelSI').getWidth());
};
function saveFunction(savecloseparam){
		if(getIsPriorityChanged() == 'true' && isNewRecord()=='false') {
		if(!automaticupdateduedate)
		{
			openPopup('recalculateDueDate', showit, 190, 300);
		}
		else
		{
			setDueDateOption(2);
			var chkBoxValue=Ext.getCmp('problem_inactive__c').getValue();
			waitbox(0);
			savecloseparam(chkBoxValue);
		}
	}else {
		var problemDescriptionData = document.getElementById(ProblemPageComp.ComponentVars.ProblemFormDescription).value.trim();
		var problemResolutionData = document.getElementById(ProblemPageComp.ComponentVars.ProblemFormResolution).value.trim();
		var problemWorkAroundData = document.getElementById(ProblemPageComp.ComponentVars.ProblemFormWorkAround).value.trim();		 
		
		if(problemDescriptionData.length > 32000){
			Ext.MessageBox.show({ msg: labelDescription + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}		
		if(problemResolutionData.length > 32000){
			Ext.MessageBox.show({ msg: labelResolution + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}
		if(problemWorkAroundData.length > 255){
			Ext.MessageBox.show({ msg: labelWorkAround + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
			return;
		}
		var chkBoxValue=Ext.getCmp('problem_inactive__c').getValue();
		waitbox(0);
		savecloseparam(chkBoxValue);
	}
}
var showit = function (selectedOption){
	setDueDateOption(selectedOption);
	var chkBoxValue=Ext.getCmp('problem_inactive__c').getValue();
	save(chkBoxValue);
}
Ext.onReady(function(){
if(closedStageVar == 'CLOSED' || closedStageVar =='Closed'){
		Ext.MessageBox.show({title: Information , msg:ClosedStage, buttons: Ext.MessageBox.OK, icon: Ext.MessageBox.INFO});		
	}
	
var TotalLatencyTime = networklatencystart - LatencyStart;
data += labelPM_netwokLatency;
data += TotalLatencyTime;
windowloaddate = new Date();
pagerenderstart = windowloaddate.getTime();
Ext.QuickTips.init(); 

var NewBtnHandler = function(button,event) { 
	openPage("ProblemPageCustom",ProblemRequestHeader,ProblemRequestHeader); activeAllWindowFlag=false;

  };

var SaveBtnHandler = function(button,event) {
	saveFunction(save);
};

var CopyBtnHandler = function(button,event) { callCopyPage(); activeAllWindowFlag=false;};
var DeleteBtnHandler = function(button,event) { 
		Ext.MessageBox.confirm(labelDelete, DeletedRecord, function(btn){
                                                         if(btn === 'yes'){
                                                                   deleteProblem();
                                                          }
														  }) 
};
											 
var ResetBtnHandler = function(button,event) { reset();};

var AssignToStaffHandler = function(button,event) {  
	openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true',preAssignedToStaff);
};

var AssignToMemberOfAdminHandler= function(button,event) { 
	openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("profileid='" + getProfileID() + "'And IsStaffUser__c=true ")+'&isAssignTo=true',preAssignedToStaff);
	}

var AssignToMyselfHandler  = function(button,event) {
	waitbox(0);
	assignedToMyself();
	handleChange();
};
var AssignToQueueHandler = function(button,event) {
	//openPopupWithTitle('QueueListPage?sObjectType=Problem__c',preAssignTOQueue,labelSelectFrom+' '+labelQueue,550, 670);        
	openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Problem__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), preAssignTOQueue);
};

var CloseBtnHandler= function(button,event) { 
	closeProblem();         
};
var ReopenBtnHandler = function(button,event) {reopenProblem();}
var ProblemProcBtnHandler = function (button,event){ getProblemProcBtnHandler()};


updateTitle();
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
        //alert('taskIdSet='+taskIdSet);
        }
    }
}
checkIDSet();

var PreviuosBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(previousProblemBtnHandler1);				
			} else {  if(document.getElementById('prevId').disabled!=true) 
				        previousProblemBtnHandler1();}
			}
var NextBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(nextProblemBtnHandler1);				
			} else {  if(document.getElementById('nextId').disabled!=true) 
				        nextProblemBtnHandler1();}
			}
function previousProblemBtnHandler1(){
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
        previousProblemBtnHandler(idSetString);
}
function nextProblemBtnHandler1(){
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
        nextProblemBtnHandler(idSetString);
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
		
	},' ','-',{
		id:'assignToId',
		scale: 'medium',
		iconCls: 'bmcAssign1',
		tooltipType : 'title',
		tooltip: labelAssignTo,
		hidden:disableTrue,
		menu: [ 
				{text:labelIncidentsStaff,
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', id:'assignToStaffButtonId',
				 disabled:!problemState,handler:AssignToStaffHandler},
				{text:labelIncidentMyself, 
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToMyselfButtonId', 
				 disabled:!problemState, handler:AssignToMyselfHandler},
				{text:labelIncidentMemberofProfName, id:'assignToMemberOfAdminButtonId', 
				 disabled:!problemState, icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',handler:AssignToMemberOfAdminHandler
				 },
				{text:labelQueue, 
				 icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToQueueButtonId', disabled:!problemState, handler:AssignToQueueHandler
				 }]
	},' ',{
		id:'actionId',
		scale: 'medium',
		iconCls: 'bmcAction1',
		tooltipType : 'title',
		tooltip: labelActions,
		hidden:disableTrue,
		menu: [ {text:labelIncidentClose, id:'closeButtonId', icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', disabled:!problemState,  handler:CloseBtnHandler },
				{text:labelReopenProblem, id:'reopenButtonId',icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', disabled:problemState, handler:ReopenBtnHandler },{xtype: 'menuseparator',id:'separaterAction'},{text:Print, disabled:IsNewRecord(problemId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',   id:'printButtonId', handler:PrintBtnHandler},{ text:PrintPDF, disabled:IsNewRecord(problemId), icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'printPdfButtonId', handler:PrintPDFBtnHandler},'-',
customActionJsonString]
	},' ',{
            scale:'medium',
            iconCls: 'bmcAPM',
            tooltipType : 'title',
            tooltip:labelProblemMgmtProcess,
            id:'problemProcButton',
            handler:ProblemProcBtnHandler
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
		  id :'problem_inactive__c',
	   xtype  : 'checkbox',
	   width  : 93,
	   color :'#004376',
	   align:'top',
	   checked: false,
	   boxLabel:'<span class="checkboxLabelCls">'+labelInactive+'</span>',
		autoCreate: {tag: "input", type: "checkbox",title:labelTooltipProblemInactive, tooltip:labelTooltipProblemInactive }
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

  	
  document.getElementById('capsule').style.display = 'block';
  var canvasPanel = new Ext.Panel({
             layout:'border',
            // width:'auto',    
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
                    height:435, 
                    cls:'northPanelCls',
                                                                 
                    region: 'center',                   
                               
                    contentEl : Ext.isIE ? 'capsule' : ProblemPageComp.ComponentVars.ProblemForm
                    
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
                    height:Ext.isIE ?230:240,
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
        // renderTo:'viewPortDiv',
         width:'auto',
         id:'viewportId',
         border:false, 
         cls:'viewportCanvasCls',
         //items:canvasPanel
         items:[{anchor: '100%', layout:'fit', items:canvasPanel} ]
        });
		if(isRecordDeleted()){
			Ext.Msg.alert(Information,labelRecordDeleted, function(){
				if((typeof(window.parent)!='undefined')&&(typeof(window.parent.popUpWindow)!= 'undefined'))
					window.parent.popUpWindow.close();
				closeWindow();
			});
		}
		problemId = getProblemID();
		ChangeBtnStatus(cilink_record);
		if(problemId == null || problemId == ''){
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
			Ext.getCmp('emailId').setDisabled(true);				
        }else if(problemId != null){
			checkEnable();	
        }
 
	 if(problemId  == null || problemId  == ''){
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
	
	
	
	renderAddNoteButton();	
	if(typeof(getIsCopySaved) == 'function'  && getIsCopySaved()=='false'){
		var chkBoxValue=getproblemInactive();
		Ext.getCmp('saveId').setDisabled(true); 
		save(chkBoxValue);
	}
	var problemInactiveVal = getproblemInactive();	
	Ext.getCmp('problem_inactive__c').setValue(problemInactiveVal);
	var pageloadstartdate = new Date() ;
	var pageRenderEnd = pageloadstartdate.getTime();
	var pagerendertime =(pageRenderEnd - pagerenderstart);
	data += '<br>';
	data += labelPM_PageLoad;
	data += pagerendertime;
	
	if(window.parent.refreshGridSI!=undefined)
		window.parent.refreshGridSI(wid,resizeGrid);
	
});
    
       function problemFormBtnHandler(btnObj, textSize){
			var btnArray=new Array(3);
			btnArray[0]={btnId:'problem_description',textAreaCompId:ProblemPageComp.ComponentVars.ProblemFormDescription,textLabel:labelProblemDescription};
			btnArray[1]={btnId:'problem_resolution',textAreaCompId:ProblemPageComp.ComponentVars.ProblemFormResolution,textLabel:labelProblemResolution};
			btnArray[2]={btnId:'work_around',textAreaCompId:ProblemPageComp.ComponentVars.ProblemFormWorkAround,textLabel:labelWorkAround};
			var activeBtnId = btnObj.id;
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

function knowErrorChkHandler(id){
       
       if(document.getElementById(id).checked){
            document.getElementById('problem_description').disabled=false;
            document.getElementById('problem_resolution').disabled=false;
            document.getElementById('problem_description').style.color='#004376';
            document.getElementById('problem_resolution').style.color='#004376';
       
       }
  }
  
 function writeCookie(){
		if(document.getElementById('configureSIId').checked){
			createSICookie(cookieName,'true');
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
		}
}

function getProblemProcBtnHandler(){
	var problemProcPage = 'NavigatorPage?title='+ProblemProcess+'&target=ProblemProcMgmtPage?id=1003';						 
	window.parent.parent.addNewTab(ProblemProcess, AlignabilityProcessModel, problemProcPage, 'false');
}

function closeWindow(){
	  
	   window.parent.refreshList();
		window.parent.closeTab(wid);
     
}
function handleResetChange(){
    if(clickedOnce){
       clickedOnce = false;
       window.parent.registerSave(wid2);
    }
} 

function updateFieldsOnSave(recTitle) {
 recTitle = '#'+recTitle 
  if(recTitle == '#'){
  recTitle = ProblemRequestHeader;
 }
 window.parent.changeTitle(wid,recTitle,recTitle);
 //window.parent.needsRefresh = true;
       
}

function refreshparentList() {
	window.parent.needsRefresh = true;
}
 
function OpenHelpUrl(link){
	if(link.toLowerCase().indexOf('composeemailpage') != -1){
		OpenHelppage('EmailConversationProblem','module','form');
	}
}  

//Function called from ProblemPage and SupportInformationComponent
function ChangeBtnStatus(link_Record){	
if(link_Record=='true'){
		Ext.getCmp('ciExplorerBtn').enable();
	}else{
		Ext.getCmp('ciExplorerBtn').disable();
	}
}  
function ShowCIExplorer(){
	var newProblemId = getProblemID();
	var title = labelCIExpCIExplorer; 
	//Will add labels and classes to this
	var linkci = escape('CIExplorerLauncher?Module=Problem__c&RecordSequence='+newProblemId+'&id='+newProblemId);
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
	window.parent.parent.addNewTab('CIExplorerLauncher', labelConfigurationItemsExplorer, url );
}

var sendEmailBtnHandler = function (button, event){
               openPopupWithTitle('ComposeEmailPage?recordId='+problemId+'&isNew=true&objectName=Problem__c',composeMailOnCompleteIn, labelComposeEmailPageHeader+probName, getEmailWinHt(), getEmailWinWidth(), false);
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
	            if(recordId == null || recordId == '' || val==null || val =='' || !state){
                    btn.disabled= true; btn.className = 'AddButtonOff';
	            }else{
                    btn.disabled= false;  btn.className = 'AddNoteButton';
	            }
	            if(recordId == null || recordId == '' || !state){
	            	elem.disabled = true;
                    elem.className = 'clsInputTextAreaDisabledNote';    
	        		elemduration.disabled = true;
	        		elemduration.className = 'clsDurationTextBoxDisable';   
	            }else{
				    if(isNoteEnableFlag){
                     elem.value=' ';
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
	                Ext.MessageBox.show({ msg: AddNote.Labels.Note + ': ' + AddNote.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
	           }else{          
                   var btn = document.getElementById('addNoteBtn');
                   btn.disabled= true; btn.className = 'AddButtonOff';
	               saveNote();
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

	
	
   function showInfoPopup(eventObject, divId , objName ){
        var recordId = '';
          var target=eventObject.target;
          if(target == null) 
             target = eventObject.srcElement;
         
          
          if(objName == 'staff')
          {
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
                    dismissDelay: 15000,
                    html: document.getElementById(divId).innerHTML
                 }); 
                   
          }    
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
function formCSZString(city,state,zip)
{
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
function buttonValidator() {
 
     if(problemId  != null && problemId  != ''){ 
      var isDisplay = document.getElementById('SIIframeID').style.display;
	  Ext.getCmp('saveId').setDisabled(!problemState);
	 Ext.getCmp('emailId').setDisabled(!problemState);
	  Ext.getCmp('printButtonId').setDisabled(false);
	  Ext.getCmp('printPdfButtonId').setDisabled(false);
	        cookieValue = Ext.util.Cookies.get(cookieName);
            if(cookieValue =='true' && isDisplay =='none' ){
                SIComp('/apex/SIContainerPage?oid='+problemId +'&otype=Problem__c&wid='+wid+'&stateofIncident='+problemState+'&isChangeCreatable='+getIsChangeCreatable()+'&isInactive='+isInactive);
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

function senddata(){return data;}

function handleChange(){
	if(!clickedOnce){ 
		clickedOnce = true;
		window.parent.registerChange(wid2);
	}
} 
function setWorkAroundEnableDisable(){
  var knownErrorHiddenEle = document.getElementById('problem_Known_Error__c');
	var knownErrorEle;
	if(knownErrorHiddenEle != null && knownErrorHiddenEle != ''){
		knownErrorEle = knownErrorHiddenEle.nextSibling;
		if(knownErrorEle!=null){
			if(knownErrorEle.tagName == 'SCRIPT'){
				knownErrorEle = knownErrorEle.nextSibling;
				if(!knownErrorEle.checked){
					disableWorkAround();
				}
			}else if(!knownErrorEle.checked){
				disableWorkAround();
			}
			
	}
	
  } 
}
function disableWorkAround(){
	document.getElementById('work_around').disabled=true;
	document.getElementById('work_around').style.color='#808080';
}
function displayTextEditor(){
	var knownErrorHiddenEle = document.getElementById('problem_Known_Error__c');
	var knownErrorEle;
	if(knownErrorHiddenEle != null && knownErrorHiddenEle != ''){
           knownErrorEle = knownErrorHiddenEle.nextSibling;
		  if(knownErrorEle != null){
			  if(knownErrorEle.tagName == 'SCRIPT'){ // This block is added because <script> tag gets added sometimes for <apex:inputfield>. here after problem save
				knownErrorEle = knownErrorEle.nextSibling;
				if(knownErrorEle != null)
				var isChecked=knownErrorEle.checked;
				if (!isChecked && labelWorkAround == activeBtnTitle) 
					return;
			  }else{
		  var isChecked=knownErrorEle.checked;
	      if (!isChecked && labelWorkAround == activeBtnTitle) 
		     return;
			  }
		  }	 

	}
	 showTextEditor(activeTextAreaId, activeBtnTitle, txtSize, labelOK, labelCancel);

}
 function openCategoryPage(returnValues){ 
            if(returnValues != null || returnValues != '')
            {
		
                if(returnValues[0] != null ||returnValues[0] !='' ) {
				
                     	var Category__c_id_id=returnValues[3];
						categoryName=returnValues[0];
						
						if(returnValues[4] != null && returnValues != 'undefined'){
							
							document.getElementById(ProblemPageComp.ComponentVars.CategoryFKUrgency).value = returnValues[4];
						}
						setCatData(Category__c_id_id, categoryName);
						
                    }
                 
             }
			 
            
}

function FetchProblemUrgencyHTTPJS(inc,cat,cl,im,bi,uin,uii,pn,pi, isPrChanged, prNameVal) {
	var prCheck = document.getElementById(isPrChanged); 
	var con = new Ext.data.Connection(),
	incid = inc, dueDateOpt, prioId,
	catid = document.getElementById(cat).value;
	if(cl != null)
		clid = document.getElementById(cl).value;
	else
		clid = null;
	iid = document.getElementById(im).value;
	if(bi != null)
		bid = document.getElementById(bi).value;
	else	
		bid = null;
	if(isPrChanged != null){	
		dueDateOpt = document.getElementById(isPrChanged).value;
	}else
		dueDateOpt = null;
	if(pi != null){
		prioId = document.getElementById(pi).value;	
	}else	
		prioId = null;
	con.request({
		url: 'FetchUrgencyData',
		method: 'POST',  
		params: {"id": incid, "fkcat": catid, "fkcl": clid, "fkb": bid, "fki": iid,  "fetchUrgency":true},
		callback: function(opts, success, response){
		if (success) {
			var dq = Ext.DomQuery, 
			xml = response.responseXML,
			node = dq.selectNode('urgencyname', xml);
			if(document.getElementById(uin) != null && node.firstChild != null)
				document.getElementById(uin).value = 
				decodeURIComponent(node.firstChild.nodeValue);
			node = dq.selectNode('urgencyid', xml);
			if(node.firstChild==null) {
				return;
			}
			if(document.getElementById(uii) != null && node.firstChild != null)
				document.getElementById(uii).value = 
				decodeURIComponent(node.firstChild.nodeValue);
			node = dq.selectNode('priorityname', xml);
			if(document.getElementById(pn) != null && node.firstChild != null)
				document.getElementById(pn).value = 
				decodeURIComponent(node.firstChild.nodeValue);
			
			if(prNameVal!=null && document.getElementById(prNameVal) != null) {
				if(node.firstChild != null) {
				document.getElementById(prNameVal).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				}else {
					document.getElementById(prNameVal).value = '';
				
				}
			}
				
			node = dq.selectNode('priorityid', xml);
			if(document.getElementById(pi) != null && node.firstChild != null){
				document.getElementById(pi).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				var newPrId = decodeURIComponent(node.firstChild.nodeValue);
				if(prioId != newPrId) {
					if(prCheck != null)
						setIsPriorityChanged('true');
				}
				else {	
					if(prCheck != null)
						setIsPriorityChanged('false');
				}
			}	
			if(node.firstChild==null && prNameVal!=null) {
				document.getElementById(pi).value = '';
				document.getElementById(prNameVal).value = '';
				document.getElementById(pn).value = '';
			}
			
			return;
			}
	    	}
	});
}

function FetchProblemPriorityHTTPJS(impactId, urgencyId, pn, pi, isPrChanged, prNameVal) {
	var con = new Ext.data.Connection();
	var pId;
	if(pi != null)
		pId = document.getElementById(pi).value;
	var prCheck = document.getElementById(isPrChanged); 
	
	con.request({
		url: 'FetchPriorityPage',
		method: 'POST',  
		params: {"fki": impactId, "fku":urgencyId, "fetchPriority":true},
		callback: function(opts, success, response){
		if (success) {
			var dq = Ext.DomQuery; 
			var xml = response.responseXML;
			var node = dq.selectNode('priorityname', xml);
			if(document.getElementById(pn) != null && node.firstChild != null)
				document.getElementById(pn).value = 
				decodeURIComponent(node.firstChild.nodeValue);
			
			if(prNameVal!=null && document.getElementById(prNameVal) != null) {
				if(node.firstChild != null) {
				document.getElementById(prNameVal).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				}else {
					document.getElementById(prNameVal).value = '';
				
				}
			}
				
			node = dq.selectNode('priorityid', xml);
			if(document.getElementById(pi) != null && node.firstChild != null){
				document.getElementById(pi).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				var newpi = decodeURIComponent(node.firstChild.nodeValue);
				if(pId != newpi){
					if(prCheck != null)
						setIsPriorityChanged('true');
					
				}else{
					if(prCheck != null)
						setIsPriorityChanged('false');
					
				}
			}
			if(node.firstChild==null && prNameVal!=null) {
				document.getElementById(pi).value = '';
				document.getElementById(prNameVal).value = '';
				document.getElementById(pn).value = '';
			}
				return;
			}
		}
	});
}
function preAssignedToStaff(saveId){
	waitbox(0);
	assignedToStaff(saveId);
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange();
	}
}
function preAssignTOQueue(queueId){
	waitbox(0);
	assignTOQueue(queueId);
	if(queueId!=null && queueId!='undefined' && queueId != '')
	{
		handleChange();
	}
} 
function getCustomActionURL(customId){
	var probId = getProblemID();
	eval(orgNamespace).JSRemoteActions.getCustomActionURL( 'Problem__c', probId,customId, function(result, event){
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
function showData(event,onCompleteFunction,whereClause,windownameflag){
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
/*	}else{
		if(typeof(onCompleteFunction)!='undefined'){
			onCompleteFunction();
		}
	}*/
}
function composeMailOnCompleteIn(){
var isDisplay = document.getElementById('SIIframeID').style.display;
	if(window.frames.SIIframeID != null && typeof(window.frames.SIIframeID) != 'undefined'){
		if(isDisplay != 'none'){
			document.getElementById('SIIframeID').contentWindow.composeMailOnComplete();
		}
	}
}

function afterSaveAndClose(){
	if(errormsg==labelSavedSuccessfully){
		checkEnable();
		closePopup();
	}else{
		showError();
		document.getElementById(ProblemPageComp.ComponentVars.closedByID).value=prevCloseClosedById;
		document.getElementById(ProblemPageComp.ComponentVars.ProblemFormResolution).value=prevcloseResolution;
		document.getElementById(ProblemPageComp.ComponentVars.CategoryIDName).value=prevcloseCategoryId;
		document.getElementById(ProblemPageComp.ComponentVars.statusIdName).value=prevcloseStatusId;
		document.getElementById(ProblemPageComp.ComponentVars.closeDateID).value=prevcloseCloseDate;
	}
	
}



function saveAndCloseJS(closeClosedById,closeResolution,closeCategoryId,closeStatusId,closeCloseDate,updateStandDesc,updateStandRes,closeTasks,closeIncident){
	var closedByID = document.getElementById(ProblemPageComp.ComponentVars.closedByID);
	prevCloseClosedById = closedByID.value;
	closedByID.value = closeClosedById;
	
	var closeResolutionid=document.getElementById(ProblemPageComp.ComponentVars.ProblemFormResolution);
	prevcloseResolution=closeResolutionid.value;
	closeResolutionid.value=closeResolution;
	
	var closeCategory=document.getElementById(ProblemPageComp.ComponentVars.CategoryIDName);
	prevcloseCategoryId=closeCategory.value;
	closeCategory.value=closeCategoryId;
	
	var closeStatus=document.getElementById(ProblemPageComp.ComponentVars.statusIdName);
	prevcloseStatusId=closeStatus.value;
	closeStatus.value=closeStatusId;
	
	var closedate=document.getElementById(ProblemPageComp.ComponentVars.closeDateID);
	prevcloseCloseDate=closedate.value;
	closedate.value=closeCloseDate;

	document.getElementById(ProblemPageComp.ComponentVars.updateStandDescId).value = updateStandDesc;
	document.getElementById(ProblemPageComp.ComponentVars.updateStandResId).value = updateStandRes;
	document.getElementById(ProblemPageComp.ComponentVars.isCloseTasksId).value = closeTasks;
	document.getElementById(ProblemPageComp.ComponentVars.isCloseIncidentsId).value = closeIncident;
	saveFunction(saveAndCloseAction);
} 
function checkEnable(){
	var probId = getProblemID();
	if(errormsg == null || errormsg == '' || errormsg == labelSavedSuccessfully){ 
      Ext.getCmp('assignToStaffButtonId').setDisabled(!problemState);
      Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(!problemState);                  
      Ext.getCmp('emailId').setDisabled(!problemState);
      Ext.getCmp('closeButtonId').setDisabled(!problemState);
      Ext.getCmp('reopenButtonId').setDisabled(problemState);
      Ext.getCmp('assignToQueueButtonId').setDisabled(!problemState);
	  Ext.getCmp('emailId').setDisabled(!problemState);
	  var AssignedToMyselfState = getAssignedToMyselfState();
	  if(AssignedToMyselfState || !problemState){
		Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
	  }else{
		Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
	  }
	}
	Ext.getCmp('saveId').setDisabled(!problemState);
 }
 function enableCpDelRes(){
	Ext.getCmp('deleteId').setDisabled(false);
    Ext.getCmp('deleteId').setIconClass('bmcDelete');
    Ext.getCmp('copyId').setDisabled(false);
    Ext.getCmp('copyId').setIconClass('bmcCopy');
	if(!disableNextPrev){
		Ext.getCmp('prevId').setDisabled(false);
		Ext.getCmp('nextId').setDisabled(false);
	}
    Ext.getCmp('resetId').setDisabled(false);
 }
 function getAssignedToMyselfState(){
	if(problemOwnerId == ''){
		return false;
	}else if(problemOwnerId != null && loggedInUserId != problemOwnerId){
		return false;
	}else if(problemOwnerId != null && loggedInUserId == problemOwnerId){
		return true;
	}
	
}

