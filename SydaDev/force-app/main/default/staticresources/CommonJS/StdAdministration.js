var windowTitle,
    idArray,
    doRefresh = false,
    groupID,
	impactData,
	urgencyData,
	categoryData,
	jsonValue = '',
    btn1 ='',
	mod,
	qvTabId='',   
    index=0,
    selectedNode='',
    selectedNodeRef='',
    jasonData,
    isQVNodeSelected,
    sysQueryId,
    oewnerOfQuery,
	isQueryCut=false,
	isQueryCopy=false,
    selecteQueryText,
    linkArray = new Array(),
    indexArray = new Array(),
    errorMessge,
    flagToDesableButton,
    tabsList = new Array(),
    functionsList = new Array(),
    folderName,
    listViewTarget,
    isQueryNode=false,
    isFolderNode=false,
    nameOfFolderNode,
	sep="___",
	incidentTabID,
    nodePageReferences = new Array();
	
		

function getSDActiveTabId(){
	return Ext.getCmp('tabs').getActiveTab().getId();
}
function getDoRefresh(){
	return doRefresh;
}
function setDoRefresh(refreshPage){
	doRefresh = refreshPage;
}
function setIdArray(val){
	idArray = val;
}
function getIdArray(){
	return idArray ;
}
var myArray = new Array();

function refreshPortletBar(){
	var MyComp =Ext.getCmp('navview');
	MyComp.findById('portalContent').removeAll();
	MyComp.doLayout();                
	resetJsonString();
	closePopup();
}
function PortletBtnComplete(){
	var MyComp =Ext.getCmp('navview');
	MyComp.findById('portalContent').removeAll();
	MyComp.doLayout();
	addPortletComponent();            
} 
function setTabFunctionList(tab, fun) {
	tabsList.push(tab);
	functionsList.push(fun);
}
function getTabsList() {
	return tabsList;
}
function getFunctionsList() {
	return functionsList;
}
function setpageTarget(target) {
	listViewTarget = target;
}
function getPageTarget() {
	return listViewTarget;
}
function refreshPortlet(wid,page){
	var win = Ext.getCmp(wid);
	if(win != null){
		Ext.get(win.body.id).update('<iframe name = "skyiframe'+wid+'" src =\"\/apex\/'+ page  +'\" style=\"width:100%;height:100%;border:none\"/>');
	}
}
function refreshPortletByTitle(wid){
	if(document.getElementById(wid+'iFrame') != null && typeof(document.getElementById(wid+'iFrame')) != 'undefined'){
		document.getElementById(wid+'iFrame').src = document.getElementById(wid+'iFrame').src;
	}
	if(wid != null && typeof(wid) == 'undefined' && wid == 'WorldTime'){
		closePopup();
	}
}

function replaceAll(value,stringToFind,stringToReplace){
	var temp = value;
	var index = temp.indexOf(stringToFind);
	while(index != -1){
		temp = temp.replace(stringToFind,stringToReplace);
		index = temp.indexOf(stringToFind);
	}
	return temp;
}
function escapeHtmlCodes(headerVal){
	headerVal=replaceAll(headerVal,'%25','%');
	headerVal=replaceAll(headerVal,'%23','#');
	headerVal=replaceAll(headerVal,'%26','&');
	headerVal=replaceAll(headerVal,'%22','"');
	headerVal = replaceAll(headerVal,'%2B','+');
	return headerVal; 
}

function addChatterFeedTab(){
	var isChatterEnabled = newsFeedVal;
	if(isChatterEnabled){
		if(Ext.getCmp('navview').findById('tabs').findById('chatterfeed')!=null){
			Ext.getCmp('navview').findById('tabs').findById('chatterfeed').show();
			return;
		}
		var chatterTabCmpt = {id:'chatterfeed', domId:'chatterfeed',title:'&nbsp;&nbsp;&nbsp;'+chatterFeedLabel, closable:true, html:'<div class=\"iframe-enclave1\" id=\"child5\"><\/div><div class=\"iframe-enclave\"><iframe frameborder="0" id="dashboardIFrame" src =\"\/apex\/NewsFeedPage\" class=\"tab-iframe chatterTabHeightCls\"\/><\/div>'};
		Ext.getCmp('tabs').add(chatterTabCmpt);
		Ext.getCmp('navview').findById('tabs').findById('chatterfeed').show();
		document.getElementById('child5').style.visibility='hidden';
	}
	else
		alert('Chatter settings are not enabled....');
}

function getFormAssignment(pageRef)
{
	var arrFormAssignment = formAssignment.split(';');
	var pattern;
	for (var i=1; i<arrFormAssignment.length; i++)
	{
		if (arrFormAssignment[i] == '') continue;
		pattern = new RegExp(arrFormAssignment[i], 'ig');
		if (pageRef.match(pattern))
		{
			pageRef = pageRef.replace(pattern, arrFormAssignment[i] + 'custom');
			break;
		}
		
	}
	return(pageRef)
}

function addNewTab(idVal, titleVal, pageRef, isFromWidget){
	mod = titleVal;	
	pageRef = getFormAssignment(pageRef);
	pageRef = pageRef.substring(0,pageRef.indexOf('?')+1)+'tabName='+titleVal+spChar+idVal+'&'+pageRef.substring(pageRef.indexOf('?')+1);
	var decodedpageref = decodeURI(pageRef);
	var pageRefParams = decodedpageref.substring(decodedpageref.indexOf('?')+1);
	var pageRefParamsList = pageRefParams.split('&');
	var i=0;
	var foundTab=0;
	if(windowTitle == titleVal){
		foundTab = 1;
	}
	while(tabsList.length>i) {
		var tabRecord = tabsList[i];
		tabRecord = tabRecord.split(spChar);
		var tab = tabRecord[0];
		var tabId = tabRecord[1];
			
		var function1 = functionsList[i];
		if(tab == titleVal) {
				
			var j=0;
			var pageTarget;
			var title;
			var tabTitle='';
			while(pageRefParamsList.length>j) {
				if(pageRefParamsList[j].match('=')!=-1) {
				var key = pageRefParamsList[j].substring(0,pageRefParamsList[j].indexOf('='));
				if(key=='tabTitle'){
					tabTitle=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
					j++;
					continue;
				}
				if(key=='title'){
					title=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
					j++;
					continue;
				}
				if(key=='target' || key=='amp;target'){
					pageTarget=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
					j++;
					continue;
				}
				j++;
				}
			}
			
			Ext.getCmp('navview').findById('tabs').findById(tabId).show();
			if(tabTitle!='') {
				function1(pageTarget,tabTitle,title);
			}else {
				function1(pageTarget,title,title);
			}
			
			foundTab = 1;
			break;
		}
		i++;
	}
	
	if(foundTab == 0) {
	   
		var initialPageRef = nodePageReferences[titleVal];
		if(initialPageRef != null) {
		   var pageRefParams = initialPageRef.substring(initialPageRef.indexOf('?')+1);
		   
		   var pageRefParamsList = pageRefParams.split('&');
		   
		   var j=0;
		   var pageTarget;
		   var title;
		   
		   
		   while(pageRefParamsList.length>j) {
			   if(pageRefParamsList[j].match('=')!=-1) {
					
				   var key = pageRefParamsList[j].substring(0,pageRefParamsList[j].indexOf('='));
				   if(key=='target') {
					   pageTarget=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
					   j++;
					   continue;
				   }
				   if(key=='title') {
					   title=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
					   j++;
					   continue;
				   }
				   j++;
			   }
		   }
		   
		   if(pageTarget.indexOf('AppAdmin') != -1){
			pageTarget = pageTarget + '&standardLayout=true';
		   }
		   
		   setpageTarget(pageTarget+spChar+title);   
		   if(typeof(isFromWidget)=='undefined' || isFromWidget == null || isFromWidget == '' )              
		   pageRef = pageRef.substring(0,pageRef.indexOf('?')+1)+'useListViewTarget=true&'+pageRef.substring(pageRef.indexOf('?')+1);
		   
		   if(pageTarget == "KnowledgeSearch"){
				pageRef = pageRef.substring(0,pageRef.indexOf('?')+1)+'useListViewTarget=false&'+pageRef.substring(pageRef.indexOf('?')+1);					
		   }
	   }
	   
	   //if faqnewsfeedpage, incidentnewsfeedpage etc is already open, open the subsequest respective news feed on the same tab
	   if (idVal.match("NewsFeedPage") != -1 && idVal.match("NewsFeedPage") != null && typeof(Ext.getCmp(idVal)) != 'undefined' && Ext.getCmp(idVal) != null)
	   {
			var cmp = Ext.getCmp(idVal);
			pageRef = '\/apex\/' + pageRef;
			if (typeof(document.getElementById(idVal+'iframe')) != 'undefined' && document.getElementById(idVal+'iframe') != null)
			{
				document.getElementById(idVal+'iframe').src = pageRef;
				cmp.show();			
			}
	   }
	   else if((linkArray[pageRef]) == null){
		   
			if(qvTabId=='') qvTabId=idVal;
			var preSrc  = '';
			if(!pageRef.match(/\isCustomActionLink/)){
				preSrc = '\/apex\/';
			}
			
			var domId='';
			if(titleVal == 'QuickView Editor'){
			  domId='QVEditor';
			}else if(pageTarget !=null && pageTarget!='') {
			 domId=pageTarget.substring(pageTarget.indexOf('=')+1,pageTarget.indexOf('%'));
			}
			Ext.getCmp('navview').findById('tabs').add({
			title: ' &nbsp;&nbsp; '+titleVal,
			width:'auto',
			id: idVal,
			domId:domId,
			html: '<div class=\"iframe-enclave1\" id=\"divId'+idVal+'\"><\/div><div class=\"sky-iframe\"><iframe name = "skyiframe'+mod+'" id = \"'+ idVal +'iframe\" src =\"'+preSrc + pageRef+'\" class=\"tab-iframe\" style=\"width:100%;height:100%;border:none;background:white\"/></div>',
				closable : true,
				listeners : {
					   close : function() {
							  linkArray[indexArray[this.id]] =null;
							  removeTabFunction(this.id);
							  qvTabId='';
					   }
			   }
		}).show();
			  linkArray[pageRef] = idVal;
			  indexArray[linkArray[pageRef]] = pageRef;
			  document.getElementById('divId'+idVal).style.visibility='hidden';
		}else{
			 var cmp = Ext.getCmp(linkArray[pageRef]+'');
			 if(cmp) cmp.show();
		}
		
		
	}
}

Ext.ux.TabScrollerMenu =  Ext.extend(Object, {
    pageSize       : 10,
    maxText        : 15,
    menuPrefixText : 'Items',
    constructor    : function(config) {
        config = config || {};
        Ext.apply(this, config);
    },
    init : function(tabPanel) {
        Ext.apply(tabPanel, this.tabPanelMethods);
		tabPanel.tabScrollerMenu = this;
        var thisRef = this;
        tabPanel.on({
            render : {
                scope  : tabPanel,
                single : true,
                fn     : function() {
                    var newFn = tabPanel.createScrollers.createSequence(thisRef.createPanelsMenu, this);
                    tabPanel.createScrollers = newFn;
                }
            }
        });
    },
    createPanelsMenu : function() {
        var h = this.stripWrap.dom.offsetHeight;
        var rtScrBtn = this.header.dom.firstChild;
        Ext.fly(rtScrBtn).applyStyles({
            right : '18px'
        });

        var stripWrap = Ext.get(this.strip.dom.parentNode);
        stripWrap.applyStyles({
             'margin-right' : '36px'
        });

        // Add the new righthand menu
        var scrollMenu = this.header.insertFirst({
            cls:'x-tab-tabmenu-right'
        });
        scrollMenu.setHeight(h);
        scrollMenu.addClassOnOver('x-tab-tabmenu-over');
        scrollMenu.on('click', this.showTabsMenu, this);
		this.scrollLeft.dom.qtip = labelTabScrollerLeft;
		this.scrollRight.dom.qtip = labelTabScrollerRight;
        this.scrollLeft.show = this.scrollLeft.show.createSequence(function() {
            scrollMenu.show();
        });

        this.scrollLeft.hide = this.scrollLeft.hide.createSequence(function() {
            scrollMenu.hide();
        });

    },
    // public
    getPageSize : function() {
        return this.pageSize;
    },
    // public
    setPageSize : function(pageSize) {
        this.pageSize = pageSize;
    },
    // public
    getMaxText : function() {
        return this.maxText;
    },
    // public
    setMaxText : function(t) {
        this.maxText = t;
    },
    getMenuPrefixText : function() {
        return this.menuPrefixText;
    },
    setMenuPrefixText : function(t) {
        this.menuPrefixText = t;
    },
    // private && applied to the tab panel itself.
    tabPanelMethods : {
        // all execute within the scope of the tab panel
        // private
        showTabsMenu : function(e) {
            if (! this.tabsMenu) {
                this.tabsMenu =  new Ext.menu.Menu();
                this.on('beforedestroy', this.tabsMenu.destroy, this.tabsMenu);
            }

            this.tabsMenu.removeAll();

            this.generateTabMenuItems();

            var target = Ext.get(e.getTarget());
            var xy     = target.getXY();
			
			//X param - 115 pixels
            xy[0] -= 115;
            //Y param + 24 pixels
            xy[1] += 24;

            this.tabsMenu.showAt(xy);
        },
        // private
        generateTabMenuItems : function() {
            var curActive  = this.getActiveTab();
            var totalItems = this.items.getCount();
            var pageSize   = this.tabScrollerMenu.getPageSize();
            var i=0;
            while(totalItems>i){
                var item = this.items.get(i);
                this.tabsMenu.add(this.autoGenMenuItem(item));
                i++;
            }

        },
        // private
        autoGenMenuItem : function(item) {
            var maxText = this.tabScrollerMenu.getMaxText();
			var tabTitle=item.title.substring(13,item.title.length);
            var text    = Ext.util.Format.ellipsis(tabTitle, maxText);

            return {
                text      : text,
                handler   : this.showTabFromMenu,
                scope     : this,
                disabled  : item.disabled,
                tabToShow : item,
                iconCls   : item.iconCls
            }

        },
        // private
        showTabFromMenu : function(menuItem) {
            this.setActiveTab(menuItem.tabToShow);
        }
    }
});
initFunction = function(p) {
	if (p.collapsible) {
		var r = p.region;
		var textClass = 'x-collapsed-header-text';
	 if ((r == 'east') || (r == 'west')) textClass += '-rotated';
		p.on('render', function() {
			var ct = p.ownerCt;
		   ct.on('afterlayout', function() {
			   p.collapsedTitleEl = ct.layout[r].getCollapsedEl().createChild({
					tag: 'div',
					cls: textClass,
					html: '<img src='+resSDEFStylesPath+'"/SDEFicons/icon_workspaces_bar_closed.gif" style="padding-left:8px;height:25px;width:25px;"/><div class="sky-title" style="color:white">'+p.title+'</div>'
				});
				p.setTitle = Ext.Panel.prototype.setTitle.createSequence(function(t) {
					p.collapsedTitleEl.dom.innerHTML = t;
				});
			}, false, {single:true});
		});
	}
};
clickFunction = function(n) {

	
   if(n.leaf){
		if(n.text== chatterFeedLabel)
		{
			addChatterFeedTab();
			return;
		}
		windowTitle =  n.text; 
		mod = n.text; 
		pageRef=n.attributes.pageRef;
		if(n.text == incidentLabel){
			incidentTabID=n.id;
		}
		
		if(windowTitle.search(AlignabilityProcessModel) != -1)
		{
			windowTitle = AlignabilityProcessModel;
			n.text = windowTitle;
		}
		pageRef = pageRef.substring(0,pageRef.indexOf('?')+1)+'tabName='+n.text+spChar+n.id+'&'+pageRef.substring(pageRef.indexOf('?')+1);
		
		var pageRefParams = pageRef.substring(pageRef.indexOf('?')+1);
		
		var pageRefParamsList = pageRefParams.split('&');
		
		var i=0;
		var foundTab=0;
		
		while(tabsList.length>i) {
			var tabRecord = tabsList[i];
			tabRecord = tabRecord.split(spChar);
			var tab = tabRecord[0];
			var tabId = tabRecord[1];
			
			var function1 = functionsList[i];
			if(tab == n.text) {
				var j=0;
				var pageTarget;
				var title;
				while(pageRefParamsList.length>j) {
					if(pageRefParamsList[j].match('=')!=-1) {
					var key = pageRefParamsList[j].substring(0,pageRefParamsList[j].indexOf('='));
					
					if(key=='title') {
						title=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
						j++;
						continue;
					}
					if(key=='target') {
						pageTarget=pageRefParamsList[j].substring(pageRefParamsList[j].indexOf('=')+1);
						j++;
						continue;
					}
					j++;
					}
				}
				 
				 if(pageTarget.indexOf('AppAdmin') != -1){
					pageTarget = pageTarget + '&standardLayout=true';
				 }
				 
				function1(pageTarget,title,title);
				Ext.getCmp('navview').findById('tabs').findById(tabId).show();
				foundTab = 1;
				break;
			}
			i++;
		}
	
		if(foundTab==0) {
		 if((linkArray[n.attributes.pageRef]) == null ){
		 
			 if(pageRef!=null && pageRef.indexOf('AppAdmin') != -1){
						
				pageRef = pageRef.substring(0,pageRef.indexOf('AppAdmin')) + 'AppAdmin?id=1001&standardLayout=true';
						
			 }
			 
			 Ext.getCmp('navview').findById('tabs').add({
			 title: ' &nbsp;&nbsp; '+n.text,
			   id: n.id,
			   domId:n.attributes.domId,
				iframeName: 'skyiframe'+mod,
				html: '<div class=\"iframe-enclave1\" id=\"divId'+n.id+'\"><\/div><div class=\"iframe-enclave\"><iframe id="skyiframe'+mod+'" name="skyiframe'+mod+'" src =\"\/apex\/'+pageRef+'\" class=\"tab-iframe\"/></div>',
				closable : true,
				listeners : {
					beforeclose: beforeCloseTabEvent,
					close : function() {
					   linkArray[indexArray[this.id]] =null;
					   removeTabFunction(this.id);
					 }
				}
			}).show();
			linkArray[n.attributes.pageRef] = n.id;
			indexArray[n.id]=n.attributes.pageRef;
			document.getElementById('divId'+n.id).style.visibility='hidden';
		}else{
			
			 var cmp = Ext.getCmp(linkArray[n.attributes.pageRef]+'');
			 if(cmp) cmp.show();
		}
	   }
	}else{
		if(n.expanded){
			n.collapse();
		}else{
			n.expand();
		}
	}
};
function beforeCloseTabEvent (tab){
	var formUnsaved = false;
	if (typeof(window.frames[this.iframeName]) == "undefined") return;
	var changeArray;
	if (typeof(window.frames[this.iframeName].changeArray) != "undefined") 
		changeArray = window.frames[this.iframeName].changeArray;
	else if (typeof(document.getElementById(this.iframeName).contentWindow) != "undefined")
		changeArray = document.getElementById(this.iframeName).contentWindow.changeArray;
	else
		return false;
	if (changeArray.length > 0)
	{
		for (var i=0; i<changeArray.length; i++)
		{
			if (changeArray[i] == 1)
			{
				formUnsaved = true;
				break;
			}
		}
	}
	
	if (formUnsaved)
	{
		Ext.Msg.show({
			title:labelCloseTab, msg: labelCloseTabLabel,
			buttons: Ext.Msg.YESNO,
			icon: Ext.MessageBox.WARNING,
			fn: function(btn){
				if (btn == 'yes'){
					var tabToCloseFrom = Ext.getCmp('navview').findById('tabs')
					tabToCloseFrom.un('beforeclose', beforeCloseTabEvent);
					linkArray[indexArray[tab.id]] =null;
					removeTabFunction(tab.id);
					tabToCloseFrom.remove(tab);
					tabToCloseFrom.addListener('beforeclose', beforeCloseTabEvent, tabToCloseFrom);
				}
			}
		});
		return false;
	}
}
function removeTabFunction(id) {
	var i=0;
	var thisTabId=id
	thisTabId=escapeHtmlCodes(thisTabId);
	while(tabsList.length>i) {
		var tabRecord = tabsList[i];
		var tabInfo = tabRecord.split(spChar);
		if(tabInfo[0] == windowTitle){
			windowTitle=null;
		}
		if(tabInfo[1] == thisTabId) {
			tabsList.splice(i,1)
			functionsList.splice(i,1);
			break;
		}
		i++;
	}
}

clickFunction1 = function(n) {
	document.getElementById("qryPageRef").value="";
		isQVNodeSelected='true';
		if(n.leaf){

			if(n.attributes.pageRef != '' && n.attributes.pageRef !=null){
				if(n.attributes.pageRef=='DashboardPage'){
					OnLoadDesableButtons();
				}else{
				desableButtons();
				selectedNode=null;
				selectedNodeRef = n.attributes.pageRef;
				sysQueryId  = n.id;
				setQuickviewId(n.id);
				isQueryNode=true;
				isFolderNode=false;
				selecteQueryText=n.text;
				oewnerOfQuery=n.attributes.owner;
				var ownerId=document.getElementById("ownerId").value;                            
				if(n.attributes.systemValue==true){
					Ext.getCmp('deleteBtn').setDisabled(true);
						Ext.getCmp('cutBtn').setDisabled(true);
					}	                           
				}	                           
			}else{
				selectedNode=n.id;
				selectedNodeRef =null;
				isQueryNode=false;
				isFolderNode=true;
				nameOfFolderNode=n.text;	
				if( n.attributes.parent=='null' || n.attributes.parent=='' || n.attributes.systemValue==true ){
					OnLoadDesableButtons();
				}
			}
		   var tab = Ext.getCmp('tabs').findById(n.id);
		   if(tab){
			   //tab.show();
			}else {
				document.getElementById("qryPageRef").value=n.text+sep+n.id+sep+n.attributes.pageRef;
				if(n.id=='default dashboards')  editDashboardHandler();			
			}
		}else{
			selectedNodeRef=null;
			selectedNode=n.id;
			folderName=n.text;
			setQuickviewId(null);
			isQueryNode=false;
			isFolderNode=true;
			nameOfFolderNode=n.text;
			if( n.attributes.parent=='null' || n.attributes.parent=='' || n.attributes.systemValue==true ){
					OnLoadDesableButtons();
				 if((n.attributes.parent=='null' || n.attributes.parent=='') && n.attributes.systemValue==true){
				   Ext.getCmp('addFldrBtn').setDisabled(false);
				   } 
			}else{
			enableButtons();
			}
			if(n.expanded){
				n.collapse();
			}else{
				n.expand();
			}
		
		}
};



function showErrorMessage(){
		Ext.Msg.alert(labelWarning, labelQueryNameExisting);
		isQueryCopy=false;
		isQueryCut=false;
		refreshTree();
  }      
function desableButtons(){
		//alert('flagToDesableButton : '+flagToDesableButton);
		/*if(flagToDesableButton==true){
		Ext.getCmp('newBtn').setDisabled(true);
		Ext.getCmp('editBtn').setDisabled(false);
		Ext.getCmp('copyBtn').setDisabled(false);
		Ext.getCmp('pasteBtn').setDisabled(true);
		Ext.getCmp('deleteBtn').setDisabled(false);
		Ext.getCmp('cutBtn').setDisabled(false);
		//Ext.getCmp('exportQueryBtn').setDisabled(true);
		Ext.getCmp('addFldrBtn').setDisabled(true);
		Ext.getCmp('deleteFldrBtn').setDisabled(true);
  */
  }
function enableButtons(){
		//alert('flagToDesableButton : '+flagToDesableButton);
		/*if(flagToDesableButton==true){
		Ext.getCmp('newBtn').setDisabled(false);
		Ext.getCmp('editBtn').setDisabled(false);
		Ext.getCmp('copyBtn').setDisabled(true);
		if(isQueryCopy==true || isQueryCut==true){
			Ext.getCmp('pasteBtn').setDisabled(false);
		}else{
			Ext.getCmp('pasteBtn').setDisabled(true);
		}
		Ext.getCmp('deleteBtn').setDisabled(true);
		Ext.getCmp('cutBtn').setDisabled(true);
		//Ext.getCmp('exportQueryBtn').setDisabled(false);
		Ext.getCmp('addFldrBtn').setDisabled(false);
		Ext.getCmp('deleteFldrBtn').setDisabled(false);
  }*/
  }
function OnLoadDesableButtons(){
		/*Ext.getCmp('newBtn').setDisabled(true);
		Ext.getCmp('editBtn').setDisabled(true);
		Ext.getCmp('copyBtn').setDisabled(true);
		Ext.getCmp('pasteBtn').setDisabled(true);
		Ext.getCmp('deleteBtn').setDisabled(true);
		Ext.getCmp('cutBtn').setDisabled(true);
		//Ext.getCmp('exportQueryBtn').setDisabled(true);
		Ext.getCmp('addFldrBtn').setDisabled(true);
		Ext.getCmp('deleteFldrBtn').setDisabled(true);*/
  }


function confirm(e){
	var rightclick;
	if (!e) var e = window.event;
	if (e.button) rightclick = (e.button == 2);
	if(rightclick==true){
		document.getElementById("homelink").href = '/ui/setup/Setup';
	}else{
		document.getElementById("homelink").href = '#nogo';
		Ext.MessageBox.confirm(labelConfirmHomePage, labelHomeLink, function(btn){
			if(btn === 'yes'){
				window.location="/ui/setup/Setup";   
			}                  		 
		});										   
	}
}

Ext.onReady(function() {
	// Create our instance of tabScrollerMenu
	var scrollerMenu = new Ext.ux.TabScrollerMenu({
		maxText  : 15,
		pageSize : 5
	});

	//Call action function to create user specific dashboard.
	//showDashboard();
	if(typeof(UpdatePropSysStage)=='undefined') 
	{ 
        return; 
	}
    var screenHeight=screen.height;
	UpdatePropSysStage(screenHeight);
	
	if(typeof(repeatNodePageReference)=='undefined') 
	{ 
        return; 
	}
	repeatNodePageReference();

	
	new Ext.Panel({
		layout: 'border',
		renderTo: 'StdConfigurationModule',
		height:850,
		id: 'navview',
		items: [
		{
			region: 'west',
			collapsible: true,
			collapseMode: 'mini',
			width: 275,
			autoScroll: true,
			id: 'navbar',
			useArrows: true,
			split: true,
			layout: 'accordion',
			titleCollapse: false,
			activeItem: 0,
			//collapseFirst: true,

			bodyStyle:{"background-color":"#334f67","border":"none"},
			footerCfg: {
				html: '<img src='+resSDEFStylesPath+'/SDEFimages/Salesforce_Logo.png width="280" height="67">'
			},
			footerStyle: 'border-top:1px solid #cbdeeb;',
			items: [{
				title: labelAdministration,
				collapsible: false,
				id: 'ConfigurationTree',
				titleCollapse: true,
				hideCollapseTool: true,
				margins: '0 10 0 0',
				autoScroll: true,
				cls:'bmcConfigurationTreeCls',
				iconCls: 'bmcConfiguration', scale: 'medium',
				useArrows: true,
				margins: '0 5 0 0',
				cmargins: '0 5 0 0',
				xtype: 'treepanel',
				loader: new Ext.tree.TreeLoader(),
				root:  new Ext.tree.AsyncTreeNode({
				expanded: true,
				children: configurationJsonFeedRoot()
			   })
				,rootVisible: false,
				plugins: {
					init: clickFunction
				},
				listeners: {
					click: clickFunction
				}
			}]
		}, {
			region: 'center',
			xtype: 'tabpanel',
			id: 'tabs',
			width:500,
			autoScroll:true,
			tabPosition:'top',
			cls:'centralTabPanelCls',
			enableTabScroll : true,
			plugins : [ scrollerMenu ],
			split:true,  
			items:[
				//With IFrame
				// You can add the code for the tab here that should be display on start up.
				
				
			],
			listeners: {
					tabchange: function (container,tab){
						var windowT = trim(tab.title.split(';')[tab.title.split(';').length-1]);
						var frame3 = myArray[windowT];
						if(frame3 != undefined){
							if(typeof(frame3.refreshDocs)!='function'){
							 if(windowT !='Configuration Items'){
							    //alert('in  if frame3.frames--');							
								frame3.frames.SIIframeID.refreshDocs();       
							} else{
							     //alert('in  else frame3.frames--');
							      var fram4 = frame3.frames;
								  fram4[0].frames.SIIframeID.refreshDocs();
								}
								delete myArray[windowT];  //to avoid refresh when we come to the parent tab again
							}else{
								frame3.refreshDocs();
							}
						}
						
						var tabEl=container.getTabEl(tab);
						if(tabEl.childNodes[0]!=null && tabEl.childNodes[0]!=undefined){
						  var tabIdVar= tab.domId.replace(' ','_');
						  tabEl.childNodes[0].id=tabIdVar.toUpperCase()+'_TAB_CLOSE_BTN';
						  tabEl.childNodes[1].childNodes[0].childNodes[0].childNodes[0].id=tabIdVar.toUpperCase()+'_TAB';
					   }
						
					}
				}
		}
	],
	listeners:{
		afterlayout: function(c){
			c.layout.west.miniSplitEl.dom.qtip = labelTooltipCollapseNavigator;
			c.layout.west.getCollapsedEl();
			c.layout.west.miniCollapsedEl.dom.qtip = labelTooltipExpandNavigator;
		   setIdToTreeNode();
		}
	}
	});
	
	function setIdToTreeNode()
	{
		    var configTree=Ext.getCmp('ConfigurationTree');
		    configTree.getRootNode().cascade(function(n) {
				if(n!=null && n!=undefined && n.attributes.domId!=undefined && n.attributes.domId!=null ){
				  var navIdVar= n.attributes.domId.replace(' ','_');
				  n.getUI().getTextEl().id=navIdVar.toUpperCase()+'_TREE_ID';
				}
		   });
		   configTree.getEl().dom.childNodes[0].childNodes[1].id='CONFIG_ACCORD';
		   	var count=0;
			  Ext.select('.x-tool').each(function(el){
			  el.dom.id = 'PANEL-TOOL-' +count++; 
		   }); 
	}
	
	OnLoadDesableButtons();
	Ext.QuickTips.init();
	
	// This is the default tab that we should show on launching Remedyforce Admin tab.
	addNewTab(labelApplicationSettingsTitle, labelApplicationSettingsTitle, 'NavigatorPage?title='+labelApplicationSettingsTitle+'&amp;target=AppAdmin?id=1001&standardLayout=true');
			
});            

openPopUp = function(){
	var userConfigPortletHeight= Ext.isIE?405:401;
	openPopupWithTitle('UserConfigPortlet',refreshPortletBar,labelAddSidebarContentHeader,userConfigPortletHeight,460,true);     
 }

function trim(str, chars) {
	return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}
 
function rtrim(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}
function CloseActiveTab() {
	var activeTab = Ext.getCmp('tabs').getActiveTab();
	var tabToCloseFrom = Ext.getCmp('navview').findById('tabs');
	tabToCloseFrom.un('beforeclose', beforeCloseTabEvent);
	linkArray[indexArray[activeTab.id]] =null;
	removeTabFunction(activeTab.id);
	tabToCloseFrom.remove(activeTab);
	tabToCloseFrom.addListener('beforeclose', beforeCloseTabEvent, tabToCloseFrom);
}
