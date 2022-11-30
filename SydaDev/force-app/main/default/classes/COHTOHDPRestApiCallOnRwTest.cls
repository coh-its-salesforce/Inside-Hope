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
private class COHTOHDPRestApiCallOnRwTest  
{
    private Static string external_ID='a5p233333456sdsdfc';
  	                 
    //This method is used to create the Account and ProgramDetermination objects record.
    @testSetup
    private static void testData(){
         
        //Fetching the RecordType id of RedwoodIntake on account object
        Id redwoodrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Redwood Intake').getRecordTypeId();
       Id redwoodrecordtypeidcon = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('COH Contacts').getRecordTypeId();
       
        //Creating new account record with required fields for testing.
        account accountobj = new account();
        accountobj.Firstname = 'testing';
        accountobj.Lastname = 'account';
        accountobj.phone = '8943944948';
        accountobj.fax = '6439264';
        accountobj.Website = 'www.coh.com';
        accountobj.Caller_Email_Address__c = 'coh@gmail.com';
        accountobj.PersonBirthdate = date.parse('06/07/2011');
        accountobj.PersonMailingState = 'new york';
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
        accountobj.Associated_Facilities__c = 'facilitate test';
        accountobj.RecordTypeId = redwoodrecordtypeid;
        
        insert accountobj;
        
        account acc=[select id,name from account where id=:accountobj.id];
        
        Contact conObj = new Contact();
        conObj.FirstName = 'test';
        conObj.LastName = 'record';
        conObj.Type__c = 'Physician';
        conObj.RecordTypeId=redwoodrecordtypeidcon;
        insert conObj;
       
        RW_Evaluation_Request__c rw1=new RW_Evaluation_Request__c();
        rw1.patient_name__c=acc.id;
        insert rw1;
        //Local_Physician_Zip__c,
        RW_Evaluation_Request__c rw = [select id,Patient_Name__c,Mailing_Address__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                       Patient_COE_Benefit_Identification_Numbe__c,Treatment_Patient_Reported_to_HDP__c,Local_PCP_First_and_Last_Name__c,Local_Physician_Credentials__c,
                                       Local_Physician_Specialty__c,Local_Physician_Street_Address__c,Local_Physician_City__c,Local_Physician_Fax_Number__c,
                                       Local_Physician_Country__c,Local_Physician_Zip__c,Local_Physician_State__c,Local_Physician_Phone_Number__c,Associated_Facilities__c from RW_Evaluation_Request__c where id=:rw1.id AND patient_name__c =:acc.id];
                                        
        
        //Fetching the account test record to create program determination object test record. 
        //account obj=[select id,name from account where id=:accountobj.id];
        
        //system.assertEquals(obj.name, 'testing account');
        
        //Creating Program Determination Object test records.
        Program_Determination__c programobj = new Program_Determination__c();
        programobj.name = 'program deter testing';
        programobj.Evaluation_Request_Name__c = rw.id;
        programobj.Determination_Date__c = date.parse('06/07/2012');
        programobj.Date_Diagnosis_Patient_Reported_to_coh__c = date.parse('06/01/2019');
        programobj.Determination_Outcome__c = 'Program Eligibility Met';
        programobj.Determination_Outcome_Reason__c = 'Clinical - Ocular';
        programobj.Primary_Diagnosis_Patient_Reported_to__c = 'patient report testing';
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
    
    private testMethod static void testCreateProgramDetermination() 
    {
				//Referred_to_Physician_Zip__c,    
                    //Here we are fetching the Program Determination,account and plan of care object data.
                Program_Determination__c prdmobj = [select id,name,Date_Diagnosis_Patient_Reported_to_coh__c,Determination_Date__c,
                                                    Determination_Outcome__c,Determination_Outcome_Reason__c,
                                                    Primary_Diagnosis_Patient_Reported_to__c,Clinical_Screening_Summary__c,Evaluation_Request_Name__c,
                                                    Referred_To_LocalPhysician1__c,Send_to_HDP_ID__c,
                                                    Referred_to_Physician_First_Last_Name__c, Referred_to_Physician_Credential__c, 
                                                    Referred_to_Physician_Specialty__c, Referred_to_Physician_Street_Address__c,
                                                    Referred_to_Physician_City__c, Referred_to_Physician_State__c,
                                                    Referred_to_Physician_Fax_Number__c,Referred_to_Physician_Country__c,
                                                    Referred_to_Physician_Phone_Number__c,Referred_to_Physician_Zip__c,  
                                                    Referred_to_Associated_Facilities__c
                                                    from Program_Determination__c where name='program deter testing'];
                
                
                if(prdmobj.Evaluation_Request_Name__c != null)
                {		//Local_Physician_Zip__c,
                 RW_Evaluation_Request__c ac = [select id,Patient_Name__c,Mailing_Address__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                                      Patient_COE_Benefit_Identification_Numbe__c,
                                                      Treatment_Patient_Reported_to_HDP__c,Local_PCP_First_and_Last_Name__c,Local_Physician_Credentials__c,
                                                      Local_Physician_Specialty__c,Local_Physician_Street_Address__c,Local_Physician_City__c,
                                                      Local_Physician_Country__c,Local_Physician_State__c,Local_Physician_Fax_Number__c,Local_Physician_Zip__c,
                                                	  Local_Physician_Phone_Number__c,Associated_Facilities__c from RW_Evaluation_Request__c where id =:prdmobj.Evaluation_Request_Name__c];
                             
                }
                
                                
                //Here We are fetching the Program Determination object test record id to pass in creatProgramDeterminitionSection method of our controller
                Program_Determination__c programDeterminationObj = [select id,name from Program_Determination__c where name='program deter testing'];
               
                system.assertEquals(programDeterminationObj.name, 'program deter testing');
                
        		//Here we are testing the creatProgramDeterminitionSection method of our controller.
                test.startTest();
                COHTOHDPRestApiCallRWMockOne mockobj = new COHTOHDPRestApiCallRWMockOne();
                //The actual AccessToken we are passing in mack test class
                string expecteAccessToken = '8UT28QKGORMivFqne-6PMRLdTYk3AS0mcxdVwRJEwYsTjwZjqGopk1TRzGX7vHSZpFNFL3HOmX3RKZrQkBap3b16j-XVkwArdDbhusArOBGzYsD1cpA8B87N_RedJrd9btvq2i22cAjPvyJLSVMc297U0V9YZ9rJ3tM429G8mglnsUNUVJJi_nnTJAN6-H038B4Y1aQeRQZVdU72Nr942eYZ3fXv1HXfxwYUZgWyYO5juVaVnoq_ZJHcrFGXfNp5LVrNlnEibHhJ2RGeD-MYKhyVjfkTrATGQhYY--OVCOemUyWKTlwgwBFjgzfpQfOq79raEglOTgEF3Qx78RY2-nBNvgOTRMET4B2fT17Q8EN4UCQLxGZTGq1ACN5j2B3YKT7isjzwAgysloYGJsL4j4D8dCGKgWBO0rTXwx7MfkNsX5TjAYRNCip5vTSRXeSBqhjM_TtwbKCA0HexikSz-XryZT7pKGYhjfRCXtWudd7OUjFYoDRfKTiAhjNk5yJj';
                Test.setMock(HttpCalloutMock.class,mockobj);
                COHTOHDPRestApiCallOnRW cohobj =new COHTOHDPRestApiCallOnRW();
                string access = cohobj.ReturnAccessToken(cohobj);
                //Here we are testing the actual accesstoken with expected accesstoken.
                system.assertEquals(expecteAccessToken, access);
                COHTOHDPRestApiCallOnRW.creatProgramDeterminitionSection(programDeterminationObj.id) ;
                COHTOHDPRestApiCallOnRW.simpleTextPost(programDeterminationObj.id, 'Chatter');
                Program_Determination__c programDeterminationObjone = [select id,name,Send_to_HDP_ID__c from Program_Determination__c where name='program deter testing'];
                //system.debug('send to hdp id '+programDeterminationObjone.Send_to_HDP_ID__c);
        test.stoptest(); 
        
     
    }
 	/* This is related to test the creatProgramDeterminitionSection method -
     *  update operation of COHTOHDPRestApiCallOnRW controller
     * 
     * 
	 */
    private testMethod static void updateProgramDeterminatioin(){
      
          Program_Determination__c programDeterminationObjtwo = [select name,id,Date_Diagnosis_Patient_Reported_to_coh__c,Determination_Date__c,
                                                                 	Determination_Outcome__c,Determination_Outcome_Reason__c ,
                                                                    Primary_Diagnosis_Patient_Reported_to__c,Clinical_Screening_Summary__c,Evaluation_Request_Name__c,
                                                                    Referred_To_LocalPhysician1__c,Send_to_HDP_ID__c  
                                                                    from Program_Determination__c where name='program deter testing'];
          
          programDeterminationObjtwo.Send_to_HDP_ID__c=external_ID;
          update programDeterminationObjtwo;
          test.startTest();
          COHTOHDPRestApiCallRWMockOne mockobj = new COHTOHDPRestApiCallRWMockOne();
          Test.setMock(HttpCalloutMock.class,mockobj);
          COHTOHDPRestApiCallOnRW cohobj =new COHTOHDPRestApiCallOnRW();
          string access = cohobj.ReturnAccessToken(cohobj);
          COHTOHDPRestApiCallOnRW.creatProgramDeterminitionSection(programDeterminationObjtwo.id) ;
          test.stopTest();
    
      }
   
     /*This related to test the testCreatePlanOfCareSection method -
     *  update operation of COHTOHDPRestApiCallOnRW controller
     * 
     * 
	 */
    private testMethod static void testCreatePlanOfCare()
    {
          
        account accountobj=[select id,name from account where name='testing account'];
        
        
        RW_Evaluation_Request__c rw2=[select patient_name__c from RW_Evaluation_Request__c where patient_name__c=:accountobj.id];
        //Local_Physician_Zip__c,
        RW_Evaluation_Request__c rw = [select id,Patient_Name__c,Mailing_Address__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                       Patient_COE_Benefit_Identification_Numbe__c,Treatment_Patient_Reported_to_HDP__c,Local_PCP_First_and_Last_Name__c,Local_Physician_Credentials__c,
                                       Local_Physician_Specialty__c,Local_Physician_Street_Address__c,Local_Physician_City__c,Local_Physician_Fax_Number__c,Local_Physician_Zip__c,
                                       Local_Physician_Country__c,Local_Physician_State__c,Local_Physician_Phone_Number__c,Associated_Facilities__c from RW_Evaluation_Request__c where patient_name__c=:accountobj.id];
                                        
         Contact conObj= [select id,name from Contact where name='test record'];
          
        //Here we are creating the plan of care record for testing.		
        Plan_Of_Care__c planOfCareObj = new Plan_Of_Care__c();
        planOfCareObj.name = 'plan of care test';
        planOfCareObj.CoH_Primary__c = conObj.id;
        planOfCareObj.Facility_Plan_of_Care_Submission_Date__c = date.parse('06/07/2018');
        planOfCareObj.Proposed_Service_Type__c ='In-Person Evaluation';//'n-Person Evaluation – Outpatient Services Bundle';//In-Person Evaluation
        planOfCareObj.Consultation_Type__c = 'Surgical Oncology';
        planOfCareObj.AdditionalDiagnosticEvaluation_Servieces__c = 'Diagnostic Radiology Review';
        planOfCareObj.Evaluation_Request_Name__c = rw.id;
        planOfCareObj.Evaluation_Date_1__c = date.parse('11/07/2018');
        planOfCareObj.Evaluation_Date_2__c = date.parse('09/07/2018');
        planOfCareObj.Estimated_Arrival_Date__c= date.parse('08/07/2018');
        planOfCareObj.Estimated_Departure_Date__c= date.parse('06/07/2018');
        planOfCareObj.First_AppointmentTimeOn_First_Evaluation__c=datetime.newInstance(2019, 08, 01, 16, 30, 25);
        planOfCareObj.Evaluation_Date_and_Time__c = datetime.newInstance(2019, 09, 01, 16, 30, 25);
        planOfCareObj.Last_Appointment_Date_and_time__c = datetime.newInstance(2019, 10, 01, 16, 30, 25);
       // planOfCareObj.First_AppointmentTimeOn_First_Evaluation__c = datetime.valueOf('2019-03-08T08:23:20.000+0000');
        
        insert planOfCareObj;
        
        
        Plan_Of_Care__c planOfCareObjtwo = [select id ,PlaneOFCare_Send_to_HDP_ID__c,Facility_Plan_of_Care_Submission_Date__c,Proposed_Service_Type__c,Consultation_Type__c,
                                  			AdditionalDiagnosticEvaluation_Servieces__c,CoH_Primary__c,First_AppointmentTimeOn_First_Evaluation__c,Evaluation_Request_Name__c from Plan_Of_Care__c where name=:planOfCareObj.Name];
        //System.debug('--->First_AppointmentTimeOn_First_Evaluation__c is -->'+planOfCareObjtwo.First_AppointmentTimeOn_First_Evaluation__c);
          
       
        
        if(planOfCareObjtwo.Evaluation_Request_Name__c != null)
        {
            RW_Evaluation_Request__c accobj = [select id ,name from RW_Evaluation_Request__c where id =:planOfCareObjtwo.Evaluation_Request_Name__c];
        }
        
        //Here we are fetching the test record id of plan of care object to pass as a parameter in creatPlaneOfCareSection method 
        Plan_Of_Care__c planOfCareObjthree=[select id,name from Plan_Of_Care__c where id=:planOfCareObj.id];
        System.assertEquals(planOfCareObjthree.name,'plan of care test');
        test.startTest();
        COHTOHDPRestApiCallRWMockOne testmockobj = new COHTOHDPRestApiCallRWMockOne();
        Test.setMock(HttpCalloutMock.class,testmockobj);
        COHTOHDPRestApiCallOnRW.creatPlaneOfCareSection(planOfCareObjthree.id);
        test.stopTest();
        
    }  
    
    
}