/****************************************************************************************
*  Name           :   CH_HealthGoalHelperClass
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :  This helper class is used when ever checklist are created for actors 
                     then to send email notification to the actors of checklist assignment
                     and creating chatter post for checklist assignments
******************************************************************************************/
public with sharing class CH_HealthGoalHelperClass {
         public static List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    public static List<FeedItem>lstOfChatterPostToBeInsertedonChecklistCreation= new list<FeedItem>();
    public  static list<CaseTeamMemberNotification__c> lstInsertCaseteamnotification= new list<CaseTeamMemberNotification__c>();
    /* method is called when health goal( checklist) records is created for users 
            This methode is used to send email notifications and chatter post for
            checklist assignment if matching master records are found for the actors. */
    public static void sendAssignmentNotificationwhenChecklistIsAssigned(LIST <Health_Goal__c> newRecords) {
        
        List<FeedItem>lstOfChatterPostToBeInsertedonChecklistManuallyCreated= new list<FeedItem>();
        List<Messaging.SingleEmailMessage> LstmailsSendForManualyCreatedChecklist = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owe= new  OrgWideEmailAddress ();
        owe = [select Address,IsAllowAllProfiles,DisplayName from OrgWideEmailAddress where DisplayName=:CH_StaticComponentHelperClass.Orgwideemailadress];
        map<string,id>mapEmailTemplates= new map<string, id>();
        for (EmailTemplate tempemailtmp : [SELECT id,folder.name ,DeveloperName 
                                           FROM EmailTemplate where folder.name =:CH_StaticComponentHelperClass.CohEmailFolder and  IsActive=true] ) {
            if(tempemailtmp!=null)
             mapEmailTemplates.put(tempemailtmp.DeveloperName,tempemailtmp.id);
        }
        set<id> setSuccessrecordid= new set<id> ();
        list<Health_Goal__c> lstUpdateRecords= new list<Health_Goal__c>();
        list<Health_Goal__c> lstCheckListRecords= new list<Health_Goal__c>();
        set<id> recordsid= new set<id>();
        list<Task> lstUpdateTask= new list<Task>();
        list<Task>lstofRelatedTask= new list<Task>();
        set<id>caseid= new set<id>();
        set<string>setcasestage=new set<string>();
        map<id,string>mapOfCaseIdAndStage= new map<id,string>();
        map<id,string> mapOfCaseTeamMemberAndRole= new map<id,string>();
        map<string,Alert_Detail__c> mapOfStageAndAlertDetail= new map<string,Alert_Detail__c>();
        lstInsertCaseteamnotification=  new list<CaseTeamMemberNotification__c>();
          
        For( Health_Goal__c healthgoal :newRecords ) {
            recordsid.add(healthgoal.id);
        }
        if(recordsid.size()>0 && recordsid !=null) {
            lstCheckListRecords= [select id ,name,Complete__c,status__c,Assigned_to__c,case__c,Assigned_to__r.name,case__r.owner.email,
                                  Assigned_to__r.firstname,Chatter_Post__c,EmailTemplate__c,Static_chatter_text__c,Checklist_Created_Manually__c,
                                  case__r.Owner_Role__c,Assign_To__c from Health_Goal__c where id in :recordsid];
        }
        set <FeedItem>setOfPreventDuplicateChatterPost= new set<FeedItem>();
        if(lstCheckListRecords.size()>0 && lstCheckListRecords !=null) {
            for (Health_Goal__c checklistrecord :lstCheckListRecords ) {
                if(checklistrecord !=null && checklistrecord.EmailTemplate__c !=null && checklistrecord.EmailTemplate__c!='') {
                    id gettempid;
                   
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(mapEmailTemplates !=null && mapEmailTemplates.size()>0) {
                        CaseTeamMemberNotification__c Insertcaseteamnotification = new CaseTeamMemberNotification__c();
                        if(checklistrecord.Assigned_to__c !=null)
                            Insertcaseteamnotification.Assign_to__c=checklistrecord.Assigned_to__c;
                        if(checklistrecord.case__c !=null)
                            Insertcaseteamnotification.Recordid__c=checklistrecord.id;
                        if(checklistrecord.EmailTemplate__c !=null)
                            Insertcaseteamnotification.Templates__c=checklistrecord.EmailTemplate__c;
                        if(checklistrecord.Assign_To__c !=null)
                                Insertcaseteamnotification.Role__c=checklistrecord.Assign_To__c;
                        if(checklistrecord.case__r.Owner_Role__c !=null)
                         Insertcaseteamnotification.Owner_role__c=checklistrecord.case__r.Owner_Role__c;
                        if(checklistrecord.case__r.owner.email !=null)
                        Insertcaseteamnotification.OwnerEmail__c=checklistrecord.case__r.owner.email;
                        lstInsertCaseteamnotification.add(Insertcaseteamnotification);
                    }
                
                    /* sending chatter post when checklist is assigned*/
                    if(checklistrecord !=null && checklistrecord.Chatter_Post__c !=null && checklistrecord.Chatter_Post__c!='') {
                        string assignTo;
                        string description;
                        description= checklistrecord.name +''+ checklistrecord.Chatter_Post__c ;
                        FeedItem TempFeedItem= new FeedItem();
                        if(checklistrecord.Assigned_to__r.name !=null) {
                            assignTo=checklistrecord.Assigned_to__r.name;
                        } else {
                            assignTo='';
                        }
                        FeedItem post = new FeedItem();
                        try {
                            post.ParentId = checklistrecord.case__c;
                            string tempAssigntoName= assignTo;
                            if(checklistrecord.Static_chatter_text__c==false) {
                                if( description != null && description !='') {
                                    if(tempAssigntoName != null && tempAssigntoName !='') {
                                        post.Body = description+' '+tempAssigntoName;
                                    } else {
                                        post.Body = description;
                                    }
                                }
                            } else {
                                
                                if( description != null && description !='') {
                                    post.Body = description;
                                }
                            }
                        }
                        catch ( Exception e) {
                            system.debug('***********Exception*********'+ e.getmessage());
                        }
                        if(checklistrecord.Checklist_Created_Manually__c==false) {
                            if((setOfPreventDuplicateChatterPost.contains(post)== false)|| (setOfPreventDuplicateChatterPost.size()==0)) {
                                lstOfChatterPostToBeInsertedonChecklistCreation.add(post);
                            }
                        } else {
                            lstOfChatterPostToBeInsertedonChecklistManuallyCreated.add(post);
                        }
                        setOfPreventDuplicateChatterPost.add(post);
                    
                    }
                }
              }
            }
                /* when checklist are manually created then this list gets populated if master records are found*/
                if(lstOfChatterPostToBeInsertedonChecklistManuallyCreated != null && lstOfChatterPostToBeInsertedonChecklistManuallyCreated.size()>0) {
                    try {
                        insert lstOfChatterPostToBeInsertedonChecklistManuallyCreated;
                    }
                    catch(Exception e) {
                        system.debug('***********Exception*********'+ e.getmessage());
                    }
                }
                /* Insert   email notification of records  which will be send through batch
                 In the object CaseTeamMemberNotification.
                 */
                if( lstInsertCaseteamnotification !=null &&  lstInsertCaseteamnotification.size()>0) {
                
                    try { 
                        
                        insert lstInsertCaseteamnotification;
                    }
                    catch(Exception e) {
                        System.debug('******************Exception***********'+ e.getmessage())  ;
                    }
                }
            
        
    }
}