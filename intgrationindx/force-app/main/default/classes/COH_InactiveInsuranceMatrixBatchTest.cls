@isTest
public class COH_InactiveInsuranceMatrixBatchTest {

    static testMethod void myTestMethod() {    
        Insurance_Matrix__c record = new Insurance_Matrix__c();
        record.term_date__c = system.today();
        insert record;
         test.starttest();
         COH_InactiveInsuranceMatrixBatch myClass = new COH_InactiveInsuranceMatrixBatch();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }  
}