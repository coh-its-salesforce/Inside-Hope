@isTest
public class ah_BaseElementTest {
    
    public static testMethod void testCreateRec() {
        BMCServiceDesk__BMC_BaseElement__c sobj = new BMCServiceDesk__BMC_BaseElement__c(
            Name = 'AH Service',                       
            BMCServiceDesk__Name__c = 'AH Service',
            TS_UEID__c = 'mc.pncell_TSIMDEV.1d5168eb.0');
        insert sobj;
    
        BMCServiceDesk__BMC_BaseElement__c sobj1 = new BMCServiceDesk__BMC_BaseElement__c(
            Name = 'AH Service1',                       
            BMCServiceDesk__Name__c = 'AH Service1');
        insert sobj1;
             
        BMCServiceDesk__BMC_BaseRelationship__c reobj = new BMCServiceDesk__BMC_BaseRelationship__c(
            BMCServiceDesk__Name__c = 'AH Service - ActionHub APP');
        insert reobj;
        
        BMCServiceDesk__BMC_BaseRelationship__c recobj1 = new BMCServiceDesk__BMC_BaseRelationship__c(
            BMCServiceDesk__Name__c = 'AH Service - ActionHub APP1', 
            TS_CMDB_Creation__c = true,                              
            TS_Created__c = false);
        insert recobj1;
    }
    
}