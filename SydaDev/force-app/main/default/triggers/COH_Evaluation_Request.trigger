/*
* This Trigger for COH -Evaluation Request Object 
* 
* Balaji Rao
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/

trigger  COH_Evaluation_Request on COH_Evaluation_Request__c (before insert,before update) 
{
    public set<String> patientNames=new set<String>();
      for (COH_Evaluation_Request__c hdevalRequestObj : Trigger.new) {
         
         if (Trigger.isUpdate && hdevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(hdevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
             string typeofRequestObj = hdevalRequestObj.Type_of_Request__c;
             if(typeofRequestObj == 'Complex/non-complex Case Reviews (EAR, APO)'){
              if((hdevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }
             }
           /*  else if(typeofRequestObj == 'Test Request Review'){
               if((hdevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 2);
                }
                Else
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 2);  
                }  
             }
             else if(typeofRequestObj == 'Enhanced Interpretation Review'){
               if((hdevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 2);
                }
                Else
                {
                    hdevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), 2);  
                }  
             } */
         }else{}
          // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(hdevalRequestObj.NP_Triage_Date_Time__c!=null && hdevalRequestObj.Report_Sent_Date_Time__c!=null){
            
            hdevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), hdevalRequestObj.Report_Sent_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            hdevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(hdevalRequestObj.NP_Triage_Date_Time__c.date(), hdevalRequestObj.Report_Sent_Date_Time__c.date()));*/
            System.debug('' + hdevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>(); 
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = hdevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = hdevalRequestObj.Report_Sent_Date_Time__c.hour();  
            Double iTimeDiff;
            DateTime NPTriageDate=hdevalRequestObj.NP_Triage_Date_Time__c;//hdevalRequestObj
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=hdevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(hdevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(hdevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(hdevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(hdevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            hdevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + hdevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Convert Days_B_W_NP_Triage_Report_Sent__c to double.
        }
          
          //Report_Sent_Date_Time__c
        if(hdevalRequestObj.Submitted_for_Review_Date_Time__c!=null && hdevalRequestObj.Report_Sent_Date_Time__c!=null){
            
           //Days_Between_Submitted_Report_Sent__c
            hdevalRequestObj.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(hdevalRequestObj.Submitted_for_Review_Date_Time__c.date(), hdevalRequestObj.Report_Sent_Date_Time__c.date()));
            //System.debug('' + hdevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = hdevalRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = hdevalRequestObj.Report_Sent_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=hdevalRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=hdevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(hdevalRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(hdevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(hdevalRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(hdevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            hdevalRequestObj.Days_Between_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + hdevalRequestObj.Days_Between_Submitted_Report_Sent__c);
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