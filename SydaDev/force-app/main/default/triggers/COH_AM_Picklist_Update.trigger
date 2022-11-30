/*
* This trigger processes AM_Account__c object.
* 
* Pradeep Noone
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*/

trigger COH_AM_Picklist_Update on AM_Account__c (before Insert,before update,After Insert) { 
    if(trigger.isBefore && Trigger.isinsert ||trigger.isBefore && Trigger.isUpdate ){
    id APORecordTypeId;
    APORecordTypeId = Schema.SObjectType.AM_Account__c.getRecordTypeInfosByName().get('APO & EAR').getRecordTypeId();
    for(AM_Account__c a:Trigger.new){
        if(a.Salutation__c != null && a.Salutation__c !=''){
            a.Salutation_DB__c = a.Salutation__c;
            a.Salutation__c = '';
        }
        
        if(a.Gender__c != null && a.Gender__c !=''){
            a.Gender_DB__c = a.Gender__c;
            a.Gender__c = '';
        }
        if(a.Relationship_to_the_Insured__c !=null && a.Relationship_to_the_Insured__c !=''){
            a.Relationship_to_the_Insured_DB__c = a.Relationship_to_the_Insured__c;
            a.Relationship_to_the_Insured__c = '';
        }
        if(a.Relationship_to_Employee__c !=null && a.Relationship_to_Employee__c !=''){
            a.Relationship_to_Employee_DB__c = a.Relationship_to_Employee__c;
            a.Relationship_to_Employee__c = '';
        }
        if(a.Preferred_Language_Depreciated__c !=null && a.Preferred_Language_Depreciated__c !=''){
            a.Preferred_Language_Depreciated_DB__c = a.Preferred_Language_Depreciated__c;
            a.Preferred_Language_Depreciated__c = '';
        }
        if(a.Plan_Service__c !=null && a.Plan_Service__c !=null){
            a.Plan_Service_DB__c = a.Plan_Service__c;
            a.Plan_Service__c = '';
        }
        if(a.Employee_Preferred_Phone__c !=null && a.Employee_Preferred_Phone__c !=''){
            a.Employee_Preferred_Phone_DB__c = a.Employee_Preferred_Phone__c;
            a.Employee_Preferred_Phone__c = '';
        }
        if(a.Employee_Gender__c !=null && a.Employee_Gender__c !=''){
            a.Employee_Gender_DB__c = a.Employee_Gender__c;
            a.Employee_Gender__c = '';
        }
      /*  if(a.Employer__c !=null && a.Employer__c !=''){
            a.Employer_DB__c = a.Employer__c;
            a.Employer__c = '';
        } */
        if(a.Plan_Service_DB__c !=null && a.Plan_Service_DB__c !=''){
            a.Benefit_Status__c = 'Enrolled';
        } else {
            a.Benefit_Status__c = 'Non-Enrolled';
        }
       if(a.Date_of_Birth__c !=null ){
                date d=a.Date_of_Birth__c;
        		a.Age__c=d.monthsBetween(System.today())/12;
          }
    }
    }
    
    //id EcenRecordTypeId1 = Schema.SObjectType.AM_Account__c.getRecordTypeInfosByName().get('ECEN Accounts').getRecordTypeId();
    id EcenRecordTypeId = Schema.SObjectType.AM_Evaluation_Request__c.getRecordTypeInfosByName().get('ECEN Evaluation Requests').getRecordTypeId();
        if(trigger.isAfter && Trigger.isInsert)   { 
    List<Am_Evaluation_Request__c> Childs = new List<Am_Evaluation_Request__c>(); 
    
   for(AM_Account__c aa : trigger.new)
    {
        if(aa.HDP_Parent_ID__c != null ){
       Am_Evaluation_Request__c Child = new Am_Evaluation_Request__c ();
       child.AM_Account__c =aa.id;
       Child.Mailing_Street__c =aa.Mailing_Street__c;
       child.Other_Pertinent_Medical_Information__c = aa.Other_Pertinent_Medical_Information__c;
       child.RecordTypeId  = EcenRecordTypeId;
       //child.COH_AM_Current_Status__c = 'New Request Submitted';
       Childs.add(Child);     
    }
    insert Childs;
    }
        }
    
}