/*
* This apex controller will update the "All Documents Received" checkbox on CH_Evaluation_Request object whenever the quick action is invoked.
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
public class COH_CM_ActionCall_Controller {
    
     @AuraEnabled
    public static void getCMERequestId(id cmid){
      
        if(cmid != null) {
            CH_Evaluation_Request__c rId = [SELECT id,name,All_Documents_Received__c FROM CH_Evaluation_Request__c where id =:cmid];
            rId.All_Documents_Received__c=true;
            Database.update(rId,false);
        }
        
    }


}