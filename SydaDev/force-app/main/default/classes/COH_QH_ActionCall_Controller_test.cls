/*
* This controller verifies the functionality of COH_QH_Action_Controller class
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
public class COH_QH_ActionCall_Controller_test {
    
    
    private static testMethod void qhevaluationRequestTest(){
    Test.startTest();
     Evaluation_Request__c qrcObj = new Evaluation_Request__c();
        qrcObj.Reasons_for_Review__c = 'Review Test';
        qrcObj.Clinical_Summary__c = 'Clinicle test';
 		Insert qrcObj;       
        
    COH_QH_ActionCall_controller.getQHERequestId(qrcObj.id); 
    COH_QH_ActionCall_controller.getQHERequestIdone(qrcObj.id);   
    Test.stopTest();
}
}