/*
* This class will query the IT Project Intake Records.
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
public class COH_Get_IT_IntakeRecords {
	@AuraEnabled
    public static TPO_Project_Portfolio__c getProjectIntake(string recordId) {
        TPO_Project_Portfolio__c ITIntakeRecs = [SELECT Id,
                                                 Primary_ISC__c,
                                                 IT_Advisor__c,
                                                 ISC_Project_Manager1__c,
                                                 Business_area_s_impacted_validation__c,
                                                 Authorized_Approver_Comments_Instruction__c,
                                                 Workgroup_1__c,
                                                 Workgroup_1_Decision_date__c,
                                                 Workgroup_2__c,
                                                 Workgroup_2_Decision_date__c,
                                                 Workgroup_3__c,
                                                 Workgroup_3_Decision_date__c,
                                                 Primary_Application__c,
                                                 Other_Impacted_Applications__c,
                                                 Estimated_range_of_effort_in_hours__c,
                                                 Technical_Requirements__c,
                                                 Assigned_Release_monthly_bundle__c,
                                                 Requested_Project_Start_Date__c,
                                                 Requester_Name__r.name,
                                                 Submitter_Name__c,
                                                 //TPO_Project_Intake_Requester__r.name,
                                                 Requested_Project_End_Date__c,
                                                 Project_Background__c,
                                                 Current_State__c,
                                                 Project_Short_Description__c,
                                                 Short_Term_Benefits__c,
                                                 Business_area_s_impacted__c,
                                                 Users_impacted__c,
                                                 Notes__c,
                                                 Requester_Priority__c,
                                                 NotesText__c
                                                 from TPO_Project_Portfolio__c where id=: recordId limit 1];
        return ITIntakeRecs;
    }
}