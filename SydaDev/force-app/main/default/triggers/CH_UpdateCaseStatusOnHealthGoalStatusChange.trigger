/*
*  Name           :   CH_UpdateCaseStatusOnHealthGoalStatusChange
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :    when this trigger is updated  and the status of the health goal(checklist) records is closed
                        the it helps in creating chatter post and email notification to the cas team members.
                        When the trigger is inserted then it calls the  CH_HealthGoalHelperClass to 
                         to prepare list of mails for the actors for checklist assignments.
*/
trigger CH_UpdateCaseStatusOnHealthGoalStatusChange on Health_Goal__c (after Update,after Insert) {

  OrgWideEmailAddress owe= new  OrgWideEmailAddress ();
  map<string,id>mapEmailTemplates= new map<string, id>();
  list<FeedItem>lstOfChatterPostToBeInserted= new list<FeedItem>();
  set<FeedItem> setOfPreventDuplicateChatterPost= new set<FeedItem>();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  set<id> setSuccessrecordid= new set<id> ();
  list<Health_Goal__c> lstUpdateRecords= new list<Health_Goal__c>();
  list<Health_Goal__c> lstCheckListRecords= new list<Health_Goal__c>();
  set<id> recordsid= new set<id>();
  list<Task> lstUpdateTask= new list<Task>();
  list<Task>lstofRelatedTask= new list<Task>();
  set<id>caseid= new set<id>();
  set<string>setcasestage=new set<string>();
  set<string>setcasestatus=new set<string>();
  map<id,string>mapOfCaseIdAndStage= new map<id,string>();
  map<id,CaseTeamMember> mapOfCaseTeamMemberAndRole= new map<id,CaseTeamMember>();
  map<string,Alert_Detail__c> mapOfStageAndAlertDetail= new map<string,Alert_Detail__c>();
  boolean checkflag=false;
  boolean addflag=false;
  list<Health_Goal__c> lstChecklistRecordsTobeProcessedOnInsert = new list<Health_Goal__c>();
  public  map<id,user> mapOfUserIdVsUserRecords= new map<id,user>();
  set<id> CaseteamMemberIds= new set<id>();
  owe = [select Address,IsAllowAllProfiles,DisplayName from OrgWideEmailAddress where DisplayName='COH Care Coordination Application'];  
 
  for(EmailTemplate tempemailtmp : [SELECT id,folder.name ,DeveloperName  FROM EmailTemplate where folder.name =:'COH Templates' and  IsActive=true] ){
    if(tempemailtmp!=null)
         mapEmailTemplates.put(tempemailtmp.DeveloperName,tempemailtmp.id);
  }  
 
  
  if(trigger.IsUpdate){
     mails = new List<Messaging.SingleEmailMessage>();
     lstOfChatterPostToBeInserted= new list<FeedItem>();
     For( Health_Goal__c healthgoal : trigger.new ){
       if ((healthgoal.Complete__c != null && Trigger.oldMap.get(healthgoal.Id).Complete__c != healthgoal.Complete__c)
            ||(Trigger.oldMap.get(healthgoal.Id).status__c != healthgoal.status__c && healthgoal.status__c=='Completed' ) ) {
            /* adding the health goal(checklist id) in the set recordsid.*/
             recordsid.add(healthgoal.id);
       }
   }
   if(recordsid != null && recordsid.size() > 0){
       lstCheckListRecords = [select id ,Complete__c,status__c,case__c ,No_of_Completed_Tasks__c,Total_No_of_Tasks__c,flag1__c from Health_Goal__c where id in :recordsid];
   }
    lstUpdateTask= new list<task>();
   
   if(lstCheckListRecords != null && lstCheckListRecords.size() > 0){
          recordsid= new set<id>();
          for(Health_Goal__c  hhg : lstCheckListRecords){
            /* when the health goal (checklist ) is completed then this loop will be executed*/
                if(hhg.status__c  =='Completed' && hhg.flag1__c== true){
                  checkflag=true;
                  recordsid.add(hhg.id);
                  /* checking if all the tasks are completed then change the status of healthgoal(checklist) to closed*/
                     if(  hhg.No_of_Completed_Tasks__c==hhg.Total_No_of_Tasks__c    ){
                          hhg.status__c='Completed';
                          hhg.Completed_Date__c=date.today();
                          lstUpdateRecords.add(hhg);
                          addflag=true;
                      }
                
               }
               /* when the health goal (checklist ) is  not completed then this loop will be executed*/
                 if(hhg.status__c  !='Completed' &&  hhg.flag1__c== false){
                  checkflag=false;
                  recordsid.add(hhg.id);
                   /* checking if all the tasks are completed then change the status of healthgoal(checklist) to closed*/
                     if(  hhg.No_of_Completed_Tasks__c==hhg.Total_No_of_Tasks__c  ){
                          hhg.status__c='Completed';
                          hhg.Completed_Date__c=date.today();
                          
                          addflag= true;
                          lstUpdateRecords.add(hhg);
                     }
               }
               caseid.add(hhg.case__c);
           }
       
     }
     if(recordsid !=null && recordsid.size()>0 && checkflag==true &&  addflag== false){
         lstofRelatedTask= [select id ,WhatId,status from task where WhatId in :recordsid  and status !='Completed' and status !='Deferred' ];   
     }
     
     if(lstofRelatedTask !=null && lstofRelatedTask.size()>0){
        for(Task temptask:lstofRelatedTask ){
            temptask.status='Completed';
            lstUpdateTask.add(temptask);
        }
    }
    
    if(lstUpdateTask !=null && lstUpdateTask.size()>0){
        try{
           update lstUpdateTask;
        }
        catch (Exception e){
        system.debug('**************Exception **********'+ e.getmessage()); 
            
        }
        
    }
   
         if(recordsid != null && recordsid.size() > 0){
            for(Health_Goal__c checklistitems : [select id ,Complete__c,status__c,case__c ,No_of_Completed_Tasks__c,Total_No_of_Tasks__c,flag1__c,Created_Status__c,Created_Stage__c from Health_Goal__c where id in :recordsid]){
                if(checklistitems !=null){
                    /* creating a map (mapOfCaseIdAndStage)of id and healthgoal(checklist items)*/
                    mapOfCaseIdAndStage.put(checklistitems.id,checklistitems.Created_Stage__c+ checklistitems.Created_Status__c);
                    setcasestage.add(checklistitems.Created_Stage__c);
                    setcasestatus.add(checklistitems.Created_Status__c);
                }
            
             }
         }
       if(caseid!=null && caseid.size() > 0){ 
        for(CaseTeamMember caseteamRecords:[select TeamRole.name,memberid,parentid from CaseTeamMember where
                                            parentid in : caseid ]){
           CaseteamMemberIds.add(caseteamRecords.memberid);
          /* creating a map (mapOfCaseTeamMemberAndRole)of id and case team member records for the particular case*/
           if(caseteamRecords !=null)
            mapOfCaseTeamMemberAndRole.put(caseteamRecords.memberid,caseteamRecords);
            
        }
    }
    if(CaseteamMemberIds !=null && CaseteamMemberIds.size()>0){
            
            mapOfUserIdVsUserRecords= new map<id,user>([select id ,CC_Receive_Checklist_Completion_Emails__c, CC_Receive_Checklist_Assignment_Email__c, 
                                                                CC_Receive_Assingment_Emails__c from user where id in :CaseteamMemberIds]);
            
     }
    if(setcasestage.size()>0 || setcasestatus.size()>0) {
        for(Alert_Detail__c  alertRecords : [select id, Alert_Master__c, Alert_Master__r.Alert_Type__c,Templates__c,Assign_To__c ,Alert_Master__r.Status__c,  
                                            Alert_Master__r.stage__c,description__c,Checklist__r.name,Static_chatter_text__c from Alert_Detail__c
                                             where Alert_Master__r.stage__c in :setcasestage 
                                            and Alert_Master__r.Status__c in: setcasestatus and Alert_Type__c='Checklist Completed']){
                                         
              if(alertRecords!=null && alertRecords.Alert_Master__r.stage__c!=null)                           
                mapOfStageAndAlertDetail.put(alertRecords.Alert_Master__r.stage__c+ alertRecords.Alert_Master__r.status__c +alertRecords.Assign_To__c+alertRecords.Checklist__r.name ,alertRecords);                         
         }  
                                  
     }
   
   If (lstUpdateRecords != null && lstUpdateRecords.size() > 0){
   
     try{
   
       Database.SaveResult[] srList = Database.update(lstUpdateRecords, false);
     
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                      setSuccessrecordid.add(sr.getId());
                     
                    }
                    else{
                        system.debug('*********Exception ListNotInserted*******');
                    }
     
                }
     }
      catch(Exception e){
      
          system.debug('*************Exception***********'+ e.getmessage());
      
      }
      if(setSuccessrecordid != null && setSuccessrecordid.size()>0){
      
        lstCheckListRecords= new list<Health_Goal__c>();
          lstCheckListRecords= [select id ,name,Complete__c,status__c,Assigned_to__c,case__c,Assigned_to__r.name,case__r.owner.email,Assigned_to__r.firstname
                                 ,Completed_By__r.name,Static_chatter_text__c,case__r.ownerid,Completed_By__c from Health_Goal__c 
                                 where id in :setSuccessrecordid and status__c='Completed'];
      }
      if(lstCheckListRecords != null && lstCheckListRecords.size() > 0 ){
            for(Health_Goal__c checklisttaskrecord :lstCheckListRecords ){
                string getStageofCase;
                Alert_Detail__c tempalertDetail= new Alert_Detail__c();
                string asigntorole;
                user Userdetails = new user();
                caseteammember CseteamMembrRecords= new caseteammember();
                if(mapOfCaseTeamMemberAndRole.size()>0 && mapOfCaseTeamMemberAndRole!=null){
                        CseteamMembrRecords=mapOfCaseTeamMemberAndRole.get(checklisttaskrecord.Assigned_to__c);
                        if(CseteamMembrRecords !=null){
                             asigntorole=CseteamMembrRecords.teamrole.name;
                            Userdetails=mapOfUserIdVsUserRecords.get(CseteamMembrRecords.memberid);
                        }
                        
                }
                if(mapOfCaseIdAndStage.size()>0 &&  mapOfCaseIdAndStage !=null){
                 getStageofCase=mapOfCaseIdAndStage.get(checklisttaskrecord.id);
                }
                if(getStageofCase!=null){
                    if( mapOfStageAndAlertDetail.size()>0 && mapOfStageAndAlertDetail !=null){
                      
                            if(asigntorole !=null)
                            tempalertDetail =   mapOfStageAndAlertDetail.get(getStageofCase+asigntorole+checklisttaskrecord.name );
                          
                    }
                    
                }
                  if(tempalertDetail !=null){
                     id tempid;
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     if(mapEmailTemplates !=null && mapEmailTemplates.size()>0){
                            if(tempalertDetail.Templates__c !=null)
                            tempid = mapEmailTemplates.get(tempalertDetail.Templates__c);
                     } 
                     if(Userdetails != null && Userdetails.CC_Receive_Checklist_Completion_Emails__c==true){
                         if(checklisttaskrecord.Assigned_to__c  !=checklisttaskrecord.Completed_By__c ){      
                           
                            if( tempid != null){
                                    mail.setTemplateId(tempid);
                                    if(owe.id !=null){
                                         mail.setOrgWideEmailAddressId(owe.Id);
                                     }
                                     mail.whatid=checklisttaskrecord.id;
                                     mail.setTargetObjectId(checklisttaskrecord.Assigned_to__c);
                                     mail.saveAsActivity = false;
                                     mails.add(mail);
                             }
                       }
                       else{
                          
                         if( tempid != null){
                              mail.setTemplateId(tempid);
                              if(owe.id !=null){
                                 mail.setOrgWideEmailAddressId(owe.Id);
                               }
                              mail.whatid=checklisttaskrecord.id;
                              mail.setTargetObjectId(checklisttaskrecord.case__r.ownerid);
                              mail.saveAsActivity = false;
                              mails.add(mail);
                         }
                        
                      }
                }
                     
              /* when checklist is completed below code helps is posting chatter posts*/       
               string assignTo;
               string description; 
                if(tempalertDetail !=null && tempalertDetail.Description__c !=null){
               
                    if(tempalertDetail.Static_chatter_text__c==false)
                      description= checklisttaskrecord.name+' ' +tempalertDetail.Description__c ;
                  else
                      description= tempalertDetail.Description__c ;
                }
                
                FeedItem TempFeedItem= new FeedItem();
                if(checklisttaskrecord.Completed_By__r.name !=null){
                    assignTo=checklisttaskrecord.Completed_By__r.name;
                }
                else{
                    assignTo='';
                }
                  TempFeedItem=CH_AlertEngineHelperClass.CreateChatterPost( checklisttaskrecord.case__c ,description,assignTo,tempalertDetail.Static_chatter_text__c);
                  if(TempFeedItem !=null){
                        if( TempFeedItem.body!=null){
                          if((setOfPreventDuplicateChatterPost.contains(TempFeedItem)== false)|| (setOfPreventDuplicateChatterPost.size()==0)){
                                lstOfChatterPostToBeInserted.add(TempFeedItem);
                             }
                         setOfPreventDuplicateChatterPost.add(TempFeedItem);
                      }
                  }
             }
         }
     }
   }
   
    
      if(mails !=null && mails.size()>0){
              try{
                Messaging.sendEmail(mails);
              }
            catch(Exception e){
                 System.debug('******************Exception***********'+ e.getmessage())  ;
                
            }
        
      }
       if(lstOfChatterPostToBeInserted !=null && lstOfChatterPostToBeInserted.size()>0){
              try{
                insert lstOfChatterPostToBeInserted;
              }
            catch(Exception e){
                 System.debug('******************Exception***********'+ e.getmessage())  ;
                
            }
        
      }
  }
  
  if(trigger.IsInsert){
    
  /*   CH_HealthGoalHelperClass is calles when the healthgoal (checklist ) record is inserted 
    to prepare list of mails for the actors for checklist assignments*/
    for(Health_Goal__c checklistrecords : trigger.new){
        lstChecklistRecordsTobeProcessedOnInsert.add(checklistrecords);
    }
    if(lstChecklistRecordsTobeProcessedOnInsert !=null && lstChecklistRecordsTobeProcessedOnInsert.size()>0)
         CH_HealthGoalHelperClass.sendAssignmentNotificationwhenChecklistIsAssigned(lstChecklistRecordsTobeProcessedOnInsert);
 
  }
   
}