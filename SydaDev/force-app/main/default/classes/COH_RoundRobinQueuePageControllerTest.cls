@isTest
public class COH_RoundRobinQueuePageControllerTest {
	
    @isTest
    static void unitTest(){
        Test.startTest();
        user u  = [select id from user where id=:userinfo.getUserId()];
        system.runAs(u){
            Group g1 = new Group(Name='TEST QUEUE', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            GroupMember gm = new GroupMember(GroupId = g1.Id, UserOrGroupId = userinfo.getUserId());
    		insert gm;
            
            COH_Round_Robin_Queue__c rrq = new COH_Round_Robin_Queue__c();
            rrq.Name = 'TEST QUEUE';
            rrq.Queue_SF_Id__c = g1.Id;
            rrq.SObject_API_Name__c = 'Case';
            insert rrq;
            
            List<COH_RoundRobinQueuePageController.SObjWrapper> objList = COH_RoundRobinQueuePageController.getObjectList();
            List<Group> groups = COH_RoundRobinQueuePageController.getQueues('Case');
            
            List<COH_RoundRobinQueuePageController.UserWrapper> members =  COH_RoundRobinQueuePageController.getQueueMembers(g1.Id, rrq.Id);
            members[0].isAssociated = true;
            members[0].isActive = true;
            string jsonstr  = JSON.serialize(members);
            COH_RoundRobinQueuePageController.updateRecords(JSON.serialize(rrq) , jsonstr);
            members =  COH_RoundRobinQueuePageController.getQueueMembers(g1.Id, rrq.Id);            
            COH_RoundRobinQueuePageController.updateRecords(JSON.serialize(rrq) , JSON.serialize(members));
            
        }
        Test.stopTest();
    }
    
    
}