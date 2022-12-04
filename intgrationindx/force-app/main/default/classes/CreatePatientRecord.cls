public class CreatePatientRecord {
    public static void fullPatientRecord(String iteration){
        String varIteration = iteration;
        
        //Account Setup variables
        String AccountObjectType = 'Account';
        String PatientScreenUnification = 'Patient (Screen Unification)';
        String varFirstName = 'Testy';
        String varLastName = 'Subject' + ' ' + varIteration;
        String varSalutation = 'Mr.';
        Date varPersonBirthDate = date.today().addYears(-50);
        String varPrimaryPhoneNumber = 'Mobile';
        String varGender = 'Male';
        String varPersonMobilePhone = '626-841-0185';
        String varPatientStreet = '10 Edward Circle';
        String varPatientCity = 'Montville';
        String varPatientState = 'New Jersey';
        String varPatientPostalCode = '07045';
        String varPatientCountry = 'United States of America';
        Id recPatientScreenUnificationRecordType = COHUtil.getRecordType(AccountObjectType,PatientScreenUnification);
        String varECMobile = '999-999-9999';
        String varECHome = '888-888-8888';
        String varECWork = '777-777-7777';
        
        //Case Setup Variables
        String CaseObjectType = 'Case';
        String EnterpriseAccessNewPatient = 'Enterprise Access – New Patient';
        Id recEnterpriseAccessNewPatientRecordType = COHUtil.getRecordType(CaseObjectType,EnterpriseAccessNewPatient);
        String varStatus = 'New';
        String varOrigin = 'Inbound Call';
        String varLightIndicatorNPS = 'Green';
        String varPriority = 'Routine';
        String varCallerRelationshiptoPatient = 'Self';
        Boolean varCallerSameAsPatient = true;
        
        //Guarantor
        String varGLastName = 'Gia';
        String varGFirstName = 'Tranquility';
        String varGMiddleName = 'A.';
        String varGCity = 'South Pasadena';
        String varGPostalCode = '91030';
        String varGState = 'California';
        String varGSSN = '323-23-4858';
        String varGStreet = '1702 Lyndon Street';
        String varGGuaranotorType = 'P/F';
        
        
        
        Account recAccount = new Account();
        recAccount.FirstName = varFirstName;
        recAccount.LastName =  varLastName; 
        recAccount.Salutation = varSalutation;
        recAccount.PersonBirthdate = varPersonBirthDate;
        recAccount.Primary_Phone_Number__c = varPrimaryPhoneNumber;
        recAccount.PersonMobilePhone = varPersonMobilePhone;
        recAccount.Gender__pc = varGender;
        recAccount.Primary_Phone_Number__c = varPrimaryPhoneNumber;
        recAccount.PersonMobilePhone = varPersonMobilePhone;
        recAccount.Patient_Street1__c = varPatientStreet;
        recAccount.Patient_City__c = varPatientCity;
        recAccount.COH_PA_State__c = varPatientState;
        recAccount.Patient_Postal_Code__c = varPatientPostalCode;
        recAccount.COH_PA_Country__c = varPatientCountry;
        recAccount.RecordtypeId = recPatientScreenUnificationRecordType;
        recAccount.COH_Account_EC_PatientAccess_MobilePhone__c = varECMobile;
        recAccount.COH_Account_EC_PatientAccess_WorkPhone__c = varECWork;
        recAccount.COH_Account_EC_PatientAccess_HomePhone__c = varECHome;
        insert recAccount;
        
        Case recCase = new Case();
        recCase.AccountId = recAccount.Id;
        recCase.Status = varStatus;
        recCase.ContactId = recAccount.PersonContactId;
        recCase.Caller_First_Name__c = recAccount.FirstName;
        recCase.Caller_Last_Name__c = recAccount.LastName;
        recCase.Primary_Callback_Number__c = recAccount.PersonMobilePhone;
        recCase.Caller_Same_as_Patient__c = varCallerSameAsPatient;
        recCase.Caller_Relationship_to_Patient__c = varCallerRelationshiptoPatient;
        recCase.RecordTypeId = recEnterpriseAccessNewPatientRecordType;
        recCase.Origin = varOrigin;
        recCase.Light_Indicator_NPS__c = varLightIndicatorNPS;
        recCase.Priority = varPriority;
        
        recCase.RecordTypeId = recEnterpriseAccessNewPatientRecordType;
        insert recCase;
        
        Epic_Account_Data__c recEpicAccountData = new Epic_Account_Data__c(Account__c = recAccount.Id,
                                                                           Authorization_number_1__c = 'Auth1Number',
                                                                           Group_Number_1_c__c  = 'GroupNumber1',
                                                                           Guarantor1_Birth_Date__c = date.today().addYears(-51),
                                                                           Guarantor1_City__c = varGCity,
                                                                           Guarantor1_Country__c = varPatientCountry,
                                                                           Guarantor1_FirstName__c = varGFirstName,
                                                                           Guarantor1_Gender__c = 'Male',
                                                                           Guarantor1_Home_Phone__c = '222-222-2222',
                                                                           Guarantor1_Id__c ='100123',
                                                                           Guarantor1_LastName__c = varGLastName,
                                                                           Guarantor1_MiddleName__c = varGMiddleName,
                                                                           Guarantor1_Mobile_Phone__c = '333-333-3333',
                                                                           Guarantor1_PostalCode__c  = varGPostalCode,
                                                                           Guarantor1_SSN__c = varGSSN,
                                                                           Guarantor1_State__c = varGState,
                                                                           Guarantor1_Street__c = varGStreet,
                                                                           Guarantor1_Type__c = varGGuaranotorType,
                                                                           Guarantor1_Work_Phone__c  = '444-444-4444',
                                                                           Insurance_Birth_Date_1__c = date.today().addYears(-52),
                                                                           Insurance_City_1__c = 'San Gabriel',
                                                                           Insurance_Country_1__c = varPatientCountry,
                                                                           Insurance_Gender_1__c = 'Male',
                                                                           Insurance_Member_eff_from_1__c = date.today(),
                                                                           Insurance_PostalCode_1__c	= '91776',
                                                                           Insurance_SSN_1__c	= '999-88-7777',
                                                                           Insurance_State_1__c = 'California',
                                                                           Insurance_Street_1__c = '1420 South Gladys Avenue',
                                                                           Insurance_Subscriber_First_Name_1__c = 'David',
                                                                           Insurance_Subscriber_Last_Name_1__c  = 'Copperfield',
                                                                           Insurance_Subscriber_Middle_Name_1__c = 'M.'
                                                                          );
        insert recEpicAccountData;
    }
}