/*
* This apex controller will update the "All Documents Received" checkbox on PR_Evaluation_Request object whenever the quick action is invoked.
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
public class COH_PR_ActionCall_Controller {
@AuraEnabled
    public static void getCOHPRequestId(id coherid){
      
        if(coherid != null) {
            PR_Evaluation_Request__c rId = [SELECT id,name,All_Documents_Received__c FROM PR_Evaluation_Request__c where id =:coherid];
            system.debug(rid.All_Documents_Received__c);
            rId.All_Documents_Received__c=true;
            
            rId.All_Documents_Received_Date_Time__c = System.now();
            Database.update(rId,false);//false,//true
        }
        
    }
}