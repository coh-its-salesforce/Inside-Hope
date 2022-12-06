({ 

    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
 
    handleCancel: function(component){
        component.set("v.viewScreen",true);
        component.set("v.editScreen",false);
    },
    handleEdit: function(component){
        component.set("v.viewScreen",false);
        component.set("v.editScreen",true);
    },
        
    handleSubmit : function(component, event, helper) {
                var today = new Date();
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
                var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                var dateTime = date+' '+time;
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
             //  }
	},
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },
        
    handleSuccess: function(cmp, event, helper) {
        //cmp.set('v.showSpinner', false);
        //cmp.set('v.saved', true);
    },
    
	init : function(component,event,helper) {                        
        var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getITProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMObj",ITProjectIntakeInfo);
               	var UId1=component.get("v.ITPMObj.Analyst__c");
                var alink1='/lightning/r/User/'+UId1+'/view';
                component.set("v.link1",alink1);
                var UId2=component.get("v.ITPMObj.CreatedById");
                var alink2='/lightning/r/User/'+UId2+'/view';
                component.set("v.link2",alink2);
                var UId3=component.get("v.ITPMObj.LastModifiedById");
                var alink3='/lightning/r/User/'+UId3+'/view';
                component.set("v.link3",alink3);
                var UId4=component.get("v.ITPMObj.MS_Teams_URL__c");
                var alink4=UId4;
                component.set("v.link4",alink4);
                var bmcCRVal=component.get("v.ITPMObj.BMC_Change_Request__c");
                component.set("v.bmcCR",bmcCRVal);
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }






})