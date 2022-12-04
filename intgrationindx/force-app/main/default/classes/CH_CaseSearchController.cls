public class CH_CaseSearchController {
    
    //String entered to search the list of accounts
    public String searchString{get;set;}
    
    public id caseid{get;set;}
    
    public id accountId {get;set;}
    public Integer totalRecords {get;set;}
    
    //Set the standard set controller
    public ApexPages.StandardSetController con {get;set;}
    
    private List<String> serachStringList;
    
    public CH_CaseSearchController(){
        //set the standard set controller to 
        setAccountList();
    }
    
    // Initialize setCon and return a list of records
    public List<Account> getAccounts() {
        return (List<Account>) con.getRecords();
    }
     
     
     public void setAccountList(){
        List<Account> accList = new List<Account>();
        
        for(Account acc : Database.query(createSearchQueryString())){
            if(acc.cases != null && 
                    ((acc.cases.size() > 0 && acc.cases[0].ownerId != Userinfo.getUserId()) || acc.cases.size() == 0)){
                        accList.add(acc);
            }
        }
        
        con = new ApexPages.StandardSetController(accList);
        con.setPageSize(10);
        totalRecords = Integer.valueOf(Math.ceil(con.getResultSize()/10.0));
     }
     
     private String createSearchQueryString(){
         serachStringList = new List<String>();
        String searchQuery = 'SELECT Id, Name , Owner.Name , ' ;
        String caseQuery =  '(select id,ownerId from cases where RecordType.name = \'Care Coordination\' ' +
                                'and Status != \'closed\' and Inactive__c = false order by createddate ) ';
        searchQuery += caseQuery + ' FROM Account where (recordtype.name = \'New Patient Services\' or recordtype.name = \'Patients\') ';
        
        
        if(searchString != null && searchString != ''){
            searchString = searchString.trim();
            if(searchString.contains(' ')){
                for(String s : searchString.split(' ')){
                    serachStringList.add('%' + s + '%');
                }
            }else{
                serachStringList.add('%' + searchString + '%');
            }
            searchQuery += ' and (firstname like :serachStringList or lastname like :serachStringList)';
        }
        searchQuery += ' order by createddate desc,name asc limit 1000';
        return searchQuery;
     }
    
    /* This method is called when the user Clicks on the  Create case  button
    of the Unmatched records of cases cases where the user is  not the owner  and creates a case of
    care coordination recordtype and assigns logged in user as owner of the record .Once the
    Case is created then it creates a record for case team member for oncc and assigns the logged in user
    to the oncc in the case team member record then it updates the case to stage as patient intake and status as
    Appoinment created.
    
    param : none
    
    */
    public void CreateCase(){
        Savepoint sp;
        if(accountId != null){
            
            //Fetch list of other CC cases for the account selected. If any case alreaday exists, do not create a new one.
            List<Case> otherCCList = [select id,Owner.Name from Case where 
                                    accountId =: accountId and RecordType.Name = 'Care Coordination' 
                                    and  Status != 'Closed' and Inactive__c = false];
            if(otherCCList == null || (otherCCList != null && otherCCList.size() == 0)){
                try{
                    //Setting the save point
                    sp = Database.setSavepoint();
                
                    List<Case> caseToBeInsertedList = new List<Case>();
                    List<RecordType> cohRT = [Select id from RecordType where sobjectType = 'Case' and Name = 'Care Coordination'];
                    List<Account> accList = [select CC_AllScripts_Disease__c,CC_Appointment_Date__c,CC_AllScripts_Physician__c,
                                            SVC_Diagnosis__c
                                             from Account where id =:accountId];
                    
                    //Fetch the disease details from account                         
                    Set<String> dignosisSet = new Set<String>();
                    Map<String,Disease_Master__c> diseaseGroupVSNameMap = new Map<String,Disease_Master__c>();
                    Map<String,Disease_Master__c> diseaseNameMap = new Map<String,Disease_Master__c>();
                    if(accList[0].SVC_Diagnosis__c != null && accList[0].SVC_Diagnosis__c.contains('-')){
                        String diagnosis = accList[0].SVC_Diagnosis__c.split('-')[1];
                        dignosisSet.add(diagnosis);
                        dignosisSet.add(accList[0].SVC_Diagnosis__c);
                    }
                    
                    /**querying all the disease master records with account svc diagonisis field value **/
                    for(Disease_Master__c diseaseMasater : [Select Disease_Group_Name__c,Name,Disease_Group_Full_Name__c, 
                                                                Disease_Group_and_Name_Combination__c
                                                                 from Disease_Master__c 
                                                                where Disease_Group_Full_Name__c IN :dignosisSet 
                                                                OR Disease_Group_and_Name_Combination__c IN : dignosisSet]){
                            diseaseGroupVSNameMap.put(diseaseMasater.Disease_Group_and_Name_Combination__c,diseaseMasater);
                            if(!diseaseNameMap.containsKey(diseaseMasater.Disease_Group_Full_Name__c)){
                                diseaseNameMap.put(diseaseMasater.Disease_Group_Full_Name__c,diseaseMasater);
                            }
                    }
                    
                    //Clone NPS case and populate the required details from Account record
                    String query = 'Select '; 
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Case.fields.getMap();
                    for(String casefield : fldObjMap.keyset()){
                        query += ' ' + casefield + ',';
                    }
                    query = query.substring(0,query.length() -1);
                    query += ' from Case where  AccountId =: accountId  and '+
                                'RecordType.Name = \'New Patient Services\' and status != \'Closed\' '; 
                    query += ' Order by lastmodifieddate DESC ';
                   
                    for(Case cs :Database.query(query)){
                        Case cloneCase = cs.clone(false,false);
                        cloneCase.RecordTypeId = cohRT[0].Id;
                        cloneCase.Status = 'Open';
                        cloneCase.Inactive__c = false;
                        cloneCase.ownerid = userinfo.getUserId();
                        cloneCase.CC_AllScripts_Disease__c = accList[0].CC_AllScripts_Disease__c;
                        cloneCase.CC_Appointment_Date__c = accList[0].CC_Appointment_Date__c;
                        cloneCase.CC_AllScripts_Physician__c = accList[0].CC_AllScripts_Physician__c;
                        if(accList[0].SVC_Diagnosis__c !=null && accList[0].SVC_Diagnosis__c.contains('-')){
                            cloneCase.CC_Diagnosis__c = accList[0].SVC_Diagnosis__c;
                            String diagnosis = String.valueOf(accList[0].SVC_Diagnosis__c);
                            if(diseaseGroupVSNameMap != null && diseaseGroupVSNameMap.get(diagnosis) != null){ 
                                cloneCase.CC_Disease__c = diseaseGroupVSNameMap.get(diagnosis).Name;
                            }else if(diseaseNameMap != null && diagnosis.contains('-') && 
                                diseaseNameMap.get(diagnosis.split('-')[1]) != null){
                                    cloneCase.CC_Disease__c = diseaseNameMap.get(diagnosis.split('-')[1]).Name;
                            }
                        }
                        caseToBeInsertedList.add(cloneCase);
                    }
                                
                    if(caseToBeInsertedList != null && caseToBeInsertedList.size() > 0){
                        //insert a new CC case
                        insert caseToBeInsertedList;
                        
                        //Add logged in user to the case team as ONCC           
                        List<caseTeamRole>  ONCCRole = [ select id,Name from CaseTeamRole where name='ONCC'];
                        if(ONCCRole != null && ONCCRole.size() > 0){
                            CaseTeamMember ctmRecord= new CaseTeamMember();
                            ctmRecord.MemberId = Userinfo.getUserId();
                            ctmRecord.parentid = caseToBeInsertedList[0].Id;
                            ctmRecord.TeamRoleId = ONCCRole[0].id;
                            insert ctmRecord;
                        }
                        
                        //Get the stage and status ID for Patient Intake and set it in the case record
                        Id stageId = null;
                        Id statusId = null;
                        for(Status_Stage_Master__c statusMaster : [Select id,Name from Status_Stage_Master__c 
                                                                    where Name IN ('Patient Intake','Appointment Created')]){
                            if(statusMaster.Name  == 'Patient Intake'){
                                stageId = statusMaster.Id;
                            }else if(statusMaster.Name  == 'Appointment Created'){
                                statusId = statusMaster.Id;
                            }
                        }
                        caseToBeInsertedList[0].FKStage__c = stageId;
                        caseToBeInsertedList[0].FKStatus__c = statusId;
                        update caseToBeInsertedList;
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                'Care Coordination case has been assigned to you. '+
                                                'Click here to go to the case details : '+
                                                '<a href="/'+caseToBeInsertedList[0].Id+'">Click Here</a>'));
                    }else{
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Care Coordination case did not got created '+
                                                                                            'as there does not exist any NPS case.'));
                    }
                }catch(Exception e){ 
                    //rollback all the transaction sinsteadaa of failure
                    Database.rollback(sp);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                }
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Care Coorination Case for the account, '+
                                            'already exists which has been assigned to : <b>' + otherCCList[0].Owner.Name + 
                                            '</b>. Please contact your administrator for furthur details.'));
            }
            setAccountList();
        } 
    }
    
    
    /*******    PAGINATION METHODS **********/
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
}