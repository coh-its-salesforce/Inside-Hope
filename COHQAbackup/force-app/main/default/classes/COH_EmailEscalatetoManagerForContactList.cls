public class COH_EmailEscalatetoManagerForContactList {
    Infection_Prevention_Email__mdt IP_Settings = [Select Timelapse_between_RA_Req_and_Resp__c From Infection_Prevention_Email__mdt Where Label = 'Infection Prevention Email CC'];
    private Double TimelapseInHours = IP_Settings.Timelapse_between_RA_Req_and_Resp__c;
    public Id contactId {get;set;}
    public String conManagerEmail {set;get;}
    public List<Contact_Trace_Loader__c> getContactList(){
         System.debug('contactId--->'+contactId);
        System.debug('conManagerEmail--->'+conManagerEmail);
        return [select id,Manager_Email__c,Send_Risk_Assessment_to_Manager__c,Employee_Name__c,Last_Exposure_Date__c 
                from Contact_Trace_Loader__c where Manager_Email__c =:conManagerEmail and Timelapse_between_RA_Req_and_Resp__c=:TimelapseInHours];
     
    }
}