function getUrlParameter( param ){
param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");;
var r1 = "[\\?&]"+param+"=([^&#]*)";
var r2 = new RegExp( r1 );
var r3 = r2.exec( window.location.href );
if( r3 == null ){return ""}
else {return r3[1]};
}
Ext.onReady(function(){
        if (!CloseProblemPage.Labels.isUpdateable) 
			Ext.MessageBox.show({ msg: CloseProblemPage.Labels.insufficentPrivilegeMsg, buttons: Ext.MessageBox.OK});
			
        Ext.QuickTips.init();
        
         var isClosedByEmpty ='False';
        
           

        function ClosedByEmpty(){
             isClosedByEmpty ='False';
             var chkClosedBy= document.getElementById(CloseProblemPage.ComponentVars.closedByUserName).value;              
             if(chkClosedBy!=null && chkClosedBy!=''){ 
                    isClosedByEmpty ='False';
                } else {
                     isClosedByEmpty ='True';
                }
        } 
       function disableSIMenues(){
                  window.parent.frames.SIIframeID.disableAll();
             
              }
    
       var SaveBtnHandler = function(button,event) { 
        ClosedByEmpty();
          if(isClosedByEmpty=='False'){
                          if(getUrlParameter('stdForm'))
                             save();

			 var checkboxDesc = getElementsByValue("isStdDescription", "input");
             var checkboxRes = getElementsByValue("isStdResolution", "input");
			 var checkboxTask = document.getElementById(CloseProblemPage.ComponentVars.closeTasksId);
			 var checkboxIncident = document.getElementById(CloseProblemPage.ComponentVars.closeIncidentsId);
			 var statusId = document.getElementById(CloseProblemPage.ComponentVars.statusIdEle).value;
			 var categoryId = document.getElementById(CloseProblemPage.ComponentVars.categoryIdEle).value;
			 var closedById = document.getElementById(CloseProblemPage.ComponentVars.closedByIdEle).value;
			 var resolution = document.getElementById(CloseProblemPage.ComponentVars.problemResolution).value;
			 var closeDateTime = document.getElementById(CloseProblemPage.ComponentVars.closedDateTimeEle).value;
			if(!getUrlParameter('stdForm')) 
              window.parent.saveAndCloseJS(closedById,resolution,categoryId,statusId,closeDateTime,checkboxDesc[0].checked,checkboxRes[0].checked,checkboxTask.checked,checkboxIncident.checked);
         }
         else{
           Ext.MessageBox.show({ msg: CloseProblemPage.Labels.ClosedBYEmpty, buttons: Ext.MessageBox.OK});
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
                iconCls: 'bmcSave',
				disabled: !CloseProblemPage.Labels.isUpdateable,
                handler:SaveBtnHandler 
            }]
        });
              
    });
 
 
   function disableCheckboxes(){
                 
                  if(document.getElementById(CloseProblemPage.ComponentVars.problemResolution).value == '')
                  {
                     var checkboxRes = getElementsByValue("isStdResolution", "input");         
                       checkboxRes[0].disabled = true;
                   }
                   if(document.getElementById(CloseProblemPage.ComponentVars.problemDescription).value == ''){
                       var checkboxDesc =getElementsByValue("isStdDescription", "input");         
                       checkboxDesc[0].disabled = true;
                   }
                   
              }
              
  function changeDescCheckboxStatus(){
                  var checkboxDesc = getElementsByValue("isStdDescription", "input");
                  var checkboxRes = getElementsByValue("isStdResolution", "input");
                   if(checkboxRes[0].checked && !checkboxDesc[0].checked) {
                           checkboxDesc[0].checked = true;
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
                    for (var i=0; i<(search.length); i++) {
                        if (pat.test(search[i].value))
                            values.push(search[i]);
                     }
                     return values;
                    
                }
             
             function closeWindow(){
                  closeIncident();
              } 
              function disableSIMenues(){
                  if(window.parent.frames.SIIframeID != null && window.parent.frames.SIIframeID != 'undefined')
                    window.parent.frames.SIIframeID.disableAll();
              }
			function validateAndCloseWindow(){				
				if((errormsg == null || errormsg == '') && getUrlParameter('stdForm')){
					window.opener.location.href="/"+getProblemID();
					window.close();
				}
				if(errormsg != null && errormsg != ''){
					showError();
				}else{
					var problemId = getProblemID();
					SendValueToParent(problemId)
				}
			}
			function SendValueToParent(a){ 
				window.parent.setPopUpVar(a);
				parent.window.closePopup();
			}   