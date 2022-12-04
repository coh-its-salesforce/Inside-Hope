/**
 * @description       : 
 * @author            : Sanjay
 * @group             : 
 * @last modified on  : 02-20-2021
 * @last modified by  : Sanjay
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   02-05-2021   Sanjay   Initial Version
**/
public class COH_CaseTriggerHelper {
    
    public static void populateEmail(List<case> newCase, Map<Id, Case> oldMap){
        List<Id> leadIds = new List<Id>();
        for(Case inx : newCase){
            if(inx.Email__c == null){
                leadIds.add(inx.Lead__c);
            }
        }
        if(!leadIds.isEmpty()){
            Map<Id,Lead> leadData =new map<Id,Lead>([Select id,email from Lead where Id in:leadIds]);
            for(Case inx : newCase){
                if(inx.Email__c == null){
                    String email = '';
                    if(leadData.containsKey(inx.Lead__c)){
                        email =leadData.get(inx.Lead__c).Email;
                    }
                    inx.Email__c = inx.ContactEmail!=null? inx.ContactEmail:email;
                }
            }
        }
    }
    
    public static void doBeforeUpdate(List<case> newCase, Map<Id, Case> oldMap){
        updateStatusToClosed(newCase, oldMap);
        assignOwnerbasedOnRoundRobinQueue(newCase, oldMap);
    }

    /**
    * @description method to assign owner based on round robin
    * @author Sanjay | 02-05-2021 
    * @param List<case> newCase 
    * @param Map<Id Case> oldMap 
    **/
    
   
    private static void assignOwnerbasedOnRoundRobinQueue(List<case> newCase, Map<Id, Case> oldMap){
        List<Case> casesToProcess = new List<Case>();
        set<Id> queueIds = new set<Id>();
        for(Case c : newCase){
            if(c.OwnerId != oldMap.get(c.Id).OwnerId && String.valueOf(c.OwnerId).startsWith('00G') ){
                queueIds.add(c.OwnerId);
                casesToProcess.add(c);
            }
        }

        if(!queueIds.isEmpty()){
            Map<Id, COH_Round_Robin_Queue__c> rrQueueMap = new Map<Id, COH_Round_Robin_Queue__c>();
            Map<Id, integer> lastAssigned = new Map<Id, integer>();
            Map<Id, COH_Round_Robin_Queue_Member__c> queueMemberToUncheck = new Map<Id, COH_Round_Robin_Queue_Member__c>();
            Map<Id, COH_Round_Robin_Queue_Member__c> queueMemberToUpdate = new Map<Id, COH_Round_Robin_Queue_Member__c>();
            for( COH_Round_Robin_Queue__c rrq : [SELECT Id, Name, Active__c, Queue_Developer_Name__c, SObject_API_Name__c, Queue_SF_Id__c, 
                                                        (SELECT Id, Name, Round_Robin_Queue__c, User__c, Order__c, Last_Assigned__c, Active__c 
                                                           FROM Round_Robin_Queue_Members__r Where Active__c = true order by Order__c ASC)
                                                   FROM COH_Round_Robin_Queue__c where Queue_SF_Id__c in : queueIds and 
                                                        SObject_API_Name__c ='Case' and Active__c = true] ){
                rrQueueMap.put(rrq.Queue_SF_Id__c, rrq);
                integer i = 0;
                for(COH_Round_Robin_Queue_Member__c m : rrq.Round_Robin_Queue_Members__r){
                    if(m.Last_Assigned__c){
                        lastAssigned.put(rrq.Queue_SF_Id__c, i);
                        queueMemberToUncheck.put(m.Id, m);
                        break;
                    }
                    i++;
                }
            }
            System.debug('===queueMemberToUncheck==='+queueMemberToUncheck);
            for(Case c : casesToProcess){
                if(rrQueueMap.containsKey(c.OwnerId) && !rrQueueMap.get(c.OwnerId).Round_Robin_Queue_Members__r.isEmpty()){
                    integer maxIndex = rrQueueMap.get(c.OwnerId).Round_Robin_Queue_Members__r.size() -1;
                    integer startIndex = lastAssigned.containsKey(c.OwnerId) ?
                                         ((lastAssigned.get(c.OwnerId) +1)  > maxIndex? 0:  (lastAssigned.get(c.OwnerId) +1)) : 0;
                    system.debug('------maxIndex---'+maxIndex);
                    system.debug('------startIndex---'+startIndex);
                    lastAssigned.put(c.OwnerId, startIndex);
                    c.OwnerId = rrQueueMap.get(c.OwnerId).Round_Robin_Queue_Members__r[startIndex].User__c;
                }
            }

            for(id i : lastAssigned.keySet()){
                COH_Round_Robin_Queue_Member__c member =  rrQueueMap.get(i).Round_Robin_Queue_Members__r[lastAssigned.get(i)];
                member.Last_Assigned__c = true;
                queueMemberToUpdate.put(member.Id, member);
            }

            for(id i : queueMemberToUncheck.keySet()){
                if(!queueMemberToUpdate.containsKey(i)){
                    COH_Round_Robin_Queue_Member__c member =  queueMemberToUncheck.get(i);
                    member.Last_Assigned__c = false;
                    queueMemberToUpdate.put(member.Id, member);
                }
            }
            database.update(queueMemberToUpdate.values(), false);
        }
    }
    
    private static void updateStatusToClosed(List<case> newCase, Map<Id, Case> oldMap){
        Id recordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EHS_Contact_Trace').getRecordTypeId();
        for(Case c : newCase){
            if(c.RecordTypeId == recordTypeId && c.Date_EHS_Cleared_to_Return_to_Work__c != null && c.Date_EHS_Cleared_to_Return_to_Work__c != oldMap.get(c.Id).Date_EHS_Cleared_to_Return_to_Work__c){
                c.Status = 'Closed';
            }
        }
    }
    
    public static void updateEHSQuestionaires(List<case> newCase, Map<Id, Case> oldMap){
        Map<Id, Case> caseToProcess = new Map<Id, Case>();
        Id recordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EHS_Contact_Trace').getRecordTypeId();
        for(Case c : newCase){
            if(c.RecordTypeId == recordTypeId && ((c.Date_EHS_Cleared_to_Return_to_Work__c != oldMap.get(c.Id).Date_EHS_Cleared_to_Return_to_Work__c) || (c.Description != oldMap.get(c.Id).Description))){
                caseToProcess.put(c.Id, c);
            }
        }
        if(!caseToProcess.isEmpty()){
            List<EHS_Risk_Assessment_Questionaire__c> rectoUpdate = new List<EHS_Risk_Assessment_Questionaire__c>();
            for(EHS_Risk_Assessment_Questionaire__c eraq : [Select Id, Date_EHS_Cleared_to_Return_to_Work__c, Has_Employee_Returned_To_Work__c,
                                                            Employee_Crisis_Assessment__r.Case__c, Case_Description__c from EHS_Risk_Assessment_Questionaire__c
                                                            Where Employee_Crisis_Assessment__r.Case__c in : caseToProcess.keySet()]){
                                                            
                //Added Condition by Sanjay on 04/01/2021:START
                if(caseToProcess.get(eraq.Employee_Crisis_Assessment__r.Case__c).Date_EHS_Cleared_to_Return_to_Work__c != oldMap.get(eraq.Employee_Crisis_Assessment__r.Case__c).Date_EHS_Cleared_to_Return_to_Work__c){
                    eraq.Date_EHS_Cleared_to_Return_to_Work__c = caseToProcess.get(eraq.Employee_Crisis_Assessment__r.Case__c).Date_EHS_Cleared_to_Return_to_Work__c;                                                    
                    eraq.Has_Employee_returned_to_work__c = caseToProcess.get(eraq.Employee_Crisis_Assessment__r.Case__c).Has_Employee_Returned_To_Work__c;
                }
                if(caseToProcess.get(eraq.Employee_Crisis_Assessment__r.Case__c).Description != oldMap.get(eraq.Employee_Crisis_Assessment__r.Case__c).Description){
                    eraq.Case_Description__c = caseToProcess.get(eraq.Employee_Crisis_Assessment__r.Case__c).Description;
                }
                //Added Condition by Sanjay on 04/01/2021:END
                rectoUpdate.add(eraq);
            }
            
            if(!rectoUpdate.isEmpty()){update rectoUpdate;}
        }
    }
    
}