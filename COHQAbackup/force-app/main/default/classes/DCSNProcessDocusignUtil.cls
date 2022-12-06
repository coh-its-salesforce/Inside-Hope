/*
 * This class contains COH-specific utility methods for the Docusign object.
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
 
 public class DCSNProcessDocusignUtil {
     
	//  Goes through all records to see if a field has changed
    public static void processFieldChanges(List<dsfs__DocuSign_Status__c> oldObjects, List<dsfs__DocuSign_Status__c> newObjects) {
        List<Id> caseIDsToRetrieve = new List<Id>();
        Map<Id, String> newStatusValues = new Map<Id, String>();
        
        if (COHUtil.isValidList(oldObjects) && COHUtil.isValidList(newObjects)) {
            Integer maxObjects = oldObjects.size();
            for (Integer i = 0; i < maxObjects; i ++) {
                dsfs__DocuSign_Status__c oldObj = oldObjects.get(i);
                dsfs__DocuSign_Status__c newObj = newObjects.get(i);
                if (oldObj != null && newObj != null) {
                    String oldStatus = oldObj.dsfs__Envelope_Status__c;
                    String newStatus = newObj.dsfs__Envelope_Status__c;
                    if (!oldStatus.equalsIgnoreCase(newStatus)) {
                        Id caseId = newObj.dsfs__Case__c;
                        caseIDsToRetrieve.add(caseId);
                        newStatusValues.put(caseId, newStatus);
                    }
                }
            }
            
            //  Retrieve the cases from the database and update them with the new value
            if (COHUtil.isValidList(caseIDsToRetrieve)) {
			    List<Case> caseObjsToUpdate = new List<Case>();
	            List<Case> retrievedCases = [select Id, PHI_StatusNew__c from Case where Id in :caseIDsToRetrieve];
                for (Case caseObj : retrievedCases) {
                    Id caseObjID = caseObj.Id;
                    caseObj.PHI_StatusNew__c = newStatusValues.get(caseObjID);
	                caseObjsToUpdate.add(caseObj);
                }
                
				if (COHUtil.isValidList(caseObjsToUpdate)) {
                    List<Database.SaveResult> saveResult = Database.update(caseObjsToUpdate);
                    for (Database.SaveResult saveResultObj : saveResult) {
                        if (!saveResultObj.isSuccess()) {
                            throw new COHDocusignException('Error: could not update case objects in DCSNProcessAccountUtil');
                        }
                    }
                }
            }    
       }
    }
     
 }