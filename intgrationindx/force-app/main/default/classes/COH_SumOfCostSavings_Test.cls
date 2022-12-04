/***********************************************************************
 	This Test class is written for COH_SumOfCostSavings Trigger.
 
	Rajeshwar Chittari
	City of Hope
	Copyright (c) 2019
 
	No portion of this code may be copied, transferred, or transmitted
	in any form (written, electronic, or otherwise) without the prior
	written consent from the City of Hope.
************************************************************************/
@isTest
public class COH_SumOfCostSavings_Test 
{
	//for Quantam Health Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestQH()
    {
        test.startTest();
        	Id QHAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Quantum Health').getRecordTypeId();   
		
			Account accQH=new Account();
    		accQH.FirstName='Test';
    		accQH.LastName='Record';
  		//accQH.Client__c='abbott';
    		accQH.Gender__pc='Male';
    		accQH.RecordTypeId=QHAccountRecTypeId;
    		insert accQH;		
			account accQH1=[select id,name from account where id=:accQH.id];
			
        	Id complexCaseRecTypeId = Schema.SObjectType.Evaluation_Request__c.getRecordTypeInfosByName().get('QH - Complex Case Review').getRecordTypeId();
    		
			Evaluation_Request__c QHEVRec=new Evaluation_Request__c();
    		QHEVRec.RecordTypeId=complexCaseRecTypeId;
			QHEVRec.Patient_Account__c=accQH1.id;
    		QHEVRec.Reasons_for_Review__c='Reason for review testing';
    		QHEVRec.Clinical_Summary__c='clinical summary testing';
    		QHEVRec.Compensation_Percentage_P1__c=25;
    		QHEVRec.Compensation_Percentage_P2__c=25;
    		QHEVRec.Compensation_Percentage_P3__c=25;
    		QHEVRec.Compensation_Percentage_P4__c=25;
    		QHEVRec.Exclude_From_Report__c=false;
			QHEVRec.Cost_Savings_Added__c=false;
        	QHEVRec.Projected_Savings__c=0;
        	QHEVRec.Program_Cost__c=0;
        	QHEVRec.ROI__c=0.00;
    		insert QHEVRec;        	
		
		Evaluation_Request__c QHEVReq1=[select id from Evaluation_Request__c where id=:QHEVRec.id];
        
        	Cost_Saving__c vCostSavingQH = new Cost_Saving__c();
        	vCostSavingQH.COH_CSQH_Evalution_Request__c=QHEVReq1.id;
            vCostSavingQH.Area_of_Cost_Savings__c='Imaging';
            vCostSavingQH.Description_of_Cost_Savings__c='My Des1';
            vCostSavingQH.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingQH.COH_Recommendation_Cost__c=9.13;
            vCostSavingQH.Cost_Source__c='My Sour1';
        	insert vCostSavingQH;
        	
			Cost_Saving__c vCostSavingQH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingQH.id];
        	
			vCostSavingQH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingQH1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingQH1;
        	Cost_Saving__c vCostSavingQH2 = new Cost_Saving__c();
        	vCostSavingQH2.COH_CSQH_Evalution_Request__c=QHEVReq1.id;
            vCostSavingQH2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingQH2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingQH2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingQH2.COH_Recommendation_Cost__c=5.13;
            vCostSavingQH2.Cost_Source__c='My Sour1';
        	insert vCostSavingQH2;
        	Cost_Saving__c vCostSavingQH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingQH2.id];
        	delete vCostSavingQH3;
        
        	
        	Evaluation_Request__c QHEVRecX=new Evaluation_Request__c();
    		QHEVRecx.RecordTypeId=complexCaseRecTypeId;
			QHEVRecx.Patient_Account__c=accQH1.id;
    		QHEVRecx.Reasons_for_Review__c='Reason for review testing';
    		QHEVRecx.Clinical_Summary__c='clinical summary testing';
    		QHEVRecx.Compensation_Percentage_P1__c=25;
    		QHEVRecx.Compensation_Percentage_P2__c=25;
    		QHEVRecx.Compensation_Percentage_P3__c=25;
    		QHEVRecx.Compensation_Percentage_P4__c=25;
    		QHEVRecx.Exclude_From_Report__c=false;
			QHEVRecx.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';
        	QHEVRecx.Exclude_from_report_reason__c = 'Patient expired';
			QHEVRecx.Cost_Savings_Added__c=false;
        	QHEVRecx.Projected_Savings__c=0;
        	QHEVRecx.Program_Cost__c=40;
        	QHEVRecx.ROI__c=0.00;
    		insert QHEVRecx;        	
		
			Evaluation_Request__c QHEVReqx1=[select id from Evaluation_Request__c where id=:QHEVRecx.id];
        
        	Cost_Saving__c vCostSavingQHx = new Cost_Saving__c();
        	vCostSavingQHx.COH_CSQH_Evalution_Request__c=QHEVReqx1.id;
            vCostSavingQHx.Area_of_Cost_Savings__c='Imaging';
            vCostSavingQHx.Description_of_Cost_Savings__c='My Des1';
            vCostSavingQHx.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingQHx.COH_Recommendation_Cost__c=9.13;
            vCostSavingQHx.Cost_Source__c='My Sour1';
        	insert vCostSavingQHx;
        	
			Cost_Saving__c vCostSavingQHx1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingQHx.id];       	
			vCostSavingQHx1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingQHx1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingQHx1;
        	
        	Cost_Saving__c vCostSavingQHx2 = new Cost_Saving__c();
        	vCostSavingQHx2.COH_CSQH_Evalution_Request__c=QHEVReqx1.id;
           	vCostSavingQHx2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingQHx2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingQHx2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingQHx2.COH_Recommendation_Cost__c=5.13;
            vCostSavingQHx2.Cost_Source__c='My Sour1';
        	insert vCostSavingQHx2;
        	Cost_Saving__c vCostSavingQHx3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingQHx2.id];
        	delete vCostSavingQHx3;
        test.stopTest();
    }
    //for Consumer Medical Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestCM()
    {
    	test.startTest();
        	Id CMAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Medical').getRecordTypeId();
        	Account acc=new Account();	
        	acc.FirstName='Test';
    		acc.LastName='Record';
    		//acc.Client__c='abbott';
    		acc.Gender__pc='Male';
    		acc.RecordTypeId=CMAccountRecTypeId;
    		insert acc;
        	account ac=[select id,name from account where id=:acc.id];
        
        	CH_Evaluation_Request__c vCMEReq=new CH_Evaluation_Request__c();
        	vCMEReq.Account_Name__c=ac.id;
        	vCMEReq.Exclude_from_Report__c=false;
        	vCMEReq.Cost_Savings_Added__c=false;
        	vCMEReq.Projected_Savings__c=0;
        	vCMEReq.Program_Cost__c=0;
        	vCMEReq.ROI__c=0.00;
        	insert vCMEReq;
        	CH_Evaluation_Request__c vCMEReq1=[select id,name from CH_Evaluation_Request__c where id=:vCMEReq.id];
        	
        	Cost_Saving__c vCostSaving = new Cost_Saving__c();
        	vCostSaving.COH_CSQH_Evalution_Request__c=null;
        	vCostSaving.COH_CSCM_Evaluation_Request__c=vCMEReq1.id;
        	vCostSaving.COH_CSRW_Evalution_Request__c=null;
        	vCostSaving.COH_CSAM_Evaluationrequest__c=null;
        	vCostSaving.COH_CSHD_Evaluationrequest__c=null;
            vCostSaving.Area_of_Cost_Savings__c='Imaging';
            vCostSaving.Description_of_Cost_Savings__c='My Des1';
            vCostSaving.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSaving.COH_Recommendation_Cost__c=9.13;
            vCostSaving.Cost_Source__c='My Sour1';
        	insert vCostSaving;
        	Cost_Saving__c vCostSaving1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving.id];
        	vCostSaving1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSaving1.COH_Recommendation_Cost__c=10.00;
        	update vCostSaving1;
        	Cost_Saving__c vCostSaving2 = new Cost_Saving__c();
        	vCostSaving2.COH_CSQH_Evalution_Request__c=null;
        	vCostSaving2.COH_CSCM_Evaluation_Request__c=vCMEReq1.id;
        	vCostSaving2.COH_CSRW_Evalution_Request__c=null;
        	vCostSaving2.COH_CSAM_Evaluationrequest__c=null;
        	vCostSaving2.COH_CSHD_Evaluationrequest__c=null;
            vCostSaving2.Area_of_Cost_Savings__c='Imaging';
            vCostSaving2.Description_of_Cost_Savings__c='My Des1';
            vCostSaving2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSaving2.COH_Recommendation_Cost__c=5.13;
            vCostSaving2.Cost_Source__c='My Sour1';
        	insert vCostSaving2;
        	Cost_Saving__c vCostSaving3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving2.id];
        	delete vCostSaving3;
        
        	CH_Evaluation_Request__c vCMEReqt=new CH_Evaluation_Request__c();
        	vCMEReqt.Account_Name__c=ac.id;
        	vCMEReqt.Exclude_from_Report__c=false;
        	vCMEReqt.Cost_Savings_Added__c=false;
        	vCMEReqt.Projected_Savings__c=0;
        	vCMEReqt.Program_Cost__c=90;
        	vCMEReqt.ROI__c=0.00;
        	insert vCMEReqt;
        	CH_Evaluation_Request__c vCMEReqt1=[select id,name from CH_Evaluation_Request__c where id=:vCMEReqt.id];
        	
        	Cost_Saving__c vCostSavingt = new Cost_Saving__c();
        	vCostSavingt.COH_CSCM_Evaluation_Request__c=vCMEReqt1.id;
            vCostSavingt.Area_of_Cost_Savings__c='Imaging';
            vCostSavingt.Description_of_Cost_Savings__c='My Des1';
            vCostSavingt.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingt.COH_Recommendation_Cost__c=9.13;
            vCostSavingt.Cost_Source__c='My Sour1';
        	insert vCostSavingt;
        	Cost_Saving__c vCostSavingt1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingt.id];
        	vCostSavingt1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingt1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingt1;
        	Cost_Saving__c vCostSavingt2 = new Cost_Saving__c();
        	vCostSavingt2.COH_CSCM_Evaluation_Request__c=vCMEReqt1.id;
            vCostSavingt2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingt2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingt2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingt2.COH_Recommendation_Cost__c=5.13;
            vCostSavingt2.Cost_Source__c='My Sour1';
        	insert vCostSavingt2;
        	Cost_Saving__c vCostSavingt3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingt2.id];
        	delete vCostSavingt3;
    	test.stopTest();
    }
    //for Redwood Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestRW()
    {     
       test.startTest();
        Id RWAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Redwood Intake').getRecordTypeId();
        	Account acc1=new Account();	
        	acc1.FirstName='Test';
    		acc1.LastName='Record';
    		//acc.Client__c='abbott';
    		acc1.Employer_Program__c='My Prog1';
        	acc1.Request_Type__c='In person Evaluation';
        	acc1.Caller_Email_Address__c='raj@gmail.com';
        	acc1.COH_Redwood_CurrentStatus__c='New Request Submitted';
        	acc1.Referral_Facility__c='My Ref facility';
        	acc1.Referral_Date_and_Time__c=system.now();
        	acc1.Patient_Preferred_Name__c='Raja';
    		acc1.Gender__pc='Male';
        	acc1.Translation_Services_Required__c='Yes';
        	acc1.PersonBirthdate=system.today();
        	acc1.Preferred_Phone__c='Mobile';
        	acc1.Email__c='rajx@gmail.com';
        	acc1.Email_POC__c='rajx@gmail.com';
        	acc1.PersonEmail='rajx@gmail.com';
        	acc1.Phone='08462276675';
        	acc1.PersonMobilePhone='9494327204';
        	acc1.PersonHomePhone='08462276675';
        	acc1.Preferred_Language__c='English';
        	acc1.Preferred_Language__pc='English';
        	acc1.Best_Time_to_Contact__c='Morning';
        	acc1.Patient_COE_Benefit_Identification_Numbe__c='201';
        	acc1.Relationship_to_Employee__c='Dependent';
        	acc1.Employee_First_Name__c='Sachin';
        	acc1.Employee_Last_Name__c='Raj';
        	acc1.Employee_Date_of_Birth__c=system.today();
        	acc1.Date_Eligibility_Verified__c=system.today();
        	acc1.Primary_Diagnosis_PatientReported_to_HDP__c='XYZ';
        	acc1.Date_of_Diagnosis_PatientReportedto_HDP__c=system.today();
        	acc1.Treatment_Patient_Reported_to_HDP__c='Previous Treatment';
        	acc1.COH_Nurse_Name__c='Rashmika';
        	acc1.HDP_Nurse_Name__c='Suma';
        	acc1.COH_Nurse_Phone_Number__c='8977661738';
        	acc1.HDP_Nurse_Phone_Number__c='8977661739';
        	acc1.COH_Nurse_Email__c='ras@gmail.com';
        	acc1.HDP_Nurse_Email__c='sum@gmail.com';
        	acc1.HDP_Parent_ID__c='123';
    		acc1.RecordTypeId=RWAccountRecTypeId;
    		insert acc1;
        	account ac1=[select id,name from account where id=:acc1.id];
        	RW_Evaluation_Request__c vRWEReq=new RW_Evaluation_Request__c();
        	vRWEReq.Patient_Name__c=ac1.id;
            vRWEReq.COH_Redwood_CurrentStatus__c='New Request Submitted';
        	vRWEReq.Cost_Savings_Added__c=false;
        	vRWEReq.Projected_Savings__c=0;
        	vRWEReq.Program_Cost__c=0;
        	vRWEReq.ROI__c=0.00;
        	insert vRWEReq;
        	RW_Evaluation_Request__c vRWEReq1=[select id,name from RW_Evaluation_Request__c where id=:vRWEReq.id];
        	Cost_Saving__c vCostSaving1 = new Cost_Saving__c();
        	vCostSaving1.COH_CSRW_Evalution_Request__c=vRWEReq1.id;
            vCostSaving1.Area_of_Cost_Savings__c='Imaging';
            vCostSaving1.Description_of_Cost_Savings__c='My Des1';
            vCostSaving1.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSaving1.COH_Recommendation_Cost__c=9.13;
            vCostSaving1.Cost_Source__c='My Sour1';
        	insert vCostSaving1;
        	Cost_Saving__c vCostSaving2=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving1.id];
        	vCostSaving2.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSaving2.COH_Recommendation_Cost__c=10.00;
        	update vCostSaving2;
        	Cost_Saving__c vCostSaving3 = new Cost_Saving__c();
        	vCostSaving3.COH_CSRW_Evalution_Request__c=vRWEReq1.id;
            vCostSaving3.Area_of_Cost_Savings__c='Imaging';
            vCostSaving3.Description_of_Cost_Savings__c='My Des1';
            vCostSaving3.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSaving3.COH_Recommendation_Cost__c=5.13;
            vCostSaving3.Cost_Source__c='My Sour1';
        	insert vCostSaving3;
        	Cost_Saving__c vCostSaving4=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving3.id];
        	delete vCostSaving4;
        	
        	RW_Evaluation_Request__c vRWEReq2=new RW_Evaluation_Request__c();
        	vRWEReq2.Patient_Name__c=ac1.id;
            vRWEReq2.COH_Redwood_CurrentStatus__c='New Request Submitted';
        	vRWEReq2.Cost_Savings_Added__c=false;
        	vRWEReq2.Projected_Savings__c=0;
        	vRWEReq2.Program_Cost__c=50;
        	vRWEReq2.ROI__c=0.00;
        	insert vRWEReq2;
        	RW_Evaluation_Request__c vRWEReq3=[select id,name from RW_Evaluation_Request__c where id=:vRWEReq2.id];
        	Cost_Saving__c vCostSaving5 = new Cost_Saving__c();
        	vCostSaving5.COH_CSRW_Evalution_Request__c=vRWEReq3.id;
            vCostSaving5.Area_of_Cost_Savings__c='Imaging';
            vCostSaving5.Description_of_Cost_Savings__c='My Des1';
            vCostSaving5.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSaving5.COH_Recommendation_Cost__c=9.13;
            vCostSaving5.Cost_Source__c='My Sour1';
        	insert vCostSaving5;
        	Cost_Saving__c vCostSaving6=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving5.id];
        	vCostSaving6.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSaving6.COH_Recommendation_Cost__c=10.00;
        	update vCostSaving6;
        	Cost_Saving__c vCostSaving7 = new Cost_Saving__c();
        	vCostSaving7.COH_CSRW_Evalution_Request__c=vRWEReq3.id;
            vCostSaving7.Area_of_Cost_Savings__c='Imaging';
            vCostSaving7.Description_of_Cost_Savings__c='My Des1';
            vCostSaving7.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSaving7.COH_Recommendation_Cost__c=5.13;
            vCostSaving7.Cost_Source__c='My Sour1';
        	insert vCostSaving7;
        	Cost_Saving__c vCostSaving8=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSaving7.id];
        	delete vCostSaving8;
        test.stopTest(); 
    }
    //for Golden Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestAM()
    {
        test.startTest();
		
		Id AMAccRecTypeId=Schema.SObjectType.AM_Account__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
		AM_Account__c vAMAcc = new AM_Account__c();
		vAMAcc.RecordTypeId=AMAccRecTypeId;		
		vAMAcc.Salutation__c='Mr.';
		vAMAcc.First_Name__c='Chittari';
		vAMAcc.Last_Name__c='Raj';
		vAMAcc.Gender__c='Male';
		vAMAcc.Date_of_Birth__c=system.today();
		vAMAcc.Account_Number__c='121';
		vAMAcc.Email__c='raj@gmail.com';
		vAMAcc.Referral_Source__c='Aetna';
		insert vAMAcc;
		AM_Account__c vAMAcc1=[select id from AM_Account__c where id=:vAMAcc.id];
        	
        Id AMEVReqRecTypeId = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
        AM_Evaluation_Request__c AMEVReq = new AM_Evaluation_Request__c();
		AMEVReq.RecordTypeId=AMEVReqRecTypeId;
		AMEVReq.AM_Account__c=vAMAcc1.id;
		AMEVReq.Oncology_Service__c='EAR';
		AMEVReq.Purpose_of_Call_DB__c='dsssjj';
		AMEVReq.Cancer_Diagnosis__c='Anal Cancer';
        AMEVReq.Exclude_from_Report__c=false;
        AMEVReq.Cost_Savings_Added__c=false;
        AMEVReq.Projected_Savings__c=0;
        AMEVReq.Program_Cost__c=0;
        AMEVReq.ROI__c=0.00;
        insert AMEVReq;        	
		AM_Evaluation_Request__c AMEVReq1=[select id from AM_Evaluation_Request__c where id=:AMEVReq.id];
        
        	Cost_Saving__c vCostSavingAM = new Cost_Saving__c();
        	vCostSavingAM.COH_CSAM_Evaluationrequest__c=AMEVReq1.id;
            vCostSavingAM.Area_of_Cost_Savings__c='Imaging';
            vCostSavingAM.Description_of_Cost_Savings__c='My Des1';
            vCostSavingAM.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingAM.COH_Recommendation_Cost__c=9.13;
            vCostSavingAM.Cost_Source__c='My Sour1';
        	insert vCostSavingAM;
        	Cost_Saving__c vCostSavingAM1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingAM.id];
        	vCostSavingAM1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingAM1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingAM1;
        	Cost_Saving__c vCostSavingAM2 = new Cost_Saving__c();
        	vCostSavingAM2.COH_CSAM_Evaluationrequest__c=AMEVReq1.id;
            vCostSavingAM2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingAM2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingAM2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingAM2.COH_Recommendation_Cost__c=5.13;
            vCostSavingAM2.Cost_Source__c='My Sour1';
        	insert vCostSavingAM2;
        	Cost_Saving__c vCostSavingAM3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingAM2.id];
        	delete vCostSavingAM3;
        
        AM_Evaluation_Request__c AMEVReq2 = new AM_Evaluation_Request__c();
		AMEVReq2.RecordTypeId=AMEVReqRecTypeId;
		AMEVReq2.AM_Account__c=vAMAcc1.id;
		AMEVReq2.Oncology_Service__c='EAR';
		AMEVReq2.Purpose_of_Call_DB__c='dsssjj';
		AMEVReq2.Cancer_Diagnosis__c='Anal Cancer';
        AMEVReq2.Exclude_from_Report__c=false;
        AMEVReq2.Cost_Savings_Added__c=false;
        AMEVReq2.Projected_Savings__c=0;
        AMEVReq2.Program_Cost__c=30;
        AMEVReq2.ROI__c=0.00;
        insert AMEVReq2;        	
		AM_Evaluation_Request__c AMEVReq3=[select id from AM_Evaluation_Request__c where id=:AMEVReq2.id];
        
        	Cost_Saving__c vCostSavingAM4 = new Cost_Saving__c();
        	vCostSavingAM4.COH_CSAM_Evaluationrequest__c=AMEVReq3.id;
            vCostSavingAM4.Area_of_Cost_Savings__c='Imaging';
            vCostSavingAM4.Description_of_Cost_Savings__c='My Des1';
            vCostSavingAM4.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingAM4.COH_Recommendation_Cost__c=9.13;
            vCostSavingAM4.Cost_Source__c='My Sour1';
        	insert vCostSavingAM4;
        	Cost_Saving__c vCostSavingAM5=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingAM4.id];
        	vCostSavingAM5.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingAM5.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingAM5;
        	Cost_Saving__c vCostSavingAM6 = new Cost_Saving__c();
        	vCostSavingAM6.COH_CSAM_Evaluationrequest__c=AMEVReq3.id;
            vCostSavingAM6.Area_of_Cost_Savings__c='Imaging';
            vCostSavingAM6.Description_of_Cost_Savings__c='My Des1';
            vCostSavingAM6.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingAM6.COH_Recommendation_Cost__c=5.13;
            vCostSavingAM6.Cost_Source__c='My Sour1';
        	insert vCostSavingAM6;
        	Cost_Saving__c vCostSavingAM7=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingAM6.id];
        	delete vCostSavingAM7;
        
        test.stopTest();
    }
    //for HD(The Home Depot) Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestHD()
    {
        test.startTest();
        	Id HDAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('The Home Depot').getRecordTypeId();
        	Account HDacc=new Account();
        	HDacc.FirstName='Test';
    		HDacc.LastName='Record';
        	HDacc.Cause_Last_Name__c='Rma';
        	HDacc.PersonBirthdate=system.today();
        	HDacc.AccountNumber='123';
        	//HDacc.Patient_Gender__c='Male';
        	HDacc.Gender__pc='Male';
        	HDacc.Email__c='rak3@gmail.com';
            HDacc.Email_POC__c='rak1@gmail.com';
        	HDacc.PersonEmail='rak2@gmail.com';
        	HDacc.RecordTypeId=HDAccountRecTypeId;
        	insert HDacc;
        	account HDacc1=[select id from account where id=:HDacc.id];
        	HD_Evaluation_Request__c HDEVReq = new HD_Evaluation_Request__c();
        	HDEVReq.Account_Name__c=HDacc1.id;
        	HDEVReq.Report_Review_Type__c='Virtual Review';
        	HDEVReq.Oncology_Service__c='EAR';
        	HDEVReq.Medical_Carrier__c='Aetna';
        	HDEVReq.Exclude_from_Report__c=false;
        	HDEVReq.Cost_Savings_Added__c=false;
        	HDEVReq.Projected_Savings__c=0;
        	HDEVReq.Program_Cost__c=0;
        	HDEVReq.ROI__c=0.00;
        	insert HDEVReq;
        	HD_Evaluation_Request__c HDEVReq1=[select id from HD_Evaluation_Request__c where id=:HDEVReq.id];
        
        	Cost_Saving__c vCostSavingHD = new Cost_Saving__c();
        	vCostSavingHD.COH_CSHD_Evaluationrequest__c=HDEVReq1.id;
            vCostSavingHD.Area_of_Cost_Savings__c='Imaging';
            vCostSavingHD.Description_of_Cost_Savings__c='My Des1';
            vCostSavingHD.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingHD.COH_Recommendation_Cost__c=9.13;
            vCostSavingHD.Cost_Source__c='My Sour1';
        	insert vCostSavingHD;
        	Cost_Saving__c vCostSavingHD1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingHD.id];
        	vCostSavingHD1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingHD1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingHD1;
        	Cost_Saving__c vCostSavingHD2 = new Cost_Saving__c();
        	vCostSavingHD2.COH_CSHD_Evaluationrequest__c=HDEVReq1.id;
            vCostSavingHD2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingHD2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingHD2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingHD2.COH_Recommendation_Cost__c=5.13;
            vCostSavingHD2.Cost_Source__c='My Sour1';
        	insert vCostSavingHD2;
        	Cost_Saving__c vCostSavingHD3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingHD2.id];
        	delete vCostSavingHD3;
        
        	
        	HD_Evaluation_Request__c HDEVReq2 = new HD_Evaluation_Request__c();
        	HDEVReq2.Account_Name__c=HDacc1.id;
        	HDEVReq2.Report_Review_Type__c='Virtual Review';
        	HDEVReq2.Oncology_Service__c='EAR';
        	HDEVReq2.Medical_Carrier__c='Aetna';
        	HDEVReq2.Exclude_from_Report__c=false;
			HDEVReq2.Reason_for_Exclusion_from_Report__c = 'Reason for Exclusion';
        	HDEVReq2.Exclude_from_report_reason__c = 'Patient expired';
        	HDEVReq2.Cost_Savings_Added__c=false;
        	HDEVReq2.Projected_Savings__c=0;
        	HDEVReq2.Program_Cost__c=20;
        	HDEVReq2.ROI__c=0.00;        	
        	insert HDEVReq2;
        	HD_Evaluation_Request__c HDEVReq3=[select id from HD_Evaluation_Request__c where id=:HDEVReq2.id];
        
        	Cost_Saving__c vCostSavingHD4 = new Cost_Saving__c();
        	vCostSavingHD4.COH_CSHD_Evaluationrequest__c=HDEVReq3.id;
            vCostSavingHD4.Area_of_Cost_Savings__c='Imaging';
            vCostSavingHD4.Description_of_Cost_Savings__c='My Des1';
            vCostSavingHD4.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingHD4.COH_Recommendation_Cost__c=9.13;
            vCostSavingHD4.Cost_Source__c='My Sour1';
        	insert vCostSavingHD4;
        	Cost_Saving__c vCostSavingHD5=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingHD4.id];
        	vCostSavingHD5.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingHD5.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingHD5;
        	Cost_Saving__c vCostSavingHD6 = new Cost_Saving__c();
        	vCostSavingHD6.COH_CSHD_Evaluationrequest__c=HDEVReq3.id;
            vCostSavingHD6.Area_of_Cost_Savings__c='Imaging';
            vCostSavingHD6.Description_of_Cost_Savings__c='My Des1';
            vCostSavingHD6.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingHD6.COH_Recommendation_Cost__c=5.13;
            vCostSavingHD6.Cost_Source__c='My Sour1';
        	insert vCostSavingHD6;
        	Cost_Saving__c vCostSavingHD7=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingHD6.id];
        	delete vCostSavingHD7;
        
        test.stopTest();
    }
    
    //for City Of Hope Evaluation request test update:
   public static testMethod void SumOfCostSavingsTestCOH()
    {
        test.startTest();
        	Id COHAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('COH ES Patient').getRecordTypeId();
        	Account COHacc=new Account();
        	COHacc.FirstName='Test';
    		COHacc.LastName='Record';
        	//COHacc.Cause_Last_Name__c='Rma';
        	COHacc.PersonBirthdate=system.today();
        	//COHacc.AccountNumber='123';
        	//COHacc.Patient_Gender__c='Male';
        	COHacc.Gender__pc='Male';
        	//COHacc.Email__c='rak3@gmail.com';
            //COHacc.Email_POC__c='rak1@gmail.com';
        	COHacc.PersonEmail='rak2@gmail.com';
        	COHacc.RecordTypeId=COHAccountRecTypeId;
        	insert COHacc;
        	account COHacc1=[select id from account where id=:COHacc.id];
		Id COHRecTypeId = Schema.SObjectType.COH_Evaluation_Request__c.getRecordTypeInfosByName().get('EAR').getRecordTypeId();
        	COH_Evaluation_Request__c COHEVReq = new COH_Evaluation_Request__c();
		COHEVReq.RecordTypeId=COHRecTypeId;
        	COHEVReq.COH_Account__c=COHacc1.id;
        	COHEVReq.Request_Type__c='In person Evaluation';
        	COHEVReq.Status__c='Submitted for Review';
        	COHEVReq.Cancer_Diagnosis__c='Bile Duct Cancer';
        	//COHEVReq.Exclude_from_Report__c=false;
        	COHEVReq.Cost_Savings_Added__c=false;
        	COHEVReq.Projected_Savings__c=0;
        	COHEVReq.Program_Cost__c=0;
        	COHEVReq.ROI__c=0.00;
        	insert COHEVReq;
        	COH_Evaluation_Request__c COHEVReq1=[select id from COH_Evaluation_Request__c where id=:COHEVReq.id];

		
        	
        	Cost_Saving__c vCostSavingCOH = new Cost_Saving__c();
        	vCostSavingCOH.COH_Evaluation_Request__c=COHEVReq1.id;
            vCostSavingCOH.Area_of_Cost_Savings__c='Imaging';
            vCostSavingCOH.Description_of_Cost_Savings__c='My Des1';
            vCostSavingCOH.Local_MD_Treatment_Plan_Cost__c=12.00;
            vCostSavingCOH.COH_Recommendation_Cost__c=9.13;
            vCostSavingCOH.Cost_Source__c='My Sour1';
        	insert vCostSavingCOH;
        	Cost_Saving__c vCostSavingCOH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH.id];
        	vCostSavingCOH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        	vCostSavingCOH1.COH_Recommendation_Cost__c=10.00;
        	update vCostSavingCOH1;
        	Cost_Saving__c vCostSavingCOH2 = new Cost_Saving__c();
        	vCostSavingCOH2.COH_Evaluation_Request__c=COHEVReq1.id;
            vCostSavingCOH2.Area_of_Cost_Savings__c='Imaging';
            vCostSavingCOH2.Description_of_Cost_Savings__c='My Des1';
            vCostSavingCOH2.Local_MD_Treatment_Plan_Cost__c=13.00;
            vCostSavingCOH2.COH_Recommendation_Cost__c=5.13;
            vCostSavingCOH2.Cost_Source__c='My Sour1';
        	insert vCostSavingCOH2;
        	Cost_Saving__c vCostSavingCOH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH2.id];
        	delete vCostSavingCOH3;
        
        	
        test.stopTest();
    } 
    /*
    //for Voya Evaluation request test update:
    public static testMethod void SumOfCostSavingsTestVO()
    {
        test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Voya Patient').getRecordTypeId();
        
		account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.RecordTypeId = cohrecordtypeid;
        insert Amc;
        	
	 	VO_Evaluation_Request__c COHevalRecord=new VO_Evaluation_Request__c();
        COHevalRecord.VO_Account__c = Amc.ID;
		COHevalRecord.Purpose_of_Call__c='General information';
		COHevalRecord.Cancer_Diagnosis__c='Acute Lymphoblastic Leukemia (ALL)';
		COHevalRecord.ICD_10_Code_s__c='C91.01';
        COHevalRecord.Status__c='Submitted for Review';
		COHevalRecord.Cost_Savings_Added__c=false;
        COHevalRecord.Projected_Savings__c=0;
        COHevalRecord.Program_Cost__c=0;
        COHevalRecord.ROI__c=0.00;
        insert COHevalRecord;
		
        VO_Evaluation_Request__c COHEVReq1=[select id from VO_Evaluation_Request__c where id=:COHevalRecord.id];

        Cost_Saving__c vCostSavingCOH = new Cost_Saving__c();
        vCostSavingCOH.COH_CSVO_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingCOH.Area_of_Cost_Savings__c='Imaging';
        vCostSavingCOH.Description_of_Cost_Savings__c='My Des1';
        vCostSavingCOH.Local_MD_Treatment_Plan_Cost__c=12.00;
        vCostSavingCOH.COH_Recommendation_Cost__c=9.13;
        vCostSavingCOH.Cost_Source__c='My Sour1';
       	insert vCostSavingCOH;
        	
		Cost_Saving__c vCostSavingCOH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH.id];
        
        vCostSavingCOH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        vCostSavingCOH1.COH_Recommendation_Cost__c=10.00;
        update vCostSavingCOH1;
        	
        Cost_Saving__c vCostSavingCOH2 = new Cost_Saving__c();
        vCostSavingCOH2.COH_CSVO_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingCOH2.Area_of_Cost_Savings__c='Imaging';
        vCostSavingCOH2.Description_of_Cost_Savings__c='My Des1';
        vCostSavingCOH2.Local_MD_Treatment_Plan_Cost__c=13.00;
        vCostSavingCOH2.COH_Recommendation_Cost__c=5.13;
        vCostSavingCOH2.Cost_Source__c='My Sour1';
       	insert vCostSavingCOH2;
        	
        Cost_Saving__c vCostSavingCOH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH2.id];
        delete vCostSavingCOH3;
        
        test.stopTest();
    }
		*/
    //for Sysco Evaluation request test update:
   public static testMethod void SumOfCostSavingsTestSY()
    {
        test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sysco Patient').getRecordTypeId();
        
		account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.RecordTypeId = cohrecordtypeid;
        insert Amc;
        	
	 	SY_Evaluation_Request__c SYevalRecord=new SY_Evaluation_Request__c();
        SYevalRecord.Account_Name__c = Amc.ID;
		SYevalRecord.Purpose_of_Call__c='General information';
		SYevalRecord.Cancer_Diagnosis__c='Acute Lymphoblastic Leukemia (ALL)';
		SYevalRecord.ICD_10_Code_s__c='C91.01';
        SYevalRecord.Status__c='Submitted for Review';
		SYevalRecord.Cost_Savings_Added__c=false;
        SYevalRecord.Projected_Savings__c=0;
        SYevalRecord.Program_Cost__c=0;
        SYevalRecord.ROI__c=0.00;
        insert SYevalRecord;
		
        SY_Evaluation_Request__c COHEVReq1=[select id from SY_Evaluation_Request__c where id=:SYevalRecord.id];

        Cost_Saving__c vCostSavingSY = new Cost_Saving__c();
        vCostSavingSY.SY_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingSY.Area_of_Cost_Savings__c='Imaging';
        vCostSavingSY.Description_of_Cost_Savings__c='My Des1';
        vCostSavingSY.Local_MD_Treatment_Plan_Cost__c=12.00;
        vCostSavingSY.COH_Recommendation_Cost__c=9.13;
        vCostSavingSY.Cost_Source__c='My Sour1';
       	insert vCostSavingSY;
        	
		Cost_Saving__c vCostSavingCOH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingSY.id];
        
        vCostSavingCOH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        vCostSavingCOH1.COH_Recommendation_Cost__c=10.00;
        update vCostSavingCOH1;
        	
        Cost_Saving__c vCostSavingCOH2 = new Cost_Saving__c();
        vCostSavingCOH2.SY_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingCOH2.Area_of_Cost_Savings__c='Imaging';
        vCostSavingCOH2.Description_of_Cost_Savings__c='My Des1';
        vCostSavingCOH2.Local_MD_Treatment_Plan_Cost__c=13.00;
        vCostSavingCOH2.COH_Recommendation_Cost__c=5.13;
        vCostSavingCOH2.Cost_Source__c='My Sour1';
       	insert vCostSavingCOH2;
        	
        Cost_Saving__c vCostSavingCOH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH2.id];
        delete vCostSavingCOH3;
        
        test.stopTest();
    }
    
    //for Plymouth Rock Evaluation request test update:
   public static testMethod void SumOfCostSavingsTestPR()
    {
        test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plymouth Rock Patient').getRecordTypeId();
        
		account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.RecordTypeId = cohrecordtypeid;
        insert Amc;
        	
	 	PR_Evaluation_Request__c PRevalRecord=new PR_Evaluation_Request__c();
        PRevalRecord.Account_Name__c = Amc.ID;
		PRevalRecord.Purpose_of_Call__c='General information';
		PRevalRecord.Cancer_Diagnosis__c='Acute Lymphoblastic Leukemia (ALL)';
		PRevalRecord.ICD_10_Code_s__c='C91.01';
        PRevalRecord.Status__c='Submitted for Review';
		PRevalRecord.Cost_Savings_Added__c=false;
        PRevalRecord.Projected_Savings__c=0;
        PRevalRecord.Program_Cost__c=0;
        PRevalRecord.ROI__c=0.00;
        insert PRevalRecord;
		
        PR_Evaluation_Request__c PREVReq1=[select id from PR_Evaluation_Request__c where id=:PRevalRecord.id];

        Cost_Saving__c vCostSavingSY = new Cost_Saving__c();
        vCostSavingSY.PR_Evaluation_Request__c=PREVReq1.id;
        vCostSavingSY.Area_of_Cost_Savings__c='Imaging';
        vCostSavingSY.Description_of_Cost_Savings__c='My Des1';
        vCostSavingSY.Local_MD_Treatment_Plan_Cost__c=12.00;
        vCostSavingSY.COH_Recommendation_Cost__c=9.13;
        vCostSavingSY.Cost_Source__c='My Sour1';
       	insert vCostSavingSY;
        	
		Cost_Saving__c vCostSavingCOH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingSY.id];
        
        vCostSavingCOH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        vCostSavingCOH1.COH_Recommendation_Cost__c=10.00;
        update vCostSavingCOH1;
        	
        Cost_Saving__c vCostSavingCOH2 = new Cost_Saving__c();
        vCostSavingCOH2.PR_Evaluation_Request__c=PREVReq1.id;
        vCostSavingCOH2.Area_of_Cost_Savings__c='Imaging';
        vCostSavingCOH2.Description_of_Cost_Savings__c='My Des1';
        vCostSavingCOH2.Local_MD_Treatment_Plan_Cost__c=13.00;
        vCostSavingCOH2.COH_Recommendation_Cost__c=5.13;
        vCostSavingCOH2.Cost_Source__c='My Sour1';
       	insert vCostSavingCOH2;
        	
        Cost_Saving__c vCostSavingCOH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH2.id];
        delete vCostSavingCOH3;
        
        test.stopTest();
    }
    //for Genentech Evaluation request test update:
   public static testMethod void SumOfCostSavingsTestGR()
    {
        test.startTest();
        Id cohrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Genentech Patient').getRecordTypeId();
        
		account Amc = new account();
        Amc.Firstname = 'testing';
        Amc.Lastname = 'account';
        Amc.PersonBirthdate = date.parse('06/07/2011');
        Amc.PersonEmail = 'testuser@test.com';
        Amc.Referral_Source1__c = 'Optum';
        Amc.RecordTypeId = cohrecordtypeid;
        insert Amc;
        	
	 	GR_Evaluation_Request__c GRevalRecord=new GR_Evaluation_Request__c();
        GRevalRecord.GR_Account__c = Amc.ID;
		GRevalRecord.Purpose_of_Call__c='General information';
		GRevalRecord.Cancer_Diagnosis__c='Acute Lymphoblastic Leukemia (ALL)';
		GRevalRecord.ICD_10_Code_s__c='C91.01';
        GRevalRecord.Status__c='Submitted for Review';
		GRevalRecord.Cost_Savings_Added__c=false;
        GRevalRecord.Projected_Savings__c=0;
        GRevalRecord.Program_Cost__c=0;
        GRevalRecord.ROI__c=0.00;
        insert GRevalRecord;
		
        GR_Evaluation_Request__c COHEVReq1=[select id from GR_Evaluation_Request__c where id=:GRevalRecord.id];

        Cost_Saving__c vCostSavingGR = new Cost_Saving__c();
        vCostSavingGR.GR_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingGR.Area_of_Cost_Savings__c='Imaging';
        vCostSavingGR.Description_of_Cost_Savings__c='My Des1';
        vCostSavingGR.Local_MD_Treatment_Plan_Cost__c=12.00;
        vCostSavingGR.COH_Recommendation_Cost__c=9.13;
        vCostSavingGR.Cost_Source__c='My Sour1';
       	insert vCostSavingGR;
        	
		Cost_Saving__c vCostSavingCOH1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingGR.id];
        
        vCostSavingCOH1.Local_MD_Treatment_Plan_Cost__c=20.00;
        vCostSavingCOH1.COH_Recommendation_Cost__c=10.00;
        update vCostSavingCOH1;
        	
        Cost_Saving__c vCostSavingCOH2 = new Cost_Saving__c();
        vCostSavingCOH2.GR_Evaluation_Request__c=COHEVReq1.id;
        vCostSavingCOH2.Area_of_Cost_Savings__c='Imaging';
        vCostSavingCOH2.Description_of_Cost_Savings__c='My Des1';
        vCostSavingCOH2.Local_MD_Treatment_Plan_Cost__c=13.00;
        vCostSavingCOH2.COH_Recommendation_Cost__c=5.13;
        vCostSavingCOH2.Cost_Source__c='My Sour1';
       	insert vCostSavingCOH2;
        	
        Cost_Saving__c vCostSavingCOH3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingCOH2.id];
        delete vCostSavingCOH3;
        
        test.stopTest();
    } 
    // redbull
    public static testMethod void SumOfCostSavingsTestRB()
    {
        test.startTest();
        Id rbrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RedBull Patient').getRecordTypeId();
        
		account ac = new account();
        ac.Firstname = 'testing';
        ac.Lastname = 'account';
        ac.PersonBirthdate = date.parse('06/07/1993');
        ac.PersonEmail = 'testuser@test2.com';
        ac.RecordTypeId = rbrecordtypeid;
        insert ac;
        Id rbRecTypeId = Schema.SObjectType.RB_Evaluation_Request__c.getRecordTypeInfosByName().get('COE').getRecordTypeId();
        		
	 	RB_Evaluation_Request__c rbEvalRecord=new RB_Evaluation_Request__c();
        rbEvalRecord.RecordTypeId = rbRecTypeId;
        rbEvalRecord.COH_Account__c = ac.ID;
		//rbEvalRecord.Purpose_of_Call__c='General information';
		rbEvalRecord.Cancer_Diagnosis__c='Acute Lymphoblastic Leukemia (ALL)';
        rbEvalRecord.Employer_Program__c = 'test';
		rbEvalRecord.ICD_10_Code_s__c='C91.01';
        rbEvalRecord.Status__c='Submitted for Review';
		rbEvalRecord.Cost_Savings_Added__c=false;
        rbEvalRecord.Projected_Savings__c=0;
        rbEvalRecord.Program_Cost__c=0;
        rbEvalRecord.ROI__c=0.00;
        insert rbEvalRecord;
		
        RB_Evaluation_Request__c rbEVReq1=[select id from RB_Evaluation_Request__c where id=:rbEvalRecord.id];

        Cost_Saving__c vCostSavingMT = new Cost_Saving__c();
        vCostSavingMT.RB_Evaluation_Request__c=rbEVReq1.id;
        vCostSavingMT.Area_of_Cost_Savings__c='Imaging';
        vCostSavingMT.Description_of_Cost_Savings__c='My Des1';
        vCostSavingMT.Local_MD_Treatment_Plan_Cost__c=12.00;
        vCostSavingMT.COH_Recommendation_Cost__c=9.13;
        vCostSavingMT.Cost_Source__c='My Sour1';
       	insert vCostSavingMT;
        	
		Cost_Saving__c vCostSavingMT1=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingMT.id];
        
        vCostSavingMT1.Local_MD_Treatment_Plan_Cost__c=20.00;
        vCostSavingMT1.COH_Recommendation_Cost__c=10.00;
        update vCostSavingMT1;
        	
        Cost_Saving__c vCostSavingMT2 = new Cost_Saving__c();
        vCostSavingMT2.RB_Evaluation_Request__c=rbEVReq1.id;
        vCostSavingMT2.Area_of_Cost_Savings__c='Imaging';
        vCostSavingMT2.Description_of_Cost_Savings__c='My Des1';
        vCostSavingMT2.Local_MD_Treatment_Plan_Cost__c=13.00;
        vCostSavingMT2.COH_Recommendation_Cost__c=5.13;
        vCostSavingMT2.Cost_Source__c='My Sour1';
       	insert vCostSavingMT2;
        	
        Cost_Saving__c vCostSavingMT3=[select id,name,Local_MD_Treatment_Plan_Cost__c,COH_Recommendation_Cost__c from Cost_Saving__c where id=:vCostSavingMT2.id];
        delete vCostSavingMT3;
        
        test.stopTest();
    } 
}