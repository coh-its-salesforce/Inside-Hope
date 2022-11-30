/***********************************************************************
 	This class will query the IT Project Intake record form its child object IT PM Lifecycle and return the related data and it uses over the IT PM Lifecycle record page Tabs.
 
	Created By: Saidaiah Surisetti
    Created Date:8/Aug/2019.

	City of Hope
	Copyright (c) 2019
 
	No portion of this code may be copied, transferred, or transmitted
	in any form (written, electronic, or otherwise) without the prior
	written consent from the City of Hope.
************************************************************************/
public class ITPM_LifeCycle_Tabs_Controller {
    
@AuraEnabled
    public static IT_Portfolio_Management__c getITProjectIntake(String recordId){
        IT_Portfolio_Management__c ITPMObj=[select ITS_Intake_Request__c,ITS_Intake_Request__r.Name,ITS_Intake_Request__r.id,ITS_Intake_Request__r.Request_Name__c,ITS_Intake_Request__r.Project_Short_Description__c,ITS_Intake_Request__r.Executive_Summary__c,
                                            ITS_Intake_Request__r.Budget_Category__c, ITS_Intake_Request__r.Master_Project__c,
                                            ITS_Intake_Request__r.Primary_ISC__c,ITS_Intake_Request__r.Business_Sponsor__c,ITS_Intake_Request__r.Business_Sponsor__r.Name,
                                            ITS_Intake_Request__r.Business_Owner__r.Name,ITS_Intake_Request__r.Business_Owner__c,ITS_Intake_Request__r.Business_Owner__r.id,ITS_Intake_Request__r.IT_Sponsor__c,
                                            ITS_Intake_Request__r.IT_Owner__c,ITS_Intake_Request__r.Fiscal_Year_Start__c,
                                            ITS_Intake_Request__r.Total_Approved_Capex_Budget_IT__c,ITS_Intake_Request__r.Total_Approved_Opex_Budget_IT__c,
                                            ITS_Intake_Request__r.Total_Combined_Internal_Labor_Hours__c, ITS_Intake_Request__r.Total_Combined_External_Labor_Hours__c,
                                            ITS_Intake_Request__r.Request_Type__c,ITS_Intake_Request__r.Parent_Request__c,ITS_Intake_Request__r.Program__c,
                                            ITS_Intake_Request__r.Investment_Category__c,
                                            ITS_Intake_Request__r.Funding_Type__c,ITS_Intake_Request__r.Multi_Year_Project__c,
                                            ITS_Intake_Request__r.CarryOver__c,ITS_Intake_Request__r.ConnectHope_Apps__c,
                                            ITS_Intake_Request__r.IT_Functional_Sub_Area__c,
                                            ITS_Intake_Request__r.IT_Functional_Area__c,ITS_Intake_Request__r.Short_Term_Benefits__c,
                                            ITS_Intake_Request__r.Project_Background__c,ITS_Intake_Request__r.ROI__c,
                                            ITS_Intake_Request__r.Describe_goals_and_objectives__c,ITS_Intake_Request__r.Impacts_Risks_if_not_approved__c,
                                            ITS_Intake_Request__r.Scope_Considerations__c,ITS_Intake_Request__r.Key_Assumptions__c,
                                            ITS_Intake_Request__r.Key_Dependencies__c,ITS_Intake_Request__r.Check_if_project_is_approved__c,
                                            ITS_Intake_Request__r.Approved_External_ITS_Hours__c,ITS_Intake_Request__r.Approved_External_IT_Labor_Hours_Year1C__c,
                                            ITS_Intake_Request__r.Approved_Total_Hours__c,ITS_Intake_Request__r.Approved_Internal_IT_Labor_Hours_Year_1__c,
                                            ITS_Intake_Request__r.Approved_Pro_Services_Cost_Yr1_Capex__c,ITS_Intake_Request__r.Approved_Consulting_Cost_Year_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_Hardware_Cost_Year_1_Capex__c,ITS_Intake_Request__r.Approved_Hardware_Maint_Cost_Yr1_Opex__c,
                                            ITS_Intake_Request__r.Approved_Software_License_Cost_Yr1_Capex__c,ITS_Intake_Request__r.Approved_Software_Maint_Cost_Yr1_Opex__c,
                                            ITS_Intake_Request__r.Approved_SaaS_Rmt_Host_Cost_Yr1_Opex__c,ITS_Intake_Request__r.Approved_Contingency_Year_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_Contingency_Year_1_Opex__c,ITS_Intake_Request__r.Approved_Capex_Budget_Year_1__c,
                                            ITS_Intake_Request__r.Approved_Opex_Budget_Year_1__c,ITS_Intake_Request__r.Approved_CAPEX_Year_2__c,
                                            ITS_Intake_Request__r.Approved_CAPEX_Year_3__c,ITS_Intake_Request__r.Approved_OPEX_Year_2__c,
                                            ITS_Intake_Request__r.Approved_OPEX_Year_3__c,ITS_Intake_Request__r.Total_Approved__c,
                                            ITS_Intake_Request__r.Approved_Managed_Svcs_Hrs_Yr_1_Capex__c,ITS_Intake_Request__r.Approved_Managed_Svcs_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_Revised_Mg_Svc_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_Revised_Mg_Svc_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_Internal_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_Total_Hrs_Yr_1__c,
                                            ITS_Intake_Request__r.Approved_Total_Hrs_Yr_2__c,
                                            ITS_Intake_Request__r.Approved_Total_Hrs_Yr_3__c,
                                            ITS_Intake_Request__r.Approved_Total_Hrs_Multi_Year__c,
                                            ITS_Intake_Request__r.Revised_Total_Hrs_Yr_1__c,
                                            ITS_Intake_Request__r.Revised_Total_Hrs_Yr_2__c,
                                            ITS_Intake_Request__r.Revised_Total_Hrs_Yr_3__c,
                                            ITS_Intake_Request__r.Revised_Total_Hrs_Multi_Year__c,
                                            ITS_Intake_Request__r.Revised_Internal_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Internal_IT_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Internal_IT_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_External_IT_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_External_IT_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_Prof_Svcs_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Consulting_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_Hardware_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Hardware_Mtc_Cost_Yr_1__c,
                                            ITS_Intake_Request__r.Revised_Software_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Software_Mtc_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_SaaS_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_Contingency_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Revised_Contingency_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Revised_Capex_Budget_Year_1__c,
                                            ITS_Intake_Request__r.Revised_Opex_Budget_Year_1__c,
                                            ITS_Intake_Request__r.Revised_Capex_Budget_Yr_2__c,
                                            ITS_Intake_Request__r.Revised_Opex_Budget_Yr_2__c,
                                            ITS_Intake_Request__r.Revised_Capex_Budget_Yr_3__c,
                                            ITS_Intake_Request__r.Revised_Opex_Budget_Yr_3__c,
                                            ITS_Intake_Request__r.Total_Approved_Revised_Capex_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_Revised_Opex_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_Revised_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_Revised_Internal_Hrs__c,
                                            ITS_Intake_Request__r.Total_Approved_Revised_External_Hrs__c,
                                            ITS_Intake_Request__r.Approved_CR_Internal_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Managed_Svc_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Managed_Svcs_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Internal_IT_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_External_IT_Hrs_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_External_IT_Hrs_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Prof_Svcs_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Consulting_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Hardware_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Hardware_Mtc_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Software_Cost_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Software_Mtc_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_SaaS_Cost_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Contingency_Yr_1_Capex__c,
                                            ITS_Intake_Request__r.Approved_CR_Contingency_Yr_1_Opex__c,
                                            ITS_Intake_Request__r.Approved_CR_Capex_Budget_Year_1__c,
                                            ITS_Intake_Request__r.Approved_CR_Opex_Budget_Year_1__c,
                                            ITS_Intake_Request__r.Approved_CR_Capex_Budget_Yr_2__c,
                                            ITS_Intake_Request__r.Approved_CR_Opex_Budget_Yr_2__c,
                                            ITS_Intake_Request__r.Approved_CR_Capex_Budget_Yr_3__c,
                                            ITS_Intake_Request__r.Approved_CR_Opex_Budget_Yr_3__c,
                                            ITS_Intake_Request__r.Approved_CR_Total_Hrs_Yr_1__c,
                                            ITS_Intake_Request__r.Approved_CR_Total_Hrs_Yr_2__c,
                                            ITS_Intake_Request__r.Approved_CR_Total_Hrs_Yr_3__c,
                                            ITS_Intake_Request__r.Approved_CR_Total_Hrs_Multi_Year__c,
                                            ITS_Intake_Request__r.Total_Approved_CR_Capex_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_CR_Opex_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_CR_Budget__c,
                                            ITS_Intake_Request__r.Total_Approved_CR_Internal_Hrs__c,
                                            ITS_Intake_Request__r.Total_Approved_CR_External_Hrs__c,
                                            ITS_Intake_Request__r.Discovery_Effort__c,
                                            ITS_Intake_Request__r.Requester_Name__r.Name,
                                            ITS_Intake_Request__r.Requesting_Department__c,
                                            ITS_Intake_Request__r.Short_Description_of_Request_Confirmed__c,
                                            ITS_Intake_Request__r.Business_area_s_impacted_validation__c,
                                            ITS_Intake_Request__r.Primary_Business_Area_Impacted_Confirmed__c,
                                            ITS_Intake_Request__r.User_impacted_Validation__c,
                                            ITS_Intake_Request__r.Authorized_Approver_Notes__c,
                                            ITS_Intake_Request__r.Business_Lead_Project_Manager__r.name,
                                            ITS_Intake_Request__r.Submitter_Name__c,
                                            ITS_Intake_Request__r.Assigned_Release_monthly_bundle__c,
                                            ITS_Intake_Request__r.Assigned_Technical_Analyst__r.Name,
                                            ITS_Intake_Request__r.Assigned_Technical_Analyst__c,
                                            ITS_Intake_Request__r.Requester_Priority__c,
                                            ITS_Intake_Request__r.Total_Requested_Estimate_Hours__c,
                                            ITS_Intake_Request__r.Workgroup_1__c,
                                            ITS_Intake_Request__r.Workgroup_1_Decision_date__c,
                                            ITS_Intake_Request__r.Workgroup_1_Final_Disposition__c,
                                            ITS_Intake_Request__r.Work_Group_1_Final_Disposition_Reason__c,
                                            ITS_Intake_Request__r.Workgroup_2__c,
                                            ITS_Intake_Request__r.Workgroup_2_Decision_date__c,
                                            ITS_Intake_Request__r.Workgroup_2_Final_Disposition__c,
                                            ITS_Intake_Request__r.Work_Group_2_Final_Disposition_Reason__c,
                                            ITS_Intake_Request__r.Workgroup_3__c,
                                            ITS_Intake_Request__r.Workgroup_3_Decision_date__c,
                                            ITS_Intake_Request__r.Workgroup_3_Final_Disposition__c,
                                            ITS_Intake_Request__r.Work_Group_3_Final_Disposition_Reason__c,
                                            ITS_Intake_Request__r.Workgroup_1_Notes__c,
                                            ITS_Intake_Request__r.Workgroup_2_Notes__c,
                                            ITS_Intake_Request__r.Workgroup_3_Notes__c,
                                            ITS_Intake_Request__r.Ranking_across_Enhancements_by_ISC__c,
                                            ITS_Intake_Request__r.Technical_Requirements__c,
                                            ITS_Intake_Request__r.Estimated_range_of_effort_in_hours__c,
                                            ITS_Intake_Request__r.Planned_Release_Date__c	,
                                            ITS_Intake_Request__r.IT_Project_Manager__r.name,
                                            ITS_Intake_Request__r.Requesting_Department_FM__c,
                                            ITS_Intake_Request__r.ConnectHope_Sub_Apps__c,
                                            ITS_Intake_Request__r.Impacted_Applications__c,
                                            ITS_Intake_Request__r.Authorized_Approver_Priority__c,
                                            ITS_Intake_Request__r.Total_Remaining_CAPEX_Budget__c,ITS_Intake_Request__r.Total_Remaining_OPEX_Budget__c,/*ITS_Intake_Request__r.Alternate_PM_Analyst__r.name,ITS_Intake_Request__r.Alternate_PM_Analyst__r.id,*/ITS_Intake_Request__r.IT_Advisor1__r.name,
                                            ITS_Intake_Request__r.Requested_Project_Start_Date__c,ITS_Intake_Request__r.Requested_Project_End_Date__c,ITS_Intake_Request__r.Impacted_ISC_s__c,ITS_Intake_Request__r.ISC_PM__r.name,
                                            ITS_Intake_Request__r.Request_Date__c, ITS_Intake_Request__r.Request_Category__c,ITS_Intake_Request__r.Regulatory_Due_Date__c,
                                            ITS_Intake_Request__r.Im__c,ITS_Intake_Request__r.ITS_Notes__c,ITS_Intake_Request__r.ITS_Cost_Center__c,
                                            ITS_Intake_Request__r.Key_Constraints__c,ITS_Intake_Request__r.IT_Advisor1__c,ITS_Intake_Request__r.ISC_PM__c,ITS_Intake_Request__r.Revised_Request_Start_Date__c,ITS_Intake_Request__r.Revised_Request_End_Date__c,ITS_Intake_Request__r.Revised_Go_Live_Date__c,LastModifiedById,CreatedById,Analyst__c,
                                            IT_Program_Manager__c,Alternate_Project_Manager__c,Sharepoint_URL__c,MS_Teams_URL__c, CR_Name__c, ITS_Intake_Request__r.Out_of_Scope__c, ITS_Intake_Request__r.Current_State__c, Approvals__c, Plan_for_Next_Reporting_Period__c, BMC_Change_Request__c,
                                            Scheduled_Start_Date_Remedyforce__c, Scheduled_End_Date_Remedyforce__c, Actual_Start_Date_Remedyforce__c, Actual_End_Date_Remedyforce__c,
                                            ITS_Intake_Request__r.Audit_Due_Date__c, ITS_Intake_Request__r.Audit_Reference_ID__c, ITS_Intake_Request__r.Audit_Subject__c, ITS_Intake_Request__r.Audit_Type__c, Completed_Date_Time__c, Closed_Date_Time__c, Cancelled_Date_Time__c 
                                            from IT_Portfolio_Management__c where id=: recordId limit 1];
    return ITPMObj;
    }
    
   @AuraEnabled
   public static boolean getDetails(){
        boolean tpoAdmin=false;
        User currUser=[select id,profile.name from user where id=:UserInfo.getUserId()];
       System.debug('currUser.profile.name=========>'+currUser.profile.name);
      // System.debug('currUser--->'+currUser);
        if(currUser.profile.name=='TPO Admin'|| currUser.profile.name == 'Dev Admin in Prod' || currUser.profile.name == 'System Administrator'){
            tpoAdmin=true;
        }
     return tpoAdmin;
    }

}