/* Created By    :  Saidaiah Surisetti
* Created Date  :  8/23/2018
* Description   :  This test controller verifies the functionality of the ITS_Intake_Request Trigger.
* Modified by   :  Larry Kiang
* Modified Date :  04/03/2019
*/
@isTest
private class ITS_Intake_Request_TriggerTestController {
    
    private static final Boolean mRunintakeRequestsTest = false;
    private static final Boolean mRunbulkIntakeRequestsTest = false;
    private static final Boolean mRunintakeRequestNullTest = false;
    private static final Boolean mRunintakeRequestNullSingleTest = false;
    private static final Boolean mRunAllTests = true;
    private static String changeRequestRecordType = 'Change Request';
    private static String initiationRecordType = 'Initiation';
    private static String itAdvisor = 'Nelson, Cindy';
    private static String ISCProjectManager = 'Pechatnikov, Leon';
    private static String fiscalYear = 'FY21';
    private static String PrimaryISC = 'Patient Care & Clinical Systems';
    private static String ITSponsor = 'Cowan, Skye';
    private static String ITOwner = 'Lee, Pearl';
    private static String ITFunctionalArea = 'Clinical Systems (Epic)';
    private static String ITSubFunctionalArea = 'Pharmacy/Oncology';
    private static String CostCenter = '8480007: ITS Enterprise Database Administration';
    private static String RequestType = 'P - Project';
       
    
    private testmethod static void intakeRequestsTest(){
        if (!mRunAllTests && !mRunintakeRequestsTest){
            System.debug ('Skipping intakeRequestsTest');
            return;
        }        
        Test.startTest();        
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(initiationRecordType).getRecordTypeId();
        Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(changeRequestRecordType).getRecordTypeId();
        
        User userId=[select id from user where name='System Account'];
        // Inserting a master request record
        TPO_Project_Portfolio__c intakeMasterRequest=new TPO_Project_Portfolio__c(Request_Date__c							= system.Date.today(),
                                                                                  Request_Type__c							= RequestType,
                                                                                  Request_Name__c							= 'City of Hope project-1',
                                                                                  Program__c								= 'No Program',
                                                                                  Requester_Name__c							= userId.id,
                                                                                  Requester_Priority__c						= 'Low (Nice to have)',
                                                                                  Project_Size__c							= 'Small',
                                                                                  Requested_Project_Start_Date__c			= system.Date.today(),
                                                                                  Requested_Project_End_Date__c				= system.Date.today(),
                                                                                  Request_Category__c						= 'Regulatory/Compliance',
                                                                                  Funding_Type__c							= 'Capex',
                                                                                  Funding_Source__c							= 'Other',
                                                                                  Funding_Source_Other__c					= 'ssdfdfgghhjhj',
                                                                                  Fiscal_Year_Start__c						= fiscalYear,
                                                                                  Business_Sponsor__c						= userId.id,
                                                                                  Business_Owner__c							= userId.id,
                                                                                  IT_Sponsor__c								= ITSponsor,
                                                                                  IT_Owner__c								= ITOwner,
                                                                                  IT_Functional_Area__c						= ITFunctionalArea,
                                                                                  IT_Functional_Sub_Area__c					= ITSubFunctionalArea, 
                                                                                  ITS_Cost_Center__c						= CostCenter,
                                                                                  Project_Background__c						= 'dsfdfgfghhgh',
                                                                                  Executive_Summary__c						= 'sfdfggdfgfgfh',
                                                                                  Describe_goals_and_objectives__c			= 'ffdgffghfgh',
                                                                                  Project_Justification__c					= 'sfffggggdd',
                                                                                  Scope_Considerations__c					= 'fffgfgg',
                                                                                  Short_Term_Benefits__c					= 'sddddgfgdg',
                                                                                  Long_Term_Benefits__c						= 'dfgfgfdgdg',
                                                                                  Request_Status__c							= 'Draft',
                                                                                  Approval_Status__c 						= 'Pending',
                                                                                  Primary_ISC__c 							= PrimaryISC,
                                                                                  IT_Advisor__c 							= itAdvisor,
                                                                                  ISC_Project_Manager1__c					= ISCProjectManager,
                                                                                  Check_if_project_is_approved__c 			= false,
                                                                                  Approved_Total_Hours__c					= null,	
                                                                                  Approved_Internal_IT_Labor_Hours_Year_1__c= null,	
                                                                                  Approved_External_IT_Labor_Hours_Year1C__c= null,
                                                                                  Approved_External_ITS_Hours__c 			= null,       
                                                                                  Total_Remaining_CAPEX_Budget__c			= 2,
                                                                                  Total_Remaining_OPEX_Budget__c			= 2,
                                                                                  Total_Combined_External_Labor_Hours__c 	= 1,
                                                                                  Total_Combined_Internal_Labor_Hours__c 	= 1,     
                                                                                  RecordTypeId								= intakeRecTypeId);
        insert intakeMasterRequest;
        intakeMasterRequest.Check_if_project_is_approved__c = true;
        intakeMasterRequest.Request_Status__c = 'Complete';
        intakeMasterRequest.Approval_Status__c = 'Approved';
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        update intakeMasterRequest;

        // Inserting a change request record1
        TPO_Project_Portfolio__c changeRequestRecord1=new TPO_Project_Portfolio__c(Requester_Name__c                            = userId.id,
                                                                                   CR__c                                        = '1',
                                                                                   Change_Request_Submission_Date__c            = Date.newInstance(2019, 08, 08),
                                                                                   Change_Classification__c                     = 'Budget',
                                                                                   Description_of_Proposed_Change__c            = 'dvfvdfdfdfdffd',
                                                                                   Impact_Risks_if_Change_RequestUnapproved__c  = 'vddffgddggdgff',
                                                                                   Request_ID_Request_Name__c                   = intakeMasterRequest.id,
                                                                                   Approval_Needed_By__c                        = system.Date.today(),
                                                                                   Request_Status__c                            = 'Complete',
                                                                                   Approval_Status__c 							= 'Approved',
                                                                                   Check_if_CR_is_approved__c 					= false,
                                                                                   Additional_Requested_Software_Amount__c      = 15000,
                                                                                   Additional_Requested_HW_Maintenance_Amt__c   = 15000,
                                                                                   RecordTypeId                                 = changeRequestRecTypeId, 
                                                                                   Additional_Requested_Capex_TS_Hours__c       = 15000,
                                                                                   AdditionalRequested_Opex_Internal_ITS_LH__c  = 15000,
                                                                                   Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c	= 0,
                                                                                   AdditionalRequested_Opex_External_ITS_LH__c  = 15000,
                                                                                   Primary_ISC__c 								= PrimaryISC,
                                                                                   IT_Advisor__c 								= itAdvisor,
                                                                                   ISC_Project_Manager1__c						= ISCProjectManager);
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert changeRequestRecord1;
        changeRequestRecord1.Check_if_CR_is_approved__c = true;
        update changeRequestRecord1;
        // Inserting a sub request record 
        TPO_Project_Portfolio__c intakeSubRequest=new TPO_Project_Portfolio__c(Request_Date__c                  			= system.Date.today(),
                                                                               Request_Type__c                  			= RequestType,
                                                                               Parent_Request__c                			= intakeMasterRequest.id,
                                                                               Request_Name__c                  			= 'City of Hope project-1',
                                                                               Program__c                       			= 'No Program',
                                                                               Requester_Name__c                			= userId.id,
                                                                               Requester_Priority__c            			= 'Low (Nice to have)',
                                                                               Project_Size__c                  			= 'Small',
                                                                               Requested_Project_Start_Date__c  			= system.Date.today(),
                                                                               Requested_Project_End_Date__c    			= system.Date.today(),
                                                                               Request_Category__c              			= 'Regulatory/Compliance',
                                                                               Funding_Type__c                  			= 'Capex',
                                                                               Funding_Source__c               				= 'Other',
                                                                               Funding_Source_Other__c          			= 'ssdfdfgghhjhj',
                                                                               Fiscal_Year_Start__c             			= fiscalYear,
                                                                               Business_Sponsor__c              			= userId.id,
                                                                               Business_Owner__c                			= userId.id,
                                                                               IT_Sponsor__c                    			= ITSponsor,
                                                                               IT_Owner__c                     				= ITOwner,
                                                                               IT_Functional_Area__c						= ITFunctionalArea,
                                                                               IT_Functional_Sub_Area__c					= ITSubFunctionalArea, 
                                                                               ITS_Cost_Center__c               			= CostCenter,
                                                                               Project_Background__c            			= 'dsfdfgfghhgh',
                                                                               Executive_Summary__c             			= 'sfdfggdfgfgfh',
                                                                               Describe_goals_and_objectives__c 			= 'ffdgffghfgh',
                                                                               Project_Justification__c         			= 'sfffggggdd',
                                                                               Scope_Considerations__c          			= 'fffgfgg',
                                                                               Short_Term_Benefits__c           			= 'sddddgfgdg',
                                                                               Long_Term_Benefits__c            			= 'dfgfgfdgdg',
                                                                               Request_Status__c                			= 'Complete',
                                                                               Approval_Status__c 							= 'Pending',
                                                                                  Primary_ISC__c 							= PrimaryISC,
                                                                                  IT_Advisor__c 							= itAdvisor,
                                                                                  ISC_Project_Manager1__c					= ISCProjectManager,                                                                             
                                                                               Check_if_project_is_approved__c 				= false,
                                                                               Approved_Hardware_Cost_Year_1_Capex__c		= 15000,
                                                                               Approved_CAPEX_Year_2__c         			= 50,
                                                                               Approved_CAPEX_Year_3__c         			= 25,
                                                                               Approved_Consulting_Cost_Year_1_Opex__c 		= 15000,
                                                                               Approved_OPEX_Year_2__c          			= 50,
                                                                               Approved_OPEX_Year_3__c          			= 25,
                                                                               Total_Remaining_CAPEX_Budget__c  			= 0,
                                                                               Total_Remaining_OPEX_Budget__c  				= 0,
                                                                               Approved_Total_Hours__c          			= 10,
                                                                               Approved_External_ITS_Hours__c   			= 5,
                                                                               RecordTypeId=intakeRecTypeId);
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert intakeSubRequest;
        intakeSubRequest.Approval_Status__c 						= 'Approved';       
        intakeSubRequest.Approved_Hardware_Cost_Year_1_Capex__c		= 25;
        intakeSubRequest.Approved_Consulting_Cost_Year_1_Opex__c	= 10;
        intakeSubRequest.Approved_Total_Hours__c        			= 100;
        intakeSubRequest.Approved_External_ITS_Hours__c 			= 100;
        intakeSubRequest.Approved_External_IT_Labor_Hours_Year1C__c = 0;
        intakeSubRequest.Approved_Internal_IT_Labor_Hours_Year_1__c = 0;
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake			= true;
        update intakeSubRequest;        
        
        Test.stopTest();    
     

        TPO_Project_Portfolio__c intakeMR = [select id, 
                                             Total_Remaining_OPEX_Budget__c,
                                             Total_Remaining_CAPEX_Budget__c,
                                             Total_Remaining_Budget_IT__c,
                                             Total_Combined_External_Labor_Hours__c,
                                             Total_Combined_Internal_Labor_Hours__c,
                                             Total_Combined_Labor_Hours__c,
                                             Request_Status__c
                                             from TPO_Project_Portfolio__c 
                                             where id =:IntakeMasterRequest.Id];
        system.assertEquals(14915, intakeMR.Total_Remaining_OPEX_Budget__c);
        system.assertEquals(14900,intakeMR.Total_Remaining_CAPEX_Budget__c);        
        system.assertEquals(29815, intakeMR.Total_Remaining_Budget_IT__c);
        system.assertEquals(29900,intakeMR.Total_Combined_External_Labor_Hours__c);
        system.assertEquals(14900,intakeMR.Total_Combined_Internal_Labor_Hours__c);
        system.assertEquals(44800,intakeMR.Total_Combined_Labor_Hours__c);       
    
    }        
    
    
    private testmethod static void bulkIntakeRequestsTest(){   
        if (!mRunAllTests && !mRunbulkIntakeRequestsTest){
            System.debug ('Skipping bulkIntakeRequestsTest');
            return;
        }
        test.startTest();
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(initiationRecordType).getRecordTypeId();
        Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(changeRequestRecordType).getRecordTypeId();
        List <TPO_Project_Portfolio__c> TPOstoInsert = New List <TPO_Project_Portfolio__c>();
        User userId=[select id from user where name='System Account'];
        for(integer i=0;i<50;i++){
            TPO_Project_Portfolio__c intakeMasterRequest=new TPO_Project_Portfolio__c(Request_Date__c					= system.Date.today(),
                                                                                      Request_Type__c					= RequestType,
                                                                                      Request_Name__c					= 'City of Hope project-1',
                                                                                      Program__c						= 'No Program',
                                                                                      Requester_Name__c					= userId.id,
                                                                                      Requester_Priority__c				= 'Low (Nice to have)',
                                                                                      Project_Size__c					= 'Small',
                                                                                      Requested_Project_Start_Date__c	= system.Date.today(),
                                                                                      Requested_Project_End_Date__c		= system.Date.today(),
                                                                                      Request_Category__c				= 'Regulatory/Compliance',
                                                                                      Funding_Type__c					= 'Capex',
                                                                                      Funding_Source__c					= 'Other',
                                                                                      Funding_Source_Other__c			= 'ssdfdfgghhjhj',
                                                                                      Fiscal_Year_Start__c				= fiscalYear,
                                                                                      Business_Sponsor__c				= userId.id,
                                                                                      Business_Owner__c					= userId.id,
                                                                                      IT_Sponsor__c						= ITSponsor,
                                                                                      IT_Owner__c						= ITOwner,
                                                                                	  IT_Functional_Area__c				= ITFunctionalArea,
                                                                                      IT_Functional_Sub_Area__c			= ITSubFunctionalArea, 
                                                                                      ITS_Cost_Center__c				= CostCenter,
                                                                           		      Primary_ISC__c 					= PrimaryISC,
                                                                                      IT_Advisor__c 					= itAdvisor,
                                                                              	  	  ISC_Project_Manager1__c			= ISCProjectManager,
                                                                                      Project_Background__c				= 'dsfdfgfghhgh',
                                                                                      Executive_Summary__c				= 'sfdfggdfgfgfh',
                                                                                      Describe_goals_and_objectives__c	= 'ffdgffghfgh',
                                                                                      Project_Justification__c			= 'sfffggggdd',
                                                                                      Scope_Considerations__c			= 'fffgfgg',
                                                                                      Short_Term_Benefits__c			= 'sddddgfgdg',
                                                                                      Long_Term_Benefits__c				= 'dfgfgfdgdg',
                                                                                      Request_Status__c					= 'Complete',
                                                                                      Approval_Status__c				= 'Approved',
                                                                                      Total_Remaining_CAPEX_Budget__c	= 0,
                                                                                      Total_Remaining_OPEX_Budget__c	= 0,
                                                                                      Check_if_project_is_approved__c	= true,
                                                                                      RecordTypeId						= intakeRecTypeId);
            TPOstoInsert.add(IntakeMasterRequest);
        }
        Insert TPOstoInsert;
        test.stopTest();
    } 
    
    
    Private testmethod static void intakeRequestNull(){
        if (!mRunAllTests && !mRunintakeRequestNullTest){
            System.debug ('Skipping intakeRequestNullTest');
            return;
        }
        Test.startTest();
        User userId=[select id from user where name='System Account'];
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(initiationRecordType).getRecordTypeId();
        Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(changeRequestRecordType).getRecordTypeId();
        TPO_Project_Portfolio__c intakeMasterRequestNull=new TPO_Project_Portfolio__c(Request_Date__c							= system.Date.today(),
                                                                                      Request_Type__c							= RequestType,
                                                                                      Request_Name__c							= 'City of Hope project-1',
                                                                                      Program__c								= 'No Program',
                                                                                      Requester_Name__c							= userId.id,
                                                                                      Requester_Priority__c						= 'Low (Nice to have)',
                                                                                      Project_Size__c							= 'Small',
                                                                                      Requested_Project_Start_Date__c			= system.Date.today(),
                                                                                      Requested_Project_End_Date__c				= system.Date.today(),
                                                                                      Request_Category__c						= 'Regulatory/Compliance',
                                                                                      Funding_Type__c							= 'Capex',
                                                                                      Funding_Source__c							= 'Other',
                                                                                      Funding_Source_Other__c					= 'ssdfdfgghhjhj',
                                                                                  	  Primary_ISC__c 							= PrimaryISC,
                                                                                  	  IT_Advisor__c 							= itAdvisor,
                                                                                  	  ISC_Project_Manager1__c					= ISCProjectManager,
                                                                                      //Regulatory__c='No',
                                                                                      Fiscal_Year_Start__c						= fiscalYear,
                                                                                      Business_Sponsor__c						= userId.id,
                                                                                      Business_Owner__c							= userId.id,
                                                                                      IT_Sponsor__c								= ITSponsor,
                                                                                      IT_Owner__c								= ITOwner,
                                                                                  	  IT_Functional_Area__c						= ITFunctionalArea,
                                                                                  	  IT_Functional_Sub_Area__c					= ITSubFunctionalArea, 
                                                                                      ITS_Cost_Center__c						= CostCenter,
                                                                                      Project_Background__c						= 'dsfdfgfghhgh',
                                                                                      Executive_Summary__c						= 'sfdfggdfgfgfh',
                                                                                      Describe_goals_and_objectives__c			= 'ffdgffghfgh',
                                                                                      Project_Justification__c					= 'sfffggggdd',
                                                                                      Scope_Considerations__c					= 'fffgfgg',
                                                                                      Short_Term_Benefits__c					= 'sddddgfgdg',
                                                                                      Long_Term_Benefits__c						= 'dfgfgfdgdg',
                                                                                      Request_Status__c							= 'Complete',
                                                                                      Approval_Status__c						= 'Approved',
                                                                                      RecordTypeId								= intakeRecTypeId);
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert intakeMasterRequestNull;
        
        TPO_Project_Portfolio__c changeRequestRecordNull=new TPO_Project_Portfolio__c(Requester_Name__c                             = userId.id,
                                                                                      CR__c                                         = '1',
                                                                                      Change_Request_Submission_Date__c             = Date.newInstance(2019, 08, 08),
                                                                                      Change_Classification__c                      = 'Budget',
                                                                                      Description_of_Proposed_Change__c             = 'dvfvdfdfdfdffd',
                                                                                      Impact_Risks_if_Change_RequestUnapproved__c   = 'vddffgddggdgff',
                                                                                      Request_ID_Request_Name__c                    = intakeMasterRequestNull.id,
                                                                                	  Primary_ISC__c 								= PrimaryISC,
                                                                                 	  IT_Advisor__c 								= itAdvisor,
                                                                                	  ISC_Project_Manager1__c						= ISCProjectManager,                                                                                 
                                                                                      Approval_Needed_By__c                         = system.Date.today(),
                                                                                      Request_Status__c                             = 'Complete',
                                                                                      Approval_Status__c 							= 'Approved',
                                                                                      RecordTypeId                                  = changeRequestRecTypeId);
        
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert changeRequestRecordNull;     
        
        TPO_Project_Portfolio__c intakeSubRequestnull   =new TPO_Project_Portfolio__c(Request_Date__c                   = system.Date.today(),
                                                                                      Request_Type__c                   = 'CP - Capital Purchase',
                                                                                      Parent_Request__c                 = intakeMasterRequestNull.id,
                                                                                      Request_Name__c                   = 'City of Hope project-1',
                                                                                      Program__c                        = 'No Program',
                                                                                      Requester_Name__c                 = userId.id,
                                                                                      Requester_Priority__c             = 'Low (Nice to have)',
                                                                                      Project_Size__c                   = 'Small',
                                                                                      Requested_Project_Start_Date__c   = system.Date.today(),
                                                                                      Requested_Project_End_Date__c     = system.Date.today(),
                                                                                      Request_Category__c               = 'Regulatory/Compliance',
                                                                                      Funding_Type__c                   = 'Capex',
                                                                                      Funding_Source__c                 = 'Other',
                                                                                      Funding_Source_Other__c           = 'ssdfdfgghhjhj',
                                                                                      Fiscal_Year_Start__c              = fiscalYear,
                                                                                      Business_Sponsor__c               = userId.id,
                                                                                      Business_Owner__c                 = userId.id,
                                                                                      IT_Sponsor__c                     = ITSponsor,
                                                                                      IT_Owner__c                       = ITOwner,
                                                                                  	  IT_Functional_Area__c				= ITFunctionalArea,
                                                                                  	  IT_Functional_Sub_Area__c			= ITSubFunctionalArea, 
                                                                                      ITS_Cost_Center__c                = CostCenter,
                                                                                      Project_Background__c             = 'dsfdfgfghhgh',
                                                                                      Executive_Summary__c              = 'sfdfggdfgfgfh',
                                                                                      Describe_goals_and_objectives__c  = 'ffdgffghfgh',
                                                                                      Project_Justification__c          = 'sfffggggdd',
                                                                                      Scope_Considerations__c           = 'fffgfgg',
                                                                                 	  Primary_ISC__c 					= PrimaryISC,
                                                                                	  IT_Advisor__c 					= itAdvisor,
                                                                               	 	  ISC_Project_Manager1__c			= ISCProjectManager,                                                                                    
                                                                                      Short_Term_Benefits__c            = 'sddddgfgdg',
                                                                                      Long_Term_Benefits__c             = 'dfgfgfdgdg',
                                                                                      Request_Status__c                 = 'Complete',
                                                                                      Approval_Status__c 				= 'Approved',
                                                                                      RecordTypeId=intakeRecTypeId);
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert intakeSubRequestnull;      
        test.stopTest();
    }
    
    private testmethod static void intakeRequestsSoloNullTest(){
        if (!mRunAllTests && !mRunintakeRequestNullSingleTest){
            System.debug ('Skipping intakeRequestsTest');
            return;
        }
        
        Test.startTest();
        
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(initiationRecordType).getRecordTypeId();
        Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get(changeRequestRecordType).getRecordTypeId();
        
        User userId=[select id from user where name='System Account'];
        // Inserting a Single Master Request Record with null External and Internal Labor Hours
        TPO_Project_Portfolio__c intakeSingleMasterRequestNull=new TPO_Project_Portfolio__c(Request_Date__c							= system.Date.today(),
                                                                                            Request_Type__c							= RequestType,
                                                                                            Request_Name__c							= 'City of Hope project-1',
                                                                                            Program__c								= 'No Program',
                                                                                            Requester_Name__c						= userId.id,
                                                                                            Requester_Priority__c					= 'Low (Nice to have)',
                                                                                            Project_Size__c							= 'Small',
                                                                                            Requested_Project_Start_Date__c			= system.Date.today(),
                                                                                            Requested_Project_End_Date__c			= system.Date.today(),
                                                                                            Request_Category__c						= 'Regulatory/Compliance',
                                                                                            Funding_Type__c							= 'Capex',
                                                                                            Funding_Source__c						= 'Other',
                                                                                            Funding_Source_Other__c					= 'ssdfdfgghhjhj',
                                                                                            //Regulatory__c='No',
                                                                               			    Primary_ISC__c 							= PrimaryISC,		
                                                                                			IT_Advisor__c 							= itAdvisor,
                                                                                 	  		ISC_Project_Manager1__c					= ISCProjectManager,                                                                                            
                                                                                            Fiscal_Year_Start__c					= fiscalYear,
                                                                                            Business_Sponsor__c						= userId.id,
                                                                                            Business_Owner__c						= userId.id,
                                                                                            IT_Sponsor__c							= ITSponsor,
                                                                                            IT_Owner__c								= ITOwner,
                                                                                            IT_Functional_Area__c					= ITFunctionalArea,
                                                                                  			IT_Functional_Sub_Area__c				= ITSubFunctionalArea, 
                                                                                            ITS_Cost_Center__c						= CostCenter,
                                                                                            Project_Background__c					='dsfdfgfghhgh',
                                                                                            Executive_Summary__c					='sfdfggdfgfgfh',
                                                                                            Describe_goals_and_objectives__c		='ffdgffghfgh',
                                                                                            Project_Justification__c				='sfffggggdd',
                                                                                            Scope_Considerations__c					='fffgfgg',
                                                                                            Short_Term_Benefits__c					='sddddgfgdg',
                                                                                            Long_Term_Benefits__c					='dfgfgfdgdg',
                                                                                            Request_Status__c						='Draft',
                                                                                            Approval_Status__c						='Pending',
                                                                                            Check_if_project_is_approved__c			=true,
                                                                                            RecordTypeId=intakeRecTypeId);
        insert intakeSingleMasterRequestNull;
        intakeSingleMasterRequestNull.Request_Status__c 						= 'Complete';
        intakeSingleMasterRequestNull.Approval_Status__c						= 'Approved';
        intakeSingleMasterRequestNull.Total_Combined_External_Labor_Hours__c 	= null;
        intakeSingleMasterRequestNull.Total_Combined_Internal_Labor_Hours__c 	= null;
        intakeSingleMasterRequestNull.Approved_Total_Hours__c    		    	= null;
        intakeSingleMasterRequestNull.Approved_External_ITS_Hours__c   		 	= null; 
        
        
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        update intakeSingleMasterRequestNull;
        
        TPO_Project_Portfolio__c changeRequestRecord4=new TPO_Project_Portfolio__c(Requester_Name__c                            =userId.id,
                                                                                   CR__c                                        ='1',
                                                                                   Change_Request_Submission_Date__c            =Date.newInstance(2019, 08, 08),
                                                                                   Change_Classification__c                     ='Budget',
                                                                                   Description_of_Proposed_Change__c            ='dvfvdfdfdfdffd',
                                                                                   Impact_Risks_if_Change_RequestUnapproved__c  ='vddffgddggdgff',
                                                                                   Request_ID_Request_Name__c                   =intakeSingleMasterRequestNull.id,
                                                                                   Approval_Needed_By__c                        =system.Date.today(),
                                                                                   Request_Status__c                            ='Complete',
                                                                                   Approval_Status__c 							='Approved',
                                                                                  Primary_ISC__c 								= PrimaryISC,
                                                                                  IT_Advisor__c 								= itAdvisor,
                                                                                  ISC_Project_Manager1__c						=ISCProjectManager,
                                                                                   Additional_Requested_Software_Amount__c      =2500,
                                                                                   Additional_Requested_HW_Maintenance_Amt__c   =100,
                                                                                   RecordTypeId                                 =changeRequestRecTypeId, 
                                                                                   AdditionalRequested_Opex_Internal_ITS_LH__c  =1000,
                                                                                   AdditionalRequested_Opex_External_ITS_LH__c  =500);
        ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake=true;
        insert changeRequestRecord4; 

        test.stopTest();
        
        
    }
}