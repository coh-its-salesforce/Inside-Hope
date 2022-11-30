var flagForOpenAttachment = false;

var cols = new Array(2);     
var sm = new Ext.grid.CheckboxSelectionModel(
{
	locked: false,
	 listeners:{
       'rowselect': function(sm, row, rec){
					var m = grid.getSelectionModel().getSelections();
					if(m.length > 0)
					{
						var objAttachmentRadio = document.getElementsByName('AttachFile');
						if(objAttachmentRadio.length > 1)
						{
							if(objAttachmentRadio[1].checked)
								enableAddButton();
						}
					}
        },
  'rowdeselect': function(sm, row, rec){
					var m = grid.getSelectionModel().getSelections();
					if(m.length==0)
						disableAddButton();
        }

	}
}
);

/////////// Open attachment flag /////////
function setOpenAttachmentFlag()
{
	flagForOpenAttachment = true;
}
/////////// end open attachment flag /////////

////////////////// Delete button in grid ///////////
Ext.ns('Extensive.grid');

Extensive.grid.ItemDeleter = Ext.extend(Ext.grid.RowSelectionModel, {

    width: 40,
    header: ' ',
    sortable: false,
	dataIndex: 0, // this is needed, otherwise there will be an error
    menuDisabled: true,
    fixed: true,
    id: 'deleter',
    
    initEvents: function(){
        Extensive.grid.ItemDeleter.superclass.initEvents.call(this);
        this.grid.on('cellclick', function(grid, rowIndex, columnIndex, e){
			if(columnIndex==grid.getColumnModel().getIndexById('deleter')) {
				var record = grid.getStore().getAt(rowIndex);
				var str_attachMentIdForDelete = record.get('ID');
				
				document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.str_attachMentIdForDelete).value=str_attachMentIdForDelete;
				deleteAttachmentJS();

				//grid.getStore().remove(record);
				//grid.getView().refresh();
			}
			if(columnIndex==grid.getColumnModel().getIndexById('consolidatedAttachmentID')) 
			{
				var record = grid.getStore().getAt(rowIndex);
				var str_attachMentIdToOpen = record.get('ID');
				
				if(flagForOpenAttachment)
				{
					flagForOpenAttachment = false;
					window.open('FileDownloadPage?attachmentId='+str_attachMentIdToOpen);
				}
			}
			
        });
		
		this.grid.on('mouseover', function(e){
			var index = grid.getView().findRowIndex(e.getTarget());
			if(index!==false){
			
				var deleteBtnsID = document.getElementsByName('deleteBtnID');
				if(deleteBtnsID != null && deleteBtnsID.length > 0)
				{
					for(var i=0;i < deleteBtnsID.length; i++)
					{
			
						if(i == index)
						{
							deleteBtnsID[i].style.display = 'block';
						}
						else
						{
							deleteBtnsID[i].style.display = 'none';
						}
					}
			
				}
			}
		});

		this.grid.on('mouseout', function(e){
			
			var deleteBtnsID = document.getElementsByName('deleteBtnID');
			if(deleteBtnsID != null && deleteBtnsID.length > 0)
			{
				for(var i=0;i < deleteBtnsID.length; i++)
				{
					deleteBtnsID[i].style.display = 'none';
				}
			}
		});		
		
		
    },
    
    renderer: function(v, p, record, rowIndex){
        return '<img src="'+ imgPath +'" name="deleteBtnID" style="display:none"></img>';
    }
});

//////////////// End of delete button in grid /////////

var arrCols = new Array(cols.length+1);
var cols_attachments = new Array(3);     
var arrCols_attachments = new Array(cols_attachments.length);
var itemDeleter = new Extensive.grid.ItemDeleter();

function intializeGrid()
{
	cols[0]='ID'; 
	cols[1]='SidebarItem';
	arrCols[0] = sm;
	arrCols[1] = {id:cols[0], header: cols[0], width: 10, dataIndex: cols[0], hideable: false, hidden: true};
	arrCols[2] = {id:cols[1], header: MultiDocumentAttachmentPage.Labels.fileColumnHeader, sortable: true, dataIndex: cols[1]};
}

function intializeGridForAttachments()
{
	cols_attachments[0]='ID'; 
	cols_attachments[1]='consolidatedAttachmentID';
	cols_attachments[2]='Delete';
	arrCols_attachments[0] = {id:cols_attachments[0], header: cols_attachments[0], width: 10, dataIndex: cols_attachments[0], hideable: false, hidden: true};
	arrCols_attachments[1] = {id:cols_attachments[1], header: MultiDocumentAttachmentPage.Labels.Attachment_Grid_Header, sortable: true, 		  dataIndex: cols_attachments[1]};
	arrCols_attachments[2] = itemDeleter;
}


var grid;
var grid_attachments;
function renderGrid(){
	intializeGrid();
	
    if(grid!=null) { grid.store.loadData(resultSet); return; }
    Ext.QuickTips.init();
    var xg = Ext.grid;
    // shared reader
    var reader = new Ext.data.ArrayReader({}, cols);
    var store = new Ext.data.Store({
        reader: reader, data: resultSet
    });
    grid = new xg.GridPanel({
        store: store,
		enableHdMenu :false,
        cm: new xg.ColumnModel({
            defaults: {sortable: true},
            columns:arrCols
        }),
        sm: sm, viewConfig: {scrollOffset: 0,forceFit: true},       
        width:336,

        stripeRows:true,
        height:97,
        listeners: {
		//added to fix bug 1818
        	sortchange: function(){
        		var colIndex = grid.getColumnModel().getIndexById('checker');
				var headerCell = grid.getView().getHeaderCell(colIndex);
				var headerCB = Ext.getDom(headerCell).childNodes[0];
				var isChecked = Ext.fly(headerCB).hasClass('x-grid3-hd-checker-on');
				if(isChecked == true){
 					sm.unlock();
                	sm.selectAll();
                	sm.lock();
				} 
        	},
             afterrender: function() {
                 //setSelectedRows();
             }, delay: 1000
        }
    });    
    grid.render('grid');
  }
function extInit(){
    renderGrid();  
	renderGridForConsolidatedAttachments();
	showErrorJS();
	changeTextForStandardLayout();
}

function changeTextForStandardLayout(){
 if(stdLayout == 'true'){
	 document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.save_attachmentID).title = stdLayoutSaveAttachmentToolTip;
	 document.getElementById('saveAttachmentSpanID').innerHTML = stdLayoutSaveAttachment;
	 }
}

function showErrorJS(){
    if(errorMessage != null && errorMessage != '' && typeof(errorMessage)!='undefined'){
        Ext.MessageBox.show({                       
                    title: ' ',
                    msg:errorMessage,
                    width:300,
                    height:'auto',
                    buttons: Ext.MessageBox.OK
                }); 
      }          
}
        
function enableDisableOkButton()
{
	if(resultSet_consolidated != null && resultSet_consolidated != 'undefined' && resultSet_consolidated.length > 0)
	{
		document.getElementById('okBtnID').className ='bgBtnGrey';
		document.getElementById('okBtnID').disabled=false;
		document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.save_attachmentID).disabled=false;
	}
	else
	{
		document.getElementById('okBtnID').className ='buttonDisabled';
		document.getElementById('okBtnID').disabled=true;
		document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.save_attachmentID).disabled=true;
	}
}

function enableAddButton()
{
	document.getElementById('addBtn').className ='bgBtnGrey';
	document.getElementById('addBtn').disabled=false;
}

function disableAddButton()
{
	document.getElementById('addBtn').className='buttonDisabled';
	document.getElementById('addBtn').disabled=true;
}

function enableBrowseButton()
{
	document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].disabled=false;
}

function disableBrowseButton()
{
	document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].value='';
	document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].disabled=true;
	var m = grid.getSelectionModel().getSelections();
	if(m.length==0)
		disableAddButton();
	else
		enableAddButton()
}

var grid_for_consolidated_attachments;
function renderGridForConsolidatedAttachments(){
	intializeGridForAttachments();
	/////////////////////////
	if(grid_attachments!=null) { grid_attachments.store.loadData(resultSet_consolidated); return; }
    Ext.QuickTips.init();
    var xg = Ext.grid;
    // shared reader
    var reader = new Ext.data.ArrayReader({}, cols_attachments);
    var store = new Ext.data.Store({
        reader: reader, data: resultSet_consolidated
    });
	
    grid_attachments = new xg.GridPanel({
        store: store,
		enableHdMenu :false,
        cm: new xg.ColumnModel({
            defaults: {sortable: true},
            columns:arrCols_attachments
        }),
		selModel: itemDeleter,
		cls: 'attachMentGrid',
        width:336,
		viewConfig: {scrollOffset: 0,forceFit: true}, 
        stripeRows:true,
        height:97,
		enableColumnResize :false
    });    
   grid_attachments.render('grid_attachments');
	////////////////////////////
}

Ext.apply(Ext.grid.CheckboxSelectionModel.prototype, {
onHdMouseDown : function(e, t){
        if(t.className == 'x-grid3-hd-checker'){
            e.stopEvent();
            var hd = Ext.fly(t.parentNode);
            var isChecked = hd.hasClass('x-grid3-hd-checker-on');
			var objAttachmentRadio = document.getElementsByName('AttachFile');
			if(objAttachmentRadio.length > 1)
			{
				if(objAttachmentRadio[1].checked)
				{
					if(isChecked){
					   sm.unlock();
						hd.removeClass('x-grid3-hd-checker-on');
						this.clearSelections();
					}else{
						  hd.addClass('x-grid3-hd-checker-on');
						  this.selectAll();
				   //sm.lock();
					   
					}
				}
			}
        }
    }
    });
	

function enableDisableControls()
{
	var objAttachmentRadio = document.getElementsByName('AttachFile');
	if(objAttachmentRadio.length > 1)
	{
		if(objAttachmentRadio[1].checked)
		{
			disableBrowseButton();
			sm.unlock();
		}
		else if(objAttachmentRadio[0].checked)
		{
			grid.getSelectionModel().clearSelections();
			sm.lock();
			enableBrowseButton();
		}
	}
}
	
	
function getAttachmentsFromIncidentGridOrSystem()
{
	var objAttachmentRadio = document.getElementsByName('AttachFile');
	
	if(objAttachmentRadio.length > 1)
	{
		if(objAttachmentRadio[1].checked)
		{
			getAttachmentsFromIncidentGrid();
		}
		else if(objAttachmentRadio[0].checked)
		{
			getAttachmentsFromSystem();
		}
	}
}	

function getAttachmentsFromSystem()
{
	attachFileJS();
}

function getAttachmentsFromIncidentGrid(){
   
    var conditionString=''; 
    var m = grid.getSelectionModel().getSelections();   
	
	if(document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.str_Incident_attachments).value != '')
		conditionString = document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.str_Incident_attachments).value;
	
    for(j=0; j < m.length; j++){
       conditionString = conditionString + m[j].get(cols[0])+",";
    }
	
    document.getElementById(MultiDocumentAttachmentPageComp.ComponentVars.str_Incident_attachments).value=conditionString;
	
	pageReloadJS();
  
}
/*
function setSelectedRows(){
   var selectedRecs=","+document.getElementById("{!$Component.selectedPortlets}").value+",";        
      var str = grid.getStore();
       for (var i = 0; i < str.getCount(); i++) {    
        for (var i = 0; i < str.getCount(); i++) {   
          if(selectedRecs.indexOf(","+str.getAt(i).get(cols[0])+",")!=-1){
            grid.getSelectionModel().selectRow(i, true);
        }   
    }
           
       
    }
}*/

sm.on('selectionchange', function(){


      var hd = Ext.fly(this.grid.getView().innerHd).child('div.x-grid3-hd-checker');
            //Remove the checked class if store is empty or all items not checked
       
            if ( (this.grid.getStore().getCount() == 0) || (this.getCount() < this.grid.getStore().getCount()) ) {
                hd.removeClass('x-grid3-hd-checker-on');
                          } else {
                hd.addClass('x-grid3-hd-checker-on');
               
         }   
            
    });

	Ext.onReady(extInit);

	
	function validateFile()
	{
		var file = document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].value;
		
		if(file != null && file != '' && file != 'null')
		{
			//document.getElementById('addBtn').disabled=false;
			enableAddButton();
			
			var v = document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].value;
			var filename = v.replace(/^.*\\/, '') ;
			var fileLength=filename.length;
			if(fileLength > 50){
			   //showMessage();
				 Ext.MessageBox.show({                       
                    title: ' ',
                    msg:MultiDocumentAttachmentPage.Labels.Attachment_File_Name_Length_Validation,
                    width:300,
                    height:'auto',
                    buttons: Ext.MessageBox.OK
                });
			  
			   //document.getElementById('addBtn').disabled=true;
			   disableAddButton();
				document.getElementsByName(MultiDocumentAttachmentPageComp.ComponentVars.inputfile+':inputFile:file')[0].value=null;
			}else{
				document.getElementById('errorDiv').innerHTML = '';
				//document.getElementById('addBtn').disabled=false;
				enableAddButton();
			}
			
		}
	}