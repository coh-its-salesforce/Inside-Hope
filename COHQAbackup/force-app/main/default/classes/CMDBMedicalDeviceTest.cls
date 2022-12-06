@isTest(SeeAllData = false)
public class CMDBMedicalDeviceTest {
    public CMDBMedicalDeviceTest() {}
    public Static testMethod void TestCMDBMedical() {

        Test.startTest();  

		createMedicalClass();
        CreateCustomSettingsFields();
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                     FROM BMCServiceDesk__CMDB_Class__c 
                                                    WHERE BMCServiceDesk__ClassID__c ='BMC_Medical']; 
        createMedicalDevice(CMDBClass.ID);
        
        Test.setMock(HttpCalloutMock.class, new MockArmisAPICall());
        String CRON_EXP = '0 0 0 10 * ? *';
        String jobId = System.schedule('ScheduledArmisCMDB',
            					CRON_EXP, 
            					new ArmisCMDBSchedule()); 
        
        List<BMCServiceDesk__BMC_BaseElement__c> lt = [SELECT ID, name, BMCServiceDesk__Name__c,BMCServiceDesk__CMDB_Class__c,
                                    BMCServiceDesk__Category__c,First_Seen_In_Armis__c,BMCServiceDesk__Network_Addresses__c,
                                    Last_Seen_In_Armis__c,BMCServiceDesk__ManufacturerName__c,BMCServiceDesk__Model__c,
                                    Device_Name__c,Operating_System__c,Risk_Level__c,Device_Type__c,Armis_User__c,Boundary__c,
                                    BMCServiceDesk__MACAddress__c,BMCServiceDesk__CITag__c,Sensor_Name__c,BMCServiceDesk__Site__c
                            FROM BMCServiceDesk__BMC_BaseElement__c
                            WHERE BMCServiceDesk__CMDB_Class__c =:CMDBClass.ID];
        System.debug(lt);
        Test.stopTest();
    }
    
    private static void createMedicalClass(){
        BMCServiceDesk__CMDB_Class__c cclass = new BMCServiceDesk__CMDB_Class__c(
                                                                                BMCServiceDesk__Namespace__c='BMC' ,
                                                                                BMCServiceDesk__ClassID__c ='BMC_Medical');
        insert cclass;
    }
    private static void createMedicalDevice(ID CMDBMedicalDeviceID){
        BMCServiceDesk__BMC_BaseElement__c ci = new BMCServiceDesk__BMC_BaseElement__c(name = '20',
                                                                                        BMCServiceDesk__ManufacturerName__c = 'Test Manu',
                                                                                        BMCServiceDesk__Model__c = 'Model -001',
                                                                                        BMCServiceDesk__SerialNumber__c = '001',
                                                                                        BMCServiceDesk__CITag__c = 'LTP001',
                                                                                        BMCServiceDesk__Name__c = '20',
                                                                                        BMCServiceDesk__Network_Addresses__c ='3123',
                                                                                        BMCServiceDesk__CMDB_Class__c = CMDBMedicalDeviceID
                                                                                        );
        insert ci;
         
    }
    
    private Static void CreateCustomSettingsFields(){
        CreateCustomSettingField('ArmisBoundaryTags','Corporate,Guest,External\\Edge Devices,Vendor Networks,Off Network');
        CreateCustomSettingField('ArmisDomain','https://cityofhope.armis.com');
        CreateCustomSettingField('ConsumerKey','0d04f1582c979a59cb46453d79646eb5d602cc3f1cc29c1612fecb50ec6021cc');
        CreateCustomSettingField('SearchParameter','category:"Medical%20Therapeutic","Medical%20Diagnostic","Medical%20Support"');
        CreateCustomSettingField('SourcePicklistValue','Armis');
    }
    
    private Static void CreateCustomSettingField(String Name, String FieldValue){
        Armis_Parameters__c field = new Armis_Parameters__c();
        field.Name = Name;
        field.Value__c = FieldValue;
        insert field;        
        return ;
    }
}