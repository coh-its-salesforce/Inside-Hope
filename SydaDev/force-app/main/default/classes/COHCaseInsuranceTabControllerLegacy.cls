/* 
 * This controller class contains the methods for working on Cases for Patient Screen Unification.
 * Although the name implies it's only for the Insurance Tab, it encompasses the other tabs. The 
 * name wasn't changed for legacy reasons.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public with sharing class COHCaseInsuranceTabControllerLegacy {

    // Identify Boolean fields that need to be converted to Yes/No picklists
    private static final String INSURANCE_LOA_REQUIRED_FIELD_ID = 'mLOA_Required__c';
    private static final String INSURANCE_VERIFIED_FIELD_ID = 'mInsurance_Verified__c';
    private static final String INSURANCE_AUTH_REQUIRED_FIELD_ID = 'mAuth_Required__c';
    private static final String PATIENT_REGISTERED_FIELD_ID = 'mPatientRegistered';
    private static final String PATIENT_DIAGNOSED_FIELD_ID = 'mPatientDiagnosed';
    private static final String PATIENT_SCHEDULED_FIELD_ID = 'mPatientScheduledFirstCall';
    private static final String PATIENT_UNDERGONE_TREATMENT_FIELD_ID = 'mPatientUndergoneTreatment';
    
    private static final String PATIENT_APPOINTMENT_NOT_OFFERED_REASONS_FIELD_ID = 'mPatientAppointmentNotOfferedReasons';
    private static final String PATIENT_CONFIRMED_BIOPSY_FIELD_ID = 'mConfirmedThroughBiopsy';
    private static final String PATIENT_CURRENTLY_UNDERGOING_TREATMENT_FIELD_ID = 'mCurrentlyUndergoingTreatment';
    private static final String PROCUREMENT_RECORDS_NOT_NEEDED_FIELD_ID = 'mRecordsNoLongerNeeded';
    private static final String PROCUREMENT_RECORDS_RECEIVED_FIELD_ID = 'mAllRecordsReceived';
    private static final String PROCUREMENT_INSURANCE_FIELD_ID = 'mInsuranceCard';
    private static final String PROCUREMENT_NEW_PATIENT_PACKET_FIELD_ID = 'mNewPatientPacket';
    private static final String PROCUREMENT_MEDICATIONS_FIELD_ID = 'mMedications';

    private static final String CASE_OBJ = 'Case';
    private static final String CANCELATION_APPT_STATUS_ID = 'mApptStatus';
    private static final String CANCELATION_REASON_ID = 'mApptCancelationReason';
    private static final String CANCELATION_RESCHEDULE_ID = 'mApptReschedule';
    private static final String CANCELATION_RESULT_CONFIRMATION_ID = 'mApptResultConfirmationStatus';
    private static final String CANCELATION_USER_FIRST_NAME_ID = 'mCanceledByFirstName';
    private static final String CANCELATION_LAST_FIRST_NAME_ID = 'mCanceledByLastName';
    private static final String CANCELATION_IS_AUTHORIZED = 'mIsCancelationAuthorized';
    private static final String DECLINED_TO_MOVE_APPT_ID = 'mMDDeclinedToMoveUpAppt';
    private static final String HOSPICE_STATUS_ID = 'mHospiceStatus';
    
    
    private static Id COHContactRecordType = null;
    
    private static List<COH_PRS_Configuration__mdt> mCancelNotificationUsersList = null;
    private static Map<String, String> mAuthorizedCancelationUsers = new Map<String, String>();     // Map of employee IDs to names
    private static String mCancelationNotificationSubject = null;
    private static String mCancelMessageTemplate = null;
    private static User mSystemAccountUser = null;
        
    static {
        COHContactRecordType = COHUtil.getRecordType('Contact', 'COH Contacts');
        
        // Retrieve the users who will receive emails when appointments are cancelled
        mCancelNotificationUsersList = [select Value__c from COH_PRS_Configuration__mdt where Configuration_Group__c = 'Cancelation_Notification_ID'    and Is_Active__c = true];
        if (!COHUtil.isValidList(mCancelNotificationUsersList)) {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.initialization: Error: no users were identified as receiving notification emails');
        }
            
        // Retrieve the default email subject when cancelation notifications are sent
        List<COH_PRS_Configuration__mdt> cancelNotificationEmailSubjectList = [select Value__c from COH_PRS_Configuration__mdt where DeveloperName = 'Cancelation_Email_Subject'    and Is_Active__c = true];
        if (COHUtil.isValidList(cancelNotificationEmailSubjectList)) {
            COH_PRS_Configuration__mdt configObj = cancelNotificationEmailSubjectList.get(0);
            mCancelationNotificationSubject = configObj.Value__c;
            if (String.isEmpty(mCancelationNotificationSubject)) {
                throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.initialization: Error: no value supplied for the appointment cancelation subject');
            }
        }
        
        // Retrieve default system account user for sending emails
        List<User> usrObjList = [select Firstname, Lastname, Email from User where Alias =: 'saccount'];
        if (COHUtil.isValidList(usrObjList)) {
            mSystemAccountUser = usrObjList.get(0);
        } else {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.initialization: Error: system account user not found');
        }
        
        // Retrieve the default email body template when cancelation notifications are sent
        List<COH_PRS_Configuration__mdt> cancelNotificationEmailBodyTemplateList = [select Value__c from COH_PRS_Configuration__mdt where DeveloperName = 'Cancelation_Email_Body_Template' and Is_Active__c = true];
        if (COHUtil.isValidList(cancelNotificationEmailBodyTemplateList)) {
            COH_PRS_Configuration__mdt configObj = cancelNotificationEmailBodyTemplateList.get(0);
            mCancelMessageTemplate = configObj.Value__c;
            if (String.isEmpty(mCancelMessageTemplate)) {
                throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.initialization: Error: empty template for the appointment cancelation message body');
            }
        }
        
        // Retrieve the users who are permitted to cancel an appointment
        List<COH_PRS_Configuration__mdt> authorizedCancelationUserList = [select Value__c from COH_PRS_Configuration__mdt where Configuration_Group__c = 'Authorized to Cancel' and Is_Active__c = true];
        if (COHUtil.isValidList(authorizedCancelationUserList)) {
            for (COH_PRS_Configuration__mdt configObj :authorizedCancelationUserList ) {
                String userInfoStr = configObj.Value__c;
                if (String.isNotEmpty(userInfoStr)) {
                    List<String> userTokens =  userInfoStr.split(';');
                    mAuthorizedCancelationUsers.put(userTokens.get(1), userTokens.get(0));
                }
            }
        }
    }
    
    /****Start** Changes made by Sanjay Singh - Date : 04-19-2020 ******/
    private static final string VIDEO_EMAIL_TEMPLATE_NAME = 'Send_Video_Email';
    @AuraEnabled
    public static Map<String, Object> sendVideoEmail(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();
        try{
            Case c = [Select id, AccountId, ContactId, Email_Video_Sent__c from Case where id=:recordId];
            List<EmailTemplate> templates = [SELECT Id, Name, DeveloperName, IsActive, Subject, HtmlValue, Body 
                                                FROM EmailTemplate Where DeveloperName =: VIDEO_EMAIL_TEMPLATE_NAME];
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(c.ContactId); 
            message.setSenderDisplayName('City of Hopes'); 
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(true); 
            message.setTemplateID(templates[0].Id); 
            message.setWhatId(c.Id); //This is important for the merge fields in template to work
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.sendEmail(messages);
            if(!c.Email_Video_Sent__c){
                c.Email_Video_Sent__c = true;
                update c;
            }
            returnValue.put('issuccess', true);
            returnValue.put('message', 'Email has been sent successfully.');
        }Catch(Exception e){
            returnValue.put('issuccess', false);
            returnValue.put('message', e.getMessage());
        }
        return returnValue;
    }
    
    /****End**  Changes made by Sanjay Singh- date : 04-19-2020 ******/
    
    
    
    
    /*
     * Initialize the COHCase InsuranceTab Lightning component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * 
     * @parameter Id recordId               The id of the Case record to return
     * @return Map<String, Object>          A Map containing the Case record associated with the recordId.
     *                                                  Also contains the Selectlist values for Case record. These values are populated from the COHCaseInsuranceDecisionTree__c custom setting
     * @throws                                          NoAccessException if the user does not have Read access to listed fields.
     * 
     */
    @AuraEnabled
    public static Map<String, Object> initCOHCaseInsuranceTabServer(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();
        List<String> fieldsToAccess = new List<String> {'id', 'Plan_Type__c', 'Line_of_Business_Decision_Tree__c', 'Health_Plan__c', 'Medical_Group_IPA__c', 'Duarte_or_Community__c', 'Auth_Required__c', 'LOA_Required__c', 'Insurance_Verified__c', 'Auth_Follow_Up_Complete__c', 'Auth_Insurance_Notes__c', 'Medical_Group_IPA__c','Auth_Required__c', 'Auth_Received__c', 'LOA_Complete__c' };
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        Case queriedCase = [SELECT id, Plan_Type__c, Line_of_Business_Decision_Tree__c, Health_Plan__c, Medical_Group_IPA__c, Duarte_or_Community__c, Auth_Required__c, LOA_Required__c, Insurance_Verified__c, Auth_Follow_Up_Complete__c, Auth_Insurance_Notes__c, Auth__c, CC_Primary_insurance__c, Auth_Received__c, LOA_Complete__c FROM Case WHERE id=:recordId];
        if (queriedCase != null) {
            returnValue.put('Case', queriedCase);
            returnValue.put('Plan_Type', getPlanTypeValues());
            returnValue.put('Line_Of_Business', getLineOfBusinessValuesServer(queriedCase.Plan_Type__c));
            returnValue.put('Health_Plan', getHealthPlanValuesServer(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c));
            returnValue.put('IPA_Medical_Group', getMedicalGroupIPAValuesServer(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c));
            returnValue.put('Location', getLocationValuesServer(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put(INSURANCE_LOA_REQUIRED_FIELD_ID, queriedCase.LOA_Required__c);
            returnValue.put(INSURANCE_VERIFIED_FIELD_ID, queriedCase.Insurance_Verified__c);
            returnValue.put(INSURANCE_AUTH_REQUIRED_FIELD_ID, queriedCase.Auth_Required__c);
        }
        return returnValue;
    }

    /*
     * Initialize the COHCaseClinicalInfo Tab Lightning component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * 
     * @parameter Id recordId               The id of the Case record to return
     * @return Map<String, Object>          A Map containing the Case record associated with the recordId.
     *                                                          Also contains the Select list values for Case record. 
     * @throws                                          NoAccessException if the user does not have Read access to listed fields.
     * 
     */
    
    @AuraEnabled
    public static Map<String, Object> initCOHCaseClinicalInfoTabServer(Id recordId) {

        Map<String, Object> returnValue = new Map<String, Object>();
        List<String> fieldsToAccess = new List<String> {'id', 'Has_patient_been_diagnosed_CheckBox__c', 'Has_patient_undergone_treatment__c',
                    'Confirmed_Through_Biopsy__c', 'Currently_Undergoing_Treatment__c', 'Plan_Type__c', 'Line_of_Business_Decision_Tree__c', 'Health_Plan__c', 'Medical_Group_IPA__c',
                    'Duarte_or_Community__c', 'Auth_Required__c', 'LOA_Required__c', 'Insurance_Verified__c', 'Auth_Follow_Up_Complete__c', 'Auth_Insurance_Notes__c',
                    'Department_Case__c', 'Service_Line__c', 'Specialty__c', 'Physician_Decision_Tree__c', 'Appt_Date__c', 'Patient_Diagnosis__c', 'Patient_Type__c', 
                    'Call_Center_Rep__c', 'Cancer_Status__c', 'OwnerId', 'AccountId', 'Subgroup_Num__c', 'Patient_Hospice_Status__c'};
                        
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
		/**** Changes made by Sanjay ** Date 07/14/20**** Added RecordType field in query****** start****/
        String queryStr = 'SELECT id, Has_patient_been_diagnosed_CheckBox__c,  Has_patient_undergone_treatment__c,  Confirmed_Through_Biopsy__c, ' +
            'Currently_Undergoing_Treatment__c, Plan_Type__c, Line_of_Business_Decision_Tree__c, Health_Plan__c, Medical_Group_IPA__c, ' +
            'Duarte_or_Community__c, Auth_Required__c, LOA_Required__c, Insurance_Verified__c, Auth_Follow_Up_Complete__c, Call_Center_Rep__c, ' +
            'Auth_Insurance_Notes__c, Auth__c, Department_Case__c, Service_Line__c, Specialty__c, Physician_Decision_Tree__c, Appt_Date__c, ' + 
            'Patient_MD_Recommends__c, Referred_To_COH_MD__c, SVC_Diagnosis_Case__c, Strategic_Program__c, Patient_Diagnosis__c, ' +
            ' Patient_Type__c, Cancer_Status__c, Subgroup_Num__c, OwnerId, AccountId, Patient_Hospice_Status__c, RecordType.DeveloperName FROM Case WHERE id=:recordId';
        
		/**** Changes ****** End****/        
        Case caseRecord = Database.query(queryStr);
        
        if (caseRecord != null) {
            returnValue.put('Case', caseRecord);
            returnValue.put(PATIENT_DIAGNOSED_FIELD_ID, caseRecord.Has_patient_been_diagnosed_CheckBox__c);
            returnValue.put(PATIENT_UNDERGONE_TREATMENT_FIELD_ID, caseRecord.Has_patient_undergone_treatment__c );
            returnValue.put(PATIENT_CONFIRMED_BIOPSY_FIELD_ID, caseRecord.Confirmed_Through_Biopsy__c );
            returnValue.put(PATIENT_CURRENTLY_UNDERGOING_TREATMENT_FIELD_ID, caseRecord.Currently_Undergoing_Treatment__c);
            returnValue.put(HOSPICE_STATUS_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Patient_Hospice_Status__c', true));
            
            returnValue.put('Departments', getDepartmentValuesServer());
            returnValue.put('ServiceLines', getServiceLineValuesServer(caseRecord.Department_Case__c));
            returnValue.put('Specialties', getSpecialtyValuesServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c));
            returnValue.put('SubgroupNumbers', getSubgroupNumberServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c, caseRecord.Specialty__c));
            returnValue.put('Physicians', getPhysiciansServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c, caseRecord.Specialty__c, caseRecord.Subgroup_Num__c));
            returnValue.put('StrategicPrograms', getStrategicPrograms());
            returnValue.put('SVCDiagnosis', getSVCDiagnosis());
            returnValue.put('PatientType', getPatientType());
            returnValue.put('CallCenterReps', getCallCenterReps());
            returnValue.put('CancerStatus', getCancerStatus(caseRecord.Has_patient_undergone_treatment__c));
        }
        return returnValue;
    }

    /*
     * Initialize the COHCase Procurement Tab Lightning component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * 
     * @parameter Id recordId               The id of the Case record to return
     * @return Map<String, Object>          A Map containing the Case record associated with the recordId.
     *                                                          Also contains the Select list values for Case record. 
     * @throws                                          NoAccessException if the user does not have Read access to listed fields.
     * 
     */
    @AuraEnabled
    public static Map<String, Object> initCOHCaseProcurementTabServer(Id recordId) {

        Map<String, Object> returnValue = new Map<String, Object>();
        List<String> fieldsToAccess = new List<String> {'id', 'PRSpecialist_Assignment__c', 'All_Records_Recieved__c', 'Records_No_Longer_Needed__c', 
                    'Imaging_Status__c', 'How_Many_Locations_Imaging_Status_1__c', 'Comments_Imaging_Status_1__c', 
                    'X2nd_Request_Imaging_Status__c', 'How_Many_Locations_Imaging_Status_2__c', 'Comments_Imaging_Status_2__c',
                    'X3rd_Request_Imaging_Status__c', 'How_Many_Locations_Imaging_Status_3__c', 'Comments_Imaging_Status_3__c',  'MD_Note_Status__c', 
                    'X1st_Request_MD_Notes__c', 'How_Many_Locations_MD_Notes_1__c', 'Comments_MD_Notes_1__c',
                    'X2nd_Request_MD_Notes__c', 'How_Many_Locations_MD_Notes_2__c', 'Comments_MD_Notes_2__c',
                    'X3rd_Request_MD_Notes__c', 'How_Many_Locations_MD_Notes_3__c', 'Comments_MD_Notes_3__c', 'Pathology_Status__c',
                    'X1st_Request_Pathology__c', 'How_Many_Locations_Pathology_1__c', 'Comments_Pathology_1__c',
                    'X2nd_Request_Pathology__c', 'How_Many_Locations_Pathology_2__c', 'Comments_Pathology_2__c',
                    'X3rd_Request_Pathology__c', 'How_Many_Locations_Pathology_3__c', 'Comments_Pathology_3__c',
                    'Confirmation_Email_Sent__c', 'Insurance_Card_ID__c', 'Confirmation_Call_Completed__c', 'New_Patient_Packet__c', 
                    'Result_of_Confirmation_Call__c', 'Medications__c', 'Date_PRS_Specialist_Is_Assigned__c'};
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }

        String queryStr = 'select id, PRSpecialist_Assignment__c, All_Records_Recieved__c, Records_No_Longer_Needed__c, ' + 
                    'Imaging_Status__c, How_Many_Locations_Imaging_Status_1__c, Comments_Imaging_Status_1__c, ' + 
                    'X2nd_Request_Imaging_Status__c, How_Many_Locations_Imaging_Status_2__c, Comments_Imaging_Status_2__c, ' + 
                    'X3rd_Request_Imaging_Status__c, How_Many_Locations_Imaging_Status_3__c, Comments_Imaging_Status_3__c,  MD_Note_Status__c, ' + 
                    'X1st_Request_MD_Notes__c, How_Many_Locations_MD_Notes_1__c, Comments_MD_Notes_1__c, ' + 
                    'X2nd_Request_MD_Notes__c, How_Many_Locations_MD_Notes_2__c, Comments_MD_Notes_2__c, ' + 
                    'X3rd_Request_MD_Notes__c, How_Many_Locations_MD_Notes_3__c, Comments_MD_Notes_3__c, Pathology_Status__c, ' +
                    'X1st_Request_Pathology__c, How_Many_Locations_Pathology_1__c, Comments_Pathology_1__c, ' +
                    'X2nd_Request_Pathology__c, How_Many_Locations_Pathology_2__c, Comments_Pathology_2__c, ' +
                    'X3rd_Request_Pathology__c, How_Many_Locations_Pathology_3__c, Comments_Pathology_3__c, ' +
                    'Confirmation_Email_Sent__c, Insurance_Card_ID__c, Confirmation_Call_Completed__c, New_Patient_Packet__c, ' +
                    'Result_of_Confirmation_Call__c, Medications__c, Date_PRS_Specialist_Is_Assigned__c from Case where id = :recordId';
        
        Case caseRecord = Database.query(queryStr);
        
        
        if (caseRecord != null) {
            returnValue.put('Case', caseRecord);
            returnValue.put(PROCUREMENT_RECORDS_NOT_NEEDED_FIELD_ID, caseRecord.Records_No_Longer_Needed__c);
            returnValue.put(PROCUREMENT_RECORDS_RECEIVED_FIELD_ID, caseRecord.All_Records_Recieved__c );
            returnValue.put(PROCUREMENT_INSURANCE_FIELD_ID, caseRecord.Insurance_Card_ID__c );
            returnValue.put(PROCUREMENT_NEW_PATIENT_PACKET_FIELD_ID, caseRecord.New_Patient_Packet__c );
            returnValue.put(PROCUREMENT_MEDICATIONS_FIELD_ID, caseRecord.Medications__c );
        }
        return returnValue;
    }

    /*
     * Initialize the COHCaseAppointmentInformationTab Lightning component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * 
     * @parameter Id recordId               The id of the Case record to return
     * @return Map<String, Object>          A Map containing the Case record associated with the recordId.
     *                                                  Also contains the Selectlist values for Case record. These values are populated from the COHCaseInsuranceDecisionTree__c custom setting
     * @throws                                          NoAccessException if the user does not have Read access to listed fields.
     * 
     */
    @AuraEnabled
    public static Map<String, Object> initCOHCaseAppointmentInformationTabServer(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();
        /**** Changes made by Sanjay Singh - Date : 04-19-2020 ***Start***/
        //Added Email_Video_Sent__c field
        List<String> fieldsToAccess = new List<String> {'id','Patient_Registered__c', 'If_Not_Registered_Explain__c', 'Pt_scheduled_1st_Call__c', 'If_Pt_Not_Scheduled_1st_Call_Explain__c', 
                    'Patient_Offered_Appointment__c', 'Reason_Not_Offered_Appt_Within_2_Days__c', 'Appt_Date_Time__c', 'Clinical_Team_Member_Assignment__c', 'COH_MRN__c',
                    'OwnerId', 'AccountId', 'Reached_out_to_MD_to_move_up_app_pkl__c', 'Date_Nurse_is_assigned__c', 'Patient_Status_Case__c', 'Completed_Clinically_Denied_Reason__c', 
                    'Clinical_Intake_Complete__c',  'Clinical_Process_Complete__c', 'Date_Email_Sent_to_MD__c', 'Date_MD_Response__c', 'Date_MD_Decision__c', 'Decline_to_move_up_appt__c',
                    'Auth_Needed__c', 'Is_Patient_Requesting_a_Specific_MD__c', 'Email_Video_Sent__c'};
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        String queryStr = 'select id, Patient_Registered__c, If_Not_Registered_Explain__c, Pt_scheduled_1st_Call__c, If_Pt_Not_Scheduled_1st_Call_Explain__c, ' + 
                'Patient_Offered_Appointment__c, Reason_Not_Offered_Appt_Within_2_Days__c, Appt_Date_Time__c, Clinical_Team_Member_Assignment__c, COH_MRN__c, ' +
                'OwnerId, AccountId, Reached_out_to_MD_to_move_up_app_pkl__c, Date_Nurse_is_assigned__c, Patient_Status_Case__c, Completed_Clinically_Denied_Reason__c, ' +
                'Clinical_Intake_Complete__c, Clinical_Process_Complete__c, Date_Email_Sent_to_MD__c, Date_MD_Response__c, Date_MD_Decision__c, ' + 
                'Decline_to_move_up_appt__c, Auth_Needed__c, Is_Patient_Requesting_a_Specific_MD__c, Email_Video_Sent__c ' +
                'from Case WHERE id=:recordId';

        /**** Changes made by Sanjay Singh - date : 04-19-2020 ***END***/
        
        Case caseRecord = Database.query(queryStr);
        if (caseRecord != null) {
            returnValue.put('Case', caseRecord);
            returnValue.put(PATIENT_APPOINTMENT_NOT_OFFERED_REASONS_FIELD_ID, getAppointmentNotOfferedReasons());
            returnValue.put(PATIENT_REGISTERED_FIELD_ID, caseRecord.Patient_Registered__c);
            returnValue.put(PATIENT_SCHEDULED_FIELD_ID, caseRecord.Pt_scheduled_1st_Call__c );
            returnValue.put(DECLINED_TO_MOVE_APPT_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Decline_to_move_up_appt__c', true));
            returnValue.put('PatientStatus', getPatientStatus());
            returnValue.put('ClinicallyDeniedReasons', getCompletedClinicallyDeniedValuesServer(caseRecord.Patient_Status_Case__c));
            returnValue.put('ClinicalTeamMembers', getClinicalTeamMembers());

        }
        return returnValue;
    }

    /*
     * Initialize the COHCaseAppointmentCancelationTab Lightning component. 
     * It returns a Map of information that the Javascript function is responsible for parsing.
     * 
     * @parameter Id recordId               The id of the Case record to return
     * @return Map<String, Object>          A Map containing the Case record associated with the recordId.
     * @throws                                          NoAccessException if the user does not have Read access to listed fields.
     * 
     */
    @AuraEnabled
    public static Map<String, Object> initCOHCaseAppointmentCancelationInfoTabServer(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();

        List<String> fieldsToAccess = new List<String> {'id', 'OwnerId', 'AccountId', 'Appt_Status__c', 'Appt_Cancelation_Date__c',
                'Appt_Canceled_By__c', 'Appt_Cancelation_Reason__c', 'Appt_Call_Date__c', 'Appt_Rescheduled__c', 'Appt_New_DateTime__c', 
                'Appt_Confirm_Email_Sent__c', 'Appt_Confirmation_Call_Completed__c', 'Appt_Result_of_Confirmation_Call__c', 'Appt_Notify_Leadership__c', 
                'Appt_Cancelation_Email_Sent__c', 'Appt_Cancelation_Reason_Other__c', 'Patient_Last_Name__c', 'Patient_First_Name__c', 'COH_MRN__c'};
            
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                System.debug('Error: NoAccessException thrown for this field: ' + fieldToCheck);
                throw new System.NoAccessException();
            }
        }
        String queryStr = 'select id,  OwnerId, AccountId, Appt_Status__c, Appt_Cancelation_Date__c, Appt_Canceled_By__c,' +
                ' Appt_Cancelation_Reason__c, Appt_Call_Date__c, Appt_Rescheduled__c, Appt_New_DateTime__c, Appt_Confirm_Email_Sent__c,' +
                ' Appt_Confirmation_Call_Completed__c, Appt_Result_of_Confirmation_Call__c, Appt_Notify_Leadership__c, ' +
                ' Appt_Cancelation_Email_Sent__c, Appt_Cancelation_Reason_Other__c, Patient_Last_Name__c, Patient_First_Name__c, ' + 
                ' COH_MRN__c from Case WHERE id=:recordId';

        
        Case caseRecord = Database.query(queryStr);
        if (caseRecord != null) {
            returnValue.put(CASE_OBJ, caseRecord);
            returnValue.put(CANCELATION_APPT_STATUS_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Appt_Status__c', true));
            returnValue.put(CANCELATION_REASON_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Appt_Cancelation_Reason__c', true));
            returnValue.put(CANCELATION_RESCHEDULE_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Appt_Rescheduled__c', true));
            returnValue.put(CANCELATION_RESULT_CONFIRMATION_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Appt_Result_of_Confirmation_Call__c', true));

            // Check if the user is authorized to cancel appointments            
            Id userID =  UserInfo.getUserId();
            Boolean isCancelationAuthorized = false;
            String userQueryStr = 'select Id, FirstName, LastName, EmployeeNumber from User where Id = :userID';
            List<User> userRecList = Database.query(userQueryStr);
            if (COHUtil.isValidList(userRecList)) {
                User userRec = userRecList.get(0);
                if (userRec != null) {
                    String userName = mAuthorizedCancelationUsers.get(userRec.EmployeeNumber);
                    if (String.isNotEmpty(userName)) { 
                        isCancelationAuthorized = true;
                    } 
                }
            }
            returnValue.put(CANCELATION_IS_AUTHORIZED, isCancelationAuthorized);
            
            // Retrieve the information for the user who canceled the appointment, if applicable
            String canceledByUserFirstName = null;
            String canceledByUserLastName = null;
            Id canceledByUserID = caseRecord.Appt_Canceled_By__c;
            if (String.isNotEmpty(canceledByUserID)) {
                userQueryStr = 'select Id, FirstName, LastName from User where Id = :canceledByUserID';
                userRecList = Database.query(userQueryStr);
                if (COHUtil.isValidList(userRecList)) {
                    User userRec = userRecList.get(0);
                    if (userRec != null) {
                        canceledByUserFirstName = userRec.FirstName;
                        canceledByUserLastName = userRec.LastName;
                    }
                }
            }
            returnValue.put(CANCELATION_USER_FIRST_NAME_ID, canceledByUserFirstName);
            returnValue.put(CANCELATION_LAST_FIRST_NAME_ID, canceledByUserLastName);
        }
        return returnValue;
    }
    
    
    /*
     * Retrieve the reasons why an appointment was not offered.  These are found in the 
     * Case.Reason_Not_Offered_Appt_Within_2_Days__c picklist.
     * 
     * @return          Map of active values for reasons why an appointment was not offered
     * 
     */
    private static List<Map<String, String>> getAppointmentNotOfferedReasons(){
        List<Map<String, String>> reasonsList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Reason_Not_Offered_Appt_Within_2_Days__c.getDescribe();
        List<Schema.PicklistEntry> reasonList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : reasonList) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                reasonsList.add(tempMap);
            }
        }
        return reasonsList;
    }
    
    /*
     * Retrieve the valid Patient Status. These are found in the Case.Patient_Status_Case__c picklist.
     * 
     * @return          Map of active values for valid patient status
     * 
     */
    private static List<Map<String, String>> getPatientStatus(){
        List<Map<String, String>> reasonsList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Patient_Status_Case__c.getDescribe();
        List<Schema.PicklistEntry> reasonList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : reasonList) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                reasonsList.add(tempMap);
            }
        }
        return reasonsList;
    }
    
    /*
     * Retrieve the reasons why the patient was completed or clinically-denied. 
     * These are found in the Case.Completed_Clinically_Denied_Reason__c picklist.
     * 
     * @return          List containing a Map of active dependendent values for corresponding valid patient status
     * 
     */
    @AuraEnabled
    public static List<Map<String, String>> getCompletedClinicallyDeniedValuesServer(String controllingFieldValue) {
        List<Map<String, String>> reasonsList = null;
        if (String.isNotEmpty(controllingFieldValue)) {
            Map<Object,List<Schema.PicklistEntry>> depValuesMap = COHUtil.getDependentPicklistValues('Case', 'Completed_Clinically_Denied_Reason__c');
            if (depValuesMap != null) {
                List<Schema.PicklistEntry> dependentPicklistEntries = depValuesMap.get(controllingFieldValue);
                if (COHUtil.isValidList(dependentPicklistEntries)) {
                    for (Schema.PicklistEntry picklistObj : dependentPicklistEntries) {
                        Boolean isActive = picklistObj.isActive();
                        if (isActive) {
                            Map<String, String> tempMap = new Map<String, String>();
                            tempMap.put('label', picklistObj.getLabel());
                            tempMap.put('value', picklistObj.getValue());
                            if (reasonsList == null) {
                                reasonsList = new List<Map<String, String>>();
                            }
                            reasonsList.add(tempMap);
                        }
                    }
                }
            }
        }
        return reasonsList;
    }

    /*
     * Method to get all possible Plan Types in the COHCaseInsuranceDecisionTree__c custom setting
     * 
     * @return List<Map<String, String>>            the possible values of Plan Type 
     */ 
    @TestVisible
    private static List<Map<String, String>> getPlanTypeValues() {
        List<AggregateResult> planTypes = [SELECT Plan_Type__c FROM COHCaseInsuranceDecisionTree__c GROUP BY Plan_Type__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('Plan_Type__c'));
            tempMap.put('value', (String) i.get('Plan_Type__c'));
            returnValue.add(tempMap);
        }
        return returnValue;
    }
    
    /*
     * Method to get all possible Line of Business in the COHCaseInsuranceDecisionTree__c custom setting based on the supplied parameters
     * 
     * @param String planType                       The selected plan type
     *   
     * @return List<Map<String, String>>            The possible values of Line of Business 
     */  
    @AuraEnabled
    public static List<Map<String,String>> getLineOfBusinessValuesServer(String planType) {
        List<AggregateResult> planTypes = [SELECT Line_of_Business__c FROM COHCaseInsuranceDecisionTree__c WHERE Plan_Type__c=:planType GROUP BY Line_of_Business__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('Line_of_Business__c'));
            tempMap.put('value', (String) i.get('Line_of_Business__c'));
            returnValue.add(tempMap);
        }
        return returnValue;
    }
    
    /*
     * Method to get all possible Health Plan in the COHCaseInsuranceDecisionTree__c custom setting based on the supplied parameters
     * 
     * @param String planType                       The plan type value
     * @param String lineOfBusiness                 The line of business value
     *   
     * @return List<Map<String, String>>            The possible values of Health Plan 
     */   
    @AuraEnabled
    public static List<Map<String, String>> getHealthPlanValuesServer(String planType, String lineOfBusiness) {
        List<AggregateResult> planTypes = [SELECT Health_Plan__c FROM COHCaseInsuranceDecisionTree__c WHERE Plan_Type__c=:planType AND Line_of_Business__c=:lineOfBusiness GROUP BY Health_Plan__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            String tempString = (String) i.get('Health_Plan__c');
            tempMap.put('label', tempString);
            tempMap.put('value', tempString);
            returnValue.add(tempMap);
        }
        
        return returnValue;        
    }
    
    /*
     * Method to get all possible Medical Group / IPA in the COHCaseInsuranceDecisionTree__c custom setting based on the supplied parameters
     * 
     * @param String planType                       The plan type value
     * @param String lineOfBusiness                 The line of business value
     * @param String healthPlan                     The healthPlan value
     *   
     * @return List<Map<String, String>>            The possible values of Medical Group / IPA 
     */      
    @AuraEnabled
    public static List<Map<String, String>> getMedicalGroupIPAValuesServer(String planType, String lineOfBusiness, String healthPlan) {
        List<AggregateResult> planTypes = [SELECT IPA_Medical_Group__c FROM COHCaseInsuranceDecisionTree__c WHERE Plan_Type__c=:planType AND Line_of_Business__c=:lineOfBusiness AND Health_Plan__c=:healthPlan GROUP BY IPA_Medical_Group__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('IPA_Medical_Group__c'));
            tempMap.put('value', (String) i.get('IPA_Medical_Group__c'));
            returnValue.add(tempMap);
        }
        return returnValue;        
    }
    
    /*
     * Method to get all possible Locations in the COHCaseInsuranceDecisionTree__c custom setting based on the supplied parameters
     * 
     * @param String planType                       The plan type value
     * @param String lineOfBusiness                 The line of business value
     * @param String healthPlan                     The healthPlan value
     * @param String medicalGroupIPA                The medicalGroupIPA value
     * 
     * @return List<Map<String, String>>            The possible values of Location
     */    
    @AuraEnabled
    public static List<Map<String, String>> getLocationValuesServer(String planType, String lineOfBusiness, String healthPlan, String medicalGroupIPA) {
        List<AggregateResult> planTypes = [SELECT Location__c FROM COHCaseInsuranceDecisionTree__c WHERE Plan_Type__c=:planType AND Line_of_Business__c=:lineOfBusiness AND Health_Plan__c=:healthPlan AND IPA_Medical_Group__c=:medicalGroupIPA GROUP BY Location__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('Location__c'));
            tempMap.put('value', (String) i.get('Location__c'));
            returnValue.add(tempMap);
        }
        return returnValue;        
    }
    
    /*
     * Method to check if Auth or LOA are required based on the COHCaseInsuranceDecisionTree__c custom setting and the supplied parameters
     * 
     * @param Case                                  The Case record, contains the values needed to determine if Auth and LOA is requred
     * 
     * @return COHCaseInsuranceDecisionTree__c      The possible values of Location
     */  
    @AuraEnabled
    public static COHCaseInsuranceDecisionTree__c getAuthAndLOARequiredServer(Case caseRecord) {
        COHCaseInsuranceDecisionTree__c returnValue = [SELECT Auth_Required__c, LOA_Required__c FROM COHCaseInsuranceDecisionTree__c WHERE Plan_Type__c=:caseRecord.Plan_Type__c AND Line_of_Business__c=:caseRecord.Line_of_Business_Decision_Tree__c AND Health_Plan__c=:caseRecord.Health_Plan__c AND IPA_Medical_Group__c=:caseRecord.Medical_Group_IPA__c AND Location__c=:caseRecord.Duarte_or_Community__c LIMIT 1];
        
        return returnValue;
    }
    
    /*
     * Save the caseRecord from the Insurance tab. This is used because the component is not a lightning:editform.
     * 
     * @param caseRecord            The case record to save
     * @param selectListMap             Map containing the IDs fo the pulldown fields and the Boolean values in those fields
     * @return                          Processing code to indicate the outcome of the operation and 
     *                                  the processing message.
     * 
     */
    @AuraEnabled
    public static void saveCOHCaseInsuranceTabServer(Case caseRecord, Map<String, Boolean> selectListMap) {
        Set<String> keyset = selectListMap.keySet();
        if (keyset.size() > 0) {
            for (String key : keyset)  {
                Boolean val = selectListMap.get(key);
                if (key.equalsIgnoreCase(INSURANCE_LOA_REQUIRED_FIELD_ID))  {
                    caseRecord.LOA_Required__c = val;
                } else if (key.equalsIgnoreCase(INSURANCE_VERIFIED_FIELD_ID))  {
                    caseRecord.Insurance_Verified__c = val;
                } else if (key.equalsIgnoreCase(INSURANCE_AUTH_REQUIRED_FIELD_ID))  {
                    caseRecord.Auth_Required__c = val;
                }
            }
        }
        try {
            upsert caseRecord;
        }
        catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseInsuranceTabServer(): Error during upsert: ' + e.getMessage());
        }
    }

    /*
     * Save the caseRecord from the Insurance tab. This is used because the component is not a lightning:editform.
     * 
     * @param caseRecord            The case record to save
     * @param physicianName     The name of the new physician that was selected for this case.
     * @param newCaseOwnerAPIName   API value for the Case Owner retrieved from a Select List.
     *                                              It is the full name followed by a semi-colon and the employee ID.
     * @return                                  Processing code to indicate the outcome of the operation.
     * 
     */
    @AuraEnabled
    public static Map<String, String> saveCOHCaseClinicalInfoTabServer(Case caseRecord, String physicianStr, String newCaseOwnerAPIName) {

        Map<String, String> processingCode = new Map<String, String>();        
        String processingCodeVal = '';
        
        // If the ID can be retrieved for the new physician, update the parent Account object.
        // Notte hat physicianName is a text field, so it might not be possible to find the physician 
        // due to discrepancies in the entered name versus the name in the database.
        Id physicianID = null;
        if (String.isNotEmpty(physicianStr)) {
            Id parentAccountID = caseRecord.AccountId;
            Account parentObj = [select id, COH_Physician__c from Account where id = :parentAccountID limit 1];
            if (parentObj != null) {
                physicianID = getPhysicianID(physicianStr);
                if (physicianID != null) {
                    parentObj.COH_Physician__c = physicianID;
                    try {
                        upsert parentObj;
                        processingCodeVal = 'Success';
                    }  catch (Exception e) {
                        throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Account record: ' + e.getMessage());
                    }
                } else {    // Could not locate the physician
                    try {
                        upsert parentObj;
                        processingCodeVal = 'Physician Not Located';
                    }  catch (Exception e) {
                        throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Account record: ' + e.getMessage());
                    }
                }
            }
        }
        if (String.isEmpty(newCaseOwnerAPIName) ) {
            caseRecord.Call_Center_Rep__c = newCaseOwnerAPIName;  // There is no new value for the Case Owner
        } else {
            List<String> nameTokens = newCaseOwnerAPIName.split(';');
            if (COHUtil.isValidList(nameTokens) && nameTokens.size() == 2) {
                String newCaseOwnerEmployeeID = nameTokens.get(1);
                if (String.isNotEmpty(newCaseOwnerEmployeeID)) {
                    Id newCaseOwnerID = getActiveUserID(';' + newCaseOwnerEmployeeID); // convert to the format used by the method
                    if (String.isNotEmpty(newCaseOwnerID)) {
                        caseRecord.Call_Center_Rep__c = newCaseOwnerAPIName;
                        caseRecord.OwnerId = newCaseOwnerID;
                        caseRecord.Call_Center_Rep_User__c = newCaseOwnerID;
                    }
                } 
            } else {
                throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseClinicalInfoTabServer(): Improperly formatted API Name value: ' + newCaseOwnerAPIName);
            }
        }
        
        try {
            upsert caseRecord;
            if (processingCodeVal != 'Physician Not Located') {     // Don't overwrite the warning if the Physician was not located.
                processingCodeVal = 'Success';
            }
        }  catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Case record: ' + e.getMessage());
        }
        
        processingCode.put('ProcessingCode', processingCodeVal);
        return processingCode;        
    }
    
    /*
     * Save the caseRecord from the Appointment Info tab. This is used because the component is not a lightning:editform.
     * 
     * @param caseRecord                    The case record to save
     * @param newCaseOwnerAPIName   API value for the Case Owner retrieved from a Select List.
     *                                                      It is the full name followed by a semi-colon and the employee ID.
     * @param reasonNotOffered          Reason why the patient was not offered an appointment.  If not applicable, this is null.
     * @param selectListMap                 Map containing the IDs fo the pulldown fields and the Boolean values in those fields
     * @return                                          Processing code to indicate the outcome of the operation.
     * 
     */
    @AuraEnabled
    public static Map<String, String> saveCOHCaseAppointmentInfoTabServer(Case caseRecord, String newCaseOwnerAPIName, String reasonNotOffered, Map<String, Boolean> selectListMap) {
               
        Map<String, String> processingCode = new Map<String, String>();        

        Id parentAccountID = caseRecord.AccountId;
        List<Account> accountObjList = [select id, COH_MRN__c from Account where id = :parentAccountID];
        if (COHUtil.isValidList(accountObjList)) {
            Account parentObj = accountObjList.get(0);
            String cohmrn = parentObj.COH_MRN__c;
            if (String.isEmpty(cohmrn)) {
                processingCode.put('ProcessingCode', 'COH MRN Not Found');
                return processingCode;
            }
        } else {
                processingCode.put('ProcessingCode', 'COH MRN Not Found');
                return processingCode;
        }
        
        Set<String> keyset = selectListMap.keySet();
        if (keyset.size() > 0) {
            for (String key : keyset)  {
                Boolean val = selectListMap.get(key);
                if (key.equalsIgnoreCase(PATIENT_REGISTERED_FIELD_ID))  {
                    caseRecord.Patient_Registered__c = val;
                } else if (key.equalsIgnoreCase(PATIENT_SCHEDULED_FIELD_ID))  {
                    caseRecord.Pt_scheduled_1st_Call__c = val;
                } else {
                    throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseAppointmentInfoTabServer(): unrecognized key: ' + key);
                }
            }
        }

        if (String.isNotEmpty(reasonNotOffered) && caseRecord.Patient_Offered_Appointment__c != 'Yes')  {
            caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c =  reasonNotOffered;           
        } else {
            caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c =  null;
        }
        
        if (String.isEmpty(newCaseOwnerAPIName) ) {
            // The Clinical Team Member Assignment is set to empty, but 
            // the Case Owner should not change.
            caseRecord.Clinical_Team_Member_Assignment__c = newCaseOwnerAPIName;
        } else {
            //List<String> nameTokens = newCaseOwnerAPIName.split(';');
            //if (COHUtil.isValidList(nameTokens) && nameTokens.size() == 2) {
                //String newCaseOwnerEmployeeID = nameTokens.get(1);
                //if (String.isNotEmpty(newCaseOwnerEmployeeID)) {
                    //Id newCaseOwnerID = getActiveUserID(';' + newCaseOwnerEmployeeID); // convert to the format used by the method
                    //if (String.isNotEmpty(newCaseOwnerID)) {
                        caseRecord.Clinical_Team_Member_Assignment__c = newCaseOwnerAPIName;
                        //caseRecord.OwnerId = newCaseOwnerID;
                        //caseRecord.Clinical_Team_Assignment_User__c = newCaseOwnerID;
                   // }
                //}
           // } else {
          //      throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseAppointmentInfoTabServer(): Improperly formatted API Name value: ' + newCaseOwnerAPIName);
            //}
        }
        try {
            upsert caseRecord;
        }
        catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseAppointmentInfoTabServer(): Error during upsert: ' + e.getMessage());
        }
        processingCode.put('ProcessingCode', 'Success');
        return processingCode;
    }
    
    /*
     * Save the caseRecord from the Cancelation/No Show tab. This is used because the component is not a lightning:editform.
     * 
     * @param caseRecord                    The case record to save
     * @param initialApptStatus             Initial appointment status
     * @param notifyLeadership              true if an email should be emailed to the leadership, false otherwise
     * @return                                          Processing code to indicate the outcome of the operation.
     * 
     */
    @AuraEnabled
    public static Map<String, String> saveCOHCaseAppointmentCancelationInfoTabServer(Case caseRecord, String initialApptStatus, Boolean notifyLeadership) {
        
        Map<String, String> processingCode = new Map<String, String>();        
        if (caseRecord.Appt_Status__c == 'Canceled')  {
            caseRecord.Appt_Call_Date__c =  null;           
            if (initialApptStatus != 'Canceled' )  {
                caseRecord.Appt_Canceled_By__c  = UserInfo.getUserId();
                processingCode.put('CanceledByUserName', UserInfo.getName());
            }
        }  else if (caseRecord.Appt_Status__c == 'No Show') {
            caseRecord.Appt_Cancelation_Date__c =  null;           
            caseRecord.Appt_Canceled_By__c  = null;
        } else if (caseRecord.Appt_Status__c == null || caseRecord.Appt_Status__c == '')  {
            caseRecord.Appt_Cancelation_Date__c =  null;           
            caseRecord.Appt_Canceled_By__c  = null;
            caseRecord.Appt_Call_Date__c =  null;           
        }

        try {
            upsert caseRecord;
            
            if (notifyLeadership == true) {
                if (COHUtil.isValidList(mCancelNotificationUsersList)) {
                    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                    for (COH_PRS_Configuration__mdt configObj : mCancelNotificationUsersList) {
                        String employeeID = configObj.Value__c;
                        // retrieve the user record
                        List<User> usrObjList = [select Firstname, Lastname, Email, Employeenumber from User where Employeenumber =: employeeID];
                        if (COHUtil.isValidList(usrObjList)) {
                            User toUser = usrObjList.get(0);
                            String[] emailToAddr = new String[] {toUser.Email};
                                
                            String cohMRN = String.isNotEmpty(caseRecord.COH_MRN__c) ? caseRecord.COH_MRN__c : ''; 
                            String textBody = mCancelMessageTemplate.replace('%MRN%', cohMRN);
                            
                            String patientName = '';
                            if (String.isNotEmpty(caseRecord.Patient_Last_Name__c ) || String.isNotEmpty(caseRecord.Patient_First_Name__c )) {
                                patientName = caseRecord.Patient_Last_Name__c  + ', ' + caseRecord.Patient_First_Name__c;
                            }
                            textBody = textBody.replace('%PatientName%', patientName);
                            
                            String userName = '';
                            if (String.isNotEmpty(toUser.FirstName ) || String.isNotEmpty(toUser.LastName )) {
                                userName = toUser.FirstName  + ' ' + toUser.LastName;
                            }
                            textBody = textBody.replace('%EmployeeName%', userName);
                            
                            Messaging.SingleEmailMessage emailMsg= COHUtil.createEmailMessage(toUser, mSystemAccountUser, mSystemAccountUser.Email, emailToAddr, mCancelationNotificationSubject, textBody);
                            if (emailMsg != null) {
                                emailList.add(emailMsg);
                            }
                        } else {
                            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseCancelationInfoTabServer(): Record information saved, but could not locate the user with this Employee ID' + employeeID);
                        }
                    } 
                    
                    try {
                        if (Test.isRunningTest() == false) {
                            Messaging.sendEmail(emailList);
                        }
                    } catch (Exception e) {
                        throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseCancelationInfoTabServer(): Record information saved, but encountered an error while sending the emails: ' + e.getMessage());
                    }
                } else {
                    throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseCancelationInfoTabServer(): Record information saved, but no User IDs were provided for the email notification');
                }
            }  
        } catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabControllerLegacy.saveCOHCaseCancelationInfoTabServer(): Error during upsert: ' + e.getMessage());
        }
        processingCode.put('ProcessingCode', 'Success');
        return processingCode;
    }
    
    /*
     * Retrieve the User ID from a delimited string containing the name of an employee and the employee number.
     * The employee must be active.  If the employee is not found or is no longer active, null is returned.
     * 
     * @param employeeInfoStr       Delimited string containing the name of the employee and the employee number.
     * @return                                  User ID of the valid employee.
     * 
     */
    @AuraEnabled
    public static Id getActiveUserID(String employeeInfoStr) {

        Id newID = null;
        if (String.isNotEmpty(employeeInfoStr)) {
            // parse the call center rep string to get the employee ID
            // Get the  employee information and set the owner to the new owner    
            List<String> tokens = employeeInfoStr.split(';');
            Integer tokenCount = tokens.size();
            if (tokenCount > 1) {
                // Retrieve the employee ID that is active.
                String employeeID = tokens.get(1);
                // testing--raymond tam
                // Disable searching only for active users.  If the user is inactive, the call center rep is changed but
                // this would be inconsistent with the owner, which wouldn't have changed
//                List<User> userList = [select id from user where employeenumber = :employeeID and empl_status__c = 'A'];

                List<User> userList = [select id from user where employeenumber = :employeeID];
                if (COHUtil.isValidList(userList)) {
                    newID = (userList.get(0)).id;
                }
            } 
        }
        return newID;
    }
    
    /*
     * Retrieve all possible Departments in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @return List<Map<String, String>>            the possible values of Department
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getDepartmentValuesServer() {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctDepartments = [SELECT Department__c FROM COHCasePhysicianDecisionTree__c GROUP BY Department__c];
        
        returnValue = buildSelectList(distinctDepartments, 'Department__c');
        
        return returnValue;
    }
    
    /*
     * Retrieve all possible Service Lines in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department                            the value of department
     * 
     * @return List<Map<String, String>>            the possible values of Service Line
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getServiceLineValuesServer(String department) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctServiceLines = [SELECT Service_Line__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department GROUP BY Service_Line__c];
        
        returnValue = buildSelectList(distinctServiceLines, 'Service_Line__c');
        
        return returnValue;
    }
    
    /*
     * Retrieve all possible Specialties in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department                            the value of department
     * @param serviceLine                           the value of serviceLine
     * 
     * @return List<Map<String, String>>            the possible values of Specialty
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getSpecialtyValuesServer(String department, String serviceLine) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctSpecialties = [SELECT Specialty__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department AND Service_Line__c=:serviceLine GROUP BY Specialty__c];
        
        returnValue = buildSelectList(distinctSpecialties, 'Specialty__c');
        
        return returnValue;
    }
    
    /*
     * Retrieve all possible Physicians in the COHCasePhysicianDecisionTree__c custom setting
     * 
     * @param department                            the value of department
     * @param serviceLine                           the value of serviceLine
     * @param specialty                             the value of specialty
     * 
     * @return List<Map<String, String>>            the possible values of Physician
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getPhysiciansServer(String department, String serviceLine, String specialty, String subgroupNumber) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctPhysicians = [select Physician__c from COHCasePhysicianDecisionTree__c where Department__c=:department AND Service_Line__c=:serviceLine AND Specialty__c=:specialty and Subgroup_Num__c = :subgroupNumber GROUP BY Physician__c];
        
        returnValue = buildSelectList(distinctPhysicians, 'Physician__c');
        
        return returnValue;
    }        

    /*
     * Retrieve the Subgroup Number based on the Department, Service Line, and Specialty 
     * 
     * @param department                            the value of department
     * @param serviceLine                           the value of serviceLine
     * @param specialty                             the value of specialty
     * 
     * @return List<Map<String, String>>            the possible values of Subgroup Number
     */ 
    @AuraEnabled
    public static List<Map<String, String>> getSubgroupNumberServer(String department, String serviceLine, String specialty) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctSubgroups = [SELECT Subgroup_Num__c FROM COHCasePhysicianDecisionTree__c WHERE Department__c=:department AND Service_Line__c=:serviceLine AND Specialty__c=:specialty GROUP BY Subgroup_Num__c];
        returnValue = buildSelectList(distinctSubgroups, 'Subgroup_Num__c');
        
        return returnValue;
    }        
    
    /*
     * Retrieve all Strategic Programs for the Clinical Information Tab (aka Diagnosis Tab)
     * 
     * @return List<Map<String, String>>        List of all Strategic Programs
     * 
     */
    @AuraEnabled
    public static List<Map<String, String>> getStrategicPrograms() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Strategic_Program__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : picklistValues) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                returnList.add(tempMap);
            }
        }
        return returnList;
    }
    
    /*
     * Retrieve all SVC/Diagnosis for the Clinical Information Tab (aka Diagnosis Tab)
     * 
     * @return List<Map<String, String>>        List of all SVC/Diagnosis
     * 
     */
    @AuraEnabled
    public static List<Map<String, String>> getSVCDiagnosis() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.SVC_Diagnosis_Case__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : picklistValues) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                returnList.add(tempMap);
            }
        }
        return returnList;
    }

    /*
     * Retrieve all Patient Types for the Clinical Information Tab (aka Diagnosis Tab)
     * 
     * @return List<Map<String, String>>        List of all Patient Types
     * 
     */
    @AuraEnabled
    public static List<Map<String, String>> getPatientType() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Patient_Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : picklistValues) {
            Boolean isActive = picklistObj.isActive();
            String labelPicklist = picklistObj.label;
            system.debug('picklistobj: '+picklistObj);
            if (labelPicklist =='Donor' || labelPicklist == 'BMT' || labelPicklist =='Car T' || labelPicklist =='Car T – HEM'|| labelPicklist =='CarT – Neuro'|| labelPicklist =='Code Leukemia'|| labelPicklist =='Consultation'|| labelPicklist =='Donor'|| labelPicklist =='Inquiry only' || labelPicklist =='IRB Study'|| labelPicklist =='Kaiser BMT'|| labelPicklist =='Research' ) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                returnList.add(tempMap);
            }
        }
        return returnList;
    }

    /*
     * Retrieve the ID of a physician.
     * 
     * @param physicianStr          Physician name string.  It might come in this format: "Thomas Magnum, MD (M)"
     * @return                              Id for the physician.   
     * 
     */
    private static Id getPhysicianID(String physicianStr) {
        Id physicianID = null;
        if (String.isNotEmpty(physicianStr))  {
            Integer commaIndex = physicianStr.indexOf(',');
            Integer suffixIndex = physicianStr.indexOf('MD');
            Integer endIndex = (commaIndex <= suffixIndex ? commaIndex : suffixIndex); // Get the end of the actual name.  This is used just in case the formatting isn't consistent.
            String substr = physicianStr.substring(0, endIndex);
            
            List<String> nameTokens = substr.split(' ');
            if (COHUtil.isValidList(nameTokens)) {
                Integer tokenCount = nameTokens.size();
                if (tokenCount > 1) {
                    String firstName = nameTokens.get(0) + '%';
                    String lastName = nameTokens.get(tokenCount - 1) + '%';
                    String soqlQueryStr = 'select id, firstname, lastname from Contact where recordtypeid = :COHContactRecordType and inactive__c = false ' +
                            ' and Type__c = \'Physician\' and firstname like :firstname and lastname like :lastName';
                    List<Contact> contactList = Database.query(soqlQueryStr);
                    if (COHUtil.isValidList(contactList)) {
                        Contact contactObj = contactList.get(0);
                        physicianID = contactObj.Id;
                    }
                }
            }
        }
        return physicianID;
    }
    /*
     * Retrieve all Clinical Team Members for the Appointment Information Tab
     * 
     * @return List<Map<String, String>>        List of all Clinical Team Members
     * 
     */
    private static List<Map<String, String>> getClinicalTeamMembers() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Clinical_Team_Member_Assignment__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : pickListValues) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                returnList.add(tempMap);
            }
        }
        return returnList;
    }        

    /*
     * Retrieve all Call Center Reps for the Clinical  Information Tab (aka Diagnosis Tab)
     * 
     * @return List<Map<String, String>>        List of all Call Center Reps
     * 
     */
    private static List<Map<String, String>> getCallCenterReps() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Call_Center_Rep__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : pickListValues) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('label', picklistObj.getLabel());
                tempMap.put('value', picklistObj.getValue());
                returnList.add(tempMap);
            }
        }
        return returnList;
    }        

    /*
     * Retrieve all Cancer Status values for the Clinical  Information Tab (aka Diagnosis Tab)
     * 
     * @param patientUndergoneTreatment     True if the patient has undergone treatment, false otherwise
     * @return List<Map<String, String>>        List of all Cancer Status values
     * 
     */
    @AuraEnabled
    public static List<Map<String, String>> getCancerStatus(Boolean patientUndergoneTreatment) {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Cancer_Status__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistObj : pickListValues) {
            Boolean isActive = picklistObj.isActive();
            if (isActive) {
                Map<String, String> tempMap = new Map<String, String>();
                String label = picklistObj.getLabel();
                String value = picklistObj.getValue();
                if (patientUndergoneTreatment && value.equalsIgnoreCase('Newly Diagnosed')) {       // Ignore "Newly Diagnosed" when the patient has already undergone treatment
                    continue;
                } else {
                    tempMap.put('label', label);
                    tempMap.put('value', value);
                }
                returnList.add(tempMap);
            }
        }
        return returnList;
    }        

    /*
     * Private method to convert agregateresults from a query using GROUP BY into a List<Map<String,String>> (which is used to populate the Select Lists in the javascript controller).
     * 
     * @param List<AggregateResult> aggregateResultList                             The List of AggregateResults
     * @param String fieldAPIName                                                   The API Name of the field the Aggregate Result was grouped by in the Query that created the List<AggregateResult>
     */ 
    private static List<Map<String, String>> buildSelectList(List<AggregateResult> aggregateResultList, String fieldAPIName) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();        
        
        for(AggregateResult i : aggregateResultList) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get(fieldAPIName));
            tempMap.put('value', (String) i.get(fieldAPIName));
            returnValue.add(tempMap);
        }
        
        return returnValue;
    }    

}