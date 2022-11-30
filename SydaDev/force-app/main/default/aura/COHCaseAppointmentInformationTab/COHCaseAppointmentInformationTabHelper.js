({
    /*
     * Method to call the saveCOHCaseAppointmentInfoTabServer method.  The record
     * is saved via an Apex class because the component is not a lightning:editform.
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
    
     * @param component						The component
     * @param helper						The helper
     * 
     */ 
    saveAppointmentInfoTabClient : function (component, event, helper, saveAll) {
        
        var caseRecord = component.get('v.mCase');
        var errorArray = [];
        
        var consentingStatus = component.get('v.consentingStatus');       
        if(consentingStatus == null || consentingStatus ==''){
            //component.set("v.mLoading", false);
            errorArray.push("'Consenting Status' is a required field.");
            //helper.showToast('Patient Appointment Information Not Saved', 'error',
            //               '\"Consenting Status\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            // return;
        }
        
        var consentingType = component.get('v.consentingType');       
        if(consentingType == null || consentingType ==''){
            errorArray.push("'Consenting Type' is a required field.");
            //component.set("v.mLoading", false);
            // helper.showToast('Patient Appointment Information Not Saved', 'error',
            //                  '\"Consenting Type\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            // return;
        }
        var visitTypePreference = component.get('v.visitTypePreference');       
        if(visitTypePreference == null || visitTypePreference ==''){
            errorArray.push("'Visit Type Preference?' is a required field.");
            //component.set("v.mLoading", false);
            // helper.showToast('Patient Appointment Information Not Saved', 'error',
            //                 '\"Visit Type Preference?\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            // return;
        }
        var requestedMD = component.get('v.requestedMD');       
        if(requestedMD == null || requestedMD ==''){
            errorArray.push("'Is Pt. Requesting a Specific MD?' is a required field.");
            //component.set("v.mLoading", false);
            //helper.showToast('Patient Appointment Information Not Saved', 'error',
            //                 '\"Is Pt. Requesting a Specific MD?\" is a required field.');
            
            // return;
        }
        
        var isSoonerAppt = component.get('v.isSoonerAppt');  
        var howmanyDays = component.get('v.howmanyDays'); 
        console.log("howmanyDays", howmanyDays);
        console.log("howmanyDays", isSoonerAppt=='');
        if(howmanyDays == '8+ Days' && (isSoonerAppt == null || isSoonerAppt =='') ){
            errorArray.push("'Does Pt want a sooner appt?' is a required field.");
            //component.set("v.mLoading", false);
            // helper.showToast('Patient Appointment Information Not Saved', 'error',
            //                 '\"Does Pt want a sooner appt?\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            // return;
        }
        
        if(errorArray.length>0 && component.get('v.mCase').Last_Appointment_Scheduled__c!=null){
            // {!v.mCase.Last_Appointment_Scheduled__c!=null}
            var errorMsg = '';
            for(var i = 0;i<errorArray.length;i++){
                errorMsg+=errorArray[i]+'\n';
            }
            
            //console.log('errorMsg',errorMsg)
            helper.showToast("Error: Patient Appointment Information Not Saved", "error", errorMsg);
            return;
        }
        
        if(saveAll){
            var appEvent = $A.get("e.c:announceErrors"); 
            appEvent.setParams({"message" : errorArray,
                                "formName" : 'Appointment Info'}); 
            appEvent.fire(); 
            
            
        }
        
        /*if(errorArray.length>0){
            var errorMsg = '';
            for(var i = 0;i<errorArray.length;i++){
                errorMsg+=errorArray[i]+'\n';
            }
            console.log('errorMsg',errorMsg);
            helper.showToast("Error: Patient Appointment Information Not Saved", "error", errorMsg);
            return;
        }*/
        
        var curCallCenterRep = caseRecord.OwnerId;
        
        
        var constArray = component.get('v.selectedSchedullingBarrier');//caseRecord.Type_of_Scheduling_Barriers_Select_All__c.split(";");
        var selLabel = '' ;
        for(var i =0 ;i<constArray.length;i++){
            selLabel = selLabel+constArray[i]+';'
        }
        if(selLabel!='')
            selLabel = selLabel.substring(0,selLabel.length-1);
        console.log('selLabel',selLabel);
        
        
        caseRecord.Type_of_Scheduling_Barriers_Select_All__c = selLabel;
        caseRecord.Is_patient_willing_to_do_Tele_Health_vis__c = component.get('v.willingToDoVisits');
        caseRecord.Does_the_patient_have_an_e_mail_address__c = component.get('v.patientEmailAddress');
        caseRecord.Does_patient_have_access_to_video_chat__c = component.get('v.haveVideoChatAccess');
        caseRecord.Virtual_Consenting_Eligibility__c = component.get('v.isEligible');
        caseRecord.Consenting_Status__c = component.get('v.consentingStatus');
        caseRecord.Consenting_Type__c = component.get('v.consentingType');
        caseRecord.Consenting_Appt_Date_Time__c = component.get('v.consentingAppt');
        
        caseRecord.Visit_Type_Preference__c = component.get('v.visitTypePreference');
        caseRecord.Is_Patient_Requesting_a_Specific_MD__c = component.get('v.requestedMD');
        caseRecord.Pt_Appt_is_Scheduled_in_how_many_days__c = component.get('v.howmanyDays');
        caseRecord.Does_Pt_want_a_sooner_appt__c = component.get('v.isSoonerAppt');
        console.log('SOONER PPT',component.get('v.isSoonerAppt'))
        
        
        //caseRecord.Location__c = component.get("v.locationVal"); //Changes Start: Added by Sanjay on 8/20/2021
        var action = component.get('c.saveCOHCaseAppointmentInfoTabServer');
        
        //  if (newCaseOwnerAPIName != null && newCaseOwnerAPIName != curCallCenterRep) {
        action.setParams({'updateTime' : component.get('v.updateTime'),'nullTime':component.get('v.nullTime'),'caseRecord' : caseRecord, 'newCaseOwnerAPIName' : null, 'reasonNotOffered' : null});
        
        
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                component.set("v.mLoading", false);
                var processingCode = response.getReturnValue().ProcessingCode;
                if (processingCode == 'Success') {
                    helper.showToast("Patient Appointment Information Saved", "success", "The record has been updated successfully.");
                    
                } else  if (processingCode == 'COH MRN Not Found') {
                    helper.showToast('Patient Appointment Information Not Saved', 'error', 'The record was not updated because a valid COH MRN was not provided.');
                }
                
                $A.get('e.force:refreshView').fire();
            } else if (responseState === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }     
                helper.showToast("Error: Patient Appointment Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
        });        
        $A.enqueueAction(action);
    },
    
    
    /*
     * Method to call the initCOHCaseAppointmentInformationTabServer method
     * If the Server side returns SUCCESS, set the values of various components.
     * 
     * @param component				The component
     * @param helper					The helper
     * 
     * 
     */
    initCOHCaseAppointmentInformationTabClient : function (component, helper) {
        
        console.log('INIT')
        var action = component.get('c.initCOHCaseAppointmentInformationTabServer');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            console.log('responseState',responseState)
            if (responseState == 'SUCCESS') {
                var caseRecord = response.getReturnValue().Case;
                console.log('caseRecord 1',caseRecord)
                if (caseRecord) {
                    console.log('caseRecord 2',caseRecord)
                    component.set('v.mCase', caseRecord);
                    /**** Changes made by sanjay- date : 04-07-2020 ***Start***/
                    component.set('v.videoEmailSent', caseRecord.Email_Video_Sent__c);
                    /**** Changes made by sanjay- date : 04-07-2020 ***End***/
                    
                    
                    component.set('v.willingToDoVisits',caseRecord.Is_patient_willing_to_do_Tele_Health_vis__c);
                    component.set('v.patientEmailAddress',caseRecord.Does_the_patient_have_an_e_mail_address__c);
                    component.set('v.haveVideoChatAccess',caseRecord.Does_patient_have_access_to_video_chat__c);
                    component.set('v.isEligible',caseRecord.Virtual_Consenting_Eligibility__c);
                    component.set('v.consentingType',caseRecord.Consenting_Type__c);
                    component.set('v.consentingStatus',caseRecord.Consenting_Status__c );
                    component.set('v.consentingAppt',caseRecord.Consenting_Appt_Date_Time__c);
                    component.set('v.visitTypePreference',caseRecord.Visit_Type_Preference__c);
                    component.set('v.requestedMD',caseRecord.Is_Patient_Requesting_a_Specific_MD__c );
                    component.set('v.howmanyDays',caseRecord.Pt_Appt_is_Scheduled_in_how_many_days__c)
                    component.set('v.isSoonerAppt',caseRecord.Does_Pt_want_a_sooner_appt__c);
                    
                    if(caseRecord.Type_of_Scheduling_Barriers_Select_All__c){
                        //selectedSchedullingBarrier
                        var constArray = caseRecord.Type_of_Scheduling_Barriers_Select_All__c.split(";");
                        
                        console.log('constArray',constArray);
                        component.set('v.selectedSchedullingBarrier',constArray)
                    }
                    
                    //Display Original Appt. Date and Time when it is different from Current. 
                    if(caseRecord.Original_Appointment__c != null){
                        if(caseRecord.Appt_Date_Time__c != caseRecord.Original_Appointment__r.Appointment_Date_Time__c){
                            component.set('v.diffAppt',true)
                        }
                    }
                    
                    
                }
            }
            else if (responseState === "ERROR") {
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
        
        
        $A.enqueueAction(action);
    },
    
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
            "mode":'dismissible',
            "duration" : '10000'
        });
        toastEvent.fire();
    },    
    
})