/*
* This Test Class verifies the functionality of COH_AM_Picklist_Update trigger.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
@isTest
public class COH_AM_Picklist_Update_Test {
    public static testmethod void PicklistUpdateTest(){
        id EcenRecordTypeIdapo = Schema.SObjectType.AM_Account__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
        id EcenRecordTypeIdcancer = Schema.SObjectType.AM_Account__c.getRecordTypeInfosByName().get('Cancer Support').getRecordTypeId();
        
        AM_Account__c Amc = new AM_Account__c();
        AMC.Salutation__c = 'Mr.';
        AMC.Salutation_DB__c = 'Mr.';
        AMC.Gender_DB__c = 'Male';
        AMC.Gender__c = 'Male';
        Amc.Last_Name__c='abcd';
        AMC.Relationship_to_the_Insured_DB__c='Employee';
        AMC.Relationship_to_Employee_DB__c='Patient is Employee';
        AMC.Relationship_to_the_Insured__c='Employee';
        AMC.Relationship_to_Employee__c='Patient is Employee';
        AMC.Preferred_Language_Depreciated__c='Armenian';
        AMC.Plan_Service_DB__c='Anthem';
         AMC.Plan_Service__c='Anthem';
        AMC.Employee_Preferred_Phone__c='Home';
        AMC.Employee_Gender__c='Male';
        // AMC.Employer__c='Facebook';
        AMC.Benefit_Status__c = 'Enrolled';
        AMC.HDP_Parent_ID__c = '1234567';
        AMC.Date_of_Birth__c=Date.newInstance(2019, 04, 12);
        AMC.RecordTypeId = EcenRecordTypeIdapo;
        insert Amc;
        
        id EcenRecordTypeId = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
        AM_Evaluation_Request__c Am1 = new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
        Am1.Patient_Account_Country__c='United States';
        Am1.Patient_Account_State__c='Alaska';
        Am1.Request_Type__c='Virtual Evaluation';
        Am1.Treating_Physician_State__c='Alaska';
        Am1.Treating_Physician_2_State__c='California';
        Am1.Virtual_Request_Type_1__c='Call';
        Am1.Virtual_Request_Type_2__c='Call';
        Am1.Type_of_Request__c='APO Expert Written Report';
        Am1.Area_of_Cost_Savings__c='imaging';
        Am1.Humanistic_Determination__c='Decreased risk of permanent heart damage';
        Am1.Appropriate_Use_of_Healthcare__c='Evidence to support best practices';
        Am1.Effective_Communication_CareCoordinate__c='Collaborative peer-to-peer discussion';
        Am1.Financial_Alignment_ROI__c='Treatment was over-utilized';
        Am1.Impact_of_Decision__c='Agree with physician';
        Am1.Improved_Customer_Experience__c='Treatment that decreases toxicity';
        Am1.Personalized_Patient_Care__c='Improved efficacy';
        Am1.Preventable_Healthcare_Harm__c='Missed/incorrect diagnoses';
        AM1.Purpose_of_Call_DB__c='General information';
        AM1.Purpose_of_Call__c='General information';
        AM1.Priority__c='High';
        AM1.Cancer_Diagnosis__c='Anal Cancer';
        AM1.Cancer_Diagnosis_DB__c='Anal Cancer';
        AM1.Oncology_Service__c='EAR';
        AM1.ICD_10_Code_s__c='C46.1';
        AM1.ICD_10_Code_s_DB__c = 'C46.1';
        AM1.Call_Re_scheduled__c='Yes';
        AM1.Member_Reached__c='Yes	';
        AM1.CSL_Call_Resolution__c='Proceeded with CSL';
        AM1.Close_Reason__c='Member Dialed Wrong Service';
        AM1.Call_Time_1__c='08:00 AM - 09:00 AM';
        AM1.Call_Time_2__c='09:00 AM - 10:00 AM';
        AM1.Call_Time_3__c='10:00 AM - 11:00 AM';
        Am1.Compensation_Percentage_P1__c=25;
        Am1.Compensation_Percentage_P2__c=25;
        Am1.Compensation_Percentage_P3__c=25;
        Am1.Compensation_Percentage_P4__c=25;
        Am1.Other_Pertinent_Medical_Information__c='Starting';
        Am1.Mailing_Street__c='CA';
        Am1.RecordTypeId = EcenRecordTypeId; 
        
        Insert Am1;
        
        system.assertEquals('Male',AMC.Gender_DB__c);
        //for ecen 
        
        RecordType rtObj = [SELECT Id FROM RecordType WHERE SobjectType='AM_Account__c' AND name='ECEN  Accounts'];
        
       // Id contactrecordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('COH Contacts').getRecordTypeId();
       //ECEN Accounts,ECEN Evaluation Requests
        
        //Creating new am_account record with required fields for testing.
        AM_Account__c accountobj = new AM_Account__c();
        accountobj.First_Name__c = 'testing';
        accountobj.Last_Name__c = 'account';
        accountobj.Salutation_DB__c ='Mr.';
        accountobj.Gender_DB__c ='Male';
        accountobj.Date_of_Birth__c = date.parse('06/07/2011');
        accountobj.Mailing_State_Province__c = 'new york';
        accountobj.Patient_COE_Benefit_Identification_Numbe__c= '89247589234';
        accountobj.Treatment_Patient_Reported_to_HDP__c = 'Previous Treatment';
        accountobj.Local_Physician_First_Name_Last_Name__c = 'firstname';
        accountobj.Local_Physician_Credentials__c = 'MD';
        accountobj.Local_Physician_Specialty__c = 'Primary Care';
        accountobj.Local_Physician_Street_Address__c = 'local street';
        accountobj.Local_Physician_City__c = 'local city';
        accountobj.Local_Physician_State__c = 'Alaska';
        accountobj.Local_Physician_Zip__c = '7489324';
        accountobj.Local_Physician_Country__c = 'usa';
        accountobj.Local_Physician_Phone_Number__c = '749327433';
        accountobj.Local_Physician_Fax_Number__c = '4897123947';
        accountobj.RecordTypeId = rtObj.Id;
        insert accountobj;
        AM_Account__c acc=[select id,name from AM_Account__c where id=:accountobj.id];
        Id redwoodrecordtypeid1 = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('ECEN Evaluation Requests').getRecordTypeId();
        AM_Evaluation_Request__c rw1=new Am_Evaluation_Request__c();
        rw1.AM_Account__c=acc.id;
        rw1.Purpose_of_Call_DB__c ='Clinical trial';
        rw1.Cancer_Diagnosis_DB__c = 'Anal Cancer';
        rw1.Patient_Account_Country__c='United States';
        rw1.Patient_Account_State__c='Alaska';
        rw1.Request_Type__c='Virtual Evaluation';
        rw1.Treating_Physician_State__c='Alaska';
        rw1.Treating_Physician_2_State__c='California';
        rw1.Virtual_Request_Type_1__c='Call';
        rw1.Virtual_Request_Type_2__c='Call';
        rw1.Type_of_Request__c='APO Expert Written Report';
        rw1.Area_of_Cost_Savings__c='imaging';
        rw1.Humanistic_Determination__c='Decreased risk of permanent heart damage';
        rw1.Appropriate_Use_of_Healthcare__c='Evidence to support best practices';
        rw1.Effective_Communication_CareCoordinate__c='Collaborative peer-to-peer discussion';
        rw1.Financial_Alignment_ROI__c='Treatment was over-utilized';
        rw1.Impact_of_Decision__c='Agree with physician';
        rw1.Improved_Customer_Experience__c='Treatment that decreases toxicity';
        rw1.Personalized_Patient_Care__c='Improved efficacy';
        rw1.Preventable_Healthcare_Harm__c='Missed/incorrect diagnoses';
        rw1.Purpose_of_Call__c='Clinical trial';
        rw1.Outcome_Of_Review__c = 'Clinical Trial';
        rw1.Priority__c='High';
        rw1.ICD_10_Code_s__c='C46.1';
        rw1.Call_Re_scheduled__c='Yes';
        rw1.Member_Reached__c='Yes';
        rw1.CSL_Call_Resolution__c='Proceeded with CSL';
        rw1.Close_Reason__c='Member Dialed Wrong Service';
        rw1.Call_Time_1__c='08:00 AM - 09:00 AM';
        rw1.Call_Time_2__c='09:00 AM - 10:00 AM';
        rw1.Call_Time_3__c='10:00 AM - 11:00 AM';
        rw1.Compensation_Percentage_P1__c=25;
        rw1.Compensation_Percentage_P2__c=25;
        rw1.Compensation_Percentage_P3__c=25;
        rw1.Compensation_Percentage_P4__c=25;
        rw1.RecordTypeId = redwoodrecordtypeid1;
        insert rw1;
        
        
        
    }
}