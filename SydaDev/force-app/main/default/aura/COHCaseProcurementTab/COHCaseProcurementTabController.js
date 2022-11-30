({
    /*
     * Method called when the Record Edit Form is done loading
     */ 
    onRecordEditFormLoad : function(component, event, helper) {
        component.set('v.mLoading', false);
      },
    
    /*
     * Method called to handle the init event for the component
     */ 
    init : function(component, event, helper) {
        $A.enqueueAction(component.get('c.subscribePlatform'));
        helper.initCOHCaseProcurementTabClient(component);
        //helper.handleApplicationEvent(component);
    },
    
    /*
     * Handles changes to the PRSSpecialist_Assignment field. If it has changed to a non-empty value, the mDatePRSSpecialistAssignedVal
     * field is popluated.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper.
     * 
     */ 
    onPRSSpecialistAssignmentChange : function(component, event, helper) {
        var curPRSpecialist = component.get('v.mCurPRSpecialist');
        var dateAssignedComp = component.find('Date_PRS_Specialist_Is_Assigned__c');
        var newDateTime = $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDTkk:mm:ssZ");
        //var newDateTime = $A.localizationService.formatDateTime(new DateTime(), "YYYY-MM-DDTkk:mm:ssZ");
        var newPRSpecialistComp = component.find('PRSpecialist_Assignment__c');
        var newPRSpecialistVal = newPRSpecialistComp.get('v.value');
        //dateAssignedComp.set / v.value is the temporary placeholder value.
        
          
        if(newPRSpecialistVal != curPRSpecialist){
            dateAssignedComp.set('v.value', newDateTime);
        }
        
        if (newPRSpecialistVal == null || newPRSpecialistVal == '') {
            dateAssignedComp.set('v.value', null);
        }
    },
   
      onPhiValuesChange : function(component, event, helper) {
        var hasPhiValuesChnaged = component.get("v.mPhiReceievedlstVal");
        if (hasPhiValuesChnaged != "Yes"){
            component.set("v.mPhiReceievedlstVal",component.get("v.mPhiReceievedlstVal"));
            component.set("v.mPhiUploadedtoeHealthvVal",component.get("v.mPhiUploadedtoeHealthvVal"));
           
        }
    }, 
	
	   onConfirmedUploadedeHealthChnage : function(component, event, helper) {
        var hasPhiValuesChnaged = component.get("v.mPhiUploadedtoeHealthvVal");    
        if (hasPhiValuesChnaged != "Yes"){
            component.set("v.mPhiUploadedtoeHealthvVal",component.get("v.mPhiUploadedtoeHealthvVal"));
            
        }
    },
  
     onPatienteHandedofftoeHealthChange : function(component, event, helper) {
        var patienteHealth = component.get('v.mPatienteHealthTemplate');
        var dateAssignedComp = component.find('mPatienteHealthTemplateSubmitted');
        var newDate = $A.localizationService.formatDate(new Date(),"YYYY-MM-DD");
        var newPRSpecialistComp = component.find('mPatienteHandedofftoeHealth');
        var newPRSpecialistVal = newPRSpecialistComp.get('v.value');
                 
        if(newPRSpecialistVal != patienteHealth){
            dateAssignedComp.set('v.value', newDate);
        }
         
        if (newPRSpecialistVal == null || newPRSpecialistVal == '' || newPRSpecialistVal == 'No' || newPRSpecialistVal == 'Patient Declined') {
            dateAssignedComp.set('v.value', null);
        }
      },
    
     onPathologySlidesNeededChange : function(component, event, helper) {
        var pathologySlides = component.get('v.mPathologySlidesNeeded');
        var dateAssignedComp = component.find('mPatientePathologyReqEntered');
        var newDate = $A.localizationService.formatDate(new Date(),"YYYY-MM-DD");
        var newPatientePathologySlidesComp = component.find('mPatientePathologySlidesNeeded');
        var newpathologySlidesVal = newPatientePathologySlidesComp.get('v.value');
                 
        if(newpathologySlidesVal != pathologySlides){
            dateAssignedComp.set('v.value', newDate);
        }
         
        if (newpathologySlidesVal == null || newpathologySlidesVal == '' || newpathologySlidesVal == 'No') {
            dateAssignedComp.set('v.value', null);
        }
      },
    
    onRADImagingNeededChange : function(component, event, helper) {
        var onRADImaging = component.get('v.mRADImagingNeeded');
        var dateAssignedComp = component.find('mPatienteAncillaryReqEntered');
        var newDate = $A.localizationService.formatDate(new Date(),"YYYY-MM-DD");
        var newPatienteAncillaryReqComp = component.find('mPatienteRADImagingNeeded');
        var newRADImagingVal = newPatienteAncillaryReqComp.get('v.value');
                 
        if(newRADImagingVal != onRADImaging){
            dateAssignedComp.set('v.value', newDate);
        }
         
        if (newRADImagingVal == null || newRADImagingVal == '' || newRADImagingVal == 'No') {
            dateAssignedComp.set('v.value', null);
        }
         
    },
    
    
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the "Procurement_Tab_Complete__c" field and then resubmits
     */ 
    saveProcurementClick : function(component, event, helper) {
        
        var allValid1 = [].concat(component.find('mPhiUploadedtoeHealth')).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        var allValid2 = [].concat(component.find('mPatienteHealthTemplateSubmitted')).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var allValid3 = [].concat(component.find('mPatientePathologyReqEntered')).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var allValid4 = [].concat(component.find('mPatienteAncillaryReqEntered')).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var allValid5 = [].concat(component.find('mPhiUploadedtoeHealth')).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if(allValid1 && allValid2 && allValid3 && allValid4 && allValid5){
            helper.saveProcurementTabServer(component, event, helper);
        }else{
            helper.showToast('Error', 'error', 'Please fill out all required fields');
        }
        
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
            if(msg.RecordId__c   == component.get('v.recordId')){
                $A.enqueueAction(component.get('c.saveProcurementClick'));
            }
            console.log('Message returned : ' +msg.Record_Id__c  );
            
            //fire toast message
           
        };
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to Appointment Tab" + channel);
        });
        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };
        //A callback function that's called when an error response is received from the server for the handshake, connect, subscribe, and unsubscribe meta channels.
        empApi.onError(errorHandler); 
    }

})