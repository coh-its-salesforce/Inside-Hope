/*
 * This trigger processes EPIC26Survey__c objects. 
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
trigger COHEpic26SurveyTrigger on EPIC26Survey__c (after update) {
	COHEpic26SurveyHelper.processSurveys();
}