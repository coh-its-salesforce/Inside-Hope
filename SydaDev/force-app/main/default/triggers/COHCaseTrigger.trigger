/*
 * This is trigger handler for COH-related operations with cases.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
trigger COHCaseTrigger on Case (after insert, after update, Before update) {
    private static final String CASE_OBJ = 'Case';
    private static final String NPS_RECORD_TYPE = 'New Patient Services';
    
    private static List<Id> mNPSAccountIDLIst = new List<Id>();     
    private static Id mNPSRecordTypeID = COHUtil.getRecordType(CASE_OBJ, NPS_RECORD_TYPE);
    if(trigger.isAfter){
        for(Case caseObj : Trigger.new){
    
            // Process NPS Account records when the Case.Action_Taken__c field has been 
            // updated to APPLICATION TAKEN.
            
            String callType = caseObj.Type;
            if (Trigger.isAfter) {
                if (caseObj.RecordTypeId == mNPSRecordTypeID) {
                    Case oldCase = null;
                    if (Trigger.isUpdate) {
                        oldCase = (Case) Trigger.oldMap.get(caseObj.Id);
                    }                    
                    Id accountID = COHCaseHelper.processNPSCase(caseObj, oldCase, Trigger.isUpdate, Trigger.isInsert);
                    if (accountID != null) {
                        mNPSAccountIDLIst.add(accountID);
                    }
                }
                
            }
        }
        if(trigger.isAfter && trigger.isUpdate){
            COH_CaseTriggerHelper.updateEHSQuestionaires(trigger.New, Trigger.oldMap);
        }
        if(COHUtil.isValidList(mNPSAccountIDLIst)) {
            NPSProcessAccountUtil.processCaseStatusUpdates(mNPSAccountIDLIst);
        }
    } 
    
    if(trigger.isbefore && trigger.isUpdate){
        COH_CaseTriggerHelper.populateEmail(trigger.New, Trigger.oldMap);
        COH_CaseTriggerHelper.doBeforeUpdate(trigger.New, Trigger.oldMap);
    }
    
    if(trigger.isbefore && trigger.isInsert){
        COH_CaseTriggerHelper.populateEmail(trigger.New, Trigger.oldMap);
    }
    
    
}