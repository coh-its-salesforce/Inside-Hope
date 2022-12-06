@isTest(SeeAllData = true)
public class ServiceNowToRFCMDBTest {
     public ServiceNowToRFCMDBTest() {}
    public Static testMethod void TestSNowToRFComputers() {

        Test.startTest();  
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                     FROM BMCServiceDesk__CMDB_Class__c 
                                                    WHERE BMCServiceDesk__ClassID__c ='BMC_ComputerSystem']; 
        createDevice(CMDBClass.ID, 'ComputerTest','ServiceNow');
        createDevice(CMDBClass.ID, 'ComputerTest1','Remedyforce UI');
        
        Test.setMock(HttpCalloutMock.class, new MockServiceNowAPICall());
        String CRON_EXP = '0 0 0 10 * ? *';
        String jobId = System.schedule('ServiceNowToRFComputerSchedule',
            					CRON_EXP, 
            					new ServiceNowToRFComputerSchedule()); 

        
		List<BMCServiceDesk__BMC_BaseElement__c> lt = [SELECT ID, Name, BMCServiceDesk__Name__c,BMCServiceDesk__CMDB_Class__c,BMCServiceDesk__UniqueCISourceID__c,
                                                       BMCServiceDesk__Source__c,BMCServiceDesk__InstanceID__c,BMCServiceDesk__SerialNumber__c,
                                                       ServiceNow_IP_address__c,BMCServiceDesk__CITag__c,BMCServiceDesk__ManufacturerName__c,ServiceNow_Sys_updated_on__c,
                                                       BMCServiceDesk__Model__c,ServiceNow_OS_Version__c,ServiceNow_First_Discovered__c,ServiceNow_Last_Discovered__c
                                                       FROM BMCServiceDesk__BMC_BaseElement__c
                                                       WHERE BMCServiceDesk__CMDB_Class__c =:CMDBClass.ID LIMIT 10];




        System.debug(lt);
        Test.stopTest();
    }

    public Static testMethod void TestSNowToRFSoftwares() {

        Test.startTest(); 
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                   FROM BMCServiceDesk__CMDB_Class__c 
                                                   WHERE BMCServiceDesk__ClassID__c ='BMC_Product']; 
        
        
        createDevice(CMDBClass.ID, 'softwareTest', 'ServiceNow');
        createDevice(CMDBClass.ID, 'softwareTest1', 'Remedyforce UI');
        Test.setMock(HttpCalloutMock.class, new MockServiceNowAPICall());
        String CRON_EXP = '0 0 0 10 * ? *';
        String jobId = System.schedule('ServiceNowToRFSoftwareSchedule',
            					CRON_EXP, 
            					new ServiceNowToRFSoftwareSchedule()); 

 		List<BMCServiceDesk__BMC_BaseElement__c> lt = [SELECT ID, Name, BMCServiceDesk__Name__c,BMCServiceDesk__CMDB_Class__c,BMCServiceDesk__UniqueCISourceID__c,
                                                       BMCServiceDesk__Source__c,BMCServiceDesk__InstanceID__c,BMCServiceDesk__SerialNumber__c,
                                                       ServiceNow_IP_address__c,BMCServiceDesk__CITag__c,BMCServiceDesk__ManufacturerName__c,ServiceNow_Sys_updated_on__c,
                                                       BMCServiceDesk__Model__c,ServiceNow_OS_Version__c,ServiceNow_First_Discovered__c,ServiceNow_Last_Discovered__c
                                                       FROM BMCServiceDesk__BMC_BaseElement__c
                                                       WHERE BMCServiceDesk__CMDB_Class__c =:CMDBClass.ID LIMIT 10];


        System.debug(lt);
        Test.stopTest();
    }
    
    private static void createDevice(ID CMDBDeviceID, string deviceName,string source){
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = deviceName,
                                                                                        BMCServiceDesk__ManufacturerName__c = 'Test Manufacturer',
                                                                                        BMCServiceDesk__Model__c = 'Model -001',
                                                                                        BMCServiceDesk__SerialNumber__c = '001',
                                                                                        BMCServiceDesk__CITag__c = 'tag',
                                                                                        BMCServiceDesk__Name__c = deviceName,
                                                                                        BMCServiceDesk__CMDB_Class__c = CMDBDeviceID,
                                                                                        BMCServiceDesk__Source__c = source
                                                                                        );
        insert ci;
         
    }
}