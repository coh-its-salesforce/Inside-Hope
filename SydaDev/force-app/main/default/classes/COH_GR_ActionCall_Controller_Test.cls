/*
* This controller verifies the functionality of COH_GR_ActionCall_Controller class
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
public class COH_GR_ActionCall_Controller_Test {
	private static testMethod void GRevaluationRequestTest(){
    Test.startTest();
       // Id recordtypeidcon = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
         
         GR_Evaluation_Request__c GREvalRecord=new GR_Evaluation_Request__c();
         GREvalRecord.Status__c='NP Triage';
         GREvalRecord.Purpose_of_Call__c = 'General information';
         GREvalRecord.Evidence_1__c ='Test Evidence';
         GREvalRecord.COH_Physician_1_CLINICAL_RECOMMENDATIONS__c = 'Test Recomendation';
         GREvalRecord.COH_Physician_1_Next_Steps__c = 'Test Next steps';
         GREvalRecord.Clinical_Trial_Notes__c='clinical summary testing';
       //  GREvalRecord.Type_of_Request__c = 'Complex/non-complex Case Reviews (EAR, APO)';
         GREvalRecord.Compensation_Percentage_P1__c=25;
         GREvalRecord.Compensation_Percentage_P2__c=25;
         GREvalRecord.Compensation_Percentage_P3__c=25;
         GREvalRecord.Compensation_Percentage_P4__c=25;
         GREvalRecord.Cancer_Diagnosis__c = 'Anal Cancer';
         //COHevalRecord.RecordTypeId = recordtypeidcon;
        Insert GREvalRecord;
        
    	COH_GR_ActionCall_Controller.getCOHGRequestId(GREvalRecord.id); 
    	//COH_QH_ActionCall_controller.getQHERequestIdone(qrcObj.id);   
    	Test.stopTest();
	}
}