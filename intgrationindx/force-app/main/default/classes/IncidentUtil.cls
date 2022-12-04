/*
 * This class contains methods to prcoesses BMCServiceDesk__Incident__c objects.  It
 * was originally written by consultants.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2018
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public with sharing class IncidentUtil {
    
    private static final String VBLOCK_INCIDENT = 'VBlock Incident';
    private static final String SUMMARY_START_TOKEN = 'Summary Start Token';
    private static final String ALERT_DEFINITION_NAME_TOKEN = 'Alert Definition Name Token';
    private static final String CLIENT_ID = 'Client ID';
    private static final String INCIDENT_SOURCE = 'Incident Source';
    private static final String LINE_BREAK = '\n';
    private static final String EOL_TOKEN = 'EOLToken';
    private static final String SPACE = ' ';

    private static String mSummaryStartToken = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, SUMMARY_START_TOKEN);
    private static String mSummaryEndToken = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, ALERT_DEFINITION_NAME_TOKEN);
    private static String mBaseVRealizeMonitoringAlertID = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, CLIENT_ID);
    private static String mMailListen = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, INCIDENT_SOURCE);

    private String mAlertID;
    
    public void onBeforeInsert(List<BMCServiceDesk__Incident__c> listIncidents){
        
        List<String> newAlertIDsList = new List<String>();
        for (BMCServiceDesk__Incident__c incidentObj : listIncidents) {
            String alertID = getAlertID(incidentObj);
            if (alertID != null) {
	            newAlertIDsList.add(alertID);
            }
        }
        
        String getExistingIncidentsSOQLQuery = 'select id, ownerid, isdeleted, name, bmcservicedesk__category_id__c, bmcservicedesk__fkclient__c,  bmcservicedesk__incidentdescription__c, alert_id__c from BMCServiceDesk__Incident__c  where alert_id__c in :newAlertIDsList';
        List<BMCServiceDesk__Incident__c> existingIncidentList = Database.query(getExistingIncidentsSOQLQuery);
        
        // Determine which alert IDs are associated with existing incidents.
        Map<String, BMCServiceDesk__Incident__c> alertIDToIncidentObjIDMap = new Map<String, BMCServiceDesk__Incident__c>();
        if (COHUtil.isValidList(existingIncidentList)) {
            for (BMCServiceDesk__Incident__c incidentObj : existingIncidentList) {
                if (String.isNotEmpty(incidentObj.alert_id__c)) {
                    alertIDToIncidentObjIDMap.put(incidentObj.alert_id__c, incidentObj);
                }
            }

        }
        
        // If the new record has the same alert ID as an existing record, copy the message
        // from the new object to the existing one and mark for later removal.

        Integer maxIndex = listIncidents.size();
        for (Integer index = 0; index < maxIndex; index++) {
            BMCServiceDesk__Incident__c newIncidentObj = listIncidents.get(index);
            String alertID = getAlertID(newIncidentObj);
            if (String.isNotEmpty(newIncidentObj.alert_id__c)) {
                BMCServiceDesk__Incident__c existingIncidentObj = alertIDToIncidentObjIDMap.get(alertID);
                if (existingIncidentObj != null) {
                    // Mark record for later deletion 
                    newIncidentObj.Delete_Record__c = true;
                    // Copy the new text to the existing object
                    existingIncidentObj.BMCServiceDesk__incidentDescription__c = newIncidentObj.BMCServiceDesk__incidentDescription__c;
                } else {
                    newIncidentObj.Delete_Record__c = false;
                }
            }
        }

        reformatSummaryAndDescription(listIncidents);
        
        //Set default business Service(ITS Service) on Incident
        setDefaultService(listIncidents);
        
        //Set default account on Incident
        setDefaultAccount(listIncidents);
        
        //Assign a Queue to an Incident with no Queue Selected based on the CI selected on the Incident.
        assignQueue(listIncidents);      
        
    }
    
    public void onBeforeInsert0(List<BMCServiceDesk__Incident__c> listIncidents){

        // Reformat the Summary and Description fields
        reformatSummaryAndDescription(listIncidents);
        
        //Set default business Service(ITS Service) on Incident
        setDefaultService(listIncidents);
        
        //Set default account on Incident
        setDefaultAccount(listIncidents);
        
        //Assign a Queue to an Incident with no Queue Selected based on the CI selected on the Incident.
        assignQueue(listIncidents);        
    }

    /*
     * Delete records that were marked for deletion by the onBeforeInsert() method.
     * 
     */
    public void onAfterInsert(List<BMCServiceDesk__Incident__c> listIncidents) {
    
        // Get the IDs of the objects that are duplicates
        List<BMCServiceDesk__Incident__c> duplicateObjects = new List<BMCServiceDesk__Incident__c>();
        List<Id> duplicateObjectIDs = new List<Id>();
        List<String> duplicateAlertIDs = new List<String>();
        for (BMCServiceDesk__Incident__c incidentObj : listIncidents) {
            if (incidentObj.Delete_Record__c == true) {
                duplicateObjectIDs.add(incidentObj.Id);
	            duplicateObjects.add(incidentObj);
                duplicateAlertIDs.add(incidentObj.Alert_ID__c);
            }
        }
        
        // Get the existing records based on AlertIDs
        Map<String, BMCServiceDesk__Incident__c> alertIDToIncidentMap = new Map<String, BMCServiceDesk__Incident__c>();
        String getExistingRecordsQuery = 'select Id, Alert_ID__c, BMCServiceDesk__incidentDescription__c from BMCServiceDesk__Incident__c where Alert_ID__c in :duplicateAlertIDs and Delete_Record__c <> true';
		List<BMCServiceDesk__Incident__c> existingRecords = Database.query(getExistingRecordsQuery);
        if (COHUtil.isValidList(existingRecords)) {
            for (BMCServiceDesk__Incident__c incidentObj : existingRecords) {
				alertIDToIncidentMap.put(incidentObj.Alert_ID__c, incidentObj);
            }
        }
  
        // Iterate through the duplicate objects.  Copy the inicident description to the existing object.
        // When it's saved, the trigger will reformat the new objects' incident decriptions.
        List<BMCServiceDesk__Incident__c> updatedObjects = new List<BMCServiceDesk__Incident__c>();
        for (BMCServiceDesk__Incident__c duplicateIncidentObj : duplicateObjects) {
            BMCServiceDesk__Incident__c existingIncidentObj = alertIDToIncidentMap.get(duplicateIncidentObj.Alert_ID__c);
            if (existingIncidentObj != null) {
	            existingIncidentObj.BMCServiceDesk__incidentDescription__c = duplicateIncidentObj.BMCServiceDesk__incidentDescription__c;
                updatedObjects.add(existingIncidentObj);
            } else {
                throw new COHException('IncidentUtil.onAfterInsert(): alert ID not found');
            }
        }
        
        if (COHUtil.isValidList(duplicateObjectIDs)) {
            Database.delete(duplicateObjectIDs);
        }

        if (COHUtil.isValidList(updatedObjects)) {
            Database.update(updatedObjects);
        }

    }
    
	/*
	 * Reformats the summary and description text into a more readable format.
	 * 
	 * @param listIncidents		List of BMCServiceDesk__Incident__c records to process
	 * 
	 */
    public void reformatSummaryAndDescription(List<BMCServiceDesk__Incident__c> listIncidents) {
        if (COHUtil.isValidList(listIncidents)) {
            
            for(BMCServiceDesk__Incident__c bmcIncidentObj : listIncidents) {
                String incidentSource = bmcIncidentObj.BMCServiceDesk__contactType__c;
                String baseClientID = bmcIncidentObj.BMCServiceDesk__FKClient__c;
                Id clientID = COHUtil.getLongID(baseClientID);
                Id vRealizeMonitoringAlertID = COHUtil.getLongID(mBaseVRealizeMonitoringAlertID);
                if (String.isNotEmpty(clientID) && clientID == vRealizeMonitoringAlertID && String.isNotEmpty(incidentSource) && incidentSource == mMailListen) {
                    String descriptionText = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
                    String newSummary = retrieveSummary(descriptionText, mSummaryStartToken, mSummaryEndToken);
                    bmcIncidentObj.Summary__c = newSummary;
                    String retrieveNewDescription = retrieveNewDescription(descriptionText, mSummaryStartToken, mSummaryEndToken);
                    bmcIncidentObj.BMCServiceDesk__incidentDescription__c = retrieveNewDescription;    
                    bmcIncidentObj.Alert_ID__c = mAlertID;
                }

            }
        }
    }
    
    /*
     * Retrieves the summary information from the allDescriptionText parameter.
     * 
     * @param	allDescriptionText		Original text that will be parsed to obtain the new summary.
     * @param	summaryStartToken		Token that marks the start of the summary information.
     * @param	summaryEndToken			Token that marks the end of the summary information.
     * @return							String containing the results.
     * 
     */
    @TestVisible 
    private String retrieveSummary(String descriptionText, String summaryStartToken, String summaryEndToken) {
        String newSummaryText = null;
        if (String.isNotEmpty(descriptionText) && String.isNotEmpty(summaryStartToken) && String.isNotEmpty(summaryEndToken)) {
            Integer summaryStartIndex = descriptionText.indexOf(summaryStartToken);
            if (summaryStartIndex >= 0) {
	            Integer summaryEndIndex = descriptionText.indexOf(summaryEndToken, summaryStartIndex);
                newSummaryText = descriptionText.substring(summaryStartIndex + 1, summaryEndIndex);	// ignore the colon
            }
        }
        return newSummaryText;
    }

    /*
     * Retrieve and reformat the description information from the descriptionText parameter.  
     * 
     * @param	descriptionText		Original text that will be parsed to obtain the new summary.
     * @param	summaryStartToken		Token that marks the start of the summary information.
     * @param	summaryEndToken			Token that marks the end of the summary information.
     * @return							String containing the results.
     * 
     */
    @TestVisible 
    private String retrieveNewDescription(String descriptionText, String summaryStartToken, String summaryEndToken) {

        String bodyToken = 'Body';
        String infoToken = ':Info';
        String alertNameToken = 'Alert Definition Name';    
        String alertDescriptionToken = 'Alert Definition Description';    
        String objectNameToken = 'Object Name';
        String objectTypeToken = 'Object Type';
        String alertImpactToken = 'Alert Impact';
        String alertStateToken = 'Alert State';
        String alertTypeToken = 'Alert Type';
        String alertSubTypeToken = 'Alert Sub-Type';
        String objectHealthStateToken = 'Object Health State';
        String objectRiskStateToken = 'Object Risk State';
        String objectEfficiencyToken = 'Object Efficiency State';
        String controlStateToken = 'Control State';
        String symptomsToken = 'Symptoms';
        String recommendationsToken = 'Recommendations';
        String notificationNameToken = 'Notification Rule Name';
        String notificationRuleToken = 'Notification Rule Description';
        String alertIDToken = 'Alert ID';
        String vcOpsServerToken = 'VCOps Server';
        
        String newDescriptionText = null;
        if (String.isNotEmpty(descriptionText) && String.isNotEmpty(summaryStartToken) && String.isNotEmpty(summaryEndToken)) {
            String tempStr = retrieveText(descriptionText, bodyToken, summaryStartToken);
			newDescriptionText = tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
                
            // Not really used.  It's a duplicate of retrieveSummary() but used in order to reduce the 
            // number of string comparisons.
            tempStr = retrieveText(descriptionText, summaryStartToken, summaryEndToken);
			descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
            
            tempStr = retrieveText(descriptionText, alertNameToken, alertDescriptionToken);
			newDescriptionText += tempStr + LINE_BREAK;
			descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
            
            tempStr = retrieveText(descriptionText, alertDescriptionToken, objectNameToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, objectNameToken, objectTypeToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, objectTypeToken, alertImpactToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, alertImpactToken, alertStateToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, alertStateToken, alertTypeToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, alertTypeToken, alertSubTypeToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, alertSubTypeToken, objectHealthStateToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, objectHealthStateToken, objectRiskStateToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, objectRiskStateToken, objectEfficiencyToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, objectEfficiencyToken, controlStateToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, controlStateToken, symptomsToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);
    
            tempStr = retrieveText(descriptionText, symptomsToken, recommendationsToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);

            tempStr = retrieveText(descriptionText, recommendationsToken, notificationNameToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);

            tempStr = retrieveText(descriptionText, notificationNameToken, notificationRuleToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);

            tempStr = retrieveText(descriptionText, notificationRuleToken, alertIDToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);

            tempStr = retrieveText(descriptionText, alertIDToken, vcOpsServerToken);
			newDescriptionText += tempStr + LINE_BREAK;
            descriptionText = (String.isNotEmpty(tempStr) ? descriptionText.substring(tempStr.length()) : descriptionText);

            // Retrieve only the alert ID
            mAlertID = (String.isNotEmpty(tempStr) ? tempStr.substringAfterLast(SPACE) : null);
                
            tempStr = retrieveText(descriptionText, vcOpsServerToken, EOL_TOKEN);
			newDescriptionText += tempStr;
        }
        return newDescriptionText;
    }    

    /*
     * Retrieve the text starting and including the start token until the end token is reached.
     * The end token is not retrieved.
     * 
     * @param	allDescriptionText		Original text that will be parsed.
     * @param	startToken				Token that marks the start of the target text.
     * @param	endToken				Token that marks the end of the target text.  If the value for 
     * 									this parameter is EOL_TOKEN, it will read to the end of the line.
     * @return							String containing the results.
     * 
     */
    private String retrieveText(String descriptionText, String startToken, String endToken) {
        String newSummaryText = null;
        if (String.isNotEmpty(descriptionText) && String.isNotEmpty(startToken) && String.isNotEmpty(endToken)) {
            Integer summaryStartIndex = descriptionText.indexOf(startToken);
            if (summaryStartIndex >= 0) {
                if (endToken == EOL_TOKEN) {
                    newSummaryText = descriptionText.substring(summaryStartIndex);
                } else {
                    Integer summaryEndIndex = descriptionText.indexOf(endToken, summaryStartIndex);
                    // Skip in case of errors
                    if (summaryEndIndex >= 0) {
	                    newSummaryText = descriptionText.substring(summaryStartIndex, summaryEndIndex);
                    } 
                }
            }
        }
        return newSummaryText;
    }

    /*
     * Retrieves the AlertID from a BMCServiceDesk__Incident__c instance.
     * 
     * @param bmcIncidentObj		BMCServiceDesk__Incident__c instance.
     * @return						Alert ID string from the instance.
     * 
     */
    @TestVisible
    private String getAlertID(BMCServiceDesk__Incident__c bmcIncidentObj) {

        mAlertID = null;
        String descriptionText = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        String retrieveNewDescription = retrieveNewDescription(descriptionText, mSummaryStartToken, mSummaryEndToken);
        bmcIncidentObj.Alert_ID__c = mAlertID;
        
        return mAlertID;
        
    }



    
    public void onBeforeUpdate(List<BMCServiceDesk__Incident__c> oldIncidents, List<BMCServiceDesk__Incident__c> newIncidents){
        
        //Set the AutoClose Date and Flag, which will be used to Auto Close RESOLVED incidents after 6 days.
        setAutoClose(oldIncidents,newIncidents);  
        
        //Assign a Queue to an Incident with no Queue Selected based on the CI selected on the Incident.
        assignQueue(newIncidents);      
        
    }
    
    public void onAfterUpdate(BMCServiceDesk__Incident__c[] oldIncidents, BMCServiceDesk__Incident__c[] updatedIncidents, Map<ID, BMCServiceDesk__Incident__c> IncidentMap){
        //AddNotes(oldIncidents, updatedIncidents);
    }
    
 
    /**
    * @name -- setAutoClose
    * @author : veenesh.vikram
    * @param -- List<BMCServiceDesk__Incident__c>, List<BMCServiceDesk__Incident__c>
    * @description -- This Method will set the AutoClose Date and Flag, 
                      which will be used to Auto Close RESOLVED incidents after 6 days.
    * @return -- void
    */   
    private void setAutoClose(List<BMCServiceDesk__Incident__c> oldIncidents,List<BMCServiceDesk__Incident__c> incidents){
        for(Integer i=0; i < incidents.size(); i++){
            
            //If Incident is RESOLVED.
            if(incidents[i].BMCServiceDesk__Status_ID__c == 'RESOLVED' && oldIncidents[i].BMCServiceDesk__Status_ID__c != incidents[i].BMCServiceDesk__Status_ID__c){
                
                //Set the flag and date values.
                incidents[i].AutoCloseFlag__c = True;
                incidents[i].AutoCloseDate__c = System.Today()+6;               
            }
                        
        }
    }
    
    /**
    * @name -- assignQueue
    * @author : veenesh.vikram
    * @param -- List<BMCServiceDesk__Incident__c>
    * @description -- This Method will assign a Queue to an Incident with no Queue Selected
                      based on the CI selected on the Incident.
    * @return -- void
    */  
    private void assignQueue(List<BMCServiceDesk__Incident__c> incidents){
        List<BMCServiceDesk__Incident__c> processList = new List<BMCServiceDesk__Incident__c>();
        List<Id> baseElementIds = new List<Id>();
        
        //Fiter records for processing
        for(BMCServiceDesk__Incident__c incident : incidents){
            //All Incidents with no Queue Assigned and having CI value.
            if(!String.valueOf(incident.OwnerId).startswith('00G') && incident.BMCServiceDesk__FKBMC_BaseElement__c != Null){
                processList.add(incident);
                baseElementIds.add(incident.BMCServiceDesk__FKBMC_BaseElement__c);
            }
        }
        
        if(processList != null && baseElementIds != null){
            Map<String,CItoQueueMapping__c> ciToQueueMap = CItoQueueMapping__c.getall();
            Map<String,id>nameIdQueue = new Map<String,id>(); 
            Map<id,String>nameIdCI = new Map<id,String>(); 
            
            //Prepare map of Queue names with corresponding Id values
            for(Group grp : [Select id,name from group where type='Queue']){
                nameIdQueue.put(grp.name,grp.id);     
            } 
            
            //Prepare map of CI Ids with names
            for(BMCServiceDesk__BMC_BaseElement__c ci : [Select id,name from BMCServiceDesk__BMC_BaseElement__c where id in:baseElementIds]){
                nameIdCI.put(ci.id,ci.name);     
            }
            
            //Assign Queue
            for(BMCServiceDesk__Incident__c incident : processList){
                String Qname='';
                    
                    //For CI with names less than or equal to 38 Characters
                    if((ciToQueueMap.size()>0) && (ciToQueueMap.get(nameIdCI.get(incident.BMCServiceDesk__FKBMC_BaseElement__c)) != null)){
                        Qname = ciToQueueMap.get(nameIdCI.get(incident.BMCServiceDesk__FKBMC_BaseElement__c)).Queue__c;
                    }
                    
                    //For CI with names greater than 38 Characters
                    else if((ciToQueueMap.size()>0) && (String.valueOf(nameIdCI.get(incident.BMCServiceDesk__FKBMC_BaseElement__c)).length() >= 25) ){
                        //Sub-string only if length greater than or equal to 25.
                        if(ciToQueueMap.get(String.valueOf(nameIdCI.get(incident.BMCServiceDesk__FKBMC_BaseElement__c)).subString(0,25).trim()) != null)
                            Qname= ciToQueueMap.get(String.valueOf(nameIdCI.get(incident.BMCServiceDesk__FKBMC_BaseElement__c)).subString(0,25).trim()).Queue__c;
                    } 
                
                //Update the Owner with the Queue(if found)
                if((Qname != null) && (nameIdQueue.get(Qname) != null))
                   incident.OwnerId = nameIdQueue.get(Qname); 
            }   
        }      
    }

    private void setDefaultService(List<BMCServiceDesk__Incident__c> incidents){
        for (BMCServiceDesk__Incident__c incident : incidents) {
            if(incident.BMCServiceDesk__FKBusinessService__c == null){
                incident.BMCServiceDesk__FKBusinessService__c = Label.ITSServiceId;
            }
        }
    }
    
    private void setDefaultAccount(List<BMCServiceDesk__Incident__c> incidents){
            
        List<Account> accounts = new List<Account>([select Id from Account 
                                                            where Default_Account__c = true Limit 1]);
        Account account;
        if(accounts.size()>0){
            account = accounts[0];
        }
                                                            
        if(account != null){
            for (BMCServiceDesk__Incident__c incident : incidents) {
                if(incident.BMCServiceDesk__FKAccount__c == null){
                    incident.BMCServiceDesk__FKAccount__c = account.Id;
                }
            }
        }
    }   
}