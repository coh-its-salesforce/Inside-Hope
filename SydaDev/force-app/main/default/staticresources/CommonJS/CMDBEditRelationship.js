    	Ext.onReady(function(){
			//Performance Metrics
			windowloaddate = new Date();
			networklatencystart = windowloaddate.getTime();
			var networklatency = networklatencystart - etime;
			data += _ServerValues.NetwokLatencyLabel;
			data +=networklatency; 
			data += '<br>';
			
			Ext.QuickTips.init();
			ExtOnPageReady();
			
			//Page-load time
			data += _ServerValues.PageLoadLabel;
			var pageloadstartdate = new Date() ;
		 
			var time1 = pageloadstartdate.getTime();
			var time2 = windowloaddate.getTime();
			var pagerendertime =(time1 - renderingstartitme);
			
			data += pagerendertime;
			
		});
		
		function ExtOnPageReady(){
			var toolbar = new Ext.Panel({
	            id:'toolBarId',
	            renderTo:'toolbar',
	            cls:'toolSpCls',
	            renderTo: 'ToolBarTD',
	            border:false,
	            tbar: [{
	                scale: 'medium',
	                border:false,
	                iconCls: 'bmcSave',
	                tooltipType : 'title',
	                tooltip: _ServerValues.Save,
	                id:'saveId',
	                
	                listeners: {
	                    mouseover: function(){
	                        this.setIconClass('bmcSaveOn');    
	                    },
	                    mouseout: function(){
	                        this.setIconClass('bmcSave');          
	                    }
	                },
	                handler : function(){ setDataModifiedFlag();if(ValidateForm()){ waitbox(0);Ext.getCmp('saveId').setDisabled(true); SaveClick(); }}
	            }]
	        });
			
			MainPanelRender();
			try{
				window.parent.ActiveReleationInstanceReference=this;
				
			   }catch(e){}
			   enableButton();
		}
		
		function renderTabs()
		{
			var accordionHeight =300;
			var tabitems = [{contentEl:'tabRelationshipInfo', title:_ServerValues.tabRelationshipInfoTitle},
							{contentEl:'tabGeneralInfo', title:_ServerValues.tabGeneralInfoTitle}
			                ];    
			 
			var tabpanel = new CMDB.Controls.VerticalTabPanel({
				//renderTo: 'OtherInfoTabs',
			    activeTab: 0,
			    tabPosition:'left',  //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs
			    textAlign:'right',
			    tabWidth:120, 
			    defaults:{autoScroll: true},
			    enableTabScroll: true,
			    
			    items: tabitems
			  });
			  
			var attributes = new Ext.Panel({
				id:'RealtionshipInformation',
				title: _ServerValues.AttributeTitle,
				items: tabpanel
			});
							  
		  	var accordion = new CMDB.Controls.AccordionPanel({
			   	renderTo:'OtherInfoTabs', 
				items: [attributes],
			    height: accordionHeight
			});


		}
		
		function MainPanelRender()
		{
			createControlMap();
		
			// Process the map later. Donot do that in the getElementByTagName Loop
			renderElementsByType();
			renderTabs();
			try {
				__CMDBControlMap.item('ImpactDirection__c').Element.remove(0);
			}
			catch(ex){}
			
		}
		
		function onSaveComplete()
		{
			MainPanelRender();
			ShowStatusMessage();
		}
