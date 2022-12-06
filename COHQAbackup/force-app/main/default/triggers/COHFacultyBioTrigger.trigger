/*
 * This trigger processes Account objects.  Persistent Systems has another trigger on the Account
 * obect called CH_PaitentIntakeTrigger (sic) but it seems to be in progress.
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
trigger COHFacultyBioTrigger on COH2_Faculty__c (after update, after insert) {
    // Updates the final Faculty objects
    COHFacultyBioUtil.processAccounts(Trigger.new);
}