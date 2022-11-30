

function initLoadData(){
	roleFieldStore = new Ext.data.ArrayStore({
		 fields:['key','value'],
		 data:roleData
	});
	fetchComboFieldStore();
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
}

function  fetchComboFieldStore(){
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
   
function showData(event,onCompleteFunction,whereClause,windownameflag){
		if(typeof(onCompleteFunction)!='undefined' && typeof(whereClause)!='undefined'){
			if(typeof(windownameflag) != 'undefined'){
				 
				showalldata(event,onCompleteFunction,whereClause,windownameflag);
			}else{
				showalldata(event,onCompleteFunction,whereClause);
			}   
		}
		else if(typeof(onCompleteFunction)!='undefined' && typeof(whereClause) =='undefined'){
			showalldata(event,onCompleteFunction);
		}                
		else{
			showalldata(event);
		}               

}
function  saveUserAccountLink(){
   var account_id=document.getElementById(ClientPageComp.ComponentVars.account_id).value;
	if(!isPortalUser && clientId!=null && clientId!='' && account_id!=null && account_id!='')
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