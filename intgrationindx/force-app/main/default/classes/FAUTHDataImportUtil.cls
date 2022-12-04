/*
 * This class contains methods for the Foundation Authorization project.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 * The Foundation Authorization project uses the Data Loader to read a CSV file 
 * and insert the contents into Data_Import_Record__c objects.  These objects
 * are then converted into Account and Case objects.
 * 
 * This is the mapping of the Data_Import_Record__c to Account and Case fields:
 * 
 * Processing_Type__c:  N/A  
 * 		Used by the COHDataImportHelper class
 * 
 * Text_255_00__c:  Physician first and last name
 * 		Used to retrieve the Contact for the Case.Ordering_Physician__c field.
 * 
 * Text_255_01__c:  Order date
 * 		Used to calculate the Account.Order_Date__c field.
 * 
 * Text_255_02__c:  COH MRN 
 * 		Account.COH_MRN__c
 * 
 * Text_255_03__c:  Patient Last Name, First Name
 * 		Used to calculate the Account.LastName__c, Account.FirstName__c,
 * 		and Account.Middle_Name__c fields.
 * 
 * Text_255_04__c:  Patient DOB
 * 		Used to calculate the Account.PersonBirthdate field.
 * 
 * Text_255_05__c:  Facility Name
 * 		Used to calculate the Case.Location__c field
 * 
 * Text_255_06__c:  Primary insurance policy number
 * 		Account.ID__c
 * 
 * Text_255_07__c:  Primary insurance name
 * 		Account.Insurance__c
 * 
 * Text_255_08__c:  Order requested for appointment date
 * 		Used to calculate the caseObj.Appt_Date__c field.
 * 
 * Text_255_09__c:  N/A
 * 
 * Text_255_10__c:  N/A
 * 
 * Text_255_11__c:  N/A
 * 
 * Text_2048_00__c:  Authorization status
 * 		Case.Auth_Status__c
 * 
 * Text_2048_01__c:  Order name
 * 		Account.FAUTH_Order_Name__c
 * 
 * Text_2048_02__c:  Primary medical group
 * 		Account.Primary_Group__c
 * 
 * Text_2048_03__c:  N/A
 * 		
 * Text_2048_04__c:  N/A
 * 		
 * Text_2048_05__c:  N/A
 * 		
 * Text_2048_06__c:  N/A
 * 		
 * Text_2048_07__c:  N/A
 * 
 * Text_16384_00__c:  Performing comments
 * 		Case.Notes__c
 * 
 */

public class FAUTHDataImportUtil {

    private static final String APPLICATION_NAME = 'Foundation';
    private static final String LOCATION_CONFIG_GROUP = 'Locations';
    private static final String FOUNDATION_AUTH_TYPE = 'Data Import Authorization Type';
    private static final String FOUNDATION_AUTH_DEFAULT_OWNER = 'Default Authorization Owner';
    private static final String FOUNDATION_AUTH_DEFAULT_PRIORITY = 'Default Authorization Priority';
    
    private static final String FOUNDATION_RECORD_TYPE_NAME = 'Foundation';
    private static final String ACCOUNT = 'Account';
    private static final String CASE_AUTHORIZATION_RECORD_TYPE = 'Authorization';
    private static final String CASE_CLASS = 'Case';

    private static final String NAME_COMMA_DELIMITER = ',';
    private static final String NAME_SPACE_DELIMITER = ' ';
    private static final Integer MIN_NAMES_COUNT = 2;
	private static final Integer LAST_NAME_INDEX = 0;    
	private static final Integer FIRST_NAME_INDEX = 1;    
    private static final Integer COMBINED_FIRST_NAME_INDEX = 0;
    private static final Integer COMBINED_MIDDLE_NAME_INDEX = 1;
	private static final Integer PHYSICIAN_FIRST_NAME_INDEX = 0;    

	// These are facility values from the incoming file
	private static final String F_ARCADIA = 'COHMF - Arcadia';
	private static final String F_CORONA = 'COHMF - Corona';
	private static final String F_GLENDORA = 'COHMF - Glendora';
	private static final String F_MISSION_HILLS = 'COHMF - Mission Hills';
	private static final String F_LANCASTER = 'COHMF - Lancaster';
	private static final String F_PASADENA = 'COHMF - Pasadena';
	private static final String F_RANCHO_CUCAMONGA = 'COHMF - Rancho Cucamonga';
	private static final String F_SANTA_CLARITA = 'COHMF - Santa Clarita';
	private static final String F_SIMI_VALLEY = 'COHMF - Lancaster';
	private static final String F_SOUTH_PASADENA = 'COHMF - S. Pasadena';
	private static final String F_WEST_CONVINA = 'COHMF - West Covina';
    
	// These are location values from the Case object
	private static final String C_ANTELOPE_VALLEY = 'Antelope Valley';
	private static final String C_ARCADIA = 'Arcadia';
	private static final String C_CORONA = 'Corona';
	private static final String C_GLENDORA = 'Glendora';
	private static final String C_MISSION_HILLS = 'Mission Hills';
	private static final String C_PASADENA = 'Pasadena Clinic-S Raymond';
	private static final String C_RANCHO_CUCAMONGA = 'Rancho Cucamonga';
	private static final String C_SANTA_CLARITA = 'Santa Clarita';
	private static final String C_SIMI_VALLEY = 'Simi Valley';
	private static final String C_SOUTH_PASADENA = 'South Pasadena - Fair Oaks Drive';
	private static final String C_WEST_CONVINA = 'West Covina';
    
    // For processing dates in this format:  YYYYMMDD
    private static final Integer YEAR_LEFT = 4;
    private static final Integer MONTH_LEFT = 4;
    private static final Integer MONTH_RIGHT = 6;
    private static final Integer DAY_RIGHT = 2;

	private static Map<String, List<Contact>> mAllPhysiciansMap;
    private static Id mFoundationRecordTypeID;
    private static Id mCaseAuthorizationRecordTypeID;
    private static String mFoundationAuthDefaultCallType;
    private static String mFoundationAuthDefaultOrigin;
    private static String mFoundationAuthDefaultStatus;
    private static String mFoundationAuthDefaultPriority;
    private static User mDefaultFoundationAuthOwner;
    
    
    private static Map<String, String> mFacilityLocationMap;
    
    static {
        initialize();
    }


    /*
     * Default constructor
     * 
     */
    public FAUTHDataImportUtil() {
    }
    
    /*
     * Initialize everything.
     * 
     */
    public static void initialize() {
		mAllPhysiciansMap = createFoundationAuthAllPhysiciansMap();        
        mCaseAuthorizationRecordTypeID = COHUtil.getRecordType(CASE_CLASS, CASE_AUTHORIZATION_RECORD_TYPE);
        mFoundationRecordTypeID = COHUtil.getRecordType(ACCOUNT, FOUNDATION_RECORD_TYPE_NAME);
        mFoundationAuthDefaultPriority = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, FOUNDATION_AUTH_DEFAULT_PRIORITY);
        String defaultFoundationAuthAlias = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, FOUNDATION_AUTH_DEFAULT_OWNER);
        mDefaultFoundationAuthOwner = [select Id, alias from User where alias = :defaultFoundationAuthAlias limit 1];
        mFacilityLocationMap = mapFacilityToLocation();
    }
    
    /*
     * This method processes a list of Data_Import_Record__c objects for Foundation Authorization
     * 
     * @param   validRecordsList	List of Data_Import_Record__c objects to process.
     * @param   validMRNsList		List of the MRNs of Data_Import_Record__c objects to process.
     * 
     */
    public static void processFoundationAuthRecords(List<Data_Import_Record__c> validRecordsList,
                                                     List<String> validMRNsList, List<String> validFoundationAuthFirstNames) {

		if (COHUtil.isValidList(validRecordsList)) {
       
			// Map of MRNs and accounts that already exist and are found in the validRecordsList
			Map<String, Account> existingAccountsMap = new Map<String, Account>();
            List<Account> existingAccountsList = [select Id, COH_MRN__c, Name from Account where COH_MRN__c in :validMRNsList];
            if (COHUtil.isValidList(existingAccountsList)) {
                for (Account accountObj : existingAccountsList) {
                    String cohMRN = accountObj.COH_MRN__c;
                    existingAccountsMap.put(cohMRN, accountObj);
                }
            }
                      
			//Map Of Accounts by Unique Key
			Map<String, Account> existingAccountsByUniqueKeyMap = new Map<String, Account>();
			List<Account> existingAccountsByUniqueKeyList = [select Id, COH_MRN__c, Name, FirstName, LastName, PersonBirthdate from Account where FirstName in :validFoundationAuthFirstNames];// and COH_MRN__c not in :validMRNsList];
			if (COHUtil.isValidList(existingAccountsByUniqueKeyList)) {
				for (Account accountObj : existingAccountsByUniqueKeyList) {
					String uniqueKey = accountObj.FirstName + accountObj.LastName + accountObj.PersonBirthdate;
					uniqueKey = uniqueKey.trim();
					existingAccountsByUniqueKeyMap.put(uniqueKey, accountObj);
					System.debug('existingAccountsByUniqueKeyMap-->' + uniqueKey);
				}
			}
           
			// Map of Data Import Record objects to their MRN where the Account object already exists
			Map<String, ImportRecords> dirWithExistingAccountsMap = new Map<String, ImportRecords>();
			Map<String, ImportRecords> dirWithExistingAccountsByUniqueKeyMap = new Map<String, ImportRecords>();
           
			// Map of the new MRNs and accounts.
            Map<String, ImportRecords> newRecordsMap = new Map<String, ImportRecords>();
            
            // Map of physician last name & first name to the corresponding Contacts.
            // NOTE: It's highly likely that the there will be unmapped entries because
            // the physician last name & first name come from an external source
            Map<String, Contact> physicianToContactMap = new Map<String, Contact>();
            
            for (Data_Import_Record__c dirObj : validRecordsList) {
    	        String dirPhysicianName = dirObj.Text_255_00__c;
                //Create unique key based on lastname firstname and date of birth
                /*String uniqueKey = ((dirObj.Text_255_03__c.replaceAll(NAME_COMMA_DELIMITER, '')).replaceAll(NAME_SPACE_DELIMITER, '')  + dirObj.Text_255_04__c);
                uniqueKey = uniqueKey.toLowerCase().trim();*/
                
                if (COHUtil.isValidStr(dirPhysicianName)) {
	    			physicianToContactMap.put(dirPhysicianName.toUpperCase(), null);
                }
                                
                //Create account object on first name, last name and Date of birth from a record in the file
                //This record is used to query account object and check if an account with name and Date of birth exists
                List<String> namesList = dirObj.Text_255_03__c.split(NAME_COMMA_DELIMITER);
                Account accountfromDataRecord = new Account();
                if (COHUtil.isValidList(namesList)) {
                    Integer tokenCount = namesList.size();
                    if (tokenCount == MIN_NAMES_COUNT) {
                        accountfromDataRecord.FirstName = namesList[FIRST_NAME_INDEX];
                        accountfromDataRecord.LastName = namesList[LAST_NAME_INDEX];
                        if (string.isNotEmpty(dirObj.Text_255_04__c)) {
                            accountfromDataRecord.PersonBirthdate = createDateObject(dirObj.Text_255_04__c);
                        }                        
                    }
                }
                                
                //check if account exists based for the record in the file
                //List<Account> existingAccountsByUniqueKey = [select Id, COH_MRN__c, Name, FirstName, LastName, PersonBirthdate from Account 
                //                                                 where FirstName = :accountObjByUniqueKeys.FirstName and LastName = :accountObjByUniqueKeys.LastName
                //                                                 and PersonBirthdate = :accountObjByUniqueKeys.PersonBirthdate Limit 1];
                
                String dirMRN = dirObj.Text_255_02__c;
                string uniqueKey = accountfromDataRecord.FirstName + accountfromDataRecord.LastName + accountfromDataRecord.PersonBirthdate;
                uniqueKey = uniqueKey.trim();
//                Account accountObj = existingAccountsMap.get(dirMRN);
                // testing--raymond tam
                // I think if dirMRN is null, don't do a lookup because it will give us the wrong
                // account object (there is a default account object without a MRN).
                // The preceding line should be replaced with the following lines:

                Account accountObj = null;
                if (COHUtil.isValidStr(dirMRN)) {
                    accountObj = existingAccountsMap.get(dirMRN);
                }
                
                Account accountObjByUniqueKey = existingAccountsByUniqueKeyMap.get(uniqueKey); 

                if (accountObj == null) {
                    // If account is found by Unique key (Firstname lastname and Date of birth) 
                    // add case to the existing account list, else add a new account
                    if (accountObjByUniqueKey == null) {
                        insertFoundationAuthMap(newRecordsMap, dirMRN, dirObj);  
                    } else {
                        insertFoundationAuthMap(dirWithExistingAccountsByUniqueKeyMap, uniqueKey, dirObj); 
                    }
                }  else {
                    insertFoundationAuthMap(dirWithExistingAccountsMap, dirMRN, dirObj);   
                    // testing--raymond tam
                    // Seems like this preceding call to insertFoundationAuthMap()
                    // should be replaced with the following IF-ELSE block
/*
                    if (COHUtil.isValidStr(dirMRN)) {
	                    insertFoundationAuthMap(dirWithExistingAccountsMap, dirMRN, dirObj);                      
                    } else {
	                    insertFoundationAuthMap(dirWithExistingAccountsMap, uniqueKey, dirObj);                      
                    }
*/
                }         
            }

            // Create a map COH physicians to their corresponding Contact object.
            populateFoundationAuthPhysicianMap(physicianToContactMap);
            
            // Create cases for existing account objects
            createFoundationAuthCases(existingAccountsMap, dirWithExistingAccountsMap, physicianToContactMap);
           
			// Create cases for existing account objects found with uniqueKey
            createFoundationAuthCases(existingAccountsByUniqueKeyMap, dirWithExistingAccountsByUniqueKeyMap, physicianToContactMap);
            
            // Create the new account objects and cases, if necessary
			createFoundationAuthNewAccountsAndCases(newRecordsMap, physicianToContactMap);
           
			Set<String> keyset0 = existingAccountsMap.keySet();
			Set<String> keyset1 = newRecordsMap.keySet();
			Integer recCount0 = 0;
			Integer recCount1 = 0;
           
			if (keyset0 != null) {
                recCount0 = keyset0.size();
            }
			if (keyset1 != null) {
                recCount1 = keyset1.size();
            }
            
            String message = 'Records processed successfully: ' + recCount0 + ' existing records, ' + recCount1 + ' new records';
			COHUtil.logMessage('Foundation', 'INFO', 'processFoundationAuthRecords()', message);
        }
    }

    /*
     * Create a map of all COH physicians.  The key is the last name.  The value of each map
     * is a List of Contacts because physicians may share the same last names.  This is needed
     * because SOQL does not have the same capabilities as SQL.
     * 
     */
    private static Map<String, List<Contact>> createFoundationAuthAllPhysiciansMap() {
        String physicianSoqlQuery = 'select Id, FirstName, LastName from Contact where Type__c = \'Physician\' and Account.Name = \'City of Hope National Medical Center\'';
        List<Contact> allPhysicianList = Database.query(physicianSoqlQuery);
		
        Map<String, List<Contact>> allPhysiciansMap = new Map<String, List<Contact>>();

        if (COHUtil.isValidList(allPhysicianList)) {
            for (Contact contactObj : allPhysicianList) {
                String lastName = contactObj.LastName;
                if (COHUtil.isValidStr(lastName)) {
                    lastName = lastName.toUpperCase();
                }
                contactObj.LastName = lastName;

                String firstName = contactObj.FirstName;
                if (COHUtil.isValidStr(firstName)) {
                    firstName = firstName.toUpperCase();
                }
                contactObj.FirstName = firstName;
                
                List<Contact> retrievedContacts = allPhysiciansMap.get(lastName);
                if (!COHUtil.isValidList(retrievedContacts)) {
                    retrievedContacts = new List<Contact>();
                }
				retrievedContacts.add(contactObj);
                allPhysiciansMap.put(lastName, retrievedContacts);
            }
        }
        return allPhysiciansMap;
    }
    
    /*
     * Populate the mapping of physician first and last names to the Contact record.  This method
     * is convoluted because SOQL doesn't support full SQL capabilities.
     * 
     * @param   physicianToContactMap	Map of physician first and last names to the Contact record.
     * 
     */
    private static void populateFoundationAuthPhysicianMap(Map<String, Contact> physicianToContactMap) {

        // Update the physicianToContactMap with the latest information
        Set<String> physicianNames = physicianToContactMap.keySet();
        
        // Retrieve the last name.  Look it up in mAllPhysiciansMap by last name.
        for (String fullName : physicianNames) {
			List<String> physicianNamesList = fullName.split(NAME_SPACE_DELIMITER);
            Integer lastNameIndex = physicianNamesList.size() - 1;
            if (lastNameIndex >= 0) {
                String lastName = physicianNamesList[lastNameIndex];
                if (COHUtil.isValidStr(lastName)) {
                    lastName = lastName.toUpperCase();
                }
                String combinedNames = null;	// If there is a middle name, it 
                								// will be stored as part of the first name
                for (Integer i = PHYSICIAN_FIRST_NAME_INDEX; i < lastNameIndex; i++) {
                    if (combinedNames == null) {
                        combinedNames = physicianNamesList[i];
                    } else {
                        combinedNames += NAME_SPACE_DELIMITER + physicianNamesList[i];
                    }
                }
                if (COHUtil.isValidStr(combinedNames)) {
					combinedNames = combinedNames.trim();
                }
                
                // traverse the List until the correct first name is found (might need something to check for duplicates)
				List<Contact> contactsToCheck = mAllPhysiciansMap.get(lastName);
                if (COHUtil.isValidList(contactsToCheck)) {
                    for (Contact contactObj : contactsToCheck) {
                        String combinedNamesCandidate = contactObj.FirstName;
                        
                        if (combinedNames.equalsIgnoreCase(combinedNamesCandidate)) {
                            // Insert the Contact object into physicianToContactMap
                            physicianToContactMap.put(fullName.toUpperCase(), contactObj);
                            break;
                        }
                    }
                }
            }
        }
    }
    
    /*
     * Inserts a new record into the newCasesMap.  If there is already an entry in the map, 
     * the new record is added to the mDataRecordsList member.
     * 
     * @param	newCasesMap		Map of new cases
     * @param	dirMRN			MRN 
     * @param	dirObj			Data Import Record object to add
     * 
     */
	private static void insertFoundationAuthMap(Map<String, ImportRecords> newCasesMap, 
                                                String dirMRN, 
                                                Data_Import_Record__c dirObj) {
		if (newCasesMap != null && COHUtil.isValidStr(dirMRN) && dirObj != null) {
        	ImportRecords importRec = newCasesMap.get(dirMRN);
            if (importRec == null) {
                importRec = new ImportRecords();
            }
            importRec.addDataRecord(dirObj);
            newCasesMap.put(dirMRN, importRec);
		}
                                                            
	}

	/*
	 * Create cases for existing account objects.
	 * 
	 * @param	existingAccounts			Map of unique key to existing account objects.
	 * 										It can be either the MRN or a combination of the
	 * 										First Name, Last Name, and Date of Birth.
	 * @param	dirWithExistingAccountsMap	Map of MRNs to Data Import Record objects where the
	 * 										MRN belongs to an existing account object.
	 * @param	physicianToContactMap		Map of physician names to the corresponding Contact object.
	 * @throws 								COHException if an error occurred.
	 */
	private static void createFoundationAuthCases(Map<String, Account> existingAccounts, 
                                                  Map<String, ImportRecords> dirWithExistingAccountsMap, 
                                                  Map<String, Contact> physicianToContactMap) {
    
		if (existingAccounts != null && dirWithExistingAccountsMap != null) {
            
            //  Retrieve all account object IDs.  Need to loop through the accountsList
            //  more than once due to bulkfication requirements.
            List<Id> accountIDList = new List<Id>();
			Set<String> keyset = dirWithExistingAccountsMap.keySet();
            for (String mrn : keyset) {
                Account accountObj = existingAccounts.get(mrn);
                accountIDList.add(accountObj.Id);
            }
            
			// retrieve Contact IDs for the AccountIDs
            Map<Id, String> accountIDToContactIDMap = new Map<Id, Id>();
	        List<Contact> contactList = [select AccountId, Id from contact where AccountId in :accountIDList];
            if (COHUtil.isValidList(contactList)) {
                for (Contact contactObj : contactList) {
		            accountIDToContactIDMap.put(contactObj.AccountId, contactObj.Id);
                }
            }
            
	        List<Case> casesList = new List<Case>();
            for (String mrn : keyset) {
                Account accountObj = existingAccounts.get(mrn);
                Id parentID = accountObj.Id;
                ImportRecords importRecordObj = dirWithExistingAccountsMap.get(mrn);
                List<Data_Import_Record__c> dataImportRecords = importRecordObj.mDataRecordsList;
                if (COHUtil.isValidList(dataImportRecords)) {
                    for (Data_Import_Record__c dirObj : dataImportRecords) {
                        Case caseObj = createFoundationAuthCase(physicianToContactMap, dirObj);
                        caseObj.AccountId = parentID;
                        
                        Id contactID = accountIDToContactIDMap.get(parentID);
                        caseObj.ContactId = contactID;
                        
                        casesList.add(caseObj);
                    }
                }
            }
            
            if (COHUtil.isValidList(casesList)) {
                try {
                    Database.insert(casesList);
                } catch (COHException e) {
                    System.debug(LoggingLevel.ERROR, 'Could not insert cases: ' + e.getMessage());
                    throw e;
                }
            }
		}
	}
    
    
	/*
	 * Create new accounts for Data Import Records that do not have a MRN to an existing account.
	 * If there are multiple records for the same MRN, cases are created subsequent records and
	 * assigned as child objects to the new Account object.
	 * 
	 * @param	newRecordsMap			Map of MRNs to Data Import Record objects where the
	 * 									MRN has not been assigned to an existing account.
	 * @param	physicianToContactMap	Map of physician names to the corresponding Contact object.
	 * @throws 							COHException if an error occurred.
	 */
    private static void createFoundationAuthNewAccountsAndCases(Map<String, ImportRecords> newRecordsMap,
                                                                Map<String, Contact> physicianToContactMap){
        
		if (newRecordsMap != null) {
            // Map the MRN to the list of cases to add for the corresponding Account object
            // with the same MRN.
            Map<String, List<Case>> mrnToCasesListMap = new Map<String, List<Case>>();
            
	        List<Account> accountsList = new List<Account>();
	        List<Case> casesList = new List<Case>();
			Set<String> keyset = newRecordsMap.keySet();
            for (String mrn : keyset) {
                ImportRecords importRecordObj = newRecordsMap.get(mrn);
                List<Data_Import_Record__c> dataImportRecords = importRecordObj.mDataRecordsList;
                Boolean firstRecord = true;
                if (COHUtil.isValidList(dataImportRecords)) {
                    List<Case> newCases = new List<Case>();
					Account newAccountObj = processNewFoundationAuthRecords(physicianToContactMap, dataImportRecords, mrn, newCases);
                    mrnToCasesListMap.put(mrn, newCases);
                    if (newAccountObj != null) {		// new Account not created if one already exists
						accountsList.add(newAccountObj);
                    }
                }
            }

            if (COHUtil.isValidList(accountsList)) {
                try {
                    Database.insert(accountsList);
                } catch (COHException e) {
                    System.debug(LoggingLevel.ERROR, 'Could not insert accounts: ' + e.getMessage());
                    throw e;
                }
            }
            
            //  Retrieve all account object IDs.  Need to loop through the accountsList
            //  more than once due to bulkfication requirements.
            List<Id> accountIDList = new List<Id>();
            for (Account accountObj : accountsList) {
                accountIDList.add(accountObj.Id);		
            }
            
			// retrieve Contact IDs for the AccountIDs
            Map<Id, String> accountIDToContactIDMap = new Map<Id, Id>();
	        List<Contact> contactList = [select AccountId, Id from contact where AccountId in :accountIDList];
            if (COHUtil.isValidList(contactList)) {
                for (Contact contactObj : contactList) {
		            accountIDToContactIDMap.put(contactObj.AccountId, contactObj.Id);
                }
            }
            
            // Loop through the accounts, retrieve the account IDs, and set the
            // parentID of the corresponding Case objects            
            for (Account accountObj : accountsList) {
                Id parentID = accountObj.Id;
                String parentMRN = accountObj.COH_MRN__c;
                List<Case> childCasesList = mrnToCasesListMap.get(parentMRN);
                for (Case childCaseObj : childCasesList) {
                    childCaseObj.AccountId = parentID;
                    Id contactID = accountIDToContactIDMap.get(parentID);
                    childCaseObj.ContactId = contactID;
                    casesList.add(childCaseObj);
                }
                
            }

			
            if (COHUtil.isValidList(casesList)) {
                try {
                    Database.insert(casesList);
                } catch (COHException e) {
                    System.debug(LoggingLevel.ERROR, 'Could not insert cases: ' + e.getMessage());
                    throw e;
                }
            }
        }
    }
    
	/*
	 * Processes accounts for Data Import Records that do not have a MRN to an existing account.
	 * If there are multiple records for the same MRN, cases are created subsequent records and
	 * assigned as child objects to the new Account object.
	 * 
	 * @param	physicianToContactMap	Map of physician names to the corresponding Contact object.
	 * @param	dataImportRecords		List of Data Import Record objects to process.
	 * @param	dirMRN					MRN for the list of Data Import Record object(s).
	 * @param	newAccountObj			New account object to be created.
	 * @param	dataImportRecords		List of new cases to be created for the newAccountObj paramenter.
	 * @return							Account object when the Account does not already exist.
	 * @throws 							COHException if an error occurred.
	 */
    private static Account processNewFoundationAuthRecords(Map<String, Contact> physicianToContactMap,
                                                        List<Data_Import_Record__c> dataImportRecords,
                                                        String dirMRN,
                                                        List<Case> newCases) {

        Boolean firstRecord = true;
		Account newAccountObj = null;
		for (Data_Import_Record__c dirObj : dataImportRecords) {
        	if (firstRecord) {	// Create account object for the first record with a specific MRN.
            	firstRecord = false;
                newAccountObj = createFoundationAuthAccount(dirObj);
            } 
            Case newCase = createFoundationAuthCase(physicianToContactMap, dirObj);
            newCases.add(newCase);
		}
		return newAccountObj;        
    }
     /*
     * Create a Foundation Authorization Account object from the Data Import Record object.
     * 
	 * @param	obj		Data_Import_Record__c object containing the raw data.
	 * @return			An Account object with the corrected info from the obj paramenter.
	 * 
     */
    private static Account createFoundationAuthAccount(Data_Import_Record__c obj) {
        Account accountObj = null;
        if (obj != null) {
            accountObj = new Account();
            String dirDOB = obj.Text_255_04__c;
			accountObj.PersonBirthdate = createDateObject(dirDOB);
            String dirMRN = obj.Text_255_02__c;
            accountObj.COH_MRN__c = dirMRN;
            
            String dirPatientName = obj.Text_255_03__c;
            List<String> namesList = dirPatientName.split(NAME_COMMA_DELIMITER);
            if (COHUtil.isValidList(namesList)) {
                Integer tokenCount = namesList.size();
                if (tokenCount < MIN_NAMES_COUNT) {
                    throw new COHException('Name expected in the format: \'<Last Name>, <First Name>\' but received \'dirPatientName\'');
                }
                
                String patientLastName = namesList[LAST_NAME_INDEX];
                if (COHUtil.isValidStr(patientLastName)) {
                    accountObj.LastName = patientLastName.trim();
                }

                // In this case, first and middle names are combined in namesList

                String combinedNames = namesList[FIRST_NAME_INDEX];
                if (COHUtil.isValidStr(combinedNames)) {
                    combinedNames = combinedNames.trim();
                }
                
                List<String> combinedNamesList = combinedNames.split(NAME_SPACE_DELIMITER);
                if (COHUtil.isValidList(combinedNamesList)) {
					String patientFirstName = combinedNamesList[COMBINED_FIRST_NAME_INDEX];
                    if (COHUtil.isValidStr(patientFirstName)) {
                        accountObj.FirstName = patientFirstName.trim();
                    }

                    Integer combinedtokenCount = combinedNamesList.size();
                    if (combinedtokenCount >= MIN_NAMES_COUNT) {
                        // Handles the situation where the middle name consists of more
                        // than one word.
                        String middleName = null;
                        for (Integer i = COMBINED_MIDDLE_NAME_INDEX; i < combinedTokenCount; i++ ) {
                            if (middleName == null) {
                                middleName = combinedNamesList[i];
                            } else {
                                middleName += NAME_SPACE_DELIMITER + combinedNamesList[i];
                            }
                            
                        }
                        if (COHUtil.isValidStr(middleName)) {
                            middleName = middleName.trim();
                        }
                        accountObj.Middle_Name__c = middleName;
                    }
                } 
            }
            
            String dirPrimaryInusrancePolicyNo = obj.Text_255_06__c;
            accountObj.ID__c = dirPrimaryInusrancePolicyNo;
            
            String dirInsuranceName = obj.Text_255_07__c;
            accountObj.Insurance__c = getFoundationAuthMappedName(dirInsuranceName);  // mapped insurance name
            
            String dirPlanName = obj.Text_2048_02__c;  // medical group
            accountObj.Medical_Group_IPA__c = dirPlanName;
            
        }
        return accountObj;
    }
    

	/*
     * Create a Foundation Authorization case object from the Data Import Record object.
     * 
	 * @param	physicianToContactMap	Map of physician names to the corresponding Contact object.
	 * @param	obj						Data_Import_Record__c object containing the raw data.
	 * @return							A case object with the corrected info from the obj paramenter.
	 * @throws 							COHException if an error occurred.
	 * 
     */
    private static Case createFoundationAuthCase(Map<String, Contact> physicianToContactMap,
                                                 Data_Import_Record__c obj) {
        Case caseObj = null;
        if (obj != null) {
            caseObj = new Case();
            String dirPhysicianName = obj.Text_255_00__c;
            if (COHUtil.isValidStr(dirPhysicianName)) {
	            dirPhysicianName = dirPhysicianName.toUpperCase();
            }
            
            List<String> physicianNamesList = dirPhysicianName.split(NAME_SPACE_DELIMITER);
            if (COHUtil.isValidList(physicianNamesList)) {
                Integer tokenCount = physicianNamesList.size();
                if (tokenCount < MIN_NAMES_COUNT) {
                    throw new COHException('Physician Name expected in the format: \'<First Name> <Last Name>\' but received \''+ dirPhysicianName + '\'');
                } else {
                    Contact contactObj = physicianToContactMap.get(dirPhysicianName);
                    if (contactObj != null) {
                        caseObj.Ordering_Physician__c = contactObj.Id;
                    } 
                }
                
                String callerName = obj.Text_255_03__c;
				List<String> callerNamesList = callerName.split(NAME_COMMA_DELIMITER);
                if (COHUtil.isValidList(callerNamesList)) {
                    tokenCount = callerNamesList.size();
                    if (tokenCount < MIN_NAMES_COUNT) {
                        throw new COHException('Caller Name expected in the format: \'<Last Name>, <First Name>\' but received \''+ callerName + '\'');
                    } else {
						caseObj.Caller_First_Name__c = callerNamesList[FIRST_NAME_INDEX];
                        caseObj.Caller_Last_Name__c = callerNamesList[LAST_NAME_INDEX];
                    }
                }
                
                String dirOrderName = obj.Text_2048_01__c;
				caseObj.FAUTH_Order_Name__c = dirOrderName;   
                
                String dirOrderCreated = obj.Text_255_01__c;
                caseObj.Order_Date__c = createDateObject(dirOrderCreated);

                String authorizationStatus = obj.Text_2048_00__c;
                caseObj.Auth_Status__c = getFoundationAuthMappedStatus(authorizationStatus);

                caseObj.Priority = mFoundationAuthDefaultPriority;
                caseObj.RecordTypeId = mCaseAuthorizationRecordTypeID;

                String dirApptDate = obj.Text_255_08__c;
                caseObj.Appt_Date__c = createDateObject(dirApptDate);

                String originalFacility = obj.Text_255_05__c;
                caseObj.Location__c = mFacilityLocationMap.get(originalFacility);
                caseObj.Notes__c = obj.Text_16384_00__c;
            }
       }
       return caseObj;
    }

    /*
     * Create a Date object from a String.  The String will be in this format:  YYYYMMDD
     * 
     * @param	dateString		String representation of the date
     * @return					Date object created from the dateString argument.
     * 
     */
    private static Date createDateObject(String dateString) {
		Date dateObj = null;
        if (COHUtil.isValidStr(dateString)) {
            Integer year = Integer.valueOf(dateString.left(YEAR_LEFT));
            Integer month = Integer.valueOf(dateString.substring(MONTH_LEFT, MONTH_RIGHT));
            Integer day = Integer.valueOf(dateString.right(DAY_RIGHT));
            dateObj = Date.newInstance(year, month, day);
        }
        return dateObj;
    }
    
    /*
     * Map the Insurance plan name to the Health Plan Name
     * 
     * @param	originalName	Original name of the Insurance plan.
     * @return					The mapped name that corresponds to the Insurance__c picklist value.
     * 
     */
    private static String getFoundationAuthMappedName(String originalName)  {

        // The "IP" prefix stands for "Insurance Plan".
        // The "MN" prefix stands for "Mapped Name".

        String IPBlueCross = 'BlueCross';
    	String IPHealthCarePartners = 'HCP MED GROUP/PA CONTRACT SPCC';
    	String MNBlueCross = 'Blue Cross Blue Shield PPO';
    	String MNHealthCarePartners = 'HealthCare Partners';

		String mappedName = originalName;
        if (COHUtil.isValidStr(originalName)) {
	        String trimmedName = originalName.trim();
            if (trimmedName.equalsIgnoreCase(IPBlueCross)) {
                mappedName = MNBlueCross;
            } else if (trimmedName.equalsIgnoreCase(IPHealthCarePartners)) {
                mappedName = MNHealthCarePartners;
            } else {
				mappedName = trimmedName;
            }
        }
        return mappedName;
    }
    
    /*
     * Map the authorization status to the correct picklist value of the Case.Auth_Status__c
     * field.
     * 
     * @param	originalName	Original name of the authorization status.
     * @return					The mapped name that corresponds to the Insurance__c picklist value.
     * 
     */
    private static String getFoundationAuthMappedStatus(String originalName) {

        // The "FA" prefix stands for "Finanicial Authorization".
        // The "MN" prefix stands for "Mapped Name".

        String FANeeded = 'Needed';
    	String MNNeeded = 'Auth. Needed';

		String mappedName = originalName;
        if (COHUtil.isValidStr(originalName)) {
	        String trimmedName = originalName.trim();
            if (trimmedName.equalsIgnoreCase(FANeeded)) {
                mappedName = MNNeeded;
            } 
        }
        return mappedName;
    }
    

    /*
     * Create the mapping of facilities to locations.
     * 
     * @return	Map object containing the mappings
     * 
     */
    private static Map<String, String> mapFacilityToLocation() {
        Map<String, String> facilityLocationMap = new Map<String, String>();
        List<COH_App_Configuration__c> configGroup = COHUtil.getConfigurationGroup(APPLICATION_NAME, LOCATION_CONFIG_GROUP);
        if (COHUtil.isValidList(configGroup)) {
            for (COH_App_Configuration__c appConfigObj : configGroup) {
                String locationName = appConfigObj.Name;
                String facilityName = null;
                // ugly IF clause because Salesforce doesn't support
                // switch statements
                if (COHUtil.isValidStr(locationName)) {
                  if (locationName.equalsIgnoreCase(C_ANTELOPE_VALLEY)) {
                        facilityName = F_LANCASTER;
                    } else if (locationName.equalsIgnoreCase(C_ARCADIA)) {
                        facilityName = F_ARCADIA;
                    } else if (locationName.equalsIgnoreCase(C_CORONA)) {
                        facilityName = F_CORONA;
                    } else if (locationName.equalsIgnoreCase(C_GLENDORA)) {
                        facilityName = F_GLENDORA;
                    } else if (locationName.equalsIgnoreCase(C_MISSION_HILLS)) {
                        facilityName = F_MISSION_HILLS;
                    } else if (locationName.equalsIgnoreCase(C_PASADENA)) {
                        facilityName = F_PASADENA;
                    } else if (locationName.equalsIgnoreCase(C_RANCHO_CUCAMONGA)) {
                        facilityName = F_RANCHO_CUCAMONGA;
                    } else if (locationName.equalsIgnoreCase(C_SANTA_CLARITA)) {
                        facilityName = F_SANTA_CLARITA;
                    } else if (locationName.equalsIgnoreCase(C_SIMI_VALLEY)) {
                        facilityName = F_SIMI_VALLEY;
                    } else if (locationName.equalsIgnoreCase(C_SOUTH_PASADENA)) {
                        facilityName = F_SOUTH_PASADENA;
                    } else if (locationName.equalsIgnoreCase(C_WEST_CONVINA)) {
                        facilityName = F_WEST_CONVINA;
                    } // ignore all other values

                    if (COHUtil.isValidStr(facilityName)) {
	                    facilityLocationMap.put(facilityName, locationName);
                    }
                }
           }
        }
        return facilityLocationMap;
    }
    
	/*
     * Internal class for keeping track of multiple records that have the same MRN.
     * 
     */
    private class ImportRecords {
        
        private List<Data_Import_Record__c> mDataRecordsList {get; set;}
        
        public ImportRecords() {
			mDataRecordsList = new List<Data_Import_Record__c>();
        }
        
        public void addDataRecord(Data_Import_Record__c obj) {
			mDataRecordsList.add(obj);
        }
    }    

}