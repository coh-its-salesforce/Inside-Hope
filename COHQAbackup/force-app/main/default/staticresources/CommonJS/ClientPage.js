

function initLoadData(){
	 timezoneFieldStore = new Ext.data.ArrayStore({
		 fields:['key','value'],
		 data:timeZoneData
	});
	localeFieldStore = new Ext.data.ArrayStore({
		 fields:['key','value'],
		 data:localeData
	});
	languageFieldStore = new Ext.data.ArrayStore({
		 fields:['key','value'],
		 data:languageData
	});
	roleFieldStore = new Ext.data.ArrayStore({
		 fields:['key','value'],
		 data:roleData
	});

	fetchComboFieldStore();
				
	moduleFieldCombo = new Ext.form.ComboBox({
			id:'timezoneFieldCombo',
			store: timezoneFieldStore,
			width: Ext.isIE7 ?198:204,
			height: Ext.isIE7 ?19:17,
			displayField:'value',
			renderTo: 'timezoneCombo',
			valueField:'value',
			typeAhead: true,
			mode: 'local',
			forceSelection:true,
			triggerAction: 'all',
			tpl: '<tpl for="." >' + '<div class="x-combo-list-item" id="{value}" ext:qtip="{value}">{value}</div>' +'</tpl>',
			selectOnFocus:true,
			editable: false,
			value: timezonevalue,
			 cls: 'timzoneCls',
			listeners:{
				'select': function(combo, record, index) {
				   comboFldIndex = index;
				   document.getElementById(ClientPageComp.ComponentVars.userTimeZone).value=record.get('key'); 
				 }
			}
	
		});
	

		//fetchtimezoneFieldStore();
		
	localeFieldCombo = new Ext.form.ComboBox({
			id:'localeFieldCombo',
			store: localeFieldStore,
			width: Ext.isIE7 ?198:204,
			height: Ext.isIE7 ?19:17,
			displayField:'value',
			renderTo: 'localeCombo',
			valueField:'value',
			typeAhead: true,
			mode: 'local',
			forceSelection:true,
			triggerAction: 'all',
			tpl: '<tpl for="." >' + '<div class="x-combo-list-item" id="{value}" ext:qtip="{value}">{value}</div>' +'</tpl>',
			selectOnFocus:true,
			editable: false,
			value: localevalue,
			 cls: 'timzoneCls',
			listeners:{
				'select': function(combo, record, index) {
				   comboFldIndex = index;
				   document.getElementById(ClientPageComp.ComponentVars.userLocale).value=record.get('key'); 
				 }
			}
	
		});
		
   languageFieldCombo = new Ext.form.ComboBox({
			id:'languageFieldCombo',
			store: languageFieldStore,
			width: Ext.isIE7 ?198:204,
			height: Ext.isIE7 ?19:17,
			displayField:'value',
			renderTo: 'languageCombo',
			valueField:'value',
			typeAhead: true,
			mode: 'local',
			forceSelection:true,
			triggerAction: 'all',
			tpl: '<tpl for="." >' + '<div class="x-combo-list-item" id="{value}" ext:qtip="{value}">{value}</div>' +'</tpl>',
			selectOnFocus:true,
			editable: false,
			value: languagevalue,
			 cls: 'timzoneCls',
			listeners:{
				'select': function(combo, record, index) {
				   comboFldIndex = index;
				   
				   document.getElementById(ClientPageComp.ComponentVars.userLanguage).value=record.get('key'); 
				 }
			}
	
		});
		
		roleFieldCombo = new Ext.form.ComboBox({
			id:'roleFieldCombo',
			store: roleFieldStore,
			width: Ext.isIE7 ?132:136,
			height: Ext.isIE7 ?19:17,
			displayField:'value',
			renderTo: 'roleCombo',
			valueField:'key',
			typeAhead: true,
			mode: 'local',
			disabled : disableRole,
			forceSelection:true,
			triggerAction: 'all',
			tpl: '<tpl for="." >' + '<div class="x-combo-list-item" id="{value}" ext:qtip="{value}">{value}</div>' +'</tpl>',
			selectOnFocus:true,
			editable: false,
			value:roleFldvalue,
			cls: 'clsClientSelectList',
			listeners:{
				'select': function(combo, record, index) {
				   comboFldIndex = index;
				   
				   document.getElementById(ClientPageComp.ComponentVars.roleListId).value=record.get('key'); 
				 }
			}
	
		});
	
setAccountRoleAsMandatory();	
	
	
}

function  fetchComboFieldStore(){
    	if(timezonevalue != '') {
			var i=0;
	        while(timezoneFieldStore.data.length > i) {
	            if( timezoneFieldStore.getAt(i).get('key') == timezonevalue) { 
	                timezonevalue = timezoneFieldStore.getAt(i).get('value');
	                break;
	            }
	            i++;
	        }
	    }else{
	    	if(timezoneFieldStore.data.length > 0) {
	            timezonevalue= timezoneFieldStore.getAt(0).get('value');
	        }
	    }
	    
	    if(localevalue != '') {
			var i=0;
	        while(localeFieldStore.data.length > i) {
	            if( localeFieldStore.getAt(i).get('key') == localevalue) { 
	                localevalue = localeFieldStore.getAt(i).get('value');
	                break;
	            }
	            i++;
	        }
	    }else{
	    	if(localeFieldStore.data.length > 0) {
	            localevalue= localeFieldStore.getAt(0).get('value');
	        }
	    }
	    if(languagevalue != '') {
			var i=0;
	        while(languageFieldStore.data.length > i) {
	            if( languageFieldStore.getAt(i).get('key') == languagevalue) { 
	                languagevalue = languageFieldStore.getAt(i).get('value');
	                break;
	            }
	            i++;
	        }
	    }else{
	    	if(languageFieldStore.data.length > 0) {
	            languagevalue= languageFieldStore.getAt(0).get('value');
	        }
	    }
	    
	     if(rolevalue != '') {
			var i=0;
			var tmpRole= rolevalue;
	        while(roleFieldStore.data.length > i) {
	        	//rolevalue = tmpRole;
	            if( roleFieldStore.getAt(i).get('key') == rolevalue) { 
	                roleFldvalue = roleFieldStore.getAt(i).get('value');
					break;
	            }else{
	            	roleFldvalue = roleFieldStore.getAt(0).get('value');
	            }
	            i++;
	        }
	       
	    }else{
	    	if(roleFieldStore.data.length > 0) {
	            roleFldvalue = roleFieldStore.getAt(0).get('value');
			}
	    }
     
   }
   
   function setComboStoreJS(){
		timezoneFieldStore.removeAll();
		Ext.getCmp('timezoneFieldCombo').store.loadData(timeZoneData);
		
		if(timezonevalue != '') {
			var i=0;
			while(timezoneFieldStore.data.length > i) {

				if( timezoneFieldStore.getAt(i).get('key') == timezonevalue) { 
					Ext.getCmp('timezoneFieldCombo').setValue(timezoneFieldStore.getAt(i).get('value'));
					break;
				}
				i++;
			}
		}
		
		localeFieldStore.removeAll();
		Ext.getCmp('localeFieldCombo').store.loadData(localeData);
		
		if(localevalue != '') {
			var i=0;
			while(localeFieldStore.data.length > i) {

				if( localeFieldStore.getAt(i).get('key') == localevalue) { 
					Ext.getCmp('localeFieldCombo').setValue(localeFieldStore.getAt(i).get('value'));
					break;
				}
				i++;
			}
		}
		
		languageFieldStore.removeAll();
		Ext.getCmp('languageFieldCombo').store.loadData(languageData);
		
		if(languagevalue != '') {
			var i=0;
			while(languageFieldStore.data.length > i) {

				if( languageFieldStore.getAt(i).get('key') == languagevalue) { 
					Ext.getCmp('languageFieldCombo').setValue(languageFieldStore.getAt(i).get('value'));
					break;
				}
				i++;
			}
		}
		
	
   setRoleOptions();
   }
   
   function setRoleOptions(){
               
				roleFieldStore.removeAll();
				Ext.getCmp('roleFieldCombo').store.loadData(roleData);
				if(rolevalue != '') {
					var i=0;
					while(roleFieldStore.data.length > i) {
						if( roleFieldStore.getAt(i).get('key') == rolevalue) { 
							Ext.getCmp('roleFieldCombo').setValue(roleFieldStore.getAt(i).get('value'));
							break;
						}else{
							Ext.getCmp('roleFieldCombo').setValue(roleFieldStore.getAt(0).get('value'));
						}
						i++;
					}
				}else{
				   Ext.getCmp('roleFieldCombo').setValue(roleFieldStore.getAt(0).get('value'));
				}
				
			   Ext.getCmp('roleFieldCombo').setDisabled(disableRole);
			   if(!isStaffUser && !isSysAdmin)
			   Ext.getCmp('btnSave').setDisabled(false);
		       setAccountRoleAsMandatory();
		   }
   
function  saveUserAccountLink(){
    var accountId=document.getElementById(ClientPageComp.ComponentVars.account_id);
	if(!isPortalUser && clientId!=null && clientId!='' && accountId!=null && accountId!='')
	   saveUserAccount();
}
function  setAccountRoleAsMandatory(){
	role_astric=document.getElementById(ClientPageComp.ComponentVars.role_label_astric);
	account_astric=document.getElementById(ClientPageComp.ComponentVars.account_label_astric);
	if(role_astric!=null){
		if(isPortalUser){
		role_astric.style.display='inline';
		account_astric.style.display='inline';
		}else{
		role_astric.style.display='none';
		account_astric.style.display='none';
		}
	}
}