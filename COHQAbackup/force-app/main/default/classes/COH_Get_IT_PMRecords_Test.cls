/*
* This Test Class verifies the functionality of COH_Get_IT_PMRecords
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

@isTest
public class COH_Get_IT_PMRecords_Test {
    public static testMethod void ITPMRecords() {
        Test.startTest();
        	//Creating TPO_Project_Portfolio record LK 06/04/2020
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        Id lifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Enhancement Request').getRecordTypeId();
        String IT_Delivery_Owner = 'Lee, Pearl';
        String IT_Sponsor = 'Thomas, Jim';
        User userId=[select id from user where name='System Account'];
        TPO_Project_Portfolio__c intakeMasterRequest=new TPO_Project_Portfolio__c(Request_Date__c							=system.Date.today(),
                                                                                  Request_Type__c							='CP - Capital Purchase',
                                                                                  Request_Name__c							='City of Hope project-1',
                                                                                  Program__c								='No Program',
                                                                                  Requester_Name__c							=userId.id,
                                                                                  Requester_Priority__c						='Low (Nice to have)',
                                                                                  Project_Size__c							='Small',
                                                                                  Requested_Project_Start_Date__c			=system.Date.today(),
                                                                                  Requested_Project_End_Date__c				=system.Date.today(),
                                                                                  Request_Category__c						='Regulatory/Compliance',
                                                                                  Funding_Type__c							='Capex',
                                                                                  Funding_Source__c							='Other',
                                                                                  Funding_Source_Other__c					='ssdfdfgghhjhj',
                                                                                  Fiscal_Year_Start__c						='FY18',
                                                                                  Business_Sponsor__c						=userId.id,
                                                                                  Business_Owner__c							=userId.id,
                                                                                  IT_Sponsor__c								=IT_Sponsor,
                                                                                  IT_Owner__c								=IT_Delivery_Owner,
                                                                                  Primary_ISC__c 							='Enterprise Data Mgmt & Analytics',
                                                                                  IT_Advisor__c 							='Ady, Kevin',
                                                                                  IT_Functional_Area__c						='Quality Center',
                                                                                  IT_Functional_Sub_Area__c					='Quality Assurance/Testing',
                                                                                  ITS_Cost_Center__c						='8480007: ITS Enterprise Database Administration',
                                                                                  Project_Background__c						='dsfdfgfghhgh',
                                                                                  Executive_Summary__c						='sfdfggdfgfgfh',
                                                                                  Describe_goals_and_objectives__c			='ffdgffghfgh',
                                                                                  Project_Justification__c					='sfffggggdd',
                                                                                  Scope_Considerations__c					='fffgfgg',
                                                                                  Short_Term_Benefits__c					='sddddgfgdg',
                                                                                  Long_Term_Benefits__c						='dfgfgfdgdg',
                                                                                  Request_Status__c							='Draft',
                                                                                  Approval_Status__c 						='Pending',
                                                                                  Check_if_project_is_approved__c 			=false,
                                                                                  Approved_Total_Hours__c					=null,	
                                                                                  Approved_Internal_IT_Labor_Hours_Year_1__c=null,	
                                                                                  Approved_External_IT_Labor_Hours_Year1C__c=null,
                                                                                  Approved_External_ITS_Hours__c 			=null,       
                                                                                  Total_Remaining_CAPEX_Budget__c			=2,
                                                                                  Total_Remaining_OPEX_Budget__c			=2,
                                                                                  Total_Combined_External_Labor_Hours__c 	=1,
                                                                                  Total_Combined_Internal_Labor_Hours__c 	=1,     
                                                                                  RecordTypeId								=intakeRecTypeId);
        insert intakeMasterRequest;
        
        	IT_Portfolio_Management__c ITPM = new IT_Portfolio_Management__c();
                ITPM.Committed_Open_POs_B__c = 100;
                ITPM.Incurred_Cost_YTD__c = 100;
                ITPM.Hours_Burned_D__c = 100;
                ITPM.Committed_Prof_Svcs_Cost_Yr_1_Capex__c = 100;
				ITPM.Committed_Hardware_Cost_Yr_1_Capex__c = 100;
                ITPM.Committed_Software_Cost_Yr_1_Capex__c = 100;
                ITPM.Project_Status__c = 'Complete';
                ITPM.Internal_Labor_YTD__c = 100;
        //adding TPO_Project_Portfolio__c LK 06/04/2020
        		ITPM.ITS_Intake_Request__c = intakeMasterRequest.id;
        		ITPM.RecordTypeId = lifeCycleRecTypeId;
        		ITPM.Methodology__c = 'Enhancement';
        		ITPM.Request_Type__c = 'Enhancement';
        		ITPM.Activity_Type__c = 'N/A';
        		ITPM.DT_Project_Type__c = 'N/A';
        		ITPM.ITS_Application__c = 'N/A';
        insert ITPM;
        COH_Get_IT_PMRecords.getSummaryRecords(ITPM.id);
        COH_Get_IT_PMRecords.getITPMLifecycleId(intakeMasterRequest.id);
      //  COH_Get_IT_PMRecords.getDetails(ITPM.id);
        ITPM_LifeCycle_Tabs_Controller.getITProjectIntake(ITPM.id);
        
        Test.stopTest();
    
    }
	private static testMethod void createUser() {
           Profile p = [SELECT Id FROM Profile WHERE Name='TPO Admin']; 
           User u = new User(Alias = 'sysad', Email='sysadmin@coh.org', 
            EmailEncodingKey='UTF-8', LastName='TestAdmin', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testsysadmin@coh.org');
         
        insert u;
        System.runAs(u) {
        	Test.startTest();
            COH_Get_IT_PMRecords.getDetails();
            ITPM_LifeCycle_Tabs_Controller.getDetails();
            Test.stopTest();
        }
    }
}