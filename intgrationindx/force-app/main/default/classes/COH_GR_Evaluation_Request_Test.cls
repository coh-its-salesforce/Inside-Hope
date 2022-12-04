/*
* This controller verifies the functionality of GR_Evaluation_Request__c class
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
    public class COH_GR_Evaluation_Request_Test {
// This test method will verify the adding X number of business days to the NP Triage date and it will update the COH Review Due date accordingly.
    private static testMethod void COHGRevaluationRequestTest(){
    test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Genentech Patient').getRecordTypeId();
        //Id cohrecordtypeid1 = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
       
        account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.Employer__c ='Genentech';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.Plan_Service__c = 'Waived';
        Amc.RecordTypeId = cohrecordtypeid;
        Amc.Referral_Source1__c = 'Optum';
        insert Amc;
        
        list<GR_Evaluation_Request__c> GRevalRecList=new list<GR_Evaluation_Request__c>();
        GR_Evaluation_Request__c GRevalRecord=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
        //hdevalRecord.Request_Type__c = 'In Person Evaluation';
        GRevalRecord.Status__c='NP Triage';
        //GRevalRecord.Oncology_Service__c = 'APO';
        GRevalRecord.Evidence_1__c ='Test Evidence';
        GRevalRecord.COH_Physician_1_CLINICAL_RECOMMENDATIONS__c = 'Test Recomendation';
        GRevalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
        GRevalRecord.Clinical_Trial_Notes__c='clinical summary testing';
        GRevalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
        GRevalRecord.Compensation_Percentage_P1__c=25;
        GRevalRecord.Compensation_Percentage_P2__c=25;
        GRevalRecord.Compensation_Percentage_P3__c=25;
        GRevalRecord.Compensation_Percentage_P4__c=25;
        GRevalRecord.Cancer_Diagnosis__c = 'Anal Cancer';
        GRevalRecord.ICD_10_Code_s__c = 'C21.0';
        //GRevalRecord.RecordTypeId = cohrecordtypeid1;
        insert GRevalRecord;
        
       // hdevalRecord.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 14, 30, 0);//Date.valueOf('2018-10-05 14:00:00');
       GRevalRecord.NP_Triage_Date_Time__c =Datetime.newInstance(2019, 03, 18, 14, 30, 0);
       GRevalRecList.add(GRevalRecord);
       Update GRevalRecord;
     
       GR_Evaluation_Request__c GRevalRecord1=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
       GRevalRecord1.Status__c='NP Triage';
       GRevalRecord1.Clinical_Trial_Notes__c='clinical summary testing';
       GRevalRecord1.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
       GRevalRecord1.Compensation_Percentage_P1__c=25;
       GRevalRecord1.Compensation_Percentage_P2__c=25;
       GRevalRecord1.Compensation_Percentage_P3__c=25;
       GRevalRecord1.Compensation_Percentage_P4__c=25;
       GRevalRecord1.Cancer_Diagnosis__c = 'Anal Cancer';
       GRevalRecord1.ICD_10_Code_s__c = 'C21.0';
       //GRevalRecord1.RecordTypeId = cohrecordtypeid1;
       insert GRevalRecord1;
       GRevalRecord1.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
       //GRevalRecord1.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
       GRevalRecList.add(GRevalRecord1);
       Update GRevalRecord1;
        
       GR_Evaluation_Request__c GRevalRecord2=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
       GRevalRecord2.Status__c='NP Triage';
       GRevalRecord2.Clinical_Trial_Notes__c='clinical summary testing';
       GRevalRecord2.Type_of_Request__c = 'Test Request Review';
       GRevalRecord2.Compensation_Percentage_P1__c=25;
       GRevalRecord2.Compensation_Percentage_P2__c=25;
       GRevalRecord2.Compensation_Percentage_P3__c=25;
       GRevalRecord2.Compensation_Percentage_P4__c=25;
       GRevalRecord2.Cancer_Diagnosis__c = 'Anal Cancer';
       GRevalRecord2.ICD_10_Code_s__c = 'C21.0';
       //GRevalRecord2.RecordTypeId = cohrecordtypeid1;
       insert GRevalRecord2;
       //hdevalRecord2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 17, 30, 0);
       GRevalRecord2.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
       GRevalRecList.add(GRevalRecord2);
       Update GRevalRecord2;
        
       GR_Evaluation_Request__c GRevalRecord3=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
       GRevalRecord3.Status__c='NP Triage';
       GRevalRecord3.Clinical_Trial_Notes__c='clinical summary testing';
       GRevalRecord3.Type_of_Request__c = 'Test Request Review';
       GRevalRecord3.Compensation_Percentage_P1__c=25;
       GRevalRecord3.Compensation_Percentage_P2__c=25;
       GRevalRecord3.Compensation_Percentage_P3__c=25;
       GRevalRecord3.Compensation_Percentage_P4__c=25;
       GRevalRecord3.Cancer_Diagnosis__c = 'Anal Cancer';
       GRevalRecord3.ICD_10_Code_s__c = 'C21.0';
       //GRevalRecord3.RecordTypeId = cohrecordtypeid1;
       insert GRevalRecord3;
       GRevalRecord3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
       //GRevalRecord3.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
       GRevalRecList.add(GRevalRecord3);
       Update GRevalRecord3;
       
       GR_Evaluation_Request__c GRevalRecord4=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
       GRevalRecord4.Status__c='NP Triage';
       GRevalRecord4.Clinical_Trial_Notes__c='clinical summary testing';
       GRevalRecord4.Type_of_Request__c = 'Enhanced Interpretation Review';
       GRevalRecord4.Compensation_Percentage_P1__c=25;
       GRevalRecord4.Compensation_Percentage_P2__c=25;
       GRevalRecord4.Compensation_Percentage_P3__c=25;
       GRevalRecord4.Compensation_Percentage_P4__c=25;
       GRevalRecord4.Cancer_Diagnosis__c = 'Anal Cancer';
       GRevalRecord4.ICD_10_Code_s__c = 'C21.0';
       //GRevalRecord4.RecordTypeId = cohrecordtypeid1;
       insert GRevalRecord4;
       GRevalRecord4.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 0, 0);
       GRevalRecList.add(GRevalRecord4);
       Update GRevalRecord4;
           
       GR_Evaluation_Request__c GRevalRecord5=new GR_Evaluation_Request__c(GR_Account__c = Amc.ID);
       //GRevalRecord5.Patient_Account__c=ac.id;
       //GRevalRecord5.Reasons_for_Review__c='Excluding the weekends & Holidays testing';
       GRevalRecord5.Clinical_Trial_Notes__c='clinical summary testing';
       GRevalRecord5.Compensation_Percentage_P1__c=25;
       GRevalRecord5.Compensation_Percentage_P2__c=25;
       GRevalRecord5.Compensation_Percentage_P3__c=25;
       GRevalRecord5.Compensation_Percentage_P4__c=25;
       GRevalRecord5.Cancer_Diagnosis__c = 'Anal Cancer';
       GRevalRecord5.ICD_10_Code_s__c = 'C21.0';
       // GRevalRecord5.RecordTypeId = cohrecordtypeid1;
       GRevalRecord5.NP_Triage_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
       GRevalRecord5.Report_Sent_to_GR_Date_Time__c=datetime.newInstance(2019, 11, 29, 7, 0, 0);
       GRevalRecord5.Submitted_for_Review_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
       //GRevalRecord5.RecordTypeId=complexCaseRecTypeId;
       insert GRevalRecord5;
                
    for(GR_Evaluation_Request__c hd:GRevalRecList){
        if(hd.Type_of_Request__c == 'Complex/non-complex Case Reviews (EAR, APO)'){
                if((hd.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
                Else
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
    		}
       else if(hd.Type_of_Request__c == 'Test Request Review'){
                if((hd.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
                Else
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
    		}
        	else if(hd.Type_of_Request__c == 'Enhanced Interpretation Review'){
                if((hd.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
                Else
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2019-03-22'),hd.COH_Review_Due_Date__c);
                }
    		}

				        
          }
        if(GRevalRecord5.NP_Triage_Date_Time__c!=null && GRevalRecord5.Report_Sent_to_GR_Date_Time__c!=null){
                   
                   GRevalRecord5.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(GRevalRecord5.NP_Triage_Date_Time__c.date(),GRevalRecord5.Report_Sent_to_GR_Date_Time__c.date()));
                system.assertEquals(2,GRevalRecord5.Days_B_W_NP_Triage_Report_Sent__c);
               
               }
          
        
               if(GRevalRecord5.Submitted_for_Review_Date_Time__c!=null && GRevalRecord5.Report_Sent_to_GR_Date_Time__c!=null){
                   
                   GRevalRecord5.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(GRevalRecord5.Submitted_for_Review_Date_Time__c.date(),GRevalRecord5.Report_Sent_to_GR_Date_Time__c.date()));
                system.assertEquals(2,GRevalRecord5.Days_Between_Submitted_Report_Sent__c);
               
               }
    test.stopTest();   
    }
}