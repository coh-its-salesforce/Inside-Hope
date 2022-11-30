	var DataStore;
    var grid;
    var keyValueOption;
    var keyvalueStore;
    var IncidentStore;
    var IncidentFieldsCombo;
    var IncidentTypeStore;
    var IncidentTypeFieldsCombo;
    var dataList;
    var ds;
    var ds1;
    var selectedComboValue='';
    var selectedTextFieldValue='';
    var blanklabel='';
    var selectedRecord;
	var customFieldComboValue;
	var splitedIncidentAssignedTo;
	var selectedDelimiter = '';
    var DelimiterCombovalue='';
	var gridordering;
	var index;
    Ext.onReady(function(){
             
	   var createdIncidentsAssignedTo = emailIncidentAssignedTovar;
    	if(createdIncidentsAssignedTo != '' && createdIncidentsAssignedTo != null){
            var splitedIncidentAssignedTo = createdIncidentsAssignedTo.split(';');
            selectedComboValue = splitedIncidentAssignedTo[0];
        	
        	if(selectedComboValue == '' && selectedComboValue == null){
            selectedComboValue = 'ContextUser';
        	}
        	selectedTextFieldValue = splitedIncidentAssignedTo[1];
    	} else {
        	selectedComboValue = 'ContextUser';     
    	}
        
	
		var selectedDelimiterAssigned  = delimiterAssignedvar;
		DelimiterCombovalue = selectedDelimiterAssigned;
		if(selectedDelimiterAssigned != '' && selectedDelimiterAssigned != null){
			selectedDelimiter = selectedDelimiterAssigned;	
		}
		
     	var blanklabel = new Ext.form.Label({
	        id:'blanklabel',
	        text:' ',
	        style:'height:17px;'
    	});
    	
    	var IncidentEmailTextfield = new Ext.form.TextField({
	        id:'incidenttextfield',
			value:emailSubjectvar
    	}); 
    
    	var IncidentEmailPanel = new Ext.Panel({
        border:false,
        id:'incidentemailpanel',
        layout:'column',
        renderTo:'incset1',
        items:[{
                xtype: 'radiogroup',
                id:'radiob',
                columns: 2,
                style: 'width: 720px;',
                items: [
                    {id:'radioone', boxLabel: IncidentEmailSettingsPage.Labels.IncidentEmailSubject, name: 'rbauto', inputValue: 1},blanklabel,
                    {id:'radiotwo',boxLabel: IncidentEmailSettingsPage.Labels.IncidentEmailSubject2, name: 'rbauto', inputValue: 2},IncidentEmailTextfield
                ]
                ,
                listeners: {
                    render:{
                        fn:function(item){
                            if(document.getElementById('incidenttextfield').value == ''){
                                document.getElementById('radioone').checked = true; 
                                document.getElementById('incidenttextfield').disabled=true;
                            }else{
                                document.getElementById('radiotwo').checked = true; 
                            }
                            
                        }
                    }
                    ,
                    change:{
                        fn:function(item){ 
                        var rd = document.getElementsByName("rbauto");
                        for(var i = 0; i < rd.length; i++) {
                                
                                if(rd[i].checked) {
                                        
                                        if(rd[i].value == 1){
                                            document.getElementById('incidenttextfield').value = '';
                                            document.getElementById('incidenttextfield').disabled = true;
                                        }else{
                                            
                                           var subjectline = IncidentEmailSettingsPage.Labels.OpenIncident;
                                           subjectline = subjectline.toUpperCase();
										   if(emailSubjectvar == null || emailSubjectvar =='' ){
										     document.getElementById('incidenttextfield').value = subjectline ; 
										   }
										   else{
                                            document.getElementById('incidenttextfield').value = emailSubjectvar ; 
										   } 
                                            document.getElementById('incidenttextfield').disabled = false;
                                        }
                                }
                           }
                       }
                    }
                  }     
                 }]
    	});
    
   eval(AssignIncidentListvar);   
    	var IncidentObjStore = new Ext.data.ArrayStore({
            id:'IncidentObjStore',
            fields:[
                {name:'Id'},
                {name:'IncidentObjFieldLabel'}
            ]
    	});
    
    	IncidentObjStore.loadData(AssignIncidentListData);
    	IncidentObjStore.sort('IncidentObjFieldLabel');
    
    
    	var IncidentObjDesc = new Ext.form.Label({
       	 	id:'IncidentObjDesc',   
			text:IncidentEmailSettingsPage.Labels.AssignEmailIncidents 	
    	});
   
    var IncidentObjectCombo = new Ext.form.ComboBox({ 
        id:'incidentassignedto',
        fieldLabel: '',
        hiddenName:'IncidentObject',
        store: IncidentObjStore,
        valueField:'Id',
        displayField:'IncidentObjFieldLabel',
        typeAhead: false,
        mode: 'local',
        editable:false,
        width:150, 
        value : selectedComboValue,
        triggerAction: 'all',
        forceSelection:true,
        selectOnFocus:true
    });

    
    
    var IncidentObjectAssignedToPanel = new Ext.Panel({
        id: 'IncidentObjectAssignedTo',
        border:false,
        layout:'table',
        renderTo:'incset2',
        items:[IncidentObjDesc,IncidentObjectCombo,
            {
            xtype: "textfield",
            name: "lookupvalue",
            readOnly:true,
            height:20,
            width:150,
            id:'lookupvalueid'
        },{
            xtype: "box",    
			autoEl: {tag: 'img', src:getSDEFStylePath() + '/SDEFbuttons/b_darrow_D.gif'},
            name: "lookupbutton",
            id:'lookupbuttonid',
			style:'padding-left:4px;',
            cls:'lookupbuttontest',
            listeners:{
                render: function(c) {
                    c.getEl().on('load', function(){
					if((document.images['lookupbuttonid'])!= null){
						if (document.images['lookupbuttonid'].getAttribute('isBtnDisabled') == null){
							selectedComboValue = IncidentObjectCombo.getValue();
							if((selectedComboValue == 'Staff')||(selectedComboValue == 'Queue')){								
										document.images['lookupbuttonid'].setAttribute('isBtnDisabled',false);
										document.images['lookupbuttonid'].src=getSDEFStylePath() + '/SDEFbuttons/b_darrow_D.gif'
								} else {
										document.images['lookupbuttonid'].setAttribute('isBtnDisabled',true);
										document.images['lookupbuttonid'].src=getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
								}
                        }}});
                    c.getEl().on('click', function(){
                   
                        var popupId = '', srchPageUrl = ''; 
					   var incidentObjWithNamespaceVal = incidentObjWithNamespacevar; 
                        if(selectedComboValue == 'Staff'){
                            popupId = 'Client';
                            srchPageUrl = 'SearchPage?popupId=Client&isLookup=true&filterClause=IsStaffUser__c=true';                   
                        } else if(selectedComboValue == 'Queue'){
                            popupId = 'Queue';
                            
                            srchPageUrl = 'SearchPage?popupId='+popupId+'&isLookup=true&queueFor='+incidentObjWithNamespaceVal;
                            srchPageUrl = srchPageUrl+'&filterClause='+escape("sobjectType=\'"+incidentObjWithNamespaceVal+ "\'");
                                    
						}
						
						if ((document.images['lookupbuttonid'].getAttribute('isBtnDisabled') == false)||(document.images['lookupbuttonid'].getAttribute('isBtnDisabled') == "false")){
                                               
							window.parent.openPopup(srchPageUrl, findNameField);       
						}
                    });
                 }
             }
             }] 
    });
    
     
     IncidentObjectCombo.on('select', function(){
        selectedComboValue = IncidentObjectCombo.getValue();
        Ext.getCmp('lookupvalueid').setValue('');
            if(selectedComboValue == 'Staff' || selectedComboValue == 'Queue'){
            var lookupbuttonid = document.images['lookupbuttonid'];
            document.images['lookupbuttonid'].setAttribute('isBtnDisabled',false);      
		lookupbuttonid.src=getSDEFStylePath() + '/SDEFbuttons/b_darrow_D.gif';  		   
        } else {
            var lookupbuttonid = document.images['lookupbuttonid'];
            document.images['lookupbuttonid'].setAttribute('isBtnDisabled',true);  
		   lookupbuttonid.src=getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
        }
    });
     
  eval(CustomObjectsListvar);  
    var objectstore = new Ext.data.ArrayStore({
    id:'objectstore',
    fields: [
        {name:'comboId'},
        {name:'comboName'}
    ]
   });
    
    
    ds = new Ext.data.ArrayStore({
        data: AvailableEmailFields,
        fields: ['value','text']         
    });
    
    ds1 = new Ext.data.ArrayStore({
        data: SelectedEmailFields,
        fields: ['value','text']          
    });
    
	delimiterstore = new Ext.data.ArrayStore({
        fields: [
        {name:'comboId'},
        {name:'comboName'}
    ]      
    });
	
     var UserComboLabel = new Ext.form.Label({
        id:'userComboLabel',    
		text:IncidentEmailSettingsPage.Labels.For    	   
    });
    var CustomObjCombo = new Ext.form.ComboBox({
        id: 'customobject',
        fieldLabel: '',
        selectOnFocus:true,
        editable:false,
        triggerAction: 'all',
        store:objectstore,
        valueField:'comboId',
		width:96,
        displayField:'comboName',
        mode:'local',
        value:selectedCustomObject
    });
    objectstore.loadData(CustomObjectsListData);
    
    
    CustomObjCombo.on('select', function(){    
        customFieldComboValue = CustomObjCombo.getValue();          
        SelectObjectCustomFields(customFieldComboValue);
                     
    });
    var CustomObjNamePanel = new Ext.Panel({
        id: 'CustomObjNamePanel',
        border:false,
        layout:'table', 
        height:55,
        renderTo:'id2',
        style:'padding-top:15px;padding-right:15px;padding-left:10px;',
       items:[UserComboLabel,CustomObjCombo] 
    });
	
    eval(AssignDelimterListvar); 
	
	var DelimiterLabel = new Ext.form.Label({
        id:'DelimiterLabel',
		text:IncidentEmailSettingsPage.Labels.SelectDelimiter        
    });
	
	var DelimiterCombo = new Ext.form.ComboBox({
        id: 'delimiterCombo',
        fieldLabel: '',
        selectOnFocus:true,
        editable:false,
        triggerAction: 'all',
        store:delimiterstore,
        valueField:'comboId',
        displayField:'comboName',
		value:selectedDelimiter,		
        mode:'local',
		width:105
    });
	delimiterstore.loadData(AssignDelimiterListData);
	
	DelimiterCombo.on('select',function(){
		DelimiterCombovalue = DelimiterCombo.getValue('comboId');
	});
	var DelimiterComboPanel = new Ext.Panel({
        id: 'DelimiterComboPanel',
        border:false, 
        layout:'table', 
        height:55,
        renderTo:'delimiterid',
        style:'padding-top:15px;padding-left:10px;',
       items:[DelimiterLabel,DelimiterCombo]
    });
	
    var CustomObjAvailableFields = new Ext.form.Label({
        id:'CustomObjAvailableFields',
        cls: 'clsInputBoldLabelTDI',
	   text:IncidentEmailSettingsPage.Labels.AvailableEmailFields
    });

    var CustomObjSelectedFields = new Ext.form.Label({
        id:'CustomObjSelectedFields',
        style:'padding-left:100px;',
        cls: 'clsInputBoldLabelTDI',
	   text:IncidentEmailSettingsPage.Labels.SelectedEmailFields
    });

    var CustomObjFieldsSelectionLabels = new Ext.Panel({
        id: 'CustomObjFieldsSelectionLabels',
        border:false,
        layout:'table',
        renderTo:'emailselector',
        style:'padding-top:10px;padding-bottom:15px;padding-right:15px;padding-left:10px;',
       items:[CustomObjAvailableFields, CustomObjSelectedFields]
    });
    
     
    var CustomFieldsSettingForm = new Ext.Panel({
        id: 'CustomFieldsSettingForm',
        width:550,
        height:170,
        cls:'incf',
        border:false,
        renderTo:'emailselector',
        style:'padding-right:15px;padding-left:10px;',
        layout:'column',
        items:[      
        {
            xtype: 'itemselector',
            id: 'itemselectorDiv',
			width:600,
            name: 'itemselector',
			drawLeftIcon:true,
            drawRightIcon:true,
			drawUpIcon:false,
			drawDownIcon:false,
            fieldLabel: 'ItemSelector',
            iconLeft:'b_darrow_L_disable_custom.gif',
            iconRight:'b_darrow_R_disable_custom.gif',
		  imagePath: getSDEFStylePath() + '/SDEFbuttons/',
            multiselects: [{
                id:'customFieldList1',
                legend: false,
                width: 200,
                height: 146,
                store: ds,
                displayField: 'text',
                valueField: 'value',
				draggable: false,
                listeners:{
                    click:function(c){
						document.getElementById('iconRightId').src = getSDEFStylePath() + '/SDEFbuttons/b_darrow_R_new.gif';
					  document.getElementById('iconLeftId').src = getSDEFStylePath() + '/SDEFbuttons/b_darrow_L_disable_custom.gif';
                        
                    }
                }   
                },{
                id:'selectedFieldList1',
                legend: false,
                width: 200,
                height: 146,
                store: ds1,
                displayField: 'text',
                valueField: 'value',
				draggable: false,
                listeners:{
                    click:function(c){
                      
						document.getElementById('iconRightId').src = getSDEFStylePath() + '/SDEFbuttons/b_darrow_R_disable_custom.gif';
                        document.getElementById('iconLeftId').src = getSDEFStylePath() + '/SDEFbuttons/b_darrow_L_new.gif';
                      
                    }
                }
                                                              
            }]
        }]
    });  
		  
		  eval(fetchdataListvar);
		  eval(IncidentFieldsvar);
		  eval(keywordOptionvar);
		  eval(IncidentFieldsDataTypevar);
          
          DataStore = new Ext.data.ArrayStore({
           id:'DataStore',
            fields:[
                {name:'Id'},
                {name:'FieldName'},
                {name:'Keyvalue'},
                {name:'FieldLabel'},
                {name:'Datatype'}
            ]
           });
        
        DataStore.loadData(fieldListData);
        
        grid = new Ext.grid.GridPanel({
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}), 
                id:'Sgrid',
				width:450,
                border:true,
				stripeRows:false,
				enableHdMenu:false,
				sortable: false,
                store:DataStore,
                columns:[{
                    id:'FieldName',
                    header: 'Field Name', 
					width:100,
                    hidden:true,
                    dataIndex:'FieldName'
                },{
                    id:'datatype',
                    header: 'Data Type', 
					width:100,
                    hidden:true,
                    dataIndex:'Datatype'
                },{
                    header:IncidentEmailSettingsPage.Labels.IncidentField,
                    id:'ValueLabel',
					width:152,
                    dataIndex:'FieldLabel'
                },{
                    header:IncidentEmailSettingsPage.Labels.EmailContent,
                    id:'EmailType',
					width:125,
                    dataIndex:'Id'
                },{
                    header:IncidentEmailSettingsPage.Labels.Emailkeyword,
                    id:'KeywordValue',
					width:152,
                    dataIndex:'Keyvalue'
                }]
    
        });
        grid.on('rowclick', selectedvalue, this);
        
        var orderlist = new Ext.Panel({
	        id:'orderlist',
	        layout: {
                type: 'table',
                columns: 1
            },
	        border:false,
	        items:[{
	          xtype:'box',
	          id:'upbutton',
	          autoEl:  {tag: 'img', 
			   src: getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_disable_custom.gif'
	          },listeners:{
	                        render: function(c) {
	                            c.getEl().on('click', function(){
	                                moveRecords(-1);
	                            });
	                        }
	                     }   
	         },{xtype:'box',
		          id:'downbutton',
		          autoEl:  {tag: 'img', 
				  src: getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif'
		          },listeners:{
		                    render: function(c) {
		                         c.getEl().on('click', function(){
		                              moveRecords(1);
		                          });
		                        }
		                    }   
	            }]
     	  });
    
        
        IncidentStore = new Ext.data.ArrayStore({
                id:'IncidentStore',
                fields:[
                    {name:'label'},
                    {name:'fieldname'}
                ]
            });
            
        IncidentStore.loadData(FieldsofIncident);
        IncidentStore.sort('label');
        
        
        
        IncidentFieldsCombo = new Ext.form.ComboBox({
        
            id:'IncidentFields',
            store: IncidentStore,
            valueField:'fieldname',
            displayField:'label',
            forceSelection:true,
            selectOnFocus:true,
            renderTo:'IncidentTD',
            FieldLabel: 'Incident Fields',
            mode: 'local',
            editable:false,
            width:110, 
            triggerAction: 'all',
            forceSelection:true,
			emptyText:IncidentEmailSettingsPage.Labels.IncidentFieldCombo,
            selectOnFocus:true,
            viewConfig:{
                enableKeyEvents:true
            }
         }); 
        
        IncidentTypeStore = new Ext.data.ArrayStore({
                id:'IncidentTypeStore',
                fields:[
                    {name:'DataType'},
                    {name:'fieldname'}
                ]
            });
            
        IncidentTypeStore.loadData(FieldTypeofIncident);
        IncidentTypeStore.sort('fieldname');
        
        IncidentTypeFieldsCombo = new Ext.form.ComboBox({
        
            id:'IncidentTypeFields',
            store: IncidentTypeStore,
            valueField:'fieldname',
            displayField:'DataType',
            forceSelection:true,
            selectOnFocus:true,
            renderTo:'IncidentTD1',
            FieldLabel: 'Incident Fields',
            mode: 'local',
            editable:false,
            width:125, 
            triggerAction: 'all',
            forceSelection:true,
			emptyText:IncidentEmailSettingsPage.Labels.IncidentFieldCombo,
            selectOnFocus:true,
            viewConfig:{
                enableKeyEvents:true
            }
         });
        
         
        IncidentFieldsCombo.on('select', function(combo, record, index) {
         		IncidentTypeFieldsCombo.setValue(IncidentFieldsCombo.getValue());
                Ext.getCmp('keyvalueOptions').reset();
                document.getElementById('inputTxt').disabled=true;
				document.getElementById('inputTxt').value=IncidentEmailSettingsPage.Labels.Keyword;
                document.getElementById('updateButtonId').style.display='none';             
                document.getElementById('removeButtonId').disabled=true;
                document.getElementById('addButtonId').style.display='inline';
			 document.getElementById('removeButtonId').src=getSDEFStylePath() + '/SDEFbuttons/b_remove_disabled.png';
				Ext.getCmp("Sgrid").getSelectionModel().clearSelections();
				document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_disable_custom.gif';
				document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
                
         });
         
          keyvalueStore = new Ext.data.ArrayStore({
                id:'keyvalueStore',
                fields:[
                    {name:'label'},
                    {name:'value'}
                ]
            });
            
        keyvalueStore.loadData(KeywordValue);
        
         keyValueOption = new Ext.form.ComboBox({
        
            id:'keyvalueOptions',
            store: keyvalueStore,
            valueField:'label',
            displayField:'value',
            forceSelection:true,
            selectOnFocus:true,
            renderTo:'keyvalueTD',
            FieldLabel: 'KeyValuePair',
            mode: 'local',
            width:110,
            editable:false, 
            triggerAction: 'all',
            forceSelection:true,
            selectOnFocus:true,
			emptyText:IncidentEmailSettingsPage.Labels.EmailContentCombo
            
         });
         
         keyValueOption.on('select', function(combo, record, index) {
         
            var keyoptValue=keyValueOption.getValue();
            if(keyoptValue=='Body' || keyoptValue=='Subject'){
                document.getElementById('inputTxt').disabled=false;
                document.getElementById('inputTxt').value='';
            }
            else{
                document.getElementById('inputTxt').disabled=true;
            }   
         });
         
         var msgsendersLabel = new Ext.form.Label({
            id:'msgincidentLabel',
            border: false,
            width:200,       
		   text:IncidentEmailSettingsPage.Labels.unidentifiedUser,
            renderTo:'id6',
            cls: 'clsInputBoldLabelTDI',
            style:'padding-bottom:10px;padding-top:2px;' 
         
         });
         
         function findNameFieldForUser(id){
            getUserName(id);
         }
         var lookupUser = new Ext.Panel({ 
            id:'lookupUserId',
            border:false,
            style:'padding-left:10px;', 
            layout: {
                type: 'table',
                columns: 3
            },
            items:[{
                xtype: "textfield",
                name: "lookupvalue",
                cls: 'clsInputTextBox',
                height:20,
                width:200,
				readOnly:true,
                id:'UserLookupId'      
                },{
                xtype: "box",  
				autoEl: {tag: 'img', src:getSDEFStylePath() + '/SDEFbuttons/b_darrow_D.gif'},			   
                name: "AccountLookupButton",
                id:'AccountLookupButtonId',
                style:'padding-left:4px;',
                cls:'lookupbuttontestsat',
                listeners:{
                    render: function(c) {
                        c.getEl().on('click', function(){                             
                            window.parent.openPopup('SearchPage?popupId=Client&isLookup=true',findNameFieldForUser);                                                            
                        });
                    }
                }
            },
			{
                xtype: "box",  
				autoEl: {tag: 'img', src:getSDEFStylePath() + '/SDEFbuttons/b_field_clear.gif', title:IncidentEmailSettingsPage.Labels.lblReset},			   
                name: "ClearButton",
                id:'ClearButtonId',
                style:'padding-left:4px;',
                listeners:{
                    render: function(c) {
                        c.getEl().on('click', function(){                             
                             var userLookupValue = Ext.getCmp('UserLookupId');
								if(userLookupValue!=null && userLookupValue!='undefined'){
									getUserName('');
								}                                                           
                        });
                    }
                }
            }]
        });
     
     var inboundsender = new Ext.Panel({
        id:'inboundsenderid',
        border:false,
        layout:'column',
        renderTo:'id6',
        items:[msgsendersLabel,lookupUser]
     });
     var FwdEmailLabel = new Ext.form.Label({
            id:'FwdEmailLabelid',
            border: false,
            width:350,       
		    text:IncidentEmailSettingsPage.Labels.FwdErrMail,
            renderTo:'id7', 
           // cls: 'clsInputBoldLabelTDI',
            style:'padding-bottom:10px;padding-top:2px;padding-left:8px;' 
         
         });
         
        function findNameFieldForAdmin(id){
            getAdminName(id);
         }
         var lookupAdmin = new Ext.Panel({ 
            id:'lookupAdminId',
            border:false,
            style:'padding-left:10px;', 
            layout: {
                type: 'table',
                columns: 2
            },
            items:[{
                xtype: "textfield",
                name: "lookupvalue",
                cls: 'clsInputTextBox',
                height:20,
                width:150,
				readOnly:true,
                id:'AdminLookupId'      
                },{
                xtype: "box",  
				autoEl: {tag: 'img', src:getSDEFStylePath() + '/SDEFbuttons/b_darrow_D.gif'},			   
                name: "AccountLookupButton",
                id:'AccountLookupButtonId',
                style:'padding-left:4px;',
                cls:'lookupbuttontestsat',
                listeners:{
                    render: function(c) {
                        c.getEl().on('click', function(){
                            window.parent.openPopup('SearchPage?popupId=Client&isLookup=true&filterClause='+escape("Profile.PermissionsModifyAllData=true"),findNameFieldForAdmin);                                                            
                        });
                    }
                }
            }]
        });
     
     var FwdErrMail = new Ext.Panel({
        id:'FwdErrMailid',
        border:false,
        layout:'column',
        renderTo:'id7',
        items:[FwdEmailLabel,lookupAdmin]
     });
     gridordering = new Ext.Panel({
        id:'gridorderingid',
        border:false,
        layout:'column',
        renderTo:'extGridPanel',
        items:[grid,orderlist]
     });
		
		 document.getElementById('incidenttextfield').title=IncidentEmailSettingsPage.Labels.EmailSubjectTooltip;
         Ext.getCmp('lookupvalueid').setValue(selectedTextFieldValue);
	   Ext.getCmp('UserLookupId').setValue(selectedUserEmailvar);	
		 Ext.getCmp('AdminLookupId').setValue(selectedAdminEmail);	
      
    }); 
    
    function findNameField(id){
        getNameField(selectedComboValue, id);
    }   
    
    	function selectedvalue(grid, rowIndex, e){
    		
    		if(rowIndex==0){
				Ext.getCmp('upbutton').disabled = true;
				document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_new.gif';
    			document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_disable_custom.gif';
    		}else if(rowIndex>0 && (rowIndex+1)< DataStore.data.length){
				Ext.getCmp('upbutton').disabled = false;
				Ext.getCmp('downbutton').disabled = false;
				document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_new.gif';
    			document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_new.gif';
    		}else if(rowIndex>0 && (rowIndex+1)== DataStore.data.length){			
				Ext.getCmp('upbutton').disabled = false;
				Ext.getCmp('downbutton').disabled = true;
				document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
    			document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_new.gif';
    		}		
    		
	        selectedRecord=rowIndex;
	        
	        IncidentFieldsCombo.setRawValue(DataStore.getAt(rowIndex).get('FieldLabel'));
	        IncidentFieldsCombo.setValue(DataStore.getAt(rowIndex).get('FieldName'));
	        IncidentTypeFieldsCombo.setValue(IncidentFieldsCombo.getValue());
	        document.getElementById('updateButtonId').style.display='inline';               
	        document.getElementById('removeButtonId').disabled=false;
	        document.getElementById('addButtonId').style.display='none';
		    document.getElementById('removeButtonId').src=getSDEFStylePath() + '/SDEFbuttons/b_remove.png';
	        
	        
	        var keyvalue=DataStore.getAt(rowIndex).get('Id');
	        if(keyvalue.indexOf('F')!= -1){ 
	            keyValueOption.setValue( keyvalueStore.getAt(0).get('label'));
	            Ext.getCmp('keyvalueOptions').show();
	            document.getElementById('inputTxt').disabled=true;
	            document.getElementById('inputTxt').value=IncidentEmailSettingsPage.Labels.FromAddressLabel;
	        }else if(keyvalue.indexOf('S')!= -1){
	            keyValueOption.setValue( keyvalueStore.getAt(1).get('label'));
	            Ext.getCmp('keyvalueOptions').show();
	            document.getElementById('inputTxt').disabled=false;
	            document.getElementById('inputTxt').value=DataStore.getAt(rowIndex).get('Keyvalue');
	        }else{
	            keyValueOption.setValue( keyvalueStore.getAt(2).get('label'));
	            document.getElementById('inputTxt').disabled=false;
	            document.getElementById('inputTxt').value=DataStore.getAt(rowIndex).get('Keyvalue');
	        }   
    	}
    
        function addnewdata(){
            var kword='';
            var recordExists = 0;;
            var fieldname=IncidentFieldsCombo.getValue();
            var fieldlabl = IncidentFieldsCombo.getRawValue();
            var fieldtype=IncidentTypeFieldsCombo.getRawValue();
            var keyOptionValue=keyValueOption.getValue();
            var lkword='';
			
            if(fieldname ==''){
                Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.incidentfieldrequired , buttons: Ext.MessageBox.OK});
            }else if(keyOptionValue ==''){
                Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.Emailcontentrequired , buttons: Ext.MessageBox.OK});
            }
            else{
                if(keyOptionValue=='Body' || keyOptionValue=='Subject'){ 				
                kword=document.getElementById('inputTxt').value;
					if(kword ==''){
						Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.keywordrequired , buttons: Ext.MessageBox.OK});
					}
				}
                else{
					kword=keyOptionValue;
				}
				lkword=kword.toLowerCase();
				if(kword!=''){
				
					if(kword.indexOf('#') != -1 || kword.indexOf('%')!= -1){
						Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.keyworddelimitererror, buttons: Ext.MessageBox.OK});
						return;
					}
					
					kword=kword.replace(/"/g,'\\"');
					
					dataList='var fieldListData=[';
					for (var i=0; i<DataStore.data.length; i++)
					{ 
						
						if(DataStore.getAt(i).get('Keyvalue').toLowerCase()==lkword){ 
							recordExists=1;
							Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.keyworderror , buttons: Ext.MessageBox.OK});    
						}
						if(DataStore.getAt(i).get('FieldName')==fieldname && fieldtype!='TEXTAREA' && fieldtype!='STRING'){
							recordExists=1;
							Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.Fielderror , buttons: Ext.MessageBox.OK});    
						}
						if(DataStore.getAt(i).get('FieldName')==fieldname && fieldname=='templatename__c'){
							recordExists=1;
							Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.Fielderror , buttons: Ext.MessageBox.OK});    
						}
						
						var keywords= DataStore.getAt(i).get('Keyvalue').replace(/"/g,'\\"');
						  dataList+= '[\"'+DataStore.getAt(i).get('Id')+'\",\"'+DataStore.getAt(i).get('FieldName')+'\",\"'+keywords+'\",\"'+DataStore.getAt(i).get('FieldLabel')+'\",\"'+DataStore.getAt(i).get('Datatype')+'\"],';
					   
					   
					}
					if(DataStore.data.length==0){
						dataList+='[\"'+keyOptionValue+'\",\"'+fieldname+'\",\"'+kword+'\",\"'+fieldlabl+'\",\"'+fieldtype+'\"]];';
					}
					else if(recordExists==0){ 
						
						dataList=dataList.substring(0,dataList.length-1)+',[\"'+keyOptionValue+'\",\"'+fieldname+'\",\"'+kword+'\",\"'+fieldlabl+'\",\"'+fieldtype+'\"]];';
					}
					
					eval(dataList);
					DataStore.loadData(fieldListData);
					resetgrid();
			   }
            }   
        }
        
        function updateValue() {
            var uptkword='';
			var luptkword='';
            var sel_model = grid.getSelectionModel();
            var record = sel_model.getSelected();
            var fieldtype=IncidentTypeFieldsCombo.getRawValue();
            var updaterecord=0;
            var fieldname=IncidentFieldsCombo.getValue();
            var fieldlabel = IncidentFieldsCombo.getRawValue();
            
            
            var keyOptionValue=keyValueOption.getValue();
            
            if(keyOptionValue=='Body' || keyOptionValue=='Subject') 
            uptkword=document.getElementById('inputTxt').value;
            else
            uptkword=keyOptionValue;
            
            luptkword=uptkword.toLowerCase();
			if(uptkword!=''){
			
				if(uptkword.indexOf('#') != -1 || uptkword.indexOf('%')!= -1){
						Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.keyworddelimitererror, buttons: Ext.MessageBox.OK});
						return;
				}
				for (var i=0; i<DataStore.data.length; i++)
				{ 
					
				  if(selectedRecord!=i){
					
					if(DataStore.getAt(i).get('Keyvalue').toLowerCase()==luptkword){
						updaterecord=1;
						Ext.MessageBox.show({ msg:IncidentEmailSettingsPage.Labels.keyworderror , buttons: Ext.MessageBox.OK});    
					}
				  } 
				   
				}
            
				if(updaterecord==0){
                
                record.set("FieldName",fieldname);
                record.set("FieldLabel",fieldlabel);
                record.set("Keyvalue",uptkword);
                record.set("Datatype",fieldtype);
                record.set("Id",keyOptionValue);
               
                document.getElementById('updateButtonId').style.display='none';             
                document.getElementById('removeButtonId').disabled=true;
                document.getElementById('addButtonId').style.display='inline';
				document.getElementById('removeButtonId').src=getSDEFStylePath() + '/SDEFbuttons/b_remove_disabled.png';
            
				Ext.getCmp("Sgrid").getSelectionModel().clearSelections();
				
                resetgrid();
            }
		  }	
        }
        
        function moveRecords(direction){
		
			if((selectedRecord != 0 && direction < 0) || (direction > 0 && selectedRecord <= grid.getStore().getCount()-2)){
            var recordabc = grid.getSelectionModel().getSelections();
            
            if (direction < 0){
                selectedRecord--;
                if (selectedRecord < 0) {
                return;
                }
            } else {
                selectedRecord++;
                if (selectedRecord >= grid.getStore().getCount()) {
                    return;
                }
            }
            for(var i=0;i<=recordabc.length;i++){
                   grid.store.remove(recordabc[i]);
                  
             }
            grid.store.insert(selectedRecord, recordabc);
			
				if (selectedRecord == 0) {
							document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_disable_custom.gif';
							Ext.getCmp('upbutton').disabled = true;
            grid.getSelectionModel().selectRow(selectedRecord, true);
							return; 						
					}
					else
					{
						document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_new.gif';
							Ext.getCmp('upbutton').disabled = false;
							grid.getSelectionModel().selectRow(selectedRecord, true);
							
					}
					if(selectedRecord == grid.getStore().getCount()-1){							
							document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
							Ext.getCmp('downbutton').disabled = true;
							return;
					} 
					else
					{			
							document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_new.gif';
							Ext.getCmp('downbutton').disabled = false;
					}
				grid.getSelectionModel().selectRow(selectedRecord, true);
			}
			
        }
        
        function removeRecord() {
            var records = grid.getSelectionModel().getSelections();
            for(var i=0;i<=records.length;i++){
           
                   grid.store.remove(records[i]);
                  
             }
            document.getElementById('updateButtonId').style.display='none';             
            document.getElementById('removeButtonId').disabled=true;
            document.getElementById('addButtonId').style.display='inline';
            document.getElementById('removeButtonId').src=getSDEFStylePath() + '/SDEFbuttons/b_remove_disabled.png';
			
			resetgrid();
        }
        
        function resetgrid(){
       
            document.getElementById('inputTxt').disabled=true;
			document.getElementById('inputTxt').value=IncidentEmailSettingsPage.Labels.Keyword;
            Ext.getCmp('keyvalueOptions').reset();
            Ext.getCmp('IncidentFields').reset();
			document.images['upbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_U_disable_custom.gif';
			document.images['downbutton'].src= getSDEFStylePath() + '/SDEFbuttons/b_darrow_D_disable_custom.gif';
        }
        
       
        
        
        function savegrid(){
            
            var finalgriddata='';
            
            for (var i=0; i<DataStore.data.length; i++)
            { 
             finalgriddata += String.format('{0};,,;{1};,,;{2};,,;{3};;;', DataStore.getAt(i).get('Id'),DataStore.getAt(i).get('FieldName'),DataStore.getAt(i).get('Keyvalue'),DataStore.getAt(i).get('Datatype'));
            }
            
			var objectemailfields="";
            
            if(selectedComboValue == 'Staff' || selectedComboValue == 'Queue'){
                if(Ext.getCmp('lookupvalueid').getValue() == ''){
					showMessage(IncidentEmailSettingsPage.Labels.SelectEmailIncidentAssignTo+selectedComboValue);
                } 
                else
                var EmailIncidentAssignTo = selectedComboValue +';'+ Ext.getCmp('lookupvalueid').getValue(); 
            
            }else 
            var EmailIncidentAssignTo = selectedComboValue +';'+ Ext.getCmp('lookupvalueid').getValue(); 
        
         	var Esubject='';
           	
           	if(document.getElementById('radiotwo').checked==true){
            	Esubject= document.getElementById('incidenttextfield').value;
				 if(Esubject == ''){
					Ext.MessageBox.show({
						width: 250,
						title: IncidentEmailSettingsPage.Labels.ApplicationSettingsTitle,
						msg: IncidentEmailSettingsPage.Labels.Incidentemailsubjecterror,
						buttons: Ext.MessageBox.OK
					});
                return false;
				}
				
            }    
        
                 
            if(Ext.getCmp('selectedFieldList1')){
	            var record = Ext.getCmp('selectedFieldList1').store;         
	            var rowCount=record.data.length;
	        
	            var fieldCount = 0;
	          
	            while(rowCount > fieldCount){
	                var cField = record.getAt(fieldCount); 
	                fieldCount++;
					if(cField.get('value')!='Email'){
						if(rowCount == fieldCount){
							objectemailfields = objectemailfields +cField.get('value');
						} else {
							objectemailfields = objectemailfields +cField.get('value')+ ';';                       
												
							} 					                    
					} 
			}			
          }
            SavegridData(finalgriddata,objectemailfields,EmailIncidentAssignTo,Esubject,DelimiterCombovalue); 
        }
        
        function setData(){        
            ds.loadData(AvailableEmailFields);  
            ds1.loadData(SelectedEmailFields);                     
        }