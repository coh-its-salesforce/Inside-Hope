public with sharing class ITIntakeTPOProjectPortfolioAuraEnabled {
    @AuraEnabled(cacheable=true)
    public static List<SObject> searchITIntake(String searchParam, Boolean searchMyRecord){
        Id userId = UserInfo.getUserId();
        String likeParam = '%' + searchParam + '%';
        String Query = '';
        if(searchParam != null && searchMyRecord == false){
            Query = 'Select Id, Name, Request_Name__c, Request_Type__c, Request_Status__c, Approval_Status__c, Requester_Name__r.name, createdby.name, Primary_ISC__c, IT_Functional_Area__c, IT_Functional_Sub_Area__c from TPO_Project_Portfolio__c where Name Like:likeParam OR CreatedBy.name like:likeParam OR Requester_Name__r.name like:likeParam OR  Primary_ISC__c like:likeParam OR IT_Functional_Area__c like:likeParam OR Request_Name__c like:likeParam Order By lastmodifieddate desc Limit 50';
        } else if (searchParam == null && searchMyRecord == false){
            Query = 'Select Id, Name, Request_Name__c, Request_Type__c, Request_Status__c, Approval_Status__c, Requester_Name__r.name, createdby.name, Primary_ISC__c, IT_Functional_Area__c, IT_Functional_Sub_Area__c from TPO_Project_Portfolio__c Order By lastmodifieddate desc Limit 50';
        } else if (searchParam != null && searchMyRecord == true){
            Query = 'Select Id, Name, Request_Name__c, Request_Type__c, Request_Status__c, Approval_Status__c, Requester_Name__r.name, createdby.name, Primary_ISC__c, IT_Functional_Area__c, IT_Functional_Sub_Area__c from TPO_Project_Portfolio__c where createdbyId =: userId AND (Name Like:likeParam OR CreatedBy.name like:likeParam OR Requester_Name__r.name like:likeParam OR  Primary_ISC__c like:likeParam OR IT_Functional_Area__c like:likeParam OR Request_Name__c like:likeParam) Order By lastmodifieddate desc Limit 50';
        } else {
            Query = 'Select Id, Name, Request_Name__c, Request_Type__c, Request_Status__c, Approval_Status__c, Requester_Name__r.name, createdby.name, Primary_ISC__c, IT_Functional_Area__c, IT_Functional_Sub_Area__c from TPO_Project_Portfolio__c where createdbyId =: userId Order By lastmodifieddate desc Limit 50';
        }
        system.debug('Query | '+ Query);
        List<SObject> sObjectList=Database.query(Query);
        return sObjectList;
    }
    @AuraEnabled(cacheable=true)
    public static List<SObject> searchEnhancement(String searchEnhancement, Boolean searchMyRecord){
        Id UserId = UserInfo.getUserId();
        String likeParam = '%' + searchEnhancement + '%';
        String QueryEnhancement ='';
        if(searchEnhancement != null && searchMyRecord == false){
            QueryEnhancement = 'Select Id, Name, Request_Name__c, Project_Short_Description__c, Request_Status__c, Approval_Status__c, Requester_Name__c, Requester_Name__r.name, createdby.name, Assigned_Technical_Analyst__r.Name, Assigned_Release_monthly_bundle__c, CreatedDate, Current_IT_PM_Lifecycle_Project_Status__c from TPO_Project_Portfolio__c where (recordtype.developername = \'Enhancement\' or recordtype.developername = \'Enhancement_Technical_Review\') AND (Name Like:likeParam OR CreatedBy.name like:likeParam OR Requester_Name__r.name like:likeParam OR Request_Name__c like:likeParam) Order By createddate desc Limit 50';
        } else if (searchEnhancement == null && searchMyRecord == false) {
            QueryEnhancement = 'Select Id, Name, Request_Name__c, Project_Short_Description__c, Request_Status__c, Approval_Status__c, Requester_Name__c, Requester_Name__r.name, createdby.name, Assigned_Technical_Analyst__r.Name, Assigned_Release_monthly_bundle__c, CreatedDate, Current_IT_PM_Lifecycle_Project_Status__c from TPO_Project_Portfolio__c where (recordtype.developername = \'Enhancement\' or recordtype.developername = \'Enhancement_Technical_Review\') Order By createddate desc Limit 50';
        } else if (searchEnhancement !=null && searchMyRecord == true){
            QueryEnhancement = 'Select Id, Name, Request_Name__c, Project_Short_Description__c, Request_Status__c, Approval_Status__c, Requester_Name__c, Requester_Name__r.name, createdby.name, Assigned_Technical_Analyst__r.Name, Assigned_Release_monthly_bundle__c, CreatedDate, Current_IT_PM_Lifecycle_Project_Status__c from TPO_Project_Portfolio__c where (createdbyId =: userId OR Requester_Name__c =: userId) AND (recordtype.developername = \'Enhancement\' or recordtype.developername = \'Enhancement_Technical_Review\') AND (Name Like:likeParam OR CreatedBy.name like:likeParam OR Requester_Name__r.name like:likeParam OR Request_Name__c like:likeParam) Order By createddate desc Limit 50';
        } else {
            QueryEnhancement = 'Select Id, Name, Request_Name__c, Project_Short_Description__c, Request_Status__c, Approval_Status__c, Requester_Name__c, Requester_Name__r.name, createdby.name, Assigned_Technical_Analyst__r.Name, Assigned_Release_monthly_bundle__c, CreatedDate, Current_IT_PM_Lifecycle_Project_Status__c from TPO_Project_Portfolio__c where (createdbyId =: userId OR Requester_Name__c =: userId) AND (recordtype.developername = \'Enhancement\' or recordtype.developername = \'Enhancement_Technical_Review\') Order By createddate desc Limit 50';
        }

        system.debug('Query Enhancement | '+ QueryEnhancement);
        List<SObject> sObjectListEnhancement=Database.query(QueryEnhancement);
        return sObjectListEnhancement;
    }
}