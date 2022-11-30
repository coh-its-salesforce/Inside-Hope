({
    /*
     * Intialize the component.
     */ 
    init : function (component, event, helper) {
          var appEvent = $A.get("e.c:initCount"); 
        appEvent.fire(); 
        $A.enqueueAction(component.get('c.subscribePlatform'));
        helper.initCOHCaseApptCancelationTabClient(component, helper);
		component.set('v.mLoading', false);
        //$A.get('e.force:refreshView').fire();
    },
    
    /*
     * Handle the clicking of the Submit button.
     */ 
    saveApptCancelationInfoClick : function(component, event, helper) {
        helper.saveCOHCaseAppointmentCancelationTabClient(component, event, helper,false);
    },
    
    /*
     * Handle changes in the appointment status.
     */ 
    onApptStatusChange : function (component, event, helper) {
        helper.onApptStatusChangeClient(component, helper);
		component.set('v.mLoading', false);
        $A.get('e.force:refreshView').fire();
    },
    
    /*
     * Handle changes in patient rescheduling.
     */
    onPatientRescheduleChange : function (component, event, helper) {
        helper.onPatientRescheduleChangeClient(component, helper);
		component.set('v.mLoading', false);
        $A.get('e.force:refreshView').fire();
    },
    
    /*
     * Handle changes in the cancelation reason
     */ 
    onCancelationReasonChange : function (component, event, helper) {
        var cancelOtherReasonComp = component.find('Appt_Cancelation_Reason_Other__c');
        var cancelOtherReasonCompVal = cancelOtherReasonComp.get('v.value');
        var cancelReasonComp = component.find('mApptCancelationReasonList');
        var cancelReasonCompVal = cancelReasonComp.get('v.value');
        if (cancelReasonCompVal == 'Other')  {
            cancelOtherReasonComp.set('v.disabled', false);
			component.set('v.mOtherReasonSelected', true);
        } else {
            cancelOtherReasonComp.set('v.disabled', true);
            cancelOtherReasonComp.set('v.value', null);
			component.set('v.mOtherReasonSelected', false);
        }
        
		component.set('v.mLoading', false);
        $A.get('e.force:refreshView').fire();
    },
     subscribePlatform: function (component,event,helper){
        var channel = '/event/Save_All__e';
        const replayId = -1;
        
        const empApi = component.find("empApi");
        
        //A callback function that's invoked for every event received
        const callback = function (message) {
            var msg = message.data.payload;
            console.log('msg = ',JSON.parse(JSON.stringify(msg)));
            // saveDiagnosisClick
            helper.saveCOHCaseAppointmentCancelationTabClient(component, event, helper,true);
            
            console.log('Message returned : ' ,msg.RecordId__c   );
            
            
        };
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to Clinical Info" + channel);
        });
        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };
        //A callback function that's called when an error response is received from the server for the handshake, connect, subscribe, and unsubscribe meta channels.
        empApi.onError(errorHandler); 
    }

    
    
})