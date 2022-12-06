/*
 * This class contains the methods for handling trigger events for FeedItem objects.
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
public class COHFeedItemHelper {
/*
	// Class constants    
    private static final String COH_BP_RULE = 'COH_Blue_Pencil_Rule__c';
    private static final String COH_BP_CONFIG_GROUP = 'COH_Blue_Pencil_Config_Group__c';
    
    // COH App Configuration constants
	private static final String	CHATTER_BP_APP = 'Chatter Blue Pencil';
    private static final String	CHATTER_BP_EMAIL_SUBJECT = 'Chatter Blue Pencil Email Subject';
    private static final String	CHATTER_BP_VIOLATION_EMAIL = 'Chatter Blue Pencil Violation Email';
	private static final String CHATTER_BP_VIOLATION_ADMIN_NAME = 'Chatter Blue Pencil Admin Email Name';
	private static final String CHATTER_BP_ADD_ERROR_MESSAGE = 'Chatter Blue Pencil addError Message';
	private static final String CHATTER_BP_LOG_INTRO = 'Chatter Blue Pencil Log Intro';
    
	// Miscellaneous constants    
	private static final String QUESTION_POST_TYPE = 'QuestionPost';	// Title updates allowed only for QuestIonPost types
    private static final String ID_DELIMITER = ';';
	private static final String	REGEX_WORD_BOUNDARY = '\\b';

    // Map Chatter Group configuration Names to the actual objects
    private static Map<String, COH_Blue_Pencil_Config_Group__c> mChatterGroupConfigurationToObjectMap =  new Map<String, COH_Blue_Pencil_Config_Group__c>();

    // Map Rule Names to the actual objects
    private static Map<String, COH_Blue_Pencil_Rule__c> mRuleToObjectMap =  new Map<String, COH_Blue_Pencil_Rule__c>();

	// Map Chatter Group configuration IDs to the list of associated Rules
    private static Map<String, List<COH_Blue_Pencil_Rule__c>> mChatterGroupConfigToRulesMap =  new Map<String, List<COH_Blue_Pencil_Rule__c>>();
    
    // Map actual CollaborationGroup (e.g. Chatter Group) IDs to the the list of applicable Chatter Group configuration objects
    private static Map<Id, List<COH_Blue_Pencil_Config_Group__c>> mCollaborationGroupIDToGroupConfigMap = new Map<Id, List<COH_Blue_Pencil_Config_Group__c>>();

    // Map User IDs to the actual objects
	private static Map<Id, User> mUserIDToObjectsMap = new Map<Id, User>();
    
    // Map Profile IDs to Collaboration Groups
    private static Map<Id, List<COH_Blue_Pencil_Config_Group__c>> mProfileIDToGroupConfigMap = new Map<Id, List<COH_Blue_Pencil_Config_Group__c>>();
    
	
	private static String mChatterMonitorRuleRecordTypeID = null;			// Chatter Monitor Rule record type
	private static String mChatterMonitorConfigGroupRecordTypeID = null;	// Chatter Monitor Config Group record type

    private static String mChatterMonitorSubject  = null;					// Default email subject for Chatter Monitor notifications
    private static String mChatterMonitorEmailAddress  = null;				// Default email address for Chatter Monitor notifications
    private static String mChatterMonitorAdminName = null;					// Default name for the Chatter Monitor email greeting
	private static String mChatterMonitorAddErrorMsg = null;				// Default message to use for Chatter Monitor addError()
    private static String mChatterLogIntro = null;							// Default introduction for Chatter Log emails and audit trails.
    
    static {
		mapRuleNamesToObjects();
        mapChatterGroupConfigurationNamesToObjects();
		mapChatterGroupConfigurationToRules();
        mapCollaborationGroupIDToGroupConfig();
        mapUserIDsToObjects();
        mapProfileIDToCollabGroups();
		mChatterMonitorEmailAddress = (String) COHUtil.getConfigurationValue(CHATTER_BP_APP, CHATTER_BP_VIOLATION_EMAIL);
		mChatterMonitorAdminName = (String) COHUtil.getConfigurationValue(CHATTER_BP_APP, CHATTER_BP_VIOLATION_ADMIN_NAME);
		mChatterMonitorSubject = (String) COHUtil.getConfigurationValue(CHATTER_BP_APP, CHATTER_BP_EMAIL_SUBJECT);
		mChatterMonitorAddErrorMsg = (String) COHUtil.getConfigurationValue(CHATTER_BP_APP, CHATTER_BP_ADD_ERROR_MESSAGE);
        mChatterLogIntro = (String) COHUtil.getConfigurationValue(CHATTER_BP_APP, CHATTER_BP_LOG_INTRO);
    }    
*/    
    /*
     * Map Rule Names to their actual objects.  The results are stored in the mRuleToObjectMap
     * variable.
     * 
     */
/*    
    private static void mapRuleNamesToObjects() {

        String getRuleObjectsSOQL = COHUtil.buildSelectAllSOQLStatement(COH_BP_RULE) +
            ' where Is_Active__c = true and Name != null';
        
        List<COH_Blue_Pencil_Rule__c> ruleObjects = Database.query(getRuleObjectsSOQL);
        if (COHUtil.isValidList(ruleObjects)) {
            for (COH_Blue_Pencil_Rule__c ruleObj : ruleObjects) {
                mRuleToObjectMap.put(ruleObj.Name, ruleObj);
            }
        }
    }
*/    
    /*
     * Map Chatter Group configuration Names to their actual objects.  The results are
     * stored in the mChatterGroupConfigurationToObjectMap variable.
     * 
     */
/*    
    private static void mapChatterGroupConfigurationNamesToObjects() {

        String getChatterGroupConfigurationObjectsSOQL = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP) +
            ' where Is_Active__c = true and Name != null';

        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigObjects = Database.query(getChatterGroupConfigurationObjectsSOQL);
        if (COHUtil.isValidList(chatterGroupConfigObjects)) {
            for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigObjects) {
                mChatterGroupConfigurationToObjectMap.put(chatterGroupConfigObj.Name, chatterGroupConfigObj);
            }
        }
    }
*/    
    /*
     * Map Chatter Group config objects to their associated Rules.  The key is the Name of the Chatter
     * Group config object, and the value is a list of associated Rule objects.  The map is stored in the 
     * mChatterGroupConfigToRulesMap variable.
     * 
     */
/*    
    private static void mapChatterGroupConfigurationToRules() {

        String getChatterGroupConfigurationObjectsSOQL = COHUtil.buildSelectAllSOQLStatement(COH_BP_CONFIG_GROUP) +
            ' where Is_Active__c = true and Name != null';

        List<COH_Blue_Pencil_Config_Group__c> chatterGroupConfigObjects = Database.query(getChatterGroupConfigurationObjectsSOQL);
        if (COHUtil.isValidList(chatterGroupConfigObjects)) {
            for (COH_Blue_Pencil_Config_Group__c chatterGroupConfigObj : chatterGroupConfigObjects) {
                String cgcName = chatterGroupConfigObj.Name;
                String ruleNameList = chatterGroupConfigObj.Rule_Names__c;
                if (!String.isEmpty(ruleNameList)) {
			        List<COH_Blue_Pencil_Rule__c> ruleList = new List<COH_Blue_Pencil_Rule__c>();
                    List<String> ruleNames = ruleNameList.split(ID_DELIMITER);
                    for (String ruleName : ruleNames) {
                        COH_Blue_Pencil_Rule__c ruleObj = mRuleToObjectMap.get(ruleName);
	                    // Add rules if they are valid.  Otherwise, throw an exception
                        if (ruleObj != null) {
							ruleList.add(ruleObj);        
                        } else {
                            throw new COHException('COHFeedItemHelper.mapChatterGroupConfigurationToRules(): group configuration \'' + cgcName + '\' has an invalid ruleName: \'' + ruleName + '\'');
                        }
                    }
                    mChatterGroupConfigToRulesMap.put(cgcName, ruleList);
                }
            }
        }
    }
*/    
    /*
     * Map the actual CollaborationGroup IDs (e.g. Chatter Group) to the list
     * of associated Configuration Groups.  The results are stored in the 
     * mCollaborationGroupIDToGroupConfigMap variable.
     * 
     */
/*    
    private static void mapCollaborationGroupIDToGroupConfig() {
        List<COH_Blue_Pencil_Config_Group__c> configObjectList = mChatterGroupConfigurationToObjectMap.values();
        if (COHUtil.isValidList(configObjectList)) {
            for (COH_Blue_Pencil_Config_Group__c configObj : configObjectList) {
                String allCollaborationGroupIDs = configObj.Chatter_Group_IDs0__c;
                if (String.isNotBlank(allCollaborationGroupIDs)) {
                    List<String> collabGroupIDList = allCollaborationGroupIDs.split(ID_DELIMITER);
                    // Check if the collaboration group already has associated group configuration objects.
                    // If so, append new rule(s) to the existing rule(s).
                    for (String collabGroupID : collabGroupIDList) {
                        // Eliminate duplicate configuration objects.  This is worth the extra step 
                        // because the string scanning would be significant for long text strings
                        // if duplicate rules were used.
                        Map<String, COH_Blue_Pencil_Config_Group__c> configMap = new Map<String, COH_Blue_Pencil_Config_Group__c>();
                        List<COH_Blue_Pencil_Config_Group__c> existingConfigObjList = mCollaborationGroupIDToGroupConfigMap.get(collabGroupID);
                        if (COHUtil.isValidList(existingConfigObjList)) {
                            for (COH_Blue_Pencil_Config_Group__c existingConfigObj : existingConfigObjList) {
                                configMap.put(existingConfigObj.Name, existingConfigObj);
                            }                 
                        }
                        configMap.put(configObj.Name, configObj);
                        // Convert any 15 character Collab Group ID to the 18 character format used by Apex.
                        // An 18 character ID is returned if it was passed in as the argument.
                        mCollaborationGroupIDToGroupConfigMap.put(Id.valueOf(collabGroupID), configMap.values());
                    }
                }
				// Repeat the above procedure for configObj.Chatter_Group_IDs1__c.  It doesn't matter
				// if there are duplicate collaboration group IDs in both CG_Chatter_Group_IDs0__c 
				// and Chatter_Group_IDs1__c. They will both still point to the same Configuration Group
				// object.
				
                String allCollaborationGroupIDs1 = configObj.Chatter_Group_IDs1__c;
                if (String.isNotBlank(allCollaborationGroupIDs1)) {
                    List<String> collabGroupIDList = allCollaborationGroupIDs1.split(ID_DELIMITER);
                    // Check if the collaboration group already has associated group configuration objects.
                    // If so, append new rule(s) to the existing rule(s).
                    for (String collabGroupID : collabGroupIDList) {
                        // Eliminate duplicate configuration objects.  This is worth the extra step 
                        // because the string scanning would be significant for long text strings
                        // if duplicate rules were used.
                        Map<String, COH_Blue_Pencil_Config_Group__c> configMap = new Map<String, COH_Blue_Pencil_Config_Group__c>();
                        List<COH_Blue_Pencil_Config_Group__c> existingConfigObjList = mCollaborationGroupIDToGroupConfigMap.get(collabGroupID);
                        if (COHUtil.isValidList(existingConfigObjList)) {
                            for (COH_Blue_Pencil_Config_Group__c existingConfigObj : existingConfigObjList) {
                                configMap.put(existingConfigObj.Name, existingConfigObj);
                            }                 
                        }
                        configMap.put(configObj.Name, configObj);
                        // Convert any 15 character Collab Group ID to the 18 character format used by Apex.
                        // An 18 character ID is returned if it was passed in as the argument.
                        mCollaborationGroupIDToGroupConfigMap.put(Id.valueOf(collabGroupID), configMap.values());
                    }
                }                
            }
        }
                
    }
*/    
    /* 
     * Map User IDs to their respective User objects.  The results will be stored
     * in the mUserIDToObjectsMap variable.
     * 
     */
/*    
    private static void mapUserIDsToObjects() {
        List<COH_Blue_Pencil_Config_Group__c> configObjectList = mChatterGroupConfigurationToObjectMap.values();
        if (COHUtil.isValidList(configObjectList)) {
            List<Id> userIDList = new List<Id>();
            for (COH_Blue_Pencil_Config_Group__c configObj : configObjectList) {
                userIDList.add(configObj.Contact_Person__c);
            }
            
            String getUserSOQLQuery = 'select Id, Name, Email from User where Id in :userIDList';
            List<User> userList = Database.query(getUserSOQLQuery);
            if (COHUtil.isValidList(userList)) {
                for (User userObj : userList) {
                    mUserIDToObjectsMap.put(userObj.Id , userObj);
                }
            }
        }
    }
*/    
    /*
     * Map Profile IDs to the list of applicable Collaboration Group Config objects.
     * The results are stored in the mProfileIDToGroupConfigMap variable.
     * 
     */
/*    
    private static void mapProfileIDToCollabGroups() {
		List<COH_Blue_Pencil_Config_Group__c> configObjList = mChatterGroupConfigurationToObjectMap.values();
        if (COHUtil.isValidList(configObjList)) {
            for (COH_Blue_Pencil_Config_Group__c configObj : configObjList) {
                String allProfileIDs = configObj.Profile_IDs0__c;
                if (String.isNotEmpty(allProfileIDs)) {
                    List<String> profileIDsList = allProfileIDs.split(ID_DELIMITER);
                    Map<String, String> profileIDMap = new Map<String, String>();
                    // Remove duplicate Profile IDs
                    for (String profileID : profileIDsList) {
                        profileIDMap.put(profileID, profileID);
                    }
                    List<String> uniqueProfileIDLIst = profileIDMap.values();
                    for (String tempUniqueProfileID : uniqueProfileIDLIst) {
                        // convert from 15 character to the 18 character format used by Apex.
                        Id uniqueProfileID = Id.valueOf(tempUniqueProfileID);	

                        // Insert into mProfileIDToGroupConfigMap
                        // If the ProfileID already has a Collab Group, append the new Collab Group to the list.
                        List<COH_Blue_Pencil_Config_Group__c> existingCollabGroupList = mProfileIDToGroupConfigMap.get(uniqueProfileID);
                        if (COHUtil.isValidList(existingCollabGroupList)) {
                            existingCollabGroupList.add(configObj);
                            mProfileIDToGroupConfigMap.put(uniqueProfileID, existingCollabGroupList);
                        } else {
                            List<COH_Blue_Pencil_Config_Group__c> newCollabGroupList = new List<COH_Blue_Pencil_Config_Group__c>();
                            newCollabGroupList.add(configObj);
                            mProfileIDToGroupConfigMap.put(uniqueProfileID, newCollabGroupList);
                        }
                    }
                }
            }
        }
    }
*/    
    /*
     * Process new FeedItems.
     * 
     * @param feedItemList			List of FeedItems to process
     * 
     */
/*    
    public static void processNewFeedItems(List<FeedItem> feedItemList) {
        if (COHUtil.isValidList(feedItemList)) {
            List<ScanResults> scanResultsList = new List<ScanResults>();
            for (FeedItem feedObj : feedItemList) {
    			Id parentID = feedObj.ParentId;
                // Retrieve rule set for each Group configuration object and process the FeedItem object.
                List<COH_Blue_Pencil_Config_Group__c> allValidGroupConfigObjects = mCollaborationGroupIDToGroupConfigMap.get(parentID);
                
                // Chatter Group rules take precedence over individual profiles.
                if (COHUtil.isValidList(allValidGroupConfigObjects))  {
                    // Apply the rules to the current FeedItem object.  Even if a breach 
                    // occurs, continue examining the rest of the rules for further breaches.
                    for (COH_Blue_Pencil_Config_Group__c groupConfigObj : allValidGroupConfigObjects) {
                        ScanResults sResults = sanitizeFeedItem(groupConfigObj, feedObj);
                        if (sResults != null) {
                            sResults.enableAuditTrail = groupConfigObj.Enable_Audit_Trail__c;
                            scanResultsList.add(sResults); 
                            if (sResults.suppressPost == true) {
								// Signal an error if necessary to prevent the FeedItem object from being inserted.
								feedObj.addError(mChatterMonitorAddErrorMsg  + '. CG name: ' + groupConfigObj.Name);
                            }
                        }
                    }
                } else {

                    // Retrieve the Config Groups that apply for each sender and receiver
                    Map<String, COH_Blue_Pencil_Config_Group__c> configGroupsMap = new Map<String, COH_Blue_Pencil_Config_Group__c>();

                    // If the FeedItem is not in a Chatter Group, check the Profile restrictions.
                    
                    // Retrieve the ProfileID from the ParentID.  
                    // When a chatter message is sent to another user or to followers, 
                    // the ParentID is for the receiver.  The sender's ID is not yet stored 
                    // in the CreatedById and InsertedById fields.  This class is run off
                    // a "before" trigger
                    User receiverUserObj = [select Id, ProfileId from User where Id = :parentID  limit 1];
                    Id receiverProfileID = null;
                    if (receiverUserObj != null) {
                        receiverProfileID = receiverUserObj.ProfileId;
                    } else {
                        throw new COHException('COHFeedItemHelper.processNewFeedItems(): Unable to retrieve the ProfileID for parentID: ' + parentID);
                    }
                    
                    if (receiverProfileID != null) {
                        List<COH_Blue_Pencil_Config_Group__c> configObjList = mProfileIDToGroupConfigMap.get(receiverProfileID);
                        if (COHUtil.isValidList(configObjList)) {
                            for (COH_Blue_Pencil_Config_Group__c configObj : configObjList) {
                                configGroupsMap.put(configObj.Name, configObj);
                            }
                        }
                    }
                    Id createdByID = feedObj.CreatedById;
                    if (createdByID != null) {
                        List<COH_Blue_Pencil_Config_Group__c> configObjList = mProfileIDToGroupConfigMap.get(createdByID);
                        if (COHUtil.isValidList(configObjList)) {
                            for (COH_Blue_Pencil_Config_Group__c configObj : configObjList) {
                                configGroupsMap.put(configObj.Name, configObj);
                            }
                        }
                    }
                    Id insertedByID = feedObj.InsertedById;
                    if (insertedByID != null) {
                        List<COH_Blue_Pencil_Config_Group__c> configObjList = mProfileIDToGroupConfigMap.get(insertedByID);
                        if (COHUtil.isValidList(configObjList)) {
                            for (COH_Blue_Pencil_Config_Group__c configObj : configObjList) {
                                configGroupsMap.put(configObj.Name, configObj);
                            }
                        }
                    }
                    
                    // Now that the duplicates have been removed, get all applicable config objects
                    List<COH_Blue_Pencil_Config_Group__c> allValidGroupConfigObjectsForProfile = configGroupsMap.values();
                    if (COHUtil.isValidList(allValidGroupConfigObjectsForProfile))  {
                        // Apply the rules to the current FeedItem object.  Even if a breach 
                        // occurs, continue examining the rest of the rules for further breaches.
                        for (COH_Blue_Pencil_Config_Group__c groupConfigObj : allValidGroupConfigObjectsForProfile) {
                            ScanResults sResults = sanitizeFeedItem(groupConfigObj, feedObj);
                            if (sResults != null) {
                                sResults.enableAuditTrail = groupConfigObj.Enable_Audit_Trail__c;
                                scanResultsList.add(sResults); 
                                if (sResults.suppressPost == true) {
                                    // Signal an error if necessary to prevent the FeedItem object from being inserted.
                                    feedObj.addError(mChatterMonitorAddErrorMsg  + '. CG name: ' + groupConfigObj.Name);
                                }
                            }
                        }
                    }
                }
            }

            // Iterate through all SanitizeResult objects to create audit logs as needed.
            List<COH_Log__c> logObjectList = createAuditLogMessages(scanResultsList);
            if (COHUtil.isValidList(logObjectList)) {
                Database.insert(logObjectList, false);
            }
        }
    }
*/
    
    /* 
	 * Sanitize the title and body of a FeedItem object.
	 * 
	 * @param groupConfigObj	Chatter Configuration object
	 * @param feedItemObj		FeedItem object to sanitize.    
	 * @return					ScanResults object containing the results of sanitizing the FeedItem object.
	 * 
	 */
/*    
    private static ScanResults sanitizeFeedItem(COH_Blue_Pencil_Config_Group__c groupConfigObj, FeedItem feedItemObj) {
        ScanResults sResults = new ScanResults();
        if (groupConfigObj != null && feedItemObj != null) {
            
            Boolean notificationEnabled = groupConfigObj.Enable_Notification__c;
            
            // Retrieve all the rules for the CollaborationGroup
            String configGroupName = groupConfigObj.Name;
            Boolean suppressPostOnBreach = groupConfigObj.Suppress_Post_on_Breach__c;
            List<COH_Blue_Pencil_Rule__c> allValidRules = mChatterGroupConfigToRulesMap.get(configGroupName);
            if (COHUtil.isValidList(allValidRules)) {
                for (COH_Blue_Pencil_Rule__c ruleObj :allValidRules ) {
                    // set the conditions for this rule
                    Boolean literalSearch = ruleObj.Literal_Search__c;
                    Boolean matchWholeWords = ruleObj.Match_Whole_Words__c;
                    String substitutionString = ruleObj.Substitution_Phrase__c;
                    String regularExpression = ruleObj.Regular_Expression__c;
    
                    // Sanitize the title on Inserts.  Titles can be updated only if the 
                    // FeedItem type is QUESTION_POST_TYPE.
                    SanitizeResult result;
                    String feedItemType = feedItemObj.Type;
                    if (Trigger.isInsert || feedItemType.equalsIgnoreCase(QUESTION_POST_TYPE)) {
                        result = sanitizeString(feedItemObj.Title, regularExpression, substitutionString, 
                                                literalSearch, matchWholeWords);
                        if (result.regExprFound) {
				            result.ruleName = ruleObj.Name;
							sResults.addResultObject(result);
                            sResults.configObjectName = configGroupName;
                            
                            feedItemObj.Title = result.newString;
                            if (notificationEnabled) {
                                sendEmail(groupConfigObj, ruleObj, feedItemObj, result);
                            }
                            // Suppress post for inserts
                            if (Trigger.isInsert && suppressPostOnBreach) {
								sResults.suppressPost = true;
                            }
                        }            
                    }
                    
                    // Sanitize the body
                    result = sanitizeString(feedItemObj.Body, regularExpression, substitutionString, 
                                            literalSearch, matchWholeWords);
                    if (result.regExprFound) {
			            result.ruleName = ruleObj.Name;
                        sResults.addResultObject(result);
                        sResults.configObjectName = configGroupName;
                        
                        feedItemObj.Body = result.newString;
                        if (notificationEnabled) {
                            sendEmail(groupConfigObj, ruleObj, feedItemObj, result);
                        }
                        // Suppress post for inserts
                        if (Trigger.isInsert && suppressPostOnBreach) {
							sResults.suppressPost = true;
                        }
                    }            
                }
            }
            
        }
       return sResults;
    }
*/    
    /*
     * Scans a string for a regular expression and creates a new string
     * where all instances of the regular expression have been replaced by the
     * substitutionStr string.  If the matchLiteral parameter is set to true,
     * a literal search on the regExpr parameter will be done.  It will NOT be 
     * evaluated as a true regular epxression.
     * 
     * For example, if the regExpr parameter is "[a-z]", it will be found in "123[a-z]"
     * but not in "x".
     * 
     * @param sourceStr			Original source string.
     * @param regExpr			Regular expression to search for.
     * @param substitutionStr	Substitution string to replace the regExpr in sourceStr.
     * @param matchLiteral		true if the regExpr parameter should be treated as a literal string.
     * @param matchWholeWords	true if only whole word matching is required, false otherwise.
     * @return					SanitizeResult object containing the new string where all
     * 							instances of the regExpr have been replaced with substitutionStr.
     * 
     */
/*    
    private static SanitizeResult sanitizeString(String sourceStr, String regExpr, 
                                                 String substitutionStr, Boolean matchLiteral, 
                                                 Boolean matchWholeWords) {
                                                     
		SanitizeResult result = new SanitizeResult(sourceStr);
                                                     
        if (String.isNotEmpty(sourceStr) && String.isNotEmpty(regExpr)) {
	        String newRegExpr = regExpr;
            if (matchLiteral) {  					// treat regExpr as a literal string
                newRegExpr = COHUtil.createLiteralRegExprSearchString(regExpr, matchWholeWords, true);
            } else if (matchWholeWords) {			// regular expression search, not a literal string
                newRegExpr = REGEX_WORD_BOUNDARY + regExpr + REGEX_WORD_BOUNDARY;
            }
            
            String newString = sourceStr.replaceAll(newRegExpr, substitutionStr);
            if (!sourceStr.equals(newString)) {
                result.regExprFound = true;
            } else {
                result.regExprFound = false;
            }
            result.newString = newString;	
        }
    
        return result;
    }
*/    
    /* 
     * Send an email to the admin in charge of a Chatter Group configuration where a rule
     * violation has occurred.
     * 
     * @param groupConfigObj		Chatter Group configuration object.
     * @param feedItemObj			FeedItem object where the violation occurred.
     * @param ruleObj				Rule that was violated.
     * @param result				Stores the results of the Strng sanitization processing.
     * 
     */
/*    
    private static void sendEmail(COH_Blue_Pencil_Config_Group__c groupConfigObj, COH_Blue_Pencil_Rule__c ruleObj, 
                                  FeedItem feedItemObj, SanitizeResult result) {
    
		if (groupConfigObj != null && ruleObj != null && feedItemObj != null && result != null) {

            Messaging.SingleEmailMessage emailMessage = createEmailMessage(groupConfigObj, ruleObj, feedItemobj, result);
            if (emailMessage != null && !test.isRunningTest()) {
	            try {
                    Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {emailMessage});
                } catch (Exception e) {
                	throw new COHException('COHFeedItemHelper.sendEmail(): Could not send emails: ' + e.getMessage());
            	}
            }
        }
    }
*/
    /*
     * Create an email message
     * 
     * @param groupConfigObj		Chatter Group configuration object.
     * @param ruleObj				Rule that was violated.
     * @param feedItemObj			FeedItem object where the violation occurred.
     * @param result				Stores the results of the Strng sanitization processing.
     * @return                      The email object that will be sent out.
     * 
     */
/*    
    private static Messaging.SingleEmailMessage createEmailMessage(COH_Blue_Pencil_Config_Group__c groupConfigObj, 
                                                                   COH_Blue_Pencil_Rule__c ruleObj, 
                                                                   FeedItem feedItemObj, 
                                                                   SanitizeResult result) {
        
        Messaging.SingleEmailMessage email = null;
		if (groupConfigObj != null && ruleObj != null && feedItemObj != null && result != null) {
            String textBody = buildEmailTextBody(groupConfigObj, ruleObj, feedItemObj, result);

            if (textBody != null) {
                User userObj = mUserIDToObjectsMap.get(groupConfigObj.Contact_Person__c);
                String emailAddr = (userObj == null ? mChatterMonitorEmailAddress : userObj.Email);
                email = new Messaging.SingleEmailMessage();
                email.setReplyTo(emailAddr);
	            email.setToAddresses(new String[] {emailAddr}); 
                email.Subject = mChatterMonitorSubject;
                email.setHTMLBody(textBody);
            }
        }
        return email;
    }
*/    
    /*
     * Create the email text body.
     * 
     * @param groupConfigObj		Chatter Group configuration object.
     * @param ruleObj				Rule that was violated.
     * @param feedItemObj			FeedItem object where the violation occurred.
     * @param result				The results of the Strng sanitization processing.
     * @return                      The text of the email body.
     * 
     */
/*    
    private static String buildEmailTextBody(COH_Blue_Pencil_Config_Group__c groupConfigObj, 
                                             COH_Blue_Pencil_Rule__c ruleObj, 
                                             FeedItem feedItemObj, 
                                             SanitizeResult result) {
        String textBody = null;
        if (groupConfigObj != null && ruleObj != null && feedItemObj != null && result != null) {
			User userObj = mUserIDToObjectsMap.get(groupConfigObj.Contact_Person__c);
			String emailName = (userObj == null ? mChatterMonitorAdminName : userObj.Name);

            String textBody0 = 'Dear ' + emailName + ':';
            String textBody1 = '<br><br>' + mChatterLogIntro;
            
            String textBody2 = '<br><br>Configuration Group Name: ' + groupConfigObj.Name;
            String textBody3 = '<br>Rule Name: ' + ruleObj.Name;
            String textBody4 = '<br>Original text: ' + result.oldString;
            String textBody5 = '<br>Modified text: ' + result.newString;
            String userURL = URL.getSalesforceBaseURL().toExternalForm() + '/' + feedItemObj.ParentId;
            String textBody6 = '<br><br> <a href="' + userURL + '">' + 'Click Here To Access This Chatter Group'  + '</a> ';
            String textBody7 = '<br><br>Ref: ' + feedItemObj.ParentId + '<br>';
            
            textBody = textBody0 + textBody1 + textBody2 + textBody3 + textBody4 + textBody5 + textBody6 + textBody7;
        }    
        return textBody;
    }    
*/
	/*
	 * Create a list of COH_Log__c objects for audit log reasons.
	 * 
     * @param scanResultsList		The list of results of scanning for violations
     * @return						List of COH_Log__c objects to be inserted.
     * 
     */
/*    
    private static List<COH_Log__c> createAuditLogMessages(List<ScanResults> scanResultsList) {
		List<COH_Log__c> logObjectsList = new List<COH_Log__c>();
		if(COHUtil.isValidList(scanResultsList)) {
            for (ScanResults sResultObj : scanResultsList) {
                List<SanitizeResult> sanitizeResultList = sResultObj.resultList;
                Boolean enableAuditTrail = sResultObj.enableAuditTrail;
                if (enableAuditTrail && COHUtil.isValidList(sanitizeResultList)) {
                    String configObjName = sResultObj.configObjectName;
		            // Iterate through all SanitizeResult objects to create audit logs as needed.
                    for (SanitizeResult sanitizeResultObj : sanitizeResultList) {
                        String text0 = ' Config Group Name: ' + configObjName + '|' + 'Rule Name: ' + sanitizeResultObj.ruleName + '|';
                        String previousText = 'Previous text: ' + sanitizeResultObj.oldString + '|';
                        String submittedText = 'Submitted text: ' + sanitizeResultObj.newString;
                        String message = mChatterLogIntro + text0 + previousText + submittedText;

                        COH_Log__c logObj = new COH_Log__c();
                        logObj.Application_Name__c = CHATTER_BP_APP;
                        logObj.Level__c = COHUtil.WARN;
                        logObj.Location__c = 'COHFeedItemHelper.processNewFeedItems()';
                        logObj.Message__c = message;
                        logObjectsList.add(logObj);
                    }
                }
            }
        } 
        return logObjectsList;
    }
*/    
    /*
     *   Inner class containing the result of sanitizing a string.    
     * 
     */
/*    
    private class SanitizeResult {
        private Boolean regExprFound {set; get;}	// true if a regular expression was found
        private String ruleName {set; get;}			// Name of the rule being applied
        private String newString {set; get;}		// New string where the regular expression 
        											// has been replaced.
        private String oldString {set; get;}		// Old string where the regular expression 
        											// has NOT been replaced.
        
        //
        // Constructor.  Set the value of newString to the str parameter.
        // 
        // @param str	Value to be used for the newString and oldString member variables.
        // 
        
        public SanitizeResult(String str) {
            newString = str;
            oldString = str;
            regExprFound = false;
        	this.ruleName = ruleName;
        }
    }
*/    
    /*
     *   Inner class containing the list of results of sanitizing a FeedItem object.    
     * 
     */
/*    
    private class ScanResults {
        private List<SanitizeResult> resultList {set; get;}		// List of SanitizeResult objects.
        private String configObjectName {set; get;}				// Name of the configuration object
        private Boolean suppressPost {set; get;}				// True if the post it to be suppressed, false otherwise
        private Boolean enableAuditTrail {set; get;}			// True to enable the audit trail, false otherwise
        
        //
        // Default constructor.  Set the value of newString to the str parameter.
        // 
        public ScanResults() {
            this.resultList = null;
            this.configObjectName = null;
            this.suppressPost = false;
            this.enableAuditTrail = false;
        }
        
        //
        // Add a SanitizeResult object to the resultList member variable.
        // 
        // @param resultObject		SanitizeResult object to add.
        // 
         
        public void addResultObject(SanitizeResult resultObj) {
            if (resultObj != null) {
                if (resultList == null) {
                    resultList = new List<SanitizeResult>();
                }
                resultList.add(resultObj);
            }
        }
    }
*/    
}