({
    /*
     * Method called when the mPatientOfferedAppointment field changes value.
     */    
    onApptNotOfferedChange : function (component, event, helper) {
        helper.onApptNotOfferedChange(component, event, helper);
    },

    /*
     * Method called when the mPatientAppointmentNotOfferedReasonsList field changes value.
     */    
    onReasonApptNotOfferedChange : function (component, event, helper) {
        helper.onReasonApptNotOfferedChange(component, event, helper);
    },
    
    /*
     * Method called when the mPatientNeedAuthLOA field changes value.
     */    
    onPatientNeedAuthLOAChange : function (component, event, helper) {
        helper.onPatientNeedAuthLOAChange(component, event, helper);
    },
    
    /*
     * Update the Completed/Clinically Denied Reason field when the Patient Status is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    onPatientStatusChange : function (component, event, helper) {
        helper.onPatientStatusChangeClient(component, event, helper);
    },

    /*
     * Update the Status field when the Clinical Process Complete field is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    onClinicalProcessCompleteChange : function (component, event, helper) {
        var caseRecord = component.get('v.mCase');
        var clinicalProcessComplete = caseRecord.Clinical_Process_Complete__c;
        var cohMRN = caseRecord.COH_MRN__c;
        if (clinicalProcessComplete == true && cohMRN != null && cohMRN != '') {
	        caseRecord.Status = 'Records Procurement';
        } else {
	        caseRecord.Status = 'Registered';
        }
    },

    /*
     * Update the Status field when the Clinical Team Member Assigned field is changed.
     * 
     * @param component		Component
     * @param event			Event
     * @param helper		Helper
     */    
    onClinicalTeamMemberAssignedChange : function (component, event, helper) {
        var caseRecord = component.get('v.mCase');
	    caseRecord.Status = 'Nursing Review';
    },

    /*
     * Method called when the Submit button is clicked
     */ 
    saveApptInfoClick : function(component, event, helper) {
        helper.saveAppointmentInfoTabClient(component, event, helper);
    },
    
    /*
     * Method called to handle the init event for the component
     */ 
    init : function (component, event, helper) {
        helper.initCOHCaseAppointmentInformationTabClient(component, helper);
		component.set('v.mLoading', false);
        $A.get('e.force:refreshView').fire();
    },
    
    handleSendEmailVideo:function(component, event, helper) {
        helper.sendVideoEmail(component,  helper)
    }
})