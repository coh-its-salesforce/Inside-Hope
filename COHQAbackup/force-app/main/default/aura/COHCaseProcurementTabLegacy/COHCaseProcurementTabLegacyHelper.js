({
    /*
     * Method to call the saveAppointmentInfoTabClient method
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component				The component
     * @param event					The event
     * @param helper				The helper
     * 
     */ 
    saveProcurementTabServer : function (component, event, helper) {

        var action = component.get('c.getActiveUserID');
        
        var fields = event.getParam('fields');
        /*** changes made by sanjay Date 01/05/21 **** changes start**
        var selectListComp = component.find('mAllRecordsReceived');
        
        var selectListVal = selectListComp.get('v.value');
        fields['All_Records_Recieved__c']  =  (selectListVal == 'true' ? true : false);
        
        selectListComp = component.find('mRecordsNoLongerNeeded');
        selectListVal = selectListComp.get('v.value');
        fields['Records_No_Longer_Needed__c']  =  (selectListVal == 'true' ? true : false);
                
        selectListComp = component.find('mInsuranceCard');
        selectListVal = selectListComp.get('v.value');
        fields['Insurance_Card_ID__c']  =  (selectListVal == 'true' ? true : false);

        selectListComp = component.find('mNewPatientPacket');
        selectListVal = selectListComp.get('v.value');
        fields['New_Patient_Packet__c']  =  (selectListVal == 'true' ? true : false);

        selectListComp = component.find('mMedications');
        selectListVal = selectListComp.get('v.value');
        fields['Medications__c']  =  (selectListVal == 'true' ? true : false);
		*** changes made by sanjay Date 01/05/21 **** changes end**/
        fields['Procurement_Tab_Complete__c'] = true;
        
        // Even though the value was set in the Date_PRS_Specialist_Is_Assigned__c component,
        // the dateTime needs to be reformatted again. I think it's a strange quirk of Javascript.
        var dateAssignedComp = component.find('Date_PRS_Specialist_Is_Assigned__c');
        var newDateTime = $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDTkk:mm:ssZ");

        // Check if the current case owner has changed
		var newPRSpecialistComp = component.find('PRSpecialist_Assignment__c');
        var newPRSpecialistVal = newPRSpecialistComp.get('v.value');
        var curPRSpecialist = component.get('v.mCurPRSpecialist');
        
        if (newPRSpecialistVal != curPRSpecialist && (newPRSpecialistVal != null || newPRSpecialistVal != "")) {  
            action.setParams({'employeeInfoStr':newPRSpecialistVal});
            dateAssignedComp.set('v.value', newDateTime);
            fields['Date_PRS_Specialist_Is_Assigned__c'] = newDateTime; 
        } else {
  	      action.setParams({'employeeInfoStr':null});
        }
        
        if (newPRSpecialistVal == null || newPRSpecialistVal == '') {
            dateAssignedComp.set('v.value', null);
        } 
        
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var newCaseOwnerID = response.getReturnValue();

                // set the mCurPRSpecialist to the correct value
                if (newCaseOwnerID != null) {
					component.set('v.mCurPRSpecialist', newPRSpecialistVal);
			        fields['OwnerId']  = newCaseOwnerID;
			        fields['PR_Specialist_User__c']  = newCaseOwnerID;
                }
		        helper.showToast('Procurement Information Saved', "success", "The record has been updated successfully.");
            } else if (responseState === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }     
                helper.showToast("Error: Patient Records Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
	        component.find('procurementForm').submit(fields);
        });
        $A.enqueueAction(action);
    
    },
    
    /*
     * Method to call the initCOHCaseProcurementTabServer method
     * If the Server side returns SUCCESS, set the values of various components.
     * 
     * @param component				The component
     * @param helper				The helper
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
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mInsuranceCardVal', convertedVal);
                    originalVal = response.getReturnValue().mNewPatientPacket;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mNewPatientPacketVal', convertedVal);
                    originalVal = response.getReturnValue().mMedications;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mMedicationsVal', convertedVal);
					component.set('v.mCurPRSpecialist', caseRecord.PRSpecialist_Assignment__c);
     
                }
            }
        });
        $A.enqueueAction(action);
    },

    
    /*
     * Method to call the e.force:showToast event
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