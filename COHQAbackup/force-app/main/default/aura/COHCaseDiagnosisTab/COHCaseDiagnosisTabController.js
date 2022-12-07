({
    //START Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
    handleClinicalProcessComplete:function(component, event, helper) {
        const mCase = component.get("v.mCase");
        mCase.Clinical_Process_Complete__c = component.find("Clinical_Process_Complete").get("v.value");
        if(mCase.Clinical_Process_Complete__c){
            mCase.Clinical_Process_Date_Time__c = $A.localizationService.formatDateTime(new Date(),'YYYY-MM-DDTHH:mm:ss.000Z');
        } else {
            mCase.Clinical_Process_Date_Time__c = null;
        }
        component.set("v.mCase",mCase);
    },
    //END Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the "Diagnosis_Tab_Complete__c" field and then resubmits
     */ 
    saveDiagnosisClick : function(component, event, helper) {
        // $A.get('e.force:refreshView').fire();// added by Vara
        //component.set("v.mLoading", true);
        //  var showspinner = component.get("v.mLoading");  
        
        // added by Vara on 6/28/2022 Round Robin
        // alert(showspinner);         
        event.preventDefault();
        
        
        helper.saveCOHCaseClinicalTabClient(component, event, helper,false);
        
        // component.set("v.mLoading", false);
        component.set("v.mPhysicianChanged", false); 
        
    },
    
    /*
     * Method called when the Submit button on the Record Edit Form is clicked
     * Prevents default to update the Do Not Send To EPIC -- "IsRead__c" field to update false
     */ 
    createEPICEncounter : function(component, event, helper) {
        helper.createEPICEncounterValueSet(component, event, helper);
    },
    /*
     * Method called to handle the init event for the component
     */ 
    init : function(component, event, helper) {
        $A.enqueueAction(component.get('c.subscribePlatform'));
        helper.initCOHCaseClinicalTabClient(component);
        component.set("v.mLoading", false);
    },
    /*START Changes by Sanjay on 04/13/2022: Patient Type changes*/
    onPatientTypeChange:function(component, event, helper) {
        const mCase = component.get("v.mCase");
        const patientTypeOptionMap = component.get("v.patientTypeOptionMap");
        component.set("v.patientTypeOptionMapValue",patientTypeOptionMap[mCase.Patient_Type__c] || '');
        
    },
    /*END Changes by Sanjay on 04/13/2022: Patient Type changes*/
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
        // $A.get('e.force:refreshView').fire();// added by Vara
        component.set("v.mShowSelectSubgroup", true);
        // $A.get('e.force:refreshView').fire();// added by Vara
        helper.getSubgroupNumberClient(component, helper);
        
    },
    
    /*
	 * Handles changes to the Subgroup Select component.
	 * 
	 */
    onSubgroupNumberChange : function(component, event, helper) {
        // $A.get('e.force:refreshView').fire();// added by Vara
        component.set("v.mShowSelectPhysician", true);
        // $A.get('e.force:refreshView').fire();// added by Vara
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
     
    onPatientDiagnosedChange : function(component, event, helper) {
        var hasPatientBeenDiagnosed = component.get("v.mPatientDiagnosedVal1");
        //var patientDiagnosisComp = component.find('Patient_Diagnosis__c');
        var patientDiagnosisComp = component.find('Does_pt_have_a_biopsy_rltd_to_their_dns__c'); // Added by vara on 9-9-22
    },*/
    
    /*
     * Enable or disable the HasPatientBeenDiagnosed__c field based on the
     * value of the associated select list.
     * 
     */
    onPatientDiagnosChange : function(component, event, helper) {
        var hasPatientBeenDiagnosed = component.get("v.mPatientDiagnosedVals1");
        // var patientDiagnosisComp = component.find('Patient_Diagnosis__c');
        var patientDiagnosisComp = component.find('Does_pt_have_a_biopsy_rltd_to_their_dns__c'); // Added by vara on 9-9-22
        if (hasPatientBeenDiagnosed != "Yes"){
            component.set("v.mPatientDiagnosedVals1",component.get("v.mPatientDiagnosedVals1"));
            component.set("v.mConfirmedThroughBiopsyVals1",component.get("v.mConfirmedThroughBiopsyVals1"));
            component.set("v.mPatientUndergoneTreatmentVal",component.get("v.mPatientUndergoneTreatmentVal"));
        }
    },  
    
    onConfirmedBiopsyChnage : function(component, event, helper) {
        var hasPatientBeenDiagnosed = component.get("v.mConfirmedThroughBiopsyVals1");    
        if (hasPatientBeenDiagnosed != "Yes"){
            component.set("v.mConfirmedThroughBiopsyVals1",component.get("v.mConfirmedThroughBiopsyVals1"));
            component.set("v.mPatientUndergoneTreatmentVal",component.get("v.mPatientUndergoneTreatmentVal"));
        }
    },
    
    onPatientUndergoneTreatmentChnage : function(component, event, helper) {
        var hasPatientBeenDiagnosed = component.get("v.mPatientUndergoneTreatmentVal");    
        if (hasPatientBeenDiagnosed != "Yes"){
            component.set("v.mPatientUndergoneTreatmentVal",component.get("v.mPatientUndergoneTreatmentVal"));
        }
    },
    
    handleIntakeStatus : function(component, event, helper) {
        var hasIntakeStatus = component.get("v.mIntakeStatusListVal");
        var hasHospiceStatus = component.get("v.mHospiceStatusVal");
        
        component.set("v.mReasonforClinicalDenial",false);
        if (hasIntakeStatus == "Clinically Denied by MD" || hasIntakeStatus == "Patient doesn't want to proceed" || hasIntakeStatus == "All Attempts Made - Case Closed"){
            component.set("v.mReasonforClinicalDenial",true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.mIsStatusValue","Closed - Not Selected");
                }), 300
            );
            component.set("v.mHospiceStatusVal","No");
            //component.find("Clinical_Specialty_Assignment").set("v.value","");
        } else {
            component.set("v.mIsStatusValue","");
        }
    },
    
    handleAdmittedHospiceStatus : function(component, event, helper) {
        var hasHospiceStatus = component.get("v.mHospiceStatusVal");
        
        component.find("Clinical_Specialty_Assignment").set("v.disabled", (true));
        component.find("Clinical_Team_Member_Assignment").set("v.disabled", (true));
        component.find("Intake_Status").set("v.disabled", (true));
        
        component.set("v.mIsStatusValue","");
        if(hasHospiceStatus == "Admitted") {            
            component.set("v.mAdmittedOnHospice",true);
            component.set("v.mIsStatusValue","Inquiry");
            
            component.set("v.mIntakeStatusListVal","");
            component.set("v.mReason_for_Clinical_Denial","");
            component.find("Clinical_Specialty_Assignment").set("v.value", '');
            component.find("Clinical_Team_Member_Assignment").set("v.value", '');
            component.set("v.mReason_for_Clinical_Denial","");
        } else if(hasHospiceStatus == "No"||hasHospiceStatus == "Hospice") {
           component.set("v.mAdmittedOnHospice",false);
            component.set("v.mIsStatusValue","New");
                
            component.find("Clinical_Specialty_Assignment").set("v.disabled", (false));
            component.find("Clinical_Team_Member_Assignment").set("v.disabled", (false));
            component.find("Intake_Status").set("v.disabled", (false));  
        }
        
    },
    
    onClinicalSpecialtyAssignmentChange: function(component, event, helper) {
        var hasClinicalSplAssig = component.find("Clinical_Specialty_Assignment").get('v.value');
        var action = component.get('c.getDateTimeStamp');
        /* Changes start by Vara on 7-27-2022 on Chevron bar*/
        /*window.setTimeout(
            $A.getCallback(function() {
                component.set("v.mIsStatusValue","Nursing Review");
            }), 300
        );*/ /* Changes end by Vara on 7-27-2022 on Chevron bar*/
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.find('Date_of_Specialty_Assignment').set('v.value',response.getReturnValue()); 
            }
        });
        if(hasClinicalSplAssig != ''){
            $A.get('e.force:refreshView').fire();// added by Vara // added by Vara - 07/05/2022 for round robbin function
            $A.enqueueAction(action); 
            
        } else {
            component.find('Date_of_Specialty_Assignment').set('v.value','');
            component.set("v.mIsStatusValue","");
            
        } 
        
    },
    
    onClinicalTeamAssignmentChange: function(component, event, helper) {
        var hasClinicalSplAssig = component.find("Clinical_Team_Member_Assignment").get('v.value');
        var action = component.get('c.getDateTimeStamp');
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.find('Date_Nurse_is_assigned').set('v.value',response.getReturnValue());
                component.find('Intake_Status').set('v.value','New'); 
            }
        });
        if(hasClinicalSplAssig != ''){
            
            $A.enqueueAction(action);
            $A.get('e.force:refreshView').fire();// added by Vara- 07/05/2022 for round robbin function
        } else {
            component.find('Date_Nurse_is_assigned').set('v.value','');
            
        } 
    }   ,
    subscribePlatform: function (component,event,helper){
        var channel = '/event/Save_All__e';
        const replayId = -1;
        
        const empApi = component.find("empApi"); 
        
        //A callback function that's invoked for every event received
        const callback = function (message) {
            var msg = message.data.payload;
            console.log('msg = ',JSON.parse(JSON.stringify(msg)));
            // saveDiagnosisClick
            if(msg.RecordId__c   == component.get('v.recordId')){
                helper.saveCOHCaseClinicalTabClient(component, event, helper,true);
                component.set("v.mPhysicianChanged", false);
            }
            console.log('Message returned : ' ,msg.Record_Id__c  );
            
            
        };
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to Clinical Info" + channel);
        });
        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };
        //A callback function that's called when an error response is received from the server for the handshake, connect, subscribe, and unsubscribe meta channels.
        empApi.onError(errorHandler); 
    }
    
})