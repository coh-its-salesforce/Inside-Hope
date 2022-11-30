// Added By Kamlesh As start of JS consolidation
	var initFlag = false,
		isHistoryEMailRecord = false,
		alreadyRun = false,
		sortColumnIndex = null,
		runCount = 0,
		elem,
		grid,
		gtabpanel,
		disableAdd = true,
		sortColumnName = 'name',
		sortDirection = 'ASC',
		detailsPanel ,
		listPanel2 ,
		msgBox,
		isResizable = true,
		customHeight,
		dispalyTitle,
		colsSize = 0,
		noName = false,    
		j=0, k=0,
		note,
		v ='',
		colsHdrs = new Array(colsSize),
		flds = new Array(colsHdrs.length),
		arrCols = new Array(colsSize),
		addEditLink,
		selectedId,
		panelHeight,
		panelHeightIE,
		panelHeightIE7,
		childObject,
		parentObject,
		childObjectName,
		editLink,
		flag=true,
		noteField,
		attachId,
		urlName,
		type,
		recId, 
		nameFld,
		NameVal,
		instanceType,
		param, 
		idArray= new Array('fileOpen','editSLA','editTask','editHistory','editIncBroadcast','editIncPriority','editIncCategory','editCategory','editStandardDesc','editStandardRes','editAction','editClient','editOrganization','editIncTemp','editCRAssessment','editProblemToCR','editCRIncident','editCRTask','editProbIncidents','editCRToProblem','editProblemTask','editCRTask','editProblemToCR','editCRToIncident'),
		objList,
		idList, 
		recordIdArray = new Array('menuOpen','menuAcknowledged','menuInProgress','menuClosed','menuSystemEntries','menuUserEntries','menuAllEntries','openProbIncidents','acknowledgedProbIncidents','inProgressProbIncidents','closedProbIncidents','openProblems','acknowledgedProblems','inProgressProblems','closedProblems','openProblemTasks','acknowledgedProblemTask','inProgressProblemTask','closedProblemTasks','openCRTasks','acknowledgedCRTask','inProgressCRTask','closedCRTasks','openCRIncidents','acknowledgedCRIncidents','inProgressCRIncidents','closedCRIncidents'),
		closeIdArray = new Array('addHistories','addFiles','addTask','openBroadcast','acknowledgedBroadcast','inprogressBroadcast','closedbroadcast','addIncPriority','addIncCategory','addIncBroadcast','linkToIncident','addCategory','addStandardDescription','addStandardResolution','addAction','assignSupportExperts','addClient','addOrganization','addTemplate','linkCI','linkService','userClosedIncId','userProgressIncId','userAcknowledgedIncId','userOpenIncId','linkIncidentToProblem','addCRToProblem','linkToCR','addProblemTask','addCRTask','','linkIncidentToCR','linkToProblems','addAssessmentToCR','addCRToIncidnet','linkChangesToInc','linkIncidentToCI','linkSLAToCI','linkChangesToCI','linkProblemsToCI','linkClient','addSLA','linkAccountsToCI'),
		unlinkIdArray=new Array('fileDelete','unAssignSuppExp','unLinkTemplates','unLinkCI','unLinkCIIncident','unLinkToIncident','unLinkIncidentToCR','unLinkIncidentToProblem','unLinkCRToProblem','unLinkProblemToCR','unLinkCRfromIncident','unLinkProblemToCR','unLinkIncidentToCI','unLinkSLAToCI','unLinkCRfromCI','unLinkReleasefromCI','unLinkProblemFromCI','unlinkClient','unLinkAccountFromCI'),
		siservertime = '',
		isSILoaded = true,
		hasNext,
		hasPrevious,
		isModifiable,
		historyId,
		historyPageName,
		linkRecord,
		cObjectName,
		historyActionId;
	
    

function GetBRes(bvar) {
	if (bvar == 'true' || bvar)
		return false;
	else 
		return true; 
}

function handleTabLoadJS(hasNext){
	if(!alreadyRun){
		flag=false;
		elem.removeAll();  
		elem.getEl().child('.x-panel-body').update('');
		elem.doLayout();
		var dGrid = new DataGrid();
		elem.add(dGrid);
		elem.doLayout(); 
		 if(typeof(Ext.getCmp('nextId')) != 'undefined' && recordExist)
			Ext.getCmp('nextId').setDisabled(true);
		if(typeof(Ext.getCmp('prevId')) != 'undefined')
			Ext.getCmp('prevId').setDisabled(GetBRes(hasPrevious));
		if(typeof(Ext.getCmp('nextId')) != 'undefined')
			Ext.getCmp('nextId').setDisabled(GetBRes(hasNext));   
		if(parentPageId == null || parentPageId == 'null' || parentPageId == ''){
			if(typeof(Ext.getCmp('nextId')) != 'undefined')
				Ext.getCmp('nextId').setDisabled(true);
		} 
		for(var i = 0; i < idArray.length; i++){
			if(typeof(Ext.getCmp(idArray[i]))!='undefined')
				Ext.getCmp(idArray[i]).setDisabled(true);
		}
		for(var i = 0; i < unlinkIdArray.length; i++){
			if(typeof(Ext.getCmp(unlinkIdArray[i]))!='undefined')
				Ext.getCmp(unlinkIdArray[i]).setDisabled(true);
		}
		
		alreadyRun = true; 
	}
}
					
function setSouthPanelHeight(heightSotuhPanel,widthSotuhPanel){
	Ext.getCmp('south-panel').setHeight(heightSotuhPanel);
	Ext.getCmp('south-panel').setWidth(widthSotuhPanel);
	if(window.parent != null)
		window.parent.Ext.getCmp('canvasPanelId').doLayout(true,true);
}
function applyToolTipOnSIHeaderBtn() {
    var detailPanelSI=Ext.getCmp('south-panel');
    new Ext.ToolTip({
            target: detailPanelSI.tools['minimize'],
            trackMouse: false,
            anchor: 'top',
            html:labelMinimize
                                                                    
    });
    new Ext.ToolTip({
            target: detailPanelSI.tools['maximize'],
            trackMouse: false,
            anchor: 'top',
            html:labelMaximize
                                                                    
     });
    new Ext.ToolTip({
            target: detailPanelSI.tools['restore'],
            trackMouse: false,
            anchor: 'top',
            html:labelRestore
    });
            
}



function displayTitle(pageName){
	if(pageName=='IncidentTemplate__c' || pageName=='TaskTemplate__c'){
		dispalyTitle=labelLinkedTemplates;
		isResizable = false;
		customHeight = 175;
		panelHeightIE = 182;
		panelHeightIE7 =182;
		panelHeight = 180;
	}else if(pageName=='Change_Request__c'){
	    dispalyTitle=labelSupportingInformation;
	    var cookieval=Ext.util.Cookies.get(window.parent.cookieName);
		if(cookieval == 'true')
		dispalyTitle +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javaScript:void(0)" id="hideSIID" onclick="clearCookie();">'+labelSupporting_Hide+'</a>';
		isResizable = true;
		customHeight = 242;
		panelHeightIE = 250;
		panelHeightIE7 =275;
		panelHeight = 245;
		
	}else if(pageName=='Problem__c'){
	    dispalyTitle=labelSupportingInformation;
	    var cookieval=Ext.util.Cookies.get(window.parent.cookieName);
		if(cookieval == 'true')
		 dispalyTitle +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javaScript:void(0)" id="hideSIID" onclick="clearCookie();">'+labelSupporting_Hide+'</a>';
		isResizable = true;
		customHeight = 242;
		panelHeightIE = 230;
		panelHeightIE7 =230;
		panelHeight = 240;
		
	}else if(pageName== 'BMC_BaseElement__c'){
		dispalyTitle=labelSupportingInformation;
		var cookieval=Ext.util.Cookies.get(window.parent.cookieName);
		if(cookieval == 'true')
			dispalyTitle +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javaScript:void(0)" id="hideSIID" onclick="clearCookie();">'+labelSupporting_Hide+'</a>';
		isResizable = true;
		customHeight = 186;
		panelHeightIE = 272;
		panelHeightIE7 = 310;
		panelHeight = 275;
		
	}else if(pageName== 'ServiceLevelAgreement__c'){	
		dispalyTitle=labelSupportingInformation;
		var cookieval=Ext.util.Cookies.get(window.parent.cookieName);
		if(cookieval == 'true')
			dispalyTitle +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javaScript:void(0)" id="hideSIID" onclick="clearCookie();">'+labelSupporting_Hide+'</a>';
		isResizable = true;
		customHeight = 186;
		panelHeightIE = 210;
		panelHeightIE7 =200;
		panelHeight = 215;
		
	}else{
		dispalyTitle=labelSupportingInformation;
		var cookieval=Ext.util.Cookies.get(window.parent.cookieName);
		if(cookieval == 'true')
			dispalyTitle +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javaScript:void(0)" id="hideSIID" onclick="clearCookie();">'+labelSupporting_Hide+'</a>';
		isResizable = true;
		customHeight = 186;
		if(pageName == 'Incident__c'){
			panelHeightIE = 205;
			panelHeightIE7 =205;
			panelHeight = 210;						
		} else if(pageName == 'Broadcasts__c') {
			panelHeightIE = 205;
			panelHeightIE7 =205;
			panelHeight = 205;					
		} else {
			panelHeightIE = 182;
			panelHeightIE7 =182;
			panelHeight = 180;			
		}
	}
}
	
	Ext.override(Ext.layout.ToolbarLayout, { fitToSize:function(n){if(this.container.enableOverflow===false){return}var m=n.dom.clientWidth;var b=this.lastWidth||0;this.lastWidth=m;var d=Ext.isIE ? document.documentElement.firstChild.offsetWidth :n.dom.firstChild.offsetWidth;var l=m-this.triggerWidth;var k=-1;if(d>m||(this.hiddens&&m>=b)){var e,h=this.container.items.items,g=h.length,j;var a=0;for(e=0;e<g;e++){j=h[e];if(!j.isFill){a+=this.getItemWidth(j);if(a>l){if(!j.xtbHidden){this.hideItem(j)}}else{if(j.xtbHidden){this.unhideItem(j)}}}}}if(this.hiddens){this.initMore();if(!this.lastOverflow){this.container.fireEvent("overflowchange",this.container,true);this.lastOverflow=true}}else{if(this.more){this.clearMenu();this.more.destroy();delete this.more;if(this.lastOverflow){this.container.fireEvent("overflowchange",this.container,false);this.lastOverflow=false}}}
		}});

function changeFlag(){
	initFlag = false;
}
	
	
	
function splitInTwo(str,splitVal){
	var ret = new Array();
	var splitIndex = str.indexOf('=');
	ret[0] = str.substring(0,splitIndex );
	ret[1] = str.substring(splitIndex +1,str.length);
	return ret;
}
    
function showStateToolTip(eventObject){
	 var target=eventObject.target;
	if(target == null) 
		target = eventObject.srcElement;                              
	
	var mainId = target.id;
	if (mainId != "noteImg_Auditing")
	{
		var note = target.getAttribute('nt');
		new Ext.ToolTip({
			target: mainId ,
			anchor: 'right',
			shadow :'sides',
			baseCls:'noteToolTipCls',
			bodyStyle:'font: 11px Tahoma, MS Sans Serif; color:black;border-color:black;',
			dismissDelay: 15000,
			html:'<div style="background-color:#DDDDDD;"><div  style="background-color:#FFFFFF;padding-top:5px;padding-bottom:5px;padding-left:5px;padding-right:5px;">'+RecordCount+' '+note+'</div></div>'
		}).show();
	}
}
	/*Added by Usha Juge For Defect: 57620*/
	function showTabLabelToolTip(eventObject){
		 var target=eventObject.target;
		if(target == null) 
			target = eventObject.srcElement;                              	
		var mainId = target.id;
		
		if (mainId != "noteImg_Auditing" && document.getElementById('tabid_'+mainId) != 'undefined')
		{		
			new Ext.ToolTip({
				target: mainId ,
				anchor: 'right',			
				bodyStyle:'font: 11px Tahoma, MS Sans Serif; color:black;border-color:black;',
				dismissDelay: 15000,
				html:document.getElementById('tabid_'+mainId).innerHTML
			}).show();
		}
	}   
function processTabRecCount(map){
	if(map!=null && typeof(map)!='undefined' && map.length > 2){
	  
		map = map.substring(1,map.length-1);
		var rec = map.split(',');
		for(var i =0;i<rec.length;i++){
			var idVal = splitInTwo(rec[i],'=');
			idVal[0] = idVal[0].replace(' ','');
			var elem = document.getElementById(idVal[0]);
			if(elem != null && typeof(elem )!='undefined'){ 
				elem.innerHTML = idVal[1]+'';
			}
		}
	}

}	
	
	
	Ext.onReady(function () {
	    Ext.override(Ext.data.Store, {
	        sortData : function(f, direction){
	            direction = direction || 'ASC';
	            var st = this.fields.get(f).sortType;
	            var fn = function(r1, r2){
	                var v1 = st(r1.data[f]), v2 = st(r2.data[f]);
					if(typeof(v1.toLowerCase) == 'function'){
						v1 = v1.toLowerCase();
						v2 = v2.toLowerCase();
					}
	                return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
	            };
	            this.data.sort(direction, fn);
	            if(this.snapshot && this.snapshot != this.data){
	                this.snapshot.sort(direction, fn);
	            }
	        }
	    });
        Ext.QuickTips.init();
		if(document.getElementById('urlForStaticResourceId') != null)
			document.getElementById('urlForStaticResourceId').value=getSdeStyleResource();
		var gtabpanel = {
                xtype: 'grouptabpanel',
                activeGroup: 0,
                id: 'grptabpanel',    
                tabWidth: 135,              
                items: getStrGrpTabVal()
        };
        
		detailsPanel = new Ext.Panel({
            title:dispalyTitle,
// IE7-8 Related Changes -- uncommented render
            renderTo: 'detailsDiv',            
            
                region:'south',
                id:'south-panel',
                width:'100%',
                split:isResizable ,
                layout: 'fit',
                overflow:'auto',
                autoScroll:false,
// IE7-8 Related Changes
                height:Ext.isIE7 ?panelHeightIE7:Ext.isIE ?panelHeightIE:panelHeight, // ****************************************
                cls:'detailsSectionCls',
                collapseMode: 'mini',
                items: [gtabpanel] ,
				tools:[
                    {
                        id: 'minimize',
					
                        handler: function() {
                            window.parent.Ext.getCmp('southPanelSI').collapse();
                        }
                    
                    },
                    {
                        id: 'maximize',
						
                        handler: function() {
						   
                            detailsPanel.tools['maximize'].hide();
                            detailsPanel.tools['restore'].show();
                            var height= Ext.isIE7 ? 660: Ext.isIE ? 664:Ext.isSafari ? 685:670;
							if(pageName=='BMC_BaseElement__c'){
							  height=Ext.isIE7 ? 595: Ext.isIE ? 595:Ext.isSafari ? 608:593;
							}
                            window.parent.Ext.getCmp('southPanelSI').setHeight(height);
                            window.parent.Ext.getCmp('canvasPanelId').doLayout(true,true);
							detailsPanel.tools['restore'].dom.style.display= 'inline'; 
							detailsPanel.tools['maximize'].dom.style.display= 'none'; 
                        }
                    },
                    {
                        id: 'restore',
                        hidden:true,
                        handler: function() {
                            detailsPanel.tools['maximize'].show();
                            detailsPanel.tools['restore'].hide();
                            var heightCanvasPanel=Ext.isIE7 ? 670: Ext.isIE ? 674:Ext.isSafari ? 695:680;
                            var heightSotuhPanel=Ext.isIE ?182:180;
							if(pageName=='Change_Request__c'){
							  heightSotuhPanel=Ext.isIE7 ? 275: Ext.isIE ? 250:245;
							}else if(pageName=='Problem__c'){
							  heightSotuhPanel=Ext.isIE7 ? 230:Ext.isIE ?230:240;
							}else if(pageName=='BMC_BaseElement__c'){
							  heightCanvasPanel=Ext.isIE7 ? 605: Ext.isIE ? 605:Ext.isSafari ? 618:603;
							  heightSotuhPanel=Ext.isIE7 ? 230:Ext.isIE ?230:230;
							}
                            window.parent.Ext.getCmp('canvasPanelId').setHeight(heightCanvasPanel);
                            
                            window.parent.Ext.getCmp('southPanelSI').setHeight(heightSotuhPanel);
                            window.parent.Ext.getCmp('canvasPanelId').doLayout(true,true);
							detailsPanel.tools['maximize'].dom.style.display= 'inline';
                            detailsPanel.tools['restore'].dom.style.display= 'none';
                        }
                    
                    }
                    ]
                    
            });
			  applyToolTipOnSIHeaderBtn();
			  
		
		if(typeof(window.parent.afterResetSI) == 'function'){
		    
		    window.parent.afterResetSI();
		}
		if(typeof(window.parent.refreshIncidentTab) == 'function'){
		    window.parent.refreshIncidentTab();
		}
     detailsPanel.tools['maximize'].dom.id= 'MaximizeBtnId'; 
	 detailsPanel.tools['restore'].dom.id= 'RestoreBtnId';
	 detailsPanel.tools['minimize'].dom.id= 'MinimizeBtnId';
    });	 // ends Ext.Onready
	
	function clearCookie(){
			clearSICookie(window.parent.cookieName);
			var southPanelSI=window.parent.Ext.getCmp('southPanelSI');
			var tempHeight= Ext.isIE7 ? 660: Ext.isIE ? 664:Ext.isSafari ? 685:670;
			var southPanelSIheight=southPanelSI.getHeight();
			if(southPanelSIheight >= tempHeight)
			   restoreSouthPanelSI();
			window.parent.removeSI(window.parent.iFrameSrc);
	}
	function restoreSouthPanelSI(){  
		var heightCanvasPanel=Ext.isIE7 ? 670: Ext.isIE ? 674:Ext.isSafari ? 695:680;
        var heightSotuhPanel=Ext.isIE ?182:180;
		if(pageName=='Change_Request__c'){
		  heightSotuhPanel=Ext.isIE7 ? 275: Ext.isIE ? 250:245;
		}else if(pageName=='Problem__c'){
			heightSotuhPanel=Ext.isIE7 ? 230:Ext.isIE ?240:240;
		}
        window.parent.Ext.getCmp('canvasPanelId').setHeight(heightCanvasPanel);                
        window.parent.Ext.getCmp('southPanelSI').setHeight(heightSotuhPanel);
        window.parent.Ext.getCmp('canvasPanelId').doLayout(true,true);	
	  
	}
	function filePopUp(attachmentId){        
        if(attachmentId!=null && attachmentId != ''){
            if(attachmentId.indexOf('[url]')>0){
                var newUrl = attachmentId.split('[url]')[0];
                if(newUrl.match('http:')!=null || newUrl.match('https:')!=null){
                    newUrl = newUrl;
                }else{
                    newUrl = 'http://' + newUrl;
                }
                window.open(newUrl,'','scrollbars=yes,menubar=no,height=1000,width=1000,resizable=yes,toolbar=no,location=yes,status=no');
            }else{
				window.open('/servlet/servlet.FileDownload?file='+attachmentId);
            }
        }else{
            checkValidity();    
        }
    }
    
    function openURL(url){
        var newUrl;
        if(url.match('http:')!=null || url.match('https:')!=null){
            newUrl = url;
        }else{
            newUrl = 'http://' + url;
        }
        window.open(newUrl,'','scrollbars=yes,menubar=no,height=1000,width=1000,resizable=yes,toolbar=no,location=yes,status=no');
    }
    
    function openFile(data, metadata, record, rowIndex, columnIndex, store){
        if(record.get(type) == 'File')
           return '<a ondblclick="filePopUp(\''+record.get(attachId)+'\')">'+data+'</a>';
        else if(record.get(type) == 'Url')  
            return '<a ondblclick="openURL(\''+record.get(urlName)+'\')">'+data+'</a>';   
    }
    
	function showNote(data, metadata, record, rowIndex, columnIndex, store) {
		data =data.replace(/<br>/gi," ");
		if(data!= '-' && data!= ' ' && data!= null)
		metadata.attr = 'title="'+data+'"';
	    data=Ext.util.Format.ellipsis(data, 60)
		return data;
    }
	     
function shState(data, metadata, record, rowIndex, columnIndex, store){
	return ""+data=="true" ? "Opened" : "Closed";        
}      
    
function colRenderer(data, metadata, record, rowIndex, columnIndex, store){
	if(data==null) data="";
	if(typeof(cols[columnIndex]) != 'undefined' && cols[columnIndex].toLowerCase()=='state__c')
		return shState(data, metadata, record, rowIndex, columnIndex, store);
	else{
		data =data.replace(/<br>/gi," ");
		if(data!= '-' && data!= ' ' && data!= null)
		metadata.attr = 'title="'+data+'"';
		data=Ext.util.Format.ellipsis(data, 60)
		return data;
	}
		
}
	function columHdrsJS(cols){
		arrCols = new Array();
		for(i=0;i<colsHdrs.length;i++){
			flds[i]='fld'+i;
		}
		recId = flds[0];
		var sortFlag = false;
		for(j=0; colsHdrs.length > j;j++){
			if(j==0){            
				arrCols[j] = {id:flds[j], header: colsHdrs[j], width: 10, dataIndex: flds[j], hideable: false, hidden: true};
			}else{
				if(cols != 'undefined' && cols[j].toLowerCase()=='attachmentid__c'){
					attachId = flds[j];
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1], sortable: sortFlag, dataIndex: flds[j],hidden: true};
				}else if(cols != 'undefined' && cols[j].toLowerCase()=='type__c'){
					type = flds[j];
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1], sortable: sortFlag, dataIndex: flds[j],hidden: true};
				}else if(cols != 'undefined' && cols[j].toLowerCase()=='filename__c'){
					urlName = flds[j];
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1], sortable: sortFlag, dataIndex: flds[j]};
				}else if(cols != 'undefined' && (cols[j].toLowerCase()=='note__c' || cols[j].toLowerCase()=='comments')){
					noteField = flds[j];
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1],  sortable: sortFlag, dataIndex: flds[j],renderer:showNote};
				}else if(cols != 'undefined' && cols[j].toLowerCase()=='type' && childObjectName == 'ProcessInstance'){
					instanceTypeIndex = flds[j];
				}else if(cols != 'undefined' && childObjectName == 'CustomAttachment__c'){
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1], sortable: sortFlag, dataIndex: flds[j]};
				}else{
					arrCols[j] = {header: colsHdrs[j],width:colwidth[j-1], sortable: sortFlag, dataIndex: flds[j],renderer: colRenderer};
				}
			}
			if(cols != 'undefined' && cols[j].toLowerCase()=='name'){
				nameFld = flds[j];
			}
		}			
	}
  
	DataGrid = function() {
		// create the data store
        var store = new Ext.data.ArrayStore({
            fields: flds ,
            data:resultSet
        });
        // create the Grid
        grid = new Ext.grid.GridPanel({
            border:false,
            tbar: getStrItem(),
            id: 'HistoryTab',
            store: store,
            columns: arrCols,
            stripeRows:true,            
			enableHdMenu :false, 
			sortInfo: {
    			field: sortColumn,
    			direction: sortDirection
			},
// IE7-8 Related Changes     
            cls:'detailSectionGridCls',
			listeners: {
				rowclick: function(grid, rowIndex, e) {    
					if(grid.getSelectionModel().getSelected() != null){                 // ****************
						selectedId = grid.getSelectionModel().getSelected().get(recId);                        
						NameVal = grid.getSelectionModel().getSelected().get(nameFld);
					}else{ // *****
                       	selectedId = '';
                    } // **********					
					for(var i = 0; i < idArray.length; i++){
							if(typeof(Ext.getCmp(idArray[i]))!='undefined')
								Ext.getCmp(idArray[i]).setDisabled(false);
						}
					
					if(closeCheck == null || closeCheck == '' || closeCheck == 'null'){
						for(var i = 0; i < unlinkIdArray.length; i++){
							if(typeof(Ext.getCmp(unlinkIdArray[i]))!='undefined')
								Ext.getCmp(unlinkIdArray[i]).setDisabled(false);
						}
					}
                    if(multiSelectOption){
						objList = grid.getSelectionModel().getSelections();
						idList = '';
						var addFlag = true
						var i=0;
						while(addFlag){
							if(objList[i] != null){
								idList = idList+ objList[i].get(flds[0])+ ',';
							}                           
							i++;
							if(i>objList.length){
								addFlag = false;
							}                           
						}
					}                                               
				},
                headerclick : function(grid, columnIndex,e ) {
					var sortableColumn = true;
					var unsortableCols = getunsortableCols();
                    for(j=0; unsortableCols.length > j;j++){
						if(cols[columnIndex] == unsortableCols[j]){
							sortableColumn = false;
                            break;
						}
					}
                    if(sortableColumn ){
						if(sortColumnName == cols[columnIndex]+''){
							if(sortDirection == 'ASC'){
								sortDirection = 'DESC';
							}else{
								sortDirection = 'ASC';
							}
						}else{
							sortDirection = 'ASC';
						}
						sortColumnName = cols[columnIndex]+'';
						sortColumnIndex = columnIndex;
						handleColumnClick(sortColumnName, sortDirection, childObject);
					}
				},
                rowdblclick: function(grid, rowIndex, e) {
					var clickedId = grid.getSelectionModel().getSelected().get(recId);
					if(childObjectName == 'ProcessInstance'){
						var instanceType = grid.getSelectionModel().getSelected().get(instanceTypeIndex);
						
						if(instanceType.toLowerCase() == 'processinstanceworkitem')
							param = 'true';
						else
							param = 'false';
					}
				if(childObjectName != 'Attachment' && editLink != 'dummy'){
							beforeEdit(editLink,clickedId);
						}
						if(childObjectName == 'CustomAttachment__c'){
							var linkType = grid.getSelectionModel().getSelected().get('fld4');
							if((linkType == 'File') || (linkType == labelFile))
								filePopUp(grid.getSelectionModel().getSelected().get('fld3'));
							else if(linkType == 'Url')  
								openURL(grid.getSelectionModel().getSelected().get('fld2'))
						}
					
                },
                afterrender: function() {
					this.setHeight( this.ownerCt.getInnerHeight() );
                    this.setWidth('100%');
				},
				render: function() {
					this.ownerCt.addListener('resize', function() {
						Ext.each( this.items.items, function(item) { item.fireEvent('afterrender'); } );
					});
				}
			},
            viewConfig: {forceFit: true, scrollOffset:0}, 
            selModel: new Ext.grid.RowSelectionModel({singleSelect : !multiSelectOption})          
        }); 
        var unsortableCols = unsortableCols; // ********************* seems incorrect
        if(grid!=null && sortColumnIndex!=null && sortDirection != null){
            var newColName = colsHdrs[sortColumnIndex];
            if(sortDirection == 'ASC'){
				imgPath = imgPathAsc;
            }else if(sortDirection == 'DESC'){
				imgPath = imgPathDsc;
            } 
            newColName += '<img style="width:13px;height:13px" src="'+ imgPath +'"/>';
            grid.getColumnModel().setColumnHeader(sortColumnIndex,newColName);  
        }
		var gridPanel = new Ext.Panel({
			layout:'fit',
			id:'gridPanelId',
			height:Ext.getCmp('south-panel').getHeight()-53,
			width:Ext.getCmp('south-panel').getWidth()-156,
			border:true,
			cls:'gridPanelCls'                  
		});
		gridPanel.add(grid);
		return gridPanel;            
    }
	
	TabAuditDetails = function() {
        var tabs = new Ext.Panel({
            contentEl: 'my-tabs',
            layout: 'fit',
            id: 'AuditDetailsTab',
            height:125,
            cls:'TabAuditDetailsCls',
            viewConfig: {forceFit: true}
        });
        return tabs;
    }
        
    TabDisplayToProfile = function() {
        var tabs = new Ext.Panel({
            contentEl: 'itemSelector',
            layout: 'fit',
            id: 'DisplayToProfileTab',
            viewConfig: {forceFit: true}
        });
        return tabs;
    }
        
    function tabElementJS(){
		if(typeof(elem)!='undefined'){    
			if(childObjectName==parentObject && tabName=='Auditing'){
				var audittab = Ext.getCmp('AuditDetailsTab');//new TabAuditDetails();
		        var profiletab = Ext.getCmp('DisplayToProfileTab');//new TabAuditDetails();
		        var historytab = Ext.getCmp('HistoryTab');
		        if (audittab == null || typeof(audittab)=='undefined') {
					var Atab = new TabAuditDetails();
		            elem.remove(historytab);
		            elem.add(Atab);
		        }
		        else {
		                if (audittab != null) audittab.show();
		                if (profiletab != null) profiletab.hide();
		                if (historytab != null) elem.remove(historytab);
		            }		                
		        }else if(childObjectName==parentObject && tabName=='DisplayTo'){
					var audittab = Ext.getCmp('AuditDetailsTab');//new TabAuditDetails();
		            var profiletab = Ext.getCmp('DisplayToProfileTab');//new TabAuditDetails();
		            var historytab = Ext.getCmp('HistoryTab');
		            if (profiletab == null || typeof(profiletab) =='undefined') {
		                
		                var Dtab = new TabDisplayToProfile();
		                elem.remove(historytab);
		                elem.add(Dtab);
		                refreshProfile();
		            }
		            else {
		                if (audittab != null) audittab.hide();
		                if (profiletab != null) profiletab.show();
		                if (historytab != null) elem.remove(historytab);
					}
		        }else{
		            flag=false;
		            elem.removeAll();  
		            elem.getEl().child('.x-panel-body').update('');
		            elem.doLayout();
		            var dGrid = new DataGrid();
		            elem.add(dGrid); 
		        }   
		        elem.doLayout();
			}         
    }       
	function AlterCIExpBtnStatusJS(linkRecord){
		if(pageName=="Task__c"){
			
			if (typeof(this.parent.ChangeBtnStatus) != "undefined")
				this.parent.ChangeBtnStatus(linkRecord);
			}
else if(pageName=="Change_Request__c"){
			
			if (typeof(this.parent.ChangeBtnStatus) != "undefined")
				this.parent.ChangeBtnStatus(linkRecord);
			}
else if(pageName=="Problem__c"){
			
			if (typeof(this.parent.ChangeBtnStatus) != "undefined")
				this.parent.ChangeBtnStatus(linkRecord);
			}
else if(pageName=="Incident__c"){
   if (typeof(this.parent.ChangeCIExpBtnStatus) != "undefined")
				this.parent.ChangeCIExpBtnStatus(linkRecord);
	}
	}
			
	
	function showMessage(message){
                Ext.MessageBox.show({                       
                    msg:message ,
                    width:200,
                    height:'auto',
                    buttons: Ext.MessageBox.OK
                });
              }
              
            function showLinkError(){
                if(err != null && err != 'null' && err != ''){
                    showMessage(err);
                }else{
                    tabReload(childObject);
                }
            }
            
            function onPopupComplete(val){
				
				cObjectName= childObjectName;
				checkAutoModify(val,getTabId(),childObject);
            }
           
            function afterModifyCheckFunction(){
                isModifiable = getIsMidifiable();
				//tabReload(childObject);
				var historyPageName = getHistoryPageName();
				var historyId = getHistoryId();
				var historyActionId = getHistoryActionId();
                if(isModifiable && (err == null || err =='')){
                    if(historyPageName == 'incidentHistoryPage'){
                    window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId+'&historyActionId='+historyActionId+'&incidentId='+parentPageId,reloadData,'',Ext.isIE7 ? 432 : Ext.isIE8 ? 420 : 418,670);
                    isModifiable =false;
                    }else if(historyPageName == 'taskHistoryPage'){
                        var taskHistoryHeight = Ext.isIE7 ? 438 : Ext.isIE8 ? 428 : 426;
                        window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId,reloadData,'',taskHistoryHeight,670);
                        isModifiable =false;
                    }else if(historyPageName == 'ObjectHistoryPage' && cObjectName == 'Change_History__c'){
                        var historyHeight = Ext.isIE7 ? 415 : Ext.isIE8 ? 397 : 395;
                        window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId+'&formname=Change_Request__c',reloadData,'',historyHeight,670);
                        isModifiable =false;
                    }else if(historyPageName == 'ObjectHistoryPage' && cObjectName == 'Problem_History__c'){
                        var historyHeight = Ext.isIE7 ? 415 : Ext.isIE8 ? 397 : 395;
                        window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId+'&formname=Problem__c',reloadData,'',historyHeight,670);
                        isModifiable =false;
                    }else if(historyPageName == 'ObjectHistoryPage' && cObjectName == 'BMC_BaseElement_History__c'){
                        var historyHeight = Ext.isIE7 ? 395 : Ext.isIE8 ? 377 : 375;
                        window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId+'&formname=BMC_BaseElement__c',reloadData,'',historyHeight,670);
                        isModifiable =false;
                    }else if(historyPageName == 'ObjectHistoryPage' && cObjectName == 'SLA_History__c'){
                        var historyHeight =Ext.isIE7 ? 398 : Ext.isIE8 ? 380 : 378;
                        window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId+'&formname=ServiceLevelAgreement__c',reloadData,'',historyHeight,670);
                        isModifiable =false;
                    }else { 
                    window.parent.openPopupWithTitle(historyPageName+'?isLookup=true&Id='+historyId,reloadData,'',Ext.isIE7 ? 416 : Ext.isIE8 ? 408 : 408,670);
                    isModifiable =false;
                    }
                }
            }
           
            function refreshDocs(){
                tabReload(childObject);
                if(pageName == 'Account')
                     setNumberOfUsers();
            }
            
            function setId(pageId,isSave){
                document.getElementById(cmpStr_id).value = pageId;
                if(isSave != null && typeof isSave != 'undefined' && isSave == true)
				{
					tabReloadOnStart(childObject);	//doNothing...removed and directly called AF  to cut down extra HTTP Post: Performance fix
                }else
				{
					tabReload(childObject);		//doNothing...removed and directly called AF  to cut down extra HTTP Post: Performance fix
				}
            }
            
            function reloadData(val){
                tabReload(childObject);
            }
            
            function openCommonPopup(url, oncompletefunction) {
                openPopup(url, oncompletefunction, 400, 730);
            }
            
            function openPopupForTemplate(url, oncompletefunction, title) {                     
                window.parent.openPopupWithTitle(url, oncompletefunction, title,500,660);
            }
			
		function openNewTabItems(url,pageTitle) { 
                var header;
                var title;
				 
                if(childObjectName.toLowerCase() == 'broadcasts__c'){                    
					header = broadcastLabelPlural;
                    title = broadcastLabel;
                }else if(childObjectName.toLowerCase() == 'servicelevelagreement__c'){
                    header = slaLabelPlural;
                    title = slaLabel;					
                }else if(childObjectName.toLowerCase() == 'category__c'){
                    header = categoryLabelPlural;
                    title = categoryLabel;
                }else if(childObjectName.toLowerCase() == 'user'){
                    header = clientCustLabelPlural;
                    title = clientCustLabel;
                }else if(childObjectName.toLowerCase() == 'account'){
                    header = accountLabelPlural;
                    title = accountLabel;
                }else if(childObjectName.toLowerCase() == 'standarddescription__c'){
                    header = standardDescriptionLabel;
                    title = standardDescriptionLabel;
                }else if(childObjectName.toLowerCase() == 'action__c'){
                    header = actionLabelPlural;
                    title = actionLabel;
                }else if(childObjectName.toLowerCase() == 'change_request__c'){
                    header = changeRequestLabelPlural;
                    title = changeRequestLabel;
                }else if(childObjectName.toLowerCase() == 'change_assessment__c'){
                    header = changeAssessmentLabelPlural;
                    title = changeAssessmentLabel;
                }else if(childObjectName.toLowerCase() == 'incident__c'){
                    header = incidentLabelPlural;
                    title = incidentLabel;
                }else if(childObjectName.toLowerCase() == 'task__c'){				
                    header = taskLabelPlural;
                    title = taskLabel;
                }else{
                    header = childObjectName.split('__c')[0]+'s';
                    title = childObjectName.split('__c')[0]+'s';
                }
					url = encodeURI(url);
					if(childObjectName.toLowerCase() == 'servicelevelagreement__c'){
					//Code for std form.. if adding agreement through CMDB tab SI.
					if(getUrlParameter('wid')==null || getUrlParameter('wid')=='') {
							var module='Configuration Items';
							var node= url.substring(0,url.indexOf('%253F',0));
							var baseId = url.substring(url.indexOf('BaseElementid',0)+18,url.indexOf('%2526',url.indexOf('BaseElementid',0)));
							url='/apex/StdWorkspacesPage?moduleName='+module+'&BMC_BaseElementid='+baseId+'&node='+node+'&fromstdCI=true'; 
						   window.parent.parent.parent.parent.location=url;
					 } else
					      window.parent.parent.parent.parent.addNewTab(pageTitle, header, "NavigatorPage?title="+title+"&target="+url);
                }  else{ 	
            				window.parent.parent.parent.addNewTab(pageTitle, header, "NavigatorPage?title="+title+"&target="+url);
						}  
            		//code for std fom... End
				}
            
            function openEditTabItems(url,pageTitle) {    
                var header;
                var title;
                if(childObjectName.toLowerCase() == 'broadcasts__c'){
                    header = broadcastLabelPlural;
                    title = broadcastLabel;
                }else if(childObjectName.toLowerCase() == 'servicelevelagreement__c'){
                    header = slaLabelPlural;
                    title = slaLabel;					
                }else if(childObjectName.toLowerCase() == 'category__c'){
                    header = categoryLabelPlural;
                    title = categoryLabel;
                }else if(childObjectName.toLowerCase() == 'user'){
                    header = clientCustLabelPlural;
                    title = clientCustLabel;
                }else if(childObjectName.toLowerCase() == 'account'){
                    header = accountLabelPlural;
                    title = accountLabel;
                }else if(childObjectName.toLowerCase() == 'standarddescription__c'){
                    header = standardDescriptionLabel;
                    title = standardDescriptionLabel;
                }else if(childObjectName.toLowerCase() == 'action__c'){
                    header = actionLabelPlural;
                    title = actionLabel;
                }else if(childObjectName.toLowerCase() == 'processinstance'){
					if(parentObject == 'Change_Request__c'){
						NameVal = getCRName();
					}
					if(parentObject == 'Incident__c'){
						NameVal =getIncidentName();
					}
					header = approvalLabel;
                    title = approvalLabel;
					//NameVal = getCRName();
				}
                else if(childObjectName.toLowerCase() == 'change_request__c'){
                    header = changeRequestLabelPlural;
                    title = changeRequestLabel;
                }else if(childObjectName.toLowerCase() == 'change_assessment__c'){
                    header = changeAssessmentLabelPlural;
                    title = changeAssessmentLabel;
                }else if(childObjectName.toLowerCase() == 'incident__c'){
                    header = incidentLabelPlural;
                    title = incidentLabel;
                }else if(childObjectName.toLowerCase() == 'task__c'){					
                    header = taskLabelPlural;
                    title = taskLabel;
                }else if(childObjectName.toLowerCase() == 'problem__c'){				
                    header = problemLabelPlural;
                    title = problemLabel;
                }else{
                    header = childObjectName.split('__c')[0]+'s';
                    title = childObjectName.split('__c')[0];
                }
				url = encodeURI(url);
                if(pageTitle.toLowerCase() == 'incidentpage' || pageTitle.toLowerCase() == 'taskpage'){
                     window.parent.parent.parent.addNewTab(pageTitle, header, "NavigatorPage?title=%23"+NameVal+"&tabTitle=%23"+NameVal+"&target="+url);  
                }else{ if(pageTitle.toLowerCase() == 'slapage')
					//Code for std form.. if editing agreement through CMDB tab SI.   
						 { 
						   if(getUrlParameter('wid')==null || getUrlParameter('wid')=='') {
								var module='Configuration Items';
								var node= url.substring(0,url.indexOf('%253F',0));
								var baseId = url.substring(url.indexOf('id',0)+7,url.indexOf('%2526',url.indexOf('id',0)));
								url='/apex/StdWorkspacesPage?moduleName='+module+'&id='+baseId+'&node='+node+'&fromstdCI=true'; 
							   window.parent.parent.parent.parent.location=url;
							}
							else {
								window.parent.parent.parent.parent.addNewTab(pageTitle, header, "NavigatorPage?title="+title+"&tabTitle="+NameVal+"&target="+url); 
							}
						}
					   else { window.parent.parent.parent.addNewTab(pageTitle, header, "NavigatorPage?title="+title+"&tabTitle="+NameVal+"&target="+url); }
					//Code for std form...End
				}
            }
            
            function refreshParentList(){
                if(window.parent.parent.refreshList != null)
					window.parent.parent.refreshList();
            }
			var moduleName;
			
			function getModuleNameJS(){
				if(typeof(window.parent.parent.getModuleName) == 'function'){
	                    moduleName = window.parent.parent.getModuleName();
						moduleName = encodeURI(moduleName);
	                    var parts = moduleName.split('%C2%AC');
	                    moduleName = parts[0];
						moduleName = decodeURI(moduleName);
	                }
				}
				
				
			function addJS(pageName, parentName){
			       if(pageName == 'SLAPage' && parentName.match('BMC_BaseElement__c')){
				        if(typeof(window.parent.parent.parent.getModuleName) == 'function'){					    
	                    moduleName = window.parent.parent.parent.getModuleName();
						moduleName = encodeURI(moduleName);
	                    var parts = moduleName.split('%C2%AC');
	                    moduleName = parts[0];
						moduleName = decodeURI(moduleName);
	                  }
					}else{ 
					    if(typeof(window.parent.parent.getModuleName) == 'function'){
					    //alert('in else sla');
	                    moduleName = window.parent.parent.getModuleName();
						moduleName = encodeURI(moduleName);
	                    var parts = moduleName.split('%C2%AC');
	                    moduleName = parts[0];
						moduleName = decodeURI(moduleName);
	                }}
                var strFormId;
                var popupTitle ='';
				
				if(pageName=='DocumentationPage'){
                    
                        if (document.all)
                        {
                            //its IE
                            window.parent.openPopupWithTitle(pageName+"?parentId="+parentPageId+'&isLookup=true'+'&objectType='+parentObject,'',lableAddDocumentation,163,450);
                        }
                        else
                        {
                            window.parent.openPopupWithTitle(pageName+"?parentId="+parentPageId+'&isLookup=true'+'&objectType='+parentObject,'',lableAddDocumentation,160,441);
                        }
                    
                    
                }else{
                    if(pageName.match('popupId')!=null){
                        if(pageName.match('popupId=Action')){
                              if(parentName.match('Incident__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToIncident__c=true and system__c=false"),onPopupComplete,popupTitle,407,575);
                              }else if(parentName.match('Broadcasts__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToBroadcasts__c=true and system__c=false"),onPopupComplete,popupTitle,407,575);
                              }else if(parentName.match('Task__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToTask__c=true and system__c=false"),onPopupComplete,popupTitle,407,575);
                              }else if(parentName.match('Problem__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToProblem__c=true and system__c=false"),onPopupComplete,popupTitle,407,575);
                              }else if(parentName.match('Change_Request__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToChange__c=true and system__c=false"),onPopupComplete,popupTitle,407,575);
                              }else if(parentName.match('BMC_BaseElement__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToConfigurationItems__c=true and system__c=false"),onPopupComplete,popupTitle,387,575);
                              }else if(parentName.match('ServiceLevelAgreement__c') ){
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("appliesToSLA__c=true and system__c=false"),onPopupComplete,popupTitle,387,575);
                              }else{
                                    window.parent.openPopupWithTitle(pageName+'&isLookup=true&filterClause='+escape("system__c=false"),onPopupComplete,popupTitle,407,575);
                              }
                        }else{
                            openNewTabItems(pageName+'?'+strFormId+'='+parentPageId,pageName);
                        }
                    }else{
                        
                        strFormId = parentObject.split('__c')[0]+'id';                
                        if(strFormId == 'IncidentTemplate__Cid'){                   
                            openNewTabTemplate(pageName+'?isLookup=true&'+strFormId+'='+parentPageId ,reloadData, labelLinkedTemp);
                        }else{
                            
                            if(pageName == 'StandardResolutionPage'){
                            window.parent.openPopupWithTitle(pageName+'?isLookup=true?&'+strFormId+'='+parentPageId,'',popupTitle,223,600);
                            }else{
                            if(pageName == 'taskPage' || pageName == 'SLAPage' || pageName == 'IncidentPage' || pageName == 'categoryPage' || pageName =='StandardDescriptionPage'|| pageName =='ClientPage'|| pageName == 'OrganizationPage'|| pageName == 'categorypage' || pageName == 'ChangeRequestPage'){
                            
                            
                            openNewTabItems(pageName+escape('?'+strFormId+'='+parentPageId+'&parentWid='+parentWid+'&moduleName='+moduleName+'&isInactive=true'),pageName);
                            }
                                else {
								      openNewTabItems(pageName+escape('?'+strFormId+'='+parentPageId+'&parentWid='+parentWid+'&moduleName='+moduleName),pageName);}
                            
                            }
                        }            
                    }
                }
            }
			
		    
            function linkTemplateComplete(val){
                linkTemplateToParent(val,parentPageId);
            }
    
            function unLinkTemplateComplete(val){
                unLinkTemplateFromParent(val,parentPageId);
            }    
    function linkCI(){  
		if(pageName=="Change_Request__c"){
			openPopupForTemplate('SearchPage?popupId=BMC_BaseElement&isLookup=true&filterObjectId='+parentPageId+"&parentName=Change_Request__c",linkCIComplete,'');
		}else if(pageName=="Problem__c"){
			openPopupForTemplate('SearchPage?popupId=BMC_BaseElement&isLookup=true&filterObjectId='+parentPageId+"&parentName=Problem__c",linkCIComplete,'');
		}else if(pageName=="Incident__c"){
			var incclientId=window.parent.getUserID();
						var incidentId = window.parent.getIncidentID();
						var incCiId = window.parent.getCIelemID();
						var incServiceId = window.parent.getServiceElemID();
						openPopupForTemplate('SearchPage?popupId=BMC_BaseElement&isLookup=true&filterObjectId='+incclientId+'&parentName=Incident__c&isRadioChecked=false&accountId='+window.parent.getAccountID()+'&incCiId='+incCiId+'&incServiceId='+incServiceId+'&selectedCIFilter='+window.parent.LinkedToClient+'&incidentId='+incidentId,linkCIComplete,'');
		}
		else{
                openPopupForTemplate('SearchPage?popupId=BMC_BaseElement&isLookup=true&filterObjectId='+parentPageId,linkCIComplete,'');
		}
	}
	function linkService(){
		if(pageName=="Change_Request__c"){
				openPopupForTemplate('SearchPage?popupId=BMC_BusinessService&isLookup=true&filterObjectId='+parentPageId+"&parentName=Change_Request__c",linkCIComplete,'');
		}else if(pageName=="Problem__c"){
			openPopupForTemplate('SearchPage?popupId=BMC_BusinessService&isLookup=true&filterObjectId='+parentPageId+"&parentName=Problem__c",linkCIComplete,'');
		}else{
                openPopupForTemplate('SearchPage?popupId=BMC_BusinessService&isLookup=true&filterObjectId='+parentPageId,linkCIComplete,'');
		}
}        
            function linkCIComplete(val){
                var newTaskId = "";
                if(pageName=="Task__c"){
                    newTaskId = window.parent.AssignNewTaskId();
					linkCITask(val, newTaskId);
                }else if(pageName=="Change_Request__c"){
					linkCIChange(val);
				}else if(pageName=="Problem__c"){
					linkCIProblem(val);
				}
				else if(pageName=="Incident__c"){
					linkCIIncident(val);
				}
                
            }
    
            function unLinkTemplate(){
                if(idList != null && idList != ''){
                    unLinkTemplateFromParent(idList,parentPageId);
                    idList ='';
                }else{
                    Ext.MessageBox.show({                                
                                title: ' ',
                                msg:'Please select a record',
                                width:'auto',
                                buttons: Ext.MessageBox.OK
                            });
                }
            }
			
function composeMailOnComplete(){
            	getIncidentHistoryRenderer();
}	
		
function beforeEdit(editLink,selectedId){
	isHistoryEMailRecord = false;
	var historyRecIds = '';
	var recordId = '';
	var emailPageHeader = '';
	var recordName = '';
	if(editLink == 'IncidentHistoryPage'){
		historyRecIds = incidentHistoryRecords.split(',');
		recordId = parent.incidentId;
		emailPageHeader = composeEmailPageHeaderLabel;
		recordName = parent.incidentName;
	}
	else if(editLink.toLowerCase() == 'objecthistorypage' && childObjectName != null 
		&& childObjectName != '' && childObjectName.toLowerCase() == 'change_history__c'){
		historyRecIds = changeHistoryRecords.split(',');
		recordId = parent.changeRequestId;
		emailPageHeader = composeEmailChangePageHeaderLabel;
		recordName = parent.changeRequestName;
	}
	else if(editLink.toLowerCase() == 'objecthistorypage' && childObjectName != null 
		&& childObjectName != '' && childObjectName.toLowerCase() == 'problem_history__c'){
		historyRecIds = problemHistoryRecords.split(',');
		recordId = parent.problemId;
		emailPageHeader = composeEmailProblemPageHeaderLabel;
		recordName = parent.getProblemName();
	}
	else if(editLink.toLowerCase() == 'taskhistorypage' && childObjectName != null 
		&& childObjectName != '' && childObjectName.toLowerCase() == 'taskhistory__c'){
		historyRecIds = taskHistoryRecords.split(',');
		recordId = parent.taskId;
		emailPageHeader = composeEmailTaskPageHeaderLabel;
		recordName = parent.taskName;
	}
	if(historyRecIds.indexOf(selectedId) != -1){
		  isHistoryEMailRecord = true;
	}
	if(isHistoryEMailRecord){
		  parent.openPopupWithTitle('ComposeEmailPage?recordId='+recordId+'&HistoryId='+ selectedId + '&isNew=false&objectName='+parentObject,composeMailOnComplete,emailPageHeader+ recordName,getEmailWinHt(),getEmailWinWidth(),false);
	}else{
		var idArray = new Array(resultSet.length);
		for(var i = 0;i < resultSet.length; i++){
			idArray[i]  = grid.store.getAt(i).get(recId);
		}
		
		if(typeof(window.parent.parent.parent.setIdArray) == 'function'){
			window.parent.parent.parent.setIdArray(idArray);
		}
		if(childObjectName != null && childObjectName != '') {
			if(childObjectName == 'Task__c' || childObjectName == 'Incident__c' || childObjectName == 'Problem__c' ||childObjectName == 'Change_Request__c'){
                    fetchData(childObjectName,selectedId);
            }else{
			edit(editLink,selectedId);
		}   
	}
}
}
			
function edit(pageName,id){
	var popupTitle = '';
	if(pageName!='null' && pageName!=''){
	  if(isaccess){
		if(id!=null && id != ''){
		var strFormId;
		strFormId = parentObject.split('__c')[0]+'id';              
		if(strFormId == 'IncidentTemplate__Cid'){
			openNewTabTemplate(pageName+'?id='+id+'&isLookup=true&'+strFormId+'='+parentPageId+'&module='+moduleName ,reloadData,labelEditTemp);
		}else{
			if(pageName.match('History') != null){
				if(pageName == 'IncidentHistoryPage'){
					window.parent.openPopupWithTitle(pageName+'?id='+id+'&isLookup=true','',popupTitle,Ext.isIE7 ? 432 : Ext.isIE8 ? 420 : 418,670);
				}else if(pageName == 'taskHistoryPage'){
					var taskHistoryHeight = Ext.isIE7 ? 438 : Ext.isIE8 ? 428 : 426;
					window.parent.openPopupWithTitle(pageName+'?id='+id+'&isLookup=true','',popupTitle,taskHistoryHeight,670);
				}else if(pageName == 'ObjectHistoryPage' && parentObject == 'Change_Request__c'){
					var taskHistoryHeight = Ext.isIE7 ? 415 : Ext.isIE8 ? 397 : 395;
					window.parent.openPopupWithTitle('ObjectHistoryPage?id='+id+'&formname=Change_Request__c&isLookup=true','',popupTitle,taskHistoryHeight,670);
				}else if(pageName == 'ObjectHistoryPage' && parentObject == 'Problem__c'){
					var taskHistoryHeight = Ext.isIE7 ? 415 : Ext.isIE8 ? 397 : 395;
					window.parent.openPopupWithTitle('ObjectHistoryPage?id='+id+'&formname=Problem__c&isLookup=true','',popupTitle,taskHistoryHeight,670);
				}else if(pageName == 'ObjectHistoryPage' && parentObject == 'BMC_BaseElement__c'){
					var taskHistoryHeight = Ext.isIE7 ? 395 : Ext.isIE8 ? 377 : 375;
					window.parent.openPopupWithTitle('ObjectHistoryPage?id='+id+'&formname=BMC_BaseElement__c&isLookup=true','',popupTitle,taskHistoryHeight,670);
				}
				else if(pageName == 'ObjectHistoryPage' && parentObject == 'ServiceLevelAgreement__c'){
					var taskHistoryHeight = Ext.isIE7 ? 398 : Ext.isIE8 ? 380 : 378;
					window.parent.openPopupWithTitle('ObjectHistoryPage?id='+id+'&formname=ServiceLevelAgreement__c&isLookup=true','',popupTitle,taskHistoryHeight,670);
				}
				else{
					window.parent.openPopupWithTitle(pageName+'?id='+id+'&isLookup=true','',popupTitle,Ext.isIE7 ? 416 : Ext.isIE8 ? 408 : 408,670);
				}
			}
			else{
				if(pageName == 'StandardResolutionPage'){
					window.parent.openPopupWithTitle(pageName+'?id='+id+'&isLookup=true','',popupTitle,201,550);
				}else if(pageName == 'Changeapproval'){
				   if(parentObject=='Change_Request__c')
						openEditTabItems(pageName + escape('?CAid=' + id + '&id=' + id + '&CAFlag=' +  param + '&ChangeId=' + parentPageId +'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true'),pageName);
				   if(parentObject=='Incident__c')
						openEditTabItems(pageName + escape('?CAid=' + id + '&id=' + id + '&CAFlag=' +  param + '&IncidentId=' + parentPageId +'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true'),pageName);
				   
				}else{
					openEditTabItems(pageName+escape('?id='+id+'&parentWid='+parentWid+'&moduleName='+moduleName+'&isDirect=true&columnField='+sortColumnName+'&direction='+sortDirection),pageName);
				}
			}
		}
		 
		}else{
		  checkValidity();
		}
	  }else{
		msgBox =Ext.MessageBox.show({                                
				title: ' ',
				msg: RecPermission,
				width:'auto',
				buttons: Ext.MessageBox.OK
			});
		}
	}
}
            
function onCompleteLinkToIncident(val){
	linkToInc(val);
}
function onCompleteLinkToChange(val){
	linkIncidentToChange(val);
}
function onCompleteLinkToProblem(val){
	linkIncidentToProblem(val);
}

function onCompleteLinkPChange(val){
	linkProblemToChange(val);
}
function onCompleteLinkCRToProblem(val){
	linkChangeToProblem(val);
}
function onCompleteLinkStaffToCategory(val){
	
	linkStaffToCategory(val);
}

function onCompleteLinkIncToCI(val){
	linkIncidentToCI(val);
}function onCompletelinkCRtoCI(val){
	linkCRtoCIJS(val);
} 
function onCompleteLinkPrbToCI(val){
	linkPrbtoCI(val);
} 
function onCompleteLinkAccToCI(val){
	linkAcctoCI(val);
}

//for Release
function onCompletelinkReleasetoCI(val){
	linkReleaseToCIJS(val);
}

function linkToIncident(){
	window.parent.openPopupWithTitle('searchPage?popupid=Incident&isLookup=true&filterClause='+escape("FKBroadcast__c=''"),onCompleteLinkToIncident,'',407,613);
}

function linkIncidentChange(){
	window.parent.openPopupWithTitle("searchPage?popupid=Incident&isLookup=true&filterObjectId="+parentPageId+"&parentName=Change_Request__c",onCompleteLinkToChange,'',407,613);
}
function linkIncidentProblem(){
	window.parent.openPopupWithTitle("searchPage?popupid=Incident&isLookup=true&filterObjectId="+parentPageId+"&parentName=Problem__c",onCompleteLinkToProblem,'',407,613);
}

function linkProblemChange(){
	window.parent.openPopupWithTitle("searchPage?popupid=Problem&isLookup=true&filterObjectId="+parentPageId+"&parentName=Change_Request__c",onCompleteLinkPChange,'',407,575); 
}

function linkChangeProblem(){
	window.parent.openPopupWithTitle("searchPage?popupid=Change&isLookup=true&filterObjectId="+parentPageId+"&parentName=Problem__c",onCompleteLinkCRToProblem,'',407,575); 
}

function assignSupportStaff(){
	var link = window.location + '';
	link = link.substring(link.indexOf('/apex/')+6,link.indexOf('?'));
	
	window.parent.openPopupWithTitle("searchPage?popupid=Client&isLookup=true&filterObjectId="+parentPageId+'&parentpage='+link+'&filterClause='+escape("IsStaffUser__c=true"),onCompleteLinkStaffToCategory,'',407,575);
}

 function unLinkToCategory(id){
	if(id!=null && id != ''){
		unLinkStaffCategory(id);
		selectedId = null;
	}else{
	   checkValidity();
	}
}

function linkIncidentToCIJS(){
	window.parent.openPopupWithTitle("searchPage?popupid=Incident&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BaseElement__c",onCompleteLinkIncToCI,'',407,613);
}

function LinkClientHandlerJS(){
	window.parent.openPopupWithTitle("searchPage?popupid=Client&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BaseElement__c",onCompleteLinkClientToCI,'',407,613);
}

function onCompleteLinkClientToCI(val){
	linkClientToCI(val);
}



function confirmation(id){
   
	if(id!=null && id != ''){                
		Ext.MessageBox.confirm(labelDelete, labelDelConfirm, function(btn){
		   if(btn === 'yes'){
			deleteThisFile(id);
		   }
		   else{
				   }
	   });
	}else{
		checkValidity();
	}    
	
}
            
         
function checkValidity(){
	msgBox= Ext.MessageBox.show({                                
		title: ' ',
		msg:'select a record',
		width:'auto',
		buttons: Ext.MessageBox.OK
	});
}
     
        
function openProfilePopup(){
	openPopup('ProfileSelector?id='+parentPageId,null,325,700);
}

function showErrorMsg(errMsg){
	if(errMsg != null && errMsg != 'undefined')
		err = errMsg;
	if(err != null && err != ''){
		Ext.MessageBox.alert(' ', err);
		/*Ext.MessageBox.show({                                
			title: ' ',
			msg:err,
			width:'auto',
			buttons: Ext.MessageBox.OK
		});*/
	}
}

function handleNextPrevJS(hasPrev, hasNxt, closeChk) {
	for(var i = 0; i < idArray.length; i++){
		if(typeof(Ext.getCmp(idArray[i]))!='undefined')
			Ext.getCmp(idArray[i]).setDisabled(true);
	}
	for(var i = 0; i < unlinkIdArray.length; i++){
		if(typeof(Ext.getCmp(unlinkIdArray[i]))!='undefined')
			Ext.getCmp(unlinkIdArray[i]).setDisabled(true);
	}
	//if(typeof(Ext.getCmp('nextId')) != 'undefined' && recordExist)
		//Ext.getCmp('nextId').setDisabled(true);
	if(typeof(Ext.getCmp('prevId')) != 'undefined')
		Ext.getCmp('prevId').setDisabled(GetBRes(hasPrev));
	if(typeof(Ext.getCmp('nextId')) != 'undefined')
		Ext.getCmp('nextId').setDisabled(GetBRes(hasNxt));                    

//	 if(typeof(Ext.getCmp('nextId')) != 'undefined' && recordExist) // *******************
  //              Ext.getCmp('nextId').setDisabled(true);
	
	isModifiable =  getIsMidifiable();  
	historyId = getHistoryId();
	historyPageName = getHistoryPageName();
	historyActionId = getHistoryActionId();
	   
	if(closeChk != null && closeChk != '' && closeChk != 'null'){
		for(var i = 0; i < idArray.length; i++){
			if(typeof(Ext.getCmp(idArray[i]))!='undefined')
				Ext.getCmp(idArray[i]).setDisabled(true);
		}
//		for(var i = 0; i < recordIdArray.length; i++){
//				if(typeof(Ext.getCmp(recordIdArray[i]))!='undefined')
//					Ext.getCmp(recordIdArray[i]).setDisabled(true);
//		}
		
		for(var i = 0; i < closeIdArray.length; i++){
			if(typeof(Ext.getCmp(closeIdArray[i]))!='undefined') 
				Ext.getCmp(closeIdArray[i]).setDisabled(true);
		}
		
		for(var i = 0; i < unlinkIdArray.length; i++){
			if(typeof(Ext.getCmp(unlinkIdArray[i]))!='undefined')
				Ext.getCmp(unlinkIdArray[i]).setDisabled(true);
		}
	}
	if(!disableAdd){
		if(typeof(Ext.getCmp('addAssessmentToCR'))!='undefined')
			Ext.getCmp('addAssessmentToCR').setDisabled(true);
		if(typeof(Ext.getCmp('addCRToProblem'))!='undefined')
			Ext.getCmp('addCRToProblem').setDisabled(true);
		if(typeof(Ext.getCmp('editCRToProblem'))!='undefined')
			Ext.getCmp('editCRToProblem').setDisabled(true);
		if(typeof(Ext.getCmp('addCRToIncidnet'))!='undefined')
			Ext.getCmp('addCRToIncidnet').setDisabled(true);
		if(typeof(Ext.getCmp('addSLA'))!='undefined')
			Ext.getCmp('addSLA').setDisabled(true);
		
	}
	
	
}

function setChildTemplateOrderJS(lbltemplateExecOrder) {
	window.parent.openHierarchyPopupWithTitle('ChildTemplateHierarchy?parentTemplateId='+parentPageId,reloadData,lbltemplateExecOrder,230,320);
}	

function linkTemplateJS(lblTmpltToLnk) {
	openPopupForTemplate('SearchPage?popupId=Template&isLookup=true&filterObjectId='+parentPageId+'&filterClause='+escape("templateFor__c='Task'"),linkTemplateComplete,lblTmpltToLnk);
}
function linkCRtoIncident(){
	window.parent.openPopupWithTitle("searchPage?popupid=Change&isLookup=true&filterObjectId="+parentPageId+"&parentName=Incident__c",LinkCRToIncident,'',407,575); 
}
function linkCRtoCI(){
	window.parent.openPopupWithTitle("searchPage?popupid=Change&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BASEELEMENT__c",onCompletelinkCRtoCI,'',407,575); 
}
function LinkProblemToCIJS(){
    window.parent.openPopupWithTitle("searchPage?popupid=Problem&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BASEELEMENT__c",onCompleteLinkPrbToCI,'',407,575); 
}
function LinkAccountToCIJS(){
    window.parent.openPopupWithTitle("searchPage?popupid=Account&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BASEELEMENT__c",onCompleteLinkAccToCI,'',407,575); 
}

//Added for Release
function LinkReleaseToCI(){
	window.parent.openPopupWithTitle("searchPage?popupid=Release&isLookup=true&filterObjectId="+parentPageId+"&parentName=BMC_BASEELEMENT__c",onCompletelinkReleasetoCI,'',407,575); 
}
