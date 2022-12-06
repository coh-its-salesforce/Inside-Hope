var SLAId;
var idset;

var isCustomPage = true;
var clickedOnce = false;  
var isAutocomplete = false;

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

var NewBtnHandler = function(){ 
	openPage("SLAPage",SLAHeader,SLAHeader); activeAllWindowFlag=false;
	activeAllWindowFlag=false;
}

var SaveBtnHandler = function(){
	var SLADescriptionData = document.getElementById(SLA_DescriptionComponent).value.trim();
	var SLATitleData = document.getElementById(SLA_TitleComponent).value.trim();
	if(SLADescriptionData.length > 32000 ){
		Ext.MessageBox.show({ msg: labelSLADescription + ': ' + TextAreaOverflow, buttons: Ext.MessageBox.OK});         
		return;
	}		
	
	Ext.getCmp('saveId').setDisabled(true);
	var chkBoxValue=Ext.getCmp('SLA_inactive__c').getValue();
	waitbox(0);
	if(csvAccountListparam != '')
		save(chkBoxValue, csvAccountListparam);
	else 
		save(chkBoxValue);
	
}

var CopyBtnHandler = function(){ callCopyPage(); activeAllWindowFlag=false;}

var DeleteBtnHandler = function(){
	Ext.MessageBox.confirm(labelDelete, DeletedRecord, function(btn){
		if(btn === 'yes'){deleteSLA();} 
	});
}

var ResetBtnHandler  = function(){resetSLA();}

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

function PreviousBtnHandler(){
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
		
		previousSLABtnHandler(idSetString);		
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
		
		nextSLABtnHandler(idSetString);
	}
}


function buttonValidator(){
	SLAId = getSLAId();
	if(SLAId != null && SLAId != ''){
		if(getDeleteBtnFlag()){ 
			Ext.getCmp('deleteId').setDisabled(false);
			Ext.getCmp('deleteId').setIconClass('bmcDelete');
		} else {
			Ext.getCmp('deleteId').setDisabled(true);
			Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
		}
        
		if(getRefreshBtnFlag()){ 
			Ext.getCmp('resetId').setDisabled(false);
		
		} else {
			Ext.getCmp('resetId').setDisabled(true);
		
		}
		if(getNewBtnFlag()){
			Ext.getCmp('newId').setDisabled(false);
			Ext.getCmp('newId').setIconClass('bmcNew');
			Ext.getCmp('copyId').setDisabled(false);
			Ext.getCmp('copyId').setIconClass('bmcCopy');
		}else{
			Ext.getCmp('newId').setDisabled(true);
			Ext.getCmp('newId').setIconClass('bmcNewDisable');		
			Ext.getCmp('copyId').setDisabled(true);
			Ext.getCmp('copyId').setIconClass('bmcCopyDisable');		
		}

		if(getSaveBtnFlag()){
			Ext.getCmp('saveId').setDisabled(false);
			Ext.getCmp('saveId').setIconClass('bmcSave');		
		} else {
			Ext.getCmp('saveId').setDisabled(true);        
			Ext.getCmp('saveId').setIconClass('bmcSaveDisable');		
		}
		
		

		var isDisplay = document.getElementById('SIIframeID').style.display;
		if(cookieValue =='true' && isDisplay =='none' ){
			SIComp(iFrameSrc);
		}else{
			if(isDisplay == 'none') {
				document.getElementById('onDemandSITableId').style.display = 'block';
				document.getElementById('noSIAvailTD').style.display = 'none';
				document.getElementById('linkSIAvailTD').style.display = 'block';
			}
		 }
		 
	} else {
		if(getNewBtnFlag()){
			Ext.getCmp('newId').setDisabled(false);
			Ext.getCmp('newId').setIconClass('bmcNew');
		}else{
			Ext.getCmp('newId').setDisabled(true);
			Ext.getCmp('newId').setIconClass('bmcNewDisable');		
		}

		if(getSaveBtnFlag()){
			Ext.getCmp('saveId').setDisabled(false);
			Ext.getCmp('saveId').setIconClass('bmcSave');		
		} else {
			Ext.getCmp('saveId').setDisabled(true);        
			Ext.getCmp('saveId').setIconClass('bmcSaveDisable');		
		}
		
                Ext.getCmp('resetId').setDisabled(true);
		Ext.getCmp('deleteId').setDisabled(true);
		Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
		Ext.getCmp('copyId').setDisabled(true);
		Ext.getCmp('copyId').setIconClass('bmcCopyDisable');		
		
	}
}

function renderGrid(){
   
    	btnFlag = getSaveBtnFlag();
        ds = new Ext.data.Store({
                reader: new Ext.data.ArrayReader({}, [ 
                        {name: 'Aggrement_Title'},
                        {name: 'RelatedSLARecordId'}
                     ])
                });
        
        
    
        
        cm = new Ext.grid.ColumnModel([
                {
                   id: 'Aggrement_Title_Id',
                   header: labelAgreementTitle,
                   dataIndex: 'Aggrement_Title'
                }
        
        ]);
        
        btnLink = new Ext.Toolbar({
        	id:'RelatedSLAToolBarId',
			items: [{
                    xtype: 'box',
                    id: 'btnAdd',
                    autoEl: {tag: 'img', src: getSDFStylesResPath()+'/SDEFbuttons/btn_add.png', title:labelLinkSLA,name:'addBtn'},
                    style : 'cursor:pointer;padding-left:5px;padding-right:5px;',
                    listeners:{
                        render: function(c) {
                        	 
                            c.getEl().on('click', function(){
                            	rowClickFlag = 0; 
								SLAId = getSLAId();								
								if(SLAId != null && SLAId != '' && btnFlag == true){		
									openPopup('SearchPage?popupId=SLA&isLookup=true&isBlk=true&filterObjectId='+SLAId+'&filterClause='+escape('AgreementType__c = \''+selectedSLAAccodion+'\''),linkSLA);
								}
                            });
                        }
                    }
                },{
                    xtype: 'box',
                    id: 'btnRemove',
                    autoEl: {tag: 'img', src: getSDFStylesResPath()+'/SDEFbuttons/btn_delete_disable.png', title:labelUnLinkSLA,name:'removeBtn'},
                    style : 'cursor:pointer;padding-right:5px;',
                    
                    listeners:{
                        render: function(c) {
                        	
                            c.getEl().on('click', function(){
								SLAId = getSLAId();
                            	if(selectIdForDelete != null && selectIdForDelete != '' && btnFlag == true && SLAId != null && SLAId != ''){
                            		unlinkSLA(selectIdForDelete);
                            	}
								selectIdForDelete = '';
                            });
                            
                        }
                    }
                }
                
                ]
		});		
        slaGrid = new Ext.grid.EditorGridPanel({
             id: 'grid_id',        
             store: ds,
             layout: 'fit',
             autoScroll: true,	
             cm: cm,      
			 sm:  new Ext.grid.RowSelectionModel({singleSelect:true}),		
             anchorSize: '100%',         
             frame: true,
             clicksToEdit:true,
             height:310,                     
             enableHdMenu:false,
             cls: 'no-dirty-mark',
             stripeRows: true,
             viewConfig: {
                             forceFit: true,
                             scrollOffset:0
                         }   
        });
        
        
        slaGrid.getSelectionModel().on('selectionchange', function(selModel, row, e){         
            var record = selModel.getSelected();
			if(typeof(record)!='undefined'){
				selectIdForDelete = record.data.RelatedSLARecordId;
			}
            rowClickFlag = 1;
            if(SLAId != null && SLAId != '' && ds.data.length > 0 && btnFlag == true ){
           		document.images['btnRemove'].src = getSDFStylesResPath()+'/SDEFbuttons/btn_delete.png';
           	}
        });
		
        mainPanel = new Ext.Panel({
        	id:'maniPanelId',
        	items:[btnLink, slaGrid]
        });
		
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	if(Ext.isIE){
		relatedSLADivWidth = 280;
	}else if(Ext.isSafari){
	
		relatedSLADivWidth = 280;
	}
	document.getElementById(SLA_AccountNAmeComponent).readOnly = true;
	selectIdForDelete = '';	
	selectedSLAAccodion = 'service level agreement';				
	getRelatedSLA(selectedSLAAccodion);
	setCleareAccountBtn();
	
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
			tooltip: labelReset,
			id: 'resetId',
			handler: ResetBtnHandler
			
		},
		new Ext.Toolbar.Fill(),
		{
			id :'SLA_inactive__c',
			xtype  : 'checkbox',
			width  : 93,
			color :'#004376',
			align: 'top',
			checked: false,
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
	
	new Ext.ToolTip({
		target: 'SLA_inactive__c',	
		anchor: 'left',	
		html: labelTooltipSLAInactive	
	});
	if(isInactiveTrue){	
        Ext.getCmp('SLA_inactive__c').setDisabled(true);       
     }
	document.getElementById('capsule').style.display = 'block';
	
	wid = getWID();
	buttonValidator();
	checkIDSet();
	handleElemEvent();
	updateInactive();
	
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
			height:480, 
			cls:'northPanelCls',
														 
			region: 'center',                   
			contentEl : Ext.isIE ? 'capsule' : SLAFormComponent 
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
			height:Ext.isIE7 ? 200: Ext.isIE ? 210:215,  // *****************************************
			minHeight:Ext.isIE ?120:150,
			animCollapse:false,												  
			region: 'south',
		    listeners : {
			resize:function( obj,adjWidth,adjHeight,rawWidth,rawHeight ) { 
				 if(typeof(adjHeight) =='number')
								document.getElementById('detailsDivSI').style.height=adjHeight+ "px";
					var isDisplay = document.getElementById('SIIframeID').style.display;
				 if(isDisplay !='none'){ 
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
	
	SLAId = getSLAId();
	if(SLAId == null || SLAId == ''){
	        
		Ext.getCmp('prevId').setDisabled(true);
		Ext.getCmp('nextId').setDisabled(true); 
        if(document.getElementById('linkSIAvailTD')!=null)
				document.getElementById('linkSIAvailTD').style.display = 'none';
            if(document.getElementById('noSIAvailTD')!=null)
            	document.getElementById('noSIAvailTD').style.display = 'block';
        }
	else if(SLAId != null){
	       
		Ext.getCmp('prevId').setDisabled(false);
		Ext.getCmp('nextId').setDisabled(false); 
        var isCookiePresent = displaySI(cookieName, iFrameSrc);
			if(!isCookiePresent){
				if(document.getElementById('noSIAvailTD')!=null)
					document.getElementById('noSIAvailTD').style.display = 'none';
				if(document.getElementById('linkSIAvailTD')!=null)
					document.getElementById('linkSIAvailTD').style.display = 'block';
			}
        }
		
renderAccList();
	
}); //END OF EXT.ONREADY


function displayActiveTab(btnObj){
	var btnArray = new Array(2);
	btnArray[0]={btnId:'GeneralInformationBtn', textAreaCompId:'SLA_GeneralInformationTab', textLabel:labelGeneralInformation};
	btnArray[1]={btnId:'ServiceTargetsBtn', textAreaCompId:'SLA_ServiceTargetsTab', textLabel:labelServiceTargets};
	
	var activeBtnId = btnObj.id;
	for(var i = 0; i < btnArray.length; i++){
		if(activeBtnId == btnArray[i].btnId){
			document.getElementById(btnArray[i].btnId).style.fontWeight = 'bold';
			document.getElementById(btnArray[i].textAreaCompId).style.display = 'block';
	  
		}else{
			document.getElementById(btnArray[i].btnId).style.fontWeight = 'normal';
			document.getElementById(btnArray[i].textAreaCompId).style.display = 'none';
		}
	}
	if(activeBtnId == 'ServiceTargetsBtn' && firstTimeRenderFlag == 0 && Ext.isIE8){
		if(document.getElementById('SLTframe') != null)
			document.getElementById('SLTframe').contentWindow.location.reload();
		firstTimeRenderFlag = 1;
	}
}

function refreshparentList() {
	window.parent.needsRefresh = true;
}

function SIComp(iframesrc)
{
 document.getElementById('SIIframeID').style.display = 'none';                          
 document.getElementById('SIIframeID').src= iframesrc;
 document.getElementById('onDemandSITableId').style.display = 'none';
 document.getElementById('SIIframeID').style.display = "";  
}

function writeCookie(){
	if(document.getElementById('configureSIId').checked){
		createSICookie(cookieName,'true');
		var isCookiePresent = displaySI(cookieName, iFrameSrc);
	}
}
function afterResetSI(){
	var modName = getModuleName();  
	var parentWid = getParentWid();
	//alert('--modName--'+modName+'--parentWid--'+parentWid+'---wid--'+wid);
	if(modName != null && modName != '' && typeof(modName) != 'undefined' && parentWid != null && parentWid != '' && typeof(parentWid) != 'undefined' && (errormsg==labelSavedSuccessfully || errormsg == '')){
		//alert('in if of afterResetSI');
		window.parent.registerSave(wid);
		window.parent.parent.refreshSupportingInformation(parentWid,modName);
	}
 }


function resetSupportingInformation(){
	var isDisplay = document.getElementById('SIIframeID').style.display;
	if(isInactive){
		if(isDisplay !='none'){
			window.frames.SIIframeID.disableAll();
		}
	}else{
		if(isDisplay !='none'){
				window.frames.SIIframeID.enableAll();
		}
	}
}
function siControlBack(){
	var cookieval =Ext.util.Cookies.get(cookieName);
	var isDisplay = document.getElementById('SIIframeID').style.display;
	if((cookieval == null || cookieval == 'false' )&& isDisplay =='none'){
		afterResetSI();
	}
}
function renderSIComponent(){
	if(cookieValue == true || cookieValue =='true')
		SIComp(iFrameSrc);
	else     
		removeSI(iFrameSrc);
 
 }
 function confirmClose(w){
	Ext.Msg.show({
						title:window.parent.labelcloseWindow,
						msg: window.parent.labelcloseWindowLabel,
						buttons: Ext.Msg.YESNO,
						fn:  function(btn){
							if (btn == 'yes'){
								w.pendingClose = true;								
								w.close();								
							}
						},
						icon: Ext.MessageBox.WARNING
					});
					
 }
 function setOnCompleteFunction(onComplete){
	onCompleteFunction = onComplete;
}
	function setCleareAccountBtn(){
		if(cleareAccountFieldFlag == true){
			document.getElementById("clearAccountOff").style.display = 'none';  
			document.getElementById("clearAccountOn").style.display = 'inline';
		}else{
			document.getElementById("clearAccountOn").style.display = 'none';
			document.getElementById("clearAccountOff").style.display = 'inline';
		} 
	}	
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
function OpenHelpUrl(link){
	OpenHelppage('MilestoneAction','module','form');  
}

function openAccountSelector(returnValue, displayInAllAccount) {
		
			if(displayInAllAccount){
            	csvAccountListparam = 'AllAccounts';
            	document.getElementById(SLA_AccountNAmeComponent).value = labelAllAccount;
            }else if (returnValue != null ) {
				var array = returnValue.data;
				listData = [];
				var param = '';
				var tempArr1='';
				var tempArr;
				var accValue ='';
				for(i=0;i < array.length;i++){
					tempArr = new Array(2);
					
					var accLen = returnValue.getAt(i).get('display').length;
					accValue = returnValue.getAt(i).get('display');
					if (accLen >= 30)
					{
						accValue = returnValue.getAt(i).get('display').substring(0, 25)+"...";
					}
					tempArr1 =tempArr1 + accValue;
					tempArr[0] = returnValue.getAt(i).get('Name');
					tempArr[1] = returnValue.getAt(i).get('elID');
					param = param + returnValue.getAt(i).get('elID');
					if(i < array.length-1){
						param = param + ',';
						tempArr1 =tempArr1 +'\n';
					}
					listData.push(tempArr);
				} 
				csvAccountListparam = param;
				document.getElementById(SLA_AccountNAmeComponent).value = tempArr1;
               	listStore.removeAll();
               	listStore.loadData(listData);
            }
        }
		
		function initAccountList() {
			
			var reader = new Ext.data.ArrayReader({}, cols);
		    listStore = new Ext.data.Store({
		        reader: reader, data: listData,
    			sortInfo: {
    				field: 'Name',
    				direction: 'ASC' 
				}
		    });
		   
		}