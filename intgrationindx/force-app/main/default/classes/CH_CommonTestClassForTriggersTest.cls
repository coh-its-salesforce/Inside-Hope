@isTest
private class CH_CommonTestClassForTriggersTest{ static testMethod void UpdateCaseStatus() {
 /*HelpingHandsGoals__c temp= COH_Test_SampleData.createChecklistandrelatedTask();
 temp.status__c='Completed';
 temp.No_of_Completed_Tasks__c=3;
 update temp;*/
 
 }
static testMethod void UpdateChecklistOnTaskCompleted() {
/*
 Task createtask= COH_Test_SampleData.createTask();
 createtask.status='Completed';
 update createtask;*/
 
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserTest2@coh.org', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTest2@coh.org'); 
     
  Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
     Status_Stage_Master__c temp = new Status_Stage_Master__c();
    temp.Name ='Patient Intake - First Appointment';
    temp.Is_Status_Only__c = false;
    insert temp;
    Status_Stage_Master__c temps = new Status_Stage_Master__c();
    temps.Name = 'MD Appointed';
    temps.Is_Status_Only__c = true;
    insert temps;
    Account account = new Account();
    account.FirstName = 'Test NPS';
    account.LastName = 'Account';
    account.SVC_Diagnosis__c = 'HEM';
   // account.AccountNumber = '0012'+index;
    account.RecordTypeId = AccountRecordTypeInfo.get('New Patient Services').getRecordTypeId();
    account.Type = 'Other';
    account.Physician_Identified__c=true;
    account.First_Appointment_Scheduled__c=true;
    account.Disease_Identified__c=true;
   account.CC_Appointment_Date__c=date.today();
    insert account;
     Case cse = new Case();
    if(account != null){
        cse.accountid = account.id;
       
    }
    cse.Origin = 'Phone';
    cse.Status = 'New';     
    cse.Type= 'Letters';
    cse.CC_Appointment_Date__c = date.today();
    cse.Caregiver_status__c = 'Caregiver not found';  
      
    Schema.DescribeSObjectResult cfrSchemaC = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchemaC.getRecordTypeInfosByName();
    cse.RecordTypeId = CaseRecordTypeInfo.get('New Patient Services').getRecordTypeId();
    
    insert cse;
     Health_Goal__c tempv= new Health_Goal__c();        
        tempv.Status__c ='Open';
        tempv.case__c=cse.id;
        tempv.No_of_Completed_Tasks__c = 1;  
        tempv.Total_No_of_Tasks__c=3;
        tempv.Created_Stage__c = 'Patient Intake - First Appointment';
        tempv.Created_Status__c = 'MD Appointed';
        
        insert tempv;
        
        Disease_Master__c Dms = new Disease_Master__c();
        Dms.Name ='Other';
        Dms.Disease_Group_Name__c ='HEM';
        insert Dms;
    account.AccountNumber = '0012';
    account.CC_Appointment_Date__c=date.today()+1;
    update account;
    System.runAs(u) {
    cse.CC_Appointment_Date__c = date.today()+1; 
    cse.FkStage__c= temp.id;  
    cse.FkStatus__c= temps.id;  
    update cse;
    }
         
  }
 
 
 
 
}