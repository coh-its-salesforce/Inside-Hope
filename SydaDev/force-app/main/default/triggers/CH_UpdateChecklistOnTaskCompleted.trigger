/*
*  Name           :   CH_UpdateChecklistOnTaskCompleted
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :  update trigger fires to count the total number of taks in a particular Health goal (checklist) record
                    and updates the total number of task field in Health goal (checklist) records.

*/


trigger CH_UpdateChecklistOnTaskCompleted on Task (after Update,after Insert) {
 set<id> tasksParentId= new set<id>();
 set<id> setOFOpentasksParentId= new set<id>();
 Map<string,Task> mapOfIdAndTask = new map<string,Task>();
 Map<string,Task> mapOfIdAndOpenTask = new map<string,Task>();
 List <Health_Goal__c> lstChecklistRecords= new list<Health_Goal__c>();
 List <Health_Goal__c> lstUpdateTaskRecords= new list<Health_Goal__c>();
 List <Health_Goal__c> lstChecklistRecordsclone= new list<Health_Goal__c>();
 List <Health_Goal__c> lstUpdateTaskRecordsclone= new list<Health_Goal__c>();
 Map<string,list<Task>> mapOfIdAndTaskinsert = new map<string,list<Task>>();
 set<id> setOfCompletedTaskTobeInserted= new set<id>();   
    
   if(Trigger.IsUpdate){
  
        For( Task task : Trigger.new){
          if( ((Trigger.oldMap.get(task.Id).Status != task.Status &&  task.Status != null) && task.IsHealthGoalTask__c==true  && ( Trigger.oldMap.get(task.Id).Status !='Completed' 
            ||   Trigger.oldMap.get(task.Id).Status !='Deferred') ) ){
            
            /* when the task is completed then the below code will execute*/
              if( task.status=='Completed' || task.status=='Deferred' ){                
                  tasksParentId.add(task.WhatId);
                  mapOfIdAndTask.put(task.WhatId + ''+task.id , task );
              }
           }
            if( (Trigger.oldMap.get(task .Id).Status != task.Status &&  task.Status != null &&  task.IsHealthGoalTask__c==true && (Trigger.oldMap.get(task .Id).Status=='Completed'
             ||Trigger.oldMap.get(task.Id).Status=='Deferred'  )) ){
              /* when the task is  not completed then the below code will execute*/
              if( task.status !='Completed' || task.status !='Deferred'){
                 setOFOpentasksParentId.add(task.WhatId);
                  mapOfIdAndOpenTask.put(task.WhatId + ''+task.id , task );
              }
           }
        }
       
         if(setOFOpentasksParentId != null && setOFOpentasksParentId.size() > 0){
            lstChecklistRecordsclone=[select id,Completed_By__c, No_of_Completed_Tasks__c From Health_Goal__c where id in :setOFOpentasksParentId];
          }
           If (lstChecklistRecordsclone.size()>0){
              for( Health_Goal__c checklist : lstChecklistRecordsclone){
                 Integer CountCompletedTaskcom =0;
                 for (string key : mapOfIdAndOpenTask .keySet()) {
                      if( key.contains(checklist.id)==true){
                        CountCompletedTaskcom ++;
                      }
                 }
               if(checklist.No_of_Completed_Tasks__c!=null){
                 checklist.No_of_Completed_Tasks__c= (checklist.No_of_Completed_Tasks__c -CountCompletedTaskcom ) ;
                 
                }
              if(UserInfo.getUserId() !=null){
                     checklist.Completed_By__c=UserInfo.getUserId();
              }
             
              lstUpdateTaskRecordsclone.add(checklist);
            }
         }
         if(lstUpdateTaskRecordsclone != null && lstUpdateTaskRecordsclone.size() > 0 ){
            try{
                update lstUpdateTaskRecordsclone;
             }
             catch( Exception e){
                 system.debug('************ExceptioN****************'+e.getmessage());
             }
          
         }
        if(tasksParentId != null && tasksParentId.size()>0){
          lstChecklistRecords=[select id, No_of_Completed_Tasks__c From Health_Goal__c where id in :tasksParentId];
        }
        If (lstChecklistRecords.size()>0){
            for( Health_Goal__c checklist : lstChecklistRecords){
                  Integer CountCompletedTask =0;
                  for (string key : mapOfIdAndTask.keySet()) {
                      if( key.contains(checklist.id)==true){
                        CountCompletedTask ++;
                      }
        
                 }
              if(checklist.No_of_Completed_Tasks__c!=null){
                      checklist.No_of_Completed_Tasks__c= checklist.No_of_Completed_Tasks__c + CountCompletedTask ;
               }
               else{
                      checklist.No_of_Completed_Tasks__c= CountCompletedTask ;
               }
              if(UserInfo.getUserId() !=null){
                      checklist.Completed_By__c=UserInfo.getUserId();
               }
                lstUpdateTaskRecords.add(checklist);
           }
       }
    
          if(lstUpdateTaskRecords != null && lstUpdateTaskRecords.size()>0){
             try{
                update lstUpdateTaskRecords;
             }
             catch( Exception e){
                 system.debug('************ExceptioN****************'+e.getmessage());
             }
          
           }
        
    }
   If(Trigger.IsInsert){
        For( Task task : Trigger.new){
            
                  if( task.status !=null && task.IsHealthGoalTask__c==true  ){
                     tasksParentId.add(task.WhatId);
                     list<task> lsttempTaskList= new list<task>();
                     if( mapOfIdAndTaskinsert.get(task.WhatId)==Null && (lsttempTaskList == Null || lsttempTaskList.isempty())) {
                         lsttempTaskList.add(task);
                    } else {
                    lsttempTaskList = mapOfIdAndTaskinsert.get(task.WhatId);
                    lsttempTaskList.add(task);
                   }
                    if(lsttempTaskList!=Null) {
                        mapOfIdAndTaskinsert.put(task.WhatId,lsttempTaskList);
                    }
                  }
         }
          if(tasksParentId != null && tasksParentId.size()>0){
             lstChecklistRecords=[select id, Total_No_of_Tasks__c,No_of_Completed_Tasks__c ,name From Health_Goal__c where id in :tasksParentId];
          }
         
        If (lstChecklistRecords.size()>0){
            
            for( Health_Goal__c checklist : lstChecklistRecords){
                Integer CountCompletedTask =0;
                Integer CountCompletedTaskInInsert =0;
                list<Task> temptask= new list <task>();
                temptask=mapOfIdAndTaskinsert.get(checklist.id);
                 CountCompletedTask = temptask.size();
                    for(task tmp :temptask){
                        if(tmp.status=='Completed' || tmp.status=='Deferred')
                         CountCompletedTaskInInsert ++;
                    }
                 if(checklist.Total_No_of_Tasks__c!=null){
                      checklist.Total_No_of_Tasks__c= checklist.Total_No_of_Tasks__c + CountCompletedTask;
                  }
                  else{
                      checklist.Total_No_of_Tasks__c= CountCompletedTask;
                  }
                if(CountCompletedTaskInInsert >0){
                  if(checklist.No_of_Completed_Tasks__c !=null ){
                  checklist.No_of_Completed_Tasks__c= checklist.No_of_Completed_Tasks__c + CountCompletedTaskInInsert ;
                  }
                   else{
                       checklist.No_of_Completed_Tasks__c= CountCompletedTaskInInsert ;
                   }
                 } 
                  
                  
                 lstUpdateTaskRecords.add(checklist);
            }
         }
       
         if(lstUpdateTaskRecords != null && lstUpdateTaskRecords.size() > 0){
             try{
             update lstUpdateTaskRecords;
             }
             catch( Exception e){
                 system.debug('************Exception****************'+e.getmessage());
             }
          
         }
       
   }
   
 }