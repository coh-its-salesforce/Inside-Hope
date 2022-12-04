/*
* This controller verifies the functionality of PR_Evaluation_Request class
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
public class COH_PR_Evaluation_Request_test {
// This test method will verify the adding X number of business days to the NP Triage date and it will update the COH Review Due date accordingly.
    private static testMethod void COHevaluationRequestTest(){
    test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plymouth Rock Patient').getRecordTypeId();
        system.debug('Record Type Name:'+cohrecordtypeid);
        //Id cohrecordtypeid1 = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
       
        account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.RecordTypeId = cohrecordtypeid;
        insert Amc;
        
        list<PR_Evaluation_Request__c> COHevalRecList=new list<PR_Evaluation_Request__c>();
        PR_Evaluation_Request__c COHevalRecord=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
         //hdevalRecord.Request_Type__c = 'In Person Evaluation';
         COHevalRecord.Status__c='NP Triage';
         //COHevalRecord.Oncology_Service__c = 'APO';
         COHevalRecord.Evidence_1__c ='Test Evidence';
         COHevalRecord.COH_Physician_1_CLINICAL_RECOMMENDATIONS__c = 'Test Recomendation';
         COHevalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
         COHevalRecord.Clinical_Trail_Notes__c='clinical summary testing';
         COHevalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         COHevalRecord.Compensation_Percentage_P1__c=25;
         COHevalRecord.Compensation_Percentage_P2__c=25;
         COHevalRecord.Compensation_Percentage_P3__c=25;
         COHevalRecord.Compensation_Percentage_P4__c=25;
         //COHevalRecord.RecordTypeId = cohrecordtypeid1;
         
    insert COHevalRecord;
   // hdevalRecord.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 14, 30, 0);//Date.valueOf('2018-10-05 14:00:00');
        COHevalRecord.NP_Triage_Date_Time__c =Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    COHevalRecList.add(COHevalRecord);
    Update COHevalRecord;
     
         PR_Evaluation_Request__c COHevalRecordobj=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
         COHevalRecordobj.Status__c='NP Triage';
         COHevalRecordobj.Clinical_Trail_Notes__c='clinical summary testing';
         COHevalRecordobj.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         COHevalRecordobj.Compensation_Percentage_P1__c=25;
         COHevalRecordobj.Compensation_Percentage_P2__c=25;
         COHevalRecordobj.Compensation_Percentage_P3__c=25;
         COHevalRecordobj.Compensation_Percentage_P4__c=25;
        //COHevalRecordobj.RecordTypeId = cohrecordtypeid1;
        insert COHevalRecordobj;
    COHevalRecordobj.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
    //COHevalRecordobj.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    COHevalRecList.add(COHevalRecordobj);
    Update COHevalRecordobj;
        
    	 PR_Evaluation_Request__c COHevalRecord2=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
         COHevalRecord2.Status__c='NP Triage';
         COHevalRecord2.Clinical_Trail_Notes__c='clinical summary testing';
         COHevalRecord2.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         COHevalRecord2.Compensation_Percentage_P1__c=25;
         COHevalRecord2.Compensation_Percentage_P2__c=25;
         COHevalRecord2.Compensation_Percentage_P3__c=25;
         COHevalRecord2.Compensation_Percentage_P4__c=25;
        //COHevalRecord2.RecordTypeId = cohrecordtypeid1;
    insert COHevalRecord2;
    //hdevalRecord2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 17, 30, 0);
    COHevalRecord2.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    COHevalRecList.add(COHevalRecord2);
    Update COHevalRecord2;
        
        //
        PR_Evaluation_Request__c hdevalRecord01=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
         hdevalRecord01.Status__c='NP Triage';
         hdevalRecord01.Clinical_Trail_Notes__c='clinical summary testing';
         hdevalRecord01.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         hdevalRecord01.Compensation_Percentage_P1__c=25;
         hdevalRecord01.Compensation_Percentage_P2__c=25;
         hdevalRecord01.Compensation_Percentage_P3__c=25;
         hdevalRecord01.Compensation_Percentage_P4__c=25;
        //hdevalRecord01.RecordTypeId = cohrecordtypeid1;
    insert hdevalRecord01;
    hdevalRecord01.NP_Triage_Date_Time__c=datetime.newInstance(2019, 03, 18, 17, 30, 0);
    //hdevalRecord01.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 30, 0);
    COHevalRecList.add(hdevalRecord01);
    Update hdevalRecord01;
       
         PR_Evaluation_Request__c hdevalRecord02=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
         hdevalRecord02.Status__c='NP Triage';
         hdevalRecord02.Clinical_Trail_Notes__c='clinical summary testing';
         hdevalRecord02.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         hdevalRecord02.Compensation_Percentage_P1__c=25;
         hdevalRecord02.Compensation_Percentage_P2__c=25;
         hdevalRecord02.Compensation_Percentage_P3__c=25;
         hdevalRecord02.Compensation_Percentage_P4__c=25;
        //hdevalRecord02.RecordTypeId = cohrecordtypeid1;
    insert hdevalRecord02;
    hdevalRecord02.NP_Triage_Date_Time__c=Datetime.newInstance(2019, 03, 18, 14, 0, 0);
    COHevalRecList.add(hdevalRecord02);
    Update hdevalRecord02;
        
        
        PR_Evaluation_Request__c hdevalRecord3=new PR_Evaluation_Request__c(Account_Name__c = Amc.ID);
  
    //hdevalRecord3.Patient_Account__c=ac.id;
    //hdevalRecord3.Reasons_for_Review__c='Excluding the weekends & Holidays testing';
    hdevalRecord3.Clinical_Trail_Notes__c='clinical summary testing';
    hdevalRecord3.Compensation_Percentage_P1__c=25;
    hdevalRecord3.Compensation_Percentage_P2__c=25;
    hdevalRecord3.Compensation_Percentage_P3__c=25;
    hdevalRecord3.Compensation_Percentage_P4__c=25;
   // hdevalRecord3.RecordTypeId = cohrecordtypeid1;
    hdevalRecord3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    hdevalRecord3.Report_Sent_Date_Time__c=datetime.newInstance(2019, 11, 29, 7, 0, 0);
    hdevalRecord3.Submitted_for_Review_Date_Time__c=datetime.newInstance(2019, 11, 27, 10, 0, 0);
    //hdevalRecord3.RecordTypeId=complexCaseRecTypeId;
    insert hdevalRecord3;
        
        
        
    for(PR_Evaluation_Request__c hd:COHevalRecList){
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
    /*   else if(hd.Type_of_Request__c == 'Test Request Review'){
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
        	else if(hd.Type_of_Request__c == 'Enhanced Interpretation Review'){
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
    		} */

				        
          }
        if(hdevalRecord3.NP_Triage_Date_Time__c!=null && hdevalRecord3.Report_Sent_Date_Time__c!=null){
                   
                   hdevalRecord3.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRecord3.NP_Triage_Date_Time__c.date(),hdevalRecord3.Report_Sent_Date_Time__c.date()));
                system.assertEquals(2,hdevalRecord3.Days_B_W_NP_Triage_Report_Sent__c);
               
               }
          
        
               if(hdevalRecord3.Submitted_for_Review_Date_Time__c!=null && hdevalRecord3.Report_Sent_Date_Time__c!=null){
                   
                   hdevalRecord3.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRecord3.Submitted_for_Review_Date_Time__c.date(),hdevalRecord3.Report_Sent_Date_Time__c.date()));
                system.assertEquals(2,hdevalRecord3.Days_Between_Submitted_Report_Sent__c);
               
               }
    test.stopTest();   
    }

}