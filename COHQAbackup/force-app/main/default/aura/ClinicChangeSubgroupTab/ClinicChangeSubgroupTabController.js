({
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the "Diagnosis_Tab_Complete__c" field and then resubmits
     */ 
    saveDiagnosisClick : function(component, event, helper) {
        event.preventDefault();
        helper.saveCOHCaseClinicalTabClient(component, event, helper);
        component.set("v.mPhysicianChanged", false);
    },
    
    /*
     * Method called to handle the init event for the component
     */ 
    init : function(component, event, helper) {
        helper.initCOHCaseClinicalTabClient(component);
        component.set("v.mLoading", false);
        
    },

	/*
	 * Enables the Service Line Select component if the Department has changed.
	 * 
	 */
    onDepartmentChange : function(component, event, helper) {
        component.set("v.mShowSelectServiceLine", true);
    	helper.getServiceLineValuesClient(component, helper);
    },
    
	/*
	 * Enables the Speciality Select component if the Service Line has changed.
	 * 
	 */
    onServiceLineChange : function(component, event, helper) {
        component.set("v.mShowSelectSpecialty", true);
        helper.getSpecialtyValuesClient(component, helper);
    },
    
	/*
	 * Enables the Physician Select component if the Speciality has changed.
	 * 
	 */
    onSpecialtyChange : function(component, event, helper) {
        component.set("v.mShowSelectSubgroup", true);
    	helper.getSubgroupNumberClient(component, helper);
    },

	/*
	 * Handles changes to the Subgroup Select component.
	 * 
	 */
    onSubgroupNumberChange : function(component, event, helper) {
        component.set("v.mShowSelectPhysician", true);
      	helper.getPhysiciansClient(component, helper);
  },

	/*
	 * Handles changes to the Physician Select component.
	 * 
	 */
    onPhysicianChange : function(component, event, helper) {
        component.set("v.mPhysicianChanged", true);
        component.set("v.mShowSelectPhysician", false);
    },

	/*
	 * Handles changes Patient Undergone Treatment component. The values
	 * are moidified for the Cancer Status component
	 * 
	 * @param component		Component
	 * @param event				Event
	 * @param helper			Helper
	 * 
	 */
    onChangePatientUndergoneTreamtment : function(component, event, helper) {
    	helper.getCancerStatusClient(component, helper);
    },
    
    /*
     * Enable or disable the Patient_Diagnosis__c field based on the
     * value of the associated select list.
     * 
     */
    onPatientDiagnosedChange : function(component, event, helper) {
        var hasPatientBeenDiagnosed = component.get("v.mPatientDiagnosedVal");
        var patientDiagnosisComp = component.find('Patient_Diagnosis__c');
		patientDiagnosisComp.set("v.disabled", (hasPatientBeenDiagnosed == "true" ? false : true));
    }
    
})