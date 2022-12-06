({
    /*
     * Method called when the init event is complete for the component
     */ 
    init : function(component, event, helper) {
        helper.initCOHCaseInsuranceTabClient(component);
    },
    
    /*
     * Method called when the Plan Type select value is changed
     */ 
    onPlanTypeChange : function (component, event, helper) {
        helper.getLineOfBusinessValuesClient(component, helper);
    },
    
    /*
     * Method called when the Line of Business select value is changed
     */ 
    onLineOfBusinessChange : function (component, event, helper) {
        helper.getHealthPlanValuesClient(component, helper);
    },
    
    /*
     * Method called when the Health Plan select value is changed
     */
    onHealthPlanChange : function (component, event, helper) {
        helper.getMedicalGroupIPAValuesClient(component, helper);
    },
    
    /*
     * Method called when the Medical Group / IPA select value is changed
     */    
    onMedicalGroupIPAChange : function (component, event, helper) {
        helper.getLocationValuesClient(component, helper);
    },
    
    /*
     * Method called when the Duarte or Community select value is changed
     */    
    onLocationChange : function (component, event, helper) {
        helper.getAuthAndLOARequiredClient(component, helper);
    },
    
    /*
     * Method called when the Save Insurance Tab button is clicked.
     */    
    onSave : function (component, event, helper) {
        helper.saveInsuranceTabClient(component, helper);
    }
})