var disableTrue = true;

//Manasi 2/2/2012
var closeIncidentWindow;
    
    function closeIncident(){
       if (!closeIncidentWindow || closeIncidentWindow .closed){
            // Nakul -------------
			closeIncidentWindow = openWindow('/apex/closeIncidentPage?stdForm=true&standardLayout=true&popupHeader='+IncidentPage.Labels.CloseIncident+'&incidentId='+ incidentId +'&isLookup=true&IncidentCat='+ incidentCategoryId);
            // End --------------
        }
        if (closeIncidentWindow .focus) {closeIncidentWindow .focus()};           
        return !closeIncidentWindow ;
    }
    
	function openWindow(url,windowFeatures){	
		if(!windowFeatures){
			windowFeatures="status = 1,height = "+stdLayoutScreenHeight+", width = "+stdLayoutScreenWidth+",left="+stdScreenLeft()+",top="+stdScreenTop()+", resizable = 1,scrollbars=yes";
		}
		var w=window.open(url,"_blank",windowFeatures);
		w.focus();
		return w;	
	}
//End---
	
Ext.onReady(function() {
		
    if(isLookup){
	disableTrue = true;
	separator = '';
    }else{ 
        disableTrue = false;
        separator = '-';
    }
	
	var incidentForClientHandlerWindow;
    var IncidentForClientHandler= function(button,event) { 
        var clientType = 'Client';

		if (!incidentForClientHandlerWindow || incidentForClientHandlerWindow.closed){
			//Manasi 2/2	  
			incidentForClientHandlerWindow=openWindow('/apex/SearchPage?popupId=Incident&isLookup=true&standardLayout=true&popupFor=incidentsforclient&popupHeader=Select From Inci&isLookup=true&filterClause=' + escape('FKClient__c=\''+clientId+'\''));
	    }
		if (incidentForClientHandlerWindow.focus) {incidentForClientHandlerWindow.focus()};
			
		return !incidentForClientHandlerWindow;		
    };

	var incidentForCategoryHandlerWindow;
    var IncidentForCategoryHandler= function(button,event) { 
        var categoryType = 'Category';

		if (!incidentForCategoryHandlerWindow || incidentForCategoryHandlerWindow.closed){
			//Manasi 2/2
			incidentForCategoryHandlerWindow=openWindow('/apex/SearchPage?popupId=Incident&filterClause=' + escape('FKCategory__c=\''+categoryId+'\'')+'&isLookup=true&standardLayout=true&popupFor=incidentsforcategory&popupHeader=Select From Incidents');
		}
		if (window.focus) {incidentForCategoryHandlerWindow.focus()};
			
		return !incidentForCategoryHandlerWindow;
    };
    
	// ----------------------- Code by Nakul -------------------------------------
	var assignToStaffWindow;
	var assignToMemberOfWindow;
    var assignToHandler = function (button, event){
        if(button.id == 'AssignToStaff'){
            profileName = 'ServiceDesk Staff';
            type = 'Staff';
   
			if (!assignToStaffWindow || assignToStaffWindow.closed){
				//MANASI 2/2
				assignToStaffWindow=openWindow('/apex/SearchPage?standardLayout=true&popupFor=Assignto&popupHeader=Select From Staff&popupId=Client&isLookup=true&filterClause='+escape("IsStaffUser__c=true"));
			}
			if (assignToStaffWindow.focus) {assignToStaffWindow.focus()};
			
			return !assignToStaffWindow;			
		
        }
        else if(button.id == 'AssignToMemberOf'){11
            profileName = getProfileName();
	 	    type = 'SysAdmin';
       	
			if (!assignToMemberOfWindow || assignToMemberOfWindow.closed){
				//mANASI 2-2
				assignToMemberOfWindow=openWindow('/apex/SearchPage?standardLayout=true&popupFor=Assignto&popupHeader=Select From Staff&popupId=Client&isLookup=true&filterClause='+escape("profileid='" + getProfileID() + "'And IsStaffUser__c=true "));
			}
			if (assignToMemberOfWindow.focus) {assignToMemberOfWindow.focus()};
			
			return !assignToMemberOfWindow;				
        }		 
    }
	
	var assignToSuggestedStaffHandlerWindow;
    var assignToSuggestedStaffHandler = function (button, event){
   		if (!assignToSuggestedStaffHandlerWindow || assignToSuggestedStaffHandlerWindow.closed){
			//mANASI 2/2
			assignToSuggestedStaffHandlerWindow=openWindow('/apex/SearchPage?standardLayout=true&popupFor=Assignto&popupHeader=Select From Staff&popupId=SuggestedStaff&isLookup=true&isActiveUser=true&categoryId='+getIncidentCategory()+'&filterClause='+escape("FKUser__r.IsStaffUser__c=true"));
		}
		if (assignToSuggestedStaffHandlerWindow.focus) {assignToSuggestedStaffHandlerWindow.focus()};
			
		return !assignToSuggestedStaffHandlerWindow;			
    }
    var assignToQueueHandlerWindow;
    var assignToQueueHandler = function(button, event){
		if (!assignToQueueHandlerWindow || assignToQueueHandlerWindow.closed){
			//Manasi 2/2
			assignToQueueHandlerWindow=openWindow('/apex/SearchPage?standardLayout=true&popupFor=Assignto&popupHeader=Select From Queue&popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Incident__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"));
		}
		if (assignToQueueHandlerWindow.focus) {assignToQueueHandlerWindow.focus()};
			
		return !assignToQueueHandlerWindow;
    }
    
    var assignToMySelfHandler = function (button, event){
		AssignedToMyselfNext();
    }
    	
	// ----------------------- End Nakul -----------------------------------------
    var incProcBtnHandlerWindow;
    var IncProcBtnHandler = function (button,event){
		if (!incProcBtnHandlerWindow || incProcBtnHandlerWindow.closed){
			//Manasi 2/2
			var width=1000;
			var height=1000;
			var stdLeft = parseInt((screen.availWidth/2) - (width/2));
			var stdTop = parseInt((screen.availHeight/2) - (height/2));
			incProcBtnHandlerWindow=openWindow('/apex/incProcMgmtPage',"status = 1, height = 1000, width = 1000,left="+stdLeft+",top="+stdTop+", resizable = 1,scrollbars=yes");
		}
		if (incProcBtnHandlerWindow.focus) {incProcBtnHandlerWindow.focus()};
			
		return !incProcBtnHandlerWindow;		
    };
	
    var QuickCloseBtnHandler = function(button,event) { quickCloseIncident();};
    
    function quickCloseIncident(){
        quickCloseIncidentNext();        
    } 	
	
    var CloseBtnHandler= function(button,event) { 
        saveBeforeCloseRecords();
    }; 	
	
    var ReopenBtnHandler = function(button,event) { 
		reOpenIncident();
    };	
    
    var CallCounterBtnHandler = function (button,event) { callCounterBtnHandler();};     
   
   var incidentKMSearchHandlerWindow;
    var incidentKMSearchHandler = function(button, event){
		updateDescription();
		if (!incidentKMSearchHandlerWindow || incidentKMSearchHandlerWindow.closed){
			//Manasi 2/2
			incidentKMSearchHandlerWindow=openWindow('/apex/KnowledgeSearch?calledFromForm=true&standardLayout=true&popupHeader='+IncidentPage.Labels.GlobalSearch +'&search='+KMdescription+'&KMincidentID='+incidentId);
		}
		if (incidentKMSearchHandlerWindow.focus) {incidentKMSearchHandlerWindow.focus()};
			
		return !incidentKMSearchHandlerWindow;
    }	

	var sendEmailBtnHandlerWindow;
	var sendEmailBtnHandlerWindow;
	var incidentName = getIncidentName();
	var header = incidentName;
	
	var sendEmailBtnHandler = function (button, event){
		if (!sendEmailBtnHandlerWindow || sendEmailBtnHandlerWindow.closed){
			//Manasi 2/2
			sendEmailBtnHandlerWindow=openWindow('/apex/ComposeEmailPage?recordId='+incidentId+'&isNew=true&objectName=Incident__c'+'&standardLayout=true&popupHeader='+header+'&popupFor=sendEmail');
		}		
		if (sendEmailBtnHandlerWindow.focus) {sendEmailBtnHandlerWindow.focus()}
			
		return !sendEmailBtnHandlerWindow;				
    }
	
    var ServiceTargetsBtnHandlerWindow;
    var ServiceTargetsBtnHandler = function (button, event){  
        var url='fieldList=';
		url += encode('Id,Name,ClockState__c,StartDate__c,EndDate__c,ElapsedTime__c,TimeRemaining__c,TargetType__c,StateValue__c,Status__c');
			 url+='&object=';
			 url+=encode('Incident_Service_Target__c');
			 url+='&whereClause=';
			 url+=encode('FKIncident__c=');                                       
			 var incidentName = getIncidentName();
			 if (!ServiceTargetsBtnHandlerWindow || ServiceTargetsBtnHandlerWindow.closed){
				//Manasi 2/2
				ServiceTargetsBtnHandlerWindow=openWindow('/apex/SearchPage?popupId=IncidentServiceTarget&isLookup=true&popupFor=ServiceTargets&filterClause=' + escape('FKIncident__c=\''+ incidentId+'\'')+'&standardLayout=true&popupHeader='+incidentName + ' ' + IncidentPage.Labels.ServiceTargets);
			}
		if (ServiceTargetsBtnHandlerWindow.focus) {ServiceTargetsBtnHandlerWindow.focus()};
			
		return !ServiceTargetsBtnHandlerWindow;	
  };
  
//public method for url encoding
    function encode (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }

        return escape(utftext);
  };  
    
    var refreshBtnHandler = function(button,event) { 
		refreshIncident();
    };
    
	
    function UpdateDueDateFieldState(){
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
	
    function isValidDate(){
        isValid ='True';
    }        
    
    function saveBeforeCloseRecords(){
		chkBoxValue=inactive;
        isValidDate();
        if(isValid=='True'){        
            saveBeforeCloseIncident(chkBoxValue);
        }else{
            Ext.MessageBox.show({ msg: IncidentPage.Labels.ValidDateTime, buttons: Ext.MessageBox.OK});
        }
    }  
var TemplateBtnHandlerWindow;
    var TemplateBtnHandler = function (button, event){
	 
        var templateBtn = Ext.getCmp('templatebutton');
		if (incidentId != null && incidentId !='') {
			Ext.MessageBox.confirm('',IncidentPage.Labels.OverwriteWarning, function(btn){
			   if(btn === 'yes'){
				//var mywindow = window.open( "/apex/TemplatePageNew?id="+incidentId, null,"status = 1, height = 575, width = 691,left=350,top=350, resizable = 1" );
				if (!TemplateBtnHandlerWindow || TemplateBtnHandlerWindow.closed){
					TemplateBtnHandlerWindow = window.open( "/apex/TemplatePageNew?id="+incidentId, null,"status = 1, height = 575, width = 691,left="+stdScreenLeft()+",top="+stdScreenTop()+", resizable = 1" );					
				}
					if (TemplateBtnHandlerWindow.focus) {TemplateBtnHandlerWindow.focus()};
						
					return !TemplateBtnHandlerWindow;
		    }});
		}  
		else
            if(templateBtn.disabled == false ){
				openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Incident'"),fetchIncidentTemplates,500,625);
			} 
		 
    };
	 var RespondedBtnHandler = function (button,event) { /*By Usha Juge . For Defect:56325 For getting message for data change on form close*/ 
	 respondedBtnHandler();};
		 
    function updateDescription(){
		var strlengh = 0;                          
		KMdescription =IncidentDescription;
		if (KMdescription.length > 100){
		KMdescription = KMdescription.substring(0,99)  
		}
    }

		
	var panel = new Ext.Panel({
        title: '',
        bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',     
		cls:'toolSpCls',
		width:315, 
		renderTo: 'btnToolbar',
		
		tbar: [ ]
    });
	
	 var tb = panel.getTopToolbar();
	
	tb.add( {                                                      
				scale: 'medium',
				iconCls :'bmcRefreshDasboard',
				tooltipType : 'title',
				tooltip: 'Refresh',
				listeners:{},
				id : 'refreshButtonId',
				handler :refreshBtnHandler
			},' ',{
					scale: 'medium',
					iconCls: 'bmcView1',
					tooltipType : 'title',
					tooltip: IncidentPage.Labels.ViewOpenIncidentsFor,
					id:'viewId',
					hidden:disableTrue,
           			menu: [ {text:IncidentPage.Labels.IncidentsforClient, id:'IncidentsforClientId', icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            handler:IncidentForClientHandler},
                           {text:IncidentPage.Labels.IncidentsforCategory, id:'IncidentsforCategoryId', icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            handler:IncidentForCategoryHandler}]
				},' ',{
					scale: 'medium',
					iconCls: 'bmcAssign1',
					tooltip: IncidentPage.Labels.AssignTo,
					tooltipType : 'title',
					id:'assignedToId',
					hidden:disableTrue, 
					//Only 'Text:' value changed for Assign To and Action Menu. For Suggested Staff in Incident.Js thay havent used Label Have Hard Coded it to suggested experts
					menu:  [ {
								text:IncidentPage.Labels.IncidentsStaff, 
                                id:'AssignToStaff',
                                disabled:getAssignStaffState(),
                                handler: assignToHandler                         
                            },
                            {
                                text:'Suggested Experts', 
                                id:'AssignToExpert',
								disabled:getAssignSuggestedStaffState(),
                                handler: assignToSuggestedStaffHandler                         
                            },
                            {
                                text:IncidentPage.Labels.IncidentMyself, 
                                id:'AssignToMyself',
                             //   enable : false,
								disabled:getAssignMyselfState(),
                                handler: assignToMySelfHandler                         
                            },
                            {
                                text:IncidentPage.Labels.IncidentMemberof + ' ' + getProfileName(),
                                id:'AssignToMemberOf',
								disabled:getAssignMemberOfAdminState() ,
                                handler: assignToHandler   
                            },
                            {
                                text:IncidentPage.Labels.Queue, 
                                id:'AssignToQueue',
								disabled:getAssignQueueState(),
                                handler: assignToQueueHandler   
                            }
                        ]
				},' ',{
					scale: 'medium',
					iconCls: 'bmcAction1',
					id: 'actionButton',
					tooltip: IncidentPage.Labels.Actions,
					tooltipType : 'title',
					hidden:disableTrue,
				menu: [ 
                        {
                            text:IncidentPage.Labels.IncidentClose, 
                            //text:"Close", 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',
                            id:'closeButtonId',
                            disabled:getCloseState(), 
                            handler:CloseBtnHandler
                        },
                        {
                            text:IncidentPage.Labels.IncidentQuickClose, 
                            //text:"Quick Close", 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF',
                            id:'quickCloseButtonId', 
                            disabled:getCloseState(), 
                            handler:QuickCloseBtnHandler
                        },
                        {
                            text:IncidentPage.Labels.IncidentReopenIncident, 
                            //text:"Reopen Incident",
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'reopenButtonId', 
                            disabled:getReOpenState(),
                            handler:ReopenBtnHandler
                        },
                        {
                            text:IncidentPage.Labels.IncidentIncrementCallCounter,
                            //text:"Incident Increment Call Counter",
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
                            handler:PrintBtnHandler                                                   
                        },
                        {
                            text:PrintPDF, 
                            icon:getSDFStylesResPath() + '/SDEFimages/_.GIF', 
                            id:'printPdfButtonId', 
                            handler:PrintPDFBtnHandler
                        }
                        ,'-',customActionJsonString]
                },' ',{
					scale:'medium',
					iconCls: 'bmcAPM',
					tooltipType : 'title',
					tooltip:IncidentPage.Labels.IncidentMgmtProcess,
					id:'incProcButton',
					handler:IncProcBtnHandler
				},' ',{
					scale: 'medium',
                    iconCls: 'bmcEmailMessage',
                    tooltipType : 'title',
                    tooltip: IncidentPage.Labels.Email,
                    id:'emailId',
					hidden:disableTrue,
                    handler:sendEmailBtnHandler
					
			},' ',{
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
            },' ',{
                    scale: 'medium',
                    iconCls: 'bmcKMSearch',
                    tooltipType : 'title',
					tooltip: 'Search Knowledge Database',
                    id:'incidentKMSearch ',
					disabled: getSaveState(),
					listeners: {},					
                    handler:incidentKMSearchHandler                                
            }    
		);
	tb.doLayout();
	Ext.QuickTips.init();
} );