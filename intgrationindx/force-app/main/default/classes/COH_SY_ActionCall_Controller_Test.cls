/*
* This controller verifies the functionality of COH_SY_ActionCall_Controller class
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
@istest
public class COH_SY_ActionCall_Controller_Test {
	private static testMethod void SYevaluationRequestTest(){
    Test.startTest();
       // Id recordtypeidcon = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
         
         SY_Evaluation_Request__c SYEvalRecord=new SY_Evaluation_Request__c();
         SYEvalRecord.Status__c='NP Triage';
         SYEvalRecord.Purpose_of_Call__c = 'General information';
         SYEvalRecord.Evidence_1__c ='Test Evidence';
         SYEvalRecord.COH_Physician_1_CLINICAL_RECOMMENDATIONS__c = 'Test Recomendation';
         SYEvalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
         SYEvalRecord.Clinical_Trail_Notes__c='clinical summary testing';
       //  SYEvalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         SYEvalRecord.Compensation_Percentage_P1__c=25;
         SYEvalRecord.Compensation_Percentage_P2__c=25;
         SYEvalRecord.Compensation_Percentage_P3__c=25;
         SYEvalRecord.Compensation_Percentage_P4__c=25;
         //COHevalRecord.RecordTypeId = recordtypeidcon;
        Insert SYEvalRecord;
        
    	COH_SY_ActionCall_Controller.getCOHSYequestId(SYEvalRecord.id); 
    	//COH_QH_ActionCall_controller.getQHERequestIdone(qrcObj.id);   
    	Test.stopTest();
	}
}