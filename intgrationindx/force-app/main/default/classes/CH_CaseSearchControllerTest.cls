@isTest(seeAllData=false)
	
public with sharing class CH_CaseSearchControllerTest {
	static testMethod void SearchAccountCase(){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		 User u = new User(Alias = 'standt', Email='standarduserTest@coh.org', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTest@coh.org');
        System.runAs(u) {  
        Schema.DescribeSObjectResult cfrSchemacontact = Schema.SObjectType.Contact;
        Map<String,Schema.RecordTypeInfo> conRecordTypeInfocontact = cfrSchemacontact.getRecordTypeInfosByName();
        Contact contact = new Contact();
	        contact.FirstName='Doctor';
	        contact.LastName='lastName';
	        contact.RecordTypeId = conRecordTypeInfocontact.get('Contacts').getRecordTypeId();
        insert contact;
                          
		Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
    	Map<String,Schema.RecordTypeInfo> conRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
		Account accountRecord = CH_Test_SampleData.createNewPatientAccounts(1);
			 accountRecord.CC_AllScripts_Disease__c = 'Diabetes';
			 accountRecord.CC_Appointment_Date__c =Date.today().adddays(2);
			 accountRecord.CC_AllScripts_Physician__c=contact.Name;
			 accountRecord.SVC_Diagnosis__c= 'GI-OTHER';		 
		 update accountRecord;
		 
		Disease_Master__c diseaseMaster = new Disease_Master__c();
	        diseaseMaster.Disease_Group_Name__c ='Transplant Group';
	        diseaseMaster.Name = 'Diabetes';
        insert diseaseMaster;
		 
		 //Case caseRecord = CH_Test_SampleData.createCase(1,accountRecord);
		Case cse = new Case();    			
	        cse.accountid = accountRecord.id;   
	    	cse.Origin = 'Phone';
	    	cse.Status = 'New';
	    	cse.Type= 'Letters'; 
	    	cse.CC_Appointment_Date__c = Date.today().adddays(2);
	     	cse.Status = 'New';
	     	cse.Inactive__c = false;
	      	cse.RecordTypeId = conRecordTypeInfo.get('Care Coordination').getRecordTypeId();// 'Care Coordination';  
    	insert cse;
    	
    	Case cseNps = new Case();    			
	        cseNps.accountid = accountRecord.id;   
	    	cseNps.Origin = 'Phone';
	    	cseNps.Status = 'New';
	    	cseNps.Type= 'Letters'; 
	    	cseNps.CC_Appointment_Date__c = Date.today().adddays(2);
	     	cseNps.Status = 'New';
	     	cseNps.Inactive__c = false;
	      	cseNps.RecordTypeId = conRecordTypeInfo.get('New Patient Services').getRecordTypeId();  
    	insert cseNps;
    	
    	 Status_Stage_Master__c statusstage = new Status_Stage_Master__c();
        	statusstage.Name = 'Patient Intake';
        	statusstage.Is_Status_Only__c = false;
        	insert statusstage;
		 Test.startTest();
		 
		 CH_CaseSearchController caseSc = new CH_CaseSearchController();
		 caseSc.accountId = accountRecord.id;
		 caseSc.caseid = cse.id;
		 PageReference pg = Page.CH_CaseSearchPage;
         Test.setCurrentPage(pg);
		 caseSc.getAccounts();
		 delete cse;
		 caseSc.CreateCase();
		 caseSc.first();
		 caseSc.last();
		 caseSc.previous();
		 caseSc.next();
		 caseSc.cancel();
		 Test.stopTest();
		 }
		 
	}

}