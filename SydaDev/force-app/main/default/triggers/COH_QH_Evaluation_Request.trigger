/*
* This trigger processes COH_QH_Evaluation_Request objects.
* 
* Abhishek Kumar
* City of Hope
* Copyright (c) 2018
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
trigger COH_QH_Evaluation_Request on Evaluation_Request__c (before insert, before update,after insert,after update) {
    
    private static String ComplexCaseRecordTypeName = 'QH - Complex Case Review';
    private static String ExpertInterpretationRecordTypeName = 'QH - Expert Interpretation';
    private static String RetroReviewRecordTypeName = 'QH - Retrospective Review';
    private static String GeneTestRecordTypeName = 'QH - Test Request Form';
    private static Id mRecordTypeName;
    Private static Date CalculatedDate;
    public set<String> patientNames=new set<String>();
    
    Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosById();
    if((Trigger.isInsert && Trigger.isBefore) || Trigger.isUpdate && Trigger.isBefore){
    for (Evaluation_Request__c evaluatioRequestObj : Trigger.new) {
        //if the value of NP_Triage_Date_Time__c has changed.
        if (Trigger.isUpdate && evaluatioRequestObj.NP_Triage_Date_Time__c != trigger.oldMap.get(evaluatioRequestObj.Id).NP_Triage_Date_Time__c)
        {
            String RecordTypeName = rtMap.get(evaluatioRequestObj.RecordTypeId).getName();
            if(RecordTypeName == ComplexCaseRecordTypeName)
            {
                if((evaluatioRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 6);
                }
                Else
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 7);     
                }
            }
            else if(RecordTypeName == ExpertInterpretationRecordTypeName)
            {
                if((evaluatioRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 4);
                }
                Else
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 5);  
                }
            }
            else if(RecordTypeName == RetroReviewRecordTypeName)
            {
                if((evaluatioRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 9);
                }
                Else
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 10); 
                }
            }
            if(RecordTypeName == GeneTestRecordTypeName)
            {
                if((evaluatioRequestObj.NP_Triage_Date_Time__c).hour() < 16)
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 2);
                }
                Else
                {
                    evaluatioRequestObj.COH_Review_Due_Date__c = COH_EMP_Strategy_Util.AddBusinessDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), 3);  
                }
            }
        }
       
        // Saidaiah added/modified the below code to exclude the weekends & COH Holidays
        
        if(evaluatioRequestObj.NP_Triage_Date_Time__c!=null && evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c!=null){
            
            evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date()));
            /*COHUtil daysDiff=new COHUtil();
            evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c=Integer.valueof(daysDiff.CalculateWorkingDays(evaluatioRequestObj.NP_Triage_Date_Time__c.date(), evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date()));*/
            System.debug('' + evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iNPTriagehour = evaluatioRequestObj.NP_Triage_Date_Time__c.hour();
            Double iReportSenthour = evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime NPTriageDate=evaluatioRequestObj.NP_Triage_Date_Time__c;
            String dayOfWeek1=NPTriageDate.format('EEEE');
            DateTime ReportSentDate=evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(evaluatioRequestObj.NP_Triage_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date())){
                iTimeDiff= 24 - iNPTriagehour ;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(evaluatioRequestObj.NP_Triage_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iNPTriagehour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + evaluatioRequestObj.Days_Between_NP_Triage_Report_Sent__c);
            //Convert Days_Between_NP_Triage_Report_Sent__c to double.
        }
        
        
        if(evaluatioRequestObj.Submitted_for_Review_Date_Time__c!=null && evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c!=null){
            
           
            evaluatioRequestObj.Days_Btw_Submitted_Report_Sent__c=Integer.valueof(COHUtil.CalculateWorkingDays(evaluatioRequestObj.Submitted_for_Review_Date_Time__c.date(), evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date()));
            //System.debug('' + evaluatioRequestObj.Days_Btw_Submitted_Report_Sent__c);
            //Abhisheks comment to calculate time difference.
            Set<Date> holidays = new Set<Date>();  
            for(COH_Federal_Holidays_list__mdt currHoliday : [Select Holiday_Date__c,Holiday_Name__c From COH_Federal_Holidays_list__mdt])  
            {  
            holidays.add(currHoliday.Holiday_Date__c);  
            }
            
           
            Double iSubmittedhour = evaluatioRequestObj.Submitted_for_Review_Date_Time__c.hour();
            Double iReportSenthour = evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.hour();
            Double iTimeDiff;
            DateTime SubmittedDate=evaluatioRequestObj.Submitted_for_Review_Date_Time__c;
            String dayOfWeek1=SubmittedDate.format('EEEE');
            DateTime ReportSentDate=evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c;
            String dayOfWeek2=ReportSentDate.format('EEEE');
            
            if(dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(evaluatioRequestObj.Submitted_for_Review_Date_Time__c.date())){
                iTimeDiff= 24 - iReportSenthour;
            }
            
            else if(dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date())){
                iTimeDiff= 24 - iSubmittedhour;
            }
            else if((dayOfWeek1=='Saturday' || dayOfWeek1=='Sunday' || holidays.contains(evaluatioRequestObj.Submitted_for_Review_Date_Time__c.date())) && (dayOfWeek2=='Saturday' || dayOfWeek2=='Sunday' || holidays.contains(evaluatioRequestObj.Report_Sent_to_QH_Date_Time__c.date()))){
                
                iTimeDiff=0;
            }
            else {
                 iTimeDiff=iReportSenthour - iSubmittedhour;
            }
            Double dTimeDiffinDays = iTimeDiff/24;
            System.debug('iTimeDiff' + iTimeDiff);
            System.debug('dTimeDiffinDays' + dTimeDiffinDays);
            evaluatioRequestObj.Days_Btw_Submitted_Report_Sent__c += dTimeDiffinDays-1;
            System.debug('' + evaluatioRequestObj.Days_Btw_Submitted_Report_Sent__c);
            //Convert Days_Btw_Submitted_Report_Sent__c to double.
        }
         
    }
    
    /*if(trigger.isBefore && trigger.isInsert){
        
        for (Evaluation_Request__c evaluatioRequestObj1 : [select id,name,Patient_Account__c from Evaluation_Request__c where Patient_Account__c!=null AND  LastModifiedDate=THIS_YEAR ]) {
            
            patientNames.add(evaluatioRequestObj1.Patient_Account__c);
        }
        
        for (Evaluation_Request__c evaluatioRequestObj2 : trigger.new){
            
            if(patientNames.contains(evaluatioRequestObj2.Patient_Account__c)){
                
                evaluatioRequestObj2.Exclude_From_Report__c=true;
                
            }
        }
        
    }*/
    
    
}
}