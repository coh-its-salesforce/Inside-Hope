/*
* This trigger processes CH_Evaluation_Request object.
* 
* Saidaiah Surisetti
* City of Hope
* Copyright (c) 2018
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
trigger COH_CM_Evaluation_Request on CH_Evaluation_Request__c (before insert,before update) {
    
     for (CH_Evaluation_Request__c cmevalRequestObj : Trigger.new) {
         
         if (Trigger.isUpdate && cmevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(cmevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
            
             if((cmevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    cmevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    cmevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }
             
                /*Integer remainderOfDay;
                if(cmevalRequestObj.Date_coh_requests_additional_records2__c!=null){
                remainderOfDay = (cmevalRequestObj.NP_Triage_Date_Time__c).date().daysBetween((cmevalRequestObj.Date_coh_requests_additional_records2__c).date());
                }
                if((cmevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                   
                    cmevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), 3);
                    
                }
                Else if((cmevalRequestObj.NP_Triage_Date_Time__c).hour() > 16){
                    Date FinalDate=COH_EMP_Strategy_Util.AddBusinessDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                    Date FinalDateWithRemainder=COH_EMP_Strategy_Util.AddBusinessDays(FinalDate, remainderOfDay);
                    cmevalRequestObj.COH_Review_Due_Date__c = FinalDateWithRemainder;
                }
                Else if((cmevalRequestObj.NP_Triage_Date_Time__c).hour() < 16 && (cmevalRequestObj.Date_coh_requests_additional_records2__c).hour() > 16 ){
                    Date FinalDate=COH_EMP_Strategy_Util.AddBusinessDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                    Date FinalDateWithRemainder=COH_EMP_Strategy_Util.AddBusinessDays(FinalDate, remainderOfDay);
                    cmevalRequestObj.COH_Review_Due_Date__c = FinalDateWithRemainder;
                }
                Else
                {
                   
                }*/
         }
          if(cmevalRequestObj.NP_Triage_Date_Time__c!=null && cmevalRequestObj.Date_COH_Posts_REO__c!=null){
            
           cmevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(cmevalRequestObj.NP_Triage_Date_Time__c.date(), cmevalRequestObj.Date_COH_Posts_REO__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), evaluatioRequestObj.Date_COH_Posts_REO__c.date()));*/
            System.debug('' + cmevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour =cmevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = cmevalRequestObj.Date_COH_Posts_REO__c.hour();
            Double iTimeDiff;
            DateTime NPTriageDate=cmevalRequestObj.NP_Triage_Date_Time__c;
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=cmevalRequestObj.Date_COH_Posts_REO__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(cmevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(cmevalRequestObj.Date_COH_Posts_REO__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(cmevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(cmevalRequestObj.Date_COH_Posts_REO__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            cmevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + cmevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Convert Days_B_W_NP_Triage_Report_Sent__c to double.
        }
          if(cmevalRequestObj.Date_CM_Sends_Additional_Records__c!=null && cmevalRequestObj.Date_COH_Posts_REO__c!=null){
            
           
           cmevalRequestObj.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(cmevalRequestObj.Date_CM_Sends_Additional_Records__c.date(), cmevalRequestObj.Date_COH_Posts_REO__c.date()));
            //System.debug('' + evaluatioRequestObj.Days_Btw_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour =cmevalRequestObj.Date_CM_Sends_Additional_Records__c.hour();
            Double iReportSenthour = cmevalRequestObj.Date_COH_Posts_REO__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=cmevalRequestObj.Date_CM_Sends_Additional_Records__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=cmevalRequestObj.Date_COH_Posts_REO__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(cmevalRequestObj.Date_CM_Sends_Additional_Records__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(cmevalRequestObj.Date_COH_Posts_REO__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(cmevalRequestObj.Date_CM_Sends_Additional_Records__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(cmevalRequestObj.Date_COH_Posts_REO__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            cmevalRequestObj.Days_Between_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + cmevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Convert Days_Between_Submitted_Report_Sent__c to double.
        }
         
     }

}