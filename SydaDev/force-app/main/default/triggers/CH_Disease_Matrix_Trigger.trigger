trigger CH_Disease_Matrix_Trigger on Disease_Matrix__c (Before Insert,Before Update){

    Map<id,Disease_Matrix__c > ExistingDiseaseList =New Map<id,Disease_Matrix__c>();
    Set<id> UserIdList =New Set<id>();
    Map<id,id> UserAndUserLimitMap = New Map<id,id>();
    
    //GET LIST OF USERS FROM TRIGGER.NEW 
    for(Disease_Matrix__c D: trigger.new){
     if(D.User__c!=NULL){
      UserIdList.add(D.User__c);
     }
    }
    
    If(!UserIdList.isempty()){
        //GET LIST OF EXISTION DISEASE RECORD FOR USERS FROM TRIGGER.NEW 
        for(Disease_Matrix__c  D:[select id,Name,Physician__c,Disease_Name__c,User_Role_Name__c,User__c from Disease_Matrix__c where User__c In :UserIdList]){
          if(D.User__c!=Null)
              ExistingDiseaseList.put(D.User__c,D);
        }
            
        //GET MAP OF USER AND USER LIMITS
        
        for(User_limits__c UL:[SELECT id,User__c from User_limits__c WHERE user__c In :UserIdList]){
         UserAndUserLimitMap.Put(UL.User__c,Ul.ID);
        }
    }
    
    //VALIDATE IF DISEASE RECORD ALREADY EXISTS FOR USER,USER ROLE,PHYSICIAN AND DISEASE TYPE COMBINATION FROM TRIGGER.NEW 
    for(Disease_Matrix__c D:trigger.new){
         if(UserAndUserLimitMap.get(D.User__c)== Null && d.User__c!=Null){
            D.addError(system.label.CH_Disease_Matrix_User_Limit_Validation);
         }
    
      }
      
}