/*
* This controller verifies the functionality of COH_AM_Evaluation_Request trigger.
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
public class COH_AM_Evaluation_Request_Test {
// This test method will verify the adding X number of business days to the NP Triage date and it will update the COH Review Due date accordingly.
    private static testMethod void amevaluationRequestTest(){
    test.startTest();
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
       // AMC.RecordTypeId = EcenRecordTypeIdapo;
        insert Amc;
        AM_Evaluation_Request__c Amc1 = new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
        Amc1.Patient_Account_Country__c='United States';
        Amc1.Patient_Account_State__c='Alaska';
        Amc1.Request_Type__c='Virtual Evaluation';
        Amc1.Treating_Physician_State__c='Alaska';
        Amc1.Treating_Physician_2_State__c='California';
        Amc1.Virtual_Request_Type_1__c='Call';
        Amc1.Virtual_Request_Type_2__c='Call';
        Amc1.Type_of_Request__c='APO Expert Written Report';
        Amc1.Area_of_Cost_Savings__c='imaging';
        Amc1.Humanistic_Determination__c='Decreased risk of permanent heart damage';
        Amc1.Appropriate_Use_of_Healthcare__c='Evidence to support best practices';
        Amc1.Effective_Communication_CareCoordinate__c='Collaborative peer-to-peer discussion';
        Amc1.Financial_Alignment_ROI__c='Treatment was over-utilized';
        Amc1.Impact_of_Decision__c='Agree with minor recommendations';
        Amc1.Improved_Customer_Experience__c='Treatment that decreases toxicity';
        Amc1.Personalized_Patient_Care__c='Improved efficacy';
        Amc1.Preventable_Healthcare_Harm__c='Missed/incorrect diagnoses';
        AMC1.Purpose_of_Call__c='Clinical trial';
        AMC1.Outcome_Of_Review__c = 'Clinical Trial';
        AMC1.Priority__c='High';
        AMC1.Cancer_Diagnosis__c='Anal Cancer';
        AMC1.ICD_10_Code_s__c='C46.1';
        AMC1.Call_Re_scheduled__c='Yes';
        AMC1.Member_Reached__c='Yes	';
        AMC1.CSL_Call_Resolution__c='Proceeded with CSL';
        AMC1.Close_Reason__c='Member Dialed Wrong Service';
        AMC1.Call_Time_1__c='08:00 AM - 09:00 AM';
        AMC1.Call_Time_2__c='09:00 AM - 10:00 AM';
        AMC1.Call_Time_3__c='10:00 AM - 11:00 AM';
        Amc1.Compensation_Percentage_P1__c=25;
        Amc1.Compensation_Percentage_P2__c=25;
        Amc1.Compensation_Percentage_P3__c=25;
        Amc1.Compensation_Percentage_P4__c=25;
        Insert Amc1;
        
     //   id APOEARRecordTypeId = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
        system.assertEquals('United States',Amc1.Patient_Account_Country__c );
        list<AM_Evaluation_Request__c> amevalRecList=new list<AM_Evaluation_Request__c>();
         AM_Evaluation_Request__c amevalRecord=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
         amevalRecord.Status__c='NP triage';
         amevalRecord.Clinical_Summary__c='clinical summary testing';
         amevalRecord.Type_of_Request__c = 'Test Recommendations';
         amevalRecord.Compensation_Percentage_P1__c=25;
         amevalRecord.Compensation_Percentage_P2__c=25;
         amevalRecord.Compensation_Percentage_P3__c=25;
         amevalRecord.Compensation_Percentage_P4__c=25;
         amevalRecord.Medical_Carrier_Options__c = 'Aetna';
      //   amevalRecord.Benefit_Status__c = 'Enrolled';
         amevalRecord.Oncology_Service__c = 'EAR';
         amevalRecord.Cancer_Diagnosis__c='Anal Cancer';
     //  amevalRecord.RecordTypeId = APOEARRecordTypeId;
         
    insert amevalRecord;
   // amevalRecord.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 14, 30, 0);//Date.valueOf('2018-10-05 14:00:00');
        amevalRecord.NP_Triage_Date_Time__c =DateTime.newInstance(2019, 03, 22, 14, 00, 00);
    amevalRecList.add(amevalRecord);
    Update amevalRecord;
     
    AM_Evaluation_Request__c amevalRecord2=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
         amevalRecord2.Status__c='NP triage';
         amevalRecord2.Clinical_Summary__c='clinical summary testing';
         amevalRecord2.Type_of_Request__c = 'APO Expert Written Report';
         amevalRecord2.Compensation_Percentage_P1__c=25;
         amevalRecord2.Compensation_Percentage_P2__c=25;
         amevalRecord2.Compensation_Percentage_P3__c=25;
         amevalRecord2.Compensation_Percentage_P4__c=25;
      //   amevalRecord2.Benefit_Status__c = 'Enrolled';
         amevalRecord2.Oncology_Service__c = 'EAR';
         amevalRecord2.Cancer_Diagnosis__c='Anal Cancer';
     //   amevalRecord2.RecordTypeId = APOEARRecordTypeId;
    insert amevalRecord2;
    //amevalRecord2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 17, 30, 0);
    amevalRecord2.NP_Triage_Date_Time__c=DateTime.newInstance(2019, 03, 22, 14, 00, 00);
    amevalRecList.add(amevalRecord2);
    Update amevalRecord2;
        
        AM_Evaluation_Request__c amevalRecord4=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
         amevalRecord4.Status__c='NP triage';
         amevalRecord4.Clinical_Summary__c='clinical summary testing';
         amevalRecord4.Type_of_Request__c = 'APO Expert Written Report';
         amevalRecord4.Compensation_Percentage_P1__c=25;
         amevalRecord4.Compensation_Percentage_P2__c=25;
         amevalRecord4.Compensation_Percentage_P3__c=25;
         amevalRecord4.Compensation_Percentage_P4__c=25;
       //  amevalRecord4.Benefit_Status__c = 'Enrolled';
         amevalRecord4.Oncology_Service__c = 'EAR';
         amevalRecord4.Cancer_Diagnosis__c='Anal Cancer';
      //  amevalRecord4.RecordTypeId = APOEARRecordTypeId;
    insert amevalRecord4;
    amevalRecord4.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 22, 18, 30, 0);
    //amevalRecord4.NP_Triage_Date_Time__c=DateTime.newInstance(2019, 03, 22, 14, 00, 00);
    amevalRecList.add(amevalRecord4);
    Update amevalRecord4;
        
        AM_Evaluation_Request__c amevalRecord02=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
         amevalRecord02.Status__c='NP triage';
         amevalRecord02.Clinical_Summary__c='clinical summary testing';
         amevalRecord02.Type_of_Request__c = 'Enhanced Interpretation Review';
         amevalRecord02.Compensation_Percentage_P1__c=25;
         amevalRecord02.Compensation_Percentage_P2__c=25;
         amevalRecord02.Compensation_Percentage_P3__c=25;
         amevalRecord02.Compensation_Percentage_P4__c=25;
     //    amevalRecord02.Benefit_Status__c = 'Enrolled';
         amevalRecord02.Oncology_Service__c = 'EAR';
         amevalRecord02.Cancer_Diagnosis__c='Anal Cancer';
      //  amevalRecord02.RecordTypeId = APOEARRecordTypeId;
        
    insert amevalRecord02;
    amevalRecord02.NP_Triage_Date_Time__c=DateTime.newInstance(2019, 03, 22, 14, 00, 00);
    amevalRecList.add(amevalRecord02);
    Update amevalRecord02;
        
        AM_Evaluation_Request__c amevalRecord5=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
         amevalRecord5.Status__c='NP triage';
         amevalRecord5.Clinical_Summary__c='clinical summary testing';
         amevalRecord5.Type_of_Request__c = 'Enhanced Interpretation Review';
         amevalRecord5.Compensation_Percentage_P1__c=25;
         amevalRecord5.Compensation_Percentage_P2__c=25;
         amevalRecord5.Compensation_Percentage_P3__c=25;
         amevalRecord5.Compensation_Percentage_P4__c=25;
       //  amevalRecord5.Benefit_Status__c = 'Enrolled';
         amevalRecord5.Oncology_Service__c = 'EAR';
         amevalRecord5.Cancer_Diagnosis__c='Anal Cancer';
       //amevalRecord5.RecordTypeId = APOEARRecordTypeId;
        
    insert amevalRecord5;
    amevalRecord5.NP_Triage_Date_Time__c=DateTime.newInstance(2019, 03, 22, 21, 00, 00);
    amevalRecList.add(amevalRecord5);
    Update amevalRecord5;
        
        AM_Evaluation_Request__c amevalRecord3=new AM_Evaluation_Request__c(AM_Account__c = AMC.ID);
    //amevalRecord3.Patient_Account__c=ac.id;
    //amevalRecord3.Reasons_for_Review__c='Excluding the weekends & Holidays testing';
    amevalRecord3.Clinical_Summary__c='Test Recommendations';
    amevalRecord3.Compensation_Percentage_P1__c=25;
    amevalRecord3.Compensation_Percentage_P2__c=25;
    amevalRecord3.Compensation_Percentage_P3__c=25;
    amevalRecord3.Compensation_Percentage_P4__c=25;
  //  amevalRecord3.Benefit_Status__c = 'Enrolled';
    amevalRecord3.Oncology_Service__c = 'EAR';
    amevalRecord3.Cancer_Diagnosis__c='Anal Cancer';
    amevalRecord3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    amevalRecord3.Report_Sent_to_AM_Date_Time__c=datetime.newInstance(2019, 11, 29, 7, 0, 0);
    amevalRecord3.Submitted_for_Review_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    //amevalRecord3.RecordTypeId=complexCaseRecTypeId;
    //amevalRecord3.RecordTypeId = APOEARRecordTypeId;
    insert amevalRecord3;
        
        
        
    for(AM_Evaluation_Request__c am:amevalRecList){
        if(am.Type_of_Request__c == 'Complex/non-complex Case Reviews (EAR, APO)'){
                if((am.NP_Triage_Date_Time__c).hour() < 16)
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 7);
                    system.assertEquals(Date.valueOf('2019-04-02'),am.COH_Review_Due_Date__c);
                }
                Else
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 8);
                    system.assertEquals(Date.valueOf('2019-04-02'),am.COH_Review_Due_Date__c);
                }
            }
       else if(am.Type_of_Request__c == 'Test Request Review'){
                if((am.NP_Triage_Date_Time__c).hour() < 16)
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 3);
                    system.assertEquals(Date.valueOf('2019-03-27'),am.COH_Review_Due_Date__c);
                }
                Else
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-28'),am.COH_Review_Due_Date__c);
                }
            }
            else if(am.Type_of_Request__c == 'Enhanced (test) Interpretation Review'){
                if((am.NP_Triage_Date_Time__c).hour() < 16)
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 5);
                    system.assertEquals(Date.valueOf('2019-03-29'),am.COH_Review_Due_Date__c);
                }
                Else
                {
                    am.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(am.NP_Triage_Date_Time__c.date(), 6);
                    system.assertEquals(Date.valueOf('2019-04-01'),am.COH_Review_Due_Date__c);
                }
            }
 
                        
          }
        if(amevalRecord3.NP_Triage_Date_Time__c!=null && amevalRecord3.Report_Sent_to_AM_Date_Time__c!=null){
                   
                   amevalRecord3.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(amevalRecord3.NP_Triage_Date_Time__c.date(),amevalRecord3.Report_Sent_to_AM_Date_Time__c.date()));
                system.assertEquals(2,amevalRecord3.Days_Between_NP_Triage_Report_Sent__c);
               
               }
          
        
               if(amevalRecord3.Submitted_for_Review_Date_Time__c!=null && amevalRecord3.Report_Sent_to_AM_Date_Time__c!=null){
                   
                   amevalRecord3.Days_Btw_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(amevalRecord3.Submitted_for_Review_Date_Time__c.date(),amevalRecord3.Report_Sent_to_AM_Date_Time__c.date()));
                system.assertEquals(2,amevalRecord3.Days_Btw_Submitted_Report_Sent__c);
               
               }
    test.stopTest();   
    }
}