        var store,
	gridData = [],
    grid,
    store2,
    image,
    listData = [],
    i = 0;

function callNewPage(id) {
	window.parent.addNewTab("IncidentPage", LabelIncidents, "NavigatorPage?title="+labelBroadcastWindowHeaderSearchPage+"&target=IncidentPage?portletTemplateId=" + id + "%26columnField=Name%26direction=ASC");
}
Ext.onReady(function() {
	Ext.QuickTips.init();
	showTable();
	setData();
	var id;
	 var rec = grid.store.getAt(0);
	 if(rec != null)
	 {
		id = rec.get('ab');
		
	 }
});
function showTable() {

	store = new Ext.data.ArrayStore({
		fields: [{
			name: 'Image'
		},{
			name: 'Id'
		},{
			name: 'ab'
		}],
		data: gridData
	});
	grid = new Ext.grid.GridPanel({
		cls:'Widgetcls',
		renderTo: 'extGridPanel',
		id: 'grid',
		store: store,
		columns: [{
			header: 'Priority',
			renderer: renderIcon,
			width: 30,
			
			sortable: true,
			dataIndex: 'Image'
		},{
			header: 'Message',
			id: 'Description',
			width: 230,
			height: 2,
			sortable: true,
			dataIndex: 'Id'
		}],
		stripeRows: false,
		layout: 'fit',
		stateful: true,
		height:117,
		header:false,
		stateId: 'grid',
		autoScroll:false,
		viewConfig: {
			forceFit: true,
			scrollOffset: 0
		},
		autoFitColumns: true,
		listeners: {
			headerclick : function(grid, columnIndex,e ) {if(columnIndex == '0') handleColumnClick(columnIndex+'');},
			rowClick: function(grid, rowIndex, e) {
				var rec = grid.store.getAt(rowIndex);
				var id = rec.get('ab');
				callNewPage(id,rec.get('Id'));
			},
			 afterrender: function() {
		  grid.getSelectionModel().selectRow(0, true);
	 }, delay: 1000
		}

	});
}
function setDataJS(listData){
	if(store!= null && typeof(store) != 'undefined'){
		store.removeAll();
		store.loadData(listData);
	}
}