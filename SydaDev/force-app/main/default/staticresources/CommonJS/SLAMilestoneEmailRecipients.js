var activeElement='',
recipientOncompleteFunction;
Ext.onReady(function(){
enableToCcbutton();

  var toolbar = new Ext.Toolbar({
    renderTo:'toolbarDiv',
    height:39,
    cls:'toolSpCls',
    items:[
                   {text:selectFromLabel,
                    xtype:'label'           
                   },
            
                    {
                        id:'involvedUsersRadio',
                        xtype:'radio',
                        fieldLabel:'Involved Users',
                        inputtype:'radio',
                        name:'users',
                        checked:true,
                        boxLabel:involvdeUsersRadioLabel,
                        handler:function(){
                                if(this.checked){
                                    document.getElementById('allUsersDiv').style.display = 'none';
                                    document.getElementById('involvedUsersGridDiv').style.display ='block';
                                
                                }   
                        }
                    },' ',
                    {
                        id:'allUsersRadio',
                        xtype:'radio',
                        fieldLabel:'All Users',
                        inputtype:'radio',
                        name:'users',
                        boxLabel:allUsersRadioLabel,
                        handler:function(){
                                if(this.checked){
                                    document.getElementById('involvedUsersGridDiv').style.display ='none';
                                    /*if(isLoaded == false){
                                        document.getElementById('allUsersIframeId').src= "/apex/SearchPage?popupId=Client&view=list&pgheight=600&wid=1";
                                        isLoaded = true;
                                    }*/
                                    document.getElementById('allUsersDiv').style.display = 'block';
                                    document.getElementById('allUsersDiv').innerHTML='<iframe id="allUsersIframeId" name="allUsersIframe" frameborder="0" scrolling="no" src ="/apex/SearchPage?popupId=Client&pgheight=600&wid=1&disableFirstColLink=true&&isActiveFilterReq=true&filterClause='+escape('isActive = true')+'" style="width:100%;height:100%;border:none;"/>';
                                }   
                        }
                    
                    }
           ]
  
  });
var involvedColumnModel = new Ext.grid.ColumnModel([
                                {header:userRoleLabel, width:180, dataIndex:"userRole", sortable: false},
                                {header:lastNameLabel, width:150,dataIndex:"lastName", sortable: false},
                                {header:firstNameLabel, width:150, dataIndex:"firstName", sortable: false},
                                {header:emailAddressLabel, width:255,dataIndex:'emailAddress', sortable: false}
                                ]
                             );
var involvedUsersStore = new Ext.data.JsonStore({
                                id:'involvedUserStoreId',
                                data:involvedUsersStoreData,
                                root:'involvedUsersRoot',
                                sortInfo: {
								    field: 'userRole',
								    direction: 'ASC' // or 'DESC' (case sensitive for local sorting)
								},
                                fields:["userRole","lastName","firstName","emailAddress","userRoleAPIName"]
                            
                            });                             
var involvedUsersGrid= new Ext.grid.GridPanel({
                                id:'involvedUsersGridPanelId',
                                cm:involvedColumnModel,
                                store:involvedUsersStore,
                                cls:'CommonGrid',
                                stripeRows:true,
                                enableHdMenu :false,
                                columnLines: true,
                                viewConfig:{
									forceFit:true,
									scrollOffset:0
								 },
                                height:362,
                                width:740,
                                listeners :{rowdblclick: populateSelectedRole}

                            });
involvedUsersGrid.render('involvedUsersGridDiv');
chkSizeOfTOCC(toTextAreaDomId);
chkSizeOfTOCC(ccTextAreaDomId);
recipientWindow = window.parent.popUpWindow;
recipientOncompleteFunction = window.parent.onCompleteFunction;
});

function populateSelectedUser(grid,rowIndex,obj){
	if(activeElement != null && activeElement != undefined && activeElement == 'to' ){
	 	document.getElementById(toTextAreaDomId).value = document.getElementById(toTextAreaDomId).value + frames['allUsersIframe'].grid.store.getAt(rowIndex).get('Email')+'; ';
	}else if(activeElement != null && activeElement != undefined && activeElement == 'cc'){
	 	document.getElementById(ccTextAreaDomId).value = document.getElementById(ccTextAreaDomId).value + frames['allUsersIframe'].grid.store.getAt(rowIndex).get('Email')+'; ';
	}
}

/*on row double click of involved users the value will be populated in To or CC field based on the focus*/
function populateSelectedRole(grid,rowIndex,obj){
	if(activeElement != null && activeElement != undefined && activeElement == 'to' ){
	 	document.getElementById(toTextAreaDomId).value = document.getElementById(toTextAreaDomId).value + grid.store.getAt(rowIndex).get('userRole')+'; ';
	}else if(activeElement != null && activeElement != undefined && activeElement == 'cc'){
	 	document.getElementById(ccTextAreaDomId).value = document.getElementById(ccTextAreaDomId).value + grid.store.getAt(rowIndex).get('userRole')+'; ';
	}
}
/* On click of to button populate add the selected rows to the To Address*/
function populateToAddress(){
    activeElement = 'to';
        var records;
    if(document.getElementById('involvedUsersGridDiv').style.display=='block'){
        records = Ext.getCmp('involvedUsersGridPanelId').getSelectionModel().getSelections();
        addInvolvedUserstoAddressFields(records, toTextAreaDomId);
    }else if(document.getElementById('allUsersDiv').style.display=='block'){
        records = frames['allUsersIframe'].grid.getSelectionModel().getSelections();
        addAllUserstoAddressFields(records, toTextAreaDomId);
    }
}
/* On click of to button populate add the selected rows to the CC Address*/
function populateccAddress(){
	activeElement = 'cc';
    var records;
    if(document.getElementById('involvedUsersGridDiv').style.display=='block'){
        records = Ext.getCmp('involvedUsersGridPanelId').getSelectionModel().getSelections();
        addInvolvedUserstoAddressFields(records, ccTextAreaDomId);
    }else if(document.getElementById('allUsersDiv').style.display=='block'){
        records = frames['allUsersIframe'].grid.getSelectionModel().getSelections();
        addAllUserstoAddressFields(records, ccTextAreaDomId);
    }
}  
/*To add user email addresss to the TO or CC from allusers Grid*/
function addAllUserstoAddressFields(SelectedRecords, textFieldId){
    var address = document.getElementById(textFieldId).value;
    for(var i=0; i < SelectedRecords.length; i++){
        address = address + SelectedRecords[i].get('Email')+';';
        frames['allUsersIframe'].grid.getSelectionModel().clearSelections();    
    }
    document.getElementById(textFieldId).value = address;
	if(address.length >120){
    	document.getElementById(textFieldId).style.height = '35px';
    }else{
    	document.getElementById(textFieldId).style.height = '16px';
    }
}  
/*function to populate the involved Users selection model in TO or CC text*/
function addInvolvedUserstoAddressFields(SelectedRecords, textFieldId){
    var address = document.getElementById(textFieldId).value;
    for(var i=0; i < SelectedRecords.length; i++){
        address = address + SelectedRecords[i].get('userRole')+';';
        Ext.getCmp('involvedUsersGridPanelId').getSelectionModel().clearSelections();       
    }
    document.getElementById(textFieldId).value = address;
    if(address.length >120){
    	document.getElementById(textFieldId).style.height = '35px';
    }else{
    	document.getElementById(textFieldId).style.height = '16px';
    }
}
/* To check the text size of TO text area size for handling its height.*/
function chkSize(textFieldId){
		var textAreaSize = textFieldId.value.length;
		if(textAreaSize > 120){
			textFieldId.style.height = '35px';
		}else{
			textFieldId.style.height = '16px';
		}
}
function chkSizeOfTOCC(textField){
		var textAreaSize = document.getElementById(textField).value.length;
		if(textAreaSize > 120){
			document.getElementById(textField).style.height = '35px';
		}else{
			document.getElementById(textField).style.height = '16px';
		} 
}
/*function to enable/disable To and CC Field*/ 
function enableToCcbutton(){
 var toAddress = window.parent.toEmailRecipientAddress.trim();
 var ccAddress = window.parent.ccEmailRecipientAddress.trim();
 if(toAddress!=undefined && toAddress!=null && toAddress!=''&& toAddress.charAt(toAddress.length-1)!=';'){
    	toAddress = toAddress + ';';
 }
 if(ccAddress!=undefined && ccAddress!=null &&ccAddress!=''&& ccAddress.charAt(ccAddress.length-1)!=';'){
 	ccAddress = ccAddress + ';';
 }
document.getElementById(toTextAreaDomId).value = toAddress;
document.getElementById(ccTextAreaDomId).value = ccAddress;
 if(enabledButtonParam=='to'){
    	document.getElementById(toTextAreaDomId).focus();
    	activeElement = 'to';
    	
 }else if(enabledButtonParam=='cc'){
   	document.getElementById(ccTextAreaDomId).focus();
   	activeElement = 'cc';
 }
}
function sendAddressValue(){
	var toAndCc = document.getElementById(toTextAreaDomId).value + DZHE + document.getElementById(ccTextAreaDomId).value
	window.parent.setOnCompleteFunction(recipientOncompleteFunction);
	window.parent.setPopUpVar(toAndCc);
	recipientWindow.close();
} 
/* cancel button closes the window*/
function cancelRecipients(){	
   	recipientWindow.close();
}
/*Search Page expects this function to be on parent page. Overridden with dummy function*/
function changeTitle(wid, newTitle,winTitle){
    
}
function activateWindow(){

}
function addTab(){

}
/*end of overrides*/