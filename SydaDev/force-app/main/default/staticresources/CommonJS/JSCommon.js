var onCompleteFunction;   
var popUpWindow;    
var lookupValues = new Array();
var activeAllWindowFlag=true;
var tabOutImg;
var BE_InstanceID;
var idNameForPopUp = false;
var customActionHeaderLabel='';
var gsPopUpWindow;
var acpopUpWindow;
var toggle=1;
var b_height=0;
var b_width=0;
var p_width=100;
var thewidth;
var position=[];
var NONPRINT ='�';
Ext.ux.collapsedPanelTitlePlugin = function ()
{
    this.init = function(p) {
        if (p.collapsible)
        {
            var r = p.region;
			var textClass = 'x-collapsed-header-text';
            if ((r == 'north') || (r == 'south'))
            {
				
                p.on ('render', function()
                    {
                        var ct = p.ownerCt;
                        ct.on ('afterlayout', function()
                            {
                                if (ct.layout[r].collapsedEl)
                                {
                                    p.collapsedTitleEl = ct.layout[r].collapsedEl.createChild ({
                                        tag: 'span',
                                        cls: textClass,
                                        html: p.title
                                    });
                                    p.setTitle = Ext.Panel.prototype.setTitle.createSequence (function(t)
                                        {p.collapsedTitleEl.dom.innerHTML = t;});
                                }
                            }, false, {single:true});
                        p.on ('collapse', function()
                            {
                                if (ct.layout[r].collapsedEl && !p.collapsedTitleEl)
                                {
                                    p.collapsedTitleEl = ct.layout[r].collapsedEl.createChild ({
                                        tag: 'span',
                                        cls: textClass,
                                        html: p.title
                                    });
                                    p.setTitle = Ext.Panel.prototype.setTitle.createSequence (function(t)
                                        {p.collapsedTitleEl.dom.innerHTML = t;});
                                }
                            }, false, {single:true});
                    });
            }
        }
    };
}

function openPopupforKM(link, onComplete, iTitle, iHeight, iWidth) {
	var customPageDetailObj =checkCustomPage();	
	  gsPopUpWindow = new Ext.Window({
		height: iHeight,
		width: iWidth,
		title: iTitle,
		x: 10,
		y: 5,
		modal:true,
		id:'mypopup1',
		resizable:false,
		bodyStyle:'background-color:#FFFFFF;',
		constrain : true,
		viewConfig: {forceFit: true},
		cls:customPageDetailObj['popUpWindowClassName'],
		frame:customPageDetailObj['isFrame'],
		html:'<iframe id="popupWindowFrameId" frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
		tools:[     
				
				{
                    id: 'help',
                    qtip: labelTooltipHelp,
                    handler: function() {
					OpenHelppage('IncidentGS','module','form');//To call help
                       
                  }
                },
                {   
                    id: 'maximize',
                    qtip: labelTooltipMaximize,
                    handler: function(){
					
						if (toggle == 1){ //Maximize
							toggle=0;
							 if(Ext.isIE){
								thewidth=document.body.offsetWidth;
							}
							else{
								thewidth=window.innerWidth;
							}
							b_height=gsPopUpWindow.getHeight();
							b_width=gsPopUpWindow.getWidth();
							position=gsPopUpWindow.getPosition(true);//758 683
							gsPopUpWindow.setPosition(0,0);
							gsPopUpWindow.setWidth(thewidth);
							this.removeClass("x-tool-maximize");
							this.addClass("x-tool-restore");
							this.dom.qtip = labelTooltipRestore;
						}
						else{//Restore
							toggle=1;
							gsPopUpWindow.setPosition(position[0],position[1]);
							gsPopUpWindow.setHeight(b_height);
							gsPopUpWindow.setWidth(b_width);
							this.removeClass("x-tool-restore");
							this.addClass("x-tool-maximize");
							this.dom.qtip = labelTooltipMaximize;
						}
					}
                },         
				{
					id: 'close',
					qtip: labelTooltipClose,
					handler: parent.closeWin
                }
            ]
	  });
	  gsPopUpWindow.show();		
}

function htmlDecode(input){
    var e = document.createElement('div');
    e.innerHTML = input;
    var ret =  e.childNodes[0].nodeValue;
    e.style.display='none';
    e.removeChild(e.childNodes[0]);     
    return ret;
}


function closeGSPopup(){
if(gsPopUpWindow!=null && gsPopUpWindow!=undefined)
    gsPopUpWindow.close(); 
}

function getClientHeightForList() {
	var screenheight = getWindowHeight();
	var logoheight = 40;
	var primarynavheight = 20;
	var padding = (5 * 2);
	var listwindowheight = 36;
	var listwindowtbheight = 36;
	var bottompadding = 20;
	var availableheight = (screenheight - logoheight - primarynavheight - padding - listwindowheight - listwindowtbheight - bottompadding); 
	return availableheight;
}
function hidePopupWindow(){
	if(popUpWindow!=null && popUpWindow!=undefined){
		popUpWindow.hide(); 
		if(typeof(onCompleteFunction) == 'function'){
			 onCompleteFunction();
		}		
	}
}
 function reloadSI(){
            	if(window.frames.SIIframeID!=undefined){ 
                      if(typeof(window.frames.SIIframeID.tabReload) == 'function')
                           window.frames.SIIframeID.tabReload(window.frames.SIIframeID.childObject);
            	}
  }
function getWindowHeight() {
	var myWidth = 0, myHeight = 0;
	if( typeof( window.innerHeight ) == 'number' && window.innerHeight > 0) {
		//Non-IE
		myHeight = window.innerHeight;
	} else if( document.documentElement && (document.documentElement.clientHeight) && document.documentElement.clientHeight > 0) {
		//IE 6+ in 'standards compliant mode'
		myHeight = document.documentElement.clientHeight;
	} else if( document.body && (document.body.clientHeight ) && document.body.clientHeight > 0) {
		//IE 4 compatible
		myHeight = document.body.clientHeight;
	}
	if (myHeight == 0) myHeight = 760;
	return myHeight; 
}
function setPopUpVar(id,add_info){
   if(id!= null && id!= '' && onCompleteFunction!=null){
		onCompleteFunction(id,add_info); 
	}
}
        
function openPopup(link, onComplete,height,width,idNameForPopUpVar,showPerformance) {
	if(idNameForPopUpVar == true){
		idNameForPopUp = idNameForPopUpVar;
	}
	//added a variable 'showPerformance' so that the user is able to set if he or she 
	//wants to show the performanance matrix in case when the height and width of the pop-up are fixed.
	//By default the value is false.
	if(showPerformance == null){
		showPerformance  = false;
	}
	return openPopupTitle(link, onComplete,height,width, '',showPerformance);
}

function openPopupTitle(link, onComplete,height,width, strtitle,showPerformance) {
	onCompleteFunction = onComplete;
	var customPageDetailObj =checkCustomPage();
	if (height!=null && width!=null){
	
		if(showPerformance){
		popUpWindow = new Ext.Window({
			height: height,
			width: width,
			x: 10,
			y: 5,
			modal:true,
			resizable:false,
			constrain : true,
			cls:customPageDetailObj['popUpWindowClassName'],
			frame:customPageDetailObj['isFrame'],
			viewConfig: {forceFit: true},
			html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
						tools:[{

					id: 'lookuppm',
					handler: function() {
						var lookuppmdata = '';
											
						
						// iCount=2 and 3 (when you close the lookup window and reopen it) is only for IE9 related
						for(var iCount =0;iCount<=3;iCount++)
						{
							if(window.frames[iCount] != 'undefined'){
								if(window.frames[iCount].document.getElementById('lookupdataval') != null){
									lookuppmdata = window.frames[iCount].document.getElementById('lookupdataval').value;						
								}
							}
							if(lookuppmdata!='')
							{
								break;
							}
						}
						
						
						var tooltiplookup = new Ext.QuickTip({
							target: this,
							title : '',
							anchor: 'right',
							width: 200,
							//trackMouse: true,
							shadow :'sides',
							bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
							dismissDelay: 1500000,
							html: lookuppmdata
						});
						tooltiplookup.show();
					},
					hidden:false
            }]			
		});
		popUpWindow.show();
		}
		else{
			popUpWindow = new Ext.Window({
			height: height,
			width: width,
			x: 10,
			y: 5,
			modal:true,
			resizable:false,
			constrain : true,
			cls:customPageDetailObj['popUpWindowClassName'],
			frame:customPageDetailObj['isFrame'],
			viewConfig: {forceFit: true},
			html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>'	});
			popUpWindow.show();
		}

   
	} else{

		popUpWindow = new Ext.Window({
			height: 570,
			width: 670,
			x: 10,
			y: 5,
			modal:true,
			resizable:false,
			constrain : true,
			cls:customPageDetailObj['popUpWindowClassName'],
			frame:customPageDetailObj['isFrame'],
			viewConfig: {forceFit: true},
			html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
			tools:[{

					id: 'lookuppm',
					handler: function() {
						var lookuppmdata = '';
						// iCount=2 and 3 (when you close the lookup window and reopen it) is only for IE9 related
						for(var iCount =0;iCount<=3;iCount++)
						{
							if(window.frames[iCount] != 'undefined'){
								if(window.frames[iCount].document.getElementById('lookupdataval') != null){
									lookuppmdata = window.frames[iCount].document.getElementById('lookupdataval').value;						
								}
							}
							if(lookuppmdata!='')
							{
								break;
							}
						}	
						var tooltiplookup = new Ext.QuickTip({
							target: this,
							title : '',
							anchor: 'right',
							width: 200,
							//trackMouse: true,
							shadow :'sides',
							bodyStyle:'font: 8pt Tahoma, Verdana, Arial; color:black;width:2%;border-color:black;',
							dismissDelay: 1500000,
							html: lookuppmdata
						});
						tooltiplookup.show();
					},
					hidden:(window.parent.parent.showPerformanceIcon==null || window.parent.parent.showPerformanceIcon =='undefined')?false:(window.parent.parent.showPerformanceIcon!= null && window.parent.parent.showPerformanceIcon!= 'undefined' && window.parent.parent.showPerformanceIcon.toLowerCase()=='true')?false:true
            }]
				
		});
		popUpWindow.show();   
	}
}
		
function openPopupForServiceTarget(link, iTitle) {
	if(!inProgress) {
		ServiceTargetHelpLink =service_target_help_link;
		openPopupWithTitle(link,null, iTitle,460,670);
	}
}
function openiframepopup(link,height,width, strtitle){
	     var customPageDetailObj =checkCustomPage();
		 popUpWindow = new parent.Ext.Window({
		    id:'popupWindowId1',
			height: height,
			width: width,
			x: 10,
			y: 5,
			title:Ext.util.Format.ellipsis(strtitle, 80),
			modal:true,
			resizable:false,
			constrain : true,
			cls:customPageDetailObj['popUpWindowClassName'],
			frame:customPageDetailObj['isFrame'],
			viewConfig: {forceFit: true},
			html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
			tools:[
                {
					id: 'help',
					qtip: labelTooltipHelp,
					handler: function() {
						OpenHelppage('ServiceTarget','module','form');
                  }
                },
				{
					id: 'close',
					qtip: labelTooltipClose,
					handler: parent.closeWin
                }				
            ]
			
		});
		  popUpWindow.show();
		  popUpWindow.center();
		 
}	
function closeWin(e,t,win){win.close();}

function openPopupWithTitle(link, onComplete, iTitle, iHeight, iWidth,clsStyle) {
	if(iTitle == null || iTitle == ''){
		iTitle = '';
		
	}
	if(iHeight == null || iHeight == ''){
		iHeight = 550;
	}
	if(iWidth == null || iWidth == ''){
		iWidth = 670;
		
	}
	
	onCompleteFunction = onComplete;
	if(clsStyle)
	{
	popUpWindow = new Ext.Window({
	    
		height: iHeight,
		width: iWidth,
		title: iTitle,
		x: 10,
		y: 5,
		modal:true,
		resizable:false,
		frame:false,
		border:false,
		cls:'portletPopup',
	
		constrain : true,
		viewConfig: {forceFit: true},
		//fixed bug no 1819
		html:'<iframe frameborder="0" scrolling="no" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none;\"/>'
		
	});
	}
	else{
	var flagForHelp = false;
	if( (link.indexOf('ComposeEmailPage') == -1) && (link.indexOf('MultiDocumentAttachmentPage')  == -1))
		flagForHelp = true;	
		
	if((link.indexOf('SLAMilestonePage') != -1))
		flagForHelp = false;	

	if(typeof(ServiceTargetHelpLink) !='undefined' && ServiceTargetHelpLink !=null ) { 
		flagForHelp = false;	
	}
		
	var customPageDetailObj =checkCustomPage();
	var pageName=link.split('?');
	var popUpWindowClassName='';
	var isFrame=true;
	if(pageName[0] !='MultiDocumentAttachmentPage'){
	  popUpWindowClassName=customPageDetailObj['popUpWindowClassName'];
	  isFrame=customPageDetailObj['isFrame'];

	}
	var backGrd = 'background-color:#FFFFFF;';
	if(link.indexOf('ComposeEmailPage')!= -1){
		backGrd = 'background-color:#EFF3F5;'
	}
	
	  popUpWindow = new Ext.Window({
		height: iHeight,
		width: iWidth,
		title: iTitle,
		x: 10,
		y: 5,
		modal:true,
		resizable:false,
		bodyStyle:backGrd,
		constrain : true,
		viewConfig: {forceFit: true},
		cls:popUpWindowClassName,
		frame:isFrame,
		html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
		tools:[
                {
					id: 'help',
					handler: function() {
							OpenHelpUrl(link);
					},
					qtip:(typeof(labelTooltipHelp) != 'undefined' && labelTooltipHelp!='undefined'&&labelTooltipHelp!=null)?labelTooltipHelp:'',
					hidden:flagForHelp
                },
                {
					id: 'close',
					qtip: (typeof(labelTooltipClose) != 'undefined' && labelTooltipClose!='undefined'&&labelTooltipClose!=null)?labelTooltipClose:'',
					handler: parent.closeWin
                }			                                     
            ]
	});
	}
	popUpWindow.show();
} 

function getEmailWinHt(){
	var xDim = 660;
	if(Ext.isIE) 	//IE 8 & 9
		xDim = 666;
	return xDim;
}

function getEmailWinWidth(){
	var yDim = 670;
//	if(Ext.isIE) 
//		yDim = 710;
	return yDim;
}

function openHierarchyPopup(link, onComplete, heightpx, widthpx, closeLabel) {
	onCompleteFunction = onComplete;
	popUpWindow = new Ext.Window({
		height: heightpx,
		width: widthpx,
		x: 10,
		y: 5,
		modal:true,
		resizable:false,
		constrain : true,
		viewConfig: {forceFit: true},
		html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;background:#FFFFFF;border:none\"/>'
		
	});
	popUpWindow.show();
	setTooltipOnWindowClose(popUpWindow, closeLabel);
}
function openHierarchyPopupWithTitle(link, onComplete, iTitle, heightpx, widthpx, closeLabel) {
	
	if(iTitle == null || iTitle == ''){
		iTitle = '';
	}
	onCompleteFunction = onComplete;
	popUpWindow = new Ext.Window({
		height: heightpx,
		width: widthpx,
		x: 10,
		y: 5,
		title: iTitle,
		modal:true,
		resizable:false,
		constrain : true,
		viewConfig: {forceFit: true},
		html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>'
		
	});
	popUpWindow.show();
	setTooltipOnWindowClose(popUpWindow, closeLabel);
}  

function openPopup1(link, onComplete) {
	onCompleteFunction = onComplete;
	popUpWindow = new Ext.Window({
		height: 400,
		width: 529,
		x: 10,
		y: 5,
		resizable:false,
		modal:true,
		constrain : true,
		viewConfig: {forceFit: true},
		html:'<iframe frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>'
		
	});
	popUpWindow.show();
} 




function closePopup(){
if(popUpWindow!=null && popUpWindow!=undefined)
    popUpWindow.close(); 
}

function changePopUpTitle(title){
	if(popUpWindow != null && popUpWindow != 'undefined')
		popUpWindow.setTitle(title); 	
}

function openPage(link, tabTitle, pageTitle) { 
	window.parent.addTab(link, tabTitle, pageTitle); 
}

function openPageForTemplate(link, onComplete, tabTitle, pageTitle) { 
	onCompleteFunction = onComplete;
	window.parent.addTab(link, tabTitle, pageTitle); 
}

function openModalDialog(link, onComplete){ 
	var returnVal = window.showModalDialog(link,"modalId","dialogWidth=600px; dialogHeight=600px; resizable=yes");
    if(onComplete != null && (returnVal != null && returnVal  != '' )){
		onComplete(returnVal); 
	}else{   
		return returnVal;
    }
}

function openLookup(popUpId, onComplete){
	return openModalDialog('/apex/SearchPage?popupId='+popUpId, onComplete);
}
function openQueueLookup(sObjectType, onComplete){
	return openModalDialog('/apex/QueueListPage?sObjectType='+sObjectType, onComplete);
}
function openAssignTo(popUpId,onComplete){
      openLookup(popUpId, onComplete);
}
function getValue(elementId){
    return document.getElementById(elementId);
}


function updateTitle(pageTitle,newTitle ){
	window.parent.changeTitle(pageTitle,newTitle );
	window.parent.refreshList();
}
		function enableMenus(arrayMenuItemId){
			var arrLength = arrayMenuItemId.length;
			var arr;
			for(var index=0; index < arrLength; index++){
				arr += arrayMenuItemId[index] +'-';
				Ext.getCmp(arrayMenuItemId[index]).enable();
			
			}
			
			
		}
		
		function disableMenus(arrayMenuItemId){
			var arrLength = arrayMenuItemId.length;
			
			for(var index=0; index < arrLength; index++){
				Ext.getCmp(arrayMenuItemId[index]).disable();
			
			}
		}
		
		function enableButtons(arrayButtonId){
			var arrLength = arrayButtonId.length;
			
			for(var index=0; index < arrLength; index++){
				Ext.getCmp(arrayButtonId[index]).setDisabled(true); 
			
			}
			
			
		}
		
		function disableButtons(arrayButtonId){
			var arrLength = arrayButtonId.length;
			
			for(var index=0; index < arrLength; index++){
				Ext.getCmp(arrayButtonId[index]).setDisabled(true); 
			
			}
		}
		
//Added by Sachin.

var onCompleteFunctionList = new Array();
var popupWindowList = new Array();

function openMultiplePopup(link, onComplete, heightpx, widthpx, title) {
	onCompleteFunctionList.push(onComplete);
	
	popUpWindow = new Ext.Window({
		title: title,
		height: heightpx,
		width: widthpx,
		x: 10,
		y: 5,
		modal:true,
		resizable:false,
		constrain : true,
		viewConfig: {forceFit: true},
		html:'<iframe src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>'
		
	});
	
	popupWindowList.push(popUpWindow);
	popUpWindow.show();
	
	
}
function closeAndRetunValue(value) {
	if(value!= null && value!= '' && onCompleteFunctionList!= null && onCompleteFunctionList.length>0){
		var listSize = onCompleteFunctionList.length;
		listSize = listSize-1;
		var parentFunction = onCompleteFunctionList[listSize];
		onCompleteFunctionList.remove(parentFunction);
		parentFunction(value);
		 
	}
}

function closeForMultiplePopup() {
	var listSize = popupWindowList.length;
	listSize = listSize-1;
	var popupWindow = popupWindowList[listSize];
	popupWindowList.remove(popupWindow);
	popupWindow.close();
}
		
function urlCheck(str) {
	var v = new RegExp();
        v.compile("^[A-Za-z]+://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\/.=+{}]+$");
        if (!v.test(str)) {
            return false;
        }
        return true;
}     
 
function httpUrlCheck(str) {
	var v = new RegExp();
        v.compile("^[hH][tT][tT][pP][sS]?://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\/.=+{}]+$");
        if (!v.test(str)) {
            return false;
        }
        return true;
}     

function httpIntranetUrlCheck(str) {
	var v = new RegExp();
         v.compile("^[hH][tT][tT][pP][sS]?://[A-Za-z0-9-_]+[A-Za-z0-9-_%&\?\/.=+{}:]+$");
        if (!v.test(str)) {
            return false;
        }
        return true;
}     
		
//End addition by Sachin.

		function detachElemEvent(){   
          	var allInputElems = Ext.DomQuery.select('input');
          	
            for(var i = 0; i < allInputElems.length ; i++){
           
              if (allInputElems[i].detachEvent)
              {
                allInputElems[i].detachEvent("onchange", handleChange);
               
              } 
              else if (allInputElems[i].removeEventListener)
              {
                allInputElems[i].removeEventListener("change", handleChange, false);    
                     
              }
            }
           
			var allTextAreaElems = Ext.DomQuery.select('textarea');
			for(var i = 0; i < allTextAreaElems.length ; i++){
			   if (allTextAreaElems[i].detachEvent)
			   {
			     allTextAreaElems[i].detachEvent("onchange", handleChange);
			   } 
			   else if (allTextAreaElems[i].removeEventListener)
			   {
			     allTextAreaElems[i].removeEventListener("change", handleChange, false);           
			   }
			       
			}
             
			var allButtonElems = Ext.DomQuery.select('input[type="button"]');
			for(var i = 0; i < allButtonElems.length ; i++){
			   if (allButtonElems[i].detachEvent)
			   {
			       allButtonElems[i].detachEvent("onfocus", handleChange);
			   } 
			   else if (allButtonElems[i].removeEventListener)
			   {
			       allButtonElems[i].removeEventListener("focus", handleChange, false);           
			   }        
			 }
		}  
	        
		function handleElemEvent(){   
		   
		   // detaching and removing, before appending the event.
		   detachElemEvent();
		   var allInputElems = Ext.DomQuery.select('input');
		   for(var i = 0; i < allInputElems.length ; i++){
		       if (allInputElems[i].attachEvent)
		       {
		         allInputElems[i].attachEvent("onchange", handleChange);
		        
		       } 
		       else if (allInputElems[i].addEventListener)
		       {
		         allInputElems[i].addEventListener("change", handleChange, false);    
		              
		        }
		   }
		    
		    var allTextAreaElems = Ext.DomQuery.select('textarea');
		    for(var i = 0; i < allTextAreaElems.length ; i++){
		       if (allTextAreaElems[i].attachEvent)
		       {
		         allTextAreaElems[i].attachEvent("onchange", handleChange);
		       } 
		       else if (allTextAreaElems[i].addEventListener)
		       {
		         allTextAreaElems[i].addEventListener("change", handleChange, false);           
		       }
		           
		    }
		    
		    var allButtonElems = Ext.DomQuery.select('input[type="button"]');
		    for(var i = 0; i < allButtonElems.length ; i++){
		       if (allButtonElems[i].attachEvent)
		       {
		           allButtonElems[i].attachEvent("onfocus", handleChange);
		       } 
		       else if (allButtonElems[i].addEventListener)
		       {
		           allButtonElems[i].addEventListener("click", handleChange, false);           
		       }        
		     }
			 
			  var allInputTextElement = Ext.DomQuery.select('input[type="text"]');
			for(var i = 0; i < allInputTextElement.length ; i++){
			   if (allInputTextElement[i].attachEvent)
			   {
				   allInputTextElement[i].attachEvent("onfocus", setLookUpValue);
			   } 
			   else if (allInputTextElement[i].addEventListener)
			   {
				   allInputTextElement[i].addEventListener("focus", setLookUpValue, false);           
			   }        
			}
		 }
		 
		 function setLookUpValue(eventObj){
			 if(eventObj != null){
				var srcElement = eventObj.target;
				if(srcElement != null){
					var srcId = srcElement.id;
					lookupValues[srcId] = srcElement.value;
				}
			}	
		}
		
		function converdisabletoreadonly()
        {
            var elements = document.getElementsByClassName("clsPanelInputTextboxReadOnly");
            var elements1 = document.getElementsByClassName("clsInputTextAreaPgWoSidePanelReadOnly");
		var elements2 = document.getElementsByClassName("clsPanelInputTextAreaReadOnly");
		var elements3 = document.getElementsByClassName("clsIdInputTextBoxReadOnly ");
		for(var i=0;i<elements.length;i++)
            {
                elements[i].disabled=false;
                elements[i].readOnly=true;
            }
		for(var i=0;i<elements1.length;i++)
            {
                elements1[i].disabled=false;
                elements1[i].readOnly=true;
            }
		for(var i=0;i<elements2.length;i++)
            {
                elements2[i].disabled=false;
                elements2[i].readOnly=true;
            }
		for(var i=0;i<elements3.length;i++)
            {
                elements3[i].disabled=false;
                elements3[i].readOnly=true;
            }
		
         }  

//Get SI on-demand		 
		function SIComp(iframesrc)
		{
		     document.getElementById('SIIframeID').style.display = 'none';							
		     document.getElementById('SIIframeID').src= iframesrc;
		     document.getElementById('onDemandSITableId').style.display = 'none';
                     document.getElementById('SIIframeID').style.display ="block";	
		}
		function removeSI(iframesrc){
		        document.getElementById('SIIframeID').src= '';
			document.getElementById('SIIframeID').style.display ="none";
			document.getElementById('onDemandSITableId').style.display = 'block';
			document.getElementById('noSIAvailTD').style.display = 'none';
			document.getElementById('configureSIId').checked =false;
			document.getElementById( "getSIUrl" ).onclick = function() {SIComp(iframesrc);}
			   document.getElementById('linkSIAvailTD').style.display = 'block';
		}


var pickListArray = new Array();
    var pickListData = new Array();
    var pickListComboStore;
    function populatePickListCombo(moduleFieldName){
	  var j = 0;
       for(var i=0 ; i < pickListData.length; i++){
            if(pickListData[i][2].toUpperCase()== moduleFieldName.toUpperCase()){            
               pickListArray[j] = pickListData[i];
               j = j+1;
            }
       } 
     
       pickListComboStore.loadData(pickListArray);	
    }

function createSICookie(cookieName,cookieValue){
	   Ext.util.Cookies.set(cookieName,cookieValue,new Date('01/01/2020'));   
}

function clearSICookie(cookieName){
		Ext.util.Cookies.set(cookieName, 'false',new Date('01/01/2020'));
	}
function displaySI(cookieName, iFrameSrc){
	var cookieValue =Ext.util.Cookies.get(cookieName);
	
	if(cookieValue == 'true'){
		SIComp(iFrameSrc);
		return true;
	}else{
		return false;
	}
			

}	

function FetchUrgencyHTTPJS(inc,cat,cl,im,bi,uin,uii,pn,pi, isPrChanged, prNameVal,contact) {
	/*alert('inc : ' + inc);
	alert('cat : ' + cat);
	alert('cl : ' + cl);
	alert('im : ' + im);
	alert('bi : ' + bi);
	alert('uin : ' + uin);
	alert('uii : ' + uii);
	alert('pn : ' + pn);
	alert('pi : ' + pi);*/
	var prCheck = document.getElementById(isPrChanged); 
	var con = new Ext.data.Connection(),
	incid = inc, dueDateOpt, prioId,
	catid = '';
	if(document.getElementById(cat)!=null && document.getElementById(cat)!='')
		catid = document.getElementById(cat).value;
	
	if(cl != null)
		clid = document.getElementById(cl).value;
	else
		clid = null;
	if(contact != null)
		contactid = document.getElementById(contact).value;
	else
		contactid = null;
	iid = document.getElementById(im).value;
	if(bi != null && document.getElementById(bi)!= null)
		bid = document.getElementById(bi).value;
	else	
		bid = null;
	if(isPrChanged != null){	
		dueDateOpt = document.getElementById(isPrChanged).value;
	}else
		dueDateOpt = null;
	if(pi != null){
		prioId = document.getElementById(pi).value;	
	}else	
		prioId = null;
	con.request({
		url: 'FetchUrgencyData',
		method: 'POST',  
		//params: {"id": incid, "fkcat": catid, "fkcl": clid, "fkb": bid,"fki": iid,  "fetchUrgency":true},
		params: {"id": incid, "fkcat": catid, "fkcl": clid, "fkb": bid,"fkcontact": contactid, "fki": iid,  "fetchUrgency":true},
		callback: function(opts, success, response){
		if (success) {
			var dq = Ext.DomQuery, 
			xml = response.responseXML,
			node = dq.selectNode('urgencyname', xml);
			if(document.getElementById(uin) != null && node.firstChild != null){
				document.getElementById(uin).value = node.firstChild.nodeValue;
			}	
			node = dq.selectNode('urgencyid', xml);
			if(document.getElementById(uii) != null && node.firstChild != null){
				document.getElementById(uii).value = node.firstChild.nodeValue;
			}	
			node = dq.selectNode('priorityname', xml);
			if(document.getElementById(pn) != null && node.firstChild != null){
				document.getElementById(pn).value = node.firstChild.nodeValue;
			}
			if(prNameVal!=null && document.getElementById(prNameVal) != null) {
				if(node.firstChild != null) {
				document.getElementById(prNameVal).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				}else {
					document.getElementById(prNameVal).value = '';
				
				}
			}
				
			node = dq.selectNode('priorityid', xml);
			if(document.getElementById(pi) != null && node.firstChild != null){
				document.getElementById(pi).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				var newPrId = decodeURIComponent(node.firstChild.nodeValue);
				if(prioId!=null && prioId!='' && prioId != newPrId) {
					if(prCheck != null)
						setIsPriorityChanged('true');
				}
				else {	
					if(prCheck != null)
						setIsPriorityChanged('false');
				}
			}	
			//alert(document.getElementById(uii).value);				         
			if(node.firstChild==null && prNameVal!=null) {
				document.getElementById(pi).value = '';
				document.getElementById(prNameVal).value = '';
				document.getElementById(pn).value = '';
			}
			
			return;
			}
	    	}
	});
}
		 
function openCategoryLookup(returnValues){      
	if(returnValues!= null){
		if(returnValues[0] != null ||returnValues[0] !=''){
			if(returnValues[0] == 'OpenCategoryPage'){
			  parent.openPopupWithTitle('CategoryPage?popupId=Category&isPopup=true',openCategoryPage,'',680,670,false);
			}else if( returnValues[0] =='OpenCategoryPageFromRequestDef'){
				parent.openPopupWithTitle('CategoryPage?popupId=Category&isPopup=true&isForReqDef=true',openCategoryPage,'',680,670,false);
			}
			else{
				if(returnValues[0] != null ||returnValues[0] !='' ) {
					var Category__c_id_id;
					if(returnValues[3] != null && returnValues[3] != ''){
						Category__c_id_id=returnValues[3];
					}
					categoryName=returnValues[0];
					setCatData(Category__c_id_id, categoryName,returnValues[4]);
				}
				
				if(returnValues[1] != null && returnValues[1] != '' && returnValues[1] != 'undefined'){
				   setDescriptionNext(returnValues[1]); //Calling Action Function
				}
				if(returnValues[2] != null && returnValues[2] != '' && returnValues[2] != 'undefined'){
					setResolutionNext(returnValues[2]); //Calling Action Function
				}
			}
		}
	}
}
		 
function FetchPriorityHTTPJS(impactId, urgencyId, pn, pi, isPrChanged, prNameVal) {
	var con = new Ext.data.Connection();
	var pId;
	if(pi != null)
		pId = document.getElementById(pi).value;
	var prCheck = document.getElementById(isPrChanged); 
	
	con.request({
		url: 'FetchPriorityPage',
		method: 'POST',  
		params: {"fki": impactId, "fku":urgencyId, "fetchPriority":true},
		callback: function(opts, success, response){
		if (success) {
			var dq = Ext.DomQuery; 
			var xml = response.responseXML;
			var node = dq.selectNode('priorityname', xml);
			if(document.getElementById(pn) != null && node.firstChild != null){
				document.getElementById(pn).value = 
				decodeURIComponent(node.firstChild.nodeValue);
			}else{
				document.getElementById(pn).value = '';
			}
			if(prNameVal!=null && document.getElementById(prNameVal) != null) {
				if(node.firstChild != null) {
				document.getElementById(prNameVal).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				}else {
					document.getElementById(prNameVal).value = '';
				
				}
			}
				
			node = dq.selectNode('priorityid', xml);
			if(document.getElementById(pi) != null && node.firstChild != null){
				document.getElementById(pi).value = 
				decodeURIComponent(node.firstChild.nodeValue);
				var newpi = decodeURIComponent(node.firstChild.nodeValue);
				if(pId!=null && pId!='' && pId != newpi){
					if(prCheck != null)
						setIsPriorityChanged('true');
					
				}else{
					if(prCheck != null)
						setIsPriorityChanged('false');
				}
			}else{
				document.getElementById(pi).value = '';
			}
			if(node.firstChild==null && prNameVal!=null) {
				document.getElementById(pi).value = '';
				document.getElementById(prNameVal).value = '';
				document.getElementById(pn).value = '';
			}
				return;
			}
		}
	});
}

function activateWindow(){   
		if(window.parent.activateWindow != undefined){
		if(activeAllWindowFlag==true)
			window.parent.activateWindow(getWID());       
		}
		activeAllWindowFlag=true;
}
function callFetchUrgencyHTTPJS(clientId, catId, clientUrgency, catUrgency){
			if(clientId == '' && catId == ''){
				return false;
			}else if(clientId == '' && catId != '' && catUrgency != ''){
				return true;
			}else if(clientId != '' && catId == '' && clientUrgency != ''){
				return true;
			}else if(clientId != '' && catId != ''){
				if(catUrgency != '' || clientUrgency != '')
					return true;
				else 
					return false; 	
			}		
			return false;
		}
function showDataCommon(event,onCompleteFunction,whereClause,windownameflag){
	if(isAutocomplete){
		return ; 
	}	
	if(taboutFlag!=true){
		if(typeof(onCompleteFunction)!='undefined' && (typeof(whereClause)!='undefined' && whereClause != null)){
			if(typeof(windownameflag) != 'undefined' && windownameflag != null){
				 
				showalldata(event,onCompleteFunction,whereClause,windownameflag);
			}else{
				showalldata(event,onCompleteFunction,whereClause);
			}   
		}else if(typeof(onCompleteFunction)!='undefined' && (typeof(whereClause) =='undefined' || whereClause == null)){
			showalldata(event,onCompleteFunction);
		}                
		else{
			showalldata(event);
		}               
	}else{
		if(typeof(onCompleteFunction)!='undefined' && onCompleteFunction != ''  && onCompleteFunction != null){
			onCompleteFunction();
		}
	}
}
/* Code for Text Editor*/
Ext.Container.prototype.bufferResize = false;
function viewTextEditor(obj,label,length,ok,cancel,readOnlyMode){
  var areaId;
		if(obj.parentNode.previousSibling.previousSibling!=null )
		{
			areaId=obj.parentNode.previousSibling.previousSibling.childNodes[1].childNodes[2].id;
		}
		else
		{
		   areaId=obj.parentNode.previousSibling.childNodes[0].childNodes[1].id;
		}
	showTextEditor(Ext.isIE ? obj.parentNode.previousSibling.childNodes[0].childNodes[1].id : areaId ,label, length,ok ,cancel);
	//added to show textEditor in readOnly mode
	if(readOnlyMode!=null && readOnlyMode!='undefined' && readOnlyMode){ 
		Ext.getCmp('formTextId').el.dom.setAttribute('readOnly', true);	
		Ext.getCmp('formTextId').addClass('disabledTextEditor');
		Ext.getCmp('formTextId').blur();	//added for removing focus in IE
	}																
}	

function showTextEditor(textAreaId, WinTitle, txtSize, saveLabel, cancelLabel, ht, wd, okBtnHandler) {
	if(ht == null || ht == 'undefined')
		ht = 450;
	if(wd == null || wd == 'undefined')
		wd = 580;
    var form = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 55,
        layout: {
            type: 'vbox',
            align: 'stretch'  // Child items are stretched to full width
        },
        defaults: {
            xtype: 'textfield'
        },
        items: [ {
            xtype: 'textarea',
            id:'formTextId',
            fieldLabel: 'Message text',
            hideLabel: true,
            border:false,
			enableKeyEvents:true,
            name: 'msg',
            flex: 1 ,
			listeners:{
			 'keyup':function(txt,e){
			    	var txtVal = txt.getValue();
					if(txtVal.length > txtSize){
					   txt.setValue(txtVal.substr(0,txtSize));
					}
			 }
			}
        }]
    });	
    var window = new Ext.Window({
        title: WinTitle,
        id:'windowId',
        width: wd,
        height: ht,
        minWidth: 300,
        minHeight: 200,
        layout: 'fit',
        modal:true,
        plain: true,
        cls:'TextEditorWindowCls',
        buttonAlign: 'left',
        items: form,
		defaultButton:'formTextId',
        buttons: [{
            text: saveLabel,
			width: 60,
            cls:'windowBtnCls',
            handler:function(){
			if(textAreaId != null && textAreaId != 'undefined'){
				document.getElementById(textAreaId).focus();
                document.getElementById(textAreaId).value = Ext.getCmp('formTextId').getValue();                
				if(typeof(okBtnHandler)!='undefined' && okBtnHandler != ''  && okBtnHandler != null && typeof(okBtnHandler) == 'function')
				{
					okBtnHandler();
				}
			}else{
				if(approvalComments != null && approvalComments != 'undefined'){
					var comments = Ext.getCmp('formTextId').getValue();
					approvalComments(comments, okBtnHandler);
				}
			}			
                window.close();
            }
        },{
            text: cancelLabel,
			width: 60,
            cls:'windowBtnCls',
            handler:function(){
              window.close();
            }
        }]
    });
    window.show();
	if(textAreaId != null && textAreaId != 'undefined'){
		Ext.getCmp('formTextId').focus();
		Ext.getCmp('formTextId').setValue(document.getElementById(textAreaId).value);
	}
}
 function validateLength(txtId, ln){
   var txtVal = document.getElementById(txtId).value;
   if(txtVal.length > ln){
		document.getElementById(txtId).value = txtVal.substr(0,ln);
   }
 
 }
 
 function waitbox(timeout){ 
	if(parseInt(timeout)>0) setTimeout("waitMsg.hide()", timeout);
	waitMsg = new Ext.Window({ 
		height:100, 
		width:200, 
		resizable:false, 
		closable : false, 
		header:false,
		frame:false, 
		modal:true,
		shadow :false, 
		items:[{ 
			xtype:'panel', 
			height:100, 
			width:200, 
			bodyStyle:'background-color:transparent;border:none;', 
			html: '<div align="center"><img src="' +  tabOutImg +  '"/></div>' 
		}] 
	}); 
	waitMsg.show();
}

 function escSpeChars(speCharStr){
	speCharStr = replaceAll(speCharStr,'\\','�');
	speCharStr = replaceAll(speCharStr,'�','\\');
	speCharStr = replaceAll(speCharStr,'?','�');
	speCharStr = replaceAll(speCharStr,'�','\\?');
	speCharStr = replaceAll(speCharStr,'^','�');
	speCharStr = replaceAll(speCharStr,'�','\\^');
	speCharStr = replaceAll(speCharStr,'$','�');
	speCharStr = replaceAll(speCharStr,'�','\\$');
	speCharStr = replaceAll(speCharStr,'(','�');
	speCharStr = replaceAll(speCharStr,'�','\\(');
	speCharStr = replaceAll(speCharStr,')','�');
	speCharStr = replaceAll(speCharStr,'�','\\)');
	speCharStr = replaceAll(speCharStr,'[','�');
	speCharStr = replaceAll(speCharStr,'�','\\[');
	speCharStr = replaceAll(speCharStr,']','�');
	speCharStr = replaceAll(speCharStr,'�','\\]');
	speCharStr = replaceAll(speCharStr,'{','�');
	speCharStr = replaceAll(speCharStr,'�','\\}');
	speCharStr = replaceAll(speCharStr,'*','�');
	speCharStr = replaceAll(speCharStr,'�','\\*');
	speCharStr = replaceAll(speCharStr,'+','�');
	speCharStr = replaceAll(speCharStr,'�','\\+');
	speCharStr = replaceAll(speCharStr,'|','�');
	speCharStr = replaceAll(speCharStr,'�','\\|');
	return speCharStr; 
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
 
/*End of code for Text editor*/



		 /*
     		END
     	*/

		
function isBrowserWindowMaximized()
{
 
	 if(Ext.isIE){
		if (screen.width -window.parent.document.body.clientWidth == 4)
		{
			return true;
		}
	 }else if(Ext.isSafari){
		if (screen.width -window.parent.document.body.clientWidth == 0)
		{
			return true;
		}
	 }else{
	   if (screen.width - window.outerWidth == -8)
	   {
			return true;
	   }
	 
	 }
		return false;
}
// Form Customization lookup button related changes - Start
var inputHTMLElement;
function openLookupPopup(obj,moduleIdName, moduleName,textId, filterParams,pageName){
	if(pageName == null || typeof(pageName) == 'undefined' || pageName == ''){
		pageName = 'SearchPage';
    }
	if(moduleName == 'Incident__c' && moduleIdName == 'FKBMC_BaseElement__c' && (textId == null  || typeof(textId) == 'undefined' || textId == '')){
		if(pageName == 'SearchPage' ){ // From main app
		var clientIdComp = document.getElementById(IncidentPageComp.ComponentVars.UserID);
		filterParams = 'filterObjectId='+ getUserID() + '&isFilterObject=true&parentName=Incident__c&isRadioChecked=false&accountId='+getAccountID()+'&incidentId='+getIncidentID()+'&incCiId='+getCIelemID()+'&incServiceId='+getServiceElemID()+'&selectedCIFilter='+LinkedToClient;
		}else{
			filterParams = 'filterObjectId='+ filterParams + '&isFilterObject=true';
		}
		textId = 'BMC_BaseElement__c_id_name';
	}
   var node = obj.previousSibling.previousSibling;
   
   if( typeof(textId) != 'undefined' && textId!=null && textId!='' && textId.indexOf('Broadcasts__c_id_name') != -1){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&moduleName='+moduleName,setBroadcastNextJS);
	}else if(textId == 'BMC_BaseElement__c_id_name') {
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=BMC_BaseElement&moduleName='+moduleName+'&isFilterObject=true&'+filterParams,null); 
	}else if(textId == 'BMC_BusinessService__c_id_instance_name__c' && moduleName == 'Incident__c'){
		if(pageName == 'SearchPage' ){ // From main app
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=BMC_BusinessService&moduleName='+moduleName+'&isFilterObject=true&filterClause='+filterParams+'&additional_columns=fkbmc_baseelement__c,instance_name__c',setServiceRelatedFields); 
		}else{ // From SS
			openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=BMC_BusinessService&moduleName='+moduleName+'&isFilterObject=true&ssFilterClause='+filterParams,null); 	
		}
	}else if(textId == 'BMC_BusinessService__c_id_instance_name__c__xx_1'  && moduleName == 'Incident__c'){
		if(pageName == 'SearchPage' ){ // From main app
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=BMC_BusinessService&moduleName='+moduleName+'&isFilterObject=true&filterClause='+filterParams+'&additional_columns=fkbmc_baseelement__c,instance_name__c',setServiceOfferingRelatedValues); 
		}else{
			openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=BMC_BusinessService&moduleName='+moduleName+'&isFilterObject=true&ssFilterClause='+filterParams,null); 
		}
	}else if(textId == 'SRM_RequestDefinition__c_id_servicerequesttitle__c' && moduleName == 'Incident__c'){
		var selectedCatId = document.getElementById(IncidentPageComp.ComponentVars.CategoryID).value;
		var selectedCatName = document.getElementById(IncidentPageComp.ComponentVars.CategoryIDName).value;
		var selectedClientId = document.getElementById(IncidentPageComp.ComponentVars.UserID).value;
        if(selectedCatName != null && selectedCatName !=''){
			openPopup('SearchPage?isLookup=true&popupId=SRM_RequestDefinition&moduleId='+moduleIdName+'&moduleName='+moduleName+'&clientIdforSrm='+selectedClientId+'&catIdForSrd='+selectedCatId,setSelectedSRD);
		}else{
			openPopup('SearchPage?isLookup=true&popupId=SRM_RequestDefinition&moduleId='+moduleIdName+'&moduleName='+moduleName+'&clientIdforSrm='+selectedClientId,setSelectedSRD);
		}
	}// Staff and Queue Assignment US
	else if(moduleIdName == 'FKOpenBy__c' && moduleName == 'Incident__c' ){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&filterClause='+escape("IsStaffUser__c=true")+'&moduleName='+moduleName,null); 		
	}else if(moduleIdName == 'FKStaff__c' && moduleName == 'Change_Request__c' ){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&filterClause='+escape("IsStaffUser__c=true")+'&moduleName='+moduleName,null); 
	}else if(moduleIdName == 'FKStaff__c' && moduleName == 'Problem__c' ){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&filterClause='+escape("IsStaffUser__c=true")+'&moduleName='+moduleName,null); 
	}else if(moduleIdName == 'FKOpenBy__c' && moduleName == 'Task__c' ){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&filterClause='+escape("IsStaffUser__c=true")+'&moduleName='+moduleName,null); 
	}
	else{
   		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&moduleName='+moduleName,null); // will open seacrhpage with correct popUpId
	}	
   setPopUpValueID(node.id);
}
function openLookupPopup1(obj,moduleIdName, moduleName,textId, filterParams,pageName){
   var node = obj.previousSibling.previousSibling;
  
   if(pageName == null || typeof(pageName) == 'undefined' || pageName == ''){
		pageName = 'SearchPage';
   }
   if(textId == 'Broadcasts__c_id_name'){
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=null&moduleName='+moduleName,setBroadcastNext);
	}else if(textId == 'BMC_BaseElement__c_id_name') {
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=BMC_BaseElement&moduleName='+moduleName+'&isFilterObject=true&'+filterParams,null); 
	}else if(textId == 'BMC_BusinessService__c_id_instance_name__c') {
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=BMC_BusinessService&moduleName='+moduleName+'&isFilterObject=true&'+filterParams,null); 
	}else if((moduleName.toUpperCase() == 'BMC_BUSINESSSERVICE__C') && (moduleIdName.toUpperCase() == 'SERVICE_PROVIDER__C')){
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=null&moduleName='+moduleName+'&SPFlag=true',null); 
	}else if((moduleName.toUpperCase() == 'BMC_BUSINESSSERVICE__C') && (moduleIdName.toUpperCase() == 'VENDOR__C')){
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=null&moduleName='+moduleName+'&VENDORFlag=true',null); 
	}else if((moduleName.toUpperCase() == 'BMC_BUSINESSSERVICE__C') && (moduleIdName.toUpperCase() == 'SERVICE_OWNER__C')){
		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&filterClause=IsStaffUser__c=true&popupId=null&moduleName='+moduleName,null); 
	}else if(moduleName.toUpperCase() == 'SERVICELEVELAGREEMENT__C' && (moduleIdName.toUpperCase()!='FKAGREEMENTOWNER__C' ) && (moduleIdName.toUpperCase()!='FKSUPPORTHOURS__C')){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&popupId=null&moduleName='+moduleName,null); 
    }else if(moduleName.toUpperCase() == 'SERVICELEVELAGREEMENT__C' && (moduleIdName.toUpperCase()=='FKAGREEMENTOWNER__C' )){
		openPopup(pageName + '?moduleId='+moduleIdName+'&isLookup=true&filterClause=IsStaffUser__c=true&popupId=null&moduleName='+moduleName,null);
	}else if(moduleName.toUpperCase() == 'SERVICELEVELAGREEMENT__C' && (moduleIdName.toUpperCase()=='FKSUPPORTHOURS__C')){
	 openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=null&&useSOQLForSearch=true&moduleName='+moduleName,null); 
	}else
   		openPopup(pageName + '?moduleId='+moduleIdName+'&InstanceID='+BE_InstanceID+'&isLookup=true&popupId=null&moduleName='+moduleName,null); // will open seacrhpage with correct popUpId
   setPopUpValueID(node.id);
}
function setPopUpValue(recordId,recordName){
   if(recordId!= null && recordId != '' && recordId !='undefined'){
		if(inputHTMLElement!= null && inputHTMLElement!= '' && inputHTMLElement !='undefined'){
		 	inputHTMLElement.value=recordId
		 	inputHTMLElement.previousSibling.value = recordId;
		 	inputHTMLElement.previousSibling.previousSibling.previousSibling.value = htmlDecode(recordName);
		}
	}
}
function setPopUpValueID(elementId){
   if(elementId!= null && elementId!= ''){
		 inputHTMLElement=document.getElementById(elementId);
	}
} 
// Form Customization lookup button related changes - End

function checkCustomPage(){
var customPageDetailObj={'popUpWindowClassName':'','isFrame':true};
if(typeof isCustomPage != 'undefined' || typeof window.parent.isCustomPage != 'undefined'){
	 customPageDetailObj={'popUpWindowClassName':'popUpWindowClass','isFrame':false};
	}
	return customPageDetailObj;
}
function setDatePickerPosition(objType,event){
    if(objType== 'date' || objType == 'datetime' ){
    var datePickerObj =  document.getElementById('datePicker');
	if(datePickerObj !=null && typeof datePickerObj != 'undefined'){
     datePickerObj.style.top=(event.clientY+10)+'px';
	 datePickerObj.style.left=event.clientX+'px';
	}
   }
}
function setTooltipOnWindowClose(winId,titleText){
	var tempWindow=Ext.getCmp(winId);
	new Ext.ToolTip({
		target: winId.tools['close'],
				trackMouse: true,
				anchor: 'top',
				anchorOffset:10,
				html:titleText							  
	});
}
 var openInVar = '';
 var customActionJsonString='';
 var urlStringVar='';
 var custionActionObj = '';
function customActionHandler(obj){
 	openInVar = obj.openIn;
	custionActionObj = obj;
 	getCustomActionURL(obj.id);
}
function openUrl(){
	if(openInVar.indexOf('Remedyforce') != -1){
		window.parent.parent.addNewTab(custionActionObj.id,customActionHeaderLabel,"NavigatorPage?title=" +custionActionObj.encodedText+"&isCustomActionLink=true&target=" + urlStringVar);	
	}else if(openInVar.toLowerCase().indexOf('window') != -1){
	    var windowFeatures= "resizable=1,scrollbars=1,fullscreen=1,toolbar=1,menubar=1,status=1,location=1";
       	window.open(urlStringVar,'',windowFeatures);
 	}else{ 
 		window.open(urlStringVar);
	} 	
}
function enableCustomActionJS(moduleId){
       	var caArray = customActionJsonString;
		if(moduleId != null && moduleId != "" && moduleId != "null" && caArray != null && typeof(caArray) !='undefined'){
			for(ind=0;ind < caArray.length;ind++){
				Ext.getCmp(caArray[ind].id).setDisabled(false);
			}
		}
}
function resetReferenceFields(obj){
	if(obj != null && typeof(obj) != 'undefined'){
		if(obj.value == null || obj.value == ''){
			var referenceFieldIdele= obj.nextSibling.nextSibling;
			referenceFieldIdele.value = ''; 
			referenceFieldIdele.nextSibling.nextSibling.previousSibling.value = referenceFieldIdele.value;
			obj.previousSibling.previousSibling.value = '';
		}
	}
}
function checkLoseChanges(prevNextBtnHandler){
Ext.Msg.show({
						title:labelcloseWindow1,
						msg: labelcloseWindowLabel1,
						buttons: Ext.Msg.YESNO,
						fn:  function(btn){
							if (btn == 'yes'){							
								 if(document.getElementById('nextId').disabled!=true || document.getElementById('prevId').disabled!=true)								
								 prevNextBtnHandler();
								return true;
								
							}
						},
						icon: Ext.MessageBox.WARNING
		});
	return false; //always return false

}
function validateSpinnerField(obj,e){
	var val=obj.getValue();
	val=val.toString();
	var newVal = val.substring(0,val.length-1);
	if(val> obj.maxValue){
		obj.setValue(parseInt(newVal));
	}
}
function hideWaitMsg(){
	if(typeof(waitMsg) != 'undefined' && waitMsg != null && waitMsg != ''){
		waitMsg.hide();
	}
}
function fetchCategoryData(sel,divId,field,iKeyCode,module){
        var con = new Ext.data.Connection();
        con.request({
            url: 'apex/ClientDataPage',
            method: 'POST',  
            params: {"startString": field.value, "module": module},
            callback: function(opts, success, response){
	            if (success) {
	             var dq = Ext.DomQuery;
	             var xml = response.responseXML;
	             var node = dq.selectNode('categorydata', xml);
	             if(list != null && node.firstChild != null){
	                 var encodedCategoryData =node.firstChild.nodeValue;
					 encodedCategoryData=String(encodedCategoryData).replace(/\+/g, "%20");
	                 list = eval('('+decodeURIComponent(encodedCategoryData)+')');
					 findAutoCompleteSelectOptions(sel,divId,field,iKeyCode);
					
	             }
	             return;
	            }
            }
        });  
 }   
var PrintBtnHandler =function (button, event){
     var windowFeatures= "resizable=1,scrollbars=1,toolbar=1,menubar=1,status=1,location=1";
     window.open(print_url,'',windowFeatures);
}
var PrintPDFBtnHandler =function (button, event){
     var windowFeatures= "resizable=1,scrollbars=1,toolbar=1,menubar=1,status=1,location=1";
     window.open(print_url_pdf,'',windowFeatures);
} 
function IsNewRecord(recordId){
	if(recordId!=null && recordId!='')
		return false
	else
		return true
}

 function highlightSearchTerms(searchText, highlightStartTag, highlightEndTag)
		{
			searchArray = searchText.split(" ");

		  if (!document.body || typeof(document.body.innerHTML) == "undefined") {
			return false;
		  }
		  var bodyText = document.body.innerHTML;
		  for (var i = 0; i < searchArray.length; i++) {
			if(searchArray[i].trim().length > 0)
			bodyText = doHighlight(bodyText, searchArray[i], highlightStartTag, highlightEndTag);
		  }
		  document.body.innerHTML = bodyText;
		  return true;
		}

 function doHighlight(bodyText, searchTerm, highlightStartTag, highlightEndTag) 
		{
		  // the highlightStartTag and highlightEndTag parameters are optional
		  if ((!highlightStartTag) || (!highlightEndTag)) {
			highlightStartTag = "<font style='color:black;font-weight: bold ; background-color:yellow;'>";
			highlightEndTag = "</font>";
		  } 
		  var newText = "";
		  var i = -1;
		  var lcSearchTerm = searchTerm.toLowerCase();
		  var lcBodyText = bodyText.toLowerCase();
		  while (bodyText.length > 0) {
			i = lcBodyText.indexOf(lcSearchTerm, i+1);
			if (i < 0) {
			  newText += bodyText;
			  bodyText = "";
			} else {
			  if (bodyText.lastIndexOf(">", i) >= bodyText.lastIndexOf("<", i)) {
				if (lcBodyText.lastIndexOf("/script>", i) >= lcBodyText.lastIndexOf("<script", i)) {
				  newText += bodyText.substring(0, i) + highlightStartTag + bodyText.substr(i, searchTerm.length) + highlightEndTag;
				  bodyText = bodyText.substr(i + searchTerm.length);
				  lcBodyText = bodyText.toLowerCase();
				  i = -1;
				}
			  }
			}
		  }
		  return newText;
		}
function decodeSpecialChar(val) {
//follow the sequence of special characters while decode.
  if(val !=null && val!='' && val!=undefined){
	val = val.replace("&gt;", ">", "g");
	val = val.replace("&lt;", "<", "g");
	val = val.replace("&quot;", "\"", "g");
	val = val.replace("&amp;", "&", "g");
  }
  return val;
}

function isIE8CompatibleInIE9()
{
	var isTrue = false;
	if(navigator.userAgent!=null)
	{
		if(navigator.userAgent.indexOf("MSIE 8")>-1){
			if(navigator.userAgent.indexOf("Trident/5")>-1)
			{
				isTrue = true;
			}
		}
	}
	return isTrue;
}

function ConvertUTCtoGMT(value){
	 var months = new Array(13);
     var weekday=new Array(7);    
	
	 months[0]  = "Jan";
	 months[1]  = "Feb";
	 months[2]  = "Mar";
     months[3]  = "Apr";
     months[4]  = "May";
     months[5]  = "Jun";
     months[6]  = "Jul";
     months[7]  = "Aug";
     months[8]  = "Sep";
     months[9]  = "Oct";
     months[10] = "Nov";
     months[11] = "Dec";
    	 
     weekday[0]="Sun";
     weekday[1]="Mon";
     weekday[2]="Tue";
     weekday[3]="Wed";
     weekday[4]="Thu";
     weekday[5]="Fri";
     weekday[6]="Sat";

	 var dateValue    = new Date(value);	 
     var monthname    = months[dateValue.getMonth()];
     var monthDate    = dateValue.getDate();
	 var day          = weekday[dateValue.getDay()];
     var year         = dateValue.getYear();
	 var hour=dateValue.getHours() ;
	 if(hour<=9){ 
	     hour='0'+hour;
	 }
     var minute = dateValue.getMinutes();
	  if(minute<=9){ 
	     minute='0'+minute;
	 }
     var second  =dateValue.getSeconds();
	  if(second<=9){ 
	     second='0'+second;
	 }
	 var GMToffset    = dateValue.getTimezoneOffset()
     var GMTfloor;
     var GMTDiff;
	 if(GMToffset<0){
	       GMTfloor=Math.floor(-GMToffset/60);		  
		   GMTDiff=-GMToffset%60;
	       GMToffset='+'+GMTfloor+GMTDiff+'';
		}
     else{
	       GMTfloor=Math.floor(GMToffset/60);		   
		   GMTDiff=GMToffset%60;
	       GMToffset='-'+GMTfloor+GMTDiff+'';	     
	 }		
			
	 if(year < 2000) { year = year + 1900; }
   
     var dateString = day+' '+ monthname +' '+ monthDate +' '+ year+' ' +hour+':'+minute+':'+second+' GMT'+GMToffset;	
     return dateString;
	
	}
		
function RemoveQueryString(sURL,sStr)
{
	var iIndex = sURL.indexOf('?');
	var sQueryString = sURL.substring(iIndex + 1);
	var shostURL = sURL.substring(0,iIndex);
	var arrQueryString = sQueryString.split('&');
	var sNewQString='';
	for(var i = 0; i < arrQueryString.length; i++)
		{
			if(!(arrQueryString[i].indexOf(sStr)>-1))						
				sNewQString = sNewQString + arrQueryString[i] + '&';
		}

	if(sNewQString != '')
		shostURL = shostURL + '?' + sNewQString.substring(0,sNewQString.length-1);
	
	return shostURL;
}


function openPopupforAC(link, onComplete, iTitle, iHeight, iWidth) {
	var customPageDetailObj =checkCustomPage();	
	  onCompleteFunction = onComplete;
	  acpopUpWindow = new Ext.Window({
		height: iHeight,
		width: iWidth,
		title: iTitle,
		x: 10,
		y: 5,
		modal:true,
		id:'mypopup1',
		resizable:false,
		bodyStyle:'background-color:#FFFFFF;',
		constrain : true,
		viewConfig: {forceFit: true},
		cls:customPageDetailObj['popUpWindowClassName'],
		frame:customPageDetailObj['isFrame'],
		html:'<iframe id="popupWindowFrameId" frameborder="0" src =\"\/apex\/'+link+'\" style=\"width:100%;height:100%;border:none\"/>',
		tools:[     
				
				{
                    id: 'help',
                    qtip: labelTooltipHelp,
					style:'padding-right: 5px;background-color:red;',
                    handler: function() {
						//To call help
                       OpenHelppage('InventorySummary','module','form');
                  }
                },
				{	id: 'maximize',
					style:'padding-right: 5px;background-color:red;',
					qtip: _ServerValues.labelTooltipMaximize,
					handler: function() {
						acpopUpWindow.setWidth(1200);
						acpopUpWindow.tools['maximize'].hide();
						acpopUpWindow.tools['restore'].show();
						acpopUpWindow.tools['restore'].dom.style.display= 'inline'; 
						acpopUpWindow.tools['restore'].dom.qtip = _ServerValues.labelTooltipRestore;
						acpopUpWindow.tools['maximize'].dom.style.display= 'none'; 
						acpopUpWindow.center();
					}
				},
				{
					id: 'restore',
					hidden:true,
					style:'padding-right: 5px;background-color:red;',
					qtip : _ServerValues.labelTooltipRestore,
					handler: function() {
					   acpopUpWindow.setWidth(750);
					   acpopUpWindow.tools['maximize'].show();
					   acpopUpWindow.tools['restore'].hide();
					   acpopUpWindow.tools['maximize'].dom.style.display= 'inline';
					   acpopUpWindow.tools['maximize'].dom.qtip = _ServerValues.labelTooltipMaximize;
					   acpopUpWindow.tools['restore'].dom.style.display= 'none';
					   acpopUpWindow.center();
					   
					}
			    },        
				{
					id: 'close',
					qtip: labelTooltipClose,
					handler: parent.closeWin
                }
            ]
	  });
	  acpopUpWindow.show();		
}
