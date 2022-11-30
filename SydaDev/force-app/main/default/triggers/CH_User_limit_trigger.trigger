trigger CH_User_limit_trigger on User_Limits__c (Before Delete) {
  /*
    if(trigger.isInsert || trigger.IsUpdate){
            Map<id,User_Limits__c> ExistingULList =New Map<id,User_Limits__c>();
            Set<id> UserIdList =New Set<id>();
            
            for(User_Limits__c  UL: trigger.new){
                 if(UL.User__c!=NULL){
                      UserIdList.add(Ul.User__c); 
                 }
            }
            
            for(User_Limits__c UL:[select id,User__c from User_limits__c where User__c In :UserIdList]){
                 if(Ul.User__c!=Null)
                      ExistingULList.put(Ul.User__c,Ul);
            }
            
            for(User_Limits__c  UL:trigger.new){
                 if(trigger.isInsert && ExistingULList.get(UL.User__c)!=NULL ){
                      Ul.addError(system.label.CH_User_Limit_Trigger_Validation_for_duplicate); 
                 }
                 if( trigger.IsUpdate && trigger.oldMap.get(UL.Id).User__c !=  UL.User__c && ExistingULList.get(UL.User__c)!=NULL){
                      Ul.addError(system.label.CH_User_Limit_Trigger_Validation_for_duplicate); 
                 }
                 
                 
            }
    }
     */
    if(trigger.isDelete){ 
     
     Set<id> ExistingCTMList =New Set<id>();
     Set<id> UserIdList =New Set<id>();
     
     For(User_limits__c UL:trigger.old ) {
          if(UL.User__c!=NULL){
              UserIdList.add(Ul.User__c); 
             }
     }
     for(caseTeamMember CTM:[select id,MemberId from caseteamMember where MemberId In :UserIdList]){
       ExistingCTMList.add(CTM.MemberID) ;
     }
     
     for(User_Limits__c  UL:trigger.old){
             if(ExistingCTMList.contains(UL.User__c)){
              Ul.addError(system.label.CH_User_Limit_trigger_delete_validation); 
             }
         }
        
    }
}