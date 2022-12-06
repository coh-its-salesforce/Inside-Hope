var categoryId='';  
var searchText='';
var divHeight;
var errorMsg='';
var tree;
var node;
var categoryFilter='';	
var selectedFilterOption=categoryFilter;
var searchFlag=true;

function changeGrouping() {
    var combo = Ext.getCmp('groupoptions');
    node = Ext.getCmp('groupoptions').getValue();
    reloadTree();        
} 

function pageRefresh(){
	 window.location.reload(true);
}

function setPanelHeight(){
	var winOffset=80;
	if(Ext.isIE){
		return document.documentElement.offsetHeight-winOffset;
	}else {
		return window.innerHeight-winOffset;
	}
}
	    
Ext.onReady(function(){	
	Ext.QuickTips.init();
	document.title=labelSelCategory;
	divHeight = setPanelHeight();
	document.getElementById('categoryTreeView').height = divHeight;
	setCategoryFilter();
	createToolbar();
	createCategoryTree();
	document.getElementById('buttonpanel').style.visibility='visible';
}); 

function createToolbar(){
	var srchTxtFld = new Ext.form.TextField({
	    id: 'searchTxt',
	    name: 'searchTxt',
	    width: 300,
	    fieldLabel: labelSearch,
	    allowBlank: true,
	    emptyText: labelSearch,
		enableKeyEvents: true 
		
	});
	    
	var filterMenuPanel = new Ext.Panel({
	    title: '',
	    tbar: [{
	        scale: 'medium',
	        iconCls: 'bmcView1',
	        tooltipType: 'title',
	        id:'filterMenuId',
	        menu: [{ 
	        	xtype: 'radio',
				name: 'IncSRCategory',
				boxLabel: incidentCategories,
				checked: isIncidentPopup(),
				iconCls: 'emptyIcon',
				inputValue: 'IncidentCat',
				handler: filterCategory
			},{ 
				xtype: 'radio',
				name: 'IncSRCategory',
				boxLabel: serviceRequestCategories,
				checked: isServiceRequestPopup(),
				iconCls: 'emptyIcon',
				inputValue: 'SRCat',
				handler: filterCategory
			},{
				text: applyLabel,
				iconCls: 'mnuList',
				handler: applyFilter
			}]
	    }]
	});
	var smallSpacer = new Ext.Spacer({width:10});
  	
	var toolbar;
	if (popupId != null && popupId != 'null' && (isIncidentPopup() || isServiceRequestPopup())) {
		toolbar=new Ext.Toolbar({
					renderTo: 'btntoolbar',
					items: [filterMenuPanel,' ',' ','  ',' ',
				 			srchTxtFld,smallSpacer,
				 			{iconCls: 'bmcSearch',tooltip: labelSearch, tooltipType: 'title',id:'categorySearch', handler: textSearch},
				 			' ',' ',' ',
				 			{scale: 'medium', iconCls: 'bmcRefresh', tooltip: labelRefresh, tooltipType: 'title', style:{align: 'left'},id:'categoryRefresh',handler: pageRefresh}
					]
				});
	}
	else {
		toolbar=new Ext.Toolbar({
				 renderTo: 'btntoolbar',
				 items: [' ',' ','  ',' ',
				 srchTxtFld,{xtype: 'spacer',width:Ext.isIE?20:5},{iconCls: 'bmcSearch',tooltip: labelSearch, tooltipType: 'title',id:'categorySearch', handler: textSearch},' ',' ',' ',{scale: 'medium', iconCls: 'bmcRefresh', tooltip: labelRefresh, tooltipType: 'title', style:{align: 'left'},id:'categoryRefresh',handler: pageRefresh}
		
		 ]
		});
	}
	var setSearchFlag =function (field, e){
		if(e.getKey() != e.ENTER ) {
            searchFlag = true;
		}
	};
	srchTxtFld.on("keyup", setSearchFlag); 
         
    var specialKeyFunction = function ( field, e ) {
	  	if(e.getKey() == e.ENTER ) {
            textSearch();
		}
	}
    srchTxtFld.on("specialkey", specialKeyFunction);

}

/* functions for list view */
function selectedCatDBClk(grid,rowindex,id){
	var name = frames['categoryListFrame'].grid.store.getAt(rowindex).get('Name');
	categoryId=id;
	saveSelectedCategory(categoryId);
}
function selectedCatSingleClk(grid,rowindex,id){
	var name = frames['categoryListFrame'].grid.store.getAt(rowindex).get('Name');
	categoryId=id;
}
/* end of functions for list view */

function createCategoryTree(){
	root = new Ext.tree.AsyncTreeNode({
		expanded: true,
		id:'0',
		text : labelCatByDesc,
		loader: new Ext.tree.TreeLoader({
				url: page_CMDBJsonGenerator + getParams(),
				requestMethod: 'GET'
	  	})
	});
	
	new Ext.Panel({
		renderTo: 'categoryTreeView',
		height: divHeight,
		autoScroll: true,
		items: [{
			xtype: 'treepanel',
			autoWidth:true,
			margins: '0 10 0 0',
			autoScroll: true,
			useArrows: true,
			split: true,
			id : 'categoryTree',
			border: false,
			margins: '0 5 0 0',
			cmargins: '0 5 0 0',
			animate: true,
			titleCollapse: true,
			root: root,
			containerScroll: true,
			listeners: {
				afterrender: function(treeComp) {
					// if you want to load the subtree automatically - do it here
				},
				click: function(n) {
					if(n == this.getRootNode()){
						return;
					}
					categoryId = n.id;
				},
				dblclick: function(n){
					if(n == this.getRootNode()){
						return;
					}
					categoryId = n.id;
					validateRecordState();
				}
			}
		}]
	});
	Ext.getCmp('categoryTree').getRootNode().expand();
}

function textSearch(){
    if(searchFlag == true){   
		 searchText=Ext.getCmp("searchTxt").getValue(); 
		 if(searchText.trim().length<2 || document.getElementById("searchTxt").value==labelSearch){
			Ext.MessageBox.show({ 
				msg: minCharsForSearchlabel, 
				title: warningTitleSearchLabel, 
				buttons: Ext.MessageBox.OK,
				width:300,
				icon: Ext.MessageBox.WARNING
			});
			return;
		}	
		reloadTree();	
		searchFlag = false; 
	}
    searchText='';
}

function isServiceRequestPopup(){
	if(popupId!=null && popupId!='null' && popupId!='' && popupId == 'incident' && isServiceRequest=='true'){
		return true;
	}else{
		return false;
	}
}
function isIncidentPopup(){
	if(popupId!=null && popupId!='null' && popupId!='' && popupId == 'incident' && isServiceRequest=='false'){
		return true;
	}else{
		return false;
	}
}
function filterCategory(item, checked) {
    if(checked){
    	selectedFilterOption=item.inputValue;
    }   
}
function applyFilter(){
    if(selectedFilterOption == 'IncidentCat')
        categoryFilter='INC';
    else
        categoryFilter='SR';
    reloadTree();
}
     
function setCategoryFilter(){
    if(isIncidentPopup()){
        categoryFilter = 'INC';
    }else if(isServiceRequestPopup()){
        categoryFilter = 'SR';
    }else {
        categoryFilter = '';
    }
}
    
function getParams(){
	var params = '?type=getCategoryTree&popupId='+ popupId +'&searchText='+ searchText +'&filter='+ categoryFilter;
	return params;
}

function reloadTree() {
	tree = Ext.getCmp('categoryTree');
	tree.loader.url = page_CMDBJsonGenerator + getParams();
	tree.loader.load(tree.getRootNode());
    tree.getRootNode().expand();
};

function validateRecordState(){
	if(typeof(state) != undefined && (state=='true' || state=='1')){
		if(categoryId!=null && categoryId!='null' && categoryId!=''){
			saveSelectedCategory(categoryId);
		}else{
			showErrorMessage(selectCategoryLabel);
		}
	}else{
		showErrorMessage(getRecordClosedLabel());
	}
}
function getRecordClosedLabel(){
	if(popupId=='incident'){
		return incidentClosedLabel;
	}
	else if(popupId=='task'){
		return taskClosedLabel;
	}
	if(popupId=='changerequest'){
		return changeRequestClosedLabel;
	}
	if(popupId=='problem'){
		return problemClosedLabel;
	}
	if(popupId=='release'){
		return releaseClosedLabel;
	}
	if(popupId=='broadcast'){
		return broadcastClosedLabel;
	}
}

function closeWindowAfterSave() {
    if(errorMsg == null || errorMsg =='' || errorMsg == 'null'){
    	if(stdForm=='false'){
        	getOpener().location.href='/'+recordId;
        }else{
        	getOpener().refreshRecord();
        }
        window.close();
    }else{
        showErrorMessage(errorMsg);
        errorMsg=null;
    }                          
}
function showErrorMessage(message){
	Ext.MessageBox.show({                                
	    msg: message ,
	    width: 300,
	    buttons: Ext.MessageBox.OK
	});
}