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
	initClient : function(component) {
		var action = component.get('c.initCOHCasePhysicianTab');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var selectListValues = component.get('v.mSelectListValues');
                component.set('v.mCase', response.getReturnValue().Case);
                selectListValues['Department_Case__c'] = response.getReturnValue().Departments;
				selectListValues['Service_Line__c'] = response.getReturnValue().Service_Lines;
                if (Array.isArray(selectListValues['Service_Line__c']) && selectListValues['Service_Line__c'].length > 0 && selectListValues['Service_Line__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Service_Line__c', true);
                }
                selectListValues['Specialty__c'] = response.getReturnValue().Specialties;
                if (Array.isArray(selectListValues['Specialty__c']) && selectListValues['Specialty__c'].length > 0 && selectListValues['Specialty__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Specialty__c', true);
                }
                selectListValues['Physician_Decision_Tree__c'] = response.getReturnValue().Physicians;
                if (Array.isArray(selectListValues['Physician_Decision_Tree__c']) && selectListValues['Physician_Decision_Tree__c'].length > 0 && selectListValues['Physician_Decision_Tree__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Physician_Decision_Tree__c', true);
                }
                component.set('v.mSelectListValues', selectListValues);
                component.set('v.mDoneLoading', true);
            }
        });
        $A.enqueueAction(action);
	},
    
    /*
     * Method to call the server side controller getServiceLineValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Service Line select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Service Line select list	
     * 2. 	Call handleResponse helper method to populate the Service Line select list
     * 3.	If the handleResponse method returns true, then calls the getSpecialtyValuesClient
     * 
     * @param component						The component
     * @param helper						The helper
     */     
    getServiceLineValuesClient : function(component, helper) {
      	var action = component.get('c.getServiceLineValuesServer');
        var department = component.get('v.mCase.Department_Case__c');
        action.setParams({department:department});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var serviceLineValues = response.getReturnValue();
                helper.resetField(component, 'Specialty__c');
                helper.resetField(component, 'Physician_Decision_Tree__c');
                var gotoNextFunction = helper.handleResponse(component, helper, serviceLineValues, 'Service_Line__c');
                if (gotoNextFunction) {
                    helper.getSpecialtyValuesClient(component, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getSpecialtyValuesServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Specialty select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Specialty select list	
     * 2. 	Call handleResponse helper method to populate the Specialty select list
     * 3.	If the handleResponse method returns true, then calls the getPhysiciansClient
     * 
     * @param component						The component
     * @param helper						The helper
     */         
    getSpecialtyValuesClient : function(component, helper) {
      	var action = component.get('c.getSpecialtyValuesServer');
        var department = component.get('v.mCase.Department_Case__c');
        var serviceLine = component.get('v.mCase.Service_Line__c');
        action.setParams({department:department, serviceLine:serviceLine});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var specialtyValues = response.getReturnValue();
                helper.resetField(component, 'Physician_Decision_Tree__c');
                var gotoNextFunction = helper.handleResponse(component, helper, specialtyValues, 'Specialty__c');
                if (gotoNextFunction) {
                    helper.getPhysiciansClient(component, helper);
                }
            } 
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getPhysiciansServer
     * If the server side controller returns:
     * 1. 	A List<Map<String,String>> containing the select options of the Physician select list
     * * If the Server side returns SUCCESS:
     * 1.	Resets the fields dependent on the Physician select list	
     * 2. 	Call handleResponse helper method to populate the Physician select list
     * 
     * @param component						The component
     * @param helper						The helper
     */     
    getPhysiciansClient : function(component, helper) {
      	var action = component.get('c.getPhysiciansServer');
        var department = component.get('v.mCase.Department_Case__c');
        var serviceLine = component.get('v.mCase.Service_Line__c');
        var specialty = component.get('v.mCase.Specialty__c');
        action.setParams({department:department, serviceLine:serviceLine, specialty:specialty});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var physicians = response.getReturnValue();
                helper.handleResponse(component, helper, physicians, 'Physician_Decision_Tree__c');
            } 
        });
        $A.enqueueAction(action);
    },    
    
    /*
     * Method to call the saveCOHCasePhysicianTabServer method
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component						The component
     * @param helper						The helper
     */     
    saveCOHCasePhysicianTabClient : function(component, helper) {
        var action = component.get('c.saveCOHCasePhysicianTabServer');
        var caseRecord = component.get('v.mCase');
        action.setParams({caseRecord:caseRecord});
        action.setCallback(this, function(response) {
       		var state = response.getState();
            if (state === 'SUCCESS') {
                helper.showToast();
                $A.get('e.force:refreshView').fire();
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
    showToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Physician Information Saved",
            "type": "success",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    } 
})