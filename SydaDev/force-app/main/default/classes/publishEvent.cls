public class publishEvent {
    
    @AuraEnabled
    public static void publishEvent(String recordId){
        Save_All__e  saveRecord = new Save_All__e();
        saveRecord.RecordId__c  = recordId;
        EventBus.publish(saveRecord);
    }
    
    @AuraEnabled
    public static String ValidateForms(Id caseRecord,String saveAll){
        Map<String,Object> validations = new Map<String,Object>();
        Boolean isErrorInForm = false;
        Map<String,List<String>> mapWithFormNameAndErrors = new Map<String,List<String>>();
        Case Record = [Select id,RecordTypeId,RecordType.DeveloperName,ConfirmedThroughBiopsy__c,HasPatientUndergoneTreatment__c,CurrentlyUndergoingTreatment__c,
                       Patient_Hospice_Status__c,Inquiry_Type__c,Intake_Status__c,Closed_Reason__c,Patient_Type__c,
                       Consenting_Status__c,Consenting_Type__c,Visit_Type_Preference__c,
                       Is_Patient_Requesting_a_Specific_MD__c,Pt_Appt_is_Scheduled_in_how_many_days__c,
                       Service_Category__c,Plan_Type__c,Health_Plan__c,Medical_Group_IPA__c,
                       Line_of_Business_Decision_Tree__c,Does_patient_have_auth_at_time_of_schedu__c,Does_Pt_want_a_sooner_appt__c,
                       Auth__c,Appt_Status__c,Appt_Cancelation_Date__c,Appt_Rescheduled__c,
                       Appt_Cancelation_Email_Sent__c,Appt_Call_Date__c,Coh_mrn__c,Last_Appointment_Scheduled__c,
                       Diagnosis_Not_Listed__c,Department__c,Service_Line__c,Specialty__c,Clinical_Specialty_Assignment__c,
                       Is_patient_diagnosed_with_cancer__c,Does_pt_have_a_biopsy_rltd_to_their_dns__c,Does_pt_have_recent_imgs_releted_to_dns__c from Case where id = :caseRecord LIMIT 1];
        
        if(Record!=null){
            //clinical info - Start
            mapWithFormNameAndErrors.put('clinicalInfo',new List<String>());
            List<String> clinicalInfoErrors = mapWithFormNameAndErrors.get('clinicalInfo');
            if(Record.RecordType.DeveloperName == 'Enterprise_Access_New_Patient'){
                /*if(String.isBlank(Record.ConfirmedThroughBiopsy__c)){
clinicalInfoErrors.add('Confirmed Through Biopsy cannot be blank');
isErrorInForm  = true;
}*/
                if(String.isBlank(Record.HasPatientUndergoneTreatment__c) && Record.ConfirmedThroughBiopsy__c == 'Yes'){
                    clinicalInfoErrors.add('Has patient undergone treatment? cannot be blank');
                    isErrorInForm  = true;
                }
                if(String.isBlank(Record.CurrentlyUndergoingTreatment__c) && Record.HasPatientUndergoneTreatment__c == 'Yes'){
                    clinicalInfoErrors.add('Currently Undergoing Treatment cannot be blank');
                    isErrorInForm  = true;
                }
                if(Record.Patient_Hospice_Status__c == 'Admitted'){
                    if(String.isBlank(Record.Inquiry_Type__c)){
                        clinicalInfoErrors.add('Inquiry Type cannot be blank');
                        isErrorInForm  = true;
                    }
                }
                if((Record.Intake_Status__c == 'Clinically Denied by MD' ||Record.Intake_Status__c == 'Clinically Denied by MD'
                    ||Record.Intake_Status__c == 'Clinically Denied by MD') ) {
                        if(String.isBlank(Record.Closed_Reason__c)){
                            clinicalInfoErrors.add('closed Reason cannot be blank'); 
                            isErrorInForm  = true;
                        }
                    }
                if(String.isBlank(Record.Patient_Type__c)){
                    clinicalInfoErrors.add('Patient Type field cannot be empty'); 
                    isErrorInForm  = true;
                }
                
                //1
                if(String.isBlank(Record.Is_patient_diagnosed_with_cancer__c)){
                    clinicalInfoErrors.add('Is patient diagnosed with cancer? field cannot be empty'); 
                    isErrorInForm  = true;
                }
                if(String.isBlank(Record.Does_pt_have_a_biopsy_rltd_to_their_dns__c)){
                    clinicalInfoErrors.add('Does patient have a biopsy related to their diagnosis? cannot be empty'); 
                    isErrorInForm  = true;
                }
                if(String.isBlank(Record.Does_pt_have_recent_imgs_releted_to_dns__c)){
                    clinicalInfoErrors.add('Does patient have recent images related to their diagnosis? field cannot be empty'); 
                    isErrorInForm  = true;
                }//3
                
                if(String.isBlank(Record.Patient_Hospice_Status__c)){
                    clinicalInfoErrors.add('Is patient currently admitted/on hospice? field cannot be empty'); 
                    isErrorInForm  = true;
                }
                
            }
            // clinical info - End
            // Appointmnet Info - Start
            mapWithFormNameAndErrors.put('appointmentInformation',new List<String>());
            List<String> appointmentInfo = mapWithFormNameAndErrors.get('appointmentInformation');
            if(String.isNotBlank(Record.Coh_mrn__c)){   
                if(String.isNotBlank(Record.Last_Appointment_Scheduled__c)){
                    if(String.isBlank(Record.Consenting_Status__c)){appointmentInfo.add('Consenting Status is a required field');  isErrorInForm  = true;
                                                                   } if(String.isBlank(Record.Consenting_Type__c)){ appointmentInfo.add('Consenting Type is a required field'); isErrorInForm  = true;}
                    if(String.isBlank(Record.Visit_Type_Preference__c)){appointmentInfo.add('Visit Type Preference? is a required field');  isErrorInForm  = true;
                                                                       }
                    if(String.isBlank(Record.Is_Patient_Requesting_a_Specific_MD__c)){appointmentInfo.add('Is Pt. Requesting a Specific MD? is a required field'); isErrorInForm  = true;
                                                                                     }
                    if(String.isNotBlank(Record.Pt_Appt_is_Scheduled_in_how_many_days__c) && Record.Pt_Appt_is_Scheduled_in_how_many_days__c == '8+ Days' && String.isBlank(Record.Does_Pt_want_a_sooner_appt__c)){appointmentInfo.add('Does Pt want a sooner appt? is a required field'); isErrorInForm  = true;
                                                                                                                                                                                                                  }
                }
                
            }else{
                appointmentInfo.add('COH MRN is Blank'); 
                // isErrorInForm  = false;
            } 
            
            if(String.isBlank(Record.Last_Appointment_Scheduled__c)){
                appointmentInfo.add('Appointment is not scheduled'); 
                //isErrorInForm  = true;
            }// Appointmnet Info - End
            // Insurance Matrix - Start
            mapWithFormNameAndErrors.put('insuranceMatrix',new List<String>());
            Boolean isError = false;
            List<String> insuranceMatrix = mapWithFormNameAndErrors.get('insuranceMatrix');
            if(String.isNotBlank(Record.Service_Category__c) && String.isNotBlank(Record.Plan_Type__c) &&
               String.isNotBlank(Record.Health_Plan__c) &&String.isNotBlank(Record.Medical_Group_IPA__c) &&
               String.isNotBlank(Record.Line_of_Business_Decision_Tree__c)){
                   if(Record.Does_patient_have_auth_at_time_of_schedu__c == 'Yes'){ if(String.isBlank(Record.Auth__c)){isError = true;
                                                                                                                      }
                                                                                  }
               }else{
                   isError = true;
                   insuranceMatrix.add('Insurance Matrix cannot be empty'); 
               }
            
            if(Record.Diagnosis_Not_Listed__c || (String.isNotBlank(Record.Department__c) || 
                                                  String.isNotBlank(Record.Service_Line__c)||
                                                  String.isNotBlank(Record.Specialty__c)) ){
                                                      
                                                  }else{
                                                      isError = true;
                                                      insuranceMatrix.add('Physician Matrix cannot be empty');
                                                  }
            if(isError){
                //insuranceMatrix.add('Please fill out all the required field on SCH Guildelines'); 
                isErrorInForm  = true;
            }
            // Insurance Matrix - End
            // Appointmnet Info - Start
            mapWithFormNameAndErrors.put('cancelation',new List<String>());
            List<String> Cancelation = mapWithFormNameAndErrors.get('cancelation');
            if(Record.Appt_Status__c == 'Canceled'){
                if(Record.Appt_Cancelation_Date__c == null){    insuranceMatrix.add('Cancelation Date is required'); isErrorInForm  = true;
                                                           }
                if(String.isBlank(Record.Appt_Rescheduled__c)){ insuranceMatrix.add('Did Patient Reschedule? is required'); isErrorInForm  = true;
                                                              }
                if(Record.Appt_Cancelation_Email_Sent__c == null){insuranceMatrix.add('Cancelation Email Sent Date is required'); isErrorInForm  = true;
                                                                 }
                
            }else if(Record.Appt_Status__c == 'No Show'){
                
                if(Record.Appt_Call_Date__c == null){insuranceMatrix.add('Cancelation Email Sent Date is required'); isErrorInForm  = true;
                                                    }
                if(String.isBlank(Record.Appt_Rescheduled__c)){insuranceMatrix.add('Did Patient Reschedule? is required'); isErrorInForm  = true;
                                                              }
            }
            mapWithFormNameAndErrors.put('newPatientConsenting',new List<String>());
            List<String> newPatientConsenting = mapWithFormNameAndErrors.get('newPatientConsenting');
            if(String.isBlank(Record.Consenting_Type__c)){
                newPatientConsenting.add('Consenting Type field cannot be empty'); 
                isErrorInForm  = true;
            }
            if(Record.Consenting_Status__c!='Scheduled' &&
               Record.Consenting_Status__c!='Completed' &&
               Record.Consenting_Status__c!='Front Office to Complete' ){
                   newPatientConsenting.add('Consenting Status field cannot be empty'); 
                   isErrorInForm  = true;
               }
            
            mapWithFormNameAndErrors.put('cohepicmrn',new List<String>());
            List<String> cohepicmrn = mapWithFormNameAndErrors.get('cohepicmrn');
            if(String.isBlank(Record.COH_MRN__c)){
                cohepicmrn.add('COH MRN not created');  isErrorInForm  = true;
            }
            if(String.isBlank(Record.Clinical_Specialty_Assignment__c)){
                cohepicmrn.add('Clinical Specialty Assignment cannot be empty'); 
                isErrorInForm  = true;
            }
        }
        validations.put('isError',isErrorInForm);
        validations.put('errorMessages',mapWithFormNameAndErrors);
        
        
        
        String queryString = COHUtil.buildSelectAllSOQLStatement('Case') + 'WHERE id = \'' + Record.Id + '\'';
        queryString = queryString.replace(' from ', ', RecordType.DeveloperName FROM ');
        Case queriedCase = Database.query(queryString);
        
        if (queriedCase != null) {        
            validations.put('Case', queriedCase);
            
        }
        
        
        
        
        // return returnValue;
        
        if(saveAll == 'saveAll'){
            Save_Record__e saveRecord = new Save_Record__e();
            saveRecord.Record_Id__c = caseRecord;
            saveRecord.Error_Message__c = json.serialize(validations);
            EventBus.publish(saveRecord);
        }
        
        
        
        return json.serialize(validations);
        //Clinical Form
    }
}