var accLeftStoreData;
var accRightStoreData;

var leftStore;
var rightStore;
    

function radioAllAccounts() {
	hasAccounts = true;
	isGridDisabled = true;
	csvAccountListparam = 'AllAccounts';
	var abc = Ext.getCmp('abc');
	abc.getEl().mask();
	var tlbr = Ext.getCmp('paginationToolbar');
	tlbr.getEl().mask();	
}
function radioSelectedAccounts(){
	csvAccountListparam = '';
	var abc = Ext.getCmp('abc');
	abc.getEl().unmask(); 
	var tlbr = Ext.getCmp('paginationToolbar');
	tlbr.getEl().unmask();
}

function onSaveClick()
{
    var array = rightStore.data;
    var listData = [];
    var param = '';
    var tempArr1='';
    var tempArr;
    var resulset;
    for(i=0;i < array.length;i++){
        tempArr = new Array(2);
        tempArr[1] = rightStore.getAt(i).get('elID');
        param = param + rightStore.getAt(i).get('elID');
        if(i < array.length-1){
            param = param + ',';
            tempArr1 =tempArr1 +'\n';
        }
        
    }
    if(orgNamespace != '' && orgNamespace != null && orgNamespace != 'undefined' && orgNamespace != 'null'){
            eval(orgNamespace).UpdateAccountBranding.UpdAccountBranding(param,themeid, function(result, event){
                if(event.status) {
              		if(result != '' && result != null){
                        resulset = result;
                         Ext.Msg.alert('', resulset[1]);
                        
                      }                     
                } else if (event.type === 'exception') {    
             
                    Ext.Msg.alert('', event.message);
                }           
            }, {escape:true});      
        } else {
            UpdateAccountBranding.UpdAccountBranding(param,themeid, function(result, event){
                if(event.status) {
                    if(result != '' && result != null){
                        resulset = result;
						Ext.Msg.alert('', resulset[1]);
                        
                      }                     
                } else if (event.type === 'exception') {  
                
                    Ext.Msg.alert('', event.message);
                }           
            }, {escape:true});
        } 
}
function onOKClick() {

    if(isForAllAccount == 'true' && csvAccountListparam.toLowerCase() == 'allaccounts')
    {
            if(getUrlParameter('stdForm')){
            
            window.opener.openAccountSelector(rightStore,true);
            window.close();
            }
            else
            window.parent.setPopUpVar(rightStore, true);
    }
    else{
         if(getUrlParameter('stdForm')){
           
            window.opener.openAccountSelector(rightStore);
            window.close();
            }
            else
        window.parent.setPopUpVar(rightStore);
    }
   
   window.parent.closePopup();
}

function onCancelClick() {
	if(getUrlParameter('stdForm')){
		window.close();
	}else
	window.parent.closePopup();
}
function refreshAccountsList(){
	var j;
	var searchstring = document.getElementById('txtSrch').value;
	j=parseInt(searchstring.length-1);
	if(searchstring[j] == '*')
	{
		searchstring = searchstring.replace('*','');
		document.getElementById('txtSrch').value = searchstring;
	}
	searchstring = searchstring.replace('\'','');
	
	if(searchstring==labelSrch){//2>searchstring.length || 
		searchstring = '';
	}
	var rightData = '';
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightStore').store;
	while(selectedAccStore.data.length > count) {
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('elID')+'\','
		count++;
	}	
	//alert('###########searchstring'+searchstring);
	//alert('###########rightData'+rightData);
	var resetPageNumber = false;
	getSearchAccounts(searchstring,rightData,resetPageNumber);
}
var displayMessageBox = false;
function msgbox(msg, title, icon){
    var msgIcon = Ext.MessageBox.INFO;//Default
    if(title==null) title='';
    if(icon==3){
        msgIcon = Ext.MessageBox.QUESTION;
        if(title=='') title=labelQuestion ;
    }else if(icon==2){
        msgIcon = Ext.MessageBox.WARNING;
        if(title=='') title=labelWarning ;
    }else if(icon==1){
        msgIcon = Ext.MessageBox.ERROR;
        if(title=='') title=labelError ;
    }
    if(title=='') title=labelInfo ;
    Ext.MessageBox.show({
       title: title,
       msg: msg,
       width:300,
       buttons: Ext.MessageBox.OK,
       //fn: clkHandler,
       icon: msgIcon
   });
}
function loadLeftData(){
	Ext.getCmp('accBtnPrevId').setDisabled(getPreFirstBtn());
	Ext.getCmp('accBtnNextId').setDisabled(getNextLastBtn());
	
		tempAccLeftStore = new Ext.data.ArrayStore({
            data: accLeftStoreData,
            fields: ['elID','Name','display'],
            sortInfo: { 
                field: 'Name',
                direction: 'ASC'
            }
		});
	
		leftStore.removeAll();
		var totalCount = tempAccLeftStore.getTotalCount();		
		if(totalCount == 0)
		{    						
			if(displayMessageBox == true){
				msgbox(labelNoRecord , '', 2);
				resetSearch();
			}		
		}
		else
		{
			for(var i=0;i<tempAccLeftStore.getTotalCount();i++){
				leftStore.add(tempAccLeftStore.getAt(i));				
			}		
		}	
	displayMessageBox = false;	
}
function blurfun() {
	checkforsearch = false;
	if(document.getElementById('txtSrch').value.trim().length == 0)
	{		
		checkforsearch = true;
	}
}

function txtSearch(){ 
	var j;
	var searchstring = document.getElementById('txtSrch').value;
	j=parseInt(searchstring.length-1);
	
	if(searchstring[j] == '*')
	{
		searchstring = searchstring.replace('*','');
		document.getElementById('txtSrch').value = searchstring;
	}
	
	
	//searchstring = searchstring.replace('\\','\\\\');
	searchstring = searchstring.replace('\'','');
	document.getElementById('txtSrch').value = searchstring;	
	blurfun();	
	if(checkforsearch)
	{    
		if(searchstring==labelSrch){//2>searchstring.length || 
			msgbox(labelMinChar , '', 2);
			return;
		}
		checkforsearch = false;
	}
	else
	{
		if(searchstring==labelSrch){//2>searchstring.length || 
			//msgbox(labelMinChar , '', 2);
			return;
		}
	
	}	
	var rightData = '';
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightStore').store;
	while(selectedAccStore.data.length > count) {		
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('elID')+'\','
		count++;
	}	
	displayMessageBox = true;
	var resetPageNumber = true;
	getSearchAccounts(searchstring,rightData,resetPageNumber);	
}
var PrevBtnHandler = function (button,event) { 	
	
	if(document.getElementById('accBtnPrevId').disabled!=true){
		
		var rightData = '';
		var count = 0;
		var selectedAccStore = Ext.getCmp('rightStore').store;
		while(selectedAccStore.data.length > count) {
			rightData = rightData + '\''+selectedAccStore.getAt(count).get('elID')+'\','
			count++;
		}			
		prevAccounts(rightData);
	} 
}
var NextBtnHandler1 = function (button,event) {  
	
	if(document.getElementById('accBtnNextId').disabled!=true){
		
		var rightData = '';
		var count = 0;
		var selectedAccStore = Ext.getCmp('rightStore').store;
		while(selectedAccStore.data.length > count) {
			rightData = rightData + '\''+selectedAccStore.getAt(count).get('elID')+'\','
			count++;
		}			
		nextAccounts(rightData);
	} 
}
function resetSearch(){
	var searchstring = '';
	var rightData = '';	
	var count = 0;
	var selectedAccStore = Ext.getCmp('rightStore').store;
	while(selectedAccStore.data.length > count) {
		rightData = rightData + '\''+selectedAccStore.getAt(count).get('elID')+'\','
		count++;
	}
	var resetPageNumber = true;
	getSearchAccounts(searchstring,rightData,resetPageNumber);
	document.getElementById('txtSrch').value = labelSrch;
}
Ext.onReady(function() { 
//alert('accRightStoreData========'+ accRightStoreData);
//alert('accLeftStoreData=========='+ accLeftStoreData); 

var toolBar= new Ext.Toolbar({
        renderTo: 'toolbar',
        cls:'toolSpCls',
		id:'paginationToolbar', 
		bodyStyle: 'padding-left:15px;padding-bottom:10px;width:200px;',	
		width: 200,
        items: [
                {
                    scale: 'medium',
                    xtype: 'textfield',
                    tooltipType : 'title',
					emptyText: labelSrch ,
					width:80,
                    id:'txtSrch' ,
					listeners: {
						specialkey: function(field, e){
							// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
							// e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
							if (e.getKey() == e.ENTER) {
									txtSearch();
							}
						}
					}
                   
                },'',
				{
					iconCls: 'bmcSearch', 
					tooltip:  labelSrch, 
					tooltipType: 'title',
					id:'searchBtn',
					handler: txtSearch										
				},
                {
                    scale: 'medium',
                    iconCls: 'bmcResetOn',
					tooltip: labelRefresh,
                    tooltipType : 'title',
                    id:'accBtnResetId',
					handler: resetSearch
				
                },'->',
				{
					xtype : 'box',
					id    : 'accBtnPrevId',
					disabled:getPreFirstBtn(),
					autoEl:  {tag: 'img', 
							  src:(getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif') , 
							  title: labelPrevious
							 },
							  
					cls:'cursorCls',
					listeners : { render: function(f){f.el.on('click', PrevBtnHandler);}}
					
								 
				},{
				   
					xtype : 'box',
					id    : 'accBtnNextId', 
					disabled:getNextLastBtn(),
					autoEl:  {tag: 'img', 
							  src: getSDFStylesResPath() + '/SDEFbuttons/b_next.gif',
							  title: labelNext 
							 },
					  cls:'cursorSpaceCls'  ,
					  listeners : { render: function(f){f.el.on('click', NextBtnHandler1)}}
					  
				}
        ]
    });

leftStore = new Ext.data.ArrayStore({
		data:accLeftStoreData,			
		fields: ['elID','Name','display'],
		sortInfo: {
			field: 'Name',
			direction: 'ASC'
		}
});
rightStore = new Ext.data.ArrayStore({
		data: accRightStoreData,
		fields: ['elID','Name','display']
});	
var listView = {
	id:'abc',
	xtype: 'itemselector',
	name: 'itemselector',
	fieldLabel: '',
	iconLeft:'b_darrow_L_disable_custom.gif',
	iconRight:'b_darrow_R_disable_custom.gif',
	imagePath: getSDFStylesResPath() +'/SDEFbuttons/',
	drawTopIcon:false,
	drawBotIcon:false,
	drawUpIcon:false,
	drawDownIcon:false,
	width: 490,
	bodyStyle: 'padding-left:5px;padding-bottom:10px;',
	listeners: {
		change: function(){                                   
			refreshAccountsList();
		}
	},
	multiselects: [{
		id: 'leftStore',
		width: 202,
		height: 400,
		cls:'itemselectorCls',
		draggable: false,
		droppable: false,
		store: leftStore,
		displayField: 'display',									
        valueField: 'elID',		
		multiSelect : true,		
		legend: labelAvailableAccounts,
		listeners: {
			render: function(multi) {
				new Ext.ToolTip({
					target: multi.el,
					renderTo: document.body,
					delegate: 'dl',
					trackMouse: true,
					anchor: 'right',
					listeners: {
						beforeshow: function(tip) {
							var rec = multi.view.getRecord(tip.triggerElement);
							tip.body.dom.innerHTML =rec.get('Name');
						}
					}
				});
			},
	        click:function(c){
              		document.getElementById('iconRightId').src = getSDFStylesResPath() +'/SDEFbuttons/b_darrow_R_new.gif';
              		if(this.view.getSelectedIndexes().length == 0)
              		document.getElementById('iconLeftId').src = getSDFStylesResPath() +'/SDEFbuttons/b_darrow_L_disable_custom.gif';
            }
		}
	},{
		id: 'rightStore',
		width: 202,
		height: 400,  
		cls:'itemselectorCls',
		draggable: false,
		droppable: false,
		store: rightStore,
		displayField: 'display',									
        valueField: 'elID',
		multiSelect : true,
		legend: labelSelectedAccounts,
		listeners: {
			render: function(multi) {
				new Ext.ToolTip({
					target: multi.el,
					renderTo: document.body,
					delegate: 'dl',
					trackMouse: true,
					anchor: 'right',
					listeners: {
						beforeshow: function(tip) {
							var rec = multi.view.getRecord(tip.triggerElement);
							tip.body.dom.innerHTML =rec.get('Name');
						}
					}
				});
			},
            click:function(c){
              		if(this.view.getSelectedIndexes().length == 0)
              			document.getElementById('iconRightId').src = getSDFStylesResPath() +'/SDEFbuttons/b_darrow_R_disable_custom.gif';
              		document.getElementById('iconLeftId').src = getSDFStylesResPath() +'/SDEFbuttons/b_darrow_L_new.gif';
            }
		}
	}]
}; 

var panel = new Ext.Panel({
	items: [ listView ],
	border:false,
	unstyled: true,
	height:'auto',
	layout:'fit',
	renderTo: 'listView'
});

	if(isForAllAccount =='true'){
		if(window.parent.csvAccountListparam == null || window.parent.csvAccountListparam == ''|| window.parent.csvAccountListparam.toLowerCase() == 'allaccounts'){
		    document.getElementById('selectRadio:0').checked= true;
			radioAllAccounts();
		}else{
			document.getElementById('selectRadio:1').checked= true;
			radioSelectedAccounts();
		}
	}	
});