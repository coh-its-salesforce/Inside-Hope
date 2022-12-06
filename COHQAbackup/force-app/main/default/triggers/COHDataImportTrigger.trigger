/*
 * This trigger processes Data Import Record objects.  
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
trigger COHDataImportTrigger on Data_Import_Record__c (after insert) {
	COHDataImportHelper.processRecords();
}