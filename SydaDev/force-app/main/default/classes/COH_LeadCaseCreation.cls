public class COH_LeadCaseCreation {
    public class CustomException extends Exception{}
    @AuraEnabled
    public Static String saveCaseLead(Lead leadRec,Case caseRec,Id recordId, String comment){
        try{
            if(recordId == null){
                Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Patient').getRecordTypeId();
                System.debug('leadRec'+leadRec);
                System.debug('caseRec'+caseRec);
                System.debug('comment'+comment);
                leadRec.RecordTypeId = devRecordTypeId;
                leadRec.Reason_for_Duplicate__c  = comment;
                leadRec.Duplicate_Date_and_Time__c = system.now();
                leadRec.Duplicate_Created_By__c  = userinfo.getUserid();
                insert leadRec;
                
                Id caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Enterprise_Access_New_Patient').getRecordTypeId();
                
                System.debug('leadRec after insertion'+leadRec.Id);
                caseRec.Lead__c = leadRec.Id;
                caseRec.RecordTypeId = caseRecordType;
                insert caserec;
                return caserec.Id;
            }
            else{
                String objectApiName= String.valueOf(recordId.getSobjectType());
                System.debug('objectApiName'+objectApiName);
                if(objectApiName == 'Lead'){
                    
                    leadRec.Id = recordId;
                    update leadRec;
                    caseRec.Lead__c = recordId;                
                }
                if(objectApiName == 'Account'){
                    
                    Account accData = [Select id,personContactId, COH_MRN__c  FROM Account where id=:recordId];
                    
                    if(String.isBlank(accData.COH_MRN__c)){
                        
                        Account inx = new Account();
                        inx.Id = recordId;
                        inx.FirstName = leadRec.FirstName;
                        inx.lastName = leadRec.lastName;
                        inx.MiddleName = leadRec.MiddleName;
                        inx.PersonBirthDate = leadRec.BirthDate__c;
                        inx.PersonMobilePhone = leadRec.MobilePhone;
                        inx.PersonOtherPhone = leadRec.Other_Phone__c;
                        inx.PersonHomePhone = leadRec.Home_Phone__c;
                        inx.gender__pc = leadRec.gender__c;
                        inx.Primary_Phone_Number__c  = leadRec.Primary_Phone_Number__c ;
                        inx.Patient_Street1__c  = leadRec.Street;
                        inx.Patient_City__c = leadRec.City;
                        inx.COH_PA_State__c = leadRec.State;
                        inx.Patient_Postal_Code__c = leadRec.PostalCode;
                        inx.COH_PA_Country__c = leadRec.country;
                        update inx;
                    }
                    
                    caseRec.AccountId = recordId;
                    caseRec.ContactId = accData.personContactId;
                }
                
                Id caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Enterprise_Access_New_Patient').getRecordTypeId();
                
                caseRec.RecordTypeId = caseRecordType;
                insert caserec;
                return caserec.Id;
            }
        }catch(DMLException dmlExp){system.debug('dmlExp'+dmlExp.getMessage());
            throw new AuraHandledException(dmlExp.getDMLMessage(0));}catch(Exception ex){throw new AuraHandledException(ex.getMessage());
                                                                                                                }
        
    } 
    
    @AuraEnabled
    public static String dupeLeadAccount(Lead leadRec,Case caseRec){
        String Firstname = LeadRec.FirstName;
        String LastName =  LeadRec.LastName;
        String gender = LeadRec.Gender__c;
        Date dateOfBirth = leadRec.BirthDate__c;
        if(String.isNotBlank(Firstname)){Firstname = Firstname.trim();}
        if(String.isNotBlank(LastName)){LastName = LastName.trim();}
        if(String.isNotBlank(gender)){gender = gender.trim();}
        Map<String,List<sObjectWrapper>> dupeData = new Map<String,List<sObjectWrapper>>();
        List<sObjectWrapper> leadList = new List<sObjectWrapper>();
        List<sObjectWrapper> accountList = new List<sObjectWrapper>();
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Patient').getRecordTypeId();
        System.debug('Firstname :'+Firstname);
        System.debug('LastName :'+LastName);
        System.debug('gender :'+gender);
        System.debug('dateOfBirth :'+dateOfBirth);
        
        for(lead inx :[Select id,name,email,City,Country,PostalCode,Street,State,MobilePhone,Gender__c,BirthDate__c,Primary_Phone_Number__c,LeadSource from Lead 
                       where gender__c =:gender and FirstName=:firstName and LastName =:lastName and BirthDate__c =: dateOfBirth
                       and isConverted = false and RecordTypeId = :devRecordTypeId]){
            sObjectWrapper ind = new sObjectWrapper();
            ind.url = '/'+inx.Id;
            ind.Record = inx;
            leadList.add(ind);
        }
        for(Account inx :[Select id,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c,WTP_Created__c
                          ,PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c 
                          from Account where gender__pc =: gender and FirstName=:firstName and LastName =:lastName and PersonBirthDate =: dateOfBirth]){
                              sObjectWrapper ind = new sObjectWrapper();
                              ind.url = '/'+inx.Id;
                              ind.Record = inx;
                              accountList.add(ind);
                              
                          }
        
        
        dupeData.put('lead',leadList);
        dupeData.put('account',accountList);
        system.debug('dupeData'+dupeData);
        return JSON.serialize(dupeData) ;
    }
    
    
    @AuraEnabled
    public static list<Case> getCases(String recordId){
        // String objectApiName= String.valueOf(recordId.getSobjectType());
        
        return [Select id,CaseNumber,Owner.Name,Appt_Date_Time__c,Status,RecordType.name from Case where Lead__c =:recordId or AccountId =:recordId];
        
    }
    
    @AuraEnabled
    public static string searchLeadAccount(String patientName){
        
        Map<String,List<sObjectWrapper>> dupeData = new Map<String,List<sObjectWrapper>>();
        List<sObjectWrapper> leadList = new List<sObjectWrapper>();
        List<sObjectWrapper> accountList = new List<sObjectWrapper>();
        patientName = patientName.trim();
        
        List<String> whereClauses = patientName.split(' ');
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Patient').getRecordTypeId();
        
        String leadQuery ;
        String accountQuery;
       /* System.debug('whereClauses'+whereClauses.size());
        if(whereClauses.size() == 1){
            string patientNameClause = '%'+patientName + '%';
            system.debug('patientNameClause'+patientNameClause);
            List<Lead> leadList1 = [Select id from Lead where (Name like: patientNameClause or email like :patientNameClause or Mobile__c like :patientNameClause or PostalCode like :patientNameClause ) and isConverted = false and RecordTypeId = :devRecordTypeId];
            System.debug('leadList'+leadList1);
            leadQuery = 'Select id,FirstName,MiddleName,LastName,name,email,City,Country,PostalCode,Street,State,Mobile__c,Gender__c,BirthDate__c,Primary_Phone_Number__c '+
                'from Lead where (Name like: patientNameClause or email like :patientNameClause or Mobile__c like :patientNameClause or PostalCode like :patientNameClause ) and isConverted = false and RecordTypeId = :devRecordTypeId';
            accountQuery = 'Select id,FirstName,MiddleName,LastName,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c'
                +',PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c from Account where (name like :patientNameClause or PersonEmail like :patientNameClause or PersonMobilePhone like :patientNameClause or Patient_Postal_Code__c like :patientNameClause)';
            system.debug(Database.query(leadQuery).size());
            
            for(lead inx : Database.query(leadQuery)){
                sObjectWrapper ind = new sObjectWrapper();
                ind.url = '/'+inx.Id;
                ind.Record = inx;
                leadList.add(ind);
            }
            for(Account inx : Database.query(accountQuery)){
                sObjectWrapper ind = new sObjectWrapper();
                ind.url = '/'+inx.Id;
                ind.Record = inx;
                accountList.add(ind);
                
            }
        }
        
        else if(whereClauses.size() == 2){
            String nameClause = '%'+whereClauses[0]+'%';
            string patientNameClause = '%'+whereClauses[1] + '%';
            
            leadQuery = 'Select id,FirstName,MiddleName,LastName,name,email,City,Country,PostalCode,Street,State,Mobile__c,Gender__c,BirthDate__c,Primary_Phone_Number__c '+
                'from Lead where (Name like: nameClause or Name like:patientNameClause) AND (email like :patientNameClause or Mobile__c like :patientNameClause or PostalCode like :patientNameClause ) and isConverted = false and RecordTypeId = :devRecordTypeId';
            accountQuery = 'Select id,FirstName,MiddleName,LastName,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c'
                +',PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c from Account where (name like :nameClause or name like:patientNameClause) AND ( PersonEmail like :patientNameClause or PersonMobilePhone like :patientNameClause or Patient_Postal_Code__c like :patientNameClause)';
            System.debug('HEE! 1');
            
            if(patientNameClause.contains('/')){
                List<String> birthDate = whereClauses[1].split('/');
                String dobDate = birthDate[2]+'-'+birthDate[0]+'-'+birthDate[1]; 
                Date dateOfBirth = Date.valueOf(dobDate);
                leadQuery = 'Select id,FirstName,MiddleName,LastName,name,email,City,Country,PostalCode,Street,State,Mobile__c,Gender__c,BirthDate__c,Primary_Phone_Number__c '+
                    'from Lead where (Name like: nameClause ) AND BirthDate__c=:dateOfBirth and isConverted = false and RecordTypeId = :devRecordTypeId';
                accountQuery = 'Select id,FirstName,MiddleName,LastName,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c'
                    +',PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c from Account where (Name like: nameClause ) AND PersonBirthDate = :dateOfBirth';
                
            }
            System.debug('leadQuery : '+leadQuery);
        System.debug('accountQuery : '+accountQuery);
            System.debug('HEE!');
            for(lead inx : Database.query(leadQuery)){
                sObjectWrapper ind = new sObjectWrapper();
                ind.url = '/'+inx.Id;
                ind.Record = inx;
                leadList.add(ind);
            }
            for(Account inx : Database.query(accountQuery)){
                sObjectWrapper ind = new sObjectWrapper();
                ind.url = '/'+inx.Id;
                ind.Record = inx;
                accountList.add(ind);
                
            }
            
            
        }*/
        
        
        string patientNameClause = '*'+patientName + '*';
        //System.debug('patientNameClause'patientNameClause)
        //List<List<sOBject>> searchRecords = new List<List<sObject>>();
        String searchQuery = 'FIND \'' + patientNameClause + '\'IN ALL FIELDS RETURNING Account(id,WTP_Created__c,FirstName,MiddleName,LastName,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c,Salutation,PersonHomePhone,PersonOtherPhone,PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c order by createddate desc), Lead(id,Salutation,LeadSource,FirstName,MiddleName,LastName,name,email,City,Country,PostalCode,Street,State,MobilePhone,Gender__c,BirthDate__c,Other_Phone__c,Home_Phone__c,Primary_Phone_Number__c where isConverted = false and RecordTypeId = :devRecordTypeId order by createddate desc)';
        
        system.debug('searchQuery'+searchQuery);
        //searchRecords = [FIND :patientName IN ALL FIELDS RETURNING Account(id,FirstName,MiddleName,LastName,name,PersonEmail,Patient_Street1__c,Patient_City__c,COH_PA_State__c,COH_PA_Country__c,Patient_Postal_Code__c,PersonMobilePhone,PersonBirthDate,Gender__pc,Primary_Phone_Number__c), Lead(id,FirstName,MiddleName,LastName,name,email,City,Country,PostalCode,Street,State,Mobile__c,Gender__c,BirthDate__c,Primary_Phone_Number__c)];
        List<List<sOBject>> searchRecords = Search.query(searchQuery);
        system.debug('searchRecords'+searchRecords);
        
       // List<Account> accData = (List<Account>)searchRecords[0];
        //List<Lead> leadData = (List<Lead>)searchRecords[1];
        
        for(lead inx : (List<lead>)searchRecords[1]){
            sObjectWrapper ind = new sObjectWrapper();
            ind.url = '/'+inx.Id;
            ind.Record = inx;
            leadList.add(ind);
        }
        for(Account inx : (List<Account>)searchRecords[0]){
            sObjectWrapper ind = new sObjectWrapper();
            ind.url = '/'+inx.Id;
            ind.Record = inx;
            accountList.add(ind);
            
        }
        
        
        
        
        
        
        
        
        system.debug('leadList'+leadList.size());
        dupeData.put('lead',leadList);
        dupeData.put('account',accountList);
        system.debug('dupeData'+dupeData);
        return JSON.serialize(dupeData) ;
    }
    
    
    
    
    public class sObjectWrapper{
        public string url;
        public sObject Record;
    }
    
    
    @AuraEnabled
    public Static String convertLead(Id recordId){
        System.debug('recordId'+recordId);
        Case caseRec = [Select id,lead__c,AccountId,ContactId from Case where id =:recordId];
        try{
            if(caseRec.lead__c != null){
                list<lead> leads = [select id,Street, City, State, PostalCode, Country, Primary_Phone_Number__c, MobilePhone, Home_Phone__c, Other_Phone__c,LeadSource from lead where id = :caseRec.Lead__C and isConverted = false];
                list<Database.LeadConvert > leadsToConvert = new list<Database.LeadConvert >();
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                for(lead l: leads){
                    Database.LeadConvert tempLC = new Database.LeadConvert();
                    tempLC.setLeadId(l.id);
                    tempLC.setConvertedStatus(convertStatus.MasterLabel);
                    leadsToConvert.add(tempLC);
                }
                list<Database.LeadConvertResult> lc = Database.convertLead(leadsToConvert);
                
                Account ind = new Account();
                ind.Id =  lc[0].getAccountId(); 
                ind.Patient_Street1__c = leads[0].Street;
                ind.Patient_City__c = leads[0].City;
                ind.COH_PA_State__c = leads[0].State;
                ind.Patient_Postal_Code__c = leads[0].PostalCode;
                ind.COH_PA_Country__c = leads[0].Country;
                ind.Primary_Phone_Number__c = leads[0].Primary_Phone_Number__c;
                ind.PersonMobilePhone = leads[0].MobilePhone;
                ind.PersonHomePhone = leads[0].Home_Phone__c;
                ind.PersonOtherPhone = leads[0].Other_Phone__c;
                ind.WTP_Created__c = leads[0].LeadSource == 'Web'?true:false;
                update ind;
                
                for(Database.LeadConvertResult lctemp: lc){
                    system.debug(lctemp.getAccountId());
                    system.debug(lctemp.getContactId());
                    caseRec.AccountId = lctemp.getAccountId();
                    caseRec.ContactId = lctemp.getContactId(); 
                }
                update caseRec;
                return 'Success';
            }else{
                throw new CustomException('No Lead Available to convert');
            }
        }catch(CustomException e){
            throw new AuraHandledException(e.getMessage());
        }
        catch(dmlException e){
            throw new AuraHandledException(e.getDmlMessage(0));
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
}