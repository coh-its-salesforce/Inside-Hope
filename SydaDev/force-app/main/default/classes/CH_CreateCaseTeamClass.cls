/*
*  Name           :  CH_CreateCaseTeamClass
*  Created By     :   Persistent Systems Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   This class contains methods to create case team based on stage and status of case.
*/
global class CH_CreateCaseTeamClass {
    public static void caseTeamCreator(List<case> caseList,List<string> physicianList ,List<string> diseaseList, list<string> statusStatusList,Set<id> setOfCaseIds) {
    
        List<User_Limits__c> toBeAssignedUserList=new List<User_Limits__c>();
        Set<caseTeamMember> caseteam = new Set<caseTeamMember>();
        Map<id,Set<caseTeamMember>> mapCaseidCaseteamMember =new  Map<id,Set<caseTeamMember>>();
        Map<id,Set<id>> MapCaseidAndChatterfollower =new  Map<id,Set<id>>();
        Map<ID,User_Limits__c> ULmap = new Map<ID,User_Limits__c>();
        Map<ID,User_Limits__c> ULmap2ndbest = new Map<ID,User_Limits__c>();
        Map<ID,User_Limits__c> ULmapDiseaseGroup = new Map<ID,User_Limits__c>();
        Map<string,string> diseaseAndDiseaseGroupMap = new Map<string,string>();
        Map <string,String> stageStatusAndCaseTeamMap   = New Map <string,String>();
        Map <string,String> stageStatusAndCaseOwnerMap  = New Map <string,String>();
        Map<id,Integer> userAndRemainingCountMap = new  Map<id,Integer>();
        Map<id,Integer> userAndCaseAssignmentCountMap = new  Map<id,Integer>();
        Set<ID> userIDofdeletedTeamMember = new set<ID>();
        Map <string,id> teamRoleMap = new map <string,id>();
        List<string> mapCaseAndDiseasePhysician = new List<string>();
        List<User_Limits__c>  UserLimitList= new List<User_Limits__c>();
        Map<string,id> MapRoleAndDefaultUser = new Map<string,id>();
        Map<string,list<Disease_Matrix__c>> mapDiseaseMatrixKeyAndUsers=new map<string,list<Disease_Matrix__c>>();
        Set<string> DiseaseGroupRolesSet = new Set<String>();
        Set<string> diseaseGroupNameset = new set<string>();
        Set<id> DiseaseUserId = new set<id>();
        Set<caseTeamMember> deleteCaseTeamMembersSet = new Set<caseTeamMember>();
       
        //DISEASE GROUP AND ROLE SET AND MAP OF ROLE AND DEFAULT USER
        
        for (Role_Master__c rd:[select id,
                                       Name,
                                       FkManager__c,
                                       Disease_Group_Assignment__c 
                                       FROM Role_Master__c   ]){
                                       
            if(rd.Disease_Group_Assignment__c==True){
                DiseaseGroupRolesSet.add(rd.Name);
            }
            MapRoleAndDefaultUser.put(rd.Name,rd.FkManager__C);
        }
        for (caseteamrole ctr: [select Id,name from CaseTeamRole]) {
            teamRoleMap.put(ctr.name,ctr.id);
        }
        //Create Status/stage and team members to be created
        For(Case_Stage_Team_Master__c SCTM:[select id,
                                                   Stage_Name__c,
                                                   Status_name__c,  
                                                   Case_Team__c,
                                                   Case_Owner_Name__c 
                                                   FROM Case_Stage_Team_Master__c]){
                                                   
            if(sctm.Status_name__c == Null){
                stageStatusAndCaseTeamMap.put(Sctm.Stage_Name__c.toLowercase(),Sctm.Case_Team__c);
                stageStatusAndCaseOwnerMap.put(Sctm.Stage_Name__c.toLowercase(),Sctm.Case_Owner_Name__c);
            } else {
                stageStatusAndCaseTeamMap.put(Sctm.Stage_Name__c.toLowercase()+Sctm.Status_name__c.toLowercase(),Sctm.Case_Team__c);
                stageStatusAndCaseOwnerMap.put(Sctm.Stage_Name__c.toLowercase()+Sctm.Status_name__c.toLowercase(),Sctm.Case_Owner_Name__c);
            }
        }
        if(diseaseList!=Null && !diseaseList.isempty()) {
            for (Disease_Master__c DD:[SELECT Disease_Group_Name__c,
                                                          Name
                                                          FROM Disease_Master__c 
                                                          WHERE Name   IN :diseaseList]) {
                diseaseGroupNameset.add(DD.Disease_Group_Name__c);
                diseaseAndDiseaseGroupMap.put(DD.Name.toLowercase(),DD.Disease_Group_Name__c);
            }
        }
        // CASE AND EXISTING CASE TEAM MEMBER MAP 
        For (caseTeamMember ctm :[select parentid,
                                         MemberId ,
                                         TeamRole.name 
                                         FROM CaseTeamMember 
                                         WHERE parentid IN :setOfCaseIds]){
                                         
            Set <caseTeamMember> tempCaseTeamList = new Set <caseTeamMember>();
            if( mapCaseidCaseteamMember.get(ctm.parentID)==Null && (tempCaseTeamList == Null || tempCaseTeamList.isempty())) {
                tempCaseTeamList.add(ctm);
            } else {
                tempCaseTeamList = mapCaseidCaseteamMember.get(ctm.parentID);
                tempCaseTeamList.add(ctm);
            }
            if(tempCaseTeamList!=Null) {
                mapCaseidCaseteamMember.put(ctm.parentID,tempCaseTeamList);
            }
        }
        // CASE AND EXISTING CASE FOLLOWER MAP  
        For (EntitySubscription es:[select parentID,
                                                   SubscriberId
                                                   FROM EntitySubscription 
                                                   WHERE parentid IN :setOfCaseIds]) {
            Set <id> tempCaseFollowerList = new Set <id>();
            if( MapCaseidAndChatterfollower.get(es.parentID) == Null &&( tempCaseFollowerList == Null || tempCaseFollowerList.isempty())) {
                tempCaseFollowerList.add(es.SubscriberId);
            } else {
                tempCaseFollowerList = MapCaseidAndChatterfollower.get(es.parentID);
                tempCaseFollowerList.add(es.SubscriberId);
            }
            if(tempCaseFollowerList!=Null) {
                MapCaseidAndChatterfollower.put(es.parentID,tempCaseFollowerList);
            }
        }
      
        for (Disease_Matrix__c DCM:[select Physician__c,
                                           User__c,
                                           User__r.isActive,
                                           User_Role_Name__c,
                                           Disease_Name__c,
                                           Disease_Group_formula__c
                                           FROM Disease_Matrix__c 
                                           WHERE (Physician__c IN :PhysicianList  
                                           OR  Disease_Group_formula__c
                                           IN :  diseaseGroupNameset ) 
                                           And Disease_Name__c IN : diseaseList 
                                           AND User__r.isActive = true]){
            DiseaseUserId.add(DCM.User__c);
            // FOR MAP OF DISEASE AND PHYSICIAN COMBINATION USERS                                 
            if(dcm.Disease_Name__c!=Null && dcm.Physician__c!=Null){
                List<Disease_Matrix__c> tempDisease= new list<Disease_Matrix__c>();
                if(mapDiseaseMatrixKeyAndUsers.get((dcm.Disease_Name__c.toLowerCase())+string.valueOf(dcm.Physician__c).substring(0,15)) == Null || 
                    mapDiseaseMatrixKeyAndUsers.get((dcm.Disease_Name__c.toLowerCase())+string.valueOf(dcm.Physician__c).substring(0,15)).isempty()) {
                    tempDisease.add(dcm);
                  }
                Else {
                    tempDisease = mapDiseaseMatrixKeyAndUsers.get((dcm.Disease_Name__c.toLowerCase())+string.valueOf(dcm.Physician__c).substring(0,15));
                    tempDisease.add(DCM);
                }
                if(tempDisease!=Null){
                    mapDiseaseMatrixKeyAndUsers.put((dcm.Disease_Name__c.toLowerCase())+string.valueOf(dcm.Physician__c).substring(0,15),tempDisease);
                }
            }
            // FOR MAP OF DISEASE COMBINATION USERS 
            if(dcm.Disease_Name__c!=Null ) {
                List<Disease_Matrix__c> tempDisease= new list<Disease_Matrix__c>();
                if(mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Name__c.toLowercase())==Null ||mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Name__c.toLowercase()).isempty()) {
                    tempDisease.add(dcm);
                }
                Else {
                    tempDisease = mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Name__c.toLowerCase());
                    tempDisease.add(dcm);
                }
                if(tempDisease!=Null){
                    mapDiseaseMatrixKeyAndUsers.put(dcm.Disease_Name__c.toLowerCase(),tempDisease);
                }
            }
            // FOR MAP OF DISEASE GROUP USERS   
            
            if(dcm.Disease_Group_formula__c != Null && DiseaseGroupRolesSet.contains(DCM.User_Role_Name__c)) {
                List<Disease_Matrix__c> tempDisease= new list<Disease_Matrix__c>();
                if(mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Group_formula__c) == Null || mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Group_formula__c).isempty()) {
                    tempDisease.add(dcm);
                }
                Else {
                    tempDisease = mapDiseaseMatrixKeyAndUsers.get(dcm.Disease_Group_formula__c);
                    tempDisease.add(dcm);
                }
                if(tempDisease!=Null){
                    mapDiseaseMatrixKeyAndUsers.put(dcm.Disease_Group_formula__c,tempDisease);
                }
            }
        }
        
        for( User_Limits__c UL:[select  Case_Count_Limit__c,   
                                        User__r.firstName,
                                        User__r.LastName,
                                        id,
                                        User__c,
                                        Max_Case_Limit__c
                                        FROM User_Limits__c 
                                        WHERE user__c IN :DiseaseUserId 
                                        ORDER BY Case_Count_Limit__c,User__r.LastName,User__r.FirstName ASC ]) {
            userLimitList.add(UL);
            userAndRemainingCountMap.put(UL.User__c,integer.ValueOf(UL.Max_Case_Limit__c-UL.Case_Count_Limit__c));
            userAndCaseAssignmentCountMap.put(Ul.User__c,integer.valueOf(UL.Case_Count_Limit__c));
        }
        for (case caseRecord:CaseList) {
            Set<string> CTMToBeCreated=new Set<string>();
            Set<id> ExistingCaseTeam = new SET<id>();
            Map<String,CaseteamMember> teammemberMap = new Map<String,CaseTeamMember>();
            Map<string,Disease_matrix__C> RoleAnd2ndBestUserMap = new Map<string,Disease_matrix__C>();
            Map<string,Disease_matrix__C> RoleAndBestUserMap = new Map<string,Disease_matrix__C>();
            Map<string,Disease_matrix__C> RoleAndDiseaseGroupMap = new Map<string,Disease_matrix__C>();
            Set<id> DCMSet= new Set<id>();
            String caseOwnerRoleToBeChanged ;
            Map<Id,User_Limits__c> ULMapForOtherCombination = new Map<Id,User_Limits__c>();
            Id NewcaseOwner;
            string NewcaseOwnerRole;
            set<ID> CaseTeamMemberIDS = new set<ID>();
          
            if((CaseRecord.status__c== Null || CaseRecord.status__c=='') && CaseRecord.Stage__c!= null && CaseRecord.Stage__c != ''){
                if(stageStatusAndCaseTeamMap!= null && stageStatusAndCaseTeamMap.get(CaseRecord.Stage__c.toLowercase())!=Null){
                    CTMToBeCreated =new Set<string>(stageStatusAndCaseTeamMap.get(CaseRecord.stage__c.toLowercase()).split(';'));
                }   
                
                if(stageStatusAndCaseOwnerMap.get(CaseRecord.stage__c.toLowercase())!=Null){
                    caseOwnerRoleToBeChanged = stageStatusAndCaseOwnerMap.get(CaseRecord.stage__c.toLowercase());
                }
            } else {
                if(stageStatusAndCaseTeamMap!= null && CaseRecord.Stage__c!= null && CaseRecord.status__c!= null && stageStatusAndCaseTeamMap.get(CaseRecord.Stage__c.toLowercase() +CaseRecord.status__c.toLowercase())!=Null){
                    CTMToBeCreated =new Set<string>(stageStatusAndCaseTeamMap.get(CaseRecord.Stage__c.toLowercase() +CaseRecord.status__c.toLowercase()).split(';'));
                }
                if(CaseRecord.Stage__c!= null && CaseRecord.status__c!= null && stageStatusAndCaseOwnerMap.get(CaseRecord.Stage__c.toLowercase() +CaseRecord.status__c.toLowercase())!=Null){
                    caseOwnerRoleToBeChanged = stageStatusAndCaseOwnerMap.get(CaseRecord.Stage__c.toLowercase() +CaseRecord.status__c.toLowercase());
               }
            }
           
            
            //REMOVE FINANCIAL COUNSELLOR IF CALL TYPE = CONSULTS
            if(caseRecord.Type==CH_StaticComponentHelperClass.CallTypeToExcludeFC && 
                                       CTMToBeCreated.contains(CH_StaticComponentHelperClass.FinancialCounselorRoleName) ) {
                CTMToBeCreated.remove(CH_StaticComponentHelperClass.FinancialCounselorRoleName);
            }
            // REMOVE INTERPRETER IF PREFERRED LANGUAGE IS ENGLISH  
            if(caseRecord.Interpreter_Needed__c == FALSE && CTMToBeCreated.contains(CH_StaticComponentHelperClass.InterpreterRoleName) ) {
                CTMToBeCreated.remove(CH_StaticComponentHelperClass.InterpreterRoleName);
            }
            
            if(mapCaseidCaseteamMember.get(caseRecord.id)!=Null && !mapCaseidCaseteamMember.get(caseRecord.id).isempty()){
                for (CaseteamMember ctm:mapCaseidCaseteamMember.get(caseRecord.id)) {
                    ExistingCaseTeam.add(ctm.MemberId);
                    teammemberMap.put(ctm.TeamRole.name ,ctm);
                }
            }    
            //SET OF CASE TEAM MEMBER ROLE TO BE CREATED
            if(mapCaseidCaseteamMember.get(caseRecord.id)!=Null && !mapCaseidCaseteamMember.get(caseRecord.id).isempty()){
                for (CaseteamMember ctm:mapCaseidCaseteamMember.get(caseRecord.id)) {
                    if(CTMToBeCreated.contains(ctm.TeamRole.name) || CTMToBeCreated.contains(ctm.TeamRole.name+CH_StaticComponentHelperClass.ManagerTeamRoleSuffix)) {
                        CTMToBeCreated.remove(ctm.TeamRole.name);
                    }
                }
            }    
            set<string> roleSetForBestUser= new set< string>();
            set<string> roleSetFor2ndBestUser= new set< string>();
            set<string> roleSetForDiseaseGroup= new set< string>();
          
            if(UserLimitList!=Null && !UserLimitList.isEmpty()){ 
                for (User_Limits__c UL:UserLimitList) {
                    //SORTED BEST USER
                    if(caseRecord.CC_AllScripts_Physician__c != Null && caseRecord.CC_Disease__c != Null 
                        && mapDiseaseMatrixKeyAndUsers.get((caseRecord.CC_Disease__c).toLowerCase()+string.valueof(caseRecord.CC_AllScripts_Physician__c).substring(0,15)) !=Null
                        && !mapDiseaseMatrixKeyAndUsers.get((caseRecord.CC_Disease__c).toLowerCase()+string.valueof(caseRecord.CC_AllScripts_Physician__c).substring(0,15)).isEmpty()){
                        for (Disease_Matrix__c DM: mapDiseaseMatrixKeyAndUsers.get((caseRecord.CC_Disease__c).toLowerCase()+ string.valueof(caseRecord.CC_AllScripts_Physician__c).substring(0,15))) {
                            if(DM.User__c == UL.User__c && CtmToBeCreated.contains(DM.user_role_name__c) ) {
                                if(ul.Case_Count_Limit__c < ul.Max_Case_Limit__c && (RoleSetForBestUser.contains(DM.user_role_name__c)==false || RoleSetForBestUser.size()==0)) {
                                    RoleAndBestUserMap.put(DM.user_role_name__c,Dm);
                                    ULmap.put(UL.User__c,UL);
                                    RoleSetForBestUser.add(DM.user_role_name__c);
                                }
                            }
                        }
                    }
                    //SORTED DISEASE GROUP USER
                    string diseaseGroupName =diseaseAndDiseaseGroupMap.get((caseRecord.CC_Disease__c).toLowerCase());
                   
                   if( diseaseGroupName!=Null && mapDiseaseMatrixKeyAndUsers.get(diseaseGroupName)!=Null && ! mapDiseaseMatrixKeyAndUsers.get(diseaseGroupName).isEmpty()){
                        for (Disease_Matrix__c DM: mapDiseaseMatrixKeyAndUsers.get(diseaseGroupName)) {
                            if(DM.User__c == UL.User__c && CtmToBeCreated.contains(DM.user_role_name__c)) {
                                if( ul.Case_Count_Limit__c < ul.Max_Case_Limit__c && (roleSetForDiseaseGroup.contains(DM.user_role_name__c)==false || roleSetForDiseaseGroup.size()==0)) {
                                    RoleAndDiseaseGroupMap.put(DM.user_role_name__c,Dm);
                                    ULmapDiseaseGroup.put(UL.User__c,UL);
                                    roleSetForDiseaseGroup.add(DM.user_role_name__c);
                                }
                            }
                        }
                    }
                    //SORTED 2ndBEST USER
                   
                    if(mapDiseaseMatrixKeyAndUsers.get(caseRecord.CC_Disease__c.toLowerCase())!=Null && !mapDiseaseMatrixKeyAndUsers.get(caseRecord.CC_Disease__c.toLowerCase()).isEmpty()){
                        
                        for (Disease_Matrix__c DM: mapDiseaseMatrixKeyAndUsers.get((caseRecord.CC_Disease__c).toLowerCase())) {
                            if((DM.physician__c == Null || DM.physician__c!= CaseRecord.CC_AllScripts_Physician__c) && DM.User__c == UL.User__c && CtmToBeCreated.contains(DM.user_role_name__c)) {
                                ULmap2ndbest.put(UL.User__c,UL);
                                if(UL.Case_Count_Limit__c < UL.Max_Case_Limit__c && (roleSetFor2ndBestUser.contains(DM.user_role_name__c)==false || roleSetFor2ndBestUser.size()==0) ){
                                    RoleAnd2ndBestUserMap.put(DM.user_role_name__c,Dm);
                                    ULMapForOtherCombination.put(UL.User__c,UL);
                                    roleSetFor2ndBestUser.add(DM.user_role_name__c);
                                }
                            }
                        }
                    }
                }
            }
            //CASE TEAM ASSIGNMENT ITTERATOR
            for (string Role:CTMToBeCreated){
                integer RemainingCaseCount;
                integer UpdatedCaseCount;
                CaseTeamMember ctm = new caseTeamMember();
                //BEST USER ASSIGNMENT 
                if(RoleAndBestUserMap.get(Role)!=Null && DiseaseGroupRolesSet.contains(Role)==false){
                    Disease_matrix__c DCM = new Disease_matrix__c();
                    DCM = RoleAndBestUserMap.get(Role);
                    User_limits__c tempUL = new  User_limits__c ();
                    if(DCM!=Null) {
                        tempUL = ULmap.get(DCM.User__C);
                    }
                    if(DCM !=Null && !ExistingCaseTeam.contains(DCM.User__c) && tempUL != Null ) {
                        if(tempUL!=Null && tempUL.Case_Count_Limit__c < tempUL.Max_Case_Limit__c && UserAndRemainingCountMap.get(tempUL.User__c) >0) {
                            ctm.memberid=DCM.User__c;
                            remainingCaseCount = integer.ValueOf(UserAndRemainingCountMap.get(tempUL.User__c))-1;
                            updatedCaseCount = integer.ValueOf(UserAndCaseAssignmentCountMap.get(tempUL.User__c))+1;
                            UserAndRemainingCountMap.Put(tempUL.User__c,remainingCaseCount);
                            UserAndCaseAssignmentCountMap.put(tempUL.User__c,updatedCaseCount);
                            tempUL.Case_count_limit__c =updatedCaseCount;
                            toBeAssignedUserList.add(tempUL);
                        }
                    }
                }
                
                //2ND BEST USER ASSIGNMENT
                If(ctm.memberid == Null && DiseaseGroupRolesSet.contains(Role) == false && RoleAnd2ndBestUserMap.get(Role)!=Null) {
                    Disease_matrix__c DCM2 = new Disease_matrix__c();
                    DCM2 = RoleAnd2ndBestUserMap.get(Role);
                    User_limits__c tempUL2 = new  User_limits__c ();
                    if(DCM2 !=null) {
                        tempUL2 = ULMapForOtherCombination.get(DCM2.User__C);
                    }
                    if(DCM2 !=Null && !ExistingCaseTeam.contains(DCM2.User__c) && tempUL2 != Null ) {
                        if(tempUL2.Case_Count_Limit__c < tempUL2.Max_Case_Limit__c && UserAndRemainingCountMap.get(tempUL2.User__c) >0) {
                            ctm.memberid=DCM2.User__c;
                            remainingCaseCount = integer.valueOf(UserAndRemainingCountMap.get(tempUL2.User__c))-1;
                            updatedCaseCount = integer.ValueOf(UserAndCaseAssignmentCountMap.get(tempUL2.User__c))+1;
                            userAndRemainingCountMap.Put(tempUL2.User__c,remainingCaseCount );
                            userAndCaseAssignmentCountMap.put(tempUL2.User__c,updatedCaseCount );
                            tempUL2.Case_count_limit__c =updatedCaseCount;
                            toBeAssignedUserList.add(tempUL2);
                        }
                    }
                }
                //DISEASE GROUP ASSIGNMENT
                if(DiseaseGroupRolesSet.contains(Role) && RoleAndDiseaseGroupMap.get(role)!=Null) {
                    Disease_matrix__c D = new Disease_matrix__c ();
                    D =RoleAndDiseaseGroupMap.get(role);
                    User_limits__c tempUL3 = new  User_limits__c ();
                    if(d!=Null) {
                        tempUL3 = ULmapDiseaseGroup.get(D.User__C);
                    }
                    if(D !=Null && !ExistingCaseTeam.contains(D.User__c) && tempUL3 !=Null && tempUL3.Case_Count_Limit__c < tempUL3.Max_Case_Limit__c  && UserAndRemainingCountMap.get(tempUL3.User__c) >0) {
                        ctm.memberid=D.User__c;
                        remainingCaseCount = integer.ValueOf(UserAndRemainingCountMap.get(tempUL3.User__c))-1;
                        updatedCaseCount = integer.ValueOf(UserAndCaseAssignmentCountMap.get(tempUL3.User__c))+1;
                        UserAndRemainingCountMap.Put(tempUL3.User__c,remainingCaseCount );
                        UserAndCaseAssignmentCountMap.put(tempUL3.User__c,updatedCaseCount );
                        tempUL3.Case_count_limit__c =updatedCaseCount;
                        toBeAssignedUserList.add(tempUL3);
                    }
                }
                ctm.ParentId=caserecord.id;
                ctm.TeamRoleId = teamRoleMap.get(Role);
                //MANAGER ASSIGNMENT    
                if(ctm.memberid == Null && !ExistingCaseTeam.contains(MapRoleAndDefaultUser.get(Role))!=Null 
                                    && !ExistingCaseTeam.contains(MapRoleAndDefaultUser.get(Role)) ) {
                    ctm.memberid= MapRoleAndDefaultUser.get(Role);
                    if(teamRoleMap.get(Role+CH_StaticComponentHelperClass.ManagerTeamRoleSuffix)!=Null) {
                        ctm.TeamRoleId = teamRoleMap.get(Role+CH_StaticComponentHelperClass.ManagerTeamRoleSuffix);
                    }
                }
                // ADD CASE TEAM MEMBER TO INSERT LIST
                if(ctm.memberid!=Null && !ExistingCaseTeam.contains(ctm.memberid) && ctm.ParentId!=Null && ctm.TeamRoleId!=Null &&
                                    !CaseTeamMemberIDS.contains(ctm.memberid)) {
                    //CASE TEAM ADD TO INSERT LIST
                    caseteam.add(ctm);
                    CaseTeamMemberIDS.add(ctm.memberid);
                    if(Role == caseOwnerRoleToBeChanged ){
                        NewcaseOwner=ctm.memberid;
                        NewcaseOwnerRole=Role;
                    }
                }
            }
            if(NewcaseOwner != Null) {
                caseRecord.ownerid= NewcaseOwner;
                caseRecord.Owner_Role__c =  caseOwnerRoleToBeChanged;
                if(CH_StaticComponentHelperClass.applyFixForSFissue1 == True && mapCaseidCaseteamMember.get(caseRecord.id) !=Null && !mapCaseidCaseteamMember.get(caseRecord.id).isEmpty()){
                    
                    deleteCaseTeamMembersSet.addAll(mapCaseidCaseteamMember.get(caseRecord.id));
                    for(CaseTeamMember ctm:mapCaseidCaseteamMember.get(caseRecord.id)){
                      caseTeamMember newTeamMember = new caseTeamMember();
                      newTeamMember.memberid =ctm.memberID;
                      newTeamMember.parentid = ctm.parentid;
                      newTeamMember.TeamRoleID =ctm.TeamRoleID;
                      caseTeam.add(newTeamMember);
                    }
                    //caseteam.addAll(mapCaseidCaseteamMember.get(caseRecord.id));
                   
                }
                
                
            }
           userLimitList.sort(); 
        }
        try {
            if(deleteCaseTeamMembersSet!=Null && !deleteCaseTeamMembersSet.isEmpty()){
               List<caseTeamMember> deleteTeamList =new List<caseTeamMember>();
               deleteTeamList.addAll(deleteCaseTeamMembersSet);
               List<Database.DeleteResult> deleteMemberList = Database.Delete(deleteTeamList, false);
            }   
        
            if (caseteam !=Null && !caseteam.isempty() ) {
                List<caseTeamMember> caseTeamList =new List<caseTeamMember>();
                List<EntitySubscription> CaseFollowers = new List<EntitySubscription>();
                set<string> teamMemberAndIdSet= new set<string>();
                for (caseTeamMember CTM:caseTeam) {
                    if(teamMemberAndIdSet.contains(string.valueOf(ctm.memberid)+string.valueOf(ctm.parentID)) == false || teamMemberAndIdSet.size() == 0 ){
                        caseTeamList.add(ctm);
                        teamMemberAndIdSet.add(string.valueOf(ctm.memberid)+string.valueOf(ctm.parentID));
                        if (MapCaseidAndChatterfollower.get(ctm.ParentID)!=Null &&  !MapCaseidAndChatterfollower.get(ctm.ParentID).isEmpty() && MapCaseidAndChatterfollower.get(ctm.ParentID).contains(Ctm.MemberId)==False) {
                            EntitySubscription es = new EntitySubscription(ParentId = Ctm.ParentID, SubscriberId = Ctm.MemberId);
                            CaseFollowers.add(es);
                        }
                        else if(MapCaseidAndChatterfollower.get(ctm.ParentID) == Null) {
                            EntitySubscription es = new EntitySubscription(ParentId = Ctm.ParentID, SubscriberId = Ctm.MemberId);
                            CaseFollowers.add(es);
                        }
                     }   
                }
              
                List<Database.SaveResult> CTMRList = Database.insert(caseteamList, false);
               
                if(CaseFollowers!=Null && !CaseFollowers.isempty()) {
                    List<Database.SaveResult> FollowersList = Database.insert(CaseFollowers, false);
                }
            }
            if(toBeAssignedUserList!=Null && !toBeAssignedUserList.isempty()) {
                set<user_limits__c> ToBeAssignedUserSet = new set<User_limits__c>(toBeAssignedUserList);
                toBeAssignedUserList.clear();
                toBeAssignedUserList.addAll(ToBeAssignedUserSet);
                if(toBeAssignedUserList!=Null && !toBeAssignedUserList.isempty()) {
                    List<Database.SaveResult> UserLimitUpdateList = Database.Update(toBeAssignedUserList, false);
                }
            }
        }
        catch(DmlException de) {
            System.debug('******************Exception***********'+de.getmessage());
        }
    }
    
    
    ///METHOD TO DECREASE OR INCREASE CASE COUNT WHEN CASE IS MADE INACTIVE/ACTIVE
    public static void updateCountOnCaseState(List<case> CaseList,List<ID> ListOfCaseIds ) {
        List<CaseTeamMember> caseTeamMemberList = new List<CaseTeamMember>();
        List<Id> memberIdList = new List<Id>();
        List<User_Limits__c> updateUserLimitList = new List<User_Limits__c>();
        for(CaseTeamMember ctm : [select parentid,
                                          MemberId ,
                                          TeamRole.name 
                                          FROM CaseTeamMember 
                                          WHERE parentid IN :ListOfCaseIds ]){
            caseTeamMemberList.add(ctm);                              
            memberIdList.add(ctm.memberID);
        }
        for (User_Limits__c UL:[select id,User__c,Case_Count_Limit__c FROM User_Limits__c WHERE user__c IN :memberIdList]) {
            UL.Case_Count_Limit__c -= 1;
            updateUserLimitList.add(ul);
        }
        SavePoint sp;
        try {
            sp = Database.setSavepoint();
            if(caseTeamMemberList != null && caseTeamMemberList.size() > 0) {
                delete caseTeamMemberList;
            }
            if(updateUserLimitList != null && updateUserLimitList.size() > 0){
                update updateUserLimitList;
            }
            delete [select id from Health_Goal__c where case__c IN : ListOfCaseIds];
        }catch(DmlException de) {
            Database.rollback(sp);
            System.debug('******************Exception***********'+de.getmessage());
        }
    }
    
    
    /// METHOD TO UPDATE STATUS WHEN ISSUE IS FOUND OR NOT FOUND.
    public static void ChangeStatusOnFinancialConcellorStatus(List<case> CaseList,List<ID> ListOfCaseIds,map<string,Status_Stage_Master__c> stageStatusMap ) {
        Map<id,id> mapCaseidNursePractitioner=new  Map<id,id>();
        Id LoggedinUserId=userinfo.getUserId();
          string FinancialCounselorRoleName = CH_StaticComponentHelperClass.FinancialCounselorRoleName+'%';
        for (caseTeamMember ctm :[select parentid,
                                         MemberId ,
                                         TeamRole.name 
                                         FROM CaseTeamMember 
                                         WHERE parentid IN :ListOfCaseIds AND TeamRole.name Like :FinancialCounselorRoleName  
                                         AND memberId =: LoggedinUserId  ]){
                                         
              mapCaseidNursePractitioner.put(ctm.parentID,ctm.memberId);
        }
        for (case caseRecord:CaseList) {
            if((mapCaseidNursePractitioner!=Null && LoggedinUserId == mapCaseidNursePractitioner.get(caseRecord.id) )){
                caseRecord.FkStatus__c =  stageStatusMap.get(CaseRecord.Financial_Status__c).ID;
                caseRecord.CC_Appointment_Date__c=null;
            }
            else{
                if((LoggedinUserId == caseRecord.ownerid )){
                    caseRecord.FkStatus__c =  stageStatusMap.get(CaseRecord.Financial_Status__c).ID;
                    caseRecord.CC_Appointment_Date__c=null;
                }
                else{
                     caseRecord.addError(system.label.CH_UpdateStage_PermissionIssue);
                }
            }
        }
    }
    
    
    public static void ChangeStatusOnPatientacceptedstatus(List<case> CaseList,set<ID> ListOfCaseIds,map<string,Status_Stage_Master__c> stageStatusMap ) {
        Map<id,id> mapCaseidFinanCialConselor=new  Map<id,id>();
        Id LoggedinUserId=userinfo.getUserId();
        string NursePractitionerRoleName = CH_StaticComponentHelperClass.NursePractitionerRoleName+'%';
        for (caseTeamMember ctm :[select parentid,
                                         MemberId ,
                                         TeamRole.name 
                                         FROM CaseTeamMember 
                                         WHERE parentid IN :ListOfCaseIds AND TeamRole.name Like :NursePractitionerRoleName
                                         and  memberId =: LoggedinUserId  
                                         ]){
              mapCaseidFinanCialConselor.put(ctm.parentID,ctm.memberId);
         }
         for (case caseRecord:CaseList) {
            if(mapCaseidFinanCialConselor.get(caseRecord.id)!=Null && (LoggedinUserId == mapCaseidFinanCialConselor.get(caseRecord.id) )){
                caseRecord.FkStatus__c =  stageStatusMap.get(CaseRecord.Clinical_Status__c).ID;
                caseRecord.CC_Appointment_Date__c=null;
            }
            else{
                if(LoggedinUserId == caseRecord.ownerid ){
                     caseRecord.FkStatus__c =  stageStatusMap.get(CaseRecord.Clinical_Status__c).ID;
                     caseRecord.CC_Appointment_Date__c=null;
                }
                else{
                     caseRecord.addError(system.label.CH_UpdateStage_PermissionIssue);
                }
            
            }
        } 
    } 
}
//END OF CLASS