/*
* This controller verifies the functionality of COH_PR_ActionCall_Controller class
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
@istest
public class COH_PR_Action_Call_Controller_test {
private static testMethod void PRevaluationRequestTest(){
    Test.startTest();
       // Id recordtypeidcon = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
         
         PR_Evaluation_Request__c COHevalRecord=new PR_Evaluation_Request__c();
         //hdevalRecord.Request_Type__c = 'In Person Evaluation';
         COHevalRecord.Status__c='NP Triage';
         COHevalRecord.Purpose_of_Call__c = 'General information';
         //COHevalRecord.Cancer_Diagnosis__c = 'Anal Cancer';
         COHevalRecord.Evidence_1__c ='Test Evidence';
         COHevalRecord.COH_Physician_1_CLINICAL_RECOMMENDATIONS__c = 'Test Recomendation';
         COHevalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
         COHevalRecord.Clinical_Trail_Notes__c='clinical summary testing';
         //COHevalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         COHevalRecord.Compensation_Percentage_P1__c=25;
         COHevalRecord.Compensation_Percentage_P2__c=25;
         COHevalRecord.Compensation_Percentage_P3__c=25;
         COHevalRecord.Compensation_Percentage_P4__c=25;
         //COHevalRecord.RecordTypeId = recordtypeidcon;
        Insert COHevalRecord;
        
    COH_PR_ActionCall_Controller.getCOHPRequestId(COHevalRecord.id); 
    //COH_QH_ActionCall_controller.getQHERequestIdone(qrcObj.id);   
    Test.stopTest();
}
}