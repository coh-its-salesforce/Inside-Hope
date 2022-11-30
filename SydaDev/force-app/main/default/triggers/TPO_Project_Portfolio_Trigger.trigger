trigger TPO_Project_Portfolio_Trigger on TPO_Project_Portfolio__c (before insert , before update) {
    /*for(TPO_Project_Portfolio__c objTPO: trigger.new){
        if(objTPO.Parent_Request__c != null){           
            try{
                List<TPO_Project_Portfolio__c> childRequests = [Select id, Total_Approved_Capex_Budget_IT__c, Total_Approved_Opex_Budget_IT__c, Total_Approved__c from TPO_Project_Portfolio__c where Parent_Request__c = :objTPO.Parent_Request__c and id <> :objTPO.id];
                Decimal dTotalApprovedCAPEXBudgetForChildRequests = 0;
                Decimal dTotalApprovedOPEXBudgetForChildRequests = 0;
                for(TPO_Project_Portfolio__c objRequest :childRequests)
                    {
                        dTotalApprovedCAPEXBudgetForChildRequests += objRequest.Total_Approved_Capex_Budget_IT__c;
                        dTotalApprovedOPEXBudgetForChildRequests += objRequest.Total_Approved_Opex_Budget_IT__c;
                    }
                
                dTotalApprovedCAPEXBudgetForChildRequests += objTPO.Total_Approved_Capex_Budget_IT__c;
                dTotalApprovedOPEXBudgetForChildRequests += objTPO.Total_Approved_Opex_Budget_IT__c;
                
                TPO_Project_Portfolio__c parentRequest = [Select id, Total_Approved_Capex_Budget_IT__c, Total_Approved_Opex_Budget_IT__c, Total_Approved__c, Total_Remaining_Budget__c from TPO_Project_Portfolio__c where id = :objTPO.Parent_Request__c limit 1];
                if (parentRequest != null)
                {
                    //parentRequest.Total_Remaining_Budget__c = parentRequest.Total_Approved__c - dTotalApprovedBudgetForChildRequests;
                    parentRequest.Total_Remaining_CAPEX_Budget__c = parentRequest.Total_Approved_Capex_Budget_IT__c - dTotalApprovedCAPEXBudgetForChildRequests;
                    parentRequest.Total_Remaining_OPEX_Budget__c = parentRequest.Total_Approved_Opex_Budget_IT__c - dTotalApprovedOPEXBudgetForChildRequests;   
                    update parentRequest;
                }
            }
            catch (Exception e)
            {
                system.debug('There was an error ='+e.getMessage()); 
            }
        }
    }*/
}