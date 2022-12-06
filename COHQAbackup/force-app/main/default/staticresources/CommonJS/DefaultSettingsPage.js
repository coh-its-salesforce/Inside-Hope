var beforeSave = false;
 var strvalue = '';
function enableDisableButtons()
	{
		if(document.getElementById(quicklink).checked)
			{
				Ext.getCmp('newId').setDisabled(false);
			}
		else
			{	    
				Ext.getCmp('deleteId').setDisabled(true);
				Ext.getCmp('upBtn').setDisabled(true);
				Ext.getCmp('downBtn').setDisabled(true);
				Ext.getCmp('newId').setDisabled(true);
			}
	}


 function updatemsgtemplatesection(isChecked)
    {
        if(isChecked.checked)
        {
         document.getElementById(templateArea).disable=false;
         document.getElementById(contactUsMessageTextArea).disabled=false;
        
        }
        else
        {
        document.getElementById(templateArea).disabled=true;
        document.getElementById(contactUsMessageTextArea).disabled=true;
        
        }
        
    }
	  var removeHandler = function (button, event){
                            var tempRecord= Ext.getCmp('faqCategoryGrid').store;
                            var linkName = tempRecord.getAt(selectedRowIndex).get('quickLinkName');
                            var linkURL = tempRecord.getAt(selectedRowIndex).get('quickLinkURL');
                           if((linkName == null || linkName == '') && (linkURL == null || linkURL == '')){
                                button = 'ok';
                                removeQuickLinkHandler(button,event);
                           }else{   
                                  Ext.Msg.show({
                                       cls:'messagePopup',
                                       title:removeQuickLinkLabel,
                                       msg: quickLinksDeleteConfirmationLabel,
                                       buttons: Ext.Msg.OKCANCEL,
                                       fn: removeQuickLinkHandler,
                                       width: 300,
                                       icon: Ext.MessageBox.WARNING ,
                                       frame:false
                                    });
                            }    
    }; 

    function  setReadOnly(){
        var assignValueId = document.getElementById(assignValuevar);
        if(assignValueId!=null)
            assignValueId.setAttribute('readonly', 'readonly');
    }
        //-------------------- preRequirement for checkBox------------------------------------------------------------------------
    Ext.ns('Ext.ux.grid');
    Ext.ux.grid.CheckColumn = function(config){
        Ext.apply(this, config);
        if(!this.id){
            this.id = Ext.id();
        }
        this.renderer = this.renderer.createDelegate(this);
    };

    Ext.ux.grid.CheckColumn.prototype ={
        init : function(grid){
            this.grid = grid;
            this.grid.on('render', function(){
                var view = this.grid.getView();
                view.mainBody.on('mousedown', this.onMouseDown, this);
            }, this);
        },
    
        onMouseDown : function(e, t){
           
            if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
                e.stopEvent();
                var index = this.grid.getView().findRowIndex(t);
                var record = this.grid.store.getAt(index);
                record.set(this.dataIndex, !record.data[this.dataIndex]);
                
            }
        },
    
        renderer : function(v, p, record){
            p.css += ' x-grid3-check-col-td'; 
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
        }
       
    };
    // register ptype
    Ext.preg('checkcolumn', Ext.ux.grid.CheckColumn);
    // backwards compat
    Ext.grid.CheckColumn = Ext.ux.grid.CheckColumn;
    
    
    //--------------------------------------- end of preRequirement for checkBox -----------------------------------------------------------------
 
  
    var SaveBtnHandler = function(button,event) {
        objList = ''; 
        beforeSave = true; 

		var ssURLvar = document.getElementById(txtSSURLvar).value;
		if(ssURLvar!='')
		{
			ssURLvar = httpIntranetUrlCheck(ssURLvar);
			if(!ssURLvar){
				Ext.Msg.show({
					msg: invalidSSURLLabel,
					buttons: Ext.Msg.OK
				});
				return;
			}
		}

        var intranetURL = httpIntranetUrlCheck(document.getElementById(txturlvar).value);
        //alert('intranetURL '+intranetURL);
        if(document.getElementById(enableIntranetvar).checked){
            if(!intranetURL){
                var msg = invalidIntranetURLLabel;
                showMessage(msg);
                return;
            }
        }
        if(document.getElementById(assignValuevar).value==''){
            var msg = 'Please select Incident Assignment to Queue';
            showMessage(msg);
            return;
        }
        var numericExpression = /^[0-9]+$/;
        var txtDays=document.getElementById(selectDaysvariable).value;
        if(!(txtDays.match(numericExpression))){
            var msg = 'Incident History in Days is Invalid';
            showMessage(msg);
            return;
        }
        /*Commented as part of US 88046*/
        /*if(document.getElementById('{!JSENCODE($Component.defaultForm.panel.Miscellaneous.AccountId)}').value=='')
        {
        var msg = '{!JSENCODE($Label.PortalAccIDErrorMsg)}';

        showMessage(msg);
        return;
        }*/
        var modifiedRecord = Ext.getCmp('faqCategoryGrid').getStore().getModifiedRecords();
        var totalSavedRecord = Ext.getCmp('faqCategoryGrid').getStore().getTotalCount(); 
        var totalRecord = Ext.getCmp('faqCategoryGrid').getStore().getCount(); 
        var count;
        var gridRecord= Ext.getCmp('faqCategoryGrid').store;
        //alert('modifiedRecord---->' + modifiedRecord.length);
        if( (modifiedRecord == null || modifiedRecord == '') && (totalRecord > totalSavedRecord) ){
            //alert('Empty object Inserted.... ');
            objList = objList + 'undefined' + PE + 'undefined' + PE + 'undefined' + PE + 'undefined' + PE + 'undefined' + EF ;
        }
        else{
            var quickURL;
            var quickLinkName;
            for (count=0 ; count < gridRecord.data.length ; count++)    {
                quickURL = httpIntranetUrlCheck(gridRecord.getAt(count).get('quickLinkURL'));
                if(!quickURL){
                    var msg = invalidQuickLinkURLLabel;
                    showMessage(msg);
                    return;
                }
                quickLinkName=gridRecord.getAt(count).get('quickLinkName')
                if(quickLinkName.length > 50){
                    var msg = SSQuickLinkNameInvalidSizeLabel;
                    showMessage(msg);
                    return;
                }
                recName = gridRecord.getAt(count).get('quickLinkNumber');
                //recURLOrder = gridRecord.getAt(count).get('URLOrder');
                recURLOrder = count+1;
                recQuickLinkName = gridRecord.getAt(count).get('quickLinkName');
                recQuickLinkURL = gridRecord.getAt(count).get('quickLinkURL');
                recQuickLinkPermanent = gridRecord.getAt(count).get('quickLinkPermanent');
                //alert('Inside nested else.....');
                objList = objList + recName + PE+ recURLOrder + PE + recQuickLinkName + PE + recQuickLinkURL + PE + recQuickLinkPermanent + EF ;
                }
            }
            //alert('objList------> ' + objList);
            updateObjList(objList);
            //alert('objListafter------> ' + objList);
            Ext.getCmp('faqCategoryGrid').getStore().commitChanges();
            Ext.getCmp('faqCategoryGrid').render('faqCategory-grid');
            //saveDefaults();
			waitbox(0);
        };
    
    var removeQuickLinkHandler = function(button ,event) {
        if(button=='ok'){
            var delRecord = Ext.getCmp('faqCategoryGrid').getStore().getAt(selectedRowIndex);
            var delName = delRecord.get('quickLinkNumber');
            deleteQuickLink(delName); 
            Ext.getCmp('faqCategoryGrid').render('faqCategory-grid');
            Ext.getCmp('faqCategoryGrid').getStore().remove(delRecord);
            Ext.getCmp('deleteId').setDisabled(true);
            Ext.getCmp('upBtn').setDisabled(true);
            Ext.getCmp('downBtn').setDisabled(true);
        }else if (button=='cancel'){
            return;
        }
    };
    var ResetBtnHandler = function(button,event) {
        reset();
    }; 
    
    var ChngBtnHandler= function(button,event) {  alert('In Change'); };
    
    var fm = Ext.form;
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
 
    function UpBtnHandler(){
        if(Ext.getCmp('upBtn').disabled == false ){
            var index=selectedRowIndex;   
            var rec1 = grid.store.getAt(index); 
            var rec2 = grid.store.getAt(index-1); 
            grid.stopEditing();
            store.insert(index-1,rec1);
            store.insert(index,rec2);
            //grid.startEditing(index-1, 0);
            grid.getView().refresh(); 
            selectedRowIndex--;
            var numOfrecord = store.data.length;
            if(selectedRowIndex == 0 || numOfrecord == 1){
                Ext.getCmp('upBtn').setDisabled(true);
            }
            else{      
                Ext.getCmp('upBtn').setDisabled(false);
            }
            if((selectedRowIndex == (numOfrecord - 1)) || (numOfrecord == 1)){
                Ext.getCmp('downBtn').setDisabled(true);
            }
            else{      
                Ext.getCmp('downBtn').setDisabled(false);
            }
        }
    }
    function DownBtnHandler(){
        if(Ext.getCmp('downBtn').disabled == false ){
            var index=selectedRowIndex;   
            var rec1 = grid.store.getAt(index); 
            var rec2 = grid.store.getAt(index+1); 
            grid.stopEditing();
            store.insert(index,rec2);
            store.insert(index+1,rec1);
            //grid.startEditing(index, 0);
            grid.getView().refresh();  
            selectedRowIndex++;
            var numOfrecord = store.data.length;
            if(selectedRowIndex == 0 || numOfrecord == 1){
                Ext.getCmp('upBtn').setDisabled(true);
            }
            else{      
                Ext.getCmp('upBtn').setDisabled(false);
            }
            if((selectedRowIndex == (numOfrecord - 1)) || (numOfrecord == 1)){
                Ext.getCmp('downBtn').setDisabled(true);
            }
            else{      
                Ext.getCmp('downBtn').setDisabled(false);
            }
        }     
    }
       
    function refresh(){
        var i=0;
        while(store.data.length>i){
            var record = grid.getStore().getAt(i);
            var fieldName = grid.getColumnModel().getDataIndex(3);
            var data = record.get(fieldName);
            var j=0;
            while(typeEditor.store.data.length>j){
                var rec= typeEditor.store.getAt(j).get('value');
                if(rec==data){
                    var rec1=typeEditor.store.getAt(j).get('name');
                    record.set(fieldName ,rec1);
                }
                j++;
            }
            i++;
        }
    }

    function enableCloseIncidentDays(){
        if(document.getElementById(limitClosedIncidentsvar).checked){
            document.getElementById(selectDaysvariable).disabled = false;
        }else{
            //document.getElementById(selectDaysvariable).value = "7";
            document.getElementById(selectDaysvariable).disabled = true;
        }
    }

    function enableMobile(){
        document.getElementById(PortalIdvalvar).disabled = true;
        if(document.getElementById(enableMobileAccessvar).checked)
            document.getElementById(PortalIdvalvar).disabled = false;
    }

    function enableUrl(){
        if(document.getElementById(enableIntranetvar).checked){
            document.getElementById(txturlvar).disabled=false;
        }
        else{
            document.getElementById(txturlvar).disabled=true;
        }
    }
        
    function templateName(){
        if(document.getElementById(showcntctvar).checked){
            openPopup('SearchPage?popupId=Template&isLookup=true&filterClause='+escape("templateFor__c='Incident'"),openTemplateLookup,580,475);
        }else{
            return false;
        }
    }
 
    function enableSearchEngine(){
        if(document.getElementById(enableInternetvar).checked){
            //document.getElementById('{!JSENCODE($Component.defaultForm.panel.search.txtSearchEngine)}').disabled=false;
        }
        else{
            document.getElementById(txtSearchEnginevar).disabled=true;
        }
    }

    function enableRadio(){
        //alert('hi'+document.getElementById('{!JSENCODE($Component.defaultForm.panel.incident.selectRadio)}').disabled);
        if(document.getElementById(closeIncidentvar).checked){
            enabledValue();
        }
        else{
            disabledValue();
        }
    }

    function openTemplateLookup(returnValues){   
        if(returnValues!= null) {
            if(returnValues != null  ) {
                setTemplateNext(returnValues);  //Calling Action Function
            }
        }
    }
    function callsaveDefaults(){
        //alert(errormsg);
        if(errormsg!= null && errormsg != '' && errormsg!="Record has been saved successfully."){
            // alert('error '+errormsg);
            showMessage(errormsg);
        }else{
            Ext.getCmp('deleteId').setDisabled(true);
            Ext.getCmp('upBtn').setDisabled(true);
            Ext.getCmp('downBtn').setDisabled(true);
            saveDefaults();
        }
    }
    function selectedValue(list){
        var result;
        for(var i=0;i<(list.options.length);i++){
            if(list.options[i].selected){
                result=list.options[i].text;
                break;
            }
        }
        return result;
    }
 
    function  openQueuePopup(returnVal){
        assignIncidentTOQueue(returnVal);
    }
	
	function checkEmptyRow(){
        totalSavedRecord = Ext.getCmp('faqCategoryGrid').getStore().getTotalCount(); 
        totalRecord = Ext.getCmp('faqCategoryGrid').getStore().getCount(); 
        gridRecord= Ext.getCmp('faqCategoryGrid').store;
        var emptyRow;
        if(totalRecord > totalSavedRecord)
        for (count=totalRecord-1 ; count >=  totalSavedRecord; count--) {
            emptyRow = Ext.getCmp('faqCategoryGrid').getStore().getAt(count);
            if((gridRecord.getAt(count).get('quickLinkName') == null || gridRecord.getAt(count).get('quickLinkName') == '') && 
                (gridRecord.getAt(count).get('quickLinkURL') == null || gridRecord.getAt(count).get('quickLinkURL') == '') ){
                //alert('-------inside if--and count is -----' + count);
                Ext.getCmp('faqCategoryGrid').getStore().removeAt(count);
            }
        }
    }  
    
    function onReadyPanelFunction(){
        store = new Ext.data.SimpleStore({
            fields: [
                {
                    
                    name: 'quickLinkNumber',
                    type: 'string'
                },{
                   
                    name: 'URLOrder',
                    type: 'string'
                },    
                {
                    
                     name: 'quickLinkName',
                    type: 'string'
                },
                {
                    
                    name: 'quickLinkURL', 
                    type: 'string'
                },
                {
                   
                    name: 'quickLinkPermanent', 
                    type: 'boolean'
                }
            ]
                  
        });
  
    var checkColumn = new Ext.grid.CheckColumn({
        header:'Is Permanent ?',
        dataIndex: 'quickLinkPermanent',
        id: 'check',
        width: 100
    });
 
    var cm = new Ext.grid.ColumnModel({
        // specify any defaults for each column
        defaults: {
            sortable: true // columns are not sortable by default           
        },
        columns: [
            { id: 'quickLinkName',
                header: NameLabel, 
                dataIndex: 'quickLinkName',
                height:100,
                width: 200,
                editor: new fm.TextField({
                    allowBlank: true,
                    listeners: {
                        render: function(c) {
                            Ext.QuickTips.register({
                                target: c.getEl(),
                                text: UrlNameLabel
                            });
                            c.getEl().on('keydown', function(e,txt){                          
                                if(e.getKey() == 13 || e.getKey() == 9){ 
                                    strvalue = txt.value;
                                    replaceSpecialChars();
                                    txt.value =  strvalue;                                              
                                }
                            });
                            c.getEl().on('change', function(e,txtnew, txtold){                                                
                                strvalue = txtnew.value;
                                replaceSpecialChars();    
                                txtnew.value = strvalue ;                 
                            }); 
                        }
                    } 
                })
            },
            { id: 'quickLinkURL',
                header: URLLabel,
                height:100, 
                //width: 290, 
                width: 600, 
                dataIndex: 'quickLinkURL',
                editor: new fm.TextField({
                    allowBlank: true,
                    listeners: {
                        render: function(c) {
                            Ext.QuickTips.register({
                                target: c.getEl(),
                                text: UrlLinkLabel
                            });
                        }
                    }
                })               
            }
             
        ]
    });
  
   
    grid = new Ext.grid.EditorGridPanel({
        // specify any defaults for each column
        id: 'faqCategoryGrid',
        store: store,
        //renderTo: 'faqCategory-grid',
        cm: cm,
        //sm:sm,
        //clicksToEdit: 1,
        stripeRows: true,
        plugins: checkColumn,
        selModel: new Ext.grid.RowSelectionModel({singleSelect : true}),
        //autoExpandColumn: 'quickLinkURL',
        height: 200,
        width: 800,
        autoWidth: true,
        viewConfig: {
                //headersDisabled: true ,// disable grid headers
                forceFit:true,
                scrollOffset: 0,
                getEditorParent: function() {
                    return this.mainWrap.dom;
                }
        },
        listeners: {
            rowclick:function(grid, r, e) {
                selectedRowIndex=r;
                rowIndex=r;
				if(document.getElementById(quicklink).checked)
				{
				   Ext.getCmp('deleteId').setDisabled(false);
				}
                var tempRecord= Ext.getCmp('faqCategoryGrid').store;
                var linkName = tempRecord.getAt(selectedRowIndex).get('quickLinkName');
                var linkURL = tempRecord.getAt(selectedRowIndex).get('quickLinkURL');
                 
                // Enable/disable up down buttons
                var numOfrecord = store.data.length;
                if(selectedRowIndex == 0 || numOfrecord == 1){
                    Ext.getCmp('upBtn').setDisabled(true);
                }
                else{   
					if(document.getElementById(quicklink).checked)
                    Ext.getCmp('upBtn').setDisabled(false);
                }
                if((selectedRowIndex == (numOfrecord - 1)) || (numOfrecord == 1)){
                    Ext.getCmp('downBtn').setDisabled(true);
                }
                else{      
					if(document.getElementById(quicklink).checked)
                    Ext.getCmp('downBtn').setDisabled(false);
                }
                //disable if emptyRow is selected
                if((linkName == null || linkName == '') && (linkURL == null || linkURL == '')){
                    Ext.getCmp('upBtn').setDisabled(true);
                    Ext.getCmp('downBtn').setDisabled(true);
                }  
            },
            afteredit: function(e){
                //refresh();
            }
        }       
    });

    grid.render('faqCategory-grid');
    //grid.getSelectionModel().selectFirstRow();
    Ext.QuickTips.init();  
        var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'quickBtnToolbar',
            defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
        });
        new SamplePanel({
            title: '',
            cls:'toolSpCls',
            bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
            tbar: [ {
                    scale: 'medium',
                    iconCls: 'addCls',
                    tooltipType : 'title',
                    tooltip: newLabel,
                    id:'newId',
                    //hidden:disableTrue,
                    listeners: {
                        mouseover: function(){
                            this.setIconClass('addCls');    
                        },
                        mouseout: function(){
                            this.setIconClass('addCls');          
                        }
                    },     
                    handler : function(){
                        var totalRows = grid.getStore().getCount();
                        var Cat = grid.getStore().recordType;
                        var p = new Cat({
                        category: '',
                        description: ''
                        
                        });
                        grid.stopEditing();
                        store.insert(totalRows, p);
                        grid.startEditing(totalRows, 0);
                    }
                } ,' ',{
                    scale: 'medium',
                    iconCls: 'deleteCls',
                    tooltipType : 'title',
                    tooltip: deleteLabel,
                    disabled : true,
                    id:'deleteId',
                    listeners: {
                        mouseover: function(){
                            this.setIconClass('deleteCls');    
                         },
                         mouseout: function(){
                            this.setIconClass('deleteCls');          
                         }
                    },              
                    handler: removeHandler

                },' ',{
                xtype: 'box',
                id: 'upBtn',
                disabled: true,
                autoEl: {tag: 'img', src:''+resourcesfilesvar+'/SDEFbuttons/b_control_up.png',title:IconUpLabel,name:'linkUp'},
                style : 'cursor:pointer;',
                listeners:{
                    render: function(c) {
                        c.getEl().on('click', function(){
                            UpBtnHandler();
                        });
                        c.getEl().on('mouseover', function(){
                            document.images['linkUp'].src=''+resourcesfilesvar+'/SDEFbuttons/b_control_up_mouseover.png';
                        });
                        c.getEl().on('mouseout', function(){
                            document.images['linkUp'].src=''+resourcesfilesvar+'/SDEFbuttons/b_control_up.png';
                        });
                    }
                }
            },
            {
            xtype: 'box',
            id: 'downBtn',
            disabled: true,
            autoEl: {tag: 'img', src:''+resourcesfilesvar+'/SDEFbuttons/b_control_down.png', title:IconDownLabel,name:'linkDown'},
            style : 'cursor:pointer;',
            listeners:{
                    render: function(c) {
                        c.getEl().on('click', function(){
                          DownBtnHandler();
                        });
                        c.getEl().on('mouseover', function(){
                            document.images['linkDown'].src=''+resourcesfilesvar+'/SDEFbuttons/b_control_down_mouseover.png';
                        });
                        c.getEl().on('mouseout', function(){
                            document.images['linkDown'].src=''+resourcesfilesvar+'/SDEFbuttons/b_control_down.png';
                        });
                    }
                }
            }]
        });
        // ---------------------------------End of code by Rajan----------------------------------------
        Ext.QuickTips.init();  
		if(document.getElementById(quicklink).checked)
			{
				Ext.getCmp('newId').setDisabled(false);
			}
			else
			{
				Ext.getCmp('newId').setDisabled(true);
			}
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
                        iconCls: 'bmcSave',
                        tooltipType : 'title',
                        tooltip: saveLabel,
                        id:'saveId',
                        listeners: {
                            mouseover: function(){
                                this.setIconClass('bmcSaveOn');    
                             },
                            mouseout: function(){
                                this.setIconClass('bmcSave');          
                            }
                        }, 
                        handler:SaveBtnHandler
                    },' ','-',' ',{
                        scale: 'medium',
                        iconCls: 'bmcRefresh',
                        tooltipType : 'title',
                        tooltip: undoDefaultSettingPageLabel,
                        id:'undoId',
                        //hidden:disableTrue,
                        listeners: {
                            mouseover: function(){
                                this.setIconClass('bmcRefresh');    
                             },
                            mouseout: function(){
                                this.setIconClass('bmcRefresh');          
                            }
                        },     
                        handler:ResetBtnHandler
                    }
                  ] 
        });
        enableMobile(); 
    }
 Ext.onReady(function(){
 defaultbroadcastSpeedValue = document.getElementById(broadcastSpeedValue).value;
 
 Ext.override(Ext.Slider, {
    getRatio : function(){
        var w = this.innerEl.getComputedWidth();
        var v = this.maxValue - this.minValue;
        return v == 0 ? w : (w/v);
    }
});
createSlider(defaultbroadcastSpeedValue);  
 });

function createSlider(speedVal){
	if(speedVal.length == 0)
		speedVal = 0; 
	broadcastSpeedsavevar=speedVal;		
	broadcastSpeedsavevar=2*broadcastSpeedsavevar; 
	 mySlider=new Ext.Slider({
			id:'silderid',
			renderTo: 'basic-slider',
			width: 189,
			value:parseInt(speedVal),
			increment: 1,
			minValue: 1,
			maxValue: 10,
			plugins: new Ext.ux.SliderTip(),
			listeners:{
			  change:setBroadcastSpeed
			  }       
        });
} 

     function setBroadcastSpeed(){
    if(document.getElementById('silderid') != null && typeof(document.getElementById('silderid')) != 'undefined' && document.getElementById('silderid').value=='')
        document.getElementById('silderid').value=0;
    if(document.getElementById('silderid') != null && typeof(document.getElementById('silderid')) != 'undefined')
        
        document.getElementById(broadcastSpeedValue).value=Ext.getCmp('silderid').getValue();
        
        broadcastSpeedsavevar=document.getElementById(broadcastSpeedValue).value;
		broadcastSpeedsavevar=2*broadcastSpeedsavevar;
      
        
}
function enableMyProfileFunction()
{  
   var pheader=document.getElementById(pheaderId);
   var showmyprofile=document.getElementById(shwprofile);
   if(pheader!=undefined && !pheader.checked){
   document.getElementById(shwprofile).checked=false;
   document.getElementById(shwBroadcast).checked=false;
   document.getElementById(shwprofile).disabled=true;
   document.getElementById(shwBroadcast).disabled=true;
 
   }else{
   document.getElementById(shwprofile).disabled=false;
   if(showmyprofile!=undefined && !showmyprofile.checked){
	document.getElementById(shwBroadcast).disabled=true;
	}else{document.getElementById(shwBroadcast).disabled=false;}
  
   }
}
function enableAllowUserFunction()
 {
	var showmyprofile=document.getElementById(shwprofile);
	if(showmyprofile!=undefined && !showmyprofile.checked){
	document.getElementById(shwBroadcast).checked=false;
	document.getElementById(shwBroadcast).disabled=true;
	}
	else{
	document.getElementById(shwBroadcast).disabled=false;
	}
 }        
 