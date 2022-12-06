/*
* This class will query the IT Resource Records.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2021
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
* 
*/
public class COH_Get_IT_ResourceRecords {
    @AuraEnabled
    public static IT_Resource__c getResourceRecords(string recordId) {
        IT_Resource__c ITRRecs = [SELECT Id, 
                                  First_Name__c, First_Name_Update__c, First_Name_Comments__c, First_Name_Override__c,First_Name_Formula__c,
                                  Last_Name__c, Last_Name_Comments__c, Last_Name_Update__c, Last_Name_Override__c,
                                  Middle_Initial__c, Middle_Initial_Update__c, Middle_Initial_Override__c, Middle_Initial_Comments__c,
                                  Suffix__c, Suffix_Override__c, Suffix_Comments__c, Suffix_Update__c,
                                  Email__c, Email_Comments__c, Email_Update__c, Override_Email__c,
                                  Job_Title__c, Job_Title_Comments__c, Job_Title_Update__c, Job_Title_Override__c,
                                  Role_Override__c, Role__c, Roles__c, Role_Comments__c,
                                  Vendor_Name__c,Vendor_Name_Comments__c,IT_PMO_Training_Complete__c,IT_PMO_Training_Completed_Date_Comment__c,
                                  Skillset_Override__c, Skillset__c, Skillset_Comments__c, Skillset_Update__c,
                                  VP_Override__c, VP__c, VP_Comments__c, VP_Update__c,VP_Updates__c,VP_Updates__r.Name,
                                  Director__c, Director_Comments__c, Director_Update__c, Override_Director__c,Director_Updates__c,Director_Updates__r.Name,
                                  Direct_Supervisor_Comments__c, Direct_Supervisor_Update__c, Override_Direct_Supervisor__c,Direct_Supervisor_Updates__c,Direct_Supervisor_Updates__r.Name,
                                  Resource_Manager_Override__c, Resource_Manager__c, Resource_Manager_Comments__c,Resource_Manager_Updates__c,Resource_Manager_Updates__r.Name,
                                  IT_Timesheet_Required__c, IT_Timesheet_Required_Comments__c, IT_Timesheet_Required_Override__c,ITS_Timesheet__c,IT_Timesheet_RM_View__c,
                                  Enhancement_Permission_Set__c, Enhancement_Permission_Set_Comments__c, Enhancement_Permission_Set_Override__c,
                                  PM_Permission_Set_Override__c, PM_Permission_Set__c, PM_Permission_Set_Comments__c,
                                  Public_Group_Management_Override__c, Public_Group_Management_Comments__c,
                                  Enhancement_Queues_and_Groups_Comments__c, Enhancement_Queues_and_Groups_Override__c,
                                  Ranking_Permission_Set_Override__c, Ranking_Permission_Set__c, Ranking_Permission_Set_Comments__c,
                                  Staff_Type1__c, Staff_Type__c, Resource_Type_Override__c, Resource_Type_Comments__c,
                                  Planned_Start_Date_Override__c, Planned_Start_Date_Comments__c, Planned_Start_Date_Update__c,
                                  Resource_Start_Date_Override__c, Resource_Start_Date__c, Resource_Start_Date_Comments__c, Resource_Start_Date_Update__c,
                                  Expected_End_Date_Comments__c, Expected_End_Date_Update__c, Override_Expected_End_Date__c,
                                  Resource_End_Date__c, Actual_Resource_End_Date_Comments__c, Actual_Resource_End_Date_Update__c, Override_Actual_Resource_End_Date__c,
                                  Override_Primary_ISC__c, Primary_ISC_Comments__c, Primary_ISC__c,
                                  Functional_Area__c, Functional_Area_Comments__c, Functional_Area_Update__c, Override_Functional_Area__c,
                                  Sub_Functional_Area__c, Override_Sub_Functional_Area__c, Sub_Functional_Area_Comments__c, Sub_Functional_Area_Update__c,
                                  Epic_Employee__c, Epic_Employee_Comments__c,
                                  Offshore_Resource__c, Offshore_Resource_Comments__c, Offshore_Resource_Update__c, Override_Offshore_Resource__c,
                                  Business_Unit_User__c, Business_Unit__c, Business_Unit_RM__c, Business_Unit_Comments__c, Override_Business_Unit__c,
                                  Department_User__c, Department__c, Department_RM__c, Department_Comments__c, Override_Department__c,
                                  Director_RM_View__c, Email_RM_View__c, Job_Title_RM_View__c, Last_Name_RM_View__c, Middle_Initial_RM_View__c,
                                  Resource_End_Date_RM_View__c, Resource_Start_Date_RM_View__c, Resource_Type_RM_view__c,Resource_Manager_RM_view__c,Direct_Supervisor_RM_View__c,
                                  Suffix_RM_View__c, VP_RM_View__c,Epic_Certifications__c
                                  from IT_Resource__c where id=: recordId limit 1];
        return ITRRecs;
    }
}