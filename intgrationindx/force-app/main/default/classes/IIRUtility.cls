/* 
 * This class contains the methods for working on Attachments where the parent object is an 
 * instance of ITS_Project_Request__c.
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
public class IIRUtility {
    private static final String APPLICATION_NAME = 'ITS Intake Request';
    private static final String EMAIL_TO_ADDRESS = 'Email To Address';
    private static final String EMAIL_SUBJECT = 'Email Subject';
    private static final String URL_PREFIX = 'URL Prefix';
    private static final String REQUESTED_STATE = 'Requested State';
    private static final String ITS_INTAKE_REQUEST = 'ITS_Project_Request__c';
    private static final String IIR_CONFIGURATION_GROUP = 'Valid Applications';
    private static final String EDW_APPLICATION = 'EDW';
        
    private static String[] mEmailToAddresses = null;
    private static String mEmailSubject;
    private static String mHyperlinkPrefix;
    private static String mRequestedState;
    private static String mRetrieveIIRObjSoqlQuery;
    
    private static List<COH_App_Configuration__c> mIIRConfigurationGroup = new List<COH_App_Configuration__c>();

    static {
        initialize();
    }

    /*
	 * Default constructor.
	 * 
	 */
    public IIRUtility() {
    }
    
    /*
     * Initialization.
     * 
     */
    private static void initialize() {
        String mailToAddress = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, EMAIL_TO_ADDRESS);
        mEmailToAddresses = new String[] {mailToAddress};
        mEmailSubject = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, EMAIL_SUBJECT);
        mHyperlinkPrefix = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, URL_PREFIX);
		mRequestedState = (String) COHUtil.getConfigurationValue(APPLICATION_NAME, REQUESTED_STATE);
		mIIRConfigurationGroup = COHUtil.getConfigurationGroup(APPLICATION_NAME, IIR_CONFIGURATION_GROUP);
        mRetrieveIIRObjSoqlQuery = COHUtil.buildSelectAllSOQLStatement(ITS_INTAKE_REQUEST);
		mRetrieveIIRObjSoqlQuery +=  ' where Id in :keySet';
    }
    
    /*
     * Process all Attachments to the ITS_Project_Request__c objects that 
     * came from specific applicaitons.  The records were filtered in the
     * COHAttachmentHelper class.  The Attachment should be retrieved and 
     * mailed to the specified email address.
     * 
     * @param	attachmentsList		List of Attachment objects to process.
     * 
     */
	public static void processIIRAttachments(List<Attachment> attachmentsList) {
        if (COHUtil.isValidList(attachmentsList)) {
            // Get a map of Parent ID to the application name
            Map<Id, String> parentIDApplicationNameMap = buildParentIDToApplicationNameMap(attachmentsList);
            Map<Id, Attachment> parentIDAttachmentMap = new Map<Id, Attachment>();
            List<EmailMessage> emailList = new List<EmailMessage>();
    
            // Identify which attachments originated from the target application(s)
            for(Attachment attachmentObject : attachmentsList) {
                Id parentID = attachmentObject.ParentId;
                String applicationName = parentIDApplicationNameMap.get(parentID);
                if (isValid(applicationName)) {
                    parentIDAttachmentMap.put(parentID, attachmentObject);
                }
            }
        
            //  If valid IDs exist, retrieve the parent object, create an email for it,
            //  and map it to the parent object ID.  Then attach the attachments and send them out.
            Map<Id, Messaging.SingleEmailMessage > parentIDEmailMap = new Map<Id, Messaging.SingleEmailMessage >();
            Set<Id> keySet = parentIDAttachmentMap.keySet();
            if (!keySet.isEmpty()) {
                List<ITS_Project_Request__c> IIRObjectList = Database.query(mRetrieveIIRObjSoqlQuery);
				
                try {
                    for (ITS_Project_Request__c IIRObj : IIRObjectList) {
                        IIRObj.Current_State__c = mRequestedState;
                        Attachment attachmentObj = parentIDAttachmentMap.get(IIRObj.Id);
                        Messaging.SingleEmailMessage emailObj = createEmailMessage(IIRObj, attachmentObj);
                        if (emailObj != null) {
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailObj});
                        }
                    }
                    // update all applicable ITS_Project_Request__c objects
                    Database.update(IIRObjectList);
                } catch (Exception e) {
                    throw new IIRException('Could not process IIR attachment: ' + e.getMessage());
                }
            }
        } 
    }

    /*
     * Build a map of the Attachment parent object IDs to the name of the application that
     * created the ITS_Project_Request__c object.
     * 
     * @param	attachmentsList		List of Attachment objects to process.
     * @return						Map of parent IDs to the application name. 
     * 
     */
    private static Map<Id, String> buildParentIDToApplicationNameMap(List<Attachment> attachmentsList) {
        Map<Id, String> resultsMap = null;
        if (COHUtil.isValidList(attachmentsList)) {
            List<Id> attachmentParentIDs = new List<Id>();
            for (Attachment attachmentObj : attachmentsList) {
                attachmentParentIDs.add(attachmentObj.ParentId);
            }
            
            resultsMap = new Map<Id, String>();
            List<ITS_Project_Request__c> IIRObjList = [select Id, ITS_Application__c from ITS_Project_Request__c where Id in :attachmentParentIDs];
            for (ITS_Project_Request__c IIRObj : IIRObjList) {
                resultsMap.put(IIRObj.Id, IIRObj.ITS_Application__c);
            }
        }
        return resultsMap;
    }

    /*
     * Check if the parent ITS_Project_Request__c object belongs to a list of
     * valid applications.
     * 
     * @param	applicationName		Name of the application that created the ITS_Project_Request__c object.
     * @return						true if it is valid, false otherwise.
     * 
     */
	private static Boolean isValid(String applicationName) {
        Boolean retVal = false;
        if (COHUtil.isValidStr(applicationName)) {
            for (COH_App_Configuration__c appConfigObj : mIIRConfigurationGroup) {
                String validApplicationName = appConfigObj.Value__c;
                if (applicationName.equalsIgnoreCase(validApplicationName)) {
                    retVal = true;
                    break;
                }
            }
        }
        return retVal;
    }
    
    /*
     * Create an email message and attach the Attachment.
     * 
     * @param	IIRObj			The parent ITS_Project_Request__c object of the Attachment.
     * @param	attachmentObj	The Attachment object.
     * @return					The email object that will be sent out.
     * 
     */
	private static Messaging.SingleEmailMessage  createEmailMessage(ITS_Project_Request__c IIRObj, Attachment attachmentObj) {
		Messaging.SingleEmailMessage email = null;
        if (IIRObj != null) {
            
            email = new Messaging.SingleEmailMessage();
            email.Subject = mEmailSubject + ' #' + IIRObj.Project_ID__c;
            email.setToAddresses(mEmailToAddresses);     
			String textBody = buildEmailTextBody(IIRObj);
            email.setHTMLBody(textBody);
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attachmentObj.Name);
            efa.setBody(attachmentObj.Body);
            efa.setContentType(attachmentObj.ContentType);
            efa.setInline(false);
            List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
            attachmentList.add(efa);
            email.setFileAttachments(attachmentList);
        }
        return email;
    }
    
    /*
     * Create the body of the email text body.
     * 
     * @param	IIRObj			The parent ITS_Project_Request__c object of the Attachment.
     * @return					The text of the email body.
     * 
     */
    private static String buildEmailTextBody(ITS_Project_Request__c IIRObj) {
        String textBody = null;
        if (IIRObj != null) {
            String objUrl = mHyperlinkPrefix + IIRObj.Id;
            
            // retrieve the information from the User table
            List<Id> userIDList = new List<Id>();
            userIDList.add(IIRObj.OwnerId);
            userIDList.add(IIRObj.Requestor_Name__c);
            userIDList.add(IIRObj.Business_Project_Lead_Mgr__c);
            userIDList.add(IIRObj.Director__c);
            userIDList.add(IIRObj.VP__c);
            
            Map<Id, User> userResultList = new Map<Id, User>([select Id, Name from User where id in :userIDList]);
            String ownerName = getUserName(IIRObj.OwnerId, userResultList);
            String requestorName = getUserName(IIRObj.Requestor_Name__c, userResultList);
            String BPLeadMgrName = getUserName(IIRObj.Business_Project_Lead_Mgr__c, userResultList);
            String directorName = getUserName(IIRObj.Director__c, userResultList);
            String VPName = getUserName(IIRObj.VP__c, userResultList);

        	textBody = 
                '<br><br><h3><u>CUSTOMER DETAIL</u></h3>' +
                '<br>&nbsp&nbsp&nbsp&nbsp <b>Requestor Name:</b> ' + requestorName + 
            	'<br><br>&nbsp&nbsp&nbsp&nbsp <b>Requesting Department:</b> ' + IIRObj.Requesting_Department_Readonly__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Business Project Lead/Mgr:</b> ' + BPLeadMgrName + 
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Requesting Director:</b> ' + directorName +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Requesting VP:</b> ' + VPName +
                '<br><br><h3><u>REQUEST DETAIL</u></h3>' +
                '<br>&nbsp&nbsp&nbsp&nbsp <b>Project Title:</b> ' + IIRObj.Name + 
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Intake ID#:</b> ' + IIRObj.Project_ID__c + 
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Owner:</b> ' + ownerName +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Application:</b> ' + IIRObj.ITS_Application__c + 
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Request Type:</b> ' + IIRObj.Request_Type__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>IRB Approval:</b> ' + IIRObj.IRB_Approval__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>IRB Number:</b> ' + IIRObj.IRB_Number__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>ITS Capital Funding Request:</b> ' + IIRObj.Capital_Funding__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Capital Funding Amount:</b> ' + IIRObj.Capital_Funding_Amount__c +
	            '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Operating Funding Amount:</b> ' + IIRObj.Operating_Funding_Amount__c + 
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Assigned Priority:</b> ' + IIRObj.IT_Assigned_Priority__c +
                '<br><br>&nbsp&nbsp&nbsp&nbsp <b>Description:</b><br>\n' + IIRObj.Description__c +
                '<br>==========================================================' +
    	        '<br>&nbsp&nbsp&nbsp&nbsp Please <a href="' + objUrl + '">Click Here</a> to open the request details.' +
                '<br>==========================================================';
                
        }    
        return textBody;
    }
    
    /*
     * Retrieve the Name field from a User object stored in a Map
     * 
     * @param	objID		ID of the User object.
     * @param	userMap		Map of User objects where the ID is the key.
     * @return				The value of the Name field.
     * 
     */
    private static String getUserName(Id objID, Map<Id, User> userMap) {
        String retVal = '';
        if (objID != null && userMap != null) {
            User userObj = userMap.get(objID);
            if (userObj != null) {
                retVal = userObj.Name;
            }
        }
        return retVal;
    }
}