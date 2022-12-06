/*
* Test Class for the COH_CEAFormTrigger
*
* Tim Hughes
* City of Hope
* Copyright (c) 2018
*
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope
*/ 
@isTest
public class COH_CEAFormTriggerTest {
    PRIVATE STATIC FINAL STRING ALIAS = 'test1133';
    PRIVATE STATIC FINAL STRING EMAIL = 'thughes@coh.org';
    PRIVATE STATIC FINAL STRING EMAIL_ENCODING_KEY = 'UTF-8';
    PRIVATE STATIC FINAL STRING LANGUAGE_LOCAL_KEY = 'en_US';
    PRIVATE STATIC FINAL STRING LAST_NAME = 'coh_ceaFormTriggerTest';
    PRIVATE STATIC FINAL STRING LOCALE_SID_KEY = 'en_US';
    PRIVATE STATIC FINAL STRING TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    PRIVATE STATIC FINAL STRING USERNAME ='coh_ceaFormTriggerTest@coh.org.test';
    PRIVATE STATIC FINAL STRING PENDING_CONDITIONAL_APPROVALS = 'Pending Conditional Approvals';
    private static String mProfileId;
    private static User mConditionalApprover1;
    private static User mConditionalApprover2;
    private static User mConditionalApprover3;
    private static User mConditionalApprover4;
    private static User mConditionalApprover5;
    private static User mConditionalApprover6;
    private static User mConditionalApprover7;
    private static User mConditionalApprover8;
    private static User mConditionalApprover9;
    
    @isTest
    public static void test1_testConditionalApproverAssignment() {
        createApprovers();
		COH_CEAForm__c newRecord = new COH_CEAForm__c();
        test.startTest();
        insert newRecord;
        System.debug(mConditionalApprover1);
        newRecord.COH_CEA_ConditionalApprover1__c = mConditionalApprover1.Id;
        newRecord.COH_CEA_ConditionalApprover2__c = mConditionalApprover2.Id;
        newRecord.COH_CEA_ConditionalApprover3__c = mConditionalApprover3.Id;
        newRecord.COH_CEA_ConditionalApprover4__c = mConditionalApprover4.Id;
        newRecord.COH_CEA_ConditionalApprover5__c = mConditionalApprover5.Id;
        newRecord.COH_CEA_ConditionalApprover6__c = mConditionalApprover6.Id;
        newRecord.COH_CEA_ConditionalApprover7__c = mConditionalApprover7.Id;
        newRecord.COH_CEA_ConditionalApprover8__c = mConditionalApprover8.Id;
        newRecord.COH_CEA_ConditionalApprover9__c = mConditionalApprover9.Id;
        newRecord.COH_CEA_ApprovalStatus__c = PENDING_CONDITIONAL_APPROVALS;
        upsert newRecord;
        test.stopTest();
        
        COH_CEAForm__c updatedRecord = [SELECT COH_CEA_Approver1__c, COH_CEA_Approver2__c, COH_CEA_Approver3__c, COH_CEA_Approver4__c, COH_CEA_Approver5__c, COH_CEA_Approver6__c, COH_CEA_Approver7__c, COH_CEA_Approver8__c, COH_CEA_Approver9__c FROM COH_CEAForm__c WHERE id=:newRecord.id];
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover1__c, updatedRecord.COH_CEA_Approver1__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover2__c, updatedRecord.COH_CEA_Approver2__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover3__c, updatedRecord.COH_CEA_Approver3__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover4__c, updatedRecord.COH_CEA_Approver4__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover5__c, updatedRecord.COH_CEA_Approver5__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover6__c, updatedRecord.COH_CEA_Approver6__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover7__c, updatedRecord.COH_CEA_Approver7__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover8__c, updatedRecord.COH_CEA_Approver8__c);
        System.assertEquals(newRecord.COH_CEA_ConditionalApprover9__c, updatedRecord.COH_CEA_Approver9__c);
        
    }
    
    private static void createApprovers() {
        Id profileId = UserInfo.getProfileId();
        Id currentUser = UserInfo.getUserId();
        User runningUser = [SELECT id FROM User WHERE ProfileId =:profileId AND (NOT Id =:currentUser) AND IsActive = true LIMIT 1];
        
        mConditionalApprover1 = new User();
        mConditionalApprover1.Alias = ALIAS;
        mConditionalApprover1.Email = EMAIL;
        mConditionalApprover1.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover1.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover1.LastName = LAST_NAME;
        mConditionalApprover1.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover1.ProfileId = profileId;
        mConditionalApprover1.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover1.Username = USERNAME + '1';
        
        mConditionalApprover2 = new User();
        mConditionalApprover2.Alias = ALIAS;
        mConditionalApprover2.Email = EMAIL;
        mConditionalApprover2.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover2.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover2.LastName = LAST_NAME;
        mConditionalApprover2.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover2.ProfileId = profileId;
        mConditionalApprover2.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover2.Username = USERNAME + '2';
        
        mConditionalApprover3 = new User();
        mConditionalApprover3.Alias = ALIAS;
        mConditionalApprover3.Email = EMAIL;
        mConditionalApprover3.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover3.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover3.LastName = LAST_NAME;
        mConditionalApprover3.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover3.ProfileId = profileId;
        mConditionalApprover3.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover3.Username = USERNAME + '3';
        
        mConditionalApprover4 = new User();
        mConditionalApprover4.Alias = ALIAS;
        mConditionalApprover4.Email = EMAIL;
        mConditionalApprover4.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover4.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover4.LastName = LAST_NAME;
        mConditionalApprover4.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover4.ProfileId = profileId;
        mConditionalApprover4.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover4.Username = USERNAME + '4';
        
        mConditionalApprover5 = new User();
        mConditionalApprover5.Alias = ALIAS;
        mConditionalApprover5.Email = EMAIL;
        mConditionalApprover5.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover5.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover5.LastName = LAST_NAME;
        mConditionalApprover5.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover5.ProfileId = profileId;
        mConditionalApprover5.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover5.Username = USERNAME + '5';
        
        mConditionalApprover6 = new User();
        mConditionalApprover6.Alias = ALIAS;
        mConditionalApprover6.Email = EMAIL;
        mConditionalApprover6.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover6.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover6.LastName = LAST_NAME;
        mConditionalApprover6.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover6.ProfileId = profileId;
        mConditionalApprover6.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover6.Username = USERNAME + '6';
        
        mConditionalApprover7 = new User();
        mConditionalApprover7.Alias = ALIAS;
        mConditionalApprover7.Email = EMAIL;
        mConditionalApprover7.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover7.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover7.LastName = LAST_NAME;
        mConditionalApprover7.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover7.ProfileId = profileId;
        mConditionalApprover7.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover7.Username = USERNAME + '7';
        
        mConditionalApprover8 = new User();
        mConditionalApprover8.Alias = ALIAS;
        mConditionalApprover8.Email = EMAIL;
        mConditionalApprover8.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover8.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover8.LastName = LAST_NAME;
        mConditionalApprover8.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover8.ProfileId = profileId;
        mConditionalApprover8.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover8.Username = USERNAME + '8';
        
        mConditionalApprover9 = new User();
        mConditionalApprover9.Alias = ALIAS;
        mConditionalApprover9.Email = EMAIL;
        mConditionalApprover9.EmailEncodingKey = EMAIL_ENCODING_KEY;
        mConditionalApprover9.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
        mConditionalApprover9.LastName = LAST_NAME;
        mConditionalApprover9.LocaleSidKey = LOCALE_SID_KEY;
        mConditionalApprover9.ProfileId = profileId;
        mConditionalApprover9.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        mConditionalApprover9.Username = USERNAME + '9';
        
        List<User> toInsert = new List<User>();
        toInsert.add(mConditionalApprover1);
        toInsert.add(mConditionalApprover2);
        toInsert.add(mConditionalApprover3);
        toInsert.add(mConditionalApprover4);
        toInsert.add(mConditionalApprover5);
        toInsert.add(mConditionalApprover6);
        toInsert.add(mConditionalApprover7);
        toInsert.add(mConditionalApprover8);
        toInsert.add(mConditionalApprover9);
        System.runAs(runningUser) {
            insert toInsert;
        }
    }
}