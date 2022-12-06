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
        helper.initCOHCaseProcurementTabClient(component);
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
    
    
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the "Procurement_Tab_Complete__c" field and then resubmits
     */ 
    saveProcurementClick : function(component, event, helper) {
		event.preventDefault();
        helper.saveProcurementTabServer(component, event, helper);
    }
})