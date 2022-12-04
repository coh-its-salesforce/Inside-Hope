public without sharing class createPortalUserCtl{
    
    
    @AuraEnabled
    public static string createPortaluser(string ConId){
        List<Contact> conRecList = new List<Contact>();
        Boolean userCreated = false;
        
        conRecList = [SELECT id FROM Contact WHERE Dependents_Info__c =:ConId AND Relationship1__C = 'Self'];
        if (conRecList.size()>0) {
            return 'A Customer Portal Contact for this Visa Request already exists';
        }
        else {
            Visa__c visaRec = [SELECT id,chkCreatePortaluser__c,Proposed_Individual_First_Name__c,Proposed_Individual_Last_Name__c,Applicant_Email_Id__c FROM Visa__c WHERE id =: ConId];
            Account acc = [SELECT id FROM Account WHERE Name = 'Immigration Services'];
            Contact conRec = new Contact();
            conRec.FirstName = visaRec.Proposed_Individual_First_Name__c;
            conRec.LastName = visaRec.Proposed_Individual_Last_Name__c ;
            conRec.Email = visaRec.Applicant_Email_Id__c; 
            conRec.Dependents_Info__c = visaRec.Id; 
            conRec.AccountId = acc.id; 
            conRec.Relationship1__C = 'Self'; 
            Id devRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Immigration Sevices').getRecordTypeId();
            conRec.RecordTypeId = devRecordTypeId ;
            try {
                insert conRec;
                visaRec.chkCreatePortaluser__c = false;
                update visaRec;
            }
            catch (Exception e) {
                return 'There was an error creating the Customer Portal Contact\n' + e.getMessage();
            }
            return 'Customer Portal Contact created successfully.';   
        }
    }
}