        var errormsg;        
		var blackoutId;
        var blackoutSDate;
        var blackoutEDate;
        var taboutFlag = false;
        var isAutocomplete = false;
		var isBlackoutCreatable;
		var isBlackoutDeletable;
		var duration=0,
		clickedOnce = false;	
		document.onclick = activateWindow; 
        function callCopyPage(){
            window.parent.addTab("BlackOutPage?copyid=" + getblackoutId(),BlackoutPage.Labels.Blackoutheader,BlackoutPage.Labels.Blackoutheader);          			
        }
        
        var blackoutIdSet;
        
        function changeMenuHandler(){
			var psoID=getblackoutId();
			if(psoID == null || psoID == ''){
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
				Ext.getCmp('copyId').setDisabled(true);
				Ext.getCmp('resetId').setDisabled(true);            
				Ext.getCmp('prevId').setDisabled(true);
				Ext.getCmp('nextId').setDisabled(true); 				
				if(isBlackoutCreatable != null &&  isBlackoutCreatable == false){
					Ext.getCmp('newId').setDisabled(true);
					Ext.getCmp('saveId').setDisabled(true);
				}
			}else{
				Ext.getCmp('deleteId').setDisabled(false);
				Ext.getCmp('deleteId').setIconClass('bmcDelete');
				Ext.getCmp('copyId').setDisabled(false);
				Ext.getCmp('resetId').setDisabled(false);            
								
				if(isBlackoutCreatable != null &&  isBlackoutCreatable == false){
					Ext.getCmp('newId').setDisabled(false);
					Ext.getCmp('saveId').setDisabled(false);
				}				
			}
        
        }

        function previousBlackoutBtnHandler1(){
            var idSetString='';
            var i=0;
           
            while(blackoutIdSet.length > i){
                if(idSetString==''){
                    idSetString=blackoutIdSet[i];
                }else{
                    idSetString=idSetString+','+blackoutIdSet[i];
                }
                i++;
            }             
            previousBlackoutBtnHandler(idSetString);
        
        }

        
        function nextBlackoutBtnHandler1(){
            var idSetString='';
            var i=0;
            while(blackoutIdSet.length > i){
                if(idSetString==''){
                    idSetString=blackoutIdSet[i];
                }else{
                    idSetString=idSetString+','+blackoutIdSet[i];
                }
                i++;
            }
            nextBlackoutBtnHandler(idSetString);        
        }

        function closeWindow(){                                  
                window.parent.refreshList();
                window.parent.closeTab(getWID());
        }
              
        function updateList(){             
            window.parent.refreshList();
        }
            
        function updateTitle(){          
                var newTitle= getName(); 				
				if (newTitle!='' && newTitle!=null){
					window.parent.changeTitle(getWID(),newTitle,BlackoutPage.Labels.Blackoutheader);
				}
        }
        function handleSave(){
               var id = getblackoutId(); 
				if(!isPopup)
               window.parent.handleSave(getWID(),getId());
        }
		
		function getSave(){
			var chkBoxValue=false;
			chkBoxValue=Ext.getCmp('idInactive').getValue();
			Ext.getCmp('saveId').setDisabled(true);
			waitbox(0);	
			save(chkBoxValue);
		}
		
		function getTextlengthFilter(){
            var psoDescription = document.getElementById(BlackoutPageComp.ComponentVars.ProjectedServiceOutageDescription).value;
            var psoName = document.getElementById(BlackoutPageComp.ComponentVars.ProjectedServiceOutageName).value;            
            if(psoDescription.length <= 255){
               getSave(); 
            }else{
                if(psoDescription.length > 255){
                    Ext.MessageBox.show({msg: getDescriptionLabel() + ' : ' + BlackoutPage.Labels.TextAreaOverflow, buttons: Ext.MessageBox.OK});                             
                }
            }
        }

		function buttonValidator() {
			if((getName() != null && getName() != '')&&(errormsg==BlackoutPage.Labels.savedMsg)){    
				Ext.getCmp('deleteId').setDisabled(false);
				Ext.getCmp('deleteId').setIconClass('bmcDelete');
				Ext.getCmp('copyId').setDisabled(false);
				Ext.getCmp('resetId').setDisabled(false); 			  
      		}  
		}
		
		var NewBtnHandler= function(button,event) {openPage('BlackOutPage',BlackoutPage.Labels.Blackoutheader,BlackoutPage.Labels.Blackoutheader);activeAllWindowFlag=false;}
        var SaveBtnHandler = function(button,event) {getTextlengthFilter();}        
        var CopyBtnHandler= function(button,event) {callCopyPage(); activeAllWindowFlag=false;}       
        var DeleteBtnHandler= function(button,event){
                                                        Ext.MessageBox.confirm(BlackoutPage.Labels.Delete, BlackoutPage.Labels.DeleteConfirmMessage, function(btn){
                                                        if(btn === 'yes'){
                                                            deleteBlackOut();
                                                        }})};
        var ResetBtnHandler= function(button,event) {reset();}
        var NextBtnHandler = function (button,event) {if(document.getElementById('nextId').disabled!=true) nextBlackoutBtnHandler1();};
        var PreviousBtnHandler = function (button,event) {if(document.getElementById('prevId').disabled!=true) previousBlackoutBtnHandler1();}; 
     
        Ext.onReady(function(){            
        Ext.QuickTips.init();
        var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'btnToolbar',
            defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
        });
        
        new SamplePanel({
            title: '',
            cls:'toolSpCls',
             bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
            tbar: [{
                scale: 'medium',
                iconCls: 'bmcNew',
                tooltipType : 'title',
                tooltip: BlackoutPage.Labels.New,
				id:'newId',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcNewOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcNew');          
                     }},handler:NewBtnHandler
            },' ',{
                scale: 'medium',
                iconCls: 'bmcSave',
                tooltipType : 'title',
                tooltip: BlackoutPage.Labels.Save,
				id:'saveId',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcSaveOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcSave');          
                     }}, handler:SaveBtnHandler
            },' ',{
                scale: 'medium',
                iconCls: 'bmcCopy',
                tooltipType : 'title',
                tooltip: BlackoutPage.Labels.Copy,
                id:'copyId',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcCopyOn');    
                    },
                    mouseout: function(){
                    this.setIconClass('bmcCopy');          
                     }},handler:CopyBtnHandler
            },' ','-',' ',{
                scale: 'medium',
                iconCls: 'bmcDelete',
                tooltipType : 'title',
                tooltip: BlackoutPage.Labels.Delete,
                id:'deleteId',
                listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcDeleteOn');    
                     },
                     mouseout: function(){
                       this.setIconClass('bmcDelete');          
                     }}
                     ,handler:DeleteBtnHandler
            },' ',{
                scale: 'medium',
                iconCls: 'bmcReset',
                tooltipType : 'title',
                 tooltip: BlackoutPage.Labels.Reset,
                 id:'resetId',
                 listeners: {
                    mouseover: function(){
                    this.setIconClass('bmcResetOn');    
                     },
                     mouseout: function(){
                    this.setIconClass('bmcReset');          
                     }},handler:ResetBtnHandler
                
				},' ',new Ext.Toolbar.Fill(), 
            {
               id :'idInactive',
               xtype  : 'checkbox',
               width  : 93,
               align:'top',
               checked: false,               
               cls:'chkStyle',
               boxLabel:'<span class="checkboxLabelCls">' + BlackoutPage.Labels.Inactive + '</span>',
               listeners:{
                    render:function(){
                        Ext.QuickTips.register({
                            target:this,
                            dismissDelay:20000,                      
                            text:BlackoutPage.Labels.ToolTipInactive
                        });
                    }               
               }
              
            }, {
                 xtype : 'box',
                  id    : 'prevId',
                autoEl:  {tag: 'img', 
                         src:getSDFStylesResPath() +'/SDEFbuttons/b_previous.gif',   
                         title:BlackoutPage.Labels.PreviousRecord
                         },
                          
                cls:'cursorCls' ,listeners : { render: function(f){f.el.on('click', PreviousBtnHandler);}}  
                             
            },{
               
                xtype : 'box',
                id    : 'nextId', 
                autoEl:  {tag: 'img', 
                          src:getSDFStylesResPath() +'/SDEFbuttons/b_next.gif',
                          title:BlackoutPage.Labels.NextRecord },
                cls:'cursorSpaceCls'   , listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}
              
            }]
           });
           
                   if(blackoutIdSet== null || blackoutIdSet== ''){
	               if(getIsDirect() == ''){
	                   if(typeof(window.parent.returnListOfId)=='function')
	                       blackoutIdSet=window.parent.returnListOfId();
	               }else{
	                   if(typeof(window.parent.parent.getIdArray)=='function')
	                       blackoutIdSet=window.parent.parent.getIdArray();
	                       window.parent.handleSave(getWID(),getId());
	               }
	               
	           }

			var isInactive=getBlackoutInactive();
			if(isInactive){     	     	
				Ext.getCmp('idInactive').setDisabled(true);       
			}
			updateInactive();
			handleElemEvent();
			isBlackoutCreatable = getIsBlackoutCreatable();
			isBlackoutDeletable =getIsBlackoutDeletable();
        
			var psoID=getblackoutId();
			if(psoID == null ||psoID == ''){
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');
				Ext.getCmp('copyId').setDisabled(true);
				Ext.getCmp('resetId').setDisabled(true);            
				Ext.getCmp('prevId').setDisabled(true);
				Ext.getCmp('nextId').setDisabled(true); 				
				if(isBlackoutCreatable != null &&  isBlackoutCreatable == false){
					Ext.getCmp('newId').setDisabled(true);
					Ext.getCmp('saveId').setDisabled(true);
				}
			}else{
				if(isBlackoutCreatable != null &&  isBlackoutCreatable == false){
					Ext.getCmp('saveId').setDisabled(true);
					Ext.getCmp('saveId').setIconClass('bmcSaveDisable');	
					Ext.getCmp('deleteId').setDisabled(true);
					Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');			
					Ext.getCmp('copyId').setDisabled(true);
					Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
					Ext.getCmp('resetId').setDisabled(true);					
					Ext.getCmp('newId').setDisabled(true);					
				}				
			}
						
           });                
		
function handleChange(){
	if(!clickedOnce){ 
		clickedOnce = true;
		window.parent.registerChange(getWID());
	}
} 	
function handleResetChange(){
    if(clickedOnce){
       clickedOnce = false;
       window.parent.registerSave(getWID());
    }
}		

