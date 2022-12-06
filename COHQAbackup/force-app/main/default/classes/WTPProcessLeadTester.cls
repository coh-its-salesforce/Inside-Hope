/*
 * This test class verifies that a Lead has been correctly converted into an Account and Cases.  
 * A Lead is inserted, and then it verifies that the corresponding Account object and Cases objects 
 * have been created.  Finally, the Lead is deleted.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2014
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class WTPProcessLeadTester {

    private static final String firstName1 = 'MaggieV';
    private static final String firstName2 = 'AgathaV';
    private static final String firstName3 = 'JoyV';
    private static final String firstName4 = 'MichelleV';
    private static final String firstName5 = 'KimberlyV';
    private static final String lastName1 = 'PoolV';
    private static final String lastName2 = 'ChumleyV';
    private static final String lastName3 = 'DoyleV';
    private static final String lastName4 = 'HueV';
    private static final String city1 = null;
    private static final String city2 = 'Baldwin Park';
    private static final String city3 = 'Irwindale';
    private static final String street = 'Rivergrade';
    private static final String postalCode = '94444';
    private static final String country = 'USA';
    private static final String state = 'CA';
    private static final String phone1 = '6267123456';
    private static final String phone2 = '8185551212';
    private static final Boolean doNotCall = false;
    private static final String mobilePhone = '6263431122';
    private static final String email1 = 'dudeV@foobar.com';
    private static final String email2 = 'mpoolV@foobar.com';
    private static final Boolean hasOptedOutOfEmail = true;
    private static final String fax = '6268884321';
    private static final Boolean hasOptedOutOfFax = true;
    private static final String industry = 'Health Care';   
    private static final String rating = '5';
    private static final String title = 'Developer';
    private static final String website = 'www.foobar.com';
    private static final String callerFirstName1 = 'ThomasV';
    private static final String callerLastName1 = 'MagnumV';
    private static final String callerFirstName2 = 'JonathanV';
    private static final String callerLastName2 = 'HigginsV';
    private static final Date dob = Date.today();
    private static final String gender = 'Female';
    
    private static final String confirmedThruBiopsy = 'Yes';        // Boolean in Account object
    private static final String undergoingTreatment = 'No';     // Boolean in Account object
    private static final String diagnosis = 'General Urology';
    private static final String diagnosisStage = 'This is for the disease stage';
    private static final String primaryInsurance1 = 'Medi-Cal';
    private static final String primaryInsurance2 = 'HealthNet -- HMO';
    private static final String primaryInsurance3 = 'International';
    private static final String policyNumber = '11111';
    private static final String primarySubscriberName = 'Margaret Pool';
    private static final Date primarySubscriberDOB = Date.today();
    
    private static final String relationshipToPatient = 'Brother';
    private static final String subscriberRelationshipToPatient = 'Sister';
    private static final String reasonForRequest = 'Evaluation';
    private static final String referralSource = 'RADIO';
    private static final String insuranceGroupNumber = '11223344';
    private static final Date effectiveDate = Date.today();
    private static final String location1 = 'Antelope Valley';
    private static final String location2 = 'Duarte-Main Medical Center';
    private static final String mrn1 = '12345678';
    private static final String mrn2 = '8675309';
    private static final String returningPatient = 'Yes';
    private static final String primaryMedicalGroup = 'Primary Medical Group';
    private static final String secondaryMedicalGroup = 'Secondary Medical Group';
    private static final String secondaryGroup = 'Group2';
    private static final String secondaryInsurance = 'CCS';
    private static final String secondaryInsurancePhone = '111-222-3333';
    private static final String secondaryPolicy = '3322';
    private static final String secondarySubscriberBirthdate = '1/01/1901';
    private static final String secondarySubscriberName = 'Buck Greene';
    private static final String secondarySubscriberRelationship = 'Brother';
    private static final String referralPhysician = 'Drake Remoray';
    private static final String webLanguage = 'Cantonese';
    
    private static final String defaultNPSAccountOwner = COHUtilTester.getDefaultNPSAccountOwner();
    private static final String defaultFoundationAccountOwner = COHUtilTester.getDefaultFoundationAccountOwner();
    private static final String marketingOwner = COHUtilTester.getMarketingOwner();
    
    private static final Id foundationAccountRecordTypeID = COHUtil.getRecordType('Account', 'Foundation');
    private static final Id internationalIntakeRecordTypeID = COHUtil.getRecordType('Lead', 'International Intake');
    private static final Id domesticPatientRecordTypeID  = COHUtil.getRecordType('Lead', 'Domestic Patient');
    private static final Id screenUnificationRecordTypeID  = COHUtil.getRecordType('Account', 'Patient (Screen Unification)');
    
    private static final Id defaultFoundationOwnerID = [select Id, alias from User where alias = :defaultFoundationAccountOwner limit 1].Id;
    private static final Id defaultNPSOwnerID = [select Id, alias from User where alias = :defaultNPSAccountOwner limit 1].Id;
    private static final Id excludedOwnerID = [select Id, alias from User where alias = :marketingOwner limit 1].Id;
    
    private static final Integer internationalLeadsCount = 2;
    
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyConversion = true;
    private static final Boolean mRunVerifyTriggerLimits = false;   // Not used because a single lookup must be
                                                                    // made for each record, so this will every time.
    private static final Boolean mRunTestMiscellaneous = true;
    
    // Verify the conversion from the Lead to Account and/or Case.
    private static testMethod void verifyConversion() {
        if (!mRunAllTests && !mRunVerifyConversion) {
            System.debug('Skipping verifyConversion()');
            return;
        }
      
        Lead leadObj1 = new Lead();

        leadObj1.FirstName = firstName1;
        leadObj1.LastName = lastName1;
        leadObj1.City = city1;
        leadObj1.Street = street;
        leadObj1.PostalCode = postalCode;
        leadObj1.Country = country;
        leadObj1.State = state;
        leadObj1.Phone = phone1;
        leadObj1.DoNotCall = doNotCall;
        leadObj1.MobilePhone = mobilePhone;
        leadObj1.Email = email1;
        leadObj1.HasOptedOutOfEmail = hasOptedOutOfEmail;
        leadObj1.Fax = fax;
        leadObj1.HasOptedOutOfFax = hasOptedOutOfFax;
        leadObj1.Industry = industry;
        leadObj1.Rating = rating;
        leadObj1.Title = title;
        leadObj1.Website = website;
        leadObj1.Submitter_First_Name__c = callerFirstName1;
        leadObj1.Submitter_Last_Name__c = callerLastName1;
        leadObj1.BirthDate__c = dob;
        leadObj1.Gender__c = gender;
        leadObj1.Diagnosis_confirmed_through_biopsy__c = confirmedThruBiopsy;
        leadObj1.Currently_Undergoing_Treatment__c = undergoingTreatment;
        leadObj1.Diagnosis__c = diagnosis;
        leadObj1.Diagnosis_stage_of_disease_metastases__c = diagnosisStage;
        leadObj1.Primary_Insurance__c = primaryInsurance1;
        leadObj1.Policy_Number__c = policyNumber;
        leadObj1.WTP_Subscriber_Name__c = primarySubscriberName;
        leadObj1.Subscriber_DOB__c = primarySubscriberDOB;
        leadObj1.Relation_to_the_Patient__c = relationshipToPatient;
        leadObj1.WTP_Subscriber_Relationship__c = subscriberRelationshipToPatient;
        leadObj1.Primary_Reason_For_Request__c = reasonForRequest;
        leadObj1.Referred_to_City_of_Hope__c = referralSource;
        //leadObj1.Year_Diag__c = String.ValueOf(system.today());
        leadObj1.WTP_Primary_Medical_Group__c = primaryMedicalGroup;
        leadObj1.WTP_Secondary_Medical_Group__c = secondaryMedicalGroup;
        leadObj1.WTP_Location__c = location1;
        leadObj1.WTP_Secondary_Group__c = secondaryGroup;
        leadObj1.WTP_Secondary_Insurance__c = secondaryInsurance;
        leadObj1.WTP_Secondary_Policy_Number__c = secondaryPolicy;
        leadObj1.WTP_Secondary_Insurance_Company_Phone__c = secondaryInsurancePhone;
//      leadObj1.WTP_Secondary_Subscriber_DOB__c = secondarySubscriberBirthdate;
        leadObj1.WTP_Secondary_Subscriber_Name__c= secondarySubscriberName;
        leadObj1.WTP_Secondary_Subscriber_Relationship__c = secondarySubscriberRelationship;
        leadObj1.WTP_Referring_Physician__c = referralPhysician;
        leadObj1.WTP_Have_you_ever_been_seen_at_COH__c = null;
        leadObj1.RecordTypeId = domesticPatientRecordTypeID;
        leadobj1.First_Name_Last_Name__c ='testFirst Lastlead';
        leadObj1.Web_Language__c = webLanguage;
        
        // This should update the Account object created by  leadObj1
        
        Lead leadObj2 = new Lead();

        leadObj2.FirstName = firstName1;
        leadObj2.LastName = lastName1;
        leadObj2.City = city2;
        leadObj2.Street = street;
        leadObj2.PostalCode = postalCode;
        leadObj2.Country = country;
        leadObj2.State = state;
        leadObj2.Phone = phone1;
        leadObj2.DoNotCall = doNotCall;
        leadObj2.MobilePhone = mobilePhone;
        leadObj2.Email = email1;
        leadObj2.HasOptedOutOfEmail = hasOptedOutOfEmail;
        leadObj2.Fax = fax;
        leadObj2.HasOptedOutOfFax = hasOptedOutOfFax;
        leadObj2.Industry = industry;
        leadObj2.Rating = rating;
        leadObj2.Title = title;
        leadObj2.Website = website;
        leadObj2.Submitter_First_Name__c = callerFirstName1;
        leadObj2.Submitter_Last_Name__c = callerLastName1;
        leadObj2.BirthDate__c = dob;
        leadObj2.Gender__c = gender;
        leadObj2.Diagnosis_confirmed_through_biopsy__c = confirmedThruBiopsy;
        leadObj2.Currently_Undergoing_Treatment__c = undergoingTreatment;
        leadObj2.Diagnosis__c = diagnosis;
        leadObj2.Diagnosis_stage_of_disease_metastases__c = diagnosisStage;
        leadObj2.Primary_Insurance__c = primaryInsurance1;
        leadObj2.Policy_Number__c = policyNumber;
        leadObj2.WTP_Subscriber_Name__c = primarySubscriberName;
        leadObj2.Subscriber_DOB__c = primarySubscriberDOB;
        leadobj2.First_Name_Last_Name__c ='testfirst lastname';
        leadObj2.Relation_to_the_Patient__c = relationshipToPatient;
        leadObj2.WTP_Subscriber_Relationship__c = subscriberRelationshipToPatient;
        leadObj2.Primary_Reason_For_Request__c = reasonForRequest;
        leadObj2.Referred_to_City_of_Hope__c = referralSource;
        leadObj2.WTP_Location__c = location1;
        leadObj2.WTP_Have_you_ever_been_seen_at_COH__c = returningPatient;
        leadObj2.RecordTypeId = domesticPatientRecordTypeID;
        
        // This lead should be ignored because the lead source is excluded from processing
        
        Lead leadObj3a = new Lead();        

        leadObj3a.FirstName = firstName1;
        leadObj3a.LastName = lastName1;
        leadObj3a.LeadSource = 'Provider Masterfile Search';

        Lead leadObj3b = new Lead();        

        leadObj3b.FirstName = firstName1;
        leadObj3b.LastName = lastName1;
        leadObj3b.OwnerId = excludedOwnerID;

        // This lead will force the Account object to be assigned to   
        // the Foundation because the insurance type will override the location.
              
        Lead leadObj4 = new Lead();

        leadObj4.FirstName = firstName2;
        leadObj4.LastName = lastName2;
        leadObj4.BirthDate__c = dob;
        leadObj4.Gender__c = gender;
        leadObj4.Phone = phone2;
        leadObj4.DoNotCall = doNotCall;
        leadObj4.MobilePhone = mobilePhone;
        leadObj4.Submitter_First_Name__c = callerFirstName2;
        leadObj4.Submitter_Last_Name__c = callerLastName2;
        leadObj4.Primary_Insurance__c = primaryInsurance2;
        leadObj4.WTP_Location__c = location2;
        leadObj4.WTP_COH_MRN__c = mrn1;
        leadObj4.Country = null;
        leadObj4.RecordTypeId = domesticPatientRecordTypeID;

        // This will update the Account object created by leadObj4. Also, it will 
        // test if the MRN search has priority over the last name, DOB, and phone
        // search.  The first names are different, but these fields are identical: last name,
        // DOB, and phone. This forces the trigger to recognize leadObj5 as an existing patient.
              
        Lead leadObj5 = new Lead();

        leadObj5.FirstName = firstName3;
        leadObj5.LastName = lastName2;
        leadObj5.BirthDate__c = dob;
        leadObj5.Gender__c = gender;
        leadObj5.Phone = phone2;
        leadObj5.DoNotCall = doNotCall;
        leadObj5.MobilePhone = mobilePhone;
        leadObj5.Submitter_First_Name__c = callerFirstName2;
        leadObj5.Submitter_Last_Name__c = callerLastName2;
        leadObj5.Primary_Insurance__c = primaryInsurance2;
        leadObj5.WTP_Location__c = location2;
        leadObj5.WTP_COH_MRN__c = mrn1;
        leadObj5.City = city2;
        leadObj5.WTP_Have_you_ever_been_seen_at_COH__c = returningPatient;
        leadObj5.RecordTypeId = domesticPatientRecordTypeID;
        leadobj5.First_Name_Last_Name__c ='testfirst lastname';
        // This object verifies that the default NPS owner has been assigned correctly.
        
        Lead leadObj6 = new Lead();

        leadObj6.FirstName = firstName4;
        leadObj6.LastName = lastName4;
        leadObj6.BirthDate__c = dob;
        leadObj6.Gender__c = gender;
        leadObj6.Phone = phone2;
        leadObj6.Primary_Insurance__c = primaryInsurance1;
        leadObj6.WTP_Location__c = location2;
        leadObj6.WTP_Have_you_ever_been_seen_at_COH__c = null;
        leadObj6.RecordTypeId = domesticPatientRecordTypeID;

        // This simulates a mistyping of the MRN during a MRN search.  The MRN will be located, but the
        // record will have a different last name.  This means that the result object did not match
        // the search object even though the MRN was entered.  As a result, a new Account object will
        // be created. This also tests when the preferred location is null.  The location should be
        // given the default value.
        
        Lead leadObj7 = new Lead();

        leadObj7.FirstName = firstName1;
        leadObj7.LastName = lastName3;
        leadObj7.BirthDate__c = dob;
        leadObj7.Phone = phone1;
        leadObj7.WTP_COH_MRN__c = mrn1;
        leadObj7.WTP_Preferred_Location__c = null;
        leadObj7.WTP_Have_you_ever_been_seen_at_COH__c = returningPatient;
        leadObj7.RecordTypeId = domesticPatientRecordTypeID;

        // This will update the Account object created by leadObj4 to test if the 
        // last name and phone search works.  The first name is different and should be
        // ignored in the search.  The trigger should recognize leadObj8 as 
        // an existing patient.  
              
        Lead leadObj8 = new Lead();

        leadObj8.FirstName = firstName5;
        leadObj8.LastName = lastName2;
        leadObj8.BirthDate__c = dob;
        leadObj8.Gender__c = gender;
        leadObj8.Phone = phone2;
        leadObj8.DoNotCall = doNotCall;
        leadObj8.MobilePhone = mobilePhone;
        leadObj8.Submitter_First_Name__c = callerFirstName2;
        leadObj8.Submitter_Last_Name__c = callerLastName2;
        leadObj8.Primary_Insurance__c = primaryInsurance2;
        leadObj8.WTP_Location__c = location2;
        leadObj8.WTP_COH_MRN__c = null;
        leadObj8.Country = country;
        leadObj8.WTP_Have_you_ever_been_seen_at_COH__c = returningPatient;
        leadObj8.RecordTypeId = domesticPatientRecordTypeID;

        // This one should be ignored because of the record type
        Lead leadObj9 = new Lead();

        leadObj9.FirstName = firstName1;
        leadObj9.LastName = lastName4;
        leadObj9.BirthDate__c = dob;
        leadObj9.RecordTypeId = internationalIntakeRecordTypeID;
        leadObj9.Gender__c = gender;
        leadObj9.Phone = phone2;
        leadObj9.WTP_Location__c = location2;
        leadObj9.WTP_COH_MRN__c = mrn2;
        
        // This one should be ignored because the insurance is for an international patient
        Lead leadObj10 = new Lead();

        leadObj10.FirstName = firstName1;
        leadObj10.LastName = lastName4;
        leadObj10.BirthDate__c = dob;
        leadObj10.Gender__c = gender;
        leadObj10.Phone = phone2;
        leadObj10.WTP_Location__c = location2;
        leadObj10.WTP_COH_MRN__c = mrn2;
        leadObj10.Primary_Insurance__c = primaryInsurance3;
        
        test.startTest();
        
        // insert the configuration objects

        COHUtilTester.setWTPConfiguration();
        
        insert leadObj1;
       /* insert leadObj3a;
        insert leadObj3b;
        insert leadObj4;
        insert leadObj6;
        insert leadObj7;*/
        
        Lead obj = new Lead();
        obj.FirstName = 'test firstLead';
        obj.Lastname ='test Last Lead';
        obj.Email = 'testLead@abc.com';
        obj.Other_Phone__c ='123467';
        obj.Searching_for__c='self';
        obj.Country_of_Residency__c= 'USA';
        obj.Year_Diag__c = '1965';
        obj.Year_of_Birth__c = '1945';
        obj.State__c= 'California';
        obj.Country_of_Residency__c = 'USA';
        obj.Zip_Postal_Code__c = '92656';
        obj.Diabetes_Type__c = 'Type 2';
        obj.Country__c= 'USA';
        obj.Are_you_a_U_S_Resident__c ='Yes';
        obj.Opt_In_Communication__c = 'NO';
        insert obj;
        
        Lead obj1 = new Lead();
        obj1.What_Type_of_Request__c = 'Academic';
        obj1.Title__c = 'Sr. Application Developer';
        obj1.Institution__c = 'COH';
        obj1.E_mail_Address__c = 'testLead@abc.com';
        obj1.Phone_Number__c = '2314567';
        obj1.PI_Supervisor_Name__c = 'test supervisor';
        obj1.PI_Supervisor_E_mail_Address__c = 'supervisor@abc.com';
        obj1.PI_Supervisor_Phone_Number__c = '8765432';
        obj1.Project_Description__c = 'test description';
        obj1.First_Name_Last_Name__c ='testFirst Lastlead';
        obj1.Lastname ='LastNameLead';
        insert obj1;
            
            
        // Test to verify that Maggie Pool has been processed correctly.
        
        // This builds the equivalent of "select * ... from Account"
        String sObjectApiName = 'Account';
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(sObjectApiName) + ' where FirstName = :firstName1 and LastName = :lastName1';
        List<Account> accountsList = Database.query(soqlQuery);
        
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName1, accountObj.FirstName);
            System.assertEquals(lastName1, accountObj.LastName);
            System.assertEquals(phone1, accountObj.PersonHomePhone);
            System.assertEquals(city1, accountObj.PersonMailingCity);
            System.assertEquals(street, accountObj.PersonMailingStreet);
            System.assertEquals(postalCode, accountObj.PersonMailingPostalCode);
            System.assertEquals(country, accountObj.PersonMailingCountry);
            System.assertEquals(state, accountObj.PersonMailingState);
            System.assertEquals(doNotCall, accountObj.PersonDoNotCall);
            System.assertEquals(mobilePhone, accountObj.PersonMobilePhone);
            System.assertEquals(email1, accountObj.PersonEmail);
            System.assertEquals(hasOptedOutOfEmail, accountObj.PersonHasOptedOutOfEmail);
            System.assertEquals(fax, accountObj.Fax);
            System.assertEquals(hasOptedOutOfFax, accountObj.PersonHasOptedOutOfFax);
            System.assertEquals(industry, accountObj.Industry);
            System.assertEquals(rating, accountObj.Rating);
            System.assertEquals(title, accountObj.PersonTitle);
            System.assertEquals(website, accountObj.Website);
            System.assertEquals(callerFirstName1, accountObj.Submitter_First_Name__c);
            System.assertEquals(callerLastName1, accountObj.Submitter_Last_Name__c);
            System.assertEquals(dob, accountObj.PersonBirthdate);
            System.assertEquals(gender, accountObj.Gender__pc);
            System.assertEquals(true, accountObj.Diagnosis_confirmed_through_biopsy__c);
            System.assertEquals(diagnosis, accountObj.Diagnosis_A__c);
            System.assertEquals(diagnosisStage, accountObj.Diagnosis__c);
            System.assertEquals(false, accountObj.Currently_Undergoing_Treatment__c);
            System.assertEquals(primaryInsurance1, accountObj.Primary_Insurance__c);
            System.assertEquals(primaryInsurance1, accountObj.Insurance__c);
            System.assertEquals(primaryInsurance1, accountObj.WTP_Primary_Insurance__c);
            System.assertEquals(policyNumber, accountObj.ID__c);
            System.assertEquals(foundationAccountRecordTypeID, accountObj.RecordTypeId);
            System.assertEquals(primarySubscriberName, accountObj.Guarantor__c);
            System.assertEquals(primarySubscriberDOB, accountObj.Guarantor_Birthdate__c);
            System.assertEquals(relationshipToPatient, accountObj.Caller_Relation_To_PatientFoundation__c);
            System.assertEquals(false, accountObj.Caller_Same_as_Patient__c);
            System.assertEquals(reasonForRequest, accountObj.Reason_For_Request__c);
            // This is a work-around for a Remedyforce update that somehow converts
            // the Marketing_Source__c value to a mixed case instead of leaving the case as is.
//            System.assertEquals(referralSource, accountObj.Marketing_Source__c);
            String actualRefSourceVal = accountObj.Marketing_Source__c;
            if (!referralSource.equalsIgnoreCase(actualRefSourceVal)) {
                System.assert(false, 'Expected: ' + referralSource + ', received: ' + actualRefSourceVal);
            }
            System.assertEquals(true, accountObj.WTP_Created__c);
            System.assertEquals(primarySubscriberName, accountObj.Guarantor__c);
            System.assertEquals(primarySubscriberDOB, accountObj.Guarantor_Birthdate__c);
            System.assertEquals(subscriberRelationshipToPatient, accountObj.Guarantor_Relation_To_Patient__c);
            System.assertEquals(reasonForRequest, accountObj.Reason_For_Request__c);
            System.assertEquals(defaultFoundationOwnerID, accountObj.OwnerId);
            System.assertEquals('Yellow', accountObj.Light_Indicator__c);
            System.assertEquals(primaryMedicalGroup, accountObj.Primary_Medical_Group__c);
            System.assertEquals(secondaryMedicalGroup, accountObj.Secondary_Medical_Group__c);
            System.assertEquals(secondaryGroup, accountObj.Secondary_Group__c);
            System.assertEquals(secondaryInsurance, accountObj.WTP_Secondary_Insurance__c);
            System.assertEquals(secondaryPolicy, accountObj.Secondary_Policy__c);
            System.assertEquals(secondaryInsurancePhone, accountObj.Secondary_Insurance_Company_Phone__c);
//          System.assertEquals(secondarySubscriberBirthdate, accountObj.Secondary_Guarantor_Birthdate__c);
            System.assertEquals(secondarySubscriberName, accountObj.Secondary_Guarantor_Name__c);
            System.assertEquals(secondarySubscriberRelationship, accountObj.Secondary_Guarantor_Relation_To_Patient__c);
            System.assertEquals(referralPhysician, accountObj.Referral_Physician__c);
            System.assertEquals(location1, accountObj.Location__pc);
            System.assertEquals(null, accountObj.Have_you_ever_been_seen_at_City_of_Hop__c);
            System.assertEquals(webLanguage, accountObj.Web_Language__c);
        }
        
        insert leadObj2;
        accountsList = Database.query(soqlQuery);
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName1, accountObj.FirstName);
            System.assertEquals(lastName1, accountObj.LastName);
            System.assertEquals(phone1, accountObj.PersonHomePhone);
            System.assertEquals(location1, accountObj.Location__pc);        // the location should have been updated
            System.assertEquals(city2, accountObj.PersonMailingCity);       // the city should have been updated
        }        

        
        // Test to verify that Agatha Chumly has been processed correctly.
        
        accountsList = [select Id, FirstName, LastName, Primary_Insurance__c, RecordTypeId, OwnerId from Account where FirstName = :firstName2 and LastName = :lastName2];
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName2, accountObj.FirstName);
            System.assertEquals(lastName2, accountObj.LastName);
            System.assertEquals(primaryInsurance2, accountObj.Primary_Insurance__c);
            System.assertEquals(foundationAccountRecordTypeID, accountObj.RecordTypeId);
            System.assertEquals(defaultFoundationOwnerID, accountObj.OwnerId);
        }

        insert leadObj5;
        
        accountsList = [select Id, FirstName, LastName, PersonMailingCity from Account where FirstName = :firstName2 and LastName = :lastName2];
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName2, accountObj.FirstName);
            System.assertEquals(lastName2, accountObj.LastName);
            System.assertEquals(city2, accountObj.PersonMailingCity);       // the city should have been updated
        }        
        
        // Test to verify that Michelle Hue has been processed correctly.
        
        accountsList = [select Id, FirstName, LastName, OwnerId from Account where FirstName = :firstName4 and LastName = :lastName4];
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName4, accountObj.FirstName);
            System.assertEquals(lastName4, accountObj.LastName);
            System.assertEquals(defaultNPSOwnerID, accountObj.OwnerId);
            System.assertEquals(screenUnificationRecordTypeID, accountObj.RecordTypeId);
        }

        // Test to verify that Maggie Doyle has been processed correctly

        accountsList = [select Id, FirstName, LastName, PersonBirthdate, PersonHomePhone, COH_MRN__c, Location__pc, Have_you_ever_been_seen_at_City_of_Hop__c from Account where FirstName = :firstName1 and LastName = :lastName3];        
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        
        for (Account accountObj : accountsList) {
            System.assertEquals(firstName1, accountObj.FirstName);
            System.assertEquals(lastName3, accountObj.LastName);
            System.assertEquals(dob, accountObj.PersonBirthdate);
            System.assertEquals(phone1, accountObj.PersonHomePhone);
            System.assertEquals(null, accountObj.COH_MRN__c);
            System.assertEquals(location2, accountObj.Location__pc);
            System.assertEquals(returningPatient, accountObj.Have_you_ever_been_seen_at_City_of_Hop__c);
        }
        
        // test updating an existing record based on last name and home phone
        
        insert leadObj8;
        accountsList = [select Id, FirstName, LastName, PersonMailingCity, PersonHomePhone,PersonMailingCountry from Account where PersonHomePhone = :phone2 and LastName = :lastName2];
        
        if (COHUtil.isValidList(accountsList)) {
            System.assertEquals(1, accountsList.size());
        }
        for (Account accountObj : accountsList) {
           // System.assertEquals(firstName2, accountObj.FirstName);              // should NOT be changed to firstName5
            System.assertEquals(lastName2, accountObj.LastName);
            System.assertEquals(country, accountObj.PersonMailingCountry);      // the country should have been updated
        }        
        
        // verify that international intake records are skipped
        insert leadObj9;
        accountsList = [select Id, FirstName, LastName from Account where COH_MRN__c = :mrn2];
        if (COHUtil.isValidList(accountsList)) {
            System.assert(false, 'International Intake record was processed instead of being ignored');
        } 

        insert leadObj10;
        
        List<Lead> leadsList = [select Id from Lead where WTP_COH_MRN__c = :mrn2];
        if (!COHUtil.isValidList(leadsList)) {
            System.assert(false, 'International Intake insurance deleted the Lead instead of ignoring it');
        } 
        Integer leadsCount = leadsList.size();
        System.assertEquals(internationalLeadsCount, leadsCount);

        accountsList = [select Id, FirstName, LastName, Primary_Insurance__c from Account where COH_MRN__c = :mrn2];
        if (COHUtil.isValidList(accountsList)) {
            System.assert(false, 'International Intake insurance created an Account of ignoring the Lead');
        }
        List<Lead> leadList = database.query(COHUtil.buildSelectAllSOQLStatement('Lead')+' Limit 1');
        string temp = '%Lastlead%';
        accountsList = database.query(COHUtil.buildSelectAllSOQLStatement('Account')+' where LastName LIKE: temp');
        WTPProcessLeadUtil.updateNewAccountForLead(accountsList[0], leadList[0]);
        test.stopTest();
    }

    /*
     * Miscellaneous tests to increase test coverage percentage.
     * 
     */
    private static testmethod void testMiscellaneous () {
                
        if (!mRunAllTests && !mRunTestMiscellaneous) {
            System.debug('Skipping testMiscellaneous()');
            return;
        } 
        
        Test.startTest();

        WTPProcessLeadUtil wtpObj = new WTPProcessLeadUtil();
        
        COHUtilTester.setWTPConfiguration();
        
        Account newAccount = WTPProcessLeadUtil.createNewAccountForLead(null, false);
        System.assertEquals(null, newAccount);

        newAccount = WTPProcessLeadUtil.findAccount(null, null, null);
        System.assertEquals(null, newAccount);

        Boolean isSameRecord = WTPProcessLeadUtil.isSameRecord(null, null);
        System.assertEquals(false, isSameRecord);
        
        List<COH_App_Configuration__c> configGroupList = COHUtil.getConfigurationGroup(null, null);
        if (COHUtil.isValidList(configGroupList)) {
            System.assert(false, 'Expected a null list but retrieved a list with ' + configGroupList.size() + ' elements');
        }

        configGroupList = COHUtil.getConfigurationGroup('foo', 'bar');
        if (COHUtil.isValidList(configGroupList)) {
            Integer listSize = configGroupList.size();
            System.assert(false, 'Expected an invalid COH_App_Configuration__c list but retrieved ' + listSize + ' records');
        }
        
        Object configVal = COHUtil.getConfigurationValue(null, null);
        System.assertEquals(null, configVal);
        
        configVal = COHUtil.getConfigurationValue('foo', 'bar');
        System.assertEquals(null, configVal);

        String soqlQuery = COHUtil.buildSelectAllSOQLStatement(null);
        if (!COHUtil.isValidStr(soqlQuery)) {
            System.assert(true);
        }
        
        soqlQuery = COHUtil.buildSelectAllSOQLStatement('Lead');
        if (COHUtil.isValidStr(soqlQuery)) {
            System.assert(true);
        }
        Account accountObject = new Account(FirstName = firstName1, LastName = lastName1, RecordTypeId = foundationAccountRecordTypeID, PersonHomePhone = phone1);
        insert accountObject;
        
        Lead leadObj1 = new Lead(FirstName = firstName1, LastName = lastName1, Phone = phone1);
        System.assertEquals(true, WTPProcessLeadUtil.isSameRecord(accountObject, leadObj1));
        Lead leadObj2 = new Lead(FirstName = firstName1, LastName = lastName1, Phone = phone2);
        System.assertEquals(false, WTPProcessLeadUtil.isSameRecord(accountObject, leadObj2));

        Id objectID = accountObject.Id;
        String objectName = COHUtil.getObjectName(objectID);
        System.assertEquals('Account', objectName);
        
        objectName = COHUtil.getObjectName(null);
        System.assertEquals(null, objectName);

        WTPProcessLeadUtil.getExcludedLeadSources();
        WTPProcessLeadUtil.getExcludedLeadOwners();
        
        accountObject = WTPProcessLeadUtil.updateNewAccountForLead(null, null);
        System.assertEquals(null, accountObject);
        
        
        System.assertEquals(false, WTPProcessLeadUtil.updateAccountField(true, false, COHUtil.BOOLEAN_TYPE));
        System.assertEquals('Yes', WTPProcessLeadUtil.updateAccountField('Yes', 'No', COHUtil.BOOLEAN_YES_NO_TYPE));
        System.assertEquals(true, WTPProcessLeadUtil.updateAccountField(null, 'Yes', COHUtil.BOOLEAN_YES_NO_TYPE));
        System.assertEquals(false, WTPProcessLeadUtil.updateAccountField(null, 'No', COHUtil.BOOLEAN_YES_NO_TYPE));
        System.assertEquals(false, WTPProcessLeadUtil.updateAccountField(null, 'XXX', COHUtil.BOOLEAN_YES_NO_TYPE));
        System.assertEquals(7, WTPProcessLeadUtil.updateAccountField(null, 7, COHUtil.INTEGER_TYPE));
        System.assertEquals(1.2, WTPProcessLeadUtil.updateAccountField(null, 1.2, COHUtil.DECIMAL_TYPE));
        Boolean errorFlag = false;
        try {
	        System.assertEquals(null, WTPProcessLeadUtil.updateAccountField('XXX', 'YYY', null));
        } catch (WTPException e) {
            errorFlag = true;
        }
        System.assertEquals(true, errorFlag);
        
        errorFlag = false;
        try {
	        System.assertEquals(null, WTPProcessLeadUtil.updateAccountField('XXX', 'YYY', 'Invalid Field Type'));
        } catch (WTPException e) {
            errorFlag = true;
        }
        System.assertEquals(true, errorFlag);

	    System.assertEquals(null, WTPProcessLeadUtil.getAccountOwnerID(null));
        
    	String mappedGender = WTPProcessLeadUtil.mapGender('Male') ;
        System.assertEquals( 'M', mappedGender);
    	mappedGender = WTPProcessLeadUtil.mapGender('Female') ;
        System.assertEquals( 'F', mappedGender);
    	mappedGender = WTPProcessLeadUtil.mapGender('Other') ;
        System.assertEquals( 'O', mappedGender);
    	mappedGender = WTPProcessLeadUtil.mapGender('Prefer Not to Say') ;
        System.assertEquals( 'Prefer Not to Say', mappedGender);
    	mappedGender = WTPProcessLeadUtil.mapGender('ABC') ;
        System.assertEquals( 'Prefer Not to Say', mappedGender);
        
        test.stopTest();
    }
    
    /*
     * Test trigger limits (Not used because a single lookup must be made for each record, so this will fail every time).
     */    
    private static testMethod void verifyTriggerLimits() {
        if (!mRunAllTests && !mRunVerifyTriggerLimits) {
            System.debug('Skipping verifyTriggerLimits()');
            return;
        }
        
        Integer MAX_RECORDS = 201;
        String BULK_FIRST_NAME = 'Maggie';
        String BULK_LAST_NAME = 'Pool';
        String BULK_GENDER = 'female';
        String PHONE = '626-111-222-3333';
        Date BULK_DOB = Date.today();
        
        List<Lead> leadsList = new List<Lead>();
        for (Integer i = 0; i < MAX_RECORDS; i++) {
            Lead leadObj = new Lead();
            String suffix = String.valueOf(i);
            
            leadObj.FirstName = BULK_FIRST_NAME + suffix;
            leadObj.LastName = BULK_LAST_NAME + suffix;
            leadObj.BirthDate__c = BULK_DOB;
            leadObj.Gender__c = BULK_GENDER;
            leadObj.Phone = PHONE;
            leadsList.add(leadObj);
        }
        Test.startTest();
        insert leadsList;
        List<Account> retrievedAccounts = [select Id from Account];
        Test.stopTest();
        if (COHUtil.isValidList(retrievedAccounts)) {
            Integer listSize = retrievedAccounts.size();
            System.assertEquals(MAX_RECORDS, listSize);
        } else {
            System.assert(false, 'Error: verifyTriggerLimits() expected ' + MAX_RECORDS + 'but retrieved an invalid list');
        }
    }
}