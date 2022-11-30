
var clickedOnce = false;
var isCustomPage = true;
var isACEnabled =false;
function postExtOnReady()
{
        var toolbar= new Ext.Toolbar({
				id:'toolBarId',
				renderTo: 'ToolBarTD',
				cls:'toolSpCls',
				border:false,
				autoWidth:true,
				items :[{
			                scale: 'medium',
			                iconCls: 'bmcNew',
			                tooltipType : 'title',
			                tooltip: _ServerValues.New, 
			                id:'newCIInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcNewOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcNew');          
			                    }
			                },
	                        handler:function(){NewCI();}
			            },
						{
					scale: 'medium',
					border:false,
					iconCls: 'bmcSave',
					tooltipType : 'title',
					tooltip: _ServerValues.Save,
					id:'saveId',
					
					listeners: {
						mouseover: function(){
							this.setIconClass('bmcSaveOn');    
						},
						mouseout: function(){
							this.setIconClass('bmcSave');          
						}
					},
					handler : function(){ if(ValidateForm()){waitbox(0); Ext.getCmp('saveId').setDisabled(true); SaveClick(); } }
									}
				]});
			toolbar.items.get('newCIInstanceBtn').setDisabled(!(_ServerValues.isCreateEnabled && _ServerValues.isSaveEnabled));
			toolbar.items.get('saveId').setDisabled(!(_ServerValues.isCreateEnabled && _ServerValues.isSaveEnabled));
			if(isACEnabled && typeof(assemblyId) != 'undefined' && assemblyId != null && assemblyId.indexOf('AC:CS:-') == 0){
				var ACMenu = getACMenu();
				var extToolbar = Ext.getCmp('toolBarId');
				if(typeof(extToolbar) != 'undefined' && extToolbar != null && extToolbar != 'undefined'){
					extToolbar.insert(3,{scale: 'medium',iconCls: 'acAction',menu:ACMenu,tooltipType : 'title',tooltip:acActionLabel});
					extToolbar.doLayout(true,true);
				}
			}
	try{
        window.parent.ActiveInstanceReference=this;
	}catch(e){}
	ChangeBtnStatus();
    
}

function functionextonreadypagecall ()
{
	//Performance Metrics
	windowloaddate = new Date();
	networklatencystart = windowloaddate.getTime();
	var networklatency = networklatencystart - etime;
	data += _ServerValues.NetwokLatencyLabel;
	data +=networklatency; 
	data += '<br>';
	//time to calculate page rendertime 
		var pageloaddate = new Date();
		var renderingstartitme = pageloaddate.getTime();
	Ext.QuickTips.init();
	ExtOnReady();
	
	 //Page-load time
    data += _ServerValues.PageLoadLabel;
    var pageloadstartdate = new Date() ;
 
    var time1 = pageloadstartdate.getTime();
    var time2 = windowloaddate.getTime();
    var pagerendertime = (time1 - renderingstartitme);
    
    data += pagerendertime;
	
	  var canvasPanel = new Ext.Panel({
                         layout:'border',
                        // width:'auto',    
                          height:Ext.isIE7 ? 605: Ext.isIE ? 605:Ext.isSafari ? 618:603,
                         border:false, 
                         id:'canvasPanelId',
                        cls:'canvasPanelCls',
                         items:[{  
                                xtype: 'panel', // TabPanel itself has no title    
                                layout: 'fit',                                                   
                                overflow:'auto',
                                autoScroll:true,
                                split:true,
                                width:'auto',    
                                //height:500, 
                                cls:'northPanelCls',                                         
                                region: 'center',                                        
                                contentEl :  CMDBGenericPageComp.ComponentVars.CMDBGenericForm
                                
                        },{                                                         
                                xtype: 'panel', // TabPanel itself has no title
                                layout: 'fit',  
                                overflow:'auto',
                                border:false, 
                                id:'southPanelSI',
                                autoScroll:true,
                                split:true,
								header : false,
                                collapsible: true,
                                collapseMode: 'mini',
                                width:'auto',    
                                height: Ext.isIE7? 300: 275,
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
		 width:'auto',
		 id:'viewportId',
		 border:false, 
		 cls:'viewportCanvasCls',          
		 items:[{anchor: '100%', layout:'fit', items:canvasPanel} ]
		}); 
		 handleElemEvent();	

}   
function handleChange(){	
	if(!clickedOnce){ 
		clickedOnce = true;
		if(typeof(window.parent.parent.registerChange)!= 'undefined' 
			&& typeof(window.parent.parent.registerChange)!= null
		)
		{
			window.parent.parent.registerChange(getWID());
		}
	}
}
function writeCookie(){
		if(document.getElementById('configureSIId').checked){
			createSICookie(cookieName,'true');
			var isCookiePresent = displaySI(cookieName, iFrameSrc);
		}
	}
function GetQueryString(name)
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if(results == null)
    return "";
  else
    return results[1];
}

function NewCI()
{
	var clsName = currentClassName;
	window.location = "/apex/cmdbgenericpage?className=" + clsName + "&InstanceID=";
}


var InRGrid;
 function onSaveComplete()
{
	if(BE_RECORD_ID != null && BE_RECORD_ID != ''){
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
	}
	MainPanelRender();
	var savestatusvar = _ServerValues.savestatus 
	if(savestatusvar == 'true')
	{
		setDataModifiedFlag(); 	
		Ext.MessageBox.alert('', _ServerValues.SuccessSaveMsg);			
	}
	else if(_ServerValues.savestatusMessage != null && _ServerValues.savestatusMessage != '')
	{
		Ext.MessageBox.alert('',_ServerValues.savestatusMessage);
	}
}
function ExtOnReady()
{
    if(typeof(preExtOnReady)!='undefined' && preExtOnReady!=null) preExtOnReady(); // Keep this as the first statement for this method
    
    MainPanelRender();
	
	if(BE_RECORD_ID == null || BE_RECORD_ID == ''){
        if(document.getElementById('linkSIAvailTD')!=null)
				document.getElementById('linkSIAvailTD').style.display = 'none';
            if(document.getElementById('noSIAvailTD')!=null)
            	document.getElementById('noSIAvailTD').style.display = 'block';
        }
	else if(BE_RECORD_ID != null){
        var isCookiePresent = displaySI(cookieName, iFrameSrc);
			if(!isCookiePresent){
				if(document.getElementById('noSIAvailTD')!=null)
					document.getElementById('noSIAvailTD').style.display = 'none';
				if(document.getElementById('linkSIAvailTD')!=null)
					document.getElementById('linkSIAvailTD').style.display = 'block';
			}
        }  
	
	
	if(typeof(postExtOnReady)!='undefined' && postExtOnReady!=null) postExtOnReady(); // Keep this as the last statement for this method
}

function MainPanelRender()
{
	createControlMap();

	// Process the map later. Donot do that in the getElementByTagName Loop
	renderElementsByType();
	renderTabs();
	
}



function renderTabs()
{
	var accordionHeight = 470; 
	var tabpanelHeight = accordionHeight-70;
	var tabitems = null;
	if(_ServerValues.isCustomAvailable == 'true'){
		if(_ServerValues.tabDerivedInfoTitleTabTip != '' && _ServerValues.tabDerivedInfoTitleTabTip != 'undefined' && _ServerValues.tabDerivedInfoTitleTabTip != null){
			tabitems = [{contentEl:'tabBaseInfo', title:_ServerValues.tabBaseInfoTitle, id:'generalTab'},
						{contentEl:'tabDerivedInfo', title:_ServerValues.tabDerivedInfoTitle, tabTip:_ServerValues.tabDerivedInfoTitleTabTip, id:'specificationTab'}, 
						{contentEl:'tabCustomInfo', title:_ServerValues.CMDBCustomTitle, id:'customFieldsTab'}];    	
		}else{
			tabitems = [{contentEl:'tabBaseInfo', title:_ServerValues.tabBaseInfoTitle, id:'generalTab'},
						{contentEl:'tabDerivedInfo', title:_ServerValues.tabDerivedInfoTitle, id:'specificationTab'}, 
						{contentEl:'tabCustomInfo', title:_ServerValues.CMDBCustomTitle, id:'customFieldsTab'}];    	
		}			
	} else {
		if(_ServerValues.tabDerivedInfoTitleTabTip != '' && _ServerValues.tabDerivedInfoTitleTabTip != 'undefined' && _ServerValues.tabDerivedInfoTitleTabTip != null){
			tabitems = [{contentEl:'tabBaseInfo', title:_ServerValues.tabBaseInfoTitle, id:'generalTab'},
						{contentEl:'tabDerivedInfo', title:_ServerValues.tabDerivedInfoTitle, tabTip:_ServerValues.tabDerivedInfoTitleTabTip, id:'specificationTab'}];    		
		}else{
			tabitems = [{contentEl:'tabBaseInfo', title:_ServerValues.tabBaseInfoTitle, id:'generalTab'},
						{contentEl:'tabDerivedInfo', title:_ServerValues.tabDerivedInfoTitle, id:'specificationTab'}];    		
		}				
	}
	 
	var tabpanel = new CMDB.Controls.VerticalTabPanel({
			//renderTo: 'MoreInfoTabs',
		    activeTab: 0,
		    tabPosition:'left',  //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs
		    textAlign:'right',
	        autoWidth:true,
		    tabWidth:120,
		    height: tabpanelHeight,
		    defaults:{autoScroll: true},
		    enableTabScroll: true,
		    items: tabitems
	});
	
	var attributes = new Ext.Panel({
		title: _ServerValues.AttributeTitle,
		autoWidth:true,
		items: tabpanel
	});	
	
	var relationshipGrid = renderGrid();
	var chatterSection = renderChatterSection();
	var accordion_items = [attributes,relationshipGrid,chatterSection];
	if(_ServerValues.BEFeedEnabled=="false") {
		accordion_items = [attributes,relationshipGrid];
	}
	var accordion = new CMDB.Controls.AccordionPanel({
		id:'AccordionPanelId',
    	renderTo:'MoreInfoTabs', 
		autoWidth:true,
		items: accordion_items,
	    height: accordionHeight
	});
	
}

function getRelationListStore () {

	var sURL = '/apex/CMDBJSONGenerator?type=instancelistforgridcirelationship&ClassName='+_ServerValues.InstanceID;
    var dataStore = new Ext.data.JsonStore({
        url: sURL,
        idPath: 'InstanceID',
        fields: ['InstanceID', 'CIName', 'CIClassId', 'CIRole','ImpactDirection','RelationshipName']
    });

    dataStore.load();
    dataStore.on('load', function(){
    	 		InRGrid.reconfigure(dataStore, InRGrid.colModel);
    	 	}.createDelegate(this)
    	 );
    	
    return dataStore;
}


function showRelationshipEditor(url, relationshipInstanceID)
{
		if(typeof(relationshipInstanceID)=='undefined' || relationshipInstanceID==null || relationshipInstanceID.trim()=='') { 
			window.parent.CMDBManagerNamespace.instance.ShowFormPanel(url,_ServerValues.RelationshipEditor);
		}
		else
		{
			if(orgNamespace != '' && orgNamespace != null && orgNamespace != 'undefined' && orgNamespace != 'null'){
				eval(orgNamespace).CMDBGenericRemoting.isInstanceReadable(relationshipInstanceID, function(result, event){
						if(event.status) 
						{
							if(result)
							{		
								window.parent.CMDBManagerNamespace.instance.ShowFormPanel(url,_ServerValues.RelationshipEditor);
							}
							else
							{
								Ext.Msg.alert('', _ServerValues.MsgNoAccessPerm);
							}								  
					  
						} else if (event.type === 'exception') 
						{
							Ext.Msg.alert('', event.message);
						}
											
					}, {escape:true});		
			} else {
				CMDBGenericRemoting.getclassaccess(relationshipInstanceID, function(result, event){
					if(event.status) {
						if(result)
						{		
							window.parent.CMDBManagerNamespace.instance.ShowFormPanel(url,_ServerValues.RelationshipEditor);
						}
						else
						{
							Ext.Msg.alert('', _ServerValues.MsgNoAccessPerm);
						}	          			
					} else if (event.type === 'exception') {    
						Ext.Msg.alert('', event.message);
					}						

				}, {escape:true});
			}
			
		}
}

function editAction(url)
{
 	var elements=InRGrid.getSelectionModel().getSelections();
 	if(elements.length==1)
 	{
	 	var url = "/apex/CMDBEditRelationship?RelationshipInstanceID="+elements[0].data.InstanceID; 
		showRelationshipEditor(url, elements[0].data.InstanceID);
 	}
}

var relationshipWin=null;


function newAction()
{

	var instanceFramePanel = RelationshipNewOnReady();
	
    // create the window on the first click and reuse on subsequent clicks
    relationshipWin = new Ext.Window({
        layout:'fit',
        width:570,
        height:440,
//        closeAction:'hide',
        plain: true,
		title: _ServerValues.RelationshipEditor,
        items: instanceFramePanel,
		resizable: false,
        buttons: [{
            text: _ServerValues.OKLabel,
			disabled : true,
			id:'Okid',
			handler: valselected
        },{
            text: _ServerValues.CancelLabel,
            handler: function(){
                relationshipWin.close();
            }
        }]
    });
    relationshipWin.show(this);
	if(document.getElementById('relatedCIClass') != null || document.getElementById('relatedCIClass') != 'undefined'){
		if(document.getElementById('relatedCIClass').childNodes[0].childNodes[0] != null || document.getElementById('relatedCIClass').childNodes[0].childNodes[0] != 'undefined')
			document.getElementById('relatedCIClass').childNodes[0].childNodes[0].title = _ServerValues.TooltipRelatedCIClass;
	}

}

function deleteAction()
{
 	
 	Ext.MessageBox.confirm(_ServerValues.Delete, _ServerValues.ConfirmDeleteCIRelationship, 
        function(btn){
        
                if(btn.toUpperCase()=="YES")
                {
	                var elements=InRGrid.getSelectionModel().getSelections();
	                if(elements.length>0)
	                {
	                    var s = '';
	                   	var str='/apex/CMDBJsonGeneratorDML?type=deleteCIRelationships&InstanceIDs=';
	                   	for(i=0;i<elements.length; i++)
	                    {
	                        s+=elements[i].data.InstanceID+',';
	                    }
            		  deletecirelationships(s);
                        
	                }
            		
                }

            })
 	
 	
 	
}

function ExploreCIRelationship()
{
	var elements=InRGrid.getSelectionModel().getSelections();
    if(elements.length==1)
    {
        ShowCIRelationshipExplorer(elements[0].data.InstanceID);
    }
}



function getRelGridToolBar()
{
		var toolBarHeight=40;
	    var tb = new Ext.Toolbar({
	        border: false,
			autoWidth:true,
	        height: toolBarHeight,
	        items: [
						{
			                scale: 'medium',
			                iconCls: 'bmcNew',
			                tooltipType : 'title',
			                tooltip: _ServerValues.New, 
			                id:'newRelInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcNewOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcNew');          
			                    }
			                },
	                        handler:newAction
			            },
						{
			                scale: 'medium',
			                iconCls: 'bmcEditRelationship',
			                tooltipType : 'title',
			                tooltip: _ServerValues.Edit, 
			                id:'editInstanceBtn',
			                
			                listeners: {
			                    mouseover: function(){
			                        this.setIconClass('bmcEditRelationshipOn');    
			                    },
			                    mouseout: function(){
			                        this.setIconClass('bmcEditRelationship');          
			                    },
			                    disable: function(){
			                        this.setIconClass('bmcEditRelationshipDisable');    
			                    },
			                    enable: function(){
			                        this.setIconClass('bmcEditRelationship');          
			                    }
			                },
	                        handler:editAction
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
			                        this.setIconClass('bmcDeleteDisable');    
			                    },
			                    enable: function(){
			                        this.setIconClass('bmcDelete');          
			                    }
			                },
	                        handler:deleteAction
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
	                        handler:ExploreCIRelationship
			            }
	                ]
	    });
	
	    return tb;
}

function ChangeBtnStatus(){
	var elements=InRGrid.getSelectionModel().getSelections();
	if(_ServerValues.InstanceID==''|| isBRCreatable==false)
	{
		Ext.getCmp('newRelInstanceBtn').disable();
	}
	else
	{
		Ext.getCmp('newRelInstanceBtn').enable();
	}
	if(elements.length==1)
	{
		Ext.getCmp('ciExplorerBtn').enable();
		Ext.getCmp('editInstanceBtn').enable();
	}
	else
	{
		Ext.getCmp('ciExplorerBtn').disable();
		Ext.getCmp('editInstanceBtn').disable();
	}
	if(elements.length>0 && isBRDeletable==true)
	{
		Ext.getCmp('deleteInstanceBtn').enable();
	}
	else{
		Ext.getCmp('deleteInstanceBtn').disable();
	}
}


function renderChatterSection() {
	
		var ChatterPanel = new Ext.Panel({
            id:'chatterPanel',
            title: _ServerValues.ChatterFeedTitle,
            //renderTo: 'contentDiv',
			layout:'fit',
            //layoutConfig: {columns:2},
	        autoWidth:true,
			border:false,
			//contentEl:'ChatterFeedDiv'
     		items: new Ext.Panel({contentEl:'ChatterFeedDiv'})
         });
         
         return ChatterPanel;
				
}


function renderGrid() {
			
		
	    var relationGridPanel = new Ext.grid.GridPanel({
	        id: 'RGridPanel',
	        store: getRelationListStore(),
	        sm: new Ext.grid.RowSelectionModel({singleSelect:false}),
	        columns: [
	            { header: _ServerValues.CIName, width: 150, dataIndex: 'CIName', sortable: true },
	            { header: _ServerValues.CIClassId, width: 100,dataIndex: 'CIClassId', sortable: true },
	            { header: _ServerValues.CIRole, width: 150, dataIndex: 'CIRole', sortable: true },
				{header: _ServerValues.ImpactDirection, width: 150, dataIndex: 'ImpactDirection', sortable: true},
	            { id: 'rname',header: _ServerValues.RelationshipName, dataIndex: 'RelationshipName', sortable: true }
	            
	        ],
	        autoExpandColumn: 'rname',
	        viewConfig: {
	            forceFit: true
	            //, scrollOffset: 2
	        },
			enableHdMenu: false,
	        stripeRows: true,
	        border: false,
	        height: 265
	    });
	  	    
	    relationGridPanel.getSelectionModel().on('selectionchange', function(grd, row, e){
	    	ChangeBtnStatus();
	    });
	    
	    relationGridPanel.on('render', function(grd, row, e){
	    	ChangeBtnStatus();	
	    });
		
		relationGridPanel.on('rowdblclick', function(grd, row, e){
	    		editAction();
	    	});
		InRGrid=relationGridPanel;

	
		var Relationpanel = new Ext.Panel({
            id:'relationship',
            title: _ServerValues.RelationshipsTile,
            //renderTo: 'contentDiv',
			layout:'fit',
            //layoutConfig: {columns:2},
	        autoWidth:true,
			border:false,
			tbar: getRelGridToolBar(),//[newaction,Editaction,Deleteaction,CIaction],
     		items: relationGridPanel,
			listeners: {
				expand:function(){					
					Ext.getCmp('AccordionPanelId').setHeight(325);				
				},
				collapse:function(){
					Ext.getCmp('AccordionPanelId').setHeight(470);					
				}
			}
         });
         
         return Relationpanel;
				
}


/*-----------------*/


/* End of server rendered javascript */ 
var InstancesGrid;
var isSource= false;
var isDestination= true;
var strSourceInstanceID;
var strDestinationInstanceID;

function ExplorerItemClickHandler(recordID){
	getInstanceListStore(recordID);
	}

function getNameSpaceListStore () {
	    var strXML = _ServerValues.NamespaceListXML;
	    xmlObject = getXMLObjectFromString(strXML);
	
	    var dataStore = new Ext.data.XmlStore({
	        autoDestroy: false,
	        proxy: new Ext.data.MemoryProxy(xmlObject),
	        record: 'namespace',
	        idPath: 'Name',
	        fields: ['Name', 'DisplayName']
	    });
	    dataStore.load();
	
	    return dataStore;
	}
function getXMLObjectFromString (strXML) {
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
	}
	
function getClassListView (newHeight) {
	
		var cvstore = getClassViewStore();
        var tpl_img = new Ext.XTemplate(
	                    '<tpl for=".">',
	                    '<img class="thumb-img" src="'+CIFORCE_RES_PATH+'/images/ci/{Image}_32.png" width="20" height="20" >',
	                    '</tpl>'
	                ).compile();
	                
	
	    var listView = new Ext.grid.GridPanel({
	        hideHeaders: true,
	        store: cvstore,
	        autoScroll: true,
	        height: newHeight,
	        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	        columns: [
	            new Ext.grid.TemplateColumn({ tpl: tpl_img, width: 30, dataIndex: 'Image', tpl: tpl_img }),
	            { id: 'DisplayName', dataIndex: 'DisplayName' }
	            ],
	        autoExpandColumn: 'DisplayName',
	        viewConfig: {
	            forceFit: false
	        },
			listeners: {
			        viewready : function(grid) {
			            grid.getSelectionModel().selectFirstRow();
			            record = grid.getStore().getAt(0);
			        	ExplorerItemClickHandler(record.data.Name);
			        }
			    },
	        stripeRows: true,
	        border: false
	    });

	    listView.on('render', function() {
                    listView.tip = new Ext.ToolTip({
                    view: listView.getView(),
                    target: listView.getView().mainBody,
                    delegate: '.x-grid3-row',
                    trackMouse: true,
                    renderTo: document.body,
                    listeners: {
                        beforeshow: function updateTipBody(tip) {
                            tip.body.dom.innerHTML = _ServerValues.tooltipLableClass;
                        }
                    }
                   });
                });

	
	    listView.on('rowclick', 
	    	function(grd, rowIndex, e) {
			        record = grd.getStore().getAt(rowIndex);
			        ExplorerItemClickHandler(record.data.Name);
		    	}.createDelegate(this)	
	    	);
	    //added to fix bug 1450
	    listView.getSelectionModel().on('selectionchange', function(selModel, row, e){	    				
	    				record = selModel.getSelected();
	    				if(typeof(record)!='undefined')
	    				{
	    					this.ExplorerItemClickHandler(record.data.Name);
	    				}
	    	}.createDelegate(this));
	
		this.TypeListView = listView;
	    return listView;
	
	}
	
function getClassViewStore () {
	    var json = _ServerValues.ClassViewListJSON;
	    //json = [{ Name: "myname", DisplayName: "DispName", Image: "img" }, { Name: "myname", DisplayName: "DispName", Image: "img"}];
	    json = eval(json);
	
	    var dataStore = new Ext.data.JsonStore({
	        proxy: new Ext.data.MemoryProxy(json),
	        idProperty: 'Name',
	        fields: ['Name', 'DisplayName', 'Image'],
		sortInfo: { field: "DisplayName", direction: "ASC" }
	    });
	
		 
	    dataStore.load();
	
	    return dataStore;
	}
	
	function valselected()
	{
		if (InstancesGrid.getSelectionModel().getSelections()==null)
		{
			alert('Please Select Row as Source/Destination');
			return ;
		}
		var elements=InstancesGrid.getSelectionModel().getSelections();
		if (!isSource)
		{
			
			strSourceInstanceID=_ServerValues.InstanceID;
			strDestinationInstanceID=elements[0].data.InstanceID;
		}
		else
		{
			strDestinationInstanceID=_ServerValues.InstanceID;
			strSourceInstanceID=elements[0].data.InstanceID;
		}
		relationshipWin.close();
	
	 	var url = "/apex/CMDBEditRelationship?srcInstanceID="+strSourceInstanceID + "&destInstanceID="+strDestinationInstanceID; 
		showRelationshipEditor(url, null);
		
		// Change the values to default.
		isSource= false;
		isDestination= true;

	}
	
	function RNewChangeBtnStatus()
	{
		var elements=InstancesGrid.getSelectionModel().getSelections();
		if(elements.length==1)
		{
			Ext.getCmp('Okid').enable();
			
		}
		else
		{
			Ext.getCmp('Okid').disable();
			
		}
		
		
	}


function SIComp(iframesrc)
{
 document.getElementById('SIIframeID').style.display = 'none';                          
 document.getElementById('SIIframeID').src= iframesrc;
 document.getElementById('onDemandSITableId').style.display = 'none';
 document.getElementById('SIIframeID').style.display = "";  
}



this.Paging_PageNumber=1;

function GoToNextPage()
{
	//this.SetPointerRecords();
	this.PageMoveDirection ='NEXT';
	this.Paging_PageNumber++;
	this.getInstanceListStore();
}

function GoToPreviousPage()
{
	//this.SetPointerRecords();
	this.PageMoveDirection = 'PREVIOUS';
	this.Paging_PageNumber--;
	if(this.Paging_PageNumber<1) this.Paging_PageNumber=1;
	this.getInstanceListStore();
}
var sortdirection='ASC';
var sortfield='Name';

function getInstanceListStore (ClassName) {
	if(typeof(ClassName)=='undefined') {
		if(typeof(this.RelClassName)!='undefined') {
			ClassName = this.RelClassName;
		}
	}
			
	this.RelClassName = ClassName;
	
	var sURL = '/apex/CMDBJSONGenerator?type=instancelistfornewcirelationship&ClassName='+ClassName+'&InstanceID='+_ServerValues.InstanceID+'&PageNumber='+this.Paging_PageNumber+'&sortdirection='+this.sortdirection+'&sortfield='+this.sortfield;
	var dataStore = new Ext.data.JsonStore({
		url: sURL,
		root:'data',
		idPath: 'InstanceID',
		fields: ['InstanceID', 'Name', 'Description', 'Dataset'],
		sortInfo: {
			field: sortfield,
			direction: sortdirection
		}
	});

	dataStore.load();
	dataStore.on('load', function(){
				InstancesGrid.reconfigure(dataStore, InstancesGrid.colModel);
				
				try{
					this.enableDisablePagingButtons();
				}catch(e){}
			}.createDelegate(this)
		 );
	return dataStore;
}	
	

function enableDisablePagingButtons()
{
	
	if(InstancesGrid.store.reader.jsonData.hasPrevious) Ext.getCmp('PreviousPageButton').enable();
	else Ext.getCmp('PreviousPageButton').disable();

	if(InstancesGrid.store.reader.jsonData.hasNext) Ext.getCmp('NextPageButton').enable();
	else Ext.getCmp('NextPageButton').disable();
	
	this.Paging_PageNumber = this.InstancesGrid.store.reader.jsonData.pageNumber;
}

function RelationshipNewOnReady() {
		this.RelClassName = '';
		this.Paging_PageNumber=1;
		var tb = new Ext.Toolbar({
	        border: false,
	        autoWidth:true,
	        items: [
						'->',
						tbarOptions
	                ]
	    });
           		 
	 var ComboBox = new Ext.form.ComboBox({
		  	width: 200,
	        fieldLabel: _ServerValues.NameSpaceDropdownLabel,
	        store: getNameSpaceListStore(),
	        typeAhead: true,
	        mode: 'local',
	        valueField: 'Name',
	        displayField: 'DisplayName',
	        triggerAction: 'all',
	        editable: false,
	        forceSelection: true
	        //applyTo: 'contentDiv'
	    });
	     var ComboBox1 = new Ext.form.ComboBox({
		  	width: 200,
	      
	        typeAhead: true,
	        mode: 'local',
	        valueField: 'Name',
	        displayField: 'DisplayName',
	        triggerAction: 'all',
	        editable: false,
	        forceSelection: true
	      
	    });
	    
	    ComboBox.value = _ServerValues.DefaultInstanceDropDownValue;
	    var explorerHeight = 275;
	    var ClassListView = getClassListView(explorerHeight);
	    
	    var xmlGridPanel = new Ext.grid.GridPanel({
	        id: 'XMLGridPanel',
	        store: getInstanceListStore(),
	        columns: [
	            { header: _ServerValues.Name, width: 100, dataIndex: 'Name', sortable: false },
	            { id: 'desc', header: _ServerValues.Description, dataIndex: 'Description', sortable: false },
	            { header: _ServerValues.InstanceIDLabel, width: 100, dataIndex: 'InstanceID', sortable: false }
	        ],
	        autoExpandColumn: 'desc',
	        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	        viewConfig: {
	            forceFit: true
	            //, scrollOffset: 2
	        },
			enableHdMenu: false,
	        stripeRows: true,
	        border: false,
			height: 250
	    });
	    xmlGridPanel.on('headerclick', function(xmlGridPanel, columnIndex,e ) { 
			sortfield = xmlGridPanel.getColumnModel().getDataIndex(columnIndex);
			sortdirection = xmlGridPanel.store.sortInfo.direction=='ASC'?'DESC':'ASC';
			Ext.getCmp("XMLGridPanel").view.store = getInstanceListStore();
			Ext.getCmp("XMLGridPanel").view.refresh();
		});	 
		
	      var labelCom1=new Ext.form.Label({
               text: _ServerValues.Namespace
           })
            var labelCom2=new Ext.form.Label({
               text: _ServerValues.Relationship
           })
		
	xmlGridPanel.on('render', function() {
                    xmlGridPanel.tip = new Ext.ToolTip({
                    view: xmlGridPanel.getView(),
                    target: xmlGridPanel.getView().mainBody,
                    delegate: '.x-grid3-row',
                    trackMouse: true,
                    renderTo: document.body,
                    listeners: {
                        beforeshow: function updateTipBody(tip) {
                            tip.body.dom.innerHTML = _ServerValues.tooltipLableCIInstance;
                        }
                    }
                   });
                });



                xmlGridPanel.on('rowdblclick', function(grd, row, e) {
                   setTimeout("valselected()", 500);
                   // valselected();
                } .createDelegate(this));
		
		xmlGridPanel.getSelectionModel().on('selectionchange', function(grd, row, e){
	    	RNewChangeBtnStatus();
	    });
	    
	    xmlGridPanel.on('render', function(grd, row, e){
	    	RNewChangeBtnStatus();	
	    });
		
		InstancesGrid=xmlGridPanel;
				
		var radioGroup = { border:false,
				        autoHeight: true,
				        items: [{
									xtype: 'radiogroup',
								    columns: 1,
						            border:false,
						            items: [
											{boxLabel: _ServerValues.RelatedAsSource, name: 'rb-col', inputValue: 1, handler: function(item, checked){isSource=checked}, listeners:{render:function(){Ext.QuickTips.register({target:this, text:_ServerValues.tooltipLableRelatedasSource});}}},
											{boxLabel: _ServerValues.RelatedAsDestination, name: 'rb-col', inputValue: 2, checked: true, handler: function(item, checked){isDestination=checked}, listeners:{render:function(){Ext.QuickTips.register({target:this, text:_ServerValues.tooltipLableRelatedasDestination});}}}
               
											 ]
								}]
     					};
	

	var panel = new Ext.Panel({
                id:'main-panel',
                //renderTo: 'contentDiv',
				layout:'table',
				autoWidth:true,
                layoutConfig: {columns:2},
				border:false,
                items:[{
						
						title: _ServerValues.RelatedCIClass,
						id:'relatedCIClass',
						items: ClassListView,
						width:150

					},{
						width:400,
						height:300,
						//colspan:3,
						items: new Ext.Panel({
										tbar:tb,
										items: xmlGridPanel
								}),
						title: _ServerValues.RelatedCIInstance

					},{
						
						colspan:2,
						border:false,
						height:10
						
						
					},{
						colspan:2,
						border:false,
						items: radioGroup
					}]
            });
            
    return panel;
				
}
