({
    /*
     * Intialize the component.
     */ 
    init : function (component, event, helper) {
        helper.initCOHCaseApptCancelationTabClient(component, helper);
		component.set('v.mLoading', false);
        $A.get('e.force:refreshView').fire();
    },
    
    /*
     * Handle the clicking of the Submit button.
     */ 
    saveApptCancelationInfoClick : function(component, event, helper) {
        helper.saveCOHCaseAppointmentCancelationTabClient(component, event, helper);
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
    }
    
    
})