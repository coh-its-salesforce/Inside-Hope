public class immigrationServicesCtl{
    public User userdetails{get;set;}
    public Contact con{get;set;}
    public boolean editPage{get;set;}
    public List<Contact> conList {get;set;}
    public List<attWrapper> J1List{get;set;}
    public List<attWrapper> F1List{get;set;}
    public List<attWrapper> STEMList{get;set;}
   
    public List<Contact> dependentList{get;set;}
    public Contact dependentInfo{get;set;}
    public Visa__c caseRec {get;set;}
    public Attachment att{get;set;}
    public string selectedDoc{get;set;}
    public List<SelectOption> visaOptions{get;set;}
    public integer selectedDependencyOption{get;set;}
    public List<SelectOption> DependencyOptions{get;set;}
    public List<docWrapper> attList{get;set;}
    public List<Attachment> existingAttList{get;set;}
    public string numberofDependencies = '0';
    public immigrationServicesCtl(ApexPages.StandardController cont){
    
        att = new Attachment();
        dependentInfo = new Contact();
        caseRec = new Visa__c();
        caseRec = (Visa__c)cont.getRecord();
        con = new Contact();
        editPage = false;
        attList = new List<docWrapper>();
        existingAttList = new List<Attachment>();
        selectedDoc = 'J-1';
        If(caserec.Number_of_Dependencies__c !='0'&& caserec.Number_of_Dependencies__c !=null){
            selectedDependencyOption= integer.valueof(caserec.Number_of_Dependencies__c);
        } else{
            selectedDependencyOption=0;
              }
        dependentList = new List<Contact>();
        visaOptions = new List<SelectOption>();
        visaOptions.add(new selectoption('J-1','J-1'));
        visaOptions.add(new selectoption('H-1B','H-1B'));
        visaOptions.add(new selectoption('Green Card – I-140','Green Card – I-140'));
        visaOptions.add(new selectoption('Green Card – PERM','Green Card – PERM'));
        visaOptions.add(new selectoption('F-1','F-1'));
        visaOptions.add(new selectoption('STEM/OPT','STEM/OPT'));
        
        //new addon by Larry.
        DependencyOptions = new list<SelectOption>();
        DependencyOptions.add(new selectoption('0','0'));
        DependencyOptions.add(new selectoption('1','1'));
        DependencyOptions.add(new selectoption('2','2')); 
        DependencyOptions.add(new selectoption('3','3')); 
        DependencyOptions.add(new selectoption('4','4'));         
List<Visa__c> caseRecList = [select id, Completed_and_Sent_to_ISSO_Team__c, Citizenship1__c, Ever_Participated_in_a_H_1B_Program__c,If_Yes_H1BIndicate_Last_Program_End_Date__c,If_Yes_indicate_Last_Program__c,Proposed_Individual_First_Name__c,Case_Type__c,Applicant_ever_participated_in_J_1_Prgm__c,Proposed_Individual_Last_Name__c,Birth_Date__c,immi_Country_of_Birth__c,immi_City_of_Birth__c,immi_Nationality__c,Street_Name__c,Fedex_Street_Name__c,City__c,Fedex_City__c,Province_Territory__c,Fedex_Province_Territory__c,State__c,Fedex_State__c,Postal_Code_Zip_Code__c,Fedex_Postal_Code_Zip_Code__c,Country__c,Fedex_Country__c,USA_Phone_Number__c,Country_of_last_legal_residence__c,Current_Visa_Status__c,Current_Visa_Expiration_Date__c,If_yes_indicate_last_program_Start_Date__c    ,If_yes_indicate_Last_program_End_Date__c,Highest_Level_of_Degree_Obtained__c,Major__c,Phone_number_for_FedEx_mailing__c,Number_of_Dependencies__c,Immigration_Comments__c,Applicant_Phone_Number__c, Applicant_Email_Id__c,Gender__c,Status__c from Visa__c where Community_User_Name__c =: UserInfo.getUserId()];       

 if(caseRecList.size()>0){
            caseRec = caseRecList[0];
        }
        
       /* if(caseRec.Id != null){
            existingAttList = [select id,Name,Description from Attachment where ParentId =: caseRec.Id];
            if(existingAttList.size()>0){
               // att = attList[0];
               for(Attachment at : existingAttList){
                   attList.add(new docWrapper(at.id,at.Name,att.Description));
               }
            }
        }*/
        
        existingAttachmentList();
        
        
        conList = new List<Contact>();

        
        userdetails =  [select id,SmallPhotoUrl, FullPhotoUrl, Department,contactId from user where id =:UserInfo.GetUserId()];
        if(userdetails.contactId !=null){
            con = [select id,lastname,Name,Email from contact where id =: userdetails.contactId];
            
            //conList = [select id,Name,lastName,Dependent1_Email_Address__c,Dependent2_FirstName__c,Dependent2_LastName__c,Dependent2_Email_Address__c,Relationship2__c,Nationality2__c,Birth_City2__c,Birth_Country2__c,Birth_Date2__c,Dependent3_First_Name__c,Dependent3_LastName__c,Dependent3_Email_Address__c,Relationship3__c,Nationality3__c,Birth_City3__c,Birth_Country3__c,Birth_Date3__c,Dependent4_First_Name__c,Dependent4_LastName__c,Dependent4_Email_Address__c,Relationship4__c,Nationality4__c,Birth_City4__c,Birth_Country4__c,Birth_Date4__c,Dependent1First_Name__c,Dependent1_LastName__c,Relationship1__c,Nationality1__c,Birth_City1__c ,Birth_Country1__c,Birth_Date1__c from contact where Dependents_Info__c=: caseRec.Id];
            //saidaiah surisetti added the condition related to 'Name' in the below query to prevent the dependent1 information as the logged in user name.
        conList = [select id,firstName,LastName,Last_Legal_Residence_Country__c, Relationship1__c,Dependent1_Email_Address__c,Birth_Date1__c,Birth_City1__c,Birth_Country1__c,Nationality1__c from contact where Dependents_Info__c =:caseRec.Id and Name!=:con.Name];
        }
        Integer nofDependencies = 0;
            nofDependencies = selectedDependencyOption; 
            system.debug('nofDependencies ='+nofdependencies);
            system.debug('Selected Depedency option is = '+selectedDependencyOption);
        
        if(conList.size()<4){
                for(Integer i=conList.size();i<nofDependencies;i++){
                    conList.add(new Contact());
                }
            }
        
        J1List = new List<attWrapper>();
        F1List = new List<attWrapper>();
        STEMList = new List<attWrapper>();

        
        /*Map<string,string> caseTypemap = new Map<String,string>{'Transfer from other Organization'=>'transfer','New Request for Foreign National Outside of US'=>'new','Extension of same immigration status'=>'ext'};

        for(RequiredDocuments__c req: RequiredDocuments__c.getAll().values()){
            Set<String> statusSet = new Set<String>();
            statusSet.addAll(req.Status__c.split(';'));
            if(req.Type__c == 'J-1'){       
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                system.debug('test'+ req);
                    J1List.add(new attWrapper(req.Document__c,new Attachment()));
                }
                
            }
            /*else if(req.Type__c == 'F-1'){
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                    F1List.add(new attWrapper(req.Document__c,new Attachment()));
                }
                
            }else if(req.Type__c == 'STEM/OPT'){
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                    STEMList.add(new attWrapper(req.Document__c,new Attachment()));
                }
            }
        }*/
        
        
        reqDocList();
            
        }
        public void reqDocList(){
        Map<string,string> caseTypemap = new Map<String,string>{'Transfer from another Organization'=>'Transfer','New Request for Foreign National Outside of US'=>'new','Extension of the same immigration status'=>'ext'};
        Map<string,RequiredDocuments__c> ReqdocumentMap = RequiredDocuments__c.getAll();
        for(integer i=1; i<= ReqdocumentMap.size(); i++)
        {
        
        if(ReqdocumentMap.containskey(string.valueof(i)))
        {
        RequiredDocuments__c req = ReqdocumentMap.get(string.valueof(i));
        //for(RequiredDocuments__c req: RequiredDocuments__c.getAll().values()){
            Set<String> statusSet = new Set<String>();
            statusSet.addAll(req.Status__c.split(';'));
            if(req.Type__c == 'J-1'){       
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                system.debug('req.Document__c'+ req.Document__c);
                    J1List.add(new attWrapper(req.Document__c,new Attachment()));
                }
                
                
            }else if(req.Type__c == 'F-1'){
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                    F1List.add(new attWrapper(req.Document__c,new Attachment()));
                }
                
            }else if(req.Type__c == 'STEM/OPT'){
                if(caseTypemap.containskey(caseRec.Case_Type__c) && statusSet.contains(caseTypemap.get(caseRec.Case_Type__c))){
                    STEMList.add(new attWrapper(req.Document__c,new Attachment()));
                }
            }
            }
        }
        system.debug('j1 list '+J1List);
    }
    
    public void existingAttachmentList(){
        attList = new List<docWrapper>();
        if(caseRec.Id != null){
            existingAttList = [select id,Name,Description from Attachment where ParentId =: caseRec.Id];
            if(existingAttList.size()>0){
               // att = attList[0];
               for(Attachment at : existingAttList){
                   attList.add(new docWrapper(at.id,at.Name,att.Description));
               }
            }
        }
    }
        
        
    
    public pageReference saveRecord(){
        caserec.Number_of_Dependencies__c=string.valueof(selectedDependencyOption);
        upsert caseRec;
        
        
       // dependentInfo.Dependents_Info__c= caseRec.Id;
        //upsert dependentInfo;
        
List<Contact> updateList = new List<Contact>();
        List<Contact> deleteList = new List<Contact>();
        for(Contact c:conList){
            if(c.Lastname != '' && c.Lastname !=null){
                c.Dependents_Info__c= caseRec.Id;
                //Saidaiah Surisetti added the recordType related code.
                c.recordtypeId=COHUTIL.getRecordType('CONTACT','Immigration Sevices');
                updateList.add(c);
            }
            if((c.LastName == '' || c.LastName == null)&& c.id != null){
                deleteList.add(c);
            }
                
        }
        upsert updateList;
        if(deleteList.size()>0){
            delete deleteList;
        }
        system.debug('att**'+att.body);
       /* if(att.Id == null && att.body != null){
            att.ParentId = caseRec.Id;
            insert att;
        }*/
        
        editPage = false;
        return null;
    }
    
    public pagereference EditRec(){
        if (COHUtil.isValidstr(caserec.Number_of_Dependencies__c)){
                selectedDependencyOption = integer.valueOf(caserec.Number_of_Dependencies__c);
                }Else{
                caserec.Number_of_Dependencies__c = '0';}
        editPage = true;
        return null;
    }
    
    public void submitandSendtoISSOTeam(){
        caseRec.status__c = 'In Process';
        caseRec.Completed_and_Sent_to_ISSO_Team__c = true;
        upsert caseRec;
        editPage = false;
    }
    
        public void submitForApproval(){
        caseRec.status__c = 'Gov Approval Pending';
        update caseRec;
        editPage = false;
    }
    
    public void uploadDocument(){
        List<attWrapper> attWrapList = new List<attWrapper>();
        List<Attachment> attList = new List<Attachment>();
        if( selectedDoc == 'J-1'){
            for(attWrapper att : J1List){
                if(att.att.Name != null && att.att.Name !=''){
                    Attachment doc = att.att;
                    String[] extArr = att.att.Name.split('\\.');
                    doc.name = att.doc+'.'+extArr[extArr.size() - 1];

                    doc.ParentId = caseRec.Id;
                    doc.Description = selectedDoc;
                    attList.add(doc);
                }
            }
            insert attList;
            J1List = new List<attWrapper>();
            reqDocList();
            existingAttachmentList();    
        }else if(selectedDoc == 'F-1'){
        for(attWrapper att : F1List){
                if(att.att.Name != null && att.att.Name !=''){
                    Attachment doc = att.att;
                    String[] extArr = att.att.Name.split('\\.');
                    doc.name = att.doc+'.'+extArr[extArr.size() - 1];
                    doc.ParentId = caseRec.Id;
                    doc.Description = selectedDoc;
                    attList.add(doc);
}
            }
            insert attList;
            F1List = new List<attWrapper>();
            reqDocList();
            existingAttachmentList(); 


            //F1List
        }else if(selectedDoc == 'STEM/OPT'){
            //STEMList
            for(attWrapper att : STEMList){
                if(att.att.Name != null && att.att.Name !=''){
                    Attachment doc = att.att;
                    String[] extArr = att.att.Name.split('\\.');
                    doc.name = att.doc+'.'+extArr[extArr.size() - 1];
                    doc.ParentId = caseRec.Id;
                    doc.Description = selectedDoc;
                    attList.add(doc);
                }
            }
            insert attList;
            STEMList = new List<attWrapper>();
            reqDocList();
            existingAttachmentList(); 

        }
    }
    public class docWrapper{
        public Id docId{get;set;}
        public String docName{get;set;}
        public String Description{get;set;}
        public docWrapper(Id doc, string docName,string Description){
            this.docId = doc;
            this.docName = docName;
            this.Description = Description;
        }
    }
    public class reqWrapper{
        public string doc{get;set;}
        public string newSt{get;set;}
        public string ext{get;set;}
        public string transfer{get;set;}
        public reqWrapper(string doc, string newSt,string ext,string transfer){
            this.doc = doc;
            this.newSt = newSt;
            this.ext = ext;
            this.transfer = transfer;
        }
    }
    public class attWrapper{
        public string doc{get;set;}
        public Attachment att{get;set;}
        public attWrapper(string doc, Attachment att){
            this.doc = doc;
            this.att = att;
        }
    }

    public void changedDoc(){
    
    }
    
    public void updateDependentsList(){
        Integer nofDependencies = 0;
        nofDependencies = selectedDependencyOption;
        if(conList.size()<4){
            conList.clear(); 
            conList = [select id,firstName,LastName,Last_Legal_Residence_Country__c, Relationship1__c,Dependent1_Email_Address__c,Birth_Date1__c,Birth_City1__c,Birth_Country1__c,Nationality1__c from contact where Dependents_Info__c =:caseRec.Id and Name!=:con.Name];
            for(Integer i=conlist.size();i<nofDependencies;i++){
                conList.add(new Contact());
            }
        }
    }
    
    public void removeDependent(){
        if(conList.size()<4){
            conList.clear(); 
            conList = [select id,firstName,LastName,Relationship1__c,Dependent1_Email_Address__c,Birth_Date1__c,Birth_City1__c,Birth_Country1__c,Nationality1__c from contact where Dependents_Info__c =:caseRec.Id and Name!=:con.Name];
            }
    }
    
   
}