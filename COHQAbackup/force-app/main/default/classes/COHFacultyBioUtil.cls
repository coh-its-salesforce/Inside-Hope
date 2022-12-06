/*
 * This class contains utility methods for the Faculty Bio project.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHFacultyBioUtil {

    private static final String FOUNDATION = 'Foundation';
    private static final String TRUE_STRING = 'true';
    private static final String FALSE_STRING = 'false';

    private static final String APPROVED_STATUS = 'Approved';
    private static final String DELETE_MARKER_STRING = '<deleted>';
    private static final Date DELETE_MARKER_DATE = Date.newInstance(1800, 1, 1);
    private static final Integer DELETE_MARKER_INTEGER = -99999;
    
    private static String mGetFinalFacultyObjectsSOQLQuery;
    private static String mGetInsertedFinalFacultyObjectsSOQLQuery;
    private static Boolean mRecordModified;
	private static List<COH2_Faculty_History__c> mFacultyHistoryList = new List<COH2_Faculty_History__c>();
    
    static {
        mGetFinalFacultyObjectsSOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty_Final__c');
        mGetFinalFacultyObjectsSOQLQuery += ' where Name in :employeeIDList';
        mGetInsertedFinalFacultyObjectsSOQLQuery = COHUtil.buildSelectAllSOQLStatement('COH2_Faculty_Final__c');
        mGetInsertedFinalFacultyObjectsSOQLQuery += 'where COH2_Faculty__c in :insertedFinalFacultyObjIDList';
    }
    
    /*  
     * Default constructor
     * 
     */
    public COHFacultyBioUtil() {
    }
       
    /*
     * Process records.  Values are copied from the temporary Faculty Bio objects to the 
     * corresponding final Faculty Bio objects.  
     * 
     * ------In this class, "temporary" refers to the staging object.  --------
     * ------"Final" refers to the final, viewable object.             --------
     * 
     * @param facultyObjList		List of temporary Faculty Bio objects to process.
     * 
     */
    public static void processAccounts(List<COH2_Faculty__c> facultyObjList) {
        if (COHUtil.isValidList(facultyObjList)) {
            Map<String, COH2_Faculty_Final__c> finalFacultyObjMap = new Map<String, COH2_Faculty_Final__c>();
            List<COH2_Faculty_Final__c> finalFacultyObjToUpdateList = new List<COH2_Faculty_Final__c>();

            // This is for new final objects that do not currently exist in the database
            List<COH2_Faculty_Final__c> newFinalFacultyObjList = new List<COH2_Faculty_Final__c>();
            
			// This is a mapping of the temp Faculty object IDs to the final object IDs.
			// In the case of new final objects, the object IDs will not be known until
			// after they are inserted into the database.  This ID is needed for history 
			// objects that were created for this new object.
			Map<Id, Id> tempToFinalFacultyMap = new Map<Id, Id>();
            
			List<String> employeeIDList = new List<String>();
            for (COH2_Faculty__c tempFacultyObj : facultyObjList){
                employeeIDList.add(tempFacultyObj.Name);
            }
                
            List<COH2_Faculty_Final__c> finalFacultyObjList = Database.query(mGetFinalFacultyObjectsSOQLQuery);
            if (COHUtil.isValidList(finalFacultyObjList)) {
                // Store the final faculty objects for later use
                for (COH2_Faculty_Final__c finalFacultyObj : finalFacultyObjList) {
                    finalFacultyObjMap.put(finalFacultyObj.Name , finalFacultyObj);
                }
            }
            
            // Iterate through all temp objects and copy the values to the final object.  
            // If the final object does not currently exist, create a new one.
            for (COH2_Faculty__c tempFacultyObj : facultyObjList) {
                String status = tempFacultyObj.Status__c;
                if (COHUtil.isValidStr(status) && status.equalsIgnoreCase(APPROVED_STATUS)) {
                    COH2_Faculty_Final__c finalFacultyObj = finalFacultyObjMap.get(tempFacultyObj.Name);

                    Boolean isNew = false;
                    if (finalFacultyObj == null) {
                        finalFacultyObj = new COH2_Faculty_Final__c();
			      		finalFacultyObj.Name = tempFacultyObj.Name;
                        isNew = true;
                    }
                    
                    Boolean hasUpdates = copyValues(tempFacultyObj, finalFacultyObj);
                    if (hasUpdates) {
                        if (isNew) {
                            newFinalFacultyObjList.add(finalFacultyObj);
                        } else {
                        	finalFacultyObjToUpdateList.add(finalFacultyObj);
                            Id tempObjID = tempFacultyObj.Id;
                            Id finalObjID = finalFacultyObj.Id;
                            tempToFinalFacultyMap.put(tempObjID, finalObjID);
                        }
                    }
                }
            }
            
            if (COHUtil.isValidList(finalFacultyObjToUpdateList)) {
                Database.upsert(finalFacultyObjToUpdateList);
                finalFacultyObjToUpdateList.clear();
            }

			// Save the data to the new Final records
            if (COHUtil.isValidList(newFinalFacultyObjList)) {
                List<Id> insertedFinalFacultyObjIDList = new List<Id>();
                for (COH2_Faculty_Final__c finalObj : newFinalFacultyObjList) {
                    insertedFinalFacultyObjIDList.add(finalObj.COH2_Faculty__c);
                }
                Database.insert(newFinalFacultyObjList);
                List<COH2_Faculty_Final__c> insertedFinalFacultyObjList = new List<COH2_Faculty_Final__c>();
                insertedFinalFacultyObjList = Database.query(mGetInsertedFinalFacultyObjectsSOQLQuery);

                // Cycle through the new objects to create a map of temp objects to final objects
                for (COH2_Faculty_Final__c finalObj : insertedFinalFacultyObjList) {
                    Id tempObjID = finalObj.COH2_Faculty__c;
                    Id finalObjID = finalObj.Id;
                    tempToFinalFacultyMap.put(tempObjID, finalObjID);
                }
                newFinalFacultyObjList.clear();
            }

            if (COHUtil.isValidList(mFacultyHistoryList)) {
                for (COH2_Faculty_History__c historyObj : mFacultyHistoryList) {
                    Id tempObjID = historyObj.COH2_Faculty__c;		
					Id finalObjID = tempToFinalFacultyMap.get(tempObjID);
                    historyObj.COH2_Faculty_Approved__c = finalObjID;
                }
                Database.insert(mFacultyHistoryList);
                tempToFinalFacultyMap.clear();
                mFacultyHistoryList.clear();
            }
        }
        
        return;
    }
    
    /*
     * Copy the updated values from the temporary Faculty Bio object to the final Faculty Bio object.
     * If any of the values have been modified, mRecordModified will be set to true in the 
     * getUpdatedFieldValue() method.
     * 
     * @param	tempFacultyBioObj			Temporary Faculty Bio object.  
     * @param	finalFacultyBioFinalObj		Final Faculty Bio object.  
     * @return								True if at least one of the fields has changed values
     * 
     */
    private static Boolean copyValues(COH2_Faculty__c tempFacultyBioObj, COH2_Faculty_Final__c finalFacultyBioFinalObj) {
        if (tempFacultyBioObj == null || finalFacultyBioFinalObj == null) {
            return false;
        }

        mRecordModified = false;	// initialize
        Id lastModifiedBy = tempFacultyBioObj.LastModifiedById;
        Id finalFacultyObjID = finalFacultyBioFinalObj.Id;
        Id tempFacultyObjID = tempFacultyBioObj.Id;

        finalFacultyBioFinalObj.COH2_Faculty__c = tempFacultyObjID;
        
        finalFacultyBioFinalObj.coh2_awards__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_awards__c, 
                                          finalFacultyBioFinalObj.coh2_awards__c, 
                                          COHUtil.STRING_TYPE, 
                                          'coh2_awards__c', 
										  lastModifiedBy,
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_boardcerttext__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_boardcerttext__c, 
                                          finalFacultyBioFinalObj.coh2_boardcerttext__c, 
                                          COHUtil.STRING_TYPE, 
                                          'coh2_boardcerttext__c', 
										  lastModifiedBy,
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_careteam__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_careteam__c, 
                                          finalFacultyBioFinalObj.coh2_careteam__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_careteam__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_clinicalfocus__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_clinicalfocus__c, 
                                          finalFacultyBioFinalObj.coh2_clinicalfocus__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_clinicalfocus__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_overviewtext__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_overviewtext__c, 
                                          finalFacultyBioFinalObj.coh2_overviewtext__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_overviewtext__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_clinicalspecialties__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_clinicalspecialties__c, 
                                          finalFacultyBioFinalObj.coh2_clinicalspecialties__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_clinicalspecialties__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_clinicianorresearcher__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_clinicianorresearcher__c, 
                                          finalFacultyBioFinalObj.coh2_clinicianorresearcher__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_clinicianorresearcher__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_credentials__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_credentials__c, 
                                          finalFacultyBioFinalObj.coh2_credentials__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_credentials__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_degrees2__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_degrees2__c, 
                                          finalFacultyBioFinalObj.coh2_degrees2__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_degrees2__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_display_email__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_display_email__c, 
                                          finalFacultyBioFinalObj.coh2_display_email__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_display_email__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_education_text__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_education_text__c, 
                                          finalFacultyBioFinalObj.coh2_education_text__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_education_text__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_emailaddress__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_emailaddress__c, 
                                          finalFacultyBioFinalObj.coh2_emailaddress__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_emailaddress__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_expert_voice_text__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_expert_voice_text__c, 
                                          finalFacultyBioFinalObj.coh2_expert_voice_text__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_expert_voice_text__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_fellowships__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_fellowships__c, 
                                          finalFacultyBioFinalObj.coh2_fellowships__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_fellowships__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_firstname__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_firstname__c, 
                                          finalFacultyBioFinalObj.coh2_firstname__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_firstname__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_gender__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_gender__c, 
                                          finalFacultyBioFinalObj.coh2_gender__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_gender__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_internships__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_internships__c, 
                                          finalFacultyBioFinalObj.coh2_internships__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_internships__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_lab_members_text__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_lab_members_text__c, 
                                          finalFacultyBioFinalObj.coh2_lab_members_text__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_lab_members_text__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_laboratory_text__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_laboratory_text__c, 
                                          finalFacultyBioFinalObj.coh2_laboratory_text__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_laboratory_text__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_languagesspoken__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_languagesspoken__c, 
                                          finalFacultyBioFinalObj.coh2_languagesspoken__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_languagesspoken__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_lastname__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_lastname__c, 
                                          finalFacultyBioFinalObj.coh2_lastname__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_lastname__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_memberships__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_memberships__c, 
                                          finalFacultyBioFinalObj.coh2_memberships__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_memberships__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_middlename__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_middlename__c, 
                                          finalFacultyBioFinalObj.coh2_middlename__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_middlename__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_office_phone_no__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_office_phone_no__c, 
                                          finalFacultyBioFinalObj.coh2_office_phone_no__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_office_phone_no__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_phoneno__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_phoneno__c, 
                                          finalFacultyBioFinalObj.coh2_phoneno__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_phoneno__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_postdocfellowships__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_postdocfellowships__c, 
                                          finalFacultyBioFinalObj.coh2_postdocfellowships__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_postdocfellowships__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
            finalFacultyBioFinalObj.coh2_preferredname__c = 
                (String) getUpdatedFieldValue(tempFacultyBioObj.coh2_preferredname__c, 
                                              finalFacultyBioFinalObj.coh2_preferredname__c, 
                                              COHUtil.STRING_TYPE,
                                              'coh2_preferredname__c', 
                                              lastModifiedBy, 
                                              tempFacultyObjID,
                                              finalFacultyObjID);
		// Assign the first name as the preferred name if no preferred name has been given
		// in the final object.
        if (!COHUtil.isValidStr(finalFacultyBioFinalObj.coh2_preferredname__c)) {
            finalFacultyBioFinalObj.coh2_preferredname__c = finalFacultyBioFinalObj.coh2_firstname__c;
        }
        
		finalFacultyBioFinalObj.coh2_primarylocations__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_primarylocations__c, 
                                          finalFacultyBioFinalObj.coh2_primarylocations__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_primarylocations__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_professional_exp__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_professional_exp__c, 
                                          finalFacultyBioFinalObj.coh2_professional_exp__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_professional_exp__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_pubmed_url__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_pubmed_url__c, 
                                          finalFacultyBioFinalObj.coh2_pubmed_url__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_pubmed_url__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_publications_text__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_publications_text__c, 
                                          finalFacultyBioFinalObj.coh2_publications_text__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_publications_text__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_researchfocus__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_researchfocus__c, 
                                          finalFacultyBioFinalObj.coh2_researchfocus__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_researchfocus__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_researchteam__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_researchteam__c, 
                                          finalFacultyBioFinalObj.coh2_researchteam__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_researchteam__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh2_researchtext__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_researchtext__c, 
                                          finalFacultyBioFinalObj.coh2_researchtext__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_researchtext__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_residencies__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_residencies__c, 
                                          finalFacultyBioFinalObj.coh2_residencies__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_residencies__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh2_titles__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh2_titles__c, 
                                          finalFacultyBioFinalObj.coh2_titles__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh2_titles__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh_institution_1__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_institution_1__c, 
                                          finalFacultyBioFinalObj.coh_institution_1__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_institution_1__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh_institution_2__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_institution_2__c, 
                                          finalFacultyBioFinalObj.coh_institution_2__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_institution_2__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh_institution_3__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_institution_3__c, 
                                          finalFacultyBioFinalObj.coh_institution_3__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_institution_3__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh_institution_4__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_institution_4__c, 
                                          finalFacultyBioFinalObj.coh_institution_4__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_institution_4__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.end_date__c = 
			(Date) getUpdatedFieldValue(tempFacultyBioObj.end_date__c, 
                                        finalFacultyBioFinalObj.end_date__c, 
                                        COHUtil.DATE_TYPE,
                                        'end_date__c', 
										lastModifiedBy, 
                                        tempFacultyObjID,
										finalFacultyObjID);
        finalFacultyBioFinalObj.left_coh__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.left_coh__c, 
                                          finalFacultyBioFinalObj.left_coh__c, 
                                          COHUtil.STRING_TYPE,
                                          'left_coh__c', 
                                          lastModifiedBy, 
                                          tempFacultyObjID,
                                          finalFacultyObjID);
		finalFacultyBioFinalObj.start_date__c = 
			(Date) getUpdatedFieldValue(tempFacultyBioObj.start_date__c, 
                                        finalFacultyBioFinalObj.start_date__c, 
                                        COHUtil.DATE_TYPE,
                                        'start_date__c', 
										lastModifiedBy, 
                                        tempFacultyObjID,
										finalFacultyObjID);
		finalFacultyBioFinalObj.coh_dept_div_prog_center_1__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_dept_div_prog_center_1__c, 
                                          finalFacultyBioFinalObj.coh_dept_div_prog_center_1__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_dept_div_prog_center_1__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh_dept_div_prog_center_2__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_dept_div_prog_center_2__c, 
                                          finalFacultyBioFinalObj.coh_dept_div_prog_center_2__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_dept_div_prog_center_2__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
        finalFacultyBioFinalObj.coh_dept_div_prog_center_3__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_dept_div_prog_center_3__c, 
                                          finalFacultyBioFinalObj.coh_dept_div_prog_center_3__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_dept_div_prog_center_3__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.coh_dept_div_prog_center_4__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.coh_dept_div_prog_center_4__c, 
                                          finalFacultyBioFinalObj.coh_dept_div_prog_center_4__c, 
                                          COHUtil.STRING_TYPE,
                                          'coh_dept_div_prog_center_4__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);
		finalFacultyBioFinalObj.status__c = 
			(String) getUpdatedFieldValue(tempFacultyBioObj.status__c, 
                                          finalFacultyBioFinalObj.status__c, 
                                          COHUtil.STRING_TYPE,
                                          'status__c', 
										  lastModifiedBy, 
                                          tempFacultyObjID,
										  finalFacultyObjID);        
        return mRecordModified;
    }
    
    /*
     * Determine if a field value has been updated.  If so, return the value from the
     * the temporary Faculty object. This value will be used to overwrite the existing
     * value in the final Faculty object.  
     * 
     * @param	tempObjectValue		Value in the field of the temporary object.
     * @param	finalObjectValue	Value in the field of the final object.
     * @param	fieldType			Field type.
     * @param	lastModifiedByID	ID of the user who last modified the temporary Faculty record.
     * @param	tempObjectID		ID of the temp Faculty record.
     * @param	finalObjectID		ID of the final Faculty record.
     * @return						Value to use in the final object.
     * 
     */
    private static Object getUpdatedFieldValue(Object tempObjectValue, Object finalObjectValue, 
                                               String fieldType, String fieldName,
                                               Id lastModifiedByID, Id tempObjectID, 
                                               Id finalObjectID) {
        Object returnVal = finalObjectValue;	// default return value
        if (tempObjectValue != null) {
            if (fieldType.equalsIgnoreCase(COHUtil.STRING_TYPE)) {
                String tempConvertedValue = String.valueOf(tempObjectValue);
                String finalConvertedValue = String.valueOf(finalObjectValue);
                 if (tempConvertedValue == null || tempConvertedValue.equalsIgnoreCase(finalConvertedValue)) {
                    returnVal = finalConvertedValue;
                } else {
                    if (tempConvertedValue.equalsIgnoreCase(DELETE_MARKER_STRING)) {
                        returnVal = null;
                    } else if (!tempConvertedValue.equalsIgnoreCase(finalConvertedValue)) {
                        returnVal = tempConvertedValue;
                    } 
                    createHistoryObject(finalConvertedValue, returnVal, fieldType, fieldName, lastModifiedByID, tempObjectID, finalObjectID);
                }
            } else if (fieldType.equalsIgnoreCase(COHUtil.BOOLEAN_TYPE)) {
                Boolean tempConvertedValue = Boolean.valueOf(tempObjectValue);
                Boolean finalConvertedValue = Boolean.valueOf(finalObjectValue);
                if (tempConvertedValue == null || tempConvertedValue == finalConvertedValue) {
                    returnVal = finalConvertedValue;
                } else {
                    returnVal = tempConvertedValue;
                    createHistoryObject(finalConvertedValue, returnVal, fieldType, fieldName, lastModifiedByID, tempObjectID, finalObjectID);
                }
            } else if (fieldType.equalsIgnoreCase(COHUtil.INTEGER_TYPE)) {
                Integer tempConvertedValue = Integer.valueOf(tempObjectValue);
                Integer finalConvertedValue = Integer.valueOf(finalObjectValue);
                if (tempConvertedValue == null || tempConvertedValue == finalConvertedValue) {
                    returnVal = finalConvertedValue;
                } else {
                    if (tempConvertedValue == DELETE_MARKER_INTEGER) {
                        returnVal = null;				
                    } else if (tempConvertedValue != finalConvertedValue) {
                        returnVal = tempConvertedValue;
                    } 
                    createHistoryObject(finalConvertedValue, returnVal, fieldType, fieldName, lastModifiedByID, tempObjectID, finalObjectID);
                }
            } else if (fieldType.equalsIgnoreCase(COHUtil.DATE_TYPE)) {
                Date tempConvertedValue = Date.valueOf(tempObjectValue);
                Date finalConvertedValue = Date.valueOf(finalObjectValue);
                if (finalConvertedValue == null) {		// Check for this to avoid problems with the next else-if condition
                                                        // The isSameDay() method requires a non-null argument.
                    returnVal = tempConvertedValue;
                } else if (tempConvertedValue == null || tempConvertedValue.isSameDay(finalConvertedValue)) {
                    returnVal = finalConvertedValue;
                } else {
                    if (tempConvertedValue.isSameDay(DELETE_MARKER_DATE)) {
                        returnVal = null;				
                    } else if (!tempConvertedValue.isSameDay(finalConvertedValue)) {
                        returnVal = tempConvertedValue;
                    } 
                    createHistoryObject(finalConvertedValue, returnVal, fieldType, fieldName, lastModifiedByID, tempObjectID, finalObjectID);
                }
            } 
        }
        return returnVal;	
    }
    

    /*
     * Create a history object and add it to mFacultyHistoryList.  Set the value of 
     * the mRecordModified class member to true.  (It's not very elegant, but it 
     * sure saves on code complexity).  Finally, create a COH2_Faculty_History__c 
     * object to record the changes.
     * 
     * @param	oldValue			The original value of the field in the final object.
     * @param	newValue			The updated value of the field in the final object.
     * @param	fieldType			Field type.
     * @param	fieldName			Field name.
     * @param	lastModifiedByID	ID of the user who last modified the temporary Faculty record.
     * @param	tempObjectID		ID of the temp Faculty record.
     * @param	finalObjectID		ID of the final Faculty record.
     * 
     */
    private static void createHistoryObject(Object oldValue, Object newValue, String fieldType, 
                                            String fieldName, Id lastModifiedByID, 
                                            Id tempObjectID, Id finalObjectID) {
        if (fieldType != null) {
            mRecordModified = true;
                                                    
            COH2_Faculty_History__c facultyHistoryObj = new COH2_Faculty_History__c();
            facultyHistoryObj.COH2_Changes_By__c = lastModifiedByID;
            facultyHistoryObj.COH2_Faculty__c = tempObjectID;
            facultyHistoryObj.COH2_Faculty_Approved__c = finalObjectID;
            facultyHistoryObj.COH2_Field__c = fieldName;
            
            if (fieldType.equalsIgnoreCase(COHUtil.STRING_TYPE)) {
                facultyHistoryObj.COH2_Old_Value__c = (String) oldValue;
                facultyHistoryObj.COH2_New_Value__c = (String) newValue;
            } else if (fieldType.equalsIgnoreCase(COHUtil.BOOLEAN_TYPE)) {
                Boolean oldConvertedValue = Boolean.valueOf(oldValue);
                Boolean newConvertedValue = Boolean.valueOf(newValue);
                if (oldConvertedValue) {
                    facultyHistoryObj.COH2_Old_Value__c = TRUE_STRING;
                } else {
                    facultyHistoryObj.COH2_Old_Value__c = FALSE_STRING;
                }
                if (newConvertedValue) {
                    facultyHistoryObj.COH2_Old_Value__c = TRUE_STRING;
                } else {
                    facultyHistoryObj.COH2_Old_Value__c = FALSE_STRING;
                }
            } else if (fieldType.equalsIgnoreCase(COHUtil.INTEGER_TYPE)) {
                facultyHistoryObj.COH2_Old_Value__c = String.valueOf(oldValue);
                facultyHistoryObj.COH2_New_Value__c = String.valueOf(newValue);
            } else if (fieldType.equalsIgnoreCase(COHUtil.DATE_TYPE)) {
                Date oldConvertedValue = Date.valueOf(oldValue);
                Date newConvertedValue = Date.valueOf(newValue);
                facultyHistoryObj.COH2_Old_Value__c = String.valueOf(oldValue);
                facultyHistoryObj.COH2_New_Value__c = String.valueOf(newValue);
            } 
            mFacultyHistoryList.add(facultyHistoryObj);
        }
    }
}