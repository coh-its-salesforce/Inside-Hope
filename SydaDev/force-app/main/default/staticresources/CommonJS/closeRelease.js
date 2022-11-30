var isAutocomplete;
var taboutFlag=false;
function getUrlParameter( param ) {
	param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
	var r1 = "[\\?&]"+param+"=([^&#]*)";
	var r2 = new RegExp( r1 );
	var r3 = r2.exec( window.location.href );
	if( r3 == null ){return ""}
	else {return r3[1]};
}
Ext.onReady(function(){
// Set title of std form 
	if(getUrlParameter('stdForm')){
		document.title=title;
	}		
// code End 

if (!isUpdateable) 
	Ext.MessageBox.show({ msg: insufficentPrivilegeMsg, buttons: Ext.MessageBox.OK});
    
Ext.QuickTips.init();
var isClosedByEmpty ='False';
var OkBtnHandler = function(button,event) { 
	closeRelease();
};
var SamplePanel = Ext.extend(Ext.Panel, {
	renderTo: 'closeBtnToolbar',
	defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'} 
});

new SamplePanel ({
	title: '',
	cls:'toolCloseCls',
	bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
	tbar: [{
		scale: 'medium',
		iconCls: 'bmcSave',
		tooltipType : 'title',
		tooltip: lblSave,//closeRelease.Labels.Save,
		disabled: !isUpdateable,
		handler:OkBtnHandler
		}]
	});
});
function disableSIMenues(){
	window.parent.frames.SIIframeID.disableAll();
}
function CloseWindow(){
	if(errormsg!=null && errormsg!=''){
		showError();
	}
	else{
		//  Close window on  std form
		if(getUrlParameter('stdForm')){
			window.opener.location.href="/"+getReleaseId();
			window.close();
		   }
		//  End
		else{
			window.parent.setPopUpVar(getReleaseId());
			window.parent.closePopup();
		}		   
	}                 
}