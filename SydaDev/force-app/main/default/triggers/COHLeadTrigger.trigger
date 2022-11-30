/*
* This trigger processes Lead objects.
* 
* Raymond Tam
* City of Hope
* Copyright (c) 2015
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  Test Class:COH_LeadCaseCreationTest
*/
trigger COHLeadTrigger on Lead (after insert,before update) {
    if(Trigger.isAfter){
        if(trigger.isInsert){
            //  COHLeadHelper.processLeads();
            COHLeadHelper.afterInsert(trigger.new);
        }
    }
     if(Trigger.isBefore){
        if(trigger.isInsert){
        }
        if(trigger.isUpdate){
            COHLeadHelper.beforeUpdate(trigger.new,trigger.OldMap);
        }
    }
}