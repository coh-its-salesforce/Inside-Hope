trigger CH_PaitentIntakeTrigger on Account (before update,after Update) {
    
    List<Case> caseToBeUpdatedList = new List<Case>();
    List<Case> caseToBeInsertedList = new List<Case>();
    
    Set<Id> accountIdSet = new Set<Id>();
    Set<Id> accountIdSetToCreateCase = new Set<Id>();
    map<id,case> mapOfAccountIdAndCase= new map<id,case>();
    
    Set<String> dignosisSet = new Set<String>();
    Map<String,Disease_Master__c> diseaseGroupVSNameMap = new Map<String,Disease_Master__c>();
    Map<String,Disease_Master__c> diseaseNameMap = new Map<String,Disease_Master__c>();
    
    RecordType npsRT = [Select id from RecordType where sobjectType = 'Account' and Name = 'New Patient Services'];
    RecordType cohRT = [Select id from RecordType where sobjectType = 'Case' and Name = 'Care Coordination'];
    Boolean disableAutomation;
    
    try {
        disableAutomation = [SELECT Disable_Automation__c FROM User WHERE id=:UserInfo.getUserId()].Disable_Automation__c;
    }
    catch (Exception e) {
        disableAutomation = false;
    }
    if (!disableAutomation) {
        //Code to be executed before update of account 
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Account acc : trigger.new){
                Account oldAcc = trigger.oldmap.get(acc.Id);
                if(acc.RecordTypeId == npsRT.Id && acc.First_Appointment_Scheduled__c == true){
                    accountIdSet.add(acc.Id);
                    if(acc.SVC_Diagnosis__c != null && acc.SVC_Diagnosis__c.contains('-')){
                        String diagnosis = acc.SVC_Diagnosis__c.split('-')[1];
                        dignosisSet.add(diagnosis);
                        dignosisSet.add(acc.SVC_Diagnosis__c);
                    }
                    acc.First_Appointment_Scheduled__c = false;
                }
            }
            
            /* Quering all the  open case for care cordination record type with matched account id */
            if(accountIdSet != null && accountIdSet.size()>0){
                for(case caserecord : [select id,CC_Disease__c,accountid,account.SVC_Diagnosis__c ,account.CC_Appointment_Date__c,
                                       CC_Appointment_Date__c 
                                       from case where  recordtype.name='Care Coordination' and status='Open'
                                       and  accountid  in : accountIdSet]){
                                           mapOfAccountIdAndCase.put(caserecord.accountid,caserecord);          
                                           
                                       }
                
                /**querying all the disease master records with account svc diagonisis field value **/
                for(Disease_Master__c diseaseMasater : [Select Disease_Group_Name__c,Name,Disease_Group_Full_Name__c, Disease_Group_and_Name_Combination__c
                                                        from Disease_Master__c 
                                                        where Disease_Group_Full_Name__c IN : dignosisSet 
                                                        OR Disease_Group_and_Name_Combination__c IN : dignosisSet]){
                                                            diseaseGroupVSNameMap.put(diseaseMasater.Disease_Group_and_Name_Combination__c,diseaseMasater);
                                                            if(!diseaseNameMap.containsKey(diseaseMasater.Disease_Group_Full_Name__c)){
                                                                diseaseNameMap.put(diseaseMasater.Disease_Group_Full_Name__c,diseaseMasater);
                                                            }
                                                        }
                
                for( id accId : accountIdSet){
                    case cseRecord= mapOfAccountIdAndCase.get(accId); 
                    if(cseRecord !=null){
                        Account acc = Trigger.newMap.get(accid);
                        String diagnosis = String.valueOf(cseRecord.account.SVC_Diagnosis__c);
                        if((diseaseGroupVSNameMap != null && diseaseGroupVSNameMap.get(diagnosis) != null
                            && cseRecord.CC_Disease__c == diseaseGroupVSNameMap.get(diagnosis).Name) || 
                           (diseaseNameMap != null && diseaseNameMap.get(diagnosis.split('-')[1]) != null 
                            &&  cseRecord.CC_Disease__c == diseaseNameMap.get(diagnosis.split('-')[1]).Name)){
                                //if disease is same, check if the appointment has changed. If yes then update the case
                                if(cseRecord.account.CC_Appointment_Date__c != null && 
                                   cseRecord.CC_Appointment_Date__c != acc.CC_Appointment_Date__c){
                                       cseRecord.CC_Appointment_Date__c = acc.CC_Appointment_Date__c;
                                       caseToBeUpdatedList.add(cseRecord);
                                   }
                            }
                        else{
                            accountIdSetToCreateCase.add(accId);
                        }
                    } 
                    else{
                        accountIdSetToCreateCase.add(accId);
                    }
                }
                
                if(accountIdSetToCreateCase != null && accountIdSetToCreateCase.size()>0){
                    Set<Id> npsAccountIdSet = new Set<Id>();
                    String query = 'Select '; 
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Case.fields.getMap();
                    for(String casefield : fldObjMap.keyset()){
                        query += ' ' + casefield + ',';
                    }
                    query = query.substring(0,query.length() -1);
                    query += ' from Case where  AccountId IN :accountIdSetToCreateCase  and RecordType.Name = \'New Patient Services\' '; 
                    query += ' Order by lastmodifieddate DESC ';
                    
                    for(Case cs :Database.query(query)){
                        if(!npsAccountIdSet.contains(cs.AccountId)){
                            Case cloneCase = cs.clone(false,false);
                            cloneCase.RecordTypeId = cohRT.Id;
                            cloneCase.Status='Open';
                            cloneCase.ownerid=userinfo.getUserId();
                            caseToBeInsertedList.add(cloneCase);
                            npsAccountIdSet.add(cs.AccountId);
                        }
                    }
                    
                    if(caseToBeInsertedList!= null && caseToBeInsertedList.size()>0){
                        // Quering all old care coordinator type case records to update status to close before cloning case from NPS
                        List<Case> oldCasesUpdate = new List<Case>();
                        for(Case oldcs: [select id,Status from Case where RecordTypeId =: cohRT.id and Status != 'Closed' and AccountId In : accountIdSetToCreateCase]){
                            oldcs.Status = 'Closed';
                            oldCasesUpdate.add(oldcs);
                        }
                        if(oldCasesUpdate!= null && oldCasesUpdate.size()>0){   
                            Update oldCasesUpdate;
                        }
                        
                        // Updated the cases above
                        insert caseToBeInsertedList;
                        
                        //Get the stage and status ID for Patient Intake
                        Id stageId = null;
                        Id statusId = null;
                        for(Status_Stage_Master__c statusMaster : [Select id,Name from Status_Stage_Master__c where Name IN ('Patient Intake','Appointment Created')]){
                            if(statusMaster.Name  == 'Patient Intake'){
                                stageId = statusMaster.Id;
                            }else if(statusMaster.Name  == 'Appointment Created'){
                                statusId = statusMaster.Id;
                            }
                        }
                        
                        //Update the case with stage, status, disease, physician and appointment date
                        for(Case cs : caseToBeInsertedList){
                            cs.FkStatus__c = statusId;
                            cs.FkStage__c = stageId;
                            Account newAcc = Trigger.newMap.get(cs.Accountid);
                            if(newAcc != null && newAcc.CC_AllScripts_Disease__c !=null){
                                cs.CC_AllScripts_Disease__c = newAcc.CC_AllScripts_Disease__c;
                            }
                            if(newAcc != null && newAcc.CC_Appointment_Date__c !=null){
                                cs.CC_Appointment_Date__c= newAcc.CC_Appointment_Date__c;
                            }
                            if(newAcc != null && newAcc.CC_AllScripts_Physician__c !=null){
                                cs.CC_AllScripts_Physician__c= newAcc.CC_AllScripts_Physician__c;
                            }
                            if(newAcc != null && newAcc.SVC_Diagnosis__c !=null){
                                if(newAcc.SVC_Diagnosis__c.contains('-')){
                                    cs.CC_Diagnosis__c = newAcc.SVC_Diagnosis__c;
                                    String diagnosis = String.valueOf(newAcc.SVC_Diagnosis__c);
                                    if(diseaseGroupVSNameMap != null && diseaseGroupVSNameMap.get(diagnosis) != null){ 
                                        cs.CC_Disease__c = diseaseGroupVSNameMap.get(diagnosis).Name;
                                    }else if(diseaseNameMap != null && diseaseNameMap.get(diagnosis.split('-')[1]) != null){
                                        cs.CC_Disease__c = diseaseNameMap.get(diagnosis.split('-')[1]).Name;
                                    }
                                }
                            }
                            caseToBeUpdatedList.add(cs);
                        }
                    }
                }
                if(caseToBeUpdatedList!=null && caseToBeUpdatedList.size()>0){
                    try{
                        update caseToBeUpdatedList;
                    }
                    catch(Exception e){
                        system.debug('*****Exception*******'+ e.getmessage());
                    }
                }
            }
        }
    }
}