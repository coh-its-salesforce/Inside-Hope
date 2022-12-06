@isTest
public class COH_ITSAssetRequest_IFrameControllerTest {
    PRIVATE STATIC FINAL BOOLEAN RUN_TEST_01 = true;
    
    PRIVATE STATIC FINAL STRING ALIAS = 'test1133';
    PRIVATE STATIC FINAL STRING EMAIL = 'thughes@coh.org';
    PRIVATE STATIC FINAL STRING EMAIL_ENCODING_KEY = 'UTF-8';
    PRIVATE STATIC FINAL STRING LANGUAGE_LOCAL_KEY = 'en_US';
    PRIVATE STATIC FINAL STRING LAST_NAME = 'COH_ITSAssetRequestLastName';
    PRIVATE STATIC FINAL STRING LOCALE_SID_KEY = 'en_US';
    PRIVATE STATIC FINAL STRING TIME_ZONE_SID_KEY = 'America/Los_Angeles';
    PRIVATE STATIC FINAL STRING USERNAME = 'COH_ITSAssetRequestLastName@coh.org.test';
    private static String mProfileId;

    @isTest
    public static void test01_ValidRecordId() {
        
        ITSAssetRequest__c testRecord = new ITSAssetRequest__c();
        List<User> listOfUsers = createUsers(1);
        testRecord.Employee__c = listOfUsers.get(0).Id;
        insert testRecord;
        ITSAssetRequest__c returnedRecord = COH_ITSAssetRequest_IframeController.getITSAssetRecordServer(testRecord.Id);
        System.assertEquals(Decimal.valueOf(listOfUsers.get(0).EmployeeNumber) * 3.14159, Decimal.valueOf(returnedRecord.Employee__r.EmployeeNumber));
    }
    
    @isTest
    public static void test02_InvalidEmployeeNumber() {
        
        ITSAssetRequest__c testRecord = new ITSAssetRequest__c();
        List<User> listOfUsers = createUsers(1);
        testRecord.Employee__c = null;
        insert testRecord;
        try {
         	ITSAssetRequest__c returnedRecord = COH_ITSAssetRequest_IframeController.getITSAssetRecordServer(testRecord.Id);
            System.assertEquals(1,0); // should not reach here
        }
        catch (Exception e) {
            
        }
    }
    
    @isTest
    public static void test03_InvalidRecordId() {
        
        ITSAssetRequest__c testRecord = new ITSAssetRequest__c();
        List<User> listOfUsers = createUsers(1);
        testRecord.Employee__c = listOfUsers.get(0).Id;
        insert testRecord;
        try {
         	ITSAssetRequest__c returnedRecord = COH_ITSAssetRequest_IframeController.getITSAssetRecordServer(UserInfo.getUserId());
            System.assertEquals(1,0); // should not reach here
        }
        catch (Exception e) {
            
        }
    }     
    
    private static List<User> createUsers(Integer numOfUsers) {
        List<User> usersToInsert = new List<User>();
        Id profileId = UserInfo.getProfileId();
        Id currentUser = UserInfo.getUserId();
        User runningUser = [SELECT id FROM User WHERE ProfileId =:profileId AND (NOT Id =:currentUser) AND IsActive = true LIMIT 1];        
        
        for (Integer i = 0; i < numOfUsers; i++) {
            User tempUser = new User();
            tempUser = new User();
            tempUser.Alias = ALIAS;
            tempUser.Email = EMAIL;
            tempUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
            tempUser.LanguageLocaleKey = LANGUAGE_LOCAL_KEY;
            tempUser.LastName = LAST_NAME;
            tempUser.LocaleSidKey = LOCALE_SID_KEY;
            tempUser.ProfileId = profileId;
            tempUser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
            tempUser.Username = USERNAME + '8';
            tempUser.EmployeeNumber = String.valueOf(Math.round((Math.random() * (900000) + 100000)));
            usersToInsert.add(tempUser);
        }
        System.runAs(runningUser) {
            insert usersToInsert;
        }
        return usersToInsert;
    }
}