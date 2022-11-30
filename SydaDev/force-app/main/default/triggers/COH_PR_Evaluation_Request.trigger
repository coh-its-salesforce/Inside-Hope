trigger COH_PR_Evaluation_Request on PR_Evaluation_Request__c (before insert,before update) {

    public set<String> patientNames=new set<String>();
      for (PR_Evaluation_Request__c PRevalRequestObj : Trigger.new) {
         
         if (Trigger.isUpdate && PRevalRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(PRevalRequestObj.Id).NP_Triage_Date_Time__c)
         {
             string typeofRequestObj = PRevalRequestObj.Type_of_Request__c;
             if(typeofRequestObj == 'Complex/non-complex Case Reviews (EAR, APO)'){
              if((PRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }
             }
           /*  else if(typeofRequestObj == 'Test Request Review'){
               if((PRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             }
             else if(typeofRequestObj == 'Enhanced Interpretation Review'){
               if((PRevalRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    PRevalRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), 4);  
                }  
             } */
         }else{}
          // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(PRevalRequestObj.NP_Triage_Date_Time__c!=null && PRevalRequestObj.Report_Sent_Date_Time__c!=null){
            
            PRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), PRevalRequestObj.Report_Sent_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            PRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(PRevalRequestObj.NP_Triage_Date_Time__c.date(), PRevalRequestObj.Report_Sent_Date_Time__c.date()));*/
            System.debug('' + PRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>(); 
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = PRevalRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = PRevalRequestObj.Report_Sent_Date_Time__c.hour();  
            Double iTimeDiff;
            DateTime NPTriageDate=PRevalRequestObj.NP_Triage_Date_Time__c;//PRevalRequestObj
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=PRevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(PRevalRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(PRevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(PRevalRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(PRevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            PRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + PRevalRequestObj.Days_B_W_NP_Triage_Report_Sent__c);
            //Convert Days_B_W_NP_Triage_Report_Sent__c to double.
        }
          
          //Report_Sent_Date_Time__c
        if(PRevalRequestObj.Submitted_for_Review_Date_Time__c!=null && PRevalRequestObj.Report_Sent_Date_Time__c!=null){
            
           //Days_Between_Submitted_Report_Sent__c
            PRevalRequestObj.Days_Between_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(PRevalRequestObj.Submitted_for_Review_Date_Time__c.date(), PRevalRequestObj.Report_Sent_Date_Time__c.date()));
            //System.debug('' + PRevalRequestObj.Days_Between_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = PRevalRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = PRevalRequestObj.Report_Sent_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=PRevalRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=PRevalRequestObj.Report_Sent_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(PRevalRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(PRevalRequestObj.Report_Sent_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(PRevalRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(PRevalRequestObj.Report_Sent_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            PRevalRequestObj.Days_Between_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + PRevalRequestObj.Days_Between_Submitted_Report_Sent__c);
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