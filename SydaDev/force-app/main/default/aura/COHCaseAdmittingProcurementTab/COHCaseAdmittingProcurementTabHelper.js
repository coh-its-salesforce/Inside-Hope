({
    /*
     * Method to call the saveAppointmentInfoTabClient method
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component					The component
     * @param event							The event
     * @param helper						The helper
     * 
     */ 
    saveProcurementTabServer : function (component, event, helper) { 
        var fields = event.getParam('fields');
        
        var selectListComp = component.find('mAllRecordsReceived');
        var selectListVal = selectListComp.get('v.value');
        fields['All_Records_Recieved__c']  =  (selectListVal == 'true' ? true : false);
        
        selectListComp = component.find('mRecordsNoLongerNeeded');
        selectListVal = selectListComp.get('v.value');
        fields['Records_No_Longer_Needed__c']  =  (selectListVal == 'true' ? true : false);

        fields['Procurement_Tab_Complete__c'] = true;
        component.find('procurementForm').submit(fields);
    },
    
    /*
     * Method to call the initCOHCaseProcurementTabServer method
     * If the Server side returns SUCCESS, set the values of various components.
     * 
     * @param component				The component
     * @param helper					The helper
     * 
     * 
     */
	initCOHCaseProcurementTabClient: function (component, helper) {

        var action = component.get('c.initCOHCaseProcurementTabServer');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});

        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var caseRecord = response.getReturnValue().Case;
                if (caseRecord) {
                    component.set('v.mCase', caseRecord);
                    var originalVal = response.getReturnValue().mRecordsNoLongerNeeded;
                    var convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mRecordsNoLongerNeededVal', convertedVal);
                    originalVal = response.getReturnValue().mAllRecordsReceived;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mAllRecordsReceivedVal', convertedVal);
                    originalVal = response.getReturnValue().mInsuranceCard;
                    convertedVal = (originalVal == true ? "true" : "false");                }
            }
        });
        $A.enqueueAction(action);
    },

    
    /*
     * Method to call the e.force:showToast event
     * Currently only used for success messages, if more toasts are added parameters should be added to customize the toast's params
     */     
    showToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Procurement Information Saved",
            "type": "success",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    }
})