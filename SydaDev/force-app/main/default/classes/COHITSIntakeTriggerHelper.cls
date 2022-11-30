/*
* 
* Larry Kiang
* City of Hope 
* Copyright (c) 2019 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/

public class COHITSIntakeTriggerHelper 

{/* Deactivated LK 04/16/2020
    public static void calculateTotalRemaining(List<TPO_Project_Portfolio__c> ITSProjectIntakeList)
    {       
        if(ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake){
            ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake = false;
            String ApproveStatus = 'Approved';
            Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Project Change Request').getRecordTypeId();
            Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId(); 
            List<id> ParentIDSubRequests = new List <id>();
            List<id> ParentIDChangeRequests = new List <id>();
            List<id> MasterID = new List<id>();
            
            
            //group the records by the different recordtypes for project Initiation
            //Initiation, Project Change Request, SubRequest.
            for(TPO_Project_Portfolio__c SubmittedTPO : ITSProjectIntakeList)
            {
                if(submittedTPO.Parent_Request__c !=null && submittedTPO.Approval_Status__c == 'Approved')
                {
                    ParentIDSubrequests.add(SubmittedTPO.Parent_Request__c);
                    system.debug('Sub Request added');
                }
                if(submittedTPO.Request_ID_Request_Name__c !=null && submittedTPO.Approval_Status__c == 'Approved')
                { 
                    ParentIDChangeRequests.add(SubmittedTPO.Request_ID_Request_Name__c);
                    system.debug('ChangeRequest added : ' + ParentIDChangeRequests);
                }
                if(SubmittedTPO.Request_ID_Request_Name__c ==null && SubmittedTPO.Parent_Request__c==null && submittedTPO.Approval_Status__c == 'Approved')
                {
                    MasterID.add(SubmittedTPO.ID);
                    system.debug('MasterID added: ' + MasterID);
                }
            }
            //Query to find the Parent Request
            List<TPO_Project_Portfolio__c> masterRequest            = [Select id, 
                                                                       Name,
                                                                       Total_Approved_Capex_Budget_IT__c,
                                                                       Total_Approved_Opex_Budget_IT__c, 
                                                                       Total_Remaining_CAPEX_Budget__c,
                                                                       Total_Remaining_OPEX_Budget__c,
                                                                       Approved_External_IT_Labor_Hours_Year1C__c,
                                                                       Approved_Internal_IT_Labor_Hours_Year_1__c,
                                                                       Approved_Total_Hours__c,
                                                                       Approved_External_ITS_Hours__c,
                                                                       Total_Combined_Internal_Labor_Hours__c,
                                                                       Total_Combined_External_Labor_Hours__c
                                                                       from TPO_Project_Portfolio__c 
                                                                       where id in: ParentIDChangeRequests
                                                                       or id in: ParentIDSubrequests 
                                                                       or id in:MasterID
                                                                      ];
            //Query to find all Change Request records
            List<TPO_Project_Portfolio__c> crChildRequests		     = [Select id, 
                                                                        name,
                                                                        Total_Additional_Requested_Capex_Budg_IT__c, 
                                                                        Total_Add_Requested_Opex_Budget_IT_CR__c,
                                                                        Total_Approved_CR_Capex_Budget__c,
                                                                        Total_Approved_CR_Opex_Budget__c,
                                                                        Approved_CR_External_IT_Hrs_Yr_1_Capex__c,
                                                                        Approved_CR_External_IT_Hrs_Yr_1_Opex__c,
                                                                        Approved_CR_Internal_IT_Hrs_Yr_1_Opex__c,
                                                                        Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c,
                                                                        Request_ID_Request_Name__c
                                                                        from TPO_Project_Portfolio__c 
                                                                        where 
                                                                        (Request_ID_Request_Name__c IN:ParentIDChangeRequests 
                                                                         or Request_ID_Request_Name__c IN:ParentIDSubrequests
                                                                         or Request_ID_Request_Name__c IN:MasterID) 
                                                                        and id NOT IN:masterRequest
                                                                       ];
            List <TPO_Project_Portfolio__c> subChildRequests	    = [Select id,
                                                                       name,
                                                                       Total_Approved_Capex_Budget_IT__c, 
                                                                       Total_Approved_Opex_Budget_IT__c,
                                                                       Approved_Total_Hours__c,
                                                                       Approved_Internal_IT_Labor_Hours_Year_1__c,
                                                                       Approved_External_ITS_Hours__c,
                                                                       Approved_External_IT_Labor_Hours_Year1C__c,
                                                                       Parent_Request__c
                                                                       from TPO_Project_Portfolio__c 
                                                                       where (Parent_Request__c IN:ParentIDChangeRequests or 
                                                                              Parent_Request__c IN:ParentIDSubrequests or 
                                                                              Parent_Request__c IN: MasterID)
                                                                       and id NOT IN:masterRequest
                                                                      ];
            List <TPO_Project_Portfolio__c> listOfTPOToUpdate = new List <TPO_Project_Portfolio__c>(); 
            for(TPO_Project_Portfolio__c SelectedTPO:masterRequest){
                if (SelectedTPO.Approved_Total_Hours__c==null||
                    SelectedTPO.Approved_Internal_IT_Labor_Hours_Year_1__c==null||
                    SelectedTPO.Approved_External_ITS_Hours__c==null||
                    SelectedTPO.Approved_External_IT_Labor_Hours_Year1C__c==null){
                        if(SelectedTPO.Approved_Total_Hours__c==null){
                            SelectedTPO.Approved_Total_Hours__c= 0;
                        }
                        if(SelectedTPO.Approved_Internal_IT_Labor_Hours_Year_1__c==null){
                            SelectedTPO.Approved_Internal_IT_Labor_Hours_Year_1__c= 0;
                        }
                        if(SelectedTPO.Approved_External_ITS_Hours__c==null){
                            SelectedTPO.Approved_External_ITS_Hours__c= 0;
                        }
                        if(SelectedTPO.Approved_External_IT_Labor_Hours_Year1C__c==null){
                            SelectedTPO.Approved_External_IT_Labor_Hours_Year1C__c = 0; 
                        }
                    }
              //Calculations for Master Request without child records.
                if(subChildRequests.size()	==0 && crChildRequests.size()==0){
                    SelectedTPO.Total_Combined_Internal_Labor_Hours__c 	= SelectedTPO.Approved_Total_Hours__c
                        												+ SelectedTPO.Approved_Internal_IT_Labor_Hours_Year_1__c;
                    SelectedTPO.Total_Combined_External_Labor_Hours__c  = SelectedTPO.Approved_External_ITS_Hours__c
                        												+ SelectedTPO.Approved_External_IT_Labor_Hours_Year1C__c;                    
                    SelectedTPO.Total_Remaining_CAPEX_Budget__c 	   	= SelectedTPO.Total_Approved_Capex_Budget_IT__c;
                    SelectedTPO.Total_Remaining_OPEX_Budget__c			= SelectedTPO.Total_Approved_Opex_Budget_IT__c;
                    listofTPOToUpdate.add(SelectedTPO);
                }
                else {
                    Decimal dTotalExternalLaborHoursForChildChangeRequests  = 0; 
                    Decimal dTotalInternalLaborHoursForChildChangeRequests  = 0;
                    Decimal dTotalExternalLaborHoursForChildRequests        = 0;
                    Decimal dTotalInternalLaborHoursForChildRequests        = 0;
                    Decimal dTotalApprovedCAPEXBudgetForChildChangeRequests = 0;
                    Decimal dTotalApprovedOPEXBudgetForChildChangeRequests  = 0;
                    Decimal dTotalApprovedCAPEXBudgetForChildRequests       = 0;
                    Decimal dTotalApprovedOPEXBudgetForChildRequests        = 0;
                    for (TPO_Project_Portfolio__c SelectedcrChildRequests: crChildRequests){
                        if(SelectedTPO.Id == SelectedcrChildRequests.Request_ID_Request_Name__c){  
                            dTotalApprovedCAPEXBudgetForChildChangeRequests += SelectedcrChildRequests.Total_Approved_CR_Capex_Budget__c;
                            dTotalApprovedOPEXBudgetForChildChangeRequests += SelectedcrChildRequests.Total_Approved_CR_Opex_Budget__c;
                            if(SelectedcrChildRequests.Approved_CR_External_IT_Hrs_Yr_1_Capex__c != null){
                                dTotalExternalLaborHoursForChildChangeRequests += SelectedcrChildRequests.Approved_CR_External_IT_Hrs_Yr_1_Capex__c;
                            }
                            if(SelectedcrChildRequests.Approved_CR_External_IT_Hrs_Yr_1_Opex__c != null){
                                dTotalExternalLaborHoursForChildChangeRequests += SelectedcrChildRequests.Approved_CR_External_IT_Hrs_Yr_1_Opex__c;
                            }
                            if(SelectedcrChildRequests.Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c != null){
                                dTotalInternalLaborHoursForChildChangeRequests += SelectedcrChildRequests.Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c;
                            }
                            if(SelectedcrChildRequests.Approved_CR_Internal_IT_Hrs_Yr_1_Opex__c != null){
                                dTotalInternalLaborHoursForChildChangeRequests += SelectedcrChildRequests.Approved_CR_Internal_IT_Hrs_Yr_1_Opex__c;
                            }
                        }
                    }
                    for (TPO_Project_Portfolio__c selectedSubChildRequests :subChildRequests){
                        if(SelectedTPO.Id == SelectedSubChildRequests.Parent_Request__c){          
                            dTotalApprovedCAPEXBudgetForChildRequests += selectedSubChildRequests.Total_Approved_Capex_Budget_IT__c;
                            dTotalApprovedOPEXBudgetForChildRequests  += selectedSubChildRequests.Total_Approved_Opex_Budget_IT__c ;
                            if(selectedSubChildRequests.Approved_External_ITS_Hours__c!=null){
                                dTotalExternalLaborHoursForChildRequests  += selectedSubChildRequests.Approved_External_ITS_Hours__c;
                            }
                            if(selectedSubChildRequests.Approved_External_IT_Labor_Hours_Year1C__c !=null){
                                dTotalExternalLaborHoursForChildRequests += selectedSubChildRequests.Approved_External_IT_Labor_Hours_Year1C__c;
                            }
                            if(selectedSubChildRequests.Approved_Total_Hours__c!=null){
                                dTotalInternalLaborHoursForChildRequests  += selectedSubChildRequests.Approved_Total_Hours__c;
                            }
                            if(selectedSubChildRequests.Approved_Internal_IT_Labor_Hours_Year_1__c != null){
                                dTotalInternalLaborHoursForChildRequests += selectedSubChildRequests.Approved_Internal_IT_Labor_Hours_Year_1__c;
                            }
                        }
                    }
                    SelectedTPO.Total_Remaining_CAPEX_Budget__c         = SelectedTPO.Total_Approved_Capex_Budget_IT__c 
                                                                        + dTotalApprovedCAPEXBudgetForChildChangeRequests 
                                                                        - dTotalApprovedCAPEXBudgetForChildRequests;
                    SelectedTPO.Total_Remaining_OPEX_Budget__c          = SelectedTPO.Total_Approved_Opex_Budget_IT__c  
                                                                        + dTotalApprovedOPEXBudgetForChildChangeRequests 
                                                                        - dTotalApprovedOPEXBudgetForChildRequests;
                    
                    SelectedTPO.Total_Combined_External_Labor_Hours__c  = SelectedTPO.Approved_External_ITS_Hours__c
                                                                        + SelectedTPO.Approved_External_IT_Labor_Hours_Year1C__c
                                                                        + dTotalExternalLaborHoursForChildChangeRequests
                                                                        - dTotalExternalLaborHoursForChildRequests;    
         
                    SelectedTPO.Total_Combined_Internal_Labor_Hours__c  = SelectedTPO.Approved_Total_Hours__c
                                                                        + SelectedTPO.Approved_Internal_IT_Labor_Hours_Year_1__c		
                                                                        + dTotalInternalLaborHoursForChildChangeRequests
                                                                        - dTotalInternalLaborHoursForChildRequests;                                                                                          
                    listOfTPOToUpdate.add(SelectedTPO);
                }
            }
        update listOfTPOToUpdate;
        }
    }
*/
    
    public static void copyRequestedBudgetToApprovedBudget(List<TPO_Project_Portfolio__c> intakeRequests){
        List<TPO_Project_Portfolio__c> updateRecs=new List<TPO_Project_Portfolio__c>();
        List<TPO_Project_Portfolio__c>RecordtoProcess = New List<TPO_Project_Portfolio__c>();
        Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        Id changeRequestRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Change Request').getRecordTypeId();        
        for(TPO_Project_Portfolio__c intakeRequest:intakeRequests){
            if(intakeRequest.Record_Type_Name__c == 'Initiation'){
                updateRecs.add(new TPO_Project_Portfolio__c(id=intakeRequest.id,
                                                            Approved_Total_Hours__c=intakeRequest.Internal_IT_Labor_Hours_Year_1_Capex__c,
                                                            Approved_Internal_IT_Labor_Hours_Year_1__c=intakeRequest.AdditionalRequested_Opex_Internal_ITS_LH__c,
                                                            Approved_External_IT_Labor_Hours_Year1C__c=intakeRequest.Additional_Requested_Capex_TS_Hours__c,
                                                            Approved_External_ITS_Hours__c=intakeRequest.AdditionalRequested_Opex_External_ITS_LH__c,
                                                            Approved_Managed_Svcs_Hrs_Yr_1_Capex__c =intakeRequest.Requested_Managed_Svcs_Hrs_Yr_1_Capex__c,
                                                            Approved_Managed_Svcs_Hrs_Yr_1_Opex__c =intakeRequest.Requested_Managed_Svcs_Hrs_Yr_1_Opex__c,
                                                            Approved_Total_Hrs_Yr_2__c = intakeRequest.Requested_Total_Hrs_Yr_2__c,
                                                            Approved_Total_Hrs_Yr_3__c = intakeRequest.Requested_Total_Hrs_Yr_3__c,
                                                            Approved_Internal_Cost_Yr_1_Capex__c  = intakeRequest.Requested_Internal_Cost_Yr_1_Capex__c,
                                                            Approved_Pro_Services_Cost_Yr1_Capex__c=intakeRequest.Capex_Temp_Staffing_Amount__c,
                                                            Approved_Consulting_Cost_Year_1_Opex__c=intakeRequest.Additional_Requested_Opex_Consult_Amount__c,
                                                            Approved_Hardware_Cost_Year_1_Capex__c=intakeRequest.Additional_Requested_Hardware_Amount__c,
                                                            Approved_Hardware_Maint_Cost_Yr1_Opex__c=intakeRequest.Additional_Requested_HW_Maintenance_Amt__c,
                                                            Approved_Software_License_Cost_Yr1_Capex__c=intakeRequest.Additional_Requested_Software_Amount__c,
                                                            Approved_Software_Maint_Cost_Yr1_Opex__c=intakeRequest.Additional_Requested_SW_Maintenance_Amt__c,
                                                            Approved_Contingency_Year_1_Capex__c=intakeRequest.Additional_Requested_Contingency_Amt__c,
                                                            Approved_Contingency_Year_1_Opex__c=intakeRequest.Contingency_Year_1_Opex__c,
                                                            Approved_SaaS_Rmt_Host_Cost_Yr1_Opex__c=intakeRequest.AdditionalRequested_SaaS_Remote_HostAmt__c,
                                                            Approved_CAPEX_Year_2__c=intakeRequest.Requested_CAPEX_Year_2__c,
                                                            Approved_OPEX_Year_2__c=intakeRequest.Requested_OPEX_Year_2__c,
                                                            Approved_CAPEX_Year_3__c=intakeRequest.Requested_CAPEX_Year_3__c,
                                                            Approved_OPEX_Year_3__c=intakeRequest.Requested_OPEX_Year_3__c,
                                                            RecordTypeId=intakeRecTypeId));
            }
            if(intakeRequest.Record_Type_Name__c =='Change Request'){
                updateRecs.add(new TPO_Project_Portfolio__c(id=intakeRequest.Id,
                                                            Approved_CR_Internal_IT_Hrs_Yr_1_Capex__c =intakeRequest.Internal_IT_Labor_Hours_Year_1_Capex__c,
                                                            Approved_CR_Internal_IT_Hrs_Yr_1_Opex__c	=intakeRequest.AdditionalRequested_Opex_Internal_ITS_LH__c,
                                                            Approved_CR_External_IT_Hrs_Yr_1_Capex__c =intakeRequest.Additional_Requested_Capex_TS_Hours__c,
                                                            Approved_CR_External_IT_Hrs_Yr_1_Opex__c =intakeRequest.AdditionalRequested_Opex_External_ITS_LH__c,
                                                            Approved_CR_Managed_Svc_Hrs_Yr_1_Capex__c =intakeRequest.Requested_Managed_Svcs_Hrs_Yr_1_Capex__c, 
                                                            Approved_CR_Managed_Svcs_Hrs_Yr_1_Opex__c =intakeRequest.Requested_Managed_Svcs_Hrs_Yr_1_Opex__c,
                                                            Approved_CR_Total_Hrs_Yr_2__c = intakeRequest.Requested_Total_Hrs_Yr_2__c,
                                                            Approved_CR_Total_Hrs_Yr_3__c = intakeRequest.Requested_Total_Hrs_Yr_3__c,
                                                            Approved_CR_Internal_Cost_Yr_1_Capex__c = intakeRequest.Requested_Internal_Cost_Yr_1_Capex__c,
                                                            Approved_CR_Prof_Svcs_Cost_Yr_1_Capex__c =intakeRequest.Capex_Temp_Staffing_Amount__c,
                                                            Approved_CR_Consulting_Cost_Yr_1_Opex__c =intakeRequest.Additional_Requested_Opex_Consult_Amount__c,
                                                            Approved_CR_Hardware_Cost_Yr_1_Capex__c =intakeRequest.Additional_Requested_Hardware_Amount__c,
                                                            Approved_CR_Hardware_Mtc_Cost_Yr_1_Opex__c =intakeRequest.Additional_Requested_HW_Maintenance_Amt__c,
                                                            Approved_CR_Software_Cost_Yr_1_Capex__c =intakeRequest.Additional_Requested_Software_Amount__c,
                                                            Approved_CR_Software_Mtc_Cost_Yr_1_Opex__c =intakeRequest.Additional_Requested_SW_Maintenance_Amt__c,
                                                            Approved_CR_Contingency_Yr_1_Capex__c =intakeRequest.Additional_Requested_Contingency_Amt__c,
                                                            Approved_CR_Contingency_Yr_1_Opex__c =intakeRequest.Contingency_Year_1_Opex__c,
                                                            Approved_CR_SaaS_Cost_Yr_1_Opex__c =intakeRequest.AdditionalRequested_SaaS_Remote_HostAmt__c,
                                                            Approved_CR_Capex_Budget_Yr_2__c =intakeRequest.Requested_CAPEX_Year_2__c,
                                                            Approved_CR_Opex_Budget_Yr_2__c =intakeRequest.Requested_OPEX_Year_2__c,
                                                            Approved_CR_Capex_Budget_Yr_3__c =intakeRequest.Requested_CAPEX_Year_3__c,
                                                            Approved_CR_Opex_Budget_Yr_3__c =intakeRequest.Requested_OPEX_Year_3__c,
                                                            RecordTypeId=changeRequestRecTypeId));
            }
        }  
        update updateRecs;
    }
}