@isTest
private class Utilities_Test {
    @isTest
    private static void getInstance(){
        String instance = '';
        Organization o = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
        String orgType = o.OrganizationType;
        String insName = o.InstanceName;

        //Set this header to test it
        ApexPages.currentPage().getHeaders().put('Host', insName+'.visual.force.com');

        Boolean isSandbox = [select IsSandbox from Organization].IsSandBox;
        if (isSandBox == true) {
            List<String> parts = ApexPages.currentPage().getHeaders().get('Host').split('\\.');
            instance = parts[parts.size() - 4] + '.';
            System.assertEquals(instance, Utilities.getInstance());
        } else {
            System.assertEquals('', Utilities.getInstance());
        }
        
    }

    @isTest
    private static void getSubdomainPrefix(){
        //This will always be empty unless it's sandbox
        Boolean isSandbox = [select IsSandbox from Organization].IsSandBox;
        if (isSandBox) {
            Organization o = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
            String orgType = o.OrganizationType;
		    System.assertNotEquals('', Utilities.getSubdomainPrefix());
        } else {
	        System.assertEquals('', Utilities.getSubdomainPrefix());
    	}
    }
}