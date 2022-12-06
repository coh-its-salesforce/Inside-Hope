var toolbarItem,
	actionInfoArr,
	hideDevSummaryMenu=false,
	imagePath ='',
	actionContext = '',
	isFPUserValidated=false,
	ACFPLaunchWindowHeader = '',
	reqContextId='',
	assemblyId='',
	renderedIn='',
	actionContextArr = ['ConfigSummary','RemoteControl','FileSystem','Registry','Events','Processes','Services','PerformAudit','FileTransfer','Ping','Reboot','Shutdown','WakeUp'],
	listViewLabel='',
	selectedRowAssemlyId = '',
	selectedrowCiId = '',
	actionsFetchedFor='',
	fromStdLayout=false,
	selectCIerr='',
	noActionsAvail='',
	acActionLabel='',
	acErrMsg='',
	deviceSummaryLabel='';
	
function getACMenu(){
	
	toolbarItem = new Ext.menu.Menu({
		id:'actionMenu',
		scale:'medium',
		iconCls: 'acAction',
		items: [],
		listeners:{
			show: function(menu){
				if(renderedIn==listViewLabel || renderedIn==instanceEditor){
					toolbarItem.removeAll(true);
					if(assemblyId != '' && reqContextId != ''){
						if(assemblyId.indexOf('AC:CS:-') == 0){
							if(isFPUserValidated){
								callGetActionsInfo(true);
							}else{
								openPopupWithTitle('ACFPUserCredentialPage',callGetActionsInfo,ACFPLaunchWindowHeader,Ext.isIE?240:228,495);
								popUpWindow.center();
							}
							
						}else{
							addNoActionsMenu();
						}
					}else if(assemblyId == '' && reqContextId != ''){
						addNoActionsMenu();
					}else{
						showAcErrMessage(selectCIerr);
					}
				}
			}
		}		
	});
	return toolbarItem;
}
function callGetActionsInfo(validated){
	if(validated != null && validated){
		isFPUserValidated=true;
		if(reqContextId != actionsFetchedFor || (actionInfoArr != null && typeof(actionInfoArr) != 'undefined' && actionInfoArr.length == 0)){
			waitbox(0);
			getActionInfoJSON(assemblyId);
		}else{
			setActionsState();
		}
	}
}
function addNoActionsMenu(){
	var actionMenuItem = new Ext.menu.Item({
		id:'noAcActionsMenu',
		icon:imagePath + '/SDEFimages/_.GIF',
		disabled:true,
		text:noActionsAvail
	});	
	toolbarItem.addItem(actionMenuItem);
}
function showAcErrMessage(acMsg){
	Ext.MessageBox.show({
	   width: 300,
	   title: errTitle,
	   msg: acMsg,
	   buttons: Ext.MessageBox.OK
   });
}
function addACMenuItems(){
	if(actionInfoArr != null && typeof(actionInfoArr) != 'undefined' && actionInfoArr.length != 0){
		for(var i = 0; i < actionContextArr.length ; i++){
			if(renderedIn==deviceSummaryLabel && actionContextArr[i] == 'ConfigSummary')
				continue;
			if((renderedIn==listViewLabel || renderedIn==instanceEditor) && (actionContextArr[i] == 'RemoteControl' || actionContextArr[i] == 'FileSystem' || actionContextArr[i] == 'PerformAudit' || actionContextArr[i] == 'Ping')){
				toolbarItem.addSeparator();
			}else if(renderedIn==deviceSummaryLabel && (actionContextArr[i] == 'FileSystem' || actionContextArr[i] == 'PerformAudit' || actionContextArr[i] == 'Ping')){
				toolbarItem.addSeparator();
			}	
			
			var actionMenuItem = new Ext.menu.Item({
				id:actionContextArr[i],
				icon:imagePath + '/SDEFimages/_.GIF',
				handler:function (){directConnectHandler(this)}
			});
			toolbarItem.addItem(actionMenuItem);
		}
	}
	}
function setActionsState(){
	if(actionInfoArr != null && typeof(actionInfoArr) != 'undefined' && actionInfoArr.length != 0){
		addACMenuItems();
		if((renderedIn==listViewLabel || renderedIn==instanceEditor) && acErrMsg == ''){
		actionsFetchedFor=reqContextId;
	}
		for(var i =0 ; i < actionInfoArr.length; i++){
			var actInfo = actionInfoArr[i];
			var action = actInfo.id;
			if(action == 'File Trnasfer'){
				action == 'FileTransfer';
			}
			var enabled=actInfo.isAvail;
			var label = actInfo.label;
			var menuItem = Ext.getCmp(action);
			if(menuItem != null && typeof(menuItem) != 'undefined' && menuItem != 'undefined'){
				//alert('action : ' + action + ' enabled : ' + enabled + ' typeof enabled : ' + typeof(enabled) + ' label : ' + label);
				if(enabled=='1'){
					menuItem.setDisabled(false);
				}else if(enabled=='0'){
					menuItem.setDisabled(true);
				}
				menuItem.setText(label);  
			}
		}
	}
}


function directConnectHandler(obj){
	actionContext = obj.id;
	if(isFPUserValidated){
		executeDirectConnectAction(true);
	}else{
		openPopupWithTitle('ACFPUserCredentialPage',executeDirectConnectAction,ACFPLaunchWindowHeader,Ext.isIE?240:228,495);
		popUpWindow.center();
	}
	
}
function executeDirectConnectAction(validated){
	if(validated != null && validated){
		isFPUserValidated=true;
		
		if(actionContext == 'ConfigSummary'){// For device summary page
			openPopupforAC('ACDeviceSummaryPage?assemblyId='+assemblyId+'&reqContextId='+reqContextId,null, deviceSummaryLabel , 700, 750);	
			acpopUpWindow.center(); 
		}else{
			if(reqContextId != ''){
	waitbox(10000);
				directConnectDevice(actionContext,assemblyId,reqContextId);	
			}	
		}
	}
}
