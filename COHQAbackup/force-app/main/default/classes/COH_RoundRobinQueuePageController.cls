/**
 * @description       : 
 * @author            : Sanjay
 * @group             : 
 * @last modified on  : 02-25-2021
 * @last modified by  : Sanjay
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   02-04-2021   Sanjay   Initial Version
**/
public with sharing class COH_RoundRobinQueuePageController {
   
    /**
    * @description method to query sobjects
    * @author Sanjay | 02-04-2021 
    * @return List<SObjWrapper> 
    **/
    @AuraEnabled
    public static List<SObjWrapper> getObjectList(){
        List<SObjWrapper> theList = new List<SObjWrapper>();
        try {
            List<string> objectTypes = new List<string>();
            for(AggregateResult ag : [Select count(id) , SobjectType from QueueSobject group by SobjectType]){
                objectTypes.add(String.valueOf(ag.get('SobjectType')));
            }
            Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();
            System.debug('===sObjects==='+sObjects.keySet());
            objectTypes.sort();
            for(string objName : objectTypes)  {
                System.debug('===objName==='+objName);
                if(sObjects.containsKey(objName.toLowerCase())){
                    schema.DescribeSObjectResult objResult = sObjects.get(objName.toLowerCase()).getDescribe();
                    theList.add(new SObjWrapper(objResult.getName(), objResult.getLabel()));
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return theList;
    }


    /**
    * @description method to get list og queues related to specified object
    * @author Sanjay | 02-04-2021 
    * @param string objName 
    * @return List<Group> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Group>  getQueues(string objName){
        List<Group> queues = new List<Group>();
        try {
            if(string.isNotBlank(objName)){
                queues = [Select id, Name, DeveloperName from Group Where Type= 'Queue' and id in (SELECT QueueId FROM QueueSobject where SobjectType  =:objName) order by Name ASC];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return queues;
    }

    @AuraEnabled
    public static map<string, object> updateRecords(string  roundRobinFields, string memberJSON){
        map<string, object> res = new map<string, object>();
        try {
            
            List<UserWrapper> userList = (List<UserWrapper>)JSON.deserialize(memberJSON, List<UserWrapper>.class);
            
            system.debug('====userList=='+userList);
            COH_Round_Robin_Queue__c rr = (COH_Round_Robin_Queue__c)JSON.deserialize(roundRobinFields, COH_Round_Robin_Queue__c.class);
            Database.upsert(rr);
            res.put('roundRobinObj', rr);
            upsertMembers(userList, rr.Id);            
           
        } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
        }
        return res;
    }
    

    /**
    * @description upsert queue members
    * @author Sanjay | 02-18-2021 
    * @param List<UserWrapper> userList 
    * @param Id roundRobinId 
    * @return List<COH_Round_Robin_Queue_Member__c> 
    **/
    private static void upsertMembers(List<UserWrapper> userList, Id roundRobinId){
        List<COH_Round_Robin_Queue_Member__c> members = new List<COH_Round_Robin_Queue_Member__c>();
        List<COH_Round_Robin_Queue_Member__c> memberToRemove = new List<COH_Round_Robin_Queue_Member__c>();
        if(roundRobinId != null){
            Map<Id, COH_Round_Robin_Queue_Member__c> membermap = new Map<Id, COH_Round_Robin_Queue_Member__c>();
            for(COH_Round_Robin_Queue_Member__c m :[SELECT Id, Name, Round_Robin_Queue__c, User__c, Order__c, Last_Assigned__c, Active__c 
                                                    FROM COH_Round_Robin_Queue_Member__c Where Round_Robin_Queue__c =: roundRobinId  ]){
                membermap.put(m.User__c , m);                                        
            }

            for(UserWrapper u : userList){
                if(u.isAssociated){
                    COH_Round_Robin_Queue_Member__c rec = membermap.containsKey(u.userRec.Id)? membermap.get(u.userRec.Id) : 
                            new COH_Round_Robin_Queue_Member__c(User__c=u.userRec.Id, Round_Robin_Queue__c =roundRobinId );
                    rec.Order__c = u.order != null? decimal.valueOf(u.Order) : null; 
                    rec.Active__c = u.isActive;
                    members.add(rec);
                }else{
                    if(membermap.containsKey(u.userRec.Id)){
                        memberToRemove.add(membermap.get(u.userRec.Id));
                    }
                }
            }
            if(!members.isEmpty()){
                database.upsert(members);
            }
            if(!memberToRemove.isEmpty()){
                database.delete(memberToRemove);
            } 
        }
        
    }

    /**
    * @description mrethod to query queue member
    * @author Sanjay | 02-05-2021 
    * @param string queueName 
    * @param Id recordId 
    * @return List<UserWrapper> 
    **/
    @AuraEnabled
    public static List<UserWrapper>  getQueueMembers(string queueId, Id recordId){
        List<UserWrapper> memberList = new  List<UserWrapper>();
        try {
            if(string.isNotBlank(queueId)){
                Map<Id, User> userMap = new  map<Id, User>([Select Id, Name, Email ,isActive from User 
                                            where id in  (select UserOrGroupId  from GroupMember  where GroupId =: queueId )]);
                
                
                Map<Id, User> roundRobinqueueMemberMap = new  map<Id, User>();
                if(recordId != null){
                    roundRobinqueueMemberMap = new  map<Id, User>([Select Id, Name, Email ,isActive from User 
                                            where id in  (SELECT User__c 
                                            FROM COH_Round_Robin_Queue_Member__c Where User__c != null and Round_Robin_Queue__c =: recordId)]);

                    for(COH_Round_Robin_Queue_Member__c m: [SELECT Id, Round_Robin_Queue__c, User__c, Order__c, Last_Assigned__c, Active__c, Name 
                                                        FROM COH_Round_Robin_Queue_Member__c Where Round_Robin_Queue__c =: recordId order by Order__c ASC ]){
                        
                        
                        memberList.add(new UserWrapper(roundRobinqueueMemberMap.get(m.User__c), 
                                                        true, 
                                                        m.Order__c != null ? m.Order__c.intValue() : null,
                                                        m.Active__c, 
                                                        m.Last_Assigned__c));
                    }
                }

                for(user u : userMap.values()){
                    if(!roundRobinqueueMemberMap.containsKey(u.Id)){
                        memberList.add(new UserWrapper(u, false, null, false, false));
                    }
                }
                
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return memberList;
    }


    public class SObjWrapper{
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public String objectLabel;

        public SObjWrapper(String devName, String label) {
            this.apiName = devName;
            this.objectLabel = label;
        }
    }

    public class UserWrapper{
        @AuraEnabled
        public User userRec;
        @AuraEnabled
        public boolean isAssociated;
        @AuraEnabled
        public integer order;
        @AuraEnabled
        public boolean isActive;
        @AuraEnabled
        public boolean lastAssigned;
        


        public UserWrapper(user u, boolean s, integer o, boolean active, boolean isLastasigned) {
            this.userRec = u;
            this.isAssociated = s;
            this.order = o;
            this.isActive = active;
            this.lastAssigned = isLastasigned;
        }
    }

}