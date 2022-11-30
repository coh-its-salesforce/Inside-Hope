({
	
    doInit : function(component, event, helper) {
        console.log('QWERTYUIO');
        
        helper.onload(component,helper,false);
        
        var channel = '/event/Save_Record__e';
        const replayId = -1;
         
        const empApi = component.find("empApi");
         var compData = component;
        //A callback function that's invoked for every event received
        const callback = function (message) {
            var msg = message.data.payload;
            //console.log('msg = ',JSON.stringify(msg));
            var errorMessages = JSON.parse(msg.Error_Message__c);
            console.log('Message returned : ',errorMessages.errorMessages );
            component.set('v.formValidation',true);
            component.set('v.formErrorMessages',errorMessages.errorMessages );
            
            if(errorMessages.errorMessages.clinicalInfo && errorMessages.errorMessages.clinicalInfo.length>0){
                component.set('v.messageClinicalInfo',errorMessages.errorMessages.clinicalInfo );
            }else{
                component.set('v.messageClinicalInfo',[]);
                component.set('v.clinicalCheck',true);
            }
            if(errorMessages.errorMessages.appointmentInformation && errorMessages.errorMessages.appointmentInformation.length>0){
                component.set('v.messageApplicationInfo',errorMessages.errorMessages.appointmentInformation );
            }else{
                component.set('v.messageApplicationInfo',[]);
                component.set('v.appointmentCheck',true);
                
            }
            
            if(errorMessages.errorMessages.insuranceMatrix && errorMessages.errorMessages.insuranceMatrix.length>0){
                component.set('v.schCheckInfo',errorMessages.errorMessages.insuranceMatrix );
            }else{
                component.set('v.schCheckInfo',[]);
                component.set('v.schCheck',true);
            }
            if(errorMessages.errorMessages.newPatientConsenting  && errorMessages.errorMessages.newPatientConsenting.length>0){
                component.set('v.newPatientConsenting',errorMessages.errorMessages.newPatientConsenting );
            }else{
                component.set('v.newPatientConsenting',[]);
                component.set('v.newPatientConsentingcheck',true);
            }
            if(errorMessages.errorMessages.cohepicmrn  && errorMessages.errorMessages.cohepicmrn.length>0){
                component.set('v.cohepicmrn',errorMessages.errorMessages.cohepicmrn );
            }else{
                component.set('v.cohepicmrn',[]);
                component.set('v.cohepicmrncheck',true);
            }
            
            
            //component.set('v.errorData',JSON.parse(msg.Error_Message__c).errorMessages.clinicalInfo[0])
             //console.log('MESSAGE',component.get('v.errorData'))
            //fire toast message
            
        };
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            //console.log("Subscribed to channel 1" + channel);
        });
        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };
        //A callback function that's called when an error response is received from the server for the handshake, connect, subscribe, and unsubscribe meta channels.
        empApi.onError(errorHandler);  
            
    },
    handleSectionToggle : function(component, event, helper) {
		
	},
    handleClick : function (cmp, event, helper) {
         helper.onload(cmp,helper,true);
    }
})