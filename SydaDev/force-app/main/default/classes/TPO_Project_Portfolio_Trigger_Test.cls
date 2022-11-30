/*
* This test class verifies the functionality of the TPO_Project_Portfolio_Trigger.  
* 
* Abhishek Kumar
* City of Hope
* Copyright (c) 2017
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
@isTest
public class TPO_Project_Portfolio_Trigger_Test {
    private static final String MASTER_TITLE = 'Lightning Migration';
    private static final String CHILD_TITLE = 'Readiness Checklist';
    
    /* 
* Verifies Total Remaining Hours.
* 
* NOTE:  The trigger is NOT properly bulkified, I will get back to this, when the changes are approved.
* 
*/
    /*private static testMethod void updateTotalRemainingHours() {        
        test.startTest();
        TPO_Project_Portfolio__c objMasterRequest = new TPO_Project_Portfolio__c();
        objMasterRequest.Request_Name__c = MASTER_TITLE;
        objMasterRequest.Approved_CAPEX__c = 1000;        
        Database.insert(objMasterRequest);
        
        TPO_Project_Portfolio__c objMasterRequestFromDb = [select Id, name from TPO_Project_Portfolio__c where Request_Name__c = :MASTER_TITLE limit 1];
        
        if(objMasterRequestFromDb != null)
        {
            TPO_Project_Portfolio__c objChildRequest = new TPO_Project_Portfolio__c();
            objChildRequest.Request_Name__c = CHILD_TITLE;
            objChildRequest.Parent_Request__c = objMasterRequestFromDb.Id;
            objChildRequest.Approved_CAPEX__c = 500;  
            Database.insert(objChildRequest);
            List<TPO_Project_Portfolio__c> lsChildRequestFromDb = [select Id, name, Total_Approved_Capex_Budget_IT__c, Total_Approved_Opex_Budget_IT__c, Total_Approved__c from TPO_Project_Portfolio__c where Parent_Request__c = :objMasterRequestFromDb.Id];
            Decimal dTotalApprovedCAPEXBudgetForChildRequests = 0;
            Decimal dTotalApprovedOPEXBudgetForChildRequests = 0;
            for(TPO_Project_Portfolio__c objRequest :lsChildRequestFromDb)
            {
                dTotalApprovedCAPEXBudgetForChildRequests += objRequest.Total_Approved_Capex_Budget_IT__c;
                dTotalApprovedOPEXBudgetForChildRequests += objRequest.Total_Approved_Opex_Budget_IT__c;
            }
            objMasterRequestFromDb = [select Id, name, Total_Remaining_CAPEX_Budget__c, Total_Remaining_OPEX_Budget__c, Total_Approved_Capex_Budget_IT__c, Total_Approved_Opex_Budget_IT__c, Total_Approved__c, Total_Remaining_Budget__c from TPO_Project_Portfolio__c where Request_Name__c = :MASTER_TITLE limit 1];
            if(objMasterRequestFromDb != null)
            {
                System.assertEquals(objMasterRequestFromDb.Total_Remaining_CAPEX_Budget__c, (objMasterRequestFromDb.Total_Approved_Capex_Budget_IT__c - dTotalApprovedCAPEXBudgetForChildRequests));  
                System.assertEquals(objMasterRequestFromDb.Total_Remaining_OPEX_Budget__c, (objMasterRequestFromDb.Total_Approved_Opex_Budget_IT__c - dTotalApprovedOPEXBudgetForChildRequests));  
            }
        }
        test.stopTest();
    }*/      
}