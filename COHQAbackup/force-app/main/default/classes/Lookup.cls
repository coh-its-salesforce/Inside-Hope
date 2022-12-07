public without sharing class Lookup {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if((filter != null && filter != '') && (searchTerm == null || searchTerm == '')){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND RecordType.Name=\''+filter+'\' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL '+ (String.isNotBlank(filter)?'AND RecordType.Name=\''+filter+'\'':'')+' ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' '+(String.isNotBlank(filter)?' AND RecordType.Name=\''+filter+'\'':'')+' LIMIT  5';
            }
        }
        System.debug('myQuery------'+myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    @AuraEnabled(cacheable=true)
    public static PurchaserPlan getDataFromAccount(String getDataFromId){
        try{
            List<PurchaserPlan> accList= new List<PurchaserPlan>([SELECT Id, Name FROM PurchaserPlan Where id=:getDataFromId]);
            if(accList.isEmpty())
                return null;
            return accList[0];
            //return JSON.serialize(accList);
            
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static Contact getDataFromContact(String getDocFromId){
        try{
            Contact conList=[SELECT Id, Name FROM Contact Where id=:getDocFromId];
            return conList;
            //return JSON.serialize(accList);
            
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
}