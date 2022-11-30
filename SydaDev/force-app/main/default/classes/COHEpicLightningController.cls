/*
 * This controller class contains the methods for creating Epic Records
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2019
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 **** Frank Salinas Modified 04/01/2021
 * Description: 	Raymond developed the createEpicRecordViaURL method some time before 2019 but it was never implemented because of Epic legal matters with APIs. The legal matters have been resolved
 *  				Added Epic Client ID to the HTTP call to Epic and enabled the Custom Metadata to use the new createEpicRecordViaURL method.
 * This Class: 		Added EPIC_CLIENT_ID to HTTP Header values
 * Custom Metadata: Added Epic Client ID to COH_Configuration MDT. 
 * Modification: 	20210401 Frank Salinas 
 * 					Added new Epic search method for looking up Epic Patients before the EpicCreatePatient method is called
 */
public class COHEpicLightningController {
    
    // Http constants
    private static final String POST = 'POST';
    private static final String GET = 'GET';//FS 20210401 new for the Epic Lookup URL
    private static final String AUTHORIZATION_KEY = 'Authorization';
    private static final String AUTHORIZATION_VAL_PREFIX = 'Bearer ';
    private static final String CONTENT_TYPE_KEY = 'Content-Type';
    private static final String CONTENT_TYPE_VALUE = 'application/json';
    private static final String ACCEPT_KEY = 'accept';
    private static final String ACCEPT_VALUE = 'application/text';//json';//FS 20210318
    private static final String CHARSET_KEY = 'charset';
    private static final String CHARSET_VALUE = 'utf-8';
    private static final String ACCEPT_ENCODING_KEY = 'Accept-Encoding';
    private static final String ACCEPT_ENCODING_VALUE = 'gzip';
    private static final Integer OK_STATUS_CODE = 200;
    private static final String EPIC_CLIENT_ID_KEY = 'Epic-Client-ID';//FS 20210401 new security feature for Create Patient API

    // For accessing Custom Metadata
    private static final String EPIC_INTEGRATION = 'Epic Integration';
    private static final String EPIC_CREATE_URL_KEY = 'Epic_Create_Patient_Endpoint_URL';
    private static final String EPIC_UPDATE_URL_KEY = 'Epic_Update_Patient_Endpoint_URL';
    private static final String EPIC_USER_KEY = 'Epic_User_Name';
    private static final String EPIC_PASSWORD_KEY = 'Epic_Password';
    private static final String EPIC_CLIENT_ID = 'Epic_Client_ID';//FS 20210401
    private static final String EPIC_LOOKUP_URL_KEY = 'Epic_Lookup_Patient_Endpoint_URL';//FS 20210401 New for Epic Patient Lookup
	private static final String DEFAULT_DEPT_ID_KEY = 'DEFAULT_DEPT_ID';//FS 20210401
    
    private static final String DEFAULT_DEPT_ID = '105000015';//'COHCC';//FS per Amir
    private static final String DEFAULT_DEPT_TYPE = 'External';// 'DEPID';<-- DEPID was previous value
	private static final String DEFAULT_USER_ID_TYPE = 'External';
	private static final String PATIENT_TYPE = 'MR';
    private static final String TYPE_STR = '"Type"';
	private static final String TYPE_Z_STR = '"Type_z"';
             
	private static final String BASIC_AUTHORIZATION = 'Basic ';

    private static String mEpicCreateURL;
	private static String mEpicUpdateURL;
    private static String mEpicUserName;
    private static String mEpicPassword;
    private static String mEpicClientID;
    private static String mEpicPatientLookupURL;//FS 20210330
    private static String mSearchMRN;
    private static Integer mSearchRecordCount;
    private static String mDefaultDeptID;//FS 20210401
  
    static {
        mEpicCreateURL = getTextConfigurationValue(EPIC_CREATE_URL_KEY);
        mEpicUpdateURL = getTextConfigurationValue(EPIC_UPDATE_URL_KEY);
        mEpicUserName = getTextConfigurationValue(EPIC_USER_KEY);
        mEpicPassword = getTextConfigurationValue(EPIC_PASSWORD_KEY);
        mEpicClientID = getTextConfigurationValue(EPIC_CLIENT_ID);//FS 20210318
        mEpicPatientLookupURL = getTextConfigurationValue(EPIC_LOOKUP_URL_KEY);//FS 20210330
        mDefaultDeptID = getTextConfigurationValue(DEFAULT_DEPT_ID_KEY);//FS 20210330
    }

    /*
     * Create an Epic record. If a valid Epic endpoint URL has been supplied in the Custom Metadata, the record 
     * will be sent to the URL. Otherwise, the Account.IsRead__c field is set to False so that Epic can poll for these
     * types records.  After Epic retrieves the record, it will create the record.  This is due to a legal problem
     * with using the URL.  
     * 
     * @param caseID		ID of the case object.
     * @return				If the URL was provided, the MRN if the newly-created object is returned. 
     * 						If the URL was not provided, 'true' is returned if the Account.IsRead__c
     * 						was set the true, 'false' otherwise.
     * 
     */
    @AuraEnabled
    public static String createNewEpicRecord(Id caseID) {
        String retVal = null;
        if (String.isEmpty(mEpicCreateURL)) {
            Boolean boolRetVal = modifyDoNotSendFlagForCreate(caseID);
            return (boolRetVal == true ? 'true' : 'false');
        } else {
            retVal = createEpicRecordViaURL(caseID);//FS 20210318 Now that COH Configuration MDT is set to ACTIVE, this method will use the Epic API
        }
        Case recCase = [Select Id from Case where Id =: caseID Limit 1];
        update recCase;

        return retVal;
    }

    /*
     * Update an Epic record. If a valid Epic endpoint URL has been supplied in the Custom Metadata, the record 
     * will be sent to the URL. Otherwise, the Account.IsRead__c field is set to False so that Epic can poll for these
     * types records.  After Epic retrieves the record, it will create the record.  This is due to a legal problem
     * with using the URL.  
     * 
     * @param caseID		ID of the case object.
     * 
     */
    @AuraEnabled
    public static void updateExistingEpicRecord(Id accountID) {
        if (String.isEmpty(mEpicUpdateURL)) {
            modifyDoNotSendFlagForUpdate(accountID);//FS 20210401 As of this release, this should never be used again
        } else {
            updateEpicAccountRecordViaURL(accountID);
        }
    }    
    
    /*
     * Modifies the Account.IsRead__c field is set to false so that Epic can poll for these
     * types records to be created.  A Chatter post is created if the modification is successful.
     * 
     * @param caseID		ID of the case object.
     * @return				True if the operation completed successfully, false otherwise.
     * 
     */
    @AuraEnabled
    @TestVisible
    public static Boolean modifyDoNotSendFlagForCreate(Id caseID) {
        Boolean bSuccess;

        if (String.isNotEmpty(caseID)) {
            List<Case> caseList = [SELECT AccountId FROM Case WHERE Id = :caseID];
            if (COHUtil.isValidList(caseList)) {
                Id accountID = (caseList.get(0)).AccountId;
                
                Account objAccount = [SELECT Id, PatientCreatedInEPIC__c, IsRead__c, COH_MRN__c, LastName, COH_Account_PatientAccess_SSN__c, Gender__pc, Primary_Phone_Number__c, PersonBirthdate FROM Account WHERE Id = :accountID];
                if (objAccount != null)
                {
                    if (objAccount.PatientCreatedInEPIC__c == True)
                    {
                        throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForCreate(): Patient has already been created in EPIC:');
                    }
                    String errMesg = checkRequiredFieldsForCreate(objAccount);
                    if (String.isNotEmpty(errMesg)) {
                        throw new AuraHandledException(errMesg);
                    }
                    
                    if (String.isEmpty(objAccount.COH_MRN__c)) {		// Ensure that legacy records aren't sent to Epic for creation because they already have MRNs but PatientCreatedInEPIC__c is false;
                        objAccount.IsRead__c = False;
                        objAccount.PatientCreatedInEPIC__c = True;
                        update objAccount;                     
                        if (!Test.isRunningTest()) {                            
                            simpleTextPost(caseID, 'Patient information has been sent to Epic. You will receive an email when we receive an MRN.');
                        }
                        bSuccess = true; 
                    } else {
                        throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForCreate(): Legacy patient record already has an assigned MRN: ' + objAccount.COH_MRN__c);
                    }
                }
            }
            else{
                Account objAccount = [SELECT Id, PatientCreatedInEPIC__c, IsRead__c, COH_MRN__c, LastName, COH_Account_PatientAccess_SSN__c, Gender__pc, Primary_Phone_Number__c, PersonBirthdate FROM Account WHERE Id = :caseID];
                if (objAccount != null)
                {
                    String errMesg = checkRequiredFieldsForCreate(objAccount);
                    if (String.isNotEmpty(errMesg)) {
                        throw new AuraHandledException(errMesg);
                    }

                    if (objAccount.COH_MRN__c != null)
                    {                            
                        objAccount.IsRead__c = False;
                        update objAccount;    
                        bSuccess = true; 
                    }
                    else
                    {
                        throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForCreate(): Patient Account does not have MRN, Please wait for the integration to update the MRN:');
                    }
                }
            }
        }
        
        return bSuccess;
    }

    /*
     * Modifies the Account.IsRead__c field is set to false so that Epic can poll for these
     * types records to be updated.  A Chatter post is created if the modification is successful.
     * 
     * @param caseID		ID of the case object.
     * @return				True if the operation completed successfully, false otherwise.
     * 
     */
    @AuraEnabled
    @TestVisible
    public static Boolean modifyDoNotSendFlagForUpdate(Id accountID) {
        Boolean bSuccess = false;
        if (String.isNotEmpty(accountID)) {
            List<Account> accountList = [SELECT Id, IsRead__c, COH_MRN__c FROM Account WHERE Id = :accountID];
			if (COHUtil.isValidList(accountList)) {
				Account objAccount = accountList.get(0);
                if (String.isEmpty(objAccount.COH_MRN__c)) {
					throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForUpdate(): MRN is empty. Send the record to Epic before updating it.');
                }
                objAccount.IsRead__c = false;
                update objAccount;                        
                if (!Test.isRunningTest()) {
                    simpleTextPost(accountID, 'Patient updated in Epic.');
                } 
                bSuccess = true; 
        	} else {
				throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForUpdate(): account record not found');
    	    }
		}
        return bSuccess;
    }

    /*
     * Create a record for EPIC via an URL. A Chatter post is created if the update is successful.
     * 
     * @param caseID	ID of the Case record.
     * @return					New MRN.
     *
     *
     */
    @AuraEnabled 
    public static String createEpicRecordViaURL(Id caseID) {
        String patientMRN = null;
        if (String.isNotEmpty(caseID)) {
               List<Case> caseList = [SELECT AccountId FROM Case WHERE Id = :caseID];
                if (COHUtil.isValidList(caseList)) {
                    Id accountID = (caseList.get(0)).AccountId;
                    String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Account') + ' where Id = :accountID';
                    List<Account> accountList = Database.query(soqlQuery);
                    if (COHUtil.isValidList(accountList)) {
                        Account accountObj = accountList.get(0);
                        if (String.isEmpty(accountObj.FirstName)) {
							throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): the First Name field in the Account record cannot be empty');
                        }
                        //FS 20210401 This will not be needed in new API verion
                        //if (accountObj.PatientCreatedInEPIC__c == True) {
						//	throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Patient has already been created in EPIC');
                        //}
                        //FS 20210401 This is code that was later on down the road but needs to be moved up
                        if (String.isNotEmpty(accountObj.COH_MRN__c)) {
							throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Patient has already has an MRN ('+accountObj.COH_MRN__c+')');
                        }
                        
                        String errMesg = checkRequiredFieldsForCreate(accountObj);
                        if (String.isNotEmpty(errMesg)) {
                            throw new AuraHandledException(errMesg);
                        }
                        //////////////////////////// LookupEpicRecord START ////////////////////////////
                        //FS Added 20210401 Calls LookupEpicRecord API based on First, Last and Birthdate
                        String retVal = LookupEpicRecord(accountObj);
                        system.debug('LookupEpicRecord retVal='+retVal);
                        LIST<String> SearchResult = new LIST<String>();
                        String[] StrArr = retVal.split(';');
                        SearchResult.add(StrArr[0]);//records returned
                        SearchResult.add(StrArr[1]);//records returned
                        mSearchRecordCount = Integer.valueOf(SearchResult[0]);
                        mSearchMRN = SearchResult[1];
                        system.debug('mSearchRecordCount='+mSearchRecordCount);
                        //if mSearchRecordCount is greater than zero, where is duplicate in Epic
                        if (mSearchRecordCount >= 1) {
                           String FirstName = accountObj.FirstName;
                           String LastName = accountObj.LastName;
                           Date PersonBirthDate = accountObj.PersonBirthdate; 
	                       String errMsg = 'Patient ' + FirstName + ' ' + LastName + ', Birthdate ' + PersonBirthdate + ' was found in Epic with the MRN ' + mSearchMRN;
                           throw new AuraHandledException(errMsg);
                        }
                        //////////////////////////// LookupEpicRecord STOP ////////////////////////////
                        
                        if (String.isEmpty(accountObj.COH_MRN__c)) {
                            
                            // Reverse order of the JSON output because the JSON class seems to use LIFO.
                            Map<String, Object> JSONFinalMap = new Map<String, Object>();
                            JSONFinalMap.put('Address', buildCreateAddressSection(accountObj));
                            JSONFinalMap.put('Name', buildCreateNameSection(accountObj));
                            JSONFinalMap = buildCreateHeaderSection(JSONFinalMap, accountObj);
                            
                            // JSON.serialize
                            String jsonStr = JSON.serialize(JSONFinalMap);
							System.debug('JSON.serialize(JSONFinalMap) jsonStr='+jsonStr);//FS 20210318                                       

                            Http httpObj = new Http();                    
                            HttpRequest httpRequestObj = new HttpRequest();
                      
                            // Authorization
                            system.debug('headValue preview='+mEpicUserName + ':' + mEpicPassword);
                            Blob headerValue = Blob.valueOf(mEpicUserName + ':' + mEpicPassword);
                            String authorizationHeader = BASIC_AUTHORIZATION + EncodingUtil.base64Encode(headerValue);
							system.debug('authorizationHeader='+authorizationHeader);
                            httpRequestObj.setHeader(AUTHORIZATION_KEY, authorizationHeader);
                            httpRequestObj.setHeader(CONTENT_TYPE_KEY, CONTENT_TYPE_VALUE);
                            httpRequestObj.setHeader(ACCEPT_KEY, ACCEPT_VALUE);
                            httpRequestObj.setHeader(CHARSET_KEY, CHARSET_VALUE);
                            httpRequestObj.setHeader(EPIC_CLIENT_ID_KEY, mEpicClientID);
                            httpRequestObj.setBody(jsonStr);
                            httpRequestObj.setMethod(POST);
                            httpRequestObj.setEndpoint(mEpicCreateURL);
                            system.debug('setBody = '+ jsonStr);
                            if (!Test.isRunningTest()) {
                                
                                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);                     
                    
                                Integer resultStatusCode = httpResponseObj.getStatusCode();
                                String resultStatus = httpResponseObj.getStatus();
                                System.debug('HttpResponseObj.getBody()='+httpResponseObj.getBody());
                                if (resultStatusCode == OK_STATUS_CODE) {    
                                    PatientInformation patientInfo = (PatientInformation) JSON.deserialize(httpResponseObj.getBody().replace(TYPE_STR, TYPE_Z_STR), PatientInformation.class);
                                    for (PatientIDs ids : patientInfo.PatientIDs) {
                                        if (ids.Type_z == PATIENT_TYPE) {
                                            patientMRN = ids.ID;
                                        }
                                    }
                                    if (patientMRN != null) {
                                        accountObj.COH_MRN__c = patientMRN;
                                        //Updating accountObj.isRead__c so that Corepoint can retrieve additional demographic information from Epic and send it to Salesforce record. LK 02/25/2022
                                        accountObj.isRead__c = false;
                                        try {
                                            update accountObj;
                                        } catch (Exception e) {
                                            throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord() failed to create the account record for MRN: ' + patientMRN + ': ' + e.getMessage());
                                        }
                                        try {
							                if (!Test.isRunningTest()) {
                            	                simpleTextPost(caseID, 'Record created in EPIC. MRN: '+ patientMRN);
                                            }
                                        } catch (Exception e) {
                                            throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord() failed to create a Chatter post for MRN: ' + patientMRN + ': ' + e.getMessage());
                                        }
                                    }
                                } else {
                                    String errMsg = 'Error: COHEpicLightningController.createNewEpicRecord() failed to create a record. Status Code: ' + resultStatusCode + ', Status: ' + httpResponseObj.getStatus();
					                if (!Test.isRunningTest()) {
                                        system.debug('errMsg: '+ errMsg);
                    	                simpleTextPost(caseID, errMsg);
                                    }
                                    throw new AuraHandledException(errMsg);
                                }
                            }
                        } else {
							throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): MRN (' + accountObj.COH_MRN__c + ' ) has already been assigned an Account ID:  ' + accountId);
                        }
                    } else {
                        throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Unable to retrieve the Account record for Account ID:  ' + accountId);
                    }
                }  else {

                	throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Unable to retrieve the Case record for Case ID:  ' + caseID);
            	}
        } else {
            throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): The Case ID cannot be null');
        }
        return patientMRN;
    }


    /*
     * Lookup an existing Epic record via an Lookup URL. 
     *
     * param  @accountObj		From CreateEpicRecord method 
     * return @retStrVal		Semi-Colon separated string
     * 
     */
    //@AuraEnabled
    public static string LookupEpicRecord(Account accountObj) {
    	String mEpicPatientLookupURL_WithParams = mEpicPatientLookupURL + SetLookupCriteria(accountObj);
        system.debug('COHEpicLightningController.LookupEpicRecord mEpicPatientLookupURL_WithParams :='+mEpicPatientLookupURL_WithParams);
        Http httpObj = new Http();                    
        HttpRequest httpRequestObj = new HttpRequest();
        
        // Authorization
        system.debug('headValue preview='+mEpicUserName + ':' + mEpicPassword);
        Blob headerValue = Blob.valueOf(mEpicUserName + ':' + mEpicPassword);
        String authorizationHeader = BASIC_AUTHORIZATION + EncodingUtil.base64Encode(headerValue);
        system.debug('authorizationHeader='+authorizationHeader);
        httpRequestObj.setHeader(AUTHORIZATION_KEY, authorizationHeader);
        httpRequestObj.setHeader(CONTENT_TYPE_KEY, CONTENT_TYPE_VALUE);
        httpRequestObj.setHeader(ACCEPT_KEY, ACCEPT_VALUE);
        httpRequestObj.setHeader(CHARSET_KEY, CHARSET_VALUE);
        httpRequestObj.setHeader(EPIC_CLIENT_ID_KEY, mEpicClientID);
        httpRequestObj.setMethod(GET);
        httpRequestObj.setEndpoint(mEpicPatientLookupURL_WithParams);
        
        
        HttpResponse httpResponseObj = httpObj.send(httpRequestObj);                     
        
        Integer resultStatusCode = httpResponseObj.getStatusCode();
        String resultStatus = httpResponseObj.getStatus();
        System.debug('HttpResponseObj.getBody()='+httpResponseObj.getBody());
        System.debug('resultStatusCode == ' + resultStatusCode);    
        
        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(httpResponseObj.getBody());

        String jsonString = httpResponseObj.getBody();

		Integer recCount = 0; String MRN = '';
		// Parsing of string
        while(parser.nextToken()!= null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                if(parser.getCurrentName() == 'total') {
                    system.debug(parser.getCurrentName() + ' (total)= ' + parser.getText());
                    if (parser.getCurrentName() == 'total') {
                        recCount = parser.getIntegerValue();
                    }
                } else if (parser.getCurrentName() == 'identifier') {
                    system.debug(parser.getText());
                    while(parser.nextToken()!= JSONToken.END_ARRAY) {
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                			parser.nextValue();
                            if(parser.getCurrentName() == 'value') {
                                while(parser.nextToken()!= JSONToken.END_ARRAY) {
			                    	system.debug('parser.getCurrentName()='+ parser.getCurrentName() + ':' + parser.getText());
                                    if (parser.getCurrentName() == 'value') {
                                        MRN = parser.getText();
                                    }
                                }
                            }  
                        } else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {
                            continue;
                        } else if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            continue;
                        }
                    }
                } 
            }
        }
        if (MRN == null || MRN == '') {
            MRN = '0';
        }
        String retValStr = Integer.valueOf(recCount) + ';' + MRN ; 
        system.debug('retValStr='+retValStr);
		return retValStr;
    }
    
    //Create the search parameters for the Patient Lookup URL
    private static string SetLookupCriteria(Account accountObj) {
        string retVal = '';
        String FirstName = accountObj.FirstName;
        FirstName = FirstName.replaceAll('\\s+', '%20');
        String LastName = accountObj.LastName;
        LastName = LastName.replaceAll('\\s+', '+');
        String PersonBirthDate = FormatEpicDate(accountObj.PersonBirthDate);
        String Gender = accountObj.Gender__pc;
        retVal = 'family='+LastName+'&given='+FirstName+'&gender='+Gender+'&birthdate='+PersonBirthDate;
        return retVal;
    }

	//FormatEpicDate - Epic needs this format YYYY-MM-DD    
    private static string FormatEpicDate(Date d) {
        String retVal = '';
        String yr = d.year().format();
        yr = yr.replace(',', '');
        String mo = d.month().format();
        mo = mo.leftPad(2, '0');
        String dy = d.day().format();
        dy = dy.leftPad(2, '0');
        retVal = yr + '-' + mo + '-' + dy;
        return retVal;
    }
	@TestVisible
    private static LIST<String> SplitArray(String input) {
        LIST<String> ListStrArr = new LIST<String>();
        String[] StrArr = input.split(';');
        ListStrArr.add(StrArr[0]);//records returned
        ListStrArr.add(StrArr[1]);//MRN
        return ListStrArr;
    }

    
    /*
     * Update an existing Epic record via an URL. A Chatter post is created if the update is successful.
     * 
     * @param accountID		Account object ID.
     * 
     */
    @AuraEnabled
    public static void updateEpicAccountRecordViaURL(Id accountID) {

        if (String.isNotEmpty(accountID)) {
            String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Account') + ' where Id = :accountID';
            List<Account> accountList = Database.query(soqlQuery);
            if (COHUtil.isValidList(accountList)) {
                Account accountObj = accountList.get(0);
                if (accountObj != null) {
                    if (String.isEmpty(accountObj.COH_MRN__c)) {
                        throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL(): MRN is empty. Send the record to Epic before updating it.');
                    }
                    if (String.isEmpty(accountObj.FirstName)) {
                        throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL(): the First Name field cannot be empty');
                    }
                    
                    // Reverse order of the JSON output because the JSON class seems to use LIFO.
                    Map<String, Object> JSONFinalMap = new Map<String, Object>();
                    JSONFinalMap.put('EmergencyContacts', buildUpdateEmergencyContactsSection());
                    JSONFinalMap.put('ConfidentialAddress', buildUpdateConfidentialAddressSection());
                    JSONFinalMap.put('TemporaryAddress', buildUpdateTempAddressSection());
                    JSONFinalMap.put('ContactInformation', buildUpdateContactSection(accountObj));
                    JSONFinalMap.put('Language', buildUpdateLanguageSection());
                    JSONFinalMap.put('NameComponents', buildUpdateNameSection(accountObj));
					JSONFinalMap.put('PermanentComments', buildUpdatePermanentCommentsSection());
            
                    String jsonStr = JSON.serialize(JSONFinalMap);
            
                    List<String> epicUserNameTokens = (String.isNotEmpty(mEpicUserName) ? mEpicUserName.split('\\$') : null);
                    String endpointUserName = null;
                    if (COHUtil.isValidList(epicUserNameTokens) && epicUserNameTokens.size() == 2) {
                        endpointUserName = epicUserNameTokens.get(1);
                    } else {
                       throw new AuraHandledException('Error: updateEpicRecord(): invalid value for mEpicUserName: ' + mEpicUserName);
                    }
                    Datetime curDateTime = Datetime.now();
                    String formattedLocalDate = curDateTime.format('YYYY-MM-dd');
                    String endpointURL = mEpicUpdateURL + 'PatientID=' + accountObj.COH_MRN__c +
                            '&PatientIDType=' + PATIENT_TYPE + '&UserID=' + endpointUserName + '&UserIDType=' + DEFAULT_USER_ID_TYPE +
                            '&Date=' + formattedLocalDate +'&DepartmentID=' + DEFAULT_DEPT_ID + '&DepartmentIDType=' + DEFAULT_DEPT_TYPE;
            
                    Blob headerValue = Blob.valueOf(mEpicUserName + ':' + mEpicPassword);
                    String authorizationHeader = BASIC_AUTHORIZATION + EncodingUtil.base64Encode(headerValue);
                    
                    HttpRequest httpRequestObj = new HttpRequest();
                    httpRequestObj.setHeader(AUTHORIZATION_KEY, authorizationHeader);
                    httpRequestObj.setHeader(CONTENT_TYPE_KEY, CONTENT_TYPE_VALUE);
                    httpRequestObj.setHeader(ACCEPT_KEY, ACCEPT_VALUE);
                    httpRequestObj.setHeader(CHARSET_KEY, CHARSET_VALUE);
                    httpRequestObj.setBody(jsonStr);
                    httpRequestObj.setMethod(POST);
                    httpRequestObj.setEndpoint(endpointURL);
                    Http httpObj = new Http();
            
                    if (!Test.isRunningTest()) {
                
                        HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
            
                        Integer resultStatusCOde = httpResponseObj.getStatusCode();
                        if (resultStatusCode == OK_STATUS_CODE) {    
							if (!Test.isRunningTest()) {
                                try {
                                    simpleTextPost(accountObj.Id, 'Record updated in EPIC. MRN: '+ accountObj.COH_MRN__c);
                                } catch (Exception e) {
                                    throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL() failed to create a Chatter post for MRN: ' + accountObj.COH_MRN__c + ': ' + e.getMessage());
                                }
                            }
                        } else {
                            throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL() failed to update a record. Status Code: ' + resultStatusCode + ', MRN: ' + accountObj.COH_MRN__c + ', Status: ' + httpResponseObj.getStatus());
                        }    
                    }
                }
            } else {
                throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL(): Unable to retrieve the Account record for Account ID:  ' + accountId);
            }
        } else {
            throw new AuraHandledException('Error: COHEpicLightningController.updateEpicAccountRecordViaURL():  The Account ID cannot be null');
        }
    }
    
    @AuraEnabled
    //Added verifyCreateEpicMRNButton method to verify required fields are null which will in turn disable the "Create Epic MRN" button by returning a true value.
    public static boolean verifyCreateEpicMRNButton(Id caseID){
        //see if account exists

        Case recCase = [Select Id, 
                        casenumber, 
                        accountId, 
                        account.FirstName, 
                        account.LastName, 
                        account.PersonBirthdate, 
                        account.Gender__pc, 
                        account.COH_Account_PatientAccess_SSN__c, 
                        account.PersonEmail, 
                        account.Patient_Street1__c, 
                        account.Patient_City__c, 
                        account.COH_PA_State__c, 
                        account.Patient_Postal_Code__c, 
                        account.COH_PA_Country__c, 
                        account.COH_Account_PatientAccess_Marital_Status__c,
                        account.COH_MRN__c,
                        account.Primary_Phone_Number__c,
                        account.PersonHomePhone,
                        account.PersonMobilePhone,
                        account.PersonOtherPhone,
                        account.Relationship_to_Patient__c,
                        account.Preferred_Language__c
                        from case where Id =: caseID
                       ];
        /*Start Sanjay Singh 02/10/2022*/
        if(recCase.AccountId == null){
            return true;
        } 
        /*End Sanjay Singh 02/10/2022*/               
        system.debug('Account ID : '+ recCase.AccountId);
        /*Sanjay Singh 02/10/2022 changed object to List*/
        /*commented out due to scope change. LK 02/26/2022
        List<Epic_Account_Data__c> recEpicAccountDatas = [Select Id, 
                                                   Authorization_number_1__c, 
                                                   Patient_Relationship_to_Subscriber_1__c, 
                                                   Subscriber_ID_1__c,
                                                   Insurance_Street_1__c,
                                                   Subscriber_Name_1__c,
                                                   Insurance_City_1__c,
                                                   Group_Number_1_c__c,
                                                   Insurance_State_1__c,
                                                   Insurance_SSN_1__c,
                                                   Insurance_PostalCode_1__c,
                                                   Insurance_Gender_1__c,
                                                   Insurance_Birth_Date_1__c,
                                                   Insurance_Country_1__c,
                                                   Guarantor1_FirstName__c,
                                                   Guarantor1_LastName__c,
                                                   Guarantor1_SSN__c,                                                   
                                                   Guarantor1_Street__c,                                                   
                                                   Guarantor1_City__c,                                                   
                                                   Guarantor1_State__c,                                                   
                                                   Guarantor1_PostalCode__c,                                                   
                                                   Guarantor1_Home_Phone__c,
                                                   Guarantor1_Mobile_Phone__c                                                   
                                                   from Epic_Account_Data__c where Account__c =: recCase.AccountId];

        */
        /*Start Sanjay Singh 02/10/2022*/
        if(recCase.account.COH_MRN__c != null){
            return true;
        }
        /*End Sanjay Singh 02/10/2022*/
        else if (
            recCase.account.Primary_Phone_Number__c						== null ||
            recCase.account.FirstName 									== null || 
            recCase.account.LastName			 						== null || 
            recCase.account.PersonBirthdate 							== null || 
            recCase.account.Gender__pc									== null || 
            recCase.account.COH_Account_PatientAccess_SSN__c			== null ||
            //recCase.account.PersonEmail 								== null ||
            recCase.account.Patient_Street1__c 							== null ||
            recCase.account.Patient_City__c 							== null || 
            recCase.account.COH_PA_State__c 							== null ||
            recCase.account.Patient_Postal_Code__c 						== null ||
            recCase.account.COH_PA_Country__c 							== null ||
            recCase.account.Relationship_to_Patient__c					== null ||
            //recCase.account.COH_Account_PatientAccess_Marital_Status__c == null ||
            (
                (recCase.account.Primary_Phone_Number__c == 'Home' && recCase.account.PersonHomePhone		 	== null)|| 
                (recCase.account.Primary_Phone_Number__c == 'Mobile' && recCase.account.PersonMobilePhone 		== null)||
                (recCase.account.Primary_Phone_Number__c == 'Other' && recCase.account.PersonOtherPhone 		== null)
            )
        ){ 
            return true;                    
        }
         /*Start Sanjay Singh 02/10/2022*/
        /* Commented out until Insurance/Guarantor/Provider is resolved with Epic
        if(recEpicAccountDatas.isEmpty()) return true;
         Epic_Account_Data__c recEpicAccountData = recEpicAccountDatas[0];
		*/
        /*End Sanjay Singh 02/10/2022*/
        /*Start below code by Sanjay on 02/10/2022*/
        //else if (recEpicAccountData == null){
        //    return true;
        //}
        //else if (
        /*End Sanjay on 02/10/2022*/    
        /* Commented out until Insurance/Guarantor/Provider is resolved with Epic
        if (                
            recEpicAccountData.Authorization_number_1__c 				== null ||
            recEpicAccountData.Patient_Relationship_to_Subscriber_1__c 	== null ||
            recEpicAccountData.Subscriber_ID_1__c 						== null ||
            recEpicAccountData.Insurance_Street_1__c					== null ||
            recEpicAccountData.Subscriber_Name_1__c						== null ||
            recEpicAccountData.Insurance_City_1__c						== null ||
            recEpicAccountData.Group_Number_1_c__c						== null ||
            recEpicAccountData.Insurance_State_1__c						== null ||
            recEpicAccountData.Insurance_Country_1__c					== null ||
            recEpicAccountData.Insurance_SSN_1__c						== null ||
            recEpicAccountData.Insurance_PostalCode_1__c				== null ||
            recEpicAccountData.Insurance_Gender_1__c					== null ||
            recEpicAccountData.Insurance_Birth_Date_1__c				== null ||
            recEpicAccountData.Guarantor1_FirstName__c					== null ||
            recEpicAccountData.Guarantor1_LastName__c					== null ||
            recEpicAccountData.Guarantor1_SSN__c						== null ||            
            recEpicAccountData.Guarantor1_Street__c						== null ||
            recEpicAccountData.Guarantor1_State__c						== null ||            
            recEpicAccountData.Guarantor1_City__c						== null ||            
            recEpicAccountData.Guarantor1_PostalCode__c					== null ||            
            (
                recEpicAccountData.Guarantor1_Home_Phone__c == null && recEpicAccountData.Guarantor1_Mobile_Phone__c == null)             
        ){
            return true;
        }
		*/
        else { 
            return false;
        }
    }
    
    

    /*
     * Create a Chatter post.
     * 
     * @param userID		User ID for the Chatter post.
     * @param postText		Text of the post.
     *
     */
    public static void simpleTextPost(Id userID, String postText) { 
        FeedItem post = new FeedItem();
        post.ParentId = userID; //eg. Opportunity id, custom object id..
        post.Body = postText;
        insert post;
    }

    /*
     * Retrieves the text value for an active Custom Metadata Item.
     * 
     * @param key		Name of the Custom Metadata item.
     * @return				Value of the  Custom Metadata item.
     * 
     */
    @TestVisible
    private static String getTextConfigurationValue(String key) {
        String returnVal = null;
        if (String.isNotEmpty(key)) {
        	String soqlQuery  = 'select Value__c from COH_Configuration__mdt where Application_Name__c = :EPIC_INTEGRATION and DeveloperName = :key and Is_Active__c = true';
            List<COH_Configuration__mdt> retValList = Database.query(soqlQuery);
            if (COHUtil.isValidList(retValList)) {
                COH_Configuration__mdt configObj = retValList.get(0);
                returnVal = configObj.Value__c;
            }
        }
        return returnVal;
    }

    /*
     * Build the header information for the Create record JSON header.
     * 
     * @param jsonMap		JSON map where the header information will be stored.
     * @param accountObj	Account object.
     * @return						Map containing the mappings for the JSON header.
     * 
     */
    private static Map<String, Object> buildCreateHeaderSection(Map<String, Object> jsonMap, Account accountObj) {
        if (jsonMap != null) {
            jsonMap.put('Religion', accountObj.COH_PA_Religion__c);
            jsonMap.put('Race', accountObj.Race__c);
            jsonMap.put('MaritalStatus', accountObj.COH_Account_PatientAccess_Marital_Status__c);
            jsonMap.put('Gender', accountObj.Gender__pc);
            jsonMap.put('DateOfBirth', String.valueOf(accountObj.PersonBirthdate) );
            jsonMap.put('NationalIdentifier', accountObj.COH_Account_PatientAccess_SSN__c);
            jsonMap.put('DepartmentIDType', DEFAULT_DEPT_TYPE);
            jsonMap.put('DepartmentID', DEFAULT_DEPT_ID);
        }
        return jsonMap;
    }
    
    /*
     * Build the Name section for the Create record JSON message.
     * 
     * @param accountObj	Account object.
     * @return						Map containing the mappings for the JSON name section.
     * 
     */

    private static Map<String, String> buildCreateNameSection(Account accountObj) {
    
        Map<String, String> returnMap = new Map<String, String>();
        returnMap.put('GivenNameInitials', null);
        returnMap.put('SpouseLastNameFirst', null);
        returnMap.put('PreferredNameType', null);
        returnMap.put('PreferredName', null); // resume here
        returnMap.put('Academic', null);
		returnMap.put('Suffix', accountObj.Patient_Suffix__c);
        returnMap.put('Title', accountObj.Title__c);
        returnMap.put('SpouseLastNamePrefix', null);
        returnMap.put('SpouseLastNamePrefix', null);
        returnMap.put( 'LastNamePrefix', null);
        //returnMap.put('Middle', accountObj.Middle_Name__c);
        returnMap.put('Middle', accountObj.MiddleName);
        returnMap.put('First', accountObj.FirstName);
        returnMap.put('LastName', accountObj.LastName);

        return returnMap;
    }

    /*
     * Build the Address section for the Create record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				Map containing the mappings for the JSON address section.
     * 
     */
    private static Map<String, Object> buildCreateAddressSection(Account accountObj) {
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('Phones', buildCreatePhoneSection(accountObj));
        returnMap.put('StreetLine2', null);
        returnMap.put('Email', accountObj.PersonEmail);
        returnMap.put('Country', accountObj.COH_PA_Country__c);
        returnMap.put('County', null);
        returnMap.put('ZipCode', accountObj.Patient_Postal_Code__c);
        returnMap.put('State', accountObj.COH_PA_State__c);
        returnMap.put('City', accountObj.Patient_City__c);
        returnMap.put('HouseNumber', null);
        returnMap.put('Street', accountObj.Patient_Street1__c);
        
        return returnMap;
    }
        
    /*
     * Build the Phone section for the  Create record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				List of maps where each one contains the sub-mappings for the JSON phone section.
     * 
     */
    private static List<Map<String, String>> buildCreatePhoneSection(Account accountObj) {
        String jsonPhoneType = 'Type';
        String jsonPhoneNumber = 'Number';
        String jsonHomePhone = 'Home Phone';
        String jsonWorkPhone = 'Work Phone';    
        String jsonMobilePhone = 'Mobile';

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Map<String, String> JSONHomePhoneMap = new Map<String, String>();
        JSONHomePhoneMap.put(jsonPhoneNumber, (accountObj != null ? accountObj.PersonHomePhone : null)); 
        JSONHomePhoneMap.put(jsonPhoneType, jsonHomePhone);
        returnList.add(JSONHomePhoneMap);
        
        Map<String, String> JSONMobilePhoneMap = new Map<String, String>();
        JSONMobilePhoneMap.put(jsonPhoneNumber, (accountObj != null ? accountObj.PersonMobilePhone : null));
        JSONMobilePhoneMap.put(jsonPhoneType, jsonMobilePhone);
        returnList.add(JSONMobilePhoneMap);
        
        Map<String, String> JSONWorkPhoneMap = new Map<String, String>();
        JSONWorkPhoneMap.put(jsonPhoneNumber, (accountObj != null ? accountObj.PersonOtherPhone : null));
        JSONWorkPhoneMap.put(jsonPhoneType, jsonWorkPhone);
        returnList.add(JSONWorkPhoneMap);

        return returnList;
    }
    
    /*
     * Inner Class used for deserializing a JSON string.
     * 
     */
    public class PatientInformation {
        public List<PatientIDs> PatientIDs {get; set;}
    }

    /*
     * Inner Class used for deserializing a JSON string.
     * 
     */
    public class PatientIDs {
        public String ID {get;set;}
        public String Type_z {get;set;}
    }    
    
    /*
     * Build the Permanent Comments section for the Update record JSON message.
     * 
     * @return				Map containing the mappings for the JSON Permanent Comments section.
     * 
     */
    private static List<String> buildUpdatePermanentCommentsSection() {
        return new List<String> {null, null};
    }    

    /*
     * Build the Name section for the Update record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				Map containing the mappings for the JSON Name section.
     * 
     */
    private static Map<String, String> buildUpdateNameSection(Account accountObj) {
        Map<String, String> returnMap = new Map<String, String>();
        returnMap.put('PreferredNameType', null);
        returnMap.put('PreferredName', null);
        returnMap.put('NameSuffix', null);
        returnMap.put('NameTitle', null);
        returnMap.put('MiddleName', null);
        returnMap.put('FirstName', null);
        returnMap.put('LastName', null);

        return returnMap;
    }    

    /*
     * Build the Language section for the Update record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				Map containing the mappings for the JSON Language section.
     * 
     */
    private static Map<String, Object>  buildUpdateLanguageSection() {
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('Written',  new List<String> {null, null});
        returnMap.put('Spoken',  new List<String> {null, null});
        returnMap.put('InterpreterNeeded', null);
        returnMap.put('Preferred', null);
        return returnMap;
    }    

    /*
     * Build the Contact section for the Update record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				Map containing the mappings for the JSON Contact section.
     * 
     */
    private static Map<String, Object> buildUpdateContactSection(Account accountObj) {
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('PhoneNumbers', buildUpdatePhoneSection(accountObj));
        returnMap.put('Address', buildUpdateAddressSection(accountObj));
        returnMap.put('Comments', new List<String> {null, null}); 
        String emailAddress = accountObj.PersonEmail;
        // Epic doesn't like an array of null values. It regards null values as invalid email addresses instead of ignoring them.
        if (String.isNotEmpty(emailAddress))  {
			returnMap.put('EmailAddresses', new List<String> {accountObj.PersonEmail}); 
        } else {
			returnMap.put('EmailAddresses', new List<String>()); 
        }
        return returnMap;
    }
        
    /*
     * Build the Address section for the Update record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				Map containing the mappings for the JSON address section.
     * 
     */
    private static Map<String, Object> buildUpdateAddressSection(Account accountObj) {
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('County', null);
        returnMap.put('Country', accountObj.COH_PA_Country__c);
        returnMap.put('Zip', accountObj.Patient_Postal_Code__c);
        returnMap.put('State', accountObj.COH_PA_State__c);
        returnMap.put('City', accountObj.Patient_City__c);
        returnMap.put('Street', new List<String> {accountObj.Patient_Street1__c, null});
        
        return returnMap;
    }
        
    /*
     * Build the Phone section for the  Update record JSON message.
     * 
     * @param accountObj	Account object.
     * @return				List of maps where each one contains the sub-mappings for the JSON Phone section.
     * 
     */
    private static List<Map<String, String>> buildUpdatePhoneSection(Account accountObj) {
        String jsonPhoneType = 'Type';
        String jsonPhoneNumber = 'Number';
        String jsonHomePhone = 'Home Phone';
        String jsonWorkPhone = 'Work Phone';    
        String jsonMobilePhone = 'Mobile';
        String jsonPriority = 'Priority';
        String jsonNotes = 'Notes';
        String jsonStartDay = 'StartDay';
        String jsonStartTime = 'StartTime';
        String jsonEndDay = 'EndDay';
        String jsonEndTime = 'EndTime';

        List<Map<String, String>> returnList = new List<Map<String, String>>();
        Map<String, String> JSONHomePhoneMap = new Map<String, String>();
        JSONHomePhoneMap.put(jsonEndTime, null);
        JSONHomePhoneMap.put(jsonEndDay, null);
        JSONHomePhoneMap.put(jsonStartTime, null);
        JSONHomePhoneMap.put(jsonStartDay, null);
        JSONHomePhoneMap.put(jsonNotes, null);
        JSONHomePhoneMap.put(jsonPriority, null);
        JSONHomePhoneMap.put(jsonPhoneNumber, accountObj.PersonHomePhone);
        JSONHomePhoneMap.put(jsonPhoneType, jsonHomePhone);
        returnList.add(JSONHomePhoneMap);
        
        Map<String, String> JSONWorkPhoneMap = new Map<String, String>();
        JSONWorkPhoneMap.put(jsonEndTime, null);
        JSONWorkPhoneMap.put(jsonEndDay, null);
        JSONWorkPhoneMap.put(jsonStartTime, null);
        JSONWorkPhoneMap.put(jsonStartDay, null);
        JSONWorkPhoneMap.put(jsonNotes, null);
        JSONWorkPhoneMap.put(jsonPriority, null);
        JSONWorkPhoneMap.put(jsonPhoneNumber, accountObj.PersonOtherPhone);
        JSONWorkPhoneMap.put(jsonPhoneType, jsonWorkPhone);
        returnList.add(JSONWorkPhoneMap);

        Map<String, String> JSONMobilePhoneMap = new Map<String, String>();
        JSONMobilePhoneMap.put(jsonEndTime, null);
        JSONMobilePhoneMap.put(jsonEndDay, null);
        JSONMobilePhoneMap.put(jsonStartTime, null);
        JSONMobilePhoneMap.put(jsonStartDay, null);
        JSONMobilePhoneMap.put(jsonNotes, null);
        JSONMobilePhoneMap.put(jsonPriority, null);
        JSONMobilePhoneMap.put(jsonPhoneNumber, accountObj.PersonMobilePhone );
        JSONMobilePhoneMap.put(jsonPhoneType, jsonMobilePhone);
        returnList.add(JSONMobilePhoneMap);
        
        return returnList;
    }

    /*
     * Build the Temp Address section for the Update record JSON message.
     * 
     * @return				Map containing the mappings for the JSON Temp Address section.
     * 
     */
    private static Map<String, Object> buildUpdateTempAddressSection() {
        
        Map<String, Object> tempAddressMap = new Map<String, Object>();
        tempAddressMap.put('County', null);
        tempAddressMap.put('Country', null);
        tempAddressMap.put('Zip', null);
        tempAddressMap.put('State', null);
        tempAddressMap.put('City', null);
        tempAddressMap.put('Street', new List<String> {null, null});
        
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('Address', tempAddressMap);
        returnMap.put('Comments', new List<String> {null, null});
        returnMap.put('Phone', null);
        returnMap.put('CareOf', null);
        returnMap.put('EndDate', null);
        returnMap.put('StartDate', null);
        
        return returnMap;
    }
    
    /*
     * Build the Confidential Address section for the Update record JSON message.
     * 
     * @return				Map containing the mappings for the JSON Confidential Address section.
     * 
     */
    private static Map<String, Object> buildUpdateConfidentialAddressSection() {

        String jsonEndTime = 'EndTime';
        String jsonEndDay = 'EndDay';
        String jsonStartTime = 'StartTime';
        String jsonStartDay= 'StartDay';
        String jsonNotes = 'Notes';
        String jsonPriority = 'Priority';
        String jsonNumber = 'Number';
        String jsonType = 'Type';

        List<Map<String, String>> phoneList = new List<Map<String, String>>();
        Map<String, String> phoneMap0 = new Map<String, String>();
        phoneMap0.put('EndTime', null);
        phoneMap0.put('EndDay', null);
        phoneMap0.put('StartTime', null);
        phoneMap0.put('StartDay', null);
        phoneMap0.put('Notes', null);
        phoneMap0.put('Priority', null);
        phoneMap0.put('Number', null);
        phoneMap0.put('Type', null);
        phoneList.add(phoneMap0);
       
        Map<String, String> phoneMap1 = new Map<String, String>(phoneMap0);
        phoneList.add(phoneMap1);
       
        Map<String, String> phoneMap2 = new Map<String, String>(phoneMap0);
        phoneList.add(phoneMap2);
       
        Map<String, Object> tempAddressMap = new Map<String, Object>();
        tempAddressMap.put('County', null);
        tempAddressMap.put('Country', null);
        tempAddressMap.put('Zip', null);
        tempAddressMap.put('State', null);
        tempAddressMap.put('City', null);
        tempAddressMap.put('Street', new List<String> {null, null});
        
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('PhoneNumbers', phoneList);
        returnMap.put('Address', tempAddressMap);
        returnMap.put('ContactName', null);
        returnMap.put('EndDate', null);
        returnMap.put('StartDate', null);
        
        return returnMap;
    }
    
    /*
     * Build the Emergency Contacts section for the Update record JSON message.
     * 
     * @return				List of Maps containing the mappings for the JSON Emergency Contacts section.
     * 
     */
    private static List<Map<String, Object>> buildUpdateEmergencyContactsSection() {

        String jsonEndTime = 'EndTime';
        String jsonEndDay = 'EndDay';
        String jsonStartTime = 'StartTime';
        String jsonStartDay= 'StartDay';
        String jsonNotes = 'Notes';
        String jsonPriority = 'Priority';
        String jsonNumber = 'Number';
        String jsonType = 'Type';

        List<Map<String, String>> phoneList = new List<Map<String, String>>();
        Map<String, String> phoneMap0 = new Map<String, String>();
        phoneMap0.put('EndTime', null);
        phoneMap0.put('EndDay', null);
        phoneMap0.put('StartTime', null);
        phoneMap0.put('StartDay', null);
        phoneMap0.put('Notes', null);
        phoneMap0.put('Priority', null);
        phoneMap0.put('Number', null);
        phoneMap0.put('Type', null);
        phoneList.add(phoneMap0);
       
        Map<String, String> phoneMap1 = new Map<String, String>(phoneMap0);
        phoneList.add(phoneMap1);
       
        Map<String, String> phoneMap2 = new Map<String, String>(phoneMap0);
        phoneList.add(phoneMap2);
       
        Map<String, Object> tempAddressMap = new Map<String, Object>();
        tempAddressMap.put('County', null);
        tempAddressMap.put('Country', null);
        tempAddressMap.put('Zip', null);
        tempAddressMap.put('State', null);
        tempAddressMap.put('City', null);
        tempAddressMap.put('Street', new List<String> {null, null});

        Map<String, Object> emergencyContactDetailMap0 = new Map<String, Object>();
        emergencyContactDetailMap0.put('PhoneNumbers', phoneList);
        emergencyContactDetailMap0.put('Address', tempAddressMap);
        emergencyContactDetailMap0.put('PrimaryPhoneType', null);
        emergencyContactDetailMap0.put('Type', null);
        emergencyContactDetailMap0.put('LegalGuardian', null);
        emergencyContactDetailMap0.put('Name', null);
        
        Map<String, Object> emergencyContactDetailMap1 = new Map<String, Object>(emergencyContactDetailMap0);
        return new List<Map<String, Object>> {emergencyContactDetailMap0, emergencyContactDetailMap1};
            
    }
 
    /*
     * Checks the required fields for creating a new record.
     * 
     * @param accountObj		Account record to validate.
     * @return							Error string if errors were encountered, null otherwise.
     * 
     */
    private static String checkRequiredFieldsForCreate(Account accountObj) {
        String retVal = null;
        List<String> errors = new List<String>();
        if (accountObj != null) {
            if (String.isEmpty(accountObj.LastName)) {
                errors.add('LastName cannot be empty');
            }
            if (String.isEmpty(accountObj.COH_Account_PatientAccess_SSN__c)) {
	            errors.add('SSN cannot be empty');
            }
            if (String.isEmpty(accountObj.Gender__pc)) {
	            errors.add('Gender cannot be empty');
            }
            if (String.isEmpty(accountObj.Primary_Phone_Number__c)) {
	            errors.add('Primary Phone Number cannot be empty');
            }
            if (accountObj.PersonBirthdate == null) {
	            errors.add('Birthdate cannot be empty');
            }
        } else {
            errors.add('Null accountObj');
        }

        if (COHUtil.isValidList(errors)) {
            retVal = 'Error: COHEpicLightningController.checkRequiredFieldsForCreate()';
            for (String errMesg : errors) {
                retVal += '\n'+ errMesg;
            }
        }
        return retVal;
    }
    
    /*
     * Sets the Epic endpoint URLs for testing purposes.
     * 
     * @param		createEndPointURL		URL for the creation of a record.
     * @param		updateEndPointURL		URL for the creation of a record.
     * 
     */
	@TestVisible
    private static void setTestEpicEndPointURLS(String createEndPointURL, String updateEndPointURL) {
        mEpicCreateURL = createEndPointURL;
        mEpicUpdateURL = updateEndPointURL;
    }
    /*
     * Sets the Epic username and password for testing purposes.
     * 
     * @param epicUserName		Epic user name.
     * @param epicPassword		Epic password.
     * 
     */
	@TestVisible
    private static void setTestEpicLoginCredentials(String epicUserName, String epicPassword) {
        mEpicUserName = epicUserName;
        mEpicPassword = epicPassword;
    }
    /*START: Changes by Sanjay 02/09/2022*/
    @AuraEnabled
    public static string createNewEpicRecordViaAccount(Id accountId) {
        if (String.isEmpty(mEpicCreateURL)) {
            Boolean boolRetVal = modifyDoNotSendFlagForCreateViaAccount(accountId);
            return (boolRetVal == true ? 'true' : 'false');
        }
        String patientMRN;
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Account') + ' where Id = :accountID';
        List<Account> accountList = Database.query(soqlQuery);
        if (COHUtil.isValidList(accountList)) {
            Account accountObj = accountList.get(0);
            if (String.isEmpty(accountObj.FirstName)) {
                throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): the First Name field in the Account record cannot be empty');
            }
            //FS 20210401 This will not be needed in new API verion
            //if (accountObj.PatientCreatedInEPIC__c == True) {
            //	throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Patient has already been created in EPIC');
            //}
            //FS 20210401 This is code that was later on down the road but needs to be moved up
            if (String.isNotEmpty(accountObj.COH_MRN__c)) {
                throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Patient has already has an MRN ('+accountObj.COH_MRN__c+')');
            }
            
            String errMesg = checkRequiredFieldsForCreate(accountObj);
            if (String.isNotEmpty(errMesg)) {
                throw new AuraHandledException(errMesg);
            }
            //////////////////////////// LookupEpicRecord START ////////////////////////////
            //FS Added 20210401 Calls LookupEpicRecord API based on First, Last and Birthdate
            String retVal = LookupEpicRecord(accountObj);
            system.debug('LookupEpicRecord retVal='+retVal);
            LIST<String> SearchResult = new LIST<String>();
            String[] StrArr = retVal.split(';');
            SearchResult.add(StrArr[0]);//records returned
            SearchResult.add(StrArr[1]);//records returned
            mSearchRecordCount = Integer.valueOf(SearchResult[0]);
            mSearchMRN = SearchResult[1];
            system.debug('mSearchRecordCount='+mSearchRecordCount);
            //if mSearchRecordCount is greater than zero, where is duplicate in Epic
            if (mSearchRecordCount >= 1) {
                String FirstName = accountObj.FirstName;
                String LastName = accountObj.LastName;
                Date PersonBirthDate = accountObj.PersonBirthdate; 
                String errMsg = 'Patient ' + FirstName + ' ' + LastName + ', Birthdate ' + PersonBirthdate + ' was found in Epic with the MRN ' + mSearchMRN;
                throw new AuraHandledException(errMsg);
            }
            //////////////////////////// LookupEpicRecord STOP ////////////////////////////
            
            if (String.isEmpty(accountObj.COH_MRN__c)) {
                
                // Reverse order of the JSON output because the JSON class seems to use LIFO.
                Map<String, Object> JSONFinalMap = new Map<String, Object>();
                JSONFinalMap.put('Address', buildCreateAddressSection(accountObj));
                JSONFinalMap.put('Name', buildCreateNameSection(accountObj));
                JSONFinalMap = buildCreateHeaderSection(JSONFinalMap, accountObj);
                
                // JSON.serialize
                String jsonStr = JSON.serialize(JSONFinalMap);
                System.debug('JSON.serialize(JSONFinalMap) jsonStr='+jsonStr);//FS 20210318                                       
                
                Http httpObj = new Http();                    
                HttpRequest httpRequestObj = new HttpRequest();
                
                // Authorization
                system.debug('headValue preview='+mEpicUserName + ':' + mEpicPassword);
                Blob headerValue = Blob.valueOf(mEpicUserName + ':' + mEpicPassword);
                String authorizationHeader = BASIC_AUTHORIZATION + EncodingUtil.base64Encode(headerValue);
                system.debug('authorizationHeader='+authorizationHeader);
                httpRequestObj.setHeader(AUTHORIZATION_KEY, authorizationHeader);
                httpRequestObj.setHeader(CONTENT_TYPE_KEY, CONTENT_TYPE_VALUE);
                httpRequestObj.setHeader(ACCEPT_KEY, ACCEPT_VALUE);
                httpRequestObj.setHeader(CHARSET_KEY, CHARSET_VALUE);
                httpRequestObj.setHeader(EPIC_CLIENT_ID_KEY, mEpicClientID);
                httpRequestObj.setBody(jsonStr);
                httpRequestObj.setMethod(POST);
                httpRequestObj.setEndpoint(mEpicCreateURL);
                
                if (!Test.isRunningTest()) {
                    
                    HttpResponse httpResponseObj = httpObj.send(httpRequestObj);                     
                    
                    Integer resultStatusCode = httpResponseObj.getStatusCode();
                    String resultStatus = httpResponseObj.getStatus();
                    System.debug('HttpResponseObj.getBody()='+httpResponseObj.getBody());
                    if (resultStatusCode == OK_STATUS_CODE) {    
                        PatientInformation patientInfo = (PatientInformation) JSON.deserialize(httpResponseObj.getBody().replace(TYPE_STR, TYPE_Z_STR), PatientInformation.class);
                        for (PatientIDs ids : patientInfo.PatientIDs) {
                            if (ids.Type_z == PATIENT_TYPE) {
                                patientMRN = ids.ID;
                            }
                        }
                        if (patientMRN != null) {
                            accountObj.COH_MRN__c = patientMRN;
                            try {
                                update accountObj;
                            } catch (Exception e) {
                                throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord() failed to create the account record for MRN: ' + patientMRN + ': ' + e.getMessage());
                            }
                        }
                    } else {
                        String errMsg = 'Error: COHEpicLightningController.createNewEpicRecord() failed to create a record. Status Code: ' + resultStatusCode + ', Status: ' + httpResponseObj.getStatus();
                        throw new AuraHandledException(errMsg);
                    }
                }
            } else {
                throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): MRN (' + accountObj.COH_MRN__c + ' ) has already been assigned an Account ID:  ' + accountId);
            }
        } else {
            throw new AuraHandledException('Error: COHEpicLightningController.createNewEpicRecord(): Unable to retrieve the Account record for Account ID:  ' + accountId);
        }
        List<Case> lstCases = [Select Id from Case where AccountId =: accountId and Status = 'New'];
        if(lstCases.size() > 0){
            update lstCases;
        }
        
        return patientMRN;
    }
    
    @AuraEnabled
    @TestVisible
    public static Boolean modifyDoNotSendFlagForCreateViaAccount(Id accountId) {
        Boolean bSuccess;
        
        Account objAccount = [SELECT Id, PatientCreatedInEPIC__c, IsRead__c, COH_MRN__c, LastName, COH_Account_PatientAccess_SSN__c, Gender__pc, Primary_Phone_Number__c, PersonBirthdate FROM Account WHERE Id = :accountID];
        if (objAccount != null)
        {
            if (objAccount.PatientCreatedInEPIC__c == True)
            {
                throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForCreate(): Patient has already been created in EPIC:');
            }
            String errMesg = checkRequiredFieldsForCreate(objAccount);
            if (String.isNotEmpty(errMesg)) {
                throw new AuraHandledException(errMesg);
            }
            
            if (String.isEmpty(objAccount.COH_MRN__c)) {		// Ensure that legacy records aren't sent to Epic for creation because they already have MRNs but PatientCreatedInEPIC__c is false;
                objAccount.IsRead__c = False;
                objAccount.PatientCreatedInEPIC__c = True;
                update objAccount;                     
                if (!Test.isRunningTest()) {                            
                    simpleTextPost(accountID, 'Patient information has been sent to Epic. You will receive an email when we receive an MRN.');
                }
                bSuccess = true; 
            } else {
                throw new AuraHandledException('Error: COHEpicLightningController.modifyDoNotSendFlagForCreate(): Legacy patient record already has an assigned MRN: ' + objAccount.COH_MRN__c);
            }
        }
        
        return bSuccess;
    }
    /*END: Changes by Sanjay 02/09/2022*/
    
/*START:Changes by Sanjay 02/15/2022*/
@AuraEnabled
//Added verifyAccountCreateEpicMRNButton method for Account to verify required
//fields are null which will in turn disable the "Create Epic MRN" button by returning a true value.
public static boolean verifyAccountCreateEpicMRNButton(Id accountId){
    //see if case exists
    List<Case> cases = [SELECT Id FROM Case WHERE AccountId=:accountId];
    if(cases.isEmpty()) return true;
    Account account = [Select Id,
                       FirstName, 
                       LastName, 
                       PersonBirthdate, 
                       Gender__pc, 
                       COH_Account_PatientAccess_SSN__c, 
                       PersonEmail, 
                       Patient_Street1__c, 
                       Patient_City__c, 
                       COH_PA_State__c, 
                       Patient_Postal_Code__c, 
                       COH_PA_Country__c, 
                       COH_Account_PatientAccess_Marital_Status__c,
                       COH_MRN__c,
                       Primary_Phone_Number__c,
                       PersonHomePhone,
                       PersonMobilePhone,
                       PersonOtherPhone,
                       Relationship_to_Patient__c,
                       Preferred_Language__c
                       from Account where Id =: accountId
                      ];
    if(account.COH_MRN__c <> null) return true;
    /* Removing due to requirement updates LK 03/08/2022 Removing Insurance and Guarantor from Requirement.
    List<Epic_Account_Data__c> recEpicAccountDatas = [Select Id, 
                                                      Authorization_number_1__c, 
                                                      Patient_Relationship_to_Subscriber_1__c, 
                                                      Subscriber_ID_1__c,
                                                      Insurance_Street_1__c,
                                                      Subscriber_Name_1__c,
                                                      Insurance_City_1__c,
                                                      Group_Number_1_c__c,
                                                      Insurance_State_1__c,
                                                      Insurance_SSN_1__c,
                                                      Insurance_PostalCode_1__c,
                                                      Insurance_Gender_1__c,
                                                      Insurance_Birth_Date_1__c,
                                                      Insurance_Country_1__c,
                                                      Guarantor1_FirstName__c,
                                                      Guarantor1_LastName__c,
                                                      Guarantor1_SSN__c,
                                                      Guarantor1_Street__c,
                                                      Guarantor1_City__c,                                                   
                                                      Guarantor1_State__c,                                                   
                                                      Guarantor1_PostalCode__c,                                                   
                                                      Guarantor1_Home_Phone__c,
                                                      Guarantor1_Mobile_Phone__c                                                   
                                                      from Epic_Account_Data__c where Account__c =: accountId];
    
    */
    
    if (
        account.Primary_Phone_Number__c                     == null ||
        account.FirstName                                   == null || 
        account.LastName                                    == null || 
        account.PersonBirthdate                             == null || 
        account.Gender__pc                                  == null || 
        account.COH_Account_PatientAccess_SSN__c            == null ||
        //account.PersonEmail                                 == null ||
        account.Patient_Street1__c                          == null ||
        account.Patient_City__c                             == null || 
        account.COH_PA_State__c                             == null ||
        account.Patient_Postal_Code__c                      == null ||
        account.COH_PA_Country__c                           == null ||
        account.Relationship_to_Patient__c                  == null ||
        //account.COH_Account_PatientAccess_Marital_Status__c == null ||
        (
            (account.Primary_Phone_Number__c == 'Home' && account.PersonHomePhone           == null)|| 
            (account.Primary_Phone_Number__c == 'Mobile' && account.PersonMobilePhone       == null)||
            (account.Primary_Phone_Number__c == 'Other' && account.PersonOtherPhone         == null)
        )
    ){ 
        return true;                    
    }
    /*Requirement update per Frank. Removing due to requirement updates LK 03/08/2022 Removing Insurance and Guarantor from Requirement.
    if(recEpicAccountDatas.isEmpty()) return true;
    Epic_Account_Data__c recEpicAccountData = recEpicAccountDatas[0];
    if (                
        recEpicAccountData.Authorization_number_1__c                == null ||
        recEpicAccountData.Patient_Relationship_to_Subscriber_1__c  == null ||
        recEpicAccountData.Subscriber_ID_1__c                       == null ||
        recEpicAccountData.Insurance_Street_1__c                    == null ||
        recEpicAccountData.Subscriber_Name_1__c                     == null ||
        recEpicAccountData.Insurance_City_1__c                      == null ||
        recEpicAccountData.Group_Number_1_c__c                      == null ||
        recEpicAccountData.Insurance_State_1__c                     == null ||
        recEpicAccountData.Insurance_Country_1__c                   == null ||
        recEpicAccountData.Insurance_SSN_1__c                       == null ||
        recEpicAccountData.Insurance_PostalCode_1__c                == null ||
        recEpicAccountData.Insurance_Gender_1__c                    == null ||
        recEpicAccountData.Insurance_Birth_Date_1__c                == null ||
        recEpicAccountData.Guarantor1_FirstName__c                  == null ||
        recEpicAccountData.Guarantor1_LastName__c                   == null ||
        recEpicAccountData.Guarantor1_SSN__c                        == null ||            
        recEpicAccountData.Guarantor1_Street__c                     == null ||
        recEpicAccountData.Guarantor1_State__c                      == null ||            
        recEpicAccountData.Guarantor1_City__c                       == null ||            
        recEpicAccountData.Guarantor1_PostalCode__c                 == null ||            
        (recEpicAccountData.Guarantor1_Home_Phone__c == null && recEpicAccountData.Guarantor1_Mobile_Phone__c == null)             
    ){
        return true;
    } */
    return false;
}
/*END: Changes by Sanjay 02/15/2022*/ 
    
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
                       Line_of_Business_Decision_Tree__c,Does_patient_have_auth_at_time_of_schedu__c,
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
            /*mapWithFormNameAndErrors.put('appointmentInformation',new List<String>());
            List<String> appointmentInfo = mapWithFormNameAndErrors.get('appointmentInformation');
            if(String.isNotBlank(Record.Coh_mrn__c)){   
                if(String.isNotBlank(Record.Last_Appointment_Scheduled__c)){
                    if(String.isBlank(Record.Consenting_Status__c)){
                        appointmentInfo.add('Consenting Status is a required field'); 
                        isErrorInForm  = true;
                    } 
                    if(String.isBlank(Record.Consenting_Type__c)){
                        appointmentInfo.add('Consenting Type is a required field');
                        isErrorInForm  = true;
                    }
                    if(String.isBlank(Record.Visit_Type_Preference__c)){
                        appointmentInfo.add('Visit Type Preference? is a required field'); 
                        isErrorInForm  = true;
                    }
                    if(String.isBlank(Record.Is_Patient_Requesting_a_Specific_MD__c)){
                        appointmentInfo.add('Is Pt. Requesting a Specific MD? is a required field'); 
                        isErrorInForm  = true;
                    }
                    if(String.isNotBlank(Record.Pt_Appt_is_Scheduled_in_how_many_days__c) && Record.Pt_Appt_is_Scheduled_in_how_many_days__c == '8+ Days' && String.isBlank(Record.Does_Pt_want_a_sooner_appt__c)){
                        appointmentInfo.add('Does Pt want a sooner appt? is a required field'); 
                        isErrorInForm  = true;
                    }
                }
                
            }else{
                appointmentInfo.add('COH MRN is Blank'); 
                // isErrorInForm  = false;
            } 
            
            if(String.isBlank(Record.Last_Appointment_Scheduled__c)){
                appointmentInfo.add('Appointment is not scheduled'); 
                //isErrorInForm  = true;
            }// Appointmnet Info - End*/
            // Insurance Matrix - Start
            mapWithFormNameAndErrors.put('insuranceMatrix',new List<String>());
            Boolean isError = false;
            List<String> insuranceMatrix = mapWithFormNameAndErrors.get('insuranceMatrix');
            if(String.isNotBlank(Record.Service_Category__c) && String.isNotBlank(Record.Plan_Type__c) &&
               String.isNotBlank(Record.Health_Plan__c) &&String.isNotBlank(Record.Medical_Group_IPA__c) &&
               String.isNotBlank(Record.Line_of_Business_Decision_Tree__c)){
                   if(Record.Does_patient_have_auth_at_time_of_schedu__c == 'Yes'){
                       if(String.isBlank(Record.Auth__c)){
                           isError = true;
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
                
                isErrorInForm  = true;
            }
            // Insurance Matrix - End
            // Appointmnet Info - Start
            /*mapWithFormNameAndErrors.put('cancelation',new List<String>());
            List<String> Cancelation = mapWithFormNameAndErrors.get('cancelation');
            if(Record.Appt_Status__c == 'Canceled'){
                if(Record.Appt_Cancelation_Date__c == null){
                    insuranceMatrix.add('Cancelation Date is required'); 
                    isErrorInForm  = true;
                }
                if(String.isBlank(Record.Appt_Rescheduled__c)){
                    insuranceMatrix.add('Did Patient Reschedule? is required'); 
                    isErrorInForm  = true;
                }
                if(Record.Appt_Cancelation_Email_Sent__c == null){
                    insuranceMatrix.add('Cancelation Email Sent Date is required'); 
                    isErrorInForm  = true;
                }
                
            }else if(Record.Appt_Status__c == 'No Show'){
                
                if(Record.Appt_Call_Date__c == null){
                    insuranceMatrix.add('Cancelation Email Sent Date is required');
                    isErrorInForm  = true;
                }
                if(String.isBlank(Record.Appt_Rescheduled__c)){
                    insuranceMatrix.add('Did Patient Reschedule? is required'); 
                    isErrorInForm  = true;
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
               }*/
            
            /*mapWithFormNameAndErrors.put('cohepicmrn',new List<String>());
            List<String> cohepicmrn = mapWithFormNameAndErrors.get('cohepicmrn');
            if(String.isBlank(Record.COH_MRN__c)){
                cohepicmrn.add('COH MRN not created'); 
                isErrorInForm  = true;
            }
            if(String.isBlank(Record.Clinical_Specialty_Assignment__c)){
                cohepicmrn.add('Clinical Specialty Assignment cannot be empty'); 
                isErrorInForm  = true;
            }*/
        }
        validations.put('isError',isErrorInForm);
        validations.put('errorMessages',mapWithFormNameAndErrors);
        
        if(saveAll == 'saveAll'){
            Save_Record__e saveRecord = new Save_Record__e();
            saveRecord.Record_Id__c = caseRecord;
            saveRecord.Error_Message__c = json.serialize(validations);
            //EventBus.publish(saveRecord);
        }
        
        
        
        return json.serialize(validations);
        //Clinical Form
    }
}