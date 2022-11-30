({
    /*
     * Create an Epic record.
     * 
     * @param component		Component
     * @param event				Eomponent
     * @param helper			Helper
     * 
     */
	createEpicRecord : function(component, event, helper) {
       // var btn = event.getSource();
       // btn.set('v.disabled', true);
//        var action = component.get("c.UpdateDoNotSendFlag");    
        var action = component.get("c.createNewEpicRecord");    
        console.log('createNewEpicRecord called')
        var caseID = component.get("v.recordId");
        action.setParams({"caseID":caseID});
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                helper.showToast('Success', 'Record saved to Epic', 'success');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();                
                // testing--raymond tam
				var retVal = response.getReturnValue();
            } else {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast('Error', message, 'error');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
          //  btn.set('v.disabled', false);
        });
        
        $A.enqueueAction(action);
	},

    /*
     * Cancel  a record.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */
	cancelRecord: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    doInit: function(component, event, helper){
        //Disables Create Epic MRN button and checks to see if all required fields are covered 01/20/2022 LK
        var disableButton = true;
        var action = component.get("c.verifyCreateEpicMRNButton");

        var caseID = component.get("v.recordId");
        action.setParams({"caseID":caseID});
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === "SUCCESS"){
                disableButton = response.getReturnValue();
                let button = component.find('createEpicButton');
                button.set('v.disabled',disableButton);
                
            } else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
        

        
        //var action = cmp.get("c.verifyCreateEpicMRNButton");
        //action.setParams({caseId:CaseId});
        
	},
    
    validate: function(component, event, helper){
        component.set('v.callServer',true)
        var action = component.get("c.ValidateForms");
        action.setParams({ caseRecord : component.get("v.recordId"),
                          saveAll : 'saveAll'});
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.callServer',false);
            
            if (state === "SUCCESS") {
                console.log('response',JSON.parse(response.getReturnValue()));
                var mapData = JSON.parse(response.getReturnValue());
                if(mapData.isError == true){
                    helper.showErrorToast(component,event,"Forms have errors, please review Patient Checklist");
                    component.set('v.showErrorMessage','Review and confirm New Patient Checklist to create MRN');
                }else{
                    helper.showSuccessToast('No Errors');
                    component.set('v.showErrorMessage','');
                    var createEpicRecord = component.get('c.createEpicRecord');
                    $A.enqueueAction(createEpicRecord);
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
    
})