var listView;
function CMDBCustomizationsavehandler(){
			var record = Ext.getCmp('SelectedFieldListId').store;			
            var rowCount=record.data.length;            
            var ObjectCustomFields = '';
            var fieldCount = 0;
            while(rowCount > fieldCount){
                var cField = record.getAt(fieldCount); 
                ObjectCustomFields += cField.get('FieldApi')+ ',';    
                fieldCount++;              
            }           	
            saveCMDBCustomFields(ObjectCustomFields);
		}
        var TypeTileView = null;
		Ext.onReady(function(){
    	Ext.QuickTips.init();
    	gridheight = 550;
    	
		if(document.documentElement && (document.documentElement.clientHeight) && document.documentElement.clientHeight > 0){
			gridheight = document.documentElement.clientHeight
			
		}						
		if( typeof( window.innerHeight ) == 'number' && window.innerHeight > 0){
			gridheight = window.innerHeight;
		}			
			
        ds = new Ext.data.ArrayStore({
	        data: AvailableCustomFields,
	        fields: ['FieldName','FieldApi'],
	        sortInfo: {
	            field: 'FieldName',
	            direction: 'ASC'
	        }
	    });
	    
	    selectedDS = new Ext.data.ArrayStore({
	        data: SelectedCustomFields,
	        fields: ['FieldName','FieldApi'],
	        sortInfo: {
	            field: 'FieldName',
	            direction: 'ASC'
	        }
	    });
       var InstanceBrowserColumn1 = new Ext.Panel({
	       
	        autoWidth:true,
	        border: false
	    }); 
	    
	    var AvailableClassesPanel = new Ext.Panel({
	        border:false,	
	        id: 'AvailableClassesPanelId',
	        title: labelCMDBAvailableClasses
	    });    
	function getXMLObjectFromString (strXML) {
	    var doc = null;
	
	    
	    if (window.ActiveXObject) {
	        doc = new ActiveXObject("Microsoft.XMLDOM");
	        doc.async = "false";
	        doc.loadXML(strXML);
	    }
	   
	    else {
	        var parser = new DOMParser();
	        doc = parser.parseFromString(strXML, "text/xml");
	    }
	
	    return doc.documentElement;
	}
	
	function getElementListStore () {
	    var strXML = _ServerValues.ElementsListXML;
		
	    xmlObject = getXMLObjectFromString(strXML);
	
	    var dataStore = new Ext.data.XmlStore({
	        autoDestroy: false,
	        proxy: new Ext.data.MemoryProxy(xmlObject),
	        record: 'element',
	        idPath: 'Name',
	        fields: ['Name', 'DisplayName']
	    });
	
	    dataStore.load();
	
	    return dataStore;
	}
	
	 	var ElementList = new Ext.form.ComboBox({
	        store: getElementListStore(),
	        typeAhead: true,
	        mode: 'local',
	        valueField: 'Name',
	        displayField: 'DisplayName',
	        editable: false,
	        forceSelection: true
	    });
	
	    ElementList.value = _ServerValues.DefaultElementsDropDownValue;
	    InstanceBrowserColumn1.add(AvailableClassesPanel);
	    
		InstanceBrowserColumn1.add(ElementList);
							
		selectedClassPanel = new Ext.Panel({
		        border:false,	       
		        title: labelSelectedClass+': '+labelPanelTitle,
		        id:'SCPanelId',
				layout:'table',				
				layoutConfig:{ columns: 2},
				bodyStyle: 'background-color: #dee0e0;padding-top: 15px;padding-bottom: 10px;',	
		        items:[
		        	
					{
		            	id:'ClassId',
		            	border:false,
		            	html: '<div class = "namecls">'+labelClassId+':</div>'
		            },
		            { 
		            	id:'ClassIdValueId',
		            	border:false,
		            	cls: 'valuecls',
		            	html: '<div class = "valueclass">'+updateClassId+'</div>'
		            },
		            {
		            	id:'SuperClass',
		            	border:false,
		            	html: '<div class = "namecls">'+labelSuperClass+':</div>'
		            },
		            {
		            	id:'SuperClassValueId',
		            	border:false,
		            	cls: 'valuecls',
		            	html: '<div class = "valueclass">'+updateSuperClass+'</div>'
		            },
		            {
		            	id:'Abstract',
		            	border:false,
		            	
		            	html: '<div class = "namecls">'+labelAbstract+':</div>'
		            },
		            {
		            	id:'AbstractValueId',
		            	border:false,
		            	cls: 'valuecls',
		            	html: '<div class = "valueclass">'+updateIsAbstract+'</div>' 
		            }
		        ]
	        
	    }); 
		
		var CustomObjAvailableFields = new Ext.form.Label({
	        id:'CustomObjAvailableFields',
	        text: labelAvailableFields
	    });

	    var CustomObjSelectedFields = new Ext.form.Label({
	        id:'CustomObjSelectedFields',
	        text:labelSelectedFields
	    });
	
	    var CustomObjFieldsSelectionLabels = new Ext.Panel({
	        id: 'CustomObjFieldsSelectionLabels',
	        border:false,
	        layout:'table',
	        items:[CustomObjAvailableFields, CustomObjSelectedFields]
	    });
		
		var InstanceBrowserColumn2 = new Ext.form.FormPanel({	        
	        
	        width: 700,
			border:false,
			layout:'column',
	        cls:'tabContainer',
	        bodyStyle: 'padding:15px;',
	        items:[
	        {
	            xtype: 'itemselector',
	            name: 'itemselector',	             
	            drawLeftIcon:true,
	            drawRightIcon:true,
	            drawUpIcon:false,	
	            drawDownIcon:false,		            
            	iconLeft:'b_darrow_L_disable_custom.gif',
            	iconRight:'b_darrow_R_disable_custom.gif',    
            	imagePath: sdefStylePath+'SDEFbuttons/', 
	            multiselects: [{
	            	legend: false,
	                width: 250,
	                height: 400,
	                store: ds,
	                displayField: 'FieldName',
	                valueField: 'FieldApi',
	                listeners:{
	                	click:function(c){
	                		document.getElementById('iconRightId').src = sdefStylePath+'SDEFbuttons/b_darrow_R_new.gif';
	                		document.getElementById('iconLeftId').src = sdefStylePath+'SDEFbuttons/b_darrow_L_disable_custom.gif';
	                	}
                	}	
	            },{
	            	id: 'SelectedFieldListId',
	            	legend: false,
	                width: 250,
	                height: 400,
	                store: selectedDS,
	                displayField: 'FieldName',
	                valueField: 'FieldApi',                	
	                listeners:{
	                	click:function(c){
							document.getElementById('iconLeftId').src = sdefStylePath+'SDEFbuttons/b_darrow_L_new.gif';
	                		document.getElementById('iconRightId').src = sdefStylePath+'SDEFbuttons/b_darrow_R_disable_custom.gif';
	                	}	                	
	                }
	            }]
	        }]
		});
			
		function resizeTypeViews(){
			newWidth =  Ext.getCmp('TabPanelID').getWidth();
			Ext.getCmp('TabPanelID').setWidth(newWidth);
			
			if(document.getElementById('listViewID') != 'undefined' && document.getElementById('listViewID') != null){
				var newtabWidth =  Ext.getCmp('TabPanelID').getWidth();				
			}
			if(tabchange == 1){
				var tabWidth =  Ext.getCmp('TabPanelID').getWidth();				
				listView.setWidth(tabWidth);
					
			}
			   	
		}
	    var InstanceBrowserPanel = new Ext.Panel({	        
	        id: 'InstanceBrowserPanelId',
	        border: false,
	        height: gridheight,
	        autoscroll:true,
	        autoWidth:true,
	        layout: 'border',
			monitorResize:true,
	        listeners: {
            afterlayout: function(){ 
                                resizeTypeViews();
                         }
            }, 
	        
	        items: [
	            { collapsible: false,  layout:'fit', animFloat: false, split: true, region: 'west', width: 260, items: [InstanceBrowserColumn1] },	            
	            { region: 'center', items: [selectedClassPanel, CustomObjFieldsSelectionLabels, InstanceBrowserColumn2] }
	            ]
	    });
		function ExplorerItemClickHandler(recordID, forceReload) {
			
		}
		function getClassViewStore() {
			var json = _ServerValues.ClassViewListJSON;			
			json = eval(json);		
			var dataStore = new Ext.data.JsonStore({
				proxy: new Ext.data.MemoryProxy(json),
				idProperty: 'Name',
				fields: ['Name', 'DisplayName', 'Image']
			});
			dataStore.load();
			return dataStore;
		}
		var item;
		function getClassTileView(displayStyle, newHeight) {
			item = new CMDBClassChooser(
							displayStyle,
							getClassViewStore(),ExplorerItemClickHandler());
														
			
			item.on('click', function() {
		   		var selNode = item.getSelectedNodes();		   		
		   		if (selNode && selNode.length > 0) {
            		
            		selNode = selNode[0];
            	}			   		
		   		selectedClassAPI = selNode.id;
		   		selectedRecordId = selectedClassAPI;
		   		getAvailableFields(selectedClassAPI);		   		
		    });
		   
			return new Ext.Panel(
					{ 
						autoScroll: true, 
						border: false, 
						height: gridheight-80,
						autoscroll:true, 
						items: item 
					})
					
		}
		var ClassTileView = getClassTileView('tile', 1000);
		
		function getClassListView(){
			var cvstore = getClassViewStore();
			var tpl_img = new Ext.XTemplate(
	                    '<tpl for=".">',
	                    '<img class="thumb-img" src="'+CIFORCE_RES_PATH+'/images/ci/{Image}_32.png" width="20" height="20" >',
	                    '</tpl>'
	                ).compile();
	        listView = new Ext.grid.GridPanel({
	        	id: 'listViewID',
		        hideHeaders: true,
		        store: cvstore,
		        autoscroll:true,
		        autowidth:true,		        
		        layout:'fit',
		        viewConfig: {
	            	forceFit: false
	        	},  
		        
		        height: gridheight - 80,
		        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		        columns: [
		            new Ext.grid.TemplateColumn({ tpl: tpl_img, width: 30, dataIndex: 'Image', tpl: tpl_img }),
		            { id: 'DisplayName', dataIndex: 'DisplayName' }
		            ],
		        autoExpandColumn: 'DisplayName',
		        stripeRows: true,
		        border: false,
		        listeners: {
	                afterlayout: function(){	                	
	                	if(!Ext.isIE){
							gridheight = window.innerHeight;
						}
						if(Ext.isIE){
							gridheight = document.body.clientHeight;
						} 
						
	                									                      
	                }
	            }
		    });
		   
		   

		    listView.getSelectionModel().on('selectionchange', function(selModel, row, e){
		    	var record = selModel.getSelected();
		    	if(record != 'undefined'){
		    		var selectedIndex = listView.getStore().indexOf(record);
		    		if(selectedIndex >= 0){		    			
		    			selectedClassAPI = cvstore.getAt(selectedIndex).get('Name');		    			
		    			selectedRecordId = selectedClassAPI; 
		    			getAvailableFields(selectedClassAPI);
		    		}		    		
		    	}
		    });
		    
	    	return listView;        
		} 
		
		ClassListView = getClassListView();
		
		var treePanelvar;
		function getClassTreeView() {
	
		    var strJSON = _ServerValues.TreeViewJSON;
		
		    var root = new Ext.tree.AsyncTreeNode({
		        expanded: true,
		        children: eval(strJSON)
		    });
		
		    treePanelvar = new Ext.tree.TreePanel({
		        root: root,
		        useArrows: true,
		        autoScroll: true,
		        animate: true,
		        containerScroll: true,
		        border: false,
		        rootVisible: false,
		        height:gridheight-80,
		        listeners: {
		            click: function(n) {	
		            	selectedClassAPI = n.attributes.id;
		            	selectedRecordId = selectedClassAPI;  					
						getAvailableFields(selectedClassAPI);
		            }
	        	}              
		    });
		    root.expand();
		    
		    return treePanelvar;
		}
		var ClassTreeView = getClassTreeView();
		
		
		var tabs = new Ext.TabPanel({
		 	id: 'TabPanelID',
       		border: false,
	        activeItem: 0,	
	        minTabWidth: 25,        
	        autoWidth:true,    
	        autoscroll:true,     
            resizeTabs:true,
	        height: gridheight,
	        layoutOnTabChange: true,
	        bodyBorder: false,      
	        listeners: {
                     tabchange: function (container,tab){
            				var tabWidth =  Ext.getCmp('TabPanelID').getWidth();
							
            				if(tab.id == 'tab2'){            					
            					if(selectedRecordId != '')
            					listView.getSelectionModel().selectRow(listView.getStore().find('Name',selectedRecordId));	
            					tabchange = 1;		
								
								listView.setWidth(tabWidth); 
								
						    }else if(tab.id == 'tab1'){
            					tabchange = 0;		
            					item.select(item.getStore().find('Name',selectedRecordId));	
            								
						    }
						    if( tab.id == 'tab3'){
						    	treePanelvar.selModel.select(treePanelvar.getNodeById(selectedRecordId));
						    	tabchange = 0;							    	
						    }	
                     }
            }
	    });
	
	    tabs.add(
	        { id:'tab1', iconCls: 'tileViewTabHeader', tabTip: tabTipCMDBTileView, items: [ClassTileView] },
	        { id:'tab2', iconCls: 'listViewTabHeader', tabTip: tabTipCMDBListView, items: [ClassListView] },
	        { id:'tab3', iconCls: 'treeViewTabHeader', tabTip: tabTipCMDBTreeView, items: [ClassTreeView] }
	    );
	                    
	 	InstanceBrowserColumn1.add(tabs);
	    var XMLGridBrowserPanel = new Ext.Viewport({
        	id: 'XMLGridBrowserPanel',
	        height: gridheight,
	        layout: 'border',
	        border: false,	        
	        autoWidth:true,
	        items:[
	              { region: 'center',  layout:'fit', items: InstanceBrowserPanel, border: false }
	        ]
    	});
	    
		}); 
         
	function updateData(){				
		ds.loadData(AvailableCustomFields);	
		selectedDS.loadData(SelectedCustomFields);		
	}
