/*
* This trigger processes SY_Evaluation_Request object.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*/
trigger COH_SY_Evaluation_Request on SY_Evaluation_Request__c (before insert,before update) {
    public set<String> patientNames=new set<String>();
      for (SY_Evaluation_Request__c SYevalRequestObj : Trigger.new) {
         
         if (Trigger.isUpdate && SYevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(SYevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
             string typeofRequestObj = SYevalRequestObj.Type_of_Request__c;
             if(typeofRequestObj == 'Complex/non-complex Case Reviews (EAR, APO)'){
              if((SYevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }
             }
            /* else if(typeofRequestObj == 'Test Request Review'){
               if((SYevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             }
             else if(typeofRequestObj == 'Enhanced Interpretation Review'){
               if((SYevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    SYevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             } */
         }else{}
          // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(SYevalRequestObj.NP_Triage_Date_Time__c!=null && SYevalRequestObj.Report_Sent_Date_Time__c!=null){
            
            SYevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), SYevalRequestObj.Report_Sent_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            SYevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(SYevalRequestObj.NP_Triage_Date_Time__c.date(), SYevalRequestObj.Report_Sent_Date_Time__c.date()));*/
            System.debug('' + SYevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>(); 
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = SYevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = SYevalRequestObj.Report_Sent_Date_Time__c.hour();  
            Double iTimeDiff;
            DateTime NPTriageDate=SYevalRequestObj.NP_Triage_Date_Time__c;//SYevalRequestObj
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=SYevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(SYevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(SYevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(SYevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(SYevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            SYevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + SYevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Convert Days_B_W_NP_Triage_Report_Sent__c to double.
        }
          
          //Report_Sent_Date_Time__c
        if(SYevalRequestObj.Submitted_for_Review_Date_Time__c!=null && SYevalRequestObj.Report_Sent_Date_Time__c!=null){
            
           //Days_Between_Submitted_Report_Sent__c
            SYevalRequestObj.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(SYevalRequestObj.Submitted_for_Review_Date_Time__c.date(), SYevalRequestObj.Report_Sent_Date_Time__c.date()));
            //System.debug('' + hdevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = SYevalRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = SYevalRequestObj.Report_Sent_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=SYevalRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=SYevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(SYevalRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(SYevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(SYevalRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(SYevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            SYevalRequestObj.Days_Between_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + SYevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Convert Days_Between_Submitted_Report_Sent__c to double.
        }
         
    }
    
    //if(trigger.isBefore && trigger.isInsert){
        
        //for (COH_Evaluation_Request__c hdevalRequestObj1 : [select id,name,COH_Account__c from COH_Evaluation_Request__c where COH_Account__c!=null AND  LastModifiedDate=THIS_YEAR ]) {
            
         //   patientNames.add(hdevalRequestObj1.COH_Account__c);
       // }
        
       // for (COH_Evaluation_Request__c hdevalRequestObj2 : trigger.new){
            
         //   if(patientNames.contains(hdevalRequestObj2.COH_Account__c)){
                
           //     hdevalRequestObj2.Exclude_From_Report_1__c=true;
                
           // }
       // }
        
    //}
    
}