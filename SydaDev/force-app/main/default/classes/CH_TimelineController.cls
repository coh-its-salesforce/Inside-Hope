public with sharing class CH_TimelineController {
    
    public Map<String,StageStatusDetailsWrapper> stageStatusDetailsMap {get;set;}
    public Map<Decimal,String> stageStatusOrderMap {get;set;}
    
    public CH_TimelineController(ApexPages.StandardController con){
        Case caseRec = (Case)con.getRecord();
        
        if(caseRec.Id != null){
            stageStatusDetailsMap = new Map<String,StageStatusDetailsWrapper>();
            stageStatusOrderMap = new Map<Decimal, String>();
            
            //Fetch all the list of stage and status combination from case stage status object.
            //Check if the stage, status has been completed by the case and accordingly set the status
            for(Case_Stage_Team_Master__c stageMaster : [Select Stage_Name__c,Status_name__c,Order__c
                                                        from Case_Stage_Team_Master__c
                                                        order by order__c]){
                StageStatusDetailsWrapper wrapper = new StageStatusDetailsWrapper();
                String stageStatusCombination = stageMaster.Stage_Name__c + ':' + stageMaster.Status_name__c;
                wrapper.progress = 2;
                wrapper.timelinedetails = 'Stage not started yet.';
                wrapper.stage = stageMaster.Stage_Name__c;
                wrapper.status = stageMaster.Status_Name__c;
                stageStatusDetailsMap.put(stageStatusCombination, wrapper);
                stageStatusOrderMap.put(stageMaster.order__c , stageStatusCombination );
            }
            
            //Fetch the current stage and status of the case record.
            Case cs = [select Stage__c, Status__c ,CC_Appointment_Date__c,CC_Physician_Name__c
                         from Case where id =: caseRec.Id];
            String stageStatusCombination = cs.Stage__c + ':' + cs.Status__c;
            StageStatusDetailsWrapper wrapper = stageStatusDetailsMap.get(stageStatusCombination);
            if(wrapper != null){
                wrapper.progress = 1;
                wrapper.timelinedetails = '<b>Current Appointment </b><br/>' +
                                            'Date :' + (cs.CC_Appointment_Date__c != null ? cs.CC_Appointment_Date__c.format() : '') + '<br/>'+
                                            'Physician Name : ' + cs.CC_Physician_Name__c + ' <br/><br/>';
                
            }
            
            //Fetch the timeline records for the case and create the map "stageStatusDetailsMap"
            Map<String,Integer> caseTimelineHistoryMap = new Map<String,Integer>();
            for(case_timelines__c caseTimeline : [Select Stage__c, status__c,Appointment_Date__c ,Physician_Name__c
                                                    from case_timelines__c where case__c =: caseRec.Id
                                                    order by Appointment_Date__c desc]){
                stageStatusCombination = caseTimeline.Stage__c + ':' +  caseTimeline.Status__c;
                wrapper = stageStatusDetailsMap.get(stageStatusCombination);
                
                if(!caseTimelineHistoryMap.containskey(stageStatusCombination)){
                    caseTimelineHistoryMap.put(stageStatusCombination,0);
                    
                    if(wrapper != null && wrapper.progress == 2){
                        wrapper.timelinedetails = '';
                        wrapper.progress = 0;
                    }
                }
                Integer timelineCount = caseTimelineHistoryMap.get(stageStatusCombination);
                caseTimelineHistoryMap.put(stageStatusCombination, ++timelineCount);
                
                String appointmentdetails = '<b>Appointment '+ caseTimelineHistoryMap.get(stageStatusCombination) + '</b><br/>' +
                                            'Date : ' + (caseTimeline.Appointment_Date__c != null ? caseTimeline.Appointment_Date__c.format() : '') + '<br/>'+
                                            'Physician Name : '+ caseTimeline.Physician_Name__c + ' <br/><br/>';
                if(wrapper != null){
                    wrapper.timelinedetails += appointmentdetails;  
                }                        
            }
        
            
        }
    }
    
    private class StageStatusDetailsWrapper{
        public String stage {get;set;}
        public String status {get;set;}
        public Integer progress {get;set;}
        public String timelinedetails {get;set;}
    }
}