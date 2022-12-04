/*
 * This test class is for the IMS_Incident_Trigger
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
@isTest
public class IMSIncidentTriggerTest {
    private static final Boolean mRunAllTests = false;
    private static final Boolean mRunVerifyIMSTrigger = true;

    private static String ACTIVE_STATUS = 'Active';
    private static String PENDING_STATUS = 'Pending';
    private static String INCIDENT_NAME0 = 'Hostage Situation';
    private static String INCIDENT_NAME1 = 'Earthquake';
    private static String INCIDENT_NAME2 = 'Drill';
	private static String CATEGORY0 = 'Earthquake';
	private static String CATEGORY1 = 'Active Shooter';
	private static String CATEGORY2 = 'Flood';
	private static String CATEGORY3 = 'All';
    
    private static Id mIncidentID0 = null;
    private static Id mIncidentID1 = null;
    private static Id mIncidentDocID0 = null;
    private static Id mIncidentDocID1 = null;
    private static Id mIncidentDocID2 = null;
    private static Id mIncidentDocID3 = null;
    private static Id mIncidentDocID4 = null;

    private static testMethod void verifyIMSTrigger() {
        if (!mRunAllTests && !mRunVerifyIMSTrigger) {
            System.debug('Skipping verifyIMSTrigger()');
            return;
        }
        createObjects();
        
        // Check the Helpful Documents count
        List<IMS_IncidentAndDocumentAssoc__c> objList = [select IMS_Incident_Document__c from IMS_IncidentAndDocumentAssoc__c where IMS_Incident__c = :mIncidentID0];
        Integer validDocumentCount = 0;
        for (IMS_IncidentAndDocumentAssoc__c obj : objList) {
            Id objID = obj.IMS_Incident_Document__c;
            if (objID.equals(mIncidentDocID2) ||
               	objID.equals(mIncidentDocID3) ||
                objID.equals(mIncidentDocID4)) { 
            	validDocumentCount++;
            }
        }
        System.assertEquals(3, validDocumentCount);

        // Check the Helpful Documents count
        objList = [select IMS_Incident_Document__c from IMS_IncidentAndDocumentAssoc__c where IMS_Incident__c = :mIncidentID1];
        validDocumentCount = 0;
        for (IMS_IncidentAndDocumentAssoc__c obj : objList) {
            Id objID = obj.IMS_Incident_Document__c;
            if (objID.equals(mIncidentDocID0) ||
               	objID.equals(mIncidentDocID1) ||
               	objID.equals(mIncidentDocID3) ||
                objID.equals(mIncidentDocID4)) { 
            	validDocumentCount++;
            }
        }
        System.assertEquals(4, validDocumentCount);
		
        // Change the Incident type.  This should change the Helpful Document count
        
        IMS_Incident__c incidentObj = [select Id, Incident_Category__c from IMS_Incident__c where Id = :mIncidentID1 limit 1];
        incidentObj.Incident_Category__c = CATEGORY2;
        update incidentObj;

        // Check the Helpful Documents count
        objList = [select IMS_Incident_Document__c from IMS_IncidentAndDocumentAssoc__c where IMS_Incident__c = :mIncidentID1];
        validDocumentCount = 0;
        for (IMS_IncidentAndDocumentAssoc__c obj : objList) {
            Id objID = obj.IMS_Incident_Document__c;
            if (objID.equals(mIncidentDocID3) ||
                objID.equals(mIncidentDocID4)) { 
            	validDocumentCount++;
            }
        }
        System.assertEquals(2, validDocumentCount);
		
        // Change the Incident status.  This should NOT change the Helpful Document count
        
        incidentObj = [select Id, Incident_Category__c from IMS_Incident__c where Id = :mIncidentID1 limit 1];
		incidentObj.Status__c = ACTIVE_STATUS;
    	update incidentObj;

        // Check the Helpful Documents count
        objList = [select IMS_Incident_Document__c from IMS_IncidentAndDocumentAssoc__c where IMS_Incident__c = :mIncidentID1];
        validDocumentCount = 0;
        for (IMS_IncidentAndDocumentAssoc__c obj : objList) {
            Id objID = obj.IMS_Incident_Document__c;
            if (objID.equals(mIncidentDocID3) ||
                objID.equals(mIncidentDocID4)) { 
            	validDocumentCount++;
            }
        }
        System.assertEquals(2, validDocumentCount);
		
    }
    
    //
    // Create common objects for testing
    // 

    private static void createObjects() {
        
        IMS_Incident_Document__c incidentDocument0 = new IMS_Incident_Document__c();
        incidentDocument0.Category__c = CATEGORY0;
        insert incidentDocument0;
        mIncidentDocID0 = incidentDocument0.Id;
        
        IMS_Incident_Document__c incidentDocument1 = new IMS_Incident_Document__c();
        incidentDocument1.Category__c = CATEGORY0;
        insert incidentDocument1;
        mIncidentDocID1 = incidentDocument1.Id;
        
        IMS_Incident_Document__c incidentDocument2 = new IMS_Incident_Document__c();
        incidentDocument2.Category__c = CATEGORY1;
        insert incidentDocument2;
        mIncidentDocID2 = incidentDocument2.Id;
        
        IMS_Incident_Document__c incidentDocument3 = new IMS_Incident_Document__c();
        incidentDocument3.Category__c = CATEGORY3;
        insert incidentDocument3;
        mIncidentDocID3 = incidentDocument3.Id;
        
        IMS_Incident_Document__c incidentDocument4 = new IMS_Incident_Document__c();
        incidentDocument4.Category__c = CATEGORY3;
        insert incidentDocument4;
        mIncidentDocID4 = incidentDocument4.Id;
        
        IMS_Incident__c incident0 = new IMS_Incident__c();
        incident0.Name = INCIDENT_NAME0;
        incident0.Incident_Category__c = CATEGORY1;
        incident0.Status__c = ACTIVE_STATUS;
        incident0.Start_Date_Time__c = Date.today();
        insert incident0;
        
        mIncidentID0 = incident0.Id;

        IMS_Incident__c incident1 = new IMS_Incident__c();
        incident1.Name = INCIDENT_NAME1;
        incident1.Incident_Category__c = CATEGORY0;
        incident1.Status__c = PENDING_STATUS;
        incident1.Start_Date_Time__c = Date.today();
        insert incident1;
        
        mIncidentID1 = incident1.Id;

    }
    
}