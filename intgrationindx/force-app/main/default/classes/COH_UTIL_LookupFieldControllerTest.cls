@isTest
public class COH_UTIL_LookupFieldControllerTest {
    
    PRIVATE STATIC FINAL STRING SOBJECT_API_NAME = 'Account';
    PRIVATE STATIC FINAL STRING PRIMARY_FIELD_API_NAME = 'Name';
    PRIVATE STATIC FINAL STRING SECONDARY_FIELD_API_NAME = 'Site';
    
    PRIVATE STATIC FINAL STRING TEST_RECORD_NAME1 = 'Bob Loblaw';
    PRIVATE STATIC FINAL STRING TEST_RECORD_SITE1 = 'Bob Loblaws law blog';
    PRIVATE STATIC FINAL STRING TEST_RECORD_NAME2 = 'Bobby Hill';
    PRIVATE STATIC FINAL STRING TEST_RECORD_SITE2 = 'Strickland Propane';
    PRIVATE STATIC FINAL STRING TEST_RECORD_NAME3 = 'Spongebob Squarepants';
    PRIVATE STATIC FINAL STRING TEST_RECORD_NAME4 = 'Robert Baratheon';
    PRIVATE STATIC FINAL STRING TEST_RECORD_SITE4 = 'Winterfell';
    
    
    PRIVATE STATIC FINAL STRING SEARCH_STRING_WITH_RESULTS = 'Bob';
    PRIVATE STATIC FINAL STRING BAD_INPUT = 'jklahsdfasdf';
	PRIVATE STATIC FINAL INTEGER EXPECTED_NUMBER_OF_RECORDS = 3;
    PRIVATE STATIC FINAL INTEGER EXPECTED_NUMBER_OF_RECORDS_WITH_ADDITIONAL_CONDITIONS = 1;
    PRIVATE STATIC FINAL STRING ADDITIONAL_WHERE = 'AND Site = \'' + TEST_RECORD_SITE2 + '\'';
    PRIVATE STATIC FINAL STRING ADDITIONAL_SELECT = 'Site';
    
    
    PRIVATE STATIC FINAL STRING INVALID_ID_ERROR_MESSAGE = 'Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:Invalid Id';
    PRIVATE STATIC FINAL STRING BAD_QUERY_ERROR_MESSAGE = 'Class:COH_UTIL_LookupFieldController Method:getPrimaryFieldServer Error:There was an error querying the database';
    private static Account mTestRecord1;
    private static Account mTestRecord2;
    private static Account mTestRecord3;
    private static Account mTestRecord4;
    
    
    /*
     * Tests the standard flow for the GetPrimaryFieldSever method. 
     * Supplies a valid Id, SObject Name and Field name
     */ 
    @isTest
    public static void Test1_getPrimaryFieldServer_StandardFlow() {
        createTestRecord();
        
       	test.startTest();
        Object testResult = COH_UTIL_LookupFieldController.getPrimaryFieldServer(mTestRecord1.id, PRIMARY_FIELD_API_NAME, SOBJECT_API_NAME);
        test.stopTest();
        
        System.assertEquals(TEST_RECORD_NAME1, testResult);
    }
    
    /*
     * Tests the GetPrimaryFieldServer method when no recordId
     * Should recieve a exception stating the ID is Invalid
     */ 
    @isTest
    public static void Test2_getPrimaryFieldServer_InvalidRecordId() {
        String errorMessage;
        createTestRecord();
        
        test.startTest();
        try {
            Object testResult = COH_UTIL_LookupFieldController.getPrimaryFieldServer('', PRIMARY_FIELD_API_NAME, SOBJECT_API_NAME);
        }
        catch (AuraHandledException e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        
        System.assertEquals(INVALID_ID_ERROR_MESSAGE, errorMessage);
        
    } 
    
    /*
     * Tests the GetPrimaryFieldServer method when no primaryField is supplied.
     * Should recieve an exception that there was an error querying the DB
     */ 
    @isTest
    public static void Test3_getPrimaryFieldServer_InvalidPrimaryField() {
        String errorMessage;
        createTestRecord();
        
        test.startTest();
        try {
            Object testResult = COH_UTIL_LookupFieldController.getPrimaryFieldServer(mTestRecord1.id, '', SOBJECT_API_NAME);
        }
        catch (AuraHandledException e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        
        System.assertEquals(BAD_QUERY_ERROR_MESSAGE, errorMessage);
    }

    /*
     * Tests the GetPrimaryFieldServer method when no SObjectAPIName is supplied.
     * Should recieve an exception that there was an error querying the DB
     */     
    @isTest
    public static void Test4_getPrimaryFieldServer_InvalidSObjectAPIName() {
        String errorMessage;
        createTestRecord();
        
        test.startTest();
        try {
            Object testResult = COH_UTIL_LookupFieldController.getPrimaryFieldServer(mTestRecord1.id, PRIMARY_FIELD_API_NAME, '');
        }
        catch (AuraHandledException e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        
        System.assertEquals(BAD_QUERY_ERROR_MESSAGE, errorMessage);        
    }
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test5_fetchLookUpValues_StandardFlow() {
        createTestRecord();
        
        test.startTest();
        List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, SOBJECT_API_NAME, PRIMARY_FIELD_API_NAME, SECONDARY_FIELD_API_NAME, 5, '', ''), List<SearchResultWrapper>.class);
        test.stopTest();
        
        System.assertEquals(EXPECTED_NUMBER_OF_RECORDS, testResult.size());
    }
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test6_fetchLookUpValues_AdditionalConditions() {
        createTestRecord();
        
        test.startTest();
        List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, SOBJECT_API_NAME, PRIMARY_FIELD_API_Name, '', 5, ADDITIONAL_WHERE, ADDITIONAL_SELECT), List<SearchResultWrapper>.class);
        test.stopTest();
        
        System.assertEquals(EXPECTED_NUMBER_OF_RECORDS_WITH_ADDITIONAL_CONDITIONS, testResult.size());
    }         
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test7_fetchLookUpValues_NullSObjectAPIName() {
        createTestRecord();
        
        test.startTest();
        try {
            List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, '', PRIMARY_FIELD_API_NAME, SECONDARY_FIELD_API_NAME, 5, '', ''), List<SearchResultWrapper>.class);            
        }
        catch (Exception e) {
            
        }
        test.stopTest();
        
        //System.assertEquals(0, testResult.size());
    }
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test8_fetchLookUpValues_InvalidSObjectAPIName() {
        createTestRecord();
        
        test.startTest();
        try {
            List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, BAD_INPUT, PRIMARY_FIELD_API_NAME, SECONDARY_FIELD_API_NAME, 5, '', ''), List<SearchResultWrapper>.class);            
        }
        catch (Exception e) {
            
        }
        test.stopTest();
        
        //System.assertEquals(0, testResult.size());
    }    
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test9_fetchLookUpValues_NullPrimaryFieldAPIName() {
        createTestRecord();
        
        test.startTest();
        try {
            List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, SOBJECT_API_NAME, '', SECONDARY_FIELD_API_NAME, 5, '', ''), List<SearchResultWrapper>.class);            
        }
        catch (Exception e) {
            
        }
        test.stopTest();
        
        //System.assertEquals(0, testResult.size());
    }
    
    /*
     * Tests the fetchLookupValues method's standard flow
     */ 
    @isTest 
    public static void Test10_fetchLookUpValues_InvalidPrimaryFieldAPIName() {
        createTestRecord();
        
        test.startTest();
        try {
            List<SearchResultWrapper> testResult = (List<SearchResultWrapper>)JSON.deserialize(COH_UTIL_LookupFieldController.fetchLookUpValues(SEARCH_STRING_WITH_RESULTS, SOBJECT_API_NAME, BAD_INPUT, SECONDARY_FIELD_API_NAME, 5, '', ''), List<SearchResultWrapper>.class);            
        }
        catch (Exception e) {
            
        } 
        test.stopTest();
        
        //System.assertEquals(0, testResult.size());
    }    


    
    
//------------------ Private Methods ------------------//
	
    private static void createTestRecord() {
        List<Account> recordsToAdd = new List<Account>();
        
        mTestRecord1 = new Account();
        mTestRecord1.Name = TEST_RECORD_NAME1;
        mTestRecord1.Site = TEST_RECORD_SITE1;
        
        
        mTestRecord2 = new Account();
        mTestRecord2.Name = TEST_RECORD_NAME2;
        mTestRecord2.Site = TEST_RECORD_SITE2;
        
        mTestRecord3 = new Account();
        mTestRecord3.Name = TEST_RECORD_NAME3;

        mTestRecord4 = new Account();
        mTestRecord4.Name = TEST_RECORD_NAME4;
        mTestRecord4.Site = TEST_RECORD_SITE4;
        
        recordsToAdd.add(mTestRecord1);
        recordsToAdd.add(mTestRecord2);
        recordsToAdd.add(mTestRecord3);
        recordsToAdd.add(mTestRecord4);
            
        insert recordsToAdd;
    }
    
    public class SearchResultWrapper {
        String id {get;set;}
        String primaryField {get;set;}
        String secondaryField {get;set;}
    }

}