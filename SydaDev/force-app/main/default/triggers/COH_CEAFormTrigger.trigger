/*
* Trigger for the COH_CEAForm__c object
* 
* Tim Hughes
* City of Hope 
* Copyright (c) 2018 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/ 
trigger COH_CEAFormTrigger on COH_CEAForm__c (before insert, before update) {
    List<COH_CEAForm__c> statusChangedRequests = new List<COH_CEAForm__c>();
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (COH_CEAForm__c currentItem : Trigger.New) {
            if (currentItem.COH_CEA_ApprovalStatus__c != Trigger.oldMap.get(currentItem.id).COH_CEA_ApprovalStatus__c) {
                    statusChangedRequests.add(currentItem);
            }
        }
        if (COHUTIL.isValidList(statusChangedRequests)) {
            COH_CEAFormTriggerHelper.setNewApprovers(statusChangedRequests);
        }
    }
}