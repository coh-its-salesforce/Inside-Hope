Public Class COH_Physician_ScholarsController{
    
    public string Photolink{get;set;}
    public string Department{get;set;}
    public string firstName{get;set;}
    public string lastname{get;set;}
    public string conName{get;set;}
    public string Email{get;set;}
    
    public string enableTab{get;set;}
    

    public transient Blob blobValue { get; set; }
    public transient String contentType { get; set; }
    public transient String filename { get; set; }
    public Boolean disableSave { get; set;}
    
    public list<Community_Notes_and_Attachment__c> conAttList = new list<Community_Notes_and_Attachment__c>();
    public list<Community_Notes_and_Attachment__c> FinalconAttList = new list<Community_Notes_and_Attachment__c>();
    public list<Attachment> visaAttList = new list<Attachment>();
    
    public List<Attachment> allFileList {get; set;}
    public List<Attachment> allvisaFileList {get; set;}
    
    
    
    public Attachment attachment1 {
        get {
            if (attachment1 == null)
                attachment1 = new Attachment();
            return attachment1;
        }
        set;
    }
    
    public Attachment attachment2 {
        get {
            if (attachment2 == null)
                attachment2 = new Attachment();
            return attachment2;
        }
        set;
    }
    
    public Attachment attachment3 {
        get {
            if (attachment3 == null)
                attachment3 = new Attachment();
            return attachment3;
        }
        set;
    }
    public Attachment attachment4 {
        get {
            if (attachment4 == null)
                attachment4 = new Attachment();
            return attachment4;
        }
        set;
    }
    public Attachment attachment5 {
        get {
            if (attachment5 == null)
                attachment5 = new Attachment();
            return attachment5;
        }
        set;
    }
    public Attachment attachment6 {
        get {
            if (attachment6 == null)
                attachment6 = new Attachment();
            return attachment6;
        }
        set;
    }
    public Attachment attachment7 {
        get {
            if (attachment7 == null)
                attachment7 = new Attachment();
            return attachment7;
        }
        set;
    }
    public Attachment attachment8 {
        get {
            if (attachment8 == null)
                attachment8 = new Attachment();
            return attachment8;
        }
        set;
    }
    public Attachment attachment9 {
        get {
            if (attachment9 == null)
                attachment9 = new Attachment();
            return attachment9;
        }
        set;
    }
    public Attachment attachment10 {
        get {
            if (attachment10 == null)
                attachment10 = new Attachment();
            return attachment10;
        }
        set;
    }
    public Attachment attachment11 {
        get {
            if (attachment11 == null)
                attachment11 = new Attachment();
            return attachment11;
        }
        set;
    }
    public Attachment attachment12 {
        get {
            if (attachment12 == null)
                attachment12 = new Attachment();
            return attachment12;
        }
        set;
    }
    public Attachment attachment13 {
        get {
            if (attachment13 == null)
                attachment13 = new Attachment();
            return attachment13;
        }
        set;
    }
    public Attachment attachment14 {
        get {
            if (attachment14 == null)
                attachment14 = new Attachment();
            return attachment14;
        }
        set;
    }
    public Attachment attachment15 {
        get {
            if (attachment15 == null)
                attachment15 = new Attachment();
            return attachment15;
        }
        set;
    }
    public Attachment attachment16 {
        get {
            if (attachment16 == null)
                attachment16 = new Attachment();
            return attachment16;
        }
        set;
    }
    public List<attachment> attachmentList = new List<attachment>(); 
    public List<attachment> attachmentvisaList = new List<attachment>(); 
    
    
    
    Public COH_Physician_ScholarsController(){
    }
    Public ApexPages.StandardController stdCon;
    
    Public Contact con {get;set;}
    Public Visa__c visaInfo {get;set;}
    public User userDetails = new User ();
    Visa__c  visa = new visa__c ();
    public List<Visa__c> VisaList {get;set;}
    Public List <Visa__c> visaInfoList = new List <Visa__c> ();
    
    Public COH_Physician_ScholarsController(ApexPages.StandardController stdCon)
    {
        enableTab = 'name1';
        disableSave = false;
        con = new Contact ();
        visaInfo = new Visa__c();
         

        userDetails = [select id,SmallPhotoUrl, FullPhotoUrl, Department,contactId from user where id =:UserInfo.GetUserId()];
        conAttList = [select id,Contact__c from Community_Notes_and_Attachment__c where Contact__c =: userDetails.contactid limit 1];
                

        Photolink = userDetails.FullPhotoUrl;
        Department = userDetails.Department;
        
        if(userDetails.Contactid!=null)
            con = [select id,firstname,lastname,Nickname__c,Home_Phone__c,Work_Phone_Number__c,email,City__c,Legal_Name__c,International_Status__c , Application_Status__c,Picklist__c,Field1__c,Field2__c,  street__c,State__c,Postal_Code__c,Country__c,Country_of_Residence__c,Select_Category__c,Title,Position__c,Emergency_Name__c,Emergency_Phone__c,Nationality__c,Emergency_Email__c,Relationship__c,Faculty_Sponsor__c,Institution__c,name,phone,Gender__c,Birthdate,Choice1StartDate__c,Choice1EndDate__c,Choice2StartDate__c,Choice2EndDate__c,MobilePhone,HomePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,OtherPhone from contact where id =: userDetails.Contactid];
        
        system.debug('Contact Details international :'+con.International_Status__c);
        if(con.International_Status__c != 'Submitted for Approval' && con.International_Status__c != 'Approved' )
        {
            disableSave = true;
        }
        firstName = con.FirstName;
        lastName = con.lastname;
        Email = con.email;
        conName = con.Name;
        system.debug('Contact Details :'+con);
        if(!conAttList.isempty())
        {
        allFileList = fetchAttachments(conAttList[0].id);  
        }
        visaInfoList = [select id,Other_Phone_Number__c,Gender2__c,Gender1__c,Gender3__c,Gender4__c,Amount__c,Phone_Number1__c,Phone_Number2__c,Phone_Number3__c,Phone_Number4__c,City_of_Birth__c,country_of_legal_residence1__c,country_of_legal_residence2__c,country_of_legal_residence3__c,country_of_legal_residence4__c,Country_of_Birth__c,Country_of_Legal_Residence__c,Dependent_firstName4__c,Dependent_LastName4__c,Dependent_Relationship4__c,Dependent_Nationality4__c,Dependent_Birthcity4__c  ,Dependent_Birthcountry4__c,Dependent_Birthdate4__c,Funding_Amount__c ,Visa_Mailing_Address__c,Other_mailing_City__c,Other_mailing_State__c,Other_mailing_Postal_code__c,Other_mailing_Country__c,Other_mailing_Street__c,Dependent_BirthDate1__c,Contact_Relationship__c,Contact_Relationship__r.International_Status__c,Dependent_Birthcity1__c,Dependent_Birthcity2__c,Dependent_Birthcity3__c,Dependent_Birthcountry1__c,Dependent_Birthcountry2__c  ,Dependent_Birthcountry3__c,Dependent_Name1__c,Dependent_BirthDate2__c,Dependent_BirthDate3__c,Dependent_firstName2__c,Dependent_firstName3__c,Dependent_lastName1__c,Dependent_lastName2__c,Dependent_lastName3__c,Dependent_Nationality1__c,Dependent_Nationality2__c,Dependent_Nationality3__c,Dependent_Relationship1__c,Dependent_Relationship2__c,Dependent_Relationship3__c,Funding__c,Funding_Provider__c,Funding_Source__c ,J_1_Status__c,Visa_Expiration_Date__c  ,Visa_Status__c from visa__c where Contact_Relationship__c=:userDetails.contactId limit 1];         
        if (!visaInfoList.isempty() ){
                visaInfo = visaInfoList[0];
                        visaAttList = [select id,name,LastModifiedDate,description from Attachment where parentid=: visaInfoList[0].id limit 1];
            }
            system.debug('visaAttList  Details :'+visaAttList);
            if(!visaAttList.isempty())
            {
             system.debug('visaAttList[0].id Details :'+visaAttList[0].id);
            allVisaFileList = fetchAttachments(visaInfoList[0].id);
            }
        
    }
    
    public List<Attachment>fetchAttachments(Id contactid){
    system.debug('Contactid  Details :'+contactid);
        if(contactid != null){
        return [SELECT Id, name, description, LastModifiedDate FROM Attachment WHERE ParentId = : contactid]; 
        }
        else
        return null; 
    }
    /* public List<Attachment>fetchvisaAttachments(Id visaInfo.id ){

return [SELECT Id, name, description, LastModifiedDate FROM Attachment WHERE ParentId = : visaInfo.id];  
}*/
    
    
    Public pageReference upload(){
        
        //try{
            Map < String, Schema.SObjectType > completeobjMap = Schema.getGlobalDescribe();
            Schema.SObjectType selectedSobjType = completeobjMap.get('Contact');
            Schema.DescribeSObjectResult sObjResult = selectedSobjType.getDescribe();
            Map < String, Schema.RecordTypeInfo > RecordTypeInfo = sObjResult.getRecordTypeInfosByName();
            if (RecordTypeInfo.containsKey('Visiting Scholar Program ')) {
                con.RecordTypeId = RecordTypeInfo.get('Visiting Scholar Program ').getRecordTypeId();
                
            }
            //            con.lastName = (Contact)Contact.LastName;
            system.debug('Pavani Test' + attachment1);
            con.International_Status__c = 'In Progress';
            update con;
            //system.debug('Pavani TestSize' + conAttList);
            if(!conAttList.isempty())
            {
            for(Community_Notes_and_Attachment__c comNotesAtt:conAttList)
            {
            comNotesAtt.Contact__c = con.id;
            FinalconAttList.add(comNotesAtt);
            }
            system.debug('Pavani FInalCOnTestSize' + FinalconAttList);
            update FinalconAttList;
            
            }
            
          else
          {
          Community_Notes_and_Attachment__c tempConAtt = new Community_Notes_and_Attachment__c();
          tempConAtt.Contact__c = con.id;
            conAttList.add(tempConAtt);
                        insert conAttList;

          }
            
            if(blobValue!=null && contentType!= null && filename !=null){
                ConnectApi.BinaryInput photoFileInput =
                    new ConnectApi.BinaryInput(blobValue, contentType, filename);
                
                
                ConnectApi.userprofiles.setPhoto(Network.getNetworkId(), UserInfo.getUserId(), photoFileInput);
                
            } 
            if(attachment1 != null){
                If(attachment1.name != '' && attachment1.name != null ){
                    attachment1.OwnerId = UserInfo.getUserId();
                    attachment1.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment1.IsPrivate = false;
                    String[] arrDots = attachment1.name.split('\\.');
                    attachment1.name = 'Curriculum Vitae'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment1);
                }
            }
           // system.debug('Pavani Attachment1'+attachment1);
            if(attachment2 != null){
                If(attachment2.name != '' && attachment2.name != null){
                    attachment2.OwnerId = UserInfo.getUserId();
                    attachment2.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment2.IsPrivate = false;                    
                    String[] arrDots = attachment2.name.split('\\.');
                    attachment2.name = 'Professional letter of recommendation'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment2);
                }
            }
            
            if(attachment3 != null){
                
                If(attachment3.name != '' && attachment3.name != null){
                    attachment3.OwnerId = UserInfo.getUserId();
                    attachment3.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment3.IsPrivate = false;                    
                    String[] arrDots = attachment3.name.split('\\.');
                    attachment3.name = 'Current color photograph of self'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment3);
                }
            }
            if(attachment4 != null){
                If(attachment4.name != '' && attachment4.name != null){
                    attachment4.OwnerId = UserInfo.getUserId();
                    attachment4.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment4.IsPrivate = false;
                    String[] arrDots = attachment4.name.split('\\.');
                    attachment4.name = 'Proof of funding'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment4);
                }
            }
            if(attachment5 != null){
                
                If(attachment5.name != '' && attachment5.name != null){
                    attachment5.OwnerId = UserInfo.getUserId();
                    attachment5.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment5.IsPrivate = false;                    
                    String[] arrDots = attachment5.name.split('\\.');
                    attachment5.name = 'Proof of M.D. or Ph.D.'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment5);
                }
            }
            if(attachment6 != null){
                If(attachment6.name != '' && attachment6.name != null){
                    attachment6.OwnerId = UserInfo.getUserId();
                    attachment6.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment6.IsPrivate = false;
                    String[] arrDots = attachment6.name.split('\\.');
                    attachment6.name = 'Proof of employment'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment6);
                }
            }
            if(attachment7 != null){
                If(attachment7.name != '' && attachment7.name != null){
                    attachment7.OwnerId = UserInfo.getUserId();
                    attachment7.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment7.IsPrivate = false;
                    String[] arrDots = attachment7.name.split('\\.');
                    attachment7.name = 'Proof of health insurance'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment7);
                }
            }
            if(attachment8 != null){
                If(attachment8.name != '' && attachment8.name != null){
                    attachment8.OwnerId = UserInfo.getUserId();
                    attachment8.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment8.IsPrivate = false;                    
                    String[] arrDots = attachment8.name.split('\\.');
                    attachment8.name = 'Proof of English proficiency'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment8);
                }
            }
            if(attachment9 != null){
                If(attachment9.name != '' && attachment9.name != null){
                    attachment9.OwnerId = UserInfo.getUserId();
                    attachment9.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment9.IsPrivate = false;
                    String[] arrDots = attachment9.name.split('\\.');
                    attachment9.name = 'Expected date of visa approval'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment9);                    
                }
            }
            if(attachment10 != null){
                If(attachment10.name != '' && attachment10.name != null){
                    attachment10.OwnerId = UserInfo.getUserId();
                    attachment10.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment10.IsPrivate = false;                    
                    String[] arrDots = attachment10.name.split('\\.');
                    attachment10.name = 'Letter of Interest'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment10); 
                }
            }
            if(attachment16 != null){
                If(attachment16.name != '' && attachment16.name != null){
                    attachment16.OwnerId = UserInfo.getUserId();
                    attachment16.ParentId = conAttList[0].id; // the record the file is attached to
                    attachment16.IsPrivate = false;
                    String[] arrDots = attachment16.name.split('\\.');
                    attachment16.name = 'Copy of Passport'+ '.' + arrDots[arrDots.size() - 1];
                    attachmentList.add(attachment16); 
                }
            }
            if(attachmentList.size()>0)
                insert attachmentList;
                system.debug('Visa Info Value : ' + visaInfo);
                system.debug('Visa attachment11: ' + attachment11);
                system.debug('Visa attachment12: ' + attachment12);
                system.debug('Visa attachment13 : ' + attachment13);
                system.debug('Visa attachment14 : ' + attachment14);
                system.debug('Visa attachment15: ' + attachment15);
                system.debug('Visa visaInfoList: ' + visaInfoList);
                system.debug('Visa visaInfoList.size(): ' + visaInfoList.size());
                
           if(visaInfoList.size() == 0 )
            {  
                //visaInfo = new Visa__c();  
                visaInfo.Contact_Relationship__c = userDetails.contactid;
                visaInfo.RecordTypeId = COHUtil.getRecordType('Visa__c', 'Visiting Scholars Program');
                insert visaInfo ;
            }
            else
            {
            update visaInfo;
            }
            /*if(VisaList.size()>0)
            {
                        VisaList[0].Contact_Relationship__c = userDetails.contactid;
                        upsert VisaList;

            }*/
            
            
            
            
            system.debug('Visa Att List : ' + visaAttList); 
            /*if(visaAttList.size()<=0)
            {
                Community_Notes_and_Attachment__c tempVisaAtt = new Community_Notes_and_Attachment__c();
                tempVisaAtt.Visa__c = visaInfo.id;
                visaAttList.add(tempVisaAtt);
                insert visaAttList;
            }*/
            //system.debug('visa,'+visainfo.id);
            
            if(attachment11 != null){
                If(attachment11.name != '' && attachment11.name != null ){
                    attachment11.OwnerId = UserInfo.getUserId();
                    attachment11.ParentId = visaInfo.id; // the record the file is attached to
                    attachment11.IsPrivate = false;                    
                    String[] arrDots = attachment11.name.split('\\.');
                    attachment11.name = visaInfo.Dependent_Name1__c + '_Passport Copy' + '.' + arrDots[arrDots.size() - 1];
                    attachmentvisaList.add(attachment11); 
                }
            }
            if(attachment12 != null){
                If(attachment12.name != '' && attachment12.name != null ){
                    attachment12.OwnerId = UserInfo.getUserId();
                    attachment12.ParentId = visaInfo.id; // the record the file is attached to
                    attachment12.IsPrivate = false;                                     
                    String[] arrDots = attachment12.name.split('\\.');
                    attachment12.name = visaInfo.Dependent_firstName2__c+'_Passport Copy' + '.' + arrDots[arrDots.size() - 1];
                    attachmentvisaList.add(attachment12); 
                }
            }
            if(attachment13 != null){
                If(attachment13.name != '' && attachment13.name != null ){
                    attachment13.OwnerId = UserInfo.getUserId();
                    attachment13.ParentId = visaInfo.id; // the record the file is attached to
                    attachment13.IsPrivate = false;                                                       
                    String[] arrDots = attachment13.name.split('\\.');
                    attachment13.name = visaInfo.Dependent_firstName3__c+'_Passport Copy' + '.' + arrDots[arrDots.size() - 1];
                    attachmentvisaList.add(attachment13);
                }
            }
            if(attachment14 != null){
                If(attachment14.name != '' && attachment14.name != null ){
                    attachment14.OwnerId = UserInfo.getUserId();
                    attachment14.ParentId = visaInfo.id; // the record the file is attached to
                    attachment14.IsPrivate = false;                                                                         
                    String[] arrDots = attachment14.name.split('\\.');
                    attachment14.name = visaInfo.Dependent_firstName4__c+'_Passport Copy' + '.' + arrDots[arrDots.size() - 1];
                    attachmentvisaList.add(attachment14);
                }
            }
            if(attachment15 != null){
                If(attachment15.name != '' && attachment15.name != null ){
                    attachment15.OwnerId = UserInfo.getUserId();
                    attachment15.ParentId = visaInfo.id; // the record the file is attached to
                    attachment15.IsPrivate = false;                                                                     
                    String[] arrDots = attachment15.name.split('\\.');
                    attachment15.name = con.FirstName+'_Medical staff application' + '.' + arrDots[arrDots.size() - 1];
                    attachmentvisaList.add(attachment15);
                }
            }
            if(attachmentvisaList.size()>0)
                insert attachmentvisaList;
           //return null;
           PageReference ConDetail1Page =  new PageReference('/apex/COH_Intl_Scholars_Program?id='+con.id);
        ConDetail1Page.setredirect(true);
        return ConDetail1Page;
        //
        //}
        
        /*Catch(Exception e) {
            
            pagereference p = apexpages.Currentpage();
            Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,e.getMessage()));
           return p;
            
}*/        
    }
    /*public PageReference Save() {
con.International_Status__c = 'In Progress';
update con;
return null;
}*/
    
    public PageReference Approval () {
        con.International_Status__c = 'Submitted for Approval';
        update con;       
        
        PageReference ConDetailPage =  new PageReference('/apex/COH_Physician_Scholars_Confirmation');
        ConDetailPage.setredirect(true);
        return ConDetailPage;
    }
    
    Public Pagereference EditRedir(){
        PageReference ConEditVfPage =  new PageReference('/apex/COH_Intl_Scholars_Program?id='+con.id);
        enableTab = 'name2';
        ConEditVfPage.setredirect(true);
        return ConEditVfPage;
        
    } 
    
    
}