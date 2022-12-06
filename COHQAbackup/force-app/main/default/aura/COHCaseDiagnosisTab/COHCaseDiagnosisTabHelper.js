({
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
    },

    /*
     * Method to call the saveDiagnosisTabServer method
     * If the Server side returns SUCCESS:
     * 1.	Call the showToast helper method 
     * 2. 	Fire the e.force.refreshView event
     * 
     * @param component					The component
     * @param event							The event
     * @param helper						The helper
     * 
     */ 
    saveCOHCaseClinicalTabClient : function (component, event, helper) { 
       //component.set("v.mLoading", true); 
        var action = component.get('c.saveCOHCaseClinicalInfoTabServer');
        var caseRecord = component.get('v.mCase');

        // Create a Map of True/False drop down values to their Boolean equivalent

        var selectListMap = {};
         var physicianStr = null;
        if (caseRecord.RecordType.DeveloperName != 'Enterprise_Access_New_Patient') {
          
            var selectListComp = component.find('mPatientDiagnosed');
            var selectListVal = selectListComp.get('v.value');
            caseRecord.Has_patient_been_diagnosed_CheckBox__c = (selectListVal == 'true' ? true : false);
            
            selectListComp = component.find('mPatientUndergoneTreatment');
            selectListVal = selectListComp.get('v.value');
            caseRecord.Has_patient_undergone_treatment__c = (selectListVal == 'true' ? true : false);
    
            selectListComp = component.find('mConfirmedThroughBiopsy');
            selectListVal = selectListComp.get('v.value');
            caseRecord.Confirmed_Through_Biopsy__c = (selectListVal == 'true' ? true : false);
    
            selectListComp = component.find('mCurrentlyUndergoingTreatment');
            selectListVal = selectListComp.get('v.value');
            caseRecord.Currently_Undergoing_Treatment__c = (selectListVal == 'true' ? true : false);
            
            var fieldComp = component.find('Patient_MD_Recommends__c');
            caseRecord.Patient_MD_Recommends__c = fieldComp.get('v.value');
            
            fieldComp = component.find('Referred_To_COH_MD__c');
            caseRecord.Referred_To_COH_MD__c = fieldComp.get('v.value');
    
            fieldComp = component.find('Patient_Diagnosis__c');
            caseRecord.Patient_Diagnosis__c = fieldComp.get('v.value');
    
           
            var physicianChanged = component.get('v.mPhysicianChanged');
            if (physicianChanged == true) {
                fieldComp = component.find('Physician_Decision_Tree__c');
                physicianStr = fieldComp.get('v.value');
            }
    
            fieldComp = component.find('Subgroup_Num__c');
            caseRecord.Subgroup_Num__c = fieldComp.get('v.value');

        } else if (caseRecord.RecordType.DeveloperName == 'Enterprise_Access_New_Patient') {	
           caseRecord.HasPatientBeenDiagnosed__c = component.find('mPatientDiagnoseds').get('v.value');
           var confirmedThrough = component.find('mConfirmedThroughBiopsys').get('v.value');
            if ((confirmedThrough == '' || confirmedThrough == null || confirmedThrough == 'None') && caseRecord.HasPatientBeenDiagnosed__c == 'Yes') {
                //component.set("v.mLoading", false);// added by Vara
                helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Confirmed Through Biopsys?' field cannot be empty. ");
                return;
            } else {
               caseRecord.ConfirmedThroughBiopsy__c = confirmedThrough;
            }
            var patientUndergone = component.find('mPatientUndergoneTreatments').get('v.value');
            if ((patientUndergone == '' || patientUndergone == null || patientUndergone == 'None')  && caseRecord.ConfirmedThroughBiopsy__c == 'Yes') {
                //component.set("v.mLoading", false);// added by Vara               
                helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Patient Under gone Treatments' field cannot be empty. ");
                return;
            } else {
               caseRecord.HasPatientUndergoneTreatment__c = patientUndergone;
            }
            var currentlyUndergoing = component.find('mCurrentlyUndergoingTreatments').get('v.value');
            if ((currentlyUndergoing == '' || currentlyUndergoing == null || currentlyUndergoing == 'None') &&caseRecord.HasPatientUndergoneTreatment__c== 'Yes') {
                //component.set("v.mLoading", false);// added by Vara                
                helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Currently Under going Treatments' field cannot be empty. ");
                return;
            } else {
               caseRecord.CurrentlyUndergoingTreatment__c = currentlyUndergoing;
            }
           caseRecord.Is_patient_interested_in_a_CAR_T_Trial__c = component.find('mIsPatientIntrestedinacar').get('v.value');
           caseRecord.Clinical_Specialty_Assignment__c = component.find('Clinical_Specialty_Assignment').get('v.value');
           caseRecord.Date_of_Specialty_Assignment__c = component.find('Date_of_Specialty_Assignment').get('v.value');
           caseRecord.Clinical_Team_Member_Assignment__c = component.find('Clinical_Team_Member_Assignment').get('v.value');
           caseRecord.Clinical_Intake_Complete__c = component.find('Clinical_Intake_Complete').get('v.value');
           caseRecord.Clinical_Process_Complete__c = component.find('Clinical_Process_Complete').get('v.value');
           //caseRecord.Location__c = component.find('Location').get('v.value');
           //caseRecord.History_of_Present_Illness__c = component.find('History_of_Present_Illness').get('v.value');
           //caseRecord.Symptoms__c = component.find('Symptoms').get('v.value');
           //caseRecord.KPS__c = component.find('KPS').get('v.value');
           //caseRecord.Treatment_Received__c = component.find('Treatment_Received').get('v.value');
           //caseRecord.Obtain_Records_From__c = component.find('Obtain_Records_From').get('v.value');
           //caseRecord.Routing_Comments__c = component.find('Routing_Comments').get('v.value');
           caseRecord.Patient_Diagnosis__c = component.find('Patient_Diagnosis__c').get('v.value');
           caseRecord.Patient_MD_Recommends__c = component.find('Patient_MD_Recommends__c').get('v.value');
           caseRecord.Denied_By__c = component.find('Denied_By').get('v.value');
           caseRecord.Referred_To_Other__c = component.find('Referred_To_Other').get('v.value');
           caseRecord.Intake_Status__c = component.find('Intake_Status').get('v.value');
           caseRecord.referred_To_COHMD__c = component.find('referredToCOHMD').get('v.value');
           //caseRecord.Epic_Location_Pool_Registry__c = component.find('Epic_Location_Pool_Registry').get('v.value');
           if(component.get('V.mHospiceStatusVal') == 'Admitted') {
               caseRecord.Status = 'Inquiry';
               caseRecord.Closed_Reason__c = '';
               
               var inquiryType = component.find('Inquiry_Type')
               var inquiryTypeValue =  Array.isArray(inquiryType) ? inquiryType[0].get('v.value'):inquiryType.get("v.value");
               if (inquiryTypeValue == '' || inquiryTypeValue == null || inquiryTypeValue == 'None') {
                  // component.set("v.mLoading", false);// added by Vara                   
                   helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Inquiry Type' field cannot be empty. ");
                   return;
               } else {
                   caseRecord.Inquiry_Type__c = inquiryTypeValue;
               }
           } else if((component.get('V.mHospiceStatusVal') == 'No' && caseRecord.COH_MRN__c == null)||component.get('V.mHospiceStatusVal') == 'Hospice') {
               caseRecord.Status = 'New';
               caseRecord.Inquiry_Type__c = '';
           }
            var hasClinicalSplAssig = component.find("Clinical_Specialty_Assignment").get('v.value');
            if(hasClinicalSplAssig){
               caseRecord.Status = 'Nursing Review';
            }
            var intakeStatusValue = component.get('V.mIntakeStatusListVal');
           if((intakeStatusValue == 'Clinically Denied by MD' || intakeStatusValue == 'All Attempts Made - Case Closed'|| intakeStatusValue == "Patient doesn't want to proceed") && hasClinicalSplAssig) {
               caseRecord.Status = 'Closed - Not Selected';
               var closedReasonValue = component.get('v.mReason_for_Clinical_Denial');
               if (closedReasonValue == '' || closedReasonValue == null || closedReasonValue == 'None') {
                 // component.set("v.mLoading", false);
                   helper.showToast("Error: Clinical Information Not Saved", "error", "The 'closed Reason' field cannot be empty. ");
                   return;
               } else {
                   caseRecord.Closed_Reason__c = closedReasonValue;
               }   
           } else if (intakeStatusValue == 'Clinically Denied by MD' || intakeStatusValue == 'All Attempts Made - Case Closed'|| intakeStatusValue == "Patient doesn't want to proceed") {
               caseRecord.Status = 'Closed - Not Selected';
               var closedReasonValue = component.get('v.mReason_for_Clinical_Denial');
               if (closedReasonValue == '' || closedReasonValue == null || closedReasonValue == 'None') {
                   //component.set("v.mLoading", false);// added by Vara                   
                   helper.showToast("Error: Clinical Information Not Saved", "error", "The 'closed Reason' field cannot be empty. ");
                   return;
               } else {
                   caseRecord.Closed_Reason__c = closedReasonValue;
               }  
           }
            
            
            
        }

        caseRecord.Clinical_Process_Complete__c = component.find('Clinical_Process_Complete').get('v.value');
        console.log('CLINICAL PROCESS',component.find('Clinical_Process_Complete').get('v.value'));
       	   var newCallCenterRepComp = component.find('callCenterRepList');
           var newCaseOwnerAPIName = newCallCenterRepComp.get('v.value');
    
            caseRecord.Diagnosis_Tab_Complete__c = true;
        var patientType = caseRecord.Patient_Type__c;
        /*** changes sanjay- 07/24/20-----Start**/
        if ((patientType == '' || patientType == null)) { /*** Changes by Sanjay Singh -- 03/31/2022-----: set the field required**/
			//component.set("v.mLoading", false);// added by Vara            
            helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Patient Type' field cannot be empty. ");
            return;
        }
        /*** changes sanjay- 07/24/20-----end**/
        var hospiceStatus = this.mapPicklistResponse(component.get('v.mHospiceStatusVal'));
        if (hospiceStatus == '' || hospiceStatus == null) {
			//component.set("v.mLoading", false);//added by Vara             
            helper.showToast("Error: Clinical Information Not Saved", "error", "The 'Is patient currently admitted/on hospice?' field cannot be empty. ");
            return;
        } else {
	        caseRecord.Patient_Hospice_Status__c = hospiceStatus;
        }
                //START Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
        delete caseRecord.Clinical_Process_Date_Time__c;
        //END Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
        console.log('caseRecord',JSON.parse(JSON.stringify(caseRecord)));

        // Check if the current case owner or physician name have changed
        action.setParams({'caseRecord' : caseRecord, 'physicianStr':physicianStr, 'newCaseOwnerAPIName':newCaseOwnerAPIName});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                //component.set("v.mLoading", false);//vara updated
                var processingCode = response.getReturnValue().ProcessingCode;
                var clinicalTeamMember = response.getReturnValue().ClinicalTeamMember;
                console.log('clinicaTeamMember: ', clinicalTeamMember);
                if (processingCode == 'Success') {
                    component.set('v.mPhysicianChanged', true);
                    //alert(caseRecord.Clinical_Team_Member_Assignment__c);
                    helper.showToast("Clinical Information Saved", "success", "The record has been updated successfully.");
                    component.find('Clinical_Team_Member_Assignment').set('v.value',response.getReturnValue().ClinicalTeamMember); 
                    //location.reload();
                    /*if (caseRecord.COH_MRN__c != null && caseRecord.History_of_Present_Illness__c != null && caseRecord.Obtain_Records_From__c != null 
                        && caseRecord.Symptoms__c != null && caseRecord.KPS__c != null && caseRecord.Treatment_Received__c != null && caseRecord.IsRead__c == true
                        && caseRecord.Epic_Location_Pool_Registry__c != null) {
                        var CreateEPICComp = component.find('CreateEPIC');
        				CreateEPICComp.set("v.disabled", (false));
            		} LK Remove in-Basket*/ 
                } else  if (processingCode == 'Physician Not Located') {
                    // allow the save even though the physician was not found
                    component.set('v.mPhysicianChanged', false);
                    helper.showToast("Clinical Information Saved", "warning", "The record has been updated successfully, but the Physician was not found");
                }
               $A.get('e.force:refreshView').fire();
            } else if (state === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }     
                component.set("v.mLoading", true);// added by Vara
                helper.showToast("Error: Clinical Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
        });
        $A.enqueueAction(action);
    },

    createEPICEncounterValueSet : function (component, event, helper) {
        component.set("v.mLoading", true);
    	var action = component.get('c.saveCreateEPICEncounters');
        var caseRecord = component.get('v.mCase');
        caseRecord.IsRead__c = false;
        // Check if the current case owner or physician name have changed
        action.setParams({'caseRecord' : caseRecord});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                  component.set("v.mLoading", true);
                  var CreateEPICComp = component.find('CreateEPIC');
        		  CreateEPICComp.set("v.disabled", (true));
              	helper.showToast("Clinical", "success", "createEPICEncounter Value updated ");
               $A.get('e.force:refreshView').fire();// added by Vara
            } else if (state === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                } 
                component.set("v.mLoading", true);// added by Vara
                helper.showToast("Error: Clinical Information Not Saved", "error", "An error occurred while attempting to save the record: " + message);
            }
        });
        $A.enqueueAction(action);

	},
    /*
     * Method to call the initCOHCaseDiagnosisTabServer method
     * If the Server side returns SUCCESS, set the values of various components.
     * 
     * @param component				The component
     * @param helper					The helper
     * 
     */
	initCOHCaseClinicalTabClient: function (component, helper) {
		
        var action = component.get('c.initCOHCaseClinicalInfoTabServer');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState == 'SUCCESS') {

                var selectListValues = component.get('v.mSelectListValues');
				var caseRec = response.getReturnValue().Case;
                component.set('v.mCase', caseRec);
				/*START Changes by Sanjay on 04/13/2022: Patient Type changes*/
                const patientTypeOptionMap = response.getReturnValue().patientTypeOptionMap || {};
                component.set("v.patientTypeOptionMap",patientTypeOptionMap);
                component.set("v.patientTypeOptionMapValue",patientTypeOptionMap[caseRec.Patient_Type__c] || '');
                /*END Changes by Sanjay on 04/13/2022: Patient Type changes*/
                selectListValues['Department_Case__c'] = response.getReturnValue().Departments;
                
                selectListValues['Service_Line__c'] = response.getReturnValue().ServiceLines;
                if (Array.isArray(selectListValues['Service_Line__c']) && selectListValues['Service_Line__c'].length > 0 && selectListValues['Service_Line__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Service_Line__c', true);
                }
                
                selectListValues['Specialty__c'] = response.getReturnValue().Specialties;
                if (Array.isArray(selectListValues['Specialty__c']) && selectListValues['Specialty__c'].length > 0 && selectListValues['Specialty__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Specialty__c', true);
                }

                selectListValues['Subgroup_Num__c'] = response.getReturnValue().SubgroupNumbers;;
                if (Array.isArray(selectListValues['Subgroup_Num__c']) && selectListValues['Subgroup_Num__c'].length > 0 && selectListValues['Subgroup_Num__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Subgroup_Num__c', true);
                }
                
                
               selectListValues['Physician_Decision_Tree__c'] = response.getReturnValue().Physicians;
                if (Array.isArray(selectListValues['Physician_Decision_Tree__c']) && selectListValues['Physician_Decision_Tree__c'].length > 0 && selectListValues['Physician_Decision_Tree__c'][0].value != '-Not Applicable-') {
                    component.set('v.mWritable.Physician_Decision_Tree__c', true);
                }

                selectListValues['Strategic_Program__c'] = response.getReturnValue().StrategicPrograms;
                selectListValues['SVC_Diagnosis_Case__c'] = response.getReturnValue().SVCDiagnosis;
                selectListValues['Patient_Type__c'] = response.getReturnValue().PatientType;
                selectListValues['Call_Center_Rep__c'] = response.getReturnValue().CallCenterReps;
                
                //Start Sanjay 08/20/2021-- Hide Values of Patient Type
                var caseRecord = response.getReturnValue().Case;
                if(caseRecord.RecordType.DeveloperName == 'Enterprise_Access_New_Patient'){
                    selectListValues['Patient_Type__c'] = (selectListValues['Patient_Type__c'] || []).filter((data) => {
                        return data.value != 'Newly Diagnosed' && data.value != 'Second Opinion' && data.value != 'Third Opinion'
                        && data.value != 'Re-occurrence';
                    });     
                    component.set("v.mPatientDiagnosedVals",caseRecord.HasPatientBeenDiagnosed__c);
                    var patientDiagnosisComp = component.find('Patient_Diagnosis__c');
       				//patientDiagnosisComp.set("v.disabled", (caseRecord.HasPatientBeenDiagnosed__c == "Yes" ? false : true));
                    if (caseRecord.HasPatientBeenDiagnosed__c == "Yes") {
                        //patientDiagnosisComp.set("v.disabled", false);
                        component.set("v.mPatientDiagnosedVal",caseRecord.Patient_Diagnosis__c);
                    } else {                   
                        window.setTimeout(
                        $A.getCallback(function() {
                        //    patientDiagnosisComp.set("v.disabled", true);
                        }), 400
                   		);
                    }
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.mConfirmedThroughBiopsyVals",caseRecord.ConfirmedThroughBiopsy__c);
                        }), 100
                    );
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.mPatientUndergoneTreatmentVal",caseRecord.HasPatientUndergoneTreatment__c);
                        }), 200
                    );
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.mCurrentlyUndergoingTreatmentVal",caseRecord.CurrentlyUndergoingTreatment__c);
                        }), 300
                    );
                    component.find('mIsPatientIntrestedinacar').set('v.value', caseRecord.Is_patient_interested_in_a_CAR_T_Trial__c);
                    component.find('mIsPatientIntrestedinacar').set('v.value',caseRecord.Is_patient_interested_in_a_CAR_T_Trial__c);
                    component.find('Clinical_Specialty_Assignment').set('v.value',caseRecord.Clinical_Specialty_Assignment__c); 
                    component.find('Date_of_Specialty_Assignment').set('v.value',caseRecord.Date_of_Specialty_Assignment__c );
                    component.find('Clinical_Team_Member_Assignment').set('v.value',caseRecord.Clinical_Team_Member_Assignment__c); 
                    component.find('Date_Nurse_is_assigned').set('v.value',caseRecord.Date_Nurse_is_assigned__c); 
                    component.set('v.mReason_for_Clinical_Denial',caseRecord.Closed_Reason__c);
                    //component.set('v.mReason_Patient_Does_Not_Want_to_Proceed',caseRecord.Reason_Patient_Does_Not_Want_to_Proceed__c); 
                    component.find('Clinical_Intake_Complete').set('v.value',caseRecord.Clinical_Intake_Complete__c); 
                    component.find('Clinical_Process_Complete').set('v.value',caseRecord.Clinical_Process_Complete__c); 
                    //component.find('Location').set('v.value',caseRecord.Location__c); 
                    //component.find('location_pool_name').set('v.value',caseRecord.location_pool_name__c); 
                    //component.find('History_of_Present_Illness').set('v.value',caseRecord.History_of_Present_Illness__c); 
                    //component.find('Symptoms').set('v.value',caseRecord.Symptoms__c);
                    //component.find('KPS').set('v.value',caseRecord.KPS__c); 
                    //component.find('Treatment_Received').set('v.value',caseRecord.Treatment_Received__c);
					//component.find('Obtain_Records_From').set('v.value',caseRecord.Obtain_Records_From__c);
                    //component.find('Routing_Comments').set('v.value',caseRecord.Routing_Comments__c);
                    component.find('Patient_MD_Recommends__c').set('v.value',caseRecord.Patient_MD_Recommends__c);
                    component.find('Denied_By').set('v.value',caseRecord.Denied_By__c);
                    component.find('Referred_To_Other').set('v.value',caseRecord.Referred_To_Other__c);
                    component.set('v.mIntakeStatusListVal',caseRecord.Intake_Status__c);
                    component.find('referredToCOHMD').set('v.value',caseRecord.referred_To_COHMD__c);
                    //component.find('Epic_Location_Pool_Registry').set('v.value',caseRecord.Epic_Location_Pool_Registry__c);
                   if(caseRecord.Patient_Hospice_Status__c == "Admitted") {
                        component.set("v.mAdmittedOnHospice",true);
                        component.find("Intake_Status").set("v.disabled", (true));
                        component.find("Clinical_Specialty_Assignment").set("v.disabled", (true));
                        component.find("Clinical_Team_Member_Assignment").set("v.disabled", (true));
                        component.find('Inquiry_Type').set('v.value',caseRecord.Inquiry_Type__c);
                   } else {
                       //component.find('Inquiry_Type').set('v.value','');
                       component.find("Clinical_Specialty_Assignment").set("v.disabled", (false));
                       component.find("Clinical_Team_Member_Assignment").set("v.disabled", (false));
                       component.find("Intake_Status").set("v.disabled", (false));
                   }

                    /*if (caseRecord.COH_MRN__c != null && caseRecord.History_of_Present_Illness__c != null && caseRecord.Obtain_Records_From__c != null 
                        && caseRecord.Symptoms__c != null && caseRecord.KPS__c != null && caseRecord.Treatment_Received__c != null && caseRecord.IsRead__c == true) {
                        var CreateEPICComp = component.find('CreateEPIC');
        				CreateEPICComp.set("v.disabled", (false));
                    } remove in-Basket LK*/
                }
                //End Sanjay 08/20/2021-- Hide Values of Patient Type
                
                component.set('v.mCancerStatusList', response.getReturnValue().CancerStatus);
                component.set('v.mSelectListValues', selectListValues);

                //Commented by Sanjay - 09/15 var caseRecord = response.getReturnValue().Case;
                if (caseRecord) {
                    component.set('v.mCase', caseRecord);
                    
                    // Set the select list values
                    var originalVal = response.getReturnValue().mPatientDiagnosed;
                    var convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mPatientDiagnosedVal', convertedVal);
                    originalVal = response.getReturnValue().mPatientUndergoneTreatment;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mPatientUndergoneTreatmentVal', convertedVal);
                    originalVal = response.getReturnValue().mConfirmedThroughBiopsy;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mConfirmedThroughBiopsyVal', convertedVal);
                    originalVal = response.getReturnValue().mCurrentlyUndergoingTreatment;
                    convertedVal = (originalVal == true ? "true" : "false");
                    component.set('v.mCurrentlyUndergoingTreatmentVal', convertedVal);

                    var fieldComp = component.find('Patient_MD_Recommends__c');
                    fieldComp.set('v.value', caseRecord.Patient_MD_Recommends__c);
                    
                    //fieldComp = component.find('Referred_To_COH_MD__c');
                    //fieldComp.set('v.value', caseRecord.Referred_To_COH_MD__c);
                    
                    fieldComp = component.find('Patient_Diagnosis__c');
                    fieldComp.set('v.value', caseRecord.Patient_Diagnosis__c);
                    
                    fieldComp = component.find('Subgroup_Num__c');
                    fieldComp.set('v.value', caseRecord.Subgroup_Num__c);
                    
                    component.set('v.mCallCenterRepList', response.getReturnValue().CallCenterReps);
                    component.set('v.mCurCallCenterRep', caseRecord.Call_Center_Rep__c);

                    component.set('v.mHospiceStatus', response.getReturnValue().mHospiceStatus);
                    component.set('v.mHospiceStatusVal', caseRecord.Patient_Hospice_Status__c == null ? '' : caseRecord.Patient_Hospice_Status__c);
                    //component.find('Inquiry_Type').set('v.value',caseRecord.Inquiry_Type__c);
                }
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
                helper.resetField(component, 'Specialty__c');
                helper.resetField(component, 'Physician_Decision_Tree__c');
                helper.resetField(component, 'Service_Line__c');
                helper.resetField(component, 'Subgroup_Num__c');
                
                var serviceLineValues = response.getReturnValue();
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
                helper.resetField(component, 'Physician_Decision_Tree__c');
		        component.set('v.mCase.Subgroup_Num__c', null);
                helper.resetField(component, 'Subgroup_Num__c');
                
                var specialtyValues = response.getReturnValue();
                var gotoNextFunction = helper.handleResponse(component, helper, specialtyValues, 'Specialty__c');
                if (gotoNextFunction) {
                    helper.getSubgroupNumberClient(component, helper);
                    
                }
            } 
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Method to call the server side controller getSubgroupNumberServer
     * If the server side controller does the following: 
     * 1. Returns the subgroup number
     * 2.If the Server side returns SUCCESS, resets the fields dependent on the Physician select list. Then populates the Subgroup_Num__c component.
     * 
     * @param component						The component
     * @param helper						The helper
     */     
    getSubgroupNumberClient : function(component, helper) {
      	var action = component.get('c.getSubgroupNumberServer');
        var department = component.get('v.mCase.Department_Case__c');
        var serviceLine = component.get('v.mCase.Service_Line__c');
        var specialty = component.get('v.mCase.Specialty__c');
        var physician = component.get('v.mCase.Physician_Decision_Tree__c');
        
        action.setParams({department:department, serviceLine:serviceLine, specialty:specialty, physician:physician});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var subgroupNum = response.getReturnValue();
                var gotoNextFunction = helper.handleResponse(component, helper, subgroupNum, 'Subgroup_Num__c');
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
        var subgroupNumber = component.get('v.mCase.Subgroup_Num__c');
        
        action.setParams({department:department, serviceLine:serviceLine, specialty:specialty, subgroupNumber:subgroupNumber});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
		        component.set('v.mCase.Physician_Decision_Tree__c', null);
                var fieldComp = component.find('Physician_Decision_Tree__c');
                fieldComp.set('v.value', null);
                var physicians = response.getReturnValue();
                helper.handleResponse(component, helper, physicians, 'Physician_Decision_Tree__c');
            } 
        });
        $A.enqueueAction(action);
    },    

    
    /*
     * Retrieve the valid Cancer Status picklist entries based on the value of the caseRecord.Has_patient_undergone_treatment__c field.
     * 
     * @param component		Component
     * @param helper			Helper
     * 
     */
    getCancerStatusClient : function(component, helper) {
      	var action = component.get('c.getCancerStatus');
        var fieldComp = component.find('mPatientUndergoneTreatment');
        var patientUndergoneTreatment = fieldComp.get('v.value');
        action.setParams({patientUndergoneTreatment:patientUndergoneTreatment});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var cancerStatusList = response.getReturnValue();
                component.set('v.mCancerStatusList', cancerStatusList);
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
     * Map picklist response values to store in a Yes/No picklist .
     * @param originalVal		Values chosen by the user.
     * @return							'Yes' if  the value is chose, 'No' if it is not, and null otherwise.
     *
     */ 
    mapPicklistResponse : function(originalVal) {
        if (originalVal == null || originalVal == '--None--')  {
            return null;
        } else {
            return originalVal;
        }
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
 
})