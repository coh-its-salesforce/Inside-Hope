@isTest
public class COH_Get_IT_IntakeRecords_Test {
	public static testMethod void ITIntakeRecords() {
        Test.startTest();
        	TPO_Project_Portfolio__c ITIntake = new TPO_Project_Portfolio__c();
        	ITIntake.Primary_ISC__c = 'Research Systems';
            ITIntake.IT_Advisor__c = 'Limaye, Jayant';
            ITIntake.ISC_Project_Manager1__c = 'Bui, Tracy';
            ITIntake.Business_area_s_impacted_validation__c = 'Surgery';
            ITIntake.Authorized_Approver_Comments_Instruction__c = 'Test';
            ITIntake.Workgroup_1__c = 'Telehealth';
            ITIntake.Workgroup_1_Decision_date__c = Date.newInstance(2016, 12, 9);
            ITIntake.Workgroup_2__c = 'Telehealth';
            ITIntake.Workgroup_2_Decision_date__c = Date.newInstance(2016, 12, 9);
            ITIntake.Workgroup_3__c = 'Telehealth';
            ITIntake.Workgroup_3_Decision_date__c = Date.newInstance(2016, 12, 9);
            ITIntake.Primary_Application__c = 'List of Epic Applications';
            ITIntake.Other_Impacted_Applications__c = 'List of Epic Applications';
           // ITIntake.Estimated_range_of_effort_in_hours__c = 41-80;
            ITIntake.Technical_Requirements__c = 'Test';
            ITIntake.Assigned_Release_monthly_bundle__c = 'December 2021 Bundle';
            
        insert ITIntake;
        COH_Get_IT_IntakeRecords.getProjectIntake(ITIntake.id);
        Test.stopTest();
    }
}