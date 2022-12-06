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
        
        var consentingStatus = component.get('v.consentingStatus');       
        if(consentingStatus == null || consentingStatus ==''){
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Consenting Status\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            return;
        }
        
        var consentingType = component.get('v.consentingType');       
        if(consentingType == null || consentingType ==''){
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Consenting Type\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            return;
        }
        var visitTypePreference = component.get('v.visitTypePreference');       
        if(visitTypePreference == null || visitTypePreference ==''){
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Visit Type Preference?\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            return;
        }
        var requestedMD = component.get('v.requestedMD');       
        if(requestedMD == null || requestedMD ==''){
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Is Pt. Requesting a Specific MD?\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            return;
        }
        /* var howmanyDays = component.get('v.howmanyDays');       
        if(howmanyDays == null || howmanyDays ==''){
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Pt Appt is Scheduled in how many days?\" is a required field.');
            return;
        }*/
          var isSoonerAppt = component.get('v.isSoonerAppt');  
        var howmanyDays = component.get('v.howmanyDays'); 
         console.log("howmanyDays", howmanyDays);
        console.log("howmanyDays", isSoonerAppt=='');
        if(howmanyDays == '8+ Days' && (isSoonerAppt == null || isSoonerAppt =='') ){
           
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Does Pt want a sooner appt?\" is a required field.');
            //$A.get('e.force:refreshView').fire();
            return;
        }
        // Validating required fields
        
        /*var patientNeedAuthLOAComp = component.find('mPatientNeedAuthLOA');
        var patientNeedAuthLOAVal = patientNeedAuthLOAComp.get('v.value');
        if (patientNeedAuthLOAVal == null || patientNeedAuthLOAVal == '') {
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error',
                             '\"Does Patient Need Auth/LOA?\" is a required field.');
            $A.get('e.force:refreshView').fire();
            return;
        }*?

      /*  var patientRequestSpecificMDComp = component.find('mPatientRequestSpecificMD');
        var patientRequestSpecificMDVal = patientRequestSpecificMDComp.get('v.value');
        if (patientRequestSpecificMDVal == null || patientRequestSpecificMDVal == '') {
            component.set("v.mLoading", false);
            helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Is Pt. Requesting A Specific MD?\" is a required field.');
            $A.get('e.force:refreshView').fire();
            return;
        }*/
        
        /*var offeredApptComp = component.find('mPatientOfferedAppointment');
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
        }*/		
        
        /*var patientNeedAUthLOAVal = component.get('v.patientNeedAUthLOAVal');
        if (patientNeedAUthLOAVal = null || patientNeedAUthLOAVal == '') {
                component.set("v.mLoading", false);
                helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Does Patient Need Auth/LOA\" is a required field.');
                $A.get('e.force:refreshView').fire();
	            return;
        }*/
        
        /*var patientRequestSpecificMDVal = component.get('v.patientRequestSpecificMDVal');
        if (patientRequestSpecificMDVal = null || patientRequestSpecificMDVal == '') {
                component.set("v.mLoading", false);
                helper.showToast('Patient Appointment Information Not Saved', 'error', '\"Is Pt. Requesting A Specific MD?\" is a required field.');
                $A.get('e.force:refreshView').fire();
	            return;
        }*/
        
        
        // Create a Map of True/False drop down values to their Boolean equivalent
        
        //var selectListMap = {};
        
        /*var selectListComp = component.find('mPatientRegistered');
        var selectListVal = selectListComp.get('v.value');
        selectListMap['mPatientRegistered']  =  (selectListVal == 'true' ? true : false);
        selectListComp = component.find('mPatientScheduledFirstCall');
        selectListVal = selectListComp.get('v.value');
        selectListMap['mPatientScheduledFirstCall']  =  (selectListVal == 'true' ? true : false);
        selectListComp = component.find('mReachedOutToMDToReschedule');
        selectListVal = selectListComp.get('v.value');*/
        
        // caseRecord.Decline_to_move_up_appt__c = this.mapPicklistResponse(component.get('v.mMDDeclinedToMoveUpApptVal'));
        //caseRecord.Patient_Status_Case__c = component.get('v.mPatientStatusVal');
        
        //var reasonNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        //var reasonNotOfferedVal = reasonNotOfferedComp.get('v.value');
        //var newCallCenterRepComp = component.find('mClinicalTeamMembersList');
        //var newCaseOwnerAPIName = newCallCenterRepComp.get('v.value');
        var curCallCenterRep = caseRecord.OwnerId;
        
        //caseRecord.Patient_Offered_Appointment__c = offeredApptCompVal;
        /*var authNeededVal = null;
		var authNeededCompVal = component.get('v.mPatientNeedAuthLOAVal');
        if (authNeededCompVal == 'Yes') { 
            authNeededVal = true;
        } else if (authNeededCompVal == 'No') {
            authNeededVal = false;
        }
        caseRecord.Auth_Needed__c = authNeededVal;*/
        
        /*var specificMDCompVal = component.get('v.mPatientRequestSpecificMDVal');
        caseRecord.Is_Patient_Requesting_a_Specific_MD__c = (specificMDCompVal == '' ? null : specificMDCompVal);*/
        
        /*var patOfferedApptVal = component.get('v.mPatientOfferedAppointmentVal');
		caseRecord.Patient_Offered_Appointment__c = (patOfferedApptVal == '' ? null : patOfferedApptVal); */
        
        // if(caseRecord.Type_of_Scheduling_Barriers_Select_All__c){
        //selectedSchedullingBarrier
        var constArray = component.get('v.selectedSchedullingBarrier');//caseRecord.Type_of_Scheduling_Barriers_Select_All__c.split(";");
        var selLabel = '' ;
        for(var i =0 ;i<constArray.length;i++){
            selLabel = selLabel+constArray[i]+';'
        }
        if(selLabel!='')
            selLabel = selLabel.substring(0,selLabel.length-1);
        console.log('selLabel',selLabel);
        
        // }
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
        
        /* var reachedOutToMDVal = component.get('v.mReachedOutToMDToRescheduleVal');
        caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c = (reachedOutToMDVal == '' ? null : reachedOutToMDVal);*/
        //caseRecord.Location__c = component.get("v.locationVal"); //Changes Start: Added by Sanjay on 8/20/2021
        var action = component.get('c.saveCOHCaseAppointmentInfoTabServer');
        
        //  if (newCaseOwnerAPIName != null && newCaseOwnerAPIName != curCallCenterRep) {
        action.setParams({'updateTime' : component.get('v.updateTime'),'nullTime':component.get('v.nullTime'),'caseRecord' : caseRecord, 'newCaseOwnerAPIName' : null, 'reasonNotOffered' : null});
        //   component.set('v.mCurrentCaseOwnerVal', newCaseOwnerAPIName );
        //  } else {
        //     action.setParams({'updateTime' : component.get('v.updateTime'),'nullTime':component.get('v.nullTime'),'caseRecord' : caseRecord, 'newCaseOwnerAPIName' :  null,  'reasonNotOffered' : reasonNotOfferedVal});
        // }
        
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
    
    /* sendVideoEmail : function (component, helper) {
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
    },*/
    
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
                    
                    
                    // Set the select list values
                    // component.set('v.mPatientRegistered', response.getReturnValue().mPatientRegistered);
                    // component.set('v.mPatientScheduledFirstCall', response.getReturnValue().mPatientScheduledFirstCall);
                    /* component.set('v.mPatientAppointmentNotOfferedReasons', response.getReturnValue().mPatientAppointmentNotOfferedReasons);
                    component.set('v.mClinicalTeamMembers', response.getReturnValue().ClinicalTeamMembers);
                    component.set('v.mLocations', response.getReturnValue().Locations);//Changes made by Sanjay - Date- 09-16-2020
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
                   // component.set('v.mPatientRequestSpecificMDVal', caseRecord.Is_Patient_Requesting_a_Specific_MD__c == null ? '' : caseRecord.Is_Patient_Requesting_a_Specific_MD__c);
                    component.set('v.mReachedOutToMDToRescheduleVal', caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c == null ? '' : caseRecord.Reached_out_to_MD_to_move_up_app_pkl__c);
                   // component.set('v.mPatientOfferedAppointmentVal', caseRecord.Patient_Offered_Appointment__c == null ? '' : caseRecord.Patient_Offered_Appointment__c);
                    component.set('v.mPatientAppointmentNotOfferedReasonsVal', caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c == null ? '' : caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c);
                    component.set("v.locationVal",caseRecord.Location__c  == null ? '' : caseRecord.Location__c ); //Changes made by Sanjay - Date- 08-20-2021
                    var authNeededVal = null;
                    if (caseRecord.Auth_Needed__c  == true) { 
                        authNeededVal = 'Yes';
                    } else if (caseRecord.Auth_Needed__c == false) {
                        authNeededVal = 'No';
                    }
                    component.set('v.mPatientNeedAuthLOAVal', authNeededVal);
            */
                    //this.handleAuthLOA(component, caseRecord.Auth_Needed__c, true);
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
    /*handleAuthLOA : function(component, authLOANeeded, initialization) {
        
       // var patRequestSpecificMDComp = component.find('mPatientRequestSpecificMD');
       // var patOfferedApptComp = component.find('mPatientOfferedAppointment');
        var reasonApptNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reachedOutToMDComp = component.find('mReachedOutToMDToReschedule');
        
        var disableFlag = (authLOANeeded == null ? true : false);
        if (initialization == false) {
          //  patRequestSpecificMDComp.set('v.disabled', disableFlag);
          //  patOfferedApptComp.set('v.disabled', disableFlag);
            reasonApptNotOfferedComp.set('v.disabled', disableFlag);
            reachedOutToMDComp.set('v.disabled', disableFlag);
            
            if (disableFlag) {
	           // component.set('v.mPatientRequestSpecificMDVal', '');
	          //  component.set('v.mPatientOfferedAppointmentVal', '');
                component.set('v.mPatientAppointmentNotOfferedReasonsVal', '');
                component.set('v.mReachedOutToMDToRescheduleVal', '');
            }
            
           // component.set('v.mDisableDisplayPatientRequestSpecificMD', disableFlag);
            component.set('v.mDisableDisplayPatientOfferedAppointment', disableFlag);
            component.set('v.mDisableDisplayReasonAppointmentNotOffered', disableFlag);
            component.set('v.mDisableDisplayReachedOutToMDToReschedule', disableFlag);
        } else  {
          //  patRequestSpecificMDComp.set('v.disabled', disableFlag);
           // patOfferedApptComp.set('v.disabled', disableFlag);
           // component.set('v.mDisableDisplayPatientRequestSpecificMD', disableFlag);
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
      */  
    /*
     * Handle changes whe the value of the mPatientOfferedAppointment element changes.
     * 
     * @param component				The component
     * @param event						The event
     * @param helper					The helper
     * 
     * 
     */
    /*onApptNotOfferedChange : function (component, event, helper) {
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
    },*/
    
    /*
     * Handle changes whe the value of the mPatientAppointmentNotOfferedReasonsList element changes.
     * 
     * @param component				The component
     * @param event						The event
     * @param helper					The helper
     * 
     * 
     */
    /* onReasonApptNotOfferedChange : function (component, event, helper) {
        var reasonApptNotOfferedComp = component.find('mPatientAppointmentNotOfferedReasonsList');
        var reasonApptNotOfferedCompVal = reasonApptNotOfferedComp.get('v.value');
        var reachedOutToMDComp = component.find('mReachedOutToMDToReschedule');
        var disableFlag = (reasonApptNotOfferedCompVal == 'No New Patient Slot Available' ? false : true);
        //component.set('v.mReachedOutToMDToRescheduleVal', '');
        reachedOutToMDComp.set('v.value', '');
        reachedOutToMDComp.set('v.disabled', disableFlag);
        component.set('v.mDisableDisplayReachedOutToMDToReschedule', disableFlag); 
        
    },*/
    
    /*
     * Call the server side controller getCompletedClinicallyDeniedValuesServer to retrieve the list of 
     * dependent values for a controlling field.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */ 
    /* onPatientStatusChangeClient : function(component, event, helper) {
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
    },*/
    
    /*
     * Handle updates to the mPatientNeedAuthLOA field.
     * 
     * @param component		Component
     * @param event				Event
     * @param helper			Helper
     * 
     */ 
    /*onPatientNeedAuthLOAChange : function(component, event, helper) {

		var boolVal = null;
        var mPatientNeedAuthLOAVal = component.get('v.mPatientNeedAuthLOAVal');
        if (mPatientNeedAuthLOAVal == 'Yes') {
            boolVal = true;
        } else if (mPatientNeedAuthLOAVal == 'No') {
            boolVal = false;
        }

		// Pass null for boolVal if --Not Applicable--was selected        
        this.handleAuthLOA(component, boolVal, false);   
    },*/
    
    /*
     * Map picklist response values to store in a Yes/No picklist .
     * @param originalVal		Values chosen by the user.
     * @return							'Yes' if  the value is chose, 'No' if it is not, and null otherwise.
     *
     */ 
    /* mapPicklistResponse : function(originalVal) {
        if (originalVal == null || originalVal == '--None--')  {
            return null;
        } else {
            return originalVal;
        }
    },*/
    
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