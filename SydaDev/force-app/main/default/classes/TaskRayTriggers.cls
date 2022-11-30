public class TaskRayTriggers
{
    public static CollaborationGroup CreateChatterGroup(String grpName, String ownerId)
    {
        CollaborationGroup[] grpList = [Select Id from CollaborationGroup where Name =:grpName];
        if (grpList.size() > 0)
        {
            CollaborationGroup grp = grpList[0];
            return grp;
        }
        else 
        {
            CollaborationGroup grp= new CollaborationGroup();
            grp.Name = grpName;  
            grp.CollaborationType = 'Private'; 
            grp.OwnerId = ownerId;  
            insert grp;
            return grp;
        }
        
    }
    
    public static void AddChatterMember(CollaborationGroup grp, String ownerId)
    {
        if ([Select memberid from CollaborationGroupMember where memberid =:ownerId and CollaborationGroupId =:grp.Id].size() == 0)
        {
            CollaborationGroupMember grpMr = new CollaborationGroupMember();
            grpMr.memberid = ownerId;
            grpMr.CollaborationGroupId = grp.Id;
            //To assign default role as "Group Manager" to all group members.
            grpMr.CollaborationRole = 'Admin';
            grpMr.NotificationFrequency = 'P';
            insert grpMr; 
        }
    }
    
    public static void ArchiveChatterGroup(String grpID)
    {
        CollaborationGroup[] grpList = [select Id, IsArchived from CollaborationGroup where Id = : grpID];
        if (grpList.size() > 0)
        {
        CollaborationGroup grp = grpList[0];
            if (grp.IsArchived == false)
            {
                grp.IsArchived = true; 
                update grp; 
            }
        }
    }
    
    public static void AddDescription(String grpID, String information)
        {
            CollaborationGroup[] grpList = [select Id, Description from CollaborationGroup where Id = : grpID];
            if (grpList.size() > 0)
            {
                CollaborationGroup grp = grpList[0];
                grp.Description = information; 
                update grp; 
            }
    }
    
}