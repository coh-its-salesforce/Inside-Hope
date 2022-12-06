/*
 * Unit tests for the ITSProjectIntakeRequestController.
 * Tim Hughes
 */

// Modified by : Saidaiah surisetti(only program__c field and requester priority related stuff was commented).
@isTest()
private class ITSProjectIntakeRequestControllerTest {
   
    // Variables for creating a test Users
    PRIVATE STATIC FINAL STRING EMAIL = 'TESTUSERDISREGARD@coh.org';
	PRIVATE STATIC FINAL STRING LAST_NAME = 'Wayne';
	PRIVATE STATIC FINAL STRING ALIAS = 'Batman';
	PRIVATE STATIC FINAL STRING TIME_ZONE_SID_KEY = 'America/Los_Angeles';
	PRIVATE STATIC FINAL STRING LANGUAGE_LOCALE_KEY = 'en_US';
	PRIVATE STATIC FINAL STRING LOCALE_SID_KEY = 'en_US';
	PRIVATE STATIC FINAL STRING EMAIL_ENCODING_KEY = 'UTF-8';
	PRIVATE STATIC FINAL STRING EMPLOYEE_NUMBER = '123456';
    PRIVATE STATIC FINAL STRING ITLT = 'ITLT';
    PRIVATE STATIC FINAL STRING ITLT_OWNER_FIRST_NAME = 'Scott';
    PRIVATE STATIC FINAL STRING ITLT_OWNER_LAST_NAME = 'Catherall';
	private static User mTestUser;
    private static User mTestITLTOwner;
    
    // Variables for creating the PeopleSoft__c records
    PRIVATE STATIC FINAL STRING VALID_DEPARTMENT = 'ITS - CRM & Philanthropy';
    PRIVATE STATIC FINAL STRING INVALID_DEPARTMENT = 'Something Else';
    private static PeopleSoft__c peopleSoftObject;
    
    // Variables for the TPO_Project_Portfolio__c record
    PRIVATE STATIC FINAL DATE TPO_DATE = date.today();
    PRIVATE STATIC FINAL STRING TPO_REQUEST_CATEGORY = 'Compliance';
    PRIVATE STATIC FINAL STRING TPO_BUDGET_CATEGORY = 'Pre-allocated';
    PRIVATE STATIC FINAL STRING TPO_PROPOSED_NAME = 'Tim\'s Unit Test';
    PRIVATE STATIC FINAL STRING TPO_FUNDING_TYPE = 'Capex';
    PRIVATE STATIC FINAL STRING TPO_ALTERNATIVE_PROPOSED_NAME = 'See above';
    PRIVATE STATIC FINAL STRING TPO_FUNDING_SOURCE = 'Enterprise/Strategic Reserves';
    //PRIVATE STATIC FINAL STRING TPO_PROGRAM = 'Epic';
    PRIVATE STATIC FINAL STRING TPO_REGULATORY = 'Yes';
    PRIVATE STATIC FINAL STRING TPO_PROJECT_SIZE = 'Small';
    PRIVATE STATIC FINAL STRING TPO_REQUESTER_PRIORITY = '3-Medium (Work arounds exist)';
    PRIVATE STATIC FINAL STRING VALID_IT_OWNER = 'Catherall, Scott';
    PRIVATE STATIC FINAL STRING INVALID_IT_OWNER = 'Lee, Pearl'; // This value is determined by the DEFAULT_IT_OWNER property in the controller.

	
    private static User mThisUser;
    private static ITSProjectIntakeRequestController mController;
    private static TPO_Project_Portfolio__c mTPOProjectPorftolio;
    
    
    static {
        mThisUser = [SELECT id FROM User WHERE Id =: UserInfo.getUserId()];
        createUserRecord();
    }
    
    //------------ Test Methods ------------//
    
    // correct information entered with valid Department
    @isTest
    private static void test0() {
        createPeopleSoftRecord(true, VALID_DEPARTMENT);
        createController();
        
        Test.startTest();
        mController.submitRequest();
        List<TPO_Project_Portfolio__c> TPOList = new List<TPO_Project_Portfolio__c>([SELECT id FROM TPO_Project_Portfolio__c WHERE id =: mController.mPortfolioObject.id]);
        System.assertEquals(true, TPOList.size() == 1);
        System.assertEquals(VALID_IT_OWNER, mController.mPortfolioObject.IT_Owner__c);
        Test.stopTest();
    }    

    // correct information entered with invalid department
    @isTest
    private static void test01InvalidDepartment() {
        createPeopleSoftRecord(true, INVALID_DEPARTMENT);
        createController();
        
        Test.startTest();
        mController.submitRequest();
        List<TPO_Project_Portfolio__c> TPOList = new List<TPO_Project_Portfolio__c>([SELECT id FROM TPO_Project_Portfolio__c WHERE id =: mController.mPortfolioObject.id]);
        System.assertEquals(true, TPOList.size() == 1);
        System.assertEquals(INVALID_IT_OWNER, mController.mPortfolioObject.IT_Owner__c);
        Test.stopTest();
    }    

    // correct information with Peoplesoft object ILTL Name != any picklist value
    @isTest
    private static void test02InvalidITLTName() {
        createPeopleSoftRecord(false, VALID_DEPARTMENT);
        createController();
        
        Test.startTest();
        mController.submitRequest();
        List<TPO_Project_Portfolio__c> TPOList = new List<TPO_Project_Portfolio__c>([SELECT id FROM TPO_Project_Portfolio__c WHERE id =: mController.mPortfolioObject.id]);
        System.assertEquals(true, TPOList.size() == 1);
        System.assertEquals(INVALID_IT_OWNER, mController.mPortfolioObject.IT_Owner__c);        
        Test.stopTest();
    }   

    // attempting to save with invalid information
    @isTest
    private static void test03InvalidTPOProjectPortfolio() {
        createPeopleSoftRecord(false, VALID_DEPARTMENT);
        createController();
        mController.mPortfolioObject.Budget_Category__c = TPO_PROJECT_SIZE;
       
        	
        Test.startTest();
        mController.submitRequest();
        List<TPO_Project_Portfolio__c> TPOList = new List<TPO_Project_Portfolio__c>([SELECT id FROM TPO_Project_Portfolio__c WHERE id =: mController.mPortfolioObject.id]);
        System.assertEquals(true, TPOList.size() == 0);      
        Test.stopTest();
    }  
    
    @isTest
    private static void test04NoPeopleSoftRecord() {
        createController();
        
        Test.startTest();
        mController.submitRequest();
        List<TPO_Project_Portfolio__c> TPOList = new List<TPO_Project_Portfolio__c>([SELECT id FROM TPO_Project_Portfolio__c WHERE id =: mController.mPortfolioObject.id]);
        System.assertEquals(true, TPOList.size() == 1);
        System.assertEquals(INVALID_IT_OWNER, mController.mPortfolioObject.IT_Owner__c);        
        Test.stopTest();
    }      
    
    //------------ Setup Methods ------------//

    /*
     * This function creates a new ITSProjectIntakeRequestController and enters information for the mPortfolioObject property.
     */ 
    private static void createController() {
        mController = new ITSProjectIntakeRequestController();
/*      These values are required by the visual force page, not the object so no need to include them in tests...
 * 		mController.mPortfolioObject.Request_Date__c = TPO_DATE;
        mController.mPortfolioObject.Request_Category__c = TPO_REQUEST_CATEGORY;
        mController.mPortfolioObject.Budget_Category__c = TPO_BUDGET_CATEGORY;
        mController.mPortfolioObject.Request_Name__c = TPO_PROPOSED_NAME;
        mController.mPortfolioObject.Funding_Type__c = TPO_FUNDING_TYPE;
        mController.mPortfolioObject.Alternate_Request_Name__c = TPO_ALTERNATIVE_PROPOSED_NAME;
        mController.mPortfolioObject.Funding_Source__c = TPO_FUNDING_SOURCE;
        mController.mPortfolioObject.Program__c = TPO_PROGRAM;
        mController.mPortfolioObject.Regulatory__c = TPO_REGULATORY;
        mController.mPortfolioObject.Project_Size__c = TPO_PROJECT_SIZE;
        mController.mPortfolioObject.Requester_Priority__c = TPO_REQUESTER_PRIORITY;
        mController.mPortfolioObject.Requested_Project_Start_Date__c = TPO_DATE;
        mController.mPortfolioObject.Requested_Project_End_Date__c = TPO_DATE;
*/
        mController.mPortfolioObject.Requester_Name__c = mTestUser.Id;
    }
    
    /*
     * Creates a PeopleSoft record for the purposes of testing. There is a process that automatically sets the ITLT Owner of a created PeopleSoft record. So I have to create the record and then update it in order
     * to correctly set the values for ITLT_Owner__c
     * 
     * @param boolean validITLTName 				determines whether the ITLTName field on the created record should have a matching value in the IT_Owner picklist in the TPO_Project_Portfolio object.
     * @param string departmentName					the name of the department
     */ 
    private static void createPeopleSoftRecord(boolean validITLTName, string departmentName) {
        peopleSoftObject = new PeopleSoft__c();
        peopleSoftObject.Name = departmentName;
        
        System.runAs(mThisUser) {
            insert peopleSoftObject;
        }
        
        if (validITLTName){
            peopleSoftObject.ITLT_Owner__c = mTestITLTOwner.Id;
        }
        else {
            peopleSoftObject.ITLT_Owner__c = mTestUser.Id;
        } 
        
        System.runAs(mThisUser) {
            update peopleSoftObject;
        }
        
        if (validITLTName) {
         	System.assertEquals(mTestITLTOwner.id, peopleSoftObject.ITLT_Owner__c);
            System.assertEquals(departmentName, peopleSoftObject.Name);
        }
        else {
            System.assertEquals(mTestUser.id, peopleSoftObject.ITLT_Owner__c);
            System.assertEquals(departmentName, peopleSoftObject.Name);
        }   
    }
    
	/*
	 * Creates two user objects for testing.
	 * One is the user who will be assigned as a requester in the TPO_Project_Intake_Request object. The other is used as the ITLT_Owner in the PeopleSoft object.
	 */ 
    private static void createUserRecord() {
		Id mProfileId = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
		List<User> usersToInsert = new List<User>();
        
        mTestUser = new User();
		mTestUser.Username = EMAIL;
		mTestUser.Email = EMAIL;
		mTestUser.LastName = LAST_NAME;
		mTestUser.Alias = ALIAS;
		mTestUser.CommunityNickname = LAST_NAME; 
		mTestUser.TimeZoneSidKey = TIME_ZONE_SID_KEY;
		mTestUser.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
		mTestUser.LocaleSidKey = LOCALE_SID_KEY;
		mTestUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
		mTestUser.ProfileId = mProfileId;
		mTestUser.IsActive = true;
		mTestUser.EmployeeNumber = EMPLOYEE_NUMBER;
        mTestUser.Department = VALID_DEPARTMENT;
		usersToInsert.add(mTestUser);
	        
        mTestITLTOwner = new User();
		mTestITLTOwner.Username = ITLT + EMAIL;
		mTestITLTOwner.Email = ITLT + EMAIL;
        mTestITLTOwner.FirstName = ITLT_OWNER_FIRST_NAME;
		mTestITLTOwner.LastName = ITLT_OWNER_LAST_NAME;
		mTestITLTOwner.Alias = ITLT;
		mTestITLTOwner.CommunityNickname =  ITLT; 
		mTestITLTOwner.TimeZoneSidKey = TIME_ZONE_SID_KEY;
		mTestITLTOwner.LanguageLocaleKey = LANGUAGE_LOCALE_KEY;
		mTestITLTOwner.LocaleSidKey = LOCALE_SID_KEY;
		mTestITLTOwner.EmailEncodingKey = EMAIL_ENCODING_KEY;
		mTestITLTOwner.ProfileId = mProfileId;
		mTestITLTOwner.IsActive = true;
		mTestITLTOwner.EmployeeNumber = EMPLOYEE_NUMBER;
        mTestITLTOwner.Department = VALID_DEPARTMENT;
		usersToInsert.add(mTestITLTOwner);  
        
		System.runas(mThisUser) {
			Database.insert(usersToInsert);            
		}        
        
    }
}