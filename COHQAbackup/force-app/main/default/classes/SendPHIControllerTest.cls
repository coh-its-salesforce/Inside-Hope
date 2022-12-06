@isTest
public class SendPHIControllerTest {
    FINAL STATIC STRING ACCOUNT_PERSON_EMAIL ='sendphicontrollertest_getacc@coh.org';
    FINAL STATIC STRING ACCOUNT_LAST_NAME = 'ControllerTest_getacc';
    FINAL STATIC STRING ACCOUNT_FIRST_NAME = 'SendPHI';
    
    FINAL STATIC STRING CONTACT_EMAIL = 'sendphicontrollertest_getcase@coh.org';
    FINAL STATIC STRING CONTACT_LAST_NAME = 'ControllerTest_getcase';
    
    @isTest
    static void getacc() {
        Account testAccount = new Account();
        Account queriedAccount = new Account();
        
        Test.startTest();
        testAccount.PersonEmail = ACCOUNT_PERSON_EMAIL;
        testAccount.LastName = ACCOUNT_LAST_NAME;
        testAccount.FirstName = ACCOUNT_FIRST_NAME;
        insert testAccount;
        
        queriedAccount = SendPHIController.getacc(testAccount.id);
        System.assertEquals(testAccount.PersonEmail, queriedAccount.PersonEmail);
        System.assertEquals(testAccount.LastName, queriedAccount.LastName);
        System.assertEquals(testAccount.FirstName, queriedAccount.FirstName);
        System.assertEquals(testAccount.id, queriedAccount.id);
        System.assertEquals(testAccount.id, queriedAccount.COH_Account_ID__c); // COH_Account_ID__c is a formula field that just copies the id.
        Test.stopTest();
	}
    
    @isTest
    static void getcase() {
        Case testCase = new Case();
        Case queriedCase = new Case();
        Contact testContact = new Contact();
        
        Test.startTest();
        testContact.Email = CONTACT_EMAIL;
        testContact.LastName = CONTACT_LAST_NAME; 
        insert testContact;
        
        testCase.ContactId = testContact.id;
        insert testCase;
        
        queriedCase = SendPHIController.getcase(testCase.id);
        System.assertEquals(queriedCase.Contact_Email__c, testContact.Email);
        System.assertEquals(queriedCase.id, testCase.id);
        System.assertEquals(queriedCase.contact.id, testContact.id);
        Test.stopTest();
    }
}