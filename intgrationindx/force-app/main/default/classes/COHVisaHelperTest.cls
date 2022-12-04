/* 
* Larry Kiang
* City of Hope 
* Copyright (c) 2019 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/

@isTest(seeAllData = false)
public class COHVisaHelperTest {   
    public testMethod static void unitTest() {  
        system.debug('Hello');
        STRING EMAIL = 'TESTUSERDISREGARD@coh.org';
        STRING LAST_NAME = 'Wayne';
        STRING First_Name = 'Bruce';
        STRING ALIAS = 'Batman';
        STRING TIME_ZONE_SID_KEY = 'America/Los_Angeles';
        STRING LANGUAGE_LOCALE_KEY = 'en_US';
        STRING LOCALE_SID_KEY = 'en_US';
        STRING EMAIL_ENCODING_KEY = 'UTF-8';
        STRING EMPLOYEE_NUMBER = '123456';
        STRING ITLT = 'ITLT';
        STRING ITLT_OWNER_FIRST_NAME = 'VisaTest';
        STRING ITLT_OWNER_LAST_NAME = 'Anonymous';
        STRING VALID_DEPARTMENT = 'ITS';
        STRING BOSSEMAIL = 'TESTBOSSDISREGARD@coh.org';
        STRING BOSSLASTNAME = 'Hithcock';
        STRING BOSSFIRSTNAME = 'Alfred';
        STRING BOSSALIAS = 'BigBoss';
        STRING BOSSEmployeenumber = '1234567';      
        Id ProfileID = [select Id, Name from Profile where Name ='COH International Services' LIMIT 1].id;
        
        user portalboss = new User();
        portalboss.Username = BOSSEMAIL;
        portalboss.Email = BOSSEMAIL;
        portalboss.LastName = BOSSLASTNAME;
        portalBoss.FirstName = BOSSFIRSTNAME;
        portalboss.Alias = BOSSALIAS;
        portalboss.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        portalboss.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
        portalboss.LocaleSidKey = LOCALE_SID_KEY;
        portalboss.EmailEncodingKey = EMAIL_ENCODING_KEY;
        portalboss.ProfileId = ProfileID;
        portalboss.IsActive = true;
        portalboss.EmployeeNumber = BOSSEmployeenumber;
        portalboss.Department = VALID_DEPARTMENT;
        portalboss.CommunityNickname = BOSSLASTNAME;
        insert portalboss;
        
        user portaluser = new User();
        portaluser.Username = EMAIL;
        portaluser.Email = EMAIL;
        portaluser.FirstName = First_Name;
        portaluser.LastName = LAST_NAME;
        portaluser.Alias = ALIAS;
        portaluser.CommunityNickname = LAST_NAME; 
        portaluser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
        portaluser.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
        portaluser.LocaleSidKey = LOCALE_SID_KEY;
        portaluser.EmailEncodingKey = EMAIL_ENCODING_KEY;
        portaluser.ProfileId = ProfileID;
        portaluser.IsActive = true;
        portaluser.EmployeeNumber = EMPLOYEE_NUMBER;
        portaluser.Department = VALID_DEPARTMENT;
        portaluser.mgr__c = portalboss.Id;
        insert portaluser;
        
        list<id>portaluserid = new list<id>();
        portaluserid.add(portaluser.id);
        Test.startTest();
        AfterUserCreation(portaluserid);
        Test.stopTest();
        List<Visa__c>DeactivatedVisas = [select Id, name, active__c from Visa__c where employee__c =: portaluser.id and active__c = false];
        List<Visa__c>AllCreatedVisas = [select Id, name, active__c from Visa__c where employee__c =: portaluser.id];
        system.debug('Total Visas Created by portaluser = '+ AllCreatedVisas.size());
        system.debug('Portal Users Manager = ' + portaluser.mgr__c);
        system.assertEquals(5, DeactivatedVisas.size());
		
    }

    @future 
    //Creates six visa records and deactivates all but the latest one. 
    static void AfterUserCreation(List<ID> UserIDsforVisas){
        String userIdValue;
        for(id userId : userIDsForVisas){
            userIdvalue = userID;
        }
        
        User applicantUser = [select Id from user where Id =: userIdvalue Limit 1];
        Date today = Date.today();
        String visaObj	= 'Visa__c';
        String InternationalServices = 'International Services';
        id RecTypeId = COHUtil.getRecordType(visaObj, InternationalServices);
        List<Visa__c> visasToInsert = new List<Visa__c>();
        Visa__c Visa = new Visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                   Proposed_Individual_Last_Name__c ='Last name',
                                   Case_Type__c= 'Transfer from another Organization',
                                   Community_User_Name__c =userinfo.getuserid(),
                                   Business_Manager_or_Contact_Person__c = UserIdvalue,
                                   Supervisor__c = UserIdvalue,
                                   of_Business_Manager_Business_Director__c = UserIdvalue,
                                   Approver_Department_Head__c = UserIdvalue,
                                   VP_ET_Member__c = UserIdvalue,
                                   Assigned_ISSO_Member__c = UserIdvalue,
                                   I_20_Valid_To__c = Today - 30,
                                   Employee__c = applicantUser.Id,
                                   Active__c = true,
                                   Status__c = 'New',
                                   RecordTypeId=RecTypeId,
                                   Createddate = Today - 500
                                  );
        visastoInsert.add(Visa);
        visa__c Visa2 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                    Proposed_Individual_Last_Name__c ='Last name',
                                    Case_Type__c= 'Transfer from another Organization',
                                    Community_User_Name__c =userinfo.getuserid(),
                                    Business_Manager_or_Contact_Person__c = UserIdvalue,
                                    Supervisor__c = UserIdvalue,
                                    of_Business_Manager_Business_Director__c = UserIdvalue,
                                    Approver_Department_Head__c = UserIdvalue,
                                    VP_ET_Member__c = UserIdvalue,
                                    Assigned_ISSO_Member__c = UserIdvalue,
                                    Initial_F_1_OPT_Valid_To__c = Today - 15,
                                    Employee__c = applicantUser.Id,
                                    Active__c = true,
                                    Status__c = 'New',
                                    RecordTypeId=RecTypeId,
                                    createddate = today - 400
                                   );   
        visastoInsert.add(Visa2); 
        visa__c Visa3 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                    Proposed_Individual_Last_Name__c ='Last name',
                                    Case_Type__c= 'Transfer from another Organization',
                                    Community_User_Name__c =userinfo.getuserid(),
                                    Business_Manager_or_Contact_Person__c = UserIdvalue,
                                    Supervisor__c = UserIdvalue,
                                    of_Business_Manager_Business_Director__c = UserIdvalue,
                                    Approver_Department_Head__c = UserIdvalue,
                                    VP_ET_Member__c = UserIdvalue,
                                    Assigned_ISSO_Member__c = UserIdvalue,
                                    DS_2019_Valid_To__c = Today + 100,
                                    Employee__c = applicantUser.Id,
                                    Active__c = true,
                                    RecordTypeId=RecTypeId,
                                    Status__c = 'New',
                                    createddate = Today - 300
                                   );   
        
        visastoInsert.add(Visa3);

        visa__c Visa4 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                    Proposed_Individual_Last_Name__c ='Last name',
                                    Case_Type__c= 'Transfer from another Organization',
                                    Community_User_Name__c =userinfo.getuserid(),
                                    Business_Manager_or_Contact_Person__c = UserIdvalue,
                                    Supervisor__c = UserIdvalue,
                                    of_Business_Manager_Business_Director__c = UserIdvalue,
                                    Approver_Department_Head__c = UserIdvalue,
                                    VP_ET_Member__c = UserIdvalue,
                                    Assigned_ISSO_Member__c = UserIdvalue,
                                    F_1_STEM_OPT_Valid_To__c = Today - 50,
                                    Employee__c = applicantUser.Id,
                                    Active__c = true,
                                    Status__c = 'New',
                                    RecordTypeId=RecTypeId,
                                    createddate = Today - 600
                                   );   
        visastoInsert.add(Visa4);
                visa__c Visa5 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                    Proposed_Individual_Last_Name__c ='Last name',
                                    Case_Type__c= 'Transfer from another Organization',
                                    Community_User_Name__c =userinfo.getuserid(),
                                    Business_Manager_or_Contact_Person__c = UserIdvalue,
                                    Supervisor__c = UserIdvalue,
                                    of_Business_Manager_Business_Director__c = UserIdvalue,
                                    Approver_Department_Head__c = UserIdvalue,
                                    VP_ET_Member__c = UserIdvalue,
                                    Assigned_ISSO_Member__c = UserIdvalue,
                                    I_797_Valid_To__c = Today - 60,
                                    Employee__c = applicantUser.Id,
                                    Active__c = True,
                                    Status__c = 'New',
                                    RecordTypeId=RecTypeId,
                                    createddate = Today - 50
                                   );   
        visastoInsert.add(Visa5);
        insert visastoInsert;
        List<Visa__c> visaUpdate = new List <Visa__c>();
        for (Visa__c v : visastoInsert){
            v.Status__c = 'Completed';
            visaUpdate.add(v);
        }
        update visaUpdate;
        visa__c MostCurrentVisa = new visa__c(Proposed_Individual_First_Name__c ='apFirst',
                                              Proposed_Individual_Last_Name__c ='MostCurrent',
                                              Case_Type__c= 'Transfer from another Organization',
                                              Community_User_Name__c =userinfo.getuserid(),
                                              Business_Manager_or_Contact_Person__c = UserIdvalue,
                                              Supervisor__c = UserIdvalue,
                                              of_Business_Manager_Business_Director__c = UserIdvalue,
                                              Approver_Department_Head__c = UserIdvalue,
                                              VP_ET_Member__c = UserIdvalue,
                                              Assigned_ISSO_Member__c = UserIdvalue,
                                              I_797_Valid_To__c = Today + 199,
                                              Employee__c = applicantUser.Id,
                                              Active__c = True,
                                              Status__c = 'New',
                                              RecordTypeId=RecTypeId,
                                              createddate = Today
                                             );   
        
        insert MostCurrentVisa;
        MostCurrentVisa.Status__c = 'Completed';
        Update MostCurrentVisa;

    }
    //Dummy CRON expression: midnight on March 15.
    //Because this is a test, job executes
    //immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob(){
        //Create Visa Records where visa date is older than today
        string visaObj	= 'Visa__c';
        String InternationalServices = 'International Services';
        id RecTypeId = COHUtil.getRecordType(visaObj, InternationalServices);
        List<Visa__c> visatoSchedule = new List<Visa__c>(); 
        for(Integer i = 0; i<200; i++){
            Visa__c v = new Visa__c(Proposed_Individual_First_Name__c ='apFirst' +i,
                                    Proposed_Individual_Last_Name__c ='Last Name' +i,
                                    Case_Type__c= 'Transfer from another Organization',
                                    I_797_Valid_To__c = Date.today() - 200 + i,
                                    Active__c = True,
                                    Status__c = 'New',
                                    RecordTypeId=RecTypeId
                                    );
            visatoSchedule.add(v);
        }
        insert visatoSchedule;
        test.startTest();
        String jobID = System.schedule('ScheduledVisaTest', CRON_EXP, new COHScheduleVisaDeactivate());
		test.stopTest();
        List<Visa__c>ActiveVisas = [Select Id, name from Visa__c where active__c != True and Id in: visatoschedule];
        system.assertEquals(200, ActiveVisas.size());
    } 
}