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
        var apptdatetime = component.get('v.ApptDateTime');// change Added by vara on 06-14-2022 NPI Issue log:124
        //alert(apptdatetime);
        var action = component.get('c.getActiveUserID');
        
        var caseObjNew = component.get('v.mCase');
        console.log('caseObjNew',JSON.parse(JSON.stringify(caseObjNew )))
        var caseObj =JSON.parse(JSON.stringify(caseObjNew));
        caseObj.Procurement_Tab_Complete__c = true;
        var dateAssignedComp = component.find('Date_PRS_Specialist_Is_Assigned__c');
        var newDateTime = $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDTkk:mm:ssZ");
        
        // Check if the current case owner has changed
        var newPRSpecialistComp = component.find('PRSpecialist_Assignment__c');
        var newPRSpecialistVal = newPRSpecialistComp.get('v.value');
        var curPRSpecialist = component.get('v.mCurPRSpecialist');
        if (newPRSpecialistVal != curPRSpecialist && (newPRSpecialistVal != null || newPRSpecialistVal != "")) {  
            action.setParams({'employeeInfoStr':newPRSpecialistVal});
            dateAssignedComp.set('v.value', newDateTime);
            caseObj.Date_PRS_Specialist_Is_Assigned__c = newDateTime;
            //fields['Date_PRS_Specialist_Is_Assigned__c'] = newDateTime; 
        } else {
            action.setParams({'employeeInfoStr':null});
        }
        if (newPRSpecialistVal == null || newPRSpecialistVal == '') {
            dateAssignedComp.set('v.value', null);
        } 
        
        if(component.find('mPatienteHealthTemplateSubmitted').get('v.value')!='' && 
           component.find('mPatienteHealthTemplateSubmitted').get('v.value')!=undefined &&
           component.find('mPatienteHealthTemplateSubmitted').get('v.value')!=null){
            var newDateTime = $A.localizationService.formatDate(component.find('mPatienteHealthTemplateSubmitted').get('v.value'), "YYYY-MM-DDTkk:mm:ssZ");
            console.log('mPatienteHealthTemplateSubmitted',newDateTime)
            caseObj.E_Health_Template_Submitted__c = newDateTime.split('T')[0]; //YYYY-MM-DDThh:mm:ssZ
        }else{
            caseObj.E_Health_Template_Submitted__c =  null;
        }
        if(component.find('mPatientePathologyReqEntered').get('v.value')!='' && 
           component.find('mPatientePathologyReqEntered').get('v.value')!=undefined &&
           component.find('mPatientePathologyReqEntered').get('v.value')!=null){
            var newDateTime = $A.localizationService.formatDate(component.find('mPatientePathologyReqEntered').get('v.value'), "YYYY-MM-DDTkk:mm:ssZ");
            console.log('mPatientePathologyReqEntered',newDateTime)
            caseObj.Pathology_Req_Entered__c = newDateTime.split('T')[0]; //YYYY-MM-DDThh:mm:ssZ
        }else{
            caseObj.Pathology_Req_Entered__c =  null;
        }
        if(component.find('mPatienteAncillaryReqEntered').get('v.value')!='' && 
           component.find('mPatienteAncillaryReqEntered').get('v.value')!=undefined &&
           component.find('mPatienteAncillaryReqEntered').get('v.value')!=null){
            var newDateTime = $A.localizationService.formatDate(component.find('mPatienteAncillaryReqEntered').get('v.value'), "YYYY-MM-DDTkk:mm:ssZ");
            console.log('mPatienteAncillaryReqEntered',newDateTime)
            caseObj.Ancillary_Req_Entered__c = newDateTime.split('T')[0]; //YYYY-MM-DDThh:mm:ssZ
        }else{
            caseObj.Ancillary_Req_Entered__c =  null;
        }
        
       
        caseObj.PHI_Received_List__c = component.find('mPhiReceievedlst').get('v.value');
        
        caseObj.PHI_uploaded_to_eHealth__c = component.find('mPhiUploadedtoeHealth').get('v.value');
        caseObj.Procurement_Process_Completed__c = component.find('procurementProcessCompleted').get('v.checked');
        console.log('procurementProcessCompleted',component.find('procurementProcessCompleted').get('v.checked'))
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {
                var newCaseOwnerID = response.getReturnValue();
                //changes start by vara on 06-14-2022 NPI Issue log:124
                var patienteHealthRecTemp = component.find('mPatienteHealthRecordTemplate').get('v.value');
                if ((patienteHealthRecTemp == '' || patienteHealthRecTemp == null || patienteHealthRecTemp == 'None') && (apptdatetime != '' && apptdatetime != null && apptdatetime && 'undefined')){
                    helper.showToast("Error: Procurement Not Saved", "error", "The 'eHealth Record Template' field cannot be empty. ");
                    return;
                }
                //changes end by vara on 06-14-2022 NPI Issue log:124
                // set the mCurPRSpecialist to the correct value
                if (newCaseOwnerID != null) {
                    component.set('v.mCurPRSpecialist', newPRSpecialistVal);
                    caseObj.OwnerId  = newCaseOwnerID;
                    caseObj.PR_Specialist_User__c  = newCaseOwnerID;
                }
                console.log('caseObj',caseObj)
                component.set("v.mCase",caseObj);
                helper.saveProcurement(component, event, helper, 'Procurement Information Saved', "success", "The record has been updated successfully.");
                
                //component.find('procurementForm').submit(fields);
                //helper.showToast('Procurement Information Saved', "success", "The record has been updated successfully.");
            } else if (responseState === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                } 
                helper.saveProcurement(component, event, helper, "Error: Patient Records Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
                
                //helper.showToast("Error: Patient Records Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
            //component.find('procurementForm').submit(fields);
        });
        $A.enqueueAction(action);
        
    },
    
    saveProcurement : function(component, event, helper, title, type, message) {
        
        console.log('saveProcurementTabServer  title ',title);
        console.log('saveProcurementTabServer  type ',type);
        console.log('saveProcurementTabServer  message ',message);
        var caseObj = component.get('v.mCase');
        var recordId = component.get('v.recordId');
        console.log('saveProcurementTabServer caseObj ',JSON.parse(JSON.stringify(caseObj)));
        console.log('saveProcurementTabServer recordId2', recordId);
        if(component.get('v.recordId') != '' && component.get('v.recordId') != undefined){
            caseObj.Id = component.get('v.recordId');
        }
        
        var action = component.get("c.saveProcurementData");
        action.setParams({'caseObj': JSON.stringify(caseObj)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //  helper.getProcurementDataHelper(component, event);
                helper.showToast(title, type, message);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                console.log('saveProcurementTabServer  errors ',errors);
                var errorMessage = '';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }  
                helper.showToast('Error', 'error', errorMessage);
            }
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
                console.log('response.getReturnValue()1',response.getReturnValue())
                var caseRecord = response.getReturnValue().Case;
                if (caseRecord) {  
                    //var caseinstance = caserecord.get('Case');
                    //alert(caseRecord.Appt_Date_Time__c); // Added by vara on 06-14-2022 NPI Issue log:124
                    console.log('caseRecord',caseRecord)
                    component.set('v.mCase', caseRecord);
                    component.set('v.ApptDateTime',caseRecord.Appt_Date_Time__c);// Added by vara on 06-14-2022 NPI Issue log:124
                    var clinicalspass = response.getReturnValue().mClinicalSpecialtyAssignment;
                    //alert('clinicalspecality'+ clinicalspass);
                    component.set('v.mClinicalSpecialtyAssignmentVal', clinicalspass);
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
                    component.set('v.mPhiReceievedlstVal', caseRecord.PHI_Received_List__c);
                    component.set('v.mPhiUploadedtoeHealthvVal', caseRecord.PHI_uploaded_to_eHealth__c);
                    component.set('v.mPatienteHandedofftoeHealthVal', caseRecord.Handed_off_to_eHealth__c);
                    component.set('v.mPatienteHealthTemplateSubmittedVal', caseRecord.E_Health_Template_Submitted__c);
                    component.set('v.mPatientePathologyReqEnteredVal', caseRecord.Pathology_Req_Entered__c);
                    component.set('v.mPatienteAncillaryReqEnteredVal', caseRecord.Ancillary_Req_Entered__c);
                    component.set('v.mPatientePathologySlidesNeededVal', caseRecord.Pathology_Slides_Needed__c);
                    component.set('v.mPatienteRADImagingNeededVal', caseRecord.RAD_Imaging_Needed__c);
                    component.find('procurementProcessCompleted').set('v.checked',caseRecord.Procurement_Process_Completed__c);
                }
                
                var patientBound = response.getReturnValue().PRSpecialist_Assignment__c;
                var arr = [];
                for (var key in patientBound) {
                    //console.log('Key',key,patientBound[key]);
                    var obj = new Object();
                    obj['key'] = key;
                    obj['value'] = patientBound[key];
                    arr.push(obj);
                }
                component.set('v.PRSpecialist_AssignmentMap',arr);
                
                var recordTem = response.getReturnValue().eHealth_Record_Template__c;
                var arr1 = [];
                for (var key in recordTem) {
                    //console.log('Key',key,patientBound[key]);
                    var obj = new Object();
                    obj['key'] = key;
                    obj['value'] = recordTem[key];
                    arr1.push(obj);
                }
                component.set('v.eHealth_Record_TemplateMap',arr1);
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