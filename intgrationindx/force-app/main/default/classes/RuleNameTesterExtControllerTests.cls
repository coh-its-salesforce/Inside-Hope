/* ************************************************************
 
 * Description : Test Class for RuleNameTesterExtControllerTests
 
 * ************************************************************/
@isTest
private class RuleNameTesterExtControllerTests 
{
	    
    @isTest
	private static void test1()
	{
        // create new RuleName__c
		BREeze__RuleName__c rn = new BREeze__RuleName__c();
        //rn.Field_Name__c = 'LastName';
        rn.BREeze__isActive__c = true;
        rn.Name = 'TestClass';
        rn.BREeze__Object_Name__c = 'Lead';
        rn.BREeze__test_ids__c = '01ri0000000SKj1,01ri0000000SKj1,01ri0000000SKj1';
        rn.BREeze__internal_Name__c = 'Test22';
        insert rn;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rn);
        RuleNameTesterExtControllerAddOn testRuleNameTester = new RuleNameTesterExtControllerAddOn(sc);

        System.assertEquals(testRuleNameTester.TestId,'01ri0000000SKj1,01ri0000000SKj1,01ri0000000SKj1');
        testRuleNameTester.runTestForRule();
        
        System.assert(testRuleNameTester.results != 'An Id is required');
  
	}
		
}