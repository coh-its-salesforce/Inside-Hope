/* 
 * This class contains the methods for working on Attachments
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
public class COHAttachmentUtility {

	private static final String ACCOUNT = 'Account';
	private static final String CASE_OBJ = 'Case';
    private static final String CALL_CENTER_APPLICATION = 'Call Center';
    private static final String DEATH_CERT_CALL_TYPE = 'Death Certificates';
    private static final String DEFAULT_EMAIL_ADDRESS = 'Default Email Address';
    private static final String CC_EMAIL_TRAIL_ADDRESS = 'CC Email Trail Address';
    private static final String DEATH_CERT_ATTACHMENT_NAME = 'Death Cert Attachment Name';
    
    private static final String CAUSE_MARKETING_RECORD_TYPE = 'Cause Marketing';
	private static final String SPACE = ' ';
        
    private static List<Id> mDeathCertCaseIDList = new List<Id>();
    private static List<Id> mCaseOwnerIDList = new List<Id>();
    
    private static Id mCauseMarketingRecordType;
    private static String mDefaultDeathCertEmail;
    private static String mDefaultDeathCertCallType;
    private static String mDefaultEmailAddress;
    private static String mCCEmailTrailAddress;
    private static String mDefaultDeathCertAttachName;
    
    static {
        mDefaultDeathCertCallType = (String) COHUtil.getConfigurationValue(CALL_CENTER_APPLICATION, DEATH_CERT_CALL_TYPE);
		mDefaultEmailAddress = (String) COHUtil.getConfigurationValue(CALL_CENTER_APPLICATION, DEFAULT_EMAIL_ADDRESS);
		mCCEmailTrailAddress = (String) COHUtil.getConfigurationValue(CALL_CENTER_APPLICATION, CC_EMAIL_TRAIL_ADDRESS);
		mDefaultDeathCertAttachName = (String) COHUtil.getConfigurationValue(CALL_CENTER_APPLICATION, DEATH_CERT_ATTACHMENT_NAME);
        mCauseMarketingRecordType = COHUtil.getRecordType(ACCOUNT, CAUSE_MARKETING_RECORD_TYPE);
    }
    
    /*
     * Process the case attachments.
     * 
     * @param caseAttachmentList	List of attachments for cases
     * 
     */
    public static void processCaseAttachments(List<Attachment> caseAttachmentList) {
        
        List<Id> caseIDList = new List<Id>();
        Map<Id, List<Attachment>> caseIDtoAttachmentsMap = new Map<Id, List<Attachment>>();
        
        // Map Case object IDs to their Attachments

		if (COHUtil.isValidList(caseAttachmentList)) {
            for (Attachment attachmentObj : caseAttachmentList)  {
                Id parentID = attachmentObj.ParentId;
                caseIDList.add(parentID);
                // Add all attachments that have the same name as mDefaultDeathCertAttachName
                List<Attachment> currentAttachments = caseIDtoAttachmentsMap.get(parentID);
                String attachmentObjName = attachmentObj.Name;
                if (!String.isEmpty(attachmentObjName) && attachmentObjName.equalsIgnoreCase(mDefaultDeathCertAttachName)) {
                    if (currentAttachments == null) {
                        currentAttachments = new List<Attachment>();  // case object does not have any attachments
                    } 
                    currentAttachments.add(attachmentObj);		
                    caseIDtoAttachmentsMap.put(parentID, currentAttachments);
                }
            }
        }
        
        // Identify the Cases where the call type is the same as mDefaultDeathCertCallType
        Map<Id, Case> caseIDtoCaseMap = new Map<Id, Case>();	// Map Case ID to the Case object
        Map<Id, Id> caseIDToAccountIDMap = new Map<Id, Id>(); // Map the Cases to the parent Account ID 
        List<Id> caseParentAccountIDList = new List<Id>();		// List of Account IDs for the valid Cases

        List<Id> caseOwnerIDList = new List<Id>();				// List of the ID of the Case Owners
        String getCasesSOQLQuery = COHUtil.buildSelectAllSOQLStatement(CASE_OBJ) + ' where Id in :caseIDList';
        if (COHUtil.isValidList(caseIDList)) {
            List<Case> allCasesList = Database.query(getCasesSOQLQuery);
            if (COHUtil.isValidList(allCasesList)) {
                for (Case caseObj : allCasesList) {
			        String callType = caseObj.Type;
                    if (mDefaultDeathCertCallType == callType) {
                        caseIDtoCaseMap.put(caseObj.Id, caseObj);
                        caseOwnerIDList.add(caseObj.OwnerId);
			            caseIDToAccountIDMap.put(caseObj.Id, caseObj.AccountId);
			            caseParentAccountIDList.add(caseObj.AccountId);
                    }
                }
            }
        }
        
        // Map the Case owner IDs to the corresponding User records
        Map<Id, User> caseOwnerIDToUserMap = new Map<Id, User>();  
		String getCasesUserSOQLQuery = 'select Id, Email, Name, Call_Center__c, Phone from User where Id in :caseOwnerIDList';
        List<User> userList = Database.query(getCasesUserSOQLQuery);
        if (COHUtil.isValidList(userList)) {
            for (User userObj : userList) {
                caseOwnerIDToUserMap.put(userObj.Id, userObj);
            }
        }
        
        // Map Account ID to the Account object
        Map<Id, Account> accountIDToAccountMap = new Map<Id, Account>();  
        if (COHUtil.isValidList(caseIDList))  {
			String getCasesAccountSOQLQuery = COHUtil.buildSelectAllSOQLStatement(ACCOUNT) + ' where Id in :caseParentAccountIDList';
            List<Account> accountsList = Database.query(getCasesAccountSOQLQuery);
            if (COHUtil.isValidList(accountsList)) {
                for (Account accountObj : accountsList) {
	                accountIDToAccountMap.put(accountObj.Id, accountObj);
                }
            }
        }

        // Map the Case ID to its parent Account Object
        Map<Id, Account> caseIDToAccountMap = new Map<Id, Account>();     
		Set<Id> validCaseIDSet = caseIDToAccountIDMap.keySet();
        for (Id caseObjID : validCaseIDSet) {
            Id accountObjID = caseIDToAccountIDMap.get(caseObjID);
            Account accountObj = accountIDToAccountMap.get(accountObjID);
            caseIDToAccountMap.put(caseObjID, accountObj);
        }

        // Process the records
        if (COHUtil.isValidList(userList)) {
			processDeathCertRecords(caseIDtoCaseMap, caseIDtoAttachmentsMap, caseOwnerIDToUserMap, caseIDToAccountMap);
        }
        
    }

    /*
     * Process the attachments for Accounts.  Those with the CAUSE_MARKETING_RECORD_TYPE are processed.
     * Other types are ignored.
     * 
     * @param attachmentList	List of attachments for Accounts
     * 
     */
    public static void processAccountAttachments(List<Attachment> attachmentList) {
        
        List<Id> accountIDList = new List<Id>();

		if (COHUtil.isValidList(attachmentList)) {
            for (Attachment attachmentObj : attachmentList)  {
                Id parentID = attachmentObj.ParentId;
                accountIDList.add(parentID);
            }
        }
        
        // Retrieve the parent Account records with the CAUSE_MARKETING_RECORD_TYPE record ID
        
		String getAccountsUserSOQLQuery = 'select Id, LastModifiedDate, RecordTypeId, Force_Update__c from Account where RecordTypeId = :mCauseMarketingRecordType and Id in :accountIDList';
        List<Account> accountCauseMarketingList = Database.query(getAccountsUserSOQLQuery);
        processCauseMarketingRecords(accountCauseMarketingList);
    }
    
    /*
     * Process records where the Death Certificate must be processed.  
     * If a mDefaultDeathCertCallType is the call type, an email is 
     * to be sent with the death certificate is attached to it.
     * 
     * @param caseIDtoCaseMap			Map of Case object IDs to the Case objects
     * @param caseIDtoAttachmentsMap	Map of Case object IDs to their attachments
     * @param caseOwnerIDToUserMap		Map of Case Owners to their User objects
     * @param caseIDToAccountMap		Map of Case object IDs to their parent Account object
     * 
     */
    private static void processDeathCertRecords(Map<Id, Case> caseIDtoCaseMap, Map<Id, List<Attachment>> caseIDtoAttachmentsMap, 
                                                Map<Id, User> caseOwnerIDToUserMap, Map<Id, Account> caseIDToAccountMap) {

        // Process every Case record
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        
        List<Case> casesList = caseIDtoCaseMap.Values();
        for (Case caseObj : casesList) {
            Id caseObjID = caseObj.Id;
            Id caseOwnerID = caseObj.OwnerId;
            User userObj = caseOwnerIDToUserMap.get(caseOwnerID);
            Account accountObj = caseIDToAccountMap.get(caseObjID);
            List<Attachment> caseObjAttachments = caseIDtoAttachmentsMap.get(caseObjID);
            
            // Ignore any cases that lack attachments
            if (COHUtil.isValidList(caseObjAttachments)) {
                Messaging.SingleEmailMessage emailMessage = createDeathCertEmailMessage(accountObj, caseObj, 
                                                                                        userObj, caseObjAttachments);
                emailsList.add(emailMessage);
            }
        }
        
        try {
            if (COHUtil.isValidList(emailsList) && !test.isRunningTest()) {
				Messaging.sendEmail(emailsList);
            }
        } catch (Exception e) {
            throw new COHException('processDeathCertRecords(): Could not send emails: ' + e.getMessage());
        }

        
    }
    
    /*
     * Create an Death Cert email message and attach the Attachment.  The email will be sent to the address stored
     * in mDefaultEmailAddress.  The owner is CC'd on the email.
     * 
     * @param accountObj					The parent Account object for the case
     * @param caseObj		                The Case object for the email.
     * @param userObj			            The User object for the case owner
     * @param caseAttachmentsList		    The List of Attachment objects to send.
     * @return                              The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createDeathCertEmailMessage(Account accountObj, Case caseObj, User userObj, 
                                                                   List<Attachment> caseAttachmentsList) {
        
        Messaging.SingleEmailMessage email = null;
        if (accountObj != null && caseObj != null && userObj != null) {
			String ownerEmailAddr = userObj.Email;
            String textBody = buildDeathCertEmailTextBody(accountObj, caseObj, userObj);
            if (textBody != null) {
                email = new Messaging.SingleEmailMessage();
                email.setReplyTo(ownerEmailAddr);
                email.setToAddresses(new String[] {mDefaultEmailAddress}); 
                email.setCcAddresses(new String[] {ownerEmailAddr, mCCEmailTrailAddress});
                String emailSubject = 'Patient: ' + accountObj.Name + ' MRN: ' + accountObj.COH_MRN__c + ' Call Type: ' + caseObj.Type;
                email.Subject = emailSubject;
                email.setHTMLBody(textBody);

                
                if (COHUtil.isValidList(caseAttachmentsList)) {
                    List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
                    for (Attachment attachmentObj : caseAttachmentsList) {
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(attachmentObj.Name);
                        efa.setBody(attachmentObj.Body);
                        efa.setContentType(attachmentObj.ContentType);
                        efa.setInline(false);
                        attachmentList.add(efa);
                    }
                    email.setFileAttachments(attachmentList);
                } 
            }
        }
        return email;
    }

    /*
     * Create the email text body.
     * 
     * @param accountObj				The parent Cccount object for the case
     * @param caseObj		            The Case object for this email.
     * @param userObj					The User object for the case owner.
     * @return                          The text of the email body.
     * 
     */
    private static String buildDeathCertEmailTextBody(Account accountObj, Case caseObj, User userObj) {
        String textBody = null;
        if (accountObj!= null && caseObj != null && userObj != null) {

            String textBody0 = '<br><b><u><font size="+2">Attention: Call Center Communication</u></b>';

            String textBody1 = '<font size="+1"><br><br><b>Call Type: </b>' + caseObj.Type +
                '<br><br><b><u>Caller Information:</u></b>' +
                '<br><br><b>Caller Name:&nbsp</b>' + caseObj.Caller_First_Name__c + '&nbsp' + caseObj.Caller_Last_Name__c +
                '<br><b>Primary Callback Number:&nbsp</b>' + caseObj.Primary_Callback_Number__c + 
                '<br><b>Alternate Callback Number:&nbsp</b>' + caseObj.Alternate_Callback_Number__c +
                '<br><b>Caller Relationship to Patient:&nbsp</b>' + caseObj.Caller_Relationship_to_Patient__c;

            String textBody2 = '<br><br><b>Physician\'s Name: </b>' + caseObj.Physician_Name__c;
                
            String textBody3 = '<br><br><b>Caregiver Facility: </b>' + caseObj.Caregiver_Facility__c +
                '<br><b>Location:&nbsp</b>' + caseObj.Location__c + 
                '<br><b>Date/Time Opened:&nbsp</b>' + caseObj.Date_Time_Opened_hidden_field__c + 
                '<br><b>Patient Name:&nbsp</b>' + accountObj.Name + 
                '<br><b>COH MRN#:&nbsp</b>' + accountObj.COH_MRN__c + 
                '<br><b>DOB:&nbsp</b>' + accountObj.PersonBirthdate + 
                '<br><b>Gender:&nbsp</b>' + accountObj.Gender__pc + 
                '<br><b>Patient Home Phone:&nbsp</b>' + accountObj.PersonHomePhone + 
                '<br><b>Patient Work Phone:&nbsp</b>' + accountObj.Phone + 
                '<br><b>Patient Mobile Phone:&nbsp</b>' + accountObj.PersonMobilePhone + 
                '<br><b>Patient Primary Number to Call:&nbsp</b>' + accountObj.Primary_Number_to_Call__pc + 
                '<br><b>Alternate MRN:&nbsp</b>' + accountObj.Alternate_MRN__c + 
                '<br><b>Patient Mood:&nbsp</b>' + caseObj.Patient_Mood__c;
                
            String textBody4 = '<br><br><b>Description:&nbsp</b>' + caseObj.Description;
                
            String caseURL = URL.getSalesforceBaseURL().toExternalForm() + '/' + caseObj.Id;
            String textBody5 = '<br><br> <a href="' + caseURL + '">' + 'Click Here To Access This Case'  + '</a> ';
            
            String textBody6 = '<br><br>Sincerely, ' +
                '<br><br>' + userObj.Name +
                '<br>' + userObj.Call_Center__c + '&nbsp Call Center Team' +
                '<br>' + userObj.Phone;
            
            String textBody7 = '<br><br>Ref: ' + caseObj.Id + '<br>';
            
            textBody = textBody0 + textBody1 + textBody2 + textBody3 + textBody4 + textBody5 + textBody6 + textBody7;
        }    
        return textBody;
    }
    
    /*
     * Process Account records with the CAUSE_MARKETING_RECORD_TYPE record ID.  The Force_Update__c
     * field is toggled in order to  force an update in the LastModifiedDate field, which is read-only.
     * 
     * @param accountCauseMarketingList		List of Account records with the CAUSE_MARKETING_RECORD_TYPE record ID.
     * 
     */
    private static void processCauseMarketingRecords(List<Account> accountCauseMarketingList) {
        if (COHUtil.isValidList(accountCauseMarketingList)) {
            for (Account accountObj : accountCauseMarketingList) {
                accountObj.Force_Update__c = !accountObj.Force_Update__c;
            }
            try {
				Database.update(accountCauseMarketingList);          
            } catch (Exception e) {
				throw new COHException('processCauseMarketingRecords(): Could not update Cause Marketing records: ' + e.getMessage());
            }
        }
    }
    
}