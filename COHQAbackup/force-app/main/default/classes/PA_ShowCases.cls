public with sharing class PA_ShowCases {

    public List<Case> lst_MyCases {get;set;}
    public List<Case> lst_QueueCases {get;set;}
    public Boolean bl_MyCases {get;set;}
    public Boolean bl_QueueCases{get;set;}
    public PA_ShowCases()
    {
        lst_MyCases = new List<case>();
        lst_QueueCases = new List<Case>();
        String str_UserId = UserInfo.getUserId();
        List<Case> lstCase = [Select Account.Name, Assign_To__c, Assign_To__r.Name, RecordType.Name, CaseNumber, id, Action_Taken__c, PAS_Actions__c , Issue__c, Occurence_Date__c, Encounter_Date__c, Department__c, Location1__c, Owner.Name, CreatedBy.Name, Status, CreatedDate, Department_Created__c from Case where IsClosed =: False AND OwnerId =:str_UserId];
        for(Integer i=0;i<lstCase.size();i++)
        {
            if(lstCase[i].OwnerId == str_UserId)
            {
                lst_MyCases.add(lstCase[i]);
            }
            else
            {
                lst_QueueCases.add(lstCase[i]);
            }
        }
        if(!lst_MyCases.isEmpty())
        {
            bl_MyCases = true;
        }
        else
        {
            bl_MyCases =false;
        }
        if(!lst_QueueCases.isEmpty())
        {
            bl_QueueCases = true;
        }
        else
        {
            bl_QueueCases =false;
        }
    }
}