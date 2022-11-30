	Ext.onReady(function(){
		if (!closeIncidentPage.Labels.isUpdateable) 
			Ext.MessageBox.show({ msg: closeIncidentPage.Labels.insufficentPrivilegeMsg, buttons: Ext.MessageBox.OK});
	
		Ext.QuickTips.init();
        var isClosedByEmpty ='False';
        // Function added by Manish Puri for bug 001700      
        function ClosedByEmpty(){
			isClosedByEmpty ='False';
             var chkClosedBy= document.getElementById(closeIncidentPage.ComponentVars.closedByusername).value;              
             if(chkClosedBy!=null && chkClosedBy!=''){ 
                isClosedByEmpty ='False';
            } else {
                isClosedByEmpty ='True';
            }
        } 

        var OkBtnHandler = function(button,event) { 
			ClosedByEmpty();
			if(isClosedByEmpty=='False'){
				closeIncident();
           }else{
				Ext.MessageBox.show({ msg: closeIncidentPage.Labels.labelCloseByEmpty, buttons: Ext.MessageBox.OK});
				return;
           }
        };
       
        var SamplePanel = Ext.extend(Ext.Panel, {
            renderTo: 'btnToolbar',
            defaults: {bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;'}
        });
        
        new SamplePanel({
			title: '',
            cls:'toolCloseCls',
            bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
            tbar: [{
                scale: 'medium',
                tooltip: closeIncidentPage.Labels.labelCloseIncident,
                iconCls: 'bmcSave',
				disabled: !closeIncidentPage.Labels.isUpdateable,
                handler:OkBtnHandler
            }]
        });
        toggleFollowUpDateTime();
    });
  
  
	function toggleFollowUpDateTime(){  
        var browser=navigator.appName;
        if(document.getElementById(closeIncidentPage.ComponentVars.followUp).checked == true){
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).disabled = false;
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).value = follwupdatetimeval;
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).style.backgroundColor = "#FFFFFF";
            if(browser == "Microsoft Internet Explorer"){
                document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).style.backgroundColor = "#FFFFFF";
            }
        }else{
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).value = "";
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).disabled = true;
            //added by roop-new
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).style.backgroundColor = "#CCCCCC";
            //end-roop
            if(browser == "Microsoft Internet Explorer"){
                document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).style.backgroundColor = "#CCCCCC";
            }
        }
    }
		function validateAndCloseWindow(){
		if(msgvalue==''){
if((errorString != null && errorString != '')){
  showError();
            }else{
			 if(stdFormValue){
            window.opener.location.href='/'+incidentId;          
            window.close();
        }else{
                window.parent.setPopUpVar(incidentId);
                window.parent.renderAddNoteAfterClose();
                window.parent.updateTitle();
                parent.window.closePopup();
				}
            }
		}
    }	  
              
	function diableCheckboxes(){
        if(document.getElementById(closeIncidentPage.ComponentVars.incidentResolution).value == ''){
            var checkboxRes = getElementsByValue("isStdResolution", "input");         
            checkboxRes[0].disabled = true;
        }
        if(document.getElementById(closeIncidentPage.ComponentVars.incidentDescription).value == ''){
            var checkboxDesc = getElementsByValue("isStdDescription", "input");         
            checkboxDesc[0].disabled = true;
        }
    }
		
	function getElementsByValue(value, tag, node) {
        var values = new Array();
        if (tag == null)
            tag = "*";
        if (node == null)
            node = document;
        var search = node.getElementsByTagName(tag);
        var pat = new RegExp(value, "i");
        for (var i=0; i<search.length; i++) {
            if (pat.test(search[i].value))
                    values.push(search[i]);
        }
        return values;
    }
	
	function changeDescCheckboxStatus(){
        var checkboxDesc = getElementsByValue("isStdDescription", "input");
        var checkboxRes = getElementsByValue("isStdResolution", "input");
		if(checkboxRes[0].checked && !checkboxDesc[0].checked) 
            checkboxDesc[0].checked = true;
                   /*if(!checkboxDesc[0].checked && checkboxRes[0].checked){
                           checkboxDesc[0].checked = false; 
                           checkboxRes[0].checked = false;
                    }*/
    }
	
	function refreshRelatedPortlets(){
        if(typeof(window.parent.parent.parent.refreshActionItemsPortlet) == 'function')
			window.parent.parent.parent.refreshActionItemsPortlet('Action Items','INC');
        var isCloseTaskChecked = document.getElementById(closeIncidentPage.ComponentVars.closeTasks);
        if(isCloseTaskChecked.checked && typeof(window.parent.parent.parent.refreshActionItemsPortlet) == 'function'){
            window.parent.parent.parent.refreshActionItemsPortlet('Action Items','TASK');
        }
    }
	  
	
    
	function assignApexErrorMessage(){
		msgvalue='';
        var elem = document.getElementById('testPanelDiv');
        if(elem != null && elem.firstChild != null){
            var ulList = elem.firstChild;
            msgvalue = ulList.firstChild.innerHTML;
            Ext.MessageBox.show({ msg: msgvalue, buttons: Ext.MessageBox.OK});
        }
    }     
	
	function disableFDT(){
        var browser=navigator.appName;
        document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).disabled = true;
        if(browser == "Microsoft Internet Explorer"){
            document.getElementById(closeIncidentPage.ComponentVars.followUpDateTime).style.backgroundColor = "#CCCCCC";
        }
    }
	
	
    
	function closeWindow(){
        closeIncident();
    } 
    
	function disableSIMenues(){
        window.parent.frames.SIIframeID.disableAll();
        if(errorString.indexOf(closeIncidentPage.Labels.labelIncidentCloseError)!= -1){
            window.parent.frames.SIIframeID.enableAll();
        }
    }