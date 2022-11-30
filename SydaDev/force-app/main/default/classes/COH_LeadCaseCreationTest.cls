@isTest
public class COH_LeadCaseCreationTest {

    /*testmethod static void saveCaseLead(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        lead leadRec = new Lead();
        leadRec.LastName = 'Test';
        
        Case newCase = new Case();
       
        COH_LeadCaseCreation.saveCaseLead(leadRec , newCase, null,null);
    }*/
    
    testmethod static void saveCaseLeadPersonAccount(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Account accountRec = new Account();
        accountRec.LastName = 'Test';
        accountRec.FirstName = 'TestFirst';
        insert accountRec;
        
        lead leadRec = new Lead();
        leadRec.LastName = 'Test1';
        leadRec.FirstName = 'TestFirst';
        
        Case newCase = new Case();
       
        COH_LeadCaseCreation.saveCaseLead(leadRec , newCase, accountRec.Id,null);
    }
    
    testmethod static void dupeLead(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
                Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Patient').getRecordTypeId();

        lead leadRec = new Lead();
        leadRec.FirstName = 'Test';
        leadRec.LastName = 'Test';
        leadRec.Gender__c = 'Male';
        leadRec.BirthDate__c = Date.today();
        leadRec.recordTypeId = devRecordTypeId;
        insert leadRec;
        
        Case newCase = new Case();
       
        COH_LeadCaseCreation.dupeLeadAccount(leadRec , newCase);
        
        COH_LeadCaseCreation.getCases(null);
    }
    
    testmethod static void dupeAccount(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
                //Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Patient').getRecordTypeId();

        Account accountrec = new Account();
        accountrec.FirstName = 'Test';
        accountrec.LastName = 'Test';
        accountrec.gender__pc = 'Male';
        accountrec.PersonBirthDate = Date.today();
        
        insert accountrec;
        
        lead leadRec = new Lead();
        leadRec.FirstName = 'Test';
        leadRec.LastName = 'Test';
        leadRec.Gender__c = 'Male';
        leadRec.BirthDate__c = Date.today();
        
        Case newCase = new Case();
       
        COH_LeadCaseCreation.dupeLeadAccount(leadRec , newCase);

    }
    
    testmethod static void searchLeadAccount(){
        
        COH_LeadCaseCreation.searchLeadAccount('Test');
        COH_LeadCaseCreation.searchLeadAccount('Test 01/01/1998');
    }
    
    
    testmethod static void convertLead(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        lead leadRec = new Lead();
        leadRec.FirstName = 'Test';
        leadRec.LastName = 'Test';
        leadRec.Gender__c = 'Male';
        leadRec.BirthDate__c = Date.today();
        insert leadRec;
        
        Case newCase = new Case();
        newCase.Lead__c = leadRec.Id;
        insert newCase;
       
        COH_LeadCaseCreation.convertLead(newCase.Id);
    }
}