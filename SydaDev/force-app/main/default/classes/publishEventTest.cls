@istest
public class publishEventTest {

    testmethod static void met1(){
        publishEvent.publishEvent('');
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Account accountRec = new Account();
        accountRec.LastName = 'Test';
        accountRec.FirstName = 'TestFirst';
        accountRec.Coh_mrn__c ='123232';
        insert accountRec;
        
        lead leadRec = new Lead();
        leadRec.LastName = 'Test1';
        leadRec.FirstName = 'TestFirst';
        
        Case newCase = new Case();
       
        COH_LeadCaseCreation.saveCaseLead(leadRec , newCase, accountRec.Id,null);
        case rec = [Select id from case];
        
        publishEvent.ValidateForms(rec.Id,'saveAll');
    }
}