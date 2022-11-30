trigger CreateITSProjectHistory on ITS_Project_Request__c (after update) {
    List<ITS_Intake_Request_History__c> insertHistory = new List<ITS_Intake_Request_History__c>();
    for(ITS_Project_Request__c  its : trigger.new){
        if(its.Approve_Status__c != trigger.oldMap.get(its.id).Approve_Status__c){
            ITS_Intake_Request_History__c itsH = new ITS_Intake_Request_History__c(
                Approval_Status__c = its.Approve_Status__c,
                Approve_Reject_By_User__c = UserInfo.getUserID(),
                Approve_Reject_Date__c = system.now(),
                Comment__c = (trigger.oldMap.get(its.id).commented__c != its.commented__c ?  its.commented__c : null),
                ITS_Intake_Request__c = its.id
            );
            insertHistory.add(itsH);
        } 
    }
    if(insertHistory.size() > 0)
        insert insertHistory;
}