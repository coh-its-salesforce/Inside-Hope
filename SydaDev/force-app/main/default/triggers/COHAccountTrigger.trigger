/*
 * This trigger processes Account objects.  Persistent Systems has another trigger on the Account
 * obect called CH_PaitentIntakeTrigger (sic) but it seems to be in progress.
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
trigger COHAccountTrigger on Account (after insert,before update,after update) {
    if(Trigger.isAfter){
        if(trigger.isUpdate){
            Boolean disableAutomation;
            try {
                disableAutomation = [SELECT Disable_Automation__c FROM User WHERE id=:UserInfo.getUserId()].Disable_Automation__c;    
            }
            catch (Exception e) {
                disableAutomation = false;
            }
            
            if (!disableAutomation){
                COHAccountHelper.processAccounts();
            }
        }
        if(trigger.isInsert){
            COHAccountHelper.afterInsert(trigger.new);
        }
    }
    
    if(Trigger.isBefore){
        
        if(trigger.isUpdate){
            COHAccountHelper.beforeUpdate(trigger.new,trigger.OldMap);
        }
    }
}