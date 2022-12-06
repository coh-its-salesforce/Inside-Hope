/*
 * This trigger processes ITSAssetRequest__c objects.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
trigger COHITSAssetRequestTrigger on ITSAssetRequest__c (before update) {

    COHITSAssetRequestHelper.processUpdates(Trigger.new);
}