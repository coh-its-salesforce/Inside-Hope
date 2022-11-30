({
    changeStatus : function(component,event, helper ) {
        console.log('Before Called', JSON.parse(JSON.stringify(component.get('v.caseRecord'))))
        // var runOnce = component.get('v.runOnce');
        // if(runOnce){
        //  component.set('v.runOnce',false)
        var originalStatus = component.get('v.caseStatus');
        var newStatus = component.get('v.caseStatusNew');
        console.log('originalStatus',originalStatus)
        console.log('newStatus',newStatus)
        if(newStatus == undefined||originalStatus == newStatus){
            
            if(component.get('v.caseRecord').Status == 'New'){
                //component.set('v.caseRecord.Status','Inquiry');
                component.set('v.isModalOpen',true);
                return;
            }
            else if(component.get('v.caseRecord').Status == 'Inquiry'){
                component.set('v.caseRecord.Status','Registered');
                
            }
            
                else if(component.get('v.caseRecord').Status == 'Registered'){
                    component.set('v.caseRecord.Status','Nursing Review');
                }
                    else if(component.get('v.caseRecord').Status == 'Nursing Review'){
                        component.set('v.caseRecord.Status','Records Procurement');
                    }
                        else if(component.get('v.caseRecord').Status == 'Records Procurement'){
                            component.set('v.isModalOpen',true);
                            return;
                            
                        }
        }else{
            if(newStatus == 'Inquiry' || newStatus == 'Closed'){
                component.set('v.isModalOpen',true);
                return;
            }
            component.set('v.caseRecord.Status',newStatus);
        }
        
        console.log('After Called', JSON.parse(JSON.stringify(component.get('v.caseRecord'))))
        //grab lightning data service template            
        component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
                component.set('v.caseStatus',component.get('v.caseStatusNew'));
                $A.get('e.force:refreshView').fire();
                component.find('recordLoader').reloadRecord(true);
                setTimeout(function() {
                    window.open("/"+component.get('v.recordId'), "_self");
                }, 2000);
                
                
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('saveResult.error.message')
                helper.showErrorToast(component, event,saveResult.error[0].message)
                console.log('Problem saving record, error: ' , 
                            JSON.parse(JSON.stringify(saveResult.error)));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
        
    },
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": "No Errors, updating the status now"
        });
        toastEvent.fire();
    },
    showErrorToast : function(component,event,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type" : "error",
            "message": message,
            "duration":"20000"
        });
        toastEvent.fire();
    }
})