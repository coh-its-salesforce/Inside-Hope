({
    /*
     * Method called when the page is loaded, calls helper methods to setup AJAX calls to the server controller.
     */     
    init: function(component, event, helper) {
		helper.getPicklistsClient(component, event, helper);
    },
    
    /*
     * This method is called from the parent component when the Submit Request button is clicked
     * Checks the validitiy of the fields
     * 
     * @return boolean validInputItems 			returns true if all fields are valid, otherwise false
     */     
    validateFields: function(component, event, helper) {
        var inputItems = component.find('intakeRequestFormCapital');
        var isValidInput = false;       
        
        if (inputItems) {            
            if ($A.util.isArray(inputItems)) {
                isValidInput = inputItems.reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && inputCmp.get('v.validity').valid;                        
                }, true);
            }
            else {
                inputItems.showHelpMessageIfInvalid();
                isValidInput = inputItems.get('v.validity').valid;                    
            }
        }
                
        return isValidInput;
    },

    /*
     * This method is used to toggle the visibility of the chart strings
     */ 
    toggleChartString : function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var chartStrings = component.get("v.mShowChartStrings");
        chartStrings[index] = !chartStrings[index];
        component.set("v.mShowChartStrings", chartStrings);
    },
    
    updateTotalBudget: function(component, event, helper) {
        var capexBudget = component.get("v.mIntakeRequest.COH_UIR_CPT_RequestedCAPEXBudget__c");
        var opexBudget = component.get("v.mIntakeRequest.COH_UIR_CPT_RequestedOPEXBudget__c");
        var additionalExternalFunding = component.get("v.mIntakeRequest.COH_UIR_CPT_AdditionalExternalFunding__c");
        var totalRequestedBudget;
        var totalProjectedBudget;    

        if (isNaN(capexBudget) || capexBudget == '') {
            capexBudget = 0;
        }
        if (isNaN(opexBudget) || opexBudget == '') {
            opexBudget = 0;
        }
        if (isNaN(additionalExternalFunding) || additionalExternalFunding == '') {
            additionalExternalFunding = 0;
        }        
        
        totalRequestedBudget = parseInt(capexBudget) + parseInt(opexBudget);
		totalProjectedBudget = totalRequestedBudget + parseInt(additionalExternalFunding);        
        component.set('v.mTotalRequestedBudget', totalRequestedBudget);
        component.set('v.mTotalProjectedBudget', totalProjectedBudget);
    }
})