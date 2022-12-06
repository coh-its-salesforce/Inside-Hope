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
public with sharing class COHCaseInsuranceTabController {

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
    private static final String PROCUREMENT_CLINICAL_SPECIALTY_ASSIGNMENT = 'mClinicalSpecialtyAssignment';
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
            throw new AuraHandledException('COHCaseInsuranceTabController.initialization: Error: no users were identified as receiving notification emails');
        }
            
        // Retrieve the default email subject when cancelation notifications are sent
        List<COH_PRS_Configuration__mdt> cancelNotificationEmailSubjectList = [select Value__c from COH_PRS_Configuration__mdt where DeveloperName = 'Cancelation_Email_Subject'    and Is_Active__c = true];
        if (COHUtil.isValidList(cancelNotificationEmailSubjectList)) {
            COH_PRS_Configuration__mdt configObj = cancelNotificationEmailSubjectList.get(0);
            mCancelationNotificationSubject = configObj.Value__c;
            if (String.isEmpty(mCancelationNotificationSubject)) {
                throw new AuraHandledException('COHCaseInsuranceTabController.initialization: Error: no value supplied for the appointment cancelation subject');
            }
        }
        
        // Retrieve default system account user for sending emails
        List<User> usrObjList = [select Firstname, Lastname, Email from User where Alias =: 'saccount'];
        if (COHUtil.isValidList(usrObjList)) {
            mSystemAccountUser = usrObjList.get(0);
        } else {
            throw new AuraHandledException('COHCaseInsuranceTabController.initialization: Error: system account user not found');
        }
        
        // Retrieve the default email body template when cancelation notifications are sent
        List<COH_PRS_Configuration__mdt> cancelNotificationEmailBodyTemplateList = [select Value__c from COH_PRS_Configuration__mdt where DeveloperName = 'Cancelation_Email_Body_Template' and Is_Active__c = true];
        if (COHUtil.isValidList(cancelNotificationEmailBodyTemplateList)) {
            COH_PRS_Configuration__mdt configObj = cancelNotificationEmailBodyTemplateList.get(0);
            mCancelMessageTemplate = configObj.Value__c;
            if (String.isEmpty(mCancelMessageTemplate)) {
                throw new AuraHandledException('COHCaseInsuranceTabController.initialization: Error: empty template for the appointment cancelation message body');
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
        Case queriedCase = [SELECT id,Is_patient_willing_to_do_Tele_Health_vis__c
                            ,Does_the_patient_have_an_e_mail_address__c,Virtual_Consenting_Eligibility__c,Consenting_Status__c,Consenting_Type__c,Consenting_Appt_Date_Time__c
                            ,Does_patient_have_access_to_video_chat__c,Service_Category__c, Plan_Type__c, Line_of_Business_Decision_Tree__c, Health_Plan__c, Medical_Group_IPA__c, Duarte_or_Community__c, Auth_Required__c, LOA_Required__c, Insurance_Verified__c, Auth_Follow_Up_Complete__c, Auth_Insurance_Notes__c, Auth__c, CC_Primary_insurance__c, Auth_Received__c, LOA_Complete__c FROM Case WHERE id=:recordId];
        if (queriedCase != null) {
            returnValue.put('Case', queriedCase);
            returnValue.put('Plan_Type', getPlanTypeValues(queriedCase.Service_Category__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put('Line_Of_Business', getLineOfBusinessValuesServer(queriedCase.Service_Category__c, queriedCase.Plan_Type__c, queriedCase.Health_Plan__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put('Health_Plan', getHealthPlanValuesServer(queriedCase.Service_Category__c, queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put('IPA_Medical_Group', getMedicalGroupIPAValuesServer(queriedCase.Service_Category__c, queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c));
            //returnValue.put('Location', getLocationValuesServer(queriedCase.Service_Category__c, queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put(INSURANCE_LOA_REQUIRED_FIELD_ID, queriedCase.LOA_Required__c);
            returnValue.put(INSURANCE_VERIFIED_FIELD_ID, queriedCase.Insurance_Verified__c);
            returnValue.put(INSURANCE_AUTH_REQUIRED_FIELD_ID, queriedCase.Auth_Required__c);
        }
        return returnValue;
    }
    
    //for COHCaseInsuranceTab Aura Component from older version to continue operating
    @AuraEnabled
    public static Map<String, Object> initCOHCaseInsuranceTabServerOld(Id recordId) {
        Map<String, Object> returnValue = new Map<String, Object>();
        List<String> fieldsToAccess = new List<String> {'id', 'Plan_Type__c', 'Line_of_Business_Decision_Tree__c', 'Health_Plan__c', 'Medical_Group_IPA__c', 'Duarte_or_Community__c', 'Auth_Required__c', 'LOA_Required__c', 'Insurance_Verified__c', 'Auth_Follow_Up_Complete__c', 'Auth_Insurance_Notes__c', 'Medical_Group_IPA__c','Auth_Required__c', 'Auth_Received__c', 'LOA_Complete__c' };
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        Case queriedCase = [SELECT id, Service_Category__c, Plan_Type__c, Line_of_Business_Decision_Tree__c, Health_Plan__c, Medical_Group_IPA__c, Duarte_or_Community__c, Auth_Required__c, LOA_Required__c, Insurance_Verified__c, Auth_Follow_Up_Complete__c, Auth_Insurance_Notes__c, Auth__c, CC_Primary_insurance__c, Auth_Received__c, LOA_Complete__c FROM Case WHERE id=:recordId];        if (queriedCase != null) {
            returnValue.put('Case', queriedCase);
            returnValue.put('Plan_Type', getPlanTypeValuesOld());
            returnValue.put('Line_Of_Business', getLineOfBusinessValuesServerOld(queriedCase.Plan_Type__c));
            returnValue.put('Health_Plan', getHealthPlanValuesServerOld(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c));
            returnValue.put('IPA_Medical_Group', getMedicalGroupIPAValuesServerOld(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c));
            returnValue.put('Location', getLocationValuesServerOld(queriedCase.Plan_Type__c, queriedCase.Line_of_Business_Decision_Tree__c, queriedCase.Health_Plan__c, queriedCase.Medical_Group_IPA__c));
            returnValue.put(INSURANCE_LOA_REQUIRED_FIELD_ID, queriedCase.LOA_Required__c);
            returnValue.put(INSURANCE_VERIFIED_FIELD_ID, queriedCase.Insurance_Verified__c);
            returnValue.put(INSURANCE_AUTH_REQUIRED_FIELD_ID, queriedCase.Auth_Required__c);
        }
        return returnValue;
    }
    
    @AuraEnabled
    public static list<String> getDistance(String caseId,String ognCity) {
        
        list<String> resList = new list<String>();
        String endpoint = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
        String apiKey = System.Label.COH_Google_Api_Distance_Key;
        Case cse = [Select id,Account.Patient_City__c from Case where id =:CaseId LIMIT 1];
        if(OgnCity == null){
            return new list<String>();
        }
        if(Account.Patient_City__c == null){
            throw new AuraHandledException('Destination City null');
        }
        String originCity = EncodingUtil.URLEncode(OgnCity,'UTF-8');
        String destinationCity = EncodingUtil.URLEncode(cse.Account.Patient_City__c,'UTF-8');
        String mainUrl = endpoint +'origins='+ originCity +'&destinations='+ destinationCity +'&key='+ apikey;
        system.debug(mainUrl);    
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(mainUrl);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        System.debug('response:--> ' + res.getBody());
        JSONParser parser =  JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if(parser.getText() == 'text') {
                System.debug('distance2'+ parser.getText());
                system.debug('Main temp_min-->' + parser.nextValue());
                resList.add(parser.getText());
                system.debug('Main temp_min--> ' + parser.nextValue());
            }
        }
        system.debug(resList);
        return resList;
    }
    
    
    
     @AuraEnabled
    public static list<String> getCordinates() {
        
        list<String> resList = new list<String>();
        String endpoint = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
        String apiKey = System.Label.COH_Google_Api_Distance_Key;
  
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key='+apiKey);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        System.debug('response:--> ' + res.getBody());
       
        system.debug('res.getStatusCode()::'+res.getStatusCode());
        if(res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            system.debug('response::'+res.getBody());
            double lat = null;
            double lon = null; 
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) { 
                    parser.nextToken(); 
                    while (parser.nextToken() != JSONToken.END_OBJECT) {
                        String txt = parser.getText();
                        parser.nextToken();
                        if(txt == 'lat') { 
                            lat = parser.getDoubleValue(); 
                        } 
                        else if(txt == 'lng') {
                            lon = parser.getDoubleValue();
                        }
                    } 
                } 
            } 
            system.debug('Latitude'+lat);
            system.debug('Longitude'+lon);
            //return new Cooridinates(lat, lon);
        } 
        else {
            //return null; 
        } 
        return resList;
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
                    'Call_Center_Rep__c', 'Cancer_Status__c', 'OwnerId', 'AccountId', 'Subgroup_Num__c', 'Patient_Hospice_Status__c','HasPatientBeenDiagnosed__c',
                    'ConfirmedThroughBiopsy__c', 'HasPatientUndergoneTreatment__c','CurrentlyUndergoingTreatment__c','History_of_Present_Illness__c', 'Obtain_Records_From__c',
                    'Symptoms__c','KPS__c','Treatment_Received__c', 'Routing_Comments__c', 'COH_MRN__c', 'IsRead__c', 'Is_patient_interested_in_a_CAR_T_Trial__c', 
                    'Clinical_Specialty_Assignment__c','Date_of_Specialty_Assignment__c', 'Clinical_Team_Member_Assignment__c', 'Date_Nurse_is_assigned__c',
                    'Reason_for_Clinical_Denial__c','Reason_Patient_Does_Not_Want_to_Proceed__c','Clinical_Process_Complete__c','location_pool_name__c','Clinical_Intake_Complete__c',
                    'Location__c','Intake_Status__c','referred_To_COHMD__c','Closed_Reason__c','Epic_Location_Pool_Registry__c','Inquiry_Type__c'};
                        
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
            ' Patient_Type__c, Cancer_Status__c, Subgroup_Num__c, OwnerId, AccountId, Patient_Hospice_Status__c, RecordType.DeveloperName,Location__c, '+ 
            ' HasPatientBeenDiagnosed__c,ConfirmedThroughBiopsy__c,HasPatientUndergoneTreatment__c,CurrentlyUndergoingTreatment__c, '+
            ' History_of_Present_Illness__c,Obtain_Records_From__c,Symptoms__c,KPS__c,Treatment_Received__c,Routing_Comments__c,COH_MRN__c,IsRead__c, '+
            'Is_patient_interested_in_a_CAR_T_Trial__c,Clinical_Specialty_Assignment__c,Date_of_Specialty_Assignment__c,Clinical_Team_Member_Assignment__c, '+
            'Date_Nurse_is_assigned__c,Reason_for_Clinical_Denial__c,Reason_Patient_Does_Not_Want_to_Proceed__c,Clinical_Intake_Complete__c,Clinical_Process_Complete__c,'+
            'location_pool_name__c,Intake_Status__c,referred_To_COHMD__c,Status,Closed_Reason__c,Epic_Location_Pool_Registry__c,Inquiry_Type__c'+
            ',Clinical_Process_Date_Time__c'+//Changes by Sanjay on 05/29/2022- Clinical_Process_Date_Time__c Changes
            ' FROM Case WHERE id=:recordId';
        
        /**** Changes ****** End****/        
        Case caseRecord = Database.query(queryStr);
        
        if (caseRecord != null) {
            returnValue.put('Case', caseRecord);
            returnValue.put(PATIENT_DIAGNOSED_FIELD_ID, caseRecord.Has_patient_been_diagnosed_CheckBox__c);
            returnValue.put(PATIENT_UNDERGONE_TREATMENT_FIELD_ID, caseRecord.Has_patient_undergone_treatment__c );
            returnValue.put(PATIENT_CONFIRMED_BIOPSY_FIELD_ID, caseRecord.Confirmed_Through_Biopsy__c );
            returnValue.put(PATIENT_CURRENTLY_UNDERGOING_TREATMENT_FIELD_ID, caseRecord.Currently_Undergoing_Treatment__c);
            returnValue.put(HOSPICE_STATUS_ID, COHUtil.getPicklistValuesMap(CASE_OBJ, 'Patient_Hospice_Status__c', true));
            
            returnValue.put('Departments', getDepartmentValuesServer(caseRecord.Location__c, caseRecord.Service_Line__c, caseRecord.Specialty__c , caseRecord.Physician_Decision_Tree__c, null));
            returnValue.put('ServiceLines', getServiceLineValuesServer(caseRecord.Department_Case__c, caseRecord.Location__c, caseRecord.Specialty__c , caseRecord.Physician_Decision_Tree__c, null));
            returnValue.put('Specialties', getSpecialtyValuesServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c, caseRecord.Location__c, caseRecord.Physician_Decision_Tree__c , null));
            returnValue.put('SubgroupNumbers', getSubgroupNumberServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c, caseRecord.Specialty__c));
            returnValue.put('Physicians', getPhysiciansServer(caseRecord.Department_Case__c, caseRecord.Service_Line__c, caseRecord.Specialty__c, caseRecord.Subgroup_Num__c , null));
            returnValue.put('StrategicPrograms', getStrategicPrograms());
            returnValue.put('SVCDiagnosis', getSVCDiagnosis());
            returnValue.put('PatientType', getPatientType());
            returnValue.put('CallCenterReps', getCallCenterReps());
            returnValue.put('CancerStatus', getCancerStatus(caseRecord.Has_patient_undergone_treatment__c));
            /*START Changes by Sanjay on 04/14/2022: Patient Type changes*/
            Map<String, String> patientTypeOptionMap = new Map<String, String>();
        	for(COH_Patient_Type_Mapping__mdt metadata:[SELECT Id,Description__c,Label FROM COH_Patient_Type_Mapping__mdt ]){
                patientTypeOptionMap.put(metadata.label, metadata.Description__c);
            }
            returnValue.put('patientTypeOptionMap',patientTypeOptionMap);
            /*END Changes by Sanjay on 04/14/2022: Patient Type changes*/
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
                    'Imaging_Status__c', 'How_Many_Locations_Imaging_Status_1__c', 'Comments_Imaging_Status_1__c', 'Appt_Date_Time__c',
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

        String queryStr = 'select id, PRSpecialist_Assignment__c, All_Records_Recieved__c, Appt_Date_Time__c, E_Health_Template_Submitted__c, Records_No_Longer_Needed__c, ' + 
                    'Imaging_Status__c, How_Many_Locations_Imaging_Status_1__c, Comments_Imaging_Status_1__c, ' + 
                    'X2nd_Request_Imaging_Status__c, Clinical_Specialty_Assignment__c, Clinical_Team_Member_Assignment__c, How_Many_Locations_Imaging_Status_2__c, Comments_Imaging_Status_2__c, ' + 
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
            returnValue.put(PROCUREMENT_CLINICAL_SPECIALTY_ASSIGNMENT, caseRecord.Clinical_Specialty_Assignment__c);
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
                    'Auth_Needed__c', 'Is_Patient_Requesting_a_Specific_MD__c', 'Email_Video_Sent__c', 'Original_Appointment__c', 'Appt_Status__c'};
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        for (String fieldToCheck : fieldsToAccess) {
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        /* Added fields by Sanjay Singh for Enterprise Access case type on 6/14/2021 */ 
        String queryStr = 'select id,Does_Pt_want_a_sooner_appt__c,Is_patient_willing_to_do_Tele_Health_vis__c, Type_of_Scheduling_Barriers_Select_All__c ,Delay_in_Clinical_Intake__c,Visit_Type_Preference__c,Is_Patient_Requesting_a_Specific_MD__c , Pt_Appt_is_Scheduled_in_how_many_days__c  ,SmartPhrase_Sent__c,Date_SmartPhrase_Sent_auto_time_stamp__c, SmartPhrase_Outreach_Result__c '+
                            ',Does_the_patient_have_an_e_mail_address__c,Virtual_Consenting_Eligibility__c,Consenting_Status__c,Consenting_Type__c,Consenting_Appt_Date_Time__c'+
                            ',Does_patient_have_access_to_video_chat__c,Appointment_Location__c,Provider_Name__c, Patient_Registered__c, If_Not_Registered_Explain__c, Pt_scheduled_1st_Call__c, If_Pt_Not_Scheduled_1st_Call_Explain__c, ' + 
                'Patient_Offered_Appointment__c, Reason_Not_Offered_Appt_Within_2_Days__c, Appt_Date_Time__c, Clinical_Team_Member_Assignment__c, COH_MRN__c, ' +
                'OwnerId, AccountId, Reached_out_to_MD_to_move_up_app_pkl__c, Date_Nurse_is_assigned__c, Patient_Status_Case__c, Completed_Clinically_Denied_Reason__c, ' +
                'Clinical_Intake_Complete__c, Clinical_Process_Complete__c, Date_Email_Sent_to_MD__c, Date_MD_Response__c, Date_MD_Decision__c, ' + 
                'Decline_to_move_up_appt__c, Auth_Needed__c, Email_Video_Sent__c,Denied_By__c, Referred_To_Other__c, RecordType.DeveloperName, Distance_between_Patient_and_Appt_Loc__c, Original_Appointment__r.Appointment_Date_Time__c, Appt_Status__c ' +
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
            returnValue.put('Locations', getLocationValues());// changes by Sanjay on 01/26/2022
        }
        system.debug('caseRecord'+caseRecord);
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
                ' Appt_Cancelation_Reason__c, Appt_Call_Date__c, Appt_Rescheduled__c, Clinical_Team_Member_Assignment__c, Appt_New_DateTime__c, Appt_Confirm_Email_Sent__c,' +
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


    // Method to get all possible Service Categories in the Insurance_Matrix__c table
    @AuraEnabled
        public static List<Map<String, String>> getServiceCategoryValues(String planType, String lineOfBusiness, String healthPlan, String medicalGroupIPA) {
        String query = 'SELECT QUESTION_Service_Categories__c FROM Insurance_Matrix__c where inactive__c = false ';
        if(lineOfBusiness != null || healthPlan != null || medicalGroupIPA !=null || planType !=null){
            if(lineOfBusiness != null){
                query += ' and QUESTION_Line_of_Bus__c = \'' + lineOfBusiness + '\'';
            }
            if(healthPlan != null){
                query += ' and QUESTION_Insurance_Plans__c = \'' + healthPlan + '\'';
            }
            if(medicalGroupIPA != null){
                query += ' and Medical_Group__c = \'' + medicalGroupIPA + '\'';
            }
            if(planType !=null){
                query += ' and QUESTION_Product__c = \'' + planType + '\'';
            }
        }
        query += ' GROUP BY QUESTION_Service_Categories__c';
        system.debug('Service Category Query : ' + query);
        List<AggregateResult> serviceCategories = database.query(query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: serviceCategories) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('QUESTION_Service_Categories__c'));
            tempMap.put('value', (String) i.get('QUESTION_Service_Categories__c'));
            returnValue.add(tempMap);
        }
        return returnValue;
    }


    /*
     * Method to get all possible Plan Types in the COHCaseInsuranceDecisionTree__c custom setting
     * 
     * @return List<Map<String, String>>            the possible values of Plan Type 
     */ 
    @TestVisible
    @AuraEnabled
        public static List<Map<String, String>> getPlanTypeValues(String serviceCategory, String lineOfBusiness, String healthPlan, String medicalGroupIPA) {
        String query = 'SELECT QUESTION_Product__c FROM Insurance_Matrix__c where inactive__c = false ';
     	serviceCategory = '';
        for(serviceCategoriesType__mdt serviceType: [select id,MasterLabel from serviceCategoriesType__mdt]){
                  serviceCategory = serviceCategory =='' ? (' QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'')  :  ( serviceCategory +' OR QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'');
        }        
        serviceCategory = ' and ('+serviceCategory+')';
        if(lineOfBusiness != null || healthPlan != null || medicalGroupIPA !=null || serviceCategory !=null){
            if(lineOfBusiness != null){
                query += ' and QUESTION_Line_of_Bus__c = \'' + lineOfBusiness + '\'';
            }
            if(healthPlan != null){
                query += ' and QUESTION_Insurance_Plans__c = \'' + healthPlan + '\'';
            }
            if(medicalGroupIPA != null){
                query += ' and Medical_Group__c = \'' + medicalGroupIPA + '\'';
            }
            if(serviceCategory !=null){
                //query += ' and QUESTION_Service_Categories__c = \'' + serviceCategory + '\'';
                query += serviceCategory;
            }
        }
        query += ' GROUP BY QUESTION_Product__c';
        system.debug('Plan Type Query : ' + query);
        List<AggregateResult> planTypes = database.query(query);
        //List<AggregateResult> planTypes = [SELECT Plan_Type__c FROM COHCaseInsuranceDecisionTree__c GROUP BY Plan_Type__c];
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: planTypes) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('QUESTION_Product__c'));
            tempMap.put('value', (String) i.get('QUESTION_Product__c'));
            returnValue.add(tempMap);
        }
        return returnValue;
    }
    
    /*
     * Original Method to get all possible Plan Types in the COHCaseInsuranceDecisionTree__c custom setting
     * 
     * @return List<Map<String, String>>            the possible values of Plan Type 
     */ 
    @TestVisible
    private static List<Map<String, String>> getPlanTypeValuesOld() {
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
        public static List<Map<String,String>> getLineOfBusinessValuesServer(String serviceCategory, String planType, String healthPlan, String medicalGroupIPA) {
        String query = 'SELECT QUESTION_Line_of_Bus__c FROM Insurance_Matrix__c WHERE inactive__c = false';
            serviceCategory = '';
            for(serviceCategoriesType__mdt serviceType: [select id,MasterLabel from serviceCategoriesType__mdt]){
                      serviceCategory = serviceCategory =='' ? (' QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'')  :  ( serviceCategory +' OR QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'');
            }        
            serviceCategory = ' and ('+serviceCategory+')';
            if(planType != null){
                query += ' and QUESTION_Product__c = \'' + planType + '\'' ;
            }
            if(healthPlan != null){
                query += ' and QUESTION_Insurance_Plans__c = \'' + healthPlan + '\'';
            }
            if(medicalGroupIPA != null){
                query += ' and Medical_Group__c = \'' + medicalGroupIPA + '\'';
            }
            if(serviceCategory !=null){
                //query += ' and QUESTION_Service_Categories__c = \'' + serviceCategory + '\'';
                query += serviceCategory;
            }
        query += ' GROUP BY QUESTION_Line_of_Bus__c';
        system.debug('Line of Business Query : ' + query);
        
        List<AggregateResult> lineOfBusinesses = database.query(query);

        
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: lineOfBusinesses) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('QUESTION_Line_of_Bus__c'));
            tempMap.put('value', (String) i.get('QUESTION_Line_of_Bus__c'));
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
    public static List<Map<String,String>> getLineOfBusinessValuesServerOld(String planType) {
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
        public static List<Map<String, String>> getHealthPlanValuesServer(String serviceCategory, String planType, String lineOfBusiness, String medicalGroupIPA) {
        String query = 'SELECT QUESTION_Insurance_Plans__c FROM Insurance_Matrix__c WHERE inactive__c = false';
            serviceCategory = '';
            for(serviceCategoriesType__mdt serviceType: [select id,MasterLabel from serviceCategoriesType__mdt]){
                serviceCategory = serviceCategory =='' ? (' QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'')  :  ( serviceCategory +' OR QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'');
                    }        
            serviceCategory = ' and ('+serviceCategory+')';
        if(planType != null){
            query += ' and QUESTION_Product__c = \'' + planType + '\'' ;
        }
        if(lineOfBusiness != null){
            query += ' and QUESTION_Line_of_Bus__c = \'' + lineOfBusiness + '\'';
        }
        if(medicalGroupIPA != null){
            query += ' and Medical_Group__c = \'' + medicalGroupIPA + '\'';
        }
        if(serviceCategory !=null){
            //query += ' and QUESTION_Service_Categories__c = \'' + serviceCategory + '\'';
            query += serviceCategory;
        }
        query += ' GROUP BY QUESTION_Insurance_Plans__c';
        system.debug('Health Plan Query : ' + query);
        
        
        List<AggregateResult> healthPlans = database.query(query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: healthPlans) {
            Map<String, String> tempMap = new Map<String, String>();
            String tempString = (String) i.get('QUESTION_Insurance_Plans__c');
            tempMap.put('label', tempString);
            tempMap.put('value', tempString);
            returnValue.add(tempMap);
        }
        
        return returnValue;        
    }
    
    //Old Version
    @AuraEnabled
    public static List<Map<String, String>> getHealthPlanValuesServerOld(String planType, String lineOfBusiness) {
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
         public static List<Map<String, String>> getMedicalGroupIPAValuesServer(String serviceCategory, String planType, String lineOfBusiness, String healthPlan) {
        String query = 'SELECT Medical_Group__c FROM Insurance_Matrix__c WHERE inactive__c = false';
             serviceCategory = '';
            for(serviceCategoriesType__mdt serviceType: [select id,MasterLabel from serviceCategoriesType__mdt]){
                serviceCategory = serviceCategory =='' ? (' QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'')  :  ( serviceCategory +' OR QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'');
                    }        
            serviceCategory = ' and ('+serviceCategory+')';
        if(planType != null){
            query += ' and QUESTION_Product__c = \'' + planType + '\'' ;
        }
        if(lineOfBusiness != null){
            query += ' and QUESTION_Line_of_Bus__c = \'' + lineOfBusiness + '\'';
        }
        if(healthPlan != null){
            query += ' and QUESTION_Insurance_Plans__c = \'' + healthPlan + '\'';
        }
        if(serviceCategory !=null){
            //query += ' and QUESTION_Service_Categories__c = \'' + serviceCategory + '\'';
            query += serviceCategory;
        }
        query += ' GROUP BY Medical_Group__c';
        system.debug('Medical Group/IPA Query : ' + query);
        List<AggregateResult> medicalGroups = database.query(query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: medicalGroups) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('Medical_Group__c'));
            tempMap.put('value', (String) i.get('Medical_Group__c'));
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
    public static List<Map<String, String>> getMedicalGroupIPAValuesServerOld(String planType, String lineOfBusiness, String healthPlan) {
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getLocationValuesServer(String department, String serviceline, String specialty, String physician, string inspdccs) {
        inspdccs = inspdccs =='NMC'?'National Medical Center':inspdccs;
        String query = 'SELECT Location__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        
        if(department != null){
            query += ' and Department__c  = \'' + department + '\'' ;
        }
        if(serviceline != null){
            query += ' and Service_Line__c  = \'' + serviceline + '\'';
        }
        if(specialty != null){
            query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';
        }
        if(physician != null){
            query += ' and Provider__c  = \'' + physician + '\'';
        }
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){
            query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';
        }
        query += ' GROUP BY Location__c ';
        system.debug('Location Query : ' + query);
        List<AggregateResult> location = database.query(query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        
        for (AggregateResult i: location) {
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', (String) i.get('Location__c'));
            tempMap.put('value', (String) i.get('Location__c'));
            returnValue.add(tempMap);
        }
        return returnValue;        
    }
    
    @AuraEnabled
    public static List<Map<String, String>> getLocationValuesServerOld(String planType, String lineOfBusiness, String healthPlan, String medicalGroupIPA) {
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
            throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseInsuranceTabServer(): Error during upsert: ' + e.getMessage());
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
         String supportPoolVal = '';
                          //START Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
        if(caseRecord.Clinical_Process_Complete__c){
            caseRecord.Clinical_Process_Date_Time__c = System.now();
        } else {
            caseRecord.Clinical_Process_Date_Time__c = null;
        }
        //END Changes by Sanjay on 05/29/2022: Clinical_Process_Date_Time__c Changes
        if(caseRecord.Epic_Location_Pool_Registry__c != null){
           
            supportPoolVal = (String) [select id,Epic_Location_Pool_ID__c from Epic_Location_Pool_Registry__c where id=:caseRecord.Epic_Location_Pool_Registry__c limit 1].Epic_Location_Pool_ID__c;
        }
        caseRecord.Support_Pool__c =supportPoolVal;
        
        
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
                        throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Account record: ' + e.getMessage());
                    }
                } else {    // Could not locate the physician
                    try {
                        upsert parentObj;
                        processingCodeVal = 'Physician Not Located';
                    }  catch (Exception e) {
                        throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Account record: ' + e.getMessage());
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
                throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseClinicalInfoTabServer(): Improperly formatted API Name value: ' + newCaseOwnerAPIName);
            }
        }
        
        try {
            upsert caseRecord;
            if (processingCodeVal != 'Physician Not Located') {     // Don't overwrite the warning if the Physician was not located.
                processingCodeVal = 'Success';
            }
        }  catch (Exception e) {
            System.debug('Exception'+e.getMessage());
            if(!test.isRunningTest())
            throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseClinicalInfoTabServer(): Error during upsert of Case record: ' + e.getMessage());
        }
        
        processingCode.put('ProcessingCode', processingCodeVal);
        Case recUpdatedCaseRecord = [Select Id, Clinical_Team_Member_Assignment__c from Case where Id =: caseRecord.Id];
        processingCode.put('ClinicalTeamMember',recUpdatedCaseRecord.Clinical_Team_Member_Assignment__c);
        return processingCode;       
    }
    
    /*
     * Save the caseRecord from the CreateEPICEncounter.
     * 
     * @param caseRecord                    The case record to save
     *  
     */
     @AuraEnabled
    public static case saveCreateEPICEncounters(Case caseRecord) {
       upsert caseRecord;
        String supportPoolVal ='';
        String vals = '';
        if(caseRecord.Epic_Location_Pool_Registry__c != null){
        	supportPoolVal = (String) [select id,Name from Epic_Location_Pool_Registry__c where id=:caseRecord.Epic_Location_Pool_Registry__c limit 1].Name;
        }
        if (caseRecord.Routing_Comments__c != null) {
            vals='Epic Location Pool Registry: ' + supportPoolVal +
                '<br><br>History of Present Illness:<br>' + (caseRecord.History_of_Present_Illness__c).escapeHTML4() +
                '<br><br>Symptoms:<br>' + (caseRecord.Symptoms__c).escapeHTML4() +
                '<br><br>KPS:<br>' + (caseRecord.KPS__c).escapeHTML4() +
                '<br><br>Treatment Received:<br>' + (caseRecord.Treatment_Received__c).escapeHTML4() +
                '<br><br>Obtain Records From:<br>' + (caseRecord.Obtain_Records_From__c).escapeHTML4() +
                '<br><br>Routing Comments:<br>' + (caseRecord.Routing_Comments__c).escapeHTML4();
        } else {
            vals='Epic Location Pool Registry: ' + supportPoolVal +
                '<br><br>History of Present Illness:<br>' + (caseRecord.History_of_Present_Illness__c).escapeHTML4() +
                '<br><br>Symptoms:<br>' + (caseRecord.Symptoms__c).escapeHTML4() +
                '<br><br>KPS:<br>' + (caseRecord.KPS__c).escapeHTML4() +
                '<br><br>Treatment Received:<br>' + (caseRecord.Treatment_Received__c).escapeHTML4() +
                '<br><br>Obtain Records From:<br>' + (caseRecord.Obtain_Records_From__c).escapeHTML4();
        }
        ContentNote cntNte = new ContentNote();
        cntNte.Content = Blob.valueof(vals);
        
        cntNte.Title = 'In-Basket Message';
        insert cntNte;
        
        ContentDocumentLink clnk = new ContentDocumentLink();
        
        clnk.LinkedEntityId = caseRecord.Id; 
        clnk.ContentDocumentId = cntNte.Id;
        
        insert clnk;
      return caseRecord;
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
    public static Map<String, String> saveCOHCaseAppointmentInfoTabServer(Boolean updateTime,Boolean nullTime,Case caseRecord, String newCaseOwnerAPIName, String reasonNotOffered, Map<String, Boolean> selectListMap) {
               
        if(updateTime){
            if(!nullTime){
                caseRecord.Date_SmartPhrase_Sent_auto_time_stamp__c = System.now();
            }else{
                caseRecord.Date_SmartPhrase_Sent_auto_time_stamp__c = null; 
             }                                                                   
        }
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
        
        Set<String> keyset = selectListMap!=null ? selectListMap.keySet(): new Set<String>();
        if (keyset.size() > 0) {
            for (String key : keyset)  {
                Boolean val = selectListMap.get(key);
                if (key.equalsIgnoreCase(PATIENT_REGISTERED_FIELD_ID))  {
                   // caseRecord.Patient_Registered__c = val;
                } else if (key.equalsIgnoreCase(PATIENT_SCHEDULED_FIELD_ID))  {
                 //   caseRecord.Pt_scheduled_1st_Call__c = val;
                } else {
                    throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseAppointmentInfoTabServer(): unrecognized key: ' + key);
                }
            }
        }

        if (String.isNotEmpty(reasonNotOffered) && caseRecord.Patient_Offered_Appointment__c != 'Yes')  {
         //   caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c =  reasonNotOffered;           
        } else {
          //  caseRecord.Reason_Not_Offered_Appt_Within_2_Days__c =  null;
        }
        
        if (String.isEmpty(newCaseOwnerAPIName) ) {
            // The Clinical Team Member Assignment is set to empty, but 
            // the Case Owner should not change.
         //   caseRecord.Clinical_Team_Member_Assignment__c = newCaseOwnerAPIName;
        } else {
            List<String> nameTokens = newCaseOwnerAPIName.split(';');
            if (COHUtil.isValidList(nameTokens) && nameTokens.size() == 2) {
                String newCaseOwnerEmployeeID = nameTokens.get(1);
                if (String.isNotEmpty(newCaseOwnerEmployeeID)) {
                    Id newCaseOwnerID = getActiveUserID(';' + newCaseOwnerEmployeeID); // convert to the format used by the method
                    if (String.isNotEmpty(newCaseOwnerID)) {
                      //  caseRecord.Clinical_Team_Member_Assignment__c = newCaseOwnerAPIName;
                     //   caseRecord.OwnerId = newCaseOwnerID;
                      //  caseRecord.Clinical_Team_Assignment_User__c = newCaseOwnerID;
                    }
                }
            } else {
                throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseAppointmentInfoTabServer(): Improperly formatted API Name value: ' + newCaseOwnerAPIName);
            }
        }
        try {
            upsert caseRecord;
        } catch (DmlException e){
          throw new AurahandledException('Error Details: ' + e.getDMLMessage(0));  
        } catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseAppointmentInfoTabServer(): Error during upsert: ' + e.getMessage());
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
                            throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseCancelationInfoTabServer(): Record information saved, but could not locate the user with this Employee ID' + employeeID);
                        }
                    } 
                    
                    try {
                        if (Test.isRunningTest() == false) {
                            Messaging.sendEmail(emailList);
                        }
                    } catch (Exception e) {
                        throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseCancelationInfoTabServer(): Record information saved, but encountered an error while sending the emails: ' + e.getMessage());
                    }
                } else {
                    throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseCancelationInfoTabServer(): Record information saved, but no User IDs were provided for the email notification');
                }
            }  
        } catch (Exception e) {
            throw new AuraHandledException('COHCaseInsuranceTabController.saveCOHCaseCancelationInfoTabServer(): Error during upsert: ' + e.getMessage());
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getDepartmentValuesServer(String location, String serviceline, String specialty, String physician, string inspdccs) {
        inspdccs = inspdccs =='NMC'?'National Medical Center':inspdccs;
        String query = 'SELECT Department__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        if(location != null){query += ' and Location__c  = \'' + location + '\'' ;}
        if(serviceline != null){query += ' and Service_Line__c  = \'' + serviceline + '\'';}
        if(specialty != null){query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';}
        if(physician != null){query += ' and Provider__c  = \'' + physician + '\'';}
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';}
        query += ' GROUP BY Department__c';
        system.debug('Department Query : ' + query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctDepartments = database.query(query);
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getServiceLineValuesServer(String location, String department, String specialty, String physician, string inspdccs) {
        String query = 'SELECT Service_Line__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        if(location != null){query += ' and Location__c  = \'' + location + '\'' ;}
        if(department != null){query += ' and Department__c  = \'' + department + '\'';}
        if(specialty != null){query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';}
        if(physician != null){query += ' and Provider__c  = \'' + physician + '\'';}
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';}
        query += ' GROUP BY Service_Line__c';
        system.debug('ServiceLine Query : ' + query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctServiceLines = database.query(query);
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSpecialtyValuesServer(String location, String department, String serviceline, String physician, string inspdccs) {
        inspdccs = inspdccs =='NMC'?'National Medical Center':inspdccs;
        String query = 'SELECT Specialty_Diagnosis__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        if(location != null)
             {query += ' and Location__c  = \'' + location + '\'' ;}
        if(department != null)
            {query += ' and Department__c  = \'' + department + '\'';}
        if(serviceline != null)
           {query += ' and Service_Line__c  = \'' + serviceline + '\'';}
        if(physician != null)
           {query += ' and Provider__c  = \'' + physician + '\'';}
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None')
           {query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';}
        query += ' GROUP BY Specialty_Diagnosis__c';
        system.debug('Specialty Query : ' + query);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctSpecialties = database.query(query);
        returnValue = buildSelectList(distinctSpecialties, 'Specialty_Diagnosis__c');
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getPhysiciansServer(String location, String department, String serviceline, String specialty, string inspdccs) {
        inspdccs = inspdccs =='NMC'?'National Medical Center':inspdccs;
        String query = 'SELECT Provider__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        if(location != null){query += ' and Location__c  = \'' + location + '\'' ;}
        if(department != null){query += ' and Department__c  = \'' + department + '\'';}
        if(serviceline != null){query += ' and Service_Line__c  = \'' + serviceline + '\'';}
        if(specialty != null){query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';}
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';}
        query += ' GROUP BY Provider__c';
        system.debug('Physician Query : ' + query);
        system.debug('serviceline value : ' + serviceline);
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctPhysician = database.query(query);
        returnValue = buildSelectList(distinctPhysician, 'Provider__c');
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
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSubgroupNumberServer(String department, String serviceline, String specialty) {
        List<Map<String, String>> returnValue = new List<Map<String, String>>();
        List<AggregateResult> distinctSubgroups = [SELECT Subgroup_No__c  FROM Physician_Matrix__c WHERE Department__c=:department AND Service_Line__c=:serviceline AND Specialty_Diagnosis__c  =:specialty GROUP BY Subgroup_No__c ];
        returnValue = buildSelectList(distinctSubgroups, 'Subgroup_No__c');
        
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
    

    @AuraEnabled(cacheable=true)
    public static List<Id> getUserIds(){
        List<PermissionSetAssignment> psList = new List<PermissionSetAssignment>();
        List<Id> userIds = new List<Id>();
        psList = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Patient_Access_Data_Administrators'];
        for(PermissionSetAssignment pa:psList){
            userIds.add(pa.AssigneeId);
        }
        return userIds;
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
            if (labelPicklist =='Donor' || labelPicklist == 'BMT' || labelPicklist =='Kaiser BMT' || labelPicklist =='New Cancer Diagnosis'|| labelPicklist =='Newly Diagnosed / Problem​ (non-cancer)'|| labelPicklist =='Reccurrence'|| labelPicklist =='Screening/Risk'|| labelPicklist =='Second Opinion Not on Treatment'|| labelPicklist =='Second Opinion on Treatment') {
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
    @AuraEnabled
    public static Id getPhysicianID(String physicianStr) {
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
                    String soqlQueryStr = 'select id, firstname, lastname from Contact where recordtypeid = \'' + COHContactRecordType + '\' and inactive__c = false and Type__c = \'Physician\' and firstname like \'%'+firstname+'\' and lastname like \'%' + lastName +'\'';
                    system.debug('soqlQueryStr = ' + soqlQueryStr);
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

    // START: changes by Sanjay on 09/16/2021
    /*
     * Retrieve all Locations for the Appointment Information Tab
     * 
     * @return List<Map<String, String>>        List of all locations
     * 
     */
    private static List<Map<String, String>> getLocationValues() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Case.Location__c.getDescribe();
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
    // END: changes by Sanjay on 09/16/2021
    
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

    /* Method that will grab the records to be placed in a tile component in the Case | Insurance tab lightning page component. */

    @AuraEnabled(cacheable=true)
    public static String searchPhysicianMatrix(String locationVal, String department, String serviceline, String specialty, String physician,String caseId,string inspdccs){
        String query = 'SELECT Id, Name, Location__c, Department__c, Service_Line__c, Specialty_Diagnosis__c, Provider__c, Geolocation__c, Scheduling_Guidelines__c, Does_not_seetreat__c, Subgroup_No__c FROM Physician_Matrix__c WHERE Inactive__c = false';
        if(locationVal != null){
            query += ' and Location__c  = \'' + locationVal + '\'' ;
        }
        if(department != null){
            query += ' and Department__c  = \'' + department + '\'';
        }
        if(serviceline != null){
            query += ' and Service_Line__c  = \'' + serviceline + '\'';
        }
        if(specialty != null){
            query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';
        }
        if(physician != null){
            query += ' and Provider__c  = \'' + physician + '\'';
        }
        if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){
            query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';
        }
        if(locationVal == null && department == null && serviceline == null && specialty == null && physician == null){
            query += ' LIMIT 0';
        }else{
            query += ' order by Location__c ASC';
        }
        
        Case cse = [Select id,Accountid,Account.Patient_Location__c,lead__r.Longitude,lead__r.Latitude,lead__r.isConverted,lead__c from case where id=:caseId];
        system.debug('Physician Matrix Query : ' + query);
        System.debug('caseId'+caseId);

        List<SObject> sObjectListPhysicianMatrices=Database.query(query);
        List<physicianList> physicianListRec = new List<physicianList>();
        for(Sobject inx : sObjectListPhysicianMatrices){
            Physician_Matrix__c ind = (Physician_Matrix__c)inx;
            
            if(cse.lead__c == null || cse.lead__r.isConverted){            
                location pmLoc = ind.GeoLocation__c;
                location accLoc = cse.Account.Patient_Location__c;
                decimal dist = 0;
                if(pmLoc!=null&&accLoc!=null)
                    dist = pmLoc.getDistance(accLoc,'mi');
                physicianList inv = new physicianList(dist,dist.setScale(2) +' miles',ind);
                
                physicianListRec.add(inv);
                System.debug('dist'+dist);
            }else{
                location pmLoc = ind.GeoLocation__c;
                location leadloc;
                if(cse.lead__r.Latitude!=null && cse.lead__r.Longitude != null)
                 leadloc = Location.newInstance(Double.valueof( cse.lead__r.Latitude),Double.valueof(cse.lead__r.Longitude));
                decimal dist = 0;
                if(pmLoc!=null&&leadloc!=null)
                    dist = pmLoc.getDistance(leadloc,'mi');
                physicianList inv = new physicianList(dist,dist.setScale(2) +' miles',ind);
                
                physicianListRec.add(inv);
                System.debug('dist'+dist);
            }
        }
        
        physicianListRec.sort();
        
        return JSON.serialize(physicianListRec) ;
    }
    
    /*public class physicianList{
        Public Decimal DistanceinMiles;
Public Decimal hj
        public String Distance;
        public Physician_Matrix__c record;
    }*/
     
    
     @AuraEnabled
        public static WrapperSchedulingGuidelines getSchedulingGuidelines(String planType, String lineOfBusiness, String healthPlan, String medicalGroupIPA, String servicecategories,String authrequired) {
            String formPrimaryDeliveryofCareCenter;
            String formLOANeededHosp;
            String formLOANeededProf;
            String formHospLinkText;
            String formClinicalNetworkText;
            String formSchedulingGuidelinesHosp;
            String formSchedulingGuildelinesProf;
            
            Insurance_Matrix__C recIMHospital = new Insurance_Matrix__C();
            Insurance_Matrix__C recIMProf = new Insurance_Matrix__C();
            String location_prof = '';
            String location_hosp = '';
            //authrequired = authrequired == 'Yes'? 'Y' : 'N';
            servicecategories = '';
            for(serviceCategoriesType__mdt serviceType: [select id,MasterLabel from serviceCategoriesType__mdt]){
                servicecategories = servicecategories =='' ? (' QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'')  :  ( servicecategories +' OR QUESTION_Service_Categories__c = \'' + serviceType.MasterLabel + '\'');
                    }        
            servicecategories = ' and ('+servicecategories+')';
            //Changes start by Vara on 8-30-2022 Added fields to the query PROF_Scheduling_Decision_Tree__c,HOSP_Scheduling_Decision_Tree__c
            String query = 'SELECT Id,Comments__c,PROF_Scheduling_Decision_Tree__c,HOSP_Scheduling_Decision_Tree__c,QUESTION_Insurance_Plans__c,QUESTION_Line_of_Bus__c,QUESTION_Product__c,QUESTION_Service_Categories__c,Auth_Required__c,MAIN_Phone_Number__c,Auth_Phone__c,Auth_Fax__c,Auth_Time_List__c,HOSPITAL_Contract_Status__c,PROFESSIONAL_Contract_Status__c,LOCATION_for_Service__c FROM Insurance_Matrix__c where inactive__c = false ';
            //Changes end by vara on 8-30-2022       
            if(lineOfBusiness != null || healthPlan != null || medicalGroupIPA !=null || planType !=null || authrequired !=null || servicecategories !=null){
            if(lineOfBusiness != null){
                query += ' and QUESTION_Line_of_Bus__c = \'' + lineOfBusiness + '\'';
            }
            if(healthPlan != null){
                query += ' and QUESTION_Insurance_Plans__c = \'' + healthPlan + '\'';
            }
            if(medicalGroupIPA != null){
                query += ' and Medical_Group__c = \'' + medicalGroupIPA + '\'';
            }
            if(planType !=null){
                query += ' and QUESTION_Product__c = \'' + planType + '\'';
            }
            /* if(authattimeofscheduling !=null){
                query += ' and Does_patient_have_auth_at_time_of_schedu__c = \'' + authattimeofscheduling + '\'';
            }*/
            			
            /*if(authrequired !=null){
                query += ' and  Auth_Required__c = \'' + authrequired + '\'';
            }*/
            if(servicecategories !=null){
                //query += ' and  QUESTION_Service_Categories__c = \'' + servicecategories + '\'';
                query += servicecategories;
            }
          
        }
        //query += ' GROUP BY QUESTION_Service_Categories__c';
        system.debug('Service Category Query : ' + query);
        List<Insurance_Matrix__c> insuranceMatrixs = database.query(query);
                
        for (Insurance_Matrix__c i: insuranceMatrixs) {
        //Modifying HOSP to NMC per DataLoad 03/07/2022 LK
        //    if(i.LOCATION_for_Service__c == 'HOSP') {
            if(i.LOCATION_for_Service__c == 'NMC') {
                recIMHospital = i;
                location_hosp = i.HOSPITAL_Contract_Status__c;         
            }
        //Modifying PROF to CLN per DataLoad 03/07/2022 LK
        //    if(i.LOCATION_for_Service__c == 'PROF') { 
            if(i.LOCATION_for_Service__c == 'CLN') {
                recIMProf = i;
                location_prof = i.PROFESSIONAL_Contract_Status__c;                    
            }  
        }
             formHospLinkText = ((recIMHospital.id) != null ? 'Link':'');
             formClinicalNetworkText = ((recIMProf.id) != null ? 'Link':'');
             formPrimaryDeliveryofCareCenter = (((location_hosp =='Contracted') || (location_hosp == 'Participating')) && (location_prof=='Contracted' || location_prof=='Participating') ? 'Both':
             ((location_hosp) !='Contracted' && (location_prof)!='Contracted' && (location_hosp) != 'Participating' && (location_prof) != 'Participating' ? 'None':
             ((location_hosp)=='Contracted' || (location_hosp) == 'Participating' ? 'NMC' :
             ((location_prof)=='Contracted' || (location_prof) == 'Participating' ? 'Clinical Network':'')))); 
             formLOANeededHosp = ((location_hosp)=='Contracted' ? 'No' : ((location_hosp)=='Non Contracted'? 'Yes':''));
             formLOANeededProf = ((location_prof)=='Contracted' ? 'No' : ((location_prof)=='Non Contracted'? 'Yes':''));
             /* Start: Added by Vara on 8-14-2022 for the Knowledge Article "NEW Scheduling Guidelines (approved 7/20/2022)"  
             if(planType == 'PPO'){
			 formSchedulingGuidelinesHosp = (location_hosp == 'Contracted'? 'Schedule Next Available':
                                            (location_hosp == 'Non Contracted'? 'Schedule 21 days for LOA':''));
            
             formSchedulingGuildelinesProf = (location_prof == 'Contracted'? 'Schedule Next Available':
                                            (location_prof == 'Non Contracted'? 'Schedule 21 days for LOA':''));
											
			}else if(planType == 'HMO' || planType == 'EPO'){									
			 formSchedulingGuidelinesHosp = (authrequired=='Yes' && (location_hosp) == 'Contracted'? 'Schedule 7 days out':
			                                (authrequired=='No' && (location_hosp) == 'Contracted'? 'Schedule 14 days out':
                                            (authrequired=='Yes' && (location_hosp) == 'Non Contracted'? 'Schedule 21 days out for LOA':
											(authrequired=='No' && (location_hosp) == 'Non Contracted'? 'Schedule 21 days out for Auth & LOA':'')))); 
            
             formSchedulingGuildelinesProf = (authrequired=='Yes' && (location_prof) == 'Contracted'? 'Schedule 7 days out':
			                                 (authrequired=='No' && (location_prof) == 'Contracted'? 'Schedule 14 days out':
                                             (authrequired=='Yes' && (location_prof) == 'Non Contracted'? 'Schedule 21 days out for LOA':
											 (authrequired=='No' && (location_prof) == 'Non Contracted'? 'Schedule 21 days out for Auth & LOA':''))));
            
            
            }else{
                formSchedulingGuidelinesHosp =(authrequired=='Yes' && (location_hosp) == 'Contracted'? 'Scheduling Next Available':
                                              (authrequired=='Yes' && (location_hosp) == 'Non Contracted'? 'Redirect or Schedule 3 Weeks Out':
                                              (authrequired=='No' && (location_hosp) == 'Contracted'? 'Schedule 14 Days Out': 
                                              (authrequired=='No' && (location_hosp) == 'Non Contracted'? 'Redirect or Offer Self-Pay': ''))));
            
             formSchedulingGuildelinesProf = (authrequired=='Yes' && (location_prof) == 'Contracted'? 'Scheduling Next Available':
                                             (authrequired=='Yes' && (location_prof) == 'Non Contracted'? 'Redirect or Schedule 3 Weeks Out':
                                             (authrequired=='No' && (location_prof) == 'Contracted'? 'Schedule 14 Days Out': 
                                             (authrequired=='No' && (location_prof) == 'Non Contracted'? 'Redirect or Offer Self-Pay': ''))));
            }*/
            /* End: Added by Vara on 8-14-2022 for the Knowledge Article "NEW Scheduling Guidelines (approved 7/20/2022)"  */ 
           /* formSchedulingGuidelinesHosp = (authrequired=='Yes' && (location_hosp) == 'Contracted'? 'Scheduling Next Available':
                                            (authrequired=='Yes' && (location_hosp) == 'Non Contracted'? 'Redirect or Schedule 3 Weeks Out':
                                            (authrequired=='No' && (location_hosp) == 'Contracted'? 'Schedule 14 Days Out': 
                                            (authrequired=='No' && (location_hosp) == 'Non Contracted'? 'Redirect or Offer Self-Pay': ''))));
            
            formSchedulingGuildelinesProf = (authrequired=='Yes' && (location_prof) == 'Contracted'? 'Scheduling Next Available':
                                            (authrequired=='Yes' && (location_prof) == 'Non Contracted'? 'Redirect or Schedule 3 Weeks Out':
                                            (authrequired=='No' && (location_prof) == 'Contracted'? 'Schedule 14 Days Out': 
                                            (authrequired=='No' && (location_prof) == 'Non Contracted'? 'Redirect or Offer Self-Pay': '')))); */
            
             WrapperSchedulingGuidelines obj = new WrapperSchedulingGuidelines(formPrimaryDeliveryofCareCenter,formLOANeededHosp,formLOANeededProf,formHospLinkText,
                                                                               formClinicalNetworkText,recIMHospital,recIMProf,formSchedulingGuidelinesHosp,formSchedulingGuildelinesProf);
        return obj;
    }
        
    public class WrapperSchedulingGuidelines {
 
        @AuraEnabled Public String formPrimaryDeliveryofCareCenter {get;set;}
        @AuraEnabled Public Insurance_Matrix__C recIMHospital{get;set;}
        @AuraEnabled Public Insurance_Matrix__C recIMProf{get;set;}
        @AuraEnabled Public String formLOANeededHosp {get;set;}
        @AuraEnabled Public String formLOANeededProf {get;set;}
        @AuraEnabled Public String formHospLinkText {get;set;}
        @AuraEnabled Public String formClinicalNetworkText {get;set;}
        @AuraEnabled Public String formSchedulingGuidelinesHosp {get;set;}
        @AuraEnabled Public String formSchedulingGuildelinesProf {get;set;}
        
        Public WrapperSchedulingGuidelines(String formPrimaryDeliveryofCareCenter,String formLOANeededHosp,String formLOANeededProf,String formHospLinkText,
                                           String formClinicalNetworkText,Insurance_Matrix__C recIMHospital,Insurance_Matrix__C recIMProf,
                                           String formSchedulingGuidelinesHosp,String formSchedulingGuildelinesProf){
            this.formPrimaryDeliveryofCareCenter = formPrimaryDeliveryofCareCenter;
            this.formLOANeededHosp = formLOANeededHosp;
            this.formLOANeededProf = formLOANeededProf;
            this.formHospLinkText = formHospLinkText;
            this.formClinicalNetworkText = formClinicalNetworkText;
            this.formSchedulingGuidelinesHosp = formSchedulingGuidelinesHosp;
            this.formSchedulingGuildelinesProf = formSchedulingGuildelinesProf;                                  
            this.recIMHospital = recIMHospital;
            this.recIMProf = recIMProf;
        }
    }
    
     @AuraEnabled
    public static dateTime getDateTimeStamp (){
        
        return system.now();
    }
    
 //Start Sanjay Singh 06/20/2022 for Physician / Insurance Decision Tree
 @AuraEnabled(cacheable=true)
 public static List<Physician_Matrix__c> searchPhysicianMatrixRecords(String locationVal, String department, 
 String serviceline, String specialty, String physician,string inspdccs){
     String query = 'SELECT Id, Name, Location__c, Department__c, Service_Line__c, Specialty_Diagnosis__c, Provider__c, Geolocation__c, Scheduling_Guidelines__c, Does_not_seetreat__c, Subgroup_No__c FROM Physician_Matrix__c WHERE Inactive__c = false';
     if(locationVal != null){
         query += ' and Location__c  = \'' + locationVal + '\'' ;
     }
     if(department != null){
         query += ' and Department__c  = \'' + department + '\'';
     }
     if(serviceline != null){
         query += ' and Service_Line__c  = \'' + serviceline + '\'';
     }
     if(specialty != null){
         query += ' and Specialty_Diagnosis__c  = \'' + specialty + '\'';
     }
     if(physician != null){
         query += ' and Provider__c  = \'' + physician + '\'';
     }
     if(inspdccs != null && inspdccs != 'Both'  && inspdccs != 'None'){
         query += ' and Type_of_Network__c  = \'' + inspdccs + '\'';
     }
     if(locationVal == null && department == null && serviceline == null && specialty == null && physician == null){
         query += ' LIMIT 0';
     }else{
         query += ' order by Location__c ASC';
     }
     system.debug('Physician Matrix Query : ' + query);
     return Database.query(query);
 }
//End Sanjay Singh 06/20/2022 for Physician / Insurance Decision Tree
}