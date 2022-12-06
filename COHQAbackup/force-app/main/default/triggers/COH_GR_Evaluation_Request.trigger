/*
* This trigger processes GR_Evaluation_Request__c object.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*/

trigger COH_GR_Evaluation_Request on GR_Evaluation_Request__c (before insert,before update) {
    public set<String> patientNames=new set<String>();
      for (GR_Evaluation_Request__c GRevalRequestObj : Trigger.new) {
         
         if (Trigger.isUpdate && GRevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(GRevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
             string typeofRequestObj = GRevalRequestObj.Type_of_Request__c;
             if(typeofRequestObj == 'Complex/non-complex Case Reviews (EAR, APO)'){
              if((GRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }
             }
             else if(typeofRequestObj == 'Test Request Review'){
               if((GRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             }
             else if(typeofRequestObj == 'Enhanced Interpretation Review'){
               if((GRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    GRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             }
         }else{}
          // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(GRevalRequestObj.NP_Triage_Date_Time__c!=null && GRevalRequestObj.Report_Sent_to_GR_Date_Time__c!=null){
            
            GRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            GRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(GRevalRequestObj.NP_Triage_Date_Time__c.date(), GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date()));*/
            System.debug('' + GRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>(); 
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = GRevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.hour();  
            Double iTimeDiff;
            DateTime NPTriageDate=GRevalRequestObj.NP_Triage_Date_Time__c;//GRevalRequestObj
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=GRevalRequestObj.Report_Sent_to_GR_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(GRevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(GRevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            GRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + GRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Convert Days_B_W_NP_Triage_Report_Sent__c to double.
        }
          
          //Report_Sent_to_GR_Date_Time__c
        if(GRevalRequestObj.Submitted_for_Review_Date_Time__c!=null && GRevalRequestObj.Report_Sent_to_GR_Date_Time__c!=null){
            
           //Days_Between_Submitted_Report_Sent__c
            GRevalRequestObj.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(GRevalRequestObj.Submitted_for_Review_Date_Time__c.date(), GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date()));
            //System.debug('' + GRevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = GRevalRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=GRevalRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=GRevalRequestObj.Report_Sent_to_GR_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(GRevalRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(GRevalRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(GRevalRequestObj.Report_Sent_to_GR_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            GRevalRequestObj.Days_Between_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + GRevalRequestObj.Days_Between_Submitted_Report_Sent__c);
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