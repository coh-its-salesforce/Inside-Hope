public class COHITPMLifecycleHelper {
    public static void calculateHoursBurned(List<IT_Portfolio_Management__c> recITPMLifecycle){
        /*if(ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake){
            ITSIntakeTriggerCheckRecursive.isFirstTimeForIntake = false;
            set<Id>ITPMids = new set<Id>();
            Map<Id,Double> trMap = new Map<Id,Double>();
            Double HoursBurned = 0;
            Long RoundHours = 0;
            RecordType EnhancementRequest = [SELECT Id from RecordType Where SObjectType = 'IT_Portfolio_Management__c' and DeveloperName='Enhancement' LIMIT 1];
            
            for(IT_Portfolio_Management__c ITPM:recITPMLifecycle){
                if(ITPM.RecordTypeId != EnhancementRequest.Id){
                    ITPMids.add(ITPM.Id);
                }
            }*/
           /* if(ITPMids!=null && ITPMids.size()>0){
                List<Time_Record__c> trList = [Select Id, IT_Portfolio_Management__c, Hours__c from Time_Record__c where IT_Portfolio_Management__c in:ITPMids  limit 49990];             
                system.debug('trList.size() = ' + trList.size());
                for(Time_Record__c tr:trList){
                    HoursBurned += tr.Hours__c;
                }
            } */
            /*if(ITPMids!=null && ITPMids.size()>0){
                List<IT_Portfolio_Management__c> ITPMListWithTimeRecords = [Select Id,(SELECT Id,Hours__c from Time_Records__r) FROM IT_Portfolio_Management__c where Id IN :ITPMids limit 49990];
                for(IT_Portfolio_Management__c ITPM : ITPMListWithTimeRecords){
                    Decimal totalHoursBurned = 0;
                    for(Time_Record__c timeRecord : ITPM.Time_Records__r){
                        totalHoursBurned += timeRecord.Hours__c;
                    }
                    system.debug('total Burned Hours :'+ totalHoursBurned);
                    trMap.put(ITPM.Id,totalHoursBurned);
                }
                for(IT_Portfolio_Management__c ITPMrecord :recITPMLifecycle){
                    RoundHours = trMap.get(ITPMrecord.Id).round();
                    ITPMrecord.Hours_Burned_D__c = RoundHours;
                }
            }*/
           /* for(IT_Portfolio_Management__c ITPMrecord :recITPMLifecycle){
                RoundHours = HoursBurned.round();
                ITPMrecord.Hours_Burned_D__c = RoundHours;
            }
            system.debug('Hours Burned :'+ HoursBurned); */
        //}
    }
}