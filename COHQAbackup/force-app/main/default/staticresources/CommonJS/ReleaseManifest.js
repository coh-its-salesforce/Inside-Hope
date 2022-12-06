var gridDataStore;
var statusList;
var grid = null;
var uniqueId = 0;
var statusComboId;     
var orderComboId;

function openWindow(recId){ 
	 window.open("/"+recId);
}

function closeWindow(){
	window.close();
}     

function waitbox(timeout){ 
	if(parseInt(timeout)>0) setTimeout("waitMsg.hide()", timeout);
	waitMsg = new Ext.Window({ 
		height:100, 
		width:200, 
		resizable:false, 
		closable : false, 
		header:false,
		frame:false, 
		modal:true,
		shadow :false, 
		items:[{ 
			xtype:'panel', 
			height:100, 
			width:200, 
			bodyStyle:'background-color:transparent;border:none;', 
			html: '<div align="center"><img src="' +  tabOutImg +  '"/></div>' 
		}] 
	}); 
	waitMsg.show();
}

function showMessage(apexmessage){
	if(apexmessage != ''){
		showErrorMessage(apexmessage);
	}else{
		showErrorMessage(savedSuccessfullyLabel);      
	}
	waitMsg.hide();            
}

function showErrorMessage(msg){
	alertMsg = Ext.Msg.show({
					msg: msg,
					buttons: Ext.Msg.OK,
					width: 300,       
					frame:false
				});
		return; 
}



Ext.onReady(function()
{ 
	Ext.QuickTips.init();
	eval(store);
	// create the data store
	gridDataStore = new Ext.data.ArrayStore({
		id 		: 'gridDataStore',
		fields	: [
			{name: 'releaseItem'},
			{name: 'itemId'},
			{name: 'description' },
			{name: 'status'  },
			{name: 'dueDate', type: 'date', dateFormat: 'Y-m-d H:i:s'},
			{name: 'priority'  },
			{name: 'assignedTo'},
			{name: 'releaseStatus'},
			{name: 'Order' , type:'int'},
			{name: 'releaseElementId'},
			{name: 'assignedToId'},
			{name: 'isDisabled'},
			{name: 'manifestId'},
			{name: 'hasAccessToRecord'}
		]
	});
	gridDataStore.loadData(wrappedmanifestList);
	
	
	//--------------------- Picklist value for Order ------------
	eval(orderNumStore);
	OrderNumber = new Ext.data.ArrayStore({
					id:'Orderid',
					fields:[
						{name:'DisplayOrderno'},
						{name:'OrderNum'}
					]
		});
	OrderNumber.loadData(order);
	
	 //--------------------- Picklist value for Status ------------
	eval(JSONStatusStore);
	statusList = new Ext.data.ArrayStore({
					id:'statusList',
					fields:[
						{name:'statusId'},
						{name:'statusName'}
					]
		});
	statusList.loadData(status);
	
	// ---------------- create combobox for status ---- 
	statusComboId = new Ext.form.ComboBox({  
			id              :'statusComboId',
			width           :85,
			fieldLabel      :'',
			store           :statusList,
			valueField      :'statusName',
			displayField    :'statusName',
			typeAhead       :true,
			mode            :'local',
			editable        :false,
			triggerAction   :'all',
			selectOnFocus   :true,
			emptyText		: '-',	
			focusClass 		:'x-grid3-col-Status-focus',
			autoShow		:true,
			autoLoad: true,
			listeners      : {
				load:function(){
					
					statusComboId.focus();
					
				}                    
			}
		});
		// ---------------- create combobox for order numbers ----
		orderComboId = new Ext.form.ComboBox({  
			id              :'OrderComboId',
			fieldLabel      :'',
			store           :OrderNumber,
			valueField      :'OrderNum',
			displayField    :'DisplayOrderno',
			typeAhead       :false,
			mode            :'local',
			editable        :false,
			triggerAction   :'all',
			forceSelection  :true,
			selectOnFocus   :true,
			lazyRender      :true,
			emptyText		: '-',
			listeners      : {
			}
		}); 
		
		 // -------------------- Create the Grid --------------
		grid = new Ext.grid.EditorGridPanel({
			store		: gridDataStore,
			id 	 		: 'manifestEditorGrid',	 
			columnLines	: true,
			clicksToEdit: true,
			layout		: 'fit',
			stripeRows	: true,
			height		: 420,
			autowidth	: true,
			frame		: false,
			enableHdMenu: false,
			sm			: new Ext.grid.RowSelectionModel(),
			columns: [
				{
					header   : releaseItemLabel,
					sortable : true,
					dataIndex: 'releaseItem'
				}, {
					header   : itemIdLabel,
					sortable : true,
					dataIndex: 'itemId',
					renderer : function(value, metaData, record, rowIndex, colIndex, store) {
									if(gridDataStore.getAt(rowIndex).get('status') != pendingCreationLabel && gridDataStore.getAt(rowIndex).get('hasAccessToRecord') == 'true'){
										var rec = gridDataStore.getAt(rowIndex).get('releaseElementId');
										var link = '<a href="#" onclick=openWindow("' +  rec + '"); >' + value +'</a>';
										return link;
									}
									return value;
							   }                            
				}, {
					header   : descriptionLabel,
					sortable : true,
					width    : 150,
					dataIndex: 'description'
				}, {
					header   : statusLabel,
					sortable : true,
					dataIndex: 'status'
				}, {
					header   : dueDateLabel,
					sortable : true,
					dataIndex: 'dueDate',
					renderer : Ext.util.Format.dateRenderer('m/d/Y H:i A')
				}, {
					header   : priorityLabel,
					sortable : true,
					width    : 60,
					dataIndex: 'priority'
				}, {
					header   : assignedToLabel,
					sortable : true,
					dataIndex: 'assignedTo',
					renderer : function(value, metaData, record, rowIndex, colIndex, store) {
									var rec = gridDataStore.getAt(rowIndex).get('assignedToId');
									var link;
									if(rec != 'null')
										link = '<a href="#" onclick=openWindow("' +  rec + '"); >' + value +'</a>';
									else
										link = '-';
									return link;
							   }    
				}, {
					id       :'Status',
					header   : releaseStatusLabel,
					sortable : true,
					dataIndex: 'releaseStatus',
					readOnly : true,
					editor	 : statusComboId
				}, {
					id       : 'OrderNo',
					sortable : true,
					dataIndex: 'Order',
					header   : orderLabel,
					width    : 50,
					readOnly : true,
					editor	 : orderComboId
				},{
					dataIndex: 'releaseElementId',
					hidden 	 : true
				},{
					dataIndex: 'assignedToId',
					hidden 	 : true
				},{
					dataIndex: 'isDisabled',
					hidden 	 : true
				}
			],
			viewConfig: {
				scrollOffset: 16,
				forceFit: true,
				stripeRows: true,
				emptyText: '<div style="width:auto; color:black; text-align:center; padding-top:160px; ">' + emptyText + '</div>',
				deferEmptyText: false
			},
			listeners: {
				beforeedit: function(e) {
									if(gridDataStore.getAt(e.row).get('isDisabled') != 'false')
									return false;
							   }   
			},
			plugins: [new Ext.ux.grid.ColumnHeaderGroup({
				rows: [
					[
						{},
						{header: itemDetailsLabel , colspan: 6, align: 'center', dataIndex: 'assignedTo'},
						{},
						{}
					]
				],
				hierarchicalColMenu: true			
			})],                    
			renderTo: 'manifestGrid'
		});
		refreshGrid();
		window.onresize = function(event) {
			refreshGrid();
		}
}); 
