var broadcastCategory,
	broadcastId,
	broadcastState,
	errormsg,
	chkBoxValue,
	flag,
	selectedModuleName,
	broadcastResolutionForClose = '',
	broadcastCategoryId = '',
	isValid ='True',
	doSave = false,
	saveFunctionRef,
	v1,
	clickedOnce = false,
	broadcastIdSet;// = window.parent.returnListOfId();
    var objName;            
    document.onclick = activateWindow;
	var isCreateable;var isDeletable;var isUpdateable;  	
Ext.onReady(function(){
        if(closedStageName == 'CLOSED' || closedStageName == 'Closed'){					
				Ext.MessageBox.show({title: Information , msg:ClosedStage, buttons: Ext.MessageBox.OK, icon: Ext.MessageBox.INFO});
		}
        Ext.QuickTips.init();
		if(isRecordDeleted()){
		Ext.Msg.alert(Information, DeletedRecord,function(){
		if ((typeof(window.parent) !='undefined')&&(typeof(window.parent.popUpWindow)!='undefined'))
					window.parent.popUpWindow.close();
					closeWindow();
			});
		}
		updateTitle();
        flag = getToEveryoneFlag();
        disableProfile();
        var followBtnHandler = 
        	function(button,event) {        	
            followBroadcastToggler();
        };
        var FindBtnHandler = function(button,event) {  
                                openIncidentLookup(); 
                                showData();
                                };
        var CopyBtnHandler = function(button,event) {  activeAllWindowFlag=false;callCopyPage(); };
        var DeleteBtnHandler = function(button,event) {
                                                        
                                                         Ext.MessageBox.confirm(labelDelete, labelDeleteBroadcastPage, function(btn){
                                                           if(btn === 'yes'){
                                                                 deleteBroadcast();
                                                           }});
                                                         };
                                                         
        var ResetBtnHandler = function(button,event) {  resetBroadcast(); };
        var NewBtnHandler = function(button,event) { activeAllWindowFlag=false; openPage('BroadcastsPage',labelBroadcastWindowHeaderSearchPage,labelBroadcastWindowHeaderSearchPage); };
        var isValid ='True';
        function isValidDate(){
            isValid ='True';
			var bcExpDate = getBroadcastExpirationDate();
            var temp = document.getElementById(bcExpDate).value;            
                /*if(temp!=null && temp!=''){
                    var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
                    if (!(temp.match(RegExPattern))) {
                        isValid ='False';
                    } else {
                        isValid ='True';                    
                    }                    
                }*/
        } 
        var SaveBtnHandler = function(button,event) {  
        
            if(!inProgress){
                doSave = false;
				var categoryIdName = getCategoryIdName();
				var broadcastCategoryFK = getBroadcastCategoryFK();
                categoryId = document.getElementById(categoryIdName).value;
                document.getElementById(broadcastCategoryFK).value = categoryId;
                chkBoxValue=Ext.getCmp('idInactive').getValue();
                isValidDate();
                if(isValid=='True' && hasAccounts == true){
					Ext.getCmp('saveId').setDisabled(true);
					waitbox(0);
					if(csvAccountListparam != '')
						save(chkBoxValue, csvAccountListparam);
					else 
						save(chkBoxValue);
                }else{
					if(isValid!='True')
						Ext.MessageBox.show({ msg: labelValidDateTime, buttons: Ext.MessageBox.OK});
					else if(hasAccounts != true)
						Ext.MessageBox.show({ msg: labelSelectAccounts, buttons: Ext.MessageBox.OK});
                }
               }  
            else{
                  doSave = true;
              }
        };
        saveFunctionRef = SaveBtnHandler;  
        
        var AssignToQueueHandler = function(button,event) {
                //openPopupWithTitle('QueueListPage?sObjectType=Broadcasts__c',preAssignBroadcastTOQueue,labelSelectFrom+' '+labelQueue,550,670);
				openPopup('SearchPage?popupId=Queue&isQueurorUser=true&isLookup=true&queueFor=Broadcasts__c&isOnlyQueueList=true&filterClause='+escape("sobjectType='" + objName +"'"), preAssignBroadcastTOQueue);
        };
        var AssignToMyselfMenuHandler = function(button,event) { 
            waitbox(0);
            broadcastAssignToMyself();
			handleChange();
        };       
        var AssignToStaffMenuHandler = function(button,event) { 
         openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("IsStaffUser__c=true")+'&isAssignTo=true',preBroadcastAssignToStaff);     
        };  
        var AssignToMemberOfHandler= function(button,event) { 
            openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("profileid='"+profileId+"' And IsStaffUser__c=true")+'&isAssignTo=true',preBroadcastAssignToStaff);
       }
        var AssignToSuggestedStaffHandler = function(button,event) { 
			selectedModuleName = 'staff';
			var catIdName = getCategoryIdName();
			broadcastCategory = document.getElementById(catIdName).value;
            openPopup('SearchPage?popupId=SuggestedStaff&isLookup=true&isSuggestExpert=true&queueFor=Broadcasts__c&isQueurorUser=true&isActiveUser=true&categoryId='+broadcastCategory+'&filterClause='+escape("FKUser__r.IsStaffUser__c=true"),preBroadcastAssignToSuggestedStaff);     
        };
        var SelectToMenuHandler = function(button,event) {  openPopup('SearchPage?popupId=Staff&isLookup=true',broadcastSelectToUser);}; 
        var SelectFromMenuHandler = function(button,event) { openPopup('SearchPage?popupId=Staff&isLookup=true',broadcastSelectFromUser);}; 
        var ReOpenMenuHandler = function(button,event) { reOpen(); };        
        var CloseMenuHandler = function(button,event) {
			var broadcastResolutionId = getBroadcastResolution();
             var broadcastResolution = document.getElementById(broadcastResolutionId);
             broadcastResolutionForClose = broadcastResolution.value;             
			 openPopupWithTitle('BroadcastClosePage?broadCastId=' + broadcastId +'&isLookUp=true&broadcastCat=' + broadcastCategoryId , updateTitle(),labelCloseBroadcast,550,640);
             
        }; 
	
        var PreviuosBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(previousBroadcastBtnHandler1);				
			} else {  if(document.getElementById('prevId').disabled!=true) 
				        previousBroadcastBtnHandler1();}
			}
			var NextBtnHandler = function (button,event) {	
			if (window.parent.changeArray[wid2] != null && typeof(window.parent.changeArray[wid2]) != 'undefined' && window.parent.changeArray[wid2] != -1 ){				
					checkLoseChanges(nextBroadcastBtnHandler1);				
			} else {  if(document.getElementById('nextId').disabled!=true) 
				        nextBroadcastBtnHandler1();}
			}
		var TemplateBtnHandler = function (button, event){ };
        var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'btnToolbar',
            defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;height:1px;'}
        });
        
        new SamplePanel({
            title: '',
            cls:'toolSpCls',
            bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;height:1px;',
            tbar: [{
                scale: 'medium',
                iconCls: 'bmcNew',
                tooltipType : 'title',
                tooltip: labelNew,
                id:'newId',
                handler:NewBtnHandler
               
            },' ',{
                scale: 'medium',
                iconCls: 'bmcSave',
                id:'saveId',
                tooltipType : 'title',
                tooltip:labelSave,
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
            },' ','-',' ',{
                scale: 'medium',
                iconCls: 'bmcAssign1',
                tooltipType : 'title',
                tooltip:labelAssignTo,
                menu: [ {text:labelIncidentsStaff,
                        icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToStaffButtonId',
                         disabled:assignStaffState,handler:AssignToStaffMenuHandler
                                               
                        },
                        {text:labelSuggestedExperts, icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToSuggestedStaffButtonId',disabled:assignSuggestedStaffState,handler:AssignToSuggestedStaffHandler },
                        {text:'Group', icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToGroupButtonId',disabled:assignGroupState, hidden:true},
                        {text:labelIncidentMyself,
                         icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToMyselfButtonId', 
                         disabled:assignMyselfState,handler:AssignToMyselfMenuHandler
                        },
                        {text:labelIncidentMemberofProfName, icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',id:'assignToMemberOfGroupButtonId',disabled:assignMemberOfGroupState,
                         handler:AssignToMemberOfHandler  },
                        {text:labelQueue, icon:getSDFStylesResPath() +'/SDEFimages/_.GIF', id:'assignToQueueButtonId',disabled:assignToQueue,
                            handler:AssignToQueueHandler }]
            },' ',{
                scale: 'medium',
                iconCls: 'bmcAction1',
                tooltipType : 'title',
                tooltip: labelActions,
                menu: [ 
                        {text:labelIncidentClose,id:'closeButtonId',disabled:closeState,
                        icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',handler:CloseMenuHandler
                         },
                        {text:labelReopenBroadcast,id:'reopenButtonId',disabled:reOpenState,
                        icon:getSDFStylesResPath() +'/SDEFimages/_.GIF',handler:ReOpenMenuHandler
                        } ]
			 },
            new Ext.Toolbar.Fill(),
            {
                  id :'idInactive',
               xtype  : 'checkbox',
               width  : 93,
               checked: false,
               boxLabel:'<span class="checkboxLabelCls">'+labelInactive+'</span>',
               listeners:{
                    render:function(){
                         new Ext.ToolTip({
							target: 'idInactive',			
							anchor: 'left',			
							html:labelTooltipBroadCastsInactive							  
						});
                    }               
               }     
               
               
              
            }, {
               
               
                xtype : 'box',
                id    : 'prevId',
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() +'/SDEFbuttons/b_previous.gif',   
                         title:labelPreviousRecord
                         },
                          
                cls:'cursorCls',
               listeners : { render: function(f){f.el.on('click', PreviuosBtnHandler);}}
                             
            },{
               
                xtype : 'box',
                id    : 'nextId',
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() +'/SDEFbuttons/b_next.gif',
                          title:labelNextRecord},
                cls:'cursorSpaceCls',
                listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
               
                
            }]
        });
		if(Ext.getCmp('saveId')!=null){
            Ext.getCmp('saveId').setDisabled(saveState);
		}	
        Ext.getCmp('idInactive').setValue(getInactiveValue());
           broadcastId = getBroadcastId();    
           broadcastState=  getBroadcastState; 
            if(broadcastId == null ||broadcastId == ''){                
            disableButtons(new Array('deleteId','copyId','prevId', 'nextId')); //,'followId'));
                    Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable'); 
                       Ext.getCmp('resetId').setDisabled(true);  
               
            }else if(broadcastId != null && broadcastState == 'false'){
                  disableAll(); }
            
            
            ///////////// // IE7-8 Related Changes
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
                                height:470, 
                                cls:'northPanelCls',
                                                                             
                                region: 'center',                   
                               // margins:'2 4 2 0',
                                                       
                                contentEl : Ext.isIE ? 'capsule' : broadcastFormComponent
                                
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
                                height:Ext.isIE ?205:205,
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
                    // renderTo:'viewPortDiv',
                     width:'auto',
                     id:'viewportId',
                     border:false, 
                     cls:'viewportCanvasCls',  
                     //items:canvasPanel
                     items:[{anchor: '100%', layout:'fit', items:canvasPanel} ]
                    });
/////////////// // End IE7-8 Related Changes
            if(broadcastId != null && broadcastState == 'false'){
				setTimeout(disableAll,1250);
			}
			handleElemEvent();
            if(broadcastId == null ||broadcastId == ''){
				document.getElementById('linkSIAvailTD').style.display = 'none';
				document.getElementById('noSIAvailTD').style.display = 'block';
				setfocusforbroadcastid();
           }else{
				var isCookiePresent = displaySI(cookieName, iFrameSrc);
				if(!isCookiePresent){
					document.getElementById('noSIAvailTD').style.display = 'none';
					document.getElementById('linkSIAvailTD').style.display = 'block';
				}
			}
        converdisabletoreadonly();   
		renderAccList();
		permissionChecksForButtons();
});
function handleChange(){
	if(!clickedOnce){
		clickedOnce = true;
		window.parent.registerChange(wid2);
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
	function setSelectedModuleName(modNameFS){
			selectedModuleName = modNameFS;
		}
function callCopyPage(){
	window.parent.addTab("BroadcastsPage?copyId=" + broadcastId,labelBroadcastWindowHeaderSearchPage,labelBroadcastWindowHeaderSearchPage);
}
function closeWindow(){
	window.parent.parent.refreshPortletByTitle('Broadcasts');
	window.parent.refreshList();
	window.parent.closeTab(wid);
}
function getBRDid(brdId,isSave){
	if(isLookup){
		//window.parent.refreshDocs();  
		//window.parent.closePopup();
		window.frames.SIIframeID.setId(brdId,isSave);
	}else{
		window.frames.SIIframeID.setId(brdId,isSave);
	}
}
function saveBroadcastFrmCloseWin(){
	callInit();
}
function buttonValidator() {
	if(( (categoryRequired=='false') ||	(broadcastCategory != null && broadcastCategory != ''))&&(errormsg == null||errormsg ==''||errormsg==labelSavedSuccessfully)){   
		var broadcastFeed = broadcastFeedVal;
		Ext.getCmp('deleteId').setDisabled(false);
        Ext.getCmp('copyId').setDisabled(false);
		Ext.getCmp('resetId').setDisabled(false);
		Ext.getCmp('deleteId').setIconClass('bmcDelete');
		Ext.getCmp('copyId').setIconClass('bmcCopy');
		
		var isDisplay = document.getElementById('SIIframeID').style.display;
		if(cookieValue =='true' && isDisplay =='none'){
		SIComp('/apex/SIContainerPage?oid='+broadcastId+'&otype=Broadcasts__c&wid='+wid+'&stateofIncident='+broadCastCloseState+ '&isChangeCreatable=false'+'&isInactive='+isInactive);
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
		if (broadcastFeed != null && broadcastFeed == 'true') {
			//Ext.getCmp('followId').setDisabled(false);
		}
	}   
}
function disableProfile(){
	if(flag == 'true'){
		document.getElementById(ProfileButtonComponentId).disabled = true;
	}else{
		document.getElementById(ProfileButtonComponentId).disabled = false;
	}
}
function isValidDate(){
	isValid ='True';
	var broadcastExpirationDateId= getBroadcastExpirationDate();
	var temp =document.getElementById(broadcastExpirationDateId).value;
	if(temp!=null && temp!=''){
		var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
		if (!(temp.match(RegExPattern))) {
			isValid ='False';
		}else{
			isValid ='True';                    
		}
	}
}
function openCategoryPage(returnValues){    
	if(returnValues != null || returnValues != ''){
		if(returnValues[0] != null ||returnValues[0] !='' ){
			setCategoryNext(returnValues[0]); //Calling Action Function
			var broadcastCategoryFKCmpId= getBroadcastCategoryFK();
			var categoryIdNameCmpId= getCategoryIdName();
			document.getElementById(broadcastCategoryFKCmpId).value = returnValues[0];
			document.getElementById(categoryIdNameCmpId).value = returnValues[0];
		}
		if(returnValues[1] != null || returnValues[1] != ''){
			setDescriptionNext(returnValues[1]); //Calling Action Function
		}
		if(returnValues[2] != null || returnValues[2] != ''){
			setResolutionNext(returnValues[2]); //Calling Action Function
		}
	}
}

function calculatePriority(){
	var impactIdNameVal = getImpactIdname();
	var urgencyIdNameVal = getUrgencyIdname();
	var impactIdVal = getimpactIdVal();
	var urgencyIdVal = getUrgencyIdVal();
	var impactNameEle = document.getElementById(impactIdNameVal);
	var impactName = '';
	if(impactNameEle != null)
		impactName = impactNameEle.value; 
		
	var urgencyNameEle = document.getElementById(urgencyIdNameVal);
	var urgencyName = '';
	if(urgencyNameEle != null)
		urgencyName = urgencyNameEle.value;
		
	var impactIdEle = document.getElementById(impactIdVal);
	var impactId = '';
	if(impactIdEle != null)
		impactId = impactIdEle.value 
		
	var urgencyIdEle = document.getElementById(urgencyIdVal);
	var urgencyId = '';
	if(urgencyIdEle != null)
		urgencyId = urgencyIdEle.value;     
	
	if( impactName != '' && urgencyName != '' && impactId != '' && urgencyId != '' ){
		calculatePriorityNext();
	}   
}
function selectUrgencyOnName(){
	var urgencyIdVal = getUrgencyIdVal();
	var urgencyId = document.getElementById(urgencyIdVal).value;
	if(urgencyId != null && urgencyId != ''){
		calculatePriority();
	}
}
function selectImpactOnName(){
	var impactIdVal = getimpactIdVal();
	var impactIdEle = document.getElementById(impactIdVal);
	var impactId = impactIdEle.value;
	if(impactId != null && impactId != ''){
		calculatePriority();
	}
}
function openImpactLookup(impactId ){  
	if(impactId != null && impactId != '' ){
		populateImpact(impactId);
	}               
}
function ellipse(fieldstring,maxlength){
	//var maxlength = 35;
    if(fieldstring.length > maxlength ){
		return fieldstring.substr(0, maxlength-3) + '...';
	}
    return fieldstring;
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
function showInfoPopup(eventObject, divId , objName ){
	var recordId = '';
	var target=eventObject.target;
	if(target == null) 
		target = eventObject.srcElement; 
	if(objName == 'staff'){
		var StaffHiddeninputCmpId = getStaffHiddeninputCmpId();
		recordId = document.getElementById(StaffHiddeninputCmpId).value;
		tooltipforstaff();
	}
	if(recordId != '' && recordId != null){
		var tooltipforclientstaff = new Ext.ToolTip({
			target: target.id,
			title : '',
			anchor: 'right',
			width:200,
			trackMouse: true,
			shadow :'sides',
			bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
			dismissDelay: 15000,
			html:document.getElementById(divId).innerHTML
		}); 
		   
		
	}
}
function resizeGridProgressionJS(StageHTML, objLabel,isLookup_P){
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
        if(isLookup_P){
          window.parent.changePopUpTitle(objLabel);
        }
}
function handleSaveJS(id){
	window.parent.handleSave(wid, id);
}
function refreshRelatedPortletsJS(){
	if(typeof(window.parent.parent.refreshPortletByTitle) == 'function'){
		window.parent.parent.refreshPortletByTitle('Broadcasts');
	}
	if(typeof(window.parent.parent.refreshActionItemsPortlet) == 'function')
	                      	window.parent.parent.refreshActionItemsPortlet('Action Items','BROAD');    
}
function resetSupportingInformationJS(broadcastState,brdcastId,isSave, inactive){
    var isDisplay = document.getElementById('SIIframeID').style.display;
	if(isDisplay !='none'){
		if(!broadcastState || inactive){ 
			window.frames.SIIframeID.disableAll();
		}else{
			window.frames.SIIframeID.enableAll();
		}
		 getBRDid(brdcastId,isSave);
	}	
}
function changeTitleAddStageProgressionJS(newTitle,StageHTML){
			if(newTitle != null && newTitle !=''){
				window.parent.changeTitle(wid,newTitle,labelBroadcastWindowHeaderSearchPage);
			}
			window.parent.addStageProgression(wid, StageHTML);			
			window.parent.refreshList();
}
function initBroadCastJS(broadcastCategory_p,broadcastId_p,flag_p,broadcastCategoryId_P){
	broadcastCategory = broadcastCategory_p;
	broadcastId = broadcastId_p;
	flag = flag_p;
	broadcastCategoryId = broadcastCategoryId_P;
}
function checkEnableJS(assignMyselfState,assignStaffState,assignSuggestedStaffState,assignGroupState,assignToQueue,assignMemberOfGroupState,closeState,reOpenState,broadcastId){
	if( broadcastId == '' || broadcastId == null){
		Ext.getCmp('saveId').setDisabled(false);
	}else{
		Ext.getCmp('assignToMyselfButtonId').setDisabled(assignMyselfState);
		Ext.getCmp('assignToStaffButtonId').setDisabled(assignStaffState);
		Ext.getCmp('assignToSuggestedStaffButtonId').setDisabled(assignSuggestedStaffState);
		Ext.getCmp('assignToGroupButtonId').setDisabled(assignGroupState);
		Ext.getCmp('assignToQueueButtonId').setDisabled(assignToQueue);
		Ext.getCmp('assignToMemberOfGroupButtonId').setDisabled(assignMemberOfGroupState);
		Ext.getCmp('closeButtonId').setDisabled(closeState);
		Ext.getCmp('reopenButtonId').setDisabled(reOpenState);
		Ext.getCmp('saveId').setDisabled(closeState);
	}
}
function completeDeleteJS(labelInsufficentDeletePrivilege){
	updateTitle();
	if(errormsg == labelInsufficentDeletePrivilege){
		showError();
	}else{
		closeWindow();
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
function openNewTab(recId,recType) {
	window.parent.parent.addNewTab("BroadcastNewsFeedPage", labelBroadcastChatterFeed, "NewsFeedPage?recordId="+recId+"&recordType="+recType);
}
function setOnClick(obj){
	if(obj.style.height=='0pt'){
		obj.style.height = '25pt';
		obj.value = '';
	}
}
function setOnBlur(obj,value){
	if (obj.style.height=='25pt' && obj.value == ''){
		obj.style.height = '0pt';
		obj.value = value;
	}
	else if (obj.style.height=='25pt' && obj.value != '')
		obj.style.height = '25pt';
}
function refreshChatterFeed(){
	refreshFeed(); 
}		       
function shareTextPost(textPostBody) {
			if(textPostBody.length > 1000)
			{                       
				Ext.MessageBox.show({ msg: TextAreaOverflowForChatter, buttons: Ext.MessageBox.OK});         
				return false;
			}
	waitbox(0);
	shareStatusPost(textPostBody); 
}              
function deleteCommentFromFeed(commentID,createById){
	Ext.MessageBox.confirm(ConfirmHomePage, ChatterDeleteComment, function(btn){
		if(btn === 'yes'){
			deleteComment(commentID,createById);
		}
	});	
}
function deleteFeedPost(feedPostID, createById){
	Ext.MessageBox.confirm(ConfirmHomePage, ChatterDeletePost, function(btn){
		if(btn === 'yes'){
			deletePost(feedPostID,createById);
		}
	});	 
}       
function setDisplay(id,value) { 
	document.getElementById(id).style.display = value; 
}
function createNewComment(divId, feedId){
	var inputtext = divId.getElementsByTagName('input')[0];
	if(inputtext.value.length > 1000){                       
		Ext.MessageBox.show({ msg: TextAreaOverflowForChatterComment, buttons: Ext.MessageBox.OK});         
		return false;
	}
	else if(inputtext.value.trim().length <= 0){
		Ext.MessageBox.show({ msg: EmptyValueForChatterComment, buttons: Ext.MessageBox.OK});         
		divId.getElementsByTagName('input')[0].focus();
		return false;
	}else{
		waitbox(0);
		NewCommentValue(inputtext.value,feedId);
	}	
}
function fetchUrgency(){
	var catIdName = getCategoryIdName();
	var categoryName = document.getElementById(catIdName).value;
	var categoryUrgency = document.getElementById(cmpCategoryUrgency).value;
	var catUrgencyIdVal = getUrgencyIdVal();
	var urgencyIdEle = document.getElementById(catUrgencyIdVal);
	var urgencyId = '';
	if(urgencyIdEle != null)
		urgencyId = urgencyIdEle.value;    

	if(categoryName != '' &&  categoryUrgency != '' && categoryUrgency != urgencyId){
		 setCategoryNext(categoryName)
	}	
}
function checkIDSet(){
        if(broadcastIdSet == null || broadcastIdSet == ''){
             if(getIsDirect()  == ''){
                 if(typeof(window.parent.returnListOfId)=='function')
				broadcastIdSet = window.parent.returnListOfId();
    
             }else{
                 if(typeof(window.parent.parent.getIdArray)=='function')
                 broadcastIdSet =window.parent.parent.getIdArray();
				 window.parent.handleSave(getWID(),getID());
                 
             }
         }
 }
        function previousBroadcastBtnHandler1(){
            var idSetString='';
            var i=0;
            while(broadcastIdSet.length > i){
                if(idSetString==''){
                    idSetString=broadcastIdSet[i];
                }else{
                    idSetString=idSetString+','+broadcastIdSet[i];
                }
                i++;
            }
            previousBroadcastBtnHandler(idSetString);
        
        }
       //broadcastIdSet=window.parent.returnListOfId(); 
       function nextBroadcastBtnHandler1(){
            var idSetString='';
            var i=0;
            while(broadcastIdSet.length > i){
                if(idSetString==''){
                    idSetString=broadcastIdSet[i];
                }else{
                    idSetString=idSetString+','+broadcastIdSet[i];
                }
                i++;
            }            
            nextBroadcastBtnHandler(idSetString);
        
        }
		
	function writeCookie(){
		if(document.getElementById('configureSIId').checked){
			createSICookie(cookieName,'true');
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
		}
	
	
	}
function DisplayChatterLimitMessage(){
	var chatterLimitError = getChatterLimitErrorMessage();
	if(chatterLimitError != "" && chatterLimitError != null && chatterLimitError.length > 0){
		Ext.MessageBox.show({ msg: chatterLimitError, buttons: Ext.MessageBox.OK});
	}
}
function preBroadcastAssignToStaff(saveId){
	waitbox(0);
	broadcastAssignToStaff(saveId);
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange();
	}
}
function preBroadcastAssignToSuggestedStaff(saveId){
	waitbox(0);
	if(selectedModuleName == 'queue'){
		assignBroadcastTOQueue(saveId);
	}else{
		broadcastAssignToSuggestedStaff(saveId);
	}
	if(saveId!=null && saveId!='undefined' && saveId != '')
	{
		handleChange();
	}
}
function preAssignBroadcastTOQueue(queueId){
	waitbox(0);
	assignBroadcastTOQueue(queueId);
	if(queueId!=null && queueId!='undefined' && queueId != '')
	{
		handleChange();
	}
}
function permissionChecksForButtons(){
		Ext.getCmp('newId').setDisabled(!isCreateable);
		if(broadcastId !='' && broadcastId != null){
			Ext.getCmp('copyId').setDisabled(!isCreateable);
			Ext.getCmp('deleteId').setDisabled(!isDeletable);
		}
		
		if(broadcastId !='' && broadcastId != null){	
			if(closeState){
				Ext.getCmp('saveId').setDisabled(true);
			}else{
				Ext.getCmp('saveId').setDisabled(!isUpdateable);
			}
			if(!isUpdateable){
				Ext.getCmp('closeButtonId').setDisabled(true);
				Ext.getCmp('reopenButtonId').setDisabled(true);
			}
		}else{
			Ext.getCmp('saveId').setDisabled(!isCreateable);
		}
		
}
function rendersavebutton(){
	if(broadcastId !='' && broadcastId != null){	
		Ext.getCmp('saveId').setDisabled(!isUpdateable);
		Ext.getCmp('copyId').setDisabled(!isCreateable);
		if(!isUpdateable){
			Ext.getCmp('closeButtonId').setDisabled(true);
			Ext.getCmp('reopenButtonId').setDisabled(true);
		}
		Ext.getCmp('deleteId').setDisabled(!isDeletable);
	}else{
		Ext.getCmp('saveId').setDisabled(!isCreateable);
		Ext.getCmp('copyId').setDisabled(true);
		Ext.getCmp('deleteId').setDisabled(true);
	}	
			
 } 
