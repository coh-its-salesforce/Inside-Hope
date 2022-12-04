@isTest
public class COH_UTIL_DependentPicklistControllerTest {
    PRIVATE STATIC FINAL STRING SOBJECT_API_NAME = 'Contact';
    PRIVATE STATIC FINAL STRING CONTROLLING_PICKLIST_API_NAME = 'COH_UTIL_ControllingPicklist__c';
    PRIVATE STATIC FINAL STRING DEPENDENT_PICKLIST_API_NAME = 'COH_UTIL_DependentPicklist__c';
    PRIVATE STATIC FINAL STRING NON_PICKLIST_FIELD = 'Name';
    PRIVATE STATIC FINAL STRING INVALID_API_NAME = 'Bad Name';
    PRIVATE STATIC FINAL MAP<STRING, LIST<STRING>> CONTROLLING_PICKLIST_VALUES = NEW MAP<STRING, LIST<STRING>>();
    
    // This should be true, but in the case that the controlling/dependent picklist is changed and the test needs to be updated... then the tests can be turned off TEMPORARILY.
    private static boolean mRunTests = true;
    
    static void setup() {
 		List<String> dependentList1 = new List<String> {'Dependent Test 1','Dependent Test 2','Dependent Test 3'};
        List<String> dependentList2 = new List<String> {'Dependent Test 4','Dependent Test 5','Dependent Test 6'};
        List<String> dependentList3 = new List<String> {'Dependent Test 7','Dependent Test 8','Dependent Test 9'}; 
        
        CONTROLLING_PICKLIST_VALUES.put('Controlling Test 1', dependentList1);
        CONTROLLING_PICKLIST_VALUES.put('Controlling Test 2', dependentList2);
        CONTROLLING_PICKLIST_VALUES.put('Controlling Test 3', dependentList3);
    }
    
    /*
     * This tests the standard flow of the controller.
     */
    @isTest
    static void test01_StandardFlow() {
        if (mRunTests) {
            Map<String, List<String>> results;
            setup();
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(SOBJECT_API_NAME, CONTROLLING_PICKLIST_API_NAME, DEPENDENT_PICKLIST_API_NAME);
            test.stopTest();
            System.assertEquals(CONTROLLING_PICKLIST_VALUES, results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test02_InvalidSObjectAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(INVALID_API_NAME, CONTROLLING_PICKLIST_API_NAME, DEPENDENT_PICKLIST_API_NAME);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test03_NullSObjectAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(null, CONTROLLING_PICKLIST_API_NAME, DEPENDENT_PICKLIST_API_NAME);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test04_InvalidControllingPicklistAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(SOBJECT_API_NAME, INVALID_API_NAME, DEPENDENT_PICKLIST_API_NAME);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test05_NullControllingPicklistAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(SOBJECT_API_NAME, null, DEPENDENT_PICKLIST_API_NAME);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test06_InvalidDependentPicklistAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(SOBJECT_API_NAME, CONTROLLING_PICKLIST_API_NAME, INVALID_API_NAME);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
    
    /*
     * 
     */
    @isTest
    static void test07_NullDependentPicklistAPIName() {
        if (mRunTests) {
            Map<String, List<String>> results;
            
            test.startTest();
            results = COH_UTIL_DependentPicklistController.getPicklistOptionsServer(SOBJECT_API_NAME, CONTROLLING_PICKLIST_API_NAME, null);
            test.stopTest();
            System.assertEquals(new Map<String, List<String>>(), results);
        }
    }
}