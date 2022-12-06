
//var SDEDateFormat =  "m/d/Y h:i A";
if(typeof(SDEDateFormat)=='undefined' || SDEDateFormat==null ||  SDEDateFormat=='')
{
	this.SDEDateFormat =  "m/d/Y h:i A";
}
Date.useStrict = true;
var dataModifiedFlag = 0;
var cdateFormat = '';
function getDataModifiedFlag(){
	return dataModifiedFlag;
}

function setDataModifiedFlag(){
	dataModifiedFlag = 0;
}

CMDBDatePickerPopup = function(){}
CMDBDatePickerPopup.prototype = {

    dateFormat : SDEDateFormat,
    
    selectHandler : function(dp, date) {
        this.TextField.dom.value = date.format(dp.format);
		var datefieldId =  this.TextField.dom.id;
		if(datefieldId.indexOf("custominputDate") > 0){
			var temp = document.getElementById(datefieldId).value;	
			var cdate = temp.split(' ');
			cdateFormat = cdate[1];
			this.TextField.dom.value = cdate[0];
		}		
		dataModifiedFlag = 1;
	    this.TextField = null;

        dp.hide();
        dp.winHandle.close();
    },

	Show : function(forFielID) {
	    this.TextField = Ext.get(forFielID);
        var dp = new Ext.DatePicker({ startDay: 1, 
                                        listeners: {
                                            select:this.selectHandler.createDelegate(this)
                                            }		  
                                    });
		try{
	        var dateval = Date.parseDate(this.TextField.dom.value, this.dateFormat);
	        dp.setValue(dateval);
		}catch(e)
		{
		}
        var rgn = this.TextField.getRegion();

        var win = new Ext.Window({ 
                            x:rgn.right-180,
                            y:rgn.top-200, 
							cls:'CMDBWindow',
                            animCollapse:true,
                            header:true,
                            modal:true,
                            autoHeight:true,
                            autoWidth:true,
                            layout: 'fit',
		                    frame: false,
		                    closable:false
                        });
                        
	    win.add(dp);
	    dp.winHandle=win;
	    win.show();
	}
}

var _datePicker = new CMDBDatePickerPopup();

function CMDBControl() {
  this.DisplayName = null;
  this.ApiName = null;
  this.DisplayType = null;
  this.UniqueID = null;
  this.Element = null;  
  this.Readonly=false;
  this.Required=false;
  this.IsExpandImage=false;
  this.IsDatePickerImage=false;
  this.IsLabel=false;
  this.Validate=true;
  this.MaxLength=null;
  this.ForControl=null;
}



var __CMDBControlMap;
var __EXPAND_IMG_PREFIX = "EIMG";
var __DATEPICK_IMG_PREFIX = "DPCK";
var __FIELD_LABEL_PREFIX = "FLBL";

function ValidateForm()
{
    Date.useStrict = true;
	var ele = null;
	var ctrl = null;
	var ctrltype=null;
	var submit = true;

	for(var i=0;i<__CMDBControlMap.length;i++)
	{
		ctrl = __CMDBControlMap.item(i);
		ele = ctrl.Element;
		
		if(ctrl.Validate && ctrl.Required && ctrl.Element.value.trim()=='')
		{
			//Ext.Msg.alert(_ServerValues.Error, _ServerValues.requiredAllFieldBRActionPage);
			Ext.Msg.alert('', _ServerValues.requiredAllFieldBRActionPage);
			submit=false;
			
			if(!submit){
				return submit;
			}
		}
		
		if(ctrl.Validate && !ctrl.Readonly && (ctrl.DisplayType=="CURRENCY" || ctrl.DisplayType=="PERCENT" || ctrl.DisplayType=="DOUBLE" || ctrl.DisplayType=="NUMBER" || ctrl.DisplayType=="PHONE"))
		{
		
			if(ctrl.Element.value.trim()!=''){
				var RegExPatternNumeric = /^[-]?\d*\.?\d*$/ ;
				if (!(ctrl.Element.value.match(RegExPatternNumeric))) {
					submit=false;
					if(ctrl.DisplayType == "DOUBLE"){
						ctrl.DisplayType = "NUMBER";
					}
					Ext.Msg.alert('', __CMDBControlMap.item(__FIELD_LABEL_PREFIX+ctrl.UniqueID).Element.innerHTML+' '+_ServerValues.numericValueRequired);
				}
				
				if(ctrl.DisplayType=="PHONE"){
					var RegExPatternNumeric = /^[-]?\d*?\d*$/ ;
					if (!(ctrl.Element.value.match(RegExPatternNumeric))) {
						submit=false;
						Ext.Msg.alert('', _ServerValues.CorrectValueErrorMsg+' '+__CMDBControlMap.item(__FIELD_LABEL_PREFIX+ctrl.UniqueID).Element.innerHTML);
					}			
				}
				
				if(!submit){
					return submit;			
				}
			}
		}
		
		//Commented the Date and DateTime validation code as it is handled in controller
		/* if(ctrl.Validate && !ctrl.Readonly && ctrl.DisplayType=="DATE"){
			if(ctrl.Element.value.trim()!='')
			{	
				//var cDate = ctrl.Element.value.trim();
				//alert('dataModifiedFlag:'+dataModifiedFlag);
				var cDate = ctrl.Element.value.trim();
				cDate = cDate + ' '+cdateFormat;
				var dateval = Date.parseDate(cDate, SDEDateFormat);
				if(typeof(dateval)=='undefined' || dateval==null)
				{
					var ctrlLabel = __CMDBControlMap.item(__FIELD_LABEL_PREFIX+ctrl.UniqueID).Element.innerHTML;
					Ext.Msg.alert('',  _ServerValues.Correct_Date +' '+ctrlLabel);
					submit=false;
				}

				if(!submit){				
					return submit;					
				} 					
			}			
		} */

		/*if(ctrl.Validate && !ctrl.Readonly && ctrl.DisplayType=="DATETIME")
		{
			try
			{
				if(ctrl.Element.value.trim()!='')
				{
					var dateval = Date.parseDate(ctrl.Element.value.trim(), SDEDateFormat);
					
					var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
					
					if (!(ctrl.Element.value.match(RegExPattern))) {
							submit=false;
					} 
					
					if(typeof(dateval)=='undefined' || dateval==null)
					{
						submit=false;
					}
				}
			}
			catch(e)
			{
				submit=false;
			}

			if(!submit)
			{
				var ctrlLabel = __CMDBControlMap.item(__FIELD_LABEL_PREFIX+ctrl.UniqueID).Element.innerHTML;
				//Ext.Msg.alert(_ServerValues.Error, _ServerValues.Correct_Date + ctrlLabel);
				Ext.Msg.alert('', _ServerValues.Correct_Date +' '+ctrlLabel);
				return submit;
			} 
		} */
	}
	
	return submit;
}

function LimitText(limitField, limitNum)
{
    if (limitField.value.length > limitNum) {
        limitField.value = limitField.value.substring(0, limitNum);
    }
}

function ShowStatusMessage()
{
	if(_ServerValues.savestatus == true)
	{
		//Ext.MessageBox.alert(_ServerValues.Status, _ServerValues.SuccessSaveMsg);
		Ext.MessageBox.alert('',_ServerValues.SuccessSaveMsg);
	}
	else if(_ServerValues.savestatusMessage != null && _ServerValues.savestatusMessage != '')
	{
		//Ext.MessageBox.alert(_ServerValues.Status,  _ServerValues.savestatusMessage);
		Ext.MessageBox.alert('',_ServerValues.savestatusMessage);
	}
}

function createControlMap()
{
    __CMDBControlMap = new Ext.util.MixedCollection();
	var elements = document.getElementsByTagName("*");
	var ele=null;
	var cname = '';
	var fieldString ='';
	var fieldArr = null;

	for(var i=0;i<elements.length;i++)
	{
		fieldString ='';
		fieldArr = null;
		ele = elements[i];
		cname = ele.className;
		if(cname.indexOf("CMDBControl")>=0)
		{ 
			fieldString=cname.substring(
							cname.indexOf("[(")+2 , 
							cname.lastIndexOf(")]") );
			fieldArr = fieldString.split(":")
			
			var ctrl = new CMDBControl();
			ctrl.Element = ele;
			ctrl.UniqueID=null;
			
			for(var k=0;k<fieldArr.length;k++)
			{
				var nv=fieldArr[k].split("=");
				switch(nv[0])
				{
					case "ApiFieldName":
									ctrl.ApiName=nv[1];
									break;
					case "DisplayType":
									ctrl.DisplayType=nv[1];
									break;
					case "UniqueID":
									ctrl.UniqueID=nv[1];
									break;
					case "GroupName":
									ctrl.GroupName=nv[1];
									break;
					case "Readonly":
									ctrl.Readonly=(nv[1]=="true");
									break;
					case "MaxLength":
									try {
										ctrl.MaxLength=parseInt(nv[1]);
									}catch(e){}
									if(ctrl.MaxLength<=0) ctrl.MaxLength=null;
									break;
					case "Required":
									ctrl.Required=(nv[1]=="true");
									break;
					default:
									break;
				}
			}

			if(ctrl.UniqueID==null || ctrl.UniqueID.trim()=='') 
			{
				ctrl.UniqueID=ele.id; // If the unique ID was not provided, take the element's ID
			}
			

			if(cname.indexOf("CMDB_ExpandImage") >= 0)
			{
				ctrl.IsExpandImage = true;
				ctrl.ForControl=__CMDBControlMap.item(ctrl.UniqueID);
				ctrl.UniqueID=__EXPAND_IMG_PREFIX+ctrl.UniqueID;
				ctrl.Validate=false;
			}			
			
			if(cname.indexOf("CMDB_DatePickerImage") >= 0)
			{
				ctrl.IsDatePickerImage = true;
				ctrl.ForControl=__CMDBControlMap.item(ctrl.UniqueID);
				ctrl.UniqueID=__DATEPICK_IMG_PREFIX+ctrl.UniqueID;
				ctrl.Validate=false;
			}
			
			if(cname.indexOf("CMDB_FieldLabel") >= 0)
			{
				ctrl.IsFieldLabel = true;
				ctrl.ForControl=__CMDBControlMap.item(ctrl.UniqueID);
				ctrl.UniqueID=__FIELD_LABEL_PREFIX+ctrl.UniqueID;
				ctrl.Validate=false;
			}
			__CMDBControlMap.add(ctrl.UniqueID,ctrl);
			
			
		}
	}
}

function renderElementsByType()
{
	var ele = null;
	var ctrl = null;
	var ctrltype=null;
	var extjsEle = null;
	var img=null; 
	var defaultSet = false;
	for(var i=0;i<__CMDBControlMap.length;i++)
	{
		ctrl = __CMDBControlMap.item(i);
		ele = ctrl.Element;
		extjsEle = Ext.get(ele);
		Ext.get(ele).on('change', function(){
		    dataModifiedFlag = 1;
		});
		
		if(ctrl.IsExpandImage)
		{
			var img = Ext.get(ele.id);
			img.on('click',
					function()
						{
							showExpansionWindow(this); 
						},ctrl);
			continue;
		}
		
		if(ctrl.IsDatePickerImage)
		{
			var img = Ext.get(ele.id);
			img.on('click',
					function()
						{
							//ShowDatePicker(this);
							//new CMDBDatePickerPopup().Show(this.ForControl.Element.id);
							_datePicker.Show(this.ForControl.Element.id)
						},ctrl);
			continue;
		}
		
		
		var param = {applyTo:ele};
		param.width = 200;
		switch(ctrl.Element.tagName.toUpperCase())
		{
			
			case "INPUT":
				{
					ctrltype = ctrl.Element.type.toUpperCase();
					
					if(ctrltype=="CHECKBOX")
					{
						if(ctrl.Readonly)
						{
							ctrl.Element.disabled = true;
						}
					}
					else
					{
						if(ctrl.Readonly)
						{
							ctrl.Element.readOnly = true;
							ctrl.Element.className += ' InputVirtualReadOnly';
						}
						//ctrl.Element.className = ctrl.Element.className + ' InputVirtualReadOnly';
					}

					switch(ctrl.DisplayType.toUpperCase())
					{
						case "STRING":
							//new CMDB.Controls.TextField(param);
							break;
						case "DATETIME":
							if(!ctrl.Readonly)
							{
								//param.style=null;
								//new CMDB.Controls.DateTimeField(param);
							}
							break;
						case "BOOLEAN":
							//new CMDB.Controls.Checkbox(param);
							break;
						default:
							break;
					}
				}
				break;

			case "SELECT":
				{
					if(ctrl.Readonly)
					{
						ctrl.Element.disabled = true;
					}
					// Add conditions if required in future
					//new CMDB.Controls.Field(param);
				}
				break;
				
			case "TEXTAREA":
				{
					ctrl.Element.readOnly = ctrl.Readonly;
					// Add conditions if required in future
					//new CMDB.Controls.TextArea(param);
					if(ctrl.MaxLength!=null)
					{
						applyTextAreaLengthLimit(ctrl);
						//ctrl.Element.onkeydown="LimitText(this,"+ctrl.MaxLength+");" 
						//ctrl.Element.onkeyup="LimitText(this,"+ctrl.MaxLength+");"
					}
				}
				break;
				
				
				
			default:
				break;
		}
		
		if(!defaultSet && !ctrl.IsExpandImage && !ctrl.IsDatePickerImage && !ctrl.Readonly && !ctrl.IsFieldLabel) 
		{
			ele.focus();
			defaultSet=true;
		}
		
	}

}


function showExpansionWindow(ctrl){
	var newwin=null;
	
	var winHeader = __CMDBControlMap.item(__FIELD_LABEL_PREFIX+ctrl.ForControl.UniqueID).Element.innerHTML;
	var old_data = ctrl.ForControl.Element.value;
	var windowX = Ext.get(ctrl.ForControl.Element).getX();
	var windowY = Ext.get(ctrl.ForControl.Element).getY();

	var param = { value: old_data,readOnly:ctrl.ForControl.Readonly, cls:'InputVirtualReadOnly', id:'textAreaPopup' };
	if(ctrl.ForControl.MaxLength != null)
	{
		param.maxLength = ctrl.ForControl.MaxLength;
	}
	var txtarea = new Ext.form.TextArea(param);
	var  msg = _ServerValues.CMDBTextFieldLimitExceeded;
	msg = msg.replace("{0}", ctrl.ForControl.MaxLength);
	txtarea.maxLengthText = msg ;
	
	newwin = new Ext.Window({
		layout: 'fit',
		title: winHeader,
		width:400,
		height:200,
		frame: false,
		animate:true,
		//x:windowX,
		//y:windowY,
		cls:'CMDBWindow',
		modal:true,
		bodyStyle:'padding: 10px; background:#FFFFFF;',
		defaultType: 'textarea',
		defaultButton:'textAreaPopup',
		items: [txtarea],

		buttons: [{
			text: _ServerValues.OKLabel,
			handler: function(){
				var val = txtarea.getValue();
				
				var maxLength = ctrl.ForControl.MaxLength;
				if(maxLength != null)
				{
					 if(maxLength && val.length > maxLength){
						   val = val.substr(0,maxLength);
					 }
				}
				
				ctrl.ForControl.Element.value = val;
				if(old_data != ctrl.ForControl.Element.value){
					dataModifiedFlag = 1;
				}
				newwin.close();
			}
		},{
			 text: _ServerValues.CancelLabel,
			 handler: function(){
				newwin.close();
			 }
		}]

	});
	newwin.show();
}


function applyTextAreaLengthLimit(ctrl){
		var element = ctrl.Element;
		element.maxLength=ctrl.MaxLength;
        element.onkeydown = function(event){
	            return doKeyPress(element,event);
	        };
        
        element.onpaste = function(){
	            return doPaste(element);
	        };
        
        element.onkeyup = function(){
	            return doKeyUp(element);
	        };
        
        element.onblur = function(){
	            return doKeyUp(element);
	        };
}

var detect = navigator.userAgent.toLowerCase();

// Keep user from entering more than maxLength characters
function doKeyPress(obj,evt){
    var maxLength = obj.maxLength;
    var e = window.event ? event.keyCode : evt.which;
    if ( (e == 32) || (e == 13) || (e > 47)) { //IE
        if(maxLength && (obj.value.length > maxLength-1)) {
            if (window.event) {
                window.event.returnValue = null;
            } else {
                evt.cancelDefault;
                return false;
            }
        }
    }
}
function doKeyUp(obj){
    var maxLength = obj.maxLength;
     if(maxLength && obj.value.length > maxLength){
           obj.value = obj.value.substr(0,maxLength);
     }
    /*sr = obj.getAttribute("showremain");
    if (sr) {
        document.getElementById(sr).innerHTML = maxLength-obj.value.length;
    }*/
}

// Cancel default behavior and create a new paste routine
function doPaste(obj){
    var maxLength = obj.maxLength;
     if(maxLength){
        if ((window.event) && (detect.indexOf("safari") + 1 == 0)) { //IE
          var oTR = obj.document.selection.createRange();
          var iInsertLength = maxLength - obj.value.length + oTR.text.length;
          try {
          var sData = window.clipboardData.getData("Text").substr(0,iInsertLength);
          oTR.text = sData;
          }
          catch (err) {
          }
          if (window.event) { //IE
            window.event.returnValue = null;
     } else {
            //not IE
            obj.value = obj.value.substr(0,maxLength);
            return false;
        }
        }
     }
}
