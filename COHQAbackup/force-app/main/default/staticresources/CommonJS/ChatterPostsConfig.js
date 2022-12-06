var ShowIncidentChatterPosts = false;
var chatterGroupsData = null;
var IncidentChatterPostsGridStore = null;


var classForCheckbox = 'checkboxClass';
		
function getInternetExplorerVersion() {
	var rv = -1; // Return value assumes failure.
	if (navigator.appName == 'Microsoft Internet Explorer') {
		var ua = navigator.userAgent;
		var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");

		if (re.exec(ua) != null)
			rv = parseFloat(RegExp.$1);
	}
	return rv;
}

var ver = getInternetExplorerVersion();

if (ver > -1) {
	if (ver >= 8.0){
		classForCheckbox = 'checkboxClass1';
	}        
}

function getIncidentChatterPostsData() {
	if(!ShowIncidentChatterPosts) return '';
	var ret_val='';
	var records = IncidentChatterPostsGridStore.getRange();
	var data =[]
	for(var i=0;i < records.length;i++) {
		data[i] = records[i].data;
	}
	ret_val = Ext.encode([{"enabled":IncidentChatterPostsGridData.enabled, "data":data}]); 
	return ret_val;
}

Ext.onReady(function() {

 
 if(ShowIncidentChatterPosts) {
	GroupBoxKeyPressed = function(e, priority_id){
		if(e.keyCode == Ext.EventObject.BACKSPACE || e.keyCode == Ext.EventObject.DELETE) {
			var rec = IncidentChatterPostsGridStore.getById(priority_id);
			rec.beginEdit()
			rec.set('groupid','');
			rec.set('groupname','');
			rec.endEdit();
		}
	}
	
	showChatterGroupsWindow=function(priority_id) {
		
		// create the data store
		var ChatterGroupsStore = new Ext.data.JsonStore({
			autoLoad: true,
			//root: 'data',
			idProperty: 'Id',
			fields: [
			   {name: 'Id'},
			   {name: 'Name'}
			 ],
			data: chatterGroupsData
		});
		var group_grid = new Ext.grid.GridPanel({
							store: ChatterGroupsStore,
							hideHeaders: true,
							autoScroll: true,
							viewConfig: {
								forceFit: true
							},
							columns: [
								{
									id       :'groupid',
									header   : '', 
									hidden : true,
									hideable: false,
									dataIndex: 'Id'
								},
								{
									header   : Labels.ChatterGroup, 
									width    : 300, 
									id       :'groupname',
									dataIndex: 'Name'
								}
							],
							stripeRows: true,
							autoExpandColumn: 'groupname',
							height: 260,
							title: ''
						});

		var win = new Ext.Window({
			height: 300,
			width: 500,
			title: Labels.PCG_SelectChatterGroup,
			items: group_grid
		});
		
		group_grid.getSelectionModel().on('selectionchange', function(selModel, row, e){
											record = selModel.getSelected();
											if(typeof(record)!='undefined')
											{
												var rec = IncidentChatterPostsGridStore.getById(priority_id);
												rec.beginEdit()
												rec.set('groupid',record.get('Id'));
												rec.set('groupname',record.get('Name'));
												rec.endEdit();
												win.close();
											}
										});
		win.show();
	}



	// create the data store
	IncidentChatterPostsGridStore = new Ext.data.JsonStore({
		autoLoad: true,
		root: 'data',
		idProperty: 'priorityid',
		fields: [
		   {name: 'priorityid'},
		   {name: 'priorityname'},
		   {name: 'impact'},
		   {name: 'urgency'},
		   {name: 'groupid'},
		   {name: 'groupname'}
		 ],
		data: IncidentChatterPostsGridData
	});
	
	var tpl_groupColumn= new Ext.XTemplate(
				 '<tpl for=".">',
					'<table style="width: 99%"><tr>',
					'<td width="270px"><input style="width: 98%" readonly="readonly" onkeypress="return GroupBoxKeyPressed(event,\'{priorityid}\')" class= "clsInputTextBox" type="text" value="{groupname}" /></td>',
					'<td width="22px"><img src="'+sdef_styles_path+'/SDEFbuttons/b_pick.gif" onclick="showChatterGroupsWindow(\'{priorityid}\');" style="width: 20px; height: 20px;" /></td>',
					'</tr></table>',
				 '</tpl>'
			 ).compile();

	function priorityRenderer(data, metadata, record, rowIndex, columnIndex, store) {
		var ret_val = '<div style="padding-top:4px">'+ data+'</div>';
		if(data < 6) {
			ret_val = '<img src="'+sdef_styles_path+'/SDEFimages/priority'+data+'-16.gif" style="width: 16px; height: 16px; padding-top:3px" />';
		}
		return ret_val;
	}
	
	var IncidentChatterPostsGrid = new Ext.grid.GridPanel({
		id: 'IncidentChatterPostsGrid',
		store: IncidentChatterPostsGridStore,
		columns: [
			{
				id       :'priorityid',
				header   : '', 
				hidden : true,
				hideable: false,
				dataIndex: 'priorityid'
			},
			{
				id       :'groupid',
				header   : '', 
				hidden : true,
				hideable: false,
				dataIndex: 'groupid'
			},
			{
				header   : Labels.PriorityWindowHeaderSearchPage, 
				width    : 80, 
				align	 : 'right',
				dataIndex: 'priorityname',
				hideable: false,
				renderer: priorityRenderer
			},
			{
				header   : Labels.ImpactWindowHeaderSearchPage, 
				width    : 80, 
				hidden : true,
				hideable: false,
				dataIndex: 'impact'
			},
			{
				header   : Labels.UrgencyWindowHeaderSearchPage, 
				width    : 80, 
				hidden : true,
				hideable: false,
				dataIndex: 'urgency'
			},
			new Ext.grid.TemplateColumn({ 
				header   : Labels.ChatterGroup, 
				tpl: tpl_groupColumn, 
				hideable: false,
				width: 280, 
				dataIndex: 'groupname',
				id: 'groupname'
			 })
		],
		stripeRows: true,
		autoExpandColumn: 'groupname',
		height: 500,
		width: 600,
		title: ''
	});

	var IncidentChatterPostsCheckbox = new Ext.form.Checkbox({
		 id:'IncidentChatterPostsChk',
		 cls:classForCheckbox ,
		 boxLabel: Labels.PCG_EnableFeature,
		 checked: IncidentChatterPostsGridData.enabled,
		 handler: function() {
			IncidentChatterPostsGridData.enabled = this.getValue();
		 }
	});
	
	var IncidentChatterPostsPanel = new Ext.Panel({
		id: 'IncidentChatterPostsPanel',
		border:false,
		renderTo: 'contentDiv',
		items:[IncidentChatterPostsCheckbox, IncidentChatterPostsGrid]
	});
  }
});

function Save() {
	saveToServer(getIncidentChatterPostsData());
}