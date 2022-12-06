/* 
 * This class contains the methods for working on ITSAssetRequest__c objects.
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
public class COHITSAssetRequestHelper {
    
    private static final String APPLICATION = 'ITS Asset Request';
	private static final String ITS_ASSET_REQUEST_OBJ = 'ITSAssetRequest__c';
    private static final String INCIDENT_SOURCE = 'Incident Source';
	private static final String NUMERIC_CHARS = '0123456789';
    private static final String LINE_BREAK = '\n';
	private static final String COLON = ': ';

    // Picklist values
    private static final String MOBILE_PHONE_NEW = 'Mobile Phone: New';
    private static final String MOBILE_PHONE_EXISTING = 'Mobile Phone: Existing Phone Available';
    private static final String DESKTOP_PHONE_NEW = 'Desktop Phone New Install';
    private static final String DESKTOP_PHONE_EXISTING = 'Desktop Phone Existing Phone Available';
    
    // Location (default is Duarte)
    private static final String RIVERGRADE_LOCATION = 'Rivergrade';
    private static final String FOUNDATION_LOCATION = 'Mayflower';

    // Ownership queues
    private static final String DUARTE_DESKTOP_SUPPORT_QUEUE = 'Duarte Desktop Support';
    private static final String RIVERGRADE_DESKTOP_SUPPORT_QUEUE = 'Rivergrade Desktop Support';
    private static final String FOUNDATION_DESKTOP_SUPPORT_QUEUE = 'Foundation Desktop Support';
    private static final String TELECOM_QUEUE = 'Telecom';
    private static final String ASSET_MANAGEMENT_QUEUE = 'Asset Management';
    private static final String INFORMATION_SECURITY_QUEUE = 'Information Security';

    private static Map<String, Schema.SObjectField> mFieldMap;	// Map of all fields and their labels
    private static String mIncidentDefaultSource;
    
    private static Id mDesktopSupportQueueIDDuarte;			// Queue for DUARTE desktop support
    private static Id mDeskTopSupportQueueIDRivergrade;		// Queue for RIVERGRADE desktop support
    private static Id mDesktopSupportQueueIDFoundation;		// Queue for FOUNDATION desktop support
    private static Id mTelecomQueueID;						// Queue for telecom
    private static Id mAssetManagementQueueID;				// Queue for asset management
    private static Id mInformationSecurityQueueID;				// Queue for information security
    
    private static String mRivergradeIdentifier;			// String that identifies a Rivergrade location
    private static String mFoundationIdentifier;			// String that identifies a Foundation location

    static {
        mIncidentDefaultSource = (String) COHUtil.getConfigurationValue(APPLICATION, INCIDENT_SOURCE);
        mDesktopSupportQueueIDDuarte = (String) COHUtil.getConfigurationValue(APPLICATION, DUARTE_DESKTOP_SUPPORT_QUEUE);
        mDeskTopSupportQueueIDRivergrade = (String) COHUtil.getConfigurationValue(APPLICATION, RIVERGRADE_DESKTOP_SUPPORT_QUEUE);
        mDesktopSupportQueueIDFoundation = (String) COHUtil.getConfigurationValue(APPLICATION, FOUNDATION_DESKTOP_SUPPORT_QUEUE);
        mTelecomQueueID = (String) COHUtil.getConfigurationValue(APPLICATION, TELECOM_QUEUE);
        mAssetManagementQueueID = (String) COHUtil.getConfigurationValue(APPLICATION, ASSET_MANAGEMENT_QUEUE);
        mRivergradeIdentifier = (String) COHUtil.getConfigurationValue(APPLICATION, RIVERGRADE_LOCATION);
        mFoundationIdentifier = (String) COHUtil.getConfigurationValue(APPLICATION, FOUNDATION_LOCATION);
        mInformationSecurityQueueID =  (String) COHUtil.getConfigurationValue(APPLICATION, INFORMATION_SECURITY_QUEUE);
        
		// Map the fields to their labels        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	    Schema.SObjectType IIARSchema = schemaMap.get(ITS_ASSET_REQUEST_OBJ);
        mFieldMap = IIARSchema.getDescribe().fields.getMap();
    }
    
    /*
     * Process the ITSAssetRequest__c record updates.  Ignore records where the user name has
     * a number.  Those are used by shared computers.
     * 
     * @param iiarList	List of ITSAssetRequest__c record to process.
     * 
     */
    public static void processUpdates(List<ITSAssetRequest__c> iiarList) {
		if (COHUtil.isValidList(iiarList)) {

            // Create the list of BMCServiceDesk__Incident__c objects
            List<BMCServiceDesk__Incident__c> newIncidentList = new List<BMCServiceDesk__Incident__c>();
            for (ITSAssetRequest__c iarObj : iiarList)  {
                // Ignore records where the user name has a number.  Those are used by shared computers.
                if (isValidName(iarObj.Employee_Name__c)) {
                    if (isValidAssetManagementIncident(iarObj)) {		// asset management
                        BMCServiceDesk__Incident__c incidentObj = createBMCIncidentObject(iarObj, mAssetManagementQueueID, createITSAssessmentDescription(iarObj));
                        if (incidentObj != null) {
                            newIncidentList.add(incidentObj);
                            // Prevent another incident from being generated for this queue
                            iarObj.ITS_Asset_Management_Incident_Created__c = true;
                        }
                    }

                    if (isValidInfoSecurityIncident(iarObj)) {		// information security
                        BMCServiceDesk__Incident__c incidentObj = createBMCIncidentObject(iarObj, mInformationSecurityQueueID, createInfoSecurityDescription(iarObj));
                        if (incidentObj != null) {
                            incidentObj.Network_Folder_Access__c = iarObj.Network_Folder_Access__c;
                            newIncidentList.add(incidentObj);
                            // Prevent another incident from being generated for this queue
                            iarObj.Information_Security_Incident_Created__c = true;
                        }
                    }

                    if (isValidDesktopSupportIncident(iarObj)) {		// desktop support queues
                      BMCServiceDesk__Incident__c incidentObj = createBMCIncidentObject(iarObj, getITSLocationQueue(iarObj), createDesktopSupportDescription(iarObj));
                        if (incidentObj != null) {
 		                    newIncidentList.add(incidentObj);
                            // Prevent another incident from being generated for this queue
                            iarObj.Desktop_Support_Incident_Created__c = true;
                        }
                    }

                    if (isValidMobileTelecomIncident(iarObj)) {		// telecom queue for mobile phones
                        BMCServiceDesk__Incident__c incidentObj = createBMCIncidentObject(iarObj, mTelecomQueueID, createMobileTelecomDescription(iarObj));
                        if (incidentObj != null) {
 		                    newIncidentList.add(incidentObj);
    	                    // Prevent another incident from being generated for this queue for mobile phones
        	                iarObj.Mobile_Phone_Telecom_Incident_Created__c = true;
                        }
                    }

                    if (isValidDesktopTelecomIncident(iarObj)) {		// telecom queue for desktop phones
                        BMCServiceDesk__Incident__c incidentObj = createBMCIncidentObject(iarObj, mTelecomQueueID, createDesktopTelecomDescription(iarObj));
                        if (incidentObj != null) {
                            newIncidentList.add(incidentObj);
                            // Prevent another incident from being generated for this queue for desktop phones
                            iarObj.Desktop_Phone_Telecom_Incident_Created__c = true;
                        }
                    }
                }
            }
            
            if (COHUtil.isValidList(newIncidentList)) {
                try {
                    Database.insert(newIncidentList);
                } catch (Exception e) {
                    throw new COHException('COHITSAssetRequestHelper.processUpdates(): Could not insert BMCServiceDesk__Incident__c records: ' + e.getMessage());
                }
            }
        }
    }    

    /*
     * Create a BMCServiceDesk__Incident__c object.
     * 
     * @param iarObj		ITS Asset Request Object
     * @param queueID		Queue ID where this incident will be assigned.
     * @param description	Text description for the new incident.
     * @return				New BMCServiceDesk__Incident__c object.
     * 
     */
    private static BMCServiceDesk__Incident__c createBMCIncidentObject(ITSAssetRequest__c iarObj, Id queueID, String description) {

        BMCServiceDesk__Incident__c incidentObj = null;
        if (iarObj != null && String.isNotEmpty(iarObj.Employee__c) &&  queueID != null && String.isNotEmpty(description)) {
            incidentObj = new BMCServiceDesk__Incident__c();
            incidentObj.BMCServiceDesk__FKClient__c = iarObj.Employee__c;
            incidentObj.OwnerId = queueID;
            incidentObj.BMCServiceDesk__incidentDescription__c = description;
            incidentObj.Asset_Request_Created__c = true;
            incidentObj.BMCServiceDesk__contactType__c = mIncidentDefaultSource;
            incidentObj.No_Assets_Needed__c = iarObj.No_Assets_Needed__c;
            incidentObj.Employee_Start_Date__c = iarObj.Start_Date__c;
        }
		return incidentObj;
    }

    /*
     * Check if the Incident is valid and ITS Asset Management-related.  If an Incident has
     * already been created for this queue, it is invalid.
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						true if one of the string criteria is not null or boolean value is true, false otherwise.
     * 
     */
    private static Boolean isValidAssetManagementIncident(ITSAssetRequest__c assetRequestObj)  {
        if (assetRequestObj != null && !assetRequestObj.ITS_Asset_Management_Incident_Created__c) {
            if (String.isNotEmpty(assetRequestObj.Additional_Software_Requested__c) ||
					String.isNotEmpty(assetRequestObj.Special_Order_Hardware__c) ||
                	assetRequestObj.No_Assets_Needed__c == true) {
                return true;
            }
        }
        return false;
    }

    /*
     * Check if the Incident is valid and Information Security-related.  If an Incident has
     * already been created for this queue, it is invalid.
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						true if the Network Folder Access field is not empty
     * 
     */
    private static Boolean isValidInfoSecurityIncident(ITSAssetRequest__c assetRequestObj)  {
        if (assetRequestObj != null && !assetRequestObj.Information_Security_Incident_Created__c) {
            if (String.isNotEmpty(assetRequestObj.Network_Folder_Access__c)) {
                return true;
            }
        }
        return false;
    }

    /*
     * Check if the Incident is valid and Desktop Support-related.  If an Incident has
     * already been created for this queue, it is invalid.
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						true if the Incident is valid and Desktop Support-related, false otherwise.
     * 
     */
    private static Boolean isValidDesktopSupportIncident(ITSAssetRequest__c assetRequestObj)  {
        if (assetRequestObj != null && !assetRequestObj.Desktop_Support_Incident_Created__c) {
            if (String.isNotEmpty(assetRequestObj.Hardware_Computing_Device__c)) {
                return true;
            }
        }
        return false;
    }

    /*
     * Check if the Incident is valid and Mobile telecom-related.  If an Incident has
     * already been created for this queue, it is invalid.
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						true the incident is valid and Mobile telecom-related, false otherwise.
     * 
     */
    private static Boolean isValidMobileTelecomIncident(ITSAssetRequest__c assetRequestObj)  {
        if (assetRequestObj != null && !assetRequestObj.Mobile_Phone_Telecom_Incident_Created__c) {
            String val = assetRequestObj.Mobile_Device__c;
            if (String.isNotEmpty(val)) {
                // Mobile phones must have VP approval in order to generate an Incident object
                if ((val.equalsIgnoreCase(MOBILE_PHONE_NEW) && assetRequestObj.VP_Approval__c) || 
						(val.equalsIgnoreCase(MOBILE_PHONE_EXISTING) && assetRequestObj.VP_Approval__c)) {
                    return true;
                }
            }
		}
        return false;
    }

    /*
     * Check if the Incident is valid and Desktop telecom-related.  If an Incident has
     * already been created for this queue, it is invalid.
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						true the incident is valid and Desktop telecom-related, false otherwise.
     * 
     */
    private static Boolean isValidDesktopTelecomIncident(ITSAssetRequest__c assetRequestObj)  {
        if (assetRequestObj != null && !assetRequestObj.Desktop_Phone_Telecom_Incident_Created__c) {
            String val = assetRequestObj.Communication_Device__c;
            if (String.isNotEmpty(val) && 
	                (val.equalsIgnoreCase(DESKTOP_PHONE_NEW) || val.equalsIgnoreCase(DESKTOP_PHONE_EXISTING))) {
    			return true;
            }
        }
        return false;
    }

    /*
     * Create the description for the ITS Assessessment incident type
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						Description.
     * 
     */
    private static String createITSAssessmentDescription(ITSAssetRequest__c assetRequestObj)  {
        
        List<String> description = new List<String>();
        
        if (assetRequestObj != null) {

            if (assetRequestObj.No_Assets_Needed__c == true) {
			    addValidValues(description, 'No_Assets_Needed__c', 'true', COLON);
            }
            if (assetRequestObj.Position_Backfill__c == true) {
			    addValidValues(description, 'Position_Backfill__c', 'true', COLON);
            }
            
		    addValidValues(description, 'If_BackFill_existing_computer_tag__c', assetRequestObj.If_BackFill_existing_computer_tag__c, COLON);
		    addValidValues(description, 'If_Positio__c', assetRequestObj.If_Positio__c, COLON);
            
            addValidValues(description, 'Work_Location__c', assetRequestObj.Work_Location__c, COLON);
            Date needByDate = assetRequestObj.Need_By_Date__c;
            if (needByDate != null) {
			    addValidValues(description, 'Need_By_Date__c', needByDate.format(), COLON);
            }
		    addValidValues(description, 'Additional_Software_Requested__c', assetRequestObj.Additional_Software_Requested__c, null);
		    addValidValues(description, 'Special_Order_Hardware__c', assetRequestObj.Special_Order_Hardware__c, null);
		    addValidValues(description, 'Licenses_provided_to_BRI__c', assetRequestObj.Licenses_provided_to_BRI__c, null);
            addValidValues(description, 'Dept_Manager_Name__c', assetRequestObj.Dept_Manager_Name__c, COLON);
        }

		return buildDescriptionString(description);
    }


    /*
     * Create the description for the Information Security incident type
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						Description.
     * 
     */
    private static String createInfoSecurityDescription(ITSAssetRequest__c assetRequestObj)  {
        
        List<String> description = new List<String>();
        
        if (assetRequestObj != null) {

            addValidValues(description, 'Work_Location__c', assetRequestObj.Work_Location__c, COLON);
            Date needByDate = assetRequestObj.Need_By_Date__c;
            if (needByDate != null) {
			    addValidValues(description, 'Need_By_Date__c', needByDate.format(), COLON);
            }
		    addValidValues(description, 'Network_Folder_Access__c', assetRequestObj.Network_Folder_Access__c, COLON);
            addValidValues(description, 'Dept_Manager_Name__c', assetRequestObj.Dept_Manager_Name__c, COLON);
        }

		return buildDescriptionString(description);
    }

    
    /*
     * Create the description for the Desktop Support incident type
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						Description string.
     * 
     */
    private static String createDesktopSupportDescription(ITSAssetRequest__c assetRequestObj)  {
        
        List<String> description = new List<String>();

        if (assetRequestObj != null) {

            if (assetRequestObj.No_Assets_Needed__c == true) {
			    addValidValues(description, 'No_Assets_Needed__c', 'true', COLON);
            }
            if (assetRequestObj.Position_Backfill__c == true) {
			    addValidValues(description, 'Position_Backfill__c', 'true', COLON);
            }

            addValidValues(description, 'If_BackFill_existing_computer_tag__c', assetRequestObj.If_BackFill_existing_computer_tag__c, COLON);
		    addValidValues(description, 'If_Positio__c', assetRequestObj.If_Positio__c, COLON);

            addValidValues(description, 'Work_Location__c', assetRequestObj.Work_Location__c, COLON);
            Date needByDate = assetRequestObj.Need_By_Date__c;
            if (needByDate != null) {
			    addValidValues(description, 'Need_By_Date__c', needByDate.format(), COLON);
            }
		    addValidValues(description, 'Hardware_Computing_Device__c', assetRequestObj.Hardware_Computing_Device__c, null);
		    addValidValues(description, 'Laptop_Criteria_Select_One__c', assetRequestObj.Laptop_Criteria_Select_One__c, COLON);
		    addValidValues(description, 'Tag__c', assetRequestObj.Tag__c, COLON);
            if (assetRequestObj.Additional_24in_Monitor_ERP_Req_CDW_PO__c == true) {
			    addValidValues(description, 'Additional_24in_Monitor_ERP_Req_CDW_PO__c', 'true', COLON);
            }

		    addValidValues(description, 'Reset_Voicemail_Password__c', assetRequestObj.Reset_Voicemail_Password__c, COLON);
            addValidValues(description, 'Dept_Manager_Name__c', assetRequestObj.Dept_Manager_Name__c, COLON);
		}
		return buildDescriptionString(description);
    }
    
    /*
     * Create the description for the Mobile telecom incident type
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						Description string.
     * 
     */
    private static String createMobileTelecomDescription(ITSAssetRequest__c assetRequestObj)  {

        List<String> description = new List<String>();

        if (assetRequestObj != null) {

            if (assetRequestObj.No_Assets_Needed__c == true) {
			    addValidValues(description, 'No_Assets_Needed__c', 'true', COLON);
            }
            if (assetRequestObj.Position_Backfill__c == true) {
			    addValidValues(description, 'Position_Backfill__c', 'true', COLON);
            }

		    addValidValues(description, 'If_BackFill_existing_computer_tag__c', assetRequestObj.If_BackFill_existing_computer_tag__c, COLON);
		    addValidValues(description, 'If_Positio__c', assetRequestObj.If_Positio__c, COLON);

		    addValidValues(description, 'Work_Location__c', assetRequestObj.Work_Location__c, COLON);
            Date needByDate = assetRequestObj.Need_By_Date__c;
            if (needByDate != null) {
			    addValidValues(description, 'Need_By_Date__c', needByDate.format(), COLON);
            }
		    addValidValues(description, 'Mobile_Device__c', assetRequestObj.Mobile_Device__c, null);
		    addValidValues(description, 'Phone_Number__c', assetRequestObj.Phone_Number__c, COLON);
		    addValidValues(description, 'ChartString__c', assetRequestObj.ChartString__c, COLON);
		    addValidValues(description, 'Reset_Voicemail_Password__c', assetRequestObj.Reset_Voicemail_Password__c, COLON);
            addValidValues(description, 'Dept_Manager_Name__c', assetRequestObj.Dept_Manager_Name__c, COLON);
        }
		return buildDescriptionString(description);
    }

    /*
     * Create the description for the Desktop telecom incident type
     * 
     * @param	assetRequestObj		ITS Asset Request object.
     * @return						Description string.
     * 
     */
    private static String createDesktopTelecomDescription(ITSAssetRequest__c assetRequestObj)  {

        List<String> description = new List<String>();

        if (assetRequestObj != null) {

            if (assetRequestObj.No_Assets_Needed__c == true) {
			    addValidValues(description, 'No_Assets_Needed__c', 'true', COLON);
            }
            if (assetRequestObj.Position_Backfill__c == true) {
			    addValidValues(description, 'Position_Backfill__c', 'true', COLON);
            }

		    addValidValues(description, 'If_BackFill_existing_computer_tag__c', assetRequestObj.If_BackFill_existing_computer_tag__c, COLON);
		    addValidValues(description, 'If_Positio__c', assetRequestObj.If_Positio__c, COLON);

		    addValidValues(description, 'Work_Location__c', assetRequestObj.Work_Location__c, COLON);
            Date needByDate = assetRequestObj.Need_By_Date__c;
            if (needByDate != null) {
			    addValidValues(description, 'Need_By_Date__c', needByDate.format(), COLON);
            }
		    addValidValues(description, 'Communication_Device__c', assetRequestObj.Communication_Device__c, null);
		    addValidValues(description, 'Extension__c', assetRequestObj.Extension__c, COLON);
		    addValidValues(description, 'Reset_Voicemail_Password__c', assetRequestObj.Reset_Voicemail_Password__c, COLON);
            addValidValues(description, 'Dept_Manager_Name__c', assetRequestObj.Dept_Manager_Name__c, COLON);
        }
		return buildDescriptionString(description);
    }

	/*
	 * Adds valid values and labels (if required) to the descriptionList parameter that will be used
	 * later to create a description for the Incident object.  If the delimiter string is not null, 
	 * the label for the field and the delimiter will also be added.
	 * 
	 * @param descriptionList		List of valid values and lables (if required).
	 * @param fieldName				Name of the field.
	 * @param fieldValue			String representation of the field value.
	 * @param delimiter				Delimiter string.
	 * 
	 */
    private static void addValidValues(List<String> descriptionList, String fieldName, String fieldValue, String delimiter)  {
        if (descriptionList != null && !String.isEmpty(fieldValue) && !String.isEmpty(fieldName)) {
            if (String.isEmpty(delimiter)) {
                descriptionList.add(fieldValue);
            } else {
                String label = (String) mFieldMap.get(fieldName).getDescribe().getLabel();
                descriptionList.add(label + delimiter + fieldValue);
            }
        }
    }
    
    /*
     * Builds a description string from the description tokens.  They will be appended
     * together and separated by a delimiter.
     * 
     * @param	description			List of String description tokens.
     * @return						Description string.
     * 
     */
    private static String buildDescriptionString(List<String> description) {
        String finalDescription = null;
        if (COHUtil.isValidList(description)) {
            for (String str : description) {
                if (!String.isEmpty(str)) {
                    if (finalDescription == null) {
                        finalDescription = str;
                    } else {
                        finalDescription += LINE_BREAK + str;
                    }
                }
            }
        }
        return finalDescription;
    }

    /*
     * Retrieve the appropriate queue for the user's location and the request type.
     * 
     * @param	accessRequestObj	ITS Asset Request object.

     * 
     */
    private static ID getITSLocationQueue(ITSAssetRequest__c assetRequestObj) {
        // If the location is neither RIVERGRADE nor FOUNDATION, it will default to DUARTE
        Id queueID = mDesktopSupportQueueIDDuarte;
        if (assetRequestobj != null) {
	        String location = assetRequestObj.Work_Location__c;
            if (!String.isEmpty(location)) {
                if (location.containsIgnoreCase(mRivergradeIdentifier)) {
                    queueID = mDeskTopSupportQueueIDRivergrade;
                } else if (location.containsIgnoreCase(mFoundationIdentifier)) {
                    queueID = mDesktopSupportQueueIDFoundation;
                } 
            }
		}
		return queueID;
    }
    
    /*
     * Checks if the user name is valid.  If it contains a number, it is invalid because
     * those are used only by shared computers.
     * 
     * @param userName		User name to check.
     * @return				True if the name is valid, false otherwise.
     * 
     */
    private static Boolean isValidName(String userName) {
        Boolean validFlag = false;
        if (!String.isEmpty(userName)) {
            validFlag = !userName.containsAny(NUMERIC_CHARS);
        }
        return validFlag;
    }
}