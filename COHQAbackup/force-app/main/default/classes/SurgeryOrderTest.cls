@isTest
public class SurgeryOrderTest {
    
    private static testmethod void myUnitTest(){
        Surgery_Order__c sorder = new Surgery_Order__c();
        sOrder.MRN__c  = '123455';
        Database.saveResult sv  = Database.insert(sOrder, false);
        system.assert(!sv.isSuccess());
        
        
    }
}