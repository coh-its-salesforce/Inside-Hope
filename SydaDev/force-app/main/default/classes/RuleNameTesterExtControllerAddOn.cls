/* ************************************************************
 * Created By  : USER_NAME (GearsCRM)
 * Created Date: __/__/20__ 
 * Description : Controller Class RuleNameTesterExtControllerAddOn
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
public with sharing class RuleNameTesterExtControllerAddOn 
{
	public class RuleNameTesterExtControllerAddOnException extends Exception{}
	 
    private final ApexPages.StandardController controller; 
	private final BREeze__RuleName__c rn;
		
	public String CreatedBy {get; private set;} 
    public String UpdatedBy {get; private set;}
    public String testID {get; set;}
    public String Results {get; set;}
    public Boolean show {get {return String.isNotBlank(Results);}}


    public RuleNameTesterExtControllerAddOn(ApexPages.StandardController controller) 
    {
        this.controller = controller;
        
        rn = [select BREeze__test_ids__c, createddate, createdby.name, lastmodifieddate, 
       						  lastmodifiedby.name, BREeze__isActive__c, BREeze__Object_Name__c, Name, BREeze__internal_name__c
       						  from BREeze__RuleName__c 
       						 where id = :this.controller.getId()];
        
        CreatedBy = rn.createdby.name + ', ' +  rn.createddate;
        UpdatedBy = rn.lastmodifiedby.name + ', ' +  rn.lastmodifieddate;
        TestId = rn.BREeze__test_ids__c;
	}
	
	public PageReference runTestForRule() 
    {
       try
       {
       		string x = (string)TestId;
       		
       		rn.BREeze__test_ids__c = x;
       		update rn; 
       			      
       		set <id> ids = new set <id>();

       		for(string s : x.split(',',0))
       		{
       			id i = (id)s.trim();
       			ids.add(i);	      
       		}
      		
          system.debug('Invoking Test rule w/ internal name : ' + rn.BREeze__internal_name__c);
       	  //results = BREeze.ProcessRules.processRuleLogicTestwithStorage(rn.BREeze__internal_name__c, ids);
	      results = BREeze.ProcessRules.processRuleLogicTest(rn.BREeze__internal_name__c, ids);
		  system.debug(results);
       }
       catch(Exception e)
       {
       		system.debug(e);
          results = 'An Id is required';
       }
       return null; 
    }
}