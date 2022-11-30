/*
* This controller verifies the functionality of COH_QH_Evaluation_Request trigger.
* 
* Saidaiah Surisetti
* City of Hope
* Copyright (c) 2018
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
@isTest
public class COH_QH_Evaluation_Request_Test {
    
 // This test method will verify the adding X number of business days to the start date.
    
    private static testMethod void evaluationRequestTest(){
    test.startTest();
    Id complexCaseRecTypeId = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosByName().get('QH - Complex Case Review').getRecordTypeId();
    Id expertInterpretationRecTypeId = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosByName().get('QH - Expert Interpretation').getRecordTypeId();
    Id retroReviewRecTypeId = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosByName().get('QH - Retrospective Review').getRecordTypeId();
    Id geneTestRecTypeId = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosByName().get('QH - Test Request Form').getRecordTypeId();
    Id QHAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Quantum Health').getRecordTypeId();   
    list<Evaluation_Request__c> complexCaseRecList=new list<Evaluation_Request__c>();
        
    Account acc=new Account();
    acc.FirstName='Test';
    acc.LastName='Record';
  //  acc.Client__c='abbott';
    acc.Gender__pc='Male';
    acc.RecordTypeId=QHAccountRecTypeId;
    insert acc;
     
    account ac=[select id,name from account where Lastname=:acc.Lastname];
    Evaluation_Request__c complexCaseRec1=new Evaluation_Request__c();
    complexCaseRec1.Patient_Account__c=ac.id;
    complexcaserec1.Reasons_for_Review__c='Reason for review testing';
    complexcaserec1.Clinical_Summary__c='clinical summary testing';
    complexcaserec1.Compensation_Percentage_P1__c=25;
    complexcaserec1.Compensation_Percentage_P2__c=25;
    complexcaserec1.Compensation_Percentage_P3__c=25;
    complexcaserec1.Compensation_Percentage_P4__c=25;
    complexcaserec1.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    complexcaserec1.RecordTypeId=complexCaseRecTypeId;
    insert complexcaserec1;
    complexCaseRec1.NP_Triage_Date_Time__c=datetime.newInstance(2018, 10, 05, 14, 30, 0);
    complexCaseRecList.add(complexcaserec1);
    Update complexCaseRec1;
    
    Evaluation_Request__c complexCaseRec2=new Evaluation_Request__c();
  
    complexCaseRec2.Patient_Account__c=ac.id;
    complexcaserec2.Reasons_for_Review__c='Reason for review testing';
    complexcaserec2.Clinical_Summary__c='clinical summary testing';
    complexcaserec2.Compensation_Percentage_P1__c=25;
    complexcaserec2.Compensation_Percentage_P2__c=25;
    complexcaserec2.Compensation_Percentage_P3__c=25;
    complexcaserec2.Compensation_Percentage_P4__c=25;
    complexcaserec2.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    complexcaserec2.RecordTypeId=complexCaseRecTypeId;
    insert complexcaserec2;
    complexCaseRec2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 10, 05, 18, 30, 0);
    complexCaseRecList.add(complexcaserec2);
    Update complexCaseRec2;
    
    Evaluation_Request__c complexCaseRec3=new Evaluation_Request__c();
  
    complexCaseRec3.Patient_Account__c=ac.id;
    complexcaserec3.Reasons_for_Review__c='Excluding the weekends & Holidays testing';
    complexcaserec3.Clinical_Summary__c='clinical summary testing';
    complexcaserec3.Compensation_Percentage_P1__c=25;
    complexcaserec3.Compensation_Percentage_P2__c=25;
    complexcaserec3.Compensation_Percentage_P3__c=25;
    complexcaserec3.Compensation_Percentage_P4__c=25;
    complexcaserec3.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    complexCaseRec3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 3, 21, 10, 0, 0);
    complexCaseRec3.Report_Sent_to_QH_Date_Time__c=datetime.newInstance(2019, 3, 22, 10, 0, 0);
    complexCaseRec3.Submitted_for_Review_Date_Time__c=datetime.newInstance(2019, 3, 21, 10, 0, 0);
    complexcaserec3.RecordTypeId=complexCaseRecTypeId;
    insert complexcaserec3;
        
    Evaluation_Request__c evalObj=[select Exclude_From_Report__c from Evaluation_Request__c where id=:complexcaserec2.id];
    
   //system.assertEquals(true,evalObj.Exclude_From_Report__c);
    
    list<Evaluation_Request__c> expertInterRecList=new list<Evaluation_Request__c>();
    Evaluation_Request__c expertInterRec1=new Evaluation_Request__c();
    expertInterRec1.Cancer_Diagnosis__c='cancer diagnosis example text';
    expertInterRec1.Requested_Laboratory__c='Laboratory name here';
    expertInterRec1.Stage_at_Diagnosis__c='Stage 1';
    expertInterRec1.Stage_Date__c=Date.valueOf('2018-10-05');
    expertInterRec1.ICD_10_Code_s__c='some text';
    expertInterRec1.Compensation_Percentage_P1__c=25;
    expertInterRec1.Compensation_Percentage_P2__c=25;
    expertInterRec1.Compensation_Percentage_P3__c=25;
    expertInterRec1.Compensation_Percentage_P4__c=25;
    expertInterRec1.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    expertInterRec1.RecordTypeId=expertInterpretationRecTypeId;
    insert expertInterRec1;
    expertInterRec1.NP_Triage_Date_Time__c=datetime.newInstance(2018, 10, 05, 14, 30, 0);
    expertInterRecList.add( expertInterRec1);
    Update expertInterRec1;
        
    Evaluation_Request__c expertInterRec2=new Evaluation_Request__c();
    expertInterRec2.Cancer_Diagnosis__c='cancer diagnosis example text';
    expertInterRec2.Requested_Laboratory__c='Laboratory name here';
    expertInterRec2.Stage_at_Diagnosis__c='Stage 1';
    expertInterRec2.Stage_Date__c=Date.valueOf('2018-10-05');
    expertInterRec2.ICD_10_Code_s__c='some text';
    expertInterRec2.Compensation_Percentage_P1__c=25;
    expertInterRec2.Compensation_Percentage_P2__c=25;
    expertInterRec2.Compensation_Percentage_P3__c=25;
    expertInterRec2.Compensation_Percentage_P4__c=25;
    expertInterRec2.RecordTypeId=expertInterpretationRecTypeId;
    insert expertInterRec2;
    expertInterRec2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 10, 05, 18, 30, 0);
    expertInterRec2.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    expertInterRecList.add( expertInterRec2);
    Update expertInterRec2;
    
    
   Evaluation_Request__c retroReviewRec1=new Evaluation_Request__c();
   retroReviewRec1.Reasons_for_Review__c='Reason for review testing';
    retroReviewRec1.Clinical_Summary__c='clinical summary testing';
    retroReviewRec1.Compensation_Percentage_P1__c=25;
    retroReviewRec1.Compensation_Percentage_P2__c=25;
    retroReviewRec1.Compensation_Percentage_P3__c=25;
    retroReviewRec1.Compensation_Percentage_P4__c=25;
    retroReviewRec1.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    retroReviewRec1.RecordTypeId=retroReviewRecTypeId;
    insert retroReviewRec1;
    retroReviewRec1.NP_Triage_Date_Time__c=Date.valueOf('2018-10-05 14:00:00');
    Update retroReviewRec1;
    
   
    Evaluation_Request__c geneTestRec1=new Evaluation_Request__c();
    geneTestRec1.Cancer_Diagnosis__c='cancer diagnosis example text';
    geneTestRec1.Requested_Laboratory__c='Laboratory name here';
    geneTestRec1.Stage_at_Diagnosis__c='Stage 1';
    geneTestRec1.Stage_Date__c=Date.valueOf('2018-10-05');
    geneTestRec1.ICD_10_Code_s__c='some text';
    geneTestRec1.Compensation_Percentage_P1__c=25;
    geneTestRec1.Compensation_Percentage_P2__c=25;
    geneTestRec1.Compensation_Percentage_P3__c=25;
    geneTestRec1.Compensation_Percentage_P4__c=25;
    geneTestRec1.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';    
    geneTestRec1.RecordTypeId=geneTestRecTypeId;
    insert geneTestRec1;
    geneTestRec1.NP_Triage_Date_Time__c=Date.valueOf('2018-10-05 14:00:00');
    Update geneTestRec1;
   
    
                for(Evaluation_Request__c ce1:complexCaseRecList){
                if((ce1.NP_Triage_Date_Time__c).hour() < 16)
                {
                    ce1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(ce1.NP_Triage_Date_Time__c.date(), 6);
                    system.assertEquals(Date.valueOf('2018-10-15'),ce1.COH_Review_Due_Date__c);
                }
                Else
                {
                    ce1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(ce1.NP_Triage_Date_Time__c.date(), 7);
                    system.assertEquals(Date.valueOf('2018-10-16'),ce1.COH_Review_Due_Date__c);
                }
                }     
        
                for(Evaluation_Request__c ei:complexCaseRecList){
                if((ei.NP_Triage_Date_Time__c).hour() < 16)
                {
                    ei.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(ei.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2018-10-11'),ei.COH_Review_Due_Date__c);
                }
                Else
                {
                    ei.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(ei.NP_Triage_Date_Time__c.date(), 5);
                    system.assertEquals(Date.valueOf('2018-10-12'),ei.COH_Review_Due_Date__c);
                }
                }
        
                if((retroReviewRec1.NP_Triage_Date_Time__c).hour() < 16)
                {
                    retroReviewRec1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(retroReviewRec1.NP_Triage_Date_Time__c.date(), 9);
                    system.assertEquals(Date.valueOf('2018-10-19'),retroReviewRec1.COH_Review_Due_Date__c);
                }
                Else
                {
                    retroReviewRec1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(retroReviewRec1.NP_Triage_Date_Time__c.date(), 10);
                    system.assertEquals(Date.valueOf('2018-10-18'),retroReviewRec1.COH_Review_Due_Date__c);
                }
        
                if((geneTestRec1.NP_Triage_Date_Time__c).hour() < 16)
                {
                    geneTestRec1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(geneTestRec1.NP_Triage_Date_Time__c.date(), 2);
                    system.assertEquals(Date.valueOf('2018-10-10'),geneTestRec1.COH_Review_Due_Date__c);
                }
                Else
                {
                   geneTestRec1.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(geneTestRec1.NP_Triage_Date_Time__c.date(), 3);
                    system.assertEquals(Date.valueOf('2018-10-09'),geneTestRec1.COH_Review_Due_Date__c);
                }
               if(complexCaseRec3.NP_Triage_Date_Time__c!=null && complexCaseRec3.Report_Sent_to_QH_Date_Time__c!=null){
                   
                   complexCaseRec3.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(complexCaseRec3.NP_Triage_Date_Time__c.date(),complexCaseRec3.Report_Sent_to_QH_Date_Time__c.date()));
                system.assertEquals(2,complexCaseRec3.Days_Between_NP_Triage_Report_Sent__c);
               
               }
          
               if(complexCaseRec3.Submitted_for_Review_Date_Time__c!=null && complexCaseRec3.Report_Sent_to_QH_Date_Time__c!=null){
                   
                   complexCaseRec3.Days_Btw_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(complexCaseRec3.Submitted_for_Review_Date_Time__c.date(),complexCaseRec3.Report_Sent_to_QH_Date_Time__c.date()));
                system.assertEquals(2,complexCaseRec3.Days_Btw_Submitted_Report_Sent__c);
               
               }
      test.stopTest();
    }

}