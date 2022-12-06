@isTest(SeeAllData=true)
private class TestLookupCOH{

    static testMethod void TestLookup(){
        // The ITSM queue has been removed from Prod, so a new related queue needs to be retrieved dynamically
        // Raymond Tam
//        Group grp = [SELECT id FROM Group where type = 'Queue' AND name='ITSM' LIMIT 1];
		QueueSobject qSobj = [select id, queueid, sobjecttype, createdbyid, systemmodstamp from QueueSobject where SobjectType = 'BMCServiceDesk__Incident__c' limit 1];
        BMCServiceDesk__Impact__c impTest = new BMCServiceDesk__Impact__c(Name='Testing');
        BMCServiceDesk__Urgency__c urgTest = new BMCServiceDesk__Urgency__c(Name='UrgencyTest');
        BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);

        test.startTest();

        insert parent;
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent.Id);
        insert child;
        insert impTest;
        insert urgTest;
        User client = [select Id from User where IsActive = true limit 1];
        BMCServiceDesk__Incident__c incident = new BMCServiceDesk__Incident__c(Summary__c = 'Unit Test', BMCServiceDesk__FKClient__c = client.Id,
                                                                                Parent_Category__c = parent.Id, Sub_Category__c = child.Id, BMCServiceDesk__ClosureCategory__c = 'Solution Applied by IT Analyst',
                                                                                BMCServiceDesk__incidentResolution__c = 'Test',BMCServiceDesk__incidentDescription__c = 'Test', ownerId = qSobj.queueid);
        insert incident;
        
        autoCompleteController auto = new autoCompleteController();
        COHAutoCompleteController cohauto = new COHAutoCompleteController();
        PageReference pageRef = Page.IncidentCustomEdit;
        Test.setCurrentPage(pageRef);
        
        
        //LookupController controller = new LookupController();
        //ApexPages.StandardController controller = new ApexPages.StandardController();
        LookupController controller = new LookupController(new ApexPages.StandardController(incident));
        List<SelectOption> impList = new List<SelectOption>(controller.ImpactList);
        List<SelectOption> urgList = new List<SelectOption>(controller.UrgencyList);        
        incident.BMCServiceDesk__incidentResolution__c = 'Test Resolution';
        //controller = new LookupController();

        controller.mysave();
        
        test.stopTest();
        
        COHTreeController con = new COHTreeController();
        PageReference pageRef2 = Page.COHCategoryTree;
        Test.setCurrentPage(pageRef2);
        
        List<BMCServiceDesk__Category__c> cat = [Select Id, Name from BMCServiceDesk__Category__c Limit 1];
        
        //con.TreeModel tm = new con.TreeModel();
        
        List<sObject> lstUser = new List<sObject>();
        lstUser = autoCompleteController.findSObjects('User', 'Select Id, Name From User Limit 1', '');
        
        List<sObject> lstUser2 = new List<sObject>();
        lstUser2 = COHAutoCompleteController.findSObjects('User', 'Select Id, Name From User Limit 1', '');
        
        
        
    }
    
}