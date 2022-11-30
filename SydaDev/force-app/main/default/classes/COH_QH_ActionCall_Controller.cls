/*
* This apex controller will update the "All Documents Received" checkbox on QH_Evaluation_Request object whenever the quick action is invoked.
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
public class COH_QH_ActionCall_Controller {
    
     @AuraEnabled
    public static void getQHERequestId(id qhid){
      
        if(qhid != null) {
            Evaluation_Request__c rId = [SELECT id,name,All_Documents_Received__c FROM Evaluation_Request__c where id =:qhid];
            rId.All_Documents_Received__c=true;
            Database.update(rId,false);
        }
        
    }
	@AuraEnabled
    public static void getQHERequestIdone(id qhid1){
      
        if(qhid1 != null) {
            Evaluation_Request__c erObj = [SELECT id,name,Favorite__c FROM Evaluation_Request__c where id =:qhid1];
            erObj.Favorite__c=true;
            Database.update(erObj,false);
        }
        
    }

}