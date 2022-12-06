public class COH_Get_IT_ResourceListView {
	/*@AuraEnabled
    public static List<IT_Resource__c> getITRecs(){
        return new List<IT_Resource__c>([Select id, Name, Job_Title__c, Unavailable_Status__c, Assign_Delegate__c,
                                         First_Name_Formula__c,Last_Name_RM_View__c 
                                         from IT_Resource__c WHERE Employee__c= :UserInfo.getUserID() LIMIT  1]);                                       
    } */
    
    @AuraEnabled
    public static IT_Resource__c getITRecs(string recordId) {
        IT_Resource__c ITRRecs = [SELECT Id, Name, Suffix_RM_View__c, Middle_Initial_RM_View__c, Job_Title__c, Job_Title_Update__c, Unavailable_Status__c, Assign_Delegate__c,
                                         First_Name_Formula__c,Last_Name_RM_View__c, Assign_Delegate__r.Name 
                                         from IT_Resource__c where Employee__c= :UserInfo.getUserID() LIMIT  1];
        return ITRRecs;
    }
    
}