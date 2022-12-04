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
public class COH_CM_Evaluation_Request_Test {
    // This test method will verify the adding X number of business days to the NP Triage date and it will update the COH Review Due date accordingly.
    private static testMethod void cmevaluationRequestTest(){
    test.startTest();
 
    list<CH_Evaluation_Request__c> cmevalRecList=new list<CH_Evaluation_Request__c>();
    CH_Evaluation_Request__c cmevalRecord=new CH_Evaluation_Request__c();
    cmevalRecord.Status__c='NP triage';
    cmevalRecord.Clinical_Summary__c='clinical summary testing';
    cmevalRecord.Type_of_Request__c= 'Complex Case Review';
     cmevalRecord.Compensation_Percentage1__c=25;
     cmevalRecord.Compensate_Percentage2__c=25;
     cmevalRecord.Compensate_Percentage3__c=25;
     cmevalRecord.Compensate_Percentage4__c=25;
    insert cmevalRecord;
    cmevalRecord.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 14, 30, 0);
    cmevalRecList.add(cmevalRecord);
    Update cmevalRecord;
     
    CH_Evaluation_Request__c cmevalRecord2=new CH_Evaluation_Request__c();
    cmevalRecord2.Status__c='Submitted for Review';
    cmevalRecord2.Type_of_Request__c= 'Test Request Review';
    cmevalRecord2.Clinical_Summary__c='clinical summary testing';
     cmevalRecord2.Compensation_Percentage1__c=25;
     cmevalRecord2.Compensate_Percentage2__c=25;
     cmevalRecord2.Compensate_Percentage3__c=25;
     cmevalRecord2.Compensate_Percentage4__c=25;
    insert cmevalRecord2;
    cmevalRecord2.NP_Triage_Date_Time__c=datetime.newInstance(2018, 11, 26, 17, 30, 0);
    cmevalRecList.add(cmevalRecord2);
    Update cmevalRecord2;
        
     CH_Evaluation_Request__c cmevalRecord3=new CH_Evaluation_Request__c();
    cmevalRecord3.Status__c='Submitted for Review';
    cmevalRecord3.Clinical_Summary__c='clinical summary testing';
    cmevalRecord3.Type_of_Request__c= 'Enhanced (test) Interpretation Review';
     cmevalRecord3.Compensation_Percentage1__c=25;
     cmevalRecord3.Compensate_Percentage2__c=25;
     cmevalRecord3.Compensate_Percentage3__c=25;
     cmevalRecord3.Compensate_Percentage4__c=25;
     //cmevalRecList.add(cmevalRecord3);
     insert cmevalRecord3;
     cmevalRecord3.NP_Triage_Date_Time__c=datetime.newInstance(2019, 3, 21, 10, 0, 0);
     cmevalRecord3.Date_CM_Sends_Additional_Records__c=datetime.newInstance(2019, 3, 21, 10, 0, 0);
     cmevalRecord3.Date_COH_Posts_REO__c=datetime.newInstance(2019, 3, 22, 10, 0, 0);
     Update cmevalRecord3;
        
    
        
    for(CH_Evaluation_Request__c cm:cmevalRecList){
        
                if((cm.NP_Triage_Date_Time__c).hour() < 16)
                {
                    cm.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cm.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2018-11-30'),cm.COH_Review_Due_Date__c);
                }
                Else
                {
                    cm.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cm.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2018-11-30'),cm.COH_Review_Due_Date__c);
                }
         
       
        /*if((cm.NP_Triage_Date_Time__c).hour() < 16)
                {
                    cm.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cm.NP_Triage_Date_Time__c.date(), 3);
                    system.assertEquals(Date.valueOf('2018-11-29'),cm.COH_Review_Due_Date__c);
                }
                Else
                {
                    cm.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cm.NP_Triage_Date_Time__c.date(), 4);
                    system.assertEquals(Date.valueOf('2018-11-30'),cm.COH_Review_Due_Date__c);
                }*/
    }
        if(cmevalRecord3.NP_Triage_Date_Time__c!=null && cmevalRecord3.Date_COH_Posts_REO__c!=null){
                   
                   cmevalRecord3.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(cmevalRecord3.NP_Triage_Date_Time__c.date(),cmevalRecord3.Date_COH_Posts_REO__c.date()));
                system.assertEquals(2,cmevalRecord3.Days_B_W_NP_Triage_Report_Sent__c);
               
               }
          
               if(cmevalRecord3.Date_CM_Sends_Additional_Records__c!=null && cmevalRecord3.Date_COH_Posts_REO__c!=null){
                   
                   cmevalRecord3.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(cmevalRecord3.Date_CM_Sends_Additional_Records__c.date(),cmevalRecord3.Date_COH_Posts_REO__c.date()));
                system.assertEquals(2,cmevalRecord3.Days_Between_Submitted_Report_Sent__c);
               
               }
    
    test.stopTest();   
    }
}