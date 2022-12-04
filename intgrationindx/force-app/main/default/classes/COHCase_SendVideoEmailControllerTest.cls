@isTest
public class COHCase_SendVideoEmailControllerTest {
    
    private static final String COHMRN1 = '00000000000001';  
    @isTest
    static void sendVideoEmailTest(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = COHUtil.getRecordType('Account', 'Patient (Screen Unification)');
        accountObj0.FirstName = 'USER_FIRST_NAME0';
        accountObj0.LastName = 'USER_LAST_NAME0';
        accountObj0.Patient_Status__c = 'In Progress';
        accountObj0.Status_Reason__c = 'This is a test';
        accountObj0.COH_MRN__c = COHMRN1;
        INSERT accountObj0;
        Contact contactObj0 = [select Id, AccountId from Contact where AccountId = :accountObj0.Id limit 1];
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = COHUtil.getRecordType('Case', 'Patient Referral Services');
        caseObj1.Origin = 'ACD';       
        caseObj1.Action_Taken__c = 'EMAIL SENT';
        caseObj1.Status = 'New';
        caseObj1.Caller_First_Name__c = 'USER_FIRST_NAME4';
        caseObj1.Caller_Last_Name__c = 'USER_LAST_NAME4';
        caseObj1.AccountId = accountObj0.Id;
        caseObj1.Warm_Handoff__c = 'Yes';
        caseObj1.ContactId = contactObj0.Id;
        INSERT caseObj1;
        COHCase_SendVideoEmailController.sendVideoEmail(caseObj1.Id);
    }
}