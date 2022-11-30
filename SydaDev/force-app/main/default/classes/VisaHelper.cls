Public class VisaHelper{
    public static void shareVisaRecord(Visa__c visa){
        List<Visa__share> vsList = new List<Visa__Share>();
        Set<Id> adminIdSet = new Set<id>();
        for(PermissionSetAssignment psAssList : [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where PermissionSetId IN(select id from PermissionSet where Name='Immigration_Services_Layout')]){
            adminIdSet.add(psAssList.AssigneeId);
        }
        
            if(Visa.Business_Manager_or_Contact_Person__c !=NUll && !adminIdSet.contains(Visa.Business_Manager_or_Contact_Person__c))
            {
            Visa__share vShare = new Visa__Share();
            
            vShare.ParentId = Visa.id;
            vShare.UserOrGroupId = Visa.Business_Manager_or_Contact_Person__c;
            vShare.AccessLevel = 'Read';
            vsList.add(vShare);
            }
                        if (Visa.Supervisor__c != null && !adminIdSet.contains(Visa.Supervisor__c))
                        {
                        Visa__share vShare2 = new Visa__Share();

            vShare2.ParentId = Visa.id;
            vShare2.UserOrGroupId = Visa.Supervisor__c;
            vShare2.AccessLevel = 'Read';
            vsList.add(vShare2);
            }
            if (Visa.of_Business_Manager_Business_Director__c != null && !adminIdSet.contains(Visa.of_Business_Manager_Business_Director__c))
            {
                        Visa__share vShare3 = new Visa__Share();

            vShare3.ParentId = Visa.id;
            vShare3.UserOrGroupId = Visa.of_Business_Manager_Business_Director__c;
            vShare3.AccessLevel = 'Read';
            vsList.add(vShare3);
            }
            if (Visa.Approver_Department_Head__c !=null && !adminIdSet.contains(Visa.Approver_Department_Head__c))
            {
            Visa__share vShare4 = new Visa__Share();
            vShare4.ParentId = Visa.id;
            vShare4.UserOrGroupId = Visa.Approver_Department_Head__c;
            vShare4.AccessLevel = 'Read';
            vsList.add(vShare4);
            }
            if(Visa.VP_ET_Member__c !=null && !adminIdSet.contains(Visa.VP_ET_Member__c))
            {
            Visa__share vShare5 = new Visa__Share();
            vShare5.ParentId = Visa.id;
            vShare5.UserOrGroupId = Visa.VP_ET_Member__c;
            vShare5.AccessLevel = 'Read';
            vsList.add(vShare5);
            }
      
        if(vsList.size()>0){
            upsert vsList;
        }
    }
 }