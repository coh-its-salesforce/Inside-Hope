/*
* This is the Test class for COHTOHDPRestApiCallOnRW.
* 
* Balaji Rao
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
/* For This Test class We have created the Mock class named as CohToHdpRestApiMockone */
@IsTest
Private class COHGoldenToHdpRestApiCallTest {

    private Static string external_ID='a5p233333456sdsdfc';
   //This method is used to create the Account and ProgramDetermination objects record.
    @testSetup
    static void testDataForRecord(){
         
        //Fetching the RecordType id of RedwoodIntake on account object
        RecordType rtObj = [SELECT Id FROM RecordType WHERE SobjectType='AM_Account__c' AND name='ECEN  Accounts'];
        
        Id contactrecordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('COH Contacts').getRecordTypeId();
       //ECEN Accounts,ECEN Evaluation Requests
        
        //Creating new am_account record with required fields for testing.
        AM_Account__c accountobj = new AM_Account__c();
        accountobj.First_Name__c = 'testing';
        accountobj.Last_Name__c = 'account';
        accountobj.Salutation_DB__c ='Mr.';
        accountobj.Gender_DB__c ='Male';
        accountobj.Date_of_Birth__c = date.parse('06/07/2011');
        accountobj.Mailing_State_Province__c = 'new york';
        accountobj.Patient_COE_Benefit_Identification_Numbe__c= '89247589234';
        accountobj.Treatment_Patient_Reported_to_HDP__c = 'Previous Treatment';
        accountobj.Local_Physician_First_Name_Last_Name__c = 'firstname';
        accountobj.Local_Physician_Credentials__c = 'MD';
        accountobj.Local_Physician_Specialty__c = 'Primary Care';
        accountobj.Local_Physician_Street_Address__c = 'local street';
        accountobj.Local_Physician_City__c = 'local city';
        accountobj.Local_Physician_State__c = 'Alaska';
        accountobj.Local_Physician_Zip__c = '7489324';
        accountobj.Local_Physician_Country__c = 'usa';
        accountobj.Local_Physician_Phone_Number__c = '749327433';
        accountobj.Local_Physician_Fax_Number__c = '4897123947';
        accountobj.RecordTypeId = rtObj.Id;
        insert accountobj;
        
        Contact conObj = new Contact();
        conObj.FirstName = 'test';
        conObj.LastName = 'record';
        conObj.Type__c = 'Physician';
        conObj.RecordTypeId=contactrecordtypeid;
        insert conObj;
        
        AM_Account__c acc=[select id,name from AM_Account__c where id=:accountobj.id];
        Id redwoodrecordtypeid1 = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('ECEN Evaluation Requests').getRecordTypeId();
        AM_Evaluation_Request__c rw1=new Am_Evaluation_Request__c();
        rw1.AM_Account__c=acc.id;
        rw1.Purpose_of_Call_DB__c ='Clinical trial';
        rw1.Cancer_Diagnosis_DB__c = 'Anal Cancer';
        rw1.Patient_Account_Country__c='United States';
        rw1.Patient_Account_State__c='Alaska';
        rw1.Request_Type__c='Virtual Evaluation';
        rw1.Treating_Physician_State__c='Alaska';
        rw1.Treating_Physician_2_State__c='California';
        rw1.Virtual_Request_Type_1__c='Call';
        rw1.Virtual_Request_Type_2__c='Call';
        rw1.Type_of_Request__c='APO Expert Written Report';
        rw1.Area_of_Cost_Savings__c='imaging';
        rw1.Humanistic_Determination__c='Decreased risk of permanent heart damage';
        rw1.Appropriate_Use_of_Healthcare__c='Evidence to support best practices';
        rw1.Effective_Communication_CareCoordinate__c='Collaborative peer-to-peer discussion';
        rw1.Financial_Alignment_ROI__c='Treatment was over-utilized';
        rw1.Impact_of_Decision__c='Agree with physician';
        rw1.Improved_Customer_Experience__c='Treatment that decreases toxicity';
        rw1.Personalized_Patient_Care__c='Improved efficacy';
        rw1.Preventable_Healthcare_Harm__c='Missed/incorrect diagnoses';
        rw1.Purpose_of_Call__c='Clinical trial';
        rw1.Outcome_Of_Review__c = 'Clinical Trial';
        rw1.Priority__c='High';
        rw1.ICD_10_Code_s__c='C46.1';
        rw1.Call_Re_scheduled__c='Yes';
        rw1.Member_Reached__c='Yes';
        rw1.CSL_Call_Resolution__c='Proceeded with CSL';
        rw1.Close_Reason__c='Member Dialed Wrong Service';
        rw1.Call_Time_1__c='08:00 AM - 09:00 AM';
        rw1.Call_Time_2__c='09:00 AM - 10:00 AM';
        rw1.Call_Time_3__c='10:00 AM - 11:00 AM';
        rw1.Compensation_Percentage_P1__c=25;
        rw1.Compensation_Percentage_P2__c=25;
        rw1.Compensation_Percentage_P3__c=25;
        rw1.Compensation_Percentage_P4__c=25;
        rw1.RecordTypeId = redwoodrecordtypeid1;
        insert rw1;
        
        AM_Evaluation_Request__c amEvObj = [select id,AM_Account__c,First_Name__c,LastName__c,Mailing_State_Province__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                            Patient_COE_Benefit_IdentificationNumber__c,
                                            Treatment_Patient_Reported_to_HDP__c from AM_Evaluation_Request__c where id=: rw1.id AND AM_Account__c =: acc.id];
                                        
        //Creating Program Determination Object test records.
        Am_Program_Determination__c programobj = new AM_Program_Determination__c();
        programobj.name = 'program deter testing';
        programobj.AM_Evaluation_Request_Name__c = amEvObj.id;
        programobj.Determination_Date__c = date.parse('06/07/2012');
        programobj.Date_of_Diagnosis_Patient_Reported_COH__c = date.parse('06/01/2019');
        programobj.Determination_Outcome__c = 'Program Eligibility Met';
        programobj.Determination_Outcome_Reason__c = 'Clinical - Ocular';
        programobj.Primary_Diagnosis_Patient_Reported__c = 'patient report testing';
        programobj.Clinical_Screening_Summary__c = 'clinical summary';
        insert programobj;
        
        //Here we are creating custom setting records. 
        COH_Config_Setting__c Cohconfigobj = new COH_Config_Setting__c();
        Cohconfigobj.name = 'Enable User Profile Monitoring';
		Cohconfigobj.Active__c = true;
        Cohconfigobj.Application_Name__c = 'Chatter Blue Pencil';
       	Cohconfigobj.Value__c ='false';
        Cohconfigobj.Value_Type__c ='Boolean'; 
		insert Cohconfigobj;
        
      	COH_Config_Setting__c Cohconfigobjone = new COH_Config_Setting__c();
        Cohconfigobjone.name = 'Enable User Role Monitoring';
		Cohconfigobjone.Active__c = true;
        Cohconfigobjone.Application_Name__c = 'Chatter Blue Pencil';
        Cohconfigobjone.Value__c ='false';
        Cohconfigobjone.Value_Type__c ='Boolean'; 
		insert Cohconfigobjone;
       }
    
  
    /*This is related to test the creatProgramDeterminitionSection method -
     *  insert operation of COHTOHDPRestApiCallOnRW controller
     * 
     * 
	 */ 
    
    testMethod static void testCreateProgramDetermination() 
    {
      
                  //Here we are fetching the Program Determination,account and plan of care object data.
       AM_Program_Determination__c prdmobj =[select Date_of_Diagnosis_Patient_Reported_COH__c , Determination_Date__c ,
                                                       Determination_Outcome__c , Determination_Outcome_Reason__c ,
                                                       Primary_Diagnosis_Patient_Reported__c,Clinical_Screening_Summary__c,AM_Evaluation_Request_Name__c,
                                                       Sent_to_HDP_ID__c,Referral_to_Physician_First_Last_Name__c, Referral_to_Physician_Credential__c, 
                                                       Referral_to_Physician_Specialty__c, Referral_to_Physician_Street_Address__c,
                                                       Referral_to_Physician_City__c, Referral_to_Physician_State__c,
                                                       Referral_to_Physician_Country__c,Referral_to_Physician_Zip__c, Referral_to_Physician_Fax_Number__c,
                                                       Referral_to_Physician_Phone_Number__c,
                                                       Referral_to_Associated_Facilities__c
                                                       from AM_Program_Determination__c where name='program deter testing'];
                
                
                if(prdmobj.AM_Evaluation_Request_Name__c != null)
                {
                    
                 AM_Evaluation_Request__c amEvObj = [select id,AM_Account__c,First_Name__c,LastName__c,Mailing_State_Province__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                                        Patient_COE_Benefit_IdentificationNumber__c,
                                                        Treatment_Patient_Reported_to_HDP__c from AM_Evaluation_Request__c where id =:prdmobj.AM_Evaluation_Request_Name__c];
                }
                //Here We are fetching the Program Determination object test record id to pass in creatProgramDeterminitionSection method of our controller
                AM_Program_Determination__c programDeterminationObj = [select id,name from AM_Program_Determination__c where name='program deter testing'];
               
                system.assertEquals(programDeterminationObj.name, 'program deter testing');
                
        		//Here we are testing the creatProgramDeterminitionSection method of our controller.
                test.startTest();
                COHGoldenTOHDPRestApiCallRWMockOne mockobj = new COHGoldenTOHDPRestApiCallRWMockOne();
                //The actual AccessToken we are passing in mack test class
                string expecteAccessToken = '8UT28QKGORMivFqne-6PMRLdTYk3AS0mcxdVwRJEwYsTjwZjqGopk1TRzGX7vHSZpFNFL3HOmX3RKZrQkBap3b16j-XVkwArdDbhusArOBGzYsD1cpA8B87N_RedJrd9btvq2i22cAjPvyJLSVMc297U0V9YZ9rJ3tM429G8mglnsUNUVJJi_nnTJAN6-H038B4Y1aQeRQZVdU72Nr942eYZ3fXv1HXfxwYUZgWyYO5juVaVnoq_ZJHcrFGXfNp5LVrNlnEibHhJ2RGeD-MYKhyVjfkTrATGQhYY--OVCOemUyWKTlwgwBFjgzfpQfOq79raEglOTgEF3Qx78RY2-nBNvgOTRMET4B2fT17Q8EN4UCQLxGZTGq1ACN5j2B3YKT7isjzwAgysloYGJsL4j4D8dCGKgWBO0rTXwx7MfkNsX5TjAYRNCip5vTSRXeSBqhjM_TtwbKCA0HexikSz-XryZT7pKGYhjfRCXtWudd7OUjFYoDRfKTiAhjNk5yJj';
                Test.setMock(HttpCalloutMock.class,mockobj);
                COHGoldenToHdpRestApiCall cohobj =new COHGoldenToHdpRestApiCall();
                string access = cohobj.ReturnAccessToken(cohobj);
                //Here we are testing the actual accesstoken with expected accesstoken.
                system.assertEquals(expecteAccessToken, access);
                COHGoldenToHdpRestApiCall.creatProgramDeterminitionSection(programDeterminationObj.id) ;
                COHGoldenToHdpRestApiCall.simpleTextPost(programDeterminationObj.id, 'Chatter');
                AM_Program_Determination__c programDeterminationObjone = [select id,name,Sent_to_HDP_ID__c from AM_Program_Determination__c where name='program deter testing'];
               
        test.stoptest(); 
    }
 	/* This is related to test the creatProgramDeterminitionSection method -
     *  update operation of COHTOHDPRestApiCallOnRW controller
     * 
     * 
	 */
    testMethod static void updateProgramDeterminatioin(){
      
          AM_Program_Determination__c programDeterminationObjtwo = [select name,id,Date_of_Diagnosis_Patient_Reported_COH__c,Determination_Date__c,
                                                                 	Determination_Outcome__c,Determination_Outcome_Reason__c ,
                                                                    Primary_Diagnosis_Patient_Reported__c,Clinical_Screening_Summary__c,AM_Evaluation_Request_Name__c,
                                                                    Sent_to_HDP_ID__c  
                                                                    from AM_Program_Determination__c where name='program deter testing'];
          
          programDeterminationObjtwo.Sent_to_HDP_ID__c=external_ID;
          update programDeterminationObjtwo;
          test.startTest();
          COHGoldenTOHDPRestApiCallRWMockOne mockobj = new COHGoldenTOHDPRestApiCallRWMockOne();
          Test.setMock(HttpCalloutMock.class,mockobj);
          COHGoldenToHdpRestApiCall cohobj =new COHGoldenToHdpRestApiCall();
          string access = cohobj.ReturnAccessToken(cohobj);
          COHGoldenToHdpRestApiCall.creatProgramDeterminitionSection(programDeterminationObjtwo.id) ;
          test.stopTest();
    
      }
   
     /*This related to test the testCreatePlanOfCareSection method -
     *  update operation of COHTOHDPRestApiCallOnRW controller
     * 
     * 
	 */
    testMethod static void testCreatePlanOfCare()
    {
        RecordType rtObj1 = [SELECT Id FROM RecordType WHERE SobjectType='AM_Account__c' AND name='ECEN  Accounts'];
        AM_Account__c accountobj=[select id,name from AM_Account__c where Recordtypeid=:rtObj1.ID limit 1];
        AM_Evaluation_Request__c rw2=[select AM_Account__c from AM_Evaluation_Request__c where AM_Account__c=:accountobj.id];
        AM_Evaluation_Request__c amEvObj1 = [select id,AM_Account__c,First_Name__c,LastName__c,Mailing_State_Province__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                            Patient_COE_Benefit_IdentificationNumber__c,
                                            Treatment_Patient_Reported_to_HDP__c from AM_Evaluation_Request__c where AM_Account__c=:accountobj.id];
         //Contact record 
         Contact conObj= [select id,name from Contact where name='test record'];   
        //Here we are creating the plan of care record for testing.		
        AM_Plan_Of_Care__c planOfCareObj = new AM_Plan_Of_Care__c();
        planOfCareObj.name = 'plan of care test';
        planOfCareObj.CoH_Primary__c = conObj.id;
        planOfCareObj.Facility_Plan_of_Care_Submission_Date__c = date.parse('06/07/2018');
        planOfCareObj.Proposed_Service_Type__c ='In-Person Evaluation';//'n-Person Evaluation – Outpatient Services Bundle';//In-Person Evaluation
        planOfCareObj.Consultation_Type__c = 'Surgical Oncology';
        planOfCareObj.Additional_Diagnostic_EvaluationServices__c = 'Diagnostic Radiology Review';
        planOfCareObj.AM_Evaluation_Request_Name__c = amEvObj1.id;
        planOfCareObj.Evaluation_Date_1__c = date.parse('11/07/2018');
        planOfCareObj.Evaluation_Date_2__c = date.parse('09/07/2018');
        planOfCareObj.Estimated_Arrival_Date__c= date.parse('08/07/2018');
        planOfCareObj.Estimated_Departure_Date__c= date.parse('06/07/2018');
        planOfCareObj.First_AppointmentTimeOn_First_Evaluation__c=datetime.newInstance(2019, 08, 01, 16, 30, 25);
        planOfCareObj.Evaluation_Date_Time__c = datetime.newInstance(2019, 09, 01, 16, 30, 25);
        planOfCareObj.Last_Appointment_Date_time__c = datetime.newInstance(2019, 10, 01, 16, 30, 25);
        
        insert planOfCareObj;
        
        AM_Plan_Of_Care__c planOfCareObjtwo = [select id ,Facility_Plan_of_Care_Submission_Date__c,Proposed_Service_Type__c,Consultation_Type__c,
                                  			Additional_Diagnostic_EvaluationServices__c,AM_Evaluation_Request_Name__c from AM_Plan_Of_Care__c where name=:planOfCareObj.Name];
        
        if(planOfCareObjtwo.AM_Evaluation_Request_Name__c != null)
        {
            AM_Evaluation_Request__c accobj = [select id ,name from AM_Evaluation_Request__c where id =:planOfCareObjtwo.AM_Evaluation_Request_Name__c];
        }
        
        //Here we are fetching the test record id of plan of care object to pass as a parameter in creatPlaneOfCareSection method 
        AM_Plan_Of_Care__c planOfCareObjthree=[select id,name from AM_Plan_Of_Care__c where id=:planOfCareObj.id];
        System.assertEquals(planOfCareObjthree.name,'plan of care test');
        test.startTest();
        COHGoldenTOHDPRestApiCallRWMockOne testmockobj = new COHGoldenTOHDPRestApiCallRWMockOne();
        Test.setMock(HttpCalloutMock.class,testmockobj);
        COHGoldenToHdpRestApiCall.creatPlaneOfCareSection(planOfCareObjthree.id);
        test.stopTest();
        
    }    
    
}