
var storeindex , cIndex, uncheckIndex;
var gridData= [];
var grid;
var cols = new Array(2);  
cols[0]='displayValue'; 
cols[1]='storedValue';
var DeleteBtnHandler = function(button,event) { deleteData();};

function setData(){
         store.removeAll();
         Ext.getCmp('grid').getView().refresh();
		 store.loadData(getListData());
         
         Ext.getCmp('grid').getView().refresh();
     }
        /*For Display grid*/
    function showTable(){
    
    	var reader = new Ext.data.ArrayReader({}, cols);
	    store = new Ext.data.Store({
	        reader: reader, data: gridData
	    });
         function renderTooltip(value, metaData, record, rowIndex, colIndex, store) { 
		    var dataArray = getListData();
       		var str =dataArray[rowIndex][colIndex];
       		if(str.indexOf('"') != -1){
       			str=str.replace(new RegExp('"','g'),'&#34;');
       		}
       		if(str.indexOf("'") != -1){
       			str=str.replace("'","&#39;");
       		}
       	   metaData.attr = 'title="'+str+'"';
           return value;     
   		 } 
     		
   		 var toolBar= new Ext.Toolbar({
	        cls:'toolSpCls',
			id:'SLToolbar',
	        items: [{
               scale: 'medium',
               iconCls: 'bmcDeleteSLTDisable',
               tooltipType : 'title',                   
	   		   tooltip :'Delete',
	           id:'btnRemove' ,
	           handler:DeleteBtnHandler
	         }]
    	 });
		    
	     var cboxSelModel =new Ext.grid.CheckboxSelectionModel({
				checkOnly : true,
				width:100,
				header: defaultVal, 
				id: 'test',
				locked: true,
				singleSelect: true,
				listeners: {
					rowselect: function (sm, rIndex, keepExisting, record) {            
					    uncheckIndex = -1;
			           	cIndex =rIndex; 
			           	updateDefaultValue();
			     	},
					rowdeselect: function (sm, rIndex, keepExisting, record) {            
						cIndex = -1;
			           	uncheckIndex =rIndex;
			           	updateDefaultValue();
			     	}
			 	}
	     });
			
		 var cm = new Ext.grid.ColumnModel({
		    columns: [
		        {   id:'FieldLabel',
                    header: FulfillmentInputDisplayedValue, 
                    width:100, 
                    sortable: true, 
                    dataIndex: cols[0]},
		        {   header: FulfillmentInputStoredValue,  
                    renderer: renderTooltip, 
                    id:'ValueField',
                    width:100, 
                    sortable: true, 
                    dataIndex: cols[1]},
		       		cboxSelModel
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
		        sm: cboxSelModel,
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
		                  var record = grid.store.getAt(a);
		                  var dValue=record.get('displayValue');
		                  var sValue=record.get('storedValue');
						  var dataArray = getListData();
		                  sValue=dataArray[a][1];
		                  document.getElementById(InputPageComp.ComponentVars.storedValue).value=sValue;
		                  document.getElementById(InputPageComp.ComponentVars.displayValue).value=dValue;
		                  document.getElementById('addbtn_id').style['display']= 'none'; 
		                  document.getElementById('updatebtn_id').style['display']= 'block'; 
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
			var dataArray = getListData();
		    for (var i = 0; i < dataArray.length; i++) {        
		       if(dataArray[i][2]== 'true'){
		            grid.getSelectionModel().selectRow(i, true);
		       }
		    }
		}
	function hideUnhidePanel(){
		document.getElementById('addbtn_id').style['display']= 'block'; 
        document.getElementById('updatebtn_id').style['display']= 'none';
		document.getElementById(InputPageComp.ComponentVars.inputStoredValue).value='';
		document.getElementById(InputPageComp.ComponentVars.inputDisplayValue).value='';
        var str=document.getElementById(InputPageComp.ComponentVars.responseType).value;
		if(str.toLowerCase()=='radio button' || str.toLowerCase()=='picklist'){
			document.getElementById('rediodetaildiv').style['display']= 'block';
			Ext.getCmp('grid').setVisible(true); 
			document.getElementById(InputPageComp.ComponentVars.referenceType).style['display']= 'none'; 
			if(str.toLowerCase()=='radio button') {
			   document.getElementById(InputPageComp.ComponentVars.radioInputSection).style['display']= 'block'; 
			   document.getElementById(InputPageComp.ComponentVars.picklistInputSection).style['display']= 'none';
			} else {
				document.getElementById(InputPageComp.ComponentVars.picklistInputSection).style['display']= 'block'; 
				document.getElementById(InputPageComp.ComponentVars.radioInputSection).style['display']= 'none';
			}
			Ext.getCmp('btnRemove').setDisabled(true);
			Ext.getCmp('btnRemove').setIconClass('bmcDeleteSLTDisable');
			setData();
		}else{
			document.getElementById('rediodetaildiv').style['display']= 'none'; 
			Ext.getCmp('grid').hide(); 
			if(str.toLowerCase()=='lookup' ){
				document.getElementById(InputPageComp.ComponentVars.referenceType).style['display']= 'block';
			}else{
				document.getElementById(InputPageComp.ComponentVars.referenceType).style['display']= 'none';
				if(str.toLowerCase()=='check box' || str.toLowerCase() == 'header section'){
					document.getElementById(InputPageComp.ComponentVars.requiredInput).disabled=true;
					document.getElementById(InputPageComp.ComponentVars.requiredInput).checked = false;
				}else{
					document.getElementById(InputPageComp.ComponentVars.requiredInput).disabled=false;
			}
			}
			
			if(str.toLowerCase() == 'header section'){
				document.getElementById(InputPageComp.ComponentVars.hiddenInput).checked = false;
				document.getElementById(InputPageComp.ComponentVars.hiddenInput).disabled = true;
			}else{
				document.getElementById(InputPageComp.ComponentVars.hiddenInput).disabled = false;
			}
		
		}
	}
	function handleResponseTypeChange(element){
		hideUnhidePanel();
	
	}
	function addDataJs(){
		var inputvalueArray = new Array(3);
		var dValue = document.getElementById(InputPageComp.ComponentVars.displayValue).value;
		var sValue = document.getElementById(InputPageComp.ComponentVars.storedValue).value;
		if(dValue == null || dValue == ''){
			showMsg(FulfillmentInputDisplayedValueValidationMsg);
			return;
		}
		if(sValue == null || sValue == ''){
			showMsg(FulfillmentInputStoredValueValidationMsg);
			return;
		}
        inputvalueArray[0]=document.getElementById(InputPageComp.ComponentVars.displayValue).value;
        inputvalueArray[1]=document.getElementById(InputPageComp.ComponentVars.storedValue).value;
        inputvalueArray[2]='false';
		if(isPicklistInput()) {
		    picklistData.push(inputvalueArray);
		} else {
        listData.push(inputvalueArray);
		}
		setData();
		document.getElementById(InputPageComp.ComponentVars.storedValue).value='';
        document.getElementById(InputPageComp.ComponentVars.displayValue).value='';
		setSelectedRows();
		setTimeout("", 1000);
	}
	function updateDefaultValue(){
		var inputvalueArray = new Array(3);
		var tempLstData = getListData();
		if(isPicklistInput()) 
			picklistData=[];
		else 
		listData=[];
		for(var i=0; i<tempLstData.length ; i++){
			inputvalueArray = tempLstData[i];
			if(i == cIndex)
				inputvalueArray[2] = 'true';
			else
				inputvalueArray[2] = 'false';
			if(i == uncheckIndex) 
				inputvalueArray[2] = 'false';
			if(isPicklistInput()) {
				picklistData.push(inputvalueArray);
			} else {
			listData.push(inputvalueArray);
			}
		}
				
	}
	function updateData(){
			var inputvalueArray = new Array(3);
			if(isPicklistInput())
				inputvalueArray= picklistData[storeindex];
			else
			inputvalueArray= listData[storeindex];
	        inputvalueArray[0]=document.getElementById(InputPageComp.ComponentVars.displayValue).value;
	        inputvalueArray[1]=document.getElementById(InputPageComp.ComponentVars.storedValue).value;
			if(isPicklistInput())
				picklistData[storeindex] =inputvalueArray;
			else 
	        listData[storeindex] =inputvalueArray;
			setData();
			document.getElementById(InputPageComp.ComponentVars.storedValue).value='';
        	document.getElementById(InputPageComp.ComponentVars.displayValue).value='';
        	document.getElementById('addbtn_id').style['display']= 'block'; 
            document.getElementById('updatebtn_id').style['display']= 'none'; 
			setSelectedRows();
			setTimeout("", 1000);
	}
	function deleteData(){
	    if(isPicklistInput()) 
			var removed = picklistData.splice(storeindex,1);
		else 
		var removed = listData.splice(storeindex,1);
		setData();
		document.getElementById(InputPageComp.ComponentVars.storedValue).value='';
        document.getElementById(InputPageComp.ComponentVars.displayValue).value='';
        document.getElementById('addbtn_id').style['display']= 'block'; 
        document.getElementById('updatebtn_id').style['display']= 'none'; 
		setSelectedRows();
		setTimeout("", 1000);
		
	}
	function beforeSave(){
		if(isPicklistInput() || isRadioButtonInput()){
			var inputvalue = '';
			var dataArray = getListData();
			for(var i= 0; i< dataArray.length;i++){
				if(inputvalue !=null && inputvalue != '')
					inputvalue+= PE;
				inputvalue+= dataArray[i][0];
				inputvalue+= EF;
				inputvalue+= dataArray[i][1];
				inputvalue+= EF;
				inputvalue+= dataArray[i][2];
			}
			if(isPicklistInput()) {
			    if(dataArray.length == 0) {
					showMsg(fulfillmentInputEmptyPicklistValidationMsg);
					return;
				}
				document.getElementById(InputPageComp.ComponentVars.picklistValue).value =inputvalue ;	
			} else {
			document.getElementById(InputPageComp.ComponentVars.inputValue).value =inputvalue ;
		}
			
		}
		waitbox(0);
		save();
	}
	
	function createRedioStore(inputValue){
		if(inputValue != null && inputValue != '' ){
			if(inputValue.indexOf(PE) > -1){
				var strLst = inputValue.split(PE);
				if(strLst.length > 0){
					var i=0;
					while(i<strLst.length){
						var sLst = strLst[i].split(EF);
						if(sLst.length > 0){
							var inputvalueArray = new Array(3);
							inputvalueArray[0] = sLst[0];
							inputvalueArray[1] = sLst[1];
							inputvalueArray[2] = sLst[2];
							if(isPicklistInput())
								picklistData.push(inputvalueArray);
							else 
							listData.push(inputvalueArray);
						}
						
						i++;
					}
				}
			}else if(inputValue.length > 0){
				if(inputValue.indexOf(EF) > -1){
					var strLst = inputValue.split(EF);
					if(strLst.length > 0){
						
						var inputvalueArray = new Array(3);
						inputvalueArray[0] = strLst[0];
						inputvalueArray[1] = strLst[1];
						inputvalueArray[2] = strLst[2];
						if(isPicklistInput())
							picklistData.push(inputvalueArray);
						else 
						listData.push(inputvalueArray);
						
						i++;
						
					}
				}
			}
		}
	}
	
	function showMsg(msg){
		Ext.MessageBox.show({                       
			msg: msg,
			width:500,
			height:'auto',
			buttons: Ext.MessageBox.OK
		});
	}
	
	function setConditionStr( rValue){
		if(rValue != null ){
			document.getElementById(InputPageComp.ComponentVars.condition_id).value= rValue[0];
			window.parent.infixCondition =rValue[0];
			document.getElementById(InputPageComp.ComponentVars.conditionPostfix_id).value=rValue[1];
			window.parent.postfixCondition =rValue[1];
		}
	}

	function openConditionPage(){
		window.parent.openPopupWithTitle('FulfillmentInputConditionalPage?Id='+inputId+'&requestId='+reqId,setConditionStr,FulfillmentInputConditionHeader,450,660);
		window.parent.conditionWinObj=parent.popUpWindow;
	}
	var conditionInvokeHandler = function (){
		window.parent.openPopupWithTitle('ControllProcessPage?inputId='+inputId+'&requestId='+reqId,'',lblTitle,Ext.isIE7 ? 520:517,Ext.isIE7 ?608:600);
		window.parent.conditionWinObj=parent.popUpWindow;
	}

	function displayConditionLink(conditional, controlProcess){
		if(conditional.checked){
			document.getElementById("conditionalLink_id").style['display']= 'inline';
		}else{
			document.getElementById("conditionalLink_id").style['display']= 'none';
		}
	}

	function displayCPLink(controlProcess){
		if(controlProcess.checked){
			document.getElementById("ControlProcessLink").style['display']= 'inline';
		}else{
			document.getElementById("ControlProcessLink").style['display']= 'none';
		}
	}

	function enableDisableLink(inputId, conditional, cp){
		var str=document.getElementById(InputPageComp.ComponentVars.responseType).value;

		if(inputId != null && inputId != '' && str.toLowerCase() != 'header section'){
			document.getElementById(InputPageComp.ComponentVars.controlProcess).disabled =false;
			if(cp){
				document.getElementById('ControlProcessLink').style['display']= 'inline'; 
			}else{
				document.getElementById('ControlProcessLink').style['display']= 'none'; 
			}
		}else{
			document.getElementById(InputPageComp.ComponentVars.controlProcess).disabled =true;
			document.getElementById('ControlProcessLink').style['display']= 'none'; 
		}
		
		if(conditional){
			document.getElementById("conditionalLink_id").style['display']= 'inline';
		}else{
			document.getElementById("conditionalLink_id").style['display']= 'none';
		}
	
	}
	function clearParentVar(){
		window.parent.infixCondition ='';
		window.parent.postfixCondition = '';
	}
	function getResponseType() {
	    var inputResType = document.getElementById(InputPageComp.ComponentVars.responseType).value;
		return inputResType.toLowerCase();
	}
	function isPicklistInput() {
		return (getResponseType() == 'picklist');
	}
	function isRadioButtonInput() {
		return (getResponseType() == 'radio button');
	}
	
	function getListData() {
	    var gridPanelData = [];
		if(isPicklistInput()) {
			gridPanelData = picklistData;
		} else if(isRadioButtonInput()) {
			gridPanelData = listData;
		}
        return gridPanelData;
	}
	Ext.onReady(function(){
		setCProcessVisbility();
		if(inputId != null && inputId != '' ){
			updateWinTitle();
			if(rType.toLowerCase()=='radio button'){
				if(radioInputValues != null && radioInputValues != ''){
					createRedioStore(radioInputValues);
				}
			} else if(rType.toLowerCase()=='picklist'){
				if(picklistInputValues != null && picklistInputValues != ''){
					createRedioStore(picklistInputValues);
				}
			}
		}
		showTable();       
		setData();
		hideUnhidePanel();
		buttonValidator();
		window.parent.infixCondition ='';
		window.parent.postfixCondition = '';
	})
	
	function showErrorMsg(){
		var message = new Array();
		message= errorStr;
		if(message!=null && message !=''){
			Ext.MessageBox.show({                                
				title: ' ',
				msg:message ,
				width:300,
				buttons: Ext.MessageBox.OK,
				fn: function(){
					if(message == saveMessage && saveandNewClicked){
						saveandNewClicked= false;
						resetForm();
					}
				}
			});
		}
    }