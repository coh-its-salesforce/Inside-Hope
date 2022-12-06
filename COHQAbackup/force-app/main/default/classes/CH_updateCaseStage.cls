/*************************************************************************

*  Name           :  CH_updateCaseStage
*  Created By     :   Persistent System Ltd
*  Created Date   :   Jan 30, 2015 
*  Description    :   This class sends  is called when the button are invoked Denied care
                      and Start survivorship and it updates the status accordingly.

**************************************************************************/


global class CH_updateCaseStage{


    /* when Start survivorship button  button is clicked from the case page layout 
    then this method  gets executed 
    param : caseid 
    return type: string message */
    WebService static string UpdateCaseToSurvivorship(string caseid) {
        string Returnmessage;
        Id LoggedinUserId=userinfo.getUserId();
        map <id,caseteammember> mapOfCaseTeamActors= new map<id,caseteammember>();
        for (  caseteammember  ctm : [select id ,Member.name,
                                                                     TeamRole.name,
                                                                     ParentId,
                                                                     memberid,
                                                                     member.email
                                                                     from caseteammember 
                                                                     where ParentId = : caseid]) {
            if( ctm != null ) {
                mapOfCaseTeamActors.put(ctm.memberid ,ctm);
            }
        }
      
        list<Case> lstOfCurrentCase=  [select id,FkStatus__c,stage__c, Owner_Role__c,status__c  from case where id =: caseid limit 1];
        if(lstOfCurrentCase != null && lstOfCurrentCase.size()>0) {
            /* checking if the stage is Solid Tumor End of Life then it will execute 
       The below logic */
     
           system.debug('line 40'+ mapOfCaseTeamActors );
           
                if(mapOfCaseTeamActors !=null && mapOfCaseTeamActors.size()>0) {
               
                    caseteammember  RoleName = mapOfCaseTeamActors.get(LoggedinUserId );
                       /* checking if the logged in user has the role financial counsellor, financial counsellor - manager , or case owner then only the 
                     below logic will execute*/
                  if(RoleName  != null && ( RoleName.TeamRole.name==  lstOfCurrentCase[0].Owner_Role__c  )) {
                       
                        List< Status_Stage_Master__c> LstOfPatientdeniedcareId= new list<Status_Stage_Master__c>();
                        LstOfPatientdeniedcareId= [select id ,name,Is_Status_Only__c from Status_Stage_Master__c  where name =: CH_StaticComponentHelperClass.StageSolidTumorsurvivorship 
                                                   and Is_Status_Only__c=true    limit 1];
                        List< Status_Stage_Master__c> LstOfsatusId= new list<Status_Stage_Master__c>();
                         LstOfsatusId= [select id ,name,Is_Status_Only__c from Status_Stage_Master__c  where name =: CH_StaticComponentHelperClass.StageSolidTumorsurvivorship 
                                                   and Is_Status_Only__c=false    limit 1];                              
                       
                         if(LstOfPatientdeniedcareId != null &&LstOfsatusId !=null && LstOfPatientdeniedcareId.size()>0 && LstOfsatusId.size()>0) {
                            lstOfCurrentCase[0].FkStatus__c=  LstOfPatientdeniedcareId[0].id;
                            lstOfCurrentCase[0].FkStage__c=  LstOfsatusId[0].id;
                            try {
                                /* if master records are founud  then updating the status to ReferredtoHOSPICE */
                                Database.SaveResult[] srList=Database.update(lstOfCurrentCase, false);
                                for (Database.SaveResult sr : srList) {
                                    if (sr.isSuccess()) {
                                        Returnmessage = system.label.CH_UpdateStage_Success;
                                    }
                                }
                            }
                            catch (Exception e) {
                                system.debug('**********Exception e *********'+ e.getmessage());
                            }
                        }
                    } else
                     Returnmessage = system.label.CH_UpdateStage_PermissionIssue;
                }
           
        } else {
            Returnmessage = system.label.CH_Sucess;
        }
        return Returnmessage;
    }
    
  
    
    
}