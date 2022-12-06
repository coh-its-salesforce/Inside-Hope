 var isAutocomplete;
  var taboutFlag=false;
// code by sumit.. to close window on  std form 
 function getUrlParameter( param ){
	param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
	var r1 = "[\\?&]"+param+"=([^&#]*)";
	var r2 = new RegExp( r1 );
	var r3 = r2.exec( window.location.href );
	if( r3 == null ){return ""}
	else {return r3[1]};
	}
// code by sumit.. End
  Ext.onReady(function(){
// code by sumit.. to set title of std form 
		if(getUrlParameter('stdForm')){
		document.title=title;
		}		
   // code by sumit.. End   
		if (!closeChangePage.Labels.isUpdateable) 
			Ext.MessageBox.show({ msg: closeChangePage.Labels.insufficentPrivilegeMsg, buttons: Ext.MessageBox.OK});   
			
        Ext.QuickTips.init();
 
        var isClosedByEmpty ='False';
        


        var OkBtnHandler = function(button,event) { 
        
    
            closeChange();
          
         };
       

        
          var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'closeBtnToolbar',
            defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'} 
        });
        
        new SamplePanel({
            title: '',
             cls:'toolCloseCls',
            bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
            tbar: [{
                scale: 'medium',
                iconCls: 'bmcSave',
				tooltipType : 'title',
                tooltip: closeChangePage.Labels.Save,
				disabled: !closeChangePage.Labels.isUpdateable,
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
	        //  to close window on  std form
            if(getUrlParameter('stdForm')){
                window.opener.location.href="/"+getChangeId();
                window.close();
               }
			//  End
			else{
				window.parent.setPopUpVar(getChangeId());
				window.parent.closePopup();
			}
                  	   
       }
                     
     }