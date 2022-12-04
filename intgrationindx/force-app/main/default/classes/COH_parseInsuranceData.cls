public class COH_parseInsuranceData {
    
    public Static void deserializeData(String response){
        // String response = '{"COH_MRN__c":"55103277","Salution":"","Patient_Suffix__c":"","FirstName":"PATFOURTWO","LastName":"PBTD","PersonBirthdate":"1942-01-01","COH_Account_PatientAccess_SSN__C":"133-53-3335","Gender__pc":"Male","Patient_Street1__C":"42 TEST ST","Patient_City__c":"TORRANCE","COH_PA_State__C":"California","Patient_Postal_Code__c":"90504","COH_PA_Country__c":"United States of America","PersonHomePhone":"(555)555-0042","PersonMobilePhone":"(626)444-7676","PersonOtherPhone":"(714)233-3434","PersonEmail":"tdrissel@coh.org","COH_Account_PatientAccess_Marital_Status__C":"Married","Preferred_Language__C":"Decline to Answer","COH_Account_PatientAccess_Countryoforigi__c":"United States of America","COH_Account_PatientAccess_Alias__c":"","Ethnicity__c":"Decline to Answer","Race__c":"Decline to Answer","Religion__c":"Baptist","Emergency_Contact_Name__c":"PATFOURTWOC PBTD","Relationship_to_Patient__c":"Spouse","COH_Account_EC_PatientAccess_HomePhone__c":"(555)555-0042","COH_Account_EC_PatientAccess_WorkPhone__c":"(666)666-9898","COH_Account_EC_PatientAccess_MobilePhone__c":"(777)777-8787","COH_Account_PatientAccess_EmployerName__c":"AMGEN","COH_Account_PatientAccess_EmployerAddres__c":"1 AMGEN CENTER DR","COH_Account_PatientAccess_EmployerCity__c":"THOUSAND OAKS","COH_Account_PatientAccess_EmployerState__c":"California","COH_Account_PatientAccess_EmployerZip__c":"91320","COH_Account_PatientAccess_EmployerCountr__c":"United States of America","COH_Account_PatientAccess_Employment_St__c":"Retired","COH_Account_PatientAccess_Occupation__c":"","COH_Account_PatientAccess_EmploymentDate__c":"","COH_Account_PatientAccess_Employee_ID__c":"0","COH_Account_EMP_PatientAccess_Phone__c":"(805)447-1000","Epic_Referring_Doctor_Provider_Id__c":"1007412","Epic_Orig_Referring_Doctor_Provider_Id__c":"","Guarantor":[{"Guarantor_Id":"551","Guarantor_FirstName":"PATFOURTWO","Guarantor_MiddleName":"","Guarantor_LastName":"PBTD","Guarantor_DateOfBirth":"1942-01-01","Guarantor_Gender":"Male","Guarantor_Street__c":"42 TEST ST","Guarantor_City__c":"TORRANCE","Guarantor_State__c":"California","Guarantor_PostalCode__c":"90504","Guarantor_Country__c":"United States of America","Guarantor_Home_Phone__c":"(555)555-0042","Guarantor_Mobile_Phone__c":"","Guarantor_SSN__c":"133-53-3335","Guarantor_Patient_Relationship_to__c":"Self","Guarantor_Type__c":"Personal/Family"}],"Insurance":[{"Payor_Id__c":"308002254","Payor_Name__c":"MEDICARE","Subscriber_ID__c":"AJC908478390","Subscriber_Name__c":"PATFOURTWO PBTD","Insurance_SSN__c":"133-53-3335","Insurance_Gender__c":"Male","Insurance_Birth_Date__c":"1942-01-01","Insurance_Street__c":"42 TEST ST","Insurance_City__c":"TORRANCE","Insurance_State__c":"California","Insurance_PostalCode__c":"90504","Insurance_Country__c":"United States of America","Group_Number__c":"E0001001","Patient_Relationship_to_Subscriber__c":"Self","PlanType":"HMO"},{"Payor_Id__c":"308002202","Payor_Name__c":"AETNA","Subscriber_ID__c":"A62345234","Subscriber_Name__c":"PATFOURTWO PBTD","Insurance_SSN__c":"133-53-3335","Insurance_Gender__c":"Male","Insurance_Birth_Date__c":"1942-01-01","Insurance_Street__c":"42 TEST ST","Insurance_City__c":"TORRANCE","Insurance_State__c":"California","Insurance_PostalCode__c":"90504","Insurance_Country__c":"United States of America","Group_Number__c":"AG23463453","Patient_Relationship_to_Subscriber__c":"Self"},{"Payor_Id__c":"308002219","Payor_Name__c":"CIGNA","Subscriber_ID__c":"C234432234","Subscriber_Name__c":"PATFOURTWO PBTD","Insurance_SSN__c":"133-53-3335","Insurance_Gender__c":"Male","Insurance_Birth_Date__c":"1942-01-01","Insurance_Street__c":"42 TEST ST","Insurance_City__c":"TORRANCE","Insurance_State__c":"California","Insurance_PostalCode__c":"90504","Insurance_Country__c":"United States of America","Group_Number__c":"CG234234","Patient_Relationship_to_Subscriber__c":"Self"}]}';
        //response = '{"COH_MRN__c":"55103277","Salution":"","Patient_Suffix__c":"","FirstName":"PATFOURTWO","LastName":"PBTD","PersonBirthdate":"1942-01-01","COH_Account_PatientAccess_SSN__C":"133-53-3335","Gender__pc":"Male","Patient_Street1__C":"42 TEST ST","Patient_City__c":"TORRANCE","COH_PA_State__C":"California","Patient_Postal_Code__c":"90504","COH_PA_Country__c":"United States of America","PersonHomePhone":"(555)555-0042","PersonMobilePhone":"(626)444-7676","PersonOtherPhone":"(714)233-3434","PersonEmail":"tdrissel@coh.org","COH_Account_PatientAccess_Marital_Status__C":"Married","Preferred_Language__C":"Decline to Answer","COH_Account_PatientAccess_Countryoforigi__c":"United States of America","COH_Account_PatientAccess_Alias__c":"","Ethnicity__c":"Decline to Answer","Race__c":"Decline to Answer","Religion__c":"Baptist","Emergency_Contact_Name__c":"PATFOURTWOC PBTD","Relationship_to_Patient__c":"Spouse","COH_Account_EC_PatientAccess_HomePhone__c":"(555)555-0042","COH_Account_EC_PatientAccess_WorkPhone__c":"(666)666-9898","COH_Account_EC_PatientAccess_MobilePhone__c":"(777)777-8787","COH_Account_PatientAccess_EmployerName__c":"AMGEN","COH_Account_PatientAccess_EmployerAddres__c":"1 AMGEN CENTER DR","COH_Account_PatientAccess_EmployerCity__c":"THOUSAND OAKS","COH_Account_PatientAccess_EmployerState__c":"California","COH_Account_PatientAccess_EmployerZip__c":"91320","COH_Account_PatientAccess_EmployerCountr__c":"United States of America","COH_Account_PatientAccess_Employment_St__c":"Retired","COH_Account_PatientAccess_Occupation__c":"","COH_Account_PatientAccess_EmploymentDate__c":"","COH_Account_PatientAccess_Employee_ID__c":"0","COH_Account_EMP_PatientAccess_Phone__c":"(805)447-1000","Epic_Referring_Doctor_Provider_Id__c":"1007412","Epic_Orig_Referring_Doctor_Provider_Id__c":"","Guarantor":[{"Guarantor_Id":"551","Guarantor_FirstName":"PATFOURTWO","Guarantor_MiddleName":"","Guarantor_LastName":"PBTD","Guarantor_DateOfBirth":"1942-01-01","Guarantor_Gender":"Male","Guarantor_Street__c":"42 TEST ST","Guarantor_City__c":"TORRANCE","Guarantor_State__c":"California","Guarantor_PostalCode__c":"90504","Guarantor_Country__c":"United States of America","Guarantor_Home_Phone__c":"(555)555-0042","Guarantor_Work_Phone__c":"","Guarantor_Mobile_Phone__c":"","Guarantor_SSN__c":"133-53-3335","Guarantor_Patient_Relationship_to__c":"Self","Guarantor_Type__c":"Personal/Family"}],"Insurance":[{"Payor":{"Insurance_Payor_Id__c":"308002254","Insurance_Payor_Name__c":"MEDICARE"},"PurchaserPlan":{"Insurance_Plan_ID__c":"a","Insurance_Plan_Name__c":"a","Insurance_Plan_Type_1__c":"HMO"},"MemberPlan":{"Subscriber_ID__c":"","Group_Number__c":"E0001001","Insurance_Member_Plan_eff_from_1__c":"2022-04-08","Insurance_Member_Plan_eff_to_1__c":"2022-04-08","VerificationStatus__c":"a"},"Subscriber":{"Insurance_Subscriber_First_Name_1__c":"PATFOURTWO","Insurance_Subscriber_Middle_Name_1__c":"MiddleName","Insurance_Subscriber_Last_Name_1__c":"PBTD","Insurance_SSN__c":"133-53-3335","Insurance_Gender__c":"Male","Insurance_Birth_Date__c":"1942-01-01","Insurance_Street__c":"42 TEST ST","Insurance_City__c":"TORRANCE","Insurance_State__c":"California","Insurance_PostalCode__c":"90504","Insurance_Country__c":"United States of America","Patient_Relationship_to_Subscriber__c":"Self","Subscriber_1_Source_ID_From_Epic__c":"786452"}}]}';
        
        Map<String,Object> insuranceObject = (Map<String,Object>)JSON.deserializeUntyped(response);
        String cohMRN = (String)insuranceObject.get('COH_MRN__c') ;
        String OriginalcohMRN = (String)insuranceObject.get('COH_Original_MRN__c') ;
        String triggerEvent = (String)insuranceObject.get('Trigger_Event__c') ;
        System.debug('cohMRN'+cohMRN);
        Id IIrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Patient_Screen_Unification').getRecordTypeId();
        Id householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesHousehold').getRecordTypeId();
        List<Account> accRecord = new List<Account>();//'0017900000CpOU6AAN' ]);
        
        
        //System.debug(cohMRN!=null)
        if(String.isNotBlank(cohMRN)){
            accRecord =  [Select id,HealthCloudGA__SourceSystem__pc from Account where COH_MRN__c =: cohMRN];
        }
        
        Boolean skipProcess = false;
        
        
        //upsert Paitent info if MRN number is not found in the system
        Account inx = new Account();
        if(!accRecord.isEmpty()){
            inx.Id = accRecord[0].Id;
        }else{
            inx.RecordTypeId = IIrecordTypeId;
            inx.COH_MRN__c = cohMRN;
            
        } 
        System.debug('accRecord'+accRecord);
        if(triggerEvent == 'A28'){
            if(!accRecord.isEmpty()){
                inx.HealthCloudGA__SourceSystem__pc = 'Salesforce';
                skipProcess = true;
            }else{
                inx.HealthCloudGA__SourceSystem__pc = 'Epic';
                skipProcess= false;
            }
        }
        if(triggerEvent == 'A31'){
            if(!accRecord.isEmpty()){
                if(accRecord[0].HealthCloudGA__SourceSystem__pc == 'Epic'){
                    
                }else if(accRecord[0].HealthCloudGA__SourceSystem__pc == 'Salesforce'){
                    String preffLang = (String)insuranceObject.get('Preferred_Language__C');
                    String contactName = (String)insuranceObject.get('Emergency_Contact_Name__c');
                    if(preffLang == null || contactName == null){
                        skipProcess = true;
                    }
                    inx.HealthCloudGA__SourceSystem__pc = 'Epic';
                }
            }else{
                inx.HealthCloudGA__SourceSystem__pc = 'Epic';
            }
        }
        System.debug('skipProcess'+skipProcess);
        if(skipProcess){
            upsert inx;
        }else{
            
            
            
            //inx.Salutation = (String)insuranceObject.get('Salution') ;
            inx.Patient_Suffix__c = (String)insuranceObject.get('Patient_Suffix__c') ;
            inx.FirstName = (String)insuranceObject.get('FirstName') ;
            inx.MiddleName = (String)insuranceObject.get('MiddleName');
            inx.LastName = (String)insuranceObject.get('LastName');
            inx.COH_Account_PatientAccess_SSN__C = (String)insuranceObject.get('COH_Account_PatientAccess_SSN__C') ;
            inx.Gender__pc = (String)insuranceObject.get('Gender__pc');
            inx.Patient_Street1__c = (String)insuranceObject.get('Patient_Street1__C');
            inx.Patient_City__c  = (String)insuranceObject.get('Patient_City__c') ;
            inx.COH_PA_State__C  = (String)insuranceObject.get('COH_PA_State__C');
            inx.Patient_Postal_Code__c  = (String)insuranceObject.get('Patient_Postal_Code__c');
            inx.COH_PA_Country__c   = (String)insuranceObject.get('COH_PA_Country__c');
            inx.PersonHomePhone = (String)insuranceObject.get('PersonHomePhone');
            inx.PersonMobilePhone  = (String)insuranceObject.get('PersonMobilePhone') ;
            inx.PersonOtherPhone  = (String)insuranceObject.get('PersonOtherPhone');
            inx.COH_Account_PatientAccess_Marital_Status__C  = (String)insuranceObject.get('COH_Account_PatientAccess_Marital_Status__C');
            inx.Preferred_Language__C   = (String)insuranceObject.get('Preferred_Language__C');
            inx.COH_Account_PatientAccess_Countryoforigi__c  = (String)insuranceObject.get('COH_Account_PatientAccess_Countryoforigi__c');
            inx.COH_Account_PatientAccess_Alias__c    = (String)insuranceObject.get('COH_Account_PatientAccess_Alias__c');
            
            inx.Ethnicity__c = (String)insuranceObject.get('Ethnicity__c');
            inx.Religion__c  = (String)insuranceObject.get('Religion__c') ;
            inx.Emergency_Contact_Name__c  = (String)insuranceObject.get('Emergency_Contact_Name__c');
            inx.Relationship_to_Patient__c  = (String)insuranceObject.get('Relationship_to_Patient__c');
            inx.COH_Account_EC_PatientAccess_HomePhone__c   = (String)insuranceObject.get('COH_Account_EC_PatientAccess_HomePhone__c');
            inx.COH_Account_EC_PatientAccess_WorkPhone__c = (String)insuranceObject.get('COH_Account_EC_PatientAccess_WorkPhone__c');
            inx.COH_Account_EC_PatientAccess_MobilePhone__c  = (String)insuranceObject.get('COH_Account_EC_PatientAccess_MobilePhone__c') ;
            inx.COH_Account_PatientAccess_EmployerName__c  = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerName__c');
            inx.COH_Account_PatientAccess_EmployerAddres__c  = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerAddres__c');
            inx.COH_Account_PatientAccess_EmployerCity__c   = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerCity__c');
            inx.COH_Account_PatientAccess_EmployerState__c  = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerState__c');
            inx.COH_Account_PatientAccess_EmployerZip__c    = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerZip__c');
            inx.COH_Account_PatientAccess_EmployerCountr__c  = (String)insuranceObject.get('COH_Account_PatientAccess_EmployerCountr__c') ;
            inx.COH_Account_PatientAccess_Employment_St__c  = (String)insuranceObject.get('COH_Account_PatientAccess_Employment_St__c');
            //inx.COH_Account_PatientAccess_EmploymentDate__c  = (Date)insuranceObject.get('COH_Account_PatientAccess_EmploymentDate__c');
            //inx.COH_Account_PatientAccess_Employee_ID__c   = (Integer)insuranceObject.get('COH_Account_PatientAccess_Employee_ID__c');
            inx.COH_Account_EMP_PatientAccess_Phone__c = (String)insuranceObject.get('COH_Account_EMP_PatientAccess_Phone__c');
            
            Account houseHoldRecord = new Account();
            houseHoldRecord.RecordTypeId = householdRecordTypeId;
            houseHoldRecord.Name = (String)insuranceObject.get('LastName');
            
            Account personAccount;
            if(!accRecord.isEmpty()){
                personAccount = [SELECT Id, PersonContactId FROM Account WHERE ID =: inx.id LIMIT 1];
                
                List<sObject> deleteTheseRecords = new List<sObject>();
                List<Account> guarantor = new List<Account>([Select id from Account where Patient_Account__c =: inx.Id]);
                List<MemberPlan> memberPlan = new List<MemberPlan>([Select id,PlanId,SubscriberId,PayerId from MemberPlan where MemberId = : inx.Id]);
                List<HealthCloudGA__ContactContactRelation__c> contactRelationList = new List<HealthCloudGA__ContactContactRelation__c>([Select id from HealthCloudGA__ContactContactRelation__c where HealthCloudGA__RelatedContact__c  = : personAccount.PersonContactId]);
                
                List<Id> planId = new List<Id>();
                List<Id> subscriberOrPayerId = new List<Id>();
                // delete parentOfMemberPlan;
                for(MemberPlan recordMember :memberPlan){
                    planId.add(recordMember.planId);
                    subscriberOrPayerId.add(recordMember.SubscriberId);
                    subscriberOrPayerId.add(recordMember.PayerId);
                }
                
                deleteTheseRecords.addAll([Select id from AccountContactRelation where ContactId =: personAccount.PersonContactId])  ;
                deleteTheseRecords.addAll([Select id from HealthCloudGA__ContactContactRelation__c  where HealthCloudGA__RelatedContact__c =: personAccount.PersonContactId])  ;
               // deleteTheseRecords.addAll([Select id from PurchaserPlan where id in :planId ])  ;
                //deleteTheseRecords.addAll([Select id from Account where id in :subscriberOrPayerId ])  ;
                deleteTheseRecords.addAll(contactRelationList)  ;
               // deleteTheseRecords.addAll(memberPlan)  ;
               // deleteTheseRecords.addAll(guarantor)  ;
                
                Database.delete(deleteTheseRecords,false);
            }
            
            if(String.isNotBlank(OriginalcohMRN)){
                List<Account> originalAccount = new List<Account>([Select id,PersonContactId from Account where COH_MRN__c = :OriginalcohMRN]);
                if(!originalAccount.isEmpty()){
                    List<sObject> deleteTheseRecords = new List<sObject>();
                    List<Account> guarantor = new List<Account>([Select id from Account where Patient_Account__c =: originalAccount[0].Id]);
                    List<MemberPlan> memberPlan = new List<MemberPlan>([Select id,PlanId,SubscriberId,PayerId from MemberPlan where MemberId = : originalAccount[0].Id]);
                    List<HealthCloudGA__ContactContactRelation__c> contactRelationList = new List<HealthCloudGA__ContactContactRelation__c>([Select id from HealthCloudGA__ContactContactRelation__c where HealthCloudGA__RelatedContact__c  = : originalAccount[0].PersonContactId]);
                    
                    List<Id> planId = new List<Id>();
                    List<Id> subscriberOrPayerId = new List<Id>();
                    // delete parentOfMemberPlan;
                    for(MemberPlan recordMember :memberPlan){
                        planId.add(recordMember.planId);
                        subscriberOrPayerId.add(recordMember.SubscriberId);
                        subscriberOrPayerId.add(recordMember.PayerId);
                    }
                    deleteTheseRecords.addAll([Select id from AccountContactRelation where ContactId =: originalAccount[0].PersonContactId])  ;
                    deleteTheseRecords.addAll([Select id from HealthCloudGA__ContactContactRelation__c  where HealthCloudGA__RelatedContact__c =: originalAccount[0].PersonContactId])  ;
                    deleteTheseRecords.addAll([Select id from PurchaserPlan where id in :planId ])  ;
                    deleteTheseRecords.addAll([Select id from Account where id in :subscriberOrPayerId ])  ;
                    deleteTheseRecords.addAll(contactRelationList)  ;
                    deleteTheseRecords.addAll(memberPlan)  ;
                    deleteTheseRecords.addAll(guarantor)  ;
                    deleteTheseRecords.addAll(originalAccount)  ;
                    Database.delete (deleteTheseRecords,false);
                    
                }
            }
            
            
            upsert inx;
            insert houseHoldRecord;
            
            
            
            
            if(personAccount == null)
                personAccount = [SELECT Id, PersonContactId FROM Account WHERE ID =: inx.id LIMIT 1];
            HealthCloudGA__ReciprocalRole__c orgianlReferDoc = [SELECT Id, Name,HealthCloudGA__CreateInverseRole__c FROM HealthCloudGA__ReciprocalRole__c WHERE Name ='Orginal Referring doctor' and HealthCloudGA__CreateInverseRole__c = true LIMIT 1];
            HealthCloudGA__ReciprocalRole__c refrealDoc = [SELECT Id, Name,HealthCloudGA__CreateInverseRole__c FROM HealthCloudGA__ReciprocalRole__c WHERE Name ='Referring doctor' and HealthCloudGA__CreateInverseRole__c = true LIMIT 1];
            HealthCloudGA__ReciprocalRole__c guarantorDoc = [SELECT Id, Name,HealthCloudGA__CreateInverseRole__c FROM HealthCloudGA__ReciprocalRole__c WHERE Name ='Guarantor' and HealthCloudGA__CreateInverseRole__c = true LIMIT 1];
            HealthCloudGA__ReciprocalRole__c subscriberDoc = [SELECT Id, Name,HealthCloudGA__CreateInverseRole__c FROM HealthCloudGA__ReciprocalRole__c WHERE Name ='Subscriber' and HealthCloudGA__CreateInverseRole__c = true LIMIT 1];
            
            
            AccountContactRelation relateHousehold = new AccountContactRelation();
            relateHousehold.AccountId = houseHoldRecord.Id;
            relateHousehold.ContactId = personAccount.PersonContactId;
            insert relateHousehold;
            System.debug('inx: '+inx.Id);
            //Referring_Doctor
            List<HealthCloudGA__ContactContactRelation__c> accountContact = new List<HealthCloudGA__ContactContactRelation__c>();
            String referringDoc = (String)insuranceObject.get('Referring_Physician_NPI__C') ;
            String origReferringDoc = (String)insuranceObject.get('Original_Referring_Physician_NPI__C');
            system.debug('referringDoc'+ referringDoc);
            system.debug('origReferringDoc'+ origReferringDoc);
            List<String> npiNo = new List<String>{referringDoc,origReferringDoc};
                
                Map<String,Contact> npiNoMap = new Map<String,Contact>();
            for(contact inr :[Select id,NPI_NO__c from Contact where NPI_NO__c in :npiNo]){
                npiNoMap.put(inr.NPI_NO__c,inr);
            }
            
            for(String record : npiNo){
                HealthCloudGA__ContactContactRelation__c  accountRecord = new HealthCloudGA__ContactContactRelation__c ();
                //refreal doctor
                if(String.isNotBlank(referringDoc)){
                    accountRecord.HealthCloudGA__Contact__c   = npiNoMap.get(record).Id;
                    accountRecord.HealthCloudGA__RelatedContact__c   = personAccount.PersonContactId;
                    accountRecord.HealthCloudGA__Role__c    = refrealDoc.Id;
                    accountContact.add(accountRecord);
                    referringDoc = null;
                }
                //orginal refal doctor 
                else if(String.isNotBlank(origReferringDoc)){
                    accountRecord.HealthCloudGA__Contact__c   = npiNoMap.get(record).Id;
                    accountRecord.HealthCloudGA__RelatedContact__c   = personAccount.PersonContactId;
                    accountRecord.HealthCloudGA__Role__c  = orgianlReferDoc.Id; 
                    accountContact.add(accountRecord); 
                    origReferringDoc = null;
                    
                }
                
            }
            if(!accountContact.isEmpty()){
                insert accountContact;
            }
            
            /** create Guarantor**/
            
            List<Account> guarantorList = new List<Account>();
            Id GuarantorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Guarantor').getRecordTypeId();
            List<Object> guarantorData = (List<Object>)insuranceObject.get('Guarantor');
            if(guarantorData != null){
                List<String> gurantorIds = new list<String>();
                Map<String,Account> guarantormap = new Map<String,Account>();
                for(Object inr : guarantorData){
                    Map<String,Object> ind=(Map<String,Object>) inr;   
                    String gurantorid = (String)ind.get('Guarantor_Id');
                    if(String.isNotblank(gurantorid)){
                        gurantorIds.add(gurantorid);
                    }
                }
                if(!gurantorIds.isEmpty()){
                    for(Account inr :[Select id,HealthCloudGA__SourceSystemId__c from Account where HealthCloudGA__SourceSystemId__c in :gurantorIds]){
                        guarantormap.put(inr.HealthCloudGA__SourceSystemId__c.trim(),inr);
                    }
                }
                for(Object inr : guarantorData){
                    Account record = new Account();
                    Map<String,Object> ind=(Map<String,Object>) inr;  
                    String gurantorid = (String)ind.get('Guarantor_Id');
                    if(gurantorid!=null && guarantormap.containskey(gurantorid.trim())){
                        record.Id = guarantormap.get(gurantorid.trim()).Id;
                    }
                    record.Patient_Account__c = inx.Id;
                    record.RecordTypeId = GuarantorRecordTypeId;
                    
                    record.HealthCloudGA__SourceSystemId__c= (String)ind.get('Guarantor_Id');

                    record.FirstName= (String)ind.get('Guarantor_FirstName');
                    record.LastName= (String)ind.get('Guarantor_LastName');
                    record.Gender__pc = (String)ind.get('Guarantor_Gender');
                    record.BillingStreet= (String)ind.get('Guarantor_Street__c');
                    record.BillingCity = (String)ind.get('Guarantor_City__c');
                    record.BillingState = (String)ind.get('Guarantor_State__c');
                    record.BillingPostalCode= (String)ind.get('Guarantor_PostalCode__c');
                    record.BillingCountry = (String)ind.get('Guarantor_Country__c');
                    //record.Birthdate = (String)ind.get('Guarantor_DateOfBirth');
                    if(ind.get('Guarantor_DateOfBirth')!=null && ind.get('Guarantor_DateOfBirth')!= ''){
                        record.PersonBirthdate   = Date.valueOf(String.valueOf(ind.get('Guarantor_DateOfBirth')));
                    }
                     
                    record.PersonHomePhone = (String)ind.get('Guarantor_Home_Phone__c');
                    record.PersonMobilePhone= (String)ind.get('Guarantor_Mobile_Phone__c');
                    record.Work_Phone_Number__pc= (String)ind.get('Guarantor_Work_Phone__c');
                    record.COH_Account_PatientAccess_SSN__c= (String)ind.get('Guarantor_SSN__c');
                    record.Relationship_to_Patient__c= (String)ind.get('Guarantor_Patient_Relationship_to__c');
                    //record.Guarantor_Type__c= (String)ind.get('Guarantor_Type__c'); **ASK LARRY
                    record.Account_Type__c= (String)ind.get('Guarantor_Type__c'); 

                    
                    
                    guarantorList.add(record);
                }
                if(!guarantorList.isEmpty())
                upsert guarantorList;
            }
            List<Account> guarantorPersonAccount = [Select id,personContactId from account where id in:guarantorList];
            system.debug('Healthcloud Role' +guarantorDoc.Id);
            List<HealthCloudGA__ContactContactRelation__c> guarantorAccount = new List<HealthCloudGA__ContactContactRelation__c>();
            for(Account record : guarantorPersonAccount){
                HealthCloudGA__ContactContactRelation__c  accountRecord = new HealthCloudGA__ContactContactRelation__c ();
                accountRecord.HealthCloudGA__Contact__c   = record.personContactId;
                accountRecord.HealthCloudGA__RelatedContact__c   = personAccount.PersonContactId;
                accountRecord.HealthCloudGA__Role__c  = guarantorDoc.Id;
                guarantorAccount.add(accountRecord);
            }
            
            if(!guarantorAccount.isEmpty()){
                insert guarantorAccount;
            }
            
            system.debug('guarantorList'+guarantorList);
            
            Id IndustriesPayerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesPayer').getRecordTypeId();
            Id IndustriesSubscriberRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Subscriber').getRecordTypeId();
            
            /** create Insurance/Member Plan**/
            
            List<MemberPlan> MemberPlanList = new List<MemberPlan>();
            List<Object> insuranceData = (List<Object>)insuranceObject.get('Insurance');
            List<sObject> payorRecords = new List<sObject>();
            List<sObject> subscriberRecords = new List<sObject>();
            
            
            System.debug('OUTSIDE INSURANCE DATA OUTSIDE');
            if(insuranceData!= null){
                System.debug('OUTSIDE INSURANCE DATA INSIDE');
                List<String> insurancePayorId = new List<String>();
                List<String> insurancePlanList = new list<String>();
                List<String> subscriberList = new list<String>();
                List<String> memberPlanIdList = new list<String>();
                Map<String,PurchaserPlan> purchaserMap = new Map<String,PurchaserPlan>();
                Map<String,Account> payorIdAccountMap = new Map<String,Account>();
                Map<String,Account> subscriberAccountMap = new Map<String,Account>();
                Map<String,MemberPlan> MemberPlanMap = new Map<String,MemberPlan>();
                for(Object inr : insuranceData){
                    Map<String,Object> ind = (Map<String,Object>)inr;
                    Map<String,Object> payorData = (Map<String,Object>)ind.get('Payor');
                    String payorId = (String)payorData.get('Insurance_Payor_Id__c');
                    System.debug('payorId'+payorId);
                    if(String.isNotBlank(payorId)){
                        insurancePayorId.add(payorId);
                    } 
                    
                    Map<String,Object> purchaserPlanData = (Map<String,Object>)ind.get('PurchaserPlan');
                    system.debug(purchaserPlanData);
                    String insurancePlanId = (String)purchaserPlanData.get('Insurance_Plan_ID__c');
                    if(insurancePlanId!=null){
                        insurancePlanList.add(insurancePlanId);
                    }
                    
                    Map<String,Object> subscriberData = (Map<String,Object>)ind.get('Subscriber');
                    String subscriberId = (String)subscriberData.get('Subscriber_1_Source_ID_From_Epic__c');
                    if(String.isNotBlank(subscriberId)){
                        subscriberList.add(subscriberId);
                    }
                    
                    Map<String,Object> memberPlanData = (Map<String,Object>)ind.get('MemberPlan');
                    String memberPlanId = (String)memberPlanData.get('MemberPlan_1_Source_ID_From_Epic__c');
                    if(String.isNotBlank(memberPlanId)){
                        memberPlanIdList.add(memberPlanId);
                    }
                }
                
                if(!insurancePayorId.isEmpty()){
                    for(Account inr :[Select id,HealthCloudGA__SourceSystemId__c from Account where HealthCloudGA__SourceSystemId__c in :insurancePayorId or HealthCloudGA__SourceSystemId__c in :subscriberList]){
                        if(insurancePayorId.contains(inr.HealthCloudGA__SourceSystemId__c.trim()))
                            payorIdAccountMap.put(inr.HealthCloudGA__SourceSystemId__c.trim(),inr);
                        if(subscriberList.contains(inr.HealthCloudGA__SourceSystemId__c.trim()))
                            subscriberAccountMap.put(inr.HealthCloudGA__SourceSystemId__c.trim(),inr);
                    }
                }
                if(!insurancePlanList.isEmpty()){
                    for(PurchaserPlan record : [Select id,SourceSystemIdentifier from PurchaserPlan where SourceSystemIdentifier in:insurancePlanList]){
                        purchaserMap.put(record.SourceSystemIdentifier,record);
                    }
                }
                if(!memberPlanIdList.isEmpty()){
                    for(MemberPlan record : [Select id,SourceSystemIdentifier from MemberPlan where SourceSystemIdentifier in:memberPlanIdList]){
                        MemberPlanMap.put(record.SourceSystemIdentifier,record);
                    } 
                }
                //Payor
                for(Object inr : insuranceData){
                    Map<String,Object> ind = (Map<String,Object>)inr;
                    list<sObject> insuranceRecords = new List<sObject>();
                    
                    Map<String,Object> payorData = (Map<String,Object>)ind.get('Payor');
                    String payorId = (String)payorData.get('Insurance_Payor_Id__c');
                    Account record = new Account();
                    System.debug('payorIdAccountMap'+payorIdAccountMap);
                    System.debug('payorId'+payorId);
                    if(String.isNotBlank(payorId) && payorIdAccountMap.containsKey(payorId)){
                        System.debug('ID: '+ payorIdAccountMap.get(payorId).Id);
                        record.Id = payorIdAccountMap.get(payorId).Id;
                    }
                    
                    record.Name= (String)payorData.get('Insurance_Payor_Name__c');
                    record.RecordTypeId = IndustriesPayerRecordTypeId;
                    record.HealthCloudGA__SourceSystemId__c = (String)payorData.get('Insurance_Payor_Id__c');   
                    record.BillingStreet  = (String)payorData.get('Insurance_Payor_Street__c'); 
                    record.BillingCity = (String)payorData.get('Insurance_Payor_City__c');  
                    record.BillingState = (String)payorData.get('Insurance_Payor_State__c');    
                    record.BillingPostalCode= (String)payorData.get('Insurance_Payor_PostalCode__c');   
                    record.BillingCountry = (String)payorData.get('Insurance_Payor_Country__c');    
                    record.Phone  = (String)payorData.get('Insurance_Payor_Phone__c');  
 
                    insuranceRecords.add(record);
                    
                    //Subscriber
                    Map<String,Object> subscriberData = (Map<String,Object>)ind.get('Subscriber');
                    Account Subscriber = new Account();
                    String subscriberId = (String)subscriberData.get('Subscriber_ID__c');
                    if(subscriberId!=null && subscriberAccountMap.containskey(subscriberId)){
                        Subscriber.Id = subscriberAccountMap.get(subscriberId).Id;
                    }
                    //Subscriber.Patient_Account__c =  inx.Id;
                    Subscriber.FirstName = (String)subscriberData.get('Insurance_Subscriber_First_Name_1__c') ;
                    Subscriber.MiddleName  = (String)subscriberData.get('Insurance_Subscriber_Middle_Name_1__c') ;
                    Subscriber.LastName = (String)subscriberData.get('Insurance_Subscriber_Last_Name_1__c') ;
                    Subscriber.RecordTypeId = IndustriesSubscriberRecordTypeId;
                    Subscriber.COH_Account_PatientAccess_SSN__c = (String)subscriberData.get('Insurance_SSN__c');
                    Subscriber.Gender__pc = (String)subscriberData.get('Insurance_Gender__c');
                    Subscriber.BillingStreet = (String)subscriberData.get('Insurance_Street__c');
                    Subscriber.BillingCity = (String)subscriberData.get('Insurance_City__c');
                    Subscriber.BillingState = (String)subscriberData.get('Insurance_State__c');
                    Subscriber.BillingPostalCode = (String)subscriberData.get('Insurance_PostalCode__c');
                    //Subscriber.BillingCountry = (String)subscriberData.get('Insurance_City__c');
                    Subscriber.Relationship_to_Patient__c = (String)subscriberData.get('Patient_Relationship_to_Subscriber__c');
                    //Subscriber.PersonBirthdate = (String)subscriberData.get('Insurance_Birth_Date__c');
                    if(subscriberData.get('Insurance_Birth_Date__c')!=null && subscriberData.get('Insurance_Birth_Date__c')!= ''){
                        Subscriber.PersonBirthdate   = Date.valueOf(String.valueOf(subscriberData.get('Insurance_Birth_Date__c')));
                    }
                    Subscriber.HealthCloudGA__SourceSystemId__c = (String)subscriberData.get('Subscriber_1_Source_ID_From_Epic__c');

                  
                    insuranceRecords.add(Subscriber);
                    
                    upsert insuranceRecords;
                    payorRecords.add(insuranceRecords[0]);
                    subscriberRecords.add(insuranceRecords[1]);
                    
                    //plan
                    
                    Map<String,Object> purchaserPlanData = (Map<String,Object>)ind.get('PurchaserPlan');
                    PurchaserPlan purchaser = new PurchaserPlan();
                    purchaser.Name = (String)purchaserPlanData.get('Insurance_Plan_Name__c');
                    purchaser.PlanType = (String)purchaserPlanData.get('Insurance_Plan_Type_1__c');
                    purchaser.SourceSystemIdentifier = (String)purchaserPlanData.get('Insurance_Plan_ID__c');
                    purchaser.PayerId = record.Id;
                    
                    String insurancePlanId = (String)purchaserPlanData.get('Insurance_Plan_ID__c');
                    system.debug('insurancePlanId'+ insurancePlanId);
                    system.debug('purchaserMap'+ purchaserMap);
                    
                    if(purchaserMap.containskey(insurancePlanId)){
                        purchaser.id = purchaserMap.get(insurancePlanId).Id;
                    }
                    
                    upsert purchaser;
                    
                    /** create Insurance/Member Plan**/
                    Map<String,Object> memberPlanData = (Map<String,Object>)ind.get('MemberPlan');
                    MemberPlan mbrPln = new MemberPlan();
                    String memberPlanId = (String)memberPlanData.get('MemberPlan_1_Source_ID_From_Epic__c');
                    
                    if(String.isNotBlank(memberPlanId) && MemberPlanMap.containsKey(memberPlanId)){
                        mbrPln.Id = MemberPlanMap.get(memberPlanId).Id;
                    }
                    
                    mbrPln.Name = 'Member Plan Name';
                    mbrPln.MemberId = inx.Id;
                    mbrPln.PlanId = purchaser.Id;
                    mbrPln.PayerId = record.Id;
                    mbrPln.SubscriberId = Subscriber.Id;
                    if(memberPlanData.get('primarysecondarytertiary')!=null && memberPlanData.get('primarysecondarytertiary')!=''){
                        String tertiary = (String)memberPlanData.get('primarysecondarytertiary');
                        if(tertiary == '1'){
                            mbrPln.PrimarySecondaryTertiary = 'Primary';
                        }
                        if(tertiary == '2'){
                            mbrPln.PrimarySecondaryTertiary = 'Secondary';
                        }
                        if(tertiary == '3'){
                            mbrPln.PrimarySecondaryTertiary = 'Tertiary';
                        }
                        //mbrPln.PrimarySecondaryTertiary = (String)memberPlanData.get('primarysecondarytertiary');
                    }
                    
                    mbrPln.MemberNumber  = (String)memberPlanData.get('MemberNumber__c');
                    mbrPln.GroupNumber    = (String)memberPlanData.get('Group_Number__c');
                    mbrPln.Subscriber_Id__c   = (String)memberPlanData.get('Subscriber_ID__c');
                    //System.debug('Efffective Date'+memberPlanData.get('Insurance_Member_Plan_eff_from_1__c'));
                    //Date field 
                    if(memberPlanData.get('Insurance_Member_Plan_eff_from_1__c')!=null && memberPlanData.get('Insurance_Member_Plan_eff_from_1__c')!= ''){
                        mbrPln.EffectiveFrom   = Date.valueOf(String.valueOf(memberPlanData.get('Insurance_Member_Plan_eff_from_1__c')));
                    }
                    if(memberPlanData.get('Insurance_Member_Plan_eff_to_1__c')!=null && memberPlanData.get('Insurance_Member_Plan_eff_to_1__c')!=''){
                        mbrPln.EffectiveTo   = Date.valueOf(String.valueOf(memberPlanData.get('Insurance_Member_Plan_eff_to_1__c')));
                    }
                    
                    
                    mbrPln.SourceSystemIdentifier= (String)memberPlanData.get('MemberPlan_1_Source_ID_From_Epic__c');
                    mbrPln.Verification_By_ID__c   = (String)memberPlanData.get('Verification_By_ID__c');
                    mbrPln.Verification_By_First_Name__c   = (String)memberPlanData.get('Verification_By_First_Name__c');
                      //Date Time field 
                    if(memberPlanData.get('Verification_DateTime__c')!= null && memberPlanData.get('Verification_DateTime__c') != ''){
                    String sDatetime=String.valueOf(memberPlanData.get('Verification_DateTime__c'));
                    Datetime validDatetime=DateTime.Valueof(sDatetime.replace('T', ' '));
                    mbrPln.Verification_DateTime__c  = validDatetime;
                        }
                    mbrPln.VerificatiVerificationStatus__c    = (String)memberPlanData.get('VerificationStatus__c');
                    mbrPln.RelationshipToSubscriber  = (String)subscriberData.get('Patient_Relationship_to_Subscriber__c');

                    //mbrPln.MemberPlan_1_Source_ID_From_Epic__c = (String)memberPlanData.get('MemberPlan_1_Source_ID_From_Epic__c');
                    MemberPlanList.add(mbrPln) ; 
                    
                    
                    
                }
                if(!MemberPlanList.isEmpty())
                upsert MemberPlanList;
            }        
            
            List<sObject> payorAccountRel = new List<sObject>();
            For(sObject record : payorRecords){
                AccountContactRelation actCntctRel = new AccountContactRelation();
                actCntctRel.AccountId = ((Account)record).Id;
                actCntctRel.ContactId = personAccount.personContactId;
                payorAccountRel.add(actCntctRel);
            }
            //insert payorAccountRel;
            
            List<Account> subscriberPersonAccount = [Select id,personContactId from Account where id in:subscriberRecords];
            List<HealthCloudGA__ContactContactRelation__c> acntContactRel = new List<HealthCloudGA__ContactContactRelation__c>();
            for(Account record : subscriberPersonAccount){
                HealthCloudGA__ContactContactRelation__c  accountRecord = new HealthCloudGA__ContactContactRelation__c ();
                accountRecord.HealthCloudGA__Contact__c   = record.personContactId;
                accountRecord.HealthCloudGA__RelatedContact__c   = personAccount.PersonContactId;
                accountRecord.HealthCloudGA__Role__c  = subscriberDoc.Id;
                payorAccountRel.add(accountRecord);
            }
            insert payorAccountRel;
            
        }
        
    }
    
    
}