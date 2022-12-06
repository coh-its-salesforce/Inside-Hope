/**
 * @author................. Sanjay Singh 
 * @version................ 1.0.0
 * @description.............Test Class for Trigger ApplicationRequestTrigger and it's Helper class
 *
 **/ 
@isTest
public class ApplicationRequestTriggerTest {
    /*
     * UNit test Method
     **/
    private static testmethod void myUnitTest(){
        List<New_Application_Request__c> appReqts= new  List<New_Application_Request__c>();
        List<Database.SaveResult> SaveResults = new List<Database.SaveResult>();
        id userID =  userINfo.getUserId();
        //Create Application Request record 
        // For Bulk Testing creating 100 Records
        for(integer i=0; i<100; i++){
            New_Application_Request__c appReq = new New_Application_Request__c();
            // Assigning Unique Name To Application 
            appreq.Application_Name__c = 'TESTAPP-'+i;
            appreq.IT_Owner__c = userID;
            appreq.IT_Manager__c = userID;
            //appreq.Application_Type__c = 'Business';
            appreq.Application_Type__c = 'Business Application';
            appreq.Primary_Support_Analyst__c = userID;
            appreq.Secondary_Support_Analyst__c = userID;
            appreq.Business_Owner__c = userID;
            appReqts.add(appreq);
        } 
        
        SaveResults = database.insert(appReqts, false);
        // Check All request should insert successfully
        for(integer i=0; i<100; i++){
            system.assert(SaveResults[i].isSuccess());
            // Also change status to apprve
            //appReqts[i].Status__c = 'Approved';
            appReqts[i].Application_Status__c = 'Approved';
        }
        // query Base Element record, ...Currently there should be no record because we have not
        // Approved request yet
        List<BMCServiceDesk__BMC_BaseElement__c> baseElements = new List<BMCServiceDesk__BMC_BaseElement__c>([Select Id from BMCServiceDesk__BMC_BaseElement__c]);
        System.assert(baseElements.isEmpty());
        //Update Now
        SaveResults = database.update(appReqts, false);
        // Query Again ...Now system should have return 100 base element records 
        // because we have created 100 unique app Request
        baseElements = new List<BMCServiceDesk__BMC_BaseElement__c>([Select Id from BMCServiceDesk__BMC_BaseElement__c]);
        System.assert(!baseElements.isEmpty());
        System.assertEquals(100, baseElements.size());
        
        appReqts= new  List<New_Application_Request__c>();
        // Again create request to update applicatoins which are already exist in system
        for(integer i=0; i<10; i++){
            New_Application_Request__c appReq = new New_Application_Request__c();
            // already available application Names
            appreq.Application_Name__c = 'TESTAPP-'+i;
            appreq.IT_Owner__c = userID;
            appreq.IT_Manager__c = userID;
            //appreq.Application_Type__c = 'Web App';
            appreq.Application_Type__c = 'Business Application';
            appreq.Primary_Support_Analyst__c = userID;
            appreq.Secondary_Support_Analyst__c = userID;
            appreq.Business_Owner__c = userID;
            appReqts.add(appreq);
        }
        
        SaveResults = database.insert(appReqts, false);
        // change status to approved
        for(integer i=0; i<10; i++){
            system.assert(SaveResults[i].isSuccess());
            //appReqts[i].Status__c = 'Approved';
              appReqts[i].Application_Status__c = 'Approved';
        }
        SaveResults = database.update(appReqts, false);
        // No new base element should insert , it should remain 100
        baseElements = new List<BMCServiceDesk__BMC_BaseElement__c>([Select Id from BMCServiceDesk__BMC_BaseElement__c]);
        System.assertEquals(100, baseElements.size());
    }
}