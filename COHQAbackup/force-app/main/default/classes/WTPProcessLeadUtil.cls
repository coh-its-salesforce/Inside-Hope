/*
 * This class contains utility methods for the Web To Patient project.
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
public class WTPProcessLeadUtil {

    private static final String ACCOUNT_OBJ = 'Account';
    private static final String LEAD_OBJ = 'Lead';
    private static final String WTP_APPLICATION_NAME = 'Web To Patient';
    private static final String DEFAULT_FOUNDATION_ACCOUNT_OWNER_PROPERTY = 'Default Foundation Account Owner';
    private static final String DEFAULT_NPS_ACCOUNT_OWNER_PROPERTY = 'Default NPS Account Owner';
    private static final String DEFAULT_LOCATION = 'Default Medical Location';
    private static final String DEFAULT_UPDATE_INTERVAL = 'Default Update Interval';    
    private static final String SELECT_STRING = 'Select';           // if user doesn't choose a value from drop down menu
    private static final String SELF_STRING = 'Self';               // used for relationship
    private static final String INTERNATIONAL_INSURANCE = 'International Insurance';

    private static final String SCREEN_UNIFICATION_RECORD_TYPE = 'Patient (Screen Unification)';
    private static final String FOUNDATION_RECORD_TYPE = 'Foundation';
    
    private static final String EXCLUDED_LEADS = 'Excluded Leads';
    private static final String EXCLUDED_OWNERS = 'Excluded Owners';
    private static final String EXCLUDED_RECORD_TYPES = 'Excluded Lead Record Types';
    
    private static final String FOUNDATION_EXCLUSIVE_PLANS = 'Foundation Exclusive';
    private static final String NPS_LOCATIONS = 'NPS Locations';

    private static final String NOTES_ADDEDUM = '\nExisting patient updated via the Web';
    private static final String NEW_CONTACT_NOTES = 'Patient created via the Web';
    private static final String FOUNDATION_DEFAULT_STATUS = 'New'; 
    
    private static final String OPT_OUT_COMM_RECORD_TYPE = 'OPT OUT COMMUNICATION'; 

    private static Id mScreenUnificationAccountRecordTypeID = null;
    private static Id mFoundationAccountRecordTypeID = null;
    
    private static List<String> mFoundationOnlyPlans = null;
    private static List<String> mNPSLocations = null;
    private static List<String> mExcludedLeadSources = null; 
    private static List<String> mExcludedLeadOwners = null; 
    private static List<String> mExcludedLeadRecordTypes = null; 
    
    private static Id mDefaultNPSOwnerID = null;
    private static Id mDefaultFoundationOwnerID = null;
    private static String mDefaultLocation = null;
    private static String mInternationalInsurance = null;
    private static String mSoqlSelectAccountQuery = null;
   
    /* 
     * Initialize some variables.
     * 
     */
    static {
        initialize();
    }

    /* 
     * Initialize some variables.
     * 
     */
    private static void initialize() {
        
        List<COH_App_Configuration__c> configObjectList = [select Name, Configuration_Group__c, Value__c, Value_Type__c from COH_App_Configuration__c where Application_Name__c = :WTP_APPLICATION_NAME and Active__c = true];
        mExcludedLeadSources = new List<String>(); 
        mExcludedLeadOwners = new List<String>(); 
        mFoundationOnlyPlans = new List<String>();
        mExcludedLeadRecordTypes = new List<String>();
        
        mNPSLocations = new List<String>();
        
        // Iterate through the configuration objects and set the appropriate values.

        if (COHUtil.isValidList(configObjectList)) {
            for (COH_App_Configuration__c configObj: configObjectList) {
                String propertyName = configObj.Name;
                String val = (String) configObj.Value__c;
                String configGroup = (String) configObj.Configuration_Group__c;
    
                if (propertyName == null) {
                    continue;
                }
                // process values that don't belong to a configuration group
                if (!COHUtil.isValidStr(configGroup)) {
                    if (propertyName.equalsIgnoreCase(DEFAULT_NPS_ACCOUNT_OWNER_PROPERTY)) {
                        
                        // Set the default owner for NPS records
                        
                        List<User> userList = [select Id, alias from User where alias = :val limit 1];
                        if (COHUtil.isValidList(userList)) {
                            User userObj = userList[0];
                            mDefaultNPSOwnerID = userObj.Id;
                        }
                    }  else if (propertyName.equalsIgnoreCase(DEFAULT_FOUNDATION_ACCOUNT_OWNER_PROPERTY)) {
                        
                        // Set the default owner for Foundation records
                        
                        List<User> userList = [select Id, alias from User where alias = :val limit 1];
                        if (COHUtil.isValidList(userList)) {
                            User userObj = userList[0];
                            mDefaultFoundationOwnerID = userObj.Id;
                        }
                    }  else if (propertyName.equalsIgnoreCase(DEFAULT_LOCATION)) {
                        
                        // Set the default location if none could be retrieved from the Lead object.
                        
                        mDefaultLocation = val;
                    }
                    
                } else {        // process configuration groups
                    if (configGroup.equalsIgnoreCase(EXCLUDED_LEADS)) {
                        
                        //  Build a list of Lead sources that should be ignored by the trigger
                        if (COHUtil.isValidStr(val)) {
                            mExcludedLeadSources.add(val);
                        }
                    } else if (configGroup.equalsIgnoreCase(EXCLUDED_OWNERS)) {
                        
                        // Build a list of Lead owners that should be ignored by the trigger.
                        // Skip those that cannot be found.
                        List<User> ownerIDList = [select Id, alias from User where alias = :val limit 1];
                        if (COHUtil.isValidList(ownerIDList)) {
                            Id ownerID = ownerIDList[0].Id;
                            mExcludedLeadOwners.add(ownerID);
                        }
                    } else if (configGroup.equalsIgnoreCase(FOUNDATION_EXCLUSIVE_PLANS)) {
                        // Build a list of health plans supported only by the Foundation
                        mFoundationOnlyPlans.add(val);
                    } else if (configGroup.equalsIgnoreCase(NPS_LOCATIONS)) {
                        // Build a list of NPS locations
                        mNPSLocations.add(val);
                    } else if (configGroup.equalsIgnoreCase(EXCLUDED_RECORD_TYPES)) {
                        String recordTypeID = (String) COHUtil.getRecordType(LEAD_OBJ, val);
                        mExcludedLeadRecordTypes.add(recordTypeID);
                    }
                }
            }
        }

        // Set the Intenational Insurance string        
        mInternationalInsurance = (String) COHUtil.getConfigurationValue(WTP_APPLICATION_NAME, INTERNATIONAL_INSURANCE);
    
        // Set the NPS and Foundation Account Record Type ID
        mScreenUnificationAccountRecordTypeID = COHUtil.getRecordType(ACCOUNT_OBJ, SCREEN_UNIFICATION_RECORD_TYPE);
        mFoundationAccountRecordTypeID = COHUtil.getRecordType(ACCOUNT_OBJ, FOUNDATION_RECORD_TYPE);

        // Build the prefix for a SOQL query for the account object ("select * from Account")
        mSoqlSelectAccountQuery = COHUtil.buildSelectAllSOQLStatement('Account');
    }
    
    /*
     * Default constructor
     * 
     */
    public WTPProcessLeadUtil() {
    }
    
    /*
     * This is the main entry point for the Web To Patient project.  This method processes a list of leads. 
     * A Lead is converted into an Account object with a record type of either 'New Patient Services'
     * or 'Foundation' for the Web To Patient project.  If the Account object already exists, it is updated.
     * 
     * This can handle at most 100 records at a time because a SOQL query (e.g. findAccount()) must be made 
     * for each Lead.
     * 
     * @param   leadObjectsList     List of leads to process.
     * @param   deleteLeads         True if the leads are to be deleted, false otherwise.
     * 
     */
    public static void processLeads(List<Lead> leadObjectsList, Boolean deleteLeads) {
        
        List<Account> accountObjsToUpsert = new List<Account>();
        List<Id> leadObjsToDelete = new List<Id>();
        
        Boolean excludedLeadFlag = false;
    
        // Ignore leads from excluded sources or owners
        for(Lead leadObj : leadObjectsList) {
            String curLeadSource = leadObj.LeadSource;
            if (curLeadSource != null) {
                for (String excludedLeadSource: mExcludedLeadSources) {
                    if (curLeadSource.containsIgnoreCase(excludedLeadSource)) {
                        excludedLeadFlag = true;
                        break;
                    }
                }
            }
            
            // Check if the Lead is to be excluded from processing
            if (excludedLeadFlag == true) {
                excludedLeadFlag = false;
                continue;
            }
    
            String curLeadOwner = leadObj.OwnerId;
            if (curLeadOwner != null) {
                for (String excludedLeadOwner: mExcludedLeadOwners) {
                    if (curLeadOwner.containsIgnoreCase(excludedLeadOwner)) {
                        excludedLeadFlag = true;
                        break;
                    }
                }
            }
            
            // Check if the Lead is to be excluded from processing
            if (excludedLeadFlag == true) {
                excludedLeadFlag = false;
                continue;
            }
            
            // Ignore excluded lead record types, such as from International Intake,
            // when manually entered into the system.
            String recordTypeId = leadObj.RecordTypeId;
            if (recordTypeId != null) {
                for (String excludedRecordType: mExcludedLeadRecordTypes) {
                    if (recordTypeId.equalsIgnoreCase(excludedRecordType)) {
                        excludedLeadFlag = true;
                        break;
                    }
                }
            }
            
            // Ignore International Intake patients from the Web To Patient Lead
            String insuranceType = leadObj.Primary_Insurance__c;
            if (COHUtil.isValidStr(mInternationalInsurance)){
                if (mInternationalInsurance.equalsIgnoreCase(insuranceType)) {
                    excludedLeadFlag = true;
                    break;
                }
            }
            
            // Check if the Lead is to be excluded from processing
            if (excludedLeadFlag == true) {
                excludedLeadFlag = false;
                continue;
            }
            
            //  Check if the Account already exists.  If it doesn't, create a new
            //  Account.  Otherwise, update the existing account.
            
            String mrn = leadObj.WTP_COH_MRN__c;
            Date dob = leadobj.BirthDate__c;
            String phone = leadObj.Phone;
            String lastName = leadObj.LastName;

            Account accountObj = findAccount(mrn, lastName, phone);
    
            // Create a new Account object if it does not already exist.
    
            if (accountObj == null) {
                accountObj = createNewAccountForLead(leadObj, false);
                if (accountObj != null) {
                    accountObjsToUpsert.add(accountObj);
                }
            } else {        // The patient already exists.
                Boolean isSameRecord = isSameRecord(accountObj, leadObj);
                if (isSameRecord) {
                    Account updatedAccountObj = updateNewAccountForLead(accountObj, leadObj);
                    if (updatedAccountObj != null) {
                        accountObjsToUpsert.add(updatedAccountObj);
                    }
                } else {
                    // Create a new Account if the existing Account object does not match the Lead object.
                    // The MRN should be cleared because it is possibly an incorrect MRN.
    
                    Account newAccountObj = createNewAccountForLead(leadObj, true);
    
                    if (newAccountObj != null) {
                      accountObjsToUpsert.add(accountObj);
                    }
                }
            }
            if (deleteLeads) {
                leadObjsToDelete.add(leadObj.Id);    
            }
        }
        
        // Execute the bulk SOQL operations
        if (COHUtil.isValidList(accountObjsToUpsert)) {
            upsert accountObjsToUpsert;
        }
        if (COHUtil.isValidList(leadObjsToDelete) && deleteLeads) {
            delete [select id from Lead where id in :leadObjsToDelete];
        }        
    }

    /*
     * Retrieves a list of Lead sources for which the Lead should not be processed.
     * 
     * @return    Returns the list of Lead sources for which Lead objects should not to be processed.
     * 
     */
    public static List<String> getExcludedLeadSources() {
        return mExcludedLeadSources;
    }
    

    /*
     * Retrieves a list of owner IDs for which the Lead should not be processed.
     * 
     * @return    Returns the list of owner IDs for which Lead objects should not to be processed.
     * 
     */
    public static List<String> getExcludedLeadOwners() {
        return mExcludedLeadOwners;
    }
    
    /*
     * Locate the Account object matching the given search criteria.  In this situation, if the 
     * MRN is supplied, other search criteria are ignored.  Otherwise, the search must be done with 
     * the last name and phone.
     * 
     * @param   mrn         MRN search criterion.
     * @param   lastName    Last name search criterion.
     * @param   phone       Phone search criterion.
     * @return              This returns the first Account object with the matching criteria.  If no such
     *                      object is found, it returns null.
     * 
     */    
    public static Account findAccount(String mrn, String lastName, String phone) {
        
        Account accountObj = null;
        List<Account> accountList = null;
        
        String soqlQuery = mSoqlSelectAccountQuery;
        
        if (COHUtil.isValidStr(mrn)) {
            soqlQuery += ' where COH_MRN__c = :mrn limit 1';
        } else if (COHUtil.isValidStr(lastName) && phone != null) {
            soqlQuery += ' where LastName = :lastName and PersonHomePhone = :phone limit 1';
        } else {
            return null;
        }
        
        accountList = Database.query(soqlQuery);
        if (COHUtil.isValidList(accountList)) {
            accountObj = accountList.get(0);
        } 
        return accountObj;
    }

    /*
     * Create a new Account object from the Lead.  If the Lead object has a MRN
     * but does not otherwise match the Account object with the same MRN (i.e. 
     * they may differ in the last name, DOB, or phone), the MRN is assumed to
     * be a mistake, and it is not copied over to the newly-created Account object.
     * 
     * @param   leadObj     Lead object with the data for the new Account.
     * @param  ignoreMRN    If set to true, the MRN field is not copied from the 
     *                      leadObj parameter.
     * @return              This returns the newly-created Account object.
     * 
     */
    public static Account createNewAccountForLead(Lead leadObj, Boolean clearMRN) {
        if (leadObj == null) {
            return null;
        }
        
        // Add or modify fields as required.
        Account accountObj = (Account) Account.sObjectType.newSObject();
        
        accountObj.RecordTypeId = getAccountIDType(leadObj.WTP_Location__c, leadObj.Primary_Insurance__c);
        if (accountObj.RecordTypeId == mFoundationAccountRecordTypeID) {
            accountObj.Light_Indicator__c = 'Yellow';    // only for Foundation
        }
        
        accountObj.PersonMailingCity = leadObj.City;
        accountObj.PersonMailingStreet = leadObj.Street;
        accountObj.PersonMailingPostalCode = leadObj.PostalCode;
        accountObj.PersonMailingCountry = leadObj.Country;
        accountObj.PersonMailingState = leadObj.State;
        accountObj.PersonHomePhone = leadObj.Phone;
        accountObj.Preferred_Phone__c = leadObj.Phone;
        accountObj.PersonDoNotCall = leadObj.DoNotCall;
        accountObj.PersonMobilePhone = leadObj.MobilePhone;
        accountObj.PersonEmail = leadObj.Email;
        accountObj.PersonHasOptedOutOfEmail = leadObj.HasOptedOutOfEmail;
        accountObj.Fax = leadObj.Fax;
        accountObj.PersonHasOptedOutOfFax = leadObj.HasOptedOutOfFax;
        accountObj.Industry = leadObj.Industry;
        accountObj.Rating = leadObj.Rating;
        accountObj.PersonTitle = leadObj.Title;
        accountObj.Website = leadObj.Website;
        
        // Custom fields
        accountObj.PersonBirthdate = leadObj.BirthDate__c;
        accountObj.Gender__pc = mapGender(leadObj.Gender__c);
        String confirmedThruBiopsyStr = leadObj.Diagnosis_confirmed_through_biopsy__c;
        accountObj.Diagnosis_confirmed_through_biopsy__c = 
            (confirmedThruBiopsyStr != null && confirmedThruBiopsyStr.equalsIgnoreCase('Yes'));
        accountObj.Diagnosis_A__c = leadObj.Diagnosis__c;
        accountObj.Diagnosis__c = leadObj.Diagnosis_stage_of_disease_metastases__c;
        String undergoingTreatmentStr = leadObj.Currently_Undergoing_Treatment__c;
        accountObj.Currently_Undergoing_Treatment__c = 
            (undergoingTreatmentStr != null && undergoingTreatmentStr.equalsIgnoreCase('Yes'));
        accountObj.Primary_Insurance__c = leadObj.Primary_Insurance__c;
        accountObj.Insurance__c = leadObj.Primary_Insurance__c;
        accountObj.ID__c = leadObj.Policy_Number__c;
        accountObj.UTM_Campaign__c = leadObj.UTM_Campaign__c;
        accountObj.UTM_Content__c = leadObj.UTM__c;
        accountObj.UTM_Location__c = leadObj.UTM_Location__c;
        accountObj.UTM_Medium__c = leadObj.UTM_Medium__c;
        accountObj.UTM_Source__c = leadObj.UTM_Source__c;
        accountObj.UTM_Term__c = leadObj.UTM_Term__c;
        if (COHUtil.isValidStr(leadObj.Relation_to_the_Patient__c)) {
            accountObj.Caller_Relation_To_PatientFoundation__c = leadObj.Relation_to_the_Patient__c;
        } else {
            accountObj.Caller_Relation_To_PatientFoundation__c = SELF_STRING;
        }
        // accountObj.FirstName = leadObj.FirstName;
        //accountObj.LastName = leadObj.LastName;
        
        accountObj.Submitter_First_Name__c = leadObj.Submitter_First_Name__c;
        accountObj.Submitter_Last_Name__c = leadObj.Submitter_Last_Name__c;
        accountObj.Have_you_ever_been_seen_at_City_of_Hop__c = leadObj.WTP_Have_you_ever_been_seen_at_COH__c;
        accountObj.Reason_For_Request__c = leadObj.Primary_Reason_For_Request__c;
        accountObj.Marketing_Source__c = leadObj.Referred_to_City_of_Hope__c;
        accountObj.Insurance_Name__c = leadObj.Primary_Insurance__c;
        accountObj.ID__c = leadObj.Policy_Number__c;
        accountObj.Insurance_Auth__c = leadObj.WTP_HMO_Auth__c;
        if(String.isBlank(Leadobj.First_Name_Last_Name__c))
            // accountobj.Name = leadobj.Firstname+ ' '+leadobj.lastname;
            accountobj.Submitter_Email__c = leadobj.Email;
        accountobj.Submitter_Phone__c = leadobj.Other_Phone__c;
        accountobj.Searching_for__c = leadobj.Searching_for__c;
        accountobj.Country_of_Residency__c = leadobj.Country_of_Residency__c;
        accountobj.Year_Diagnosed_with_Diabetes__c = leadobj.Year_Diag__c;
        accountobj.Year_of_Birth__c = leadobj.Year_of_Birth__c;
        accountobj.State_Province__c = leadobj.State__c;
        accountobj.Country_of_Residency__c = leadobj.Country_of_Residency__c;
        accountobj.Zip_Postal_Code__c = leadobj.Zip_Postal_Code__c;
        accountobj.Diabetes_Type__c = leadobj.Diabetes_Type__c;
        accountobj.Opt_In_Communication__c = leadobj.Opt_In_Communication__c;
        accountobj.Islet_Cell__c = leadobj.Islet_Cell__c;
        accountobj.Are_you_a_U_S_Resident__c= leadobj.Are_you_a_U_S_Resident__c;
        accountobj.Country__c= leadobj.Country__c;
        
        accountobj.What__c = leadobj.What_Type_of_Request__c;
        accountobj.Title__c = leadobj.Title__c;
        accountobj.Institution__c = leadobj.Institution__c;
        accountobj.E_mail_Address__c = leadobj.E_mail_Address__c;
        accountobj.Phone__c = leadobj.Phone_Number__c;
        accountobj.PI_Supervisor_Name__c = leadobj.PI_Supervisor_Name__c;
        accountobj.PI_Supervisor_E_mail_Address__c = leadobj.PI_Supervisor_E_mail_Address__c;
        accountobj.PI_Supervisor_Phone_Number__c = leadobj.PI_Supervisor_Phone_Number__c;
        accountobj.Project_Description__c = leadobj.Project_Description__c;
        accountobj.Sent__c = leadobj.Sent__c;
        accountobj.File_Downloaded__c = leadobj.File_Downloaded__c;
        
        accountObj.PPO_HMO_HCP_PH_Auth__c = leadObj.WTP_HMO_Auth__c;
        accountObj.Primary_Medical_Group__c = leadObj.WTP_Primary_Medical_Group__c;
        accountObj.Secondary_Medical_Group__c = leadObj.WTP_Secondary_Medical_Group__c;
        accountObj.Primary_Group__c = leadObj.WTP_Group__c;
        accountObj.WTP_Primary_Insurance__c = leadObj.Primary_Insurance__c;
        accountObj.Primary_Insurance_Co_Phone__c = leadObj.WTP_Primary_Insurance_Co_Phone_Number__c;
        accountObj.Guarantor__c = leadObj.WTP_Subscriber_Name__c;
        accountObj.Guarantor_Birthdate__c = leadObj.Subscriber_DOB__c;
        accountObj.Guarantor_Relation_To_Patient__c = leadObj.WTP_Subscriber_Relationship__c;
        accountObj.Secondary_Group__c = leadObj.WTP_Secondary_Group__c;
        accountObj.WTP_Secondary_Insurance__c = leadObj.WTP_Secondary_Insurance__c;
        accountObj.Secondary_Insurance__c = leadObj.WTP_Secondary_Insurance__c;
        accountObj.Secondary_Insurance_Company_Phone__c = leadObj.WTP_Secondary_Insurance_Company_Phone__c;
        accountObj.Secondary_Policy__c = leadObj.WTP_Secondary_Policy_Number__c;
        accountObj.Secondary_Guarantor_Birthdate__c = leadObj.WTP_Secondary_Subscriber_DOB__c;
        accountObj.Secondary_Guarantor_Name__c = leadObj.WTP_Secondary_Subscriber_Name__c;
        accountObj.Secondary_Guarantor_Relation_To_Patient__c = leadObj.WTP_Secondary_Subscriber_Relationship__c;
        accountObj.Secondary_Insurance_Auth__c = leadObj.WTP_HMO_SEC_Auth__c;
        accountObj.Referral_Physician__c = leadObj.WTP_Referring_Physician__c;
        accountObj.Physician_Type_Requested__c = leadObj.WTP_Physician_Type_Requested__c;
        accountObj.PH__c = leadObj.WTP_Referring_Physician_Phone__c;
        accountObj.Patient_Status__c = FOUNDATION_DEFAULT_STATUS;
        accountObj.WTP_Created__c = true;
        accountObj.Web_Language__c = leadObj.Web_Language__c;
        
        if (!clearMRN) {
            accountObj.COH_MRN__c = leadObj.WTP_COH_MRN__c;
        }
        Id accountOwnerID = getAccountOwnerID(accountObj.RecordTypeId);
        if (accountOwnerID != null) {
            accountObj.OwnerId = accountOwnerID;
        }
        String location = leadObj.WTP_Location__c;
        if (COHUtil.isValidStr(location) && !location.equalsIgnoreCase(SELECT_STRING)) {
            //accountObj.Location__pc = leadObj.WTP_Location__c;
        } else {
            // accountObj.Location__pc = mDefaultLocation;
        }
        accountObj.Additional_Notes__c = NEW_CONTACT_NOTES;
        
        //Abhishek Sept 13 2017 - Changes for Opt Out Communications form
        if(leadObj.Lead_Record_type_Conversion__c == OPT_OUT_COMM_RECORD_TYPE)
        {
            // Set the OPT OUT COMM Account Record Type ID        
            List<RecordType> recordTypesList = 
                [select Id, name from RecordType where name = :OPT_OUT_COMM_RECORD_TYPE and SObjectType = 'Account'];
            for (RecordType recordObj : recordTypesList) {
                String recordName = recordObj.name;
                if (COHUtil.isValidStr(recordName)) {
                    if (recordName.equalsIgnoreCase(OPT_OUT_COMM_RECORD_TYPE)) {
                        accountObj.RecordTypeId = recordObj.Id;
                        //accountObj.Are_you_a_current_patient__c = leadObj.Are_you_a_current_patient__c;
                        accountObj.Phone = leadObj.Phone;
                        //accountObj.Reason_No_Communication__c = leadObj.Reason_No_Communication__c;
                    }
                }
            }
        }
        //End of Code - Abhishek Sept 13 2017
        if(Leadobj.Year_Diag__c != null && leadobj.Year_Diag__c != '' )
        {
            accountobj.FirstName = leadobj.Firstname; 
            accountobj.LastName = leadobj.lastname;
            accountobj.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Diabetes Clinical Trials').getRecordTypeId();
        }else if(String.isNotBlank(Leadobj.First_Name_Last_Name__c)){
            accountobj.FirstName = Leadobj.First_Name_Last_Name__c.split(' ')[0];
            accountobj.LastName = Leadobj.First_Name_Last_Name__c.split(' ')[1];
            //accountobj.Name = '';
            accountobj.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lab Request Form').getRecordTypeId();
            
        }else{
            accountObj.FirstName = leadObj.FirstName;
            accountObj.LastName = leadObj.LastName;
        }
        
        return accountObj;
    }

    /*
     * Update an existing Account object. 
     * 
     * @param   accountObj  Existing Account object to update.
     * @param   leadObj     Lead object with the updated data for the Account object.
     * @return              True if the update succeeded, false otherwise.
     * 
     */
    public static Account updateNewAccountForLead(Account accountObj, Lead leadObj) {
        if (leadObj == null || accountObj == null) {
            return null;
        }
        
        // Update the field in the accountObj if the field is either null or empty
        /* accountobj.Name = leadobj.Firstname+ ' '+leadobj.lastname;
        accountobj.Submitter_Email__c = leadobj.Email;
        accountobj.Submitter_Phone__c = leadobj.Other_Phone__c;
        accountobj.Searching_for__c = leadobj.Searching_for__c;
        accountobj.Country_of_Residency__c = leadobj.Country_of_Residency__c;
        
        accountobj.Year_Diagnosed_with_Diabetes__c = leadobj.Year_Diag__c;
        accountobj.Year_of_Birth__c = leadobj.Year_of_Birth__c;
        accountobj.State_Province__c = leadobj.State__c;
        accountobj.Country_of_Residency__c = leadobj.Country_of_Residency__c;
        accountobj.Zip_Postal_Code__c = leadobj.Zip_Postal_Code__c;
        accountobj.Diabetes_Type__c = leadobj.Diabetes_Type__c;
        accountobj.Country__c= leadobj.Country__c;
        accountobj.Are_you_a_U_S_Resident__c= leadobj.Are_you_a_U_S_Resident__c;
        
        accountobj.Opt_In_Communication__c = leadobj.Opt_In_Communication__c;
        accountobj.Islet_Cell__c = leadobj.Islet_Cell__c; 
        
        accountobj.What__c = leadobj.What_Type_of_Request__c;
        accountobj.Title__c = leadobj.Title__c;
        accountobj.Institution__c = leadobj.Institution__c;
        accountobj.E_mail_Address__c = leadobj.E_mail_Address__c;
        accountobj.Phone__c = leadobj.Phone_Number__c;
        accountobj.PI_Supervisor_Name__c = leadobj.PI_Supervisor_Name__c;
        accountobj.PI_Supervisor_E_mail_Address__c = leadobj.PI_Supervisor_E_mail_Address__c;
        accountobj.PI_Supervisor_Phone_Number__c = leadobj.PI_Supervisor_Phone_Number__c;
        accountobj.Project_Description__c = leadobj.Project_Description__c;
        accountobj.Sent__c = leadobj.Sent__c;
        accountobj.File_Downloaded__c = leadobj.File_Downloaded__c; */
        
        
        accountObj.Submitter_First_Name__c = (String) updateAccountField(accountObj.Submitter_First_Name__c, leadObj.Submitter_First_Name__c, COHUtil.STRING_TYPE);
        accountObj.Submitter_Last_Name__c = (String) updateAccountField(accountObj.Submitter_Last_Name__c, leadObj.Submitter_Last_Name__c, COHUtil.STRING_TYPE);
        
        accountObj.Have_you_ever_been_seen_at_City_of_Hop__c = (String) updateAccountField(accountObj.Have_you_ever_been_seen_at_City_of_Hop__c, leadObj.WTP_Have_you_ever_been_seen_at_COH__c, COHUtil.STRING_TYPE);
        //accountObj.FirstName = (String) updateAccountField(accountObj.FirstName, leadObj.FirstName, COHUtil.STRING_TYPE);
        //accountObj.LastName = (String) updateAccountField(accountObj.LastName, leadObj.LastName, COHUtil.STRING_TYPE);
        accountObj.PersonMailingCity = (String) updateAccountField(accountObj.PersonMailingCity, leadObj.City, COHUtil.STRING_TYPE);
        accountObj.PersonMailingStreet = (String) updateAccountField(accountObj.PersonMailingStreet, leadObj.Street, COHUtil.STRING_TYPE);
        accountObj.PersonMailingPostalCode = (String) updateAccountField(accountObj.PersonMailingPostalCode, leadObj.PostalCode, COHUtil.STRING_TYPE);
        accountObj.PersonMailingState = (String) updateAccountField(accountObj.PersonMailingState, leadObj.State, COHUtil.STRING_TYPE);
        accountObj.PersonMailingCountry = (String) updateAccountField(accountObj.PersonMailingCountry, leadObj.Country, COHUtil.STRING_TYPE);
        accountObj.PersonHomePhone = (String) updateAccountField(accountObj.PersonHomePhone, leadObj.Phone, COHUtil.STRING_TYPE);
        //accountObj.PersonEmail = (String) updateAccountField(accountObj.PersonEmail, leadObj.Email, COHUtil.STRING_TYPE);
        
        // Custom fields
        accountObj.PersonBirthdate = (Date) updateAccountField(accountObj.PersonBirthdate, leadObj.BirthDate__c, COHUtil.DATE_TYPE);
        //accountObj.Gender__pc = (String) updateAccountField(accountObj.Gender__pc, leadObj.Gender__c, COHUtil.STRING_TYPE);
        accountObj.Diagnosis_confirmed_through_biopsy__c = (Boolean) updateAccountField(accountObj.Diagnosis_confirmed_through_biopsy__c, leadObj.Diagnosis_confirmed_through_biopsy__c, COHUtil.BOOLEAN_YES_NO_TYPE);
        accountObj.Diagnosis_A__c = (String) updateAccountField(accountObj.Diagnosis_A__c, leadObj.Diagnosis__c, COHUtil.STRING_TYPE);
        accountObj.Diagnosis__c = (String) updateAccountField(accountObj.Diagnosis__c, leadObj.Diagnosis_stage_of_disease_metastases__c, COHUtil.STRING_TYPE);
        accountObj.Currently_Undergoing_Treatment__c = (Boolean) updateAccountField(accountObj.Currently_Undergoing_Treatment__c, leadObj.Currently_Undergoing_Treatment__c, COHUtil.BOOLEAN_YES_NO_TYPE);
        accountObj.Referral_Physician__c = (String) updateAccountField(accountObj.Referral_Physician__c, leadObj.WTP_Referring_Physician__c, COHUtil.STRING_TYPE);
        accountObj.Physician_Type_Requested__c = (String) updateAccountField(accountObj.Physician_Type_Requested__c, leadObj.WTP_Physician_Type_Requested__c, COHUtil.STRING_TYPE);
        accountObj.PH__c = (String) updateAccountField(accountObj.PH__c, leadObj.WTP_Referring_Physician_Phone__c, COHUtil.STRING_TYPE);
        accountObj.Insurance_Name__c = (String) updateAccountField(accountObj.Insurance_Name__c, leadObj.Primary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.ID__c = (String) updateAccountField(accountObj.ID__c, leadObj.Policy_Number__c, COHUtil.STRING_TYPE);
        accountObj.Primary_Insurance__c = (String) updateAccountField(accountObj.Primary_Insurance__c, leadObj.Primary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.Insurance__c = (String) updateAccountField(accountObj.Insurance__c, leadObj.Primary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.Primary_Group__c = (String) updateAccountField(accountObj.Primary_Group__c, leadObj.WTP_Group__c, COHUtil.STRING_TYPE);
        accountObj.PPO_HMO_HCP_PH_Auth__c = (String) updateAccountField(accountObj.PPO_HMO_HCP_PH_Auth__c, leadObj.WTP_HMO_Auth__c, COHUtil.STRING_TYPE);
        
        accountObj.Primary_Medical_Group__c = (String) updateAccountField(accountObj.Primary_Medical_Group__c, leadObj.WTP_Primary_Medical_Group__c, COHUtil.STRING_TYPE);
        accountObj.WTP_Primary_Insurance__c = (String) updateAccountField(accountObj.WTP_Primary_Insurance__c, leadObj.Primary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.Primary_Insurance_Co_Phone__c = (String) updateAccountField(accountObj.Primary_Insurance_Co_Phone__c, leadObj.WTP_Primary_Insurance_Co_Phone_Number__c, COHUtil.STRING_TYPE);
        accountObj.Guarantor__c = (String) updateAccountField(accountObj.Guarantor__c, leadObj.WTP_Subscriber_Name__c, COHUtil.STRING_TYPE);
        accountObj.Guarantor_Birthdate__c = (Date) updateAccountField(accountObj.Guarantor_Birthdate__c, leadObj.Subscriber_DOB__c, COHUtil.DATE_TYPE);
        accountObj.Guarantor_Relation_To_Patient__c = (String) updateAccountField(accountObj.Guarantor_Relation_To_Patient__c, leadObj.WTP_Subscriber_Relationship__c, COHUtil.STRING_TYPE);
        accountObj.Insurance_Auth__c =  (String) updateAccountField(accountObj.Insurance_Auth__c, leadObj.WTP_HMO_Auth__c, COHUtil.STRING_TYPE);
        
        accountObj.Secondary_Medical_Group__c = (String) updateAccountField(accountObj.Secondary_Medical_Group__c, leadObj.WTP_Secondary_Medical_Group__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Group__c = (String) updateAccountField(accountObj.Secondary_Group__c, leadObj.WTP_Secondary_Group__c, COHUtil.STRING_TYPE);
        accountObj.WTP_Secondary_Insurance__c = (String) updateAccountField(accountObj.WTP_Secondary_Insurance__c, leadObj.WTP_Secondary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Insurance__c = (String) updateAccountField(accountObj.Secondary_Insurance__c, leadObj.WTP_Secondary_Insurance__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Insurance_Company_Phone__c = (String) updateAccountField(accountObj.Secondary_Insurance_Company_Phone__c, leadObj.WTP_Secondary_Insurance_Company_Phone__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Policy__c = (String) updateAccountField(accountObj.Secondary_Policy__c, leadObj.WTP_Secondary_Policy_Number__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Guarantor_Birthdate__c = (Date) updateAccountField(accountObj.Secondary_Guarantor_Birthdate__c, leadObj.Subscriber_DOB__c, COHUtil.DATE_TYPE);
        accountObj.Secondary_Guarantor_Name__c = (String) updateAccountField(accountObj.Secondary_Guarantor_Name__c, leadObj.WTP_Secondary_Subscriber_Name__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Guarantor_Relation_To_Patient__c = (String) updateAccountField(accountObj.Secondary_Guarantor_Relation_To_Patient__c, leadObj.WTP_Secondary_Subscriber_Relationship__c, COHUtil.STRING_TYPE);
        accountObj.Secondary_Insurance_Auth__c = (String) updateAccountField(accountObj.Secondary_Insurance_Auth__c, leadObj.WTP_HMO_SEC_Auth__c, COHUtil.STRING_TYPE);
        accountObj.Web_Language__c = (String) updateAccountField(accountObj.Web_Language__c, leadObj.Web_Language__c, COHUtil.STRING_TYPE);
        
        accountObj.Reason_For_Request__c = (String) updateAccountField(accountObj.Reason_For_Request__c, leadObj.Primary_Reason_For_Request__c, COHUtil.STRING_TYPE);
        accountObj.Marketing_Source__c = (String) updateAccountField(accountObj.Marketing_Source__c, leadObj.Referred_to_City_of_Hope__c, COHUtil.STRING_TYPE);
        accountObj.WTP_Created__c = true;
        accountObj.Additional_Notes__c = accountObj.Additional_Notes__c + NOTES_ADDEDUM;
        //accountObj.Location__pc = (String) updateAccountField(accountObj.Location__pc, leadObj.WTP_Location__c, COHUtil.STRING_TYPE);
        
        return accountObj;
    }

    /*
     * Returns the value that should be used to update a field in an Account object with the value from a 
     * corresponding field in the Lead Object.  If the field in the existing Account object already has
     * a value, then it should NOT be updated.
     * 
     * @param  accountFieldVal    Value of the field in the existing Account object.
     * @param  leadFieldVal    Value of the field in the Lead object.
     * @param  fieldType      Type of the field.
     * @return             The value to put into the field of existing Account object.
     * 
     */
    @TestVisible
    private static Object updateAccountField(Object accountFieldVal, Object leadFieldVal, String fieldType) {
        if (!COHUtil.isValidStr(fieldType)) {
            throw new WTPException('Error: updateAccountField(): fieldType cannot be null');
        }
        if (fieldType.equalsIgnoreCase(COHUtil.STRING_TYPE)) {
            if (COHUtil.isValidStr((String) accountFieldVal)) { 
                return accountFieldVal;
            } else {
                return (String) leadFieldVal;  
            }
        } else if (fieldType.equalsIgnoreCase(COHUtil.BOOLEAN_TYPE)) {
            return (Boolean) leadFieldVal;
        } else if (fieldType.equalsIgnoreCase(COHUtil.BOOLEAN_YES_NO_TYPE)) {
            if (accountFieldVal != null) {
                return accountFieldVal;
            } else {
              String strVal = (String) leadFieldVal;
                if (COHUTIL.isValidStr(strVal)) {
                    if (strVal.equalsIgnoreCase('yes') || strVal.equalsIgnoreCase('y') ||
                        strVal.equalsIgnoreCase('true') || strVal.equalsIgnoreCase('t')) {
                        return true;
                    }
                } 
                return false;
            }
        } else if (fieldType.equalsIgnoreCase(COHUtil.DECIMAL_TYPE)) {
            if (accountFieldVal == null) {
                return (Decimal) leadFieldVal;
            }
        } else if (fieldType.equalsIgnoreCase(COHUtil.DATE_TYPE)) {
            if (accountFieldVal == null) {
                return (Date) leadFieldVal;
            }
        } else if (fieldType.equalsIgnoreCase(COHUtil.INTEGER_TYPE)) {
            if (accountFieldVal == null) {
                return (Integer) leadFieldVal;
            }
        } else {
            throw new WTPException('Error: updateAccountField(): unrecognized fieldType: ' + fieldType);
        }
        return null;    // should never reach this line
    }
    
  /*
   * Checks if a Lead object is the same record as an Account object.  This is necessary in case 
   * a user mistypes a MRN value that is used to search for existing patients.  The Lead 
   * is considered to be a duplicate if it has the following values identical to those in 
   * the Account object: first name, DOB, and phone.
   * 
   * @param  accountObj     Existing Account object to check.
   * @param  leadObj        Lead object to check.
   * @return                True if the record is the same, false otherwise.
   */
    public static Boolean isSameRecord(Account accountObj, Lead leadObj) {
        if (accountObj == null || leadObj == null) {
            return false;
        }
        
        String leadLastName = leadObj.LastName;
        String leadPhone = leadObj.Phone;
        
        String accountLastName = accountObj.LastName;
        String accountPhone = accountObj.PersonHomePhone;

        if (!leadLastName.equalsIgnoreCase(accountLastName) ||
                !leadPhone.equalsIgnoreCase(accountPhone)) {
        
            return false;
        }
        return true;
    }
    
    /*
     * Retrieve the ID of the default owner for the Account based on the record type of the Lead
     * object that is passed in as the parameter.
     * 
     * @param  recordTypeID     Record type for the Lead Object.
     * @return                  ID of the default owner for the Account.
     * 
     */
    @TestVisible
    private static Id getAccountOwnerID(Id recordTypeID) {
        if (recordTypeID == mScreenUnificationAccountRecordTypeID) {
            return mDefaultNPSOwnerID;
        } else if (recordTypeID == mFoundationAccountRecordTypeID) {
            return mDefaultFoundationOwnerID;
        } else {
            return null;
        }
    }

    /*
     * Retrieves the Record type for an Account object based on the location
     * selected by the user and the primary insurance.  The insurance has a 
     * higher priority than the location when it comes to determining the Record type.
     * 
     * @param  location     This is the location selected by the user.
     * @param  insurance    This is the primary insurance.
     * @return              Screen Unification record type if the location is the 'NPS Locations' configuration
     *                      group in COH App Configuration or not supplied.  Otherwise, it returns
     *                      Foundation record type.  Also, Foundation record type is also returned
     *                      if the insurance is either HEALTH_NET_HMO or HEALTH_NET_PPO.
     * 
     */
    private static Id getAccountIDType(String location, String insurance) {
        if (!COHUtil.isValidStr(location) || location.endsWithIgnoreCase(SELECT_STRING)) {
            return mScreenUnificationAccountRecordTypeID;
        }
        if (COHUtil.isValidStr(insurance)) {
            for (String planName : mFoundationOnlyPlans) {
                if (insurance.equalsIgnoreCase(planName)) {
                    return mFoundationAccountRecordTypeID;
                }
            }
        }
        for (String locationName : mNPSLocations) {
            if (location.equalsIgnoreCase(locationName)) {
                return mScreenUnificationAccountRecordTypeID;
            }
        }
        return mFoundationAccountRecordTypeID;
    }
 
    /*
     * Map the gender field to reflect the picklist values.
     * 
     * @param originalGender        Original value of the gender from the web form.
     * @return                                  Corresponding value for the picklist.
     * 
     */
    @TestVisible
    private static String mapGender(String originalGender) {
        String mappedGender =  'Prefer Not to Say';     // default value
        if (String.isNotEmpty(originalGender)) {
            if (originalGender.equalsIgnoreCase('Male')) {
                mappedGender = 'M';
            } else if (originalGender.equalsIgnoreCase('Female')) {
                mappedGender = 'F';
            } else if (originalGender.equalsIgnoreCase('Other')) {
                mappedGender = 'O';
            } 
        }
        return mappedGender;
    }
}