({ 
   /* handleRefresh: function(component,event,helper){
        helper.handleRefresh(component,event,helper);
    }, */

    handleLoad: function(cmp, event, helper) {
          var goLiveDateFieldValue = cmp.find("fieldId7").get("v.value");
        console.log('goLiveDateFieldValue--->'+goLiveDateFieldValue)
        var isAdminUserProfile = cmp.get("v.isAdminUser");
        console.log('isAdminUserProfile---->'+isAdminUserProfile);
        if(goLiveDateFieldValue && !isAdminUserProfile){
            cmp.set("v.isDisableGoLiveDateField",true);
        }
        cmp.set('v.showSpinner', false);
       
    },
 
    handleCancel: function(component, event, helper){
        component.set("v.viewScreen",true);
        component.set("v.editScreen",false);
    },
    handleEdit: function(component, event, helper){
        component.set("v.viewScreen",false);
        component.set("v.editScreen",true);
    },
            
    handleSubmit : function(component, event, helper) {
                var today = new Date();
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
                var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                var dateTime = date+' '+time;
                var reqField1 = component.find('fieldId1');
                var reqField2 = component.find('fieldId2');
                var reqField3 = component.find('fieldId3');
                var reqField4 = component.find('fieldId4');
                var reqField5 = component.find('fieldId5');
                var reqField6 = component.find('fieldId6');
                var reqField7 = component.find('fieldId7');
                var reqField8 = component.find('fieldId8');
                var reqField9 = component.find('fieldId9');
                var reqField10 = component.find('fieldId10');
                var reqField11 = component.find('fieldId11');
        		var reqField12 = component.find('fieldId12');
             
               
                var reqFieldVal1=reqField1.get('v.value');
                var reqFieldVal2=reqField2.get('v.value');
                var reqFieldVal3=reqField3.get('v.value');
                var reqFieldVal4=reqField4.get('v.value');
                var reqFieldVal5=reqField5.get('v.value');
                var reqFieldVal6=reqField6.get('v.value');
                var reqFieldVal7=reqField7.get('v.value');
                var reqFieldVal8=reqField8.get('v.value');
                var reqFieldVal9=reqField9.get('v.value');
                var reqFieldVal10=reqField10.get('v.value');
                var reqFieldVal11=reqField11.get('v.value');
        		var reqFieldVal12=reqField12.get('v.value');
                //alert(reqFieldVal2);
                if ($A.util.isEmpty(reqFieldVal1) || $A.util.isEmpty(reqFieldVal2) || $A.util.isEmpty(reqFieldVal3)
                || $A.util.isEmpty(reqFieldVal4) || $A.util.isEmpty(reqFieldVal5) || $A.util.isEmpty(reqFieldVal6)
                || $A.util.isEmpty(reqFieldVal7) || $A.util.isEmpty(reqFieldVal8) || $A.util.isEmpty(reqFieldVal9) 
                || $A.util.isEmpty(reqFieldVal10) || $A.util.isEmpty(reqFieldVal11) || $A.util.isEmpty(reqFieldVal12)) {
                    alert('All required fields must be entered in order to “Save Status Details”');
                    //alert('Overall Project Health,Scope,Schedule,Financials,Resources,Percent Complete,Go-Live Date,Phase,Methodology,Baseline Start Date & Baseline End Date must be completed');
                    //adding event.preventDefault() to prevent record from being saved 09/10/2019 LK
                    event.preventDefault();
                 }
               else
               {
               
                event.preventDefault();
                var fields = event.getParam("fields");
                fields['Current_Status_Accomplishments__c']=today.toJSON();
                component.find('createevalForm').submit(fields); // Submit form
                component.set("v.editScreen",false);
                component.set("v.viewScreen",true);
                var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({
                        "title": "",
                        "message": "Record updated successfully",
                        "type": "success"
                    });
                toastEvent.fire();
                   //window.location.reload()
               }
        
                      
	},
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },
        
    handleSuccess: function(component, event, helper) {
        //cmp.set('v.showSpinner', false);
        //cmp.set('v.saved', true); 
       /* helper.loadInit(component,event,helper);
         setTimeout(
            $A.getCallback(function(){
                helper.handleRefresh(component,event,helper);  
                console.log('handleRefresh Complete');
            }), 4000
        ); */
    },
    
	init : function(component,event,helper) {                        
        helper.loadInit(component,event,helper);
        setInterval(function(){helper.loadInit(component,event,helper);}, 10000);
    }
        
})