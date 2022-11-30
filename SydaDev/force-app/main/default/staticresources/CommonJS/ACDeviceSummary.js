 var paginationInfoText;
 var pageNumber = 1;
 var fromStdLayout=false;
function addToolBar(){
	Ext.QuickTips.init();
	var toolbar= new Ext.Toolbar({
				id:'toolBarId',
				renderTo: 'ToolBarTD',
				cls:'toolSpCls',
				border:false,
				autoWidth:true,
				autoHeight:true,
				autoEl:true,
				items :[]
			});
									}
function setPaginationText()
{
	if(totalPages == 0 ||  totalPages == pageNumber){
		paginationInfoText = ACDeviceSummaryPage.Labels.PageLabel+ ' '+	totalPages +' '+ACDeviceSummaryPage.Labels.OfLabel+ ' '+totalPages;
		Ext.getCmp('nextBtnId').setDisabled(true);
		Ext.getCmp('lastBtnId').setDisabled(true);
		}
	else{
		paginationInfoText = ACDeviceSummaryPage.Labels.PageLabel+ ' '+pageNumber +' '+ACDeviceSummaryPage.Labels.OfLabel+ ' '+totalPages;
		Ext.getCmp('nextBtnId').setDisabled(false);
		Ext.getCmp('lastBtnId').setDisabled(false);
		}
}
Ext.onReady(function(){
		 addToolBar();
		
		tableStoreHW = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields
		});
		tableStoreSW = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields 
		});
		tableStoreLI = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields 
		});
		tableStoreSEC = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields 
		});
		tableStoreFIN = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields 
		});
		tableStoreAH = new Ext.data.JsonStore({ 
		root: 'Response', 
        fields: storeFields,
		sortInfo: {
             field: 'hcol2',
             direction: 'DESC'
         }		
		});
		
		gridName  = 'Hardware';
		 //waitbox(0); 
		paginationInfoText = ACDeviceSummaryPage.Labels.PageLabel+ ' '+	totalPages +' '+ACDeviceSummaryPage.Labels.OfLabel+ ' '+totalPages;
		
		 tabs = new Ext.TabPanel({
		    
		    region: 'center',
		    cls:'centralTabPanelCls',
		    activeTab: 0,
			style:'padding:10px;', 
			items: [getGrid('Hardware',ACDeviceSummaryPage.Labels.HardwareTab), getSoftWareGrid('Software',ACDeviceSummaryPage.Labels.SoftwareTab),getGrid('License',ACDeviceSummaryPage.Labels.LicenseUnitsTab),getGrid('Security',ACDeviceSummaryPage.Labels.SecurityTab),getGrid('Financial',ACDeviceSummaryPage.Labels.FinancialTab),getGrid('ActionHistory',ACDeviceSummaryPage.Labels.ActionHistory)],
		    listeners: {
					tabchange: function (container,tab){
						Ext.getCmp(tab.id).getStore().removeAll(); 
						if(tab.id =='Security'){
							gridName  = 'Security';
							selectedTabName = tab.id;
							if(typeof(securityJson.Response[0]) == 'undefined' ){
									waitbox(0);
									fetchSecurityDetails(); 
							}else{
								refreshTabValues();
							}
						}else if(tab.id =='Hardware'){  
							if(gridName != 'Hardware'){
								gridName  = 'Hardware';
								selectedTabName = tab.id;
								if(typeof(HWJson.Response[0]) == 'undefined' ){
									fetchHardwareDetails(); 
								}else{
									refreshTabValues();
								}
							}
						}else if(tab.id =='Financial'){
							gridName  = 'Financial';
							selectedTabName = tab.id;
							if(typeof(financeJson.Response[0]) == 'undefined' ){
									waitbox(0);
									fetchFinalcialDetails(); 
							}else{
								refreshTabValues();
							}
						}else if(tab.id =='Software'){ 
							gridName  = 'Software';
							selectedTabName = tab.id;
							if(typeof(softwareData.Response[0]) == 'undefined' ){
									waitbox(0);									
									fetchSoftwareDetails(0); 								
							}else{
								refreshTabValues();
							}
						}else if(tab.id =='License'){
							gridName  = 'License';
							selectedTabName = tab.id;
							if(typeof(licenseJson.Response[0]) == 'undefined' ){
									waitbox(0);
									fetchLicenseDetails();  
							}else{
								refreshTabValues();
							}
						}else if(tab.id =='ActionHistory'){
							gridName  = 'ActionHistory';
							selectedTabName = tab.id;
							if(typeof(actionJson.Response[0]) == 'undefined' ){
									waitbox(0);
									fetchActionHistoryDetails();  
							}else{
								refreshTabValues();
							}
						}
						
					}  
			} 
		});
		var view = new Ext.Viewport({
		  layout:'border',
		  items: [{contentEl:'capsule',region: 'north'},tabs]
		});
		  
		tableStoreHW.loadData(json);  
		if(!fromStdLayout){
			parent.acpopUpWindow.setTitle(pageTitle);
		}
		var ACMenu = getACMenu();
		var extToolbar = Ext.getCmp('toolBarId');
		if(typeof(extToolbar) != 'undefined' && extToolbar != null && extToolbar != 'undefined'){
			extToolbar.insert(1,{iconCls: 'acAction',menu:ACMenu,tooltipType : 'title',tooltip:acActionLabel});
			extToolbar.doLayout(true,true);
			setActionsState();
		}
		setTimeout(makeGridTextSelectable, 2000);
	}); 
		
	   
function getGrid(gridId,gridLabel){
      var  autocolunmName = 'Attribute';
	 if(gridId == 'Software'){
		autocolunmName = 'hcol4';
	}else if(gridId == 'License'){
		autocolunmName = 'hcol2';
	}else if(gridId == 'Financial'){
		autocolunmName = 'hcol1';
	}else if(gridId == 'ActionHistory'){
		autocolunmName = 'hcol4';
	}	
gridObj = new Ext.grid.GridPanel({
		id:gridId,
		stripeRows: true,
		border:false,
        columns: ColumnModel,
        store: gettableStore(gridId),
		autoExpandColumn: autocolunmName,
		autoExpandMin:160,
        enableHdMenu : false,
		autoScroll:false,
        title:gridLabel, 
        buttonAlign : 'center',		
		viewConfig:{
			emptyText:emptyText
        }
    });
return gridObj;
} 
function getSoftWareGrid(gridId,gridLabel){
    var  autocolunmName = 'Attribute';
	if(gridId == 'Software'){
		autocolunmName = 'hcol4';
	}else if(gridId == 'License'){
		autocolunmName = 'hcol2';
	}else if(gridId == 'Financial'){
		autocolunmName = 'hcol1';
	}	
grid = new Ext.grid.GridPanel({
		id:gridId,
		stripeRows: true,
		border:false,
              	columns: ColumnModel,
        store: gettableStore(gridId), 
		autoExpandColumn: autocolunmName,
		autoExpandMin:160,
        title:gridLabel, 
			enableHdMenu : false,
			autoScroll:false,
        bbar : {
				displayInfo: true,
				buttonAlign : "center",	
				height: 35,
				items : getBbarOptions()
				}, 	
		
         		viewConfig:{
					emptyText:emptyText
				 
          		}
    });
return grid ;
}
function refreshGrid(){
                      
	Ext.getCmp(gridName).getColumnModel().setConfig(ColumnModel); 
	Ext.getCmp(gridName).getStore().loadData(json);
	Ext.getCmp(gridName).getView().refresh();
	makeGridTextSelectable();
}

function makeGridTextSelectable(){
if (Ext.isIE){
	var elms=Ext.DomQuery.select("div[unselectable=on]",Ext.getCmp(gridName).dom);
	for (i=0; i<elms.length;i++){
		elms[i].unselectable="off";
	}
	}
}

function gettableStore(gridId)
{
	if(gridId=='Software')	
		return tableStoreSW;
	else if(gridId=='Hardware')
		return tableStoreHW;
	else if(gridId == 'License')
		return tableStoreLI;
	else if(gridId == 'Security')
		return tableStoreSEC;
	else if(gridId == 'Financial')
		return tableStoreFIN;
	else if(gridId == 'ActionHistory')
		return tableStoreAH;
}
function checkEnable(){
		tableStore.loadData(json);  
      }

function refreshTabValues(){
	if(selectedTabName == 'Security'){
		storeFields = securityStoreFlds;
		ColumnModel = securityColunmfields;
		json = securityJson; 
		refreshGrid(); 
	}else if(selectedTabName == 'Financial'){
		storeFields = financeStoreFlds;
		ColumnModel = financeColunmfields;  
		json = financeJson; 
		refreshGrid(); 
	}else if(selectedTabName== 'Software'){		
		storeFields = softwareStorefields;
		ColumnModel =softwareColModel; 
		setPaginationText();
		document.getElementById('pageCountID').innerHTML=paginationInfoText;
		json = softwareData;
		refreshGrid(); 
	}else if(selectedTabName == 'License'){
		storeFields = licenseStoreFlds;
		ColumnModel = licenseColunmfields;  
		json = licenseJson; 
		refreshGrid(); 
	}else if(selectedTabName == 'ActionHistory'){
		storeFields = actionStoreFlds;
		ColumnModel = actionColunmfields;  
		json = actionJson; 
		refreshGrid();  
	}else{
		storeFields = HWStoreFlds;
		ColumnModel =HWColunmfields; 
		json = HWJson; 
		refreshGrid(); 
	}
	
	

	}
	
function getBbarOptions(){
	var bbarOptions = new Array(5);
	bbarOptions[0] =  { scale: 'medium', iconCls: 'x-tbar-page-first', tooltipType : 'title',  id:'firstBtnId',  disabled:'true', handler: firstBtnHandler};
	bbarOptions[1] =  { scale: 'medium', iconCls: 'x-tbar-page-prev', tooltipType : 'title',  id:'prevBtnId', disabled:'true', handler: prevBtnHandler};
	
	bbarOptions[2] =  '<span id="pageCountID" style="padding:2px;">'+ paginationInfoText +'</span>';
	
	bbarOptions[3] =  { scale: 'medium', iconCls: 'x-tbar-page-next', tooltipType : 'title',  id:'nextBtnId', handler: nextBtnHandler};
	bbarOptions[4] =  { scale: 'medium', iconCls: 'x-tbar-page-last', tooltipType : 'title',  id:'lastBtnId',  handler: lastBtnHandler};
	return bbarOptions;
}		  

function firstBtnHandler(){
	waitbox(0);
	 pageNumber = 1;
	Ext.getCmp('prevBtnId').setDisabled(true);
	Ext.getCmp('firstBtnId').setDisabled(true);
	Ext.getCmp('nextBtnId').setDisabled(false);
	Ext.getCmp('lastBtnId').setDisabled(false);
	fetchSoftwareDetails(0); 
}
function prevBtnHandler(){
	waitbox(0);
	pageNumber = pageNumber -1;
	if(pageNumber == 1){
		Ext.getCmp('prevBtnId').setDisabled(true);
		Ext.getCmp('firstBtnId').setDisabled(true);
	}else{
		Ext.getCmp('prevBtnId').setDisabled(false);
		Ext.getCmp('firstBtnId').setDisabled(false);
	}
	Ext.getCmp('nextBtnId').setDisabled(false);
	Ext.getCmp('lastBtnId').setDisabled(false);
	
	if(pageNumber > 1){
		fetchSoftwareDetails((pageNumber -1) * record_count);
	}else{ 
		fetchSoftwareDetails(pageNumber-1);	
	}
}
function nextBtnHandler(){
	waitbox(0);
	fetchSoftwareDetails(pageNumber * record_count); 
	pageNumber = pageNumber+1;
	if(pageNumber == totalPages){
		Ext.getCmp('nextBtnId').setDisabled(true);
		Ext.getCmp('lastBtnId').setDisabled(true);
	}else{
		Ext.getCmp('nextBtnId').setDisabled(false);
		Ext.getCmp('lastBtnId').setDisabled(false);
	}
	Ext.getCmp('prevBtnId').setDisabled(false);
	Ext.getCmp('firstBtnId').setDisabled(false);

}
function lastBtnHandler(){
	waitbox(0);
	pageNumber = totalPages;
	Ext.getCmp('nextBtnId').setDisabled(true);
	Ext.getCmp('lastBtnId').setDisabled(true);
	Ext.getCmp('prevBtnId').setDisabled(false);
	Ext.getCmp('firstBtnId').setDisabled(false);
	fetchSoftwareDetails((totalPages - 1)*record_count);
}
function colRenderer(data, metadata, record, rowIndex, columnIndex, store){
		if(selectedTabName == 'ActionHistory'){	
			return colRender(data, metadata, record, rowIndex, columnIndex, store);
		}else{ 
			var tip=''+data;
		    metadata.attr = 'title="'+data+'"';  
			return data;  
		}	
}
