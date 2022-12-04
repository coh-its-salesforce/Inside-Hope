/*
 * This class contains the methods for handling trigger events for IMS Incident objects.
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
public class IMSIncidentTriggerHelper {
    
    private static final String ALL = 'All';
    private static final String DELIMETER = ';';
    
    /*
     * This method handles all trigger calls for the IMS_Incident object.
     * 
     */
    public static void processIMSIncidents() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter)  {
                if (Trigger.isInsert)  {
					List<IMS_IncidentAndDocumentAssoc__c> incidentDocumentJoinObjList = new List<IMS_IncidentAndDocumentAssoc__c>();
                    addRelevantDocuments(incidentDocumentJoinObjList);
                    if (COHUtil.isValidList(incidentDocumentJoinObjList)) {
                        Database.insert(incidentDocumentJoinObjList);
                    }
                } else if (Trigger.isUpdate)  {
                    // Check if the IMS incident category has changed.
                    // If it has, then remove the existing documentation references.
                    // Then add the new ones
                    Boolean incidentTypeChanged = false;
                    Integer maxSize = (Trigger.new).size();
                    List<Id> updatedRecordIDList = new List<Id>();
                    List<IMS_Incident__c> newRecords = (List<IMS_Incident__c>) Trigger.new;
                    List<IMS_Incident__c> oldRecords = (List<IMS_Incident__c>) Trigger.old;
                    for (Integer i = 0; i < maxSize; i++) {
                        IMS_Incident__c newIncidentObj = newRecords.get(i);
 						IMS_Incident__c oldIncidentObj = oldRecords.get(i);
						String newIncidentCategory = newIncidentObj.Incident_Category__c;		
 						String oldIncidentCategory = oldIncidentObj.Incident_Category__c;	
                        if ((newIncidentCategory != null && oldIncidentCategory == null) ||
                            (newIncidentCategory == null && oldIncidentCategory != null)) {

                                incidentTypeChanged = true;
                        		updatedRecordIDList.add(newIncidentObj.Id);
                        } else if (newIncidentCategory != null && oldIncidentCategory != null) {
                            List<String> newCategoriesList = newIncidentCategory.split(DELIMETER);
                            List<String> oldCategoriesList = oldIncidentCategory.split(DELIMETER);
                            if (checkForChangedCategories(newCategoriesList, oldCategoriesList)) {

                                incidentTypeChanged = true;
                                updatedRecordIDList.add(newIncidentObj.Id);
                            }
                        }
                    }

                    // Update the Helpful Documents only if the Incident type 
                    // has been changed
                    if (incidentTypeChanged == true) {
                        //  Remove documents from the new object
                        deleteOldDocuments(updatedRecordIDList);
                        
                        //  Add updated documents to the new object 
                        List<IMS_IncidentAndDocumentAssoc__c> incidentDocumentJoinObjList = new List<IMS_IncidentAndDocumentAssoc__c>();
                        addRelevantDocuments(incidentDocumentJoinObjList);
                        
                        if (COHUtil.isValidList(incidentDocumentJoinObjList)) {
                            Database.upsert(incidentDocumentJoinObjList);
                        }
                    }
                }
            }
        }
    }
    
	/*
	 * Add the relevant documents to an IMS Incident by creating IMS_IncidentAndDocumentAssoc__c objects.
	 * 
	 * @param	incidentDocumentJoinObjList		IMS_IncidentAndDocumentAssoc__c to upsert.
	 * 
	 */
    private static void addRelevantDocuments(List<IMS_IncidentAndDocumentAssoc__c> incidentDocumentJoinObjList) {
        List<IMS_Incident_Document__c> allDocuments = getAllIncidentDocuments();
        for (IMS_Incident__c incidentObj : (List<IMS_Incident__c>) Trigger.new)  {
            Id incidentObjID = incidentObj.Id;
            String incidentCategory = incidentObj.Incident_Category__c;		
            List<IMS_Incident_Document__c> relevantDocuments = getIncidentDocuments(incidentCategory,  allDocuments);
            if (COHUtil.isValidList(relevantDocuments)) {
                for (IMS_Incident_Document__c docObj : relevantDocuments) {
                    IMS_IncidentAndDocumentAssoc__c joinObj = new IMS_IncidentAndDocumentAssoc__c();
                    joinObj.IMS_Incident__c = incidentObjID;
                    joinObj.IMS_Incident_Document__c = docObj.Id;
                    incidentDocumentJoinObjList.add(joinObj);
                }
            }
        }
    }
    
    /*
     * Retrieves all IMS_Incident_Document__c objects.
     * 
     * @return		A list of all IMS_Incident_Document__c objects
     * 
     */
    private static List<IMS_Incident_Document__c> getAllIncidentDocuments() {
        String soqlQuery  = COHUtil.buildSelectAllSOQLStatement('IMS_Incident_Document__c');
        List<IMS_Incident_Document__c> incidentDocumentsList = Database.query(soqlQuery);
        return incidentDocumentsList;
    }
    
    /*
     * Retrieve a list of all IMS Incident Documents that are related to the IMS Incident category.
     * 
     * @param	incidentCategory		IMS Incident category (might be a list)
     * @param 	incidentDocumentsList	List of all IMS Incident Documents
     * @return							List of all IMS Incident Documents for the given IMS Incident category.
     * 
     */
    private static List<IMS_Incident_Document__c> getIncidentDocuments(String incidentCategory,  List<IMS_Incident_Document__c> incidentDocumentsList) {
        if (incidentCategory == null || !COHUtil.isValidList(incidentDocumentsList)) {
            return null;
        }
		List<IMS_Incident_Document__c> relevantDocumentsList = new List<IMS_Incident_Document__c>();
        List<String> incidentCategoryList = incidentCategory.split(DELIMETER);
        for (IMS_Incident_Document__c docObj : incidentDocumentsList) {
            List<String> docCategoryList = (docObj.Category__c).split(DELIMETER);
            if (isValidCategory(incidentCategoryList, docCategoryList)) {
                    relevantDocumentsList.add(docObj);
            }
        }
		return relevantDocumentsList;
    }
    
    /*
     * Check if any element of docCategoryList can be found in incidentCategoryList.
     * 
     * @param	incidentCategoryList		List of all applicable categories for the IMS Incident
     * @param	docCategoryList				List of all categories for which an IMS Document is valid.
     * @return								true if at least one element of docCategory list can be found
     * 										in incidentCategoryList, false otherwise.
     */
    private static Boolean isValidCategory(List<String> incidentCategoryList, List<String> docCategoryList) {
        if (!COHUtil.isValidList(incidentCategoryList) || !COHUtil.isValidList(docCategoryList)) {
            return false;
        }
        for (String docCategory : docCategoryList)    {
            for (String incidentCategory: incidentCategoryList) {
                if (docCategory.equalsIgnoreCase(incidentCategory) || docCategory.equalsIgnoreCase(ALL)) {
                    return true;
                }
            }
        }
        return false;
    }
    
	/* 
	 * Check if two lists differ in their contents.  The order of the items in each list is ignored.
	 * 
	 * @param	    list1		First list to check.
	 * @param	    list2		Second list to check.
	 * @return					true if the lists are different, false otherwise.
	 * 
	 */
    private static Boolean checkForChangedCategories(List<String> list1, List<String> list2) {
        Set<String> set1 = new Set<String>(list1);
        Set<String> set2 = new Set<String>(list2);
        if (set1.equals(set2)) {
            return false;
        } else {
            return true;
        }
    }
    
    /*
     I* Delete old IMS Incident Document records that are no longer needed.
     * 
     * @param	incidentObj		IMS incident objects where the documents should be removed.
     * @return					List of IMS Incident Document objects t
     * 
     */
    private static void deleteOldDocuments(List<Id> incidentObjIDs) {
        if (incidentObjIDs != null) {
            String soqlQuery = 'select Id from IMS_IncidentAndDocumentAssoc__c where IMS_Incident__c in :incidentObjIDs';
            List<sObject> objectsToDelete = Database.query(soqlQuery);
            Database.delete(objectsToDelete);
        }
    }
    
}