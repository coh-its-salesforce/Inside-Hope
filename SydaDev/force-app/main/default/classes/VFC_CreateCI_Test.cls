@isTest
Private Class VFC_CreateCI_Test{
    //Method to test the Search CI functionality
    Private Static testmethod Void testSearchCI(){
        
        //Create a CMDB Class
        BMCServiceDesk__CMDB_Class__c classDesk = new BMCServiceDesk__CMDB_Class__c(name = 'COH_Desktop',BMCServiceDesk__Namespace__c = 'BMC',BMCServiceDesk__ClassName__c = 'COH_Desktop' ,BMCServiceDesk__ClassID__c = 'COH_Desktop');
        insert classDesk; 
        
        //Create a CI related to the CMDB Class 
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'Test CI',
                                                                                       BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                                       BMCServiceDesk__Model__c = 'Model -001',
                                                                                       BMCServiceDesk__SerialNumber__c = '001',
                                                                                       BMCServiceDesk__CITag__c = 'LTP001',
                                                                                       BMCServiceDesk__Name__c = 'Test CI',
                                                                                       BMCServiceDesk__CMDB_Class__c = classDesk.Id
                                                                                        );
        insert ci;
         
        Test.startTest();
        
        //Set the current page
        PageReference pg = Page.VF_CreateCI;
        Test.setCurrentPage(pg);
        
        //Initialize Controller
        VFC_CreateCI controller = new VFC_CreateCI(new ApexPages.StandardController(new BMCServiceDesk__BMC_BaseElement__c()));
        
        controller.showFilters();
        //Get the classes available to be present on Page Picklist
        controller.getclasses();

        //Negative Test
        //Put a search string
        controller.searchStr = 't';
        
        //Search
        controller.SearchItems();
        
        //Positive Test
        //Put a search string
        controller.searchStr = 'Test CI';
        
        //Search
        controller.SearchItems();
        
        //Delete a CI
        system.currentpagereference().getparameters().put('index','0');
        controller.removeCI();
        
        //Update CI
        controller.SaveMe();
        
        Test.stopTest();
    }
    //Method to test the Search CI functionality
    Private Static testmethod Void testCreateCI(){
        
        //Create a CMDB Class
        BMCServiceDesk__CMDB_Class__c classDesk = new BMCServiceDesk__CMDB_Class__c(name = 'COH_Desktop',BMCServiceDesk__Namespace__c = 'BMC',BMCServiceDesk__ClassName__c = 'COH_Desktop' ,BMCServiceDesk__ClassID__c = 'COH_Desktop');
        insert classDesk; 
        
        //Create a CI related to the CMDB Class 
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'Test CI',
                                                                                       BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                                       BMCServiceDesk__Model__c = 'Model -001',
                                                                                       BMCServiceDesk__SerialNumber__c = '001',
                                                                                       BMCServiceDesk__CITag__c = 'LTP001',
                                                                                       BMCServiceDesk__Name__c = 'Test CI',
                                                                                       BMCServiceDesk__CMDB_Class__c = classDesk.Id
                                                                                        );
        insert ci;
         
        Test.startTest();
        
        //Set the current page
        PageReference pg = Page.VF_CreateCI;
        Test.setCurrentPage(pg);
        
        //Initialize Controller
        VFC_CreateCI controller = new VFC_CreateCI(new ApexPages.StandardController(new BMCServiceDesk__BMC_BaseElement__c()));
        
        controller.showFilters();
        //Get the classes available to be present on Page Picklist
        controller.getclasses();
        
        //Negative Test
        //Put values in CI
        controller.ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'Test CI',
                                                                BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                BMCServiceDesk__Model__c = 'Model -001',
                                                                BMCServiceDesk__SerialNumber__c = '001',
                                                                BMCServiceDesk__CITag__c = 'LTP001',
                                                                BMCServiceDesk__Name__c = 'Test CI',
                                                                BMCServiceDesk__CMDB_Class__c = classDesk.Id
                                                                 );
        //Select a class
        controller.classsel = classDesk.id;
        
        //Validate
        controller.Validate();
        
        //Navigate to re-Validate
        controller.reValidateScreen();
        
        //Positive Test
        //Put values in CI
        controller.ci = new BMCServiceDesk__BMC_BaseElement__c(name = 'Test CI 1',
                                                                BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                BMCServiceDesk__Model__c = 'Model -001',
                                                                BMCServiceDesk__SerialNumber__c = '0011',
                                                                BMCServiceDesk__Name__c = 'Test CI 1',
                                                                BMCServiceDesk__CMDB_Class__c = classDesk.Id
                                                                );
        //Validate
        controller.Validate();
        
        ci.BMCServiceDesk__CITag__c = 'LTP0011';
        
        //Create CI
        controller.createCI();
        
        //Create New Page
        controller.createNew();
        
        
        Test.stopTest();
    }

}