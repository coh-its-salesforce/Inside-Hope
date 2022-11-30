/*
 * This class contains utility methods for the Foundation project.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
global class FoundationProcessAccountUtil {
    
    private static final String RECORD_TYPE_NAME = 'Foundation';
    private static final String ACCOUNT = 'Account';
    private static final String COH_DATA_ENVELOPE = 'COH_Data_Envelope__c';
    private static final String APPLICATION_NAME = 'Foundation';
    private static final String LOCATION_GROUP_NAME = 'Locations';
    private static final String EMAIL_SUBJECT = 'Email Subject';
    private static final String DUMMY_EMAIL_ADDRESS = 'Dummy Email Address';
    private static final String URL_TEMPLATE = 'Map URL Template';
    private static final String DELIMITER = ';';
    private static final String SITE_TOKEN = '[SiteName]';
    private static final String MAP_SEARCH_CRITERIA_TOKEN = '[SearchCriteria]';
    private static final String ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS = 'Activity History BCC Email Address';

    private static final String mGetDataEnvelopeSOQLQuery = 'select Id, Name, Active__c from COH_Data_Envelope__c where Active__c = true and RecordTypeId = :mFoundationCOHDataEnvelopeRecordTypeID';
    private static final String mGetDataEnvelopeAttachmentsSOQLQuery = 'select Id, Name, ParentId, Body, ContentType from Attachment where ParentID in :mDocumentEnvelopeParentIDs';
        
    private static Map<String, String> mLocationToURLSearchCriteria = new Map<String, String>();
    private static List<Id> mDocumentEnvelopeParentIDs = new List<Id>();
    private static String mEmailSubject;
    private static String mDummyEmailAddress;
    private static Id mFoundationAccountRecordTypeID;
    private static Id mFoundationCOHDataEnvelopeRecordTypeID;
    private static String mMapURLTemplate;
    private static String mActivityHistoryBCCEmailAddress;
    private static String mGetAccountSOQLQuery;
    private static String valAddress;
    private static String valPhonenum;
    private static String floorNum;
    private static String floorSuite;
    private static String Streetaddress;
    private static String afteraddress; 
    


    
    /*
     * Initialization.
     * 
     */
    static {
        List<COH_App_Configuration__c> locationSearchCriteria = COHUtil.getConfigurationGroup(APPLICATION_NAME, LOCATION_GROUP_NAME);
        if (COHUtil.isValidList(locationSearchCriteria)) {
            for (COH_App_Configuration__c configObj : locationSearchCriteria) {
                mLocationToURLSearchCriteria.put(configObj.Name, configObj.Value__c);
            }
        }
        mFoundationAccountRecordTypeID = COHUtil.getRecordType(ACCOUNT, RECORD_TYPE_NAME);
        mFoundationCOHDataEnvelopeRecordTypeID = COHUtil.getRecordType(COH_DATA_ENVELOPE, RECORD_TYPE_NAME);
        mEmailSubject = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, EMAIL_SUBJECT);
        mDummyEmailAddress = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, DUMMY_EMAIL_ADDRESS);
        mMapURLTemplate = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, URL_TEMPLATE);
        mActivityHistoryBCCEmailAddress = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, ACTIVITY_HISTORY_BCC_EMAIL_ADDRESS);
        mGetAccountSOQLQuery = COHUtil.buildSelectAllSOQLStatement('Account');
    }
    
    /*
     * Default constructor
     * 
     */
    public FoundationProcessAccountUtil() {
    }
    
    
    /*
     * This method processes a list of Accounts.  When the record is saved, an email will be sent
     * to the patient with a PDF attachment from a picklist.
     * 
     * @param   accountObjectsList      List of Accounts to process.
     * @throws  COHException            Thrown if an error occurs.
     * 
     */
    public static void processNewAccounts(List<Account> accountObjectsList) {

        if (COHUtil.isValidList(accountObjectsList)) {

            Boolean validAccountRecordFound = false;
                
            // Map all valid Account Object IDs to Account Objects for easier retrieval
            Map<Id, Account> accountIDToAccountMap = new Map<Id, Account>();

            // Map all Account Object IDs to packet types
            Map<Id, List<String>> accountIDToPacketTypeMap = new Map<Id, List<String>>();

            // Create a list of COH Physician IDs
            List<Id> accountRecordOwnerList = new List<Id>();
            
            // Create a list of COH Physician IDs
            List<Id> COHPhysicianList = new List<Id>();
            
            for (Account accountObj : accountObjectsList) {
                if (accountObj.RecordTypeId == mFoundationAccountRecordTypeID) {
                    validAccountRecordFound = true;
                    
                    // Map the packet types
                    String allPacketTypes = accountObj.Foundation_Packet_Type__c;
                    if (allPacketTypes != null) {
                        String[] packetTypes = allPacketTypes.split(DELIMITER);
                        List<String> packetTypeList = new List<String>();
                        for (String packetType : packetTypes) {
                            if (packetType != null) {
                                packetTypeList.add(packetType);
                            }
                        }
                        accountIDToPacketTypeMap.put(accountObj.Id, packetTypeList);
                    }
                    // Add the physician IDs
                    COHPhysicianList.add(accountObj.COH_Physician__c);
                    // Add the owner IDs
                    accountRecordOwnerList.add(accountObj.OwnerId);
                }
            }
            
            if (validAccountRecordFound == false) {
                return;
            }
            
            // Retrieve all the owner IDs and map them their names
            Map<Id, User>  ownerIDToOwnerNameMap = new Map<Id, User>([select Id, Name from User where id in :accountRecordOwnerList]);
            
            // Retrieve all the physician names and map them to object IDs
            Map<Id, Contact> physicianIDToContactMap = new Map<Id, Contact>([select Id, Name from Contact where id in :COHPhysicianList]);
            
            // Retrieve all the map directions URL criteria and map them to the location 
            
            // Map the names to the IDs of all Data Envelope objects.  This name 
            // will be matched against the value retrieved from the 
            // Foundation_Packet_Type__c field.
            List<COH_Data_Envelope__c> allDataEnvelopes = Database.query(mGetDataEnvelopeSOQLQuery);
            Map<String, Id> dataEnvelopeNameToIDMap = new Map<String, Id>();
            if (COHUtil.isValidList(allDataEnvelopes)) {
                for (COH_Data_Envelope__c COH_DEobj: allDataEnvelopes) {
                    mDocumentEnvelopeParentIDs.add(COH_DEobj.Id);
                    dataEnvelopeNameToIDMap.put(COH_DEobj.Name, COH_DEobj.Id);
                }
            }
            
            // Retrieve the Attachments and their COH_Data_Envelope__c parent IDs for all 
            // active Data Envelope objects.
            List<Attachment> allAttachments = Database.query(mGetDataEnvelopeAttachmentsSOQLQuery);
            
            Map<Id, List<Attachment>> attachmentParentIDToListMap = new Map<Id, List<Attachment>>();
            if (COHUtil.isValidList(allAttachments)) {
                for (Attachment attachmentObj : allAttachments) {
                    List<Attachment> attachmentList = null;
                    Object obj = attachmentParentIDToListMap.get(attachmentObj.ParentId);
                    if (obj == null) {
                        attachmentList = new List<Attachment>();
                    } else {
                        attachmentList = (List<Attachment>) obj;
                    }
                    attachmentList.add(attachmentObj);
                    attachmentParentIDToListMap.put(attachmentObj.ParentId, attachmentList);    
                }
            }
            
            // Go through all Accounts and associate each account ID with a list
            // of Attachments
            
            Map<Id, List<Attachment>> accountIDToPacketListAttachmentMap = new Map<Id, List<Attachment>>();
            Set<Id> allAccountIDs = accountIDToPacketTypeMap.keySet();

            for (Id accountID : allAccountIDs) {
                List<String> packetTypeNames = accountIDToPacketTypeMap.get(accountID);
                List<Attachment> packetListAttachments = new List<Attachment>();
                for (String packetName : packetTypeNames) {
                    if (packetName != null) {
                        Id COH_DEObjID = dataEnvelopeNameToIDMap.get(packetName);
                        if (COH_DEObjID != null) {
                            List<Attachment> availableAttachments = attachmentParentIDToListMap.get(COH_DEObjID);
                            for (Attachment attachmentObj : availableAttachments) {
                                packetListAttachments.add(attachmentObj);
                            }
                        }
                    }
                }
                accountIDToPacketListAttachmentMap.put(accountID, packetListAttachments);
            }

            try {
                // Create emails for all Accounts that have packet type attachments.
                for (Account accountObj : accountObjectsList) {
                    List<Attachment> attachmentsForAccount = (List<Attachment>) accountIDToPacketListAttachmentMap.get(accountObj.Id);
                    if (COHUtil.isValidList(attachmentsForAccount)) {
                        Contact cohPhysician = physicianIDToContactMap.get(accountObj.COH_Physician__c);
                        String physicianName = cohPhysician.Name;
                        User userObj = ownerIDToOwnerNameMap.get(accountObj.OwnerId);
                        String ownerName = userObj.Name;
                        Messaging.SingleEmailMessage emailObj = createEmailMessage(accountObj, attachmentsForAccount, physicianName, ownerName);
                        if (emailObj != null) {
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailObj});
                        }
                    }
                }
            } catch (Exception e) {
                throw new COHException('Could not process new Foundation Account record: ' + e.getMessage());
            }
        }
    }

    /*
     * Create an email message and attach the Attachment.
     * 
     * @param   accountObj                  The account object for the patient who will receive the email.
     * @param   attachmentsForAccount       The List of Attachment objects to send.
     * @param   physicianName               The name of the COH physician
     * @param   ownerName                   The name of the Account record's owner.
     * @return                              The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createEmailMessage(Account accountObj, 
                                                                   List<Attachment> attachmentsForAccount,
                                                                   String physicianName,
                                                                   String ownerName) {
        
        Messaging.SingleEmailMessage email = null;
        if (accountObj != null && COHUtil.isValidStr(accountObj.PersonEmail)) {
            // Continue processing if mDummyEmailAddress is null.  Otherwise, check if the 
            // email address is a dummy address.
            if (mDummyEmailAddress != null && mDummyEmailAddress.equalsIgnoreCase(accountObj.PersonEmail)) {
                return email;
            }

            String textBody = buildEmailTextBody(accountObj, attachmentsForAccount, physicianName, ownerName);
            if (textBody != null) {
                email = new Messaging.SingleEmailMessage();
                email.Subject = mEmailSubject.replace(SITE_TOKEN, accountObj.Location__pc);
                String[] emailAddress = new String[1];
                emailAddress[0] = accountObj.PersonEmail;
                email.setHTMLBody(textBody);
                email.setToAddresses(emailAddress); 
                String[] ccEmailAddress = new String[1];
                ccEmailAddress[0] = mActivityHistoryBCCEmailAddress;
                email.setBccAddresses(ccEmailAddress);
                                
                if (COHUtil.isValidList(attachmentsForAccount)) {
                    List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
                    for (Attachment attachmentObj : attachmentsForAccount) {
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
     * @param   accountObj              The account object for the patient who will receive the email.
     * @param   attachmentsForAccount   The List of Attachment objects to send.
     * @param   physicianName           The name of the COH physician
     * @param   ownerName               The name of the Account record's owner.
     * @return                          The text of the email body.
     * 
     */
    private static String buildEmailTextBody(Account accountObj, 
                                             List<Attachment> attachmentsForAccount,
                                             String physicianName,
                                             String ownerName) {
        String textBody = null;
        String addressSplit;

        if (accountObj != null && COHUtil.isValidList(attachmentsForAccount)) {
            Date emailDate = Date.today();
            Date appointmentDate = accountObj.Appointment_Date_Time__c;
            valAddress = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, accountObj.Location__pc);
            valPhonenum = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, accountObj.Location__pc + ' Phone Number');
            String phyName = [Select id,name from contact where id =: accountObj.COH_Physician__c limit 1].name;
            String phySuite = [Select id,suite__c from contact where id =: accountObj.COH_Physician__c limit 1].suite__c;
                      
                       

            floorNum = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, phyName);
            

            if (valAddress != null) {
                Streetaddress = valAddress.substring(0, valAddress.indexOfAny(','));
                afteraddress = valAddress.substringAfter(',');
                string FinalStreetaddress = Streetaddress.replace('+',' ');
                string Finalafteraddress= afteraddress.replace('+',' ');
                
                if(accountObj.Location__pc == 'Rancho Cucamonga' && floorNum != null) {
                    if(phySuite != null){
                    
                        addressSplit  = FinalStreetaddress +', '+phySuite +','+Finalafteraddress; 
                    }
                    else
                    {
                       
                        addressSplit  = FinalStreetaddress +', '+Finalafteraddress; 
                      }

                }
                else
                {
                    addressSplit  = FinalStreetaddress +', '+Finalafteraddress; 

                }
            }
            
            String textBody0 = 'Date: ' + emailDate.format() + 
                '<br><br>Dear ' + accountObj.FirstName + '&nbsp ' + accountObj.LastName + ', ' +
                '<br><br>Welcome to the <b>City of Hope Medical Group - ' + accountObj.Location__pc + '</b>.' +
                '<br><br>We have scheduled an appointment for you with Dr. ' + physicianName + 
                '&nbsp on ' + appointmentDate.format() + ' at ' + accountObj.Time__c + '.';

            String textBody1 = '<br><br>To save time, we have enclosed new patient registration forms along with a medical questionnaire for you to ' +
                'complete and return prior to your appointment.&nbsp  <u><b>Please arrive 30 minutes prior to your scheduled appointment time with the following items:</b></u>.';
                
            String textBody2 = '<br><br>&nbsp&nbsp&#10003&nbsp All completed paperwork mailed to you if you are unable to return the paperwork prior to the visit' +
                '<br>&nbsp&nbsp&#10003&nbsp Insurance card(s)' +
                '<br>&nbsp&nbsp&#10003&nbsp Insurance co-payments. <i>If you are a cash paying patient, please be prepared to pay immediately after your appointment with your doctor.</i>' +
                '<br>&nbsp&nbsp&#10003&nbsp Insurance authorization for HMO plans' +
                '<br>&nbsp&nbsp&#10003&nbsp All of your medical bottle(s) which include name, dose, and directions' +
                '<br>&nbsp&nbsp&#10003&nbsp Copies of medical records if not already faxed by your physicians' +
                '<br>&nbsp&nbsp&#10003&nbsp Radiology film or CD with the respective reports (if applicable)' +
                '<br>&nbsp&nbsp&#10003&nbsp Pathology report and slides (if applicable)';
            
            String textBody3 = '<br><br>Please call our office <b>48 hours</b> in advance should you have problems obtaining any of the above items or if you ' +
                'need to cancel or reschedule this appointment.';

            String searchCriteria = mLocationToURLSearchCriteria.get(accountObj.Location__pc);
            String mapURL = mMapURLTemplate.replace(MAP_SEARCH_CRITERIA_TOKEN, searchCriteria);
            
            String textBody4 = '<br><br> <a href="' + mapURL + '">' + addressSplit + '</a> ';
            String textBody7 = '<br><br> Phone Number : '+valPhonenum;
            String textBody5 = '<br><br>Sincerely, <br><br>' + ownerName + '<br>';
            String textBody6 = '<br>Ref: ' + accountObj.COH_Account_ID__c + '<br>';
            
            textBody = textBody0 + textBody1 + textBody2 + textBody3 + textBody4 + textBody7 + textBody5 + textBody6;
        }    
        return textBody;
    }

    /*
     * Webservice to resend the packet email.
     * 
     * @param   accountObjID            The Account object ID from where the packet email is to be resent.
     * 
     */
    webservice static void resendEmailWS(String accountObjID) {
        if (accountObjID != null) {
            mGetAccountSOQLQuery += ' where Id = \'' + accountObjID + '\'';
            List<Account> accountObjectsList = Database.query(mGetAccountSOQLQuery);
            if (COHUtil.isValidList(accountObjectsList)) {
                processNewAccounts(accountObjectsList);
            }
        }
    }   
}