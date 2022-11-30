/*
* This apex controller will update the "All Documents Received" checkbox on SY_Evaluation_Request object whenever the quick action is invoked.
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
public class COH_GR_ActionCall_Controller {
@AuraEnabled
    public static void getCOHGRequestId(id coherid){
      
        if(coherid != null) {
            GR_Evaluation_Request__c rId = [SELECT id,name,All_Documents_Received__c FROM GR_Evaluation_Request__c where id =:coherid];
            system.debug(rid.All_Documents_Received__c);
            rId.All_Documents_Received__c=true;
            
            rId.All_Documents_Received_Date_Time__c = System.now();
            Database.update(rId,false);//false,//true
        }
        
    }
}