public class SurgeryOrderTriggerHelper {
    
    public static void validateMRNNumber(List<Surgery_Order__c> listOfSugeryOrders, 
                                            Map<id, Surgery_Order__c> oldMapSurgeryOrder){
        Set<String> setOfMRNNumbsers = new Set<String>();
        List<Surgery_Order__c> sorderToCheck = new List<Surgery_Order__c>();
        for(Surgery_Order__c sOrder: listOfSugeryOrders){
            if(string.isNotBlank(sOrder.MRN__c) && 
                    (sOrder.id == null || (sOrder.id != null && sOrder.MRN__c != oldMapSurgeryOrder.get(sOrder.id).MRN__c))){
                setOfMRNNumbsers.add(sOrder.MRN__c);
                sorderToCheck.add(sOrder);
            }
        }
        // Getting MRN no from Account 
        
        if(!setOfMRNNumbsers.isEmpty()){
            Map<String, Account> mapOfMRNAndAccounts = new Map<String, Account>();
            for(Account acc :[Select id, Name, COH_MRN__c, EPIC26_Survey_Sent__c from Account 
                                where EPIC26_Survey_Sent__c = true and COH_MRN__c in :setOfMRNNumbsers] ){
                mapOfMRNAndAccounts.put(acc.COH_MRN__c, acc);
            }
            
            for(Surgery_Order__c sOrder: sorderToCheck){
                if(!mapOfMRNAndAccounts.containsKey(sOrder.MRN__c)){
                    sOrder.MRN__c.addError('Not valid for EPIC 26 Survey,Record cannot be inserted');
                }
            }
        }
    }
}