/*
 * Test class for some methods methods in the IncidentUtil class.  Much of 
 * that class was originally written by consultants.  Those tests are not
 * located in this class.
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
@isTest
public class COHIncidentUtilTest {
    private static final Boolean mRunVerifyReformatSummaryAndDescription = true;
    private static final Boolean mRunVerifyUpdateSummaryAndDescription = true;
    // Test disabled because APU time limit is exceeded.  Remedyforce does too 
    // much stuff behind the scene.
    private static final Boolean mRunVerifyBulkReformatSummaryDescriptionTest = false;
    private static final Boolean mRunAllTests = false;
    
    private static final String VBLOCK_INCIDENT = 'VBlock Incident';
    private static final String BMC_INCIDENT_OBJ = 'BMCServiceDesk__Incident__c';
    private static final String SUMMARY_START_TOKEN = 'Summary Start Token';
    private static final String SUMMARY_START_TOKEN_VAL = ':Info';
    private static final String ALERT_DEFINITION_NAME_TOKEN = 'Alert Definition Name Token';
    private static final String ALERT_DEFINITION_NAME_TOKEN_VAL = 'Alert Definition Name';
    private static final String CLIENT_ID = 'Client ID';
    private static final String INCIDENT_SOURCE = 'Incident Source';
    private static final String INCIDENT_SOURCE_VAL = 'Mail Listen';
    private static final String LINE_BREAK = '\n';
    private static final String DUMMY_INCIDENT_SOURCE_VAL = 'Email';
    
    private static final Integer MAX_RECORDS = 102;
    
    private static String mTargetClientID;
    private static Id mEmployeeID0;
    private static Id mQueueID0;
    
    /*
     * Test reformatting the Summary and Description
     * 
     */
    private static testMethod void reformatSummaryAndDescriptionTest() {
        if (!mRunAllTests && !mRunVerifyReformatSummaryAndDescription) {
            System.debug('Skipping reformatSummaryAndDescription()');
            return;
        }
        
        Test.startTest();
        
        setUserQueueIDs();
        setupCustomSettings();
        
        String body = 'Body: New alert was generated at Wed Jan 17 10:06:59 PST 2018';
        String summaryInfo = 'Info:IRWVPEPCFILE01 VirtualMachine is acting abnormally since Wed Jan 17 10:06:59 PST 2018 and was last updated at Wed Jan 17 10:06:59 PST 2018';
        String alertDefinition = 'Alert Definition Name: Epic File System Health is degraded:';
        String alertDescription = 'Alert Definition Description: Epic File System is not responsive';
        String objName = 'Object Name : IRWVPEPCFILE01';
        String objType = 'Object Type : VirtualMachine';
        String alertImpact = 'Alert Impact: health';
        String alertState = 'Alert State : critical';
        String alertType = 'Alert Type : Application';
        String alertSubType = 'Alert Sub-Type : Performance';
        String objHealthState = 'Object Health State: critical';
        String objRiskState = 'Object Risk State: warning';
        String objEfficiencyState = 'Object Efficiency State: info';
        String controlState = 'Control State: Open';
        String symptoms = 'Symptoms:SYMPTOM SET - self';
        String recommendations = 'Recommendations: Get a new computer';
        String notificationName = 'Notification Rule Name: PRDTicketNotification';
        String notificationRule = 'Notification Rule Description: Remedy Tickets for EPIC PRD';
        String alertID0 = 'Alert ID:bf869360-39bb-40000-83cf';
        String alertID1 = 'Alert ID:bf869360-39bb-40000-83aa';
        String alertID2 = 'Alert ID:bf869360-39bb-40000-83bb';
        String alertID3 = 'Alert ID:bf869360-39bb-40000-83cc';
        String alertID4 = 'Alert ID:bf869360-39bb-40000-83dd';
        String vcOpsServer = 'VCOps Server: IRWVPVROMSTR1';
        
        
        String description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID0 + vcOpsServer;

        // This object SHOULD be processed

        String targetClientID = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, CLIENT_ID);
        String targetIncidentSource = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, INCIDENT_SOURCE);
        BMCServiceDesk__Incident__c bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = null;
        bmcIncidentObj.BMCServiceDesk__contactType__c = null;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
        Database.insert(bmcIncidentObj);
        Id bmcIncidentID = bmcIncidentObj.Id;
        
        String bmcIncidentSOQLQuery = COHUtil.buildSelectAllSOQLStatement(BMC_INCIDENT_OBJ) + ' where Id = :bmcIncidentID';
        List<BMCServiceDesk__Incident__c> incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        String newSummary = bmcIncidentObj.Summary__c;
        String newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);
        
        // This object should not be processed

        description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID1 + vcOpsServer;

        bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = null;
        bmcIncidentObj.BMCServiceDesk__contactType__c =  DUMMY_INCIDENT_SOURCE_VAL;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
        Database.insert(bmcIncidentObj);
        bmcIncidentID = bmcIncidentObj.Id;
        
        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        newSummary = bmcIncidentObj.Summary__c;
        newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);
        
        // This object should not be processed
         
        description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID2 + vcOpsServer;

        bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = mTargetClientID;
        bmcIncidentObj.BMCServiceDesk__contactType__c =  null;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
        Database.insert(bmcIncidentObj);
        bmcIncidentID = bmcIncidentObj.Id;
        
        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        newSummary = bmcIncidentObj.Summary__c;
        newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);
        
        // This object should not be processed

        description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID3 + vcOpsServer;

        bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = mTargetClientID;
        bmcIncidentObj.BMCServiceDesk__contactType__c =  DUMMY_INCIDENT_SOURCE_VAL;

        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
        Database.insert(bmcIncidentObj);
        bmcIncidentID = bmcIncidentObj.Id;
        
        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        newSummary = bmcIncidentObj.Summary__c;
        newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);
        
        // This object should not be processed

        description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID4 + vcOpsServer;


        bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = targetClientID;
        bmcIncidentObj.BMCServiceDesk__contactType__c =  targetIncidentSource;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
        Database.insert(bmcIncidentObj);
        bmcIncidentID = bmcIncidentObj.Id;
        
        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        newSummary = bmcIncidentObj.Summary__c;
        newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        
        System.assertEquals(summaryInfo, newSummary);
        
        String expectedDescriptionStr = body + LINE_BREAK + alertDefinition + LINE_BREAK +alertDescription + LINE_BREAK + objName +
            LINE_BREAK + objType + LINE_BREAK + alertImpact + LINE_BREAK + alertState + LINE_BREAK + alertType + LINE_BREAK + alertSubType + LINE_BREAK + objHealthState +
            LINE_BREAK + objRiskState + LINE_BREAK + objEfficiencyState + LINE_BREAK + controlState + LINE_BREAK + symptoms + LINE_BREAK + recommendations + LINE_BREAK + 
            notificationName + LINE_BREAK + notificationRule + LINE_BREAK + alertID4 + LINE_BREAK + vcOpsServer;

        System.assertEquals(expectedDescriptionStr, newDescription);
        
        Test.stopTest();
    }

    /*
     * Test updating an existing BMC Incident object.
     * 
     */
    private static testMethod void updateSummaryAndDescriptionTest() {
        if (!mRunAllTests && !mRunVerifyUpdateSummaryAndDescription) {
            System.debug('Skipping updateSummaryAndDescription()');
            return;
        }
        
        Test.startTest();
        
        setUserQueueIDs();
        setupCustomSettings();
        
        String body = 'Body: New alert was generated at Wed Jan 17 10:06:59 PST 2018';
        String summaryInfo = 'Info:IRWVPEPCFILE01 VirtualMachine is acting abnormally since Wed Jan 17 10:06:59 PST 2018 and was last updated at Wed Jan 17 10:06:59 PST 2018';
        String alertDefinition = 'Alert Definition Name: Epic File System Health is degraded:';
        String alertDescription = 'Alert Definition Description: Epic File System is not responsive';
        String objName = 'Object Name : IRWVPEPCFILE01';
        String objType = 'Object Type : VirtualMachine';
        String alertImpact = 'Alert Impact: health';
        String alertState = 'Alert State : critical';
        String alertType = 'Alert Type : Application';
        String alertSubType = 'Alert Sub-Type : Performance';
        String objHealthState = 'Object Health State: critical';
        String objRiskState = 'Object Risk State: warning';
        String objEfficiencyState = 'Object Efficiency State: info';
        String controlState = 'Control State: Open';
        String symptoms = 'Symptoms:SYMPTOM SET - self';
        String recommendations = 'Recommendations: Get a new computer';
        String notificationName = 'Notification Rule Name: PRDTicketNotification';
        String notificationRule = 'Notification Rule Description: Remedy Tickets for EPIC PRD';
        String alertID0 = 'Alert ID:bf869360-39bb-40000-83cf';
        String alertID1 = 'Alert ID:bf869360-39bb-40000-83xx';
        String vcOpsServer = 'VCOps Server: IRWVPVROMSTR1';
        
        
        String description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID0 + vcOpsServer;

        // This object SHOULD be processed
        String targetClientID = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, CLIENT_ID);
        String targetIncidentSource = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(VBLOCK_INCIDENT, INCIDENT_SOURCE);
        BMCServiceDesk__Incident__c bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = null;
        bmcIncidentObj.BMCServiceDesk__contactType__c = null;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;

        Database.insert(bmcIncidentObj);

        Id bmcIncidentID = bmcIncidentObj.Id;
        
        String bmcIncidentSOQLQuery = COHUtil.buildSelectAllSOQLStatement(BMC_INCIDENT_OBJ) + ' where Id = :bmcIncidentID';
        List<BMCServiceDesk__Incident__c> incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        String newSummary = bmcIncidentObj.Summary__c;
        String newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);

		// This insert should result in an update of an existing record

        description = body + '8675309:' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID0 + vcOpsServer;

        bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);

        bmcIncidentObj.BMCServiceDesk__FKClient__c = null;
        bmcIncidentObj.BMCServiceDesk__contactType__c = null;
        bmcIncidentObj.Summary__c = null;
        bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;

        Database.insert(bmcIncidentObj);

        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(1, incidentList.size());
        bmcIncidentObj = incidentList.get(0);
        
        newSummary = bmcIncidentObj.Summary__c;
        newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
        System.assertEquals(null, newSummary);
        System.assertEquals(description, newDescription);

        Test.stopTest();
    }

    /*
     * Test bulk processing
     * 
     * NOTE: Test disabled because APU time limit is exceeded.  Remedyforce does too 
     * much stuff behind the scene.
     * 
     */
    private static testMethod void bulkReformatSummaryDescriptionTest() {
        if (!mRunAllTests && !mRunVerifyBulkReformatSummaryDescriptionTest) {
            System.debug('Skipping bulkReformatSummaryDescriptionTest()');
            return;
        }
        
        Test.startTest();
        
        setUserQueueIDs();
        setupCustomSettings();
        
        String body = 'Body: New alert was generated at Wed Jan 17 10:06:59 PST 2018';
        String summaryInfo = 'Info:IRWVPEPCFILE01 VirtualMachine is acting abnormally since Wed Jan 17 10:06:59 PST 2018 and was last updated at Wed Jan 17 10:06:59 PST 2018';
        String alertDefinition = 'Alert Definition Name: Epic File System Health is degraded:';
        String alertDescription = 'Alert Definition Description: Epic File System is not responsive';
        String objName = 'Object Name : IRWVPEPCFILE01';
        String objType = 'Object Type : VirtualMachine';
        String alertImpact = 'Alert Impact: health';
        String alertState = 'Alert State : critical';
        String alertType = 'Alert Type : Application';
        String alertSubType = 'Alert Sub-Type : Performance';
        String objHealthState = 'Object Health State: critical';
        String objRiskState = 'Object Risk State: warning';
        String objEfficiencyState = 'Object Efficiency State: info';
        String controlState = 'Control State: Open';
        String symptoms = 'Symptoms:SYMPTOM SET - self';
        String recommendations = 'Recommendations: Get a new computer';
        String notificationName = 'Notification Rule Name: PRDTicketNotification';
        String notificationRule = 'Notification Rule Description: Remedy Tickets for EPIC PRD';
        String alertID = 'Alert ID:bf869360-39bb-40000-83cf';
        String vcOpsServer = 'VCOps Server: IRWVPVROMSTR1';
        
        String description = body + ':' + summaryInfo + alertDefinition + alertDescription +
            objName + objType + alertImpact + alertState + alertType + alertSubType + objHealthState +
            objRiskState + objEfficiencyState + controlState + symptoms + recommendations + notificationName + 
            notificationRule + alertID + vcOpsServer;
    
        List<BMCServiceDesk__Incident__c> incidentList = new List<BMCServiceDesk__Incident__c>();
        for (Integer recCount = 0; recCount <= MAX_RECORDS; recCount) {
            BMCServiceDesk__Incident__c bmcIncidentObj = createBMCIncidentObject(mEmployeeID0, mQueueID0, description);
            bmcIncidentObj.Summary__c = null;
            bmcIncidentObj.BMCServiceDesk__incidentDescription__c = description;
            incidentList.add(bmcIncidentObj);
        }
        
        Database.insert(incidentList);
        
        String bmcIncidentSOQLQuery = COHUtil.buildSelectAllSOQLStatement(BMC_INCIDENT_OBJ) + 
            ' where BMCServiceDesk__FKClient__c = :mEmployeeID0 and OwnerId = :mQueueID0';
        incidentList = Database.query(bmcIncidentSOQLQuery);
        if (!COHUtil.isValidList(incidentList)) {
            System.assert(false, 'Expected a valid list but did not retrieve one');
        }
        System.assertEquals(MAX_RECORDS, incidentList.size());
        
        String expectedDescriptionStr = body + LINE_BREAK + alertDefinition + LINE_BREAK +alertDescription + LINE_BREAK + objName +
            LINE_BREAK + objType + LINE_BREAK + alertImpact + LINE_BREAK + alertState + LINE_BREAK + alertType + LINE_BREAK + alertSubType + LINE_BREAK + objHealthState +
            LINE_BREAK + objRiskState + LINE_BREAK + objEfficiencyState + LINE_BREAK + controlState + LINE_BREAK + symptoms + LINE_BREAK + recommendations + LINE_BREAK + 
            notificationName + LINE_BREAK + notificationRule + LINE_BREAK + alertID + LINE_BREAK + vcOpsServer + LINE_BREAK;

        for (BMCServiceDesk__Incident__c bmcIncidentObj: incidentList) {
            String newSummary = bmcIncidentObj.Summary__c;
            String newDescription = bmcIncidentObj.BMCServiceDesk__incidentDescription__c;
            
            System.assertEquals(summaryInfo, newSummary);
            System.assertEquals(expectedDescriptionStr, newDescription);
        }
        

        Test.stopTest();
    }

    /*
     * Create a BMCServiceDesk__Incident__c object.
     * 
     * @param employee      ID of the User object representing the employee.
     * @param queueID       Queue ID where this incident will be assigned.
     * @param description   Text description for the new incident.
     * @return              New BMCServiceDesk__Incident__c object.
     * 
     */
    private static BMCServiceDesk__Incident__c createBMCIncidentObject(Id employeeID, Id queueID, String description) {
        BMCServiceDesk__Incident__c incidentObj = null;
        if (employeeID != null && queueID != null && !String.isEmpty(description)) {
            incidentObj = new BMCServiceDesk__Incident__c();
            incidentObj.BMCServiceDesk__FKClient__c = employeeID;
            incidentObj.OwnerId = queueID;
            incidentObj.BMCServiceDesk__incidentDescription__c = description;
            incidentObj.Asset_Request_Created__c = true;
            incidentObj.BMCServiceDesk__contactType__c = null;
        }
        return incidentObj;
    }
    
    /*
     * Set the user and queue IDs
     * 
     */
    private static void setUserQueueIDs() {
        // The Foundation Account should be in prodcopy and prod
        String userSOQLQuery = 'select Id from User where name = \'Foundation Account\'';
        List<User> userList = Database.query(userSOQLQuery);
        User userObj = userList.get(0);
        mEmployeeID0 = userObj.Id;

        // In prod, the test should use the ID from the actual target ID.  However, 
        // this is not in the sandboxes, so the tests there should use the System Account ID instead.
         
        // The System Account should be in prodcopy and prod
        userSOQLQuery = 'select Id from User where name = \'System Account\'';
        userList = Database.query(userSOQLQuery);
        userObj = userList.get(0);
		String tempID = userObj.Id;
        mTargetClientID = tempID.left(COHUtil.GUI_ID_LENGTH);		// Test short ID obtained from the GUI.
        
        // Select a queue        
        String queueSOQLQuery = 'select id,  queueid, sobjecttype, Queue.Name from QueueSobject where SobjectType = \'BMCServiceDesk__Incident__c\' order by Queue.Name asc';
        List<QueueSobject> queueList = Database.query(queueSOQLQuery);
        if (COHUtil.isValidList(queueList)) {
            QueueSobject queueObj = queueList.get(0);
            mQueueID0 = queueObj.QueueId;
        } else {
            System.assert(false, 'Error: no queues were found for BMCServiceDesk__Incident__c object type');
        }
    }
    
    
    /*    
     * Set up the custom settings.  The setUserQueueIDs() should be invoked before calling this method.
     * 
     */
    private static void setupCustomSettings() {
        COH_Config_Setting__c configObj0 = new COH_Config_Setting__c();
        configObj0.Active__c = true;
        configObj0.Application_Name__c = VBLOCK_INCIDENT;
        configObj0.Name = SUMMARY_START_TOKEN;
        configObj0.Value__c = SUMMARY_START_TOKEN_VAL;
        configObj0.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj0.Configuration_Group__c = null;

        COH_Config_Setting__c configObj1 = new COH_Config_Setting__c();
        configObj1.Active__c = true;
        configObj1.Application_Name__c = VBLOCK_INCIDENT;
        configObj1.Name = ALERT_DEFINITION_NAME_TOKEN;
        configObj1.Value__c = ALERT_DEFINITION_NAME_TOKEN_VAL;
        configObj1.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj1.Configuration_Group__c = null;

        COH_Config_Setting__c configObj2 = new COH_Config_Setting__c();
        configObj2.Active__c = true;
        configObj2.Application_Name__c = VBLOCK_INCIDENT;
        configObj2.Name = INCIDENT_SOURCE;
        configObj2.Value__c = INCIDENT_SOURCE_VAL;
        configObj2.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj2.Configuration_Group__c = null;

        COH_Config_Setting__c configObj3 = new COH_Config_Setting__c();
        configObj3.Active__c = true;
        configObj3.Application_Name__c = VBLOCK_INCIDENT;
        configObj3.Name = CLIENT_ID;
        configObj3.Value__c = mTargetClientID;
        configObj3.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj3.Configuration_Group__c = null;
        
        List<COH_Config_Setting__c> configObjList = new List<COH_Config_Setting__c>();
        configObjList.add(configObj0);
        configObjList.add(configObj1);
        configObjList.add(configObj2);
        configObjList.add(configObj3);
        
        Database.insert(configObjList);
    }
}