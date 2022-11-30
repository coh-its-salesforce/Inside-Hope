/*
* This apex controller will update the "All Documents Received" checkbox on AM_Evaluation_Request object whenever the quick action is invoked.
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
public class COH_AM_Action_Call_Controller {
    
     @AuraEnabled
    public static void getCMERequestId(id amid){
      

        if(amid != null) {
            Id APORecordTypeId = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
            AM_Evaluation_Request__c rId = [SELECT id,name,All_Documents_Received__c FROM AM_Evaluation_Request__c where id =:amid];
            rId.All_Documents_Received__c=true;
            rId.All_Documents_Received_Date_Time__c=system.now();
            rid.recordtypeid=APORecordTypeId;
            Database.update(rId,false);
        }
        
    }


}