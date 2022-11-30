 //changes by mayuri
               function getUrlParameter( param ){
                        param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
                        var r1 = "[\\?&]"+param+"=([^&#]*)";
                        var r2 = new RegExp( r1 );
                        var r3 = r2.exec( window.location.href );
                        if( r3 == null ){return ""}
                        else {return r3[1]};
                 }
 var standardLayout;
var win,
	pagetargettocontrolhelp,
	indexArray = new Array(),
	titleArray = new Array(),
	linkArray = new Array(),   //[link] = index
	reverseLinkArray = new Array(),  //[index] = link
	tempIndexWin,        
	counter = 0,
	index = 1,
	windowIndex = 0,
	tabIndex = 0,
	splitIndex = 0,
	win2,
	tb,  
	skyWindow,
	splitButton,
	resTokens,                 
	idSet,  
	tabToolTipText,
	idArray = new Array(),
	reverseIdArray = new Array(),
	changeArray = new Array(),
	refreshGridArray = new Array(),
	refreshSearchPageToolbar=new Array(),
	selectedWinId,
	tabCount=0,
	xOnMove=0;
	yOnMove=0;
	needsRefresh = false;
	doSubmitForApproval = null;
function activateWindow(wid){
    if(wid!=null && wid!='')
        Ext.getCmp('winId'+wid).show();          
}
function RefreshToolbar(fun){
	refreshSearchPageToolbar[1] = fun;
}
function loadingDataToList(){
	Ext.MessageBox.show({
	   msg: 'Loading data, please wait...',
	   progressText: 'Loading...',
	   width:300,
	   wait:true,
	   waitConfig: {interval:150}
   
	  
   });
   setTimeout(function(){
		Ext.MessageBox.hide();
	},3000);
}
function refreshGridSI(wid, fun){
	refreshGridArray[wid] = fun;
}
function registerChange(wid){
	changeArray[wid] = 1;
}
function registerSave(wid){
	changeArray[wid] = -1;
}
function getParam(strUrl, param){
	var val = "";
	if ( strUrl.indexOf("?") > -1 ){
		var paramString = strUrl.substr(strUrl.indexOf("?")+1);
		var paramArray = paramString.split("&");
		for ( var paranIndex = 0; paranIndex < paramArray.length; paranIndex++ ){
			var paramPair = paramArray[paranIndex].split("=");
			//alert(paramPair );
			if (paramPair[0] == param ){		
				val = paramPair[1];
				break;
			}
		}
	}
	return unescape(val);
}
function refreshList(){
	var frame1 = window.frames['naviframe'+1];
	frame1.pgRefresh();	
}
function addQuery(queryId, queryName){
	window.parent.addQueryNode(queryId, queryName);
}
function refreshPage(wid){
	var win = Ext.getCmp('winId'+wid);
	if(win != null){
		var link = reverseLinkArray[wid];
		if(link.match(/\?/)){
			link = link + '&wid='+wid;
		}else{
			link = link + '?wid='+wid;
		}               
		Ext.get(win.body.id).update('<iframe name = "naviframe'+wid+'" src =\"\/apex\/'+ link  +'\" style=\"width:100%;height:100%;border:none\"/>');
	}
}
function refreshPage(wid, objId){
	var win = Ext.getCmp('winId'+wid);
	if(win != null){
		var link = reverseLinkArray[wid];
		if(link.match(/\?/)){
			link = link + '&wid='+wid;
		}else{
			link = link + '?wid='+wid;
		}
		if(!(link.match(/\?id=/) || link.match(/\&id=/))){
			link = link + '&id='+objId;
		}
		Ext.get(win.body.id).update('<iframe name = "naviframe'+wid+'" src =\"\/apex\/'+ link  +'\" style=\"width:100%;height:100%;border:none\"/>');
	}
}
function listOfId(listId){
	idSet=listId;
}
function returnListOfId(){
	return idSet;
}
function getTitleText(title){
	var titleText = '';
	if(title!=null && title!=''){
		if(title.length > 9){
			titleText = title.substring(0,9) + '...';
		}else{
			titleText = title;
		}
	}
	return titleText;
}  
function handleDelet(pageId){
	var wid = idArray[pageId];
	if(typeof(wid)!='undefined' && wid != -1){
		closeTab(wid);
	}
}
function closeTab(wid){
	linkArray[reverseLinkArray[wid]] = -1;
	idArray[reverseIdArray[wid]] = -1;
	reverseIdArray[wid] = -1;
	Ext.getCmp('tbId').remove('tabId' + wid, true);
	Ext.getCmp('splitButtonId').menu.remove( 'splitId' + wid,true);
	Ext.getCmp('tbId').remove('spacerId' + wid, true);
	var tempWin = document.getElementById('winId' + wid);
	tempWin.parentNode.removeChild(tempWin); 
	colorChange(1);	
}

function handleMultiDelet(pageId){
	var widArr = new Array();
	for(var i = 0; i < pageId.length; i++){
		widArr.push(idArray[pageId[i]])
	}
	if(typeof(widArr)!='undefined' && widArr != -1){
		closeMultiTabs(widArr);
	}
}

function closeMultiTabs(widArr){
	var wid;
	for(var i = 0; i < widArr.length; i++){
		wid = widArr[i];
		linkArray[reverseLinkArray[wid]] = -1;
		idArray[reverseIdArray[wid]] = -1;
		reverseIdArray[wid] = -1;
		Ext.getCmp('tbId').remove('tabId' + wid, true);
		Ext.getCmp('splitButtonId').menu.remove( 'splitId' + wid,true);
		Ext.getCmp('tbId').remove('spacerId' + wid, true);
		skyWindow.remove('winId' + wid, true); 	
	}
}

function closeTemplateTab(wid,pwid){
	linkArray[reverseLinkArray[wid]] = -1;
	idArray[reverseIdArray[wid]] = -1;
	reverseIdArray[wid] = -1;
	Ext.getCmp('tbId').remove('tabId' + wid, true);
	Ext.getCmp('splitButtonId').menu.remove('splitId'+wid,true);
	Ext.getCmp('tbId').remove('spacerId' + wid, true);
	var tempWin = document.getElementById('winId' + wid);
	tempWin.parentNode.removeChild(tempWin);
	var tempPWin = document.getElementById('winId' + pwid);
	
	if(tempPWin == null || tempPWin == undefined){
		colorChange(1); 	
	}else{
		if(pwid >= 1)
			colorChange(pwid); 		
	}
}
function changeTitle(wid, newTitle,winTitle){
	if(win)
		win.hide();
	var width = skyWindow.findById('winId' + wid).getWidth();
	
	Ext.getCmp('tabId' + wid).setTooltip(newTitle);
	var changedTitle=getTitleText(newTitle);
	winTitle=getHeaderTitleText(winTitle,width,wid);
	Ext.getCmp('tabId' + wid).setText(changedTitle);
	Ext.getCmp('splitId' + wid).setText(changedTitle) ;
	skyWindow.findById('winId' + wid).setTitle(winTitle);
	titleArray[wid] = newTitle;
	setTooltipOnWindowTitle(wid,newTitle);
}
function setTooltipOnWindowTitle(wid,titleText){
	var tempWindow=Ext.getCmp('winId' + wid);
	var tempHeader=tempWindow.header;
	var winTitleElement=tempHeader.child('span:last-child');
	new Ext.ToolTip({
		target: winTitleElement.id,
		trackMouse: true,
		anchor: 'top',
		anchorOffset:5,
		html:titleText								  
	});
}
function addStageProgression(wid, StageHTML){
	var win = skyWindow.findById('winId' + wid);
	if(win != null && typeof(win ) != 'undefined'){
		win.stageIndicator = StageHTML;
		var existingTitle = skyWindow.findById('winId' + wid).title;
		var answerIdx = existingTitle.search('<div id="title">');
		if(answerIdx!= -1) {
			var startIndex = existingTitle.indexOf('<div id="title">') + 16 ;
			var endIndex = existingTitle.indexOf('</div>');
			existingTitle = existingTitle.substring(startIndex, endIndex );
		}
					  
		var newTitleWithStage = StageHTML;
		var charWidth = skyWindow.findById('winId' + wid).getWidth();
		if(charWidth >=650){
			newTitleWithStage = adjustStageProgressionLabels(charWidth, newTitleWithStage);
			
			skyWindow.findById('winId' + wid).setTitle(setTitleWithStageProgression(existingTitle, newTitleWithStage));
			win2.addClass('headerOnRender');
			
		}else{
			skyWindow.findById('winId' + wid).setTitle(existingTitle);
		}
	}	
}
function getHeaderTitleText(title,width,wid){
	var titleText = title;
	var chars;
  if(title!=null && title!=''){
	
	
	if((width < 650) || wid==1 || (width >= 650 && ( pagetargettocontrolhelp != "INCIDENTPAGE" && pagetargettocontrolhelp!="INCIDENTPAGECUSTOM" && pagetargettocontrolhelp != "CHANGEREQUESTPAGE"  && pagetargettocontrolhelp!="CHANGEREQUESTPAGECUSTOM" && pagetargettocontrolhelp != "PROBLEMPAGE" && pagetargettocontrolhelp != "TASKPAGECUSTOM" && pagetargettocontrolhelp != "TASKPAGE" && pagetargettocontrolhelp != "BROADCASTSPAGE") ) ){	
		chars = (width -110)/11;
	}else if((width >=650) && (pagetargettocontrolhelp == "INCIDENTPAGE" || pagetargettocontrolhelp == "CHANGEREQUESTPAGE" || pagetargettocontrolhelp=="INCIDENTPAGECUSTOM" || pagetargettocontrolhelp=="CHANGEREQUESTPAGECUSTOM" || pagetargettocontrolhelp == "PROBLEMPAGE" || pagetargettocontrolhelp == "TASKPAGECUSTOM" || pagetargettocontrolhelp == "TASKPAGE" || pagetargettocontrolhelp == "BROADCASTSPAGE")){
	    chars = (width - 510)/11;
	}
	if(title.length > chars){
		titleText = title.substring(0,chars) + '...';
	}else{
		titleText = title;
	}
	
	}
	return titleText;
}   
function highlightWindow(wid){
	skyWindow.findById('winId' + wid).show();
}
function getId(pageRef){
	var customLinkValue = getParam(pageRef,'isCustomActionLink');
	if(customLinkValue != null && typeof(customLinkValue) != 'undefined' && customLinkValue!=''){
		var customLinkValueSplit =customLinkValue.split('~');
		if(customLinkValueSplit != null && typeof(customLinkValueSplit) != 'undefined' && customLinkValueSplit.length >1){
			return customLinkValueSplit[1];
		}
	}
	return getParam(pageRef, 'id');
}
function handleSave(wid, id){
	if(typeof(idArray[id]) == 'undefined' || idArray[id] == wid){
	 idArray[reverseIdArray[wid]] = -1;
	 idArray[id] = wid;
	 reverseIdArray[wid] = id;
	 linkArray[reverseLinkArray[wid]] = -1;
	}
}
function updateListWindow(pageTarget,tabHeader,windowHeader){
	var wid = 1;
	var changedTitle=getTitleText(tabHeader);
	Ext.getCmp('tabId' + wid).setText(changedTitle);
	Ext.getCmp('splitId' + wid).setText(changedTitle) ;
	skyWindow.findById('winId' + wid);
	var win = skyWindow.findById('winId' + wid);
	pageTarget = pageTarget+"&wid="+wid;
	if(win != null){
		linkArray[pageTarget] = 1;
		reverseLinkArray[1] = pageTarget;
		win.setTitle(windowHeader)
		Ext.get(win.body.id).update('<iframe name = "naviframe'+wid+'" src =\"\/apex\/'+pageTarget+'\" style=\"width:100%;height:100%;border:none\"/>');
	}
	win.show();
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
function changeHeader(headerVal){
	headerVal=replaceAll(headerVal,'%25','%');
	headerVal=replaceAll(headerVal,'%23','#');
	headerVal=replaceAll(headerVal,'%26','&');
	headerVal=replaceAll(headerVal,'%22','"');
	headerVal=replaceAll(headerVal,'%2B','+');
	headerVal=replaceAll(headerVal,'&amp;','&');
	return headerVal; 
}


function htmlEncode(value){
	// SFDC raises an exception if it finds a closing script tag - so prevent it gracefully in query
    value = value.replace("/script>","");
	var div = document.createElement('div');
	div.innerHTML = value;
	return div.firstChild.nodeValue;
}

function addTab(pageTarget,tabHeader,windowHeader) {
	tabHeader = htmlEncode(tabHeader);
	windowHeader = htmlEncode(windowHeader);
	pageTarget = unescape(pageTarget);
	var pageId = getId(pageTarget);
	if(tabHeader.match('%23') != -1) {
		tabHeader = tabHeader.replace('%23', '#');
	}
	if(windowHeader.match('%23') != -1) {
		windowHeader = windowHeader.replace('%23', '#');
	}
	if(tabHeader.match('%20') != -1) {
		tabHeader = tabHeader.replace('%20', ' ');
	}
	windowHeader = windowHeader.replace(' #','# ');
	tabHeader=changeHeader(tabHeader);
	windowHeader=changeHeader(windowHeader);
	tabToolTipText=tabHeader;
	if(pageTarget.match('%26') != -1) {
		pageTarget = pageTarget.replace('%26', '&');
	}
	if(pageTarget.match('%23') != -1) {
		pageTarget = pageTarget.replace('%23', '#');
	}
	pageTarget = unescape(pageTarget);
	if (pageTarget.match(/SearchPage/) != null) {
                     
                           standardLayout = getUrlParameter('standardLayout');
                          var popupid = getUrlParameter('popupId');   
                     if(standardLayout=='true' && popupid=='Organization%26view=list'){
                         
                        pageTarget = pageTarget + '&pgheight='+444 ;   
                      }else{

                         pageTarget = pageTarget + '&pgheight=' + getClientHeightForList(); 
                      } 
		
	}
	var wid = linkArray[pageTarget];
	   if(typeof(wid)!='undefined' && wid!= -1 && (( pageTarget.match(/\?id/)!=null || pageTarget.match(/\&id/)!=null || pageTarget.match(/\&qvId/)!=null || pageTarget.match(/\?qvId/)!=null || pageTarget.match(/ManagePage/)!=null))){
		  highlightWindow(wid);	
	}else if(pageId!=null && pageId!='' && typeof(idArray[pageId])!='undefined' && idArray[pageId]!= -1 ){
		highlightWindow(idArray[pageId]);
	}else if((pageId == null || pageId =='' )&& index>1 && (pageTarget.match(/SearchPage/)!=null || pageTarget.match(/SelfServiceSettingsCollection/)!=null )){
		updateListWindow(pageTarget,tabHeader,windowHeader);
	}else if(typeof(wid)!='undefined' && wid!= -1 && (pageTarget.match(/\?isPrbLink/)!=null || pageTarget.match(/\&isPrbLink/)!=null)){
		highlightWindow(wid);
	}else{
		idArray[pageId] = index;
		reverseIdArray[index] = pageId;
		linkArray[pageTarget] = index;
		reverseLinkArray[index] = pageTarget;
		indexArray[tabHeader] = index;
		titleArray[index] = tabHeader;
		tabHeader = getTitleText(tabHeader);
	   
		tabCount++;
		var link = pageTarget;
		if(link.match(/\?/)){
			link = link + '&wid='+index;
		}else{
			link = link + '?wid='+index;
		}
		counter++;
		tempIndexTab = index++;
		tb.add( {
			id :'tabId' + tempIndexTab,
			tooltipType : 'title',
			tooltip: tabToolTipText,
			text : tabHeader,
			width : 70,
			enableToggle: true,
			listeners: {
				toggle :onItemToggle
			},
			pressed :true
	   } );
	   tb.add({
			id:'spacerId'+tempIndexTab,
			xtype: 'spacer',
			width:5
		   
		});
	   windowIndex = index;
	   splitIndex = tempIndexTab;
	   splitButton.menu.add( {
		   id :'splitId' + splitIndex,
		   text :tabHeader ,
		   checked : false,
		   group :'sBtnItemGroup',
		  
		   handler:onItemCheck
			
		   
	   } );
	   tb.doLayout(true,true);
	   openPanel(link,windowHeader);
   }
}

function openPanel(pageTarget2,windowHeader) {
//Code for std form...To add or edit agreement through CMDB SI

 if(getUrlParameter('fromstdCI')=='true') {
		if(getUrlParameter('BMC_BaseElementid')!=null && getUrlParameter('BMC_BaseElementid')!='') {
		   pageTarget2=pageTarget2+"&BMC_BaseElementid="+getUrlParameter('BMC_BaseElementid');
		}
		else if(getUrlParameter('id')!=null && getUrlParameter('id')!='') {
		   pageTarget2=pageTarget2+"&id="+getUrlParameter('id');
		}
	}
	
if(getUrlParameter('standardLayout')=='true'){
	var param=getUrlParameter('target');
	if(param.indexOf('ChangeSchedule')!=-1){
	
	pageTarget2=pageTarget2+"&standardLayout=true";
	
	}
}
	
	
//Code for std form..End
	pageTarget2 = unescape(pageTarget2);
	var wid = getParam(pageTarget2, 'wid');                            
	tempIndexWin = windowIndex-1;
	splitIndex = tempIndexWin;
	var finalpagenameforhelp;
	var splitted_pgetarget = pageTarget2.split('?');  
	pagetargettocontrolhelp = splitted_pgetarget[0];
	pagetargettocontrolhelp = pagetargettocontrolhelp.toUpperCase();
	var preSrc = '';
	if(!getParam(pageTarget2,'isCustomActionLink').match(/\true/)){
			preSrc = '\/apex\/';
	}
	
	win2 = new Ext.Window({

		id :'winId' + tempIndexWin,
		title       : windowHeader,
		stageIndicator    : '',
		renderTo    : skyWindow.body,
		constrain   : true,
		width : 400,
		height : 300,
		maximizable : true,
		minimizable : true,
		resizable : true,
		frame:false,
		border : true,
		closable : true,    
		xOnMove:xOnMove,
	    yOnMove:yOnMove,
		cls :'headerDefault',
		tools:[
			{
				id: 'pm',
		 
				handler: function() {
		   
					var ifrm = 'naviframe'+wid;
					var naviframe = window.frames[ifrm].senddata();
					if(pagetargettocontrolhelp == "CMDBMANAGER"){
						naviframe = window.frames[ifrm].CMDBManagerNamespace.instance.showMetrics();
					}
					var pagenameforhelp = new Array();
					pagenameforhelp = pageTarget2.split("?");
					var tooltipfo = new Ext.QuickTip({
						target: this,
						title : '',
						anchor: 'right',
						width: 200,
						shadow :'sides',
						bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
						dismissDelay: 1500000,
						html: naviframe
					});
					tooltipfo.show();
									   
				},
				hidden: (pagetargettocontrolhelp == "SEARCHPAGE")? true:(pagetargettocontrolhelp == "APPROVALLISTVIEWPAGE")? true:(pagetargettocontrolhelp == "INCIDENTPAGE")?false:(pagetargettocontrolhelp == "TASKPAGE")?false:(pagetargettocontrolhelp == "CMDBMANAGER")?false:(pagetargettocontrolhelp == "CIEXPLORERLAUNCHER")?false:(pagetargettocontrolhelp == "CHANGEASSESSMENTPAGE")?false:(pagetargettocontrolhelp == "CHANGEAPPROVAL")?false:(pagetargettocontrolhelp == "CHANGEREQUESTPAGE")?false:(pagetargettocontrolhelp == "PROBLEMPAGE")?false:(pagetargettocontrolhelp == "INCIDENTPAGECUSTOM")?false:(pagetargettocontrolhelp == "CHANGEREQUESTPAGECUSTOM")?false:(pagetargettocontrolhelp == "TASKPAGECUSTOM")?false:(pagetargettocontrolhelp == "REQUESTDEFPAGE")?false:true
			},{
									  
			id: 'dpm',
									 
			handler: function() {
			},
			hidden: (pagetargettocontrolhelp != "SEARCHPAGE")? true:false
			},
			{
				id: 'help',
									 
				handler: function() {
					var frameurlinhelp = window.frames['naviframe1'].location.pathname;
					var splitted_path = frameurlinhelp .split('/');  
					finalpagenameforhelp = splitted_path[splitted_path.length-1];
					finalpagenameforhelp = finalpagenameforhelp.toUpperCase();
					if(finalpagenameforhelp == 'SEARCHPAGE')
					{
						var stringtopass;
						var pagenameforhelp = new Array();
						pagenameforhelp = pageTarget2.split("?");
						if(pagenameforhelp[0] == 'SearchPage'){
							stringtopass = 'list';				   
						}
						else{
							stringtopass ='form';
						}
						window.frames['naviframe1'].showFrameHelp(stringtopass);
					}else if(finalpagenameforhelp == 'CMDBMANAGER'){
						window.frames['naviframe1'].CMDBManagerNamespace.instance.showHelp();
					}else if(finalpagenameforhelp == 'APPROVALLISTVIEWPAGE')
					{
						var stringtopass;
						var pagenameforhelp = new Array();
						pagenameforhelp = pageTarget2.split("?");
						pagenameforhelp[0] = pagenameforhelp[0].toUpperCase();
						if(pagenameforhelp[0] == 'APPROVALLISTVIEWPAGE'){
							stringtopass = 'list';				   
						}
						else{
							stringtopass ='form';
						}
						window.frames['naviframe1'].showFrameHelp(stringtopass);
					}
					else{
						window.frames['naviframe1'].OpenHelppage();					
					}

				},
				hidden: (pagetargettocontrolhelp == "INCPROCMGMTPAGE" || pagetargettocontrolhelp == "CHANGEPROCMGMTPAGE" || pagetargettocontrolhelp == "PROBLEMPROCMGMTPAGE")? true:false
			}
								   
		],
		defaultButton : 'tabId'+tempIndexWin,
		html :'<iframe name = "naviframe'+wid+'" src =\"'+pageTarget2+'\" style=\"width:100%;height:100%;border:none\"/>',
		listeners : {
			beforeclose:function(w){
				var str = this.id;
				var resTokens = str.split("winId");
				var wid = resTokens[1];
				if (!w.pendingClose && changeArray[wid] != null && typeof(changeArray[wid]) != 'undefined' && changeArray[wid] != -1 ){
					Ext.Msg.show({
						title:labelcloseWindow,
						msg: labelcloseWindowLabel,
						buttons: Ext.Msg.YESNO,
						fn:  function(btn){
							if (btn == 'yes'){
								w.pendingClose = true;
								w.close();
							}
						},
						icon: Ext.MessageBox.WARNING
					});
					return false; //always return false
				}
		},
		close : function() {
			counter--;
											
			var str = this.id;
			var resTokens = str.split("winId");
			var tabButton=Ext.getCmp('tabId' + resTokens[1]);        
            var spacerButton=Ext.getCmp('spacerId' + resTokens[1]); 
            var spiltButton=Ext.getCmp('splitButtonId');  
            		
            /*
		 To remove the element from the toolbar first unhide that element and then remove the element this will take care of hiding the chevron button dynamically. 
		    */ 
			if (tabButton.xtbHidden == true) {
                tb.getLayout().unhideItem(tabButton);  
			}
            if (spacerButton.xtbHidden == true) {
                tb.getLayout().unhideItem(spacerButton);  
            }

			tb.remove(tabButton, true);
			tb.remove(spacerButton, true);
			linkArray[reverseLinkArray[resTokens[1]]] = -1;
			spiltButton.menu.remove( 'splitId' + resTokens[1],true);
			
			try{
				var ifrm = 'naviframe'+wid;
				var frmWin = window.frames[ifrm].window; // TODO - Frames 1 must be replaced by something else
				frmWin.document.clear();
				frmWin.location.href = "about:blank";
			}catch(e){}

			skyWindow.remove(this, true);
			
			linkArray[reverseLinkArray[resTokens[1]]] = -1;
			idArray[reverseIdArray[resTokens[1]]] = -1;
			reverseIdArray[resTokens[1]] = -1;
			tabCount--;
			if(Ext.getCmp('winId1')!=null && Ext.getCmp('winId1')!='undefined')
			   Ext.getCmp('winId1').show();
			colorChange(1);
			tb.doLayout(true,true);	
            if(tempIndexWin == 1 && pagetargettocontrolhelp !='SEARCHPAGE'){
			   window.parent.CloseActiveTab(); 
			}		
	   		if(tabCount == 0 && pagetargettocontrolhelp =='CIEXPLORERLAUNCHER'){
			   window.parent.CloseActiveTab(); 
			}				
			
			try{
				this.removeAll();
			}catch(e){}
		},
		minimize : function(){
			this.hide();
			var tempId = this.id;
			var resTokens = tempId.split("winId");
			this.setAnimateTarget(this.defaultButton);
			this.hide();
			onWindowMinimize(resTokens[1]);
		},
		maximize: function(){ 
			this.focus();
			db=this.defaultButton;
			Ext.getCmp(db);            
			this.setAnimateTarget(Ext.getCmp(db));
			this.removeClass("headerOnRestore");
			this.addClass("headerOnMaximize");		
            this.tools['restore'].dom.style.display= 'inline'; 
            this.tools['maximize'].dom.style.display= 'none'; 
			
		},
		restore: function(){ 
			this.focus();
			this.removeClass("headerOnMaximize");
			this.addClass("headerOnRestore");
			this.tools['maximize'].dom.style.display= 'inline';
            this.tools['restore'].dom.style.display= 'none';
		},
		resize: function(){ 
			tb.doLayout(true,true);
			var str = this.id;
			var resTokens = str.split("winId");
			var orignalTitle = titleArray[resTokens[1]];
		    
			var winTitle = getHeaderTitleText(orignalTitle ,this.getWidth(),resTokens[1]);
		    
			var winTitleWithStageHTML = this.stageIndicator;
			if(winTitleWithStageHTML != ''){
			   if(this.getWidth() >=650)
			   {
				   winTitleWithStageHTML = adjustStageProgressionLabels(this.getWidth(),winTitleWithStageHTML);
				   	
				   this.setTitle(setTitleWithStageProgression(winTitle, winTitleWithStageHTML)) ;
				   
			   }
			   else
			   {
				   this.removeClass('headerOnRender');
				   this.setTitle(winTitle) ;
			   }
			} 
		   
			if(document.getElementById('stageprogressbar') != null){
				this.addClass('headerOnRender');
			}else {
				this.removeClass('headerOnRender');
			} 
		   
			var resTokens = str.split("winId");
			var wid = resTokens[1];
			if(refreshGridArray[wid]!=null)
				refreshGridArray[wid]();   
			if(refreshSearchPageToolbar[1]!=null)
				refreshSearchPageToolbar[1]();
		},
		move : function() {
					   if(isBrowserWindowMaximized()){
						this.xOnMove=this.x;
						this.yOnMove=this.y;
					 }
		}

										
		}

	});

	skyWindow.add(win2 );
	win2.on('activate', function(){
		
		var str = this.id;
		var resTokens = str.split("winId");
		colorChange(resTokens[1]);
		  this.focus();
	} );
	
	if(tempIndexWin == 1 && pagetargettocontrolhelp =='SEARCHPAGE'){
	   win2.tools.close.disabled = true;
	   win2.addClass('closeBtnDisabledCls');  
	}

	applyToolTipOnWinHeaderBtn();
	setTooltipOnWindowTitle(tempIndexWin,windowHeader);
	try{
		win2.show();
		win2.maximize();
	}catch(e){
		win2.maximize(); 
		win2.setSize(500,600); 
		win2.minimize(); 
	   
		win2.show(); 
		win2.on('restore', function(){ 
			win2.setSize(400,300); 
			win2.setPosition(200, 200);  
		}); 
		var str = win2.id; 
		var resTokens = str.split("winId"); 
		colorChange(resTokens[1]);                        
	}					
}
function setWindowPosition(){
	Ext.WindowMgr.each(
		function(win){
		if(win.xOnMove!=0)
			win.setPosition(win.xOnMove,win.yOnMove);
			
		}
	);
}
function closeTabsByCount(){
	if(tabCount!=1 ){
		counter--;
		Ext.getCmp('tbId').remove('tabId' + selectedWinId, true);
		Ext.getCmp('tbId').remove('spacerId' + selectedWinId, true);
		linkArray[reverseLinkArray[selectedWinId]] = -1;
		Ext.getCmp('splitButtonId').menu.remove( 'splitId' + selectedWinId,true);
		linkArray[reverseLinkArray[selectedWinId]] = -1;
		idArray[reverseIdArray[selectedWinId]] = -1;
		if(selectedWinId!=1){
			Ext.getCmp('winId'+selectedWinId).close();
		}else{
			 for (var i = 2; i <=index; i++) {
				if(Ext.getCmp('winId'+i)!=null){
					Ext.getCmp('winId'+selectedWinId).close();
					Ext.getCmp('winId'+ i).show();
					colorChange(i);
					break;
				}
			}
		}   
		tb.doLayout(true,true);
	}else{
		window.parent.setQVTabId();
	}
}
function applyToolTipOnWinHeaderBtn() {
	new Ext.ToolTip({
				target: win2.tools['close'],
				trackMouse: true,
				anchor: 'top',
				anchorOffset:10,
				html:ToolTipClose
	});
	new Ext.ToolTip({
				  target: win2.tools['minimize'],
				  trackMouse: true,
				  anchor: 'top',
				  html:TooltipMinimize
															
	 });
	 new Ext.ToolTip({
				  target: win2.tools['maximize'],
				  trackMouse: true,
				  anchor: 'top',
				  html:TooltipMaximize
															
	 });
	 new Ext.ToolTip({
				  target: win2.tools['restore'],
				  trackMouse: true,
				  anchor: 'top',
				  html:TooltipRestore
															
	 });
	 new Ext.ToolTip({
				  target: win2.tools['help'],
				  trackMouse: true,
				  anchor: 'top',
				  html: ToolTipHelp
															
	 });
}
function onItemToggle(item, pressed) {if(win)win.hide();
	var str2 = item.id;
	var loc = getModuleName();
		if(str2=='tabId1' && (loc.indexOf(NavTasksLabel) > -1 || loc.indexOf(NavIncidentsLabel) > -1 || loc.indexOf(NavChangeAssessmentsLabel) > -1 || loc.indexOf(NavProblemsLabel) > -1 || loc.indexOf(NavChangeRequestsLabel) > -1 || loc.indexOf(NavSLALabel) > -1)&& needsRefresh)
	   {
	   refreshList();
	   needsRefresh = false;
	}
	resTokens = str2.split("tabId");
	Ext.getCmp('winId' + resTokens[1]).show();
	colorChange(resTokens[1]);			
}
function onItemCheck(item, checked) {
           
	var str2 = item.id;
	resTokens = str2.split("splitId");

	if(item.id== 'splitCascadeId' ) {
		var x=0;
		var y=0;
		for ( var i = 1; i <=index; i++) {
			   
			if(Ext.getCmp('winId'+i)!=null) {
				if(Ext.getCmp('winId'+i).maximized==true)
					Ext.getCmp('winId' + i).restore();
				Ext.getCmp('winId'+i).setPosition(x, y);  
				Ext.getCmp('winId' + i).show();
				x=x+40;
				y=y+50;
			}
		}
	}
	if(item.id== 'splitTileId' ) {
	  var totalHeight=skyWindow.getHeight();
	  var tiledHeight=0;
	  var   tiledWidth=skyWindow.getWidth()/2;
	  
		if(counter==2) {
			tiledHeight=totalHeight;
		}else{
		   
		   if((counter%2)==0){
			  tiledHeight=(totalHeight/counter)*2;
		   }else{
			   tiledHeight=(totalHeight/(counter+1))*2;
		   }
	   
		}
  
		var x=0;
		var y=0;
		var cFlag=0;
		for ( var i = 1; i <=index; i++) {
				if(Ext.getCmp('winId'+i)!=null) {
						if(Ext.getCmp('winId'+i).maximized==true)
							Ext.getCmp('winId' + i).restore();
						Ext.getCmp('winId'+i).setPosition(x, y);  
					  
						Ext.getCmp('winId'+i).setHeight(tiledHeight);
					   
						Ext.getCmp('winId'+i).setWidth(tiledWidth);
						Ext.getCmp('winId' + i).show();
						cFlag++;
						x=x+tiledWidth+2;
						if((cFlag%2)==0) {
							x=0;
							y=y+tiledHeight+2;
					  }
				}		 
		}
	}
	 if(item.id!= 'splitTileId' && item.id != 'splitCascadeId') {
	 	 Ext.getCmp('winId' + resTokens[1]).show();
	 }
}
function onWindowMinimize(idIndex){
   if(idIndex!=1 &&  Ext.getCmp('winId1').hidden==false){
	   Ext.getCmp('winId1').show();
	   colorChange(1);
   }else{
		for (var i = 2; i <=index; i++) {
		  if(Ext.getCmp('winId'+i)!=null && Ext.getCmp('winId'+i).hidden==false ){
			  Ext.getCmp('winId'+ i).show();
			  colorChange(i);
			  break;
		  }else if(Ext.getCmp('winId1').hidden==false){
			  colorChange(1);
		  }
	  }
   }
}
function colorChange(idIndex) {
   selectedWinId= idIndex;
   for ( var i = 1; i <=index; i++) {
        var winObj=Ext.getCmp('winId' + i);
		var tabObj=Ext.getCmp('tabId' + i);
		var splitBtnObj=Ext.getCmp('splitId' + i);
		if(winObj!=null) {
		   if(i== idIndex){
			   winObj.removeClass("headerDefault");
			   winObj.removeClass("headerLightBlue");
			   winObj.removeClass("headerBlue");
			   winObj.addClass("headerBlue");
			   winObj.show();
		   }else {
			   winObj.removeClass("headerDefault");
			   winObj.removeClass("headerBlue");
			   winObj.removeClass("headerLightBlue ");
			   winObj.addClass("headerLightBlue");            
		   }
	   }
	   if(Ext.getCmp('tabId'+i)!=null) {
		   if(i== idIndex){
			  tabObj.removeClass("bgGrey");
			  tabObj.removeClass("bgBlue");
			  tabObj.addClass("bgBlue");
		   }else {
			   tabObj.removeClass("bgBlue");
			   tabObj.removeClass("bgGrey");
			   tabObj.addClass("bgGrey");            
		   }
	   }
	  if(splitBtnObj!=null) {
		   if(i==idIndex){
				   splitBtnObj.setChecked(true);
		   }  
	   } 
	}  
}               
var firstWindowWidth;           
Ext.onReady( function() {
                       
   Ext.override(Ext.Panel, {
	   createToolHandler : function(t, tc, overCls, panel){
		 return function(e){
			 t.removeClass(overCls);
			 e.stopEvent();
			 if(!t.disabled && tc.handler){
				   tc.handler.call(tc.scope || t, e, t, panel);
			 }
		 };
	  }
	});

          
            var showPopupHeader = getUrlParameter('popupHeader');
            showPopupHeader = showPopupHeader.replace(/\+/gi," ");
            document.title=showPopupHeader;
            
            //change end by mayuri

	
	var skyWindowWidth='98%';
	var tbWidth='auto';
	var skyWindowHeight=Ext.isIE7 ? 730: Ext.isIE8 ? 716:Ext.isSafari ? 735:720;
	
	// changes for standard layout
	var standardLayout = getUrlParameter('standardLayout');
	if(standardLayout != 'true'){
		if(typeof(parent.parent.Ext.getCmp('winId1')) !='undefined' && parent.parent.Ext.getCmp('winId1') !=null){
			firstWindowWidth=parent.parent.Ext.getCmp('winId1').getWidth();
		}
	}
	//end for standard layout
	
	
   if(paramTabName == 'SSCategory' || paramTabName == 'SSTemplate' || paramTabName ==  'SSFAQ'){
    skyWindowWidth=firstWindowWidth- 50;
    tbWidth=skyWindowWidth;
	if(typeof(parent.parent.Ext.getCmp('winId1')) !='undefined' && parent.parent.Ext.getCmp('winId1') !=null)
      parent.parent.Ext.getCmp('winId1').on('resize', setWidthForSelfSetting);
	if(firstWindowWidth >800){
	skyWindowWidth=firstWindowWidth- 175;
	tbWidth=skyWindowWidth;
	}
	
   }
	tb = new Ext.Toolbar( {
		id :'tbId',
		width :tbWidth,
		height :'35',
		renderTo :'menubar',
		cls :'tBarCls'
	});

	skyWindow = new Ext.Window({
		renderTo    : 'skyWind',
		baseCls : 'sky',
		width       : skyWindowWidth,
		shadow :false,
		resizable : false,
		closable : false,
		height:skyWindowHeight,
		bodyStyle:{"background-color":"#FFFFFF"} ,
		listeners: {
			afterlayout: function(){
			  tb.doLayout();
			  setWindowPosition();
			}
			
		}
	});
	splitButton = new Ext.Button( {

		id :'splitButtonId',
		tooltipType : 'title',
		tooltip: labellayout,
		enableToggle:false,
		iconCls : 'blist',
		cls:'splitButtonCls',
		menu : {
			cls:'splitMenuCls',
			items : [{
						id :'splitCascadeId',
						text : NavCascade,
						checked : false,
						 
						 group :'sBtnItemGroup',
						 handler:onItemCheck
				   },
				   {
						id :'splitTileId',
						text : NavTile,
						checked : false,
						 group :'sBtnItemGroup',
						 handler:onItemCheck
				   },'-']
		},
		listeners: {
			mouseover: function(){
				this.setIconClass('blistOn');    
			},
			mouseout: function(){
				this.setIconClass('blist');          
			}
			
		}
	});

	tb.add(splitButton);
	tb.add({
		
		xtype: 'spacer',
		width:2
	   
	});
	
	tb.add('-');
	tb.add({
		
		xtype: 'spacer',
		width:7
	   
	});
	tb.doLayout(true,true);

	var skyDiv = document.getElementById('skyWind');
	if(skyDiv ){
		if(Ext.isIE7){
			skyDiv.style.marginTop = "375px";
		}else if(Ext.isIE){
			skyDiv.style.marginTop = "344px";
		}else if(Ext.isSafari){
			skyDiv.style.marginTop = "353px";
		}else{
			skyDiv.style.marginTop = "345px";
		}
	}
  
   if(paramTabName == 'SSCategory' || paramTabName == 'SSTemplate' || paramTabName ==  'SSFAQ'){
      adjustWindowSizeForSelfServiceSetting();
   }
	skyWindow.show();
	if(paramuseListViewTarget == 'true') {            
		var pageInfo = window.parent.getPageTarget().split('¬');
		addTab(pageInfo[0],pageInfo[1],pageInfo[1]);
		window.parent.setpageTarget(null);
	}
	
	
	if(tabTitle!='') {
		if(standardLayout == 'true'){
			
			if(paramTarget!=null && paramTarget.indexOf('AppAdmin') != -1){
				paramTarget = paramTarget + '&standardLayout=true';
			}
			
			addTab(paramTarget,tabTitle,paramtitle);
		}else{
			addTab(paramTarget,tabTitle,paramtitle);
		}
	}else {
		if(standardLayout == 'true'){
			
			if(paramTarget!=null && paramTarget.indexOf('AppAdmin') != -1){
				paramTarget = paramTarget + '&standardLayout=true';
			}
			
			addTab(paramTarget,paramtitle,paramtitle);
		}else{
			addTab(paramTarget,paramtitle,paramtitle);
		}
	}
	var localTabName = paramTabName;
	if(localTabName  != null && localTabName  != '' && localTabName  != 'SSFAQ' && localTabName  != 'SSCategory' && localTabName  != 'SSTemplate') 
	window.parent.setTabFunctionList(localTabName , addTab);     
	Ext.QuickTips.init();
});

function adjustStageProgressionLabels(screenWidth, stageProgressionTable){
	//alert(stageProgressionTable);
	var newData = '';
	var NewStageLabel = '';
	var formWidth = screenWidth - 670;
	var addCount = 0;
	var tokenCount = 0;
	if((formWidth > 115) && (formWidth < 271)){
		addCount = 4;
	}else if((formWidth > 270) && (formWidth < 436)){
		addCount = 8;
	}else if((formWidth > 435) && (formWidth < 601)){
		addCount = 12;
	}else if(formWidth > 600){
		addCount = 16;
	}
	var htmlData = stageProgressionTable.split('</span>');
	var tokenNum = htmlData.length - 1;
	for(var i = 0 ; i < tokenNum ; i++){
		var startIndex = htmlData[i].lastIndexOf('>');
		
		var stageLabel = htmlData[i].substring(startIndex + 1,htmlData[i].length);
		
		tokenCount = stageLabel.length + addCount;
		if(i == 0){
			NewStageLabel = StageProgression_Opened.substring(0,tokenCount);
		}else if(i == 1){
			NewStageLabel = StageProgression_Acknowledged.substring(0,tokenCount);
		}else if(i == 2){
			NewStageLabel = StageProgression_InProcess.substring(0,tokenCount);
		}else if(i == 3){
			NewStageLabel = StageProgression_Closed.substring(0,tokenCount);
		} 
		
		newData += htmlData[i].substring(0,startIndex + 1) + NewStageLabel + '</span>';
	}
	newData +=  htmlData[4];
	
	return newData;
	
}
function setWidthForSelfSetting(){

  try{
	if(typeof(parent.parent.Ext.getCmp('winId1')) !='undefined' && parent.parent.Ext.getCmp('winId1') !=null){
		firstWindowWidth=parent.parent.Ext.getCmp('winId1').getWidth();
		skyWindow.setWidth(firstWindowWidth-40);
		tb.setWidth(firstWindowWidth-40);
		if(firstWindowWidth >800){
		skyWindow.setWidth(firstWindowWidth-175);
		tb.setWidth(firstWindowWidth-175);
	}
	skyWindow.doLayout();
	Ext.WindowMgr.each(
	function(win){
	if(win!=null){
		var winId=win.id;
		var idArr=winId.split("Id");
		if(idArr[0] == 'win'){
		win.restore();
		win.maximize();
		}	
	}
	}
	);
	}
}catch(e){}
}
function adjustWindowSizeForSelfServiceSetting(){
var skyDiv = document.getElementById('skyWind');
try{
	if(Ext.isIE7){
		skyDiv.style.marginLeft = "117px";
	}else if(Ext.isIE8){
		skyDiv.style.marginLeft = "117px";
	}else if(Ext.isSafari){
		skyDiv.style.marginLeft = "110px";
	}else{
		skyDiv.style.marginLeft = "110px";
	}
	if(firstWindowWidth >800){
		skyDiv.style.marginLeft = "0px";
	}
}catch(e){}
}
function handleApprovalSubmission(w, doApprovalAction,label){
		var str = w.id;
		var resTokens = str.split("winId");
		var wid = resTokens[1];
		if (changeArray[wid] != null && typeof(changeArray[wid]) != 'undefined' && changeArray[wid] != -1 ){
			Ext.Msg.show({
				title:labelcloseWindow,
				msg: label,
				buttons: Ext.Msg.YESNO,
				fn:  function(btn){
					if(btn == 'yes'){
						doSubmitForApproval = true;
						doApprovalAction();
					}else if(btn == 'no'){
						doSubmitForApproval = false;
					}
				},
				icon: Ext.MessageBox.WARNING
			});
			return false;
		}else{
			doApprovalAction();
		}
}
