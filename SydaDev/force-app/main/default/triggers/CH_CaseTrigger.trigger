/* Name           :  CH_CaseTrigger
*  Created By     :   Persistent Systems Ltd
*  Created Date   :   Feb 11, 2015 
*  Description    :   This is case trigger runs on before and after case update to send alerts,
                  :   to create timeline events,assign caseteam members to case
*/
trigger CH_CaseTrigger on Case (after Update,before update) {
// testing--raymond tam
// No longer used.  Commented out for code coverage reasons
/*    
    boolean triggerIsBefore;
    List<case> CaseofUserLimitToBeUpdated = new List<case>();
    List<case> caseListToCreateTeam = new List<case>();
    List<id> CaseIDofUserLimitToBeUpdated =new List<id>();
    List<case_timelines__c> lstTimeLineRecords = new List<case_timelines__c>();
    
    List<Case>lstCaseRecordsToBeprocessed= new list<case>();
    List<string> physicianList =new List<String>();
    List<string> diseaseList =new List<String>();
    list<string> statusStatusList = new List<string>();
    Set<id> setOfCaseIds= new set<Id>();
    set<String> setCurrntStage= new set<string>();
    set<String> setCurrntStatus= new set<string>();
    set<id> setIdToBeProcessed= new set<id>();
    List<case> listOfCaseForfinancialcounselorStatus= new List<case>();
    List<id> listOfCaseIDForfinancialcounselorStatus= new List<id>();
    List<case> listOfCaseForpatientacceptStatus= new List<case>();
    set <id> setOfCaseIDForpatientacceptStatus= new set<id>();
    Map<String,Status_Stage_Master__c> stageStatusMap = new Map<String,Status_Stage_Master__c>();
    Map<id,List<Health_Goal__c>> hGoalsMap = new Map<id,List<Health_Goal__c>>();
    for (Status_Stage_Master__c statusRecord:[select id,Name from Status_Stage_Master__c]) {
        stageStatusMap.put(statusRecord.Name,StatusRecord);
    }
    map <id,case> mapCaseRecordsToBeprocessed = new map <id,case>();
    Set<Id> relatedChecklistSet = new Set<Id>();
    set<id> setPreventduplicateHealthGoalid= new set<id>();
    Set<String> relatedChecklistStage = new Set<String>();
    Set<String> relatedChecklistStatus = new Set<String>();
    //List<Health_Goal__c> relatedChecklist = new List<Health_Goal__c>();
    List<Health_Goal__c> relatedChecklistUpdateList = new List<Health_Goal__c>();
    
    
    
    if( trigger.Isupdate) {
    //Added code in is After
        if(trigger.IsAfter){
            for ( case caseHgids : trigger.new) {
                relatedChecklistSet.add(caseHGids.id);
                relatedChecklistStage.add(caseHGids.Stage__c);
                relatedChecklistStatus.add(caseHGids.status__c);
                if(relatedChecklistStage!=null && relatedChecklistStage.size()>0 && relatedChecklistStatus!= null && relatedChecklistStatus.size()>0){
                    if(relatedChecklistSet!= null && relatedChecklistSet.size()>0){
                        for(Health_Goal__c relatedChecklist : [select id,Due_Date__c,case__r.Accountid,Created_Stage__c,Created_Status__c,case__r.Stage__c,case__r.status__c from Health_Goal__c 
                                                        where case__r.CC_Appointment_Date__c != null 
                                                        AND Status__c != 'Completed' 
                                                        AND Created_Stage__c IN: relatedChecklistStage
                                                        AND Created_Status__c IN: relatedChecklistStatus
                                                        AND case__c IN:relatedChecklistSet]){
                            if(!hGoalsMap.containsKey(relatedChecklist.case__c)) {
                                 hGoalsMap.put(relatedChecklist.case__c,new List<Health_Goal__c>());
                            } 
                            hGoalsMap.get(relatedChecklist.case__c).add(relatedChecklist);
                        }
                    }  
                }
            }
            
        }


        for ( case te : trigger.new) {
            if(!te.Inactive__c){
                //Create case team
                if(trigger.IsBefore &&  trigger.isUpdate) {
                     //When stage is "First Appointment" and status is "MD Appointed"
                    if(te.Stage__c == CH_StaticComponentHelperClass.CaseStagePIFA && 
                        te.Status__c == CH_StaticComponentHelperClass.CaseStatusMDAppointed){
                        //If First Appointment with MD has been completed once, the stage should not be changed to First MD appointment
                        if(te.CC_MD_Appointed__c){
                            te.FkStage__c =Trigger.oldMap.get(te.Id).FkStage__c;
                            te.FkStatus__c =Trigger.oldMap.get(te.Id).FkStatus__c;
                        }else{//else allow the stage change
                            te.CC_MD_Appointed__c = true;
                        }
                    } 
                    //When stage is "First Appointment" and status is "Appointment Details Updated"
                    if(te.Stage__c == CH_StaticComponentHelperClass.CaseStagePIFA && 
                        te.Status__c == CH_StaticComponentHelperClass.CaseStatusAppointmentDetailsUpdated){
                        //If First Appointment details has been upadated once, the stage should not be changed 
                        if(te.CC_Appointment_Details_Updated__c){
                            te.FkStage__c = Trigger.oldMap.get(te.Id).FkStage__c;
                            te.FkStatus__c =Trigger.oldMap.get(te.Id).FkStatus__c;
                        }else{
                             te.CC_Appointment_Details_Updated__c = true; 
                        }
                    } 
                    
                    //If the case stage or status has been updated
                    if((te.Stage__c != null && Trigger.oldMap.get(te.Id).Stage__c != te.Stage__c) || 
                        (te.status__c != null && Trigger.oldMap.get(te.Id).status__c != te.status__c)) {
                        setOfCaseIds.add(te.id);
                        //replace accountdisease filed with program field mapped from stretegic program field on Account
                        if(te.CC_Disease__c!=Null) {
                            diseaseList.add(te.CC_Disease__c);
                        }
                        if(te.CC_AllScripts_Physician__c!=Null) {
                            PhysicianList.add(te.CC_AllScripts_Physician__c);
                        }
                        statusStatusList.Add(te.Status__c);
                        statusStatusList.Add(te.Stage__c);
                        caseListToCreateTeam.add(te);
                    }
                    //
                    if(Trigger.oldMap.get(te.Id).Financial_Status__c != te.Financial_Status__c && stageStatusMap.get(te.Financial_Status__c) != null) {
                        listOfCaseForfinancialcounselorStatus.add(te);
                        listOfCaseIDForfinancialcounselorStatus.add(te.id);
                    }
                    //
                    if(Trigger.oldMap.get(te.Id).Clinical_Status__c != te.Clinical_Status__c && stageStatusMap.get(te.Clinical_Status__c)!=Null  && te.Clinical_Status__c != null ) {
                        listOfCaseForpatientacceptStatus.add(te);
                        setOfCaseIDForpatientacceptStatus.add(te.id);
                    }
                    //
                    if( (Trigger.oldMap.get(te.Id).Caregiver_status__c != te.Caregiver_status__c) &&  (te.Caregiver_status__c != '' || te.Caregiver_status__c  !=null) ) {
                        Id LoggedinUserId=userinfo.getUserId();
                        if(LoggedinUserId == te.ownerid) {
                            if(te.Caregiver_status__c == CH_StaticComponentHelperClass.statuscaregiverfound) {
                                te.FkStatus__c = stageStatusMap.get(CH_StaticComponentHelperClass.statuscaregiverfound).ID;
                                te.CC_Appointment_Date__c=null;
                            }
                            if(te.Caregiver_status__c == CH_StaticComponentHelperClass.statuscaregivernotfound) {
                                te.FkStatus__c = stageStatusMap.get(CH_StaticComponentHelperClass.statuscaregivernotfound).ID;
                                te.CC_Appointment_Date__c=null;
                            }
                        } else {
                            te.adderror(system.label.CH_UpdateStage_PermissionIssue);
                        }
                    }
                }
                
                //Added new logic to fire alerts.   
                if(Trigger.IsAfter && Trigger.isUpdate) {
                    if( (Trigger.oldMap.get(te.Id).Stage__c != te.Stage__c &&  te.Stage__c != null) || 
                        (Trigger.oldMap.get(te.Id).Status__c != te.Status__c &&  te.Status__c != null ) ) {
                            lstCaseRecordsToBeprocessed.add(te);
                            setIdToBeProcessed.add(te.id);
                            setCurrntStage.add(te.stage__c);
                            setCurrntStatus.add(te.status__c);
                    }
                    
                    //If the appointment etails have been updated
                    if(Trigger.oldMap.get(te.Id).Stage__c != null && Trigger.oldMap.get(te.Id).status__c != null && te.Stage__c!= null && te.status__c!= null){
                        if(Trigger.oldMap.get(te.Id).Stage__c == te.Stage__c && Trigger.oldMap.get(te.Id).status__c == te.status__c){
                            if(Trigger.oldMap.get(te.Id).CC_Appointment_Date__c != null && te.CC_Appointment_Date__c !=null 
                                && Trigger.oldMap.get(te.Id).CC_Appointment_Date__c != te.CC_Appointment_Date__c){
                                    List<Health_Goal__c> hlgs;
                                    if(hGoalsMap!=null && hGoalsMap.size()>0){
                                        hlgs = hGoalsMap.get(te.id);    
                                    }                           
                                    if(hlgs != null && hlgs.size()>0){  
                                        for(Health_Goal__c hg:hlgs){                                        
                                            if(te.id == hg.case__c){                             
                                                if(te.Stage__c == hg.Created_Stage__c && te.status__c == hg.Created_Status__c ){
                                                    if(Trigger.oldMap.get(te.Id).CC_Appointment_Date__c!=null && te.CC_Appointment_Date__c!=null){
                                                        Integer difference = Trigger.oldMap.get(te.Id).CC_Appointment_Date__c.daysBetween(te.CC_Appointment_Date__c);
                                                        if( hg.Due_Date__c  != null && difference  !=null && te.CC_Appointment_Date__c !=null){                           
                                                            hg.Due_Date__c =  hg.Due_Date__c.addDays(difference);
                                                        }else{
                                                            hg.Due_Date__c = te.CC_Appointment_Date__c;
                                                        }
                                                        if(setPreventduplicateHealthGoalid.size() == 0 || setPreventduplicateHealthGoalid.contains(hg.id)==false){
                                                            relatedChecklistUpdateList.add(hg);
                                                        }
                                                        setPreventduplicateHealthGoalid.add(hg.id);
                                                    }
                                                }
                                             }
                                         }
                                     }              
                             }
                        }
                    }
                }  
            }
            if((Trigger.oldMap.get(te.Id).Inactive__c == False && te.Inactive__c == True)) {
                CaseofUserLimitToBeUpdated.add(te);
                CaseIdofUserLimitToBeUpdated.add(te.id);
            }
            if(Trigger.isAfter && Trigger.isUpdate){
                // Inserting case stage records to timeline object when the case changes/
                if((te.CH_CaseStageStatus__c != null) && (Trigger.oldMap.get(te.Id).CH_CaseStageStatus__c != null) 
                    && (Trigger.oldMap.get(te.Id).CH_CaseStageStatus__c).trim()!= '-' 
                    && (Trigger.oldMap.get(te.Id).CH_CaseStageStatus__c != te.CH_CaseStageStatus__c) ) {
                        case_timelines__c tempTimeLineRecords = new case_timelines__c();
                        tempTimeLineRecords.Case__c= te.id;
                       
                        if(Trigger.oldMap.get(te.Id).CC_Appointment_Date__c != null){
                            tempTimeLineRecords.Appointment_Date__c = Trigger.oldMap.get(te.Id).CC_Appointment_Date__c;
                        }
                        if(Trigger.oldMap.get(te.Id).Stage__c != null){
                            tempTimeLineRecords.Stage__c = Trigger.oldMap.get(te.Id).Stage__c;
                        }
                        if(Trigger.oldMap.get(te.Id).Status__c != null){
                            tempTimeLineRecords.Status__c = Trigger.oldMap.get(te.Id).Status__c;
                        }
                        if(Trigger.oldMap.get(te.Id).CC_Physician_Name__c != null){
                            tempTimeLineRecords.Physician_Name__c = Trigger.oldMap.get(te.Id).CC_Physician_Name__c;
                        }
                                
                        Date oldModifiedDate = date.newinstance(Trigger.oldMap.get(te.Id).LastModifiedDate.year(), Trigger.oldMap.get(te.Id).LastModifiedDate.month(),Trigger.oldMap.get(te.Id).LastModifiedDate.day());
                        tempTimeLineRecords.Date__c = oldModifiedDate;
                                
                        tempTimeLineRecords.name=Trigger.oldMap.get(te.Id).CH_CaseStageStatus__c;
                        lstTimeLineRecords.add(tempTimeLineRecords);
                }
            }
        }
        // Call alert engine helper class
        if(lstCaseRecordsToBeprocessed !=null && lstCaseRecordsToBeprocessed.size()>0  && setIdToBeProcessed.size()>0 && setCurrntStage.size()>0 && setCurrntStatus.size()>0 ) {
            CH_AlertEngineHelperClass.actionItems(lstCaseRecordsToBeprocessed, setIdToBeProcessed, setCurrntStage, setCurrntStatus);
        }
        //CALL METHOD TO UPDATE CASE COUNT
        if(!caseofUserLimitToBeUpdated.isempty() && !caseIdofUserLimitToBeUpdated.isempty()) {
            CH_Createcaseteamclass.UpdateCountOnCaseState(CaseofUserLimitToBeUpdated,CaseIdofUserLimitToBeUpdated);
        }
        //CALL METHOD TO CREATE CASE TEAM
        if(!caseListToCreateTeam.isempty()) {
            CH_Createcaseteamclass.CaseTeamCreator(caseListToCreateTeam,physicianList,diseaseList,statusStatusList,setOfCaseIds);
        }
        if(listOfCaseForfinancialcounselorStatus !=Null && !listOfCaseForfinancialcounselorStatus.isEmpty()) {
            CH_Createcaseteamclass.ChangeStatusOnFinancialConcellorStatus(listOfCaseForfinancialcounselorStatus,listOfCaseIDForfinancialcounselorStatus,stageStatusMap);
        }
        if(listOfCaseForpatientacceptStatus!=Null && setOfCaseIDForpatientacceptStatus !=null && !listOfCaseForpatientacceptStatus.isEmpty() &&  setOfCaseIDForpatientacceptStatus.size()>0 ) {
            CH_Createcaseteamclass.ChangeStatusOnPatientacceptedstatus(listOfCaseForpatientacceptStatus,setOfCaseIDForpatientacceptStatus,stageStatusMap);
        }
        if(lstTimeLineRecords != null && lstTimeLineRecords.size()>0) {
            try {
                insert lstTimeLineRecords;
            }
            catch (Exception e) {
                 system.debug('*****Exception*******'+ e.getmessage());
            }
        }
         if(relatedChecklistUpdateList != null && relatedChecklistUpdateList.size()>0) {
           
            try {
                Update relatedChecklistUpdateList;
            }
            catch (Exception e) {
                 system.debug('*****Exception*******'+ e.getmessage());
            }
        }
      
    }
*/
}