var recordString;
var bDeferEmptyTxt = true;
function sendRecordasString(grid,rowIndex,obj){
sendRecord(); 
}
function sendRecord(){
	waitMsg.show();
	var recordData = grid.getSelectionModel().getSelected().data;
	var recordString = JSON.stringify(recordData);
	document.getElementById(recorDataInputHiddenId).value = recordString;
	importLinkCI();
}
Ext.onReady(function(){
 	waitbox(1);
	var srchTxtFld = new Ext.form.TextField({
	    id: 'txtSrch',
	    name: 'txtSrch',
	    fieldLabel: lblSearch,
	    width: '350',
	    allowBlank: true,
	    emptyText: lblSearch,
		style:{align: 'left'},
		listeners: {
	                    specialkey: function(field, e){
	                        if (e.getKey() == e.ENTER){
	                        	DoSearch(0);
	                        }
	                    }
					}
		});
	var adTipBox=new Ext.BoxComponent({
                	xtype : 'box',
                	autoEl: {tag: 'img', src:sInfoPath}, 
                	id:'advanceSearch',
                	listeners:{
                		render: function(c){
                			c.getEl().on('mouseover', function(){
                				if(advtooltip){
                					advtooltip.show();
                				}                				
	                        });
							c.getEl().on('mouseout', function(){
                				if(advtooltip){
                					advtooltip.hide();
                				}                				
	                        });
                		}
                	}
                });
				
	var advtooltip = new Ext.QuickTip({
					target: 'advanceSearch',
					anchor: 'bottom',
					width:Ext.isIE ? Ext.isIE7 ? 365:355:368,
					trackMouse: false,
					bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
					hideDelay:3000,
					dismissDelay: 0,
					html: lblSearchTip,
					autoHide: true
				 });
	
 
	var toolBar= new Ext.Toolbar({
				title: '',
	           cls:'toolSpCls',
	           renderTo: 'toolBar',
	           bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
		 items: [
			' ',
			new Ext.Toolbar.Fill(),' ',
			adTipBox,'  ',
			srchTxtFld,' ',
			{scale: 'medium', iconCls: 'bmcSearch',  tooltip: lblSearch, tooltipType: 'title', id:'searchBtn', handler: btnSearch },' ',
			{scale: 'medium', iconCls: 'bmcRefresh', tooltip: lblReset, tooltipType: 'title', id:'refreshbtn', style:{align: 'left'},handler: pageRefresh},' ',
			{xtype : 'box', autoEl:  {tag: 'img', src:sPrevPath, title:lblPrevious }, cls:'cursorCls',id:'prevId',disabled:true,listeners : { render: function(f){f.el.on('click', PreviousBtnHandler)}}				}, ' ',
			{xtype : 'box', autoEl:  {tag: 'img', src:sNextPath, title:lblNext }, id:'nextId',cls:'cursorSpaceCls', listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}				}
		]
	});
	
	
	var reader = new Ext.data.ArrayReader({}, [
					{name: grdFields[0]},
					{name: grdFields[1]},
					{name: grdFields[3]},
					{name: grdFields[2]},
					{name: grdFields[4]},
					{name: grdFields[5]},
					{name: grdFields[6]},
					{name: grdFields[7]},
					{name: grdFields[8]},
					{name: grdFields[9]},
					{name: grdFields[10]}
					
                ]);
	
	store = new Ext.data.GroupingStore({
            data: objSearch,	
 		    reader: reader
        });
	function addLink(data, metadata, record, rowIndex, columnIndex, store){
		return '<a onclick="sendRecord()">'+data+'</a>';
	}
		
	document.getElementById("txtSrch").value = searchKeyword;
	if(document.getElementById("txtSrch").value != '')
		bDeferEmptyTxt = false;
		
     grid = new Ext.grid.GridPanel({
     			id: 'maindatagrid',
                store: store,
                 columns: [
							{header: grdHeaders[0], width: 7,  dataIndex: grdFields[4], id: grdFields[4],renderer:addLink},
							{header: grdHeaders[7], width: 10,  dataIndex: grdFields[2], id: grdFields[2]},
							{header: grdHeaders[6], width: 17,  dataIndex: grdFields[1], id: grdFields[1]},
							{header: grdHeaders[1], width: 22,  dataIndex: grdFields[6], id: grdFields[6]},
							{header: grdHeaders[2], width: 20,  dataIndex: grdFields[5], id: grdFields[5]},
							{header: grdHeaders[3], width: 9,  dataIndex: grdFields[8], id: grdFields[8]},
							{header: grdHeaders[4], width: 12,  dataIndex: grdFields[7], id: grdFields[7]},
                            {header: grdHeaders[5], width: 15,  dataIndex: grdFields[9], id: grdFields[9]},
                            
                            {header: grdHeaders[0], width: 7,  dataIndex: grdFields[0], id: grdFields[0],hidden:true},
                            {header: grdHeaders[0], width: 7,  dataIndex: grdFields[1], id: grdFields[1],hidden:true}
                          ],
                stripeRows: true,
				autoExpandColumn: grdFields[3],
                enableHdMenu:false,
                height: 500,
                autoWidth: true,
				border: false,
				layout: 'fit',
				listeners :{rowdblclick:sendRecordasString},
				viewConfig:{forceFit:true,scrollOffset:0,emptyText:noRecordmsg,deferEmptyText: bDeferEmptyTxt }
                
             });
			 
       srchTxtFld.focus(true);    
	   
       store.on('load', function() {
			grid.render('gridPanel');
	});
	
			
    BindGrid();
    
    
	
	directConnectHandler();
	
	Ext.EventManager.onWindowResize(function(){
		Resize();
	});

});
	
	function getNextPrevState(bPrevious)
	{
	    if(bPrevious) { 
	        if(hasPrevious == 'true' || hasPrevious) { 
	            return false; 
	        } 
	        else 
	            return true; 
	    }else { 
	        if (hasNext == 'true' || hasNext) { 
	            return false; 
	        } 
	        else 
	            return true;     
	    }
	}

	function BindGrid()
	{
		waitMsg.hide();
		if(msgString!='')
			{
				Ext.MessageBox.show({
			       title: lblErrorSearch,
			       msg: msgString,
			       width:300,
			       buttons: Ext.MessageBox.OK,
			       icon:  Ext.MessageBox.ERROR
			   });
			   return;
			}
		
		if((objSearch!=null) && (iSearchLoad == '1'))
		{
			store.loadData(objSearch);
			grid.getColumnModel().setColumnHeader(0, grdHeaders[0]);	//Type
			grid.getColumnModel().setColumnHeader(1, grdHeaders[7]);	//Device Name
			grid.getColumnModel().setColumnHeader(2, grdHeaders[6]);	//User
			grid.getColumnModel().setColumnHeader(3, grdHeaders[1]);	//Serial Number
			grid.getColumnModel().setColumnHeader(4, grdHeaders[2]);	// Operating System
			grid.getColumnModel().setColumnHeader(5, grdHeaders[3]);	// IP Address
			grid.getColumnModel().setColumnHeader(6, grdHeaders[4]);	// MAC Address
			grid.getColumnModel().setColumnHeader(7, grdHeaders[5]);	//Domain
		}
		Ext.getCmp('prevId').setDisabled(getNextPrevState(true));
		Ext.getCmp('nextId').setDisabled(getNextPrevState(false)); 
	}
	
	function DoSearch(sPgNo)
	{	if(isFPUserValidated)
		{
			waitMsg.show();
			var searchstring = document.getElementById("txtSrch").value;
			searchstring = searchstring.replace("\"","");
			document.getElementById("txtSrch").value = searchstring;
			
			if((2>searchstring.trim().length) || (searchstring == lblSearch))
			{
				Ext.MessageBox.show({
				   title: lblwarningSearch,
				   msg: lblValidationMsg,
				   width:300,
				   buttons: Ext.MessageBox.OK,
				   icon:  Ext.MessageBox.WARNING
			   });
				
				waitMsg.hide()
				return;
			}
			CDoSearch(searchstring, sPgNo);
		}
		else
			directConnectHandler();
	}
	
	function pageRefresh()
	{
		if(isFPUserValidated)
		{
			waitMsg.show();
			document.getElementById("txtSrch").value='';
			document.getElementById("txtSrch").focus();
			CDoSearch('', 0);
		}
		else
			directConnectHandler();
		
	}
	function btnSearch()
	{
		DoSearch(0);
	}
 	function NextBtnHandler()
 	{
	if(isFPUserValidated)
		{
			if(hasNext=='true' || hasNext)
			{
			waitMsg.show();
			NextClick(cPgNo);
			}
		}
		else
			directConnectHandler();
 	}
 	function PreviousBtnHandler()
 	{
 		if(isFPUserValidated)
		{
			if(hasPrevious=='true' || hasPrevious)
			{
			waitMsg.show();
			PrevClick(cPgNo);
			}
		else
			directConnectHandler();
		}
	}

function directConnectHandler(){
	if(isFPUserValidated==false){
		openPopupWithTitle('ACFPUserCredentialPage',executeConnectAction,ACFPLaunchWindowHeader,225,475);
		popUpWindow.center();
	}
}
function executeConnectAction(validated){
	if(validated != null && validated){
		isFPUserValidated=true;
	}
}
	
