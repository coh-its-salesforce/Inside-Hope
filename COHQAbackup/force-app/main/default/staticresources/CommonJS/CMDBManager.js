Ext.ns('CMDBManagerNamespace'); 
CMDBManagerNamespace.instance = null;
var	ServiceInstanceGridColumns =[];
var	ServiceInstanceArrayStore =[];
var colInstanceGrid = [];
var searchstring = '';
var sdeHome = window.parent.parent;
var isCustomPage = true;
var actionContext = '';
var iPageSize = 27;
if(isStdForm){
 
_ServerValues.InstanceGridTitle=_ServerValues.InstanceGridTitle+'<a href="#" onclick="OpenHelppage(\'CMDBManager\',\'page\',\'InstanceBrowser\');"><img style="float:right;margin-top:-1px" title="Help" height="17" width="17" id="helpId" src="'+imageHelp+'/SDEFbuttons/b_help.png"></a>';
_ServerValues.InstanceEditorTitle=_ServerValues.InstanceEditorTitle+'<a href="#" onclick="OpenHelppage(\'CMDBManager\',\'page\',\'ConfigurationItem\');"><img style="float:right;margin-top:-2px" title="Help" height="17" width="17" id="helpIdInstance" src="'+imageHelp+'/SDEFbuttons/b_help.png"></a>';
iPageSize = 35;
}
function unloadPage()
{	
	if(sdeHome != null)
		sdeHome.CMDBManagerWin = null;
}
window.onunload = unloadPage;

Ext.onReady(function() {
	var selectedRowIndex = 0;
	var selectedRowIndexInstanceID = 0;
	var splitedheadercols = headercols.split(',');
	var splitetdataindex = headerdataIndex.split(',');
	
	for(var i=0;i<splitedheadercols.length;i++){
		ServiceInstanceGridColumns[i] = { header: splitedheadercols[i], width: 150, dataIndex: splitetdataindex[i], sortable: true };
		if(splitetdataindex[i]=='InstanceID__c' || splitetdataindex[i]=='ClassName__c')
			ServiceInstanceArrayStore[i] = { header: splitedheadercols[i], width: 150, dataIndex: splitetdataindex[i], hidden: true};
		else
			ServiceInstanceArrayStore[i] = { header: splitedheadercols[i], width: 150, dataIndex: splitetdataindex[i], sortable: true };
	}
	
	colInstanceGrid = [
							{ header: _ServerValues.Name, width: 150, dataIndex: 'Name__c', sortable: true },
							{ id: 'desc', header: _ServerValues.Description, width: 200, dataIndex: 'Description__c', sortable: true },
							{ header: _ServerValues.InstanceID, width: 200, dataIndex: 'InstanceID__c', sortable: true },
							{ header: _ServerValues.ClassName, width: 200, dataIndex: 'ClassName__c', sortable: true },
							{ header: _ServerValues.BE_Stage, width: 200, dataIndex: 'Stage__c', sortable: true },
							{ header: _ServerValues.AssemblyId, width: 150, dataIndex: 'AssemblyId__c', sortable: true},
							{ header: _ServerValues.Id, width: 0, dataIndex: 'Id', sortable: true ,hidden:true}
						];							
	//Performance Metrics
	windowloaddate = new Date();
    networklatencystart = windowloaddate.getTime();
    var networklatency = networklatencystart - etime;
	data += _ServerValues.NetwokLatencyLabel;
	data +=networklatency; 
	data += '<br>';
    
    Ext.QuickTips.init();
    ExtOnReady();
});
function enabledisablenewbutton(){
	if(isabstract || !iscreatable || !isupdateable){
		if(Ext.getCmp('newInstanceBtn') != null && Ext.getCmp('newInstanceBtn') != 'undefined' ){
			Ext.getCmp('newInstanceBtn').disable();
			Ext.getCmp('newInstanceBtn').setIconClass('bmcNewDisable');
		}	
	}else if(iscreatable && isupdateable){
		if(Ext.getCmp('newInstanceBtn') != null && Ext.getCmp('newInstanceBtn') != 'undefined' ){
			Ext.getCmp('newInstanceBtn').enable();
			Ext.getCmp('newInstanceBtn').setIconClass('bmcNew');
		}
	}
	if(isabstract)
		Ext.getCmp('ciCMDBReportBtn').disable();
	else
		Ext.getCmp('ciCMDBReportBtn').enable();
}
function ExtOnReady() {
    CMDBManagerNamespace.instance = new CMDBManager();
    CMDBManagerNamespace.instance.getContent().render("contentDiv");
	if(isACEnabled){
		var ACMenu = getACMenu();
		var extToolbar = Ext.getCmp('toolBarId');
		if(typeof(extToolbar) != 'undefined' && extToolbar != null && extToolbar != 'undefined'){
			extToolbar.insert(6,{id:'actionsMenuId',disabled:true,iconCls:'acActionDisabled',menu:ACMenu,tooltipType : 'title',tooltip:acActionLabel});
			extToolbar.doLayout(true,true);
		}
	}
    //Page-load time
    data += _ServerValues.PageLoadLabel;
    var pageloadstartdate = new Date() ;
    var time1 = pageloadstartdate.getTime();
    var time2 = windowloaddate.getTime();
    var pagerendertime =(time1 - renderingstartitme);
    data += pagerendertime;
	setTimeout("CheckAndOpenInstance();",300);
}
function CheckAndOpenInstance() {
	 if(getUrlParameter('cmdbRecordId')!=null && getUrlParameter('cmdbRecordId')!='')
	    var recid = getUrlParameter('cmdbRecordId');
	 else
	   var recid = window.parent.parent.CMDB_RecordID;
	 if(typeof(recid)!='undefined' && recid!=null && recid!='') {
		var url = "/apex/cmdbgenericpage?BE_RecordID="+recid;
		CMDBManagerNamespace.instance.ShowFormPanel(url, _ServerValues.InstanceEditorTitle);
		window.parent.parent.CMDB_RecordID = null;
	}
}
function getUrlParameter( param ){
	param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
	var r1 = "[\\?&]"+param+"=([^&#]*)";
	var r2 = new RegExp( r1 );
	var r3 = r2.exec( window.location.href );
	if( r3 == null ){return ""}
	else {return r3[1]};
}
function SearchCI(){
	CMDBManagerNamespace.instance.searchBaseElement();
}
CMDBManager = function(){}
CMDBManager.prototype = {
	InstancesGrid : null,
	TypeListView : null,
	TypeTileView : null, 
	TypeTreeView : null,
	viewPanels : null,
	BrowserContainerPanel : null,
	MainTabPanel : null,
	SelectedRecordID  : '',
	BrowserContainerPanelHeight:900,	
	ExplorerItemClickHandler : function(recordID, forceReload) {
		if(this.SelectedRecordID != recordID || forceReload==true)
		{
			if(this.InstancesGrid!=null)
			{
				this.Paging_PageNumber=1;
				this.getInstanceListStore(recordID);
			}
				
			try{
				
				this.SelectedRecordID = recordID; // Sync up the record id to avoid recursive calls.
                this.syncTypeViews(recordID);
			}
			catch(e){
			}
		}
		this.SelectedRecordID = recordID;
		
		if(this.TypeTreeView != null && this.TypeTreeView != 'undefined'
		&& this.TypeTreeView.selModel != null && this.TypeTreeView.selModel != 'undefined'
		&& this.TypeTreeView.selModel.selNode != null && this.TypeTreeView.selModel.selNode != 'undefined'
		&& this.TypeTreeView.selModel.selNode.attributes != null && this.TypeTreeView.selModel.selNode.attributes != 'undefined')
		{
			isabstract = this.TypeTreeView.selModel.selNode.attributes.abstract;
		}
	},
	
	syncTypeViews : function(recordID) {

			try{
		        this.TypeListView.getSelectionModel().selectRow(this.TypeListView.getStore().findExact('Name',recordID));
			}
			catch(e){
			}
			
			try{
		        this.TypeTileView.select(this.TypeListView.getStore().findExact('Name',recordID));
			}
			catch(e){
			}
			
			try{
		        this.TypeTreeView.selModel.select(this.TypeTreeView.getNodeById(recordID));
			}
			catch(e){
			}
	},
	
	resizeTypeViews : function() {

        try{
            var i = this.viewPanels.getWidth();
            this.viewPanels.setWidth(i+1);
            this.viewPanels.setWidth(i-1);
            this.TypeListView.setWidth(i);
            this.TypeListView.setHeight(this.explorerHeight);
        }catch(e){}

	},

	showHelp : function() {
                var tab = this.MainTabPanel.getActiveTab();
                var pagename = 'CMDBManager';
                var view = 'InstanceBrowser';
                if(typeof(tab.url)!='undefined' && typeof(tab.url)!=null)
                {
                    var url = tab.url.toLowerCase();
                    
                    if(url.indexOf("generic")>=0)
                    {
                        view='ConfigurationItem';
                    }
                    else if(url.indexOf("relationship")>=0)
                    {
                        view='CIRelationship';
                    }
					else if(url.indexOf("cmdbreport") >= 0){
						OpenHelppage('CIReport','module','form');
						return;
					}
                } 
                OpenHelppage(pagename,'page',view);
	},
	
	showMetrics : function() {
                var tab = this.MainTabPanel.getActiveTab();
                if(typeof(tab.url)!='undefined' && typeof(tab.url)!=null)
                {
                    var url = tab.url.toLowerCase();
                    
                    if(url.indexOf("generic")>=0)
                    {
                        var data1 = window.frames[0].senddata();
                        return data1;
                    }
                    else if(url.indexOf("relationship")>=0)
                    {
                        var data2 = window.frames[1].senddata();
                        return data2;
                    }
                } 
				return data;              
				
	},
	
	getContent : function() {
		var mainPanelHeight = parseInt(_ServerValues.CMDBManagerHeight);
		
		if(typeof(mainPanelHeight)=='undefined' 
					|| mainPanelHeight==null 
					|| isNaN(mainPanelHeight))
		{
			mainPanelHeight=850;
		} 
		
	    var browserContainerPanelHeight = mainPanelHeight;// - 24; // 24 is for the namespace dropdown
	    var instanceBrowserPanelHeight = browserContainerPanelHeight -6;//- 24;
	    var tabPanelHeight = instanceBrowserPanelHeight - 20;
	    var explorerHeight = tabPanelHeight - 27;
	    this.explorerHeight = explorerHeight;
	    var instanceDisplayHeight = instanceBrowserPanelHeight;
	
		this.BrowserContainerPanelHeight=browserContainerPanelHeight;
	    
	    // create some portlet tools using built in Ext tool ids
        var btnTools = [{
            id:'help',
            handler: function() {
	                this.showHelp();
	            }.createDelegate(this)

        }];
        
	    var mainPanel = new CMDB.Controls.FormPanel({
	        title: _ServerValues.mainPanelTitle,
			header:false,
	        tools: btnTools,
	        height: mainPanelHeight,
			autoWidth:true,
	        border:false
	    });
	
	
		var browserContainerPanel = new CMDB.Controls.Panel({
	        height: browserContainerPanelHeight,
	        autoWidth:true,
	        border:false
	    }); 
		this.BrowserContainerPanel = browserContainerPanel;	
		
	    var NameSpaceDropdown = new CMDB.Controls.DropDownField({
	        width: 200,
	        fieldLabel: _ServerValues.NameSpaceDropdownLabel,
	        store: this.getNameSpaceListStore(),
	        typeAhead: true,
	        mode: 'local',
	        valueField: 'Name',
	        displayField: 'DisplayName',
	        triggerAction: 'all',
	        editable: false,
	        forceSelection: true
	    });
	    NameSpaceDropdown.value = _ServerValues.DefaultInstanceDropDownValue;
	
	    var InstanceBrowserColumn1 = new CMDB.Controls.Panel({
	        layout: 'fit',
	        autoWidth:true,
	        border: false
	    });
	
	    var InstanceBrowserColumn2 = new CMDB.Controls.Panel({
	        height: instanceDisplayHeight,
	        autoWidth:true,
	        anchor: '100%',
	        border: false
	    });
	
	    var InstanceBrowserPanel = new CMDB.Controls.Panel({
	        anchor: '100%',
	        border: false,
	        height: instanceBrowserPanelHeight,
	        autoWidth:true,
	        layout: 'border',
			monitorResize:true,
	        listeners: {
	                        afterlayout: function(){ 
	                                            this.resizeTypeViews();
	                                        }.createDelegate(this)
            },
	        
	        items: [
	            { collapsible: false,  layout:'fit', animFloat: false, split: true, region: 'west', width: 260, items: [InstanceBrowserColumn1] },
	            { region: 'center',  layout:'fit', items: [InstanceBrowserColumn2] }
	            ]
	    });
	
	
	    var ElementList = new CMDB.Controls.DropDownField({
	        store: this.getElementListStore(),
	        typeAhead: true,
	        mode: 'local',
	        valueField: 'Name',
	        displayField: 'DisplayName',
	        editable: false,
	        forceSelection: true
	    });
	    ElementList.value = _ServerValues.DefaultElementsDropDownValue;
	
	    var ClassTileView = this.getClassTileView('tile', explorerHeight);
	    var ClassListView = this.getClassListView(explorerHeight);
	    var ClassTreeView = this.getClassTreeView(explorerHeight);
	
	
	    var viewPanels = new CMDB.Controls.TabPanel({
	        border: false,
	        activeItem: 2,
	        autoWidth:true,
            cls: 'x-tab-hide',
            resizeTabs:true,
	        height: tabPanelHeight,
	        bodyBorder: false
	    });
	
		this.viewPanels = viewPanels;
		
	
	    viewPanels.add(
	                        { title: '1', items: [ClassTileView] },
	                        { title: '2', items: [ClassListView] },
	                        { title: '3', items: [ClassTreeView] }
	                    );
	
	
	    InstanceBrowserColumn1.add(ElementList);
	    InstanceBrowserColumn1.add(new CMDBTypeIcons(this.viewTypeChanged.createDelegate(this)));
	    InstanceBrowserColumn1.add(viewPanels);
	
	    browserContainerPanel.add(InstanceBrowserPanel);

	    var mainTabPanel = new CMDB.Controls.TabPanel({
	        
	        height: mainPanelHeight,
	        border:false,
	        
	        border: false,
			autoWidth:true,
	        activeItem: 0,
            cls: 'x-tab-hide',
	        
	        bodyBorder: false
	    });
	    this.MainTabPanel=mainTabPanel
	    
	    mainTabPanel.add(browserContainerPanel);
		
	    mainPanel.add(mainTabPanel);
		
	
	    InstanceBrowserColumn2.add(this.getGridDisplay(instanceDisplayHeight));
	    return mainPanel;
	},
	
	viewTypeChanged : function(name, index)
	{
		this.viewPanels.setActiveTab(index);
		this.resizeTypeViews();
		this.syncTypeViews(this.SelectedRecordID);
	},
	
	getNameSpaceListStore : function() {
	    var strXML = _ServerValues.NamespaceListXML;
	    xmlObject = this.getXMLObjectFromString(strXML);
	
	    var dataStore = new Ext.data.XmlStore({
	        autoDestroy: false,
	        proxy: new Ext.data.MemoryProxy(xmlObject),
	        record: 'namespace',
	        idPath: 'Name',
	        fields: ['Name', 'DisplayName']
	    });
	    dataStore.load();
	
	    return dataStore;
	},
	
	getElementListStore : function() {
	    var strXML = _ServerValues.ElementsListXML;
	    xmlObject = this.getXMLObjectFromString(strXML);
	
	    var dataStore = new Ext.data.XmlStore({
	        autoDestroy: false,
	        proxy: new Ext.data.MemoryProxy(xmlObject),
	        record: 'element',
	        idPath: 'Name',
	        fields: ['Name', 'DisplayName']
	    });
	
	    dataStore.load();
	
	    return dataStore;
	},
	
	getXMLObjectFromString : function(strXML) {
	    var doc = null;
	
	    //load XML string code for IE
	    if (window.ActiveXObject) {
	        doc = new ActiveXObject("Microsoft.XMLDOM");
	        doc.async = "false";
	        doc.loadXML(strXML);
	    }
	    //load XML string code for Mozilla, Firefox, Opera, etc.
	    else {
	        var parser = new DOMParser();
	        doc = parser.parseFromString(strXML, "text/xml");
	    }
	
	    return doc.documentElement;
	},
	
	getClassViewStore : function() {
	    var json = _ServerValues.ClassViewListJSON;
	    //json = [{ Name: "myname", DisplayName: "DispName", Image: "img" }, { Name: "myname", DisplayName: "DispName", Image: "img"}];
	    json = eval(json);
	
	    var dataStore = new Ext.data.JsonStore({
	        proxy: new Ext.data.MemoryProxy(json),
	        idProperty: 'Name',
			fields: ['Name', 'DisplayName', 'Image', 'Abstract'],
			sortInfo: { field: "DisplayName", direction: "ASC" }
	    });
	
		 
	    dataStore.load();
	
	    return dataStore;
	},
	
	getClassListView : function(newHeight) {
	
		var cvstore = this.getClassViewStore();
		
	    var tpl_img = new Ext.XTemplate(
	                    '<tpl for=".">',
	                    '<img class="thumb-img" id="{Name}Id" src="'+CIFORCE_RES_PATH+'/images/ci/{Image}_32.png" width="20" height="20" >',
	                    '</tpl>'
	                ).compile();
	
	
	    var listView = new CMDB.Controls.GridPanel({
	        hideHeaders: true,
	        store: cvstore,
	        autoScroll: true,
			defaults: {sortable: true},
	        height: newHeight,
	        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	        columns: [
	            new Ext.grid.TemplateColumn({ tpl: tpl_img, width: 30, dataIndex: 'Image', tpl: tpl_img }),
	            { id: 'DisplayName', dataIndex: 'DisplayName' , sortable:true }
	            ],
	        autoExpandColumn: 'DisplayName',
	        viewConfig: {
                sortAscText : strAscending,
                sortDescText : strDescending,
                columnsText : strSelectColumn,  
	            forceFit: false
	        },
			listeners: {
			        viewready : function(grid) {
			                this.syncTypeViews(this.SelectedRecordID);
							var rowCount=cvstore.data.length;
							 for (i=0; i<rowCount; i++) { 
							  var gridCell=grid.getView().getCell(i,1);
							   var cellRec = cvstore.getAt(i);
							    gridCell.firstChild.id =cellRec.get('Image')+'Id';
							  
							 }
			            }.createDelegate(this)
			    },
	        stripeRows: true,
	        border: false
	    });
	
	    listView.on('rowclick', 
	    	function(grd, rowIndex, e) {
			        record = grd.getStore().getAt(rowIndex);
			        this.ExplorerItemClickHandler(record.data.Name);
		    	}.createDelegate(this)	
	    	);
		
		listView.getSelectionModel().on('selectionchange', function(selModel, row, e){
				record = selModel.getSelected();
				if(typeof(record)!='undefined')
				{
					this.ExplorerItemClickHandler(record.data.Name);
				}
	    	}.createDelegate(this));
	
		this.TypeListView = listView;
	    return listView;
	
	},
		
	getClassTileView : function(displayStyle, newHeight) {
	
	    var item = new CMDBClassChooser(
	    				displayStyle,
    					this.getClassViewStore(), 
    					this.ExplorerItemClickHandler.createDelegate(this));
    					
	    this.TypeTileView = item;
	
	    return new CMDB.Controls.Panel({ autoScroll: true, border: false, height: newHeight, items: item })
	},
	
	getClassTreeView : function(newHeight) {
	
	    var strJSON = _ServerValues.TreeViewJSON;
	
	    var root = new Ext.tree.AsyncTreeNode({
	        expanded: true,
	        children: eval(strJSON)
	    });
	
	    var t = new Ext.tree.TreePanel({
	        root: root,
	        useArrows: true,
	        autoScroll: true,
	        animate: true,
	        containerScroll: true,
	        border: false,
	        rootVisible: false,
	        height: newHeight,
	        listeners: {
	            
	            afterrender: function(treeComp) {
	                this.syncTypeViews(this.SelectedRecordID);
					
					if(treeComp != null && treeComp.getRootNode() != null && treeComp.getRootNode().firstChild != null 
						&& treeComp.getRootNode().firstChild.id != null)
					{
						treeComp.getRootNode().firstChild.select();
						this.ExplorerItemClickHandler(treeComp.getRootNode().firstChild.id);
					}
	            }.createDelegate(this),
	            
	            click: function(n) {
		                this.ExplorerItemClickHandler(n.attributes.id);
	            }.createDelegate(this)
	        }
	    });
	
	    root.expand();
	    
	    this.TypeTreeView = t;
	    
	    return t;
	},
	
	GridRowClick : function(grd, rowIndex, e) {
	    record = grd.getStore().getAt(rowIndex);
	},
	
	
	getGridDisplay : function(containerPanelHeight) {
	
	    var toolBarHeight = 40;
	    var gridPanelHeight = containerPanelHeight - toolBarHeight-24;
	
	    var xmlGridPanel = new CMDB.Controls.GridPanel({
	        id: 'XMLGridPanel',
	        store: this.getInstanceListStore(),
	        columns: this.InstanceGridColumns,
	        autoExpandColumn: 'desc',
			enableHdMenu: false,
	        viewConfig: {
                sortAscText : strAscending,
                sortDescText : strDescending,
                columnsText : strSelectColumn,  
	            forceFit: true,
				emptyText: _ServerValues.NoRecordFoundMsg
	        },
	        stripeRows: true,
	        border: false,
	        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	        height: gridPanelHeight
	    });
	    xmlGridPanel.on('rowdblclick', function(grd, row, e){
	    		this.LoadCI();
	    	}.createDelegate(this));
		xmlGridPanel.on('rowclick', function(grd, row, e){
	    		this.OnRowSelect();
	    	}.createDelegate(this));
	    this.InstancesGrid = xmlGridPanel;

		xmlGridPanel.getSelectionModel().on('selectionchange', function(grd, row, e){
	    		this.ChangeBtnStatus();
	    	}.createDelegate(this));
	    
	    xmlGridPanel.on('render', function(grd, row, e){
	    		this.ChangeBtnStatus();
	    	}.createDelegate(this));
	    
	    	
	    var XMLGridActiveFilterPanel = new CMDB.Controls.Panel({
	        border: false,
	        id: 'XMLGridActiveFilterPanel',
	        html: 'This section is for advanced filters'
	    });
	
	    var XMLGridButtonsPanel = new CMDB.Controls.Panel({
	        id: 'XMLGridButtonsPanel',
	        border: false,
	        autoWidth:true,
	        items: this.generateToolbarButtons(toolBarHeight)
	    });
	
	
	    var XMLGridBrowserPanel = new CMDB.Controls.Panel({
	        id: 'XMLGridBrowserPanel',
	        height: containerPanelHeight,
	        layout: 'border',
	        border: false,
	        title: _ServerValues.InstanceGridTitle,
	        autoWidth:true,
	        items: [
	                { region: 'center',  layout:'fit', items: xmlGridPanel, border: false },
	                { region: 'north',  layout:'fit', height: 32, items: XMLGridButtonsPanel, border: false }
	            ]
	    });
	
	    return XMLGridBrowserPanel;
	},
	
	getGridFilterPanel: function() {
	    var pnl = new CMDB.Controls.Panel({
	        id: 'XMLGridFilterPanel',
	        border: false,
	        html: ''
	    });
	    return pnl;
	},
	
	generateToolbarButtons : function(toolBarHeight) {
	
	    var tb = new Ext.Toolbar({
			id:'toolBarId',
	        border: false,
	        height: toolBarHeight,
	        autoWidth:true,
	        items: [
						{
			                scale: 'medium',
			                iconCls: 'bmcNew',
			                tooltipType : 'title',
			                tooltip: _ServerValues.New, 
			                id:'newInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcNewOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcNew');          
			                    }
			                },
	                        handler:this.NewCI.createDelegate(this)
			            },
						{
			                scale: 'medium',
			                iconCls: 'bmcEditCI',
			                tooltipType : 'title',
			                tooltip: _ServerValues.Edit,
			                id:'editInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcEditCIOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcEditCI');          
			                    },
			                    disable: function(){
			                        this.setIconClass('bmcEditCIDisable');    
			                    },
			                    enable: function(){
			                        this.setIconClass('bmcEditCI');          
			                    }
			                },
	                        handler:this.LoadCI.createDelegate(this)
			            },
						{
			                scale: 'medium',
			                iconCls: 'bmcDelete',
			                tooltipType : 'title',
			                tooltip: _ServerValues.Delete, 
			                id:'deleteInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcDeleteOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcDelete');          
			                    },
			                    disable: function(){
			                        this.setIconClass('bmcDeleteDisable ');    
			                    },
			                    enable: function(){
			                        this.setIconClass('bmcDelete');          
			                    }
			                },
	                        handler:this.DeleteCI.createDelegate(this)
	                    },
	                    '-',
						{
			                scale: 'medium',
			                iconCls: 'bmcCIExplorer',
			                tooltipType : 'title',
			                tooltip: _ServerValues.LaunchCIExplorerLabel, 
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
	                        handler:this.ExploreCI.createDelegate(this)
			            },
						{
                            scale: 'medium',
                            iconCls: 'bmcLaunchFPConsole',
                            tooltipType : 'title',
                            tooltip: _ServerValues.ACLaunchFPConsole, 
                            id:'ACLaunchFPBtn',
							hidden : !isACEnabled,
                            handler: this.ACLaunchFPConsole.createDelegate(this)
                        },
						{
                            scale: 'medium',
                            iconCls: 'bmcLaunchDKConsole',
                            tooltipType : 'title',
                            tooltip: _ServerValues.LaunchDellKace, 
                            id:'DKLaunchBtn',
							hidden : !isDKEnable,
                            handler: this.LaunchDKConsole.createDelegate(this),
                            listeners: {
                                disable: function(){
                                    this.setIconClass('bmcLaunchDKConsoleDisable');    
                                },
                                enable: function(){
                                    this.setIconClass('bmcLaunchDKConsole');          
                                }
                            }
                        },
						'-',
						{
                            scale: 'medium',
                            iconCls: 'bmcAPM',
                            tooltipType : 'title',
                            tooltip: _ServerValues.APM, 
                            id:'ciCMDBapmBtn',
                            listeners: {
                        		mouseover: function(){
                                    this.setIconClass('bmcAPMOn');    
                                },
                                mouseout: function(){
                                    this.setIconClass('bmcAPM');          
                                }
                            },
                            handler: this.OpenBMCAPM.createDelegate(this)
                        },
			            {
                            scale: 'medium',
                            iconCls: 'bmcCMDBReport',
                            tooltipType : 'title',
                            tooltip: _ServerValues.Report, 
                            id:'ciCMDBReportBtn',
                            listeners: {
                                disable: function(){
                                    this.setIconClass('bmcCMDBReportDisable');    
                                },
                                enable: function(){
                                    this.setIconClass('bmcCMDBReport');          
                                }
                            },
                            handler: this.CMDBReport.createDelegate(this)
                        },
						{
							id:'viewMenu',
							scale: 'medium',
							iconCls: 'bmcView1',
							tooltipType : 'title',
							tooltip: _ServerValues.ViewsTitle,
							menu: new Ext.menu.Menu({
									autoWidth : true,
									showSeparator: false,
									plain: true,
									items: [{
										xtype: (Ext.isIE7 || Ext.isIE8)? 'menucheckitem':'checkbox',
										id :'ShowDerivedCIsButton',
										text : _ServerValues.ShowDerivedCIs,
										boxLabel:_ServerValues.ShowDerivedCIs,
										checked : this.ShowDerivedCIs,
										autoWidth: true,
										handler:this.ShowDerivedCIsClicked.createDelegate(this),
										listeners: {
											'checkchange': function(ctrl, checked){
												if(Ext.isIE7 || Ext.isIE8){
													this.ShowDerivedCIs = checked;
													this.Paging_PageNumber=1;
													this.getInstanceListStore();
												}
											}.createDelegate(this)
										}
									}]
								})
						}
						,'->',
						new Ext.form.TextField({
							id:'searchTxt',
							name: 'searchTxt',
							fieldLabel: _ServerValues.srchTxtFldLabel,
							width: 100,
							allowBlank: true,
							emptyText: _ServerValues.srchTxtFldLabel,
							style:{align: 'left'},
							listeners: {
								specialkey: function ( field, e ) {
									searchstring = document.getElementById("searchTxt").value;	
									if ( e.getKey() == e.RETURN || e.getKey() == e.ENTER ) {
										SearchCI();
									}
								}
							}
						}),
						{
			                scale: 'medium',
			                iconCls: 'bmcSearch',
			                tooltipType : 'title',
			                tooltip: _ServerValues.srchTxtFldLabel, 
			                id:'searchBtn',
							style:{align: 'left'},
							handler: this.searchBaseElement.createDelegate(this)
			            },
						{
							scale: 'medium', 
							iconCls: 'bmcRefresh', 
							tooltip: _ServerValues.refreshBtnToolTip, 
							tooltipType: 'title',
							id:'refreshbtn', 
							style:{align: 'left'}, 
							handler: this.pageRefresh.createDelegate(this)
						},
						{ xtype: 'tbspacer', width: 5 },
						tbarOptions
	                ]
	    });
	
	    return tb;
	},
	
	ShowInstancePanel : function(cname, instID, assemblyId, reqContextId)
	{
		var url = "/apex/cmdbgenericpage?className="+cname+"&InstanceID="+instID+"&wid="+getWID()+"&assemblyId="+assemblyId+"&reqContextId="+reqContextId;
		this.ShowFormPanel(url, _ServerValues.InstanceEditorTitle);
	},
	
	ShowFormPanel : function(url, panelTitle)
	{
	    var instanceContainerPanelHeight = this.BrowserContainerPanelHeight;
	    var instanceFramePanelHeight = instanceContainerPanelHeight-40;
	    var backToolbarHeight = 30;

		var instanceContainerPanel = new CMDB.Controls.Panel({
	        height: instanceContainerPanelHeight,
	        autoWidth:true,
	        collapsed:false,
	        border:false
	    }); 

		var tab = this.MainTabPanel.add(instanceContainerPanel);
		tab.url = url;
		
		var InstanceCloseButton = new Ext.Toolbar({
	        border: false,
	        autoWidth:true,
	        height: backToolbarHeight,
	        items: [
						{
			                scale: 'medium',
			                iconCls: 'bmcBackCMDB',
			                tooltipType : 'title',
			                tooltip: _ServerValues.Back, 
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcBackCMDBOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcBackCMDB');          
			                    }
			                },
	                        handler: this.CloseFormPanel.createDelegate(this)
			            } 
	                ]
	    });
	
		var instanceFramePanel = new CMDB.Controls.IFramePanel({
	        height:instanceFramePanelHeight,
	        autoWidth:true,
	        anchor: '100',
			title: panelTitle,//_ServerValues.InstanceEditorTitle,
			src:"about:blank"
		});
		
		instanceContainerPanel.add(InstanceCloseButton);
		instanceContainerPanel.add(instanceFramePanel);
	
		instanceFramePanel.setSource(url);
		tab.show()
	},
	
	LoadCI : function()
	{
		var elements=this.InstancesGrid.getSelectionModel().getSelections();
		if(elements.length==1)
		{
			this.ShowInstancePanel(elements[0].data.ClassName__c,elements[0].data.InstanceID__c,elements[0].data.AssemblyId__c,elements[0].data.Id);
		}
	},
	OnRowSelect: function(grd, rowIndex, e){
		var record = this.InstancesGrid.getSelectionModel().getSelected();
		selectedRowIndex = record;
		selectedRowIndexInstanceID = record.data.InstanceID__c;
		if(isACEnabled){
			assemblyId = record.get('AssemblyId__c');
			reqContextId = record.get('Id');
			/*var acMenu = Ext.getCmp('actionMenu');
			if(acMenu != null && typeof(acMenu) != 'undefined'){
				if(assemblyId != null && assemblyId.indexOf('AC:CS:-') != -1){
					acMenu.setDisabled(false);
				}else{
					acMenu.setDisabled(true);
				}
			}*/
		}
	},
	ChangeBtnStatus : function()
	{
		var elements=this.InstancesGrid.getSelectionModel().getSelections();
		var strAssemblyId = '';
		if(this.InstancesGrid.getSelectionModel().getSelected()){
			var record = this.InstancesGrid.getSelectionModel().getSelected();
			selectedRowIndex = record;
			selectedRowIndexInstanceID = record.data.InstanceID__c;
			strAssemblyId = record.get('AssemblyId__c');
		}
		if(elements.length==1)
		{
			Ext.getCmp('ciExplorerBtn').enable();
			if(isupdateable)
				Ext.getCmp('editInstanceBtn').enable();
			else
				Ext.getCmp('ciExplorerBtn').disable();
		}
		else
		{
			Ext.getCmp('ciExplorerBtn').disable();
			Ext.getCmp('editInstanceBtn').disable();
		}
		if(elements.length>0 && isdeletable)
		{
			Ext.getCmp('deleteInstanceBtn').enable();
		}
		else{
			Ext.getCmp('deleteInstanceBtn').disable();
		}
		var acMenu = Ext.getCmp('actionsMenuId');
		if(acMenu != null && typeof(acMenu) != 'undefined'){
			if(elements.length==1){
				acMenu.setDisabled(false);
				acMenu.setIconClass('acAction');
			}else{
				acMenu.setDisabled(true);
				acMenu.setIconClass('acActionDisabled');
			}
		}
		
		if(isDKEnable){
			if(strAssemblyId != '' &&  strAssemblyId.toUpperCase().indexOf('DELLKACE') == 0)
				Ext.getCmp('DKLaunchBtn').enable();
			else
				Ext.getCmp('DKLaunchBtn').disable();
		}
			
	},
	
	ExploreCI : function()
	{
		var elements=this.InstancesGrid.getSelectionModel().getSelections();
		if(elements.length==1)
		{
			ShowCIExplorer(elements[0].data.InstanceID__c);
		}
	},
	CMDBReport: function()
	{
	    var url = "/apex/CMDBReport?classname=" +  this.SelectedRecordID ;
        CMDBManagerNamespace.instance.ShowFormPanel(url, "");
	},
	ACLaunchFPConsole: function()
	{
	    if(isFPUserValidated){
			waitbox(0);
			directConnectDevice('Full');
		}else{
			openPopupWithTitle('ACFPUserCredentialPage',oncompleteFPvalidateJS,_ServerValues.ACFPLaunchWindowHeader,Ext.isIE?240:228,495);
			popUpWindow.center();
		}
	},
	LaunchDKConsole: function()
	{
		
		if(this.InstancesGrid.getSelectionModel().getSelected()){
			var record = this.InstancesGrid.getSelectionModel().getSelected();
			
			var strClassName = record.get('ClassName__c');
			if(strClassName.toUpperCase() == 'BMC_SOFTWARESERVER'){
					var id = parseInt(record.get('TokenId__c'));
					if(!isNaN(id)){
						if(isDKEnable){
							window.open(strDKServer + '/adminui/software.php?ID='+ id);
						}
					}
			}else {
				var strAssemblyId = record.get('AssemblyId__c');
				var id = '';
				if(isDKEnable && strAssemblyId != null && strAssemblyId != undefined &&  strAssemblyId.toUpperCase().indexOf('DELLKACE') == 0){
					id = parseInt(strAssemblyId.substr(strAssemblyId.indexOf('-') + 1,strAssemblyId.length - strAssemblyId.indexOf('-')));
				}
				if(!isNaN(id)){
					window.open(strDKServer + '/adminui/machine.php?ID='+ id );
				}
			}
		}
	},
	searchBaseElement : function()
	{
		searchstring = document.getElementById("searchTxt").value;
    	searchstring = searchstring.replace("\"","");
		searchstring = RemoveReserveCharactersForSOSL(searchstring).trim();
        document.getElementById("searchTxt").value = searchstring;
				
		if(searchstring.length < 2 || searchstring == _ServerValues.srchTxtFldLabel){
			Ext.MessageBox.show({
				title: '',
				msg: _ServerValues.validateMinimumCharsSearchPage,
				width:300,
				buttons: Ext.MessageBox.OK,
				fn: function(btn){
					if(btn == 'ok'){
						document.getElementById("searchTxt").focus(false,10);
					}
				},
				title: _ServerValues.WarningTitle,
				icon: Ext.MessageBox.WARNING
			});
			return;
		}
		this.getInstanceListStore();
	},
	
	pageRefresh : function()
	{
		document.getElementById("searchTxt").value = _ServerValues.srchTxtFldLabel;
		searchstring = '';
		this.getInstanceListStore();
	}
	,
	NewCI : function()
	{
		if(this.SelectedRecordID!='')
		{
			this.ShowInstancePanel(this.SelectedRecordID,'','');
		}
	},
	
	DeleteCI : function()
	{
	
            Ext.MessageBox.confirm(_ServerValues.Delete, _ServerValues.ConfirmDeleteCI, 
            function(btn){
                    if(btn.toUpperCase()=="YES")
                    {
		                var elements=this.InstancesGrid.getSelectionModel().getSelections();
		                if(elements.length>0)
		                {
		                    var s = '';
		                    var cname = elements[0].data.ClassName__c;
		                    for(var i=0;i<elements.length;i++)
		                    {
		                        s+=elements[i].data.InstanceID__c+',';
		                    }
                		    
							deleteCIs(cname,s);
                            
		                }
                		
                    }

                }.createDelegate(this));
	},

	CloseFormPanel : function()
	{
		var backbtntoolbar = this;
		try{
    		window.ActiveInstanceReference.getRelationListStore();
			var dataModifiedFlag = window.ActiveInstanceReference.getDataModifiedFlag();
			var dataModifiedFlagRel = 0;
			if(window.ActiveReleationInstanceReference != null && window.ActiveReleationInstanceReference != 'undefined')
			{
				dataModifiedFlagRel = window.ActiveReleationInstanceReference.getDataModifiedFlag();
				if( dataModifiedFlagRel == 1 || dataModifiedFlagRel == 1)
				{
					dataModifiedFlag = 1
				}
			}
		}catch(e){}
	    if(dataModifiedFlag){
			Ext.Msg.show({
				title:_ServerValues.closeWindowTitle,
				msg: _ServerValues.closeWindowMessage,
				width:400,
				buttons: Ext.Msg.YESNO,
				fn:function(btn){
					if(btn == 'yes'){
						backbtntoolbar.ExplorerItemClickHandler(backbtntoolbar.SelectedRecordID, true);
						backbtntoolbar.MainTabPanel.remove(backbtntoolbar.MainTabPanel.getActiveTab());
						backbtntoolbar.resizeTypeViews();
					} 
				},
				icon: Ext.MessageBox.WARNING
			}); 
		} else {
			backbtntoolbar.ExplorerItemClickHandler(backbtntoolbar.SelectedRecordID, true);
			backbtntoolbar.MainTabPanel.remove(backbtntoolbar.MainTabPanel.getActiveTab());
			backbtntoolbar.resizeTypeViews();		
		}
	},

	ShowDerivedCIs : true,
	ShowDerivedCIsClicked : function(ctrl, checked)
	{
		if(!Ext.isIE7 && !Ext.isIE8){
			this.ShowDerivedCIs = checked;
			this.Paging_PageNumber=1;
			this.getInstanceListStore();
		}
	},
	
	/* Paging code */

	InstanceGridColumns: [
							{ header: _ServerValues.Name, width: 150, dataIndex: 'Name__c', sortable: true },
							{ id: 'desc', header: _ServerValues.Description, width: 200, dataIndex: 'Description__c', sortable: true },
							{ header: _ServerValues.InstanceID, width: 200, dataIndex: 'InstanceID__c', sortable: true },
							{ header: _ServerValues.ClassName, width: 200, dataIndex: 'ClassName__c', sortable: true },
							{ header: _ServerValues.BE_Stage, width: 200, dataIndex: 'Stage__c', sortable: true },
							{ header: _ServerValues.AssemblyId, width: 100, dataIndex: 'AssemblyId__c', sortable: true },
							{ dataIndex: 'TokenId__c', hidden: true },
							{ header: _ServerValues.Id, width: 15, dataIndex: 'Id', sortable: true }
						],

	
	getGridFields : function(){
		var arr = [];
		for(var i =0;i<this.InstanceGridColumns.length;i++)
		{
			arr[i] = this.InstanceGridColumns[i].dataIndex;
		}
		return arr;
	},
	getServiceGridFields : function(){
		var arr = [];
		for(var i =0;i<ServiceInstanceGridColumns.length;i++)
		{
			arr[i] = ServiceInstanceGridColumns[i].dataIndex;
		}
		return arr;
	},
	
	Paging_SortColumn : 'InstanceID__c',
	Paging_PointerFirstRecordValue : '',
	Paging_PointerLastRecordValue : '',
	Paging_PageSize : iPageSize,
	Paging_PageNumber : 1,
	Paging_SortDirection : 'ASC',
	PageMoveDirection : 'NEXT',

	enableDisablePagingButtons : function()
	{
		
		if(this.InstancesGrid.store.reader.jsonData.hasPrevious) Ext.getCmp('PreviousPageButton').enable();
		else Ext.getCmp('PreviousPageButton').disable();

		if(this.InstancesGrid.store.reader.jsonData.hasNext) Ext.getCmp('NextPageButton').enable();
		else Ext.getCmp('NextPageButton').disable();
		
		this.Paging_PageNumber = this.InstancesGrid.store.reader.jsonData.pageNumber;
		inprogress = 0;

	},
	
	getPagingParamString : function()
	{
		var s = '';
		s+='&SortColumn='+this.Paging_SortColumn;
		s+='&PointerFirstRecordValue='+this.Paging_PointerFirstRecordValue;
		s+='&PointerLastRecordValue='+this.Paging_PointerLastRecordValue;
		s+='&PageSize='+this.Paging_PageSize;
		s+='&PageNumber='+this.Paging_PageNumber;
		s+='&SortDirection='+this.Paging_SortDirection;
		s+='&PageMoveDirection='+this.PageMoveDirection;
		s+='&ShowDerivedCIs='+this.ShowDerivedCIs;
		return s;
	},
	
	getInstanceListStore : function(ClassName) {
		
		if(typeof(ClassName)=='undefined' || ClassName==null || ClassName.trim()=='') { 
			ClassName = this.SelectedRecordID; 
		}
		if(orgNamespace != '' && orgNamespace != null && orgNamespace != 'undefined' && orgNamespace != 'null'){
			eval(orgNamespace).CMDBClassAccess.getclassaccess(ClassName, function(result, event){
					if(event.status) {
						if(result != '' && result != null){
							classaccess = result;
							//alert(classaccess[0]);
							iscreatable = classaccess[0];
							isdeletable = classaccess[1];
							isupdateable = classaccess[2];
							enabledisablenewbutton();
						  }           			
					} else if (event.type === 'exception') {    
						Ext.Msg.alert('', event.message);
					}			
				}, {escape:true});		
		} else {
			CMDBClassAccess.getclassaccess(ClassName, function(result, event){
				if(event.status) {
					if(result != '' && result != null){
						classaccess = result;
						iscreatable = classaccess[0];
						isdeletable = classaccess[1];
						isupdateable = classaccess[2];
						enabledisablenewbutton();
					  }           			
				} else if (event.type === 'exception') {    
					Ext.Msg.alert('', event.message);
				}			
			}, {escape:true});
		}
		var sURL = '';
		if(searchstring.length < 2 || searchstring == _ServerValues.srchTxtFldLabel)
			sURL = '/apex/CMDBJsonGenerator?type=instancelistbyclass&ClassName='+ClassName+'&'+this.getPagingParamString();
		else
			sURL = '/apex/CMDBJsonGenerator?type=instancelistbyclass&searchStr='+searchstring+'&ClassName='+ClassName+'&'+this.getPagingParamString();
	    var dataStore = new Ext.data.JsonStore({
	        url: sURL,
	        idPath: this.Paging_SortColumn,
			remoteSort: true,
			root:'data',
			sortInfo: {
				field: this.Paging_SortColumn,
				direction: this.Paging_SortDirection
			},
	        fields: this.getGridFields()
	    });
		var serviceDataStore = null;
		if(ClassName == 'BMC_BusinessService'){
			dataStore= new Ext.data.JsonStore({
				url: sURL,
				idPath: this.Paging_SortColumn,
				remoteSort: true,
				root:'data',
				sortInfo: {
					field: this.Paging_SortColumn,
					direction: this.Paging_SortDirection
				},
				fields: this.getServiceGridFields()
			});
			
		}
		
	    dataStore.on('load', function(){
			
										
				
					var instanceGridcm = new Ext.grid.ColumnModel(colInstanceGrid);
	    	 		if(ClassName == 'BMC_BusinessService'){
					
						instanceGridcm = new Ext.grid.ColumnModel(ServiceInstanceArrayStore);

						this.InstancesGrid.reconfigure(dataStore, instanceGridcm);
						dataStore = dataStore;
					}else{
						this.InstancesGrid.reconfigure(dataStore,  instanceGridcm);
					}	
					try{
						this.Paging_SortColumn = this.InstancesGrid.store.sortInfo.field;
						this.Paging_SortDirection = this.InstancesGrid.store.sortInfo.direction;
						this.enableDisablePagingButtons();
						var index = 0;
						for (index = 0; index < this.InstancesGrid.store.data.length; index++){	
							if(this.InstancesGrid.store.getAt(index).get('InstanceID__c') == selectedRowIndexInstanceID){
								break;
							}
						}
						this.InstancesGrid.getSelectionModel().selectRow(index);
					}catch(e){}
	    	 	}.createDelegate(this)
	    	 );
		dataStore.load();
		return dataStore;
	},

	SetPointerRecords : function()
	{
		try{
		var storData = this.InstancesGrid.store.data;
		this.Paging_PointerFirstRecordValue = storData.items[0].data[this.Paging_SortColumn];
		this.Paging_PointerLastRecordValue = storData.items[storData.length-1].data[this.Paging_SortColumn];
		}catch(e){}
	},
	
	GoToNextPage : function()
	{
		this.SetPointerRecords();
		this.PageMoveDirection ='NEXT';
		this.Paging_PageNumber++;
		this.getInstanceListStore();
	},

	GoToPreviousPage : function()
	{
		this.SetPointerRecords();
		this.PageMoveDirection = 'PREVIOUS';
		this.Paging_PageNumber--;
		this.getInstanceListStore();
	},

	OpenBMCAPM : function(){
		if(isStdForm){
			window.open( "/apex/CMDBProcMgmtPage",'_blank',"status = 1, height = 1000, width = 1000,left=100,right=200, resizable = 1,scrollbars=no");
		}else{
			var CMBDProcPage = 'NavigatorPage?title='+ _ServerValues.CMDBProcess +'&target=CMDBProcMgmtPage';
			window.parent.parent.addNewTab('CMDB Process', _ServerValues.AlignabilityProcessModel, CMBDProcPage, 'false');
		}
	},
	/* End of paging code */

	empty:''
}

function oncompleteFPvalidateJS(validated){
	if(validated){
		isFPUserValidated = true;
		waitbox(0);
		directConnectDevice('Full');
	}
}

function ReplaceAll(Source,stringToFind,stringToReplace){
				var reptemp = Source;
				var repindex = reptemp.indexOf(stringToFind);
				while(repindex != -1)
				{
					reptemp = reptemp.replace(stringToFind,stringToReplace);
					repindex = reptemp.indexOf(stringToFind);
				}
				return reptemp;
}

function RemoveReserveCharactersForSOSL(value)
{
	var chars = new Array('?', '&', '|', '!', '{', '}', '[', ']', '(', ')', '^', '~', '*', ':', '\\', '"', '+', '-', '\'');
	for(var j = 0 ; j < chars.length; j++)
	{
		value = ReplaceAll(value, chars[j],'');
	}
	return value
}
