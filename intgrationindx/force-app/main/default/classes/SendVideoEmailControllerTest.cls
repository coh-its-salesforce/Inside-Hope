@isTest
public class SendVideoEmailControllerTest {
    
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
        accountObj0.PersonEmail = 'sam@invalid.com';
        INSERT accountObj0;
        SendVideoEmailController.sendEmail(accountObj0.Id);
    }
}