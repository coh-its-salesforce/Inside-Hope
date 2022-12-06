@isTest
private class ITIntakeTPOProjectPortfolioTest {
    @isTest
    static void testQuery() {
        Boolean containMasterRecord = false;
        Boolean containEnhancementRecord = false;
        //Create an IT Intake Record
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        Id enhancementRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Enhancement Request').getRecordTypeId();
        User userId=[select id from user where name='System Account'];
        // Inserting a master request record
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
                                                                                  IT_Sponsor__c								='Ahwah, Gary',
                                                                                  IT_Owner__c								='Ahwah, Gary',
                                                                                  IT_Functional_Area__c						='Clinical Systems (Epic)',
                                                                                  IT_Functional_Sub_Area__c					='Pharmacy/Oncology', 
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
                                                                                  Primary_ISC__c 							='Patient Care & Clinical Systems',
                                                                                  IT_Advisor__c 							='Nelson, Cindy',
                                                                                  ISC_Project_Manager1__c					='Bhattacharya, Gautam',
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

        String masterRequestName = intakeMasterRequest.name;
        List<TPO_Project_Portfolio__c> queriedIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchITIntake(masterRequestName, false);
        List<TPO_Project_Portfolio__c> nullIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchITIntake('', false);
        List<TPO_Project_Portfolio__c> queriedMyIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchITIntake(masterRequestName, true);
        List<TPO_Project_Portfolio__c> queriedNullMyIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchITIntake('', true);
        system.debug(masterRequestName);
        for(TPO_Project_Portfolio__c intakeRecScan : queriedIntakeRecords){

            if(intakeRecScan.name == masterRequestName){
                containMasterRecord = true;
            }
        }
        System.Assert(true,containMasterRecord);

        TPO_Project_Portfolio__c enhancementRequest=new TPO_Project_Portfolio__c(Request_Date__c						=system.Date.today(),
                                                                                Request_Type__c							='CP - Capital Purchase',
                                                                                Request_Name__c							='City of Hope project-1',
                                                                                Program__c								='No Program',
                                                                                Requester_Name__c						=userId.id,
                                                                                Requester_Priority__c					='Low (Nice to have)',
                                                                                Project_Size__c							='Small',
                                                                                Requested_Project_Start_Date__c			=system.Date.today(),
                                                                                Requested_Project_End_Date__c			=system.Date.today(),
                                                                                Request_Category__c						='Regulatory/Compliance',
                                                                                Funding_Type__c							='Capex',
                                                                                Funding_Source__c						='Other',
                                                                                Funding_Source_Other__c					='ssdfdfgghhjhj',
                                                                                Fiscal_Year_Start__c					='FY18',
                                                                                Business_Sponsor__c						=userId.id,
                                                                                Business_Owner__c						=userId.id,
                                                                                IT_Sponsor__c							='Ahwah, Gary',
                                                                                IT_Owner__c								='Ahwah, Gary',
                                                                                IT_Functional_Area__c					='Clinical Systems (Epic)',
                                                                                IT_Functional_Sub_Area__c				='Pharmacy/Oncology', 
                                                                                ITS_Cost_Center__c						='8480007: ITS Enterprise Database Administration',
                                                                                Project_Background__c					='dsfdfgfghhgh',
                                                                                Executive_Summary__c					='sfdfggdfgfgfh',
                                                                                Describe_goals_and_objectives__c		='ffdgffghfgh',
                                                                                Project_Justification__c				='sfffggggdd',
                                                                                Scope_Considerations__c					='fffgfgg',
                                                                                Short_Term_Benefits__c					='sddddgfgdg',
                                                                                Long_Term_Benefits__c					='dfgfgfdgdg',
                                                                                Request_Status__c						='Draft',
                                                                                Approval_Status__c 						='Pending',
                                                                                Primary_ISC__c 							='Patient Care & Clinical Systems',
                                                                                IT_Advisor__c 							='Nelson, Cindy',
                                                                                ISC_Project_Manager1__c					='Bhattacharya, Gautam',
                                                                                Check_if_project_is_approved__c 		=false,
                                                                                Approved_Total_Hours__c					=null,	
                                                                                Approved_Internal_IT_Labor_Hours_Year_1__c=null,	
                                                                                Approved_External_IT_Labor_Hours_Year1C__c=null,
                                                                                Approved_External_ITS_Hours__c 			=null,       
                                                                                Total_Remaining_CAPEX_Budget__c			=2,
                                                                                Total_Remaining_OPEX_Budget__c			=2,
                                                                                Total_Combined_External_Labor_Hours__c 	=1,
                                                                                Total_Combined_Internal_Labor_Hours__c 	=1,     
                                                                                RecordTypeId							=enhancementRecTypeId);
    insert enhancementRequest;
    String enhancementRequestName = enhancementRequest.name;
    List<TPO_Project_Portfolio__c> queriedEnhancementRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchEnhancement(enhancementRequestName,false);
    List<TPO_Project_Portfolio__c> nullEnhancementRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchEnhancement('',false);
    List<TPO_Project_Portfolio__c> queriedEnhancementMyIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchEnhancement(enhancementRequestName, true);
    List<TPO_Project_Portfolio__c> queriedEnhancementNullMyIntakeRecords = ITIntakeTPOProjectPortfolioAuraEnabled.searchEnhancement('', true);
    for(TPO_Project_Portfolio__c enhancementRecScan : queriedIntakeRecords){

    if(enhancementRecScan.name == enhancementRequestName){
        containEnhancementRecord = true;
        }
    }
    System.Assert(true,containEnhancementRecord);
    }
}