/*
* This controller verifies the functionality of COH_HD_Evaluation_Request trigger.
* 
* Balaji Rao
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/


@isTest
public class COH_HD_Evaluation_Request_Test {

     // This test method will verify the adding X number of business days to the NP Triage date and it will update the COH Review Due date accordingly.
    private static testMethod void hdevaluationRequestTest(){
    test.startTest();
        list<HD_Evaluation_Request__c> hdevalRecList=new list<HD_Evaluation_Request__c>();
     
        
        
         HD_Evaluation_Request__c hdevalRecord=new HD_Evaluation_Request__c();
         hdevalRecord.Request_Type__c = 'In Person Evaluation';
         hdevalRecord.Status__c='NP Triage';
         hdevalRecord.Oncology_Service__c = 'APO';
         hdevalRecord.Evidence_1__c ='Test Evidence';
         hdevalRecord.COH_Physician_1_CLINICAL_RECOMMENDATION__c = 'Test Recomendation';
         hdevalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
         hdevalRecord.Clinical_Summary__c='clinical summary testing';
         hdevalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         hdevalRecord.Compensation_Percentage_P1__c=25;
         hdevalRecord.Compensation_Percentage_P2__c=25;
         hdevalRecord.Compensation_Percentage_P3__c=25;
         hdevalRecord.Compensation_Percentage_P4__c=25;
         
    insert hdevalRecord;
   // hdevalRecord.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 14, 30, 0);//Date.valueOf('2018-10-05 14:00:00');
        hdevalRecord.NP_Triage_Date_Time__c =Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    hdevalRecList.add(hdevalRecord);
    Update hdevalRecord;
     
         HD_Evaluation_Request__c hdevalRecordobj=new HD_Evaluation_Request__c();
         hdevalRecordobj.Status__c='NP Triage';
         hdevalRecordobj.Clinical_Summary__c='clinical summary testing';
         hdevalRecordobj.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         hdevalRecordobj.Compensation_Percentage_P1__c=25;
         hdevalRecordobj.Compensation_Percentage_P2__c=25;
         hdevalRecordobj.Compensation_Percentage_P3__c=25;
         hdevalRecordobj.Compensation_Percentage_P4__c=25;
    insert hdevalRecordobj;
    hdevalRecordobj.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
    //hdevalRecordobj.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    hdevalRecList.add(hdevalRecordobj);
    Update hdevalRecordobj;
        
    	 HD_Evaluation_Request__c hdevalRecord2=new HD_Evaluation_Request__c();
         hdevalRecord2.Status__c='NP Triage';
         hdevalRecord2.Clinical_Summary__c='clinical summary testing';
         hdevalRecord2.Type_of_Request__c = 'Test Request Review';
         hdevalRecord2.Compensation_Percentage_P1__c=25;
         hdevalRecord2.Compensation_Percentage_P2__c=25;
         hdevalRecord2.Compensation_Percentage_P3__c=25;
         hdevalRecord2.Compensation_Percentage_P4__c=25;
    insert hdevalRecord2;
    //hdevalRecord2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 17, 30, 0);
    hdevalRecord2.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    hdevalRecList.add(hdevalRecord2);
    Update hdevalRecord2;
        
        //
        HD_Evaluation_Request__c hdevalRecord01=new HD_Evaluation_Request__c();
         hdevalRecord01.Status__c='NP Triage';
         hdevalRecord01.Clinical_Summary__c='clinical summary testing';
         hdevalRecord01.Type_of_Request__c = 'Test Request Review';
         hdevalRecord01.Compensation_Percentage_P1__c=25;
         hdevalRecord01.Compensation_Percentage_P2__c=25;
         hdevalRecord01.Compensation_Percentage_P3__c=25;
         hdevalRecord01.Compensation_Percentage_P4__c=25;
    insert hdevalRecord01;
    hdevalRecord01.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
    //hdevalRecord01.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    hdevalRecList.add(hdevalRecord01);
    Update hdevalRecord01;
       
         HD_Evaluation_Request__c hdevalRecord02=new HD_Evaluation_Request__c();
         hdevalRecord02.Status__c='NP Triage';
         hdevalRecord02.Clinical_Summary__c='clinical summary testing';
         hdevalRecord02.Type_of_Request__c = 'Enhanced (test) Interpretation Review';
         hdevalRecord02.Compensation_Percentage_P1__c=25;
         hdevalRecord02.Compensation_Percentage_P2__c=25;
         hdevalRecord02.Compensation_Percentage_P3__c=25;
         hdevalRecord02.Compensation_Percentage_P4__c=25;
    insert hdevalRecord02;
    hdevalRecord02.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 0, 0);
    hdevalRecList.add(hdevalRecord02);
    Update hdevalRecord02;
        
        
        HD_Evaluation_Request__c hdevalRecord3=new HD_Evaluation_Request__c();
  
    //hdevalRecord3.Patient_Account__c=ac.id;
    //hdevalRecord3.Reasons_for_Review__c='Excluding the weekends & Holidays testing';
    hdevalRecord3.Clinical_Summary__c='clinical summary testing';
    hdevalRecord3.Compensation_Percentage_P1__c=25;
    hdevalRecord3.Compensation_Percentage_P2__c=25;
    hdevalRecord3.Compensation_Percentage_P3__c=25;
    hdevalRecord3.Compensation_Percentage_P4__c=25;
    hdevalRecord3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    hdevalRecord3.Report_Sent_to_CM_Date_Time__c=datetime.newInstance(2019, 11, 29, 7, 0, 0);
    hdevalRecord3.Submitted_for_Review_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    //hdevalRecord3.RecordTypeId=complexCaseRecTypeId;
    insert hdevalRecord3;
        
        
        
    for(HD_Evaluation_Request__c hd:hdevalRecList){
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
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 2);
                    system.assertEquals(Date.valueOf('2019-03-20'),hd.COH_Review_Due_Date__c);
                }
                Else
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 2);
                    system.assertEquals(Date.valueOf('2019-03-20'),hd.COH_Review_Due_Date__c);
                }
    		}
        	else if(hd.Type_of_Request__c == 'Enhanced (test) Interpretation Review'){
                if((hd.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 2);
                    system.assertEquals(Date.valueOf('2019-03-20'),hd.COH_Review_Due_Date__c);
                }
                Else
                {
                    hd.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hd.NP_Triage_Date_Time__c.date(), 2);
                    system.assertEquals(Date.valueOf('2019-03-20'),hd.COH_Review_Due_Date__c);
                }
    		}

				        
          }
        if(hdevalRecord3.NP_Triage_Date_Time__c!=null && hdevalRecord3.Report_Sent_to_CM_Date_Time__c!=null){
                   
                   hdevalRecord3.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRecord3.NP_Triage_Date_Time__c.date(),hdevalRecord3.Report_Sent_to_CM_Date_Time__c.date()));
                system.assertEquals(2,hdevalRecord3.Days_B_W_NP_Triage_Report_Sent__c);
               
               }
          
        
               if(hdevalRecord3.Submitted_for_Review_Date_Time__c!=null && hdevalRecord3.Report_Sent_to_CM_Date_Time__c!=null){
                   
                   hdevalRecord3.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRecord3.Submitted_for_Review_Date_Time__c.date(),hdevalRecord3.Report_Sent_to_CM_Date_Time__c.date()));
                system.assertEquals(2,hdevalRecord3.Days_Between_Submitted_Report_Sent__c);
               
               }
    test.stopTest();   
    }
}