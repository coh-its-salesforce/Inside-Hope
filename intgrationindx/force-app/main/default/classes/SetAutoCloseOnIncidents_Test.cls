/**
    * @name -- SetAutoCloseOnIncidents_Test 
    * @author : veenesh.vikram
   * @description -- Test Class for Batch Class setAutoCloseOnIncidents
*/
@isTest
Private Class SetAutoCloseOnIncidents_Test{
    private static testmethod void testAutoClose(){
     
        //Test Starts
        Test.StartTest();
                
        // Prepare test data

        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];
        
        List<BMCServiceDesk__Status__c> statusList = new List<BMCServiceDesk__Status__c>();
        
        //Create Resolved Status
        BMCServiceDesk__Status__c resolvedtatus = new BMCServiceDesk__Status__c(Name='RESOLVED',BMCServiceDesk__appliesToIncident__c=true);
        statusList.add(resolvedtatus);
        
        //Create a New Status
        BMCServiceDesk__Status__c newstatus = new BMCServiceDesk__Status__c(Name='OPEN',BMCServiceDesk__appliesToIncident__c=true);
        statusList.add(newstatus);
        
        insert statusList ;
        
        //Create an Impact
        BMCServiceDesk__Impact__c testImpact = new BMCServiceDesk__Impact__c(name = 'Test Impact');
        insert testImpact ;
        
        //Create an urgency
        BMCServiceDesk__Urgency__c testUrgency = new BMCServiceDesk__Urgency__c(name = 'Test Urgency');
        insert testUrgency ;
        
        //Create a Configuration Item
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'testCI',BMCServiceDesk__Name__c='testCI');
        insert ci;
        
        //Create Category
        BMCServiceDesk__Category__c categoryTest = new BMCServiceDesk__Category__c(Name = 'Test Cat',BMCServiceDesk__AvailableForIncidents__c = True);
        insert categoryTest;
        
        //Create a Account.
        Account acc = new Account(name = 'testAcc',Default_Account__c = true);
        insert acc;
        
        //Create a Custom Setting record which stores the CI to Queue Association.
        CItoQueueMapping__c setting = new CItoQueueMapping__c(name='testCI',Queue__c = 'ITSM');
        insert setting;
        
        //Insert Incident Record.
        List<BMCServiceDesk__Incident__c> incidentList = new List<BMCServiceDesk__Incident__c>();
        
        BMCServiceDesk__Incident__c incident= new BMCServiceDesk__Incident__c(
                                                                      BMCServiceDesk__FKStatus__c = statusList[1].id,
                                                                      BMCServiceDesk__FKImpact__c = testImpact.id,
                                                                      BMCServiceDesk__FKUrgency__c = testUrgency.id,
                                                                      Summary__c = 'testRecord',
                                                                      BMCServiceDesk__incidentDescription__c = 'Test Record',
                                                                      BMCServiceDesk__FKBMC_BaseElement__c = ci.id,
                                                                      BMCServiceDesk__FKCategory__c = categoryTest.id,
            														  ownerId = qSobj.queueid);
        insert incident;
        
        //Update Incident record-moving the status to RESOLVED

// Commented out because this executes too many SOQL queries.
// Raymond Tam
//        incident.BMCServiceDesk__FKStatus__c = statusList[0].id;
        incident.BMCServiceDesk__ClosureCategory__c = 'Test Close';
        incident.BMCServiceDesk__incidentResolution__c = 'Test Resolution';
        incident.BMCServiceDesk__FKOpenBy__c = UserInfo.getUserId();
        update incident;
        
        incident.AutoCloseDate__c = System.Today()-1;

        update incident;


        SetAutoCloseOnIncidents c = new SetAutoCloseOnIncidents();
        Database.executeBatch(c);
        
        Test.stopTest();

    }
}