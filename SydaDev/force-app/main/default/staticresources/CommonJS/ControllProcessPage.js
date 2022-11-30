
var storeindex , cIndex;
var record;
var gridData = [];
var grid;
var templategrid;
var valuegrid;

var cols = new Array(5);
cols[0]='processId'; 
cols[1]='templateId';
cols[2]='templateValue'; 
cols[3]='storedValue'; 
cols[4]='displayValue';

var valuecols = new Array(2);  
valuecols[0]='invokeValue'; 
valuecols[1]='storeValue';

var templatecols = new Array(2);
templatecols[0]='id';
templatecols[1]='templateValue';

var templateId;
var templateName;
var valueId;
var storeValueId;
	
var DeleteBtnHandler = function(button,event) { deleteData();};

function setData(){
         store.removeAll();
         Ext.getCmp('grid').getView().refresh();
         store.loadData(listData);
         Ext.getCmp('grid').getView().refresh();
     }
        /*For display invoke grid*/
    function showTable(){
    
    	var reader = new Ext.data.ArrayReader({}, cols);
	    store = new Ext.data.Store({
	        reader: reader, data: gridData
	    });
     		
   		 var toolBar= new Ext.Toolbar({
	        cls:'toolSpCls',
			id:'CPToolbar',
	        items: [{
               scale: 'medium',
               iconCls: 'bmcDeleteSLTDisable',
               tooltipType : 'title',                   
	   		   tooltip :lblDelete,
	           id:'btnRemove' ,
	           handler:DeleteBtnHandler
	         }]
    	 });
		 
		 var cm = new Ext.grid.ColumnModel({
		    columns: [
				{   hidden: true,
					dataIndex: cols[0]},
				{   hidden: true,
					dataIndex: cols[1]},
				{   id:'FieldLabel',
                    header: lblProcess, 
                    width:250, 
                    sortable: true, 
                    dataIndex: cols[2]},
		        {   hidden: true,
					dataIndex: cols[3]},
		        {   header: lblInvokeWhenValueIs,
                    id:'ValueField',
                    width:250, 
                    sortable: true, 
                    dataIndex: cols[4]}
		    		],defaults: {sortable: true, menuDisabled: true, width: 100}
		 });
		
         grid = new Ext.grid.GridPanel({
		        id:'grid',
		        width:'99%',
		        border:true,
		        store: store,
		        tbar: toolBar,
		        autoscroll: false,
		        height :'100px',
		        autoHeight :false,
		        cm :cm,
		        height:150,
		        layout: 'fit',
		        stateful: true,
		        stateId: 'grid',
		        autoScroll:true,
		        enableColumnResize : false,
		        enableColumnMove : false,
		        viewConfig:{
		            forceFit:true,
		            scrollOffset:0 
		        },
		        autoFitColumns: true,
		        listeners: {
		            afterrender: function() {
			         	setSelectedRows();
			      	},delay: 1000,
			        rowClick :function(grid,a,b){
		                  storeindex = a;
		                  record = grid.store.getAt(a);
		                  Ext.getCmp('btnRemove').setDisabled(false);
						  Ext.getCmp('btnRemove').setIconClass('bmcDeleteSLT');
		
		              }
		                
		         }        
         });
            grid.on('columnresize');
           	grid.render('extGridPanel');
    }
	
	function setSelectedRows(){
		    var selectedRecs="";        
		    var str = grid.getStore();
		    for (var i = 0; i < listData.length; i++) {        
		       if(listData[i][2]== 'true'){
		            grid.getSelectionModel().selectRow(i, true);
		       }
		    }
		}
	/* Add process record */
	function addDataJs(){
		for (var i = 0; i < listData.length; i++) {
		   if(listData[i][1] == templateId && listData[i][4] == valueId){
				showMsg(lblProcessMappingError);
				return;
		   }
		}
		var inputvalueArray = new Array(5);
		var tValue = templateName;
		var iValue = valueId;
		if(tValue == null || tValue == ''){
			showMsg(lblProcessTemplateSelectionError);
			return;
		}
		if(iValue == null || iValue == ''){
			showMsg(lblProcessFulfillmentValueSelectionError);
			return;
		}
		inputvalueArray[0]=null;
        inputvalueArray[1]=templateId;
		inputvalueArray[2]=tValue;
        inputvalueArray[3]=storeValueId;
		inputvalueArray[4]=iValue;
        listData.push(inputvalueArray);
		setData();
		setSelectedRows();
		setTimeout("", 1000);	
	}
	/* Delete process record */
	function deleteData(){
		var deleteProcessId = listData[storeindex][0];
		if (deleteProcessId != null) {
			var recordIds = document.getElementById(ControllProcessPageComp.ComponentVars.processId).value;
			if (recordIds == null || recordIds == '') 
				document.getElementById(ControllProcessPageComp.ComponentVars.processId).value = '\'' + deleteProcessId + '\'';
			else 
				document.getElementById(ControllProcessPageComp.ComponentVars.processId).value = recordIds + ',' + '\'' + deleteProcessId + '\'';
		}
		var removed = listData.splice(storeindex,1);		
		setData();
	}
	/* Save process control data */
	function beforeSave(){
		if (listData.length == 0 && (document.getElementById(ControllProcessPageComp.ComponentVars.processId).value == null || document.getElementById(ControllProcessPageComp.ComponentVars.processId).value == '')) {
			return;
		}
		waitbox(0);
		//if (listData.length > 0 && (document.getElementById(ControllProcessPageComp.ComponentVars.processId).value != null || document.getElementById(ControllProcessPageComp.ComponentVars.processId).value != '')) {
			var processRecords = '';
			for (var i = 0; i < listData.length; i++) {
				var tempData = '';
				if (listData[i][0] == null || listData[i][0] == '') {
					tempData += listData[i][1] + EF;
					tempData += listData[i][3] + EF;
					tempData += listData[i][4] + PE;
					processRecords += tempData;
				}
			}
			document.getElementById(ControllProcessPageComp.ComponentVars.recordsId).value = processRecords;
			saveProcessControll();
			document.getElementById(ControllProcessPageComp.ComponentVars.processId).value = null;
		//}
		waitMsg.hide();
		Ext.getCmp('btnRemove').setDisabled(true);
		Ext.getCmp('btnRemove').setIconClass('bmcDeleteSLTDisable');
		showMsg(lblSavedSuccessfully);
	}
	/* Pass Fulfillment input value and get it value array */
	function createRedioStore(inputValue, type){
		if(inputValue != null && inputValue != '' ){
            if(inputValue.indexOf(PE) > -1){
                var strLst = inputValue.split(PE);
                if(strLst.length > 0){
                    var i=0;
                    while(i<strLst.length){
                        var sLst = strLst[i].split(EF);
                        if(sLst.length > 0){
                            var inputvalueArray = new Array(2);
                            inputvalueArray[0] = sLst[0];
                            inputvalueArray[1] = sLst[1];
                            if (type == 'value')
                                valueData.push(inputvalueArray);
                            else if (type == 'control')
                                listData.push(inputvalueArray);
                        }
                        
                        i++;
                    }
                }
            }else if(inputValue.length > 0){
                if(inputValue.indexOf(EF) > -1){
                    var strLst = inputValue.split(EF);
                    if(strLst.length > 0){
                        
                        var inputvalueArray = new Array(2);
                        inputvalueArray[0] = strLst[0];
                        inputvalueArray[1] = strLst[1];
                        if (type == 'value')
                                valueData.push(inputvalueArray);
                            else if (type == 'control')
                                listData.push(inputvalueArray);
                        
                        i++;
                        
                    }
                }
            }
        }
    }
	/* Show warning/error message */
	function showMsg(msg){
		Ext.MessageBox.show({                       
			msg: msg,
			width:300,
			height:'auto',
			buttons: Ext.MessageBox.OK
		});
	}
	
	/*For display process grid*/
    function showTemplateTable(){
        var reader = new Ext.data.ArrayReader({}, templatecols);
        templatestore = new Ext.data.Store({
            reader: reader, data: templateData
        });
        
        var cmtemplate = new Ext.grid.ColumnModel({
            columns: [
                {   id:'FieldLabel',
                    header: lblSelectProcess, 
                    width:250, 
                    sortable: true, 
                    dataIndex: templatecols[1]}
                    ],defaults: {sortable: true, menuDisabled: true, width: 100}
         });
        var smtemplate = new Ext.grid.RowSelectionModel({singleSelect:true});
         templategrid = new Ext.grid.GridPanel({
                id:'templategrid',
                renderTo: 'templateData', 
                width:'99%',
                border:true,
                store: templatestore,
                autoscroll: false,
                autoHeight :false,
				sm:smtemplate,
                cm :cmtemplate,
                height:150,
                layout: 'fit',
                stateful: true,
                stateId: 'templategrid',
                enableColumnResize : false,
                enableColumnMove : false,
                viewConfig:{
                      forceFit:true,
                      scrollOffset:0 
                  },
                autoFitColumns: true,
                listeners: {
                    rowClick :function(grid,a,b){
                          var record = grid.store.getAt(a);
                          templateId = record.get('id');
						  templateName = record.get('templateValue');
                      }                     
                 }        
         });
    }
    
    function loadTemplateData() {
        templatestore.removeAll();
        Ext.getCmp('templategrid').getView().refresh();
        templatestore.loadData(templateData);
        Ext.getCmp('templategrid').getView().refresh();
    }
	    /*For value grid*/
    function showValueTable(){
    
        var reader = new Ext.data.ArrayReader({}, valuecols);
        valuestore = new Ext.data.Store({
            reader: reader, data: valueData
        });
            
         var cmvalue = new Ext.grid.ColumnModel({
            columns: [
                {   id:'FieldLabel',
                    header: lblValue, 
                    width:250, 
                    sortable: true, 
                    dataIndex: valuecols[0]}
                    ],defaults: {sortable: true, menuDisabled: true, width: 100}
         });
         var smvalue = new Ext.grid.RowSelectionModel({singleSelect:true});
         valuegrid = new Ext.grid.GridPanel({
                id:'valuegrid',
				renderTo: 'valueData', 
                width:'99%',
                border:true,
                store: valuestore,
                autoscroll: false,
                autoHeight :false,
				sm:smvalue,
                cm :cmvalue,
                height:150,
                layout: 'fit',
                stateful: true,
                stateId: 'valuegrid',
                enableColumnResize : false,
                enableColumnMove : false,
				viewConfig:{
                      forceFit:true,
                      scrollOffset:0 
                  },
                autoFitColumns: true,
                listeners: {
                    rowClick :function(grid,a,b){
                          var record = grid.store.getAt(a);
                          valueId = record.get('invokeValue');
						  storeValueId = record.get('storeValue');
                      } 
                 }        
         });
    }
	function loadInvokeValueData() {
		valuestore.removeAll();
        Ext.getCmp('valuegrid').getView().refresh();
        valuestore.loadData(valueData);
        Ext.getCmp('valuegrid').getView().refresh();		
    }