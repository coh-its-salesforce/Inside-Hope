({
    /*
     * Method called when the mPatientOfferedAppointment field changes value.
     */    
    /*onApptNotOfferedChange : function (component, event, helper) {
        helper.onApptNotOfferedChange(component, event, helper);
    },*/
    
    /*
     * Method called when the mPatientAppointmentNotOfferedReasonsList field changes value.
     */    
    /*onReasonApptNotOfferedChange : function (component, event, helper) {
        helper.onReasonApptNotOfferedChange(component, event, helper);
    },*/
    
    /*
     * Method called when the mPatientNeedAuthLOA field changes value.
     */    
    /*onPatientNeedAuthLOAChange : function (component, event, helper) {
        helper.onPatientNeedAuthLOAChange(component, event, helper);
    },*/
    
    /*
     * Update the Completed/Clinically Denied Reason field when the Patient Status is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    /* onPatientStatusChange : function (component, event, helper) {
        helper.onPatientStatusChangeClient(component, event, helper);
    },*/
    
    /*
     * Update the Status field when the Clinical Process Complete field is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    /*  onClinicalProcessCompleteChange : function (component, event, helper) {
        var caseRecord = component.get('v.mCase');
        var clinicalProcessComplete = caseRecord.Clinical_Process_Complete__c;
        var cohMRN = caseRecord.COH_MRN__c;
        if (clinicalProcessComplete == true && cohMRN != null && cohMRN != '') {
	        // Changes Start: Added by Sanjay on 6/16/2021 for Enterprise Access
            if(caseRecord.RecordType.DeveloperName == 'Enterprise_Access_New_Patient'){
                caseRecord.Status = 'PHI Form';  
            }else{
                caseRecord.Status = 'Records Procurement';
            }
            //Changes End: Added by Sanjay on 6/16/2021 
        } else {
	        caseRecord.Status = 'Registered';
        }
    },*/
    
    /*
     * Update the Status field when the Clinical Team Member Assigned field is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    /*  onClinicalTeamMemberAssignedChange : function (component, event, helper) {
        var caseRecord = component.get('v.mCase');
	    caseRecord.Status = 'Nursing Review';
    },*/
    
    /*
     * Method called when the Submit button is clicked
     */ 
    saveApptInfoClick : function(component, event, helper) {
        helper.saveAppointmentInfoTabClient(component, event, helper,true);
    },
    
    /*
     * Method called to handle the init event for the component
     */ 
    init : function (component, event, helper) {
        /*var appEvent = $A.get("e.c:initCount"); 
        appEvent.fire(); 
        console.log('INIT appointment1')*/
        $A.enqueueAction(component.get('c.subscribePlatform'));
        helper.initCOHCaseAppointmentInformationTabClient(component, helper);
        component.set('v.mLoading', false);
        
    },
    
    /*  handleSendEmailVideo:function(component, event, helper) {
        helper.sendVideoEmail(component,  helper)
    },*/
    
    telehealthScreeningChange:function(component, event, helper) {
        console.log(component.get('v.willingToDoVisits'))
        console.log(component.get('v.patientEmailAddress'))
        console.log(component.get('v.haveVideoChatAccess'))
        if(component.get('v.willingToDoVisits') == 'Yes'
           && component.get('v.patientEmailAddress') == 'Yes'
           && component.get('v.haveVideoChatAccess') == 'Yes') {
            component.set('v.isEligible','Eligible');
        }else{
            component.set('v.isEligible','Not Eligible');
            
        }
    },
    handleScheduleBarrier :function(component, event, helper) {
    },
    
    resetData : function(component, event, helper) {
        component.set('v.isSoonerAppt','');
    },
    resetScheduleBarrier : function(component, event, helper) {
        component.set('v.selectedSchedullingBarrier',[]);
        var caseObj = component.get('v.mCase');
        //Request to remove SmartPhase Sent? automation per Change Request document LK 04/11/2022
        /*if(component.get('v.isSoonerAppt') == 'Yes: No New Pt Slot Available*'){          
            caseObj['SmartPhrase_Sent__c'] = true;    
            component.set('v.nullTime',false)
        }else{
            caseObj['SmartPhrase_Sent__c'] = false;
            component.set('v.nullTime',true)
        }
        component.set('v.updateTime',true);*/
        /*if(caseObj['SmartPhrase_Sent__c'] = true){
            component.set('v.nullTime', false);
        } else {
            component.set('v.nullTime', true);
        }
        component.set('v.updateTime',true);
        caseObj['SmartPhrase_Outreach_Result__c'] = '';
        component.set('v.mCase',caseObj);*/
    },
    resetOutreachPicklist : function(component, event, helper) {
        var caseObj = component.get('v.mCase');
        caseObj['SmartPhrase_Outreach_Result__c'] = '';
        component.set('v.mCase',caseObj);
        component.set('v.updateTime',true);
        if(caseObj.SmartPhrase_Sent__c){
            component.set('v.nullTime',false)
        }else{
            component.set('v.nullTime',true)
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
                if(component.get('v.mCase').COH_MRN__c!=null){
                    helper.saveAppointmentInfoTabClient(component, event, helper,true);
                }
            }
            console.log('Message returned : ' +msg.RecordId__c  );
            
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