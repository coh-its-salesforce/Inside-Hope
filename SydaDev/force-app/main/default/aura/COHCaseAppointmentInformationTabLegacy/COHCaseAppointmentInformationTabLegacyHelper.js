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
    saveAppointmentInfoTabClient : function (component, event, helper) {

        var caseRecord = component.get('v.mCase');
        
		// Validating required fields

        var patientNeedAuthLOAComp = component.find('mPatientNeedAuthLOA');
        var patientNeedAuthLOAVal = patientNeedAuthLOAComp.get('v.value');
        if (patientNeedAuthLOAVal == null || patientNeedAuthLOAVal == '') {
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Does Patient Need Auth/LOA?\" is a required field.');
            $A.get('e.force:refreshView').fire();
            return;
        }

        var patientRequestSpecificMDComp = component.find('mPatientRequestSpecificMD');
        var patientRequestSpecificMDVal = patientRequestSpecificMDComp.get('v.value');
        if (patientRequestSpecificMDVal == null || patientRequestSpecificMDVal == '') {
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Is Pt. Requesting A Specific MD?\" is a required field.');
            $A.get('e.force:refreshView').fire();
            return;
        }

        var offeredApptComp = component.find('mPatientOfferedAppointment');
        var offeredApptCompVal = offeredApptComp.get('v.value');
        if (offeredApptCompVal == 'No') {
	        var apptNotOfferedReasonComp = component.find('mPatientAppointmentNotOfferedReasonsList');
            var reasonNotOfferedVal = apptNotOfferedReasonComp.get('v.value');
            if (reasonNotOfferedVal == null || reasonNotOfferedVal == '') {
                component.set("v.mLoading", false);
                helper.showToast('Patient Appointment Information Not Saved', 'error', 'An appointment was not offered, but no reason was selected.');
                $A.get('e.force:refreshView').fire();
	            return;
            }
        }		
        
        var patientNeedAUthLOAVal = component.get('v.patientNeedAUthLOAVal');
        if (patientNeedAUthLOAVal = null || patientNeedAUthLOAVal == '') {
                component.set("v.mLoading", false);
                helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Does Patient Need Auth/LOA\" is a required field.');
                $A.get('e.force:refreshView').fire();
	            return;
        }
        
        var patientRequestSpecificMDVal = component.get('v.patientRequestSpecificMDVal');
        if (patientRequestSpecificMDVal = null || patientRequestSpecificMDVal == '') {
                component.set("v.mLoading", false);
                helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Is Pt. Requesting A Specific MD?\" is a required field.');
                $A.get('e.force:refreshView').fire();
	            return;
        }
        
        
        // Create a Map of True/False drop down values to their Boolean equivalent

        var selectListMap = {};
        
        var selectListComp = component.find('mPatientRegistered');
        var selectListVal = selectListComp.get('v.value');
        selectListMap['mPatientRegistered']  =  (selectListVal == 'true' ? true : false);
        selectListComp = component.find('mPatientScheduledFirstCall');
        selectListVal = selectListComp.get('v.value');
        selectListMap['mPatientScheduledFirstCall']  =  (selectListVal == 'true' ? true : false);
        selectListComp = component.find('mReachedOutToMDToReschedule');
        selectListVal = selectListComp.get('v.value');

        caseRecord.Decline_to_move_up_appt__c = this.mapPicklistResponse(component.get('v.mMDDeclinedToMoveUpApptVal'));
		caseRecord.Patient_Status_Case__c = component.get('v.mPatientStatusVal');
        
		var reasonNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reasonNotOfferedVal = reasonNotOfferedComp.get('v.value');
		var newCallCenterRepComp = component.find('mClinicalTeamMembersList');
        var newCaseOwnerAPIName = newCallCenterRepComp.get('v.value');
		var curCallCenterRep = caseRecord.OwnerId;
        
        caseRecord.Patient_Offered_Appointment__c = offeredApptCompVal;
        var authNeededVal = null;
		var authNeededCompVal = component.get('v.mPatientNeedAuthLOAVal');
        if (authNeededCompVal == 'Yes') { 
            authNeededVal = true;
        } else if (authNeededCompVal == 'No') {
            authNeededVal = false;
        }
        caseRecord.Auth_Needed__c = authNeededVal;
            
        var specificMDCompVal = component.get('v.mPatientRequestSpecificMDVal');
        caseRecord.Is_Patient_Requesting_a_Specific_MD__c = (specificMDCompVal == '' ? null : specificMDCompVal);

        var patOfferedApptVal = component.get('v.mPatientOfferedAppointmentVal');
		caseRecord.Patient_Offered_Appointment__c = (patOfferedApptVal == '' ? null : patOfferedApptVal); 
        
        var reachedOutToMDVal = component.get('v.mReachedOutToMDToRescheduleVal');
        caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c = (reachedOutToMDVal == '' ? null : reachedOutToMDVal);
        
        var action = component.get('c.saveCOHCaseAppointmentInfoTabServer');
        
        if (newCaseOwnerAPIName != null && newCaseOwnerAPIName != curCallCenterRep) {
            action.setParams({'caseRecord' : caseRecord, 'newCaseOwnerAPIName' : newCaseOwnerAPIName, 'reasonNotOffered' : reasonNotOfferedVal, 'selectListMap' : selectListMap});
            component.set('v.mCurrentCaseOwnerVal', newCaseOwnerAPIName );
        } else {
	        action.setParams({'caseRecord' : caseRecord, 'newCaseOwnerAPIName' :  null,  'reasonNotOffered' : reasonNotOfferedVal, 'selectListMap' : selectListMap});
        }
        
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
    
    sendVideoEmail : function (component, helper) {
    	 var action = component.get('c.sendVideoEmail');
       	 var recordId = component.get('v.recordId');
    	 action.setParams({recordId:recordId});
         action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var response = response.getReturnValue();
                var issuccess = response.issuccess;
                var message = response.message;
                if(issuccess)
                	component.set('v.videoEmailSent', true);
                helper.showToast(issuccess? 'Success': 'Error', issuccess? 'success': 'error', message);
                $A.get('e.force:refreshView').fire();
            }else{
                helper.showToast('Error', 'error', 'There has some error occured in background, Please contact system administrator.');
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

        var action = component.get('c.initCOHCaseAppointmentInformationTabServer');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var caseRecord = response.getReturnValue().Case;
                
                if (caseRecord) {
                    component.set('v.mCase', caseRecord);
                    /**** Changes made by sanjay- date : 04-07-2020 ***Start***/
                    component.set('v.videoEmailSent', caseRecord.Email_Video_Sent__c);
                    /**** Changes made by sanjay- date : 04-07-2020 ***End***/
                    
                    // Set the select list values
                    component.set('v.mPatientRegistered', response.getReturnValue().mPatientRegistered);
                    component.set('v.mPatientScheduledFirstCall', response.getReturnValue().mPatientScheduledFirstCall);
                    component.set('v.mPatientAppointmentNotOfferedReasons', response.getReturnValue().mPatientAppointmentNotOfferedReasons);
                    component.set('v.mClinicalTeamMembers', response.getReturnValue().ClinicalTeamMembers);
                    component.set('v.mCurrentCaseOwnerVal', caseRecord.Clinical_Team_Member_Assignment__c);
                    
                    var apptNotOfferedReasonComp = component.find('mPatientAppointmentNotOfferedReasonsList');
                    //Abhishek commented code Nov 21 to enable the reason dropdown even when yes is selected for the dependent dropdown
                    //apptNotOfferedReasonComp.set("v.disabled",(originalVal == true ? true : false));

                    var patientStatus = caseRecord.Patient_Status_Case__c;
        			var cohMRN = caseRecord.COH_MRN__c;
                    if (patientStatus == null || patientStatus == '') {
                        patientStatus = 'New';
                    }
                  
                    component.set('v.mPatientStatusVal', patientStatus);				// For the actual value
                    component.set('v.mPatientStatus', response.getReturnValue().PatientStatus);					// For the picklist
					component.set('v.mClinicallyCompletedDeniedReasonVal', caseRecord.Completed_Clinically_Denied_Reason__c);		// For the actual value
					component.set('v.mCompletedClinicallyDeniedReasons', response.getReturnValue().ClinicallyDeniedReasons);			// For the picklist                    
                    component.set('v.mMDDeclinedToMoveUpAppt', response.getReturnValue().mMDDeclinedToMoveUpAppt);
                    component.set('v.mMDDeclinedToMoveUpApptVal', caseRecord.Decline_to_move_up_appt__c == null ? '' : caseRecord.Decline_to_move_up_appt__c);
                    component.set('v.mPatientRequestSpecificMDVal', caseRecord.Is_Patient_Requesting_a_Specific_MD__c == null ? '' : caseRecord.Is_Patient_Requesting_a_Specific_MD__c);
                    component.set('v.mReachedOutToMDToRescheduleVal', caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c == null ? '' : caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c);
                    component.set('v.mPatientOfferedAppointmentVal', caseRecord.Patient_Offered_Appointment__c == null ? '' : caseRecord.Patient_Offered_Appointment__c);
                    component.set('v.mPatientAppointmentNotOfferedReasonsVal', caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c == null ? '' : caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c);
                    var authNeededVal = null;
                    if (caseRecord.Auth_Needed__c  == true) { 
                        authNeededVal = 'Yes';
                    } else if (caseRecord.Auth_Needed__c == false) {
                        authNeededVal = 'No';
                    }
                    component.set('v.mPatientNeedAuthLOAVal', authNeededVal);
            
                	this.handleAuthLOA(component, caseRecord.Auth_Needed__c, true);
                }
            }
        });
        
        
        $A.enqueueAction(action);
    },

    /*
     * Handle the set logic for Auth/LOA needed.
     * @param component				Component
     * @param authLOANeeded			True if Auth/LOA needed, false otherwise.
     * @param initialization				True if this method is being invoked during initialization, false otherwise.
     *
     */ 
    handleAuthLOA : function(component, authLOANeeded, initialization) {
        
        var patRequestSpecificMDComp = component.find('mPatientRequestSpecificMD');
        var patOfferedApptComp = component.find('mPatientOfferedAppointment');
        var reasonApptNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reachedOutToMDComp = component.find('mReachedOutToMDToReschedule');
        
        var disableFlag = (authLOANeeded == null ? true : false);
        if (initialization == false) {
            patRequestSpecificMDComp.set('v.disabled', disableFlag);
            patOfferedApptComp.set('v.disabled', disableFlag);
            reasonApptNotOfferedComp.set('v.disabled', disableFlag);
            reachedOutToMDComp.set('v.disabled', disableFlag);
            
            if (disableFlag) {
	            component.set('v.mPatientRequestSpecificMDVal', '');
	            component.set('v.mPatientOfferedAppointmentVal', '');
                component.set('v.mPatientAppointmentNotOfferedReasonsVal', '');
                component.set('v.mReachedOutToMDToRescheduleVal', '');
            }
            
            component.set('v.mDisableDisplayPatientRequestSpecificMD', disableFlag);
            component.set('v.mDisableDisplayPatientOfferedAppointment', disableFlag);
            component.set('v.mDisableDisplayReasonAppointmentNotOffered', disableFlag);
            component.set('v.mDisableDisplayReachedOutToMDToReschedule', disableFlag);
        } else  {
            patRequestSpecificMDComp.set('v.disabled', disableFlag);
            patOfferedApptComp.set('v.disabled', disableFlag);
            component.set('v.mDisableDisplayPatientRequestSpecificMD', disableFlag);
            component.set('v.mDisableDisplayPatientOfferedAppointment', disableFlag);
            
            var patOfferedApptCompVal = patOfferedApptComp.get('v.value');
            disableFlag = (patOfferedApptCompVal != 'No' ? true : false);
            if (disableFlag == true) {
                reasonApptNotOfferedComp.set('v.disabled', true);
                reachedOutToMDComp.set('v.disabled', true);
                component.set('v.mDisableDisplayReasonAppointmentNotOffered', true);
                component.set('v.mDisableDisplayReachedOutToMDToReschedule', true);
            } else {		// Patient was not offered an appointment
                reasonApptNotOfferedComp.set('v.disabled', false);
                component.set('v.mDisableDisplayReasonAppointmentNotOffered', false);
                var reasonApptNotOfferedCompVal = component.get('v.mPatientAppointmentNotOfferedReasonsVal');
                if (reasonApptNotOfferedCompVal == 'No New Patient Slot Available') {
                    reachedOutToMDComp.set('v.disabled', false);
					component.set('v.mDisableDisplayReachedOutToMDToReschedule', false);
                } else {
                    reachedOutToMDComp.set('v.disabled', true);
					component.set('v.mDisableDisplayReachedOutToMDToReschedule', true);
                }
            }
        }
    },
        
    /*
     * Handle changes whe the value of the mPatientOfferedAppointment element changes.
     * 
     * @param component				The component
     * @param event						The event
     * @param helper					The helper
     * 
     * 
     */
    onApptNotOfferedChange : function (component, event, helper) {
        var reasonApptNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reachedOutToMDComp = component.find('mReachedOutToMDToReschedule');
        reachedOutToMDComp.set('v.disabled', true);
        component.set('v.mDisableDisplayReachedOutToMDToReschedule', true);
        reasonApptNotOfferedComp.set('v.value', null);
        
        var patOfferedApptComp = component.find('mPatientOfferedAppointment');
        var patOfferedApptCompVal = patOfferedApptComp.get('v.value');
        var disableFlag = (patOfferedApptCompVal == 'No' ? false : true);
        reasonApptNotOfferedComp.set('v.disabled', disableFlag);
        component.set('v.mDisableDisplayReasonAppointmentNotOffered', disableFlag);
        component.set('v.mReachedOutToMDToRescheduleVal', '');
    },

    /*
     * Handle changes whe the value of the mPatientAppointmentNotOfferedReasonsList element changes.
     * 
     * @param component				The component
     * @param event						The event
     * @param helper					The helper
     * 
     * 
     */
    onReasonApptNotOfferedChange : function (component, event, helper) {
        var reasonApptNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reasonApptNotOfferedCompVal = reasonApptNotOfferedComp.get('v.value');
        var reachedOutToMDComp = component.find('mReachedOutToMDToReschedule');
        var disableFlag = (reasonApptNotOfferedCompVal == 'No New Patient Slot Available' ? false : true);
        component.set('v.mReachedOutToMDToRescheduleVal', '');
        reachedOutToMDComp.set('v.value', '');
        reachedOutToMDComp.set('v.disabled', disableFlag);
        component.set('v.mDisableDisplayReachedOutToMDToReschedule', disableFlag); 
        
    },

    /*
     * Call the server side controller getCompletedClinicallyDeniedValuesServer to retrieve the list of 
     * dependent values for a controlling field.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */ 
    onPatientStatusChangeClient : function(component, event, helper) {
    	var action = component.get('c.getCompletedClinicallyDeniedValuesServer');
        var controllingFieldValue = component.get('v.mPatientStatusVal');
        action.setParams({controllingFieldValue : controllingFieldValue});
        
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var reasonsValues = response.getReturnValue();
                component.set('v.mCompletedClinicallyDeniedReasons', reasonsValues);
                if (reasonsValues == null) {
			        var caseRecord = component.get('v.mCase');
                    caseRecord.Completed_Clinically_Denied_Reason__c = null;		// reset to null if no dependent values are found
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * Handle updates to the mPatientNeedAuthLOA field.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */ 
    onPatientNeedAuthLOAChange : function(component, event, helper) {

		var boolVal = null;
        var mPatientNeedAuthLOAVal = component.get('v.mPatientNeedAuthLOAVal');
        if (mPatientNeedAuthLOAVal == 'Yes') {
            boolVal = true;
        } else if (mPatientNeedAuthLOAVal == 'No') {
            boolVal = false;
        }

		// Pass null for boolVal if --Not Applicable--was selected        
        this.handleAuthLOA(component, boolVal, false);   
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
     * Method to call the e.force:showToast event
     * @param title			Message title.
     * @param type			Message type.
     * @param message	Message contents.
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
    },    
    
})