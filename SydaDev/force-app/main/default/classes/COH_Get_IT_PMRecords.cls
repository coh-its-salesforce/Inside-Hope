/*
* This class will query the IT PM Lifecycle, IT Project Intake Records and it uses over the IT PM Lifecycle record page Tabs.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2020
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
public class COH_Get_IT_PMRecords {
    @AuraEnabled
    public static IT_Portfolio_Management__c getSummaryRecords(string recordId) {
        IT_Portfolio_Management__c ITPMRecs = [SELECT Id,
                ITS_Intake_Request__r.ConnectHope_Sub_Apps__c,
                ITS_Intake_Request__r.Financial_Key__c,
                ITS_Intake_Request__r.Fiscal_Year_Start__c,
                ITS_Intake_Request__r.Impacted_Applications__c,
                ITS_Intake_Request__r.Project_Short_Description__c,                
                ITS_Intake_Request__r.Revised_Capex_Budget_Year_1__c, 
                ITS_Intake_Request__r.Revised_Capex_Budget_Yr_2__c,    
                ITS_Intake_Request__r.Revised_Capex_Budget_Yr_3__c,                                           
                ITS_Intake_Request__r.Revised_Contingency_Yr_1_Capex__c,
                ITS_Intake_Request__r.Revised_Hardware_Cost_Yr_1_Capex__c,
                ITS_Intake_Request__r.Revised_Internal_Cost_Yr_1_Capex__c,
                ITS_Intake_Request__r.Revised_Opex_Budget_Year_1__c,
                ITS_Intake_Request__r.Revised_Opex_Budget_Yr_2__c,     
                ITS_Intake_Request__r.Revised_Opex_Budget_Yr_3__c,                           
                ITS_Intake_Request__r.Revised_Prof_Svcs_Cost_Yr_1_Capex__c,
                ITS_Intake_Request__r.Revised_Software_Cost_Yr_1_Capex__c,
                ITS_Intake_Request__r.Revised_Total_Hrs_Multi_Year__c,
                ITS_Intake_Request__r.Short_Description_of_Request_Confirmed__c,
                ITS_Intake_Request__r.Technical_Requirements__c,                               
                ITS_Intake_Request__r.Total_Approved_Revised_Capex_Budget__c,
                ITS_Intake_Request__r.Total_Approved_Revised_Opex_Budget__c,
                Stages__c,
  				Approvals__c,                                
                Approved_Hours_C__c,
                Authorized_Approver_Comments_Instruction__c,                
                Benefits__c,
                BMC_Change_Request__c,
                CR_Name__c,
                Committed_External_Cost_Yr_2_Capex__c,                
                Committed_External_Cost_Yr_3_Capex__c,
                Committed_Hardware_Cost_Yr_1_Capex__c,
                Committed_Hardware_Cost_Yr_2_Capex__c,                
                Committed_Hardware_Cost_Yr_3_Capex__c,
                Committed_Open_POs_B__c,                
                Committed_Prof_Svcs_Cost_Yr_1_Capex__c,                
                Committed_Software_Cost_Yr_1_Capex__c,
                Committed_Software_Cost_Yr_2_Capex__c,                
                Committed_Software_Cost_Yr_3_Capex__c,
                Current_State_Revised__c,                               
                Executive_Summary__c,
                Hours_Burned__c,                               
                Hours_Burned_D__c,
                Hours_Burned_rollup__c,
                Impacted_Applications__c,
                In_Scope_Revised__c,                
                Incurred_Cost_YTD__c,
                Internal_Actual_Cost_YTD_Yr_1_Capex__c,
                Internal_Actual_Cost_YTD_Yr_2_Capex__c,                
                Internal_Actual_Cost_YTD_Yr_3_Capex__c,                
                Internal_Cost_Yr_1_Capex_Variance__c,                
                Internal_Labor_YTD__c,                
                Launch_Console__c,
                Other_Impacted_Applications__c,                
                Out_of_Scope_Revised__c,
                Primary_Application__c,                
                Problem_Statement__c,
                Project_Status__c,
                Remaining_Capex_Budget_AB__c,
                Remaining_Contingency_Yr_1_Capex__c,
                Remaining_Contingency_Yr_1_Capex_Cur__c,                               
                Remaining_Hardware_Cost_Yr_1_Capex__c,
                Remaining_Hours_CD__c,                
                Remaining_Prof_Svcs_Cost_Yr_1_Capex__c,
                Remaining_Software_Cost_Yr_1_Capex__c,
                Technical_Requirements__c,
                Technical_Specifications__c, 
                Total_Committed_Opex_Open_POs_F__c,
                Total_Remaining_Opex_Budget_E_F__c,
                Total_Committed_Cost_Yr_1_Capex__c,
                Total_Committed_Cost_Yr_1_Opex__c,
                Total_Committed_Cost_Yr_2_Capex__c,
                Total_Committed_Cost_Yr_2_Opex__c,                
                Total_Committed_Cost_Yr_3_Capex__c,                
                Total_Committed_Cost_Yr_3_Opex__c,
                Total_Remaining_Budget_Yr_1_Capex__c,
                Total_Remaining_Budget_Yr_1_Opex__c,                               
                Total_Remaining_Budget_Yr_2_Capex__c,
                Total_Remaining_Budget_Yr_2_Opex__c,                
                Total_Remaining_Budget_Yr_3_Capex__c,
                Total_Remaining_Budget_Yr_3_Opex__c
                from IT_Portfolio_Management__c where id=: recordId limit 1];
        return ITPMRecs;
        
    } 
    @AuraEnabled
    public static boolean getDetails(){
        System.debug('getDetails---func');
        boolean tpoAdmin=false;
        User currUser=[select id,profile.name from user where id=:UserInfo.getUserId()];
        System.debug('currUser---->'+currUser.profile.name);
        if(currUser.profile.name=='TPO Admin'|| currUser.profile.name == 'Dev Admin in Prod' || currUser.profile.name == 'System Administrator'){
            tpoAdmin=true;
        }
     return tpoAdmin;
    }

    @AuraEnabled (cacheable = true)
    public static Id getITPMLifecycleId(Id itProjectIntakeId){
        Id key = itProjectIntakeId;
        IT_Portfolio_Management__c itpmRec = [select Id from IT_Portfolio_Management__c WHERE ITS_Intake_Request__c =: key limit 1];
        return itpmRec.Id;
    }
}