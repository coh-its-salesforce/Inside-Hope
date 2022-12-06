@isTest(SeeAllData=false)
/**
 * @Description Class COH_Test_SampleData 
 * Used for Creating sample data 
 * @Author : Satish Tale
 */
 public class CH_Test_SampleData{
   
   
    //Create User record
      public static User createUserRecord(Integer index, String profileName){
        Profile profile = [ Select  Id 
                            From    Profile 
                            Where   Name = :profileName 
                            limit   1 ];
            
        User user=new User( Alias = 'User ' + index, 
                             Email               = 'standarduser3454@testorg.coh.org',
                             FirstName           = 'User' + index,
                             LastName            = 'Testing ' + index, 
                             ProfileId           = profile.Id, 
                            
                             UserName            = 'user@unittest'+Index+'.com',
                             languagelocalekey='en_US', 
                             localesidkey='en_US',
                             emailencodingkey='UTF-8',
                             timezonesidkey='America/Los_Angeles',
                             isactive = true,
                             CC_Receive_Checklist_Completion_Emails__c= true,
                             CC_Receive_Assingment_Emails__c=true,
                             CC_Receive_Checklist_Assignment_Email__c=true
                                );
        insert User;  
        return user;
        
    }
    
      public static User createUserRecord(Integer index, String profileName,string roleName){
        
        Profile profile = [ Select  Id 
                            From    Profile 
                            Where   Name = :profileName 
                            limit   1 ];
                            
        UserRole userRole = [ Select  Id,Name
                            From    UserRole 
                            Where   Name = :roleName 
                            limit   1 ];
          
          system.debug('userRole'+userRole);
                                      
        User user=new User( Alias = 'User ' + index, 
                             Email               = 'standarduser344@testorg.coh.org',
                             FirstName           = 'User' + index,
                             LastName            = 'Testing ' + index, 
                             ProfileId           = profile.Id, 
                            
                             UserName            = 'user@unittest'+Index+'.com',
                             languagelocalekey='en_US', 
                             localesidkey='en_US',
                             emailencodingkey='UTF-8',
                             timezonesidkey='America/Los_Angeles',
                             UserRole = userRole,
                             isactive = true  
                             
                                                      
                                );
        insert User;  
        return user;
        
    }
    
        
    public static List<User> createUserRecordsInBulk(Integer startIndex, Integer numberOfRecords, String profileName){
        Profile profile = [ Select  Id 
                            From    Profile 
                            Where   Name = :profileName 
                            limit   1 ];
        List<User> userList = new List<User>();
        for(Integer i = startIndex ; i <=numberOfRecords; i++)  {                 
                User user=new User( Alias = 'User ' + i, 
                             Email               = 'standarduser3454@testorg.coh.org',
                             FirstName           = 'User' + i,
                             LastName            = 'Testing ' + i, 
                             ProfileId           = profile.Id, 
                            
                             UserName            = 'user@unittest'+i+'.com',
                             languagelocalekey='en_US', 
                             localesidkey='en_US',
                             emailencodingkey='UTF-8',
                             timezonesidkey='America/Los_Angeles',
                             isactive = true
                                );
            userList.add(user);
        }
        insert userList;
        return userList;
                            
    }
  
  public static Account createBusinessAccounts(Integer index){
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
    Account account = new Account();
    account.Name = 'Test Business Account'+index;
    account.AccountNumber = '0012'+index;
    account.RecordTypeId = AccountRecordTypeInfo.get('Business Accounts').getRecordTypeId();
    account.Type = 'Other';
    
    insert account;
    
    return account;
  }
  
   
  public static Account createCOHBusinessAccounts(Integer index){
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
    Account account = new Account();
    account.Name = 'Test COH Business Account'+index;
    account.AccountNumber = '0022'+index;
    account.RecordTypeId = AccountRecordTypeInfo.get('COH Business Accounts').getRecordTypeId();
    //account.Type = 'Press';
    
    insert account;
    
    return account;
  }
  
   
  public static Account createFoundationAccounts(Integer index){
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
    Account account = new Account();
    try{
        //account.Name = 'Sample Test Foundation Account'+index;
        account.AccountNumber = '0022'+index;
        account.RecordTypeId = AccountRecordTypeInfo.get('Foundation').getRecordTypeId();
        account.Type = 'Press';
        account.FirstName = 'Test FirstName'+index;
        account.LastNAme = 'Test LastName'+index;
        account.COH_MRN__c = 'MRN-'+index;
        account.Gender__pc = 'Male';
        account.Preferred_Language__pc = 'English';
        insert account;
        
    }catch(exception ex){
        system.debug(ex.getmessage());
    }
    
  
    
    return account;
  }
  
   
  public static Account createNewPatientAccounts(Integer index){
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
    Account account = new Account();
    account.RecordTypeId = AccountRecordTypeInfo.get('New Patient Services').getRecordTypeId();
    account.Type = 'Press';
    account.FirstName = 'Test FirstName'+index;
    account.LastNAme = 'Test LastName'+index;
    account.COH_MRN__c = 'MRN-'+index;
    account.Gender__pc = 'Male';
    account.Preferred_Language__pc = 'English';
    account.Patient_Status__c = 'New';
    account.Marketing_Source__c = 'PRINT';
    
    insert account;
    
    return account;
  }
  
  public static Contact createContact(Integer index, Account account){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
        Contact contact = new Contact();
        contact.FirstName='lastName' + index;
        contact.LastName='lastName' + index;
        contact.RecordTypeId = conRecordTypeInfo.get('Contacts').getRecordTypeId();
        if(account!= null){
            contact.accountid = account.id;
        }
        insert contact;
        
        return contact;
   } 
 
 
  public static Contact createRecruitmentContact(Integer index, Account account){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    
        Contact contact = new Contact();
        contact.FirstName='lastName' + index;
        contact.LastName='lastName' + index;
        contact.RecordTypeId = conRecordTypeInfo.get('Physician Recruitment').getRecordTypeId();
        if(account != null){
            contact.accountid = account.id;
        }
        insert contact;
         
        return contact;
   } 
 
 
 
 
  public static Contact createCOHContact(Integer index, Account account){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Contact contact = new Contact();
        contact.FirstName='lastName' + index;
        contact.LastName='lastName' + index;
        contact.RecordTypeId = conRecordTypeInfo.get('COH Contacts').getRecordTypeId();
        if(account != null){
            contact.accountid = account.id;
        }
        contact.Type__c = 'Other';
        contact.Division__c = 'Other';
        contact.Email = 'test@coh.com';
        
        insert contact;
         
        return contact;
   } 
   
   
  public static Contact createReferringPhysiciansContact(Integer index, Account account){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Contact contact = new Contact();
        contact.FirstName='lastName' + index;
        contact.LastName='lastName' + index;
        contact.RecordTypeId = conRecordTypeInfo.get('Referring Physicians').getRecordTypeId();
        if(account != null){
            contact.accountid = account.id;
        }
        insert contact;
        return contact;
   } 
 
 
 
  public static Case createCase(Integer index, Account account){
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();  
    Case cse = new Case();
    cse.RecordTypeId = CaseRecordTypeInfo.get('Care Coordination').getRecordTypeId();
    if(account != null){
        cse.accountid = account.id;
        system.debug('Account in case'+ account);
    }
    cse.Origin = 'Phone';
    cse.Status = 'New';      




    cse.Type= 'Letters';   
    insert cse;
    return cse;
  }
  
  //Create case timeline 
  public static case_timelines__c createCasetime(String Stage, Case cse){
    case_timelines__c caseTime = new case_timelines__c();
    caseTime.Case__c = cse.id;
    caseTime.Name = stage;
    
    insert caseTime;
    
    return caseTime;
  }
  
  //Create Alert Matrix Master 
  public static Alert_Master__c createAlertMatrix(String stage, String alertType, String status){
    
    Status_Stage_Master__c tempStage = CreateStage(stage);
    Status_Stage_Master__c tempStatus = CreateStatus(status); 
  
 
    Alert_Master__c alerrtMatrix = new Alert_Master__c();
    alerrtMatrix.Alert_Type__c = alertType; 
    alerrtMatrix.Status_Master__c= tempStatus.id;
    alerrtMatrix.Stage_Master__c =  tempStage.id;
   
    
    insert alerrtMatrix;
    
    return alerrtMatrix;
  }
  
  //*Create Alert detail 
  public static Alert_Detail__c createAlertDetial(Alert_Master__c matrix, Checklist__c checklist, Checklist_Tasks__c checklistTasks,string assignTo){
  
    Alert_Detail__c alertDetail = new Alert_Detail__c();
    alertDetail.Checklist__c = checklist.id;
    alertDetail.Checklist_Tasks__c = checklistTasks.id;
    alertDetail.Description__c = 'Test Description';
    alertDetail.Alert_Master__c = matrix.id;
    alertDetail.Task_Name__c = 'Test Task Name';
    alertDetail.Templates__c = 'Care_Coordinator_Email';
    
    Role_Master__c role = new Role_Master__c();
    role.Name = assignTo;
    insert role;
    
    alertDetail.Assign_to_role__c = role.id;   
    
    insert alertDetail;
    
    return alertDetail;
  }
  //Create Checklist /
  public static Checklist__c createChecklist(Integer index){
    Checklist__c checklist = new Checklist__c();
    
    checklist.Checklist_Description__c = 'Checklist Description';
    checklist.Days__c = 3;
    checklist.Stage__c = 'Patient Intake';
    checklist.Name = 'Patient Intake – Care Coordinator Checklist'+index;
    
    insert checklist; 
    
    return checklist;
  }
  
  //Create Checklist
  public static Checklist_Tasks__c createChecklistTasks(Checklist__c checklist, Integer index){
    Checklist_Tasks__c checklistTasks = new Checklist_Tasks__c();
    
    checklistTasks.Checklist__c = checklist.id;
    checklistTasks.Name = 'Interact with patient'+index;
    checklistTasks.Task_Description__c = 'Task Description';
    
    insert checklistTasks;
    
    return checklistTasks;
  }
  //Create user limit master
   public static User_Limits__c createUserLimits(User user){
   
    User_Limits__c userLimits = new User_Limits__c();
    userLimits.Case_Count_Limit__c = 15;
    userLimits.Max_Case_Limit__c = 20;
    userLimits.User__c = user.id;
    
    insert userLimits;
    
    return userLimits;
   }
       
    //Create Disease Master 
   public static Disease_Matrix__c createDiseaseMaster(User user, Contact physician,Role_Master__c Role,Disease_Master__c diseaseMaster){    
    
    Disease_Matrix__c disease = new Disease_Matrix__c();
       try{       
   
    
    if(diseaseMaster != null){
        disease.FKDisease__c = diseaseMaster.id;
    }

    //disease.Disease_type__c = 'Diabetes';
    if(physician != null){
        disease.Physician__c = physician.id;
    }
       system.debug('disease user'+user);
    if(user != null){
        disease.User__c = user.id;
    }
    if(Role!=Null)   { 
        disease.FKUser_Role__c = Role.id;
    }   
   
    insert disease;
       }catch(exception ex)
       {
           system.debug('Exception' + ex.getMessage());
       }
    return disease;
   }  















    //Create StageCase Team Matrix 
    public static Case_Stage_Team_Master__c createStageCaseTeamMatrix(string ownerName,Role_Master__c roleMaster,id stageid){
        Case_Stage_Team_Master__c stageTeamMatrix = new Case_Stage_Team_Master__c();
        
        //Status_Stage_Master__c stage = CreateStage('Frist Appointment');
        
       // stageTeamMatrix.Case_Owner_Lookup__c = roleMaster.id;
        stageTeamMatrix.Case_Team__c = ownerName;  
        stageTeamMatrix.FKStage__c = stageid;
        stageTeamMatrix.FKCase_Owner_Role__c = roleMaster.id;
        
        insert stageTeamMatrix;
    
        return stageTeamMatrix;
    }
     public static Case_Stage_Team_Master__c createStageCaseTeamMatrix(string ownerName,Role_Master__c roleMaster,id stageid,id statusid){
        Case_Stage_Team_Master__c stageTeamMatrix = new Case_Stage_Team_Master__c();
        
        //Status_Stage_Master__c stage = CreateStage('Frist Appointment');
        
       // stageTeamMatrix.Case_Owner_Lookup__c = roleMaster.id;
        stageTeamMatrix.Case_Team__c = ownerName;  
        stageTeamMatrix.FKStage__c = stageid;
        stageTeamMatrix.FKStatus__c = statusid;
        stageTeamMatrix.FKCase_Owner_Role__c = roleMaster.id;
        
        insert stageTeamMatrix;
    
        return stageTeamMatrix;
    }
    
     public static Health_Goal__c createChecklistandrelatedTask(){
        Health_Goal__c temp= new Health_Goal__c();
        
        temp.status__c='Open';
        Account acc= new Account();
        case t = createCase(1,acc);
        temp.case__c=t.id;
        temp.No_of_Completed_Tasks__c = 1;  
        temp.Total_No_of_Tasks__c=3;
        
        insert temp;
    
        return temp;
    }
    public static Task createTask(string hgId){
    Task temp = new Task();
    //Health_Goal__c getid= createChecklistandrelatedTask();
    temp .Type = 'Email';
    temp.Subject='demo';
    temp.Status='Not Started';
    temp.WhatId = hgId; //record id
    insert temp;
    return temp;
    
    }

    
    //Create Stage & Status
    public static Status_Stage_Master__c CreateStage(string stage){
        Status_Stage_Master__c temp = new Status_Stage_Master__c();
        temp.Name =stage;
        temp.Is_Status_Only__c = false;
        insert temp;
        return temp;
    }
    
    public static Status_Stage_Master__c CreateStatus(string status){
         Status_Stage_Master__c temp1 = new Status_Stage_Master__c();
        temp1.Name =status;
        temp1.Is_Status_Only__c = true;
        insert temp1; 
        return temp1; 
    
    }
    
    public static CaseTeamRole CreateCaseTeamRole(string teamRole){
        CaseTeamRole ctr = new CaseTeamRole();
        ctr.Name = teamRole;
        ctr.PreferencesVisibleInCSP = false;
        ctr.ACCESSLEVEL ='Edit';        
        return ctr;
    }
    
    
    
}