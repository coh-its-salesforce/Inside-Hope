({
    /*
     * Initialize the tab by invoking initCOHCaseAppointmentCancelationTabServer method
     * If the Server side returns SUCCESS, set the values of various components.
     * 
     * @param component		The component
     * @param helper		The helper
     * 
     */
    initCOHCaseApptCancelationTabClient : function (component, helper) {
        var action = component.get('c.initCOHCaseAppointmentCancelationInfoTabServer');
        var recordID = component.get('v.recordId');
        action.setParams({recordId:recordID});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var caseRecord = response.getReturnValue().Case;

                if (caseRecord) {
                    component.set('v.mCase', caseRecord);
                    
                    // Set the select list values. If there is no value, set it to an empty string because Lightning doesn't interpret null
                    // strings correctly in the cmp file.
                    component.set('v.mApptStatusVal', caseRecord.Appt_Status__c == null ? '' : caseRecord.Appt_Status__c);
                    component.set('v.mApptStatusInitialVal', caseRecord.Appt_Status__c);
                    component.set('v.mApptCancelationReasonVal', caseRecord.Appt_Cancelation_Reason__c == null ? '' : caseRecord.Appt_Cancelation_Reason__c); 
                    component.set('v.mApptRescheduledVal', caseRecord.Appt_Rescheduled__c == null ? '' : caseRecord.Appt_Rescheduled__c);
                    component.set('v.mApptResultConfirmationCallVal', caseRecord.Appt_Result_of_Confirmation_Call__c == null ? '' : caseRecord.Appt_Result_of_Confirmation_Call__c);

                    // For the picklists
                    component.set('v.mApptStatus', response.getReturnValue().mApptStatus);									
                    component.set('v.mApptCancelationReason', response.getReturnValue().mApptCancelationReason);
                    component.set('v.mApptRescheduled', response.getReturnValue().mApptReschedule);
                    component.set('v.mApptResultConfirmationCall', response.getReturnValue().mApptResultConfirmationStatus);

                    var firstName = response.getReturnValue().mCanceledByFirstName;
                    var lastName = response.getReturnValue().mCanceledByLastName;
                    if (caseRecord.Appt_Canceled_By__c == null || caseRecord.Appt_Canceled_By__c == 'undefined') {
	                    component.set('v.mApptCanceledByVal', null);
                    } else {
	                    component.set('v.mApptCanceledByVal', firstName + ' ' + lastName);
                    }

                    var isCancelationAuthorized = response.getReturnValue().mIsCancelationAuthorized;
                    if (isCancelationAuthorized == true) {
                        component.set('v.mIsCancelationAuthorizedVal', true);
                    } else {
                        component.set('v.mIsCancelationAuthorizedVal', false);
                    }
                    
                    var otherReason = caseRecord.Appt_Cancelation_Reason_Other__c;
                    var cancelOtherReasonComp = component.find('Appt_Cancelation_Reason_Other__c');
                    cancelOtherReasonComp.set('v.value', otherReason);     
                    
                    // Lightning does not handle null values well

                    if (otherReason == null || otherReason.length == 0 || otherReason == 'undefined') {
                    	component.set('v.mOtherReasonSelected', false);    
                    } else {
                        component.set('v.mOtherReasonSelected', true);    
                    }
                    
                    // If the value is null, set the component to an empty string because null isn't recognized correctly
                    // in the cmp file.
                    if (caseRecord.Patient_Offered_Appointment__c == null) {
						component.set('v.mPatientOfferedAppointmentVal', '');
                    }  else {
                        component.set('v.mPatientOfferedAppointmentVal', Patient_Offered_Appointment__c);
                    }      
                    
                    component.set('v.mNotifyLeadershipVal', caseRecord.Appt_Notify_Leadership__c);
                    component.set('v.mNotifyLeadershipInitialVal', caseRecord.Appt_Notify_Leadership__c);
                }
            } else  {
                this.showToast('Initialization Error', 'error', 'COHCaseAppointmentCancelizationHelper.initCOHCaseAppointmentCancelationTabClient encountered this response state: ' + responseState);
                $A.get('e.force:refreshView').fire();
	            return;
            }

        });
        
        
        $A.enqueueAction(action);
    },

    /*
     * Save the case information by invoking the saveCOHCaseAppointmentCancelationInfoTabServer method.  
     * The recordis saved via an Apex class because the component is not a lightning:editform.
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component		The component
     * @param event			The event
     * @param helper		The helper
     * 
     */ 
    saveCOHCaseAppointmentCancelationTabClient : function (component, event, helper) {

        var caseRecord = component.get('v.mCase');
        
		// Validating required fields
		 
        var apptStatusComp = component.find('mApptStatusList');
        var apptStatusCompVal = apptStatusComp.get('v.value');
        var rescheduleComp = component.find('mApptRescheduledList');
        var rescheduleCompVal = rescheduleComp.get('v.value');
        var cancelationEmailSentComp = component.find('Appt_Cancelation_Email_Sent__c');
        var cancelationEmailSentCompVal = cancelationEmailSentComp.get('v.value');
		var initialApptStatus = component.get('v.mApptStatusInitialVal');

        if (apptStatusCompVal == 'Canceled') {
            // Verify that the user has permission to cancel the appointment
	        var isCancelationAuthorized = component.get('v.mIsCancelationAuthorizedVal');
            if (initialApptStatus != 'Canceled' && isCancelationAuthorized != true) {
                this.showToast("Error: Appointment Cancelation/No Show Information Not Saved", "error", "User is not authorized to cancel appointments");
                return;
            }
            
            var cancelationDateComp = component.find('Appt_Cancelation_Date__c');
            var cancelationDateCompVal = cancelationDateComp.get('v.value');
            if (cancelationDateCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component,  'A value must be entered for the \'Cancelation Date\' field');
	            return;
            }
            if (rescheduleCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Did Patient Reschedule?\' field');
	            return;
            }
            if (cancelationEmailSentCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Cancelation Email Sent Date\' field');
	            return;
            }
        } else if (apptStatusCompVal == 'No Show') {
            var callDateComp = component.find('Appt_Call_Date__c');
            var callDateCompVal = callDateComp.get('v.value');
            if (callDateCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Call Date\' field');
	            return;
            }
            if (rescheduleCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Did Patient Reschedule?\' field');
	            return;
            }
        }
        
        var apptNewDatetimeComp = component.find('Appt_New_DateTime__c');
        var apptNewDatetimeCompVal = apptNewDatetimeComp.get('v.value');
        var confirmEmailComp = component.find('Appt_Confirm_Email_Sent__c');
        var confirmEmailCompVal = confirmEmailComp.get('v.value');
        var confirmCallComp = component.find('Appt_Confirmation_Call_Completed__c');
        var confirmCallCompVal = confirmCallComp.get('v.value');
        var confirmResultComp = component.find('mApptResultConfirmationCallList');
        var confirmResultCompVal = confirmResultComp.get('v.value');
        var cancelReasonComp = component.find('mApptCancelationReasonList');
        var cancelReasonCompVal = cancelReasonComp.get('v.value');
        
        if (rescheduleCompVal == 'Yes') {
            if (apptNewDatetimeCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'New Appt. Date and Time\' field');
	            return;
            }
            if (confirmEmailCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'New Confirmation Email Sent\' field');
	            return;
            }
            if (confirmCallCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'New Confirmation Call Completed\' field');
	            return;
            }
            if (confirmResultCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Result of Confirmation Call\' field');
	            return;
            }
            if (confirmResultCompVal == null) {
                helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Result of Confirmation Call\' field');
	            return;
            }
            
        }
        
        var cancelOtherReasonComp = component.find('Appt_Cancelation_Reason_Other__c');
        var cancelOtherReasonCompVal = cancelOtherReasonComp.get('v.value');     
        if (cancelReasonCompVal == 'Other' && (cancelOtherReasonCompVal == null || cancelOtherReasonCompVal.length == 0)) {
            helper.saveMissingRequiredFieldHandler(component, 'A value must be entered for the \'Other Reason\' field');
            return;
        }
        caseRecord.Appt_Cancelation_Reason_Other__c = cancelOtherReasonCompVal;
        caseRecord.Appt_Notify_Leadership__c = component.get('v.mNotifyLeadershipVal');
        
        var notifyLeadershipVal = null;
        var initialNotifyLeadership =  component.get('v.mNotifyLeadershipInitialVal');
        if (initialNotifyLeadership != true && caseRecord.Appt_Notify_Leadership__c == true) {
            notifyLeadershipVal = true;
        } else {
            notifyLeadershipVal = false;
        }
        
        caseRecord.Appt_Status__c = this.mapPicklistResponse(apptStatusCompVal);
        caseRecord.Appt_Cancelation_Reason__c = this.mapPicklistResponse(cancelReasonCompVal);
        caseRecord.Appt_Rescheduled__c = this.mapPicklistResponse(rescheduleCompVal);
        caseRecord.Appt_Result_of_Confirmation_Call__c = this.mapPicklistResponse(confirmResultCompVal);
        
        var action = component.get('c.saveCOHCaseAppointmentCancelationInfoTabServer');
        action.setParams({'caseRecord' : caseRecord, 'initialApptStatus' : initialApptStatus, 'notifyLeadership' : notifyLeadershipVal});
        
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                component.set("v.mLoading", false);
                var processingCode = response.getReturnValue().ProcessingCode;
                if (processingCode == 'Success') {
                    component.set('v.mApptStatusInitialVal', caseRecord.Appt_Status__c);
                    component.set('v.mApptCanceledByVal', response.getReturnValue().CanceledByUserName);
					component.set('v.mNotifyLeadershipInitialVal', caseRecord.Appt_Notify_Leadership__c);
                    this.showToast("Appointment Cancelation/No Show Information Saved", "success", "The record has been updated successfully.");
                } 
               $A.get('e.force:refreshView').fire();
            } else {
                component.set("v.mLoading", false);
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }     
                this.showToast("Error: Appointment Cancelation/No Show Information Not Saved", "error", "responseState: " + responseState + ". An error occurred while attempting to save the record: " + message);
            }
             var appEvent = $A.get("e.c:announceErrors"); 
            appEvent.setParams({"message" : 'Cancelation',
                                "formName" : 'Cancelation'}); 
            appEvent.fire(); 
        });        
        $A.enqueueAction(action);

    },    
    
    /*
     * Handle changes in the appointment status.
     * 
     * @param component		The component
     * @param helper		The helper
     * 
     */ 
    onApptStatusChangeClient : function (component, helper) {
        
        // All rescheduling fields need to be cleared
        var apptNewDatetimeComp = component.find('Appt_New_DateTime__c');
        var confirmEmailComp = component.find('Appt_Confirm_Email_Sent__c');
        var confirmCallComp = component.find('Appt_Confirmation_Call_Completed__c');
        var confirmResultComp = component.find('mApptResultConfirmationCallList');
        var cancelReasonComp = component.find('mApptCancelationReasonList');
        
        apptNewDatetimeComp.set('v.disabled', true);        
        confirmEmailComp.set('v.disabled', true);        
        confirmCallComp.set('v.disabled', true);        
        confirmResultComp.set('v.disabled', true);        

        var cancelationDateComp = component.find('Appt_Cancelation_Date__c');
        var callDateComp = component.find('Appt_Call_Date__c');
        var rescheduleComp = component.find('mApptRescheduledList');
        var cancelationEmailSentComp = component.find('Appt_Cancelation_Email_Sent__c');
        var canceledByComp = component.find('Appt_Canceled_By__c');
		var statusVal = component.get('v.mApptStatusVal');
        
        if (statusVal == 'Canceled') {
			// Enable cancelation date. It's required, so check it when saving.
	        cancelationDateComp.set('v.disabled', false);        
	        callDateComp.set('v.disabled', true);        
	        callDateComp.set('v.value', null);        
            rescheduleComp.set('v.disabled', false);
            rescheduleComp.set('v.value', null);        
            cancelationEmailSentComp.set('v.disabled', false); 
            canceledByComp.set('v.disabled', false); 
            cancelReasonComp.set('v.disabled', false); 
        } else {
	        cancelationDateComp.set('v.disabled', true);        
            cancelationDateComp.set('v.value', null);        
	        rescheduleComp.set('v.disabled', false);        
 	        rescheduleComp.set('v.value', null);        
            canceledByComp.set('v.disabled', true); 
            canceledByComp.set('v.value', null);   
            cancelReasonComp.set('v.value', null);            
            cancelationEmailSentComp.set('v.disabled', true); 
            cancelationEmailSentComp.set('v.value', null);  
            if (statusVal == 'No Show') {
                // Enable call date. It's required, so check it when saving.
                callDateComp.set('v.disabled', false); 
                cancelReasonComp.set('v.disabled', false); 
            } else {
		        var notifyLeadershipComp = component.find('mNotifyLeadership');
                notifyLeadershipComp.set('v.disabled', true); 
                callDateComp.set('v.disabled', true); 
                callDateComp.set('v.value', null);   
	            cancelReasonComp.set('v.disabled', true); 
            }
        }

        var cancelOtherReasonComp = component.find('Appt_Cancelation_Reason_Other__c');
        cancelOtherReasonComp.set('v.disabled', true);
        cancelOtherReasonComp.set('v.value', null);        
        apptNewDatetimeComp.set('v.value', null);
        confirmEmailComp.set('v.value', null);
        confirmCallComp.set('v.value', null);
        confirmResultComp.set('v.value', null);
        component.set('v.mNotifyLeadershipVal', null);
    },
    
    /*
     * Handle changes when the patient is rescheduled.
     * 
     * @param component		The component
     * @param helper		The helper
     * 
     */ 
    onPatientRescheduleChangeClient : function (component, helper) {
        var apptNewDatetimeComp = component.find('Appt_New_DateTime__c');
        var confirmEmailComp = component.find('Appt_Confirm_Email_Sent__c');
        var confirmCallComp = component.find('Appt_Confirmation_Call_Completed__c');
        var confirmResultComp = component.find('mApptResultConfirmationCallList');
        
		var reschedVal = component.get('v.mApptRescheduledVal');
        if (reschedVal == 'Yes') {
            apptNewDatetimeComp.set('v.disabled', false);        
            confirmEmailComp.set('v.disabled', false);        
            confirmCallComp.set('v.disabled', false);        
            confirmResultComp.set('v.disabled', false);   
        } else {
            apptNewDatetimeComp.set('v.disabled', true);        
            confirmEmailComp.set('v.disabled', true);        
            confirmCallComp.set('v.disabled', true);        
            confirmResultComp.set('v.disabled', true);        
            apptNewDatetimeComp.set('v.value', null);
            confirmEmailComp.set('v.value', null);
            confirmCallComp.set('v.value', null);
            confirmResultComp.set('v.value', null);
        }
    },

    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },    
    
    /*
     * Handle missing field errors while saving the record.
     * @param component		The component
     * @param message		Message contents
     *
     */ 
    saveMissingRequiredFieldHandler : function(component,  message) {
        component.set("v.mLoading", false);
        this.showToast('Appointment Cancelation/No Show Information Not Saved', 'error', message);
        $A.get('e.force:refreshView').fire();        
    },
    
    /*
     * Map picklist response values to store in a Yes/No picklist .
     * @param originalVal		Values chosen by the user.
     * @return							'Yes' if  the value is chose, 'No' if it is not, and null otherwise.
     *
     */ 
    mapPicklistResponse : function(originalVal) {
        if (originalVal == null || originalVal == '--None--')  {
            return null;
        } else {
            return originalVal;
        }
    },
    
    /*
     * Invoke the e.force:showToast event
     * @param title			Message title.
     * @param type			Message type.
     * @param message		Message contents.
     *
     */ 
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    }
    
})