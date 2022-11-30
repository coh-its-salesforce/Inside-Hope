var showFooterPanel=true;
var NewBtnHandler = function(button,event) { 
 
        var rval=new Array(1);
            if(isRequestCatalog == 'true')
			   rval[0]='OpenCategoryPageFromRequestDef'; 
			else
			   rval[0]='OpenCategoryPage';  			
            window.parent.setPopUpVar(rval);
            parent.window.closePopup();
      };
	  
function changeGrouping() {
        var combo = Ext.getCmp('groupoptions');
        var selectedfield = Ext.getCmp('groupoptions').getValue();
        document.getElementById("selectedCategory").value= Ext.getCmp('groupoptions').getValue();
        renderTree();        
        } 
		
function SendValueToParent(a){ 
	window.parent.setPopUpVar(a);
	parent.window.closePopup();
         
}
    
function pageRefresh(){
	 window.location.reload();
 }
 
Ext.onReady(function()
{	
	Ext.QuickTips.init();
	var nwdate = new Date(); // ********* 
	var nwstart = nwdate.getTime();
	Nwlatency = nwstart - getServerendtime();
	clookupdata += labelPMServerTime;
	clookupdata += servertime;
	clookupdata += '<br>';
	clookupdata += labelNwLatency;
	clookupdata += Nwlatency;
	clookupdata += '<br>'; // *******
	showCategoryList = getshowCategoryList();
	if(showCategoryList){ 
		if (isRequestCatalog)
		document.getElementById('categoryListPage').innerHTML='<iframe id="categoryListFrameId" name="categoryListFrame" frameborder="0" scrolling="no" src ="/apex/SearchPage?popupId=Category&pgheight=750&wid=1&isLookup=true&disableFirstColLink=true&hideIncidentCat=true&filterClause='+escape('inactive__c = false')+'" style="width:100%;height:100%;border:none;"/>';
		else if (popupId != null && popupId != 'null' && popupId.toLowerCase() == 'incident') 
			document.getElementById('categoryListPage').innerHTML='<iframe id="categoryListFrameId" name="categoryListFrame" frameborder="0" scrolling="no" src ="/apex/SearchPage?popupId=Category&pgheight=750&wid=1&isLookup=true&disableFirstColLink=true&showFilterMenu=true&pId=incident&filterClause='+escape('inactive__c = false')+'" style="width:100%;height:100%;border:none;"/>';
		else
			document.getElementById('categoryListPage').innerHTML='<iframe id="categoryListFrameId" name="categoryListFrame" frameborder="0" scrolling="no" src ="/apex/SearchPage?popupId=Category&pgheight=750&wid=1&isLookup=true&disableFirstColLink=true&filterClause='+escape('inactive__c = false')+'" style="width:100%;height:100%;border:none;"/>';
	}else{ 
	document.getElementById('categoryListPage').style.display ='none';
	if (popupId != null && popupId != 'null' && popupId.toLowerCase() == 'incident') {
		new Ext.Toolbar({
				 renderTo: 'btntoolbar',
				 items: [{
				 scale: 'medium',
				 tooltipType : 'title',
				 disabled: isNewButtonDisable,
				 tooltip: labelNew,
				 iconCls: 'bmcNew',
				 id : 'categoryNew',
				 listeners: {
				  mouseover: function(){
				  this.setIconClass('bmcNewOn');    
				  },
				   mouseout: function(){
				   this.setIconClass('bmcNew');          
				 }
			},
			 handler:NewBtnHandler
			},' ','-',' ',			
			filterMenuPanel
			,' ','-',' ',
			 cmbbx ,
	   
			' ','  ',' ',srchTxtFld,{xtype: 'spacer',width:Ext.isIE?20:5},{iconCls: 'bmcSearch',tooltip: labelSearch, tooltipType: 'title',id:'categorySearch', handler: txtSearch},' ',' ',' ',{scale: 'medium', iconCls: 'bmcRefresh', tooltip: labelRefresh, tooltipType: 'title', style:{align: 'left'},id:'categoryRefresh',handler: pageRefresh}
		
		 ]
		});
	}
	else {
		new Ext.Toolbar({
				 renderTo: 'btntoolbar',
				 items: [{
				 scale: 'medium',
				 tooltipType : 'title',
				 disabled: isNewButtonDisable,
				 tooltip: labelNew,
				 iconCls: 'bmcNew',
				 id : 'categoryNew',
				 listeners: {
				  mouseover: function(){
				  this.setIconClass('bmcNewOn');    
				  },
				   mouseout: function(){
				   this.setIconClass('bmcNew');          
				 }
			},
			 handler:NewBtnHandler
			},' ','-',' ',
			 cmbbx ,
	   
			' ','  ',' ',srchTxtFld,{xtype: 'spacer',width:Ext.isIE?20:5},{iconCls: 'bmcSearch',tooltip: labelSearch, tooltipType: 'title',id:'categorySearch', handler: txtSearch},' ',' ',' ',{scale: 'medium', iconCls: 'bmcRefresh', tooltip: labelRefresh, tooltipType: 'title', style:{align: 'left'},id:'categoryRefresh',handler: pageRefresh}
		
		 ]
		});
	}
         
      var specialKey=function ( field, e ) {
            if ( e.getKey() == e.RETURN || e.getKey() == e.ENTER ) {
              if(document.getElementById(cancelBtnId) != null)
	      {
	         document.getElementById(cancelBtnId).disabled=true;
	      }
              txtSearch();
		}
    }
    srchTxtFld.on("specialkey", specialKey);
	var treeHeight = 193 ;
	if(isRequestCatalog == 'true'){
		treeHeight = 395; 
	}
    new Ext.Panel({
			renderTo: 'categoryPageTree',
			height:treeHeight,
			autoScroll: true,
			items: [
			{
				xtype: 'treepanel',
				height:treeHeight,
				width:640,
				margins: '0 10 0 0',
				autoScroll: true,
				useArrows: true,
				split: true,
				id : 'categoryTree',
				border: false,
				margins: '0 5 0 0',
				cmargins: '0 5 0 0',
				titleCollapse: true,
				loader: new Ext.tree.TreeLoader(),
				root: new Ext.tree.AsyncTreeNode({
					text : labelCatByDesc, 
					expanded: true,
				   children: categoriesObj  // <apex:outputText escape="false" value="{!categories}"/> *********************
				}),
				rootVisible: true,
				listeners: {
					click: function(n) {
						  if(n == this.getRootNode()){
							setCategoryId('','','');
						  }
						  else{
							availableForSR = n.attributes.availableForSR;
							setCategoryId(n.id,n.text,n.attributes.urgencyId);
								if(showFooterPanel != null && typeof(showFooterPanel) != 'undefined' && (showFooterPanel == true || showFooterPanel == '')){
									if(isRequestCatalog != 'true'){
									nodeClicked(n.id);
									}
								}
						  }  
														   
					},
					dblclick: function(n){
							if(n == this.getRootNode()){
									return;
							}
							availableForSR = n.attributes.availableForSR;
							setCategoryId(n.id,n.text,n.attributes.urgencyId);															
							saveCategory();
					}
				}
			}
		]
   });

   }

   function setCategoryId(catId,catName,cUrgency){  
				categoryId=catId;
				categoryName=catName;
				catUrgency = cUrgency;
				//alert('catUrgency : ' + catUrgency)	;
				//alert(catId + '|' + catName);
	} 
	if(isRequestCatalog != 'true'){
       var ds1 = new Ext.data.ArrayStore({
            fields:[{name: 'StandardDescription'}, {name: 'DescriptionID'},{name: 'ID'}],
            data:descriptionData
        });    
    
	 var ds2 = new Ext.data.ArrayStore({
		fields:[{name: 'StandardResolution'},{name: 'ResolutionID'},{name: 'ID'}],
		data:resolutionData
	});    
      
	var arrCols = new Array(3);
	arrCols[0] = {id:'StandardDescription', header: labelStandardDescription, dataIndex: 'StandardDescription'};
	arrCols[1] = {id:'DescriptionID', header:'DescriptionID', hidden: true,dataIndex: 'DescriptionID'};
	arrCols[2] = {id:'ID', header:'ID',hidden: true, dataIndex: 'ID'};

	var arrCols1 = new Array(3);
	arrCols1[0] = {id:'StandardResolution', header: labelStandardResolution, dataIndex: 'StandardResolution'};
	arrCols1[1] = {id:'ResolutionID', header:'ResolutionID', hidden: true,dataIndex: 'ResolutionID'};
	arrCols1[2] = {id:'ID', header:'ID', hidden: true,dataIndex: 'ID'};
  


desGrid = new Ext.grid.GridPanel({
    store: ds1,
    border:true,
     cm: new Ext.grid.ColumnModel({
            defaults: {sortable: true},
            columns:arrCols
        }),
   viewConfig: {scrollOffset: 0,forceFit: true},
   sm: new Ext.grid.RowSelectionModel({singleSelect:true}), 
    trackMouseOver: false,
    loadMask: true,
     height:145,
     frame:true,
    stripeRows: true,
    enableColumnMove: false,
   enableHdMenu: false,
    id:'decsriptionGrid',
    layout:'fit',
     listeners: {
		rowClick:function(grid, rowIndex, e){
		descriptionString='';
		var rec = grid.store.getAt(rowIndex);
		var id = rec.get('DescriptionID');
		descriptionString=rec.get('ID');
		handleRowClick(id);}
	}
  });
  
   var checkBoxPanel = new Ext.Panel({
      defaults     : { height : 33 },
   items:[
           {  id :'desCheckBox',
              xtype  : 'checkbox',
               width  : 37,
               checked: false
         }]   
    });
  
    var checkBoxPanel1 = new Ext.Panel({
    defaults     : { height : 33 },
   items:[
           {  id :'resCheckBox',
               xtype  : 'checkbox',
               width  : 37,
               checked: false
         }]   
    });
  

resGrid = new Ext.grid.GridPanel({
    store: ds2,
         cm: new Ext.grid.ColumnModel({
            defaults: {sortable: true},
            columns:arrCols1
            }),
   viewConfig: {scrollOffset: 0,forceFit: true},  
   sm: new Ext.grid.RowSelectionModel({singleSelect:true}),   
    trackMouseOver: false,
    loadMask: true,
    layout:'fit',
     height:145,
    frame:true,
    stripeRows: true,
    enableColumnMove: false,
    enableHdMenu: false,
   
    id:'resolutionGrid',
    listeners: {                    
	   rowClick:function(grid, rowIndex, e){
	   resolutionString='';
		var rec = grid.store.getAt(rowIndex);
			 var resid = rec.get('ResolutionID');
			  resolutionString=rec.get('ResolutionID');
	   }
    }
  });

   var displayPanel1 = new Ext.Panel({
        height       : 175,
        layout       : 'vbox',
        layoutConfig : { align : 'stretch' },
        items        : [
            checkBoxPanel,
            desGrid
        ]
    });
    
    var displayPanel2 = new Ext.Panel({
        height       : 175,
        layout       : 'vbox',
        layoutConfig : { align : 'stretch' },
        items        : [
            checkBoxPanel1,
            resGrid
        ]
    });
	if(getIsStandardDescription() == 'true') {
	var displayPanel = new Ext.Panel({
        border:false,
        height       : 200,
        layout       : 'hbox',
        collapsible:true,
        title: labelStandardDescriptionAndResolution,
        renderTo     : 'div1',
		disabled: isShowFooterDisabled(),
        defaults     : { flex : 1 }, //auto stretch
        items        : [
            displayPanel1,displayPanel2
        ]
    });
	}
	}
	var nwenddate = new Date();
    var nwend = nwenddate.getTime();
    var pagerender = nwend - nwstart ;
  
    clookupdata += pageLoad;
    clookupdata += pagerender;
    document.getElementById('lookupdataval').value = clookupdata ; 
}); //close of Ext.OnReady

function saveCategory()
{
	if (!availableForSR && isRequestCatalog) {
		showMessage(labelSRDCategorySelectionErrorMsg);
		return;
	}
	if(categoryId==null||categoryId==''){
		 showMessage(labelSelCategory);
	}
	else{
		var retunValue=categoryName +":"+descriptionString+":"+resolutionString;
		var rval=new Array(5);
		rval[0]=decodeSpecialChar(categoryName);   
		if(isRequestCatalog != 'true'){
			if(Ext.getCmp('desCheckBox').getValue())
				 rval[1]=decodeSpecialChar(descriptionString);    
			else
				 rval[1]=null;
				  
			if(Ext.getCmp('resCheckBox').getValue()){
				   rval[2]=decodeSpecialChar(resolutionString);    
				  }    
				  else
				 rval[2]=null;
		}else{
			rval[1]=null;
			rval[2]=null;
		}
					  
			rval[3] = categoryId;
			rval[4] = decodeSpecialChar(catUrgency);	
		
				
		  window.parent.setPopUpVar(rval);
		  setTimeout("window.parent.closePopup()",1000);
	   }  
 }
/*Search Page expects this function to be on parent page. Overridden with dummy function*/
function changeTitle(wid, newTitle,winTitle){
    
}
function activateWindow(){

}
function addTab(){

}
/* End of dummy function section */
function selectedCatDBClk(grid, rowindex,id){
	var name = frames['categoryListFrame'].grid.store.getAt(rowindex).get('Name');
	catUrgency = frames['categoryListFrame'].grid.store.getAt(rowindex).get('FkUrgency__c');
	categoryId=id
	categoryName=name; 
	saveCategory();
}
function selectedCatSingleClk(grid, rowindex,id){
	var name = frames['categoryListFrame'].grid.store.getAt(rowindex).get('Name');
	catUrgency = frames['categoryListFrame'].grid.store.getAt(rowindex).get('FkUrgency__c');
	
	categoryId=id
	categoryName=name; 
	 if(showFooterPanel != null && typeof(showFooterPanel) != 'undefined' && (showFooterPanel == true || showFooterPanel == '')){
		nodeClicked(id);
	}
}
/*end of overrides*/
