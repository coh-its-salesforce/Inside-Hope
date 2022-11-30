var functionCalled = true;
var activeWindowFlag=true;
var EF;
var SLTGridClass = '';
var ServiceTargetHelpLink ;
var SLTMenuBarClass = '';
var IsGridEmpty=false;
var viewport;
var queueLabel = '';
var isExecuting=false;
var defaultfocus=true  ;
var priorityArray = new Array();
priorityArray[1]='priority1-16.gif';
priorityArray[2]='priority2-16.gif';
priorityArray[3]='priority3-16.gif';
priorityArray[4]='priority4-16.gif';
priorityArray[5]='priority5-16.gif';
priorityArray[6]='priority6-16.gif';
var isOnlyQueueList=false,
hideQueueMembersGird=true,
selectedCIFilter=null,
FilterObjectId='',
qmGrid,qMembersStr='[]',qmGridHeader,qMemType,qMemName, qMemStore;

document.onclick = activateSerachpageWindow;  
Ext.ns('Ext.ux');
Ext.ux.PanelCollapsedTitle = (function() {
  var rotatedCls = 'x-panel-header-rotated';
  var supportsSVG =
    !!document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
  var patchCollapsedElem = function() {
    var verticalText = ((this.region == 'east') || (this.region == 'west'));
    var containerStyle = 'overflow: visible; padding: 0; border: none; background: none;';
    // For vertical text, and for browsers that support SVG
    // (Firefox, Chrome, Safari 3+, Opera 8+)
    if (verticalText && supportsSVG) {
      this.collapsedHeader = this.ownerCt.layout[this.region].getCollapsedEl().createChild({
        tag: 'div',
        style: 'height: 100%; overflow: hidden;'
      });
      // embed svg code inside this container div
      var SVGNS = 'http://www.w3.org/2000/svg';
      var svg = document.createElementNS(SVGNS, 'svg');
      this.collapsedHeader.dom.appendChild(svg);
      svg.setAttribute('width', '100%');
      svg.setAttribute('height', '100%');
      var textContainer = document.createElementNS(SVGNS, 'text');
      textContainer.setAttribute('x', 6);
      textContainer.setAttribute('y', 1);
      textContainer.setAttribute('transform', 'rotate(90 6 1)');
      textContainer.setAttribute('class', 'x-panel-header ' + rotatedCls);
      svg.appendChild(textContainer);
      this.collapsedHeaderText = document.createTextNode(this.title);
      textContainer.appendChild(this.collapsedHeaderText);
      // set the style to override the unwanted aspects of the x-panel-header class
      // also copy the x-panel-header "color" to "fill", to color the SVG text node
      var color = Ext.fly(textContainer).getStyle('color');
      textContainer.setAttribute('style', containerStyle + ';fill: ' + color + ';');
    // For horizontal text or IE
    } else {
      var titleElemStyle = 'position: relative;';
      if (verticalText) {
        // use writing-mode for vertical text
        titleElemStyle +=
          'white-space: nowrap; writing-mode: tb-rl; top: 1px; left: 3px;';
      } else {
        titleElemStyle += 'top: 2px;';
        // margin-right to ensure no overlap with uncollapse button
        containerStyle += 'padding-left: 4px; margin-right: 18px;';
      };
      this.collapsedHeader = this.ownerCt.layout[this.region].getCollapsedEl().createChild({
        tag: 'div',
        // overrides x-panel-header to remove unwanted aspects
        style: containerStyle,
        cls: 'x-panel-header ' + rotatedCls,
        html: '<span style="'+ titleElemStyle + '">'+this.title+'</span>'
      });
      this.collapsedHeaderText = this.collapsedHeader.first();
    };
    if (this.collapsedIconCls) this.setCollapsedIconClass(this.collapsedIconCls);
  };
  this.init = function(p) {
    if (p.collapsible) {
      var verticalText = ((p.region == 'east') || (p.region == 'west'));
      // update the collapsed header title also
      p.setTitle = Ext.Panel.prototype.setTitle.createSequence(function(t) {
        if (this.rendered && this.collapsedHeaderText) {
          // if the collapsed title element is regular html dom
          if (this.collapsedHeaderText.dom) {
            this.collapsedHeaderText.dom.innerHTML = t;
          // or if this is an SVG text node
          } else if (this.collapsedHeaderText.replaceData) {
            this.collapsedHeaderText.nodeValue = t;
          };
        };
      });
      // update the collapsed icon class also
      p.setCollapsedIconClass = function(cls) {
        var old = this.collapsedIconCls;
        this.collapsedIconCls = cls;
        if(this.rendered && this.collapsedHeader){
          var hd = this.collapsedHeader,
          img = hd.child('img.x-panel-inline-icon');
          // if an icon image is already shown, modify it or remove it
          if(img) {
            if (this.collapsedIconCls) {
              Ext.fly(img).replaceClass(old, this.collapsedIconCls);
            } else {
              // remove img node if the icon class is removed
              Ext.fly(img).remove();
            };
          // otherwise create the img for the icon
          } else if (this.collapsedIconCls) {
            Ext.DomHelper.insertBefore(hd.dom.firstChild, {
              tag:'img', src: Ext.BLANK_IMAGE_URL,
              cls:'x-panel-inline-icon '+this.collapsedIconCls,
              style: verticalText
                ? 'display: block; margin: 1px 2px;'
                : 'margin-top: 2px; margin-right: 4px'
            });
          };
        };
      };
      p.on('render', function() {
        if (this.ownerCt.rendered && this.ownerCt.layout.hasLayout) {
          patchCollapsedElem.call(p);
        } else {
          // the panels container first needs to render/layout its collapsed title bars
          this.ownerCt.on('afterlayout', patchCollapsedElem, p, {single:true});
        };
      }, p);
    }
  };
  return this;
})();

//Added By Niraj for Key Navigation within Auto Refresh Textbox (Menu item)
Ext.menu.MenuNav = Ext.extend(Ext.KeyNav, function(){
    function up(e, m){
        if(!m.tryActivate(m.items.indexOf(m.activeItem)-1, -1)){
            m.tryActivate(m.items.length-1, -1);
        }
    }
    function down(e, m){
        if(!m.tryActivate(m.items.indexOf(m.activeItem)+1, 1)){
            m.tryActivate(0, 1);
        }
    }
    return {
        constructor : function(menu){
		    
            Ext.menu.MenuNav.superclass.constructor.call(this, menu.el);
            this.scope = this.menu = menu;
        },
		
        doRelay : function(e, h){
            var k = e.getKey();
            if(!this.menu.activeItem && e.isNavKeyPress() && k != e.SPACE && k != e.RETURN){
                this.menu.tryActivate(0, 1);
                return false;
            }
            return h.call(this.scope || this, e, this.menu);
        },
        tab: function(e, m) {
            e.stopEvent();
            if (e.shiftKey) {
                up(e, m);
            } else {
                down(e, m);
            }
        },
        up : up,
        down : down,
        right : function(e, m){
            var active = m.activeItem;
            if(active){   
                return true;
                m.activeItem.expandMenu(true);
            }
        },
        left : function(e, m){
            var active = m.activeItem;
            if (active ) {  
                return true;
            }
            m.hide();
            if(m.parentMenu && m.parentMenu.activeItem){
                m.parentMenu.activeItem.activate();
            }
        },
        enter : function(e, m){
            if(m.activeItem){
                e.stopPropagation();
                m.activeItem.onClick(e);
                m.fireEvent('click', this, m.activeItem);
                return true;
            }
        }
    };

}());

	function addtabWithProgressJS(stageHTML, objAutID)
	{
		var test = pageName ;
		var progressBar = stageHTML;
		var objAutoId = objAutID;
		var windowHeader = windowTitle + ' #' + objAutoId;
		var stdLayout=getStandardLayout();
		if(popUpId == 'SYSBRInformation' || popUpId == 'Template' || popUpId=='SSTemplate'){
			if(!stdLayout)
			window.parent.addTab(test +'?id='+objectId+'&columnField='+columnField+'&direction='+direction, objAutoId ,objAutoId);
			else
			window.parent.addTab(test +'?standardLayout=true&id='+objectId+'&columnField='+columnField+'&direction='+direction, objAutoId ,objAutoId);
		}
		else if(popUpId == 'Task'){
			var isCreateable = isUserPermitted('new');
			var isDeletable = isUserPermitted('delete');
			var isUpdateable = isUserPermitted('update');
			window.parent.addTab(test +'?id='+objectId+'&columnField='+columnField+'&direction='+direction+'&isCreateable='+isCreateable+'&isDeletable='+isDeletable+'&isUpdateable='+isUpdateable, '#'+ objAutoId ,'#'+objAutoId);
		}else{
		
			window.parent.addTab(test +'?id='+objectId+'&columnField='+columnField+'&direction='+direction, '#'+ objAutoId ,'#'+objAutoId);
		}
	}
		
    function shState(data, metadata, record, rowIndex, columnIndex, store){
        return ""+data=="true" ? labelOpened : labelClosed;
    }
    function shDefStatus(data, metadata, record, rowIndex, columnIndex, store){
      //  return ""+data=="true" ? "1" : "0";
      /*BY Usha: 15 March*/
        return ""+data=="true" ? labelYes : labelNo ;
    }
	function shBooleanData(data, metadata, record, rowIndex, columnIndex, store){
        return ""+data=="true" ? labelTrue : labelFalse;
    }
    function addToolTip(data, cell, record, rowIndex, columnIndex, store) {
        var tip=''+data;
        cell.attr = 'title="'+data+'"';
        return data;
    }
    function modBrInfo(data, metadata, record, rowIndex, columnIndex, store){
        if(data.toLowerCase()=="brinboundemail__c") data="Mail Listen";
        if(data.indexOf("__c")!=-1)
            data=data.substring(0, data.indexOf("__c"));
        if(data.indexOf("__C")!=-1)
            data=data.substring(0, data.indexOf("__C"));
        return ""+data;
    }
	var deletedIds;
	function getSelectedIds(){
        var conditionString='';
        var m = grid.getSelectionModel().getSelections();
        for(j=0; j < m.length; j++){
           conditionString = conditionString + m[j].get(cols[0])+",";
        }
        //document.getElementById("selectedSOId").value=conditionString;
        if(conditionString != null && conditionString != '')
            conditionString = conditionString.substring(0,conditionString.length-1);
			
		deletedIds = conditionString.split(',');
        return conditionString;
    }
    function validateSelection(){
        return true;
    }
    function shNew(item){ 
	   activeWindowFlag=false;
		setObjId(''); 
	}
	 function activeObj(){
        if(idList != null){
            activeObject(idList);
        }
    }
    function inActiveObj(){
        if(idList != null){
            inActiveObject(idList);
        }
    }
	
	var uq=null;
    var srchUserorQueueHandler = function(item, checked) {
        if(checked){
            uq = item.inputValue;
        }
    };  
	var FilterOnCI =function(item, checked) {
	  if(checked){
            selectedCIFilter = item.inputValue;
			isCIRadioChecked=checked;
      }
	}
    function doApply(){
	    if(selectedCIFilter == labelAll){
			CIRefresh(isCIRadioChecked);
			return;
		}
		var stdVal = getUrlParameter('standardLayout');
		var idVal = getUrlParameter('id');
		var objName = getObjName();
		
		
			
        if(uq!=null){
            var ilu="";
			
			
            if(isLookup)
                ilu="&isLookup="+isLookup;            
			if(isSuggestExpert == 'true' || isSuggestExpert == true){
				if(uq==queueLabel && !firstTime){
						if(typeof(window.parent.setSelectedModuleName) != 'undefined')
							window.parent.setSelectedModuleName('queue');
						
						if(qFor.indexOf('Incident__c') != -1){
							if(stdVal == 'true' || stdVal == true){							
								window.location = '/apex/SearchPage?id='+idVal+'&objName='+objName+'&popupFor=Assignto&standardLayout=true&standardLayoutCategory=true&popupId=Queue&additional_columns=Queue.Name,QueueId&filterObjectId=' + parentCategoryName + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
							}else{
								window.location = '/apex/SearchPage?popupId=Queue&additional_columns=Queue.Name,QueueId&filterObjectId=' + parentCategoryName + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
							}
						}else{
							if(stdVal == 'true' || stdVal == true){	
								window.location = '/apex/SearchPage?id='+idVal+'&objName='+objName+'&popupFor=Assignto&standardLayout=true&standardLayoutCategory=true&popupId=Queue&filterObjectId=' + parentCategoryName + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
							}else{
								window.location = '/apex/SearchPage?popupId=Queue&filterObjectId=' + parentCategoryName + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
							}
						}
				}else{
					if(typeof(window.parent.setSelectedModuleName) != 'undefined')
						window.parent.setSelectedModuleName('staff');
					if(qFor.indexOf('Incident__c') != -1){
						if(stdVal == 'true' || stdVal == true){		
							window.location = '/apex/SearchPage?id='+idVal+'&objName='+objName+'&popupFor=Assignto&standardLayout=true&standardLayoutCategory=true&popupId=SuggestedStaff&isQueurorUser=true&isSuggestExpert=true&additional_columns=FKUser__r.firstname,FKUser__r.lastname,FKUser__r.phone,FKUser__r.extension,FKUser__r.email,FKUser__r.ProfileId,FKUser__r.Profile.Name,QueueName__c,QueueId__c,FKUser__r.Id&categoryId='+parentCategoryName+'&queueFor='+queueFor+'&filterClause='+escape("FKUser__r.IsStaffUser__c%3Dtrue")+ilu;
						}else{
							window.location = '/apex/SearchPage?popupId=SuggestedStaff&isQueurorUser=true&isSuggestExpert=true&additional_columns=FKUser__r.firstname,FKUser__r.lastname,FKUser__r.phone,FKUser__r.extension,FKUser__r.email,FKUser__r.ProfileId,FKUser__r.Profile.Name,QueueName__c,QueueId__c,FKUser__r.Id&categoryId='+parentCategoryName+'&queueFor='+queueFor+'&filterClause='+escape("FKUser__r.IsStaffUser__c%3Dtrue")+ilu;
						}
					}else{
						if(stdVal == 'true' || stdVal == true){	
							window.location = '/apex/SearchPage?id='+idVal+'&objName='+objName+'&popupFor=Assignto&standardLayout=true&standardLayoutCategory=true&popupId=SuggestedStaff&isQueurorUser=true&isSuggestExpert=true&categoryId='+parentCategoryName+'&queueFor='+queueFor+'&filterClause='+escape("FKUser__r.IsStaffUser__c%3Dtrue")+ilu;
						}else{
							window.location = '/apex/SearchPage?popupId=SuggestedStaff&isQueurorUser=true&isSuggestExpert=true&categoryId='+parentCategoryName+'&queueFor='+queueFor+'&filterClause='+escape("FKUser__r.IsStaffUser__c%3Dtrue")+ilu;
						}
					}
				}
			}else{
				if(uq==queueLabel && !firstTime){
					if(stdVal == 'true' || stdVal == true){	
						window.location = '/apex/SearchPage?id='+idVal+'&objName='+objName+'&popupFor=Assignto&standardLayout=true&popupId=Queue&filterObjectId=' +  + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
					}else{
						window.location = '/apex/SearchPage?popupId=Queue&filterObjectId=' +  + '&isSuggestExpert=true&isQueurorUser=true&filterClause='+escape("sobjectType=\'"+qFor + "\'")+'&queueFor='+qFor+ilu;
					}
				}else{
					//alert('In User Else');
					window.location = '/apex/SearchPage?popupId=Client&isQueurorUser=true&queueFor='+queueFor+'&filterClause='+escape("IsStaffUser__c%3Dtrue")+ilu;
				}
			}
            firstTime = false;
            uq=null;
        }else if(selectedCIFilter!=null && pageSource=='BMC_BaseElement'){
		
			if(stdVal == 'true' || stdVal == true){	
				window.location= 'SearchPage?popupId=BMC_BaseElement&isLookup=true&standardLayout=true&filterObjectId='+FilterObjectId+'&isFilterObject=true&parentName=Incident__c&isRadioChecked=true&selectedCIFilter='+selectedCIFilter+'&accountId='+accountId+'&incidentId='+incidentId+'&incCiId='+incCiId+'&incServiceId='+incServiceId+'&moduleId='+moduleId+'&moduleName='+moduleName + '&PrimaryLinkCI=' + isPrimaryCI;
			}else{
				window.location= 'SearchPage?popupId=BMC_BaseElement&isLookup=true&filterObjectId='+FilterObjectId+'&isFilterObject=true&parentName=Incident__c&isRadioChecked=true&selectedCIFilter='+selectedCIFilter+'&accountId='+accountId+'&incidentId='+incidentId+'&incCiId='+incCiId+'&incServiceId='+incServiceId+'&moduleId='+moduleId+'&moduleName='+moduleName + '&PrimaryLinkCI=' + isPrimaryCI;
			}

		}else{
			createCookie();
			pageSearch();
			if(!isLookup){
		      	callCount = 0;
				parseLimit = Ext.util.Cookies.get(cookieName);
				autoRefresh();
			}
			
			
        }
    }
	function getValidData(data){
        if(data==null || data=="")
            return "-";
        return data;
    }
	function getColsIdxForHeader(hdr){
        for(i1=0;i1<colsHdrs.length;i1++){
            if(colsHdrs[i1]==hdr){
                return i1;
                break;
            }
        }
    }
	
	var shMineHandler=function(item, checked) {
        document.getElementById('shMine').value=checked;        
    }
    var srchInaHandler = function(item, checked) {
		//commenting as inactive filters not working for lookups.
        /*if(isLookup=="true" && item.inputValue=="Active"){
            item.checked=true;
            checked=true;
        }*/
        setOptions("inactiveOption", item, checked);
    };
	var srchServiceRequestHandler = function(item, checked) {
		setOptions("incidentOption", item, checked);
    };
	var srchCategoryFilterHandler = function(item, checked) {
		setOptions("categoryOption", item, checked);
    };
    var srchStaHandler = function(item, checked) {
        setOptions("stateOption", item, checked);
    };
                
	var NextBtnHandler = function(button,event) {
    	if( hasNext){
    		doNext();
		}
	};
    
    var PreviousBtnHandler = function(button,event) {if( hasPrevious){ doPrevious();}};
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
    
    function setOptions(txtFld, item, checked){
		if (txtFld == 'categoryOption') {
			if (checked)
				document.getElementById(txtFld).value=item.inputValue;
		}
		else {
			if(checked){
				document.getElementById(txtFld).value=document.getElementById(txtFld).value + item.inputValue + ",";
			}else{
				document.getElementById(txtFld).value=","+document.getElementById(txtFld).value;
				while(document.getElementById(txtFld).value.indexOf(","+item.inputValue+",")!=-1)
					document.getElementById(txtFld).value=document.getElementById(txtFld).value.replace(","+item.inputValue+",", ",");
				while(document.getElementById(txtFld).value.indexOf(",,")!=-1)
					document.getElementById(txtFld).value=document.getElementById(txtFld).value.replace(",,", ",");
			}
		}
    }
	
	    function changeGrouping() {
        //alert('changeGrouping()');
        var combo = Ext.getCmp('groupoptions');
        var newSelect = combo.getValue();
        if(newSelect != selectedfield ){
            //alert('changeGrouping() IN IF, '+newSelect );
            selectedfield = newSelect;
			if(newSelect =='queueid')
			 selectedfield = 'queue_name';  
            for(j=0; cols.length > j;j++){
                {
                    if(cols[j]!= null && cols[j] != '' && cols[j]!='null' && cols[j].match('__r_')!=null)
                        cols[j]=cols[j].replace('__r_','__r.'); 
                    else if(cols[j] == 'Owner_userName')
                        cols[j] = 'Owner.userName';  
                    else if(cols[j].toLowerCase() == 'parent_name')
                         cols[j] = 'parent.name'; 
                    grid.getColumnModel().setColumnHeader(j,colsHdrs[j]); 
                }
            }
            var decodedselectedfield = selectedfield;
            if(decodedselectedfield != null &&  decodedselectedfield != '' &&  decodedselectedfield.match('__r_')!=null ){
                decodedselectedfield = decodedselectedfield.replace('__r_','__r.');  
            }else if(decodedselectedfield == 'Owner_userName'){
                decodedselectedfield = 'Owner.userName';  
            }
            order = 'ASC';
			doGrouping();
			pageRefresh();
        }
    }

    function doGrouping(){
        var grid = Ext.getCmp('maindatagrid');
        grid.store.groupField = selectedfield;
		if(typeof(grid.store.sortInfo) == 'undefined' || grid.store.sortInfo == null)
			grid.store.sortInfo = { field: '', direction: ''};
        grid.store.sortInfo.field = selectedfield;
        grid.store.sortInfo.direction = order;
		columnField=sortColumn;
        if(grid!=null) 
		{
          
			if(selectedfield != null && selectedfield!=''){
				grid.getStore().sortInfo.field = sortColumn;
				grid.getStore().sortInfo.direction = order;
			}else{
				grid.getStore().sortInfo = null;
			}
		}
        grid.store.groupField = selectedfield;
		if(selectedfield == 'queue_name')
		selectedfield = 'queueid';
    }

function extInit(){
    loadingData();
    var nwdate = new Date();
    var nwstart = nwdate.getTime();
    Nwlatency = nwstart - serverendtime;
	
    Ext.override(Ext.data.Store, {
        sortData : function(f, direction){
            direction = direction || 'ASC';
            var st = this.fields.get(f).sortType;
			if(st != null){
            var fn = function(r1, r2){
                var v1 = st(r1.data[f]), v2 = st(r2.data[f]);
				if(typeof(v1.toLowerCase) == 'function'){
					v1 = v1.toLowerCase();
					v2 = v2.toLowerCase();
				}
                return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
            };}
            this.data.sort(direction, fn);
            if(this.snapshot && this.snapshot != this.data){
                this.snapshot.sort(direction, fn);
            }
        }
    });
   /* var serverstart= '{!serverstarttime}';
    var serverend = '{!serverendtime}';*/
    var temp = labelServerTime;
    var servertime = endtime - starttime;
  
    lookupdata = '';
    lookupdata += temp;
	servertime = servertime + vservertime ;
    lookupdata += servertime;
    lookupdata += '<br>';
    lookupdata += labelLatency;
    lookupdata += Nwlatency;
    lookupdata += '<br>';
    document.getElementById('grid').innerHTML='';
    renderMenuBar(); renderGrid(); renderQueueMembers();renderAdvSearch();
    if(document.getElementById('deleteId') != null && typeof document.getElementById('deleteId') != 'undefined'){
		if (popUpId == 'SLT'){
			Ext.getCmp('deleteId').setDisabled(true);
			Ext.getCmp('deleteId').setIconClass('bmcDeleteSLTDisable');		
		} else {
			Ext.getCmp('deleteId').setDisabled(true);
			Ext.getCmp('deleteId').setIconClass('bmcDeleteDisable');				
		}
    }
   	if(document.getElementById('copyId') != null && typeof document.getElementById('copyId') != 'undefined'){
    	Ext.getCmp('copyId').setDisabled(true);
    	Ext.getCmp('copyId').setIconClass('bmcCopyDisable');}
   	
   	if(document.getElementById('btnSRMActions') != null && typeof document.getElementById('btnSRMActions') != 'undefined'){
   		if(isUserPermitted('new')){
   			if (popUpId == 'SRM_RequestDefinition'){
   				Ext.getCmp('btnSRMActions').setDisabled(false);
   				Ext.getCmp('btnSRMActions').setIconClass('bmcAction1');		
   			} 
   	    }else{
   	   		Ext.getCmp('btnSRMActions').setDisabled(true);
   			Ext.getCmp('btnSRMActions').setIconClass('bmcAction');	
   	    }
   		
   	}
   	
    if(Ext.getCmp('txtSrch') != null && defaultfocus)
		Ext.getCmp('txtSrch').focus(true);
	if(typeof(Ext.getCmp('prevId')) != 'undefined')
        Ext.getCmp('prevId').setDisabled(getNextPrevState(true));
    if(typeof(Ext.getCmp('nextId')) != 'undefined')
        Ext.getCmp('nextId').setDisabled(getNextPrevState(false));
	
			Ext.getCmp('waitMsgId').hide()
	
	var nwenddate = new Date();
    var nwend = nwenddate.getTime();
    var pagerender = nwend - nwstart ;
 
  
    lookupdata += labelPageLoad;
    lookupdata += pagerender;
    document.getElementById('lookupdataval').value = lookupdata ; 
	if(resultSet.length==0 && !IsGridEmpty){
	   IsGridEmpty=true;
	   pageRefresh();
	   
    }
	if(isOnlyQueueList == "true" || popUpId == 'Document'){
		Ext.getCmp('btnView').setDisabled(true);
	}
}
   function renderMenuBar(){
   
    Ext.QuickTips.init();
    // This function renders a block of buttons
    var SamplePanel = Ext.extend(Ext.Panel, {
        renderTo: 'grid',
        border: false,
        defaults: {bodyStyle:'padding:0px;margin:0px;zoom:0px;'}
    }); /*, height: 50, autoWidth: true, autoHeight: true*/
	
	//In case of SS Service Grouping, we need only next and previous buttons. So other toolbar options are removed.	
	if (requestType != null && requestType == 'service') {
		for(j=tbarOptions.length-1;j>0;j--) {		
			if (j<=17) 
				tbarOptions.splice(j, 1);
		}
		tbarOptions[0]={xtype: 'tbspacer', height:32};
	}
	
    mnuBar=new SamplePanel({
        border: true,
        bodyStyle:'padding:0px;margin:0px;zoom:0px;',
        cls:'mnuBarCls' ,
        tbar: tbarOptions,
		id:'mnuBarId'
    });
   
    if(getCopyDisabled() && Ext.getCmp("copyId")!=null)
    { 
        Ext.getCmp("copyId").disabled=true;
        Ext.getCmp('copyId').setIconClass('bmcCopyDisable');
    }
	
	if(document.getElementById('GroupByLabelId') != null && document.getElementById('GroupByLabelId') != 'undefined'){
		document.getElementById('GroupByLabelId').title = groupByLabelTooltip;
	}
	
	if(document.getElementById('ShowAllCILabel') != null && document.getElementById('ShowAllCILabel') != 'undefined'){
		document.getElementById('ShowAllCILabel').title = showAllCITooltip;
	}	
	
}
function renderAdvSearch(){
    if(viewport!=null) {
        return;
    }
    viewport = new Ext.Viewport({
		layout:'border',
        cls:'viewportSearchCls',    
        items:[
        {region:'center', margins:'35 0 0 0', layout:'fit',items:[ grid]},
		{id:'queueMemberGrid',region:'south', collapsible: true, collapsed: true, layout:'fit', 
			title:qmGridHeader,
			items:[qmGrid], 
			height:qmGridHeight,
			hidden: hideQueueMembersGird,
			floatable: false,
			cmargins:{
				top: 0,
				right: 0,
				bottom: 0,
				left: 0
			} ,
			plugins: new Ext.ux.collapsedPanelTitlePlugin()
		}]
    });
	var qmR = Ext.getCmp('queueMemberGrid'); 
	qmR.on('expand', function(){
		if(isOnlyQueueList == 'true' || popUpId == "Queue"){
			var sm = grid.getSelectionModel();
			var rec = sm.getSelected();
			if(rec == null || rec == 'undefined' || typeof(rec) == 'undefined'){
				sm.selectFirstRow(); 
			}
		}
    });
}
    
function loadingData(){ 

      var  waitMsg = new Ext.Window({ 
            id:'waitMsgId',
            height:100, 
            width:200, 
            resizable:false, 
            closable : false, 
            header:false,
            frame:false, 
            shadow :false, 
            items:[{ 
				xtype:'panel', 
				height:100, 
				modal:false,
				width:200, 
				bodyStyle:'background-color:transparent;border:none;',     
				html: '<div align="center"><img src="' + getSDEFExtJSResPath() + '/resources/images/default/shared/blue-loading.gif"/></div>'
           }] 
        
     }); 

    waitMsg.show();
}
 function chkForChangeBeforeDelete(){
        var wid;
        var ChangeArr;
        if (popUpId == 'SLT'){
		   wid = window.parent.parent.idArray[selectedId];
		   ChangeArr = window.parent.parent.changeArray[wid];
		} else{
		 wid = window.parent.idArray[selectedId];
		 ChangeArr = window.parent.changeArray[wid];
		}
		
        var  isChanged = false;
    	if (ChangeArr != null && typeof(ChangeArr) != 'undefined' && ChangeArr != -1 ){
					Ext.Msg.show({
						title:labelcloseWindow,
						msg: labelcloseWindowLabel,
						buttons: Ext.Msg.YESNO,
						fn:  function(btn){
							if (btn == 'yes'){
								//w.pendingClose = true;
								deleteObj();
								window.parent.changeArray[wid] = null;
															
							}
						},
						icon: Ext.MessageBox.WARNING
					});
				}else{
				  deleteObj();
				}
    
	}
function afterDelete(){
    window.parent.handleDelet(selectedId);
}

function afterMultiDelete(){
    window.parent.handleMultiDelet(deletedIds);
}

  function showRecord(){
  if(IsServiceTargetPopup()) return ;
  activeWindowFlag=false;
        var rec = grid.getSelectionModel().getSelected();//grid.store.getAt(rowIndex);
		var add_info=rec.get('additional_info__c');
		if(rec!=null){
			setObjId(rec.get(idFld), rec.get(nameFld),add_info);
		}
    }
	

    function setObjIdJS(objId, nameVal, oPopupId, oView,add_info)
	{
		setIdSet();
		//if(window.parent.opener==null) msgbox(objId+":"+nameVal);        
        popUpId = oPopupId;
		
        var view = oView;
        var pageName;
        var tabHeader = "Search";
        var windowHeader = "Search";
			//changes Nakul
		  var stdLayout = getStandardLayout();
		  var popupFor = getPopupFor();
		  var objName = getObjName();
		  // end Changes
		if((view == '') || (view == null)){
			if(idNameForPopUp){
				var returnVal = objId + '' + EF + '' + nameVal;
				window.parent.setPopUpVar(returnVal);
			}else{
			    if(isAssignTo && (!(stdLayout) || stdLayout == null || stdLayout == '')){
					performAssignTo(grid.getSelectionModel().getSelected());
					return;
				}
				window.parent.setPopUpVar(objId,add_info);
				//Changes By Mayuri, Nakul To Include Standerd Layout For Incident FOr CLient and IncidentFOr Category
			    if((stdLayout) && (popupFor=='incidentsforclient' || popupFor=='incidentsforcategory')){ 
					mywindow1=window.open('/'+objId,null,"status=1,height=1000,width=1000,resizable=0");
					//mywindow1=window.open('/'+objId,null,"");
					mywindow1.opener.close();
				}else if((stdLayout) && popupFor=='Assignto'){
					if(popUpId == 'Queue'){
						setAssignedToSuggestedStaffNext(objId,objName);
						//window.opener.assignIncidentTOQueue(objId);
					}else if(popUpId == 'Client'){
						window.opener.setAssignedToStaffNext(objId);
					}else if(popUpId == 'SuggestedStaff'){
						//window.opener.setAssignedToSuggestedStaffNext(objId);
						
						setAssignedToSuggestedStaffNext(objId,objName);
					}
					//window.close();
				}else if((stdLayout) && popupFor=='QueueAssignment'){
					if(popUpId == 'Queue'){
						//setAssignedToSuggestedStaffNext(objId,objName);
						window.opener.queueId = objId;						
						window.opener.setQueueId(objId);						
						window.close();
						//window.opener.assignIncidentTOQueue(objId);
					}else if(popUpId == 'Client'){
						window.opener.staffId = objId;					
						window.opener.setStaffId(objId);
						window.close();
						//window.opener.setAssignedToStaffNext(objId);
					}
				}else if((stdLayout) && popUpId == 'Profile'){			
		
							window.opener.populateProfileNames(nameVal);
							window.close();
				}else if((stdLayout) && popUpId=='Action' && functionCalled == true){
					addToHistory(objId);
				}else if((stdLayout) && popUpId=='BMC_BaseElement' && functionCalled == true){
					var ciId = objId;
					if(tempParentName=="Incident__c")
					{
						if(isPrimaryCI!=null && isPrimaryCI!='' && isPrimaryCI=='true')
							linkPrimaryCIIncident(ciId);
						else
							linkCIIncident(ciId);
						
					}
					if(tempParentName=="Change_Request__c") 
						linkCIChange(objId);
					if(tempParentName=="Problem__c")
						linkCIProblem(objId);
					if(tempParentName=="Task__c")
						linkCITask(objId);  
					if(tempParentName=="Release__c")
						linkCIRelease(objId);
				}else if((stdLayout) && popUpId=='Problem' && tempParentName=="Change_Request__c" && functionCalled == true){                                             
					linkProblemToChange(objId);
				}else if((stdLayout) &&popUpId=='Change' && tempParentName=="Incident__c" && functionCalled == true) {							  
					linkCRtToInc(objId);
				}else if((stdLayout) && popUpId=='Change' && tempParentName=="Problem__c" && functionCalled == true){							  
					linkChangeToProblem(objId);
				}else if((stdLayout) && popUpId=='Incident' && tempParentName=="Change_Request__c" && functionCalled == true){							
					linkIncidentToChange(objId);
				}else if((stdLayout) &&popUpId=='Incident' && tempParentName=="Problem__c" && functionCalled == true) {							  
					linkIncidentToProblem(objId);
				}else if((stdLayout) && popUpId=='Problem' && tempParentName=="Incident__c" && functionCalled == true){
					linkProblemToIncident(objId);
				}else if((stdLayout) && popUpId=='Problem' && tempParentName=="Release__c" && functionCalled == true){
					linkProblemToRelease(objId);
				}else if((stdLayout) && popUpId=='Change' && tempParentName=="Release__c" && functionCalled == true){
					linkChangeToRelease(objId);
				}else if((stdLayout) && popUpId=='Incident' && tempParentName=="Release__c" && functionCalled == true){
					linkIncidentToRelease(objId);
				}else if((stdLayout) && popUpId=='Release' && tempParentName=="Problem__c" && functionCalled == true){
					linkReleaseToProblem(objId);
				}else if((stdLayout) && popUpId=='Release' && tempParentName=="Incident__c" && functionCalled == true){
					linkReleaseToIncident(objId);
				}else if((stdLayout) && popUpId=='Release' && tempParentName=="Change_Request__c" && functionCalled == true){
					linkReleaseToChange(objId);
				}else if((stdLayout) && popUpId=='KnowledgeArticle' && tempParentName=="Change_Request__c" && functionCalled == true){
					linkKnowledgeArticleToChange(objId);
				}
				else if((stdLayout) && popUpId=='KnowledgeArticle' && tempParentName=="Problem__c" && functionCalled == true){
					linkKnowledgeArticleToProblem(objId);
				}
				else if(broadcastLink){
                                        linkBroadcastInc(objId);
                                }
				functionCalled = false;							
				//Change End Mayuri, Nakul
			}
			if(moduleId!= null && moduleId !='')
				 window.parent.setPopUpValue(objId,nameVal);
            window.parent.closePopup();
          
        }else
		{
            var pageName = getPopupDetails(popUpId, 1);
            var tabHeader = getPopupDetails(popUpId, 2);
            var windowHeader = getPopupDetails(popUpId, 3);
            if(objId == '')
            {  
			    if (popUpId == 'SLT')
				{ 
				    SID = getSlaID();
					var newurl=pageName+'?title='+encodeURIComponent(windowHeader)+'&SlaId='+SID;
				  openiframepopup(newurl,500,689, windowHeader);
				 }//Sridhar: Added for Stage Progression
				else if( (popUpId == 'Incident') || (popUpId == 'Task') || ( popUpId == 'Broadcast') )
                {
					if(popUpId == 'Task'){
						var isCreateable = isUserPermitted('new');
						var isDeletable = isUserPermitted('delete');
						var isUpdateable = isUserPermitted('update');
						window.parent.addTab(pageName+'?title='+encodeURIComponent(windowHeader)+'&isCreateable='+isCreateable+'&isDeletable='+isDeletable+'&isUpdateable='+isUpdateable,windowHeader,windowHeader);
					}else{

                    	window.parent.addTab(pageName+'?title='+encodeURIComponent(windowHeader),windowHeader,windowHeader);
					}	
                }
                else
                {
					if(stdLayout){
						window.parent.addTab(pageName+'?standardLayout=true&title='+encodeURIComponent(windowHeader),windowHeader,windowHeader);

					}else{
						window.parent.addTab(pageName+'?title='+encodeURIComponent(windowHeader),windowHeader,windowHeader);
					}
                }
            }else{              
                if( (popUpId == 'Incident') || (popUpId == 'Task') || ( popUpId == 'SYSBRInformation') || (popUpId=='FAQ')  || (popUpId=='SSFAQ') || (popUpId=='Template') || (popUpId=='SSTemplate') || (popUpId=='Change')|| (popUpId=='Problem') || (popUpId == 'ChangeAssessment'))
                {   
                    windowTitle = windowHeader
                    objectId = objId;
                    addtabWithProgressJS('',nameVal);
                }else if((popUpId == 'Broadcast') || (popUpId == 'Client') || ( popUpId == 'StandardDescription')){
					objectId = objId;			    		    
					
					if(stdLayout){
						window.parent.addTab(pageName +'?id='+objectId+'&columnField='+columnField+'&direction='+direction+'&standardLayout=true', windowHeader,windowHeader);
					}else{
						window.parent.addTab(pageName +'?id='+objectId+'&columnField='+columnField+'&direction='+direction, windowHeader,windowHeader);
					}
                }else{
                    objectId = objId;
                      					
                      if (popUpId == 'SLT')
					  {
					    ServiceTargetheading = windowHeader+' - '+ nameVal;			    
					    openiframepopup(pageName +'?id='+objectId+'&columnField='+columnField+'&direction='+direction,500,689,ServiceTargetheading);
					 
					  }else
                     {
					                        	  
		                window.parent.addTab(pageName +'?id='+objectId+'&columnField='+columnField+'&direction='+direction, nameVal,windowHeader);
					  }
					
                }
            }
        }
    }

	function setArrCols(arrCols)
	{
		var j;
	 	for(j=0;j<colsHdrs.length;j++){
			var colWidth=colsWidth[j].substring(colsWidth[j].indexOf('=')+1);
			//alert(j+":"+colsWidth[j]+":"+colWidth);
			if(j==0)//cols[j]==idFld//Hide Id column
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			else if(popUpId == 'SLT' && cols[j].toLowerCase()=='businessdays__c'){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			}else if(cols[j].toLowerCase()=="queueid" ){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			}else if((popUpId == 'Category' || popUpId == 'SSCategory' || popUpId == 'Category__c') && cols[j].toLowerCase()=="fkurgency__c"){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			}else if((popUpId == 'Category' || popUpId == 'SSCategory' || popUpId == 'Category__c') && cols[j].toLowerCase()=="children__c"){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			}else if(popUpId == 'Category' && requestType != null && requestType == 'service' && (cols[j].toLowerCase()=="fkparentcategory__r_name" || cols[j].toLowerCase()=="children__c")){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], width: 10, sortable: false, dataIndex: cols[j], hideable: false, hidden: true};
			}else if(j==1){//cols[j]==nameFld
				if(cols[j].toLowerCase() == 'service_target_title__c'){
					arrCols[j] = {id:cols[j], header: labelTitle, autoWidth:true, width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: addLink};				
				} else {
					arrCols[j] = {id:cols[j], header: colsHdrs[j], autoWidth:true, width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: addLink};					
				}
			}else if(cols[j].toLowerCase()=="queue_name"){
				arrCols[j] = {id:cols[j], header: colsHdrs[j], autoWidth:true, width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: addLink};
			}else if(j==colsHdrs.length-1){//Last column will auto adjust its width irrespective of its given width
				if(popUpId == 'Broadcast' || moduleId == 'FKBroadcast__c'){
				arrCols[j] = {header: colsHdrs[j], autoWidth: false, /*width: parseInt(colWidth),*/ sortable: false, dataIndex: cols[j], renderer: colRenderer,hidden: true};
				}else if(cols[j].toLowerCase()=="additional_info__c"){
			arrCols[j] = {id:cols[j], header: colsHdrs[j], autoWidth:true, width: 10, sortable: false, dataIndex: cols[j],hidden: true};
			}else{
				arrCols[j] = {header: colsHdrs[j], autoWidth: true, /*width: parseInt(colWidth),*/ sortable: false, dataIndex: cols[j], renderer: colRenderer};
			   
				}
				if(IsServiceTargetPopup()){
					arrCols[j].autoWidth=false;
					arrCols[j].width=parseInt(colWidth);
				}
			   
				if(cols[j] == 'priorityDuration__c'){
						durationflag = 1;
					  
				}
			}
			else{
			    if(popUpId == 'Broadcast' || moduleId == 'FKBroadcast__c' && j==colsHdrs.length-2){
				arrCols[j] = {header: colsHdrs[j], autoWidth: true, sortable: false, dataIndex: cols[j], renderer: colRenderer};
				} else if(cols[j].toLowerCase() == 'target_type__c'){
					arrCols[j] = {header: labelType, autoWidth: true, sortable: false, dataIndex: cols[j], renderer: colRenderer};
				}else{
				arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer};
				}
				
			}   
			if(cols[j].toLowerCase()=='defaultstatus__c')
				arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: shDefStatus};
			
			if(colsHdrs[j] == "Order Number"){
				if(cols[j].toLowerCase() == "ordernumber__c"){
					arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer, hidden: true};
					if(isLookup == "true"){
						sortColumn = cols[j];
					}
				}
			}
				
			if(colsHdrs[j] == "FAQ Number")
			{
				if(cols[j].toLowerCase() == "name")
				{
					arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer, hidden: true};           
				}
			}
					
			
			if(cols[j].toLowerCase() == 'agreementtype__c' && isLookup == "true"){
				arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer, hidden: true};           
			}
			if((cols[j].toLowerCase() == 'fkbmc_baseelement__r_name' || cols[j].toLowerCase() == 'fkbmc_baseelement__c') && (popUpId == 'BMC_BusinessService' || moduleId.toLowerCase() == 'fkbusinessservice__c')){
				arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer, hidden: true};           
			}
			if(cols[j].toLowerCase() == 'account_name__c' && popUpId == 'Client'){
				arrCols[j] = {header: colsHdrs[j], width: parseInt(colWidth), sortable: false, dataIndex: cols[j], renderer: colRenderer, hidden:true};           
			}
			
		}
	}
	
		
	function GridSelectionChanged(grd, row, e){
		if(IsServiceTargetPopup()) {
			
		}
	}
	
	function renderGridJS(showBRLst)
	{
		var objList;
		var isActiveList;
		var isSame;
		var firstValue;
	    columnField=sortColumn;
		if(popUpId.toUpperCase() == 'SLT'){
			SLTGridClass = 'SLTGrid';
		} else {
			SLTGridClass = 'CommonGrid';
		}
        if(grid!=null) 
		{
          //**** Checked for first column is not type of textArea ******//
          if(!notSortableFields.match('<<'+sortColumn+'>>')){
            columnField=sortColumn;
            
            if(columnField != null && columnField != '' && columnField !='null' && columnField.match('__r_')!=null){
                columnField=sortColumn.replace('__r_','__r.');
            }else if(popUpId == 'Organization' && columnField.match('_name') != null){
                columnField=sortColumn.replace('_name','.name');
            }else if(columnField == 'Owner_userName'){
                columnField = 'Owner.userName';
			}else if(columnField.toLowerCase() == 'profile_name'){
				columnField = 'profile.name';
			}
            
            direction=order;
          }
          grid.store.loadData(resultSet); 
		  if(typeof(Ext.getCmp('prevId')) != 'undefined')
			Ext.getCmp('prevId').setDisabled(getNextPrevState(true));

			Ext.getCmp('nextId').setDisabled(getNextPrevState(false));  
			return; 
		}
        
        // create the data store
        var store = new Ext.data.GroupingStore({
            reader: new Ext.data.ArrayReader({}, cols),
            data: resultSet,//xg.dummyData,	
		    groupField: ''
        });
       store.loadData(resultSet);
	   
		var has_forcefit = true;
		if(IsServiceTargetPopup()) {
			has_forcefit=false;
		}

        // create the Grid
        grid = new Ext.grid.GridPanel({
            store: store, border: false,
            id: 'maindatagrid', height: 500, columnLines: true,
			cls:SLTGridClass,
            columns: arrCols, stripeRows: true,
            enableHdMenu :false, 
            
            view: new Ext.grid.GroupingView({
                forceFit:has_forcefit, scrollOffset:0,
				emptyText:NoRecordFoundMsg,
                groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? labelItems : labelItem]})'
            }),
            selModel: new Ext.grid.RowSelectionModel({singleSelect : false})
        });
		grid.getSelectionModel().on('selectionchange', GridSelectionChanged);
		grid.getSelectionModel().on('rowselect', function(sm,rowIndex,row){
			if(isOnlyQueueList == "true" || popUpId == "Queue"){
				fetchQMData(row);
				return;
			}
		});
		
		
			
		var imgPath='';
		if(order == 'DESC'){
				imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_descending.gif';
		}else{
				imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_ascending.gif';
		}
		var v = grid.getColumnModel().getColumnHeader(1);
		v  = v + '<img style="width:13px;height:13px" src="'+ imgPath +'"/>'
		grid.getColumnModel().setColumnHeader(1,v); 
        grid.render('grid');
		
        grid.on('rowclick', function(grid, rowIndex, e){
			if(IsServiceTargetPopup()) return ;
			if (popUpId == 'Category'&& typeof(window.parent.selectedCatSingleClk)!= 'undefined' && typeof(window.parent.selectedCatSingleClk)=='function'){
				var rec = grid.store.getAt(rowIndex);
				window.parent.selectedCatSingleClk(grid,rowIndex,rec.get(idFld));
				return;
			}
			var rec = grid.store.getAt(rowIndex);
            var id = rec.get(idFld);
		    var selectedName=rec.get(nameFld);
			
            if(popUpId == 'Action'){
                 checksequence(rec.get(cols[0]));
            }else if(popUpId == 'Status'){
                checkstatussequence(rec.get(cols[0]));
            }else if(isOnlyQueueList == "true" || popUpId == "Queue"){
				return;
			}else {
                if(document.getElementById('deleteId') != null){
					if(isUserPermitted('delete')){
						if (popUpId == 'SLT'){
							Ext.getCmp('deleteId').setDisabled(false);
							Ext.getCmp('deleteId').setIconClass('bmcDeleteSLT');		
						} else {
							Ext.getCmp('deleteId').setDisabled(false);
							Ext.getCmp('deleteId').setIconClass('bmcDelete');                    
						}
	                }
	            }
            }
			
			if(document.getElementById('editId') != null){
				if (popUpId == 'SLT'){
					if(isUserPermitted('edit')){
						Ext.getCmp('editId').setDisabled(false);
						Ext.getCmp('editId').setIconClass('bmcEditSLT');		
					} else {
						Ext.getCmp('editId').setDisabled(true);
						Ext.getCmp('editId').setIconClass('bmcEditSLTDisable');							
					}
				} else {
					Ext.getCmp('editId').setDisabled(false);
					Ext.getCmp('editId').setIconClass('bmcEdit');                    
				}			
			}
			
            selectedId = id;
            if(showBRLst)
			{
                objList = grid.getSelectionModel().getSelections();
                if(objList.length > 1){
                    Ext.getCmp('editId').setDisabled(true);
					if(document.getElementById('copyId') != null && typeof document.getElementById('copyId') != 'undefined'){
						Ext.getCmp('copyId').setDisabled(true);
					}

                } else{
					if(isUserPermitted('copy')){
	                    Ext.getCmp('editId').setDisabled(false);
						if(document.getElementById('copyId') != null && typeof document.getElementById('copyId') != 'undefined'){
							Ext.getCmp('copyId').setDisabled(false);
						}
	                }
                }
                isSame = true;
                idList = '';
                isActiveList = new Array(objList.length);
                firstValue = isActiveList[i];
                for(var i=0 ; i< objList.length ; i++){
                    idList = idList+ objList[i].get(cols[0])+ ',';
                    isActiveList[i] = objList[i].get(cols[index]);
                        if(i == 0){
                            firstValue = isActiveList[i];
                        }
                 }
                for(var i=0 ; i< isActiveList.length ; i++){
                    //firstValue = isActiveList[i];
                    for(var j=0 ; j< isActiveList.length ; j++){
                        if(isActiveList[i] != isActiveList[j]){
                             isSame = false;
                             break;
                        }
                    }
                }
                if(isSame == false){
                    Ext.getCmp('activeId').setDisabled(false);
                    Ext.getCmp('InactiveId').setDisabled(false);
                }else if(isSame == true){
                        if(firstValue == 'true'){
                            Ext.getCmp('activeId').setDisabled(true);
                            Ext.getCmp('InactiveId').setDisabled(false);
                        }else{
                                Ext.getCmp('activeId').setDisabled(false);
                                Ext.getCmp('InactiveId').setDisabled(true);
                            }
                        }
            }else{
                if(document.getElementById('copyId') != null && typeof document.getElementById('copyId') != 'undefined'){
					if(isUserPermitted('copy')){
	                    Ext.getCmp('copyId').setDisabled(false);
	                    Ext.getCmp('copyId').setIconClass('bmcCopy');
					}
                }
            }
			if(isLookup=="true"){
			    if(isAssignTo){
					performAssignTo(rec);
					return;
				}
				var add_info=rec.get('additional_info__c');
			    	
				if(idNameForPopUp){
					var returnVal = id + '' + EF + '' + selectedName;
					window.parent.setPopUpVar(returnVal);
				}else{
					window.parent.setPopUpVar(id,add_info);
				}
				if(moduleId!= null && moduleId !=''){
				 window.parent.setPopUpValue(id,selectedName);
				}
				window.parent.closePopup();
            }else{
                document.getElementById("selectedSOId").value = id;
                grid.getView().focusEl.focus();
            }

        });
        grid.on('rowdblclick', function (grid,rowIndex){
			if(IsServiceTargetPopup()) return ;
			if (popUpId == 'Client'&& typeof(window.parent.populateSelectedUser)!= 'undefined' && typeof(window.parent.populateSelectedUser)=='function'){
				window.parent.populateSelectedUser(grid,rowIndex);
			}
			if (popUpId == 'Category'&& typeof(window.parent.selectedCatDBClk)!= 'undefined' && typeof(window.parent.selectedCatDBClk)=='function'){
				var rec = grid.store.getAt(rowIndex);
				window.parent.selectedCatDBClk(grid,rowIndex,rec.get(idFld));
				return;
			}

            var rec = grid.store.getAt(rowIndex);
            setObjId(rec.get(idFld), rec.get(nameFld));
        });
        grid.on('keypress', function (e){
			if(IsServiceTargetPopup()) return ;

            if ( e.getKey() == e.RETURN || e.getKey() == e.ENTER ) {
                var m = grid.getSelectionModel().getSelections();   
                for(j=0; j < m.length; j++){
                   setObjId(m[j].get(idFld),m[j].get(nameFld));                                   
                }
            }
        });
        grid.on('headerclick', function(grid, columnIndex,e ) { 
			if(!notSortableFields.match(grid.getColumnModel().getColumnHeader(columnIndex))){
                var combo = Ext.getCmp('groupoptions');
                var newSelect = combo.getValue();
                var imgPath = '';
                if(newSelect == null || newSelect == '') {
                    for(j=0; colsHdrs.length > j;j++){
						if(cols[j].toLowerCase() == 'service_target_title__c'){
							colsHdrs[j] = labelTitle;
						} else if(cols[j].toLowerCase() == 'target_type__c'){
							colsHdrs[j] = labelType;
						}
						grid.getColumnModel().setColumnHeader(j,grid.getColumnModel().getColumnHeader(j)); 
                        var imgPathAsc = '<img style="width:13px;height:13px" src="'+getSDFStylesResPath() + '/SDEFimages/arrow_sort_ascending.gif'+'"/>';
						var imgPathDesc = '<img style="width:13px;height:13px" src="'+getSDFStylesResPath() + '/SDEFimages/arrow_sort_descending.gif'+'"/>';
						var columnToSort=grid.getColumnModel().getColumnHeader(columnIndex);
						if(columnToSort!=null && columnToSort!='' && columnToSort.indexOf(imgPathAsc)>=0)
							columnToSort=columnToSort.replace(imgPathAsc,"");
						if(columnToSort!=null && columnToSort!='' && columnToSort.indexOf(imgPathDesc)>=0)
							columnToSort=columnToSort.replace(imgPathDesc,"");
						if(columnToSort==colsHdrs[j] && notSortableFields.match(colsHdrs[j])== null ){
                            if(order == 'DESC'){
                                imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_ascending.gif';
                            }else{
                                imgPath = getSDFStylesResPath() + '/SDEFimages/arrow_sort_descending.gif';
                            }
							var v=colsHdrs[j];
                            v  = v + '<img style="width:13px;height:13px" src="'+ imgPath +'"/>';
                            sortColumn = cols[j];
                            if(cols[j]!= null && cols[j] != '' && cols[j]!='null' && cols[j].match('__r_')!=null)
                                cols[j]=cols[j].replace('__r_','__r.'); 
                            else if(cols[j] == 'Owner_userName')
                                cols[j] = 'Owner.userName';  
                            else if(cols[j].toLowerCase() == 'parent_name')
                                cols[j] = 'parent.name';
							else if(cols[j].toLowerCase() == 'profile_name')
								cols[j] = 'profile.name';
							else if(cols[j] == 'Owner_Name'){
                                cols[j] = 'Owner.Name';          
							}
                            if(order == 'ASC'){
                                order = 'DESC';
                            }else{
                                order = 'ASC';
                            }   
                            grid.getColumnModel().setColumnHeader(columnIndex,v);    
                            //**** Checked for first column is not type of textArea ******//
                            handleColClickWithoutGrp(cols[j],order);
                            columnField=cols[j];
                            direction=order;
							break;
                        }
                    }
                }
            } 
        });
        grid.on('resize', function(grid, rowIndex, e) {
			Ext.getCmp('maindatagrid').removeClass(SLTGridClass);
            if (firstTime || (requestType != null && requestType == 'service')) {
                firstTime = false;
            }else{
				if(isOnlyQueueList != "true" && popUpId != "Queue"){
					handleResize(''+grid.getInnerHeight());
				}
                
            } 
        });
		var noOfCol= grid.getColumnModel().getColumnCount( true);
		   var i=0;
		   while(noOfCol>i){
		    var headerCell=grid.getView().getHeaderCell(i);
			headerCell.id= 'GRID-HD' +i;
			headerCell.firstChild.id ='GRID-HD-INNER-'+i;
		    i++;
		   }
		   var l=0;
			Ext.select('.x-form-trigger').each(function(el){
			  el.dom.id = 'FORM-TRIGGER-BTN-' +l++;
			}); 
    
    }
function activateSerachpageWindow(){  
		if(window.parent.activateWindow != undefined){
		if(activeWindowFlag==true && !isLookup)
			window.parent.activateWindow(getWID());       
		}
		activeWindowFlag=true;
}

var callCount =0;
 function autoRefresh(){
	if(parseLimit!=0 && parseLimit!=null && parseLimit!=''){
		if(parseLimit==1 && callCount!=0){
			defaultfocus = false ;
			pageRefresh();
		 }else{
		   parseLimit = 1;        
		 }
	 callCount = callCount + 1;
	 t=setTimeout("autoRefresh();",Ext.util.Cookies.get(cookieName)*60000);
	}
 }
 
	   
function createCookie(){
	if(document.getElementById('refreshTimeID') != null && typeof(document.getElementById('refreshTimeID')) != 'undefined' && document.getElementById('refreshTimeID').value=='')
		document.getElementById('refreshTimeID').value=0;
	if(document.getElementById('refreshTimeID') != null && typeof(document.getElementById('refreshTimeID')) != 'undefined')
		Ext.util.Cookies.set(cookieName,document.getElementById('refreshTimeID').value,new Date('01/01/2020'));    
}

function addRefreshMenu(filterMenus ,counter, latRefreshedTime ){


	 if(!isLookup ){
	    intervalTime= Ext.util.Cookies.get(cookieName);
	    if(intervalTime =='' || intervalTime == null)
	        intervalTime=DEFAULT_INTERVAL;
	   
	     var temp ={text: refresheveryLabel +' '+ '<input id="refreshTimeID" name="refreshTimeID" value="'+intervalTime+'" class="autoRefreshTextBox" type="text" onkeypress="javascript: return validateText(event);"  maxlength="3" onchange="setTextvalue(this.value);"/>'+' '+ minuteslabel ,style:'cursor:text',hideOnClick:false}; 
	     filterMenus[counter++]='-';
	    
	    filterMenus[counter++]=temp;
	    filterMenus[counter++]={text: refreshedlabel+' '+latRefreshedTime,canActivate:false,hideOnClick:false,style:'cursor:text'};
	 }
 }
 
 function validateText(event){
		var asciiVal;
		if(Ext.isIE) {
			asciiVal = event.keyCode;
		} else {
			asciiVal = event.charCode;
		}
		var pattern=new RegExp("[^0-9\0]");
		if(pattern.test(String.fromCharCode(asciiVal))){
			return false;
		}
		var textObj = document.getElementById("refreshTimeID");
		try{
			 textObj.focus(); 
		}catch(e){}
		return true;
		
}
function setTextvalue(val){
var textObj = document.getElementById("refreshTimeID");
		textObj.value=val;
		try{
			 textObj.focus(); 
		}catch(e){}
}
function renderQueueMembers(){
		
		var qmGridColModel = new Ext.grid.ColumnModel({
    	    header: true,
			columns:[
    	              {dataIndex: 'id', hidden: true},
    	              {dataIndex: 'name', header:qMemName, sortable: true},
					  {dataIndex: 'type', header:qMemType, sortable: true}
					]
		});	
		if(qMemStore == null){
		qMemStore = new Ext.data.SimpleStore({
            fields:['id','name','type'],
			autoLoad:false,
			autoDestroy:true,
			data:qMembersStr
		});
		}
		if(qmGrid == null){
		qmGrid = new Ext.grid.GridPanel({
            store: qMemStore, 
			border: false,
            id: 'qMembersGrid',
			width:650,
			height: 200, 
			columnLines: true,
			cm:qmGridColModel,
			stripeRows: true,
            enableHdMenu :false,
			enableColumnMove: false,  
			viewConfig:{forceFit:true,scrollOffset:0 }
		});
		}
}
function loadQMdata(){
		qMemStore.removeAll(true);
		qMemStore.loadData(qMembersStr); 
		if(Ext.getCmp('queueMemberGrid').collapsed){
			Ext.getCmp('queueMemberGrid').expand();
		}
		qmGrid.getView().refresh();	
		
}
function fetchQMData(row){
	var qName = row.get('queue_name');
	Ext.getCmp('queueMemberGrid').setTitle(qmGridHeader + '  ' + qName);
	if(row != null && row != 'undefined' && typeof(row) != 'undefined'){
		var qId = row.get('queueid');
		loadQueueMembers(qId);
	}
}
function clearQMdata(){
	if(isOnlyQueueList == 'true' || popUpId == "Queue"){
		if(qmGrid != null && qmGrid != 'undefined' && typeof(qmGrid) != 'undefined'){
			qmGrid.store.removeAll(true);
			qmGrid.getView().refresh();
			Ext.getCmp('queueMemberGrid').collapse();
			Ext.getCmp('queueMemberGrid').setTitle(qmGridHeader);
		}
	}
}

function performAssignTo(rec){
	var isOutOfOffice;
	if(popUpId=='Client')
		isOutOfOffice = rec.get('IsOutOfOffice__c');
	if(popUpId=='SuggestedStaff')
		isOutOfOffice = rec.get('FKUser__r_IsOutOfOffice__c');
	var trueLabel = "true";//convertBooleanToYesNo(true);
	var falseLabel = "false";//convertBooleanToYesNo(false);
	var id=rec.get(idFld);
	var add_info=rec.get('additional_info__c');
	if(!isExecuting){
		if(isOutOfOffice==trueLabel){
			 isExecuting = true;
			 Ext.MessageBox.show({
				 msg : outOfOfficeConfirmationMsg,
				 width : 450,
				 buttons : Ext.MessageBox.YESNO,
				 icon : Ext.MessageBox.QUESTION,
				 fn : function(btn) {
					 if(btn == 'yes') {
						window.parent.setPopUpVar(id,add_info);
						window.parent.closePopup();
					 } 
					 isExecuting = false;
				 }
			 }); 
		}
		else if(isOutOfOffice==falseLabel){
			window.parent.setPopUpVar(id,add_info);
			window.parent.closePopup();
		}
	}	
}
