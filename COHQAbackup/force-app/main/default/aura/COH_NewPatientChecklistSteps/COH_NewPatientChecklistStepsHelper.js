({
    "onload" : function(cmp,helper,showToast) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        console.log('case record',JSON.parse(JSON.stringify(cmp.get("v.mCase"))))
        var action = cmp.get("c.ValidateForms");
        action.setParams({ caseRecord : cmp.get("v.mCase").Id,
                          saveAll : 'onload'});

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('RESPONSE',JSON.parse(response.getReturnValue()));
                var errorMessages = JSON.parse(response.getReturnValue());
                
                cmp.set('v.mCase',errorMessages.Case);
                cmp.set('v.formValidation',true);
                cmp.set('v.formErrorMessages',errorMessages.errorMessages );
                if(errorMessages.errorMessages.clinicalInfo && errorMessages.errorMessages.clinicalInfo.length>0){
                    cmp.set('v.messageClinicalInfo',errorMessages.errorMessages.clinicalInfo );
                }else{
                    cmp.set('v.messageClinicalInfo',[])
                    cmp.set('v.clinicalCheck',true);
                }
                if(errorMessages.errorMessages.appointmentInformation && errorMessages.errorMessages.appointmentInformation.length>0){
                    cmp.set('v.messageApplicationInfo',errorMessages.errorMessages.appointmentInformation );
                }else{
                    cmp.set('v.messageApplicationInfo',[])
                    cmp.set('v.appointmentCheck',true);
                    
                }
            
                if(errorMessages.errorMessages.insuranceMatrix && errorMessages.errorMessages.insuranceMatrix.length>0){
                    cmp.set('v.schCheckInfo',errorMessages.errorMessages.insuranceMatrix );
                }else{
                    cmp.set('v.schCheckInfo',[])
                    cmp.set('v.schCheck',true);
                }
                
                if(errorMessages.errorMessages.newPatientConsenting  && errorMessages.errorMessages.newPatientConsenting.length>0){
                    cmp.set('v.newPatientConsenting',errorMessages.errorMessages.newPatientConsenting );
                }else{
                    cmp.set('v.newPatientConsenting',[])
                    cmp.set('v.newPatientConsentingcheck',true);
                }
                if(errorMessages.errorMessages.cohepicmrn  && errorMessages.errorMessages.cohepicmrn.length>0){
                    cmp.set('v.cohepicmrn',errorMessages.errorMessages.cohepicmrn );
                }else{
                   cmp.set('v.cohepicmrn',[])
                    cmp.set('v.cohepicmrncheck',true);
                }
                
                if(showToast)
                helper.showToast(cmp)
                // Alert the user with the value returned 
                // from the server
               // alert("From server: " + response.getReturnValue());

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
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
    },
    
    showToast : function(component) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "Please check the Patient Checklist"
    });
    toastEvent.fire();
}
})