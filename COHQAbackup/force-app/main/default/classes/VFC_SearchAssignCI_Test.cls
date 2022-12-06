@isTest
Private Class VFC_SearchAssignCI_Test{
    Private Static testmethod Void testShowAssignedCI(){
        User client = [select Id from User where IsActive = true limit 1];
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'Test CI',
                                                                                       BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                                       BMCServiceDesk__Model__c = 'Model -001',
                                                                                       BMCServiceDesk__SerialNumber__c = '001',
                                                                                       BMCServiceDesk__CITag__c = 'LTP001',
                                                                                       BMCServiceDesk__PrimaryClient__c = client.Id,
                                                                                       BMCServiceDesk__Name__c = 'Test CI'
                                                                                        );
        insert ci;
        
        Test.startTest();
        PageReference pg = Page.VF_SearchAssignCI;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('uid',client.Id );
        
        VFC_SearchAssignCI controller = new VFC_SearchAssignCI(new ApexPages.StandardController(new BMCServiceDesk__BMC_BaseElement__c()));
        
        controller.searchStr = 'test';
        controller.SearchItems();
        
        controller.searchStr = 't';
        controller.SearchItems();
        controller.SaveMe();
        Test.stopTest();
    }
}