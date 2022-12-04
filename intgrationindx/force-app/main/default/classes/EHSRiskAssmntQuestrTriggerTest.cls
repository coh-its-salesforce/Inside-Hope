@isTest
public class EHSRiskAssmntQuestrTriggerTest {
    // Case constants
	private static final String CASE_ORIGIN = 'ACD';
	private static final String CASE_ACTION_TAKEN = 'EMAIL SENT';
	private static final String CASE_STATUS_NEW = 'New';
	private static final String CASE_STATUS_CLOSED = 'Closed';
	private static final String CASE_APPLICATION_TAKEN = 'APPLICATION TAKEN';
    private static final String CASE_WARM_HANDOFF_YES = 'Yes';
    private static final String APPLICATION_NAME = 'Call Center';
    private static final String DEATH_CERT_CALL_TYPE = 'Death Certificates';
    private static final String DEATH_CERT_CALL_TYPE_NEEDED = 'Yes';

    
    @isTest
    static void unitTest1(){
        Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name ='System Administrator'];
        user manager = createUser('test', 'manager', '999999', userInfo.getUserId(), adminProfile);
       
        
        user employeerec = createUser('test', 'employee', '999998', manager.Id, adminProfile);
        system.runAs(employeerec){
           test.startTest();
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
            eca.EmployeeId = emp1.Id;
            update eca;
            cs.Date_EHS_Cleared_to_Return_to_Work__c = date.today();
            update cs;
            
            EHSRiskAsmntQuestEmailController.updateNotification(ehs.Id);
            /****changes by sanjay--- Date 11/12/2020 ---- START---*/
            Apexpages.currentPage().getparameters().put('Id', eca.Id);
            Apexpages.StandardController std = new Apexpages.StandardController(eca);
            EmployeeAssessmentEmailController con = new EmployeeAssessmentEmailController(std);
            con.updateFlag();
            Apexpages.currentPage().getparameters().put('Id', null);
            std = new Apexpages.StandardController(eca);
            con = new EmployeeAssessmentEmailController(std);
            con.updateFlag();
            /****changes by sanjay--- Date 11/12/2020 ---- END---*/
            test.stopTest();
        }
    }
    
    @isTest
    static void unitTest2(){
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        Account accountObj = new Account();
        accountObj.RecordTypeId = COHUtil.getRecordType('Account', 'New Patient Services');
        accountObj.FirstName = 'TEST ACC';
        accountObj.LastName = 'LAstNAME';
        accountObj.Patient_Status__c = 'New';
        accountObj.COH_MRN__c = '1234455';
        accountObj.Status_Reason__c = 'This is a test';
        insert accountObj;
        
		//Changes added by Sanjay on 04/22/2021:START
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        COH_Round_Robin_Queue__c rrqObj = new COH_Round_Robin_Queue__c();
        rrqObj.Name = 'rrq record';
        rrqObj.Active__c = true;
        rrqObj.SObject_API_Name__c = 'Case';
        rrqObj.Queue_SF_Id__c = testGroup.Id;
        insert rrqObj;
        
        COH_Round_Robin_Queue_Member__c rrqmObj = new COH_Round_Robin_Queue_Member__c();
        rrqmObj.Active__c = true;
        rrqmObj.Round_Robin_Queue__c = rrqObj.Id;
        rrqmObj.Order__c = 1;
        rrqmObj.Last_Assigned__c = true;
        rrqmObj.User__c = UserInfo.getUserId();
        insert rrqmObj;
        //Changes added by Sanjay on 04/22/2021:END
		
        Case caseObj = new Case();
        caseObj.Origin = CASE_ORIGIN;
        caseObj.RecordTypeId = COHUtil.getRecordType('Case', 'New Patient Services');
        caseObj.Action_Taken__c = 'EMAIL SENT';
        caseObj.Status = 'New';
        caseObj.Caller_First_Name__c = 'firstName';
        caseObj.Caller_Last_Name__c = 'LastName';
        caseObj.AccountId = accountObj.Id;
        caseObj.Warm_Handoff__c = 'Yes';
        caseObj.Type = 'Death Certificates';
        caseObj.Death_Certificate__c = 'Yes';
        insert  caseObj;
		
        //Changes added by Sanjay on 04/22/2021:START
        caseObj.OwnerId = testGroup.Id;
        update  caseObj;
		//Changes added by Sanjay on 04/22/2021:END
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