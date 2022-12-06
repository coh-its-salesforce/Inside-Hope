@isTest
public class HighMedRiskNotifcationCtrlTest {
    
    @isTest
    static void test1(){
        Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name ='System Administrator'];
        user manager = createUser('test', 'manager', '999999', userInfo.getUserId(), adminProfile);
        
        
        user employeerec = createUser('test', 'employee', '999998', manager.Id, adminProfile);
        system.runAs(employeerec){
            Employee emp1 = createEmployee(manager, null);
            Employee emp2 = createEmployee(employeerec, emp1.Id);
            //Account acc = createAccount();
            Case cs = createCase(null);
            crisis c = createCrisisRecord();
            EmployeeCrisisAssessment eca = new EmployeeCrisisAssessment();
            eca.EmployeeId = emp2.Id;
            eca.Case__c = cs.Id;
            eca.CrisisId = c.id;
            eca.AssessmentDate = date.today().addDays(10);
            insert eca;
            EHS_Risk_Assessment_Questionaire__c ehs =  createQuestionaire(eca.Id);
            Work_place_exposure__c data = new Work_place_exposure__c(
                EHS_Risk_Assessment_Questionaire__c  = ehs.Id,
                Employee__c=emp1.Id);
            INSERT data;
            HighMedRiskNotifcationCtrl.sendHighOrMediumRiskNotification(new List<Id>{data.Id});
        }
    }
    
    private static Crisis createCrisisRecord(){
        Crisis cs = new Crisis();
        cs.Name = 'Covid-19';
        cs.StartDate = date.today().addDays(-10);
        cs.CrisisType  = 'Pandemic';
        insert cs;
        return cs;
    }
    
    private static EHS_Risk_Assessment_Questionaire__c createQuestionaire(id parentId){
        EHS_Risk_Assessment_Questionaire__c ehs = new EHS_Risk_Assessment_Questionaire__c();
        ehs.Employee_Crisis_Assessment__c = parentId;
        insert ehs;
        return ehs;
    }
    
    private static Account createAccount(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Account account = new Account();
        account.RecordTypeId = AccountRecordTypeInfo.get('New Patient Services').getRecordTypeId();
        account.Type = 'Press';
        account.FirstName = 'Test FirstName';
        account.LastNAme = 'Test LastName';
        account.COH_MRN__c = 'MRN-001';
        account.Gender__pc = 'Male';
        account.Preferred_Language__pc = 'English';
        account.Patient_Status__c = 'New';
        account.Marketing_Source__c = 'PRINT';
        insert account;
        return account;
    }
    
    private static Case createCase(Id accountId){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();  
        Case cse = new Case();
        cse.RecordTypeId = CaseRecordTypeInfo.get('EHS Contact Trace').getRecordTypeId();
        cse.accountid = accountId;
        cse.Origin = 'Phone';
        cse.Status = 'New';      
        cse.Type= 'Letters';   
        insert cse;
        return cse;
    }
    
    private static Employee createEmployee(user u, Id parentId){
        Individual ind = new Individual();
        ind.FirstName = u.FirstName;
        ind.LastName = u.LastName;
        ind.BirthDate = date.today().addYears(-35);
        insert ind;
        Employee emp = new Employee();
        emp.FirstName = u.FirstName;
        emp.LastName = u.LastName;
        emp.Email = u.Email;
        emp.IndividualId = ind.Id;
        emp.EmployeeNumber = u.EmployeeNumber;
        emp.WorkerType = 'Employee';
        emp.StatusAsOf = system.now();
        emp.EmployeeStatus = 'Active';
        emp.ManagerId = parentId;
        insert emp;
        return emp;
    }
    
    private static user createUser(string fName, String lName, string employeeId, Id ManagerId, profile p){
        User testMgr = new User(Alias = 'tdusr',
                           Email = fName+ '.'+lName+'test123@coh.org',
                           EmailEncodingKey = 'UTF-8',
                           LastName = lName,
                           Firstname =fName,
                           LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US',
                           ProfileId = p.id, 
                           VIA_Nominator_Total_Amount__c = 100,                            
                           TimezoneSidKey = 'America/Los_Angeles',                             
                           UserName =  fName+ '.'+lName+'test123@coh.org',
                           Mgr__c = ManagerId,
                           title = 'Testtitle',
                           isActive = true,
                           EmployeeNumber = employeeId,   
                           Per_Status__c = 'E');
        insert testMgr;
        return testMgr;
    }
}