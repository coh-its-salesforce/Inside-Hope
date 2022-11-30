function OpenHelpUrl(link){
	if(objectName.toLowerCase() == INCIDENT.toLowerCase())
		OpenHelppage('EmailConversation','module','form');
	else if(objectName.toLowerCase() == TASK.toLowerCase())
		OpenHelppage('EmailConversationTask','module','form');
	else if(objectName.toLowerCase() == PROBLEM.toLowerCase())
		OpenHelppage('EmailConversationProblem','module','form');
	else if(objectName.toLowerCase() == CHANGE_REQUEST.toLowerCase())
		OpenHelppage('EmailConversationChange','module','form');
}
//changes by mayuri
function getUrlParameter( param ){
param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
var r1 = "[\\?&]"+param+"=([^&#]*)";
var r2 = new RegExp( r1 );
var r3 = r2.exec( window.location.href );
if( r3 == null ){return ""}
else {return r3[1]};
}
function getStaffLinkCookie()
{
	var blStaffLink = Ext.util.Cookies.get(cookieName + 'staffLink');
	if(blStaffLink =='' || blStaffLink == null)
		return true;
	return blStaffLink;
}

function getClientLinkCookie()
{
	var blClientLink = Ext.util.Cookies.get(cookieName + 'clientLink');
	if(blClientLink =='' || blClientLink == null)
		return true;
	return blClientLink;
}


//change end by mayuri
var errormsg;
var attachment_Ids;
var save_attachments_flag;
var copyInciFlds = false;
var NONE = 'none';
var INCIDENT = 'Incident__c';
var CHANGE_REQUEST = 'Change_Request__c';
var TASK = 'Task__c';
var PROBLEM = 'Problem__c';
var emailTemplSelected = false;
var body = '', subject = '';
var isResetEnabled = false;
var bStaffLink = getStaffLinkCookie();
var bClientLink = getClientLinkCookie();
var bActionClicked=false;	//Added to stop first click event of ActionMenu


var bClientURLExist = ( sClientURL.trim().length>0 )?true:false;

var StaffLinkClickHandler=function(item, checked) {
	
	if(bActionClicked==true){
        bStaffLink=item.checked;
		Ext.util.Cookies.set(cookieName + 'staffLink', bStaffLink, new Date('01/01/2020'));
		if(bStaffLink==true)
			InsertLink(false);
	}
}
var ClientLinkClickHandler=function(item, checked) {
	
	if(bActionClicked==true){
        bClientLink=item.checked;
		Ext.util.Cookies.set(cookieName + 'clientLink', bClientLink, new Date('01/01/2020'));
		if(bClientLink==true)
			InsertLink(false);
	}
}
function enableDisableActionbutton()
{
	if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
			if(isNew == 'true')
				Ext.getCmp('btnActions').setDisabled(false);
			else
				Ext.getCmp('btnActions').setDisabled(true);
			}
	else
		Ext.getCmp('btnActions').setDisabled(true);
}
 function buttonValidator(){
	var bodyComponent   = document.getElementById(bodyId);
	var ccComponent = document.getElementById(ccId);
	var inciFldsChkBx = document.getElementById(chkBxId);
	var subjectComponent = document.getElementById(subjId);

	 if(isSendEnabled == 'true'){
		 Ext.getCmp('replyId').setDisabled(true);
		 Ext.getCmp('replyId').setIconClass('bmcReplyEmailDisable');
		 Ext.getCmp('resetId').setDisabled(false);
		 Ext.getCmp('resetId').setIconClass('bmcReset'); 
		 Ext.getCmp('attachId').setDisabled(false);
		 Ext.getCmp('attachId').setIconClass('bmcAttachFile');
		 Ext.getCmp('sendmailId').setDisabled(false);
		 Ext.getCmp('sendmailId').setIconClass('bmcSendEmail');
		 
		if(objectName.toLowerCase() == INCIDENT.toLowerCase())
			Ext.getCmp('btnActions').setDisabled(false);			
		else
			Ext.getCmp('btnActions').setDisabled(true);
		 
		 document.getElementById('ccLookupBtn').disabled = false;
		 if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
			bodyComponent.className = 'clsMailInputTextArea';    
			bodyComponent.readOnly = false;
		}
		 
		 if(ccComponent != null && typeof(ccComponent) != 'undefined'){
				ccComponent.className = 'clsInputTextArea';  
				ccComponent.readOnly = false;
		}
				 
		if(isNew == 'false'){
			var subjectComponent = document.getElementById(subjId);
			if(subjectComponent != null && typeof(subjectComponent) != 'undefined'){
				subjectComponent.className = 'clsIdInputTextBox';
				subjectComponent.readOnly = false;
			}
		 }
	 } else{ 
		 //clsInputTextAreaDisabled
		 Ext.getCmp('sendmailId').setDisabled(true);
		 Ext.getCmp('sendmailId').setIconClass('bmcSendEmailDisable');   
		 Ext.getCmp('replyId').setDisabled(false);
		 Ext.getCmp('replyId').setIconClass('bmcReplyEmail'); 
		 Ext.getCmp('resetId').setDisabled(true);
		 Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
		 Ext.getCmp('attachId').setDisabled(true);
		 Ext.getCmp('attachId').setIconClass('bmcAttachFileDisabled'); 
		 Ext.getCmp('btnActions').setDisabled(true);
		 document.getElementById('ccLookupBtn').disabled = true;
		 if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
			bodyComponent.className = 'clsMailInputTextAreaDisabled';
			bodyComponent.readOnly = true;
		}
			
		 if(ccComponent != null && typeof(ccComponent) != 'undefined'){
				ccComponent.className = 'clsInputTextAreaReadOnlyBrownBackground';
				ccComponent.readOnly = true;
		}
				
		 if(inciFldsChkBx != null && typeof(inciFldsChkBx) != 'undefined'){
			//inciFldsChkBx.className = 'clsMailInputCheckBoxDisabled';
			inciFldsChkBx.disabled = true;
		}
		
		if(emailTmpl != null && typeof(emailTmpl) != 'undefined'){
			emailTmpl.className = 'clsDisabledComboBox';
			emailTmpl.disabled = true;
		}
	 } 
	 enableDisableToField();
	 enableDiableEmailTemplate();
	}

function callToOpenPopup(){     
	if(clientSearchPageFlag == 'true'){
		openPopupWithTitle('ClientSearchPage?str=',setUserToEmail,labelSelectClients,Ext.isIE7 ? 480:477,Ext.isIE7 ?665:675);        		           
	} else {
		openPopupWithTitle('SearchPage?popupId=Client&isLookup=true&hasTitle=true&isActiveFilterReq=true&filterClause='+escape('isActive = true'),setUserToEmail,labelSelectFrom+' '+labelUserWinHeaderSrchPage,Ext.isIE7 ? 480:477,Ext.isIE7 ?510:560);
	} 
}

function callCCOpenPopup(){ 
	if(clientSearchPageFlag == 'true'){
		openPopupWithTitle('ClientSearchPage?str=',setUserEmail,labelSelectClients,Ext.isIE7 ? 480:477,Ext.isIE7 ?665:675);        		           
	} else {
		openPopupWithTitle('SearchPage?popupId=Client&isLookup=true&hasTitle=true&isActiveFilterReq=true&filterClause='+escape('isActive = true'),setUserEmail,labelSelectFrom+' '+labelUserWinHeaderSrchPage,Ext.isIE7 ? 480:477,Ext.isIE7 ?510:560);
	}
} 

function enableDisableSendAttach(doDisable) {
	Ext.getCmp('sendmailId').setDisabled(doDisable);
	Ext.getCmp('sendmailId').setIconClass(doDisable==true?'bmcSendEmailDisable':'bmcSendEmail');
	Ext.getCmp('attachId').setDisabled(doDisable);
	Ext.getCmp('attachId').setIconClass(doDisable==true?'bmcAttachFileDisabled':'bmcAttachFile');
}
function SetMailBodyText()
{
	var bodyComponent   = document.getElementById(bodyId);
	if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){  
			bodyComponent.value = mailBodyText;
			InsertLink(false);
		}
}

function enableDisbaleEmailBody(selVal){
	var bodyComponent   = document.getElementById(bodyId);
	var ccComponent = document.getElementById(ccId);
	var inciFldsChkBx = document.getElementById(chkBxId);
	var subjectComponent = document.getElementById(subjId);

	if(selVal == NONE){ //enable the email body, attachments and select inci fields check box
		 emailTemplSelected = false;
		 emailTemplId = emailTemplateId = '';
		 Ext.getCmp('attachId').setDisabled(false);
		 Ext.getCmp('attachId').setIconClass('bmcAttachFile');
		 if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
			Ext.getCmp('btnActions').setDisabled(false);
		}
		if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
			bodyComponent.className = 'clsMailInputTextArea';
			//bodyComponent.disabled = false;    
			bodyComponent.readOnly = false;   
			if(bodyComponent.value.length <= 0)
				bodyComponent.value = mailBodyText;
			
			InsertLink(false);
		}
		if(isResetEnabled == true){
			Ext.getCmp('resetId').setDisabled(false);
			Ext.getCmp('resetId').setIconClass('bmcReset'); 
		}
		isResetEnabled = false;
		if(subjectComponent != null && typeof(subjectComponent) != 'undefined'){
			//subjectComponent.disabled = false;
			subjectComponent.readOnly = false;
			subjectComponent.className = 'clsInputTextEnabled';
			if(subjectComponent.value == ''){
				if(isNew == 'true')
					subjectComponent.value =  labelSubject;
				else{
					subjectComponent.value = 'Re: ' + labelSubject + ' ' + labelRefUID;
				}
			}
		}
		if(inciFldsChkBx != null && typeof(inciFldsChkBx) != 'undefined'){
			inciFldsChkBx.disabled = false;
		}
	 }else{ //disable the email body, attachments and select inci fields check box
		emailTemplSelected = true;
		emailTemplId = emailTemplateId = selVal;
		 Ext.getCmp('replyId').setDisabled(true);
		 Ext.getCmp('replyId').setIconClass('bmcReplyEmail'); 
		 Ext.getCmp('attachId').setDisabled(true);
		 Ext.getCmp('attachId').setIconClass('bmcAttachFileDisabled'); 
		 if(Ext.getCmp('resetId').disabled == false){
			isResetEnabled = true;
			Ext.getCmp('resetId').setDisabled(true);
			Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
		}
		if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
			Ext.getCmp('btnActions').setDisabled(true);
		}
		if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
			bodyComponent.className = 'clsMailInputTextAreaDisabled';
			//bodyComponent.disabled = true;
			bodyComponent.readOnly = true;
		}
		if(subjectComponent != null && typeof(subjectComponent) != 'undefined'){
			//subjectComponent.disabled = true;
			subjectComponent.readOnly = true;
			subjectComponent.className = 'clsInputTextDisabled';
		}
		if(inciFldsChkBx != null && typeof(inciFldsChkBx) != 'undefined'){
			inciFldsChkBx.disabled = true;
		}
	}
	enableDisableToField();
	enableDiableEmailTemplate();
}

function getCheckBoxVal(sender){
	copyInciFlds = sender.checked;
}

function setLabelsToolTips(){
	var copyFldLabel = document.getElementById(copyFieldLblId);
	var mailBodyComponent = document.getElementById(bodyId);
	var copyFldChkBox = document.getElementById(chkBxId);
	if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
		if(copyFldLabel != null && typeof(copyFldLabel) != 'undefined')
			copyFldLabel.innerHTML = labelInciCopyField;
		if(copyFldChkBox != null && typeof(copyFldChkBox) != 'undefined')
			copyFldChkBox.title = labelInciCopyFldsToolTip;
		if(mailBodyComponent != null && typeof(mailBodyComponent) != 'undefined')
			mailBodyComponent.title = labelInciBodyToolTip;
	}
	else if (objectName.toLowerCase() == CHANGE_REQUEST.toLowerCase()){
		if(copyFldLabel != null && typeof(copyFldLabel) != 'undefined')
			copyFldLabel.innerHTML = labelChngCopyFlds;
		if(copyFldChkBox != null && typeof(copyFldChkBox) != 'undefined')
			copyFldChkBox.title = labelChngCopyFldsToolTip;
		if(mailBodyComponent != null && typeof(mailBodyComponent) != 'undefined')
			mailBodyComponent.title = labelChngBodyToolTip;
	}
	else if (objectName.toLowerCase() == TASK.toLowerCase()){
		if(copyFldLabel != null && typeof(copyFldLabel) != 'undefined')
			copyFldLabel.innerHTML = labelTaskCopyFlds;
		if(copyFldChkBox != null && typeof(copyFldChkBox) != 'undefined')
			copyFldChkBox.title = labelTaskCopyFldsToolTip;
		if(mailBodyComponent != null && typeof(mailBodyComponent) != 'undefined')
			mailBodyComponent.title = labelTaskBodyToolTip;
	}
	else if (objectName.toLowerCase() == PROBLEM.toLowerCase()){
		if(copyFldLabel != null && typeof(copyFldLabel) != 'undefined')
			copyFldLabel.innerHTML = labelProblemCopyFlds;
		if(copyFldChkBox != null && typeof(copyFldChkBox) != 'undefined')
			copyFldChkBox.title = labelProblemCopyFldsToolTip;
		if(mailBodyComponent != null && typeof(mailBodyComponent) != 'undefined')
			mailBodyComponent.title = labelProblemBodyToolTip;
	}
}

function getEmailIdCount(emailIds){
	var numOfIds = 0;
	var emailIdList = emailIds.split(';');
	
	if(emailIdList.length > 0){
		var index = 0;
		for(; index < emailIdList.length; index++){
			if(emailIdList[index] != null && emailIdList[index].trim().length > 0){
				if(propEnableEmailConvTempl == 'true' && emailTemplId != '' && emailTemplId != NONE 
					&& !validateEmail(emailIdList[index].trim())){ //Only for email templ. Check invalid email id. Notify user.
					Ext.Msg.show({
						msg: labelInvalidEmail + ' ' + emailIdList[index].trim(),
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return -1;
				}
				numOfIds++;
			}
		}
	}
	return numOfIds;
}

function validateEmail(email) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
} 

function ValidateEmailIdsLimit(){
	//No email addresses entered check + Maximum addresses check. 100 for To and 25 for cc
	var noToAddr = false;
	var noCCAddr = false;
	var maxToAddr = 100;
	var maxCCAddr = 25;
	var toAddrComponent = document.getElementById(toAddrId);
	if(toAddrComponent != null && typeof(toAddrComponent) != 'undefined'){
		if(toAddrComponent.value != null && toAddrComponent.value != 'undefined')
			if(toAddrComponent.value.trim().length <= 0){
				noToAddr = true;
			}
			else{
				var idCount = getEmailIdCount(toAddrComponent.value);
				if(idCount < 0){
					return false;
				}
				else if(idCount == 0){
					noToAddr = true;
				}
				else if(idCount > maxToAddr){
					Ext.Msg.show({
						msg: labelMaxToAddr,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return false;
				}
			}
	}
	
	var ccComponent = document.getElementById(ccId);
	if(ccComponent != null && typeof(ccComponent) != 'undefined'){
		if(ccComponent.value != null && ccComponent.value != 'undefined')
			if(ccComponent.value.trim().length <= 0){
				noCCAddr = true;
			}
			else{
				var idCount = getEmailIdCount(ccComponent.value);
				if(idCount == -1){ //invalid email id
					return false;
				}
				else if(idCount == 0){
					noCCAddr = true;
				}
				else if(idCount > maxCCAddr){
					Ext.Msg.show({
						msg: labelMaxCCAddr,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return false;
				}
			}
	}
	
	if(noToAddr && noCCAddr){
		Ext.Msg.show({
			msg: labelNoEmailAddr,
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}
	
	return true;
}

 Ext.onReady(function(){
        Ext.QuickTips.init();
               //changes by mayuri
         
           //change end by mayuri

         // This function renders a block of buttons
       var sendBtnHandler = function(button,event) {
			if(!ValidateEmailIdsLimit()) //Validation of no. of ids
				return;
            var bodyComponent = document.getElementById(subjId);
            if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
				if(propEnableEmailConvTempl == 'true' && emailTemplId != '' && emailTemplId != NONE){
            		sendMailTemplate(Ext.isIE,emailTemplateId);
            	}
            	else{
					var emailBodyComp = document.getElementById(bodyId);
					if(emailBodyComp != null && typeof(emailBodyComp) != 'undefined'){
						var strBody  = emailBodyComp.value;
						var emailLength = strBody.length;						
						if(emailLength>100000)
							emailBodyComp.value = strBody.substring(0,100000);
					}
					sendMail(Ext.isIE,save_attachments_flag);
				}
            }
			enableDisableSendAttach(true);			
			
			if(Ext.getCmp('resetId').disabled == false){
				isResetEnabled = true;
				Ext.getCmp('resetId').setDisabled(true);
				Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
			}
       };
       var ResetBtnHandler = function (button,event) { 
			Ext.getCmp('resetId').setDisabled(true);
			Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
			enableDisableSendAttach(true);
            reset(Ext.isIE);
       };
	   
	   var ActionBtnHandler = function(button,event){
			bActionClicked=true;
	   }

	   // HelpBtnHandler Added by Amit start
		var HelpBtnHandler = function (button,event) { 
            OpenHelpUrl();
       };
	   // HelpBtnHandler Added by Amit end
	   
		var AttachmentBtnHandler= function (button,event) { 
		var winHt = 464; //Default attachment window ht
		var winWd = 460;
		if(Ext.isIE7)
			winHt = 485;
		else if(Ext.isIE)
			winHt = 473;
				
		if(attachment_Ids != null && attachment_Ids !='')
			openPopupWithTitle('MultiDocumentAttachmentPage?objectName='+ objectName  + '&recordId='+recordId+'&isNew=true&consolidatedAttachments='+attachment_Ids+'&save_attachments_flag='+save_attachments_flag + '&standardLayout=' + standardLayout,attachFilesOnCompleteIn,labelAddAttachment,winHt,winWd,false);
		else
			openPopupWithTitle('MultiDocumentAttachmentPage?objectName='+ objectName + '&recordId='+recordId+'&isNew=true' + '&standardLayout=' + standardLayout,attachFilesOnCompleteIn,labelAddAttachment,winHt,winWd,false);		//reset(Ext.isIE);
		};       
	   var toolBar= new Ext.Toolbar({
            title: '',
             cls:'toolSpCls',
             renderTo: 'btnToolbar',
             bodyStyle:'border:0px;padding:0px;margin:0px;zoom:0px;',
            items: [' ',{
                scale: 'medium',
                id: 'sendmailId',
                tooltipType : 'title',
                tooltip: labelSend,
                iconCls: 'bmcSendEmail', 
                handler:sendBtnHandler
                
            },' ',{
                scale: 'medium',
                id: 'replyId',
                tooltipType : 'title',
                tooltip: labelReply,
                iconCls: 'bmcReplyEmail', 
                handler:replyBtnHandler
                
            },' ',{
                scale: 'medium',
                id:'attachId',
                iconCls: 'bmcAttachFile',
                tooltipType : 'title',
                tooltip: labelAttachFile,
                handler:AttachmentBtnHandler
            },' ',{
                scale: 'medium',
                id:'resetId',
                iconCls: 'bmcReset',
                tooltipType : 'title',
                tooltip: labelReset,
                handler:ResetBtnHandler
            },' ',{
				scale: 'medium', 
				id:'btnActions', 
				iconCls: 'bmcAction1', 
				tooltipType: 'title',
				tooltip: labelActions, 
				menu: new Ext.menu.Menu ({
					autoWidth : true,
					showSeparator: false,
					plain: true,
					items:[
						{
							xtype: 'checkbox',
							id :'StaffLink',
							text : labelStaffLink,
							boxLabel: labelStaffLink,
							checked : (bStaffLink=='true' || bStaffLink==true)?true:false,
							autoWidth: true,
							handler:StaffLinkClickHandler
						},
						{
							xtype: 'checkbox',
							id :'ClientLink',
							text : labelClientLink,
							boxLabel:labelClientLink ,
							checked : (bClientLink=='true' || bClientLink==true)? true:false,
							autoWidth: true,
							hidden: (bClientURLExist == 'true' || bClientURLExist==true)?false:true,
							handler:ClientLinkClickHandler
						}
					]
				}),
				handler:ActionBtnHandler,
				listeners: 
					{
						disable: function(){
							this.setIconClass('bmcAction');    
						},
						enable: function(){
							this.setIconClass('bmcAction1');          
						}
					}									
			},' ',{ // this help Added by Amit start
                scale: 'medium',
                id:'helpId',
                iconCls: 'bmcSendEmailHelp',
                tooltipType: 'title',
                tooltip: labelTooltipHelp,
                handler:HelpBtnHandler
            } // this help Added by Amit end
			] 
        });
		// this if Added by Amit start
		if(standardLayout == 'true'){
			Ext.get('helpId').show();
		}else{
			Ext.get('helpId').hide();
		}
		// this if Added by Amit end        
		
		enableDisableActionbutton();
		
    if(isNew == 'true'){
         Ext.getCmp('replyId').setDisabled(true);
         Ext.getCmp('replyId').setIconClass('bmcReplyEmailDisable');   
         Ext.getCmp('resetId').setDisabled(true);
         Ext.getCmp('resetId').setIconClass('bmcResetDisable');
         enableDisableToField();
         enableDiableEmailTemplate();
		 InsertLink(true);
     }else{
         Ext.getCmp('sendmailId').setDisabled(true);
         Ext.getCmp('sendmailId').setIconClass('bmcSendEmailDisable');
         Ext.getCmp('resetId').setDisabled(true);
         Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
         Ext.getCmp('attachId').setDisabled(true);  
         Ext.getCmp('attachId').setIconClass('bmcAttachFileDisabled');  
         var subjectComponent = document.getElementById(subjId);
         if(subjectComponent != null && typeof(subjectComponent) != 'undefined'){
         	subjectComponent.className = 'clsIdInputTextBoxReadOnly';
         	subjectComponent.onfocus = function(){this.blur();};
			subjectComponent.readOnly = true;
         }
         var bodyComponent   = document.getElementById(bodyId);
         if(bodyComponent != null && typeof(bodyComponent) != 'undefined'){
         	bodyComponent.className = 'clsMailInputTextAreaDisabled';
			bodyComponent.readOnly = true;
		}
         
         var ccComponent = document.getElementById(ccId);
         if(ccComponent != null && typeof(ccComponent) != 'undefined'){
         	ccComponent.className = 'clsInputTextAreaReadOnlyBrownBackground';
         	ccComponent.onfocus = function(){this.blur();};
			ccComponent.readOnly = true;
         }
         document.getElementById('ccLookupBtn').disabled = true;
		 
        var inciFldsChkBx = document.getElementById(chkBxId);
        if(inciFldsChkBx != null && typeof(inciFldsChkBx) != 'undefined'){
      		//inciFldsChkBx.className = 'clsMailInputCheckBoxDisabled';
       		inciFldsChkBx.disabled = true;
		}
		
		var emailTmpl = document.getElementById(emailTmplId);
       	if(emailTmpl != null && typeof(emailTmpl) != 'undefined'){
     		emailTmpl.className = 'clsDisabledComboBox';
     		emailTmpl.disabled = true;
   		}
		
		if(isSendEnabled == 'true')
			enableDisableToField();
		else{
			var toAddrComponent = document.getElementById(toAddrId);
			if(toAddrComponent != null && typeof(toAddrComponent) != 'undefined'){
				toAddrComponent.onfocus = function(){this.blur();};
				toAddrComponent.className = 'clsInputTextAreaReadOnlyBrownBackground';
				toAddrComponent.readOnly = true;
			}	
			document.getElementById('toLookupBtn').disabled = true;
		}
     }
     setLabelsToolTips();
     
     // create the data store
    var store = new Ext.data.ArrayStore({
        fields: [
           {name: 'name'},
           {name: 'label'}
        ]
    });
     
     store.loadData(inciFields);
     
     this.contextMenu = new Ext.menu.Menu({
        items: [
        	new Ext.grid.GridPanel({
        		store: store,
        		columns: [{
		                id       : 'name',
		                header   : 'Name',
		                dataIndex: 'name',
		                hidden: true, 
		                hideable: false
		            },
		            {
		                id       : 'label',
		                header   : getHeader(),
		                sortable : false,
		                width: 200,
		                dataIndex: 'label'
		            }
		            ],
	            stripeRows: true,
        		autoExpandColumn: 'label',
        		height: 200,
        		width: 250,
        		closable: true,
        		enableCtxMenu: false,  // turn off header context menu
    			enableColLock: false,  // turn off column lock context items
    			enableColumnMove: false,  // turn off column reorder drag drop
    			enableColumnResize: false,  // turn off column resize for whole grid
        		listeners : {
					'rowclick':function(grid, rowIndex, e) {
								e.stopEvent(); //Stop double call to rowclick
      							var sel_model = grid.getSelectionModel();
								var record = sel_model.getSelected();
								fetchObjectFieldData(record.get('name'));
								Ext.get('fieldMenu').hide();
    						},
  					'rowcontextmenu':function(grid,index,e){
  						e.stopEvent(); //Stop context menu on context menu
  					},
					'headercontextmenu': function(grid, columnIndex, e ){
						e.stopEvent(); //Stop context menu on context menu
					}
				}
       		})
        ],
       	id: 'fieldMenu',
		width: 255
    });
     
    	AttachContextMenu();
    });

	function getHeader(){
		var headerVal = '';
		if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
			headerVal =  labelContextMenuIncident;
		}
		else if(objectName.toLowerCase() == CHANGE_REQUEST.toLowerCase()) {
			headerVal = labelContextMenuChange;
		}
		else if(objectName.toLowerCase() == TASK.toLowerCase()) {
			headerVal = labelContextMenuTask;
		}
		else if(objectName.toLowerCase() == PROBLEM.toLowerCase()) {
			headerVal = labelContextMenuProblem;
		}
		return headerVal;
	}
 
 	function AttachContextMenu(){
 		var element = Ext.get(bodyId);
		if(typeof(element) != 'undefined' && element != null){
			element.on('contextmenu',
				function(e) {
				if(copyInciFlds == true){
					var elm = Ext.get(bodyId);
					var ht = elm.getHeight();
					var wt = elm.getWidth();
					var xy = e.getXY();
					if( xy[1] > ht ){ //adjust height = xy[1] starts with 250 there adding only 50
						xy[1] = xy[1] - 205;
					}
					if( (xy[0]+255) > wt ) { //adjust width
						xy[0] = xy[0] - 255;
					}
					this.contextMenu.showAt(xy);
					e.stopEvent();
				}
			}, this);
		}
 	}
 	
 	function InsertDataAtCursor(fieldData) {
        var bodyComponent = document.getElementById(bodyId);
        if(bodyComponent != null && typeof(bodyComponent) != 'undefined' &&
        	bodyComponent.value != null && typeof(bodyComponent.value) != 'undefined'){
        	if(Ext.isIE){
        		if (document.selection) {
					bodyComponent.focus();
					sel = document.selection.createRange();
					sel.text = fieldData;
				}
        	} else{
	        	var startPos = bodyComponent.selectionStart;
	          	var endPos = bodyComponent.selectionEnd;
	          	if(startPos != null && typeof(startPos) != 'undefined' && endPos != null && typeof(endPos) != 'undefined'){
		          	bodyComponent.focus();
		          	bodyComponent.value = bodyComponent.value.substring(0, startPos) + fieldData
		          		+ bodyComponent.value.substring(endPos, bodyComponent.value.length);
		          	bodyComponent.setSelectionRange(endPos+fieldData.length, endPos+fieldData.length);
	       		}
       		}
		}
	}
 	 	
	function enableDisableToField(){
		var toAddrComponent = document.getElementById(toAddrId);
		
		if(propEnableEmailConvToFld == 'true'){
			if(toAddrComponent != null && typeof(toAddrComponent) != 'undefined'){
   				//toAddrComponent.disabled = false;
				toAddrComponent.onfocus = function(){};
   				toAddrComponent.className = 'clsInputTextArea';
				toAddrComponent.readOnly = false;
 			}
 			document.getElementById('toLookupBtn').disabled = false;
 			document.getElementById('toLookupBtn').style.display = '';
		}
		else{
			if(toAddrComponent != null && typeof(toAddrComponent) != 'undefined'){
   				//toAddrComponent.disabled = true;
				toAddrComponent.onfocus = function(){this.blur();};
   				toAddrComponent.className = 'clsInputTextAreaReadOnlyBrownBackground';
				toAddrComponent.readOnly = true;
 			}
 			document.getElementById('toLookupBtn').disabled = true;
 			document.getElementById('toLookupBtn').style.display = 'none';
    	}
	}
	
	function enableDiableEmailTemplate(){
		var emailTmpl = document.getElementById(emailTmplId);
		if(emailTmpl != null && typeof(emailTmpl) != 'undefined'){
			if(propEnableEmailConvTempl == 'true'){
				emailTmpl.disabled = false;
				emailTmpl.className = 'clsComboBox';
			}
			else {
				emailTmpl.disabled = true;
				emailTmpl.className = 'clsDisabledComboBox';
			}
		}
	}
 
 function attachFilesOnCompleteIn(attachmentIds)
 {	
	
	if(attachmentIds != null && attachmentIds != '' && attachmentIds !='null'){
		attachment_Ids=attachmentIds;
		fetchAttachmentListJS(attachmentIds);
	}else{
		attachment_Ids='';
		 document.getElementById(attachFileId).value='';
	}
	
	
 }
 
 function setFlagForSaveAttachments(tmp_save_attachments_flag)
 {
	save_attachments_flag = tmp_save_attachments_flag;
 }
 
 function afterSendEmail(){ 
	createCookie();
	enableDisableSendAttach(false);
	if(isResetEnabled == true){
		Ext.getCmp('resetId').setDisabled(false);
		Ext.getCmp('resetId').setIconClass('bmcReset'); 
	}
	isResetEnabled = false;
    if(errormsg=='Send Successfully'){
		// afterSendEmail Added by Amit start
	    if(standardLayout == 'true'){
                       if(getUrlParameter('stdform')){
						Ext.getCmp('sendmailId').setDisabled(true);
						Ext.getCmp('sendmailId').setIconClass('bmcSendEmailDisable');
						Ext.getCmp('attachId').setDisabled(true);
						Ext.getCmp('attachId').setIconClass('bmcAttachFileDisabled');
                        window.location.href="/"+recordId;
                       }else{ 
			 window.opener.location.href="/"+recordId;
                           window.close();
                       }
		}else{
     		window.parent.setPopUpVar(recordId);
            window.parent.closePopup();
		}
	    // afterSendEmail Added by Amit end		 
    }else{
		showError();
		var emailTmpl1 = document.getElementById(emailTmplId);
		if(emailTmpl1 != null && typeof(emailTmpl1) != 'undefined'){
			Ext.getCmp('resetId').setDisabled(true);
			Ext.getCmp('resetId').setIconClass('bmcResetDisable'); 
			isResetEnabled = true;
			Ext.getCmp('attachId').setDisabled(true);
			Ext.getCmp('attachId').setIconClass('bmcAttachFileDisabled');
		}
	}
  }

function replyBtnHandler(){
	Ext.getCmp('replyId').setDisabled(true);
	Ext.getCmp('replyId').setIconClass('bmcReplyEmailDisable');
    replyMail(Ext.isIE);
}


function createCookie(){
	if(objectName.toLowerCase() == INCIDENT.toLowerCase()){	
		Ext.util.Cookies.set(cookieName + 'staffLink', bStaffLink, new Date('01/01/2020'));    
		Ext.util.Cookies.set(cookieName + 'clientLink', bClientLink, new Date('01/01/2020'));    
	}
}

//newReply-> true: New conversation/false: ReplyConversation
function InsertLink(newReply){
	if(objectName.toLowerCase() == INCIDENT.toLowerCase()){
		var mailbodyComponent = document.getElementById(bodyId);
					
		if(mailbodyComponent != null && typeof(mailbodyComponent) != 'undefined')
		{
			var bSURLExistinBody = false;
			var bCURLExistinBody = false;
			if(newReply == false)
			{
				if(mailbodyComponent.value.indexOf(sStaffURL) > -1)
					bSURLExistinBody = true;
				if(mailbodyComponent.value.indexOf(sClientURL) > -1)
					bCURLExistinBody = true;
				
			}
			//Insert Staff URL at bottom of Email body
			if((bStaffLink=='true' || bStaffLink==true) 
				&& (bSURLExistinBody == false))
				mailbodyComponent.value = mailbodyComponent.value + '\n' + labelLinkRemedyforceUser + ' ' + sStaffURL;

			if((bClientURLExist=='true' || bClientURLExist==true) 
					&& (bClientLink=='true' || bClientLink==true) 
					&& (bCURLExistinBody == false))
			{
				//Insert client URL at bottom of Email body
				mailbodyComponent.value = mailbodyComponent.value + '\n' + labelLinkSelfServiceClient + ' ' + sClientURL;
			}
		}
	}
}



