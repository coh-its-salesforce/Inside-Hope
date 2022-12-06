// global variable declarations
var g_loadTime = new Date(),
	startTime = new Date(),
	test = '',
	durationError = 0,
	serverTime = "39",
	networklatencystart = '',
	windowloaddate = '',
	v1,
	doSave = false,
	saveFunctionRef,
	clickedOnce = false,
	taboutFlag=true,
	keyName,
	keyValue,
	reqDtlsId = '',
	selectedModuleName,
	incidentclientId,
	ownerIdString,
	priorityString,
	priorityNameString,
	isValid ='True',
	CI_value,
	service_value,
	stgName,
	CI_state,
	userHasAccesToInc,
	clientID,
	categoryId,
	orgId,
	incidentId,
	clientName,
	incidentCategory,
	errormsg,
	chkBoxValue,
	incidentCategoryId = '',
	separator,
	disableTrue = true,
	isDormantSection=false,
	idset,
	NoRightsToViewEdit,
	timeoutreturn,
	objName,
	isServiceRequest,
	loggedInUserId='',
	loggedInUserFirstName = '',
	loggedInUserLastName = '',
	primaryCI='',
	pageloadstartdate = new Date();    
    insideNote = false; 
	isNoteEnableFlag=true;
	changeDone = false;
	var incnState=true;
var OfferingClause = ''; var soqlDateClause;var businessServiceClause;
document.onclick = activateWindow;  	
var resizeGrid= function resizeGrid(){
	if(Ext.getCmp('southPanelSI')!=undefined)
 		Ext.getCmp('southPanelSI').setWidth(Ext.getCmp('southPanelSI').getWidth());
};
function RequestDetailId(requestDetailId){
	document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value = requestDetailId;
	renderRequestDetails(requestDetailId); 
}
function initFunc_1() {
	if(window.parent.refreshGridSI!=undefined)
		window.parent.refreshGridSI(wid,resizeGrid);

	if(isLookup){
		window.parent.changePopUpTitle('{!objLabel}');
	}
}
function setSelectedModuleName(modNameFS){
	selectedModuleName = modNameFS;
}
function ShowCIExplorerJS(title, lblCIExplorer) {
	var linkci = escape('CIExplorerLauncher?Module=Incident__c&RecordSequence=' + incidentId + '&id='+ incidentId );
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
	window.parent.parent.addNewTab('CIExplorerLauncher', lblCIExplorer, url );
}

function ChangeCIExpBtnStatusJS(cmpBaseElm, btnCIExp) {
	CI_value = document.getElementById(cmpBaseElm).value.trim();
	if(0==CI_value.length){
		document.getElementById(btnCIExp).disabled =true;
	}else{
		document.getElementById(btnCIExp).disabled =false;
	}
}

function DisableCIExpBtnJS(cmpBaseElm, btnCIExp) {
	var CI_new_value = document.getElementById(cmpBaseElm).value.trim();
	if((CI_value != CI_new_value) || (0==CI_new_value.length)){
	    document.getElementById(btnCIExp).disabled =true;
	}
}

function handleResetChange(){
    if(clickedOnce){
       clickedOnce = false;
	   changeDone = false;
       window.parent.registerSave(wid2);
    }
}    
function handleChange(obj){
    if(obj!=null)
	{
		var target = obj.target || obj.srcElement;
		if(target != 'undefined' && target.id.match("incidentNote__c") == null && target.id.match("addNoteBt") == null){
			insideNote = true;
		}
	}		
	if(!clickedOnce){ 
		clickedOnce = true;
		changeDone = true;
		window.parent.registerChange(wid2);
	}
}       
       
function setIncForCategoryEnabledJS(cmpCategoryName) {
	var categoryName = '';
	if(document.getElementById(cmpCategoryName)!=null && document.getElementById(cmpCategoryName)!='')
		categoryName = document.getElementById(cmpCategoryName).value;

	if(categoryName != null && categoryName != ''){
		Ext.getCmp('IncidentsforCategoryId').setDisabled(false);
	}else{
		Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
	}
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
function senddata(){return data;}

function setClientDetailsJS(cmpUserId) {
	setClientNext(returnvalue);
	if (returnvalue != null) {
	//IE7-8 Related Changes
	    document.getElementById(cmpUserId).value = returnvalue;
	}
}
function afterSaveCloseAction(){ 

     waitMsg.hide();
    if(errormsg==IncidentPage.Labels.SavedSuccessfully){            
        closeIncident();
    }else {
        showError();
    }

}
var showit = function (selectedOption){
            document.getElementById(dueDateCalculationOptionJS).value = selectedOption; 
            saveRecords();
       }
function disableRequestDetailBtn(){
	var selectedReqDefID = document.getElementById(IncidentPageComp.ComponentVars.reqDefinationID).value;	
	var requestDetailID	 = document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value;
	if((selectedReqDefID == null || selectedReqDefID =='') &&(requestDetailID == null || requestDetailID =='')){	
		document.getElementById("reqDetailBtn").disabled = true;
	}else{	
		document.getElementById("reqDetailBtn").disabled = false;
	}
}
Ext.onReady(function(){
           primaryCI=document.getElementById(IncidentPageComp.ComponentVars.BaseElementIDName).value;
			if(stgName == 'CLOSED' || stgName =='Closed'){				
				Ext.MessageBox.show({title: IncidentPage.Labels.Information , msg:IncidentPage.Labels.ClosedStage, buttons: Ext.MessageBox.OK, icon: Ext.MessageBox.INFO});				
			}
			getapplyTemp();
			createControlMap();
            renderElementsByType();
			windowloaddate = new Date();
            networklatencystart = windowloaddate.getTime();

        
             var networklatency = networklatencystart - etime;
                
             data +=IncidentPage.Labels.PM_netwokLatency;
             data +=networklatency; 
             data += '<br>';
            Ext.QuickTips.init();   
            if(isLookup){
            disableTrue = true;
            separator = '';
          }else{ 
              disableTrue = false;
              separator = '-';
          }
            // This function renders a block of buttons
            var NewBtnhandler = function(button,event) {openPage("IncidentPage",IncidentPage.Labels.IncidentWindowHeaderSearchPage,IncidentPage.Labels.IncidentWindowHeaderSearchPage); activeAllWindowFlag=false; };
			var followBtnHandler = 
                function(button,event) {
                    followIncidentToggler();
                };     
            var SaveBtnHandler = 
                function(button,event) {
                    var validate = ValidateForm();
                    if(validate == true){ 

                    if(!inProgress){
                        doSave = false;
                        var incDescription = document.getElementById(IncidentPageComp.ComponentVars.IncidentDescription).value;
                        var incResolution = document.getElementById(IncidentPageComp.ComponentVars.IncidentResolution).value;
                        var isPriorityChanged = document.getElementById(IncidentPageComp.ComponentVars.IsPriorityChanged).value;
                        var dueDateOpt = document.getElementById(IncidentPageComp.ComponentVars.DueDateCalculationOption).value;
                        
                        var impactNameEle = document.getElementById(IncidentPageComp.ComponentVars.ImpactIDName);
                        var impactName = '';
                        if(impactNameEle != null)
                            impactName = impactNameEle.value; 
                        var urgencyNameEle = document.getElementById(IncidentPageComp.ComponentVars.UrgencyIDName);
                        var urgencyName = '';
                        if(urgencyNameEle != null)
                            urgencyName = urgencyNameEle.value; 
                        var countDescription = incDescription.length;
						if(!Ext.isIE && incDescription != null ){
							if(null != incDescription.match(/[^\n]*\n[^\n]*/gi)){
								countDescription = countDescription + incDescription.match(/[^\n]*\n[^\n]*/gi).length;
							}
						}
						var countResolution = incResolution.length;
						if(!Ext.isIE && incResolution != null) {
							if(null != incResolution.match(/[^\n]*\n[^\n]*/gi)){
								countResolution = countResolution + incResolution.match(/[^\n]*\n[^\n]*/gi).length;
							}
						} 
                        if(countDescription <= 32000 && countResolution <= 32000){
							if(isPriorityChanged == 'true' && incidentId != '' && incidentId != null && impactName != '' && urgencyName != '' && isDueDateOverridenByServiceTarget() == false){
                                if(!automaticupdateduedate)
								{
									openPopup('recalculateDueDate', showit, 190, 300);
								}
								else
								{
									 document.getElementById(dueDateCalculationOptionJS).value = 2; 
									 saveRecords();
								}
                            }else{
                                saveRecords();
                            }   
                        }else{
                            if(countDescription > 32000){
                                Ext.MessageBox.show({ msg:  IncidentPage.Labels.Description + ': ' + IncidentPage.Labels.TextAreaOverflow, width: 300, buttons: Ext.MessageBox.OK});         
                            }else if(countResolution > 32000){
                                Ext.MessageBox.show({ msg: IncidentPage.Labels.Resolution + ': ' + IncidentPage.Labels.TextAreaOverflow, width: 300, buttons: Ext.MessageBox.OK});
                            }
                        }
                    }else{
                        doSave = true;
                    }
		 }
                };
                
            saveFunctionRef = SaveBtnHandler;   

var incidentKMSearchHandler = function(button, event){
			updateDescription();
			KMdescription = KMdescription.replace(/</g,'&lt;');
			KMdescription = encodeURIComponent(KMdescription);
			openPopupforKM('KnowledgeSearch?calledFromForm=true&search='+KMdescription+'&KMincidentID='+incidentId,'',globalSearch,615,680);
}
			
var ServiceTargetsBtnHandler = function (button, event){
				openPopupForServiceTarget('SearchPage?popupId=IncidentServiceTarget&isLookup=true&amp;filterClause=' + escape('FKIncident__c=\''+ incidentId+'\''), ('#'+incidentName + ' ' + IncidentPage.Labels.ServiceTargets));
			}           

 var sendEmailBtnHandler = function (button, event){
                openPopupWithTitle('ComposeEmailPage?recordId='+incidentId+'&isNew=true&objectName=Incident__c',composeMailOnCompleteIn,IncidentPage.Labels.ComposeEmailPageHeader+incidentName, getEmailWinHt(), getEmailWinWidth(), false);
            }            
			
            var ClearBtnHandler= function(button,event) {clearIncident();
            Ext.getCmp('incident_inactive__c').setValue(false);                        //new one
            };         
            var CopyBtnHandler = function(button,event) {activeAllWindowFlag=false; callCopyPage(); };
            var ResetBtnHandler = function(button,event) { document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).value = ''; resetIncident(); };
           
            var DeleteBtnHandler = function(button,event) {                                                            
                                                         Ext.MessageBox.confirm(IncidentPage.Labels.Delete, IncidentPage.Labels.DeleteIncidentPage, function(btn){
                                                         if(btn === 'yes'){
                                                                   deleteIncident();
                                                          }});
                                                             };
            var AssignedToStaffBtnHandler = function(button,event) {  
                AssignedToStaff();
            };
            var AssignToMemberOfHandler= function(button,event) { 
				openPopup('SearchPage?popupId=Client&isLookup=true&additional_columns= name,username,firstname,lastname,phone,extension,email,ProfileId,Profile.Name&filterClause='+escape("profileid='" + getProfileID() + "'And IsStaffUser__c=true ")+'&isAssignTo=true',preSetAssignedToStaffNext);
                }
            var AssignToSuggestedStaffHandler = function(button,event) {  
                AssignToSuggestedStaff();
            };          
            var AssignedToMyselfBtnHandler  = function(button,event) {
                AssignedToMyself();
            };
            var AssignToQueueHandler = function(button,event) {
				openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Incident__c&isOnlyQueueList=true&additional_columns=Queue.Name,QueueId&filterClause='+escape("sobjectType='" + objName +"'"), preSetAssignedToSuggestedStaffNext);
			};
            var AssignedToClearBtnHandler  = function(button,event) { 
                AssignedToClear();
            };
            var CloseBtnHandler= function(button,event) { 
                saveBeforeCloseRecords();
            };
            var QuickCloseBtnHandler = function(button,event) { quickCloseIncident();};
            var ReopenBtnHandler = function(button,event) { 
                reopenIncident();
            };
            var IncidentForClient = function(button,event) { incidentForClient();};
            /// *********** Code by Vilas *************//
            var IncidentForClient = function(button,event) { incidentForClient();};
            var IncidentForCategory = function(button,event) { incidentForCatagory();};
            var RespondedBtnHandler = function (button,event) { window.parent.registerChange(wid2);respondedBtnHandler();};
            var MyselfBtnHandler = function (button,event) { myselfBtnHandler();};
            var CallCounterBtnHandler = function (button,event) { callCounterBtnHandler();}; 
            var PreviuosBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(previousIncidentBtnHandler1);				
			} else {  if(document.getElementById('prevId').disabled!=true) 
				        previousIncidentBtnHandler1();}
			}
			var NextBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(nextIncidentBtnHandler1);				
			} else {  if(document.getElementById('nextId').disabled!=true) 
				        nextIncidentBtnHandler1();}
			}
            var IncProcBtnHandler = function (button,event){ getIncProcBtnHandler()};
            var TemplateBtnHandler = function (button, event){
            var templateBtn = Ext.getCmp('templatebutton');
		if (incidentId != null && incidentId !='' && overwrite =='true') {
		  Ext.MessageBox.confirm('',IncidentPage.Labels.OverwriteWarning, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Incident'"),fetchIncidentTemplates,500,625)
                  }});
		}  
		else if((incidentId != null && incidentId !='' && overwrite =='false'&& changeDone == true) || (incidentId == null||incidentId =='' && templateBtn.disabled == false && overwrite =='false' && changeDone == true)) {
			    Ext.MessageBox.confirm('',IncidentPage.Labels.replaceUnsaved, function(btn){
                   if(btn === 'yes'){
                     openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Incident'"),fetchIncidentTemplates,500,625)
                  }});
		}
		else
                if(templateBtn.disabled == false ){
		   openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Incident'"),fetchIncidentTemplates,500,625);} };
            var SamplePanel = Ext.extend(Ext.Panel, {
                renderTo: 'btnToolbar',
                defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
            });
        
            new SamplePanel({
                title: '',
            cls:'toolSpCls',
                bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
                tbar: [ {
                    scale: 'medium',
                    iconCls: 'bmcNew',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.New,
                    id:'newId',
                    hidden:disableTrue,
                    handler:NewBtnhandler
                  
                } ,' ', {
                    scale: 'medium',
                    iconCls: 'bmcSave',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Save,
                    disabled : getSaveState(),
                    id:'saveId',
                handler:SaveBtnHandler
                    
                },' ',{
                    scale: 'medium',
                    iconCls: 'bmcCopy',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Copy,
                    id:'copyId',
                    hidden:disableTrue,
                    handler:CopyBtnHandler
                    
                },' ','-',' ',{
                    scale: 'medium',
                    iconCls: 'bmcDelete',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Delete,
                    id:'deleteId',
                     handler:DeleteBtnHandler
                   
                },' ',{
                    scale: 'medium',
                    iconCls: 'bmcRefreshDasboard',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Reset,
                    id:'resetId',
                    hidden:disableTrue,
                     handler:ResetBtnHandler
                    
                },' ',separator,' ',{
                    scale: 'medium',
                iconCls: 'bmcView1',
                tooltipType : 'title',
                tooltip: IncidentPage.Labels.ViewOpenIncidentsFor,
                id:'viewId',
                hidden:disableTrue,
                menu: [ {text:IncidentPage.Labels.IncidentsforClient, id:'IncidentsforClientId', icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            handler:IncidentForClient
                            
                             },
                        {text:IncidentPage.Labels.IncidentsforCategory, id:'IncidentsforCategoryId', icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            handler:IncidentForCategory
                        
                        }]
            },' ',{
                scale: 'medium',
                iconCls: 'bmcAssign1',
                tooltipType : 'title',
                tooltip: IncidentPage.Labels.AssignTo,
                id:'assignedToId',
                hidden:disableTrue,
                menu: [ {text:IncidentPage.Labels.IncidentsStaff, icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'assignToStaffButtonId',
                            disabled:getAssignStaffState(), 
                            handler:AssignedToStaffBtnHandler
                            
                          },
                        {text:IncidentPage.Labels.SuggestedExperts,disabled: 'true', icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',id:'assignToSuggestedStaffButtonId',disabled:getAssignSuggestedStaffState(),handler:AssignToSuggestedStaffHandler
                           
                        },
                         {text:IncidentPage.Labels.IncidentMyself, icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'assignToMyselfButtonId', 
                         disabled:getAssignMyselfState(), 
                         handler:AssignedToMyselfBtnHandler
                         },
                         {text:IncidentPage.Labels.IncidentMemberof + ' ' + getProfileName(), id:'assignToMemberOfAdminButtonId', 
                         disabled:getAssignMemberOfAdminState() ,icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',
                         handler:AssignToMemberOfHandler
                         },
                        {text:IncidentPage.Labels.Queue, icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', id:'assignToQueueButtonId', disabled:getAssignQueueState(), 
                          handler:AssignToQueueHandler
                            
                         
                         }]
            },' ',{
                scale: 'medium',
                iconCls: 'bmcAction1',
				id: 'actionButton',
                tooltipType : 'title',
                tooltip: IncidentPage.Labels.Actions,
                hidden:disableTrue,
                menu: [ 
                        {
                            text:IncidentPage.Labels.IncidentClose, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',
                            id:'closeButtonId',
                            disabled:getCloseState(), 
                            handler:CloseBtnHandler
                           
                            
                        },
                        {
                            text:IncidentPage.Labels.IncidentQuickClose, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',
                            id:'quickCloseButtonId', 
                            disabled:getCloseState(), 
                            handler:QuickCloseBtnHandler
                           
                            
                        },
                        {
                            text:IncidentPage.Labels.IncidentReopenIncident, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'reopenButtonId', 
                            disabled:getReOpenState(),
                            handler:ReopenBtnHandler
                            
                            
                        },
                        {
                            text:IncidentPage.Labels.IncidentIncrementCallCounter,
                            disabled:getCloseState(), 
                            id:'incrementCallButtonId',
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            handler:CallCounterBtnHandler
                            
                            
                        },
						 {
                            text:IncidentPage.Labels.IncidentResponded, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'respondedButtonId', 
                            disabled:getRespondedState(),
                            handler:RespondedBtnHandler
                           
                            
                        },
						{
                            text:Print, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'printButtonId', 
							disabled:IsNewRecord(incidentId),
                            handler:PrintBtnHandler
                           
                            
                        },
						{
                            text:PrintPDF, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'printPdfButtonId', 
							disabled:IsNewRecord(incidentId),
                            handler:PrintPDFBtnHandler
                           
                            
                        }
						,'-',customActionJsonString]
                },' ',{
                scale:'medium',
                iconCls: 'bmcTemplate',
                tooltipType : 'title',
                tooltip:IncidentPage.Labels.Template,
                id:'templatebutton',
                disabled:getFlagForTemplate(),
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
				
            },{
                scale:'medium',
                iconCls: 'bmcAPM',
                tooltipType : 'title',
                tooltip:IncidentPage.Labels.IncidentMgmtProcess,
                id:'incProcButton',
                handler:IncProcBtnHandler
            },' ', {
                    scale: 'medium',
                    iconCls: 'bmcEmailMessage',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Email,
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
            },' ', {
                    scale: 'medium',
                    iconCls: 'bmcServiceTargets',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.ServiceTargets,
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
            },' ', {
                    scale: 'medium',
                    iconCls: 'bmcKMSearch',
                    tooltipType : 'title',
                    tooltip: KMSearchLabel,
                    id:'incidentKMSearch',
					disabled: getSaveState(),
					listeners: {
						disable: function(){
							this.setIconClass('bmcKMSearchDisable');    
						},
						enable: function(){
							this.setIconClass('bmcKMSearch');          
						}
					},					
                    handler:incidentKMSearchHandler                                
            },' ','-',' ',{ 
				scale: 'medium',
				iconCls: 'bmcCIExplorer',
				tooltipType : 'title',
				tooltip: IncidentPage.Labels.LaunchCIExplorer, 
				id:'CIExpBut',
				listeners: {
					disable: function(){
						this.setIconClass('bmcCIExplorerDisable');    
					},
					enable: function(){
						this.setIconClass('bmcCIExplorer');          
					}
				},
				handler: ShowCIExplorer 
			}, 
            new Ext.Toolbar.Fill(), 
            {
                  id :'incident_inactive__c',
               xtype  : 'checkbox',
               width  : 93,
               color :'#004376',
               align:'top',
               checked: false,
               boxLabel:'<span class="checkboxLabelCls" style="font-family: Tahoma, MS Sans Serif;font-size: 11px;">' + IncidentPage.Labels.Inactive  +'</span>',
               listeners:{
                    render:function(){
                        Ext.QuickTips.register({
                            target:this,
                            text:IncidentPage.Labels.TooltipIncidentInactive,
                            dismissDelay: 20000
                        });
                    }               
               }    
              
            }, {
               
               
                xtype : 'box',
                id    : 'prevId',
                autoEl:  {tag: 'img', 
                          src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif'),   
                         title:IncidentPage.Labels.PreviousRecord
                         },
                          
                cls:'cursorCls',
               listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
                             
            },{
               
                xtype : 'box',
                id    : 'nextId', 
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
                          title:IncidentPage.Labels.NextRecord },
                cls:'cursorSpaceCls',
                listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
               
                
            }
            ] 
        });
        
        if(isInactive){             
        Ext.getCmp('incident_inactive__c').setDisabled(true);      
       
        }


	if(copymetrue){  
        Ext.getCmp('saveId').setDisabled(true);
    	}

        
        Ext.getCmp('incident_inactive__c').setValue(getInactive());         // new one
        incidentId = getIncidentID();
        incidentState = getStateVar();
          
        if(incidentId == null || incidentId == ''){
            Ext.getCmp('emailId').setDisabled(true);
            Ext.getCmp('emailId').setIconClass('bmcEmailMessageDisable');            
                
            Ext.getCmp('deleteId').setDisabled(true);
            Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
            Ext.getCmp('copyId').setDisabled(true);
            Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
            Ext.getCmp('prevId').setDisabled(true);
            Ext.getCmp('nextId').setDisabled(true);
            Ext.getCmp('resetId').setDisabled(true);
            Ext.getCmp('IncidentsforClientId').setDisabled(true);
            Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
        }else if(incidentId != null){
            Ext.getCmp('saveId').setDisabled(!incnState);
            Ext.getCmp('closeButtonId').setDisabled(!incnState);
            Ext.getCmp('quickCloseButtonId').setDisabled(!incnState);
            Ext.getCmp('reopenButtonId').setDisabled(incnState);
			Ext.getCmp('emailId').setDisabled(!incnState);			
        }
        
           
        if(incidentId == null || incidentId == ''){
            Ext.getCmp('templatebutton').setDisabled(false);
            Ext.getCmp('templatebutton').setIconClass('bmcTemplate');
			if(document.getElementById('linkSIAvailTD')!=null)
				document.getElementById('linkSIAvailTD').style.display = 'none';
            if(document.getElementById('noSIAvailTD')!=null)
            	document.getElementById('noSIAvailTD').style.display = 'block';
        }

          else if(incidentId != null){
			if(setcheckforTemplate == 'true'){
				Ext.getCmp('templatebutton').setDisabled(!incnState);
			}
			else{
						Ext.getCmp('templatebutton').setDisabled(true);
						Ext.getCmp('templatebutton').setIconClass('bmcTemplateDisable');
				}
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
			if(!isCookiePresent){
				if(document.getElementById('noSIAvailTD')!=null)
					document.getElementById('noSIAvailTD').style.display = 'none';
				if(document.getElementById('linkSIAvailTD')!=null)
					document.getElementById('linkSIAvailTD').style.display = 'block';
			}
		}  
		EnableAdditionalCILink();
       document.getElementById('capsule').style.display = 'block';
       var canvasPanel = new Ext.Panel({
             layout:'border',
             height:Ext.isIE7 ? 670: Ext.isIE ? 674:Ext.isSafari ? 695:680,
             border:false, 
             id:'canvasPanelId',
            cls:'canvasPanelCls',
             items:[{  
                    xtype: 'panel', 
                      layout: 'fit',                                                   
                    overflow:'auto',
                    autoScroll:true,
                    split:false,
                    width:'auto',    
                    height:480, 
                    cls:'northPanelCls',
                                                                 
                    region: 'center',                   
                               
                    contentEl : Ext.isIE ? 'capsule' : IncidentPageComp.ComponentVars.IncidentForm
                    
            },{                                                         
                    xtype: 'panel', 
                    layout: 'fit',  
                    overflow:'auto',
                     border:false, 
                     id:'southPanelSI',
                    autoScroll:true,
                    split:true,
                    collapsible: true,
                    collapseMode: 'mini',
                    width:'auto',    
                    height:Ext.isIE ?205:210,
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
                    c.layout.south.miniSplitEl.dom.qtip = IncidentPage.Labels.DragResizeClickCollapse;
                    c.layout.south.getCollapsedEl();
                    c.layout.south.miniCollapsedEl.dom.qtip = IncidentPage.Labels.ClickToExpand;
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

            handleElemEvent();
        disabledatefield ();
        converdisabletoreadonly();   
        if(incidentId == null || incidentId == ''){
            var uname= document.getElementById(IncidentPageComp.ComponentVars.UserLastName).value;
            if(uname == null || uname == ''){
               try{
                    document.getElementById(IncidentPageComp.ComponentVars.UserLastName).focus();
               }catch(e){}
            }
        }
            
              
        var NoRightsToViewEdit = getNoRightsToViewEdit();
        if(isRecordDeleted()) 
		{
		Ext.Msg.alert(IncidentPage.Labels.Information,IncidentPage.Labels.DeletedRecord, function(){
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
        
       
	
	pageloadstartdate = 0 ;
        pageloadstartdate = new Date() ;
	
        var t1 = pageloadstartdate.getTime();
        var t2 = windowloaddate.getTime();
 	var pagerendertime =(t1 - renderingstartitme);
      	data += IncidentPage.Labels.PM_PageLoad;
        data += pagerendertime;
		var portletTemplateId = getPortelTemplateId();
		if(portletTemplateId != null && typeof(portletTemplateId) != 'undefined' && portletTemplateId != '')
			fetchIncidentTemplates(portletTemplateId);
			
		

		ChangeServiceTargetButtonState();
		UpdateDueDateFieldState();
		updateKM();
		ChangeCIExpBtnStatus(cilink_record);
    });
	
	function UpdateDueDateFieldState()
	{
		if (!(typeof(document.getElementById(IncidentPageComp.ComponentVars.DueDateTime)) == 'undefined' || document.getElementById(IncidentPageComp.ComponentVars.DueDateTime) == null))
		{
			if (isDueDateOverridenByServiceTarget() == true)
			{
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).disabled = true;
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).readOnly = true;
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).className = "clsPanelInputTextboxReadOnly";
			}
			else
			{
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).disabled = false;
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).readOnly = false;
				document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).className = "clsPanelInputTextbox";
			}
		}
	}
	
	function ChangeServiceTargetButtonState(){
	  if(typeof(Ext.getCmp('servicetargets'))!='undefined' && Ext.getCmp('servicetargets')!=null) {
		if(!hasServiceTargets){
			Ext.getCmp('servicetargets').disable();
		} else {
			Ext.getCmp('servicetargets').enable();
		}
	  }
	}
    
	function writeCookie(){
		if(document.getElementById('configureSIId').checked){
			createSICookie(cookieName,'true');
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
		}
	}
	

function checkSave(){
            
            if(doSave){
                saveFunctionRef();
            }
        
        }

            
function handleResetChange(){
	if(clickedOnce){
	   clickedOnce = false;
	   window.parent.registerSave(wid2);
   }
   }
function openCategoryPage(returnValues){ 
            if(returnValues != null || returnValues != '')
            {
                if(returnValues[0] != null ||returnValues[0] !='' ) {
                     	var Category__c_id_id=returnValues[3];
						categoryName=returnValues[0];
						setIncForCategoryEnabled();
						checkSave();
						if(returnValues[4] != null && returnValues != 'undefined'){
							document.getElementById(IncidentPageComp.ComponentVars.CategoryFKUrgency).value = returnValues[4];
						}
						setCatData(Category__c_id_id, categoryName);
                    }
                    if(returnValues[1] != null || returnValues[1] != '') {
                           setDescriptionNext(returnValues[1]); //Calling Action Function
                    }
                    if(returnValues[2] != null || returnValues[2] != ''){
                        setResolutionNext(returnValues[2]); //Calling Action Function
                    }
             }
            
} 

        
function openImpactLookup(impactId,add_info) {  
	var all_add_info=add_info.split('П');
	for(var i=0;i<all_add_info.length;i++){
		var add_info_val=all_add_info[i].split(':');
		 var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:'';
		 fieldValue=decodeSpecialChar(fieldValue);
		if(add_info_val[0] =='name')
		  document.getElementById(IncidentPageComp.ComponentVars.ImpactIDName).value=fieldValue;
		if(add_info_val[0] =='id'){
		   document.getElementById(IncidentPageComp.ComponentVars.ImpactID).value=fieldValue;  
		}
	}          
	if(impactId != null && impactId != '' ){
			 FetchPriorityHTTP();
	}               
}
function previousIncidentBtnHandler1(){
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
        previousIncidentBtnHandler(idSetString);
}
function nextIncidentBtnHandler1(){
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
		nextIncidentBtnHandler(idSetString);
}
function  AssignedToStaff(){
         openPopup('SearchPage?popupId=Client&isLookup=true&additional_columns=name,username,firstname,lastname,phone,extension,email,ProfileId,Profile.Name&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true',preSetAssignedToStaffNext);                               
}

function  AssignToSuggestedStaff(){
	selectedModuleName = 'staff';
	openPopup('SearchPage?popupId=SuggestedStaff&isSuggestExpert=true&isLookup=true&queueFor=Incident__c&isQueurorUser=true&isActiveUser=true&additional_columns=FKUser__r.firstname,FKUser__r.lastname,FKUser__r.phone,FKUser__r.extension,FKUser__r.email,FKUser__r.ProfileId,FKUser__r.Profile.Name,QueueName__c,QueueId__c,FKUser__r.Id&categoryId='+incidentCategory+'&filterClause='+escape("FKUser__r.IsStaffUser__c=true"),preSetAssignedToSuggestedStaffNext);                               
}
function AssignedToMyself(){
        //waitbox(0);
        //AssignedToMyselfNext();
		 Ext.getCmp('assignToMyselfButtonId').setDisabled(true);
		 toggleStaffTooltipState(true);
		 document.getElementById(IncidentPageComp.ComponentVars.incidentOwnerId).value=loggedInUserId;
		 document.getElementById(IncidentPageComp.ComponentVars.staff_firstname).value=loggedInUserFirstName; 
         document.getElementById(IncidentPageComp.ComponentVars.staff_laststname).value= loggedInUserLastName; 
         document.getElementById(IncidentPageComp.ComponentVars.staff_phone).value=''; 
         document.getElementById(IncidentPageComp.ComponentVars.staff_extension).value=''; 
         document.getElementById(IncidentPageComp.ComponentVars.staff_profilename).value=''; 
		 document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value='';
		 handleChange(null);	
}
function deleteIncident(){
        deleteIncidentNext();
}
function quickCloseIncident(){
        quickCloseIncidentNext();        
}

function reopenIncident(){
	reopenIncidentNext();
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

function isValidDate(){
isValid ='True';
            var temp =document.getElementById(IncidentPageComp.ComponentVars.DueDateTime).value;
            }   
     
       
        function DisableCIExpBtn(){
			var CI_new_value = document.getElementById(IncidentPageComp.ComponentVars.BaseElementIDName).value;
			var service_new_value=document.getElementById(IncidentPageComp.ComponentVars.serviceIDName).value;
			
			if((CI_new_value!=null && CI_new_value!= '') || (service_new_value!=null && service_new_value!= '')){
				   Ext.getCmp('CIExpBut').setDisabled(false);
            }else{
			       Ext.getCmp('CIExpBut').setDisabled(true);
			}
        }
		
		function setIncForCategoryEnabled(){
            if(getcategoryName() != ''){
                Ext.getCmp('IncidentsforCategoryId').setDisabled(false);
            }else{
                Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
            }
        }
		
		function setClientDetails(returnvalue) {
            setClientNext(returnvalue);
            if (returnvalue != null) {
// IE7-8 Related Changes
                document.getElementById(IncidentPageComp.ComponentVars.UserID).value = returnvalue;
            }
        }
		
		function incidentForClient(){
        var clientId = document.getElementById(IncidentPageComp.ComponentVars.UserName).value;
		var recordId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
        
        if(clientId != null && clientId != ''){
            openPopup('SearchPage?popupId=Incident&filterObj=1&clientId='+ 
                recordId+'&isLookup=true',setIncidentNext);           
        }   
    }
    
    function incidentForCatagory(){
 		var categoryName = getcategoryName();
        if(categoryName != ''){
			categoryName = encodeURIComponent(categoryName);
            openPopup('SearchPage?popupId=Incident&filterObj=3&categoryId='+
                categoryName+'&isLookup=true',setIncidentNext);                           
        } 
    }
    function setIncidentForMenu(){
        var clientName = document.getElementById(IncidentPageComp.ComponentVars.UserName).value;
        var clientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
        if(clientId != null && clientId != '' && clientName != '' && clientName != null){
            Ext.getCmp('IncidentsforClientId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforClientId').setDisabled(true);
        } 
        if(getcategoryName() != ''){
            Ext.getCmp('IncidentsforCategoryId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
        }
    }
    function FetchUrgency(){
        var clientName = document.getElementById(IncidentPageComp.ComponentVars.UserName).value;
        var clientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
        
        if(clientId != null && clientId != '' && clientName != '' && clientName != null){
            Ext.getCmp('IncidentsforClientId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforClientId').setDisabled(true);
        } 
        if(getcategoryName() != ''){
            Ext.getCmp('IncidentsforCategoryId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
        }
        FetchUrgencyDetails(clientId);
    }
    
	function getcategoryName()
	{
		var categoryName = '';
		if(document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName)!=null && document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName)!='')
			categoryName = document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName).value;
		return categoryName;
	}
    
    function FetchUrgencyForCategoryTabOut(){
      
        var clientId = document.getElementById(IncidentPageComp.ComponentVars.UserName).value;
        var categoryUrgency=document.getElementById(IncidentPageComp.ComponentVars.CategoryFKUrgency).value;
        if(clientId != null && clientId != ''){
            Ext.getCmp('IncidentsforClientId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforClientId').setDisabled(true);
        } 
        if(getcategoryName() != ''){
            Ext.getCmp('IncidentsforCategoryId').setDisabled(false);
        }else{
            Ext.getCmp('IncidentsforCategoryId').setDisabled(true);
        }
        var urgenycId = document.getElementById(IncidentPageComp.ComponentVars.UrgencyIDName).value
        }
	
	function ChangeCIExpBtnStatus(link_record){
	        CI_value = document.getElementById(IncidentPageComp.ComponentVars.BaseElementIDName).value.trim();
			service_value=document.getElementById(IncidentPageComp.ComponentVars.serviceIDName).value.trim();
			
			if((0==CI_value.length) && (0==service_value.length) && (link_record=='false'  || typeof(link_record) == 'undefined') ){
			 Ext.getCmp('CIExpBut').setDisabled(true);
			}else{
			Ext.getCmp('CIExpBut').setDisabled(false);
			}
        }
    
    function clientLookUp(){
        showalldata(event,IncidentPageComp.ComponentVars.PBarItemIDCD);
        FetchUrgencyName();
    }
    function copyIncident(){
    
        }
    function selectBroadcast(){
        var broadcastName = document.getElementById(IncidentPageComp.ComponentVars.BroadcastIDName).value;
        if(broadcastName == ''){
            setBroadcastNextFromTabout(broadcastName);
        }   
    }
	
	function saveRecords(){
    chkBoxValue=Ext.getCmp('incident_inactive__c').getValue(); //new one
        isValidDate();
        if(isValid=='True'){
		waitbox(0);
		Ext.getCmp('saveId').setDisabled(true);		
        saveIncident(chkBoxValue,ownerIdString,KMids);
		
        }else{
            Ext.MessageBox.show({ msg: IncidentPage.Labels.ValidDateTime, buttons: Ext.MessageBox.OK});
        }
	}

	
	function saveBeforeCloseRecords(){
    chkBoxValue=Ext.getCmp('incident_inactive__c').getValue(); //new one
        isValidDate();
		waitbox(0);
        if(isValid=='True'){        
            saveBeforeCloseIncident(chkBoxValue,KMids);
        }else{
            Ext.MessageBox.show({ msg: IncidentPage.Labels.ValidDateTime, buttons: Ext.MessageBox.OK});
        }
}

function getINCid(incId,isSave){
    if(errormsg == null||errormsg ==''||errormsg==IncidentPage.Labels.SavedSuccessfully){
            setId(incId,isSave);
        }else{
            setId(incId,isSave);
        }
}     

function buttonValidator() {
    
    if((incidentClient  != null && incidentClient != '')&&
        ( ((categoryRequired=='false') ||(incidentCategory != null && incidentCategory != '')) || copymetrue) &&
        (errormsg == null||errormsg ==''||errormsg==IncidentPage.Labels.SavedSuccessfully)){   
		
		if(setcheckforTemplate == 'true'){
			Ext.getCmp('templatebutton').setDisabled(false); 
			Ext.getCmp('templatebutton').setIconClass('bmcTemplate');
		
		}else{
			Ext.getCmp('templatebutton').setDisabled(true);
			Ext.getCmp('templatebutton').setIconClass('bmcTemplateDisable');
        }
			Ext.getCmp('saveId').setDisabled(!incnState);
			Ext.getCmp('emailId').setDisabled(!incnState);
			copymetrue = false;
			Ext.getCmp('deleteId').setDisabled(false);
			 Ext.getCmp('deleteId').setIconClass('bmcDelete');
			Ext.getCmp('copyId').setDisabled(false);
			Ext.getCmp('resetId').setDisabled(false);
			Ext.getCmp('viewId').setDisabled(false);
			Ext.getCmp('printButtonId').setDisabled(false);
			Ext.getCmp('printPdfButtonId').setDisabled(false);
		   
			Ext.getCmp('copyId').setIconClass('bmcCopy');
			
			Ext.getCmp('viewId').setIconClass('bmcView1');
			var isDisplay = document.getElementById('SIIframeID').style.display;
			if(cookieValue =='true' && isDisplay =='none' ){
				SIComp('/apex/SIContainerPage?oid='+incidentId+'&otype=Incident__c&wid='+wid+'&stateofIncident='+closeState+ '&isChangeCreatable='+getIsChangeCreatable()+'&isInactive='+isIncInactive);
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
			var incidentFeed=getIncidentFeed();
			if (incidentFeed != null && incidentFeed == 'true') {
				
		} 
	}   
	if((incidentClient  != null || incidentClient != '')&&
        (incidentCategory == null || incidentCategory == '')){  
		Ext.getCmp('copyId').setDisabled(false);
		Ext.getCmp('copyId').setIconClass('bmcCopy');
	}
	
	EnableAdditionalCILink();
}

function closedRelatedBroadcasts(){
    
    if(hasRelatedBRD){
    isclosebroadcast = false;
           Ext.MessageBox.confirm('', IncidentPage.Labels.IncidentRelatedBroadcastsChanges, function(btn){
                   if(btn === 'yes'){
                      isclosebroadcast = true;
                      closeBroadcasts(isclosebroadcast);
                  }else{
                      closeBroadcasts(isclosebroadcast);

                  }});
      }
 }
var windownameflag =0;
   function showData(event,onCompleteFunction,whereClause,windownameflag){
	if(isAutocomplete)
   				return ; 

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

function ellipse(fieldstring,maxlength)
{
    if(fieldstring.length > maxlength )
    {
       return fieldstring.substr(0, maxlength-3) + '...';
    }
    return fieldstring;
}
function formCSZString(city,state,zip)
{
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


function afterResetSI(){
    var modName = getModName();  
    var parentWid = getParentWid();
    if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && 
    	parentWid != '' && typeof(parentWid) != 'undefined' && errormsg==IncidentPage.Labels.SavedSuccessfully){
		window.parent.registerSave(wid);
        window.parent.parent.refreshSupportingInformation(parentWid,modName);
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
function renderPrbId(problemID,prbName){
	document.getElementById(IncidentPageComp.ComponentVars.ProblemIDName).value = prbName;
	document.getElementById(IncidentPageComp.ComponentVars.ProblemID).value = problemID;
}
function afterSaveAction(){
    var modName = getModName();  
    var parentWid = getParentWid();
    if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && 
    	parentWid != '' && typeof(parentWid) != 'undefined' && errormsg==IncidentPage.Labels.SavedSuccessfully){
        return true;
    }else{
        showError();
    }
}

function tooltipforclientJS(clientFirstName, clientLastName, clienttitle, cszstring, clientCountry, clientPhone, clientEmail){
    document.getElementById('clientNameforttdivId').innerHTML = ellipse(clientFirstName,25)+' '+ellipse(clientLastName,25);
    document.getElementById('clientTitleforttdivId').innerHTML = ellipse(clienttitle,40);
    var strSingleLineText = document.getElementById('clientAddressforttdivId').innerHTML.replace(new RegExp( "\\n", "g" ), ' ');
    document.getElementById('clientAddressforttdivId').innerHTML = ellipse(strSingleLineText,33);
    document.getElementById('clientCSZforttdivId').innerHTML = cszstring ;
    document.getElementById('clientCountryforttdivId').innerHTML = ellipse(clientCountry,33);
    document.getElementById('clientPhoneforttdivId').innerHTML = ellipse(clientPhone,33);
    document.getElementById('clientEmailforttdivId').innerHTML = '<a href="' + clientEmail + '" class="clsCmdLinkTooltip">'+ellipse(clientEmail,33)+'</a>';
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


function getIncProcBtnHandler(){
	var incProcPage = 'NavigatorPage?title='+IncidentPage.Labels.IncidentProcess+'&target=IncProcMgmtPage?id=1001';
	window.parent.parent.addNewTab('Incident Process', IncidentPage.Labels.AlignabilityProcessModel, incProcPage, 'false');
}


function setElHeight(obj,value){
			if(obj.style.height=='0pt'){
				obj.style.height = '25pt';
				obj.value = '';
			}
			else if (obj.style.height=='25pt' && obj.value == ''){
				obj.style.height = '0pt';
				obj.value = value;
			}
		}

function composeMailOnCompleteIn(){
var isDisplay = document.getElementById('SIIframeID').style.display;
	if(window.frames.SIIframeID != null && typeof(window.frames.SIIframeID) != 'undefined'){
		if(isDisplay != 'none'){
			document.getElementById('SIIframeID').contentWindow.composeMailOnComplete();
		}
	}
}

function refreshChatterFeed(){
			refreshFeed(); 
		}

function shareTextPost(textPostBody) {
			if(textPostBody.length > 1000)
			{                       
				Ext.MessageBox.show({ msg: IncidentPage.Labels.TextAreaOverflowForChatter, buttons: Ext.MessageBox.OK});         
				return false;
			}
			waitbox(0);
			shareStatusPost(textPostBody); 
		}              

function deleteCommentFromFeed(commentID,createdByID){
	Ext.MessageBox.confirm(IncidentPage.Labels.ConfirmHomePage, IncidentPage.Labels.ChatterDeleteComment, function(btn){
		if(btn === 'yes'){
			deleteComment(commentID,createdByID);
		}
	});	
}
function deleteFeedPost(feedPostID,createdByID){
	Ext.MessageBox.confirm(IncidentPage.Labels.ConfirmHomePage, IncidentPage.Labels.ChatterDeletePost, function(btn){
		if(btn === 'yes'){
			deletePost(feedPostID,createdByID);
		}
	});	 
}

function setDisplay(id,value){ 
		    document.getElementById(id).style.display = value; 
		}

function createNewComment(divId, feedId){
	var inputtext = divId.getElementsByTagName('input')[0]; 
	if(inputtext.value.length > 1000){                       
		Ext.MessageBox.show({ msg: IncidentPage.Labels.TextAreaOverflowForChatterComment, buttons: Ext.MessageBox.OK});         
		return false;
	}
	else if(inputtext.value.trim().length <= 0){
		Ext.MessageBox.show({ msg: IncidentPage.Labels.EmptyValueForChatterComment, buttons: Ext.MessageBox.OK});         
		divId.getElementsByTagName('input')[0].focus();
		return false;
	}
	else{
		waitbox(0);
		NewCommentValue(inputtext.value,feedId);
	}
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

function renderAddNoteButton_JS(elem,elemduration,incidentState){
            if(elem != null){
                var btn = document.getElementById('addNoteBtn');
	            var val = elem.value.trim();
	            if(incidentId == null || incidentId == '' || val==null || val =='' || incidentState == 'false'){
                    btn.disabled= true; btn.className = 'AddButtonOff';
	            }else{
                    btn.disabled= false;  btn.className = 'AddButton';
	            }
	            if(incidentId == null || incidentId == '' || incidentState == 'false'){
	            	elem.disabled  = true;
                    elem.className = 'clsInputTextAreaDisabledNote';    
	        		elemduration.disabled = true;
	        		elemduration.className = 'clsDurationTextBoxDisable';   
	            }else{
				   if(isNoteEnableFlag){
                     elem.value='';
                     isNoteEnableFlag=false;
                    }
	            	elem.disabled  = false;
                    elem.className = 'clsInputTextAreaNote';
	        		elemduration.disabled = false;
	        		elemduration.className = 'clsDurationTextBox';   
	            }
	        }
	    }

function validateDuration_JS(incidentDuration){
           if(incidentDuration != ''){
				var split = incidentDuration.split(':');
				if(split[0].length == 1){
					incidentDuration = '0'+incidentDuration;
					document.getElementById(IncidentPageComp.ComponentVars.IncidentDuration).value = incidentDuration;
					durationError = 0;
				}			
				var timePat = /^([0-9]{2}):([0-9]{2})$/;
  	            var matchArray = incidentDuration.match(timePat);
				if (matchArray == null) {
					durationError = 1;
					Ext.MessageBox.show({ msg: IncidentPage.Labels.DurationError, buttons: Ext.MessageBox.OK});
		document.getElementById(IncidentPageComp.ComponentVars.IncidentDuration).value = '00:00';
				}                  
           }
       }

function enableAddNote_JS(){
            if((errormsg!='' && errormsg!=null) || errormsg == IncidentPage.Labels.DurationError){
                var btn = document.getElementById('addNoteBtn');
                btn.disabled= false; btn.className = 'AddButton';             
	            var incidentNote = document.getElementById(IncidentPageComp.ComponentVars.IncidentNotes);
	            incidentNote.disabled = false;
                incidentNote.className = 'clsInputTextAreaNote';    
	        	var elemduration = document.getElementById(IncidentPageComp.ComponentVars.IncidentDuration);
	           	elemduration.disabled = false;
         		elemduration.className = 'clsDurationTextBox'; 	
         		elemduration.value = '00:00';
       		}
       }
	   
function disableAddNote_JS(incidentNote,incidentDuration) {
		   validateDuration_JS(incidentDuration);
		   if(durationError != 1){
	           if(incidentNote.length > 32000){                       
	                Ext.MessageBox.show({ msg:  IncidentPage.Labels.Note + ': ' + IncidentPage.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});         
	           }else{          
                   var btn = document.getElementById('addNoteBtn');
                   btn.disabled= true; btn.className = 'AddButtonOff';
	               saveNote(incidentNote,incidentDuration);
	           }		   
		   }
		   durationError = 0;
       }
	   
 function renderIncidentNote_JS(){
			 if((errormsg!='' && errormsg!=null) || errormsg == IncidentPage.Labels.DurationError){
                Ext.MessageBox.show({ msg: errormsg, buttons: Ext.MessageBox.OK});
			} else {
	        	var elem = document.getElementById(IncidentPageComp.ComponentVars.IncidentNotes);
	        	if(elem != null){
		            elem.disabled = false;
                    elem.className = 'clsInputTextAreaNote';
		           	elem.value = '';
					if(insideNote == false){
						clickedOnce = true;  
						handleResetChange(); 
					}
				}
	        	var elemduration = document.getElementById(IncidentPageComp.ComponentVars.IncidentDuration);
	        	if(elemduration != null){
		            	elemduration.disabled = false;
		           		elemduration.value = '00:00'; 	
		            }
	        } 
	   }
	   
function loadChatterFeeds(){
			if(!this.FeedsVisible)
			{
				showChatterFeeds();
		    	this.FeedsVisible = true;
			}
		}
function siControlBack(){
	var cookieval =Ext.util.Cookies.get(cookieName);
	var isDisplay = document.getElementById('SIIframeID').style.display;
    	if((cookieval == null || cookieval == 'false' ) && isDisplay =='none'){
			afterResetSI();
		}
	if(incidentCloseState == 'true' && errormsg != IncidentPage.Labels.SavedSuccessfully){
		Ext.getCmp('saveId').setDisabled(false);	
	}	
}
function SetIncidentCategory(categoryId){
	if(categoryId != null && categoryId != ''){
		incidentCategory  = document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName).value;; 
	}
}
function DisplayChatterLimitMessage(){
	var chatterLimitError = getChatterLimitErrorMessage();
	if(chatterLimitError != "" && chatterLimitError != null && chatterLimitError.length > 0){
		Ext.MessageBox.show({ msg: chatterLimitError, buttons: Ext.MessageBox.OK});
	}
}
function preSetAssignedToStaffNext(saveId,add_info){
	waitbox(0);
	if(add_info !=null && add_info!=undefined){
        var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:'';
		  fieldValue=decodeSpecialChar(fieldValue);
          if(add_info_val[0].toLowerCase() =='firstname')
              document.getElementById(IncidentPageComp.ComponentVars.staff_firstname).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='lastname')
               document.getElementById(IncidentPageComp.ComponentVars.staff_laststname).value= fieldValue; 
          if(add_info_val[0].toLowerCase() =='phone')
               document.getElementById(IncidentPageComp.ComponentVars.staff_phone).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='extension')
               document.getElementById(IncidentPageComp.ComponentVars.staff_extension).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='profile.name')
               document.getElementById(IncidentPageComp.ComponentVars.staff_profilename).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='queue')
               document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value=fieldValue; 			   
           
         }
	 }
	 if(saveId != null && saveId != '' ){
		 document.getElementById(IncidentPageComp.ComponentVars.incidentOwnerId).value=saveId;
		 document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value='';
		toggleStaffTooltipState(true);
		Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
		handleChange(null);
	 }	 
	 waitMsg.hide();
}
function toggleStaffTooltipState(staffTooltipState){
	document.getElementById('staffInfobtn').disabled = staffTooltipState;
}
function preSetAssignedToSuggestedStaffNext(saveId,add_info){
	
	if(add_info !=null && add_info!=undefined){
        var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:'';
		  fieldValue=decodeSpecialChar(fieldValue);
		  
          if(add_info_val[0].toLowerCase() =='fkuser__r.firstname')
              document.getElementById(IncidentPageComp.ComponentVars.staff_firstname).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='fkuser__r.lastname')
               document.getElementById(IncidentPageComp.ComponentVars.staff_laststname).value= fieldValue; 
          if(add_info_val[0].toLowerCase() =='fkuser__r.phone')
               document.getElementById(IncidentPageComp.ComponentVars.staff_phone).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='fkuser__r.extension')
               document.getElementById(IncidentPageComp.ComponentVars.staff_extension).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='fkuser__r.profile.name')
               document.getElementById(IncidentPageComp.ComponentVars.staff_profilename).value=fieldValue; 
          if(add_info_val[0].toLowerCase() =='queuename__c')
               document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value=fieldValue;
          if(add_info_val[0].toLowerCase() =='queueid__c'){
        	  document.getElementById(IncidentPageComp.ComponentVars.incidentOwnerId).value=fieldValue;
			  toggleStaffTooltipState(true);
		  }  
          if(add_info_val[0].toLowerCase() =='queue.name')
              document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value=fieldValue;
         if(add_info_val[0].toLowerCase() =='queueid'){
       	  document.getElementById(IncidentPageComp.ComponentVars.incidentOwnerId).value=fieldValue;
			 document.getElementById(IncidentPageComp.ComponentVars.staff_firstname).value=''; 
			 document.getElementById(IncidentPageComp.ComponentVars.staff_laststname).value= ''; 
			 document.getElementById(IncidentPageComp.ComponentVars.staff_phone).value=''; 
			 document.getElementById(IncidentPageComp.ComponentVars.staff_extension).value=''; 
			 document.getElementById(IncidentPageComp.ComponentVars.staff_profilename).value=''; 
			 toggleStaffTooltipState(true);
		 } 

          if(add_info_val[0].toLowerCase() =='fkuser__r.id'){
        	  document.getElementById(IncidentPageComp.ComponentVars.incidentOwnerId).value=fieldValue;
			  document.getElementById(IncidentPageComp.ComponentVars.staff_queue).value='';
			  toggleStaffTooltipState(true);
		  }
         }
		 Ext.getCmp('assignToMyselfButtonId').setDisabled(false);
		 handleChange(null);
	}
}

function oncompleteForCILookup(){
    DisableCIExpBtn();
	converdisabletoreadonly();

}
function convertUserCalledToInt(){
	if(document.getElementById(IncidentPageComp.ComponentVars.usercalledID).value!=null && document.getElementById(IncidentPageComp.ComponentVars.usercalledID).value!='') {
		var UserCalled = parseInt(document.getElementById(IncidentPageComp.ComponentVars.usercalledID).value);
		document.getElementById(IncidentPageComp.ComponentVars.usercalledID).value = UserCalled;   
	}
}
function copyResolutionAndCloseIncident(commentBody)	{
	document.getElementById(IncidentPageComp.ComponentVars.IncidentResolution).value = commentBody;
	quickCloseIncident();
}
function updateInactive(){ 
	Ext.getCmp('incident_inactive__c').setValue(isIncInactive);
	//added for custom fields
	createControlMap();
	renderElementsByType();             
} 
function refreshRelatedPortlets(){
	if(typeof(window.parent.parent.refreshActionItemsPortlet) == 'function')
			window.parent.parent.refreshActionItemsPortlet('Action Items','INC');
	if((getIsChildTempExist() == 'true' || getIsChildTempExist() == true)&& typeof(window.parent.parent.refreshActionItemsPortlet) == 'function'){
			window.parent.parent.refreshActionItemsPortlet('Action Items','TASK');
	}
	clearTimeout(timeoutreturn);
} 
function refreshBroadcastReleatedPortlets(){
	if(typeof(window.parent.parent.refreshPortletByTitle) == 'function')
		window.parent.parent.refreshPortletByTitle('Broadcasts');
	if(typeof(window.parent.parent.refreshActionItemsPortlet) == 'function')
			window.parent.parent.refreshActionItemsPortlet('Action Items','BROAD');
}    
function callFetchUrgencyHTTPJS(clientId, catId, clientUrgency, catUrgency){
	if(clientId == '' && catId == ''){
		return false;
	}else if(clientId == '' && catId != '' && catUrgency != ''){
		return true;
	}else if(clientId != '' && catId == '' && clientUrgency != ''){
		return true;
	}else if(clientId != '' && catId != ''){
		if(catUrgency != '' || clientUrgency != '')
			return true;
		else 
			return false; 	
	}		
	return false;
}   
function disableSIMenu(){
	if(document.getElementById(IncidentPageComp.ComponentVars.StatusId).value== 'CLOSED'){
		window.frames.SIIframeID.disableAll();
	}
}
function reopenedRelatedBroadcasts(){
  if(hasRelatedBRD){
  isclosebroadcast = false;
	  Ext.MessageBox.confirm('', IncidentPage.Labels.IncidentRelatedBroadcastsChanges, function(btn){
			   if(btn === 'yes'){
				  isclosebroadcast = true;
				  reopenBroadcasts(isclosebroadcast);
			  }else{
				  reopenBroadcasts(isclosebroadcast);

			  }});

 }
} 
function renderSIComponent(){
	if(cookieValue == true || cookieValue =='true')
		SIComp('/apex/SIContainerPage?oid='+incidentId+'&otype=Incident__c&wid='+wid+'&stateofIncident='+closeState+'&isChangeCreatable='+getIsChangeCreatable()+'&isInactive='+isIncInactive);
	else     
		removeSI('/apex/SIContainerPage?oid='+incidentId+'&otype=Incident__c&wid='+wid+'&stateofIncident='+closeState+'&isChangeCreatable='+getIsChangeCreatable()+'&isInactive='+isIncInactive);
}
function checkEnable(){
	if(errormsg == null || errormsg == '' || errormsg == IncidentPage.Labels.SavedSuccessfully){ 
		hasRelatedBRD = getHasRelatedBroadcasts();
		templateEnable = getFlagForTemplate();
		Ext.getCmp('assignToMyselfButtonId').setDisabled(getAssignMyselfState());
		Ext.getCmp('assignToStaffButtonId').setDisabled(!incnState);
		Ext.getCmp('assignToSuggestedStaffButtonId').setDisabled(!incnState);
		Ext.getCmp('assignToMemberOfAdminButtonId').setDisabled(!incnState);                  
		Ext.getCmp('quickCloseButtonId').setDisabled(!incnState);
		Ext.getCmp('closeButtonId').setDisabled(!incnState);
		Ext.getCmp('reopenButtonId').setDisabled(incnState);
		Ext.getCmp('assignToQueueButtonId').setDisabled(!incnState);
		Ext.getCmp('incrementCallButtonId').setDisabled(!incnState);
		Ext.getCmp('respondedButtonId').setDisabled(!incnState);
		Ext.getCmp('emailId').setDisabled(!incnState);
	} 
  Ext.getCmp('saveId').setDisabled(!incnState);
  Ext.getCmp('incidentKMSearch').setDisabled(!incnState);
  Ext.getCmp('templatebutton').setDisabled(!incnState);
  
}

function  updateKM(){
 if(getSaveState()==false){
	Ext.getCmp('incidentKMSearch').setDisabled(false);
	Ext.getCmp('incidentKMSearch').setIconClass('bmcKMSearch');	
  }else{	
	Ext.getCmp('incidentKMSearch').setDisabled(true);
	Ext.getCmp('incidentKMSearch').setIconClass('bmcKMSearchDisable');
  }
}

function getCustomActionURL(customId){
	var incId = getIncidentIDForPrb();
	eval(orgNamespace).JSRemoteActions.getCustomActionURL( 'Incident',incId,customId, function(result, event){
		if(event.status) {
			if(result != '' && result != null){
				urlStringVar = result;
				openUrl();
			  }           			
		} else if (event.type === 'exception') {    
			Ext.Msg.alert('', event.message);
		}			
	}, {escape:false});
}
function OpenHelpUrl(link){
	if(link.toLowerCase().indexOf('incidentservicetarget') != -1)
	{
		OpenHelppage('ServiceTransaction','module','form');
	}
	else if(link.toLowerCase().indexOf('servicerequestdetail') != -1)
	{
		OpenHelppage('ServiceRequestDetail','module','form');
	}
	else if(link.toLowerCase().indexOf('composeemailpage') != -1)
	{
		OpenHelppage('EmailConversation','module','form');
	}
}
function disableSRDlookup(){
	if(isServiceRequest != null && isServiceRequest != '' && isServiceRequest == IncidentPage.Labels.ExtjsMessageYes){
		var srdBtn = document.getElementById('reqDefLookupBtn');
		if(srdBtn != null)
			srdBtn.disabled = true;
		var srdTitle = getSRDtitle();
		if(srdTitle != null){
			srdTitle.disabled = true;
			srdTitle.style.backgroundColor = '#D4D0C8';
			srdTitle.style.color = '#000000';
			if(Ext.isIE){	
				srdTitle.style.width = '195px';
				srdTitle.className='clsPanelInputTextboxReadOnly';
		}
	}	
}
}


function setServiceClauses(type){
	if(type == 'offering'){
		var fkService = document.getElementById(IncidentPageComp.ComponentVars.businessServiceID).value;
		if(fkService != null && fkService != '' && fkService != 'undefined'){
			OfferingClause = escape('(serviceType__c = \'Offering\') And (FKBusinessService__c =\'' + fkService + '\')  And (end_date__c = null or end_date__c >=' + soqlDateClause + ')');
			
		}else{
			OfferingClause = escape('(serviceType__c = \'Offering\') And (end_date__c = null or end_date__c >=' + soqlDateClause + ')');
		}	
	}else if(type == 'businessService'){
		businessServiceClause = escape('(serviceType__c != \'Offering\') And (end_date__c = null or end_date__c >=' + soqlDateClause + ')');
	}
}
function openSRDpopUp(){
	var selectedCatId = document.getElementById(IncidentPageComp.ComponentVars.CategoryID).value;
	var selectedCatName = document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName).value;
	var selectedClientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
	if(selectedCatName != null && selectedCatName !=''){
	   openPopup('SearchPage?isLookup=true&popupId=SRM_RequestDefinition&clientIdforSrm='+selectedClientId+'&catIdForSrd='+selectedCatId,setSelectedSRD);
	}else{
	   openPopup('SearchPage?isLookup=true&popupId=SRM_RequestDefinition&clientIdforSrm='+selectedClientId,setSelectedSRD);
	}
}
function openSRDetailpopUp(){
	var selectedReqDefID = document.getElementById(IncidentPageComp.ComponentVars.reqDefinationID).value;
	var selectedReqDefTitle = document.getElementById(IncidentPageComp.ComponentVars.serviceRequestTitle).value;
	var requestDetailID	 = document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value;
	
	var incidentId = getIncidentIDForSRD();
	var clientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
	if((selectedReqDefID != null && typeof(selectedReqDefID)!='undefined' && selectedReqDefID !='' && selectedReqDefTitle != '')||((requestDetailID!=null && requestDetailID !='' )&&(incidentId != null && incidentId != ''))){
		openPopupWithTitle('ServiceRequestDetail?incidentId='+ incidentId+'&isLookup=true&reqDefId='+ selectedReqDefID+'&reqDtlsId='+requestDetailID+'&clientId='+clientId,
		null, IncidentPage.Labels.ServiceRequestLabel, 563, 650);
	}
		
	}

function callRequestDetailTooltip(eventObject){ 
    var requestDetailId = getRequestDetailID();
    var target=eventObject.target;
    if(target == null) 
        target = eventObject.srcElement;
    if(requestDetailId != ''){
        eval(orgNamespace).ClientInfo.getRequestDetailInfo(requestDetailId, function(result, event){
            if(event.status) {
				tooltipHtmlResult = '';
                var fieldLabels = result['objectFieldLabels'];
                var fieldDisplayLabels = result['displayFieldLabels'];
                tooltipHtmlResult = '<table cellpadding=4 cellspacing=3 width="290" border=0 style="table-layout:fixed; font-size:11px;">';
                if(result != '' && result != null){
                    var fieldListArray = fieldLabels.split(';'); 
                    var fieldDisplayArray = fieldDisplayLabels.split(';'); 
                    var i=0;
                    for(i=0; i<fieldListArray.length-1;i++){
                        tooltipHtmlResult +='<tr><td width="40%" style="font-weight:bold; word-wrap:break-word;">'+fieldListArray[i]+'</td><td style="white-space:normal; font-weight:bold; word-wrap:break-word;">' + fieldDisplayArray[i].replace(undefined, '').replace(null, '') + '</td></tr>';
                    }
                    tooltipHtmlResult += '</table>';
                    tooltipforclientstaff = new Ext.QuickTip({
                        target: target.id,
                        anchor: 'left',
                        width:Ext.isIE ? Ext.isIE7 ? 305:295:308,
                        trackMouse: false,
                        bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
                        hideDelay:200,
                        dismissDelay: 5000,
                        html: tooltipHtmlResult 
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

                    tooltipforclientstaff.show();
                  }                     
            } else if (event.type === 'exception') {    
                alert(event.message);
            }         
        }, {escape:true});
    } else {
        return;
    }            
}
function  setClientRelatedFields(id,add_info){	
   if(add_info !=null && add_info!=undefined){
         var all_add_info=add_info.split('П');
         for(var i=0;i<=all_add_info.length-2;i++){
			  var add_info_val=all_add_info[i].split(':');
			  var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:''; 
			  fieldValue=decodeSpecialChar(fieldValue);
			if(add_info_val[0] =='firstname')
				document.getElementById(clFname).value=fieldValue;
			if(add_info_val[0] =='lastname')
				document.getElementById(clLname).value=fieldValue;
			if(add_info_val[0] =='username')
				document.getElementById(clUname).value=fieldValue;
			if(add_info_val[0] =='id'){
				document.getElementById(IncidentPageComp.ComponentVars.UserID).value=fieldValue;
				document.getElementById(IncidentPageComp.ComponentVars.TipUserID).value=fieldValue;
			}
			if(add_info_val[0] =='phone'){
				document.getElementById(clPhone).value=fieldValue;
			}
			if(add_info_val[0] =='extension'){
				document.getElementById(clExtension).value=fieldValue;
			}
			if(add_info_val[0] =='contact.accountid'){
				if(fieldValue != null && fieldValue != ''){
					document.getElementById(incAccountId).value=fieldValue;				
				}
			}	
			if(add_info_val[0] =='contact.account.name'){
				if(fieldValue != null && fieldValue != ''){
					document.getElementById(accname).value=fieldValue;
					document.getElementById(clAccname).value=fieldValue;				
				}
			}
			if(add_info_val[0] =='Account_ID__c'){
				if(fieldValue != null && fieldValue != ''){
					document.getElementById(incAccountId).value=fieldValue;
				}
			}	
			if(add_info_val[0] =='Account_Name__c'){				
				if(fieldValue != null && fieldValue != ''){
					document.getElementById(accname).value=fieldValue;
					document.getElementById(clAccname).value=fieldValue;				
				}
			}
			   
         }
	}
         FetchUrgencyHTTP();converdisabletoreadonly();
 }
 function  setAccountNext(id,add_info){
    if(add_info !=null && add_info!=undefined){
      var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		  var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:'';
          fieldValue=decodeSpecialChar(fieldValue);		  
          if(add_info_val[0] =='name'){
              document.getElementById(accname).value=fieldValue;
          }else if(add_info_val[0] =='id'){
               document.getElementById(incAccountId).value=fieldValue;  
           }
         }
	}
 }
 function  setStatusField(id,add_info){
    if(add_info !=null && add_info!=undefined){
        var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:''; 
		 fieldValue=decodeSpecialChar(fieldValue);
          if(add_info_val[0] =='name'){
              document.getElementById(IncidentPageComp.ComponentVars.StatusId).value=fieldValue;
          }else if(add_info_val[0] =='id'){
               document.getElementById(IncidentPageComp.ComponentVars.Status_Id).value=fieldValue;  
           }else if(add_info_val[0] =='stage__c'){
			   document.getElementById(IncidentPageComp.ComponentVars.StatusStage).value=fieldValue;  	
           }
         }
	}
 }
 function  setUrgencyField(id,add_info){

        var all_add_info=add_info.split('П');
        
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:'';
		 fieldValue=decodeSpecialChar(fieldValue);
          if(add_info_val[0] =='name')
              document.getElementById(IncidentPageComp.ComponentVars.UrgencyIDName).value=fieldValue;
          if(add_info_val[0] =='id'){
               document.getElementById(IncidentPageComp.ComponentVars.UrgencyID).value=fieldValue;  
           }
         }
		 if(id != null && id != '' ){
			 FetchPriorityHTTP();
	}    
 }
 function resetSRDtldVal(){
	var selectedReqDefID = document.getElementById(IncidentPageComp.ComponentVars.reqDefinationID);
            if(selectedReqDefID != null && typeof(selectedReqDefID)!='undefined' && selectedReqDefID !=''){
            	if(reqDtlsId ==''){
            		reqDtlsId = selectedReqDefID.value;
            	}else{
            		if(selectedReqDefID.value != reqDtlsId){
	                    reqDtlsId = selectedReqDefID.value;
	                    document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value = '';
                    }
            	}
            }else{
                document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value = '';
            } 
}		
function setServiceRelatedFields(id,add_info){
	if(add_info !=null && add_info!=undefined){
        var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:''; 
		 fieldValue=decodeSpecialChar(fieldValue);
		 if(add_info_val[0] =='instance_name__c'){
			document.getElementById(IncidentPageComp.ComponentVars.serviceIDName).value = fieldValue;
            DisableCIExpBtn();
         }else if(add_info_val[0] =='fkbmc_baseelement__c'){
            document.getElementById(IncidentPageComp.ComponentVars.businessServiceID).value = fieldValue;
         }
       }
	}
}
function setServiceOfferingRelatedValues(offeringId,add_info){
	if(add_info !=null && add_info!=undefined){
        var all_add_info=add_info.split('П');
        for(var i=0;i<all_add_info.length;i++){
         var add_info_val=all_add_info[i].split(':');
		 var fieldValue=add_info_val[1] !='null' ?add_info_val[1]:''; 
		 fieldValue=decodeSpecialChar(fieldValue);
		 if(add_info_val[0] =='instance_name__c'){
			document.getElementById(IncidentPageComp.ComponentVars.offeringNameEleID).value = fieldValue;
         }else if(add_info_val[0] =='fkbmc_baseelement__c'){
            document.getElementById(IncidentPageComp.ComponentVars.offeringIdEleID).value = fieldValue;
         }
       }
	}
	var bsName = document.getElementById(IncidentPageComp.ComponentVars.serviceIDName).value;
	var bsId = document.getElementById(IncidentPageComp.ComponentVars.businessServiceID).value;
	if(bsName == '' || bsId == ''){
		setServiceOffering(offeringId);
	}
}
function linkCIIncidentJS(ciID){
 if(window.frames.SIIframeID.linkCIIncident !='undefined' && window.frames.SIIframeID.linkCIIncident != null)
    window.frames.SIIframeID.linkCIIncident(ciID);
 else
    linkCIIncident(ciID); 
}
function EnableAdditionalCILink(){
primaryCI=document.getElementById(IncidentPageComp.ComponentVars.BaseElementIDName).value;
var service=document.getElementById(IncidentPageComp.ComponentVars.serviceIDName).value;
if((primaryCI!=null && primaryCI!='' || service!=null && service!='') && incidentId!='' && incidentId!=null)
{
		  document.getElementById('linkAddCILink').style.display="block";
		  DisableCIExpBtn();
		  
}
}
function selectBroadcastNextFromTabout(){
	var  broadcastId = document.getElementById(IncidentPageComp.ComponentVars.BroadcastID).value;
	if(broadcastId != null && broadcastId != ''){
		setBroadcastNextJS(broadcastId);
	}
}
function setBroadcastNextJS(brdIdOrName){
	var ln = document.getElementById(clLname).value;
	var fn = document.getElementById(clFname).value;
	var cn = document.getElementById(clUname).value;
	var cid = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
	var an = document.getElementById(accname).value;
	var aid = document.getElementById(incAccountId).value;
	var rdn = document.getElementById(IncidentPageComp.ComponentVars.serviceRequestTitle).value;
	var rdid = document.getElementById(IncidentPageComp.ComponentVars.reqDefinationID).value;
	var reqDetailId = document.getElementById(IncidentPageComp.ComponentVars.reqDetailID).value;
	var descrption = document.getElementById(IncidentPageComp.ComponentVars.IncidentDescription).value;	
	var resolution = document.getElementById(IncidentPageComp.ComponentVars.IncidentResolution).value;
	var sn = document.getElementById(IncidentPageComp.ComponentVars.StatusId).value;
	var sid = document.getElementById(IncidentPageComp.ComponentVars.Status_Id).value;
	var iin = document.getElementById(IncidentPageComp.ComponentVars.ImpactIDName).value;
	var iid = document.getElementById(IncidentPageComp.ComponentVars.ImpactID).value;
	var un = document.getElementById(IncidentPageComp.ComponentVars.UrgencyIDName).value;
	var uid = document.getElementById(IncidentPageComp.ComponentVars.UrgencyID).value;
	setBroadcastNext(brdIdOrName,ln,fn, cn, cid, an, aid, rdn, rdid, reqDetailId, descrption, resolution, sn, sid, iin, iid, un, uid);
}
