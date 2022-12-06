public class ITSProjectIntakeRequestController {

    public TPO_Project_Portfolio__c mPortfolioObject {get;set;}
    Id intakeRecTypeId = Schema.SObjectType.TPO_Project_Portfolio__c.getRecordTypeInfosByName().get('Intake Request').getRecordTypeId();
    PRIVATE STATIC FINAL STRING IT_OWNER_FIELD_NAME = 'IT_Owner__c'; 
    PRIVATE STATIC FINAL STRING IT_OWNER_DEFAULT = 'Lee, Pearl';
    
    /*
     * Contructor for ITSProjectIntakeRequestController 
     */ 
    public ITSProjectIntakeRequestController() {
        mPortfolioObject = new TPO_Project_Portfolio__c();
    }
    
    /*
     * This method inserts the TPO_Project_Portfolio__c based on input from the visualforce page. 
     * It does not do any validation, the fields on the visualforce page are bound to the Salesforce fields. It handles all validation automatically.
     */ 
    public pageReference submitRequest() {
        try {
            findITOwner();
            mPortfolioObject.RecordTypeId=intakeRecTypeId;
            insert mPortfolioObject;
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'There was an error submitting your request. Please contact your Salesforce Administrator.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Exception: ' + e.getMessage()));
            return null;
        }
        
        PageReference confirmationPage = new PageReference('/apex/ITSProjectIntakeRequestConfirmation');
        confirmationPage.setRedirect(true);
        
        return confirmationPage;
    }
    
    /*
     * This method finds the IT Owner of the Requester. Determined by using the Department of the Requester and the PeopleSoft__c custom object
     * In the peoplesoft__c object Department == Name and IT Owner == ITLT Owner
     * If there is an error finding the IT owner, the IT Owner is assigned the IT_OWNER_DEFAULT global variable
     */  
    private void findITOwner() {
        User requesterUser;
        PeopleSoft__c peopleSoftObj;
        boolean ITOwnerFound = false;
        List<string> ITOwners;
        string ITLTOwner;
        
        // Get Submitter's User object in order to find their department
        // Get list of PeopleSoft objects to get ITLT Owner
        try {
			requesterUser = [SELECT id, Department FROM User WHERE id =: mPortfolioObject.Requester_Name__c];
            peopleSoftObj = [SELECT id, Name, ITLT_Owner__r.FirstName, ITLT_Owner__r.LastName FROM PeopleSoft__c WHERE Name =:requesterUser.Department];
        }
        catch (Exception e) {
			mPortfolioObject.IT_Owner__c = IT_OWNER_DEFAULT;            
            return;
        }
        ITLTOwner = peopleSoftObj.ITLT_Owner__r.LastName + ', ' + peopleSoftObj.ITLT_Owner__r.FirstName;
        
        // Get List of IT Owners in TBO Picklist
        ITOwners = getITOwners();
        for (string ITOwner : ITOwners) {
            if (ITOwner.normalizeSpace().equalsIgnoreCase(ITLTOwner.normalizeSpace()) ) {
                mPortfolioObject.IT_Owner__c = ITOwner;
                ITOwnerFound = true;
            }
        }
        
        if (ITOwnerFound == false) {
            mPortfolioObject.IT_Owner__c = IT_OWNER_DEFAULT;
        }
    }
    
    /*
     * This function gets the Values in the IT_Owner__c Picklist field from the TPO_Project_Portfolio__c object
     * 
     * returns List<String>				The values of the IT_Owner__c picklist field from the TPO_Project_Portfolio__c object
     */ 
    private List<string> getITOwners() {
        List<string> ITOwners = new List<string>();
        
        Schema.sObjectType portfolioSObjectType = TPO_Project_Portfolio__c.getSObjectType();
        Schema.DescribeSObjectResult portfolioSObjectDescribe = portfolioSObjectType.getDescribe();
		Map<String,Schema.SObjectField> fieldMap =  portfolioSObjectDescribe.fields.getMap();
        List<Schema.PicklistEntry> pickListValues = fieldMap.get(IT_OWNER_FIELD_NAME).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry ITOwner : pickListValues) {
            ITOwners.add(ITOwner.getValue());
        }
        
        return ITOwners; 
    }
}