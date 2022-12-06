/*
* This trigger processes AM_Evaluation_Request object.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*/

trigger COH_AM_Evaluation_Request on AM_Evaluation_Request__c (before insert,before update) {
     for(AM_Evaluation_Request__c a:trigger.new){                                                                            
        if(a.Patient_Account_Country__c !=null && a.Patient_Account_Country__c !=''){
            a.Patient_Account_Country_DB__c = a.Patient_Account_Country__c;
            a.Patient_Account_Country__c = '';
        }
        if(a.Patient_Account_State__c !=null && a.Patient_Account_State__c !=''){
            a.Patient_Account_State_DB__c = a.Patient_Account_State__c;
            a.Patient_Account_State__c = '';
        }
        
        if(a.Request_Type__c !=null && a.Request_Type__c !=''){
            a.Request_Type_DB__c = a.Request_Type__c;
            a.Request_Type__c = '';
        }
         if(a.Medical_Carrier_Options__c !=null && a.Medical_Carrier_Options__c !=null){
            a.Medical_Carrier_DB__c = a.Medical_Carrier_Options__c;
            a.Medical_Carrier_Options__c = '';
        }
         if(a.Medical_Carrier_DB__c !=null && a.Medical_Carrier_DB__c !=''){
            a.Benefit_Status__c = 'Enrolled';
        } else {
            a.Benefit_Status__c = 'Non-Enrolled';
        }
        if(a.Treating_Physician_State__c !=null && a.Treating_Physician_State__c !=''){
            a.Treating_Physician_State_DB__c = a.Treating_Physician_State__c;
            a.Treating_Physician_State__c = '';
        }
        if(a.Treating_Physician_2_State__c !=null && a.Treating_Physician_2_State__c !=''){
            a.Treating_Physician_2_State_DB__c = a.Treating_Physician_2_State__c;
            a.Treating_Physician_2_State__c = '';
        }
        if(a.Virtual_Request_Type_1__c !=null && a.Virtual_Request_Type_1__c !=''){
            a.Virtual_Request_Type_1_DB__c = a.Virtual_Request_Type_1__c;
            a.Virtual_Request_Type_1__c = '';
        }
        if(a.Virtual_Request_Type_2__c !=null && a.Virtual_Request_Type_2__c !=''){
            a.Virtual_Request_Type_2_DB__c = a.Virtual_Request_Type_2__c;
            a.Virtual_Request_Type_2__c = '';
        }
        if(a.Type_of_Request__c !=null && a.Type_of_Request__c !=''){
            a.Type_of_Request_DB__c = a.Type_of_Request__c;
            a.Type_of_Request__c = '';
        }
        if(a.Area_of_Cost_Savings__c !=null && a.Area_of_Cost_Savings__c !=''){
            String areaCostString = a.Area_of_Cost_Savings__c;
            List<String> listOFAreaCostString = areaCostString.split(';');
            a.Area_of_Cost_Savings_DB__c=String.join(listOFAreaCostString,'\n');
            a.Area_of_Cost_Savings__c = '';
        }
         if(a.Humanistic_Determination__c !=null && a.Humanistic_Determination__c !=''){
             string HumanisticDeterminationString = a.Humanistic_Determination__c;
             List<String> listOfHumanisticDetermination = HumanisticDeterminationString.split(';');
             a.Humanistic_Outcomes_DB__c = String.join(listOfHumanisticDetermination, '\n');
             a.Humanistic_Determination__c = '';
         }
         if(a.Appropriate_Use_of_Healthcare__c !=null && a.Appropriate_Use_of_Healthcare__c !=''){
             string AppropriateUseOfHealthcareString = a.Appropriate_Use_of_Healthcare__c;
             List<String> listOfAppropriateUseOfHealthcare = AppropriateUseOfHealthcareString.split(';');
             a.Appropriate_Use_of_Healthcare_DB__c = String.join(listOfAppropriateUseOfHealthcare, '\n');
             a.Appropriate_Use_of_Healthcare__c = '';
         }
        if(a.Effective_Communication_CareCoordinate__c !=null && a.Effective_Communication_CareCoordinate__c !=''){
            String effectiveCommunicationCareCoordinateString = a.Effective_Communication_CareCoordinate__c;
            List<String> ListOfEffectiveCommunicationCareCoordinateString = effectiveCommunicationCareCoordinateString.split(';');
            a.Effective_Communication_CareCoordinat_DB__c=String.join(ListOfEffectiveCommunicationCareCoordinateString,'\n');
            a.Effective_Communication_CareCoordinate__c = '';
        }
        if(a.Financial_Alignment_ROI__c !=null && a.Financial_Alignment_ROI__c !=''){
            String financialAlignmentROI = a.Financial_Alignment_ROI__c;
            List<String> ListOfFinancialAlignmentROI = financialAlignmentROI.split(';');
            a.Financial_Alignment_ROI_DB__c = String.join(ListOfFinancialAlignmentROI,'\n');
            a.Financial_Alignment_ROI__c = '';
        }
        if(a.Impact_of_Decision__c !=null && a.Impact_of_Decision__c !=''){
            String impactOfDecision = a.Impact_of_Decision__c;
            List<String> ListOfImpactOfDecision = impactOfDecision.split(';');
            a.Impact_of_Decision_DB__c = String.join(ListOfImpactOfDecision,'\n');
            a.Impact_of_Decision__c = '';
        }
        if(a.Improved_Customer_Experience__c !=null && a.Improved_Customer_Experience__c !=''){
            String improvedCustomerExperience = a.Improved_Customer_Experience__c;
            List<String> ListOfImprovedCustomerExperience = improvedCustomerExperience.split(';');
            a.Improved_Customer_Experience_DB__c = String.join(ListOfImprovedCustomerExperience,'\n');
            a.Improved_Customer_Experience__c = '';
        }
        if(a.Personalized_Patient_Care__c !=null && a.Personalized_Patient_Care__c !=''){
            String personalizedPatientCare = a.Personalized_Patient_Care__c;
            List<String> ListOfPersonalizedPatientCare = personalizedPatientCare.split(';');
            a.Personalized_Patient_Care_DB__c = String.join(ListOfPersonalizedPatientCare,'\n');            
            a.Personalized_Patient_Care__c = '';
        }
        if(a.Preventable_Healthcare_Harm__c !=null && a.Preventable_Healthcare_Harm__c!=''){
            String preventableHealthcareHarm = a.Preventable_Healthcare_Harm__c;
            List<String> ListOfPersonalizedPatientCare = preventableHealthcareHarm.split(';');
            a.Preventable_Healthcare_Harm_DB__c = String.join(ListOfPersonalizedPatientCare,'\n');
            a.Preventable_Healthcare_Harm__c = '';
        }
        if(a.Purpose_of_Call__c !=null && a.Purpose_of_Call__c!=''){
            string PurposeOfCall = a.Purpose_of_Call__c;
            list<string> ListOfPurposeOfCall = PurposeOfCall.split(';');
            a.Purpose_of_Call_DB__c = string.join(ListOfPurposeOfCall, '\n');
            a.Purpose_of_Call__c = '';
        }
         if(a.Outcome_Of_Review__c !=null && a.Outcome_Of_Review__c!=''){
             string OutcomeOfReview = a.Outcome_Of_Review__c;
             list<string> ListOfOutcomeOfReview = OutcomeOfReview.split(';');
             a.Outcome_Of_Review_DB__c = string.join(ListOfOutcomeOfReview, '\n');
             a.Outcome_Of_Review__c = '';
         }
        if(a.Priority__c !=null && a.Priority__c!=''){
            a.Priority_DB__c = a.Priority__c;
            a.Priority__c = '';
        }
        if(a.Cancer_Diagnosis__c !=null && a.Cancer_Diagnosis__c!=''){
            a.Cancer_Diagnosis_DB__c = a.Cancer_Diagnosis__c;
            a.Cancer_Diagnosis__c = '';
        }
        if(a.ICD_10_Code_s__c !=null && a.ICD_10_Code_s__c!=''){
            a.ICD_10_Code_s_DB__c = a.ICD_10_Code_s__c;
            a.ICD_10_Code_s__c = '';
        }
        if(a.Call_Time_1__c !=null && a.Call_Time_1__c!=''){
            a.Call_Time_1_DB__c = a.Call_Time_1__c;
            a.Call_Time_1__c = '';
        }
        if(a.Call_Time_2__c !=null && a.Call_Time_2__c!=''){
            a.Call_Time_2_DB__c = a.Call_Time_2__c;
            a.Call_Time_2__c = '';
        }
        if(a.Call_Time_3__c !=null && a.Call_Time_3__c!=''){
            a.Call_Time_3_DB__c = a.Call_Time_3__c;
            a.Call_Time_3__c = '';
        }
        if(a.Call_Re_scheduled__c !=null && a.Call_Re_scheduled__c!=''){
            a.Call_Re_scheduled_DB__c = a.Call_Re_scheduled__c;
            a.Call_Re_scheduled__c = '';
        }
        if(a.Member_Reached__c !=null && a.Member_Reached__c !=''){
            a.Member_Reached_DB__c = a.Member_Reached__c;
            a.Member_Reached__c = '';
        }
        if(a.CSL_Call_Resolution__c !=null && a.CSL_Call_Resolution__c !=''){
            string CSLCallResolution = a.CSL_Call_Resolution__c;
            list<string> ListOfCSLCallResolution = CSLCallResolution.split(';');
            a.CSL_Call_Resolution_DB__c = string.join(ListOfCSLCallResolution, '\n');
            a.CSL_Call_Resolution__c = '';
        }
        if(a.Close_Reason__c !=null && a.Close_Reason__c !=''){
            a.Close_Reason_DB__c = a.Close_Reason__c;
            a.Close_Reason__c = '';
        }
         //if(a.HIPAA_Consent_Form_submitted__c == true){
           //  a.Date_HIPAA_Consent_Form_submitted__c = system.now();
        // }
    }
    public set<String> patientNames=new set<String>();
     for (AM_Evaluation_Request__c amevalRequestObj : Trigger.new){
         
         if (Trigger.isUpdate && amevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(amevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
             string typeofRequestObj = amevalRequestObj.Type_of_Request_DB__c;
             if(typeofRequestObj == 'Test Recommendations'){
              if((amevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 7);
                }
                Else
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 8);  
                }
             }
             else if(typeofRequestObj == 'APO Expert Written Report'){
               if((amevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 3);
                }
                Else
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             }
             else if(typeofRequestObj == 'Enhanced Interpretation Review'){
               if((amevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 5);
                }
                Else
                {
                    amevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), 6);  
                }  
             }
                             
         }
          // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(amevalRequestObj.NP_Triage_Date_Time__c!=null && amevalRequestObj.Report_Sent_to_AM_Date_Time__c!=null){
            
            amevalRequestObj.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            amevalRequestObj.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(amevalRequestObj.NP_Triage_Date_Time__c.date(), amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date()));*/
            System.debug('' + amevalRequestObj.Days_Between_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>(); 
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = amevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = amevalRequestObj.Report_Sent_to_AM_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime NPTriageDate=amevalRequestObj.NP_Triage_Date_Time__c;//amevalRequestObj
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=amevalRequestObj.Report_Sent_to_AM_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(amevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(amevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            amevalRequestObj.Days_Between_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + amevalRequestObj.Days_Between_NP_Triage_Report_Sent__c);
            //Convert Days_Between_NP_Triage_Report_Sent__c to double.
        }
          
          //Report_Sent_to_AM_Date_Time__c
        if(amevalRequestObj.Submitted_for_Review_Date_Time__c!=null && amevalRequestObj.Report_Sent_to_AM_Date_Time__c!=null){
            
           //Days_Btw_Submitted_Report_Sent__c
            amevalRequestObj.Days_Btw_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(amevalRequestObj.Submitted_for_Review_Date_Time__c.date(), amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date()));
            //System.debug('' + amevalRequestObj.Days_Btw_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = amevalRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = amevalRequestObj.Report_Sent_to_AM_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=amevalRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=amevalRequestObj.Report_Sent_to_AM_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(amevalRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(amevalRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(amevalRequestObj.Report_Sent_to_AM_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            amevalRequestObj.Days_Btw_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + amevalRequestObj.Days_Btw_Submitted_Report_Sent__c);
            //Convert Days_Btw_Submitted_Report_Sent__c to double.
        }
         
    }
    
    /*if(trigger.isBefore && trigger.isInsert){
        
        for (AM_Evaluation_Request__c amevalRequestObj1 : [select id,name,Account_Name__c from AM_Evaluation_Request__c where Account_Name__c!=null AND  LastModifiedDate=THIS_YEAR ]) {
            
            patientNames.add(amevalRequestObj1.Account_Name__c);
        }
        
        for (AM_Evaluation_Request__c amevalRequestObj2 : trigger.new){
            
            if(patientNames.contains(amevalRequestObj2.Account_Name__c)){
                
                amevalRequestObj2.Exclude_From_Report__c=true;
                
            }
        }
        
    }*/
         
}