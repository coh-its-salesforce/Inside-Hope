({
    init : function(component, event, helper) {
        helper.initClient(component, helper);  
    },
    
    onDepartmentChange : function(component, event, helper) {
    	helper.getServiceLineValuesClient(component, helper);
    },
    
    onServiceLineChange : function(component, event, helper) {
        helper.getSpecialtyValuesClient(component, helper);
    },
    
    onSpecialtyChange : function(component, event, helper) {
    	helper.getPhysiciansClient(component, helper);
    },
    
    saveButtonClicked : function(component,event,helper) {
      	helper.saveCOHCasePhysicianTabClient(component, helper);
    },
    
    handleSubmit : function(component,event,helper) {
      	event.preventDefault();
        component.find('saveBtn').set('v.disabled',true);
        var fields = event.getParam('fields');
        console.log(fields.Accepting_MD__c);
        fields.Department_Case__c = component.get('v.mCase.Department_Case__c');
        fields.Service_Line__c = component.get('v.mCase.Service_Line__c');
        fields.Specialty__c = component.get('v.mCase.Specialty__c');
        fields.Physician_Decision_Tree__c = component.get('v.mCase.Physician_Decision_Tree__c');
        component.find('admittingPhysicianForm').submit(fields);
    },
    
    handleSuccess : function(component,event,helper) {
        helper.showToast('Physician Saved','success','The record has been updated successfully.');
        component.find('saveBtn').set('v.disabled',false);
        $A.get('e.force:refreshView').fire();
    },

    handleError : function(component,event,helper) {
        helper.showToast('Error','error','There was an error updating the record');
        component.find('saveBtn').set('v.disabled',false);
    }    
})