({
    /*
     * Method to call the Server side controller to initialize the default values of the Case record
     * The Server Side controller returns:
     * 1.	The Case record
     * 2. 	The select list values for the select lists
     * If the Server side returns SUCCESS:
     * 1.	The case record is assigned to mCase
     * 2.	The Select Lists are populated with their options (if any)
     * 3. 	The mWritable field is set if necessary 
     * 4. 	mDoneLoading is set to true
     * 
     * @param component						The component
     */ 
    initCOHCaseInsuranceTabClient : function(component) {
        var action = component.get('c.initCOHCaseInsuranceTabServerOld');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var caseRecord = response.getReturnValue().Case;
                if (caseRecord) {
                    component.set('v.mCase', caseRecord);
                    var selectListValues = component.get('v.mSelectListValues');
                    selectListValues['Plan_Type__c'] = response.getReturnValue().Plan_Type;                 
                    selectListValues['Line_of_Business_Decision_Tree__c'] = response.getReturnValue().Line_Of_Business;
                    if (Array.isArray(selectListValues['Line_of_Business_Decision_Tree__c']) && selectListValues['Line_of_Business_Decision_Tree__c'].length > 0 && selectListValues['Line_of_Business_Decision_Tree__c'][0].value != '-Not Applicable-') {
                        component.set('v.mWritable.Line_of_Business_Decision_Tree__c', true);
                    }
                    selectListValues['Health_Plan__c'] = response.getReturnValue().Health_Plan;
                    if (Array.isArray(selectListValues['Health_Plan__c']) && selectListValues['Health_Plan__c'].length > 0 && selectListValues['Health_Plan__c'][0].value != '-Not Applicable-') {
                        component.set('v.mWritable.Health_Plan__c', true);
                    }                    
                    selectListValues['Medical_Group_IPA__c'] = response.getReturnValue().IPA_Medical_Group;
                    if (Array.isArray(selectListValues['Medical_Group_IPA__c']) && selectListValues['Medical_Group_IPA__c'].length > 0 && selectListValues['Medical_Group_IPA__c'][0].value != '-Not Applicable-') {
                        component.set('v.mWritable.Medical_Group_IPA__c', true);
                    }                      
                    selectListValues['Duarte_or_Community__c'] = response.getReturnValue().Location;
                    if (Array.isArray(selectListValues['Duarte_or_Community__c']) && selectListValues['Duarte_or_Community__c'].length > 0 && selectListValues['Duarte_or_Community__c'][0].value != '-Not Applicable-') {
                        component.set('v.mWritable.Duarte_or_Community__c', true);
                        // If Duarte or Community is populated.. then Auth and LOA required should be populated as well
                        component.set('v.mWritable.Auth_Required__c', true);
                        component.set('v.mWritable.LOA_Required__c', true);
                    }
                    component.set('v.mSelectListValues', selectListValues);
                    component.set('v.mDoneLoading', true);
                    component.set('v.mLOA_Required__c', response.getReturnValue().mLOA_Required__c);
                    component.set('v.mInsurance_Verified__c', response.getReturnValue().mInsurance_Verified__c);
                    component.set('v.mAuth_Required__c', response.getReturnValue().mAuth_Required__c);
                    
                    var originalVal = response.getReturnValue().mLOA_Required__c;
                    var convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mLOARequiredVal', convertedVal);

                    originalVal = response.getReturnValue().mAuth_Required__c;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mAuthRequiredVal', convertedVal);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getLineOfBusinessValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Line of Business select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Line of Business select list	
     * 2. 	Call handleResponse helper method to populate the line of business select list
     * 3.	If the handleResponse method returns true, then calls the getHealthPlanValuesClient (because the Line Of Business select list only contains not applicable)
     */ 
    getLineOfBusinessValuesClient : function(component, helper) {
    	var action = component.get('c.getLineOfBusinessValuesServerOld');
        var planType = component.get('v.mCase.Plan_Type__c');
        action.setParams({planType: planType});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var lineOfBusinessValues = response.getReturnValue();
                helper.resetField(component, 'Health_Plan__c');
                helper.resetField(component, 'Medical_Group_IPA__c');
                helper.resetField(component, 'Duarte_or_Community__c');
                helper.resetField(component, 'Auth_Required__c');
                helper.resetField(component, 'LOA_Required__c');
                var gotoNextFunction = helper.handleResponse(component, helper, lineOfBusinessValues, 'Line_of_Business_Decision_Tree__c');
                if (gotoNextFunction) {
                    helper.getHealthPlanValuesClient(component, helper);
                }          
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getHealthPlanValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Health Plan select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Health Plan select list	
     * 2. 	Call handleResponse helper method to populate the Health Plan select list
     * 3.	If the handleResponse method returns true, then calls the getMedicalGroupIPAValuesClient (because the Health Plan select list only contains not applicable)
     * 
     * @param component						The component
     * @param helper						The helper
     */     
    getHealthPlanValuesClient : function (component, helper) {
        var action = component.get('c.getHealthPlanValuesServerOld');
        var planType = component.get('v.mCase.Plan_Type__c');
        var lineOfBusiness = component.get('v.mCase.Line_of_Business_Decision_Tree__c');
        action.setParams({planType:planType, lineOfBusiness:lineOfBusiness});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var healthPlanValues = response.getReturnValue();
                helper.resetField(component, 'Medical_Group_IPA__c');
                helper.resetField(component, 'Duarte_or_Community__c');
                helper.resetField(component, 'Auth_Required__c');
                helper.resetField(component, 'LOA_Required__c');                
                var gotoNextFunction = helper.handleResponse(component, helper, healthPlanValues, 'Health_Plan__c');
                if (gotoNextFunction) {
                    helper.getMedicalGroupIPAValuesClient(component, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getMedicalGroupIPAValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Medical Group / IPA select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Medical Group / IPA select list	
     * 2. 	Call handleResponse helper method to populate the Medical Group / IPA select list
     * 3.	If the handleResponse method returns true, then calls the getLocationValuesClient (because the Medical Group / IPA select list only contains not applicable)
     * 
     * @param component						The component
     * @param helper						The helper
     */        
    getMedicalGroupIPAValuesClient : function (component, helper) {
        var action = component.get('c.getMedicalGroupIPAValuesServerOld');
        var planType = component.get('v.mCase.Plan_Type__c');
        var lineOfBusiness = component.get('v.mCase.Line_of_Business_Decision_Tree__c');
        var healthPlan = component.get('v.mCase.Health_Plan__c');
        action.setParams({planType:planType, lineOfBusiness:lineOfBusiness, healthPlan:healthPlan});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                var medicalGroupIPAValues = response.getReturnValue();
                helper.resetField(component, 'Duarte_or_Community__c');
                helper.resetField(component, 'Auth_Required__c');
                helper.resetField(component, 'LOA_Required__c');                
                var gotoNextFunction = helper.handleResponse(component, helper, medicalGroupIPAValues, 'Medical_Group_IPA__c');
                if (gotoNextFunction) {
                    helper.getLocationValuesClient(component, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getLocationValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Duarte or Community select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Duarte or Community select list	
     * 2. 	Call handleResponse helper method to populate the Duarte or Community select list
     * 
     * @param component						The component
     * @param helper						The helper
     * 
     */    
    getLocationValuesClient : function (component, helper) {
        var action = component.get('c.getLocationValuesServerOld');
        var planType = component.get('v.mCase.Plan_Type__c');
        var lineOfBusiness = component.get('v.mCase.Line_of_Business_Decision_Tree__c');
        var healthPlan = component.get('v.mCase.Health_Plan__c');
        var medicalGroupIPA = component.get('v.mCase.Medical_Group_IPA__c');
        action.setParams({planType:planType, lineOfBusiness:lineOfBusiness, healthPlan:healthPlan, medicalGroupIPA:medicalGroupIPA});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                var duarteOrCommunity = response.getReturnValue();
                helper.resetField(component, 'Auth_Required__c');
                helper.resetField(component, 'LOA_Required__c');                
                helper.handleResponse(component, helper, duarteOrCommunity, 'Duarte_or_Community__c');
            }            
        });
        $A.enqueueAction(action);        
    },
    
    /*
     * Method to call the server side controller getLocationValuesServer
     * If the server side controller returns:
     * 1. 	A Map<Boolean> containing the values for the Auth Required and LOA Required checkboxes
     * * If the Server side returns SUCCESS:
     * 1. 	Set the Auth Required and LOA Required Checkboxes
     * 2. 	Set the mWritable field to make Auth Required and LOA writable
     */  
    getAuthAndLOARequiredClient : function (component, helper) {
      	var action = component.get('c.getAuthAndLOARequiredServer');
        var caseRecord = component.get('v.mCase');
        
        action.setParams({caseRecord:caseRecord});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                component.set('v.mCase.Auth_Required__c', response.getReturnValue().Auth_Required__c);
                component.set('v.mCase.LOA_Required__c', response.getReturnValue().LOA_Required__c);

				// Convert this to the proper format
                var authReq = (response.getReturnValue().Auth_Required__c == true ? 'true' : 'false');
                var loaReq = (response.getReturnValue().LOA_Required__c == true ? 'true' : 'false');
                component.set('v.mAuthRequiredVal', authReq);
                component.set('v.mLOARequiredVal', loaReq);

                component.set('v.mWritable.Auth_Required__c', true);
                component.set('v.mWritable.LOA_Required__c', true);
            } 
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the saveCOHCaseInsuranceTabServer method.  The record
     * is saved via an Apex class because the component is not a lightning:editform.
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component						The component
     * @param helper						The helper
     * 
     */ 
    saveInsuranceTabClient : function (component, helper) {
        var action = component.get('c.saveCOHCaseInsuranceTabServer');
        var caseRecord = component.get('v.mCase');
        
        // Create a Map of True/False drop down values to their Boolean equivalent

        var selectListMap = {};
        
        var selectListComp = component.find('mLOA_Required__c');
        var selectListVal = selectListComp.get('v.value');
        selectListMap['mLOA_Required__c']  =  (selectListVal == 'true' ? true : false);

        selectListComp = component.find('mInsurance_Verified__c');
        selectListVal = selectListComp.get('v.value');
        selectListMap['mInsurance_Verified__c']  =  (selectListVal == 'true' ? true : false);

        selectListComp = component.find('mAuth_Required__c'); 
        selectListVal = selectListComp.get('v.value');
        selectListMap['mAuth_Required__c']  =  (selectListVal == 'true' ? true : false);

        action.setParams({'caseRecord' : caseRecord, 'selectListMap' : selectListMap});

       action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                helper.showToast("Insurance Information Saved", "success", "The record has been updated successfully.");
                $A.get('e.force:refreshView').fire();
            } else if (responseState === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }     
                helper.showToast("Error: Insurance Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    /*
     * Method to handle populating select lists from the responses supplied from the get[fieldname] methods
     * 
     * If the select list only contains '-Not Applicable-' then the method handles populates the select list, makes the field unwritable and returns false
     * If the select list does not start with '-Not Applicable-' and is >= 1, then the method populates the select list, makes the field writable and returns true
     * If the selct list is < 1 then the resetField method is called
     * 
     * @param component						The component
     * @param helper						The helper
     * @param selectList					The Array of objects to assign to the select list
     * @param fieldAPIName					The APIName of the field the select list's value is bound to
     * 
     * @returns boolean 					True if the selectList only contains notApplicable
     */ 
    handleResponse : function(component, helper, selectList, fieldAPIName) {
        var selectListOnlyNotApplicable;
        
        if (selectList.length === 1 && selectList[0].value === '-Not Applicable-') {
            component.set('v.mCase.' + fieldAPIName, selectList[0].value);
            component.set('v.mWritable.' + fieldAPIName, false);
            component.set('v.mSelectListValues.' + fieldAPIName, selectList);
            selectListOnlyNotApplicable = true;
        }
        else {
            if (selectList.length >= 1) {
            component.set('v.mSelectListValues.' + fieldAPIName, selectList);
            component.set('v.mWritable.' + fieldAPIName, true);
            selectListOnlyNotApplicable = false;
            }
            else {
                helper.resetField(component, fieldAPIName);
            }
        }        
        return selectListOnlyNotApplicable;
    },
    
    /*
     * Method to reset the select lists
     * @param component 					The component
     * @param fieldAPIName					The APIName of the field the select list's value is bound to
     */ 
    resetField : function (component, fieldAPIName) {
        component.set('v.mCase.' +  fieldAPIName, null);
        component.set('v.mWritable.' + fieldAPIName, false);
        component.set('v.mSelectListValues.' + fieldAPIName, null);
    },
    
    /*
     * Method to call the e.force:showToast event
     * Currently only used for success messages, if more toasts are added parameters should be added to customize the toast's params
     */ 
// testing--raymond tam
/*    
    showToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Insurance Information Saved",
            "type": "success",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    }
*/    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title, "type": type, "message": message});
        toastEvent.fire();
    }
    
})