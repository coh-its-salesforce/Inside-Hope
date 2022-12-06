/*
 * This trigger processes DocuSign_Status objects.  Although that is a managed code, 
 * some custom trigger functionality is required.
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
trigger COHDocusignTrigger on dsfs__DocuSign_Status__c (after update) {
    COHDocusignHelper.processRecords();
}