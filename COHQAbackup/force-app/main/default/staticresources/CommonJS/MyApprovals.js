var ds ;
var approveflag = 0;
var rejectflag = 0;
var myData = '';
var order = 'DESC';
var idSet;
var viewport = null;
var queue_grid;
var toolbarOptions = new Array(20);
var approvedRadioClicked = 0;
var rejectedRadioClicked = 0;
var pendingRadioClicked = 1;
var assignedToMe = 'checked';
var clickedheader = 0;

var hasPrev = 0;
var nextBtnClicked = 0;
var prevBtnClicked = 0;
var currentPageCount = 0;
var applyfilterflag = 0 ;
function pgRefresh(){
	
	if(approvedRadioClicked){
		getApproveRecords('Approved', assignedToMe, 'true', 'setPageCount');
	}
	if(rejectedRadioClicked){
		getRejectedRecords('Rejected', assignedToMe, 'true', 'setPageCount');
	}
	if(pendingRadioClicked){
		getpendingRecords(assignedToMe, 'true', 'setPageCount');
	}
}


/*
  viewRequest : To open the incident/Change Records in the Incident Page or Change Request Page Respectively.
  Task : To Change the comparison Condition.
*/
function viewRequest(){
          var pGrid = Ext.ComponentMgr.get('queuegrid_id');
          var gridrecord = pGrid.getSelectionModel().getSelected();
          var index = pGrid.getStore().indexOf(gridrecord);
          var recordId = pGrid.getStore().getAt(index).get('RecordId');
          var flag = 0;
          var recordName = pGrid.getStore().getAt(index).get('RecordName');
          var url ;
		  /*
		    If it is a change record open Change Request Page.
		  */
		  if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.changeLabel){
				url= "NavigatorPage?&title="+encodeURIComponent(recordName)+"&target=ChangeRequestPage?id="+recordId;
				window.parent.parent.addNewTab("ChangeRequestPage", QueueListViewPage.Labels.Change_Requests,url);  
		  }
		  /*
		   Else if it is a Incident record open the Incident Page
		   
		  */
		   if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.incidentLabel){
				url= "NavigatorPage?&title="+encodeURIComponent(recordName)+"&target=IncidentPage?id="+recordId;
				window.parent.parent.addNewTab("IncidentPage", QueueListViewPage.Labels.IncidenPluralLabel,url);  
		  }
		  
		  
}

/*
 renderToRecord: to open the approval page.

*/
function renderToRecord(){
	var pGrid = Ext.ComponentMgr.get('queuegrid_id');
	var gridrecord = pGrid.getSelectionModel().getSelected();
	var index = pGrid.getStore().indexOf(gridrecord);
	var RecordId = pGrid.getStore().getAt(index).get('RecordId');
	var flag = 0;
	var RecordName = pGrid.getStore().getAt(index).get('RecordName');
	if(pGrid.getStore().getAt(index).get('Status') == 'Pending'){
		var WorkItemId = pGrid.getStore().getAt(index).get('WorkItemOrStepId');		
		/*
		 if the record to opened on ChangeApprovalPage is change
		
		*/
		if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.changeLabel){
			window.parent.addTab("Changeapproval?CAid="+WorkItemId+"&id="+WorkItemId+"&navFlag=TRUE&CAFlag=true&ChangeId="+RecordId+"&title="+encodeURIComponent(RecordName), RecordName, RecordName);
	     }
		/*
		 if the record to opened on ChangeApprovalPage is Incident
		
		*/
		
		if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.incidentLabel){
			window.parent.addTab("Changeapproval?CAid="+WorkItemId+"&id="+WorkItemId+"&navFlag=TRUE&CAFlag=true&IncidentId="+RecordId+"&title="+encodeURIComponent(RecordName), RecordName, RecordName);
			
		}
		
	}else{
		var StepId = pGrid.getStore().getAt(index).get('WorkItemOrStepId');
		if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.changeLabel){
			window.parent.addTab("Changeapproval?CAid="+StepId+"&id="+StepId+"&navFlag=TRUE&CAFlag=false&ChangeId="+RecordId+"&title="+encodeURIComponent(RecordName), RecordName, RecordName);
		}
		if(pGrid.getStore().getAt(index).get('Type')==QueueListViewPage.Labels.incidentLabel){
			window.parent.addTab("Changeapproval?CAid="+StepId+"&id="+StepId+"&navFlag=TRUE&CAFlag=false&IncidentId="+RecordId+"&title="+encodeURIComponent(RecordName), RecordName, RecordName);
		}
		
	}
	
}
   
Ext.onReady(function(){
    Ext.QuickTips.init();
    
    if(rejectflag == 0 && approveflag == 0){
    	getpendingRecords(assignedToMe, '', 'setPageCount');
    }
    
    myData = '';
    
    var refreshButton = new Ext.Button( {
		id : 'refreshButtonId',		 
		scale: 'medium',		
		iconCls :'bmcRefreshDasboard',
		tooltipType : 'title',
		tooltip: QueueListViewPage.Labels.refresh,
		handler: refreshHandler,
		listeners: {
			mouseover: function(){
				this.setIconClass('bmcRefreshDasboardOn');    
			},
			mouseout: function(){
				this.setIconClass('bmcRefreshDasboard');          
			}
		}
	});
	
	function refreshHandler(){
		applyfilterflag = 1;
		Ext.getCmp('prevId').setDisabled(true);
		
		if(approvedRadioClicked){
			getApproveRecords('Approved', assignedToMe,'true', 'setPageCount');
		}
		if(rejectedRadioClicked){
			getRejectedRecords('Rejected', assignedToMe,'true', 'setPageCount');
		}
		if(pendingRadioClicked){
			getpendingRecords(assignedToMe,'true', 'setPageCount');
		}
	}
     var filterMenus = new Array(7);
        filterMenus[0] = {xtype:'radio', id:'PendingRadioId', checked: true, name: 'shmy', group: 'shmy',  iconCls: 'emptyIcon', boxLabel: QueueListViewPage.Labels.Pending, inputValue: 1};
        filterMenus[1] = {xtype:'radio', id:'ApprovedRadioId', name: 'shmy', group: 'shmy',  iconCls: 'emptyIcon', boxLabel: QueueListViewPage.Labels.Approved, inputValue: 2};
        filterMenus[2] = {xtype:'radio', id: 'RejectedRadioId', name: 'shmy', group: 'shmy',  iconCls: 'emptyIcon', boxLabel: QueueListViewPage.Labels.Rejected, inputValue: 3};
        filterMenus[3] = '-';
        filterMenus[4] = {xtype:'checkbox', id: 'AssignedToMeChkId', checked: true, name: 'AssignedToMeChkName', group: 'AssignedToMeChkGrp',  iconCls: 'emptyIcon', boxLabel: QueueListViewPage.Labels.AssignedToMe};
        filterMenus[5] = '-';
        filterMenus[6] = {text: QueueListViewPage.Labels.Apply, iconCls: 'mnuList', handler: applyFilter};
        var tbarOptions = new Array(5);
        tbarOptions[0] = {iconCls: 'bmcView1', tooltip: QueueListViewPage.Labels.views, tooltipType: 'title', scale: 'medium', menu: filterMenus};
        tbarOptions[1] = refreshButton;
		tbarOptions[2] = new Ext.Toolbar.Fill();
        tbarOptions[3] =  {xtype : 'box', autoEl:  {tag: 'img', src:getSDFStylesResPath() + '/SDEFbuttons/b_previous.gif', title:QueueListViewPage.Labels.previouspage }, disabled:true,cls:'cursorCls',id:'prevId',listeners : { render: function(f){f.el.on('click', PreviousBtnHandler)}}};
        tbarOptions[4] =  {xtype : 'box', autoEl:  {tag: 'img', src:getSDFStylesResPath() + '/SDEFbuttons/b_next.gif', title:QueueListViewPage.Labels.nextpage }, id:'nextId',cls:'cursorSpaceCls', listeners : { render: function(f){f.el.on('click', NextBtnHandler)}}}; 
        var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'grid',
            border: false,
            defaults: {bodyStyle:'padding:0px;margin:0px;zoom:0px;'}
        }); 
        var mnuBar=new SamplePanel({
            border: true,
            //bodyStyle:'padding:0px;margin:0px;zoom:0px;',
            //cls:'mnuBarCls' ,
            tbar: tbarOptions,
            id:'mnuBarId'
        });
    Ext.getCmp('prevId').setDisabled(true); 

    function NextBtnHandler(){
		if(nextFlag != 1){
		
			var nextRecord = '';
			if(approvedRadioClicked){
				nextRecord = 'Approved';
				if(clickedheader == 4){
					nextApprovedRecords('Next', nextRecord, '', '', order, 'true', assignedToMe, 'assignedtoflag');
				}
				if(clickedheader == 5){
					nextApprovedRecords('Next', nextRecord, 'CreatedDate',order, '', 'true', assignedToMe, 'assignedtoflag');
				}
				if(clickedheader == 0){
					nextApprovedRecords('Next', nextRecord, '', '', '', '',assignedToMe, 'assignedtoflag');
				}    		

			}
			if(rejectedRadioClicked){
				nextRecord = 'Rejected';
					
				if(clickedheader == 4){
					nextRejectedRecords('Next', nextRecord, '', '', order, 'true', assignedToMe, 'assignedtoflag');
				}
				if(clickedheader == 5){
					nextRejectedRecords('Next', nextRecord, 'CreatedDate',order, '', 'true', assignedToMe, 'assignedtoflag');
				}
				if(clickedheader == 0){
					nextRejectedRecords('Next', nextRecord, '', '', '', '', assignedToMe, 'assignedtoflag');
				}    		
				
			}
			if(hasNext == 'true'){
				if(pendingRadioClicked){
					nextRecord = 'Pending';
					if(clickedheader == 4){
						
						nextRecords('Next', nextRecord, order, '', '', assignedToMe, 'assignedtoflag');
					}
					if(clickedheader == 5){
						nextRecords('Next', nextRecord, '', 'CreatedDate',order, assignedToMe, 'assignedtoflag');
					}
					if(clickedheader == 0){
						nextRecords('Next', nextRecord, '', '', '',  assignedToMe, 'assignedtoflag');
					}    		
				}
			}
		}
    	
    }
    function PreviousBtnHandler(){
    	
    	if(hasPrev != 0){
	    	var prevRecord = '';
	    	if(approvedRadioClicked){
	    		prevRecord = 'Approved';
	    		if(clickedheader == 4){
	    			nextApprovedRecords('Prev', prevRecord, '', '', order, 'true', assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 5){
		    		nextApprovedRecords('Prev', prevRecord, 'CreatedDate',order, '', '', assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 0){
		    		nextApprovedRecords('Prev', prevRecord, '', '', '', '', assignedToMe, 'assignedtoflag');
		    	}    		
	    	}
	    	if(rejectedRadioClicked){
	    		prevRecord = 'Rejected';	
	    		
	  			if(clickedheader == 4){
	    			nextRejectedRecords('Prev', prevRecord, '', '', order, 'true', assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 5){
		    		nextRejectedRecords('Prev', prevRecord, 'CreatedDate',order, '', 'true', assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 0){
		    		nextRejectedRecords('Prev', prevRecord, '', '', '', '', assignedToMe, 'assignedtoflag');
		    	}       		
	    	}
	    	if(pendingRadioClicked){
	    		prevRecord = 'Pending';
	    		if(clickedheader == 4){
	    		
		    		nextRecords('Prev', prevRecord, order,'', '', assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 5){
		    		nextRecords('Prev', prevRecord, '', 'CreatedDate',order, assignedToMe, 'assignedtoflag');
		    	}
		    	if(clickedheader == 0){
		    		nextRecords('Prev', prevRecord, '', '', '', assignedToMe, 'assignedtoflag');
		    	}
	    	}
    	}
    }
    function applyFilter(){
		applyfilterflag = 1;
    	Ext.getCmp('prevId').setDisabled(true);
    	
        order = 'DESC';
        if(document.getElementById('AssignedToMeChkId').checked){
        	assignedToMe = 'checked';
        }else{
        	assignedToMe = 'unchecked';	
        } 
        if(document.getElementById('PendingRadioId').checked){
			pendingRadioClicked = 1;
			approvedRadioClicked = 0;
			rejectedRadioClicked = 0;
            getpendingRecords(assignedToMe, 'true', 'setPageCount');
        }
        if(document.getElementById('ApprovedRadioId').checked){
            rejectflag =1;approveflag=1; 
			pendingRadioClicked = 0;
			approvedRadioClicked = 1;
			rejectedRadioClicked = 0;
            getApproveRecords('Approved', assignedToMe, 'true', 'setPageCount');
            
        }
        if(document.getElementById('RejectedRadioId').checked){rejectflag =1;approveflag=1; 
			pendingRadioClicked = 0;
			approvedRadioClicked = 0;
			rejectedRadioClicked = 1;
            getRejectedRecords('Rejected', assignedToMe, 'true', 'setPageCount');
        }
		currentPageCount = 0;
    }
   
    function renderQueueGrid(){		        
        myData =returnData();
		/*
			10/20/2011
			Updated code, removed extjs popup for no records message. 
		*/
        idSet = returnIDset();
		window.parent.listOfId(idSet);    
        function addLink(data, metadata, record, rowIndex, columnIndex, store){   
            var modData='<a href = "#" onclick=" viewRequest();" oncontextmenu="return false;">'+data+'</a>';
            return modData; 
        }
        function addActionLink(data, metadata, record, rowIndex, columnIndex, store){
            var modData='<a href = "#" onclick=" renderToRecord();" oncontextmenu="return false;">'+data+' </a>';
            return modData;
        } 
        var sm = new Ext.grid.CheckboxSelectionModel({
               
        });
        var cm = new Ext.grid.ColumnModel([
            {
               id: 'Action_Id',
               header: QueueListViewPage.Labels.Change_Approval_Action,
               dataIndex: 'Action',              
               renderer: addActionLink
            },{
               id: 'Type',
               header: QueueListViewPage.Labels.Type,
               dataIndex: 'Type'
            },{
               id: 'Record_Id',
               header: QueueListViewPage.Labels.Approval_record,
               dataIndex: 'RecordName',
               renderer: addLink
               
            },{
               id: 'Status_Id',
               header: QueueListViewPage.Labels.Change_Approval_Status,
               dataIndex: 'Status'
               
            },{
               id: 'Approver_Id',
               header: QueueListViewPage.Labels.Change_Approval_Approver,
               dataIndex: 'Approver'
               
            },
            {
               id: 'Submitted_Date_Id',
               header: QueueListViewPage.Labels.Change_Approval_Submitted_Date,
               dataIndex: 'Submitted_Date'
            }
        ]);
        ds = new Ext.data.Store({
            reader: new Ext.data.ArrayReader({}, [ 
            		{name: 'Action'},                    
                    {name: 'Status'},            
                    {name: 'RecordId'},
                    {name: 'RecordName'},
                    {name: 'Approver'},
                    {name: 'Submitted_Date'},
                    {name: 'WorkItemOrStepId'},
					{name: 'Type'}
                 ])
        });
        
        
        ds.loadData(myData);

        queue_grid = new Ext.grid.EditorGridPanel({
            id: 'queuegrid_id', 
            store: ds,
            layout: 'fit',
            cm: cm,
            sm: sm,            
            anchorSize: '100%',
            height: 500,
            frame: true,
            clicksToEdit: 1,           
            enableHdMenu:false,
            cls: 'no-dirty-mark',
            stripeRows: true,
            viewConfig: {
                                forceFit: true,
                                scrollOffset:0,
								emptyText:QueueListViewPage.Labels.NoRecordsFound
                        }                    
        });
    
        queue_grid.on('resize', function(queue_grid, columnIndex,e ){ 
        	setGridHeight(queue_grid.getInnerHeight());
        });
        
        queue_grid.on('headerclick', function(queue_grid, columnIndex,e ){ 
			applyfilterflag = 1;
        	
    	 	var imgPath='';
    	 	clickedheader = columnIndex;
			if(order == 'DESC'){
					imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_ascending.gif';
			}else{
					imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_descending.gif';
			}
			var v = queue_grid.getColumnModel().getColumnHeader(columnIndex);
			
    	 	if(columnIndex == 4){
    	 		
    	 		if(order == 'ASC'){
    	 			order = 'DESC';
    	 		}else{
    	 			order = 'ASC';
    	 		}
    	 		
    	 		if(approvedRadioClicked == 1){
    	 			sortApprovedByApprover(order, 'Approved', assignedToMe, 'true', 'setPageCount');
    	 		}
    	 		if(rejectedRadioClicked == 1){
    	 			sortRejectedByApprover(order, 'Rejected', assignedToMe, 'true', 'setPageCount');
    	 		}
				if(pendingRadioClicked == 1){
    	 			sortPendingByApprover(order, assignedToMe, 'true', 'setPageCount');
    	 		}
    	 	}
    	 	if(columnIndex == 5){
    	 		if(order == 'ASC'){
    	 			order = 'DESC';
    	 		}else{
    	 			order = 'ASC';
    	 		}
    	 		
    	 		if(approvedRadioClicked == 1){
    	 			sortApprovedByColumnName('CreatedDate',order, 'Approved', assignedToMe, 'true', 'setPageCount');
    	 		}
    	 		if(rejectedRadioClicked == 1){
    	 			sortRejectedByColumnName('CreatedDate',order, 'Rejected', assignedToMe, 'true', 'setPageCount');
    	 		}
				if(pendingRadioClicked == 1){
    	 			sortPendingByColumnName('CreatedDate',order, assignedToMe, 'true', 'setPageCount');
    	 		}
    	 	}
        }); 
    }
    
	
	function renderViewPort(){
        if(viewport!=null) {
			return;
		}

		viewport = new Ext.Viewport({
			layout:'border',
			border:false,
			items:[
				  {region:'center', id:'queuegridPanel', layout:'fit', margins:'35 0 0 0',items:[queue_grid]}
			]
		});	
	}
    renderQueueGrid();
	renderViewPort();

});
function showFrameHelp(stringpassedfromnav)
{            
	var Modulenameforhelp= "ChangeApproval";
	 OpenHelppage(Modulenameforhelp,'module',stringpassedfromnav);
}