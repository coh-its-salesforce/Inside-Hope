/*
 * This trigger processes IMS_Incident__c objects.
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
trigger IMS_Incident_Trigger on IMS_Incident__c (after update, after insert) {
	IMSIncidentTriggerHelper.processIMSIncidents();
}